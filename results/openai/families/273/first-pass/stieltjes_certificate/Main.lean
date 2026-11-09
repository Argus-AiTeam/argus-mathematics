import Mathlib

namespace StieltjesBoundary

noncomputable section

def jacobian (p q h : ℝ) : ℝ := p ^ 2 + q ^ 2 * h ^ 2 - q * h

def pDot (p q h : ℝ) : ℝ :=
  -p * (h + q * (1 - h ^ 2)) / jacobian p q h

def radius (p q h : ℝ) : ℝ := (1 - h ^ 2) * (p ^ 2 / h ^ 2 + q ^ 2)

def height (p h : ℝ) : ℝ := p / h

def densityDenom (p q h : ℝ) : ℝ := (q * h - 1) ^ 2 + (height p h) ^ 2

def heightDot (p q h : ℝ) : ℝ :=
  pDot p q h / h - p * (1 - h ^ 2) / h ^ 2

def radiusDot (p q h : ℝ) : ℝ :=
  2 * p * pDot p q h * (1 - h ^ 2) / h ^ 2 -
    2 * p ^ 2 * (1 - h ^ 2) / h ^ 3 +
    2 * q * (1 - h ^ 2) - 2 * q ^ 2 * h * (1 - h ^ 2)

theorem jacobian_pos {p q h : ℝ} (hp : 1 < p) :
    0 < jacobian p q h := by
  have hp2 : 1 < p ^ 2 := by nlinarith [sq_nonneg (p - 1)]
  unfold jacobian
  nlinarith [sq_nonneg (q * h - 1 / 2)]

theorem radius_pos {p q h : ℝ} (hp : 1 < p) (hh0 : 0 < h) (hh1 : h < 1) :
    0 < radius p q h := by
  have hp0 : 0 < p := by linarith
  have hc : 0 < 1 - h ^ 2 := by
    have ht : 0 < (1 - h) * (1 + h) := mul_pos (by linarith) (by linarith)
    nlinarith
  unfold radius
  exact mul_pos hc
    (add_pos_of_pos_of_nonneg (div_pos (sq_pos_of_pos hp0) (sq_pos_of_pos hh0))
      (sq_nonneg q))

theorem height_pos {p h : ℝ} (hp : 1 < p) (hh0 : 0 < h) :
    0 < height p h := by
  exact div_pos (by linarith) hh0

theorem densityDenom_pos {p q h : ℝ} (hp : 1 < p) (hh0 : 0 < h) :
    0 < densityDenom p q h := by
  exact add_pos_of_nonneg_of_pos (sq_nonneg _) (sq_pos_of_pos (height_pos hp hh0))

theorem heightDot_eq {p q h : ℝ} (hp : 1 < p) (hh0 : 0 < h) :
    heightDot p q h = -p * (1 + radius p q h) / jacobian p q h := by
  have hj : jacobian p q h ≠ 0 := ne_of_gt (jacobian_pos hp)
  have hh : h ≠ 0 := ne_of_gt hh0
  dsimp [heightDot, pDot, radius]
  field_simp [hj, hh]
  dsimp [jacobian]
  ring

theorem radiusDot_eq {p q h : ℝ} (hp : 1 < p) (hh0 : 0 < h) :
    radiusDot p q h =
      -2 * h * radius p q h * densityDenom p q h / jacobian p q h := by
  have hj : jacobian p q h ≠ 0 := ne_of_gt (jacobian_pos hp)
  have hh : h ≠ 0 := ne_of_gt hh0
  dsimp [radiusDot, pDot, radius, densityDenom, height]
  field_simp [hj, hh]
  dsimp [jacobian]
  ring

theorem boundary_density {p q h : ℝ}
    (hp : 1 < p) (hh0 : 0 < h) (hh1 : h < 1) :
    0 < jacobian p q h ∧
    0 < radius p q h ∧
    0 < height p h ∧
    0 < densityDenom p q h ∧
    heightDot p q h < 0 ∧
    radiusDot p q h < 0 ∧
    heightDot p q h / radiusDot p q h =
      (1 + radius p q h) * height p h /
        (2 * radius p q h * densityDenom p q h) := by
  have hj := jacobian_pos (q := q) (h := h) hp
  have hr := radius_pos (q := q) hp hh0 hh1
  have hd := height_pos hp hh0
  have hk := densityDenom_pos (q := q) hp hh0
  have hp0 : 0 < p := by linarith
  have hD : heightDot p q h < 0 := by
    rw [heightDot_eq hp hh0]
    exact div_neg_of_neg_of_pos
      (mul_neg_of_neg_of_pos (neg_neg_of_pos hp0) (by linarith)) hj
  have hR : radiusDot p q h < 0 := by
    rw [radiusDot_eq hp hh0]
    have ht : 0 < 2 * h * radius p q h * densityDenom p q h := by positivity
    exact div_neg_of_neg_of_pos (by nlinarith) hj
  have hratio :
      heightDot p q h / radiusDot p q h =
        (1 + radius p q h) * height p h /
          (2 * radius p q h * densityDenom p q h) := by
    rw [heightDot_eq hp hh0, radiusDot_eq hp hh0]
    dsimp [height]
    field_simp [ne_of_gt hj, ne_of_gt hr, ne_of_gt hk, ne_of_gt hh0]
  exact ⟨hj, hr, hd, hk, hD, hR, hratio⟩

#print axioms boundary_density

end

end StieltjesBoundary
