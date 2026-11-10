import Mathlib

namespace Family255InterfaceWitnesses

open OAI.PolycyclicRecognition

theorem integers_polycyclic : IsPolycyclic (Multiplicative ℤ) :=
  isPolycyclic_of_isCyclic

theorem integers_virtually_polycyclic : IsVirtuallyPolycyclic (Multiplicative ℤ) :=
  by
    let : IsCyclic (⊤ : Subgroup (Multiplicative ℤ)) :=
      isCyclic_of_injective (⊤ : Subgroup (Multiplicative ℤ)).subtype Subtype.val_injective
    exact ⟨⊤, inferInstance, isPolycyclic_of_isCyclic⟩

noncomputable def integers_coarse_identity :
    GroupCoarseEquivalence (Multiplicative ℤ) (Multiplicative ℤ) where
  toFun := id
  invFun := id
  bornologous_toFun := groupBornologous_hom (MonoidHom.id _)
  bornologous_invFun := groupBornologous_hom (MonoidHom.id _)
  left_error := by simpa using Set.finite_singleton (1 : Multiplicative ℤ)
  right_error := by simpa using Set.finite_singleton (1 : Multiplicative ℤ)

theorem integers_coarse_identity_retains_fg : Group.FG (Multiplicative ℤ) :=
  integers_coarse_identity.finitelyGenerated

def real_identity_quasi_isometry : SelfQuasiIsometry ℝ 1 0 where
  toFun := id
  upper := by intros; simp
  lower := by intros; simp
  surjective := fun y => ⟨y, by simp⟩

theorem real_identity_inverse_error (x : ℝ) :
    dist (real_identity_quasi_isometry.inverse
      (real_identity_quasi_isometry.toFun x)) x ≤ 0 := by
  simpa using real_identity_quasi_isometry.left_inverse_close (by norm_num) x

#print axioms integers_polycyclic
#print axioms integers_virtually_polycyclic
#print axioms integers_coarse_identity_retains_fg
#print axioms real_identity_inverse_error
#print axioms OAI.PolycyclicRecognition.GroupCoarseEquivalence.metric
#print axioms OAI.PolycyclicRecognition.GroupCoarseEquivalence.finitelyGenerated
#print axioms OAI.PolycyclicRecognition.SelfQuasiIsometry.inverse_upper

end Family255InterfaceWitnesses
