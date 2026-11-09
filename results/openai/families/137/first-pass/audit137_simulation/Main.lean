import AcceptedEvaluator

set_option autoImplicit false

namespace Simulation137

open scoped BigOperators

section Replay

variable {R B I : Type*} [DecidableEq R] [DecidableEq I]

def serial (sel : R → I) (visit : R → B → R × B)
    (z : R) (A : I → B) : R × (I → B) :=
  let r := visit z (A (sel z))
  (r.1, Function.update A (sel z) r.2)

def reference (sel : R → I) (visit : R → B → R × B) :
    ℕ → R → (I → B) → R × (I → B)
  | 0, z, A => (z, A)
  | n + 1, z, A =>
      let s := serial sel visit z A
      reference sel visit n s.1 s.2

def transcript (sel : R → I) (visit : R → B → R × B) :
    ℕ → R → (I → B) → List R
  | 0, _, _ => []
  | n + 1, z, A =>
      let s := serial sel visit z A
      s.1 :: transcript sel visit n s.1 s.2

def replay (sel : R → I) (visit : R → B → R × B) (i : I) :
    R → List R → B → B × Bool
  | _, [], B => (B, true)
  | z, y :: ys, B =>
      let r := if sel z = i then visit z B else (y, B)
      let p := if sel z = i then decide (r.1 = y) else true
      let rest := replay sel visit i y ys r.2
      (rest.1, p && rest.2)

@[simp] theorem transcript_length (sel : R → I) (visit : R → B → R × B)
    (n : ℕ) (z : R) (A : I → B) :
    (transcript sel visit n z A).length = n := by
  induction n generalizing z A with
  | zero => rfl
  | succ n ih => simp [transcript, ih]

theorem all_replay_cons (sel : R → I) (visit : R → B → R × B)
    (z y : R) (ys : List R) (A : I → B) :
    (∀ i, (replay sel visit i z (y :: ys) (A i)).2 = true) ↔
      y = (serial sel visit z A).1 ∧
      ∀ i, (replay sel visit i y ys ((serial sel visit z A).2 i)).2 = true := by
  constructor
  · intro h
    have hsel := h (sel z)
    simp [replay] at hsel
    have hy : y = (visit z (A (sel z))).1 := hsel.1.symm
    refine ⟨hy, ?_⟩
    intro i
    have hi := h i
    by_cases he : sel z = i
    · subst i
      simpa [serial, replay, hy] using hsel.2
    · simpa [serial, replay, he, Ne.symm he] using hi
  · rintro ⟨hy, h⟩ i
    by_cases he : sel z = i
    · subst i
      simpa [replay, serial, hy] using h (sel z)
    · simpa [replay, serial, he, Ne.symm he] using h i

theorem replay_accepts_iff (sel : R → I) (visit : R → B → R × B)
    (Y : List R) (z : R) (A : I → B) :
    (∀ i, (replay sel visit i z Y (A i)).2 = true) ↔
      Y = transcript sel visit Y.length z A := by
  induction Y generalizing z A with
  | nil => simp [replay, transcript]
  | cons y ys ih =>
      rw [all_replay_cons, ih]
      simp only [List.length_cons, transcript, List.cons.injEq]
      constructor <;> rintro ⟨hy, hys⟩ <;> exact ⟨hy, by simpa [hy] using hys⟩

theorem replay_reference_buffers (sel : R → I) (visit : R → B → R × B)
    (n : ℕ) (z : R) (A : I → B) (i : I) :
    (replay sel visit i z (transcript sel visit n z A) (A i)).1 =
      (reference sel visit n z A).2 i := by
  induction n generalizing z A with
  | zero => rfl
  | succ n ih =>
      simp only [transcript, reference, replay]
      by_cases he : sel z = i
      · subst i
        simpa [serial] using
          ih (serial sel visit z A).1 (serial sel visit z A).2
      · simpa [serial, he, Ne.symm he] using
          ih (serial sel visit z A).1 (serial sel visit z A).2

theorem replay_exact (sel : R → I) (visit : R → B → R × B)
    (Y : List R) (z : R) (A : I → B) :
    (∀ i, (replay sel visit i z Y (A i)).2 = true) ↔
      Y = transcript sel visit Y.length z A ∧
      ∀ i, (replay sel visit i z Y (A i)).1 =
        (reference sel visit Y.length z A).2 i := by
  constructor
  · intro h
    have he := (replay_accepts_iff sel visit Y z A).mp h
    refine ⟨he, ?_⟩
    intro i
    rw [he]
    simpa using replay_reference_buffers sel visit Y.length z A i
  · exact fun h => (replay_accepts_iff sel visit Y z A).mpr h.1

theorem transcript_add (sel : R → I) (visit : R → B → R × B)
    (n m : ℕ) (z : R) (A : I → B) :
    transcript sel visit (n + m) z A =
      transcript sel visit n z A ++
        transcript sel visit m (reference sel visit n z A).1
          (reference sel visit n z A).2 := by
  induction n generalizing z A with
  | zero => simp [transcript, reference]
  | succ n ih =>
      simpa [Nat.succ_add, transcript, reference] using
        congrArg (List.cons (serial sel visit z A).1)
          (ih (serial sel visit z A).1 (serial sel visit z A).2)

theorem reference_add (sel : R → I) (visit : R → B → R × B)
    (n m : ℕ) (z : R) (A : I → B) :
    reference sel visit (n + m) z A =
      reference sel visit m (reference sel visit n z A).1
        (reference sel visit n z A).2 := by
  induction n generalizing z A with
  | zero => simp [reference]
  | succ n ih =>
      simpa [Nat.succ_add, reference] using
        ih (serial sel visit z A).1 (serial sel visit z A).2

theorem unique_raw_suffix (sel : R → I) (visit : R → B → R × B)
    (p k : ℕ) (z : R) (A : I → B) (Y : List R) (hY : Y.length = k) :
    (∀ i, (replay sel visit i z
      (transcript sel visit p z A ++ Y) (A i)).2 = true) ↔
      Y = transcript sel visit k (reference sel visit p z A).1
        (reference sel visit p z A).2 := by
  rw [replay_accepts_iff]
  simp only [List.length_append, transcript_length, hY]
  rw [transcript_add]
  exact ⟨List.append_cancel_left, congrArg (List.append _)⟩

end Replay

section Selection

variable {Y I K : Type*} [Fintype Y] [Fintype I] [Field K]

theorem product_flags (P : I → Bool) :
    (∏ i, if P i then (1 : K) else 0) =
      if ∀ i, P i = true then 1 else 0 := by
  classical
  by_cases h : ∀ i, P i = true
  · simp [h]
  · rw [if_neg h]
    obtain ⟨i, hi⟩ := not_forall.mp h
    apply Finset.prod_eq_zero (Finset.mem_univ i)
    cases hpi : P i <;> simp_all

theorem one_passing_sum (P : Y → I → Bool) (out : Y → K) (y₀ : Y)
    (h : ∀ y, (∀ i, P y i = true) ↔ y = y₀) :
    (∑ y, out y * ∏ i, if P y i then (1 : K) else 0) = out y₀ := by
  classical
  simp only [product_flags, h]
  simp

end Selection

inductive Terminal where
  | running
  | halted
  | timeout
  deriving DecidableEq, Repr

structure Controller (Q : Type*) (heads : ℕ) where
  state : Q
  elapsed : ℕ
  position : Fin heads → ℤ
  terminal : Terminal

def Safe {Q : Type*} {heads : ℕ} (T : ℕ) (z : Controller Q heads) : Prop :=
  z.elapsed ≤ T ∧ ∀ h, (z.position h).natAbs ≤ z.elapsed

structure Instruction (Q S : Type*) (heads : ℕ) where
  state : Q
  write : S
  move : Fin heads → ℤ
  unit : ∀ h, (move h).natAbs ≤ 1

def finish {Q : Type*} (halt : Q → Bool) (T time : ℕ) (q : Q) : Terminal :=
  if halt q then .halted else if time = T then .timeout else .running

def advance {Q S : Type*} {heads : ℕ} (halt : Q → Bool) (T : ℕ)
    (z : Controller Q heads) (a : Instruction Q S heads) : Controller Q heads :=
  ⟨a.state, z.elapsed + 1, fun h => z.position h + a.move h,
    finish halt T (z.elapsed + 1) a.state⟩

theorem safe_advance {Q S : Type*} {heads T : ℕ} (halt : Q → Bool)
    (z : Controller Q heads) (a : Instruction Q S heads)
    (hz : Safe T z) (ht : z.elapsed < T) :
    Safe T (advance halt T z a) := by
  refine ⟨by simpa [advance] using ht, ?_⟩
  intro h
  exact (Int.natAbs_add_le _ _).trans (Nat.add_le_add (hz.2 h) (a.unit h))

theorem all_heads_in_cap {Q : Type*} {heads T : ℕ}
    (z : Controller Q heads) (hz : Safe T z) (h : Fin heads) :
    (z.position h).natAbs ≤ T := (hz.2 h).trans hz.1

theorem halt_has_priority {Q : Type*} (halt : Q → Bool)
    (T time : ℕ) (q : Q) (hq : halt q = true) :
    finish halt T time q = .halted := by simp [finish, hq]

theorem timeout_at_cap {Q : Type*} (halt : Q → Bool)
    (T : ℕ) (q : Q) (hq : halt q = false) :
    finish halt T T q = .timeout := by simp [finish, hq]

structure RawCodec (R C : Type*) where
  decode : R → Option C
  encode : C → R
  canonical : ∀ z c, decode z = some c → encode c = z

def accepted {R Q : Type*} {heads : ℕ} (codec : RawCodec R (Controller Q heads))
    (T : ℕ) (z : R) : Prop :=
  ∃ c, codec.decode z = some c ∧ Safe T c

theorem accepted_confined {R Q : Type*} {heads T : ℕ}
    (codec : RawCodec R (Controller Q heads)) (z : R)
    (hz : accepted codec T z) :
    ∃ c, codec.encode c = z ∧ Safe T c ∧ ∀ h, (c.position h).natAbs ≤ T := by
  obtain ⟨c, hc, hs⟩ := hz
  exact ⟨c, codec.canonical z c hc, hs, all_heads_in_cap c hs⟩

def blockIndex (a b q : ℤ) : ℤ := (q - a) / b

theorem adjacent_boundary (x b : ℤ) (hb : 0 < b) :
    (x + 1) / b ≠ x / b ↔ (x + 1) % b = 0 := by
  have h₀ := Int.emod_nonneg x (ne_of_gt hb)
  have h₁ := Int.emod_lt_of_pos x hb
  have h₂ := Int.emod_nonneg (x + 1) (ne_of_gt hb)
  have h₃ := Int.emod_lt_of_pos (x + 1) hb
  have e₀ := Int.mul_ediv_add_emod x b
  have e₁ := Int.mul_ediv_add_emod (x + 1) b
  constructor
  · intro hd
    by_contra hn
    have hr : 1 ≤ (x + 1) % b := by omega
    have hge : x / b + 1 ≤ (x + 1) / b := by
      have hm := Int.ediv_le_ediv hb (show x ≤ x + 1 by omega)
      omega
    nlinarith
  · intro hr he
    nlinarith

theorem right_crossing_offset (q a b : ℤ) (hb : 0 < b)
    (ha₀ : 0 ≤ a) (ha₁ : a < b) :
    blockIndex a b (q + 1) ≠ blockIndex a b q ↔ a = (q + 1) % b := by
  have hre : q + 1 - a = q - a + 1 := by ring
  have h : blockIndex a b (q + 1) ≠ blockIndex a b q ↔
      (q + 1 - a) % b = 0 := by
    simpa only [blockIndex, hre] using adjacent_boundary (q - a) b hb
  rw [h]
  constructor
  · intro he
    have eqn := Int.mul_ediv_add_emod (q + 1 - a) b
    have hq : q + 1 = b * ((q + 1 - a) / b) + a := by
      nlinarith
    rw [hq]
    simp [Int.add_emod, Int.mul_emod, Int.emod_eq_of_lt ha₀ ha₁]
  · intro he
    subst a
    have eqn := Int.mul_ediv_add_emod (q + 1) b
    have hq : q + 1 - (q + 1) % b = b * ((q + 1) / b) := by omega
    rw [hq]
    simp

theorem averaging (b T : ℕ) (hb : 0 < b) (count : Fin b → ℕ)
    (h : ∑ a, count a ≤ T) :
    ∃ a, count a ≤ T / b := by
  by_contra hn
  have hall : ∀ a, T / b + 1 ≤ count a := by
    intro a
    have := not_exists.mp hn a
    omega
  have hs := Finset.sum_le_sum (s := Finset.univ) (fun a _ => hall a)
  have hm := Nat.mod_lt T hb
  have he := Nat.div_add_mod T b
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul] at hs
  nlinarith

structure Partition where
    width : ℕ
    positive : 0 < width
    offset : ℤ

def Partition.index (P : Partition) (q : ℤ) : ℤ :=
    blockIndex P.offset P.width q

def Partition.slot (P : Partition) (q : ℤ) : Fin P.width :=
    ⟨((q - P.offset) % (P.width : ℤ)).toNat, by
      have hp : (0 : ℤ) < P.width := by exact_mod_cast P.positive
      have hn := Int.emod_nonneg (q - P.offset) (ne_of_gt hp)
      have hl := Int.emod_lt_of_pos (q - P.offset) hp
      omega⟩

def Partition.point (P : Partition) (v : ℤ) (j : Fin P.width) : ℤ :=
    P.offset + v * P.width + j.val

theorem Partition.reconstruct (P : Partition) (q : ℤ) :
      P.point (P.index q) (P.slot q) = q := by
    have hp : (0 : ℤ) < P.width := by exact_mod_cast P.positive
    have hn := Int.emod_nonneg (q - P.offset) (ne_of_gt hp)
    have he := Int.mul_ediv_add_emod (q - P.offset) P.width
    simp only [Partition.point, Partition.index, blockIndex, Partition.slot]
    rw [Int.toNat_of_nonneg hn]
    nlinarith

theorem Partition.coordinates_injective (P : Partition) (q r : ℤ)
      (hi : P.index q = P.index r) (hs : P.slot q = P.slot r) : q = r := by
    rw [← P.reconstruct q, hi, hs, P.reconstruct]

structure Machine (Q S U : Type*) (rho : ℕ) where
    halt : Q → Bool
    transition : Q → S → (Fin rho → U) → Instruction Q S (rho + 1)

section Visits

variable {Q S U W : Type*} {rho : ℕ}

def small (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
      (z : Controller Q (rho + 1)) (B : Fin P.width → W) :
      Controller Q (rho + 1) × (Fin P.width → W) :=
    let a := M.transition z.state (decode (B (P.slot (z.position 0))))
      (fun h => sym h (z.position h.succ))
    (advance M.halt T z a,
      Function.update B (P.slot (z.position 0)) (encode a.write))

def visitLoop (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U) :
      ℕ → Controller Q (rho + 1) → (Fin P.width → W) →
        Controller Q (rho + 1) × (Fin P.width → W)
    | n, z, B =>
      if z.terminal ≠ .running then (z, B)
      else if M.halt z.state then ({z with terminal := .halted}, B)
      else if T ≤ z.elapsed then ({z with terminal := .timeout}, B)
      else match n with
        | 0 => (z, B)
        | n + 1 =>
          let r := small M P T decode encode sym z B
          if P.index (r.1.position 0) ≠ P.index (z.position 0) then r
          else visitLoop M P T decode encode sym n r.1 r.2

def visitQueries (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U) :
      ℕ → Controller Q (rho + 1) → (Fin P.width → W) →
        List (Controller Q (rho + 1))
    | n, z, B =>
      if z.terminal ≠ .running then []
      else if M.halt z.state then []
      else if T ≤ z.elapsed then []
      else match n with
        | 0 => []
        | n + 1 =>
          let r := small M P T decode encode sym z B
          z :: if P.index (r.1.position 0) ≠ P.index (z.position 0) then []
            else visitQueries M P T decode encode sym n r.1 r.2

theorem small_safe (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
      (z : Controller Q (rho + 1)) (B : Fin P.width → W)
      (hz : Safe T z) (ht : z.elapsed < T) :
      Safe T (small M P T decode encode sym z B).1 :=
    safe_advance M.halt z _ hz ht

theorem small_departure_owned (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
      (z : Controller Q (rho + 1)) (B : Fin P.width → W)
      (j : Fin P.width) (hj : j ≠ P.slot (z.position 0)) :
      (small M P T decode encode sym z B).2 j = B j := by
    simp [small, hj]

theorem visit_safe_and_queries (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
      (n : ℕ) (z : Controller Q (rho + 1)) (B : Fin P.width → W)
      (hz : Safe T z) :
      Safe T (visitLoop M P T decode encode sym n z B).1 ∧
        ∀ c ∈ visitQueries M P T decode encode sym n z B,
          Safe T c ∧ c.elapsed < T ∧ ∀ h, (c.position h).natAbs ≤ T := by
    induction n generalizing z B with
    | zero =>
        simp only [visitLoop, visitQueries]
        split_ifs <;> simp_all [Safe]
    | succ n ih =>
        simp only [visitLoop, visitQueries]
        split_ifs with hterm hhalt htime hcross
        · simp_all
        · simp_all [Safe]
        · simp_all [Safe]
        · exact ⟨small_safe M P T decode encode sym z B hz (by omega),
            by simpa using
              (show Safe T z ∧ z.elapsed < T ∧
                ∀ h, (z.position h).natAbs ≤ T from
                  ⟨hz, by omega, all_heads_in_cap z hz⟩)⟩
        · have hs := small_safe M P T decode encode sym z B hz (by omega)
          have hh := ih (small M P T decode encode sym z B).1
            (small M P T decode encode sym z B).2 hs
          exact ⟨hh.1, by simpa using
            (show (Safe T z ∧ z.elapsed < T ∧
              ∀ h, (z.position h).natAbs ≤ T) ∧
              ∀ c ∈ visitQueries M P T decode encode sym n
                (small M P T decode encode sym z B).1
                (small M P T decode encode sym z B).2,
                Safe T c ∧ c.elapsed < T ∧ ∀ h, (c.position h).natAbs ≤ T from
              ⟨⟨hz, by omega, all_heads_in_cap z hz⟩, hh.2⟩)⟩

theorem visit_stops (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
      (n : ℕ) (z : Controller Q (rho + 1)) (B : Fin P.width → W)
      (hbudget : T ≤ z.elapsed + n) :
      (visitLoop M P T decode encode sym n z B).1.terminal ≠ .running ∨
        P.index ((visitLoop M P T decode encode sym n z B).1.position 0) ≠
          P.index (z.position 0) := by
    induction n generalizing z B with
    | zero =>
        have ht : T ≤ z.elapsed := by omega
        simp only [visitLoop]
        split_ifs <;> simp_all
    | succ n ih =>
        simp only [visitLoop]
        split_ifs with hterm hhalt htime hcross
        · exact Or.inl hterm
        · exact Or.inl (by simp)
        · exact Or.inl (by simp)
        · exact Or.inr hcross
        · have hh := ih (small M P T decode encode sym z B).1
            (small M P T decode encode sym z B).2 (by
              simpa [small, advance, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm]
                using hbudget)
          simpa [not_not.mp hcross] using hh

theorem visit_preserves_exterior (M : Machine Q S U rho) (P : Partition) (T : ℕ)
      (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
      (n : ℕ) (z : Controller Q (rho + 1)) (B : Fin P.width → W)
      (hz : Safe T z) (j : Fin P.width)
      (hj : T < (P.point (P.index (z.position 0)) j).natAbs) :
      (visitLoop M P T decode encode sym n z B).2 j = B j := by
    induction n generalizing z B with
    | zero =>
        simp only [visitLoop]
        split_ifs <;> rfl
    | succ n ih =>
        have hneq : j ≠ P.slot (z.position 0) := by
          intro he
          rw [he, P.reconstruct] at hj
          have hc := all_heads_in_cap z hz 0
          omega
        simp only [visitLoop]
        split_ifs with hterm hhalt htime hcross
        · rfl
        · rfl
        · rfl
        · exact small_departure_owned M P T decode encode sym z B j hneq
        · have hs := small_safe M P T decode encode sym z B hz (by omega)
          have hh := ih (small M P T decode encode sym z B).1
            (small M P T decode encode sym z B).2 hs (by
              simpa [not_not.mp hcross] using hj)
          exact hh.trans (small_departure_owned M P T decode encode sym z B j hneq)

def assemble (P : Partition) (A : ℤ → Fin P.width → W) (q : ℤ) : W :=
  A (P.index q) (P.slot q)

theorem assemble_update (P : Partition) (A : ℤ → Fin P.width → W)
    (q : ℤ) (w : W) :
    assemble P (Function.update A (P.index q)
      (Function.update (A (P.index q)) (P.slot q) w)) =
      Function.update (assemble P A) q w := by
  funext r
  by_cases hr : r = q
  · subst r
    simp [assemble]
  · by_cases hi : P.index r = P.index q
    · have hs : P.slot r ≠ P.slot q :=
          fun he => hr (P.coordinates_injective r q hi he)
      simp [assemble, hi, hs, hr]
    · simp [assemble, hi, hr]

def tapeSmall (M : Machine Q S U rho) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : Controller Q (rho + 1)) (tape : ℤ → W) :
    Controller Q (rho + 1) × (ℤ → W) :=
  let a := M.transition z.state (decode (tape (z.position 0)))
    (fun h => sym h (z.position h.succ))
  (advance M.halt T z a, Function.update tape (z.position 0) (encode a.write))

theorem small_agrees_with_one_tape (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : Controller Q (rho + 1)) (A : ℤ → Fin P.width → W) :
    let r := small M P T decode encode sym z (A (P.index (z.position 0)))
    tapeSmall M T decode encode sym z (assemble P A) =
      (r.1, assemble P (Function.update A (P.index (z.position 0)) r.2)) := by
  dsimp only [small, tapeSmall]
  congr 1
  exact (assemble_update P A _ _).symm

def tapeVisitLoop (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U) :
    ℕ → Controller Q (rho + 1) → (ℤ → W) →
      Controller Q (rho + 1) × (ℤ → W)
  | n, z, tape =>
    if z.terminal ≠ .running then (z, tape)
    else if M.halt z.state then ({z with terminal := .halted}, tape)
    else if T ≤ z.elapsed then ({z with terminal := .timeout}, tape)
    else match n with
      | 0 => (z, tape)
      | n + 1 =>
          let r := tapeSmall M T decode encode sym z tape
          if P.index (r.1.position 0) ≠ P.index (z.position 0) then r
          else tapeVisitLoop M P T decode encode sym n r.1 r.2

theorem visit_agrees_with_one_tape (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (A : ℤ → Fin P.width → W) :
    let r := visitLoop M P T decode encode sym n z (A (P.index (z.position 0)))
    tapeVisitLoop M P T decode encode sym n z (assemble P A) =
      (r.1, assemble P (Function.update A (P.index (z.position 0)) r.2)) := by
  induction n generalizing z A with
  | zero =>
      simp only [visitLoop, tapeVisitLoop]
      split_ifs <;> simp [Function.update_eq_self]
  | succ n ih =>
      simp only [visitLoop, tapeVisitLoop, small_agrees_with_one_tape]
      split_ifs with hterm hhalt htime hcross
      · simp [Function.update_eq_self]
      · simp [Function.update_eq_self]
      · simp [Function.update_eq_self]
      · rfl
      · have hh := ih (small M P T decode encode sym z
            (A (P.index (z.position 0)))).1
          (Function.update A (P.index (z.position 0))
            (small M P T decode encode sym z
              (A (P.index (z.position 0)))).2)
        simpa [not_not.mp hcross, Function.update_idem] using hh

theorem visit_terminal_fixed (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (B : Fin P.width → W)
    (ht : z.terminal ≠ .running) :
    visitLoop M P T decode encode sym n z B = (z, B) := by
  cases n <;> simp [visitLoop, ht]

def tapeRun (M : Machine Q S U rho) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U) :
    ℕ → Controller Q (rho + 1) → (ℤ → W) →
      Controller Q (rho + 1) × (ℤ → W)
  | n, z, tape =>
    if z.terminal ≠ .running then (z, tape)
    else if M.halt z.state then ({z with terminal := .halted}, tape)
    else if T ≤ z.elapsed then ({z with terminal := .timeout}, tape)
    else match n with
      | 0 => (z, tape)
      | n + 1 =>
        let r := tapeSmall M T decode encode sym z tape
        tapeRun M T decode encode sym n r.1 r.2

def crossLoop (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U) :
    ℕ → Controller Q (rho + 1) → (ℤ → W) → ℕ
  | 0, _, _ => 0
  | n + 1, z, tape =>
    if z.terminal ≠ .running then 0
    else if M.halt z.state then 0
    else if T ≤ z.elapsed then 0
    else
      let r := tapeSmall M T decode encode sym z tape
      (if P.index (r.1.position 0) ≠ P.index (z.position 0) then 1 else 0) +
        crossLoop M P T decode encode sym n r.1 r.2

theorem tape_run_terminal (M : Machine Q S U rho) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (tape : ℤ → W)
    (ht : z.terminal ≠ .running) :
    tapeRun M T decode encode sym n z tape = (z, tape) := by
  cases n <;> simp [tapeRun, ht]

theorem tape_visit_terminal (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (tape : ℤ → W)
    (ht : z.terminal ≠ .running) :
    tapeVisitLoop M P T decode encode sym n z tape = (z, tape) := by
  cases n <;> simp [tapeVisitLoop, ht]

theorem cross_loop_terminal (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (tape : ℤ → W)
    (ht : z.terminal ≠ .running) :
    crossLoop M P T decode encode sym n z tape = 0 := by
  cases n <;> simp [crossLoop, ht]

theorem visit_outcome_and_crossing_credit
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (tape : ℤ → W)
    (heq : z.elapsed + n = T) :
    let r := tapeVisitLoop M P T decode encode sym n z tape
    tapeRun M T decode encode sym n z tape =
      tapeRun M T decode encode sym (T - r.1.elapsed) r.1 r.2 ∧
      (if r.1.terminal = .running then 1 else 0) +
        crossLoop M P T decode encode sym (T - r.1.elapsed) r.1 r.2 ≤
          crossLoop M P T decode encode sym n z tape := by
  induction n generalizing z tape with
  | zero =>
      have ht : T ≤ z.elapsed := by omega
      have hrem : T - z.elapsed = 0 := by omega
      by_cases hterm : z.terminal ≠ .running
      · simp [tape_visit_terminal, tape_run_terminal, cross_loop_terminal, hterm]
      by_cases hhalt : M.halt z.state = true
      · simp [tapeVisitLoop, tapeRun, crossLoop, hterm, hhalt, hrem]
      · simp [tapeVisitLoop, tapeRun, crossLoop, hterm, hhalt, ht, hrem]
  | succ n ih =>
      by_cases hterm : z.terminal ≠ .running
      · simp [tape_visit_terminal, tape_run_terminal, cross_loop_terminal, hterm]
      by_cases hhalt : M.halt z.state = true
      · simp [tapeVisitLoop, tapeRun, crossLoop, hterm, hhalt,
          tape_run_terminal, cross_loop_terminal]
      by_cases htime : T ≤ z.elapsed
      · simp [tapeVisitLoop, tapeRun, crossLoop, hterm, hhalt, htime,
          tape_run_terminal, cross_loop_terminal]
      let r := tapeSmall M T decode encode sym z tape
      have hr : r.1.elapsed + n = T := by
        dsimp only [r, tapeSmall, advance]
        omega
      have hrem : T - r.1.elapsed = n := by omega
      by_cases hcross :
          P.index ((tapeSmall M T decode encode sym z tape).1.position 0) ≠
            P.index (z.position 0)
      ·
        simp only [tapeVisitLoop, tapeRun, crossLoop, if_neg hterm, if_neg hhalt,
          if_neg htime, if_pos hcross]
        change (tapeRun M T decode encode sym n r.1 r.2 =
          tapeRun M T decode encode sym (T - r.1.elapsed) r.1 r.2 ∧
          (if r.1.terminal = .running then 1 else 0) +
            crossLoop M P T decode encode sym (T - r.1.elapsed) r.1 r.2 ≤
            1 + crossLoop M P T decode encode sym n r.1 r.2)
        rw [hrem]
        exact ⟨rfl, by split_ifs <;> omega⟩
      ·
        have hh := ih r.1 r.2 hr
        simpa only [tapeVisitLoop, tapeRun, crossLoop, if_neg hterm, if_neg hhalt,
          if_neg htime, if_neg hcross, Nat.zero_add, r] using hh

def tapeMacro (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (s : Controller Q (rho + 1) × (ℤ → W)) :
    Controller Q (rho + 1) × (ℤ → W) :=
  tapeVisitLoop M P T decode encode sym (T - s.1.elapsed) s.1 s.2

def macroRun (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U) :
    ℕ → (Controller Q (rho + 1) × (ℤ → W)) →
      Controller Q (rho + 1) × (ℤ → W)
  | 0, s => s
  | n + 1, s => macroRun M P T decode encode sym n
      (tapeMacro M P T decode encode sym s)

theorem macro_run_terminal (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (s : Controller Q (rho + 1) × (ℤ → W)) (ht : s.1.terminal ≠ .running) :
    macroRun M P T decode encode sym n s = s := by
  induction n with
  | zero => rfl
  | succ n ih => simpa [macroRun, tapeMacro, tape_visit_terminal, ht] using ih

theorem tape_macro_safe (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (s : Controller Q (rho + 1) × (ℤ → W)) (hs : Safe T s.1) :
    Safe T (tapeMacro M P T decode encode sym s).1 := by
  let A : ℤ → Fin P.width → W := fun v j => s.2 (P.point v j)
  have ha : assemble P A = s.2 := by
    funext q
    simp [assemble, A, P.reconstruct]
  have hh := visit_agrees_with_one_tape M P T decode encode sym (T - s.1.elapsed) s.1 A
  rw [ha] at hh
  have hsafe := (visit_safe_and_queries M P T decode encode sym
    (T - s.1.elapsed) s.1 (A (P.index (s.1.position 0))) hs).1
  simpa only [tapeMacro, hh] using hsafe

def remainingCross (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (s : Controller Q (rho + 1) × (ℤ → W)) : ℕ :=
  crossLoop M P T decode encode sym (T - s.1.elapsed) s.1 s.2

theorem actual_macro_completion (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (s : Controller Q (rho + 1) × (ℤ → W)) (hs : Safe T s.1)
    (hbudget : remainingCross M P T decode encode sym s < n) :
    (macroRun M P T decode encode sym n s).1.terminal ≠ .running := by
  have hcredit : ∀ n s, Safe T s.1 →
      (macroRun M P T decode encode sym n s).1.terminal = .running →
        n + remainingCross M P T decode encode sym
          (macroRun M P T decode encode sym n s) ≤
            remainingCross M P T decode encode sym s := by
    intro n
    induction n with
    | zero => intro s _ _; simp [macroRun]
    | succ n ih =>
        intro s hs hrun
        let r := tapeMacro M P T decode encode sym s
        have hr : Safe T r.1 := tape_macro_safe M P T decode encode sym s hs
        have hrrun : r.1.terminal = .running := by
          by_contra hn
          have hh := macro_run_terminal M P T decode encode sym n r hn
          have hc : (macroRun M P T decode encode sym n r).1.terminal = .running := hrun
          rw [hh] at hc
          exact hn hc
        have hi := ih r hr hrun
        have hv := (visit_outcome_and_crossing_credit M P T decode encode sym
          (T - s.1.elapsed) s.1 s.2 (by have := hs.1; omega)).2
        change (if r.1.terminal = .running then 1 else 0) +
          remainingCross M P T decode encode sym r ≤
            remainingCross M P T decode encode sym s at hv
        rw [if_pos hrrun] at hv
        change n + 1 + remainingCross M P T decode encode sym
          (macroRun M P T decode encode sym n r) ≤ _
        omega
  intro hn
  have hh := hcredit n s hs hn
  omega

theorem macro_outcome_invariant (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (s : Controller Q (rho + 1) × (ℤ → W)) (hs : Safe T s.1) :
    let r := macroRun M P T decode encode sym n s
    tapeRun M T decode encode sym (T - s.1.elapsed) s.1 s.2 =
      tapeRun M T decode encode sym (T - r.1.elapsed) r.1 r.2 := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih =>
      have hv := (visit_outcome_and_crossing_credit M P T decode encode sym
        (T - s.1.elapsed) s.1 s.2 (by have := hs.1; omega)).1
      exact hv.trans (ih (tapeMacro M P T decode encode sym s)
        (tape_macro_safe M P T decode encode sym s hs))

end Visits

section RawVisits

variable {R Q S U W : Type*} {rho : ℕ}

instance safeDecidable (T : ℕ) (z : Controller Q (rho + 1)) : Decidable (Safe T z) := by
  unfold Safe
  infer_instance

def checkedDecode (codec : RawCodec R (Controller Q (rho + 1))) (T : ℕ) (z : R) :
    Option (Controller Q (rho + 1)) :=
  match codec.decode z with
  | none => none
  | some c => if Safe T c then some c else none

def rawSelector (codec : RawCodec R (Controller Q (rho + 1))) (P : Partition)
    (T : ℕ) (z : R) : ℤ :=
  match checkedDecode codec T z with
  | none => P.index 0
  | some c => P.index (c.position 0)

def rawVisit (codec : RawCodec R (Controller Q (rho + 1)))
    (dummy : Controller Q (rho + 1)) (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (B : Fin P.width → W) : R × (Fin P.width → W) :=
  match checkedDecode codec T z with
  | none => (codec.encode dummy, B)
  | some c =>
    if c.terminal ≠ .running then (z, B)
    else
      let r := visitLoop M P T decode encode sym (T - c.elapsed) c B
      (codec.encode r.1, r.2)

def rawQueries (codec : RawCodec R (Controller Q (rho + 1)))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (B : Fin P.width → W) : List (Controller Q (rho + 1)) :=
  match checkedDecode codec T z with
  | none => []
  | some c =>
    if c.terminal ≠ .running then []
    else visitQueries M P T decode encode sym (T - c.elapsed) c B

theorem raw_queries_confined (codec : RawCodec R (Controller Q (rho + 1)))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (B : Fin P.width → W) :
    ∀ c ∈ rawQueries codec M P T decode encode sym z B,
      c.elapsed < T ∧ ∀ h, (c.position h).natAbs ≤ T := by
  unfold rawQueries checkedDecode
  cases he : codec.decode z with
  | none => simp
  | some c =>
      dsimp only
      by_cases hs : Safe T c
      ·
        simp only [if_pos hs]
        by_cases ht : c.terminal ≠ .running
        ·
          simp [ht]
        ·
          simp only [if_neg ht]
          intro u hu
          exact ((visit_safe_and_queries M P T decode encode sym
            (T - c.elapsed) c B hs).2 u hu).2
      ·
        simp [hs]

theorem raw_rejected_buffer_unchanged
    (codec : RawCodec R (Controller Q (rho + 1))) (dummy : Controller Q (rho + 1))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (B : Fin P.width → W) (hz : checkedDecode codec T z = none) :
    rawVisit codec dummy M P T decode encode sym z B = (codec.encode dummy, B) := by
  simp [rawVisit, hz]

theorem raw_accepted_agreement
    (codec : RawCodec R (Controller Q (rho + 1))) (dummy : Controller Q (rho + 1))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (B : Fin P.width → W) (c : Controller Q (rho + 1))
    (hc : codec.decode z = some c) (hs : Safe T c) :
    let r := visitLoop M P T decode encode sym (T - c.elapsed) c B
    rawVisit codec dummy M P T decode encode sym z B = (codec.encode r.1, r.2) := by
  simp only [rawVisit, checkedDecode, hc, if_pos hs]
  by_cases ht : c.terminal ≠ .running
  · rw [if_pos ht, visit_terminal_fixed M P T decode encode sym _ c B ht]
    simp [codec.canonical z c hc]
  · simp [ht]

theorem raw_one_tape_agreement
    (codec : RawCodec R (Controller Q (rho + 1))) (dummy : Controller Q (rho + 1))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (c : Controller Q (rho + 1)) (A : ℤ → Fin P.width → W)
    (hc : codec.decode z = some c) (hs : Safe T c) :
    let out := rawVisit codec dummy M P T decode encode sym z
      (A (rawSelector codec P T z))
    let whole := tapeMacro M P T decode encode sym (c, assemble P A)
    out.1 = codec.encode whole.1 ∧
      whole.2 = assemble P (Function.update A (rawSelector codec P T z) out.2) := by
  have hsel : rawSelector codec P T z = P.index (c.position 0) := by
    simp [rawSelector, checkedDecode, hc, hs]
  dsimp only [tapeMacro]
  rw [hsel, raw_accepted_agreement codec dummy M P T decode encode sym
    z (A (P.index (c.position 0))) c hc hs]
  rw [visit_agrees_with_one_tape M P T decode encode sym (T - c.elapsed) c A]
  exact ⟨rfl, rfl⟩

theorem raw_serial_one_tape
    (codec : RawCodec R (Controller Q (rho + 1))) (dummy : Controller Q (rho + 1))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (roundtrip : ∀ c, Safe T c → codec.decode (codec.encode c) = some c)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : R) (c : Controller Q (rho + 1)) (A : ℤ → Fin P.width → W)
    (hc : codec.decode z = some c) (hs : Safe T c) :
    let raw := reference (rawSelector codec P T)
      (rawVisit codec dummy M P T decode encode sym) n z A
    let whole := macroRun M P T decode encode sym n (c, assemble P A)
    raw.1 = codec.encode whole.1 ∧ whole.2 = assemble P raw.2 := by
  induction n generalizing z c A with
  | zero => exact ⟨(codec.canonical z c hc).symm, rfl⟩
  | succ n ih =>
      let raw := serial (rawSelector codec P T)
        (rawVisit codec dummy M P T decode encode sym) z A
      let whole := tapeMacro M P T decode encode sym (c, assemble P A)
      have ha := raw_one_tape_agreement codec dummy M P T decode encode sym z c A hc hs
      have hsafe : Safe T whole.1 := tape_macro_safe M P T decode encode sym _ hs
      have hdec : codec.decode raw.1 = some whole.1 := by
        change codec.decode
          (rawVisit codec dummy M P T decode encode sym z
            (A (rawSelector codec P T z))).1 = _
        rw [ha.1]
        exact roundtrip whole.1 hsafe
      have hh := ih raw.1 whole.1 raw.2 hdec hsafe
      have hp : (whole.1, assemble P raw.2) = whole := by
        apply Prod.ext
        · rfl
        · exact ha.2.symm
      rw [hp] at hh
      exact hh

end RawVisits

section Words

abbrev Raw (c : ℕ) := Fin c → Bool
abbrev Word (d : ℕ) := Fin d → Bool

def slice {c d : ℕ} (H : Word d) (t : ℕ) : Raw c :=
  fun j => if h : t * c + j.val < d then H ⟨t * c + j.val, h⟩ else false

def pack {c d : ℕ} (Z : List (Raw c)) : Word d :=
  fun i =>
    if hc : 0 < c then
      match Z[i.val / c]? with
      | none => false
      | some z => z ⟨i.val % c, Nat.mod_lt _ hc⟩
    else false

theorem slice_pack {c d : ℕ} (Z : List (Raw c))
    (hwidth : Z.length * c ≤ d) (t : ℕ) (ht : t < Z.length) :
    slice (c := c) (pack (d := d) Z) t = Z[t] := by
  funext j
  have hc : 0 < c := Nat.zero_lt_of_lt j.isLt
  have hpos : t * c + j.val < d := by nlinarith [j.isLt]
  have hdiv : (t * c + j.val) / c = t := by
    rw [Nat.mul_comm t c, Nat.mul_add_div hc, Nat.div_eq_of_lt j.isLt]
    omega
  have hmod : (t * c + j.val) % c = j.val := by
    simp [Nat.add_mod, Nat.mod_eq_of_lt j.isLt]
  simp only [slice, dif_pos hpos, pack, dif_pos hc, hdiv]
  simp only [List.getElem?_eq_getElem ht]
  exact congrArg (Z[t]) (Fin.ext hmod)

def parsedOut {c d : ℕ} (H : Word d) (m : ℕ) : List (Raw c) :=
  List.ofFn (fun t : Fin m => slice H (t.val + 1))

theorem slice_history_start {B I : Type*} [DecidableEq I]
    {c d : ℕ} (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (m : ℕ) (z : Raw c) (A : I → B) (hw : (m + 1) * c ≤ d) :
    slice (c := c) (pack (d := d) (z :: transcript sel visit m z A)) 0 = z := by
  simpa using slice_pack (d := d) (z :: transcript sel visit m z A)
    (by simpa using hw) 0 (by simp)

theorem parsed_history {B I : Type*} [DecidableEq I] {c d : ℕ}
    (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (m : ℕ) (z : Raw c) (A : I → B) (hw : (m + 1) * c ≤ d) :
    parsedOut (c := c) (pack (d := d) (z :: transcript sel visit m z A)) m =
      transcript sel visit m z A := by
  unfold parsedOut
  have he : (fun t : Fin m => slice (c := c)
      (pack (d := d) (z :: transcript sel visit m z A)) (t.val + 1)) =
      (fun t : Fin m => (transcript sel visit m z A)[t.val]'(by simpa using t.isLt)) := by
    funext t
    simpa using slice_pack (d := d) (z :: transcript sel visit m z A)
      (by simpa using hw) (t.val + 1) (by simpa using t.isLt)
  rw [he]
  simpa using List.ofFn_get (transcript sel visit m z A)

def padBlock {l d : ℕ} (B : Word l) : Word d :=
  fun j => if h : j.val < l then B ⟨j.val, h⟩ else false

def parseBlock {l d : ℕ} (hw : l ≤ d) (A : Word d) : Word l :=
  fun j => A ⟨j.val, j.isLt.trans_le hw⟩

@[simp] theorem parse_pad_block {l d : ℕ} (hw : l ≤ d) (B : Word l) :
    parseBlock hw (padBlock (d := d) B) = B := by
  funext j
  simp [parseBlock, padBlock, j.isLt]

noncomputable def candidates (k c : ℕ) :
    Fin (2 ^ (k * c)) ≃ (Fin k → Raw c) :=
  Fintype.equivOfCardEq (by simp [Raw, ← Nat.pow_mul, Nat.mul_comm])

noncomputable def candidateList {k c : ℕ} (Y : Fin (2 ^ (k * c))) : List (Raw c) :=
  List.ofFn (candidates k c Y)

@[simp] theorem candidate_length {k c : ℕ} (Y : Fin (2 ^ (k * c))) :
    (candidateList Y).length = k := by simp [candidateList]

theorem candidate_injective {k c : ℕ} :
    Function.Injective (candidateList : Fin (2 ^ (k * c)) → List (Raw c)) := by
  intro Y Z he
  exact (candidates k c).injective (List.ofFn_injective he)

theorem candidate_surjective {k c : ℕ} (Y : List (Raw c)) (hY : Y.length = k) :
    ∃ y : Fin (2 ^ (k * c)), candidateList y = Y := by
  subst k
  refine ⟨(candidates Y.length c).symm Y.get, ?_⟩
  simp [candidateList, List.ofFn_get]

def roundOutput {c d : ℕ} (m : ℕ) (ys : List (Raw c)) (H : Word d) : Word d :=
  pack (slice H 0 :: (parsedOut H m ++ ys))

def roundPredicate {c l d N : ℕ} (hw : l ≤ d)
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (m : ℕ) (ys : List (Raw c)) (i : Fin N) (H A : Word d) : Bool :=
  (replay sel visit i (slice H 0) (parsedOut H m ++ ys) (parseBlock hw A)).2

theorem round_unique {c l d N k : ℕ} (hw : l ≤ d)
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (m : ℕ) (z : Raw c) (A : Fin N → Word l) (hwidth : (m + 1) * c ≤ d) :
    ∃! y : Fin (2 ^ (k * c)),
      ∀ i, roundPredicate hw sel visit m (candidateList y) i
        (pack (d := d) (z :: transcript sel visit m z A)) (padBlock (A i)) = true := by
  obtain ⟨y, hy⟩ := candidate_surjective
    (transcript sel visit k (reference sel visit m z A).1
      (reference sel visit m z A).2) (transcript_length _ _ _ _ _)
  have hp : ∀ Y : Fin (2 ^ (k * c)),
      (∀ i, roundPredicate hw sel visit m (candidateList Y) i
        (pack (d := d) (z :: transcript sel visit m z A)) (padBlock (A i)) = true) ↔
      candidateList Y = transcript sel visit k (reference sel visit m z A).1
        (reference sel visit m z A).2 := by
    intro Y
    simp only [roundPredicate, slice_history_start sel visit m z A hwidth,
      parsed_history sel visit m z A hwidth, parse_pad_block]
    exact unique_raw_suffix sel visit m k z A (candidateList Y) (candidate_length Y)
  refine ⟨y, (hp y).mpr hy, ?_⟩
  intro Y hY
  exact candidate_injective ((hp Y).mp hY |>.trans hy.symm)

theorem round_factored_identity {K : Type*} [Field K] {c l d N k : ℕ}
    (hw : l ≤ d) (sel : Raw c → Fin N)
    (visit : Raw c → Word l → Raw c × Word l)
    (m : ℕ) (z : Raw c) (A : Fin N → Word l) (hwidth : (m + 1) * c ≤ d) :
    Audit137.augment (K := K) (pack (d := d)
      (z :: transcript sel visit (m + k) z A)) =
    (fun bit => ∑ y : Fin (2 ^ (k * c)),
      Audit137.augment (K := K)
        (roundOutput m (candidateList y)
          (pack (d := d) (z :: transcript sel visit m z A))) bit *
        ∏ i : Fin N, if roundPredicate hw sel visit m (candidateList y) i
          (pack (d := d) (z :: transcript sel visit m z A))
          (padBlock (A i)) then 1 else 0) := by
  obtain ⟨y, hy⟩ := candidate_surjective
    (transcript sel visit k (reference sel visit m z A).1
      (reference sel visit m z A).2) (transcript_length _ _ _ _ _)
  have hp : ∀ Y : Fin (2 ^ (k * c)),
      (∀ i, roundPredicate hw sel visit m (candidateList Y) i
        (pack (d := d) (z :: transcript sel visit m z A)) (padBlock (A i)) = true) ↔
      Y = y := by
    intro Y
    simp only [roundPredicate, slice_history_start sel visit m z A hwidth,
      parsed_history sel visit m z A hwidth, parse_pad_block]
    rw [unique_raw_suffix sel visit m k z A (candidateList Y) (candidate_length Y)]
    rw [← hy]
    exact candidate_injective.eq_iff
  funext bit
  rw [one_passing_sum _ _ y hp]
  simp only [roundOutput, slice_history_start sel visit m z A hwidth,
    parsed_history sel visit m z A hwidth, hy, ← transcript_add]

theorem round_instantiates_reviewed_history {K : Type*} [Field K]
    {c l d N k : ℕ} (hw : l ≤ d) (sel : Raw c → Fin N)
    (visit : Raw c → Word l → Raw c × Word l)
    (m : ℕ) (z : Raw c) (A : Fin N → Word l) (hwidth : (m + 1) * c ≤ d) :
    Audit137.historyPolynomial
      (Audit137.booleanHistoryOutput (K := K)
        (fun Y H => roundOutput m (candidateList (k := k) Y) H))
      (Audit137.booleanHistoryPredicate (K := K)
        (fun Y i H B => roundPredicate hw sel visit m (candidateList Y) i H B))
      (fun i => Audit137.augment (K := K) (padBlock (d := d) (A i)))
      (Audit137.augment (K := K) (pack (d := d) (z :: transcript sel visit m z A))) =
        Audit137.augment (K := K) (pack (d := d)
          (z :: transcript sel visit (m + k) z A)) :=
  Audit137.semantic_only_history_identity _ _ _ _ _
    (round_factored_identity hw sel visit m z A hwidth)

theorem transcript_last {R B I : Type*} [DecidableEq R] [DecidableEq I]
    (sel : R → I) (visit : R → B → R × B)
    (n : ℕ) (z : R) (A : I → B) :
    (z :: transcript sel visit n z A)[n]'(by simp) =
      (reference sel visit n z A).1 := by
  induction n generalizing z A with
  | zero => rfl
  | succ n ih =>
      simpa only [transcript, reference, List.getElem_cons_succ] using
        ih (serial sel visit z A).1 (serial sel visit z A).2

theorem history_last {B I : Type*} [DecidableEq I] {c d : ℕ}
    (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (m : ℕ) (z : Raw c) (A : I → B) (hw : (m + 1) * c ≤ d) :
    slice (c := c) (pack (d := d) (z :: transcript sel visit m z A)) m =
      (reference sel visit m z A).1 := by
  rw [slice_pack _ (by simpa using hw) m (by simp)]
  exact transcript_last sel visit m z A

def epochState {B I : Type*} [DecidableEq I] {c : ℕ}
    (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (b : ℕ) (z : Raw c) (A : I → B) (e : ℕ) : Raw c × (I → B) :=
  reference sel visit (e * b) z A

def epochHistory {B I : Type*} [DecidableEq I] {c d : ℕ}
    (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (b k : ℕ) (z : Raw c) (A : I → B) (e j : ℕ) : Word d :=
  let s := epochState sel visit b z A e
  pack (s.1 :: transcript sel visit (j * k) s.1 s.2)

def checkpoint {c l d N : ℕ} (hw : l ≤ d)
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (b : ℕ) (i : Fin N) (H A : Word d) : Word d :=
  padBlock ((replay sel visit i (slice H 0) (parsedOut H b) (parseBlock hw A)).1)

def extraction {c d : ℕ} (b : ℕ) (H : Word d) : Word d :=
  pack [slice (c := c) H b]

theorem epoch_state_next {B I : Type*} [DecidableEq I] {c : ℕ}
    (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (b : ℕ) (z : Raw c) (A : I → B) (e : ℕ) :
    epochState sel visit b z A (e + 1) =
      reference sel visit b (epochState sel visit b z A e).1
        (epochState sel visit b z A e).2 := by
  simp only [epochState, Nat.add_mul, Nat.one_mul]
  exact reference_add sel visit (e * b) b z A

theorem epoch_checkpoint_identity {c l d N : ℕ} (hw : l ≤ d)
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (k : ℕ) (z : Raw c) (A : Fin N → Word l) (e : ℕ) (i : Fin N)
    (hwidth : (k * k + 1) * c ≤ d) :
    padBlock (d := d) ((epochState sel visit (k * k) z A (e + 1)).2 i) =
      checkpoint hw sel visit (k * k) i
        (epochHistory (d := d) sel visit (k * k) k z A e k)
        (padBlock ((epochState sel visit (k * k) z A e).2 i)) := by
  rw [epoch_state_next]
  simp only [checkpoint, epochHistory,
    slice_history_start sel visit _ _ _ hwidth,
    parsed_history sel visit _ _ _ hwidth, parse_pad_block,
    replay_reference_buffers]

theorem epoch_extraction_identity {B I : Type*} [DecidableEq I] {c d : ℕ}
    (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (k : ℕ) (z : Raw c) (A : I → B) (e : ℕ)
    (hwidth : (k * k + 1) * c ≤ d) :
    epochHistory (d := d) sel visit (k * k) k z A (e + 1) 0 =
      extraction (c := c) (k * k)
        (epochHistory (d := d) sel visit (k * k) k z A e k) := by
  simp only [epochHistory, Nat.zero_mul, transcript, extraction]
  rw [history_last sel visit _ _ _ hwidth, epoch_state_next]

theorem final_epoch_raw_controller {B I : Type*} [DecidableEq I] {c d E : ℕ}
    (sel : Raw c → I) (visit : Raw c → B → Raw c × B)
    (k : ℕ) (z : Raw c) (A : I → B) (hE : 1 ≤ E)
    (hwidth : (k * k + 1) * c ≤ d) :
    slice (c := c) (epochHistory (d := d) sel visit (k * k) k z A (E - 1) k)
      (k * k) = (reference sel visit (E * (k * k)) z A).1 := by
  simp only [epochHistory]
  rw [history_last sel visit _ _ _ hwidth]
  have hh := congrArg Prod.fst (epoch_state_next sel visit (k * k) z A (E - 1))
  have he : E - 1 + 1 = E := by omega
  simpa only [he, epochState] using hh.symm

theorem guess_fits {k c d : ℕ} (hk : 1 ≤ k) (hw : (k * k + 1) * c ≤ d) :
    k * c ≤ d := by nlinarith

theorem round_width {k c d : ℕ} (hk : 1 ≤ k) (hw : (k * k + 1) * c ≤ d)
    (j : ℕ) (hj : j < k) : (j * k + 1) * c ≤ d := by
  have hm := Nat.mul_le_mul_right k (Nat.le_of_lt hj)
  exact (Nat.mul_le_mul_right c (Nat.add_le_add_right hm 1)).trans hw

end Words

theorem signed_cap_bounds (q : ℤ) (T : ℕ) (h : q.natAbs ≤ T) :
    -(T : ℤ) ≤ q ∧ q ≤ T := by
  have hp : q ≤ (T : ℤ) :=
    Int.le_natAbs.trans (by exact_mod_cast h)
  have hn : -q ≤ (T : ℤ) := by
    have hneg : (-q).natAbs ≤ T := by simpa using h
    exact Int.le_natAbs.trans (by exact_mod_cast hneg)
  omega

def blockLow (P : Partition) (T : ℕ) : ℤ := P.index (-(T : ℤ))
def blockHigh (P : Partition) (T : ℕ) : ℤ := P.index T
def blockCount (P : Partition) (T : ℕ) : ℕ := (blockHigh P T - blockLow P T + 1).toNat

theorem index_in_range (P : Partition) (T : ℕ) (q : ℤ) (hq : q.natAbs ≤ T) :
    blockLow P T ≤ P.index q ∧ P.index q ≤ blockHigh P T := by
  have hp : (0 : ℤ) < P.width := by exact_mod_cast P.positive
  have hb := signed_cap_bounds q T hq
  exact ⟨Int.ediv_le_ediv hp (by omega), Int.ediv_le_ediv hp (by omega)⟩

theorem block_count_bound (P : Partition) (T : ℕ) :
    1 ≤ blockCount P T ∧ P.width * blockCount P T ≤ 2 * P.width + 2 * T := by
  have hp : (0 : ℤ) < P.width := by exact_mod_cast P.positive
  have hm := index_in_range P T 0 (by simp)
  have hlo := Int.mul_ediv_add_emod (-(T : ℤ) - P.offset) P.width
  have hhi := Int.mul_ediv_add_emod ((T : ℤ) - P.offset) P.width
  have hrlo := Int.emod_lt_of_pos (-(T : ℤ) - P.offset) hp
  have hrhi := Int.emod_nonneg ((T : ℤ) - P.offset) (ne_of_gt hp)
  have hnn : 0 ≤ blockHigh P T - blockLow P T + 1 := by omega
  have hcast : (blockCount P T : ℤ) = blockHigh P T - blockLow P T + 1 := by
    exact Int.toNat_of_nonneg hnn
  constructor
  · omega
  · apply Int.ofNat_le.mp
    push_cast
    rw [hcast]
    dsimp only [blockHigh, blockLow, Partition.index, blockIndex]
    nlinarith

section RawCap

variable {R Q S U W : Type*} {rho : ℕ}

theorem raw_selector_range (codec : RawCodec R (Controller Q (rho + 1)))
    (P : Partition) (T : ℕ) (z : R) :
    blockLow P T ≤ rawSelector codec P T z ∧
      rawSelector codec P T z ≤ blockHigh P T := by
  unfold rawSelector checkedDecode
  cases he : codec.decode z with
  | none => exact index_in_range P T 0 (by simp)
  | some c =>
      dsimp only
      split_ifs with hs
      · exact index_in_range P T (c.position 0) (all_heads_in_cap c hs 0)
      · exact index_in_range P T 0 (by simp)

def finiteSelector (codec : RawCodec R (Controller Q (rho + 1)))
    (P : Partition) (T : ℕ) (z : R) : Fin (blockCount P T) :=
  ⟨(rawSelector codec P T z - blockLow P T).toNat, by
    have hr := raw_selector_range codec P T z
    have hnn : 0 ≤ blockHigh P T - blockLow P T + 1 := by omega
    have hc : (blockCount P T : ℤ) = blockHigh P T - blockLow P T + 1 :=
      Int.toNat_of_nonneg hnn
    omega⟩

theorem finite_selector_exact (codec : RawCodec R (Controller Q (rho + 1)))
    (P : Partition) (T : ℕ) (z : R) :
    blockLow P T + (finiteSelector codec P T z).val = rawSelector codec P T z := by
  have hr := raw_selector_range codec P T z
  simp only [finiteSelector]
  rw [Int.toNat_of_nonneg (by omega)]
  omega

theorem raw_preserves_exterior
    (codec : RawCodec R (Controller Q (rho + 1))) (dummy : Controller Q (rho + 1))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (B : Fin P.width → W) (j : Fin P.width)
    (hj : T < (P.point (rawSelector codec P T z) j).natAbs) :
    (rawVisit codec dummy M P T decode encode sym z B).2 j = B j := by
  unfold rawVisit rawSelector checkedDecode at *
  cases he : codec.decode z with
  | none => simp [he]
  | some c =>
      simp only [he] at *
      by_cases hs : Safe T c
      ·
        simp only [if_pos hs] at *
        by_cases ht : c.terminal ≠ .running
        · simp [ht]
        ·
          simp only [if_neg ht]
          exact visit_preserves_exterior M P T decode encode sym _ c B hs j hj
      · simp [hs]

theorem raw_visit_safe_stops
    (codec : RawCodec R (Controller Q (rho + 1)))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (dummy : Controller Q (rho + 1)) (hd : Safe T dummy)
    (hdt : dummy.terminal ≠ .running)
    (roundtrip : ∀ c, Safe T c → codec.decode (codec.encode c) = some c)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : R) (B : Fin P.width → W) :
    ∃ c, codec.decode (rawVisit codec dummy M P T decode encode sym z B).1 = some c ∧
      Safe T c ∧ (c.terminal ≠ .running ∨
        P.index (c.position 0) ≠ rawSelector codec P T z) := by
  cases he : codec.decode z with
  | none =>
      refine ⟨dummy, ?_, hd, Or.inl hdt⟩
      simpa [rawVisit, checkedDecode, he] using roundtrip dummy hd
  | some c =>
      by_cases hs : Safe T c
      ·
        rw [raw_accepted_agreement codec dummy M P T decode encode sym z B c he hs]
        have hsafe := (visit_safe_and_queries M P T decode encode sym
          (T - c.elapsed) c B hs).1
        refine ⟨_, roundtrip _ hsafe, hsafe, ?_⟩
        have hstop := visit_stops M P T decode encode sym (T - c.elapsed) c B (by omega)
        simpa [rawSelector, checkedDecode, he, hs] using hstop
      ·
        refine ⟨dummy, ?_, hd, Or.inl hdt⟩
        simpa [rawVisit, checkedDecode, he, hs] using roundtrip dummy hd

def represented {W : Type*} (P : Partition) (T : ℕ) (filler : W)
    (tape : ℤ → W) (v : ℤ) : Fin P.width → W :=
  fun j => if (P.point v j).natAbs ≤ T then tape (P.point v j) else filler

theorem initial_accessor_radius {W : Type*} (P : Partition) (T : ℕ) (filler : W)
    (tape : ℤ → W) (v : ℤ) (j : Fin P.width) :
    ((P.point v j).natAbs ≤ T ∧
      represented P T filler tape v j = tape (P.point v j)) ∨
      (T < (P.point v j).natAbs ∧ represented P T filler tape v j = filler) := by
  by_cases h : (P.point v j).natAbs ≤ T
  · exact Or.inl ⟨h, by simp [represented, h]⟩
  · exact Or.inr ⟨by omega, by simp [represented, h]⟩

end RawCap

def blockPacking (b ell : ℕ) : (Fin b → Raw ell) ≃ Raw (b * ell) :=
  (Equiv.curry (Fin b) (Fin ell) Bool).symm.trans
    (Equiv.arrowCongr finProdFinEquiv (Equiv.refl Bool))

def crossingEvent (b : ℕ) (hb : 0 < b) (q r : ℤ) : Option (Fin b) :=
  if q = r then none else
    some ⟨((max q r) % (b : ℤ)).toNat, by
      have hp : (0 : ℤ) < b := by exact_mod_cast hb
      have h₀ := Int.emod_nonneg (max q r) (ne_of_gt hp)
      have h₁ := Int.emod_lt_of_pos (max q r) hp
      omega⟩

theorem physical_crossing_event (b : ℕ) (hb : 0 < b) (q r : ℤ)
    (hm : (r - q).natAbs ≤ 1) (a : Fin b) :
    blockIndex a.val b r ≠ blockIndex a.val b q ↔ crossingEvent b hb q r = some a := by
  have hp : (0 : ℤ) < b := by exact_mod_cast hb
  have ha₀ : (0 : ℤ) ≤ a.val := by omega
  have ha₁ : (a.val : ℤ) < b := by exact_mod_cast a.isLt
  have hd := signed_cap_bounds (r - q) 1 hm
  have hc : r = q ∨ r = q + 1 ∨ r = q - 1 := by omega
  rcases hc with he | he | he
  · subst r
    simp [crossingEvent]
  · subst r
    rw [right_crossing_offset q a.val b hp ha₀ ha₁]
    have hmax : max q (q + 1) = q + 1 := by omega
    simp only [crossingEvent, show q ≠ q + 1 by omega, if_false, hmax,
      Option.some.injEq, Fin.ext_iff]
    have hn := Int.emod_nonneg (q + 1) (ne_of_gt hp)
    omega
  · subst r
    have hr : blockIndex a.val b q ≠ blockIndex a.val b (q - 1) ↔
        (a.val : ℤ) = q % b := by
      simpa using right_crossing_offset (q - 1) a.val b hp ha₀ ha₁
    rw [ne_comm, hr]
    have hmax : max q (q - 1) = q := by omega
    simp only [crossingEvent, show q ≠ q - 1 by omega,
      if_false, hmax, Option.some.injEq, Fin.ext_iff]
    have hn := Int.emod_nonneg q (ne_of_gt hp)
    omega

def offsetPartition (b : ℕ) (hb : 0 < b) (a : Fin b) : Partition :=
  ⟨b, hb, a.val⟩

theorem unit_step_offset_sum (b : ℕ) (hb : 0 < b) (q r : ℤ)
    (hm : (r - q).natAbs ≤ 1) :
    (∑ a : Fin b, if (offsetPartition b hb a).index r ≠
      (offsetPartition b hb a).index q then 1 else 0) ≤ 1 := by
  have he : (∑ a : Fin b, if (offsetPartition b hb a).index r ≠
      (offsetPartition b hb a).index q then 1 else 0) =
      ∑ a : Fin b, if crossingEvent b hb q r = some a then 1 else 0 := by
    apply Finset.sum_congr rfl
    intro a _
    simp only [offsetPartition, Partition.index, physical_crossing_event b hb q r hm a]
  rw [he]
  cases h : crossingEvent b hb q r <;> simp

theorem actual_crossing_sum {Q S U W : Type*} {rho : ℕ}
    (M : Machine Q S U rho) (b : ℕ) (hb : 0 < b) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (tape : ℤ → W) :
    (∑ a : Fin b, crossLoop M (offsetPartition b hb a) T
      decode encode sym n z tape) ≤ n := by
  induction n generalizing z tape with
  | zero => simp [crossLoop]
  | succ n ih =>
      by_cases hterm : z.terminal ≠ .running
      · simp [crossLoop, hterm]
      by_cases hhalt : M.halt z.state = true
      · simp [crossLoop, hterm, hhalt]
      by_cases htime : T ≤ z.elapsed
      · simp [crossLoop, hterm, hhalt, htime]
      let r := tapeSmall M T decode encode sym z tape
      have hm : (r.1.position 0 - z.position 0).natAbs ≤ 1 := by
        dsimp only [r, tapeSmall, advance]
        simpa using
          (M.transition z.state (decode (tape (z.position 0)))
            (fun h => sym h (z.position h.succ))).unit 0
      have hs := unit_step_offset_sum b hb (z.position 0) (r.1.position 0) hm
      have hi := ih r.1 r.2
      simp only [crossLoop, if_neg hterm, if_neg hhalt, if_neg htime,
        Finset.sum_add_distrib]
      change (∑ a : Fin b, if (offsetPartition b hb a).index (r.1.position 0) ≠
        (offsetPartition b hb a).index (z.position 0) then 1 else 0) +
        (∑ a : Fin b, crossLoop M (offsetPartition b hb a) T
          decode encode sym n r.1 r.2) ≤ n + 1
      omega

theorem supplied_cap_completed_offset {Q S U W : Type*} {rho : ℕ}
    (M : Machine Q S U rho) (b : ℕ) (hb : 0 < b) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (z : Controller Q (rho + 1)) (tape : ℤ → W)
    (hz : Safe T z) (hzero : z.elapsed = 0) :
    ∃ a : Fin b,
      let out := macroRun M (offsetPartition b hb a) T decode encode sym
        (1 + Audit137.ceilDiv T b) (z, tape)
      out.1.terminal ≠ .running ∧ out = tapeRun M T decode encode sym T z tape := by
  obtain ⟨a, ha⟩ := averaging b T hb
    (fun a : Fin b => crossLoop M (offsetPartition b hb a) T decode encode sym T z tape)
    (actual_crossing_sum M b hb T decode encode sym T z tape)
  have hd : T / b ≤ Audit137.ceilDiv T b := by
    apply Nat.div_le_div_right
    omega
  have hbudget : remainingCross M (offsetPartition b hb a) T decode encode sym
      (z, tape) < 1 + Audit137.ceilDiv T b := by
    simpa only [remainingCross, hzero, Nat.sub_zero] using
      (show crossLoop M (offsetPartition b hb a) T decode encode sym T z tape <
        1 + Audit137.ceilDiv T b by omega)
  have ht := actual_macro_completion M (offsetPartition b hb a) T decode encode sym
    (1 + Audit137.ceilDiv T b) (z, tape) hz hbudget
  refine ⟨a, ht, ?_⟩
  have ho := macro_outcome_invariant M (offsetPartition b hb a) T decode encode sym
    (1 + Audit137.ceilDiv T b) (z, tape) hz
  dsimp only at ho
  rw [tape_run_terminal M T decode encode sym _ _ _ ht] at ho
  simpa only [hzero, Nat.sub_zero] using ho.symm

section ConcreteGraph

abbrev Vertex (E N k : ℕ) := (Fin E × Fin N) ⊕ (Fin E × Fin (k + 1))

def vertexLabel {E N k : ℕ} : Vertex E N k → Audit137.EpochVertex
  | .inl (e, i) => .array e.val i.val
  | .inr (e, j) => .history e.val j.val

def previousFin {n : ℕ} (e : Fin n) (he : e.val ≠ 0) : Fin n :=
  ⟨e.val - 1, by omega⟩

def historySlot (t : Fin 3) : Fin 3 := Audit137.skipSlot t 0
def arraySlot (t : Fin 3) : Fin 3 := Audit137.skipSlot t 1

theorem history_slot_avoid (t : Fin 3) : historySlot t ≠ t :=
  Audit137.skipSlot_avoid t 0

theorem array_slot_avoid (t : Fin 3) : arraySlot t ≠ t :=
  Audit137.skipSlot_avoid t 1

theorem distinct_slots (t : Fin 3) : historySlot t ≠ arraySlot t := by
  intro he
  have hi := Audit137.skipSlot_injective t he
  exact (show (0 : Fin 2) ≠ 1 by decide) hi

noncomputable def unary {K Id : Type*} [Field K] {d : ℕ}
    (u : Id) (f : Word d → Word d) : Audit137.OrdinaryData K 3 (d + 1) d Id :=
  Audit137.booleanOrdinary (fun _ : Fin 1 => u)
    (fun t _ => historySlot t)
    (fun _ _ _ _ => Subsingleton.elim _ _) (fun t _ => history_slot_avoid t)
    (fun args => f (args 0))

noncomputable def binary {K Id : Type*} [Field K] {d : ℕ}
    (u v : Id) (f : Word d → Word d → Word d) :
    Audit137.OrdinaryData K 3 (d + 1) d Id :=
  Audit137.booleanOrdinary (fun j : Fin 2 => if j.val = 0 then u else v) Audit137.skipSlot
    Audit137.skipSlot_injective Audit137.skipSlot_avoid
    (fun args => f (args 0) (args 1))

theorem unary_agrees {K Id : Type*} [Field K] {d : ℕ}
    (u : Id) (f : Word d → Word d) (v : Id → Word d) :
    (Audit137.Rule.ordinary (unary (K := K) u f)).semantic
      (fun x => Audit137.augment (K := K) (v x)) =
      Audit137.augment (K := K) (f (v u)) := by
  exact Audit137.booleanOrdinary_agrees _ _ _ _ _ _

theorem binary_agrees {K Id : Type*} [Field K] {d : ℕ}
    (u w : Id) (f : Word d → Word d → Word d) (v : Id → Word d) :
    (Audit137.Rule.ordinary (binary (K := K) u w f)).semantic
      (fun x => Audit137.augment (K := K) (v x)) =
      Audit137.augment (K := K) (f (v u) (v w)) := by
  exact Audit137.booleanOrdinary_agrees _ _ _ _ _ _

variable {K : Type*} [Field K] {c l d N k E : ℕ}

def semanticWord (sel : Raw c → Fin N)
    (visit : Raw c → Word l → Raw c × Word l)
    (z : Raw c) (A : Fin N → Word l) : Vertex E N k → Word d
  | .inl (e, i) => padBlock ((epochState sel visit (k * k) z A e.val).2 i)
  | .inr (e, j) => epochHistory sel visit (k * k) k z A e.val j.val

noncomputable def epochRules (hw : l ≤ d) (hk : 1 ≤ k)
    (hwidth : (k * k + 1) * c ≤ d)
    (D : Audit137.Stencil K ((N + 1) * d))
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (z : Raw c) (A : Fin N → Word l) :
    Vertex E N k → Audit137.Rule K 3 (d + 1) d (Vertex E N k)
  | .inl (e, i) =>
    if he : e.val = 0 then .base (Audit137.augment (padBlock (A i)))
    else .ordinary (binary (.inl (previousFin e he, i))
      (.inr (previousFin e he, ⟨k, by omega⟩))
      (fun B H => checkpoint hw sel visit (k * k) i H B))
  | .inr (e, j) =>
    if hj : j.val = 0 then
      if he : e.val = 0 then .base (Audit137.augment (pack [z]))
      else .ordinary (unary (.inr (previousFin e he, ⟨k, by omega⟩))
        (extraction (c := c) (k * k)))
    else .history (Audit137.booleanHistory (k * c) N (guess_fits hk hwidth)
      (.inr (e, previousFin j hj)) (fun i => .inl (e, i))
      historySlot arraySlot history_slot_avoid array_slot_avoid distinct_slots D
      (fun Y H => roundOutput ((j.val - 1) * k) (candidateList Y) H)
      (fun Y i H B => roundPredicate hw sel visit ((j.val - 1) * k)
        (candidateList Y) i H B))

theorem epoch_rules_semantic (hw : l ≤ d) (hk : 1 ≤ k)
    (hwidth : (k * k + 1) * c ≤ d)
    (D : Audit137.Stencil K ((N + 1) * d))
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (z : Raw c) (A : Fin N → Word l) (u : Vertex E N k) :
    Audit137.augment (K := K) (semanticWord sel visit z A u) =
      (epochRules hw hk hwidth D sel visit z A u).semantic
        (fun v => Audit137.augment (K := K) (semanticWord sel visit z A v)) := by
  cases u with
  | inl pair =>
      obtain ⟨e, i⟩ := pair
      by_cases he : e.val = 0
      · simp [epochRules, he, Audit137.Rule.semantic, semanticWord, epochState, reference]
      ·
        simp only [epochRules, dif_neg he]
        rw [binary_agrees]
        apply congrArg Audit137.augment
        have hh := epoch_checkpoint_identity (d := d) hw sel visit k z A
          (e.val - 1) i hwidth
        have heq : e.val - 1 + 1 = e.val := by omega
        simpa only [heq, semanticWord, previousFin] using hh
  | inr pair =>
      obtain ⟨e, j⟩ := pair
      by_cases hj : j.val = 0
      ·
        by_cases he : e.val = 0
        · simp [epochRules, hj, he, Audit137.Rule.semantic, semanticWord,
            epochHistory, epochState, reference, transcript]
        ·
          simp only [epochRules, dif_pos hj, dif_neg he]
          rw [unary_agrees]
          apply congrArg Audit137.augment
          have hh := epoch_extraction_identity (d := d) sel visit k z A
            (e.val - 1) hwidth
          have heq : e.val - 1 + 1 = e.val := by omega
          simpa only [heq, semanticWord, previousFin, hj] using hh
      ·
        simp only [epochRules, dif_neg hj, Audit137.Rule.semantic,
          Audit137.booleanHistory]
        have hprev : j.val - 1 < k := by omega
        have hwround := round_width hk hwidth (j.val - 1) hprev
        have hh := round_instantiates_reviewed_history (K := K) (k := k) hw sel visit
          ((j.val - 1) * k) (epochState sel visit (k * k) z A e.val).1
          (epochState sel visit (k * k) z A e.val).2 hwround
        have hlen : (j.val - 1) * k + k = j.val * k := by
          have hjq : j.val - 1 + 1 = j.val := by omega
          nlinarith
        simpa only [semanticWord, epochHistory, previousFin, hlen,
          Function.comp_def] using hh.symm

theorem epoch_rules_navigation (hw : l ≤ d) (hk : 1 ≤ k)
    (hwidth : (k * k + 1) * c ≤ d)
    (D : Audit137.Stencil K ((N + 1) * d))
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (z : Raw c) (A : Fin N → Word l) (u v : Vertex E N k) (w : ℕ)
    (h : Audit137.Dependency (epochRules hw hk hwidth D sel visit z A) u v w) :
    Audit137.EpochEdge k (k * c) (vertexLabel u) (vertexLabel v) w := by
  cases u with
  | inl pair =>
      obtain ⟨e, i⟩ := pair
      by_cases he : e.val = 0
      · simp [Audit137.Dependency, epochRules, he] at h
      ·
        simp only [Audit137.Dependency, epochRules, dif_neg he, binary,
          Audit137.booleanOrdinary] at h
        obtain ⟨j, rfl, rfl⟩ := h
        have heq : e.val - 1 + 1 = e.val := by omega
        fin_cases j
        ·
          simpa [vertexLabel, previousFin, heq] using
            Audit137.EpochEdge.checkpointArray (k := k) (g := k * c) (e.val - 1) i.val
        ·
          simpa [vertexLabel, previousFin, heq] using
            Audit137.EpochEdge.checkpointHistory (k := k) (g := k * c) (e.val - 1) i.val
  | inr pair =>
      obtain ⟨e, j⟩ := pair
      by_cases hj : j.val = 0
      ·
        by_cases he : e.val = 0
        · simp [Audit137.Dependency, epochRules, hj, he] at h
        ·
          simp only [Audit137.Dependency, epochRules, dif_pos hj, dif_neg he, unary,
            Audit137.booleanOrdinary] at h
          obtain ⟨a, rfl, rfl⟩ := h
          have heq : e.val - 1 + 1 = e.val := by omega
          simpa only [vertexLabel, previousFin, hj, heq] using
            Audit137.EpochEdge.extraction (k := k) (g := k * c) (e.val - 1)
      ·
        simp only [Audit137.Dependency, epochRules, dif_neg hj,
          Audit137.booleanHistory] at h
        have hjq : j.val - 1 + 1 = j.val := by omega
        have hprev : j.val - 1 < k := by omega
        rcases h with ⟨rfl, rfl⟩ | ⟨i, rfl, rfl⟩
        ·
          simpa only [vertexLabel, previousFin, hjq] using
            Audit137.EpochEdge.previous (g := k * c) e.val (j.val - 1) hprev
        ·
          simpa only [vertexLabel, hjq] using
            Audit137.EpochEdge.array (g := k * c) e.val (j.val - 1) i.val hprev

theorem realized_epoch_evaluator (hw : l ≤ d) (hk : 1 ≤ k)
    (hwidth : (k * k + 1) * c ≤ d) (hE : 1 ≤ E)
    (S : Audit137.Stencil K d) (D : Audit137.Stencil K ((N + 1) * d))
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (z : Raw c) (A : Fin N → Word l)
    (lambda : K) (t : Fin 3) (R : Audit137.Pool K 3 (d + 1)) (ell : ℕ) :
    let rules := epochRules hw hk hwidth D sel visit z A
    let wf := Audit137.epoch_navigation_wellFounded rules vertexLabel
      (epoch_rules_navigation hw hk hwidth D sel visit z A)
    let u : Vertex E N k := .inr (⟨E - 1, by omega⟩, ⟨k, by omega⟩)
    let out := Audit137.evaluate S rules (Audit137.maximumHeight rules wf u + 1) u lambda t
    out.run R = ((), Audit137.shift R t
      (lambda • Audit137.augment (K := K) (semanticWord sel visit z A u))) ∧
      3 * (d + 1) * ell + out.peak R * ell ≤
        (5 * (d + 1) + E * (k + k * c + 2)) * ell := by
  have hh := Audit137.certified_epoch_evaluator S _
    (Audit137.epoch_navigation_wellFounded _ vertexLabel
      (epoch_rules_navigation hw hk hwidth D sel visit z A))
    _ (epoch_rules_semantic hw hk hwidth D sel visit z A) (by omega)
    vertexLabel (epoch_rules_navigation hw hk hwidth D sel visit z A)
    (.inr (⟨E - 1, by omega⟩, ⟨k, by omega⟩) : Vertex E N k)
    rfl hE lambda t R ell
  simpa only [show 3 * (d + 1) + 2 * (d + 1) = 5 * (d + 1) by ring] using hh

end ConcreteGraph

def dummyController {Q : Type*} (q : Q) (heads : ℕ) : Controller Q heads :=
  ⟨q, 0, fun _ => 0, .timeout⟩

theorem dummy_safe {Q : Type*} (q : Q) (heads T : ℕ) :
    Safe T (dummyController q heads) := by simp [Safe, dummyController]

def finiteVisit {Q S U : Type*} {rho c ell : ℕ}
    (codec : RawCodec (Raw c) (Controller Q (rho + 1))) (q₀ : Q)
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : Raw ell → S) (encode : S → Raw ell) (sym : Fin rho → ℤ → U)
    (z : Raw c) (B : Raw (P.width * ell)) : Raw c × Raw (P.width * ell) :=
  let r := rawVisit codec (dummyController q₀ (rho + 1)) M P T decode encode sym z
    ((blockPacking P.width ell).symm B)
  (r.1, blockPacking P.width ell r.2)

theorem concrete_raw_replay {Q S U : Type*} {rho c ell : ℕ}
    (codec : RawCodec (Raw c) (Controller Q (rho + 1))) (q₀ : Q)
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : Raw ell → S) (encode : S → Raw ell) (sym : Fin rho → ℤ → U)
    (z : Raw c) (A : Fin (blockCount P T) → Raw (P.width * ell)) (Y : List (Raw c)) :
    (∀ i, (replay (finiteSelector codec P T)
      (finiteVisit codec q₀ M P T decode encode sym) i z Y (A i)).2 = true) ↔
      Y = transcript (finiteSelector codec P T)
        (finiteVisit codec q₀ M P T decode encode sym) Y.length z A ∧
      ∀ i, (replay (finiteSelector codec P T)
        (finiteVisit codec q₀ M P T decode encode sym) i z Y (A i)).1 =
        (reference (finiteSelector codec P T)
          (finiteVisit codec q₀ M P T decode encode sym) Y.length z A).2 i :=
  replay_exact _ _ _ _ _

theorem reference_change_blocks {R B C I : Type*} [DecidableEq I]
    (e : B ≃ C) (sel : R → I) (visit : R → B → R × B)
    (n : ℕ) (z : R) (A : I → B) :
    reference sel
      (fun z v => let r := visit z (e.symm v); (r.1, e r.2))
      n z (fun i => e (A i)) =
      let r := reference sel visit n z A
      (r.1, fun i => e (r.2 i)) := by
  induction n generalizing z A with
  | zero => rfl
  | succ n ih =>
      let r := visit z (A (sel z))
      have hu : Function.update (fun i => e (A i)) (sel z) (e r.2) =
          fun i => e (Function.update A (sel z) r.2 i) := by
        funext i
        by_cases h : i = sel z <;> simp [h]
      simpa only [reference, serial, Equiv.symm_apply_apply, r, hu] using
        ih r.1 (Function.update A (sel z) r.2)

def physicalBlock (P : Partition) (T : ℕ) (i : Fin (blockCount P T)) : ℤ :=
  blockLow P T + i.val

theorem physical_block_injective (P : Partition) (T : ℕ) :
    Function.Injective (physicalBlock P T) := by
  intro i j h
  apply Fin.ext
  dsimp only [physicalBlock] at h
  omega

theorem finite_reference_embeds {R Q S U W : Type*} {rho : ℕ}
    (codec : RawCodec R (Controller Q (rho + 1))) (dummy : Controller Q (rho + 1))
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : R) (A : Fin (blockCount P T) → Fin P.width → W)
    (G : ℤ → Fin P.width → W)
    (hG : ∀ i, G (physicalBlock P T i) = A i) :
    let f := rawVisit codec dummy M P T decode encode sym
    let finite := reference (finiteSelector codec P T) f n z A
    let global := reference (rawSelector codec P T) f n z G
    finite.1 = global.1 ∧
      ∀ i, global.2 (physicalBlock P T i) = finite.2 i := by
  induction n generalizing z A G with
  | zero => exact ⟨rfl, hG⟩
  | succ n ih =>
      let f := rawVisit codec dummy M P T decode encode sym
      let i := finiteSelector codec P T z
      let r := f z (A i)
      have hi : physicalBlock P T i = rawSelector codec P T z :=
        finite_selector_exact codec P T z
      have hg : G (rawSelector codec P T z) = A i := by rw [← hi]; exact hG i
      have hu : ∀ j, (Function.update G (rawSelector codec P T z) r.2)
          (physicalBlock P T j) = Function.update A i r.2 j := by
        intro j
        by_cases h : j = i
        · subst j; simp [hi]
        · have hn : physicalBlock P T j ≠ rawSelector codec P T z := by
            rw [← hi]
            exact fun he => h (physical_block_injective P T he)
          simp [Function.update_of_ne hn, Function.update_of_ne h, hG]
      have hh := ih r.1 (Function.update A i r.2)
        (Function.update G (rawSelector codec P T z) r.2) hu
      simpa only [reference, serial, hg, f, i, r] using hh

theorem packed_reference_one_tape {Q S U : Type*} {rho c ell : ℕ}
    (codec : RawCodec (Raw c) (Controller Q (rho + 1))) (q₀ : Q)
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (roundtrip : ∀ z, Safe T z → codec.decode (codec.encode z) = some z)
    (decode : Raw ell → S) (encode : S → Raw ell) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Raw c) (ctrl : Controller Q (rho + 1))
    (A : Fin (blockCount P T) → Fin P.width → Raw ell)
    (G : ℤ → Fin P.width → Raw ell)
    (hG : ∀ i, G (physicalBlock P T i) = A i)
    (hc : codec.decode z = some ctrl) (hs : Safe T ctrl) :
    (reference (finiteSelector codec P T) (finiteVisit codec q₀ M P T decode encode sym)
      n z (fun i => blockPacking P.width ell (A i))).1 =
      codec.encode (macroRun M P T decode encode sym n (ctrl, assemble P G)).1 := by
  have hp := congrArg Prod.fst
    (reference_change_blocks (blockPacking P.width ell)
      (finiteSelector codec P T)
      (rawVisit codec (dummyController q₀ (rho + 1)) M P T decode encode sym) n z A)
  have hf := finite_reference_embeds codec (dummyController q₀ (rho + 1))
    M P T decode encode sym n z A G hG
  have hg := raw_serial_one_tape codec (dummyController q₀ (rho + 1))
    M P T roundtrip decode encode sym n z ctrl G hc hs
  exact hp.trans (hf.1.trans hg.1)

theorem assemble_sampled_tape {W : Type*} (P : Partition) (tape : ℤ → W) :
    assemble P (fun v j => tape (P.point v j)) = tape := by
  funext q
  simp only [assemble, Partition.reconstruct]

theorem tape_run_radius_extensional {Q S U W : Type*} {rho : ℕ}
    (M : Machine Q S U rho) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n : ℕ) (z : Controller Q (rho + 1)) (tape tape' : ℤ → W)
    (hz : Safe T z) (h : ∀ q, q.natAbs ≤ T → tape q = tape' q) :
    (tapeRun M T decode encode sym n z tape).1 =
      (tapeRun M T decode encode sym n z tape').1 ∧
      ∀ q, q.natAbs ≤ T →
        (tapeRun M T decode encode sym n z tape).2 q =
          (tapeRun M T decode encode sym n z tape').2 q := by
  induction n generalizing z tape tape' with
  | zero =>
      simp only [tapeRun]
      split_ifs <;> exact ⟨rfl, h⟩
  | succ n ih =>
      by_cases ht : z.terminal ≠ .running
      · simpa only [tapeRun, if_pos ht, true_and] using h
      by_cases hh : M.halt z.state = true
      · simpa only [tapeRun, if_neg ht, if_pos hh, true_and] using h
      by_cases hc : T ≤ z.elapsed
      · simpa only [tapeRun, if_neg ht, if_neg hh, if_pos hc, true_and] using h
      have hread := h (z.position 0) (all_heads_in_cap z hz 0)
      let r := tapeSmall M T decode encode sym z tape
      let r' := tapeSmall M T decode encode sym z tape'
      have hp : r.1 = r'.1 := by simp only [r, r', tapeSmall, hread]
      have hs : Safe T r.1 :=
        safe_advance M.halt z _ hz (by omega)
      have hw : ∀ q, q.natAbs ≤ T → r.2 q = r'.2 q := by
        intro q hq
        by_cases he : q = z.position 0
        · simp [r, r', tapeSmall, he, hread]
        · simp [r, r', tapeSmall, he, hread, h q hq]
      simp only [tapeRun, if_neg ht, if_neg hh, if_neg hc]
      change (tapeRun M T decode encode sym n r.1 r.2).1 =
        (tapeRun M T decode encode sym n r'.1 r'.2).1 ∧
        ∀ q, q.natAbs ≤ T →
          (tapeRun M T decode encode sym n r.1 r.2).2 q =
            (tapeRun M T decode encode sym n r'.1 r'.2).2 q
      rw [← hp]
      exact ih r.1 r.2 r'.2 hs hw

def cappedTape {W : Type*} (T : ℕ) (filler : W) (tape : ℤ → W) : ℤ → W :=
  fun q => if q.natAbs ≤ T then tape q else filler

theorem assemble_represented {W : Type*} (P : Partition) (T : ℕ)
    (filler : W) (tape : ℤ → W) :
    assemble P (represented P T filler tape) = cappedTape T filler tape := by
  funext q
  simp only [assemble, represented, Partition.reconstruct, cappedTape]

theorem tape_run_decodes {Q S U W : Type*} {rho : ℕ}
    (M : Machine Q S U rho) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (hcode : ∀ s, decode (encode s) = s) (n : ℕ)
    (z : Controller Q (rho + 1)) (tape : ℤ → W) :
    tapeRun M T id id sym n z (fun q => decode (tape q)) =
      let r := tapeRun M T decode encode sym n z tape
      (r.1, fun q => decode (r.2 q)) := by
  induction n generalizing z tape with
  | zero =>
      simp only [tapeRun]
      split_ifs <;> rfl
  | succ n ih =>
      by_cases ht : z.terminal ≠ .running
      · simp only [tapeRun, if_pos ht]
      by_cases hh : M.halt z.state = true
      · simp only [tapeRun, if_neg ht, if_pos hh]
      by_cases hc : T ≤ z.elapsed
      · simp only [tapeRun, if_neg ht, if_neg hh, if_pos hc]
      let a := M.transition z.state (decode (tape (z.position 0)))
        (fun h => sym h (z.position h.succ))
      have hu : (fun q => decode (Function.update tape (z.position 0) (encode a.write) q)) =
          Function.update (fun q => decode (tape q)) (z.position 0) a.write := by
        funext q
        by_cases he : q = z.position 0 <;> simp [he, hcode]
      simp only [tapeRun, if_neg ht, if_neg hh, if_neg hc, tapeSmall, id_eq]
      change tapeRun M T id id sym n (advance M.halt T z a)
        (Function.update (fun q => decode (tape q)) (z.position 0) a.write) = _
      rw [← hu]
      exact ih (advance M.halt T z a) (Function.update tape (z.position 0) (encode a.write))

theorem certified_raw_epoch_evaluator {K Q S U : Type*} [Field K]
    {rho c ell d k E : ℕ} (P : Partition)
    (hw : P.width * ell ≤ d) (hk : 1 ≤ k)
    (hwidth : (k * k + 1) * c ≤ d) (hE : 1 ≤ E)
    (T : ℕ) (codec : RawCodec (Raw c) (Controller Q (rho + 1))) (q₀ : Q)
    (M : Machine Q S U rho)
    (decode : Raw ell → S) (encode : S → Raw ell) (sym : Fin rho → ℤ → U)
    (S₀ : Audit137.Stencil K d)
    (D : Audit137.Stencil K ((blockCount P T + 1) * d))
    (z : Raw c) (A : Fin (blockCount P T) → Raw (P.width * ell))
    (lambda : K) (t : Fin 3) (R : Audit137.Pool K 3 (d + 1)) (unitBits : ℕ) :
    let sel := finiteSelector codec P T
    let visit := finiteVisit codec q₀ M P T decode encode sym
    let rules := epochRules hw hk hwidth D sel visit z A
    let wf := Audit137.epoch_navigation_wellFounded rules vertexLabel
      (epoch_rules_navigation hw hk hwidth D sel visit z A)
    let u : Vertex E (blockCount P T) k := .inr (⟨E - 1, by omega⟩, ⟨k, by omega⟩)
    let out := Audit137.evaluate S₀ rules (Audit137.maximumHeight rules wf u + 1) u lambda t
    out.run R = ((), Audit137.shift R t
      (lambda • Audit137.augment (K := K) (semanticWord sel visit z A u))) ∧
      3 * (d + 1) * unitBits + out.peak R * unitBits ≤
        (5 * (d + 1) + E * (k + k * c + 2)) * unitBits :=
  realized_epoch_evaluator hw hk hwidth hE S₀ D _ _ z A lambda t R unitBits

theorem counted_offsets {b n : ℕ} (offset : Fin n → Option (Fin b)) :
    (∑ a : Fin b, ∑ t : Fin n, if offset t = some a then 1 else 0) ≤ n := by
  classical
  rw [Finset.sum_comm]
  calc
    _ ≤ ∑ _ : Fin n, 1 := by
      apply Finset.sum_le_sum
      intro t _
      cases h : offset t <;> simp
    _ = n := by simp

theorem good_offset {b n : ℕ} (hb : 0 < b) (offset : Fin n → Option (Fin b)) :
    ∃ a : Fin b, (∑ t : Fin n, if offset t = some a then 1 else 0) ≤ n / b :=
  averaging b n hb _ (counted_offsets offset)

theorem capped_path_good_offset {b T : ℕ} (hb : 0 < b) (q : ℕ → ℤ)
    (hm : ∀ t, t < T → (q (t + 1) - q t).natAbs ≤ 1) :
    ∃ a : Fin b,
      (∑ t : Fin T, if blockIndex a.val b (q (t.val + 1)) ≠
        blockIndex a.val b (q t.val) then 1 else 0) ≤ T / b := by
  obtain ⟨a, ha⟩ := good_offset hb
    (fun t : Fin T => crossingEvent b hb (q t.val) (q (t.val + 1)))
  refine ⟨a, ?_⟩
  have he : (∑ t : Fin T, if blockIndex a.val b (q (t.val + 1)) ≠
      blockIndex a.val b (q t.val) then 1 else 0) =
      ∑ t : Fin T, if crossingEvent b hb (q t.val) (q (t.val + 1)) = some a
        then 1 else 0 := by
    apply Finset.sum_congr rfl
    intro t _
    simp only [physical_crossing_event b hb _ _ (hm t.val t.isLt) a]
  rwa [he]

theorem completion_budget {C R : ℕ} (used : ℕ → ℕ) (done : ℕ → Prop)
    (hzero : used 0 = 0)
    (hstep : ∀ n, n < R → ¬ done (n + 1) → used n + 1 ≤ used (n + 1))
    (hpast : ∀ n, n < R → ¬ done (n + 1) → ¬ done n)
    (hcap : used R ≤ C) (hR : C < R) : done R := by
  by_contra hnot
  have hh : ∀ n, n ≤ R → ¬ done n → n ≤ used n := by
    intro n
    induction n with
    | zero => intro _ _; omega
    | succ n ih =>
        intro hn hd
        have hprev := hpast n (by omega) hd
        have hbound := ih (by omega) hprev
        have hinc := hstep n (by omega) hd
        omega
  have := hh R (by omega) hnot
  omega

theorem supplied_visit_budget_completes {b T C : ℕ} (hb : 0 < b)
    (hC : C ≤ T / b) (used : ℕ → ℕ) (done : ℕ → Prop)
    (hzero : used 0 = 0)
    (hstep : ∀ n, n < 1 + Audit137.ceilDiv T b →
      ¬ done (n + 1) → used n + 1 ≤ used (n + 1))
    (hpast : ∀ n, n < 1 + Audit137.ceilDiv T b →
      ¬ done (n + 1) → ¬ done n)
    (hcap : used (1 + Audit137.ceilDiv T b) ≤ C) :
    done (1 + Audit137.ceilDiv T b) := by
  apply completion_budget used done hzero hstep hpast hcap
  have hd : T / b ≤ Audit137.ceilDiv T b := by
    apply Nat.div_le_div_right
    omega
  omega

theorem certified_two_fifths_realization {K : Type*} [Field K]
    {c l d N k T : ℕ} (hw : l ≤ d) (hk : 1 ≤ k) (hc : 1 ≤ c)
    (hwidth : (k * k + 1) * c ≤ d) (hT : T ≤ k ^ 5)
    (S : Audit137.Stencil K d) (D : Audit137.Stencil K ((N + 1) * d))
    (sel : Raw c → Fin N) (visit : Raw c → Word l → Raw c × Word l)
    (z : Raw c) (A : Fin N → Word l)
    (lambda : K) (t : Fin 3) (R : Audit137.Pool K 3 (d + 1)) (ell : ℕ) :
    let E := Audit137.epochCount T k
    let rules := epochRules hw hk hwidth D sel visit z A
    let wf := Audit137.epoch_navigation_wellFounded rules vertexLabel
      (epoch_rules_navigation hw hk hwidth D sel visit z A)
    let u : Vertex E N k := .inr
      (⟨E - 1, by have := Audit137.epochCount_pos (T := T) hk; omega⟩, ⟨k, by omega⟩)
    let out := Audit137.evaluate S rules (Audit137.maximumHeight rules wf u + 1) u lambda t
    out.run R = ((), Audit137.shift R t
      (lambda • Audit137.augment (K := K) (semanticWord sel visit z A u))) ∧
      3 * (d + 1) * ell + out.peak R * ell ≤
        (5 * (d + 1) + 4 * k ^ 2 * (c + 1)) * ell := by
  have hh := realized_epoch_evaluator (K := K) (E := Audit137.epochCount T k)
    hw hk hwidth (Audit137.epochCount_pos hk) S D sel visit z A lambda t R ell
  refine ⟨hh.1, hh.2.trans ?_⟩
  simpa only [show 3 * (d + 1) + 2 * (d + 1) = 5 * (d + 1) by ring] using
    (Audit137.capped_epoch_two_fifths_bound (d := d) (ell := ell) hk hc hT)

theorem ceil_div_capacity (a b : ℕ) (hb : 0 < b) :
    a ≤ Audit137.ceilDiv a b * b := by
  have he := Nat.div_add_mod (a + b - 1) b
  have hm := Nat.mod_lt (a + b - 1) hb
  have hsub : a + b - 1 + 1 = a + b := by omega
  unfold Audit137.ceilDiv
  nlinarith

theorem epoch_padding_capacity (T k : ℕ) (hk : 1 ≤ k) :
    1 + Audit137.ceilDiv T (k * k) ≤ Audit137.epochCount T k * (k * k) := by
  have hh := ceil_div_capacity (1 + Audit137.ceilDiv T (k * k)) (k * k) (by nlinarith)
  simpa only [Audit137.epochCount, pow_two] using hh

theorem macro_run_add {Q S U W : Type*} {rho : ℕ}
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n m : ℕ) (s : Controller Q (rho + 1) × (ℤ → W)) :
    macroRun M P T decode encode sym (n + m) s =
      macroRun M P T decode encode sym m (macroRun M P T decode encode sym n s) := by
  induction n generalizing s with
  | zero => simp [macroRun]
  | succ n ih =>
      simpa only [Nat.succ_add, macroRun] using
        ih (tapeMacro M P T decode encode sym s)

theorem completed_epoch_padding {Q S U W : Type*} {rho : ℕ}
    (M : Machine Q S U rho) (P : Partition) (T : ℕ)
    (decode : W → S) (encode : S → W) (sym : Fin rho → ℤ → U)
    (n m : ℕ) (s : Controller Q (rho + 1) × (ℤ → W)) (hn : n ≤ m)
    (ht : (macroRun M P T decode encode sym n s).1.terminal ≠ .running) :
    macroRun M P T decode encode sym m s = macroRun M P T decode encode sym n s := by
  have he : m = n + (m - n) := by omega
  rw [he, macro_run_add]
  exact macro_run_terminal M P T decode encode sym _ _ ht

theorem capped_epoch_output_correct {Q S U : Type*} {rho c ell d k : ℕ}
    (hk : 1 ≤ k) (hwidth : (k * k + 1) * c ≤ d) (T : ℕ)
    (codec : RawCodec (Raw c) (Controller Q (rho + 1))) (q₀ : Q)
    (M : Machine Q S U rho)
    (roundtrip : ∀ z, Safe T z → codec.decode (codec.encode z) = some z)
    (decode : Raw ell → S) (encode : S → Raw ell) (sym : Fin rho → ℤ → U)
    (filler : Raw ell) (tape : ℤ → Raw ell) (z : Raw c)
    (ctrl : Controller Q (rho + 1)) (hc : codec.decode z = some ctrl)
    (hs : Safe T ctrl) (hzero : ctrl.elapsed = 0) :
    ∃ a : Fin (k * k),
      let P := offsetPartition (k * k) (by nlinarith) a
      let sel := finiteSelector codec P T
      let visit := finiteVisit codec q₀ M P T decode encode sym
      let A := fun i => blockPacking P.width ell
        (represented P T filler tape (physicalBlock P T i))
      slice (c := c) (epochHistory (d := d) sel visit (k * k) k z A
        (Audit137.epochCount T k - 1) k) (k * k) =
          codec.encode (tapeRun M T decode encode sym T ctrl tape).1 ∧
        (tapeRun M T decode encode sym T ctrl tape).1.terminal ≠ .running := by
  obtain ⟨a, ht, hout⟩ := supplied_cap_completed_offset M (k * k) (by nlinarith)
    T decode encode sym ctrl (cappedTape T filler tape) hs hzero
  let P := offsetPartition (k * k) (by nlinarith) a
  let sel := finiteSelector codec P T
  let visit := finiteVisit codec q₀ M P T decode encode sym
  let A := fun i => blockPacking P.width ell
    (represented P T filler tape (physicalBlock P T i))
  have hcapacity := epoch_padding_capacity T k hk
  have hE : 1 ≤ Audit137.epochCount T k := by
    by_contra hn
    have he : Audit137.epochCount T k = 0 := by omega
    rw [he] at hcapacity
    omega
  have hpad := completed_epoch_padding M P T decode encode sym
    (1 + Audit137.ceilDiv T (k * k)) (Audit137.epochCount T k * (k * k))
    (ctrl, cappedTape T filler tape) hcapacity ht
  have hfinal := hpad.trans hout
  have hreference := packed_reference_one_tape codec q₀ M P T roundtrip
    decode encode sym (Audit137.epochCount T k * (k * k)) z ctrl
    (fun i => represented P T filler tape (physicalBlock P T i))
    (represented P T filler tape) (fun _ => rfl) hc hs
  rw [assemble_represented, hfinal] at hreference
  have hcap := tape_run_radius_extensional M T decode encode sym T ctrl
    (cappedTape T filler tape) tape hs (by
      intro q hq
      simp only [cappedTape, if_pos hq])
  rw [hcap.1] at hreference
  refine ⟨a, ?_⟩
  constructor
  · exact (final_epoch_raw_controller sel visit k z A hE hwidth).trans hreference
  · have hh : (tapeRun M T decode encode sym T ctrl
          (cappedTape T filler tape)).1.terminal ≠ .running := by
        rw [← hout]
        exact ht
    simpa only [hcap.1] using hh

end Simulation137

#print axioms Simulation137.replay_exact
#print axioms Simulation137.unique_raw_suffix
#print axioms Simulation137.good_offset
#print axioms Simulation137.raw_queries_confined
#print axioms Simulation137.visit_agrees_with_one_tape
#print axioms Simulation137.round_instantiates_reviewed_history
#print axioms Simulation137.certified_raw_epoch_evaluator
#print axioms Simulation137.certified_two_fifths_realization
#print axioms Simulation137.supplied_cap_completed_offset
#print axioms Simulation137.raw_serial_one_tape
#print axioms Simulation137.final_epoch_raw_controller
#print axioms Simulation137.capped_epoch_output_correct
#print axioms Simulation137.tape_run_decodes
