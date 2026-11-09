import Mathlib

open scoped BigOperators

namespace ChecksumCore

theorem represented_mass_le_one {ι : Type*} (s : Finset ι) (m : ι → ℝ)
    {L : ℝ} (hL : 0 < L) (hMass : ∑ i ∈ s, m i ≤ L) :
    ∑ i ∈ s, m i / L ≤ 1 := by
  rw [← Finset.sum_div]
  exact (div_le_one hL).2 hMass

theorem weighted_first_moment {ι : Type*} (s : Finset ι)
    (m : ι → ℝ) (z : ι → ℂ) {L P : ℝ}
    (hL : 0 < L) (hP : 0 < P) (hm : ∀ i ∈ s, 1 ≤ m i) :
    ∑ i ∈ s, (m i / L) • ((L / (P * m i)) • z i) =
      ∑ i ∈ s, (1 / P) • z i := by
  apply Finset.sum_congr rfl
  intro i hi
  have hmi : m i ≠ 0 := ne_of_gt (lt_of_lt_of_le zero_lt_one (hm i hi))
  have h : m i / L * (L / (P * m i)) = 1 / P := by
    field_simp [ne_of_gt hL, ne_of_gt hP, hmi]
  rw [smul_smul, h]

theorem weighted_second_moment {ι : Type*} (s : Finset ι)
    (m : ι → ℝ) (z : ι → ℂ) {L P : ℝ}
    (hL : 0 < L) (hP : 0 < P) (hm : ∀ i ∈ s, 1 ≤ m i) :
    ∑ i ∈ s, (m i / L) * ‖(L / (P * m i)) • z i‖ ^ 2 =
      (L / P ^ 2) * ∑ i ∈ s, ‖z i‖ ^ 2 / m i := by
  simp only [norm_smul, Real.norm_eq_abs, mul_pow, sq_abs]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  have hmi : m i ≠ 0 := ne_of_gt (lt_of_lt_of_le zero_lt_one (hm i hi))
  field_simp [ne_of_gt hL, ne_of_gt hP, hmi]

theorem weighted_second_moment_le {ι : Type*} (s : Finset ι)
    (m : ι → ℝ) (z : ι → ℂ) {L P : ℝ}
    (hL : 0 < L) (hP : 0 < P) (hm : ∀ i ∈ s, 1 ≤ m i) :
    ∑ i ∈ s, (m i / L) * ‖(L / (P * m i)) • z i‖ ^ 2 ≤
      (L / P ^ 2) * ∑ i ∈ s, ‖z i‖ ^ 2 := by
  rw [weighted_second_moment s m z hL hP hm]
  apply mul_le_mul_of_nonneg_left _ (div_nonneg hL.le (sq_nonneg P))
  apply Finset.sum_le_sum
  intro i hi
  exact div_le_self (sq_nonneg ‖z i‖) (hm i hi)

end ChecksumCore
