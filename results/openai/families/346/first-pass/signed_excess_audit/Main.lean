import Mathlib

open scoped BigOperators

namespace SignedExcessAudit

theorem finite_weighted_flux_fourth
    {ι : Type*} (s : Finset ι) (w v q : ι → ℝ)
    (hw : ∀ i ∈ s, 0 ≤ w i) :
    (∑ i ∈ s, w i * v i * q i) ^ 4 ≤
      (∑ i ∈ s, w i * v i ^ 4) *
        (∑ i ∈ s, w i * q i ^ 2) ^ 2 * (∑ i ∈ s, w i) := by
  have h₁ :
      (∑ i ∈ s, w i * v i * q i) ^ 2 ≤
        (∑ i ∈ s, w i * v i ^ 2) * (∑ i ∈ s, w i * q i ^ 2) := by
    apply Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul s
    · intro i hi
      exact mul_nonneg (hw i hi) (sq_nonneg (v i))
    · intro i hi
      exact mul_nonneg (hw i hi) (sq_nonneg (q i))
    · intro i hi
      exact le_of_eq (by ring)
  have h₂ :
      (∑ i ∈ s, w i * v i ^ 2) ^ 2 ≤
        (∑ i ∈ s, w i * v i ^ 4) * (∑ i ∈ s, w i) := by
    apply Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul s
    · intro i hi
      exact mul_nonneg (hw i hi) (by positivity)
    · exact hw
    · intro i hi
      exact le_of_eq (by ring)
  have hV : 0 ≤ ∑ i ∈ s, w i * v i ^ 2 :=
    Finset.sum_nonneg fun i hi => mul_nonneg (hw i hi) (sq_nonneg (v i))
  have hE : 0 ≤ ∑ i ∈ s, w i * q i ^ 2 :=
    Finset.sum_nonneg fun i hi => mul_nonneg (hw i hi) (sq_nonneg (q i))
  calc
    (∑ i ∈ s, w i * v i * q i) ^ 4 =
        ((∑ i ∈ s, w i * v i * q i) ^ 2) ^ 2 := by ring
    _ ≤ ((∑ i ∈ s, w i * v i ^ 2) *
        (∑ i ∈ s, w i * q i ^ 2)) ^ 2 := by
      gcongr
    _ = (∑ i ∈ s, w i * v i ^ 2) ^ 2 *
        (∑ i ∈ s, w i * q i ^ 2) ^ 2 := by ring
    _ ≤ ((∑ i ∈ s, w i * v i ^ 4) * (∑ i ∈ s, w i)) *
        (∑ i ∈ s, w i * q i ^ 2) ^ 2 :=
      mul_le_mul_of_nonneg_right h₂ (sq_nonneg _)
    _ = (∑ i ∈ s, w i * v i ^ 4) *
        (∑ i ∈ s, w i * q i ^ 2) ^ 2 * (∑ i ∈ s, w i) := by ring

theorem interpolation_exponent (m p : ℝ) :
    2 / p + (1 - 2 / p) * (1 - m / 2) =
      1 - m * (1 / 2 - 1 / p) := by ring

theorem uniform_concentration_exponent (m : ℕ) :
    (0 : ℝ) < 1 / (2 * ((m : ℝ) + 1)) ∧
      (1 / 2 : ℝ) ≤ 1 - (m : ℝ) / (2 * ((m : ℝ) + 1)) := by
  constructor
  · positivity
  · have hm : (0 : ℝ) < 2 * ((m : ℝ) + 1) := by positivity
    have h : (m : ℝ) / (2 * ((m : ℝ) + 1)) ≤ 1 / 2 := by
      apply (div_le_iff₀ hm).2
      nlinarith
    linarith

end SignedExcessAudit
