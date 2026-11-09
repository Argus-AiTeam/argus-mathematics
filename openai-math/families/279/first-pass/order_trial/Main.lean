import Mathlib

noncomputable section

namespace OrderTrial

def R0 (s a : ℝ) : ℝ := a * (1 - s) - a ^ 2 / 2
def I0 (s a : ℝ) : ℝ := -a * s - a ^ 2 / 2
def R1 (x y : ℝ) : ℝ := (x ^ 2 - y ^ 2) / 2
def I1 (x y : ℝ) : ℝ := (x ^ 2 + y ^ 2) / 2 - x - y
def R2 (x y : ℝ) : ℝ := (x ^ 2 + y ^ 2) / 2 - y - 1 / 2
def I2 (x y : ℝ) : ℝ := (x ^ 2 + y ^ 2) / 2 - x - 1 / 2

theorem sector_zero (s a : ℝ) :
    0 ≤ (R0 s a) ^ 2 + (I0 s a) ^ 2 - a ^ 2 / 4 := by
  have identity :
      (R0 s a) ^ 2 + (I0 s a) ^ 2 - a ^ 2 / 4 =
        2 * (a * (s + a / 2 - 1 / 2)) ^ 2 + (a / 2) ^ 2 := by
    unfold R0 I0
    ring
  rw [identity]
  positivity

theorem sector_one (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y)
    (hx1 : x ≤ 1) (hy1 : y ≤ 1) :
    0 ≤ (R1 x y) ^ 2 + (I1 x y) ^ 2 - (x + y) ^ 2 / 4 := by
  have he : 0 ≤ x * (1 - x) + y * (1 - y) :=
    add_nonneg (mul_nonneg hx (sub_nonneg.mpr hx1))
      (mul_nonneg hy (sub_nonneg.mpr hy1))
  have ha : 0 ≤ x + y := add_nonneg hx hy
  have identity :
      (R1 x y) ^ 2 + (I1 x y) ^ 2 - (x + y) ^ 2 / 4 =
        (R1 x y) ^ 2 +
          (x + y) * (x * (1 - x) + y * (1 - y)) / 2 +
          ((x * (1 - x) + y * (1 - y)) / 2) ^ 2 := by
    unfold R1 I1
    ring
  rw [identity]
  positivity

theorem sector_two (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y)
    (hxy : x + y ≤ 1) :
    0 ≤ (R2 x y) ^ 2 + (I2 x y) ^ 2 - (1 + x + y) ^ 2 / 4 := by
  have hp : 0 ≤ x + y := add_nonneg hx hy
  have hz : 0 ≤ 1 - (x + y) := sub_nonneg.mpr hxy
  have identity :
      (R2 x y) ^ 2 + (I2 x y) ^ 2 - (1 + x + y) ^ 2 / 4 =
        2 * x ^ 2 * y ^ 2 +
          2 * (1 - (x + y)) * (x + y) * x * y +
          (1 - (x + y)) / 4 +
          3 * (1 - (x + y)) * (x + y) / 4 +
          (x + y) ^ 2 * (1 - (x + y)) ^ 2 / 2 := by
    unfold R2 I2
    ring
  rw [identity]
  positivity

theorem sharp_endpoint :
    (R2 1 0) ^ 2 + (I2 1 0) ^ 2 = (1 + (1 : ℝ) + 0) ^ 2 / 4 := by
  norm_num [R2, I2]

theorem power_sum_one (M : ℕ) :
    (∑ i ∈ Finset.range M, (i : ℚ)) = (M : ℚ) * ((M : ℚ) - 1) / 2 := by
  induction M with
  | zero => norm_num
  | succ M ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring

theorem power_sum_two (M : ℕ) :
    (∑ i ∈ Finset.range M, (i : ℚ) ^ 2) =
      (M : ℚ) * ((M : ℚ) - 1) * (2 * (M : ℚ) - 1) / 6 := by
  induction M with
  | zero => norm_num
  | succ M ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring

theorem power_sum_three (M : ℕ) :
    (∑ i ∈ Finset.range M, (i : ℚ) ^ 3) =
      ((M : ℚ) * ((M : ℚ) - 1) / 2) ^ 2 := by
  induction M with
  | zero => norm_num
  | succ M ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring

theorem power_sum_four (M : ℕ) :
    (∑ i ∈ Finset.range M, (i : ℚ) ^ 4) =
      (M : ℚ) * ((M : ℚ) - 1) * (2 * (M : ℚ) - 1) *
        (3 * (M : ℚ) ^ 2 - 3 * (M : ℚ) - 1) / 30 := by
  induction M with
  | zero => norm_num
  | succ M ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring

theorem correction_mass (P U c rho S lam : ℚ)
    (hS : S = U / 2) (hrho : rho = lam - c * S) :
    c / 2 * P + c / 2 * (U - P) + rho = lam := by
  rw [hrho, hS]
  ring

end OrderTrial
