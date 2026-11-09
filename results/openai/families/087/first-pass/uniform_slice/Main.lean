import Mathlib

namespace UniformSlice

theorem resolvent_slack (q x y : ℝ) :
    (1 + q) * (1 + x) - ((1 + x) ^ 2 + y ^ 2) =
      (q ^ 2 - x ^ 2 - y ^ 2) + (1 - q) * (q - x) := by
  ring

theorem disk_resolvent (q x y : ℝ) (hq0 : 0 ≤ q) (hq1 : q < 1)
    (hxy : x ^ 2 + y ^ 2 ≤ q ^ 2) :
    1 / (1 + q) ≤ (1 + x) / ((1 + x) ^ 2 + y ^ 2) := by
  have hx2 : x ^ 2 ≤ q ^ 2 := by nlinarith [sq_nonneg y]
  have hx := abs_le.1 (abs_le_of_sq_le_sq hx2 hq0)
  have hp : 0 < 1 + q := by linarith
  have hxp : 0 < 1 + x := by linarith [hx.1]
  have hd : 0 < (1 + x) ^ 2 + y ^ 2 := by
    nlinarith [sq_pos_of_pos hxp, sq_nonneg y]
  apply (div_le_div_iff₀ hp hd).2
  have hm : 0 ≤ (1 - q) * (q - x) :=
    mul_nonneg (by linarith) (by linarith [hx.2])
  nlinarith [resolvent_slack q x y]

theorem exponential_peak (x : ℝ) :
    x * Real.exp (-x) ≤ Real.exp (-1) := by
  have hx : x ≤ Real.exp (x - 1) := by
    simpa using Real.add_one_le_exp (x - 1)
  calc
    x * Real.exp (-x) ≤ Real.exp (x - 1) * Real.exp (-x) :=
      mul_le_mul_of_nonneg_right hx (Real.exp_pos _).le
    _ = Real.exp (-1) := by
      rw [← Real.exp_add]
      congr 1
      ring

theorem endpoint_peak (H : ℝ) :
    H / 2 * Real.exp (-(H / 2)) ≤ Real.exp (-1) :=
  exponential_peak (H / 2)

theorem left_half_kernel (H y : ℝ) (hH : 0 < H) (hy : y ≤ H / 2) :
    Real.sqrt (y / (H - y)) ≤ 1 := by
  have hd : 0 < H - y := by linarith
  apply Real.sqrt_le_one.mpr
  apply (div_le_iff₀ hd).2
  linarith

theorem tip_constant_square (p : ℝ) :
    (3 * Real.sqrt 2 * p ^ 2 / 8) ^ 2 * (p ^ 2 / 2) =
      (3 * p ^ 3 / 8) ^ 2 := by
  calc
    (3 * Real.sqrt 2 * p ^ 2 / 8) ^ 2 * (p ^ 2 / 2) =
        9 * (Real.sqrt 2) ^ 2 * p ^ 6 / 128 := by ring
    _ = (3 * p ^ 3 / 8) ^ 2 := by
      rw [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
      ring

end UniformSlice
