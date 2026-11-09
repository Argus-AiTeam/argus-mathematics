import Mathlib.Algebra.Polynomial.Div
import Mathlib.RingTheory.Ideal.Quotient.Defs
import Mathlib.RingTheory.Ideal.Span
import Mathlib.Tactic.Ring

namespace DivisionIndexAudit

theorem power_mul_eq_of_mul_eq {R : Type*} [CommRing R]
    (s t q : R) (h : s * q = t * q) (n : Nat) :
    s ^ n * q = t ^ n * q := by
  induction n with
  | zero => simp
  | succ n ih =>
      calc
        s ^ (n + 1) * q = s * (s ^ n * q) := by rw [pow_succ]; ring
        _ = s * (t ^ n * q) := by rw [ih]
        _ = t ^ n * (s * q) := by ring
        _ = t ^ n * (t * q) := by rw [h]
        _ = t ^ (n + 1) * q := by rw [pow_succ]; ring

theorem nilpotent_lift {R : Type*} [CommRing R]
    (a d p c x q : R) (nu v : Nat)
    (ha : a * q = 0) (hx : x ^ nu = a * d + p * c)
    (hp : p ^ v = 0) :
    x ^ (nu * v) * q = 0 := by
  have hstep : x ^ nu * q = (p * c) * q := by
    calc
      x ^ nu * q = (a * q) * d + (p * c) * q := by rw [hx]; ring
      _ = (p * c) * q := by rw [ha]; simp
  calc
    x ^ (nu * v) * q = (x ^ nu) ^ v * q := by rw [pow_mul]
    _ = (p * c) ^ v * q := power_mul_eq_of_mul_eq _ _ _ hstep v
    _ = 0 := by rw [mul_pow, hp, zero_mul, zero_mul]

open Polynomial

theorem constant_zero_of_truncated_bezout {R : Type*} [CommRing R]
    (p : R) (A D T U Q : Polynomial R) (nu v h : Nat)
    (hp : p ^ v = 0) (hbound : nu * v <= h)
    (hAQ : X ^ (h + 1) ∣ A * Q)
    (hbezout : X ^ nu = A * D + C p * T + X ^ (h + 1) * U) :
    Q.coeff 0 = 0 := by
  let I : Ideal (Polynomial R) := Ideal.span {X ^ (h + 1)}
  let pi := Ideal.Quotient.mk I
  have hz : pi (X ^ (h + 1)) = 0 := by
    apply Ideal.Quotient.eq_zero_iff_mem.mpr
    exact Ideal.subset_span (by simp)
  have hz' : (pi X) ^ (h + 1) = 0 := by
    simpa only [map_pow] using hz
  have ha : pi A * pi Q = 0 := by
    rw [← map_mul]
    exact Ideal.Quotient.eq_zero_iff_mem.mpr
      (Ideal.mem_span_singleton.mpr hAQ)
  have hp' : (pi (C p)) ^ v = 0 := by
    simpa only [map_pow, map_zero] using
      congrArg (fun r : R => pi (C r)) hp
  have hx : (pi X) ^ nu = pi A * pi D + pi (C p) * pi T := by
    simpa only [map_pow, map_add, map_mul, hz', zero_mul, add_zero] using
      congrArg pi hbezout
  have hnil := nilpotent_lift (pi A) (pi D) (pi (C p)) (pi T)
    (pi X) (pi Q) nu v ha hx hp'
  have hmem : X ^ (nu * v) * Q ∈ I := by
    apply Ideal.Quotient.eq_zero_iff_mem.mp
    simpa only [map_mul, map_pow] using hnil
  have hdvd : X ^ (h + 1) ∣ X ^ (nu * v) * Q :=
    Ideal.mem_span_singleton.mp hmem
  have hcoeff := (Polynomial.X_pow_dvd_iff.mp hdvd)
    (nu * v) (Nat.lt_succ_of_le hbound)
  simpa [Polynomial.coeff_X_pow_mul'] using hcoeff

theorem determinant_weights (g : Int) :
    (-(2 - g) + (1 - g), -(2 - g) + (2 - g)) = (-1, 0) := by
  apply Prod.ext <;> dsimp <;> ring

end DivisionIndexAudit
