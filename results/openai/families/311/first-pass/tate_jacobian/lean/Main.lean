import Mathlib

set_option autoImplicit false

namespace TateJacobian

theorem frobenius_ignores_square_zero
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] [CharP R p]
    (a b : R) (hb : b ^ 2 = 0) :
    (a + b) ^ p = a ^ p := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hz : b ^ p = 0 := by
    calc
      b ^ p = b ^ (2 + (p - 2)) := by congr 1; omega
      _ = b ^ 2 * b ^ (p - 2) := pow_add b 2 (p - 2)
      _ = 0 := by rw [hb, zero_mul]
  rw [add_pow_char a b p, hz, add_zero]

theorem linearized_inseparable_polynomial
    {R I : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] [CharP R p]
    (S : Finset I) (a b : I → R) (k : I → ℕ)
    (e t s : R) (he : e ^ 2 = 0) :
    (∑ i ∈ S, (a i + e * b i) * (t + e * s) ^ (p * k i)) =
      (∑ i ∈ S, a i * t ^ (p * k i)) +
        e * (∑ i ∈ S, b i * t ^ (p * k i)) := by
  have hes : (e * s) ^ 2 = 0 := by rw [mul_pow, he, zero_mul]
  have hf : (t + e * s) ^ p = t ^ p :=
    frobenius_ignores_square_zero p t (e * s) hes
  have hk (i : I) : (t + e * s) ^ (p * k i) = t ^ (p * k i) := by
    simp only [pow_mul, hf]
  calc
    (∑ i ∈ S, (a i + e * b i) * (t + e * s) ^ (p * k i)) =
        ∑ i ∈ S, (a i * t ^ (p * k i) + e * (b i * t ^ (p * k i))) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [hk i]
      ring
    _ = (∑ i ∈ S, a i * t ^ (p * k i)) +
        e * (∑ i ∈ S, b i * t ^ (p * k i)) := by
      rw [Finset.sum_add_distrib, Finset.mul_sum]

theorem section_of_kernel_annihilation
    {E₁ E₂ G : Type*}
    [AddCommGroup E₁] [AddCommGroup E₂] [AddCommGroup G]
    (P : E₁ →+ E₂) (pi : G →+ E₂) (W : E₁ →+ G)
    (hP : Function.Surjective P) (hker : P.ker ≤ W.ker)
    (hquot : pi.comp W = P) :
    ∃! s : E₂ →+ G, s.comp P = W ∧ pi.comp s = AddMonoidHom.id E₂ := by
  classical
  let s : E₂ →+ G := P.liftOfSurjective hP ⟨W, hker⟩
  have hs : s.comp P = W :=
    AddMonoidHom.liftOfRightInverse_comp P (Function.surjInv hP)
      (Function.rightInverse_surjInv hP) ⟨W, hker⟩
  have hpi : pi.comp s = AddMonoidHom.id E₂ := by
    ext x
    obtain ⟨y, rfl⟩ := hP x
    have hsy : s (P y) = W y :=
      congrArg (fun f : E₁ →+ G => f y) hs
    have hqy : pi (W y) = P y :=
      congrArg (fun f : E₁ →+ E₂ => f y) hquot
    change pi (s (P y)) = P y
    rw [hsy, hqy]
  refine ⟨s, ⟨hs, hpi⟩, ?_⟩
  intro t ht
  ext x
  obtain ⟨y, rfl⟩ := hP x
  exact (congrArg (fun f : E₁ →+ G => f y) ht.1).trans
    (congrArg (fun f : E₁ →+ G => f y) hs).symm

theorem etale_block_det_ne_zero
    {K : Type*} [Field K] (a r : ℕ)
    (L : ((Fin a → K) × (Fin r → K)) →ₗ[K]
      ((Fin a → K) × (Fin r → K)))
    (hL : Function.Injective L)
    (M : Matrix (Fin r) (Fin r) K)
    (hconnected : ∀ v, (L (0, v)).1 = 0)
    (hetale : ∀ v, (L (0, v)).2 = M.mulVec v) :
    M.det ≠ 0 := by
  have hM : Function.Injective M.mulVec := by
    intro v w h
    have hpair : L (0, v) = L (0, w) := by
      apply Prod.ext
      · rw [hconnected v, hconnected w]
      · rw [hetale v, hetale w]
        exact h
    exact congrArg Prod.snd (hL hpair)
  exact ((Matrix.isUnit_iff_isUnit_det M).mp
    (Matrix.mulVec_injective_iff_isUnit.mp hM)).ne_zero

theorem det_ne_zero_from_trivial_deformation
    {K V : Type*} [Field K] [AddCommGroup V] [Module K V] (a r : ℕ)
    (KS : ((Fin a → K) × (Fin r → K)) →ₗ[K] V)
    (hKS : Function.Injective KS)
    (M : Matrix (Fin r) (Fin r) K)
    (htrivial : ∀ v, M.mulVec v = 0 → KS (0, v) = 0) :
    M.det ≠ 0 := by
  have hker : ∀ v, M.mulVec v = 0 → v = 0 := by
    intro v hv
    have hzero : KS (0, v) = KS 0 :=
      (htrivial v hv).trans KS.map_zero.symm
    exact congrArg Prod.snd (hKS hzero)
  have hM : Function.Injective M.mulVec := by
    intro v w h
    apply sub_eq_zero.mp
    apply hker
    rw [Matrix.mulVec_sub, h, sub_self]
  exact ((Matrix.isUnit_iff_isUnit_det M).mp
    (Matrix.mulVec_injective_iff_isUnit.mp hM)).ne_zero

#print axioms frobenius_ignores_square_zero
#print axioms linearized_inseparable_polynomial
#print axioms section_of_kernel_annihilation
#print axioms etale_block_det_ne_zero
#print axioms det_ne_zero_from_trivial_deformation

end TateJacobian
