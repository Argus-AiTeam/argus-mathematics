import Mathlib

namespace LCSliceAudit

theorem exact_penalty
    (e lam C D B b h R V : ℝ)
    (he : 0 < e) (hlam : 0 < lam) (hC : 0 ≤ C)
    (hD : 0 ≤ D) (hB : 0 ≤ B)
    (hb : 0 < b) (hbB : b ≤ B) (hR : 0 < R)
    (hh : b - D * e ≤ h)
    (hV : R / (1 + C * e) ≤ V)
    (hbudget : lam * (D + C * B) < 1) :
    lam * b * R < (e + lam * h) * V := by
  have hK : 0 < 1 + C * e := by positivity
  have hVpos : 0 < V := lt_of_lt_of_le (div_pos hR hK) hV
  have hVR : R ≤ (1 + C * e) * V := by
    have ht := (div_le_iff₀ hK).mp hV
    nlinarith only [ht]
  have hbudget' : lam * (D + C * b) < 1 := by
    have hcb : C * b ≤ C * B := mul_le_mul_of_nonneg_left hbB hC
    have hsum : D + C * b ≤ D + C * B := by linarith only [hcb]
    calc
      lam * (D + C * b) ≤ lam * (D + C * B) :=
        mul_le_mul_of_nonneg_left hsum hlam.le
      _ < 1 := hbudget
  have hmargin : 0 < e * (1 - lam * (D + C * b)) :=
    mul_pos he (by linarith)
  have hslack : 0 ≤ lam * (h - b + D * e) :=
    mul_nonneg hlam.le (by linarith)
  have hnum : lam * b * (1 + C * e) < e + lam * h := by
    nlinarith only [hmargin, hslack]
  calc
    lam * b * R ≤ lam * b * ((1 + C * e) * V) :=
      mul_le_mul_of_nonneg_left hVR (mul_nonneg hlam.le hb.le)
    _ = (lam * b * (1 + C * e)) * V := by ring
    _ < (e + lam * h) * V := mul_lt_mul_of_pos_right hnum hVpos

theorem common_budget
    (lam S : ℝ) (hlam : 0 < lam) (hS : 0 ≤ S)
    (hsmall : lam ≤ 1 / (2 * (1 + S))) :
    lam * S < 1 / 2 := by
  have hden : 0 < 2 * (1 + S) := by positivity
  have hmul := (le_div_iff₀ hden).mp hsmall
  nlinarith only [hmul, hlam]

theorem minimizer_defect_zero
    {T : Type*} (e h root : T → ℝ) (r : T → T)
    (u : T) (lam C D B : ℝ)
    (hlam : 0 < lam) (hC : 0 ≤ C)
    (hD : 0 ≤ D) (hB : 0 ≤ B)
    (hbudget : lam * (D + C * B) < 1)
    (he : 0 ≤ e u) (her : e (r u) = 0)
    (hb : 0 < h (r u)) (hbB : h (r u) ≤ B)
    (hR : 0 < root (r u))
    (hh : h (r u) - D * e u ≤ h u)
    (hV : root (r u) / (1 + C * e u) ≤ root u)
    (hmin : ∀ w : T,
      (e u + lam * h u) * root u ≤
        (e w + lam * h w) * root w) :
    e u = 0 := by
  by_contra hne
  have hepos : 0 < e u := lt_of_le_of_ne he (Ne.symm hne)
  have hstrict := exact_penalty (e u) lam C D B (h (r u)) (h u)
    (root (r u)) (root u) hepos hlam hC hD hB hb hbB hR hh hV hbudget
  have hcompare := hmin (r u)
  rw [her, zero_add] at hcompare
  exact (not_lt_of_ge hcompare) hstrict

end LCSliceAudit
