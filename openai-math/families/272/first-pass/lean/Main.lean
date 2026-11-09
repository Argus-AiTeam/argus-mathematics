import Mathlib

open scoped BigOperators Matrix
open Matrix

namespace DimensionTenCertificate

theorem full_spark_over_extension
    {F K N T : Type*} [Field F] [Field K] [Fintype N] [DecidableEq N]
    (E : Matrix T N F) (base : N → T)
    (hbase : (E.submatrix base id).det ≠ 0)
    (hcover : ∀ r : N → T, Function.Injective r →
      ∃ s : F ≃+* F, ∀ i j, s (E (base i) j) = E (r i) j)
    (embedding : F →+* K) (r : N → T) (hr : Function.Injective r) :
    (embedding.mapMatrix (E.submatrix r id)).det ≠ 0 := by
  obtain ⟨s, hs⟩ := hcover r hr
  have hm : s.mapMatrix (E.submatrix base id) = E.submatrix r id := by
    ext i j
    exact hs i j
  have htarget : (E.submatrix r id).det ≠ 0 := by
    intro hz
    apply hbase
    apply s.injective
    simpa only [s.map_det, hm, map_zero] using hz
  intro hz
  apply htarget
  apply embedding.injective
  simpa only [embedding.map_det, map_zero] using hz

def tensor {K I : Type*} [Mul K] (u v : I → K) : I × I → K :=
  fun ij => u ij.1 * v ij.2

theorem tensor_dot {K I : Type*} [CommSemiring K] [Fintype I]
    (a b u v : I → K) :
    tensor a b ⬝ᵥ tensor u v = (a ⬝ᵥ u) * (b ⬝ᵥ v) := by
  classical
  simp only [dotProduct, tensor, Fintype.sum_prod_type]
  rw [Finset.sum_mul]
  simp_rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  ring

theorem product_free_of_kernel_bound
    {K I T : Type*} [Field K] [DecidableEq K]
    [Fintype I] [Fintype T] [DecidableEq T]
    (E : Matrix T I K) (Z : Matrix (I × I) (I × I) K) (bound : ℕ)
    (hsize : 2 * bound < Fintype.card T)
    (hsym : Z.transpose = Z)
    (hkernel : ∀ t, Z *ᵥ tensor (E t) (E t) = 0)
    (hbound : ∀ u : I → K, u ≠ 0 →
      (Finset.univ.filter fun t => E t ⬝ᵥ u = 0).card ≤ bound)
    (u v : I → K) (w : I × I → K)
    (hw : Z *ᵥ w = tensor u v) : u = 0 ∨ v = 0 := by
  classical
  by_contra hnonzero
  push Not at hnonzero
  let zerosU := Finset.univ.filter fun t => E t ⬝ᵥ u = 0
  let zerosV := Finset.univ.filter fun t => E t ⬝ᵥ v = 0
  have hu : zerosU.card ≤ bound := hbound u hnonzero.1
  have hv : zerosV.card ≤ bound := hbound v hnonzero.2
  have hcover : (Finset.univ : Finset T) ⊆ zerosU ∪ zerosV := by
    intro t _
    have hpair : tensor (E t) (E t) ⬝ᵥ (Z *ᵥ w) = 0 := by
      have h := Matrix.dotProduct_transpose_mulVec Z (tensor (E t) (E t)) w
      rw [hsym, hkernel t] at h
      simpa only [dotProduct_zero] using h
    rw [hw, tensor_dot] at hpair
    rcases mul_eq_zero.mp hpair with hleft | hright
    · exact Finset.mem_union.mpr (Or.inl (by simp [zerosU, hleft]))
    · exact Finset.mem_union.mpr (Or.inr (by simp [zerosV, hright]))
  have hcard : Fintype.card T ≤ zerosU.card + zerosV.card := by
    calc
      Fintype.card T = (Finset.univ : Finset T).card := by simp
      _ ≤ (zerosU ∪ zerosV).card := Finset.card_le_card hcover
      _ ≤ zerosU.card + zerosV.card := Finset.card_union_le _ _
  omega

theorem zero_bound_of_full_spark
    {K : Type*} [Field K] [DecidableEq K] (E : Matrix (Fin 20) (Fin 10) K)
    (hfull : ∀ r : Fin 10 → Fin 20, Function.Injective r →
      (E.submatrix r id).det ≠ 0)
    (u : Fin 10 → K) (hu : u ≠ 0) :
    (Finset.univ.filter fun t => E t ⬝ᵥ u = 0).card ≤ 9 := by
  classical
  by_contra hcard
  have hten : Fintype.card (Fin 10) ≤
      (Finset.univ.filter fun t => E t ⬝ᵥ u = 0).card := by
    simpa only [Fintype.card_fin] using (show 10 ≤
      (Finset.univ.filter fun t => E t ⬝ᵥ u = 0).card by omega)
  obtain ⟨r, hrange⟩ := Function.Embedding.exists_of_card_le_finset hten
  have hzero : (E.submatrix r id) *ᵥ u = 0 := by
    ext i
    have hmem := hrange (show r i ∈ Set.range r from ⟨i, rfl⟩)
    exact (Finset.mem_filter.mp hmem).2
  exact hu (Matrix.eq_zero_of_mulVec_eq_zero (hfull r r.injective) hzero)

theorem dimensionTen_from_galois_equivariance
    {F K : Type*} [Field F] [Field K]
    (E : Matrix (Fin 20) (Fin 10) F) (base : Fin 10 → Fin 20)
    (hbase : (E.submatrix base id).det ≠ 0)
    (hcover : ∀ r : Fin 10 → Fin 20, Function.Injective r →
      ∃ s : F ≃+* F, ∀ i j, s (E (base i) j) = E (r i) j)
    (embedding : F →+* K)
    (Z : Matrix (Fin 10 × Fin 10) (Fin 10 × Fin 10) K)
    (hsym : Z.transpose = Z)
    (hkernel : ∀ t, Z *ᵥ tensor (E.map embedding t)
      (E.map embedding t) = 0)
    (u v : Fin 10 → K) (w : Fin 10 × Fin 10 → K)
    (hw : Z *ᵥ w = tensor u v) : u = 0 ∨ v = 0 := by
  classical
  have hfull : ∀ r : Fin 10 → Fin 20, Function.Injective r →
      ((E.map embedding).submatrix r id).det ≠ 0 := by
    intro r hr
    exact full_spark_over_extension E base hbase hcover embedding r hr
  exact product_free_of_kernel_bound (E.map embedding) Z 9 (by decide)
    hsym hkernel (zero_bound_of_full_spark _ hfull) u v w hw

end DimensionTenCertificate
