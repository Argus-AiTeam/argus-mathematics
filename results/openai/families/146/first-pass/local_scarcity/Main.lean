import Mathlib

namespace LocalScarcity

def total8 (x0 x1 x2 x3 x4 x5 x6 x7 : ℝ) : ℝ :=
  x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7

def minEdges (x0 x1 x2 x3 x4 x5 x6 x7 : ℝ) : ℝ :=
  min x0 x1 + min x1 x2 + min x2 x3 + min x3 x4 +
    min x4 x5 + min x5 x6 + min x6 x7

def maxEdges (x0 x1 x2 x3 x4 x5 x6 x7 : ℝ) : ℝ :=
  max x0 x1 + max x1 x2 + max x2 x3 + max x3 x4 +
    max x4 x5 + max x5 x6 + max x6 x7

theorem eighth_chain_exponent
    (x0 x1 x2 x3 x4 x5 x6 x7 c : ℝ)
    (h0 : 1 ≤ x0) (h1 : 1 ≤ x1) (h2 : 1 ≤ x2) (h3 : 1 ≤ x3)
    (h4 : 1 ≤ x4) (h5 : 1 ≤ x5) (h6 : 1 ≤ x6) (h7 : 1 ≤ x7)
    (hc : (2 : ℝ) / 3 ≤ c) :
    -1 + x0 + x7 + minEdges x0 x1 x2 x3 x4 x5 x6 x7
      - c * maxEdges x0 x1 x2 x3 x4 x5 x6 x7
      - c * total8 x0 x1 x2 x3 x4 x5 x6 x7
      ≤ 8 - 15 * c - (total8 x0 x1 x2 x3 x4 x5 x6 x7 - 8) / 8 := by
  let A := minEdges x0 x1 x2 x3 x4 x5 x6 x7
  let V := maxEdges x0 x1 x2 x3 x4 x5 x6 x7
  let T := total8 x0 x1 x2 x3 x4 x5 x6 x7
  have e0 : 8 * min x0 x1 ≤ x0 + 7 * x1 := by
    linarith [min_le_left x0 x1, min_le_right x0 x1]
  have e1 : 8 * min x1 x2 ≤ 2 * x1 + 6 * x2 := by
    linarith [min_le_left x1 x2, min_le_right x1 x2]
  have e2 : 8 * min x2 x3 ≤ 3 * x2 + 5 * x3 := by
    linarith [min_le_left x2 x3, min_le_right x2 x3]
  have e3 : 8 * min x3 x4 ≤ 4 * x3 + 4 * x4 := by
    linarith [min_le_left x3 x4, min_le_right x3 x4]
  have e4 : 8 * min x4 x5 ≤ 5 * x4 + 3 * x5 := by
    linarith [min_le_left x4 x5, min_le_right x4 x5]
  have e5 : 8 * min x5 x6 ≤ 6 * x5 + 2 * x6 := by
    linarith [min_le_left x5 x6, min_le_right x5 x6]
  have e6 : 8 * min x6 x7 ≤ 7 * x6 + x7 := by
    linarith [min_le_left x6 x7, min_le_right x6 x7]
  have hmin : 8 * A ≤ x0 + x7 + 9 * (x1 + x2 + x3 + x4 + x5 + x6) := by
    dsimp [A, minEdges]
    linarith
  have htotal : T = x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 := rfl
  have hidentity : A + V = 2 * T - x0 - x7 := by
    dsimp [A, V, T, minEdges, maxEdges, total8]
    linarith [min_add_max x0 x1, min_add_max x1 x2, min_add_max x2 x3,
      min_add_max x3 x4, min_add_max x4 x5, min_add_max x5 x6,
      min_add_max x6 x7]
  have hsum : 8 ≤ T := by
    linarith
  have hmax : 7 ≤ V := by
    dsimp [V, maxEdges]
    linarith [le_max_left x0 x1, le_max_left x1 x2, le_max_left x2 x3,
      le_max_left x3 x4, le_max_left x4 x5, le_max_left x5 x6,
      le_max_left x6 x7]
  have hcritical : x0 + x7 + A - ((2 : ℝ) / 3) * (V + T) ≤ -T / 8 := by
    linarith
  have hproduct : 0 ≤ (c - (2 : ℝ) / 3) * (V + T - 15) :=
    mul_nonneg (sub_nonneg.mpr hc) (by linarith)
  change -1 + x0 + x7 + A - c * V - c * T ≤ 8 - 15 * c - (T - 8) / 8
  nlinarith

theorem alternating_quadratic
    (a b c d : ℝ)
    (h0 : c + d = 0)
    (h1 : a + b + c - d = 0)
    (h2 : 4 * a + 2 * b + c + d = 0)
    (h3 : 9 * a + 3 * b + c - d = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 := by
  constructor
  · linarith
  constructor
  · linarith
  constructor <;> linarith

theorem uniform_error_margins
    (c alpha : ℝ) (hc : (2 : ℝ) / 3 < c) (ha : 2 * alpha < 3 * c - 1) :
    10 - 15 * c < 0 ∧ 2 - 3 * c < 0 ∧ 1 - 3 * c + 2 * alpha < 0 := by
  constructor
  · linarith
  constructor <;> linarith

theorem degree_seven_cannot_be_eighth_power
    (P : Polynomial ℝ) (hP : P.natDegree ≤ 7) :
    P ≠ Polynomial.X ^ 8 := by
  intro h
  subst P
  norm_num at hP

end LocalScarcity
