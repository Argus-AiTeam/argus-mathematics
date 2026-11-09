import Mathlib

noncomputable section

open scoped BigOperators
open Finset Matrix

namespace LSChain

theorem interpolation_polynomial
    (N : ℕ) (hN : 1 ≤ N) (t : Fin 3 → ℕ)
    (ht : ∀ j, 3 * (N - 1) ≤ t j)
    (hdim : (4 * N - 3) ^ 4 < ∏ j, (t j - 3 * (N - 1) + 1))
    (A : LSRectInterpolation.C4 →ₗ[ℂ] LSRectInterpolation.C3)
    (hA : Function.Surjective A)
    (c : LSRectInterpolation.C4)
    (hker : ∀ x, A x = 0 ↔ ∃ z : ℂ, x = z • c)
    (hc : LinearIndependent ℚ c) (y : LSRectInterpolation.intBox N → ℂ) :
    ∃ p : LSRectInterpolation.Poly, (∀ j, p.degreeOf j ≤ t j) ∧
      ∀ n : LSRectInterpolation.intBox N,
        MvPolynomial.eval (A (LSRectInterpolation.castPoint n)) p = y n :=
  LSRectInterpolation.rectangular_interpolation_of_selection
    lattice_selection N hN t ht hdim A hA c hker hc y

theorem greedy_scalar_extension
    {K L : Type*} [Field K] [Field L] [Algebra K L]
    {ι : Type*} [LinearOrder ι] {n : ℕ} (row : ι → Fin n → K) :
    LSGenericGreedy.greedySet K row =
      LSGenericGreedy.greedySet L
        (fun i => LSScalarDescent.entryMap (L := L) (row i)) := by
  ext i
  exact not_congr (LSScalarDescent.earlier_span_descent (L := L) row i)

theorem concentration_from_capacity
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ)
    (hV : (N : ℝ) ≤ V) (hvol : (H : ℝ) * V ^ 3 = (N : ℝ) ^ 4)
    (S₁ S₂ : ℕ)
    (hpack : (N ^ 4) ^ 2 ≤ 4 * (weightBound H V / H + 1) ^ 2 * S₁)
    (hsmall : S₂ ≤ 2 * (weightBound H V / H) * N ^ 4) :
    (N : ℝ) ^ 4 * (H : ℝ) * V / (4 * 97 ^ 2) ≤ (S₁ : ℝ) ∧
      (S₂ : ℝ) ≤ 192 * (N : ℝ) ^ 4 * V := by
  have hNr : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hVp : 0 < V := by linarith
  have hB := coordinate_capacity_bound N H hN hH V hV
  have hpackr :
      ((N : ℝ) ^ 4) ^ 2 ≤
        4 * (((weightBound H V / H + 1) ^ 2 : ℕ) : ℝ) * (S₁ : ℝ) := by
    exact_mod_cast hpack
  have hpack' : ((N : ℝ) ^ 4) ^ 2 ≤ 4 * 97 ^ 2 * V ^ 2 * (S₁ : ℝ) := by
    have hh := mul_le_mul_of_nonneg_right hB.2 (by positivity : 0 ≤ 4 * (S₁ : ℝ))
    nlinarith
  have hcancel :
      ((N : ℝ) ^ 4 * (H : ℝ) * V) * V ^ 2 ≤
        (4 * 97 ^ 2 * (S₁ : ℝ)) * V ^ 2 := by
    calc
      ((N : ℝ) ^ 4 * (H : ℝ) * V) * V ^ 2 = ((N : ℝ) ^ 4) ^ 2 := by
        rw [← hvol]
        ring
      _ ≤ _ := by nlinarith [hpack']
  have hraw := le_of_mul_le_mul_right hcancel (sq_pos_of_pos hVp)
  refine ⟨(div_le_iff₀ (by norm_num : (0 : ℝ) < 4 * 97 ^ 2)).mpr ?_, ?_⟩
  · nlinarith [hraw]
  · have hs : (S₂ : ℝ) ≤
        2 * ((weightBound H V / H : ℕ) : ℝ) * (N : ℝ) ^ 4 := by
      exact_mod_cast hsmall
    have hb := mul_le_mul_of_nonneg_right hB.1
      (by positivity : 0 ≤ 2 * (N : ℝ) ^ 4)
    nlinarith

theorem manuscript_construction
    {R : Type*} [CommRing R] (f : R →+* ℂ) (hf : Function.Injective f)
    (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N)
    [LinearOrder (Candidate H (weightBound H (manuscriptScale N H)))]
    (horder : ∀ a b : Candidate H (weightBound H (manuscriptScale N H)),
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (A : LSRectInterpolation.C4 →ₗ[ℂ] LSRectInterpolation.C3)
    (hA : Function.Surjective A)
    (c : LSRectInterpolation.C4)
    (hker : ∀ x, A x = 0 ↔ ∃ z : ℂ, x = z • c)
    (hc : LinearIndependent ℚ c)
    (coordinates : LSRectInterpolation.intBox N → Fin 3 → R)
    (hcoordinates : ∀ n j, f (coordinates n j) =
      A (LSRectInterpolation.castPoint n) j)
    (P : Finset ℕ) (side : ℕ → Bool)
    (hp : ∀ p ∈ P, H < p)
    (hfrob : ∀ p ∈ P, ∀ n,
      (p : R) ∣ coordinates n 0 ^ p - target (coordinates n) (side p))
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * manuscriptScale N H) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H (weightBound H (manuscriptScale N H)),
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun a j => f (candidateRow (fun j => coordinates (gridEnumeration N j)) a j)) ∧
      (retainedMatrix (fun j => coordinates (gridEnumeration N j)) g).det ≠ 0 ∧
      (∀ i, (weight H (candidateExponent (g i)) : ℝ) ≤
        96 * (H : ℝ) * manuscriptScale N H) ∧
      (∀ p ∈ P, (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p) ∣
        (retainedMatrix (fun j => coordinates (gridEnumeration N j)) g).det) ∧
      ((N : ℝ) ^ 4 * (H : ℝ) * manuscriptScale N H / (4 * 97 ^ 2) ≤
        ((∑ i : Fin (N ^ 4), candidateExponent (g i) 0) : ℝ)) ∧
      (((∑ i : Fin (N ^ 4),
          (candidateExponent (g i) 1 + candidateExponent (g i) 2)) : ℕ) : ℝ) ≤
        192 * (N : ℝ) ^ 4 * manuscriptScale N H := by
  have hN : 1 ≤ N := hH.trans hHN
  have hs := manuscript_scale_properties N H hH hHN
  have hb := rectangle_budget N H hN hH (manuscriptScale N H) hs.1 hs.2
  obtain ⟨g, hgreedy, hdet, hw, hdiv, hpack, hsmall⟩ :=
    constructed_core f hf N hN H (weightBound H (manuscriptScale N H)) hH
      horder (rectangleDegrees H (manuscriptScale N H)) hb.1 hb.2.1 hb.2.2
      (capacity_threshold N H hN hH (manuscriptScale N H) hs.1 hs.2 hthreshold)
      A hA c hker hc coordinates hcoordinates P side hp hfrob
  have hconc := concentration_from_capacity N H hN hH (manuscriptScale N H) hs.1 hs.2
    _ _ hpack hsmall
  refine ⟨g, hgreedy, hdet, ?_, hdiv, ?_, hconc.2⟩
  · intro i
    have hwr : (weight H (candidateExponent (g i)) : ℝ) ≤
        weightBound H (manuscriptScale N H) := by exact_mod_cast hw i
    exact hwr.trans (Nat.floor_le (by
      have hpos : 0 < manuscriptScale N H :=
        lt_of_lt_of_le (by exact_mod_cast (show 0 < N by omega)) hs.1
      positivity))
  · simpa only [Nat.cast_sum] using hconc.1

def biquadraticCoordinates {R : Type*} [CommRing R] (a b : R)
    (n : Fin 4 → ℤ) : Fin 3 → R :=
  ![LSBiquadratic.theta a b n, LSBiquadratic.sigmaTheta a b n,
    LSBiquadratic.sigmaTauTheta a b n]

theorem biquadratic_coordinates_map
    {R : Type*} [CommRing R] (f : R →+* ℂ) (a b : R)
    (n : Fin 4 → ℤ) (j : Fin 3) :
    f (biquadraticCoordinates a b n j) =
      LSBiquadratic.conjugateProjection (f a) (f b) (fun i => (n i : ℂ)) j := by
  rw [LSBiquadratic.conjugateProjection_int]
  fin_cases j <;>
    simp [biquadraticCoordinates, LSBiquadratic.theta, LSBiquadratic.sigmaTheta,
      LSBiquadratic.sigmaTauTheta]

def primeSymbol (p : ℕ) (d : ℤ) : ℤ :=
  if hp : p.Prime then @legendreSym p ⟨hp⟩ d else 0

def frobeniusSide (p : ℕ) : Bool := decide (primeSymbol p 2 = 1)

theorem biquadratic_frobenius
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] (hp2 : p ≠ 2)
    (d : ℤ) (a b : R) (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    (p : R) ∣ biquadraticCoordinates a b n 0 ^ p -
      target (biquadraticCoordinates a b n) (frobeniusSide p) := by
  rcases LSBiquadratic.legendre_two_eq_one_or_neg_one p hp2 with h2 | h2
  · simpa [biquadraticCoordinates, target, frobeniusSide, primeSymbol,
      (Fact.out : p.Prime), h2] using
      LSBiquadratic.prime_dvd_theta_sub_sigmaTheta p hp2 d a b ha hb hd h2 n
  · simpa [biquadraticCoordinates, target, frobeniusSide, primeSymbol,
      (Fact.out : p.Prime), h2] using
      LSBiquadratic.prime_dvd_theta_sub_sigmaTauTheta p hp2 d a b ha hb hd h2 n

theorem simultaneous_prime_powers
    {R : Type*} [CommRing R] (P : Finset ℕ) (E : ℕ → ℕ) (z : R)
    (hprime : ∀ p ∈ P, p.Prime)
    (hdiv : ∀ p ∈ P, (p : R) ^ E p ∣ z) :
    (∏ p ∈ P, (p : R) ^ E p) ∣ z := by
  apply UniformDeterminant.simultaneous_coprime_factors P (fun p => (p : R) ^ E p) z
    _ hdiv
  intro p hp q hq hne
  apply IsCoprime.pow
  apply Nat.Coprime.cast
  exact (hprime p hp).coprime_iff_not_dvd.mpr
    (fun hd => hne ((Nat.prime_dvd_prime_iff_eq (hprime p hp) (hprime q hq)).mp hd))

theorem biquadratic_manuscript_chain
    {R : Type*} [CommRing R] (f : R →+* ℂ) (hf : Function.Injective f)
    (d : ℤ) (a b : R) (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hdegree : LinearIndependent ℚ (LSBiquadratic.basisVector (f a) (f b)))
    (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N)
    [LinearOrder (Candidate H (weightBound H (manuscriptScale N H)))]
    (horder : ∀ a b : Candidate H (weightBound H (manuscriptScale N H)),
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (P : Finset ℕ)
    (hprime : ∀ p ∈ P, p.Prime)
    (hp2 : ∀ p ∈ P, p ≠ 2)
    (hpH : ∀ p ∈ P, H < p)
    (hd : ∀ p ∈ P, primeSymbol p d = -1)
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * manuscriptScale N H) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H (weightBound H (manuscriptScale N H)),
      let Δ := (retainedMatrix
        (fun j => biquadraticCoordinates a b (gridEnumeration N j)) g).det
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun α j => f (candidateRow
          (fun j => biquadraticCoordinates a b (gridEnumeration N j)) α j)) ∧
      Δ ≠ 0 ∧
      (∀ i, (weight H (candidateExponent (g i)) : ℝ) ≤
        96 * (H : ℝ) * manuscriptScale N H) ∧
      ((∏ p ∈ P, (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p)) ∣ Δ) ∧
      ((N : ℝ) ^ 4 * (H : ℝ) * manuscriptScale N H / (4 * 97 ^ 2) ≤
        ((∑ i : Fin (N ^ 4), candidateExponent (g i) 0) : ℝ)) ∧
      (((∑ i : Fin (N ^ 4),
          (candidateExponent (g i) 1 + candidateExponent (g i) 2)) : ℕ) : ℝ) ≤
        192 * (N : ℝ) ^ 4 * manuscriptScale N H := by
  have ha0 : f a ≠ 0 := by
    simpa [LSBiquadratic.basisVector] using hdegree.ne_zero 1
  have hb0 : f b ≠ 0 := by
    simpa [LSBiquadratic.basisVector] using hdegree.ne_zero 2
  have hdata := LSBiquadratic.explicit_projection_data (f a) (f b) ha0 hb0 hdegree
  obtain ⟨g, hgreedy, hdet, hw, hdiv, hS₁, hS₂⟩ :=
    manuscript_construction f hf N H hH hHN horder
      (LSBiquadratic.conjugateProjection (f a) (f b)) hdata.1
      (LSBiquadratic.kernelVector (f a) (f b)) hdata.2.1 hdata.2.2
      (fun n => biquadraticCoordinates a b n)
      (fun n j => biquadratic_coordinates_map f a b n j)
      P frobeniusSide hpH (by
        intro p hp n
        letI : Fact p.Prime := ⟨hprime p hp⟩
        have hdp : legendreSym p d = -1 := by
          simpa [primeSymbol, hprime p hp] using hd p hp
        exact biquadratic_frobenius p (hp2 p hp) d a b ha hb hdp n)
      hthreshold
  exact ⟨g, hgreedy, hdet, hw, simultaneous_prime_powers P _ _ hprime hdiv, hS₁, hS₂⟩

theorem simultaneous_integral_norm
    {R : Type*} [CommRing R] [IsDomain R]
    (basis : Module.Basis (Fin 4) ℤ R)
    (P : Finset ℕ) (E : ℕ → ℕ) (z : R) (hz : z ≠ 0)
    (hprime : ∀ p ∈ P, p.Prime)
    (hdiv : ∀ p ∈ P, (p : R) ^ E p ∣ z) :
    Algebra.norm ℤ z ≠ 0 ∧
      (∏ p ∈ P, (p : ℤ) ^ (4 * E p)) ∣ Algebra.norm ℤ z := by
  refine ⟨(Algebra.norm_ne_zero_iff_of_basis basis).mpr hz, ?_⟩
  apply simultaneous_prime_powers P (fun p => 4 * E p) _ hprime
  intro p hp
  obtain ⟨w, hw⟩ := hdiv p hp
  refine ⟨Algebra.norm ℤ w, ?_⟩
  rw [hw, map_mul, map_pow]
  have hnorm : Algebra.norm ℤ (p : R) = (p : ℤ) ^ 4 := by
    simpa using Algebra.norm_algebraMap_of_basis basis (p : ℤ)
  rw [hnorm, ← pow_mul]

theorem full_chain
    {R : Type*} [CommRing R] [IsDomain R]
    (basis : Module.Basis (Fin 4) ℤ R)
    (f : R →+* ℂ) (hf : Function.Injective f)
    (d : ℤ) (a b : R) (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hdegree : LinearIndependent ℚ (LSBiquadratic.basisVector (f a) (f b)))
    (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N)
    [LinearOrder (Candidate H (weightBound H (manuscriptScale N H)))]
    (horder : ∀ a b : Candidate H (weightBound H (manuscriptScale N H)),
      weight H (candidateExponent a) < weight H (candidateExponent b) → a < b)
    (P : Finset ℕ) (hprime : ∀ p ∈ P, p.Prime)
    (hp2 : ∀ p ∈ P, p ≠ 2) (hpH : ∀ p ∈ P, H < p)
    (hd : ∀ p ∈ P, primeSymbol p d = -1)
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * manuscriptScale N H) :
    ∃ g : Fin (N ^ 4) ↪o Candidate H (weightBound H (manuscriptScale N H)),
      let Δ := (retainedMatrix
        (fun j => biquadraticCoordinates a b (gridEnumeration N j)) g).det
      Set.range g = LSGenericGreedy.greedySet ℂ
        (fun α j => f (candidateRow
          (fun j => biquadraticCoordinates a b (gridEnumeration N j)) α j)) ∧
      Δ ≠ 0 ∧
      (∀ i, (weight H (candidateExponent (g i)) : ℝ) ≤
        96 * (H : ℝ) * manuscriptScale N H) ∧
      ((∏ p ∈ P, (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p)) ∣ Δ) ∧
      ((N : ℝ) ^ 4 * (H : ℝ) * manuscriptScale N H / (4 * 97 ^ 2) ≤
        ((∑ i : Fin (N ^ 4), candidateExponent (g i) 0) : ℝ)) ∧
      ((((∑ i : Fin (N ^ 4),
          (candidateExponent (g i) 1 + candidateExponent (g i) 2)) : ℕ) : ℝ) ≤
        192 * (N : ℝ) ^ 4 * manuscriptScale N H) ∧
      Algebra.norm ℤ Δ ≠ 0 ∧
      (∏ p ∈ P, (p : ℤ) ^
        (4 * ∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p)) ∣ Algebra.norm ℤ Δ := by
  obtain ⟨g, hgreedy, hdet, hw, hprod, hS₁, hS₂⟩ :=
    biquadratic_manuscript_chain f hf d a b ha hb hdegree
      N H hH hHN horder P hprime hp2 hpH hd hthreshold
  have hdiv : ∀ p ∈ P,
      (p : R) ^ (∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p) ∣
        (retainedMatrix (fun j => biquadraticCoordinates a b (gridEnumeration N j)) g).det :=
    fun p hp => (Finset.dvd_prod_of_mem _ hp).trans hprod
  have hnorm := simultaneous_integral_norm basis P
    (fun p => ∑ i : Fin (N ^ 4), candidateExponent (g i) 0 / p) _ hdet hprime hdiv
  exact ⟨g, hgreedy, hdet, hw, hprod, hS₁, hS₂, hnorm.1, hnorm.2⟩

end LSChain

#print axioms LSChain.interpolation_polynomial
#print axioms LSChain.constructed_core
#print axioms LSChain.greedy_scalar_extension
#print axioms LSChain.biquadratic_manuscript_chain
#print axioms LSChain.full_chain
