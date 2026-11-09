import Mathlib

namespace ComplexEstimate

section Filtrations

variable {R : Type*} [CommRing R]
variable (M : ℕ → Type*) [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)]

def descend (d : ∀ i, M (i + 1) →ₗ[R] M i) (a : ℕ) :
    (n : ℕ) → M (a + n) →ₗ[R] M a
  | 0 => LinearMap.id
  | n + 1 => (descend d a n).comp (d (a + n))

theorem descend_mem
    (d : ∀ i, M (i + 1) →ₗ[R] M i)
    (fil : ∀ i, ℕ → Submodule R (M i))
    (low : ∀ i k (x : M (i + 1)),
      x ∈ fil (i + 1) (k + 1) → d i x ∈ fil i k)
    (a n k : ℕ) (x : M (a + n))
    (hx : x ∈ fil (a + n) (k + n)) :
    descend M d a n x ∈ fil a k := by
  induction n with
  | zero => simpa [descend] using hx
  | succ n ih =>
      have hy : d (a + n) x ∈ fil (a + n) (k + n) :=
        low (a + n) (k + n) x hx
      exact ih (d (a + n) x) hy

theorem descend_eq_zero
    (d : ∀ i, M (i + 1) →ₗ[R] M i)
    (fil : ∀ i, ℕ → Submodule R (M i))
    (low : ∀ i k (x : M (i + 1)),
      x ∈ fil (i + 1) (k + 1) → d i x ∈ fil i k)
    (n : ℕ) (bottom : ∀ i, fil i 0 = ⊥) (top : ∀ i, fil i n = ⊤)
    (a : ℕ) :
    descend M d a n = 0 := by
  ext x
  have hx : x ∈ fil (a + n) (0 + n) := by simp [top]
  have hy := descend_mem M d fil low a n 0 x hx
  simpa [bottom] using hy

end Filtrations

section Images

variable {R : Type*} [CommRing R]
variable {H BN BM T : Type*}
variable [AddCommGroup H] [Module R H]
variable [AddCommGroup BN] [Module R BN]
variable [AddCommGroup BM] [Module R BM]
variable [AddCommGroup T] [Module R T]

theorem stabilized_range
    (iN : H →ₗ[R] BN) (iM : H →ₗ[R] BM)
    (t : BN →ₗ[R] BM) (δ : BM →ₗ[R] T)
    (compatible : t.comp iN = iM)
    (exactM : LinearMap.range iM = LinearMap.ker δ)
    (dies : δ.comp t = 0) :
    LinearMap.range t = LinearMap.range iM := by
  apply le_antisymm
  · intro y hy
    rcases hy with ⟨x, rfl⟩
    rw [exactM]
    change δ (t x) = 0
    simpa using DFunLike.congr_fun dies x
  · intro y hy
    rcases hy with ⟨x, rfl⟩
    refine ⟨iN x, ?_⟩
    exact DFunLike.congr_fun compatible x

theorem stabilized_unique
    (iN : H →ₗ[R] BN) (iM : H →ₗ[R] BM)
    (t : BN →ₗ[R] BM) (δ : BM →ₗ[R] T)
    (compatible : t.comp iN = iM)
    (exactM : LinearMap.range iM = LinearMap.ker δ)
    (dies : δ.comp t = 0) (injective : Function.Injective iM)
    (y : BM) (hy : y ∈ LinearMap.range t) :
    ∃! x : H, iM x = y := by
  rw [stabilized_range iN iM t δ compatible exactM dies] at hy
  rcases hy with ⟨x, hx⟩
  exact ⟨x, hx, fun z hz => injective (hz.trans hx.symm)⟩

end Images

theorem normalize_error
    (length mu power lead rank0 error budget : ℝ)
    (hlead : 0 < lead) (hmu : 0 ≤ mu) (hpower : 0 ≤ power)
    (positive : 0 ≤ lead * (length - mu * power * rank0) + mu * power * error)
    (bounded : error ≤ lead * budget) :
    mu * power * (rank0 - budget) ≤ length := by
  have h := mul_le_mul_of_nonneg_left bounded (mul_nonneg hmu hpower)
  have h' := positive.trans
    (add_le_add (le_refl (lead * (length - mu * power * rank0))) h)
  apply (mul_le_mul_iff_right₀ hlead).mp
  nlinarith [h']

end ComplexEstimate
