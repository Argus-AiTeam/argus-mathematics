import Mathlib

noncomputable section

open scoped BigOperators

namespace LSBiquadratic

section Congruences

variable {R : Type*} [CommRing R]

def theta (a b : R) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) + (n 1 : R) * a + (n 2 : R) * b + (n 3 : R) * a * b

def sigmaTheta (a b : R) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) - (n 1 : R) * a + (n 2 : R) * b - (n 3 : R) * a * b

def sigmaTauTheta (a b : R) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) - (n 1 : R) * a - (n 2 : R) * b + (n 3 : R) * a * b

def signedTheta (a b : R) (s : ℤ) (n : Fin 4 → ℤ) : R :=
  (n 0 : R) - (n 1 : R) * a + (s : R) * (n 2 : R) * b -
    (s : R) * (n 3 : R) * a * b

@[simp] theorem signedTheta_one (a b : R) (n : Fin 4 → ℤ) :
    signedTheta a b 1 n = sigmaTheta a b n := by
  simp [signedTheta, sigmaTheta]

@[simp] theorem signedTheta_neg_one (a b : R) (n : Fin 4 → ℤ) :
    signedTheta a b (-1) n = sigmaTauTheta a b n := by
  simp [signedTheta, sigmaTauTheta, sub_eq_add_neg]

/-- Euler's criterion transferred along the canonical map from `ZMod p`. -/
theorem root_pow_eq_legendre_mul (p : ℕ) [Fact p.Prime] [CharP R p]
    (hp2 : p ≠ 2) (d : ℤ) (a : R) (ha : a ^ 2 = (d : R)) :
    a ^ p = (legendreSym p d : R) * a := by
  have hp : p.Prime := Fact.out
  have hpodd : p % 2 = 1 := hp.mod_two_eq_one_iff_ne_two.mpr hp2
  have hexp : p = 2 * (p / 2) + 1 := by omega
  have heuler : (d : R) ^ (p / 2) = (legendreSym p d : R) := by
    have h := congrArg (ZMod.castHom (dvd_refl p) R) (legendreSym.eq_pow p d)
    simpa only [map_intCast, map_pow] using h.symm
  calc
    a ^ p = (a ^ 2) ^ (p / 2) * a := by
      rw [← pow_mul, ← pow_succ, ← hexp]
    _ = (legendreSym p d : R) * a := by rw [ha, heuler]

theorem not_dvd_of_legendre_neg_one (p : ℕ) [Fact p.Prime] (d : ℤ)
    (hd : legendreSym p d = -1) : ¬(p : ℤ) ∣ d := by
  intro h
  have hz : (d : ZMod p) = 0 := (ZMod.intCast_zmod_eq_zero_iff_dvd d p).mpr h
  have hs := (legendreSym.eq_zero_iff p d).mpr hz
  omega

/-- In characteristic `p`, the generator equations determine Frobenius on every tuple. -/
theorem theta_pow_eq_signedTheta (p : ℕ) [Fact p.Prime] [CharP R p]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    theta a b n ^ p = signedTheta a b (legendreSym p 2) n := by
  have hap : a ^ p = -a := by
    simpa only [hd, Int.cast_neg, Int.cast_one, neg_one_mul] using
      root_pow_eq_legendre_mul p hp2 d a ha
  have hbp : b ^ p = (legendreSym p 2 : R) * b :=
    root_pow_eq_legendre_mul p hp2 2 b (by simpa using hb)
  have hcoeff (z : ℤ) : (z : R) ^ p = (z : R) := by
    exact map_intCast (frobenius R p) z
  simp only [theta, signedTheta, add_pow_char, mul_pow, hcoeff, hap, hbp]
  ring

/-- Divisibility in any commutative ring, including nonmaximal orders and trivial quotients. -/
theorem prime_dvd_theta_sub_signedTheta (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - signedTheta a b (legendreSym p 2) n := by
  let I : Ideal R := Ideal.span {(p : R)}
  let Q := R ⧸ I
  let π : R →+* Q := Ideal.Quotient.mk I
  apply (Ideal.Quotient.eq_zero_iff_dvd (p : R) _).mp
  change π (theta a b n ^ p - signedTheta a b (legendreSym p 2) n) = 0
  rcases subsingleton_or_nontrivial Q with hQ | hQ
  · letI := hQ
    exact Subsingleton.elim _ _
  · letI := hQ
    have hpzero : (p : Q) = 0 := by
      rw [← map_natCast π p]
      exact Ideal.Quotient.mk_singleton_self (p : R)
    letI : CharP Q p :=
      (CharP.charP_iff_prime_eq_zero (Fact.out : p.Prime)).mpr hpzero
    have hqa : (π a) ^ 2 = (d : Q) := by
      simpa only [map_pow, map_intCast] using congrArg π ha
    have hqb : (π b) ^ 2 = (2 : Q) := by
      simpa only [map_pow, map_ofNat] using congrArg π hb
    rw [map_sub, map_pow, sub_eq_zero]
    simpa only [theta, signedTheta, map_add, map_sub, map_mul, map_intCast] using
      theta_pow_eq_signedTheta p hp2 d (π a) (π b) hqa hqb hd n

theorem prime_dvd_theta_sub_sigmaTheta (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (h2 : legendreSym p 2 = 1) (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - sigmaTheta a b n := by
  simpa only [h2, signedTheta_one] using
    prime_dvd_theta_sub_signedTheta p hp2 d a b ha hb hd n

theorem prime_dvd_theta_sub_sigmaTauTheta (p : ℕ) [Fact p.Prime]
    (hp2 : p ≠ 2) (d : ℤ) (a b : R)
    (ha : a ^ 2 = (d : R)) (hb : b ^ 2 = (2 : R))
    (hd : legendreSym p d = -1) (h2 : legendreSym p 2 = -1) (n : Fin 4 → ℤ) :
    (p : R) ∣ theta a b n ^ p - sigmaTauTheta a b n := by
  simpa only [h2, signedTheta_neg_one] using
    prime_dvd_theta_sub_signedTheta p hp2 d a b ha hb hd n

theorem legendre_two_eq_one_or_neg_one (p : ℕ) [Fact p.Prime] (hp2 : p ≠ 2) :
    legendreSym p 2 = 1 ∨ legendreSym p 2 = -1 := by
  apply legendreSym.eq_one_or_neg_one
  have hp : p.Prime := Fact.out
  have hnot : ¬p ∣ 2 := by
    intro h
    exact hp2 ((Nat.prime_dvd_prime_iff_eq hp Nat.prime_two).mp h)
  intro hz
  exact hnot ((ZMod.natCast_eq_zero_iff 2 p).mp (by simpa using hz))

end Congruences

section Projection

def basisVector (a b : ℂ) : Fin 4 → ℂ := ![1, a, b, a * b]

def kernelVector (a b : ℂ) : Fin 4 → ℂ := ![a * b, b, -a, -1]

/-- The rows are `[1,a,b,ab]`, `[1,-a,b,-ab]`, and `[1,-a,-b,ab]`. -/
def conjugateProjection (a b : ℂ) : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 3 → ℂ) where
  toFun x := ![x 0 + a * x 1 + b * x 2 + a * b * x 3,
    x 0 - a * x 1 + b * x 2 - a * b * x 3,
    x 0 - a * x 1 - b * x 2 + a * b * x 3]
  map_add' x y := by
    ext i
    fin_cases i <;> simp <;> ring
  map_smul' t x := by
    ext i
    fin_cases i <;> simp [smul_eq_mul] <;> ring

theorem conjugateProjection_int (a b : ℂ) (n : Fin 4 → ℤ) :
    conjugateProjection a b (fun i => (n i : ℂ)) =
      ![theta a b n, sigmaTheta a b n, sigmaTauTheta a b n] := by
  ext i
  fin_cases i <;> simp [conjugateProjection, theta, sigmaTheta, sigmaTauTheta] <;> ring

theorem conjugateProjection_kernelVector (a b : ℂ) :
    conjugateProjection a b (kernelVector a b) = 0 := by
  ext i
  fin_cases i <;> simp [conjugateProjection, kernelVector] <;> ring

theorem conjugateProjection_surjective (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) :
    Function.Surjective (conjugateProjection a b) := by
  intro y
  refine ⟨![(y 0 + y 2) / 2, (y 0 - y 1) / (2 * a),
    (y 1 - y 2) / (2 * b), 0], ?_⟩
  ext i
  fin_cases i <;> simp [conjugateProjection] <;> field_simp [ha, hb] <;> ring

theorem conjugateProjection_eq_zero_iff (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (x : Fin 4 → ℂ) :
    conjugateProjection a b x = 0 ↔ ∃ t : ℂ, x = t • kernelVector a b := by
  constructor
  · intro hx
    have h0 : x 0 + a * x 1 + b * x 2 + a * b * x 3 = 0 :=
      congrFun hx 0
    have h1 : x 0 - a * x 1 + b * x 2 - a * b * x 3 = 0 :=
      congrFun hx 1
    have h2 : x 0 - a * x 1 - b * x 2 + a * b * x 3 = 0 :=
      congrFun hx 2
    have hx1 : x 1 + b * x 3 = 0 := by
      have h : a * (x 1 + b * x 3) = 0 := by
        linear_combination (1 / 2 : ℂ) * h0 - (1 / 2 : ℂ) * h1
      exact (mul_eq_zero.mp h).resolve_left ha
    have hx2 : x 2 - a * x 3 = 0 := by
      have h : b * (x 2 - a * x 3) = 0 := by
        linear_combination (1 / 2 : ℂ) * h1 - (1 / 2 : ℂ) * h2
      exact (mul_eq_zero.mp h).resolve_left hb
    have hx0 : x 0 + a * b * x 3 = 0 := by
      linear_combination h1 + a * hx1 - b * hx2
    refine ⟨-x 3, ?_⟩
    ext i
    fin_cases i <;> simp [kernelVector, smul_eq_mul]
    · linear_combination hx0
    · linear_combination hx1
    · linear_combination hx2
  · rintro ⟨t, rfl⟩
    simp [conjugateProjection_kernelVector]

theorem conjugateProjection_ker (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) :
    LinearMap.ker (conjugateProjection a b) = Submodule.span ℂ {kernelVector a b} := by
  ext x
  simp only [LinearMap.mem_ker, conjugateProjection_eq_zero_iff a b ha hb,
    Submodule.mem_span_singleton]
  constructor <;> rintro ⟨t, ht⟩ <;> exact ⟨t, ht.symm⟩

/-- This equivalence is only a signed reindexing; no number-field hypothesis is hidden. -/
theorem linearIndependent_kernelVector_iff (a b : ℂ) :
    LinearIndependent ℚ (kernelVector a b) ↔ LinearIndependent ℚ (basisVector a b) := by
  constructor
  · intro h
    have hr := h.comp Fin.rev Fin.rev_injective
    have hs := hr.units_smul (![-1, -1, 1, 1] : Fin 4 → ℚˣ)
    convert hs using 1
    ext i
    fin_cases i <;>
      norm_num [kernelVector, basisVector, Function.comp_def, Fin.rev, Pi.smul_apply,
        Units.smul_def]
  · intro h
    have hr := h.comp Fin.rev Fin.rev_injective
    have hs := hr.units_smul (![1, 1, -1, -1] : Fin 4 → ℚˣ)
    convert hs using 1
    ext i
    fin_cases i <;>
      norm_num [kernelVector, basisVector, Function.comp_def, Fin.rev, Pi.smul_apply,
        Units.smul_def]

theorem kernelVector_rationally_independent (a b : ℂ)
    (h : LinearIndependent ℚ (![1, a, b, a * b] : Fin 4 → ℂ)) :
    LinearIndependent ℚ (kernelVector a b) :=
  (linearIndependent_kernelVector_iff a b).mpr h

theorem explicit_projection_data (a b : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (h : LinearIndependent ℚ (![1, a, b, a * b] : Fin 4 → ℂ)) :
    Function.Surjective (conjugateProjection a b) ∧
      (∀ x, conjugateProjection a b x = 0 ↔ ∃ t : ℂ, x = t • kernelVector a b) ∧
      LinearIndependent ℚ (kernelVector a b) :=
  ⟨conjugateProjection_surjective a b ha hb,
    conjugateProjection_eq_zero_iff a b ha hb, kernelVector_rationally_independent a b h⟩

end Projection

end LSBiquadratic
