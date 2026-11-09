import Mathlib

namespace CapAudit

theorem directed_T (H Is eps t B : ℝ) :
    ((H - Is) - eps * (1 + t * B)) / 2 + B * eps * t =
      (H - Is - eps + eps * t * B) / 2 := by
  ring

theorem directed_S (A As At H Is eps t B mu r : ℝ) :
    As / 2 + A * (-H + Is) / 2 +
        eps / 2 * (A + t * At + t * A * B) - (mu * As + A * r) =
      -(mu - 1 / 2) * As + eps * t * At / 2 - H * A / 2 +
        A * ((Is + eps + eps * t * B) / 2 - r) := by
  ring

theorem directed_J (A As H Is eps t mu r : ℝ) :
    eps * t * (mu * As + A * r - As - A * (-H + Is)) =
      eps * t * ((mu - 1) * As + A * (H - Is + r)) := by
  ring

theorem square_completion (T S J x y : ℝ) (hT : T ≠ 0) :
    T * x ^ 2 + S * y ^ 2 + J * x * y =
      T / 2 * x ^ 2 + (S - J ^ 2 / (2 * T)) * y ^ 2 +
        (T * x + J * y) ^ 2 / (2 * T) := by
  field_simp [hT]
  <;> ring

theorem quadratic_lower (T S J x y : ℝ) (hT : 0 < T) :
    T / 2 * x ^ 2 + (S - J ^ 2 / (2 * T)) * y ^ 2 ≤
      T * x ^ 2 + S * y ^ 2 + J * x * y := by
  rw [square_completion T S J x y (ne_of_gt hT)]
  exact le_add_of_nonneg_right
    (div_nonneg (sq_nonneg _) (by positivity))

theorem uniform_coercivity (T S J H gamma x y : ℝ)
    (hH : 0 < H) (hT : H / 4 ≤ T)
    (hS : gamma ≤ S - J ^ 2 / (2 * T)) :
    H / 8 * x ^ 2 + gamma * y ^ 2 ≤
      T * x ^ 2 + S * y ^ 2 + J * x * y := by
  have hTp : 0 < T := by linarith
  have hx : H / 8 * x ^ 2 ≤ T / 2 * x ^ 2 :=
    mul_le_mul_of_nonneg_right (by linarith) (sq_nonneg x)
  have hy : gamma * y ^ 2 ≤ (S - J ^ 2 / (2 * T)) * y ^ 2 :=
    mul_le_mul_of_nonneg_right hS (sq_nonneg y)
  linarith [quadratic_lower T S J x y hTp]

theorem scaled_young (v e u x : ℝ) (hv : 0 < v) :
    u * e * x ≤ v / 4 * x ^ 2 + (e ^ 2 / v) * u ^ 2 := by
  have hid :
      v / 4 * x ^ 2 + (e ^ 2 / v) * u ^ 2 - u * e * x =
        (v * x - 2 * e * u) ^ 2 / (4 * v) := by
    field_simp [ne_of_gt hv]
    <;> ring
  have hn : 0 ≤ (v * x - 2 * e * u) ^ 2 / (4 * v) :=
    div_nonneg (sq_nonneg _) (by positivity)
  linarith

theorem transverse_drift_decomposition (K Ky G Gy v vy r l : ℝ) :
    K * G * vy + v * (G * Ky + l * (Ky * G + K * Gy) + K * r) -
        (l + 1) * (G * v * Ky + K * Gy * v + 2 * K * G * vy) =
      K * (v * r - v * Gy - (2 * l + 1) * G * vy) := by
  ring

theorem high_factor_count (l : ℕ) (hl : 8 ≤ l) :
    l < 2 * (l - 3) := by
  omega

theorem no_two_high_factors (l a b : ℕ) (hl : 8 ≤ l)
    (ha : l - 3 ≤ a) (hb : l - 3 ≤ b) (hab : a + b ≤ l) :
    False := by
  omega

end CapAudit
