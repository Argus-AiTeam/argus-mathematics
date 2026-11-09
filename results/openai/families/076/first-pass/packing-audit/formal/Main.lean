import Mathlib

namespace PackingAudit

variable {K V W : Type*}
variable [Field K] [AddCommGroup V] [Module K V]
variable [AddCommGroup W] [Module K W]

/-- Splitting an affine fiber into the value of `g` and its `g = 0` subfiber. -/
def fiberEquiv (F : V →ₗ[K] W) (g : V →ₗ[K] K) (s : W)
    (v : V) (hvF : F v = 0) (hvg : g v = 1) :
    {x : V // F x = s} ≃ K × {x : V // F x = s ∧ g x = 0} where
  toFun x := ⟨g x, ⟨x - g x • v, by
    constructor
    · simp [map_sub, map_smul, hvF, x.property]
    · simp [map_sub, map_smul, hvg]⟩⟩
  invFun z := ⟨z.2 + z.1 • v, by
    simp [map_add, map_smul, hvF, z.2.property.1]⟩
  left_inv x := by
    apply Subtype.ext
    exact sub_add_cancel _ _
  right_inv z := by
    apply Prod.ext
    · simp [map_add, map_smul, hvg, z.2.property.2]
    · apply Subtype.ext
      simp [map_add, map_smul, hvg, z.2.property.2]

/-- The same splitting with the `g` coordinate restricted to an arbitrary finset. -/
def selectedFiberEquiv (F : V →ₗ[K] W) (g : V →ₗ[K] K) (s : W)
    (B : Finset K) (v : V) (hvF : F v = 0) (hvg : g v = 1) :
    {x : V // F x = s ∧ g x ∈ B} ≃
      ↥B × {x : V // F x = s ∧ g x = 0} where
  toFun x := ⟨⟨g x, x.property.2⟩, ⟨x - g x • v, by
    constructor
    · simp [map_sub, map_smul, hvF, x.property.1]
    · simp [map_sub, map_smul, hvg]⟩⟩
  invFun z := ⟨z.2 + (z.1 : K) • v, by
    constructor
    · simp [map_add, map_smul, hvF, z.2.property.1]
    · simp [map_add, map_smul, hvg, z.2.property.2]⟩
  left_inv x := by
    apply Subtype.ext
    exact sub_add_cancel _ _
  right_inv z := by
    apply Prod.ext
    · apply Subtype.ext
      simp [map_add, map_smul, hvg, z.2.property.2]
    · apply Subtype.ext
      simp [map_add, map_smul, hvg, z.2.property.2]

theorem fiber_card_factorization (F : V →ₗ[K] W) (g : V →ₗ[K] K)
    (s : W) (v : V) (hvF : F v = 0) (hvg : g v = 1) :
    Nat.card {x : V // F x = s} =
      Nat.card K * Nat.card {x : V // F x = s ∧ g x = 0} := by
  calc
    _ = Nat.card (K × {x : V // F x = s ∧ g x = 0}) :=
      Nat.card_congr (fiberEquiv F g s v hvF hvg)
    _ = _ := Nat.card_prod _ _

theorem selected_fiber_card_factorization (F : V →ₗ[K] W) (g : V →ₗ[K] K)
    (s : W) (B : Finset K) (v : V) (hvF : F v = 0) (hvg : g v = 1) :
    Nat.card {x : V // F x = s ∧ g x ∈ B} =
      B.card * Nat.card {x : V // F x = s ∧ g x = 0} := by
  calc
    _ = Nat.card (↥B × {x : V // F x = s ∧ g x = 0}) :=
      Nat.card_congr (selectedFiberEquiv F g s B v hvF hvg)
    _ = _ := by rw [Nat.card_prod, Nat.card_eq_finsetCard]

/-- Exact uniformity on every fiber, including an empty fiber. -/
theorem uniform_fiber_count [Finite K] [Finite V]
    (F : V →ₗ[K] W) (g : V →ₗ[K] K)
    (hw : ∃ v : V, F v = 0 ∧ g v = 1) (s : W) (B : Finset K) :
    Nat.card K * Nat.card {x : V // F x = s ∧ g x ∈ B} =
      B.card * Nat.card {x : V // F x = s} := by
  obtain ⟨v, hvF, hvg⟩ := hw
  rw [selected_fiber_card_factorization F g s B v hvF hvg,
    fiber_card_factorization F g s v hvF hvg]
  ac_rfl

/-- Nonproportional forms admit a vector in `ker f` normalized to have `g` value one. -/
theorem exists_kernel_normalized_of_not_scalar_multiple
    (f g : V →ₗ[K] K) (hf : f ≠ 0)
    (hnon : ∀ c : K, g ≠ c • f) :
    ∃ v : V, f v = 0 ∧ g v = 1 := by
  classical
  obtain ⟨u, hu⟩ : ∃ u : V, f u ≠ 0 := by
    by_contra! h
    apply hf
    ext x
    exact h x
  let w : V := (f u)⁻¹ • u
  have hw : f w = 1 := by simp [w, map_smul, hu]
  obtain ⟨z, hfz, hgz⟩ : ∃ z : V, f z = 0 ∧ g z ≠ 0 := by
    by_contra! hker
    apply hnon (g w)
    ext x
    have hx : f (x - f x • w) = 0 := by simp [map_sub, map_smul, hw]
    have hzero := hker (x - f x • w) hx
    have heq : g x = f x * g w := by
      apply sub_eq_zero.mp
      simpa [map_sub, map_smul, smul_eq_mul] using hzero
    simpa [LinearMap.smul_apply, smul_eq_mul, mul_comm] using heq
  refine ⟨(g z)⁻¹ • z, ?_, ?_⟩
  · simp [map_smul, hfz]
  · simp [map_smul, hgz]

theorem nonparallel_forms_uniform_count [Finite K] [Finite V]
    (f g : V →ₗ[K] K) (hf : f ≠ 0)
    (hnon : ∀ c : K, g ≠ c • f) (s : K) (B : Finset K) :
    Nat.card K * Nat.card {x : V // f x = s ∧ g x ∈ B} =
      B.card * Nat.card {x : V // f x = s} := by
  exact uniform_fiber_count f g
    (exists_kernel_normalized_of_not_scalar_multiple f g hf hnon) s B

theorem constant_on_fiber (f g : V →ₗ[K] K) (c s : K)
    (hg : g = c • f) {x : V} (hx : f x = s) :
    g x = c * s := by
  simp [hg, LinearMap.smul_apply, hx, smul_eq_mul]

end PackingAudit
