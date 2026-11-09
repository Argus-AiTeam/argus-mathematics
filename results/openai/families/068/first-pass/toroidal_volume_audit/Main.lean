import Mathlib

namespace ToroidalVolumeAudit

open Matrix

theorem cleared_logarithmic_determinant
    {I R : Type*} [Fintype I] [DecidableEq I] [CommRing R]
    (A : Matrix I I R) (k : I) (m : I → R) (t : R) :
    (A.updateRow k (m + t • A k)).det =
      (A.updateRow k m).det + t * A.det := by
  rw [Matrix.det_updateRow_add, Matrix.det_updateRow_smul,
    Matrix.updateRow_eq_self]

theorem at_most_simple_logarithmic_pole
    {I K : Type*} [Fintype I] [DecidableEq I] [Field K]
    (A : Matrix I I K) (k : I) (m : I → K) (t : K) (ht : t ≠ 0) :
    t * (A.updateRow k (A k + t⁻¹ • m)).det =
      t * A.det + (A.updateRow k m).det := by
  rw [Matrix.det_updateRow_add, Matrix.det_updateRow_smul,
    Matrix.updateRow_eq_self]
  calc
    t * (A.det + t⁻¹ * (A.updateRow k m).det) =
        t * A.det + (t * t⁻¹) * (A.updateRow k m).det := by ring
    _ = t * A.det + (A.updateRow k m).det := by
      rw [mul_inv_cancel₀ ht, one_mul]

def correction (lam : ℚ) : ℚ := max 0 (lam - 1)

def room (lam : ℚ) : ℚ := min lam 1

theorem correction_nonnegative (lam : ℚ) : 0 ≤ correction lam :=
  le_max_left _ _

theorem room_identity (lam : ℚ) : lam - correction lam = room lam := by
  unfold correction room
  by_cases h : lam ≤ 1
  · rw [max_eq_left (by linarith), min_eq_left h]
    ring
  · rw [max_eq_right (by linarith), min_eq_right (by linarith)]
    ring

theorem correction_bounded_by_jacobian
    (a e lam : ℚ) (ha : 0 ≤ a) (he : 1 ≤ e)
    (hmin : e * lam ≤ a + 1) :
    e * correction lam ≤ a := by
  unfold correction
  by_cases h : lam ≤ 1
  · rw [max_eq_left (by linarith), mul_zero]
    exact ha
  · rw [max_eq_right (by linarith)]
    nlinarith

theorem nonexceptional_branch_forces_zero
    (e lam : ℚ) (he : 1 ≤ e) (hmin : e * lam ≤ 1) :
    correction lam = 0 := by
  have hlam : lam ≤ 1 := by
    by_contra h
    have hpos : 0 < e := by linarith
    have hmul := mul_lt_mul_of_pos_left (show 1 < lam by linarith) hpos
    nlinarith
  exact max_eq_left (by linarith)

theorem minimum_positive
    {I : Type*} (a e : I → ℚ) (lam : ℚ)
    (ha : ∀ i, 0 ≤ a i) (he : ∀ i, 0 < e i)
    (hatt : ∃ i, e i * lam = a i + 1) :
    0 < lam := by
  obtain ⟨i, hi⟩ := hatt
  have hnum : 0 < a i + 1 := by linarith [ha i]
  have hprod : 0 < e i * lam := by linarith
  exact (mul_pos_iff_of_pos_left (he i)).mp hprod

theorem positive_room (lam : ℚ) (hlam : 0 < lam) : 0 < room lam :=
  lt_min hlam (by norm_num)

theorem sharp_prime_threshold
    {I : Type*} (a e : I → ℚ) (lam b : ℚ)
    (he : ∀ i, 0 < e i)
    (hmin : ∀ i, e i * lam ≤ a i + 1)
    (hatt : ∃ i, e i * lam = a i + 1) :
    (∀ i, -1 < a i - e i * (correction lam + b)) ↔ b < room lam := by
  constructor
  · intro h
    obtain ⟨i, hi⟩ := hatt
    have hmul : e i * (correction lam + b) < e i * lam := by
      linarith [h i]
    have hc : correction lam + b < lam :=
      (mul_lt_mul_iff_right₀ (he i)).mp hmul
    rw [← room_identity]
    linarith
  · intro hb i
    rw [← room_identity] at hb
    have hc : correction lam + b < lam := by linarith
    have hmul := mul_lt_mul_of_pos_left hc (he i)
    linarith [hmin i]

theorem full_support_discrepancy
    {V : Type*} (lc cartier : V → ℚ)
    (hlc : ∀ v, 0 ≤ lc v)
    (hcartier : ∀ v, 0 ≤ cartier v)
    (hfull : ∀ v, lc v = 0 → 0 < cartier v) :
    ∀ v, 0 < lc v + cartier v := by
  intro v
  by_cases h : lc v = 0
  · linarith [hfull v h]
  · have hpos : 0 < lc v := lt_of_le_of_ne (hlc v) (Ne.symm h)
    linarith [hcartier v]

theorem klt_type_monotonicity
    {V : Type*} (klt effective : V → ℚ)
    (hklt : ∀ v, 0 < klt v)
    (heffective : ∀ v, 0 ≤ effective v) :
    ∀ v, 0 < klt v + effective v := by
  intro v
  exact add_pos_of_pos_of_nonneg (hklt v) (heffective v)

theorem blowup_endpoint (codim s : ℚ) :
    (-1 < (codim - 1) - (codim - 1 + s)) ↔ s < 1 := by
  constructor <;> intro h <;> linarith

end ToroidalVolumeAudit
