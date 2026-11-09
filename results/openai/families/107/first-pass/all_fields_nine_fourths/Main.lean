import Mathlib.LinearAlgebra.Basis.VectorSpace
import Mathlib.LinearAlgebra.Dual.Lemmas
import Mathlib.Tactic.Ring

open scoped BigOperators
open Module

namespace AllFieldsNineFourths

variable {F E : Type*} [Field F] [Field E] [Algebra F E]
variable {D I J K X Y Z : Type*}
variable [Fintype D] [Fintype I] [Fintype J] [Fintype K]

theorem normalized_functional :
    ∃ ell : E →ₗ[F] F, ell (1 : E) = 1 :=
  Module.Projective.exists_dual_eq_one F one_ne_zero

theorem functional_product_expansion
    (b : Basis D F E) (ell : E →ₗ[F] F) (x y z : E) :
    ell (x * y * z) =
      ∑ s, ∑ t, (b.repr x s * b.repr y t) * ell (b s * b t * z) := by
  conv_lhs => rw [← b.sum_repr x, ← b.sum_repr y]
  simp only [Finset.sum_mul, Finset.mul_sum, smul_mul_assoc, mul_smul_comm,
    map_sum, map_smul, smul_eq_mul, mul_assoc]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro s hs
  apply Finset.sum_congr rfl
  intro t ht
  ring

def restrictionCoefficient
    (a : I × J × K → F) (u : I → X → F)
    (v : J → Y → F) (w : K → Z → F) (x : X) (y : Y) (z : Z) : F :=
  ∑ q, a q * u q.1 x * v q.2.1 y * w q.2.2 z

def extensionRestrictionCoefficient
    (a : I × J × K → F) (u : I → X → E)
    (v : J → Y → E) (w : K → Z → E) (x : X) (y : Y) (z : Z) : E :=
  ∑ q, a q • (u q.1 x * v q.2.1 y * w q.2.2 z)

theorem sum_three_swap {T : Type*} [Fintype T] (f : T → D → D → F) :
    (∑ q, ∑ s, ∑ t, f q s t) = ∑ s, ∑ t, ∑ q, f q s t := by
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro s hs
  rw [Finset.sum_comm]

theorem restriction_descent_formula
    (b : Basis D F E) (ell : E →ₗ[F] F) (h_one : ell (1 : E) = 1)
    (a : I × J × K → F) (target : X → Y → Z → F)
    (u : I → X → E) (v : J → Y → E) (w : K → Z → E)
    (h : ∀ x y z, extensionRestrictionCoefficient a u v w x y z =
      target x y z • (1 : E)) (x : X) (y : Y) (z : Z) :
    target x y z =
      ∑ s, ∑ t, restrictionCoefficient a
        (fun i x => b.repr (u i x) s)
        (fun j y => b.repr (v j y) t)
        (fun k z => ell (b s * b t * w k z)) x y z := by
  have term (q : I × J × K) :
      ell (a q • (u q.1 x * v q.2.1 y * w q.2.2 z)) =
        ∑ s, ∑ t, a q * b.repr (u q.1 x) s * b.repr (v q.2.1 y) t *
          ell (b s * b t * w q.2.2 z) := by
    rw [map_smul, functional_product_expansion b ell]
    simp only [smul_eq_mul, Finset.mul_sum, mul_assoc]
  calc
    target x y z = ell (extensionRestrictionCoefficient a u v w x y z) := by
      rw [h, map_smul, h_one, smul_eq_mul, mul_one]
    _ = ∑ q, ∑ s, ∑ t,
        a q * b.repr (u q.1 x) s * b.repr (v q.2.1 y) t *
          ell (b s * b t * w q.2.2 z) := by
      rw [extensionRestrictionCoefficient, map_sum]
      exact Finset.sum_congr rfl (fun q _ => term q)
    _ = ∑ s, ∑ t, ∑ q,
        a q * b.repr (u q.1 x) s * b.repr (v q.2.1 y) t *
          ell (b s * b t * w q.2.2 z) := sum_three_swap _
    _ = _ := rfl

theorem finite_extension_restriction_descent
    (b : Basis D F E) (a : I × J × K → F) (target : X → Y → Z → F)
    (u : I → X → E) (v : J → Y → E) (w : K → Z → E)
    (h : ∀ x y z, extensionRestrictionCoefficient a u v w x y z =
      target x y z • (1 : E)) :
    ∃ ell : E →ₗ[F] F, ell (1 : E) = 1 ∧
      ∀ x y z, target x y z =
        ∑ s, ∑ t, restrictionCoefficient a
          (fun i x => b.repr (u i x) s)
          (fun j y => b.repr (v j y) t)
          (fun k z => ell (b s * b t * w k z)) x y z := by
  obtain ⟨ell, h_one⟩ := normalized_functional (F := F) (E := E)
  exact ⟨ell, h_one, restriction_descent_formula b ell h_one a target u v w h⟩

theorem number_of_source_copies :
    Fintype.card (D × D) = Fintype.card D ^ 2 := by
  simp [pow_two]

theorem mismatch_weight_identity {R : Type*} [CommRing R] (g h u v : R) :
    (g ^ 2 + h * u - h ^ 2 - h * v) - (g - h) ^ 2 =
      h * (u - v + 2 * (g - h)) := by
  ring

#print axioms finite_extension_restriction_descent
#print axioms mismatch_weight_identity

end AllFieldsNineFourths
