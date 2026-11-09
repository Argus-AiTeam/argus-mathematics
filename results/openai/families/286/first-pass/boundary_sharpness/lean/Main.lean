import Mathlib

namespace BoundarySharpness

variable {E K₁ K₂ : Type*}
variable [AddCommGroup E] [Module ℂ E]
variable [NormedAddCommGroup K₁] [NormedSpace ℂ K₁]
variable [NormedAddCommGroup K₂] [NormedSpace ℂ K₂]

def closedAntidiagonal (j₁ : E →ₗ[ℂ] K₁) (j₂ : E →ₗ[ℂ] K₂) :
    Submodule ℂ (K₁ × K₂) :=
  (LinearMap.range (j₁.prod (-j₂))).topologicalClosure

noncomputable def sumFunctional (L₁ : K₁ →L[ℂ] ℂ) (L₂ : K₂ →L[ℂ] ℂ) :
    K₁ × K₂ →L[ℂ] ℂ :=
  L₁.comp (ContinuousLinearMap.fst ℂ K₁ K₂) +
    L₂.comp (ContinuousLinearMap.snd ℂ K₁ K₂)

theorem antidiagonal_mem (j₁ : E →ₗ[ℂ] K₁) (j₂ : E →ₗ[ℂ] K₂) (b : E) :
    (j₁ b, -j₂ b) ∈ closedAntidiagonal j₁ j₂ :=
  (LinearMap.range (j₁.prod (-j₂))).le_topologicalClosure ⟨b, rfl⟩

theorem quotient_inputs_agree (j₁ : E →ₗ[ℂ] K₁) (j₂ : E →ₗ[ℂ] K₂) (b : E) :
    (closedAntidiagonal j₁ j₂).mkQ (j₁ b, 0) =
      (closedAntidiagonal j₁ j₂).mkQ (0, j₂ b) := by
  apply (Submodule.Quotient.eq _).2
  simpa using antidiagonal_mem j₁ j₂ b

theorem antidiagonal_le_kernel
    (j₁ : E →ₗ[ℂ] K₁) (j₂ : E →ₗ[ℂ] K₂)
    (L₁ : K₁ →L[ℂ] ℂ) (L₂ : K₂ →L[ℂ] ℂ)
    (h : ∀ b, L₁ (j₁ b) = L₂ (j₂ b)) :
    closedAntidiagonal j₁ j₂ ≤ (sumFunctional L₁ L₂).ker := by
  apply (LinearMap.range (j₁.prod (-j₂))).topologicalClosure_minimal
    ?_ (sumFunctional L₁ L₂).isClosed_ker
  rintro _ ⟨b, rfl⟩
  change L₁ (j₁ b) + L₂ (-j₂ b) = 0
  rw [map_neg, h b]
  exact add_neg_cancel _

theorem nonzero_common_functional_survives
    (j₁ : E →ₗ[ℂ] K₁) (j₂ : E →ₗ[ℂ] K₂)
    (L₁ : K₁ →L[ℂ] ℂ) (L₂ : K₂ →L[ℂ] ℂ)
    (h : ∀ b, L₁ (j₁ b) = L₂ (j₂ b))
    (hne : ∃ b, L₁ (j₁ b) ≠ 0) :
    ∃ b, (closedAntidiagonal j₁ j₂).mkQ (j₁ b, 0) ≠ 0 := by
  obtain ⟨b, hb⟩ := hne
  refine ⟨b, ?_⟩
  intro hz
  have hm : (j₁ b, 0) ∈ closedAntidiagonal j₁ j₂ :=
    (Submodule.Quotient.mk_eq_zero _).mp hz
  have hk := antidiagonal_le_kernel j₁ j₂ L₁ L₂ h hm
  change L₁ (j₁ b) + L₂ 0 = 0 at hk
  exact hb (by simpa using hk)

theorem closedAntidiagonal_invariant
    (j₁ : E →ₗ[ℂ] K₁) (j₂ : E →ₗ[ℂ] K₂)
    (T₁ : K₁ →L[ℂ] K₁) (T₂ : K₂ →L[ℂ] K₂) (m : E →ₗ[ℂ] E)
    (h₁ : ∀ b, T₁ (j₁ b) = j₁ (m b))
    (h₂ : ∀ b, T₂ (j₂ b) = j₂ (m b)) :
    ∀ v ∈ closedAntidiagonal j₁ j₂,
      (T₁ v.1, T₂ v.2) ∈ closedAntidiagonal j₁ j₂ := by
  let T : K₁ × K₂ →L[ℂ] K₁ × K₂ :=
    (T₁.comp (ContinuousLinearMap.fst ℂ K₁ K₂)).prod
      (T₂.comp (ContinuousLinearMap.snd ℂ K₁ K₂))
  have hr : LinearMap.range (j₁.prod (-j₂)) ≤
      (closedAntidiagonal j₁ j₂).comap T.toLinearMap := by
    rintro _ ⟨b, rfl⟩
    change (T₁ (j₁ b), T₂ (-j₂ b)) ∈ closedAntidiagonal j₁ j₂
    simpa [map_neg, h₁, h₂] using antidiagonal_mem j₁ j₂ (m b)
  have hc : IsClosed
      (((closedAntidiagonal j₁ j₂).comap T.toLinearMap) : Set (K₁ × K₂)) :=
    (LinearMap.range (j₁.prod (-j₂))).isClosed_topologicalClosure.preimage T.continuous
  exact (LinearMap.range (j₁.prod (-j₂))).topologicalClosure_minimal hr hc

end BoundarySharpness
