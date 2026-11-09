import Mathlib

set_option autoImplicit false
set_option maxHeartbeats 1000000

namespace RootCharacter

open DihedralGroup

abbrev D3 := DihedralGroup 3

def IsRoot (q : D3) : Prop := q = r 1 ∨ q = r 2

def IsSimple (q : D3) : Prop := ∃ i, q = sr i

instance (q : D3) : Decidable (IsSimple q) := by
  unfold IsSimple
  infer_instance

variable {G A : Type*} [Group G] [CommRing A] [CharP A 2]

structure TraceData (π : G →* D3) (t : G → A) : Prop where
  one : t 1 = 0
  cyclic : ∀ x y, t (x * y) = t (y * x)
  product : ∀ x y, t x * t y = t (x * y) + t (x * y⁻¹)
  split : ∀ x, π x = 1 → t x = 0
  root : ∀ x, IsRoot (π x) → t x ^ 2 = 1
  simple : ∀ x y, IsSimple (π x) → IsSimple (π y) → t x * t y = 0

variable {π : G →* D3} {t : G → A}

lemma TraceData.conj (T : TraceData π t) (x y : G) :
    t (x * y * x⁻¹) = t y := by
  rw [T.cyclic, inv_mul_cancel_left]

lemma TraceData.square_invariant (T : TraceData π t) (u : G) (hu : π u = 1)
    (x : G) : t (x * u ^ 2) = t x := by
  have h := T.product (x * u) u
  rw [T.split u hu, mul_zero] at h
  have hx : x * u * u⁻¹ = x := by group
  rw [hx] at h
  have hh : t (x * u * u) = t x := by
    exact CharTwo.add_eq_zero.mp h.symm
  simpa [pow_two, mul_assoc] using hh

def invisible (π : G →* D3) (t : G → A) : Subgroup G where
  carrier := {u | π u = 1 ∧ ∀ x, t (x * u) = t x}
  one_mem' := by simp
  mul_mem' := by
    rintro a b ⟨ha, ha'⟩ ⟨hb, hb'⟩
    refine ⟨by simp [ha, hb], ?_⟩
    intro x
    rw [← mul_assoc, hb', ha']
  inv_mem' := by
    rintro a ⟨ha, ha'⟩
    refine ⟨by simp [ha], ?_⟩
    intro x
    simpa using (ha' (x * a⁻¹)).symm

lemma invisible_normal (T : TraceData π t) : (invisible π t).Normal where
  conj_mem := by
    rintro a ⟨ha, ha'⟩ c
    refine ⟨by simp [ha], ?_⟩
    intro x
    calc
      t (x * (c * a * c⁻¹)) = t ((c⁻¹ * x * c) * a) := by
        calc
          t (x * (c * a * c⁻¹)) = t ((x * c * a) * c⁻¹) := by congr 1; group
          _ = t (c⁻¹ * (x * c * a)) := T.cyclic _ _
          _ = t ((c⁻¹ * x * c) * a) := by congr 1; group
      _ = t (c⁻¹ * x * c) := ha' _
      _ = t x := by simpa using T.conj c⁻¹ x

lemma invisible_square (T : TraceData π t) (u : G) (hu : π u = 1) :
    u ^ 2 ∈ invisible π t :=
  ⟨by simp [hu], T.square_invariant u hu⟩

def kernelSquares (π : G →* D3) : Subgroup G :=
  Subgroup.closure {x | ∃ u, π u = 1 ∧ x = u ^ 2}

instance kernelSquares_normal : (kernelSquares π).Normal where
  conj_mem := by
    intro n hn g
    refine Subgroup.closure_induction (fun x hx => ?_) ?_
      (fun x y _ _ ihx ihy => ?_) (fun x _ ihx => ?_) hn
    · obtain ⟨u, hu, rfl⟩ := hx
      apply Subgroup.subset_closure
      refine ⟨g * u * g⁻¹, by simp [hu], ?_⟩
      simp [conj_pow]
    · simp
    · rw [← conj_mul]
      exact (kernelSquares π).mul_mem ihx ihy
    · rw [← conj_inv]
      exact (kernelSquares π).inv_mem ihx

lemma kernelSquares_invisible (T : TraceData π t) :
    kernelSquares π ≤ invisible π t := by
  apply (Subgroup.closure_le (invisible π t)).mpr
  rintro _ ⟨u, hu, rfl⟩
  exact invisible_square T u hu

theorem square_subgroup_factorization (T : TraceData π t) :
    kernelSquares π ≤ π.ker ∧
      (∀ u, π u = 1 → u ^ 2 ∈ kernelSquares π) ∧
      ∀ u ∈ kernelSquares π, ∀ x, t (x * u) = t x := by
  refine ⟨fun _ h => (kernelSquares_invisible T h).1, ?_, ?_⟩
  · intro u hu
    exact Subgroup.subset_closure ⟨u, hu, rfl⟩
  · exact fun _ h => (kernelSquares_invisible T h).2

lemma kernel_comm (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1)
    {a b : G} (ha : π a = 1) (hb : π b = 1) : a * b = b * a := by
  have hai : a⁻¹ = a := inv_eq_of_mul_eq_one_left (by simpa [pow_two] using e2 a ha)
  have hbi : b⁻¹ = b := inv_eq_of_mul_eq_one_left (by simpa [pow_two] using e2 b hb)
  have habi : (a * b)⁻¹ = a * b :=
    inv_eq_of_mul_eq_one_left (by simpa [pow_two] using e2 (a * b) (by simp [ha, hb]))
  calc
    a * b = (a * b)⁻¹ := habi.symm
    _ = b * a := by simp [hai, hbi]

lemma rotation_lift (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1)
    (hrot : ∃ g, π g = r 1) : ∃ R : G, π R = r 1 ∧ R ^ 3 = 1 := by
  obtain ⟨g, hg⟩ := hrot
  have hg3 : π (g ^ 3) = 1 := by
    rw [map_pow, hg]
    decide
  have hg6 : g ^ 6 = 1 := by simpa [← pow_mul] using e2 (g ^ 3) hg3
  refine ⟨g ^ 4, ?_, ?_⟩
  · rw [map_pow, hg]; decide
  calc
    (g ^ 4) ^ 3 = (g ^ 6) ^ 2 := by group
    _ = 1 := by rw [hg6]; simp

lemma normalizer_lift (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1)
    {R x : G} (hR : π R = r 1) (hR3 : R ^ 3 = 1) (hx : π x = sr 0) :
    ∃ s : G, π s = sr 0 ∧ s * R * s⁻¹ = R⁻¹ := by
  let a := x * R * x⁻¹ * R
  let b := R⁻¹ * a * R
  let c := (R⁻¹) ^ 2 * a * R ^ 2
  have ha : π a = 1 := by norm_num [a, hx, hR]
  have hb : π b = 1 := by simp [b, ha]
  have hb2 : b * b = 1 := by simpa [pow_two] using e2 b hb
  have hbi : b⁻¹ = b := inv_eq_of_mul_eq_one_left hb2
  have hab : a * b = b * a := kernel_comm e2 ha hb
  have hq : (a * R⁻¹) ^ 3 = 1 := by
    have heq : a * R⁻¹ = x * R * x⁻¹ := by dsimp [a]; group
    rw [heq, conj_pow, hR3]
    group
  have hn : a * b * c = 1 := by
    calc
      a * b * c = (a * R⁻¹) ^ 3 * R ^ 3 := by
        dsimp [b, c]
        simp only [pow_succ, pow_zero, mul_one]
        group
      _ = 1 := by rw [hq, hR3]; simp
  refine ⟨b * x, by simp [hb, hx], ?_⟩
  calc
    (b * x) * R * (b * x)⁻¹ = b * (a * R⁻¹) * b := by
      rw [mul_inv_rev, hbi]
      dsimp [a]
      group
    _ = (b * a * c) * R⁻¹ := by dsimp [b, c]; group
    _ = R⁻¹ := by rw [← hab, hn, one_mul]

lemma trace_rotation (T : TraceData π t) {R : G}
    (hR : π R = r 1) (hR3 : R ^ 3 = 1) : t R = 1 := by
  have hs : t R ^ 2 = 1 := T.root R (Or.inl hR)
  have hi : t R⁻¹ = t R := by
    have h := T.product 1 R
    simp only [T.one, zero_mul, one_mul] at h
    exact (CharTwo.add_eq_zero.mp h.symm).symm
  have hR2 : R ^ 2 = R⁻¹ := by
    apply mul_right_cancel (b := R)
    simpa [pow_succ] using hR3
  have hp := T.product R R
  rw [← pow_two (a := R), hR2, hi, mul_inv_cancel, T.one, add_zero,
    ← pow_two, hs] at hp
  exact hp.symm

lemma trace_two_cosets (T : TraceData π t) {R a : G}
    (hR : π R = r 1) (hR3 : R ^ 3 = 1) (ha : π a = 1) :
    t (a * R ^ 2) = t (a * R) := by
  have h := T.product a R
  rw [T.split a ha, zero_mul] at h
  have hR2 : R ^ 2 = R⁻¹ := by
    apply mul_right_cancel (b := R)
    simpa [pow_succ] using hR3
  rw [hR2]
  exact (CharTwo.add_eq_zero.mp h.symm).symm

def beta (t : G → A) (R a : G) : A := t (a * R)

lemma beta_one (T : TraceData π t) {R : G}
    (hR : π R = r 1) (hR3 : R ^ 3 = 1) : beta t R 1 = 1 := by
  simpa [beta] using trace_rotation T hR hR3

lemma beta_mul (T : TraceData π t) (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1)
    {R a b : G} (hR : π R = r 1) (hR3 : R ^ 3 = 1)
    (ha : π a = 1) (hb : π b = 1) :
    beta t R (a * b) = beta t R a * beta t R b := by
  have hp := T.product (a * R) (b * R)
  have hsplit : π ((a * R) * (b * R)⁻¹) = 1 := by simp [ha, hb]
  rw [T.split _ hsplit, add_zero] at hp
  let c := a * R * b * R⁻¹
  have hc : π c = 1 := by simp [c, ha, hb]
  have heq : a * R * (b * R) = c * R ^ 2 := by dsimp [c]; group
  rw [heq, trace_two_cosets T hR hR3 hc] at hp
  have heq2 : t (c * R) = t (a * b * R) := by
    calc
      t (c * R) = t ((a * R) * b) := by congr 1; dsimp [c]; group
      _ = t (b * (a * R)) := T.cyclic _ _
      _ = t (a * b * R) := by rw [← mul_assoc, kernel_comm e2 hb ha]
  simpa [beta, heq2] using hp.symm

lemma beta_square (T : TraceData π t) {R a : G} (hR : π R = r 1)
    (ha : π a = 1) : beta t R a ^ 2 = 1 := by
  apply T.root
  exact Or.inl (by simp [ha, hR])

lemma beta_conj (T : TraceData π t) {R a c : G}
    (hR : π R = r 1) (hR3 : R ^ 3 = 1) (ha : π a = 1)
    (hc : c⁻¹ * R * c = R ∨ c⁻¹ * R * c = R⁻¹) :
    beta t R (c * a * c⁻¹) = beta t R a := by
  unfold beta
  have heq : t (c * a * c⁻¹ * R) = t (a * (c⁻¹ * R * c)) := by
    calc
      t (c * a * c⁻¹ * R) = t (c * (a * c⁻¹ * R)) := by congr 1; group
      _ = t ((a * c⁻¹ * R) * c) := T.cyclic _ _
      _ = t (a * (c⁻¹ * R * c)) := by congr 1; group
  rw [heq]
  rcases hc with hc | hc
  · rw [hc]
  · rw [hc]
    have hR2 : R ^ 2 = R⁻¹ := by
      apply mul_right_cancel (b := R)
      simpa [pow_succ] using hR3
    rw [← hR2, trace_two_cosets T hR hR3 ha]

lemma beta_simple_square (T : TraceData π t) {R s : G}
    (hR : π R = r 1) (hR3 : R ^ 3 = 1) (hs : π s = sr 0)
    (hn : s * R * s⁻¹ = R⁻¹) : beta t R (s ^ 2) = 1 := by
  have hz := T.simple s (s * R) ⟨0, hs⟩ ⟨1, by simp [hs, hR]⟩
  have hp := T.product s (s * R)
  have hi : s * (s * R)⁻¹ = R := by
    calc
      s * (s * R)⁻¹ = (s * R * s⁻¹)⁻¹ := by group
      _ = R := by rw [hn, inv_inv]
  have hr : t R = 1 := trace_rotation T hR hR3
  rw [hz, hi, hr] at hp
  unfold beta
  have heq : s * (s * R) = s ^ 2 * R := by simp [pow_two, mul_assoc]
  rw [heq] at hp
  exact CharTwo.add_eq_zero.mp hp.symm

def rot (R : G) (i : ZMod 3) : G :=
  if i.val = 0 then 1 else if i.val = 1 then R else R⁻¹

@[simp] lemma rot_zero (R : G) : rot R 0 = 1 := rfl
@[simp] lemma rot_one (R : G) : rot R 1 = R := rfl
@[simp] lemma rot_two (R : G) : rot R 2 = R⁻¹ := rfl

lemma rot_add {R : G} (hR3 : R ^ 3 = 1) (i j : ZMod 3) :
    rot R (i + j) = rot R i * rot R j := by
  have hrr : R * R = R⁻¹ := by
    apply mul_right_cancel (b := R)
    simpa [pow_succ] using hR3
  have hii : R⁻¹ * R⁻¹ = R := by
    calc
      R⁻¹ * R⁻¹ = (R * R)⁻¹ := by group
      _ = R := by rw [hrr, inv_inv]
  fin_cases i <;> fin_cases j
  · change (1 : G) = 1 * 1; simp
  · change R = 1 * R; simp
  · change R⁻¹ = 1 * R⁻¹; simp
  · change R = R * 1; simp
  · change R⁻¹ = R * R; exact hrr.symm
  · change (1 : G) = R * R⁻¹; simp
  · change R⁻¹ = R⁻¹ * 1; simp
  · change (1 : G) = R⁻¹ * R; simp
  · change R = R⁻¹ * R⁻¹; exact hii.symm

lemma rot_map {R : G} (hR : π R = r 1) (i : ZMod 3) :
    π (rot R i) = r i := by
  fin_cases i <;> norm_num [rot, ZMod.val, hR] <;> decide

lemma rot_swap {R s : G} (hn : s * R * s⁻¹ = R⁻¹) (i : ZMod 3) :
    rot R i * s = s * rot R (-i) := by
  have h1 : R * s = s * R⁻¹ := by
    calc
      R * s = (s * R * s⁻¹)⁻¹ * s := by rw [hn, inv_inv]
      _ = s * R⁻¹ := by group
  have h2 : R⁻¹ * s = s * R := by
    calc
      R⁻¹ * s = (s * R * s⁻¹) * s := by rw [hn]
      _ = s * R := by group
  fin_cases i
  · change 1 * s = s * 1; simp
  · change R * s = s * R⁻¹; exact h1
  · change R⁻¹ * s = s * R; exact h2

def liftRep (R s : G) : D3 → G
  | r i => rot R i
  | sr i => s * rot R i

@[simp] lemma section_one (R s : G) : liftRep R s 1 = 1 := rfl

lemma section_map {R s : G} (hR : π R = r 1) (hs : π s = sr 0)
    (q : D3) : π (liftRep R s q) = q := by
  cases q with
  | r i => exact rot_map hR i
  | sr i => simp [liftRep, rot_map hR, hs]

lemma section_product {R s : G} (hR3 : R ^ 3 = 1)
    (hn : s * R * s⁻¹ = R⁻¹) (q v : D3) :
    liftRep R s q * liftRep R s v =
      (if IsSimple q ∧ IsSimple v then s ^ 2 else 1) * liftRep R s (q * v) := by
  cases q with
  | r i =>
    cases v with
    | r j => simp [liftRep, IsSimple, rot_add hR3]
    | sr j =>
      simp only [liftRep, r_mul_sr]
      have h := rot_swap hn i
      simp only [IsSimple, reduceCtorEq, exists_false, false_and, if_false, one_mul]
      calc
        rot R i * (s * rot R j) = s * (rot R (-i) * rot R j) := by
          rw [← mul_assoc, h, mul_assoc]
        _ = s * rot R (j - i) := by rw [← rot_add hR3]; congr 2; ring
  | sr i =>
    cases v with
    | r j => simp [liftRep, IsSimple, rot_add hR3, mul_assoc]
    | sr j =>
      simp only [liftRep, sr_mul_sr]
      simp only [IsSimple, sr.injEq, exists_eq', and_self, if_true]
      calc
        (s * rot R i) * (s * rot R j) =
            s ^ 2 * (rot R (-i) * rot R j) := by
          rw [mul_assoc, ← mul_assoc (rot R i), rot_swap hn i]
          simp [pow_two, mul_assoc]
        _ = s ^ 2 * rot R (j - i) := by rw [← rot_add hR3]; congr 2; ring

lemma section_conj {R s : G} (hn : s * R * s⁻¹ = R⁻¹) (q : D3) :
    (liftRep R s q)⁻¹ * R * liftRep R s q = R ∨
      (liftRep R s q)⁻¹ * R * liftRep R s q = R⁻¹ := by
  have hsi : s⁻¹ * R * s = R⁻¹ := by
    calc
      s⁻¹ * R * s = (s⁻¹ * R⁻¹ * s)⁻¹ := by group
      _ = (s⁻¹ * (s * R * s⁻¹) * s)⁻¹ := by rw [hn]
      _ = R⁻¹ := by group
  cases q with
  | r i =>
    left
    fin_cases i <;> simp [liftRep, rot, ZMod.val] <;> group
  | sr i =>
    right
    change (s * rot R i)⁻¹ * R * (s * rot R i) = R⁻¹
    calc
      (s * rot R i)⁻¹ * R * (s * rot R i) =
          (rot R i)⁻¹ * (s⁻¹ * R * s) * rot R i := by group
      _ = R⁻¹ := by
        rw [hsi]
        fin_cases i <;> simp [rot, ZMod.val] <;> group

lemma assemble_character (T : TraceData π t)
    (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1) {R : G}
    (hR : π R = r 1) (hR3 : R ^ 3 = 1) (σ : D3 → G)
    (hσ1 : σ 1 = 1) (hσ : ∀ g, π (σ (π g)) = π g)
    (hσroot : σ (r 1) = R ∧ σ (r 2) = R⁻¹)
    (hconj : ∀ g a, π a = 1 →
      beta t R (σ (π g) * a * (σ (π g))⁻¹) = beta t R a)
    (hcoc : ∀ g h,
      beta t R (σ (π g) * σ (π h) * (σ (π (g * h)))⁻¹) = 1) :
    ∃ f : G →* A, (∀ g, f g ^ 2 = 1) ∧
      ∀ g, IsRoot (π g) → f g = t g := by
  let a := fun g => g * (σ (π g))⁻¹
  have ha : ∀ g, π (a g) = 1 := by intro g; simp [a, hσ]
  let f : G →* A := {
    toFun := fun g => beta t R (a g)
    map_one' := by
      change beta t R (1 * (σ (π 1))⁻¹) = 1
      simpa [hσ1] using beta_one T hR hR3
    map_mul' := by
      intro g h
      let c := σ (π g) * a h * (σ (π g))⁻¹
      let d := σ (π g) * σ (π h) * (σ (π (g * h)))⁻¹
      have hc : π c = 1 := by simp [c, ha]
      have hd : π d = 1 := by
        have hgh := hσ (g * h)
        simp only [map_mul] at hgh
        simp [d, hσ, hgh]
      have heq : a (g * h) = (a g * c) * d := by dsimp [a, c, d]; group
      change beta t R (a (g * h)) = beta t R (a g) * beta t R (a h)
      rw [heq, beta_mul T e2 hR hR3 (by simp [ha, hc]) hd,
        beta_mul T e2 hR hR3 (ha g) hc]
      rw [show beta t R c = beta t R (a h) from hconj g (a h) (ha h)]
      rw [show beta t R d = 1 from hcoc g h, mul_one]
  }
  refine ⟨f, fun g => beta_square T hR (ha g), ?_⟩
  intro g hg
  change t (a g * R) = t g
  rcases hg with hg | hg
  · simp [a, hg, hσroot.1]
  · have heq : a g * R ^ 2 = g := by
      dsimp [a]
      rw [hg, hσroot.2, inv_inv]
      calc
        g * R * R ^ 2 = g * R ^ 3 := by group
        _ = g := by rw [hR3, mul_one]
    rw [← trace_two_cosets T hR hR3 (ha g), heq]

lemma elementary_character (T : TraceData π t)
    (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1) (hrot : ∃ g, π g = r 1) :
    ∃ f : G →* A, (∀ g, f g ^ 2 = 1) ∧
      ∀ g, IsRoot (π g) → f g = t g := by
  classical
  obtain ⟨R, hR, hR3⟩ := rotation_lift e2 hrot
  by_cases hx : ∃ x, π x = sr 0
  · obtain ⟨x, hx⟩ := hx
    obtain ⟨s, hs, hn⟩ := normalizer_lift e2 hR hR3 hx
    apply assemble_character T e2 hR hR3 (liftRep R s) rfl
      (fun g => section_map hR hs (π g)) ⟨rfl, rfl⟩
    · intro g a ha
      exact beta_conj T hR hR3 ha (section_conj hn (π g))
    · intro g h
      rw [map_mul, section_product hR3 hn]
      by_cases hj : IsSimple (π g) ∧ IsSimple (π h)
      · simp only [hj, if_true, mul_assoc, mul_inv_cancel, mul_one]
        exact beta_simple_square T hR hR3 hs hn
      · simp only [hj, if_false, one_mul, mul_inv_cancel]
        exact beta_one T hR hR3
  · have hrotations : ∀ g, ∃ i, π g = r i := by
      intro g
      cases hg : π g with
      | r i => exact ⟨i, rfl⟩
      | sr i =>
        exfalso
        apply hx
        refine ⟨g * rot R (-i), ?_⟩
        simp [hg, rot_map hR]
    refine assemble_character T e2 hR hR3 (liftRep R 1) rfl ?_ ⟨rfl, rfl⟩ ?_ ?_
    · intro g
      obtain ⟨i, hi⟩ := hrotations g
      simpa [hi, liftRep] using rot_map hR i
    · intro g a ha
      obtain ⟨i, hi⟩ := hrotations g
      apply beta_conj T hR hR3 ha
      left
      rw [hi]
      fin_cases i <;> simp [liftRep, rot, ZMod.val]
    · intro g h
      obtain ⟨i, hi⟩ := hrotations g
      obtain ⟨j, hj⟩ := hrotations h
      simp only [map_mul, hi, hj, r_mul_r, liftRep]
      rw [← rot_add hR3, mul_inv_cancel]
      exact beta_one T hR hR3

theorem elementary_factorization (T : TraceData π t) :
    ∃ N : Subgroup G, N.Normal ∧ N ≤ π.ker ∧
      (∀ u, π u = 1 → u ^ 2 ∈ N) ∧
      ∀ u ∈ N, ∀ x, t (x * u) = t x := by
  refine ⟨invisible π t, invisible_normal T, ?_, invisible_square T, ?_⟩
  · exact fun _ h => h.1
  · exact fun _ h => h.2

theorem root_character (T : TraceData π t) (hrot : ∃ g, π g = r 1) :
    ∃ α : G →* Aˣ, (∀ g, α g ^ 2 = 1) ∧
      ∀ g, IsRoot (π g) → (α g : A) = t g := by
  let N := invisible π t
  letI : N.Normal := invisible_normal T
  let p : G ⧸ N →* D3 := QuotientGroup.lift N π (fun _ h => h.1)
  let v : G ⧸ N → A := Quotient.lift t (by
    intro a b hab
    have hmem : a⁻¹ * b ∈ N := QuotientGroup.leftRel_apply.mp hab
    have hh := hmem.2 a
    simpa using hh.symm)
  have hv : ∀ g, v (QuotientGroup.mk' N g) = t g := fun _ => rfl
  have hp : ∀ g, p (QuotientGroup.mk' N g) = π g := fun _ => rfl
  have Tv : TraceData p v := {
    one := T.one
    cyclic := by
      intro a b
      induction a using QuotientGroup.induction_on with | H a =>
      induction b using QuotientGroup.induction_on with | H b =>
      exact T.cyclic a b
    product := by
      intro a b
      induction a using QuotientGroup.induction_on with | H a =>
      induction b using QuotientGroup.induction_on with | H b =>
      exact T.product a b
    split := by
      intro a
      induction a using QuotientGroup.induction_on with | H a =>
      exact T.split a
    root := by
      intro a
      induction a using QuotientGroup.induction_on with | H a =>
      exact T.root a
    simple := by
      intro a b
      induction a using QuotientGroup.induction_on with | H a =>
      induction b using QuotientGroup.induction_on with | H b =>
      exact T.simple a b
  }
  have e2 : ∀ a : G ⧸ N, p a = 1 → a ^ 2 = 1 := by
    intro a
    induction a using QuotientGroup.induction_on with | H a =>
    intro ha
    change (QuotientGroup.mk' N (a ^ 2)) = 1
    apply (QuotientGroup.eq_one_iff _).mpr
    exact invisible_square T a ha
  have hrot' : ∃ g, p g = r 1 := by
    obtain ⟨g, hg⟩ := hrot
    exact ⟨QuotientGroup.mk' N g, hg⟩
  obtain ⟨f, hf, hft⟩ := elementary_character Tv e2 hrot'
  let f' := f.comp (QuotientGroup.mk' N)
  have hf' : ∀ g, f' g ^ 2 = 1 := fun g => hf (QuotientGroup.mk' N g)
  let α : G →* Aˣ := {
    toFun := fun g => ⟨f' g, f' g, by simpa [pow_two] using hf' g,
      by simpa [pow_two] using hf' g⟩
    map_one' := by apply Units.ext; exact f'.map_one
    map_mul' := by intro a b; apply Units.ext; exact f'.map_mul a b
  }
  refine ⟨α, ?_, ?_⟩
  · intro g
    apply Units.ext
    exact hf' g
  · intro g hg
    exact hft (QuotientGroup.mk' N g) hg

theorem pullback_unramified {K B : Type*} [Group K] [Monoid B]
    (ρ : K →* G) (α : G →* B) (u : K) (hu : ρ u = 1) :
    (α.comp ρ) u = 1 := by
  simp [hu]

theorem character_quotient_exponent_two (α : G →* Aˣ)
    (hα : ∀ g, α g ^ 2 = 1) (q : G ⧸ α.ker) : q ^ 2 = 1 := by
  induction q using QuotientGroup.induction_on with | H g =>
  change (QuotientGroup.mk' α.ker (g ^ 2)) = 1
  apply (QuotientGroup.eq_one_iff _).mpr
  change α (g ^ 2) = 1
  rw [map_pow, hα g]

lemma cyclic_of_class (hc : ∀ c x, t (c * x * c⁻¹) = t x) (x y : G) :
    t (x * y) = t (y * x) := by
  simpa [mul_assoc] using hc x (y * x)

theorem root_character_of_class
    (hc : ∀ c x, t (c * x * c⁻¹) = t x)
    (h1 : t 1 = 0)
    (hm : ∀ x y, t x * t y = t (x * y) + t (x * y⁻¹))
    (hz : ∀ x, π x = 1 → t x = 0)
    (hr : ∀ x, IsRoot (π x) → t x ^ 2 = 1)
    (hs : ∀ x y, IsSimple (π x) → IsSimple (π y) → t x * t y = 0)
    (hrot : ∃ g, π g = r 1) :
    ∃ α : G →* Aˣ, (∀ g, α g ^ 2 = 1) ∧
      ∀ g, IsRoot (π g) → (α g : A) = t g :=
  root_character ⟨h1, cyclic_of_class hc, hm, hz, hr, hs⟩ hrot

end RootCharacter

#print axioms RootCharacter.root_character_of_class
#print axioms RootCharacter.square_subgroup_factorization
#print axioms RootCharacter.normalizer_lift
#print axioms RootCharacter.character_quotient_exponent_two
