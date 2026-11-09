import Mathlib

open scoped BigOperators

namespace CubicalCutoff

theorem scalar_determinant (q : ℝ) (A : Matrix (Fin 3) (Fin 3) ℝ) :
    Matrix.det (q • A) = q ^ 3 * Matrix.det A := by
  simpa using Matrix.det_smul A q

set_option maxHeartbeats 1000000 in
private theorem rank_one_determinant
    (d u0 u1 u2 w0 w1 w2 : ℝ) :
    Matrix.det
      !![d + u0 * w0, u0 * w1, u0 * w2;
         u1 * w0, d + u1 * w1, u1 * w2;
         u2 * w0, u2 * w1, d + u2 * w2] =
      d ^ 3 + d ^ 2 * (u0 * w0 + u1 * w1 + u2 * w2) := by
  rw [Matrix.det_fin_three]
  change
    (d + u0 * w0) * (d + u1 * w1) * (d + u2 * w2) -
        (d + u0 * w0) * (u1 * w2) * (u2 * w1) -
        (u0 * w1) * (u1 * w0) * (d + u2 * w2) +
        (u0 * w1) * (u1 * w2) * (u2 * w0) +
        (u0 * w2) * (u1 * w0) * (u2 * w1) -
        (u0 * w2) * (d + u1 * w1) * (u2 * w0) =
      d ^ 3 + d ^ 2 * (u0 * w0 + u1 * w1 + u2 * w2)
  ring

theorem frame_transport_determinant
    (v0 v1 v2 w0 w1 w2 : ℝ) :
    let d := w0 ^ 2 + w1 ^ 2 + w2 ^ 2
    Matrix.det
      !![d + (v0 - w0) * w0, (v0 - w0) * w1, (v0 - w0) * w2;
         (v1 - w1) * w0, d + (v1 - w1) * w1, (v1 - w1) * w2;
         (v2 - w2) * w0, (v2 - w2) * w1, d + (v2 - w2) * w2] =
      d ^ 2 * (v0 * w0 + v1 * w1 + v2 * w2) := by
  dsimp only
  rw [rank_one_determinant]
  have hdot :
      (v0 - w0) * w0 + (v1 - w1) * w1 + (v2 - w2) * w2 =
        (v0 * w0 + v1 * w1 + v2 * w2) - (w0 ^ 2 + w1 ^ 2 + w2 ^ 2) := by
    ring
  rw [hdot]
  generalize w0 ^ 2 + w1 ^ 2 + w2 ^ 2 = d
  ring

theorem dyadic_sum_identity (N : ℕ) :
    (∑ k ∈ Finset.range N, (1 / 2 : ℝ) ^ k) +
      2 * (1 / 2 : ℝ) ^ N = 2 := by
  induction N with
  | zero => norm_num
  | succ N ih =>
      rw [Finset.sum_range_succ, pow_succ]
      linarith

theorem dyadic_sum_bound (N : ℕ) :
    (∑ k ∈ Finset.range N, (1 / 2 : ℝ) ^ k) ≤ 2 := by
  have h := dyadic_sum_identity N
  have htail : 0 ≤ 2 * (1 / 2 : ℝ) ^ N := by positivity
  linarith

theorem weighted_overlap_bound
    (K : ℝ) (hK : 0 ≤ K) (w : ℕ → ℝ)
    (hw : ∀ k, w k ≤ K * (4 : ℝ) ^ k) (N : ℕ) :
    (∑ k ∈ Finset.range N, w k / (8 : ℝ) ^ k) ≤ 2 * K := by
  have hterm (k : ℕ) :
      w k / (8 : ℝ) ^ k ≤ K * (1 / 2 : ℝ) ^ k := by
    calc
      w k / (8 : ℝ) ^ k ≤ (K * (4 : ℝ) ^ k) / (8 : ℝ) ^ k :=
        (div_le_div_iff_of_pos_right (by positivity)).mpr (hw k)
      _ = K * (1 / 2 : ℝ) ^ k := by
        rw [mul_div_assoc, ← div_pow]
        norm_num
  calc
    (∑ k ∈ Finset.range N, w k / (8 : ℝ) ^ k) ≤
        ∑ k ∈ Finset.range N, K * (1 / 2 : ℝ) ^ k :=
      Finset.sum_le_sum (fun k _ => hterm k)
    _ = K * ∑ k ∈ Finset.range N, (1 / 2 : ℝ) ^ k := by
      rw [Finset.mul_sum]
    _ ≤ K * 2 := mul_le_mul_of_nonneg_left (dyadic_sum_bound N) hK
    _ = 2 * K := by ring

end CubicalCutoff
