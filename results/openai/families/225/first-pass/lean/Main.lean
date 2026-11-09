import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

namespace StaggeredFidelity

theorem corrected_symbol (a b E : ℂ) (hab : 1 - a * b ≠ 0) :
    ((1 - E) * (1 + a * b) / 2 - b + E * a) / (1 - a * b)
        + (1 + E) / 2
      = (1 - b) * (1 + E * a) / (1 - a * b) := by
  field_simp [hab]
  ring

theorem relative_symbol (a b E : ℂ)
    (hab : 1 - a * b ≠ 0) (hb : 1 - b ≠ 0) (ha : 1 + a ≠ 0) :
    ((1 - b) * (1 + E * a) / (1 - a * b)) /
        ((1 - b) * (1 + a) / (1 - a * b))
      = (1 + E * a) / (1 + a) := by
  field_simp [hab, hb, ha]
  field_simp [hab]

theorem pair_accelerations_cancel (vi vj wi wj fp fpp : ℝ) :
    (fpp * (vj ^ 2 + vi ^ 2 - (vi - vj) ^ 2)
        + fp * (-wj + wi - (wi - wj))) / 2
      = vi * vj * fpp := by
  ring

theorem density_coefficient (p lam : ℝ)
    (hlam : lam ≠ 0) (hgap : p - lam ≠ 0) :
    2 * (1 / (2 * (p - lam))) ^ 2
        - 2 * p / lam * (1 / (2 * (p - lam))) ^ 2
      = -(1 / (2 * lam * (p - lam))) := by
  field_simp [hlam, hgap]
  ring

end StaggeredFidelity
