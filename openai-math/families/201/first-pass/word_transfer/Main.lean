import Mathlib

namespace WordTransfer

variable {K E F U : Type*} [Field K]
  [AddCommGroup E] [Module K E]
  [AddCommGroup F] [Module K F]
  [AddCommGroup U] [Module K U]

def block (A : E →ₗ[K] E) (B : F →ₗ[K] E)
    (C : E →ₗ[K] F) (D : F ≃ₗ[K] F) : (E × F) →ₗ[K] (E × F) where
  toFun x := (A x.1 + B x.2, C x.1 + D x.2)
  map_add' x y := by
    ext <;> simp only [Prod.fst_add, Prod.snd_add, map_add] <;> abel
  map_smul' a x := by
    ext <;> simp [smul_add]

theorem kernel_iff (A : E →ₗ[K] E) (B : F →ₗ[K] E)
    (C : E →ₗ[K] F) (D : F ≃ₗ[K] F)
    (hS : A = B.comp (D.symm.toLinearMap.comp C)) (x : E × F) :
    block A B C D x = 0 ↔ x.2 = -D.symm (C x.1) := by
  constructor
  · intro hx
    have hlow : C x.1 + D x.2 = 0 := congrArg Prod.snd hx
    have hsum : D.symm (C x.1) + x.2 = 0 := by
      simpa using congrArg D.symm hlow
    calc
      x.2 = (D.symm (C x.1) + x.2) - D.symm (C x.1) := by abel
      _ = -D.symm (C x.1) := by rw [hsum]; simp
  · intro hx
    ext <;> simp [block, hS, hx]

theorem kernel_graph_unique (A : E →ₗ[K] E) (B : F →ₗ[K] E)
    (C : E →ₗ[K] F) (D : F ≃ₗ[K] F)
    (hS : A = B.comp (D.symm.toLinearMap.comp C))
    (x : E × F) (hx : block A B C D x = 0) :
    ∃! u : E, x = (u, -D.symm (C u)) := by
  refine ⟨x.1, ?_, ?_⟩
  · exact Prod.ext rfl ((kernel_iff A B C D hS x).mp hx)
  · intro u hu
    exact (congrArg Prod.fst hu).symm

theorem fixed_complement_solution (A : E →ₗ[K] E) (B : F →ₗ[K] E)
    (C : E →ₗ[K] F) (D : F ≃ₗ[K] F)
    (hS : A = B.comp (D.symm.toLinearMap.comp C))
    (b : E × F) (hb : ∃ x, block A B C D x = b) :
    block A B C D (0, D.symm b.2) = b := by
  obtain ⟨x, rfl⟩ := hb
  ext <;> simp [block, hS, map_add]

theorem fixed_complement_sandwich (A : E →ₗ[K] E) (B : F →ₗ[K] E)
    (C : E →ₗ[K] F) (D : F ≃ₗ[K] F)
    (hS : A = B.comp (D.symm.toLinearMap.comp C))
    (L : (E × F) →ₗ[K] U) (J : (E × F) →ₗ[K] (E × F))
    (hL : ∀ x, block A B C D x = 0 → L x = 0)
    (b : E × F) (hb : ∃ x, block A B C D x = b)
    (hJ : block A B C D (J b) = b) :
    L (J b) = L (0, D.symm b.2) := by
  have hz : block A B C D (J b - (0, D.symm b.2)) = 0 := by
    rw [map_sub, hJ, fixed_complement_solution A B C D hS b hb, sub_self]
  have h := hL _ hz
  exact sub_eq_zero.mp (by simpa only [map_sub] using h)

end WordTransfer
