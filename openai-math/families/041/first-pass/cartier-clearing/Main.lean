import Mathlib

namespace CartierClearing

section Adjoint

variable {K : Type*} [CommRing K] {ι J : Type*}

def applyWord (d : ι → Derivation ℤ K K) : List ι → K → K
  | [], x => x
  | i :: w, x => d i (applyWord d w x)

def adjointCoeff (d : ι → Derivation ℤ K K) : List ι → K → K
  | [], c => c
  | i :: w, c => adjointCoeff d w (-(d i c))

theorem integration_by_parts (d : ι → Derivation ℤ K K)
    (C : K →+ K) (hC : ∀ i x, C (d i x) = 0) (i : ι) (c x : K) :
    C (c * d i x) = C ((-(d i c)) * x) := by
  have h : C (c * d i x) + C (d i c * x) = 0 := by
    simpa only [Derivation.leibniz, smul_eq_mul, map_add, mul_comm x]
      using hC i (c * x)
  calc
    C (c * d i x) = -C (d i c * x) := eq_neg_of_add_eq_zero_left h
    _ = C ((-(d i c)) * x) := by simp

theorem word_adjoint (d : ι → Derivation ℤ K K)
    (C : K →+ K) (hC : ∀ i x, C (d i x) = 0)
    (w : List ι) (c x : K) :
    C (c * applyWord d w x) = C (adjointCoeff d w c * x) := by
  induction w generalizing c with
  | nil => rfl
  | cons i w ih =>
    exact (integration_by_parts d C hC i c (applyWord d w x)).trans
      (ih (-(d i c)))

theorem adjoint_mem (d : ι → Derivation ℤ K K) (A : Subring K)
    (hA : ∀ i x, x ∈ A → d i x ∈ A) (w : List ι) (c : K)
    (hc : c ∈ A) : adjointCoeff d w c ∈ A := by
  induction w generalizing c with
  | nil => exact hc
  | cons i w ih => exact ih _ (A.neg_mem (hA i c hc))

theorem field_clearing [Fintype J] (d : ι → Derivation ℤ K K)
    (C : K →+ K) (hC : ∀ i x, C (d i x) = 0)
    (s g : K) (t c : J → K) (w : J → List ι)
    (hidentity : s = ∑ j, c j * applyWord d (w j) (g * t j * s)) :
    C s = C (s * g * ∑ j, t j * adjointCoeff d (w j) (c j)) := by
  classical
  calc
    C s = ∑ j, C (c j * applyWord d (w j) (g * t j * s)) := by
      simpa only [map_sum] using congrArg C hidentity
    _ = ∑ j, C (adjointCoeff d (w j) (c j) * (g * t j * s)) := by
      apply Finset.sum_congr rfl
      intro j _
      exact word_adjoint d C hC (w j) (c j) (g * t j * s)
    _ = C (∑ j, adjointCoeff d (w j) (c j) * (g * t j * s)) := by
      rw [map_sum]
    _ = C (s * g * ∑ j, t j * adjointCoeff d (w j) (c j)) := by
      congr 1
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring

theorem subring_clearing [Fintype J] (d : ι → Derivation ℤ K K)
    (C : K →+ K) (hC : ∀ i x, C (d i x) = 0)
    (A R : Subring K) (hAR : A ≤ R)
    (hA : ∀ i x, x ∈ A → d i x ∈ A)
    (s : K) (g : R) (t : J → R) (c : J → A) (w : J → List ι)
    (ψ : R →+ R) (hψ : ∀ r : R, (ψ r : K) = C (s * (r : K)))
    (hidentity : s = ∑ j, (c j : K) *
      applyWord d (w j) ((g : K) * (t j : K) * s)) :
    ∃ T : R, (T : K) = ∑ j, (t j : K) * adjointCoeff d (w j) (c j : K) ∧
      ψ (g * T) = ψ 1 := by
  classical
  let a : J → R := fun j =>
    ⟨adjointCoeff d (w j) (c j : K),
      hAR (adjoint_mem d A hA (w j) (c j : K) (c j).property)⟩
  let T : R := ∑ j, t j * a j
  have hT : (T : K) =
      ∑ j, (t j : K) * adjointCoeff d (w j) (c j : K) := by
    simp [T, a]
  refine ⟨T, hT, ?_⟩
  apply Subtype.ext
  rw [hψ, hψ]
  simpa only [Subring.coe_mul, Subring.coe_one, mul_one, hT, mul_assoc]
    using (field_clearing d C hC s (g : K) (fun j => (t j : K))
      (fun j => (c j : K)) w hidentity).symm

end Adjoint

section PBasis

variable {K : Type*} [Field K] {p n : ℕ} [CharP K p]

def monomial (u : Fin n → K) (α : Fin n → Fin p) : K :=
  ∏ i, u i ^ (α i).val

def lower (α : Fin n → Fin p) (i : Fin n) : Fin n → Fin p :=
  Function.update α i
    ⟨(α i).val - 1, lt_of_le_of_lt (Nat.sub_le _ _) (α i).isLt⟩

structure PBasisCartier (K : Type*) [Field K] (p n : ℕ) [CharP K p] where
  coordinates : Fin n → K
  deriv : Fin n → Derivation ℤ K K
  deriv_coordinates : ∀ i j, deriv i (coordinates j) = if j = i then 1 else 0
  expansion : ∀ x : K, ∃ a : (Fin n → Fin p) → K,
    x = ∑ α, (a α) ^ p * monomial coordinates α
  cartier : K →+ K
  extraction : ∀ (a : K) (α : Fin n → Fin p),
    cartier (a ^ p * monomial coordinates α) =
      if (∀ i, (α i).val = p - 1) then a else 0

theorem derivation_prod_zero {ι : Type*} [DecidableEq ι]
    (D : Derivation ℤ K K) (f : ι → K) (S : Finset ι)
    (h : ∀ i ∈ S, D (f i) = 0) : D (∏ i ∈ S, f i) = 0 := by
  induction S using Finset.induction_on with
  | empty => simp
  | @insert i S hi ih =>
    rw [Finset.prod_insert hi, Derivation.leibniz]
    have hS : ∀ j ∈ S, D (f j) = 0 := fun j hj => h j (Finset.mem_insert_of_mem hj)
    simp [ih hS, h i (Finset.mem_insert_self i S)]

theorem monomial_derivative (B : PBasisCartier K p n)
    (i : Fin n) (α : Fin n → Fin p) :
    B.deriv i (monomial B.coordinates α) =
      (α i).val • monomial B.coordinates (lower α i) := by
  classical
  let f : Fin n → K := fun j => B.coordinates j ^ (α j).val
  have hprod :
      B.deriv i (∏ j ∈ Finset.univ.erase i, f j) = 0 := by
    apply derivation_prod_zero
    intro j hj
    have hji : j ≠ i := (Finset.mem_erase.mp hj).1
    simp [f, B.deriv_coordinates, hji]
  have hsplit : monomial B.coordinates α =
      f i * ∏ j ∈ Finset.univ.erase i, f j := by
    exact (Finset.mul_prod_erase Finset.univ f (Finset.mem_univ i)).symm
  have hsplitLower : monomial B.coordinates (lower α i) =
      B.coordinates i ^ ((α i).val - 1) *
        ∏ j ∈ Finset.univ.erase i, f j := by
    rw [monomial, ← Finset.mul_prod_erase Finset.univ
      (fun j => B.coordinates j ^ (lower α i j).val) (Finset.mem_univ i)]
    simp only [lower, Function.update_self]
    congr 1
    apply Finset.prod_congr rfl
    intro j hj
    have hji : j ≠ i := (Finset.mem_erase.mp hj).1
    simp [hji, f]
  rw [hsplit, Derivation.leibniz, hprod, smul_zero, zero_add, hsplitLower]
  simp [f, B.deriv_coordinates, smul_eq_mul, nsmul_eq_mul] <;> ring

theorem pth_power_derivative_zero (D : Derivation ℤ K K) (a : K) :
    D (a ^ p) = 0 := by
  simp [Derivation.leibniz_pow, nsmul_eq_mul]

theorem cartier_partial_zero (B : PBasisCartier K p n)
    (i : Fin n) (x : K) : B.cartier (B.deriv i x) = 0 := by
  classical
  obtain ⟨a, ha⟩ := B.expansion x
  rw [ha, map_sum, map_sum]
  apply Finset.sum_eq_zero
  intro α _
  have hterm : B.deriv i ((a α) ^ p * monomial B.coordinates α) =
      (α i).val • ((a α) ^ p * monomial B.coordinates (lower α i)) := by
    rw [Derivation.leibniz, pth_power_derivative_zero, smul_zero, add_zero,
      monomial_derivative]
    simp only [smul_eq_mul, nsmul_eq_mul]
    ring
  rw [hterm, map_nsmul]
  by_cases hzero : (α i).val = 0
  · simp [hzero]
  · have hnot : ¬∀ j, (lower α i j).val = p - 1 := by
      intro h
      have hi := h i
      simp only [lower, Function.update_self] at hi
      have hb := (α i).isLt
      omega
    rw [B.extraction, if_neg hnot]
    simp

theorem cartier_clearing [Fintype J] (B : PBasisCartier K p n)
    (A R : Subring K) (hAR : A ≤ R)
    (hA : ∀ i x, x ∈ A → B.deriv i x ∈ A)
    (s : K) (g : R) (t : J → R) (c : J → A) (w : J → List (Fin n))
    (ψ : R →+ R) (hψ : ∀ r : R, (ψ r : K) = B.cartier (s * (r : K)))
    (hidentity : s = ∑ j, (c j : K) *
      applyWord B.deriv (w j) ((g : K) * (t j : K) * s)) :
    ∃ T : R,
      (T : K) = ∑ j, (t j : K) * adjointCoeff B.deriv (w j) (c j : K) ∧
      ψ (g * T) = ψ 1 :=
  subring_clearing B.deriv B.cartier (cartier_partial_zero B)
    A R hAR hA s g t c w ψ hψ hidentity

theorem cartier_clearing_noncontainment [Fintype J] (B : PBasisCartier K p n)
    (A R : Subring K) (hAR : A ≤ R)
    (hA : ∀ i x, x ∈ A → B.deriv i x ∈ A)
    (s : K) (g : R) (t : J → R) (c : J → A) (w : J → List (Fin n))
    (ψ : R →+ R) (hψ : ∀ r : R, (ψ r : K) = B.cartier (s * (r : K)))
    (hidentity : s = ∑ j, (c j : K) *
      applyWord B.deriv (w j) ((g : K) * (t j : K) * s))
    (I : Ideal R) (hunit : ψ 1 ∉ I) :
    ¬∀ T : R, ψ (g * T) ∈ I := by
  obtain ⟨T, _, hT⟩ := cartier_clearing B A R hAR hA s g t c w ψ hψ hidentity
  intro h
  exact hunit (hT ▸ h T)

end PBasis

end CartierClearing

#print axioms CartierClearing.cartier_clearing
#print axioms CartierClearing.cartier_clearing_noncontainment
