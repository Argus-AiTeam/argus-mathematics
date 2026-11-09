import Mathlib

open Finset

namespace QuarticCore

theorem quartet_factor (a b d : ℝ) :
    a ^ 2 - b ^ 2 + (b + d - a) ^ 2 - d ^ 2 =
      2 * (a - b) * (a - d) := by
  ring

theorem gaussian_completion (x u v a : ℝ) :
    (x - a) ^ 2 + (x - u - a) ^ 2 +
      (x - u - v - a) ^ 2 + (x - v - a) ^ 2 =
      4 * (a - (x - (u + v) / 2)) ^ 2 + u ^ 2 + v ^ 2 := by
  ring

theorem potential_expansion (ju jv pu pv : ℝ) :
    ju * jv - pu * pv =
      (ju - pu) + (jv - pv) +
        ((1 - ju) * (1 - jv) - (1 - pu) * (1 - pv)) := by
  ring

theorem geometric_identity (r : ℝ) (N : ℕ) :
    (1 - r) * (∑ k ∈ range N, r ^ k) = 1 - r ^ N := by
  induction N with
  | zero => simp
  | succ N ih =>
      rw [sum_range_succ, mul_add, ih, pow_succ]
      ring

theorem geometric_bound (r : ℝ) (N : ℕ) (hr0 : 0 ≤ r) (hr1 : r < 1) :
    (∑ k ∈ range N, r ^ k) ≤ 1 / (1 - r) := by
  have hd : 0 < 1 - r := sub_pos.mpr hr1
  have hp : 0 ≤ r ^ N := pow_nonneg hr0 N
  have hi := geometric_identity r N
  apply (le_div_iff₀ hd).2
  nlinarith

theorem dyadic_exact (N : ℕ) :
    (∑ k ∈ range N, (2 * (k : ℝ) + 1) / (2 : ℝ) ^ k) =
      6 - (4 * (N : ℝ) + 6) / (2 : ℝ) ^ N := by
  induction N with
  | zero => norm_num
  | succ N ih =>
      rw [sum_range_succ, ih, pow_succ]
      push_cast
      field_simp
      <;> ring

theorem dyadic_bound (N : ℕ) :
    (∑ k ∈ range N, (2 * (k : ℝ) + 1) / (2 : ℝ) ^ k) ≤ 6 := by
  rw [dyadic_exact]
  have ht : 0 ≤ (4 * (N : ℝ) + 6) / (2 : ℝ) ^ N := by positivity
  linarith

theorem rectangle_exact (N : ℕ) :
    (∑ k ∈ range N, ((k : ℝ) + 3) / (2 : ℝ) ^ k) =
      8 - (2 * (N : ℝ) + 8) / (2 : ℝ) ^ N := by
  induction N with
  | zero => norm_num
  | succ N ih =>
      rw [sum_range_succ, ih, pow_succ]
      push_cast
      field_simp
      <;> ring

theorem rectangle_bound (N : ℕ) :
    (∑ k ∈ range N, ((k : ℝ) + 3) / (2 : ℝ) ^ k) ≤ 8 := by
  rw [rectangle_exact]
  have ht : 0 ≤ (2 * (N : ℝ) + 8) / (2 : ℝ) ^ N := by positivity
  linarith

theorem weighted_geometric_budget
    (r D : ℝ) (loss : ℕ → ℝ) (height : ℕ → ℕ) (N M : ℕ)
    (hr0 : 0 ≤ r) (hr1 : r < 1) (hD : 0 ≤ D)
    (hloss : ∀ m, 0 ≤ loss m) :
    D * (∑ k ∈ range N, r ^ k) +
        (∑ m ∈ range M, loss m * (∑ k ∈ range (height m), r ^ k)) ≤
      (D + ∑ m ∈ range M, loss m) / (1 - r) := by
  calc
    _ ≤ D * (1 / (1 - r)) +
          ∑ m ∈ range M, loss m * (1 / (1 - r)) := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_left (geometric_bound r N hr0 hr1) hD
      · exact sum_le_sum fun m _ =>
          mul_le_mul_of_nonneg_left
            (geometric_bound r (height m) hr0 hr1) (hloss m)
    _ = _ := by
      rw [← sum_mul]
      ring

end QuarticCore
