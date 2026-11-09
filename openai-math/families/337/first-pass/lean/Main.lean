import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

set_option autoImplicit false

namespace SobolevAudit

theorem critical_constants (m : ℝ) (hm : 2 < m) :
    0 < 4 / (m - 2) ∧
    2 * m / (m - 2) - 2 = 4 / (m - 2) ∧
    (4 / (m - 2)) * ((m - 2) / 2) = 2 ∧
    (4 / (m - 2)) * ((m - 2) / 2) ^ 2 = m - 2 := by
  have hd : 0 < m - 2 := sub_pos.mpr hm
  refine ⟨div_pos (by norm_num) hd, ?_, ?_, ?_⟩
  all_goals field_simp [ne_of_gt hd] <;> ring

theorem critical_mass_exponent (m : ℝ) (hm : 2 < m) :
    0 < (m - 2) / m ∧ (m - 2) / m < 1 := by
  have hm0 : 0 < m := lt_trans (by norm_num) hm
  constructor
  · exact div_pos (sub_pos.mpr hm) hm0
  · exact (div_lt_iff₀ hm0).mpr (by linarith)

theorem no_mass_loss (p Y B t : ℝ)
    (hp : p ≤ 1) (hY : 0 ≤ Y) (hgap : Y < B)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1)
    (hmass : Y * t ^ p + B * (1 - t) ^ p ≤ Y) :
    t = 1 := by
  have hB : 0 ≤ B := le_trans hY hgap.le
  have htp : t ≤ t ^ p :=
    Real.self_le_rpow_of_le_one ht0 ht1 hp
  have hsp : 1 - t ≤ (1 - t) ^ p :=
    Real.self_le_rpow_of_le_one (by linarith) (by linarith) hp
  have hleft := mul_le_mul_of_nonneg_left htp hY
  have hright := mul_le_mul_of_nonneg_left hsp hB
  have hprod : (B - Y) * (1 - t) ≤ 0 := by nlinarith
  have hzero : 1 - t = 0 := by
    by_contra hne
    have hpos : 0 < 1 - t :=
      lt_of_le_of_ne (by linarith) (Ne.symm hne)
    have hstrict : 0 < (B - Y) * (1 - t) :=
      mul_pos (sub_pos.mpr hgap) hpos
    linarith
  linarith

theorem coordinate_bound (c q Y E : ℝ) (hc : 0 < c)
    (hcq : c = q - 2) (h : (q - 2) * Y ≤ c * E) :
    Y ≤ E := by
  rw [← hcq] at h
  by_contra hn
  have hpos : 0 < Y - E := sub_pos.mpr (lt_of_not_ge hn)
  have hstrict : 0 < c * (Y - E) := mul_pos hc hpos
  nlinarith

theorem square_rigidity (c Y E D : ℝ) (hc : 0 < c)
    (hD : 0 ≤ D) (hlower : E + c * D ≤ Y) (hupper : Y ≤ E) :
    D = 0 := by
  by_contra hne
  have hpos : 0 < D := lt_of_le_of_ne hD (Ne.symm hne)
  have hstrict : 0 < c * D := mul_pos hc hpos
  linarith

end SobolevAudit
