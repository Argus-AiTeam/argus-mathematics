import OAI.Analysis.Kaplansky.Main

namespace Reviewer294

open OAI.Kaplansky
open scoped ComplexOrder
attribute [local instance] CStarAlgebra.spectralOrder CStarAlgebra.spectralOrderedRing

theorem positiveContraction_iff {A : Type*} [CStarAlgebra A] (a : A) :
    PositiveContraction a ↔ 0 ≤ a ∧ ‖a‖ ≤ 1 := by
  change (∃ x, a = star x * x) ∧ ‖a‖ ≤ 1 ↔ 0 ≤ a ∧ ‖a‖ ≤ 1
  rw [← CStarAlgebra.nonneg_iff_eq_star_mul_self]

theorem defect_is_real {A : Type*} [CStarAlgebra A] (τ : OneQuasitrace A)
    {a b : A} (ha : PositiveContraction a) (hb : PositiveContraction b) :
    (τ (a + b) - τ a - τ b).im = 0 := by
  have hsa := ((positiveContraction_iff a).mp ha).1.isSelfAdjoint
  have hsb := ((positiveContraction_iff b).mp hb).1.isSelfAdjoint
  simp only [Complex.sub_im, τ.selfAdjoint_im_zero (hsa.add hsb),
    τ.selfAdjoint_im_zero hsa, τ.selfAdjoint_im_zero hsb, sub_self]

theorem extension_has_value_two {A : Type*} [CStarAlgebra A]
    (τ : OneQuasitrace A) (hn : τ.Normalized) (ht : τ.IsTwo) :
    ∃ σ : OneQuasitrace (CStarMatrix (Fin 2) (Fin 2) A),
      (∀ a, σ (upperLeft a) = τ a) ∧ σ 1 = 2 := by
  obtain ⟨σ, hσ⟩ := ht
  exact ⟨σ, hσ, extension_value_two τ hn σ hσ⟩

#print axioms positiveContraction_iff
#print axioms defect_is_real
#print axioms extension_has_value_two

end Reviewer294
