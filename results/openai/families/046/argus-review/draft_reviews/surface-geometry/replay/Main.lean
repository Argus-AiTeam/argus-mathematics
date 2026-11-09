import Mathlib.GroupTheory.QuotientGroup.Basic

namespace SurfaceGeometry

universe u v w z

variable {G : Type u} {Q : Type v} {P : Type w} {I : Type z}
variable [Group G] [Group Q] [Group P]

theorem local_kernel_agreement
    (f : G →* Q) (p : Q →* P) (A : Subgroup Q)
    (himage : ∀ g, f g ∈ A)
    (hdetect : Set.InjOn p (A : Set Q)) :
    (p.comp f).ker = f.ker := by
  ext g
  change p (f g) = 1 ↔ f g = 1
  constructor
  · intro h
    exact hdetect (himage g) A.one_mem (by simpa using h)
  · intro h
    simp [h]

theorem conjugate_kernel_trivial
    (p : Q →* P) (A : Subgroup Q)
    (hdetect : Set.InjOn p (A : Set Q))
    {a : Q} (ha : a ∈ A) (g : Q)
    (h : p (g * a * g⁻¹) = 1) :
    g * a * g⁻¹ = 1 := by
  have hp : p a = 1 := by
    have h' := congrArg (fun t : P => (p g)⁻¹ * t * p g) h
    simpa [map_mul, map_inv, mul_assoc] using h'
  have haone : a = 1 :=
    hdetect ha A.one_mem (by simpa using hp)
  simp [haone]

theorem normal_closure_killed
    (rho : G →* Q) (p : Q →* P) (A : I → Subgroup Q)
    (S : Set G)
    (hdetect : ∀ i, Set.InjOn p (A i : Set Q))
    (hlocal : ∀ s ∈ S, ∃ i a g, a ∈ A i ∧ rho s = g * a * g⁻¹)
    (hfinite : ∀ s ∈ S, p (rho s) = 1) :
    Subgroup.normalClosure S ≤ rho.ker := by
  apply Subgroup.normalClosure_le_normal
  intro s hs
  change rho s = 1
  rcases hlocal s hs with ⟨i, a, g, ha, heq⟩
  rw [heq]
  apply conjugate_kernel_trivial p (A i) (hdetect i) ha g
  rw [← heq]
  exact hfinite s hs

theorem descent_exists
    (rho : G →* Q) (p : Q →* P) (A : I → Subgroup Q)
    (S : Set G)
    (hdetect : ∀ i, Set.InjOn p (A i : Set Q))
    (hlocal : ∀ s ∈ S, ∃ i a g, a ∈ A i ∧ rho s = g * a * g⁻¹)
    (hfinite : ∀ s ∈ S, p (rho s) = 1) :
    ∃ descended : G ⧸ Subgroup.normalClosure S →* Q,
      ∀ g, descended (QuotientGroup.mk g) = rho g := by
  have hker := normal_closure_killed rho p A S hdetect hlocal hfinite
  refine ⟨QuotientGroup.lift (Subgroup.normalClosure S) rho hker, ?_⟩
  intro g
  rfl

end SurfaceGeometry
