import Mathlib

namespace AdjointJetLifting

variable {A I : Type*} [AddCommGroup A] [Fintype I]

def ClosedHalfspaces (forms : I → A →+ ℤ) (q : A) : Prop :=
  ∀ i, 0 ≤ forms i q

def StrictHalfspaces (forms : I → A →+ ℤ) (q : A) : Prop :=
  ∀ i, 0 < forms i q

theorem height_one_surjective (form : A →+ ℤ) (c : A)
    (height : form c = 1) : Function.Surjective form := by
  intro z
  refine ⟨z • c, ?_⟩
  simp [map_zsmul, height]

theorem exact_saturation (forms : I → A →+ ℤ) (c : A)
    (Gamma : A → Prop)
    (height : ∀ i, forms i c = 1)
    (contained : ∀ q, Gamma q → ClosedHalfspaces forms q)
    (lift : ∀ q, StrictHalfspaces forms (q + c) → Gamma q) :
    (∀ q, Gamma q ↔ ClosedHalfspaces forms q) ∧
      (∀ q, StrictHalfspaces forms q ↔
        ∃ g, Gamma g ∧ q = c + g) := by
  have saturated : ∀ q, Gamma q ↔ ClosedHalfspaces forms q := by
    intro q
    constructor
    · exact contained q
    · intro hq
      apply lift q
      intro i
      have hi := hq i
      simp only [map_add, height i]
      omega
  refine ⟨saturated, ?_⟩
  intro q
  constructor
  · intro hq
    have hclosed : ClosedHalfspaces forms (q - c) := by
      intro i
      have hi := hq i
      simp only [map_sub, height i]
      omega
    refine ⟨q - c, (saturated (q - c)).mpr hclosed, ?_⟩
    abel
  · rintro ⟨g, hg, rfl⟩
    intro i
    have hi := contained g hg i
    simp only [map_add, height i]
    omega

end AdjointJetLifting
