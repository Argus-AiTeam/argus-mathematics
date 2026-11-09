import Mathlib

namespace HostRequests

def word {α : Type*} (A : ℤ → α) (a : ℤ) : ℕ → List α
  | 0 => []
  | n + 1 => A a :: word A (a + 1) n

@[simp] theorem word_length {α : Type*} (A : ℤ → α) (a : ℤ) (n : ℕ) :
    (word A a n).length = n := by
  induction n generalizing a with
  | zero => rfl
  | succ n ih => simp [word, ih]

theorem word_add {α : Type*} (A : ℤ → α) (a : ℤ) (n m : ℕ) :
    word A a (n + m) = word A a n ++ word A (a + n) m := by
  induction n generalizing a with
  | zero => simp [word]
  | succ n ih =>
      simp only [Nat.succ_add, word, List.cons_append]
      rw [ih]
      have hx : a + 1 + (n : ℤ) = a + ((n + 1 : ℕ) : ℤ) := by push_cast; omega
      rw [hx]

def window {α : Type*} (A : ℤ → α) (a b : ℤ) : List α :=
  word A a (b - a).toNat

theorem window_split {α : Type*} (A : ℤ → α) {a c b : ℤ}
    (hac : a ≤ c) (hcb : c ≤ b) :
    window A a b = window A a c ++ window A c b := by
  have hn : (b - a).toNat = (c - a).toNat + (b - c).toNat := by omega
  have ha : a + ((c - a).toNat : ℤ) = c := by omega
  simp only [window, hn, word_add, ha]

theorem transport_word {α : Type*} (A : ℤ → α) (a δ : ℤ) (n : ℕ) :
    word (fun x => A (x - δ)) (a + δ) n = word A a n := by
  induction n generalizing a with
  | zero => rfl
  | succ n ih =>
      simp only [word]
      have h : a + δ + 1 = (a + 1) + δ := by ring
      rw [h, ih]
      simp

theorem periodic_nat {α : Type*} (A : ℤ → α) (p : ℤ)
    (hp : ∀ x, A (x + p) = A x) (n : ℕ) (x : ℤ) :
    A (x + n * p) = A x := by
  induction n with
  | zero => simp
  | succ n ih =>
      have h : x + (↑(n + 1) : ℤ) * p = (x + n * p) + p := by
        push_cast
        ring
      rw [h, hp, ih]

theorem periodic_int {α : Type*} (A : ℤ → α) (p : ℤ)
    (hp : ∀ x, A (x + p) = A x) (k x : ℤ) :
    A (x + k * p) = A x := by
  cases k with
  | ofNat n => exact periodic_nat A p hp n x
  | negSucc n =>
      have h := periodic_nat A p hp (n + 1) (x - ((n : ℤ) + 1) * p)
      simp only [Nat.cast_add, Nat.cast_one] at h
      have hx : x - ((n : ℤ) + 1) * p + ((n : ℤ) + 1) * p = x := by ring
      rw [hx] at h
      have he : (Int.negSucc n : ℤ) = -((n : ℤ) + 1) := by omega
      rw [he]
      have hr : x + -((n : ℤ) + 1) * p = x - ((n : ℤ) + 1) * p := by ring
      rw [hr]
      exact h.symm

theorem word_periodic {α : Type*} (A : ℤ → α) (p : ℤ)
    (hp : ∀ x, A (x + p) = A x) (k a : ℤ) (n : ℕ) :
    word A (a + k * p) n = word A a n := by
  induction n generalizing a with
  | zero => rfl
  | succ n ih =>
      simp only [word, periodic_int A p hp]
      have h : a + k * p + 1 = (a + 1) + k * p := by ring
      rw [h, ih]

theorem window_periodic {α : Type*} (A : ℤ → α) (p : ℤ)
    (hp : ∀ x, A (x + p) = A x) (k a b : ℤ) :
    window A (a + k * p) (b + k * p) = window A a b := by
  have h : b + k * p - (a + k * p) = b - a := by ring
  simp only [window, h, word_periodic A p hp]

theorem layer_shift_nat (z : ℤ → ℤ) (q : ℤ)
    (hz : ∀ x, z (x + q) = z x + q) (n : ℕ) (x : ℤ) :
    z (x + n * q) = z x + n * q := by
  induction n with
  | zero => simp
  | succ n ih =>
      have h : x + (↑(n + 1) : ℤ) * q = (x + n * q) + q := by
        push_cast
        ring
      rw [h, hz, ih]
      push_cast
      ring

theorem layer_shift_int (z : ℤ → ℤ) (q : ℤ)
    (hz : ∀ x, z (x + q) = z x + q) (k x : ℤ) :
    z (x + k * q) = z x + k * q := by
  cases k with
  | ofNat n => exact layer_shift_nat z q hz n x
  | negSucc n =>
      have h := layer_shift_nat z q hz (n + 1) (x - ((n : ℤ) + 1) * q)
      simp only [Nat.cast_add, Nat.cast_one] at h
      have hx : x - ((n : ℤ) + 1) * q + ((n : ℤ) + 1) * q = x := by ring
      rw [hx] at h
      have hn : (Int.negSucc n : ℤ) = -((n : ℤ) + 1) := by omega
      have he : x + (Int.negSucc n : ℤ) * q = x - ((n : ℤ) + 1) * q := by rw [hn]; ring
      rw [he, hn]
      have hr : -((n : ℤ) + 1) * q = -(((n : ℤ) + 1) * q) := by ring
      rw [hr]
      omega

def Actual (z : ℤ → ℤ) (a b : ℤ) : Prop :=
  z (a - 1) ≤ b ∧ b ≤ z a

theorem transport_actual (z : ℤ → ℤ) {a b δ : ℤ} (h : Actual z a b) :
    Actual (fun x => z (x - δ) + δ) (a + δ) (b + δ) := by
  dsimp [Actual] at *
  have hx : a + δ - 1 - δ = a - 1 := by ring
  simp only [hx, add_sub_cancel_right]
  omega

theorem transport_layer (z : ℤ → ℤ) {p δ : ℤ}
    (hm : Monotone z) (hp : ∀ x, z (x + p) = z x + p)
    (hl : ∀ x, x ≤ z (x - 1)) :
    Monotone (fun x => z (x - δ) + δ) ∧
      (∀ x, z (x + p - δ) + δ = z (x - δ) + δ + p) ∧
      (∀ x, x ≤ z (x - 1 - δ) + δ) := by
  refine ⟨?_, ?_, ?_⟩
  · intro x y hxy
    have h := hm (show x - δ ≤ y - δ by omega)
    change z (x - δ) + δ ≤ z (y - δ) + δ
    omega
  · intro x
    have hx : x + p - δ = (x - δ) + p := by ring
    rw [hx, hp]
    ring
  · intro x
    have h := hl (x - δ)
    have hx : x - 1 - δ = (x - δ) - 1 := by ring
    rw [hx]
    omega

theorem transport_periodic {α : Type*} (A : ℤ → α) {p δ : ℤ}
    (hp : ∀ x, A (x + p) = A x) :
    ∀ x, A (x + p - δ) = A (x - δ) := by
  intro x
  have hx : x + p - δ = (x - δ) + p := by ring
  rw [hx, hp]

theorem transport_distinct {α : Type*} (A B : ℤ → α) (δ η : ℤ)
    (hne : ¬ ∃ t : ℤ, ∀ x, A x = B (x + t)) :
    (fun x => A (x - δ)) ≠ (fun x => B (x - η)) := by
  intro heq
  apply hne
  refine ⟨δ - η, ?_⟩
  intro x
  have h := congrFun heq (x + δ)
  have hx : x + δ - η = x + (δ - η) := by ring
  simpa only [add_sub_cancel_right, hx] using h

theorem actual_translate (z : ℤ → ℤ) (q : ℤ)
    (hz : ∀ x, z (x + q) = z x + q) {a b : ℤ}
    (h : Actual z a b) (k : ℤ) : Actual z (a + k * q) (b + k * q) := by
  dsimp [Actual] at *
  have hx : a + k * q - 1 = (a - 1) + k * q := by ring
  rw [hx, layer_shift_int z q hz, layer_shift_int z q hz]
  omega

theorem actual_order (z : ℤ → ℤ) (hz : Monotone z)
    {a b c d : ℤ} (hu : Actual z a b) (hv : Actual z c d) (hac : a < c) :
    b ≤ d := by
  have h := hz (show a ≤ c - 1 by omega)
  dsimp [Actual] at hu hv
  omega

theorem normalize_start {a a₀ q : ℤ} (hq : 0 < q) :
    ∃ k : ℤ, a₀ ≤ a + k * q ∧ a + k * q < a₀ + q := by
  refine ⟨-((a - a₀) / q), ?_⟩
  have hmod := Int.emod_nonneg (a - a₀) (ne_of_gt hq)
  have hlt := Int.emod_lt_of_pos (a - a₀) hq
  have hid := Int.mul_ediv_add_emod (a - a₀) q
  have he : a + -((a - a₀) / q) * q = a₀ + (a - a₀) % q := by
    linear_combination -hid
  rw [he]
  omega

theorem normalize_record (z : ℤ → ℤ) {q a₀ b₀ a b : ℤ}
    (hq : 0 < q) (hm : Monotone z)
    (hz : ∀ x, z (x + q) = z x + q)
    (h₀ : Actual z a₀ b₀) (h : Actual z a b) :
    ∃ k : ℤ, Actual z (a + k * q) (b + k * q) ∧
      a₀ ≤ a + k * q ∧ a + k * q ≤ a₀ + q ∧
      b₀ ≤ b + k * q ∧ b + k * q ≤ b₀ + q := by
  obtain ⟨k, hlo, hhi⟩ := normalize_start (a := a) (a₀ := a₀) hq
  have hk := actual_translate z q hz h k
  have hnext : Actual z (a₀ + q) (b₀ + q) := by
    simpa using actual_translate z q hz h₀ 1
  by_cases hafter : b₀ ≤ b + k * q
  · refine ⟨k, hk, hlo, le_of_lt hhi, hafter, ?_⟩
    exact actual_order z hm hk hnext hhi
  · have heq : a + k * q = a₀ := by
      by_contra hn
      have ho := actual_order z hm h₀ hk (show a₀ < a + k * q by omega)
      omega
    have hshift := actual_translate z q hz h (k + 1)
    have hstart : a + (k + 1) * q = a₀ + q := by
      linear_combination heq
    have hend : b + (k + 1) * q = b + k * q + q := by ring
    refine ⟨k + 1, hshift, ?_, ?_, ?_, ?_⟩
    · omega
    · omega
    · exact actual_order z hm h₀ hshift (by omega)
    · omega

theorem normalized_pair_order (z : ℤ → ℤ) (hm : Monotone z)
    {a b c d : ℤ} (hu : Actual z a b) (hv : Actual z c d)
    (hlex : a < c ∨ (a = c ∧ b ≤ d)) : a ≤ c ∧ b ≤ d := by
  rcases hlex with h | ⟨h, hb⟩
  · exact ⟨le_of_lt h, actual_order z hm hu hv h⟩
  · exact ⟨le_of_eq h, hb⟩

theorem texts_equal_of_agreement {α : Type*} (A B : ℤ → α)
    {a p q : ℤ} (hp : 0 < p) (hq : 0 < q)
    (hA : ∀ x, A (x + p) = A x) (hB : ∀ x, B (x + q) = B x)
    (hag : ∀ x, a ≤ x → x < a + p + q → A x = B x) : A = B := by
  have hBp : ∀ x, B (x + p) = B x := by
    intro x
    obtain ⟨k, hlo, hhi⟩ := normalize_start (a := x) (a₀ := a) hq
    have hkp : x + p + k * q = x + k * q + p := by ring
    calc
      B (x + p) = B (x + k * q + p) := by rw [← hkp, periodic_int B q hB]
      _ = A (x + k * q + p) := (hag _ (by omega) (by omega)).symm
      _ = A (x + k * q) := hA _
      _ = B (x + k * q) := hag _ hlo (by omega)
      _ = B x := periodic_int B q hB k x
  funext x
  obtain ⟨k, hlo, hhi⟩ := normalize_start (a := x) (a₀ := a) hp
  calc
    A x = A (x + k * p) := (periodic_int A p hA k x).symm
    _ = B (x + k * p) := hag _ hlo (by omega)
    _ = B x := periodic_int B p hBp k x

theorem agreement_bound {α : Type*} (A B : ℤ → α)
    {a b p q : ℤ} (hp : 0 < p) (hq : 0 < q)
    (hA : ∀ x, A (x + p) = A x) (hB : ∀ x, B (x + q) = B x)
    (hne : A ≠ B) (hag : ∀ x, a ≤ x → x < b → A x = B x) :
    b - a < p + q := by
  by_contra h
  apply hne
  exact texts_equal_of_agreement A B hp hq hA hB (by
    intro x hlo hhi
    exact hag x hlo (by omega))

theorem raw_separation {a b p e c r f : ℤ}
    (he : a + p < e) (heb : e ≤ b - p)
    (hf : c + r < f) (hov : b - c < p + r) :
    a + p < c + r ∧ e < f := by omega

theorem clipping_order {a p e c r f T B : ℤ}
    (hs : a + p ≤ c + r) (he : e ≤ f) :
    min (a + p) T ≤ min (c + r) T ∧ max e B ≤ max f B :=
  ⟨min_le_min_right T hs, max_le_max_right B he⟩

theorem clipped_contact {a₀ b₀ q p₀ a b p e e₀ : ℤ}
    (hp₀ : 0 < p₀) (hmin : p₀ ≤ p)
    (ha : a₀ ≤ a) (haT : a ≤ a₀ + q)
    (hb : b₀ ≤ b)
    (he : a + p < e) (heb : e ≤ b - p)
    (hhost : b₀ - a₀ < p₀ + q)
    (hprev : b₀ - a < p₀ + p)
    (hnext : b - (a₀ + q) < p + p₀)
    (he₀ : a₀ + p₀ < e₀) :
    let s := min (a + p) (a₀ + q)
    let h := max e b₀
    a ≤ s ∧ s ≤ a + p ∧ s < h ∧ h ≤ b ∧
      e ≤ h ∧ h ≤ e + p ∧
      a₀ ≤ s ∧ b₀ ≤ h ∧ s ≤ a₀ + q ∧
      h < a₀ + q + p₀ ∧ h < e₀ + q := by
  dsimp
  simp only [min_def, max_def]
  split_ifs <;> omega

theorem only_group_short {a b p q e : ℤ}
    (hp : 0 < p) (hhost : b - a < p + q) (he : a + p < e) :
    max 0 (b - (a + q)) < p ∧ b < e + q := by
  simp only [max_def]
  split_ifs <;> omega

theorem attachment_order {a p e s h : ℤ}
    (hs : a ≤ s) (hsp : s ≤ a + p)
    (he : e ≤ h) (hep : h ≤ e + p) :
    s ≤ a + p ∧ h ≤ e + p ∧ a + p ≤ s + p ∧ e + p ≤ h + p := by
  omega

theorem budget_bound {q others short p unused : ℕ} (hshort : short < p) :
    q + others + short ≤ q + others + p + unused := by omega

structure Language (α : Type*) where
  ok : List α → Prop
  empty : ok []
  letter : ∀ c, ok [c]
  take_prefix : ∀ u v, ok (u ++ v) → ok u
  take_suffix : ∀ u v, ok (u ++ v) → ok v

inductive Walk {α : Type*} (L : Language α) : List α → List α → ℕ → Type _
  | nil (u : List α) (hu : L.ok u) : Walk L u u 0
  | up {u v : List α} {n : ℕ} (c : α) (h : L.ok (u ++ [c]))
      (rest : Walk L (u ++ [c]) v n) : Walk L u v (n + 1)
  | down {u v : List α} {n : ℕ} (c : α) (h : L.ok (c :: u))
      (rest : Walk L u v n) : Walk L (c :: u) v n

def Reach {α : Type*} (E : Set (List α × List α)) (u v : List α) : Prop :=
  Relation.EqvGen (fun x y => (x, y) ∈ E) u v

theorem reach_step {α : Type*} {E : Set (List α × List α)} {u v : List α}
    (h : (u, v) ∈ E) : Reach E u v := Relation.EqvGen.rel u v h

theorem reach_symm {α : Type*} {E : Set (List α × List α)} {u v : List α}
    (h : Reach E u v) : Reach E v u := Relation.EqvGen.symm u v h

theorem reach_trans {α : Type*} {E : Set (List α × List α)} {u v w : List α}
    (huv : Reach E u v) (hvw : Reach E v w) : Reach E u w :=
  Relation.EqvGen.trans u v w huv hvw

theorem reach_mono {α : Type*} {E F : Set (List α × List α)}
    {u v : List α} (hEF : E ⊆ F) (h : Reach E u v) : Reach F u v := by
  induction h with
  | rel u v h => exact reach_step (hEF h)
  | refl u => exact .refl u
  | symm u v h ih => exact reach_symm ih
  | trans u v w h₁ h₂ ih₁ ih₂ => exact reach_trans ih₁ ih₂

namespace Walk

def vertices {α : Type*} {L : Language α} {u v : List α} {n : ℕ}
    (walk : Walk L u v n) : Set (List α) :=
  match walk with
  | .nil _ _ => {u}
  | .up _ _ rest => insert u rest.vertices
  | .down _ _ rest => insert u rest.vertices

def edges {α : Type*} {L : Language α} {u v : List α} {n : ℕ}
    (walk : Walk L u v n) : Set (List α × List α) :=
  match walk with
  | .nil _ _ => ∅
  | .up c _ rest => insert (u, u ++ [c]) rest.edges
  | .down _ _ rest => insert (u, u.tail) rest.edges

theorem start_mem {α : Type*} {L : Language α} {u v : List α} {n : ℕ}
    (walk : Walk L u v n) : u ∈ walk.vertices := by
  cases walk <;> simp [vertices]

theorem end_mem {α : Type*} {L : Language α} {u v : List α} {n : ℕ}
    (walk : Walk L u v n) : v ∈ walk.vertices := by
  induction walk with
  | nil u hu => simp [vertices]
  | up c h rest ih => exact Or.inr ih
  | down c h rest ih => exact Or.inr ih

theorem vertices_valid {α : Type*} {L : Language α} {u v : List α} {n : ℕ}
    (walk : Walk L u v n) : ∀ x ∈ walk.vertices, L.ok x := by
  induction walk with
  | nil u hu =>
      intro x hx
      have he : x = u := by simpa [vertices] using hx
      simpa [he] using hu
  | @up u v n c h rest ih =>
      intro x hx
      rcases (show x = u ∨ x ∈ rest.vertices from hx) with he | hx
      · subst x
        exact L.take_prefix u [c] h
      · exact ih x hx
  | @down u v n c h rest ih =>
      intro x hx
      rcases (show x = c :: u ∨ x ∈ rest.vertices from hx) with he | hx
      · simpa [he] using h
      · exact ih x hx

theorem reaches {α : Type*} {L : Language α} {u v : List α} {n : ℕ}
    {E : Set (List α × List α)} (walk : Walk L u v n) :
    ∀ {x}, walk.edges ⊆ E → x ∈ walk.vertices → Reach E u x := by
  induction walk with
  | nil u hu =>
      intro x _ hx
      have he : x = u := by simpa [vertices] using hx
      subst x
      exact .refl u
  | @up u v n c h rest ih =>
      intro x hE hx
      have hr : rest.edges ⊆ E := by
        intro edge he
        exact hE (by simp [edges, he])
      have hs : (u, u ++ [c]) ∈ E := hE (by simp [edges])
      rcases (show x = u ∨ x ∈ rest.vertices from hx) with he | hx
      · subst x
        exact .refl u
      · exact reach_trans (reach_step hs) (ih hr hx)
  | @down u v n c h rest ih =>
      intro x hE hx
      have hr : rest.edges ⊆ E := by
        intro edge he
        exact hE (by simp [edges, he])
      have hs : (c :: u, u) ∈ E := hE (by simp [edges])
      rcases (show x = c :: u ∨ x ∈ rest.vertices from hx) with he | hx
      · subst x
        exact .refl (c :: u)
      · exact reach_trans (reach_step hs) (ih hr hx)

def flux {α : Type*} [DecidableEq α] {L : Language α}
    {u v : List α} {n : ℕ} (walk : Walk L u v n) (x : List α) : ℤ :=
  match walk with
  | .nil _ _ => 0
  | .up c _ rest =>
      (if u = x then 1 else 0) - (if u ++ [c] = x then 1 else 0) + rest.flux x
  | .down _ _ rest =>
      (if u = x then 1 else 0) - (if u.tail = x then 1 else 0) + rest.flux x

theorem flux_endpoints {α : Type*} [DecidableEq α] {L : Language α}
    {u v : List α} {n : ℕ} (walk : Walk L u v n) (x : List α) :
    walk.flux x = (if u = x then 1 else 0) - (if v = x then 1 else 0) := by
  induction walk with
  | nil u hu => simp [flux]
  | up c h rest ih => simp only [flux, ih]; ring
  | down c h rest ih => simp only [flux, List.tail_cons, ih]; ring

theorem closed_balanced {α : Type*} [DecidableEq α] {L : Language α}
    {u : List α} {n : ℕ} (walk : Walk L u u n) (x : List α) :
    walk.flux x = 0 := by
  simpa using flux_endpoints walk x

def reindex {α : Type*} {L : Language α} {u v : List α} {m n : ℕ}
    (walk : Walk L u v m) (h : m = n) : Walk L u v n := h ▸ walk

def retarget {α : Type*} {L : Language α} {u v w : List α} {n : ℕ}
    (walk : Walk L u v n) (h : v = w) : Walk L u w n := h ▸ walk

@[simp] theorem vertices_retarget {α : Type*} {L : Language α}
    {u v w : List α} {n : ℕ} (walk : Walk L u v n) (h : v = w) :
    (walk.retarget h).vertices = walk.vertices := by
  subst w
  rfl

@[simp] theorem vertices_reindex {α : Type*} {L : Language α}
    {u v : List α} {m n : ℕ} (walk : Walk L u v m) (h : m = n) :
    (walk.reindex h).vertices = walk.vertices := by
  subst n
  rfl

noncomputable def trans {α : Type*} {L : Language α} {u v w : List α} {m n : ℕ}
    (first : Walk L u v m) (second : Walk L v w n) : Walk L u w (m + n) := by
  induction first with
  | nil u hu => exact second.reindex (by omega)
  | up c h rest ih =>
      exact (Walk.up c h (ih second)).reindex (by omega)
  | down c h rest ih => exact Walk.down c h (ih second)

theorem vertices_trans {α : Type*} {L : Language α} {u v w : List α} {m n : ℕ}
    (first : Walk L u v m) (second : Walk L v w n) :
    (first.trans second).vertices = first.vertices ∪ second.vertices := by
  induction first with
  | nil u hu =>
      have hs := second.start_mem
      change (second.reindex _).vertices = {u} ∪ second.vertices
      simp [Set.insert_eq_of_mem hs]
  | @up u v m c h rest ih =>
      change ((Walk.up c h (rest.trans second)).reindex _).vertices =
        insert u rest.vertices ∪ second.vertices
      rw [vertices_reindex]
      change insert u (rest.trans second).vertices = _
      rw [ih]
      exact Set.insert_union.symm
  | @down u v m c h rest ih =>
      change insert (c :: u) (rest.trans second).vertices =
        insert (c :: u) rest.vertices ∪ second.vertices
      rw [ih]
      exact Set.insert_union.symm

def delete_prefix {α : Type*} (L : Language α) (u v : List α)
    (h : L.ok (u ++ v)) : Walk L (u ++ v) v 0 := by
  induction u with
  | nil => exact .nil v h
  | cons c u ih =>
      have h' : L.ok (u ++ v) := L.take_suffix [c] (u ++ v) (by simpa using h)
      exact .down c (by simpa using h) (ih h')

def append_suffix {α : Type*} (L : Language α) (u v : List α)
    (h : L.ok (u ++ v)) : Walk L u (u ++ v) v.length := by
  induction v generalizing u with
  | nil => simpa using Walk.nil u (by simpa using h)
  | cons c v ih =>
      have h' : L.ok ((u ++ [c]) ++ v) := by simpa [List.append_assoc] using h
      have hp := L.take_prefix (u ++ [c]) v h'
      simpa [List.append_assoc] using Walk.up c hp (ih (u ++ [c]) h')

def gap {α : Type*} (L : Language α) (cs : List α) :
    Walk L [] [] cs.length := by
  induction cs with
  | nil => exact .nil [] L.empty
  | cons c cs ih => exact .up c (L.letter c) (.down c (L.letter c) ih)

theorem round_trip {α : Type*} (L : Language α) (u : List α) (hu : L.ok u) :
    ∃ walk : Walk L u u u.length, [] ∈ walk.vertices := by
  have hd := delete_prefix L u [] (by simpa using hu)
  have hu' := append_suffix L [] u (by simpa using hu)
  have hd' : Walk L u [] 0 := by simpa using hd
  have hu'' : Walk L [] u u.length := by simpa using hu'
  have hmem : [] ∈ (hd'.trans hu'').vertices := by
    rw [vertices_trans]
    exact Or.inr hu''.start_mem
  exact ⟨(hd'.trans hu'').reindex (by omega), by simpa using hmem⟩

end Walk

theorem rooted_star {α ι : Type*} {L : Language α}
    {h short : List α} {q r : ℕ} {contact : ι → List α} {cost : ι → ℕ}
    (host : Walk L h h q) (root : Walk L short short r)
    (children : ∀ i, Walk L (contact i) (contact i) (cost i))
    (hshort : short ∈ host.vertices) (hempty : [] ∈ root.vertices)
    (hcontact : ∀ i, contact i ∈ host.vertices) :
    let E := host.edges ∪ root.edges ∪ ⋃ i, (children i).edges
    (∀ x ∈ host.vertices, Reach E [] x) ∧
      (∀ x ∈ root.vertices, Reach E [] x) ∧
      (∀ i x, x ∈ (children i).vertices → Reach E [] x) := by
  let E := host.edges ∪ root.edges ∪ ⋃ i, (children i).edges
  have hh : host.edges ⊆ E := by
    intro edge he
    exact Or.inl (Or.inl he)
  have hr : root.edges ⊆ E := by
    intro edge he
    exact Or.inl (Or.inr he)
  have hc : ∀ i, (children i).edges ⊆ E := by
    intro i edge he
    exact Or.inr (Set.mem_iUnion.mpr ⟨i, he⟩)
  have hhs : Reach E h short := host.reaches hh hshort
  have hse : Reach E short [] := root.reaches hr hempty
  have heh : Reach E [] h := reach_symm (reach_trans hhs hse)
  refine ⟨?_, ?_, ?_⟩
  · intro x hx
    exact reach_trans heh (host.reaches hh hx)
  · intro x hx
    exact reach_trans (reach_symm hse) (root.reaches hr hx)
  · intro i x hx
    exact reach_trans (reach_trans heh (host.reaches hh (hcontact i)))
      ((children i).reaches (hc i) hx)

theorem attach_layer {α : Type*} {L : Language α}
    {E : Set (List α × List α)} {anchor : List α} {p : ℕ}
    (base : Walk L anchor anchor p) (hroot : Reach E [] anchor) :
    ∀ x ∈ base.vertices, Reach (E ∪ base.edges) [] x := by
  intro x hx
  have he : Reach (E ∪ base.edges) [] anchor :=
    reach_mono (by intro edge h; exact Or.inl h) hroot
  have hb : base.edges ⊆ E ∪ base.edges := by intro edge h; exact Or.inr h
  exact reach_trans he (base.reaches hb hx)

theorem ordered_windows {α : Type*} (L : Language α) (A : ℤ → α)
    {a b c d : ℤ} (_hab : a ≤ b) (hcd : c ≤ d)
    (hac : a ≤ c) (hbd : b ≤ d)
    (hu : L.ok (window A a b)) (hv : L.ok (window A c d)) :
    ∃ mid : List α, mid.length ≤ (max 0 (b - c)).toNat ∧
      Nonempty (Walk L (window A a b) mid 0) ∧
      Nonempty (Walk L mid (window A c d) (d - b).toNat) := by
  by_cases hcb : c ≤ b
  · have hfirst := window_split A hac hcb
    have hsecond := window_split A hcb hbd
    refine ⟨window A c b, ?_, ?_, ?_⟩
    · simp [window, max_eq_right (show 0 ≤ b - c by omega)]
    · rw [hfirst] at hu ⊢
      exact ⟨Walk.delete_prefix L _ _ hu⟩
    · rw [hsecond] at hv ⊢
      have w := Walk.append_suffix L (window A c b) (window A b d) hv
      simpa [window] using Nonempty.intro w
  · refine ⟨[], by simp, ?_, ?_⟩
    · simpa using Nonempty.intro (Walk.delete_prefix L (window A a b) [] (by simpa using hu))
    · have wg := Walk.gap L (word A b (c - b).toNat)
      have wu := Walk.append_suffix L [] (window A c d) (by simpa using hv)
      have hn : (c - b).toNat + (d - c).toNat = (d - b).toNat := by omega
      simpa [window, hn] using Nonempty.intro (wg.trans wu)

inductive WindowChain {α : Type*} (L : Language α) (A : ℤ → α) :
    (ℤ × ℤ) → (ℤ × ℤ) → Type _
  | one (u : ℤ × ℤ) (hlen : u.1 ≤ u.2) (hvalid : L.ok (window A u.1 u.2)) :
      WindowChain L A u u
  | step {u v w : ℤ × ℤ} (hlen : u.1 ≤ u.2) (hvalid : L.ok (window A u.1 u.2))
      (hordered : u.1 ≤ v.1 ∧ u.2 ≤ v.2) (rest : WindowChain L A v w) :
      WindowChain L A u w

namespace WindowChain

def targets {α : Type*} {L : Language α} {A : ℤ → α}
    {u v : ℤ × ℤ} (chain : WindowChain L A u v) : Set (List α) :=
  match chain with
  | .one _ _ _ => {window A u.1 u.2}
  | .step _ _ _ rest => insert (window A u.1 u.2) rest.targets

theorem first_valid {α : Type*} {L : Language α} {A : ℤ → α}
    {u v : ℤ × ℤ} (chain : WindowChain L A u v) :
    u.1 ≤ u.2 ∧ L.ok (window A u.1 u.2) := by
  cases chain with
  | one u hlen hvalid => exact ⟨hlen, hvalid⟩
  | step hlen hvalid hordered rest => exact ⟨hlen, hvalid⟩

theorem last_valid {α : Type*} {L : Language α} {A : ℤ → α}
    {u v : ℤ × ℤ} (chain : WindowChain L A u v) :
    v.1 ≤ v.2 ∧ L.ok (window A v.1 v.2) := by
  induction chain with
  | one u hlen hvalid => exact ⟨hlen, hvalid⟩
  | step hlen hvalid hordered rest ih => exact ih

theorem endpoints_order {α : Type*} {L : Language α} {A : ℤ → α}
    {u v : ℤ × ℤ} (chain : WindowChain L A u v) :
    u.1 ≤ v.1 ∧ u.2 ≤ v.2 := by
  induction chain with
  | one u hlen hvalid => exact ⟨le_rfl, le_rfl⟩
  | step hlen hvalid hordered rest ih => exact ⟨hordered.1.trans ih.1, hordered.2.trans ih.2⟩

theorem realize {α : Type*} {L : Language α} {A : ℤ → α}
    {u v : ℤ × ℤ} (chain : WindowChain L A u v) :
    ∃ walk : Walk L (window A u.1 u.2) (window A v.1 v.2) (v.2 - u.2).toNat,
      chain.targets ⊆ walk.vertices := by
  induction chain with
  | one u hlen hvalid =>
      refine ⟨(Walk.nil _ hvalid).reindex (by simp), ?_⟩
      simp [targets, Walk.vertices]
  | @step u v w hlen hvalid hordered rest ih =>
      obtain ⟨mid, _, ⟨before⟩, ⟨after⟩⟩ :=
        ordered_windows L A hlen rest.first_valid.1 hordered.1 hordered.2
          hvalid rest.first_valid.2
      obtain ⟨tail, htail⟩ := ih
      have hn : (0 + (v.2 - u.2).toNat) + (w.2 - v.2).toNat =
          (w.2 - u.2).toNat := by
        have he := rest.endpoints_order.2
        omega
      let all := (before.trans after).trans tail
      refine ⟨all.reindex hn, ?_⟩
      intro x hx
      rw [Walk.vertices_reindex]
      change x ∈ ((before.trans after).trans tail).vertices
      rw [Walk.vertices_trans, Walk.vertices_trans]
      rcases (show x = window A u.1 u.2 ∨ x ∈ rest.targets from hx) with he | hx
      · subst x
        exact Or.inl (Or.inl before.start_mem)
      · exact Or.inr (htail hx)

theorem closed {α : Type*} {L : Language α} {A : ℤ → α}
    {a b h : ℤ} (hA : ∀ x, A (x + h) = A x)
    (chain : WindowChain L A (a, b) (a + h, b + h)) :
    ∃ walk : Walk L (window A a b) (window A a b) h.toNat,
      chain.targets ⊆ walk.vertices := by
  have hw : window A (a + h) (b + h) = window A a b := by
    simpa using window_periodic A h hA 1 a b
  have hn : (b + h - b).toNat = h.toNat := by congr 1; ring
  obtain ⟨walk, htargets⟩ := chain.realize
  refine ⟨(walk.retarget hw).reindex hn, ?_⟩
  simpa using htargets

end WindowChain

theorem close_at_short {α : Type*} {L : Language α} {A : ℤ → α}
    {a b c d q : ℤ} (hA : ∀ x, A (x + q) = A x)
    (initialChain : WindowChain L A (a, b) (c, d))
    (hstart : c ≤ a + q) (hend : d ≤ b + q) :
    ∃ walk : Walk L (window A a b) (window A a b) q.toNat,
      initialChain.targets ⊆ walk.vertices ∧
      ∃ short ∈ walk.vertices, short.length ≤ (max 0 (d - (a + q))).toNat := by
  have hw : window A (a + q) (b + q) = window A a b := by
    simpa using window_periodic A q hA 1 a b
  have first := initialChain.first_valid
  obtain ⟨initial, htargets⟩ := initialChain.realize
  have last_valid : L.ok (window A c d) := initial.vertices_valid _ initial.end_mem
  have hlen : c ≤ d := initialChain.last_valid.1
  have final_valid : L.ok (window A (a + q) (b + q)) := by rw [hw]; exact first.2
  obtain ⟨short, hshort, ⟨before⟩, ⟨after⟩⟩ :=
    ordered_windows L A hlen (by omega) hstart hend last_valid final_valid
  rw [hw] at after
  have hn : (d - b).toNat + (0 + (b + q - d).toNat) = q.toNat := by
    have h := initialChain.endpoints_order.2
    omega
  let all := initial.trans (before.trans after)
  refine ⟨all.reindex hn, ?_, short, ?_, hshort⟩
  · intro x hx
    rw [Walk.vertices_reindex]
    change x ∈ (initial.trans (before.trans after)).vertices
    rw [Walk.vertices_trans]
    exact Or.inl (htargets hx)
  · rw [Walk.vertices_reindex]
    change short ∈ (initial.trans (before.trans after)).vertices
    rw [Walk.vertices_trans, Walk.vertices_trans]
    exact Or.inr (Or.inl before.end_mem)

theorem attachment_loop {α : Type*} (L : Language α) (A : ℤ → α)
    {a e p s h : ℤ} (hp : 0 < p) (hA : ∀ x, A (x + p) = A x)
    (hreq : a + p < e) (hs : a ≤ s) (hsp : s ≤ a + p)
    (he : e ≤ h) (hep : h ≤ e + p)
    (hQ : L.ok (window A s h)) (hW : L.ok (window A a e)) :
    ∃ walk : Walk L (window A s h) (window A s h) p.toNat,
      window A a e ∈ walk.vertices := by
  have hmiddle : window A (a + p) (e + p) = window A a e := by
    simpa using window_periodic A p hA 1 a e
  have hlast : window A (s + p) (h + p) = window A s h := by
    simpa using window_periodic A p hA 1 s h
  let chain : WindowChain L A (s, h) (s + p, h + p) :=
    .step (u := (s, h)) (v := (a + p, e + p)) (by omega) hQ ⟨hsp, hep⟩
      (.step (u := (a + p, e + p)) (v := (s + p, h + p))
        (by omega) (by rw [hmiddle]; exact hW) ⟨by omega, by omega⟩
        (.one (s + p, h + p) (by omega) (by rw [hlast]; exact hQ)))
  obtain ⟨walk, htargets⟩ := chain.closed hA
  refine ⟨walk, ?_⟩
  rw [← hmiddle]
  apply htargets
  simp [chain, WindowChain.targets]

end HostRequests
