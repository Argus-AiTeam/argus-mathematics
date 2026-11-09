import Mathlib.Algebra.Group.Equiv.Basic
import Mathlib.Topology.LocallyConstant.Basic

namespace PrescribedFiltration

theorem frobenius_basis_change {G : Type*} [Group G]
    (sigma : G →* G) (b g : G) :
    (sigma g)⁻¹ * sigma b * sigma (sigma g) =
      sigma (g⁻¹ * b * sigma g) := by
  simp only [map_mul, map_inv]

theorem representation_basis_change {G H : Type*} [Group G] [Group H]
    (sigma : G →* G) (tau : H →* H) (rho : G →* H)
    (compatible : ∀ a, tau (rho a) = rho (sigma a)) (b g : G) :
    (rho (sigma g))⁻¹ * rho (sigma b) * tau (rho (sigma g)) =
      rho (sigma (g⁻¹ * b * sigma g)) := by
  rw [compatible (sigma g)]
  simp only [map_mul, map_inv]

theorem faithful_central_preimage {G H : Type*} [Group G] [Group H]
    (rho : G →* H) (faithful : Function.Injective rho) (z : G)
    (central : ∀ a : H, rho z * a = a * rho z) :
    ∀ g : G, z * g = g * z := by
  intro g
  apply faithful
  simpa only [map_mul] using central (rho g)

theorem propagate_tensor_equalities {X I : Type*} [TopologicalSpace X]
    {A : I → Type*} (discrepancy : ∀ i, X → A i)
    (locallyConstant : ∀ i, IsLocallyConstant (discrepancy i))
    (zero : ∀ i, A i) (good : X → Prop)
    (hitsComponents : ∀ x : X,
      ∃ y : X, y ∈ connectedComponent x ∧ good y)
    (goodValues : ∀ y : X, good y →
      ∀ i : I, discrepancy i y = zero i) :
    ∀ i : I, ∀ x : X, discrepancy i x = zero i := by
  intro i x
  obtain ⟨y, hy, hgood⟩ := hitsComponents x
  calc
    discrepancy i x = discrepancy i y :=
      (locallyConstant i).apply_eq_of_isPreconnected
        isPreconnected_connectedComponent mem_connectedComponent hy
    _ = zero i := goodValues y hgood i

end PrescribedFiltration
