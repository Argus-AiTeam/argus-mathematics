import KusnerL1.ScalarReduction
import KusnerL1.Cardinality

/-! The main theorem for arbitrary equilateral sets in the genuine ℓ₁ metric. -/
namespace KusnerL1

theorem no_unit_equilateral {n : ℕ} (hn : 2 ≤ n) (hn6 : n ≤ 6)
    (x : Fin (2 * n + 1) → L1 n) : ¬ UnitEquilateral x := by
  intro hx
  exact no_scalar_solution hn hn6 _ _ (scalar_obstruction hn hx)

/-- Every equilateral set, without an a priori finiteness assumption. -/
theorem equilateral_upper {n : ℕ} (hn : 2 ≤ n) (hn6 : n ≤ 6)
    {S : Set (L1 n)} (hS : Equilateral S) : S.encard ≤ 2 * n :=
  equilateral_encard_le_of_exclusion (no_unit_equilateral hn hn6) hS

theorem equilateral_finite {n : ℕ} (hn : 2 ≤ n) (hn6 : n ≤ 6)
    {S : Set (L1 n)} (hS : Equilateral S) : S.Finite ∧ S.ncard ≤ 2 * n :=
  equilateral_finite_of_exclusion (no_unit_equilateral hn hn6) hS

theorem equilateralDimension_eq {n : ℕ} (hn : 2 ≤ n) (hn6 : n ≤ 6) :
    equilateralDimension n = (2 * n : ℕ) :=
  equilateralDimension_eq_of_exclusion n (no_unit_equilateral hn hn6)

/-- The conclusion `e(ℓ₁⁵) = 10`. -/
theorem equilateralDimension_five : equilateralDimension 5 = 10 :=
  equilateralDimension_eq (by norm_num) (by norm_num)

/-- The conclusion `e(ℓ₁⁶) = 12`. -/
theorem equilateralDimension_six : equilateralDimension 6 = 12 :=
  equilateralDimension_eq (by norm_num) (by norm_num)

end KusnerL1
