import Mathlib

namespace SeedRemoval

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

theorem pullback_sub_norm (V : E ≃ₗᵢ[ℝ] E) (a b : E) :
    ‖V.symm a - b‖ = ‖a - V b‖ := by
  calc
    ‖V.symm a - b‖ = ‖V (V.symm a - b)‖ := (V.norm_map _).symm
    _ = ‖a - V b‖ := by simp

theorem pullback_add_norm (V : E ≃ₗᵢ[ℝ] E) (a b : E) :
    ‖V.symm a + b‖ = ‖a + V b‖ := by
  calc
    ‖V.symm a + b‖ = ‖V (V.symm a + b)‖ := (V.norm_map _).symm
    _ = ‖a + V b‖ := by simp

theorem identity_defect (V Z : E ≃ₗᵢ[ℝ] E) (x : E) :
    ‖V.symm (Z (V x)) - Z x‖ ≤
      ‖V x - x‖ + ‖V (Z x) - Z x‖ := by
  rw [pullback_sub_norm]
  calc
    ‖Z (V x) - V (Z x)‖ =
        ‖(Z (V x) - Z x) + (Z x - V (Z x))‖ := by congr 1; abel
    _ ≤ ‖Z (V x) - Z x‖ + ‖Z x - V (Z x)‖ := norm_add_le _ _
    _ = ‖V x - x‖ + ‖V (Z x) - Z x‖ := by
      rw [← map_sub, Z.norm_map, norm_sub_rev (Z x) (V (Z x))]

theorem flip_defect (V Z F : E ≃ₗᵢ[ℝ] E)
    (anti : ∀ x, Z (F x) = -(F (Z x))) (x : E) :
    ‖V.symm (Z (V x)) + Z x‖ ≤
      ‖V x - F x‖ + ‖V (Z x) - F (Z x)‖ := by
  rw [pullback_add_norm]
  calc
    ‖Z (V x) + V (Z x)‖ =
        ‖(Z (V x) - Z (F x)) + (V (Z x) - F (Z x))‖ := by
      rw [anti]
      congr 1
      abel
    _ ≤ ‖Z (V x) - Z (F x)‖ + ‖V (Z x) - F (Z x)‖ := norm_add_le _ _
    _ = ‖V x - F x‖ + ‖V (Z x) - F (Z x)‖ := by
      rw [← map_sub, Z.norm_map]

theorem split_insertion_defect (V Z F : E ≃ₗᵢ[ℝ] E)
    (anti : ∀ x, Z (F x) = -(F (Z x))) (o s : E) :
    ‖V.symm (Z (V (o + s))) - Z (o + s) + (2 : ℝ) • Z s‖ ≤
      (‖V o - o‖ + ‖V (Z o) - Z o‖) +
      (‖V s - F s‖ + ‖V (Z s) - F (Z s)‖) := by
  have split :
      V.symm (Z (V (o + s))) - Z (o + s) + (2 : ℝ) • Z s =
      (V.symm (Z (V o)) - Z o) + (V.symm (Z (V s)) + Z s) := by
    simp only [map_add, two_smul]
    abel
  rw [split]
  exact (norm_add_le _ _).trans (add_le_add (identity_defect V Z o)
    (flip_defect V Z F anti s))

theorem transported_identity_defect (U V Z : E ≃ₗᵢ[ℝ] E) (s : E) :
    ‖U.symm (V.symm (Z (V s))) - U.symm (Z s)‖ ≤
      ‖V s - s‖ + ‖V (Z s) - Z s‖ := by
  calc
    ‖U.symm (V.symm (Z (V s))) - U.symm (Z s)‖ =
        ‖V.symm (Z (V s)) - Z s‖ := by rw [← map_sub, U.symm.norm_map]
    _ ≤ _ := identity_defect V Z s

theorem transported_flip_defect (U V Z F : E ≃ₗᵢ[ℝ] E)
    (anti : ∀ x, Z (F x) = -(F (Z x))) (s : E) :
    ‖U.symm (V.symm (Z (V s))) + U.symm (Z s)‖ ≤
      ‖V s - F s‖ + ‖V (Z s) - F (Z s)‖ := by
  calc
    ‖U.symm (V.symm (Z (V s))) + U.symm (Z s)‖ =
        ‖V.symm (Z (V s)) + Z s‖ := by rw [← map_add, U.symm.norm_map]
    _ ≤ _ := flip_defect V Z F anti s

theorem rescale_defect (r t K : ℝ) (hr : 0 < r) (d : E)
    (hd : ‖d‖ ≤ K * r ^ 2) :
    ‖(t / r) • d‖ ≤ |t| * K * r := by
  calc
    ‖(t / r) • d‖ = (|t| / r) * ‖d‖ := by
      rw [norm_smul, Real.norm_eq_abs, abs_div, abs_of_pos hr]
    _ ≤ (|t| / r) * (K * r ^ 2) :=
      mul_le_mul_of_nonneg_left hd (div_nonneg (abs_nonneg t) hr.le)
    _ = |t| * K * r := by field_simp [ne_of_gt hr]

theorem singular_echo_bound (r t K : ℝ) (hr : 0 < r) (v vp w : E)
    (hd : ‖vp - v + (2 * r) • w‖ ≤ K * r ^ 2) :
    ‖(t / r) • (vp - v) + (2 * t) • w‖ ≤ |t| * K * r := by
  have cancel : (t / r) * (2 * r) = 2 * t := by
    field_simp [ne_of_gt hr]
  have algebra :
      (t / r) • (vp - v) + (2 * t) • w =
      (t / r) • (vp - v + (2 * r) • w) := by
    rw [smul_add, smul_smul, cancel]
  rw [algebra]
  exact rescale_defect r t K hr _ hd

omit [NormedSpace ℝ E] in
theorem finite_transport_accumulation {n : ℕ} (errors : Fin n → E)
    (bounds : Fin n → ℝ) (h : ∀ j, ‖errors j‖ ≤ bounds j) :
    ‖∑ j, errors j‖ ≤ ∑ j, bounds j :=
  (norm_sum_le _ _).trans (Finset.sum_le_sum fun j _ => h j)

theorem reuse_energy_gap (q z : ℝ) :
    q * (1 + z ^ 2) / 4 - q * z / 2 = q * (1 - z) ^ 2 / 4 := by
  ring

theorem gaussian_gap_positive :
    0 < Real.exp (-(1 / 2 : ℝ)) * (1 - Real.exp (-1)) ^ 2 / 4 := by
  have h : Real.exp (-1) < 1 := Real.exp_lt_one_iff.mpr (by norm_num)
  have hp : 0 < 1 - Real.exp (-1) := by linarith
  positivity

end SeedRemoval
