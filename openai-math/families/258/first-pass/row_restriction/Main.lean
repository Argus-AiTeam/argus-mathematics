import Mathlib

namespace RowRestriction

section Pivots

variable {D : Type*} [DivisionRing D]

theorem right_pivot_cancel {c p : D} (hp : p ≠ 0) (h : c * p = 0) :
    c = 0 :=
  (mul_eq_zero.mp h).resolve_right hp

theorem triangular_injective {B : Type*} (q : B → D) (p : D) (hp : p ≠ 0) :
    Function.Injective
      (fun v : (B → D) × D => ((fun j => v.1 j + v.2 * q j), v.2 * p)) := by
  intro v w h
  have hpivot : v.2 * p = w.2 * p := congrArg Prod.snd h
  have hdiff : (v.2 - w.2) * p = 0 := by
    rw [sub_mul, hpivot, sub_self]
  have hc : v.2 = w.2 := sub_eq_zero.mp (right_pivot_cancel hp hdiff)
  apply Prod.ext
  · funext j
    have hj := congrFun (congrArg Prod.fst h) j
    change v.1 j + v.2 * q j = w.1 j + w.2 * q j at hj
    rw [hc] at hj
    exact add_right_cancel hj
  · exact hc

theorem private_column
    {A B W : Type*} [AddGroup A] [AddGroup B] [AddGroup W]
    (source : A →+ W) (relation : B →+ W)
    (probe : W →+ D) (coefficient : B →+ D)
    (hs : Function.Injective source) (hc : Function.Injective coefficient)
    (p : D) (hp : p ≠ 0)
    (hsource : ∀ a, probe (source a) = 0)
    (hrelation : ∀ b, probe (relation b) = coefficient b * p)
    {a : A} {b : B} (h : source a = relation b) :
    a = 0 ∧ b = 0 := by
  have hzero : coefficient b * p = 0 := by
    rw [← hrelation b, ← h, hsource a]
  have hb : b = 0 := hc (by simpa using right_pivot_cancel hp hzero)
  have ha : a = 0 := hs (by simpa [hb] using h)
  exact ⟨ha, hb⟩

def xToY (x s : D) (v : D × D) : D × D :=
  (-v.1 * x, v.1 * s + v.2)

def yToX (x s : D) (v : D × D) : D × D :=
  (-v.1 * x⁻¹, v.1 * x⁻¹ * s + v.2)

theorem root_frame_inverse (x s : D) (hx : x ≠ 0) (v : D × D) :
    yToX x s (xToY x s v) = v ∧ xToY x s (yToX x s v) = v := by
  constructor <;> apply Prod.ext <;>
    simp [xToY, yToX, mul_assoc, hx]

end Pivots

section Line

variable {E V : ℤ → Type*}
variable [∀ i, AddCommGroup (E i)] [∀ i, AddCommGroup (V i)]

theorem line_single_support
    (left : ∀ i, E i →+ V i) (right : ∀ i, E (i - 1) →+ V i)
    (hl : ∀ i, Function.Injective (left i))
    (hr : ∀ i, Function.Injective (right i))
    (b : ∀ i, E i) (s : Finset ℤ)
    (hs : ∀ i, b i ≠ 0 ↔ i ∈ s) (root : ℤ)
    (hboundary : ∀ i, i ≠ root → left i (b i) = right i (b (i - 1))) :
    ∀ i, b i = 0 := by
  classical
  by_contra h
  obtain ⟨j, hj⟩ := not_forall.mp h
  have hne : s.Nonempty := ⟨j, (hs j).mp hj⟩
  let lo := s.min' hne
  let hi := s.max' hne
  have hlo : lo ∈ s := Finset.min'_mem s hne
  have hhi : hi ∈ s := Finset.max'_mem s hne
  have hbelow : b (lo - 1) = 0 := by
    by_contra hn
    have hm : lo - 1 ∈ s := (hs (lo - 1)).mp hn
    have hh : lo ≤ lo - 1 := Finset.min'_le s (lo - 1) hm
    omega
  have habove : b (hi + 1) = 0 := by
    by_contra hn
    have hm : hi + 1 ∈ s := (hs (hi + 1)).mp hn
    have hh : hi + 1 ≤ hi := Finset.le_max' s (hi + 1) hm
    omega
  have hroot : lo = root := by
    by_contra hn
    have he := hboundary lo hn
    have hz : b lo = 0 := hl lo (by simpa [hbelow] using he)
    exact ((hs lo).mpr hlo) hz
  have horder : lo ≤ hi := Finset.min'_le s hi hhi
  have hfar : hi + 1 ≠ root := by omega
  have he := hboundary (hi + 1) hfar
  have hz : b ((hi + 1) - 1) = 0 :=
    hr (hi + 1) (by simpa [habove] using he.symm)
  have hm : (hi + 1) - 1 ∈ s := by
    have hpred : (hi + 1) - 1 = hi := by omega
    rw [hpred]
    exact hhi
  exact ((hs ((hi + 1) - 1)).mpr hm) hz

theorem line_vertex_relation
    (left : ∀ i, E i →+ V i) (right : ∀ i, E (i - 1) →+ V i)
    (hl : ∀ i, Function.Injective (left i))
    (hr : ∀ i, Function.Injective (right i))
    (b : ∀ i, E i) (s : Finset ℤ)
    (hs : ∀ i, b i ≠ 0 ↔ i ∈ s) (root : ℤ) (v : V root)
    (hboundary : ∀ i, i ≠ root → left i (b i) = right i (b (i - 1)))
    (hatroot : left root (b root) - right root (b (root - 1)) = v) :
    v = 0 := by
  have hz := line_single_support left right hl hr b s hs root hboundary
  simpa [hz root, hz (root - 1)] using hatroot.symm

end Line

end RowRestriction
