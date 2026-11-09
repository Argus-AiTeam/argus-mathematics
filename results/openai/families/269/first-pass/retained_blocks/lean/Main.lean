import Mathlib

open scoped BigOperators InnerProductSpace

namespace RetainedBlocks

theorem diagonalEnergyTransfer
    {ι F : Type*} [Fintype ι] [NormedAddCommGroup F] [NormedSpace ℝ F]
    (r : ι → ℝ) (a b : ι → F) (D : F →L[ℝ] F)
    (hr : ∀ i, 1 ≤ r i)
    (hD : ∀ y, ‖D y‖ ≤ ‖y‖)
    (hconj : ∀ i, r i • a i = D (b i)) :
    ∑ i, ‖a i‖ ^ 2 ≤ ∑ i, ‖b i‖ ^ 2 := by
  apply Finset.sum_le_sum
  intro i _
  have hr0 : 0 ≤ r i := le_trans zero_le_one (hr i)
  have heq : r i * ‖a i‖ = ‖D (b i)‖ := by
    simpa only [norm_smul, Real.norm_of_nonneg hr0] using congrArg norm (hconj i)
  have hle : ‖a i‖ ≤ ‖b i‖ := by
    nlinarith [hr i, norm_nonneg (a i), hD (b i)]
  nlinarith [norm_nonneg (a i), norm_nonneg (b i)]

theorem kernelSafeRelativeBound
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (R : E →L[ℝ] E) (x : E) (L h hDelta C ε : ℝ)
    (hL : 0 ≤ L) (hC : 0 ≤ C) (hε : 0 ≤ ε)
    (hR : ‖R‖ ≤ ε)
    (hx : ‖x‖ ^ 2 ≤ C * hDelta) (hTransfer : hDelta ≤ h) :
    -(ε * C * h) ≤ L + ⟪x, R x⟫_ℝ := by
  have hnorm : ‖R x‖ ≤ ε * ‖x‖ :=
    (R.le_opNorm x).trans (mul_le_mul_of_nonneg_right hR (norm_nonneg x))
  have hi : |⟪x, R x⟫_ℝ| ≤ ε * ‖x‖ ^ 2 := by
    calc
      |⟪x, R x⟫_ℝ| = ‖⟪x, R x⟫_ℝ‖ := (Real.norm_eq_abs _).symm
      _ ≤ ‖x‖ * ‖R x‖ := norm_inner_le_norm x (R x)
      _ ≤ ‖x‖ * (ε * ‖x‖) :=
        mul_le_mul_of_nonneg_left hnorm (norm_nonneg x)
      _ = ε * ‖x‖ ^ 2 := by ring
  have he : ε * ‖x‖ ^ 2 ≤ ε * C * h := by
    calc
      ε * ‖x‖ ^ 2 ≤ ε * (C * hDelta) :=
        mul_le_mul_of_nonneg_left hx hε
      _ ≤ ε * (C * h) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hTransfer hC) hε
      _ = ε * C * h := by ring
  have hl := (abs_le.mp hi).1
  linarith

theorem selectiveMargin :
    (1 : ℚ) - 93527408868499 / 10^14 - 61 / 4096
      - 658 * (3 / 10^6) = 4785933319001 / 10^14 := by
  norm_num

theorem strongerThanStagedCoefficient :
    (4616733319001 : ℚ) / 10^14 < 4785933319001 / 10^14 := by
  norm_num

end RetainedBlocks
