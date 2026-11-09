import Mathlib

namespace FormalDataBridge

variable {R : Type*} [CommRing R]

theorem square_zero_product {ι : Type*} (s : Finset ι)
    (t : R) (ht : t * t = 0) (r u : ι → R) :
    t * (∏ i ∈ s, (r i + t * u i)) = t * ∏ i ∈ s, r i := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
      simp only [Finset.prod_insert ha]
      calc
        t * ((r a + t * u a) * ∏ i ∈ s, (r i + t * u i)) =
            r a * (t * ∏ i ∈ s, (r i + t * u i)) := by
              calc
                _ = r a * (t * ∏ i ∈ s, (r i + t * u i)) +
                    (t * t) * (u a * ∏ i ∈ s, (r i + t * u i)) := by ring
                _ = _ := by rw [ht]; ring
        _ = r a * (t * ∏ i ∈ s, r i) := by rw [ih]
        _ = t * (r a * ∏ i ∈ s, r i) := by ring

theorem taylor_remainder_ideal {ι : Type*} (I J : Ideal R)
    (q : ℕ) (delta : ι → R) (remainder : R)
    (hdelta : ∀ i, delta i ∈ J ^ q * I)
    (hremainder : remainder ∈ (Ideal.span (Set.range delta)) ^ 2) :
    remainder ∈ J ^ (2 * q) * I ^ 2 := by
  have hspan : Ideal.span (Set.range delta) ≤ J ^ q * I := by
    apply Ideal.span_le.mpr
    rintro x ⟨i, rfl⟩
    exact hdelta i
  have hpow := Ideal.pow_right_mono hspan 2
  have heq : (J ^ q * I) ^ 2 = J ^ (2 * q) * I ^ 2 := by
    rw [mul_pow, ← pow_mul]
    congr 2
    omega
  rw [← heq]
  exact hpow hremainder

theorem newton_step {ι : Type*} (I J : Ideal R)
    (q : ℕ) (delta : ι → R)
    (oldValue linearTerm remainder newValue : R)
    (hdelta : ∀ i, delta i ∈ J ^ q * I)
    (hremainder : remainder ∈ (Ideal.span (Set.range delta)) ^ 2)
    (hcancel : oldValue + linearTerm = 0)
    (htaylor : newValue = oldValue + linearTerm + remainder) :
    newValue ∈ J ^ (2 * q) * I ^ 2 := by
  rw [htaylor, hcancel, zero_add]
  exact taylor_remainder_ideal I J q delta remainder hdelta hremainder

theorem error_zero_of_nilpotent (I J : Ideal R) (N q : ℕ)
    (hJ : J ^ N = ⊥) (hN : N ≤ q) (e : R)
    (he : e ∈ J ^ q * I ^ 2) : e = 0 := by
  have hq : J ^ q = ⊥ := by
    apply le_antisymm
    · calc
        J ^ q ≤ J ^ N := Ideal.pow_le_pow_right hN
        _ = ⊥ := hJ
    · exact bot_le
  simpa [hq] using he

theorem finite_newton_termination {ι : Type*}
    (I J : Ideal R) (N steps : ℕ)
    (hJ : J ^ N = ⊥) (hsteps : N ≤ 2 ^ steps)
    (value linearTerm remainder : ℕ → R) (delta : ℕ → ι → R)
    (hzero : value 0 ∈ J * I ^ 2)
    (hdelta : ∀ k < steps, ∀ i, delta k i ∈ J ^ (2 ^ k) * I)
    (hremainder : ∀ k < steps,
      remainder k ∈ (Ideal.span (Set.range (delta k))) ^ 2)
    (hcancel : ∀ k < steps, value k + linearTerm k = 0)
    (htaylor : ∀ k < steps,
      value (k + 1) = value k + linearTerm k + remainder k) :
    value steps = 0 := by
  have hvalue : ∀ k ≤ steps, value k ∈ J ^ (2 ^ k) * I ^ 2 := by
    intro k hk
    cases k with
    | zero => simpa using hzero
    | succ k =>
        have hks : k < steps := by omega
        have h := newton_step I J (2 ^ k) (delta k)
          (value k) (linearTerm k) (remainder k) (value (k + 1))
          (hdelta k hks) (hremainder k hks)
          (hcancel k hks) (htaylor k hks)
        simpa [pow_succ, Nat.mul_comm] using h
  exact error_zero_of_nilpotent I J N (2 ^ steps) hJ hsteps
    (value steps) (hvalue steps le_rfl)

set_option maxRecDepth 4096 in
theorem twenty_parameters_five_steps (I J : Ideal R)
    (hJ : J ^ 21 = ⊥) (e : R)
    (he : e ∈ J ^ (2 ^ 5) * I ^ 2) : e = 0 :=
  error_zero_of_nilpotent I J 21 (2 ^ 5) hJ (by decide) e he

theorem unit_of_nilpotent_congruence (J : Ideal R) (N : ℕ)
    (hJ : J ^ N = ⊥) (u v : R) (hu : IsUnit u)
    (hvu : v - u ∈ J) : IsUnit v := by
  have hnil : IsNilpotent J := ⟨N, by simpa using hJ⟩
  apply (IsNilpotent.isUnit_quotient_mk_iff hnil).mp
  have heq : Ideal.Quotient.mk J v = Ideal.Quotient.mk J u :=
    (Ideal.Quotient.eq (I := J)).mpr hvu
  rw [heq]
  exact hu.map (Ideal.Quotient.mk J)

theorem polynomial_congruence {ι : Type*} (I : Ideal R)
    (x y : ι → R) (hxy : ∀ i, x i - y i ∈ I)
    (p : MvPolynomial ι R) :
    MvPolynomial.eval x p - MvPolynomial.eval y p ∈ I := by
  apply (Ideal.Quotient.eq (I := I)).mp
  have hcoordinates : (fun i => Ideal.Quotient.mk I (x i)) =
      (fun i => Ideal.Quotient.mk I (y i)) := by
    funext i
    exact (Ideal.Quotient.eq (I := I)).mpr (hxy i)
  change Ideal.Quotient.mk I
      (MvPolynomial.eval₂Hom (RingHom.id R) x p) =
    Ideal.Quotient.mk I
      (MvPolynomial.eval₂Hom (RingHom.id R) y p)
  rw [MvPolynomial.map_eval₂Hom, MvPolynomial.map_eval₂Hom, hcoordinates]

theorem polynomial_membership_transport {ι : Type*} (I : Ideal R)
    (x y : ι → R) (hxy : ∀ i, x i - y i ∈ I)
    (p : MvPolynomial ι R) (hy : MvPolynomial.eval y p ∈ I) :
    MvPolynomial.eval x p ∈ I := by
  have h := I.add_mem (polynomial_congruence I x y hxy p) hy
  simpa using h

end FormalDataBridge
