import Mathlib.NumberTheory.FLT.MasonStothers
import Mathlib.FieldTheory.RatFunc.Degree
import Mathlib.Tactic

namespace Rigidity047

open Polynomial UniqueFactorizationMonoid
open scoped Classical

theorem determinant_coefficients {R : Type*} [CommRing R]
    (a d b c x y : R) (hdet : a * c - b * d = 1) (hrel : a * y = d * x) :
    a * (c * x - b * y) = x ∧ d * (c * x - b * y) = y := by
  constructor
  · linear_combination x * hdet - b * hrel
  · linear_combination y * hdet - c * hrel

theorem ratFunc_neg_X_cube_not_square (F : Type*) [Field F] :
    ¬ IsSquare (-(RatFunc.X : RatFunc F) ^ 3) := by
  rintro ⟨r, hr⟩
  have hx : (RatFunc.X : RatFunc F) ≠ 0 := RatFunc.X_ne_zero
  have hr0 : r ≠ 0 := by
    intro h
    have : -(RatFunc.X : RatFunc F) ^ 3 = 0 := by simpa [h] using hr
    exact (neg_ne_zero.mpr (pow_ne_zero 3 hx)) this
  have hcube : ((RatFunc.X : RatFunc F) ^ 3).intDegree = 3 := by
    rw [show (RatFunc.X : RatFunc F) ^ 3 =
      (RatFunc.X * RatFunc.X) * RatFunc.X by ring,
      RatFunc.intDegree_mul (mul_ne_zero hx hx) hx, RatFunc.intDegree_mul hx hx]
    norm_num
  have hd : (3 : ℤ) = r.intDegree + r.intDegree := by
    calc
      3 = (-(RatFunc.X : RatFunc F) ^ 3).intDegree := by
        rw [RatFunc.intDegree_neg, hcube]
      _ = r.intDegree + r.intDegree := by rw [hr, RatFunc.intDegree_mul hr0 hr0]
  omega

section PolynomialOrbit

variable {K : Type*} [Field K]

theorem low_degree_coprime (A D U : K[X]) (hD : D ≠ 0)
    (hN : D ^ 2 + A ^ 2 * U ^ 3 ≠ 0)
    (hdeg : (D ^ 2 + A ^ 2 * U ^ 3).natDegree ≤ 1) :
    IsCoprime D (A * U) := by
  classical
  let g := EuclideanDomain.gcd D (A * U)
  have hgD : g ∣ D := EuclideanDomain.gcd_dvd_left _ _
  have hgAU : g ∣ A * U := EuclideanDomain.gcd_dvd_right _ _
  have hgsq : g ^ 2 ∣ D ^ 2 + A ^ 2 * U ^ 3 := by
    apply dvd_add (pow_dvd_pow_of_dvd hgD 2)
    have h := dvd_mul_of_dvd_left (pow_dvd_pow_of_dvd hgAU 2) U
    convert h using 1
    ring
  have hgdeg := Polynomial.natDegree_le_of_dvd hgsq hN
  rw [Polynomial.natDegree_pow] at hgdeg
  have hgzero : g.natDegree = 0 := by omega
  have hgnz : g ≠ 0 := by
    intro h
    exact hD (zero_dvd_iff.mp (h ▸ hgD))
  apply EuclideanDomain.gcd_isUnit_iff.mp
  apply Polynomial.isUnit_iff_degree_eq_zero.mpr
  rw [Polynomial.degree_eq_natDegree hgnz, hgzero]
  rfl

theorem radical_mul_degree_le (P Q : K[X]) :
    (radical (P * Q)).natDegree ≤
      (radical P).natDegree + (radical Q).natDegree := by
  classical
  calc
    _ ≤ (radical P * radical Q).natDegree :=
      Polynomial.natDegree_le_of_dvd radical_mul_dvd
        (mul_ne_zero radical_ne_zero radical_ne_zero)
    _ = _ := Polynomial.natDegree_mul radical_ne_zero radical_ne_zero

theorem orbit_radical_degree_le (A D U N : K[X]) :
    (radical (D ^ 2 * (A ^ 2 * U ^ 3) * (-N))).natDegree ≤
      D.natDegree + A.natDegree + U.natDegree + N.natDegree := by
  classical
  have h₁ := radical_mul_degree_le (D ^ 2 * (A ^ 2 * U ^ 3)) (-N)
  have h₂ := radical_mul_degree_le (D ^ 2) (A ^ 2 * U ^ 3)
  have h₃ := radical_mul_degree_le (A ^ 2) (U ^ 3)
  rw [UniqueFactorizationDomain.radical_neg] at h₁
  rw [radical_pow D (by decide)] at h₂
  rw [radical_pow A (by decide), radical_pow U (by decide)] at h₃
  have hD := natDegree_radical_le (a := D)
  have hA := natDegree_radical_le (a := A)
  have hU := natDegree_radical_le (a := U)
  have hN := natDegree_radical_le (a := N)
  omega

theorem orbit_polynomials_constant [CharZero K]
    (A D U : K[X]) (u0 : K)
    (hA : A ≠ 0) (hD : D ≠ 0) (hU : U ≠ 0)
    (hU0 : U.eval 0 = u0) (hns : ¬ IsSquare (-u0 ^ 3))
    (hN : D ^ 2 + A ^ 2 * U ^ 3 ≠ 0)
    (hdeg : (D ^ 2 + A ^ 2 * U ^ 3).natDegree ≤ 1) :
    A.natDegree = 0 ∧ D.natDegree = 0 ∧ U.natDegree = 0 := by
  classical
  have hD2 : D ^ 2 ≠ 0 := pow_ne_zero 2 hD
  have hA2U3 : A ^ 2 * U ^ 3 ≠ 0 :=
    mul_ne_zero (pow_ne_zero 2 hA) (pow_ne_zero 3 hU)
  have hc := low_degree_coprime A D U hD hN hdeg
  have hcoprime : IsCoprime (D ^ 2) (A ^ 2 * U ^ 3) :=
    hc.of_mul_right_left.pow.mul_right hc.of_mul_right_right.pow
  have hsum : D ^ 2 + A ^ 2 * U ^ 3 + (-(D ^ 2 + A ^ 2 * U ^ 3)) = 0 := by ring
  rcases Polynomial.abc hD2 hA2U3 (neg_ne_zero.mpr hN) hcoprime hsum with habc | hder
  · have hrad := orbit_radical_degree_le A D U (D ^ 2 + A ^ 2 * U ^ 3)
    have hd := habc.1.trans hrad
    have hau := habc.2.1.trans hrad
    rw [Polynomial.natDegree_pow] at hd
    rw [Polynomial.natDegree_mul (pow_ne_zero 2 hA) (pow_ne_zero 3 hU),
      Polynomial.natDegree_pow, Polynomial.natDegree_pow] at hau
    have hu : U.natDegree = 0 := by omega
    have hda : D.natDegree = A.natDegree := by omega
    have hUc : U = C u0 := by
      have h := Polynomial.eq_C_of_natDegree_eq_zero hu
      rw [← Polynomial.coeff_zero_eq_eval_zero] at hU0
      exact h.trans (congrArg C hU0)
    have hlc :
        (D ^ 2).leadingCoeff + (A ^ 2 * U ^ 3).leadingCoeff ≠ 0 := by
      rw [Polynomial.leadingCoeff_pow, Polynomial.leadingCoeff_mul,
        Polynomial.leadingCoeff_pow, Polynomial.leadingCoeff_pow, hUc,
        Polynomial.leadingCoeff_C]
      intro hz
      apply hns
      apply (isSquare_iff_exists_sq _).mpr
      refine ⟨D.leadingCoeff / A.leadingCoeff, ?_⟩
      rw [div_pow, eq_div_iff (pow_ne_zero 2 (Polynomial.leadingCoeff_ne_zero.mpr hA))]
      linear_combination -hz
    have heqdeg : (D ^ 2).degree = (A ^ 2 * U ^ 3).degree := by
      rw [Polynomial.degree_eq_natDegree hD2, Polynomial.degree_eq_natDegree hA2U3,
        Polynomial.natDegree_pow,
        Polynomial.natDegree_mul (pow_ne_zero 2 hA) (pow_ne_zero 3 hU),
        Polynomial.natDegree_pow, Polynomial.natDegree_pow, hu, hda]
      simp
    have hndeg :
        (D ^ 2 + A ^ 2 * U ^ 3).natDegree = (D ^ 2).natDegree := by
      apply Polynomial.natDegree_eq_of_degree_eq
      rw [Polynomial.degree_add_eq_of_leadingCoeff_add_ne_zero hlc, ← heqdeg, max_self]
    rw [hndeg, Polynomial.natDegree_pow] at hdeg
    exact ⟨by omega, by omega, hu⟩
  · have hd := Polynomial.derivative_eq_zero.mp hder.1
    have hau := Polynomial.derivative_eq_zero.mp hder.2.1
    rw [Polynomial.natDegree_pow] at hd
    rw [Polynomial.natDegree_mul (pow_ne_zero 2 hA) (pow_ne_zero 3 hU),
      Polynomial.natDegree_pow, Polynomial.natDegree_pow] at hau
    exact ⟨by omega, by omega, by omega⟩

theorem ratFunc_orbit_polynomials_constant (F : Type*) [Field F] [CharZero F]
    (A D U : (RatFunc F)[X])
    (hA : A ≠ 0) (hD : D ≠ 0) (hU : U ≠ 0)
    (hU0 : U.eval 0 = RatFunc.X)
    (hN : D ^ 2 + A ^ 2 * U ^ 3 ≠ 0)
    (hdeg : (D ^ 2 + A ^ 2 * U ^ 3).natDegree ≤ 1) :
    A.natDegree = 0 ∧ D.natDegree = 0 ∧ U.natDegree = 0 :=
  orbit_polynomials_constant A D U RatFunc.X hA hD hU hU0
    (ratFunc_neg_X_cube_not_square F) hN hdeg

end PolynomialOrbit

end Rigidity047
