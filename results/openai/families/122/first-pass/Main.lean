import Mathlib

noncomputable section

namespace PositiveMomentMultiscale

def rho : ℝ := 500 / 1001
def delta : ℝ := 1 - 4 * rho ^ 2
def cOne : ℝ := delta / 2
def cFour : ℝ := 3 + (4 + rho) ^ 2 * (1 + 8 * rho ^ 2 / delta)
def beta : ℝ := 1 / 2 ^ 48

theorem four_sum_sq (a b c d : ℝ) :
    (a + b + c + d) ^ 2 ≤ 4 * (a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2) := by
  nlinarith [sq_nonneg (a - b), sq_nonneg (a - c), sq_nonneg (a - d),
    sq_nonneg (b - c), sq_nonneg (b - d), sq_nonneg (c - d)]

theorem four_factor_coercivity (r a b c d : ℝ) :
    (1 - 4 * r ^ 2) * (a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2) ≤
      a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 - r ^ 2 * (a + b + c + d) ^ 2 := by
  have h := mul_le_mul_of_nonneg_left (four_sum_sq a b c d) (sq_nonneg r)
  nlinarith

theorem rho_range : 0 < rho ∧ rho < 1 / 2 := by
  norm_num [rho]

theorem delta_positive : 0 < delta := by
  norm_num [delta, rho]

theorem cOne_lower : 1 / 1024 < cOne := by
  norm_num [cOne, delta, rho]

theorem weighted_young_identity (x b : ℝ) :
    (1 - cOne) * x ^ 2 + (cFour - 3) * b ^ 2 -
        (2 * rho * x + (4 + rho) * b) ^ 2 =
      (delta / 2) * (x - (4 * rho * (4 + rho) / delta) * b) ^ 2 := by
  norm_num [cOne, cFour, delta, rho]
  <;> ring

theorem contour_young (x b : ℝ) :
    3 * b ^ 2 + (2 * rho * x + (4 + rho) * b) ^ 2 ≤
      (1 - cOne) * x ^ 2 + cFour * b ^ 2 := by
  have hpos : 0 ≤ delta / 2 :=
    le_of_lt (div_pos delta_positive (by norm_num))
  have h := mul_nonneg hpos
    (sq_nonneg (x - (4 * rho * (4 + rho) / delta) * b))
  nlinarith [weighted_young_identity x b]

theorem bent_energy (b x omega : ℝ) (hb : 0 ≤ b) (hx : 0 ≤ x)
    (homega : |omega| ≤ 2 * x + b) :
    3 * b ^ 2 + (4 * b + rho * |omega|) ^ 2 ≤
      (1 - cOne) * x ^ 2 + cFour * b ^ 2 := by
  have hr : 0 ≤ rho := le_of_lt rho_range.1
  have hlo : 0 ≤ 4 * b + rho * |omega| := by positivity
  have hbound :
      4 * b + rho * |omega| ≤ 2 * rho * x + (4 + rho) * b := by
    nlinarith [mul_le_mul_of_nonneg_left homega hr]
  have hhi : 0 ≤ 2 * rho * x + (4 + rho) * b := le_trans hlo hbound
  have hprod := mul_nonneg (sub_nonneg.mpr hbound) (add_nonneg hhi hlo)
  nlinarith [contour_young x b]

theorem explicit_contour_constants :
    cFour * (2 ^ 16 : ℝ) ^ 2 * beta ^ 2 / 2 < 1 / 1000000 ∧
      30 < cOne * (2 ^ 16 : ℝ) ^ 2 / 1024 ∧
      beta + rho * (beta + 1 / 4) < 1 := by
  norm_num [cFour, cOne, delta, rho, beta]

theorem sector_bound (b omega : ℝ) (hb : 0 ≤ b) :
    |omega| ≤ (1001 / 500 : ℝ) * (b + rho * |omega|) := by
  norm_num [rho]
  nlinarith

theorem endpoint_two (c₁ c₂ j₁ j₂ d : ℂ) :
    c₁ * (j₁ - d) + c₂ * (j₂ - d) =
      (c₁ + c₂) * (j₂ - d) - c₁ * (j₂ - j₁) := by
  ring

theorem endpoint_three (c₁ c₂ c₃ j₁ j₂ j₃ d : ℂ) :
    c₁ * (j₁ - d) + c₂ * (j₂ - d) + c₃ * (j₃ - d) =
      (c₁ + c₂ + c₃) * (j₃ - d) -
        (c₁ * (j₂ - j₁) + (c₁ + c₂) * (j₃ - j₂)) := by
  ring

theorem endpoint_four (c₁ c₂ c₃ c₄ j₁ j₂ j₃ j₄ d : ℂ) :
    c₁ * (j₁ - d) + c₂ * (j₂ - d) + c₃ * (j₃ - d) + c₄ * (j₄ - d) =
      (c₁ + c₂ + c₃ + c₄) * (j₄ - d) -
        (c₁ * (j₂ - j₁) + (c₁ + c₂) * (j₃ - j₂) +
          (c₁ + c₂ + c₃) * (j₄ - j₃)) := by
  ring

end PositiveMomentMultiscale
