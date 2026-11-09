import Mathlib

open scoped BigOperators
open Polynomial

noncomputable section

namespace PairedState

theorem disk_sign (B W I h l : Int)
    (hfaces : B + W = 2 * I + h - 2)
    (hsides : 3 * (B - W) = 2 * l - h)
    (hmatching : B = I + l) :
    2 * l - h = -3 := by
  omega

theorem involution_sum_zero {P : Type*} [Fintype P]
    (flip : P -> P) (hinv : Function.Involutive flip)
    (w : P -> Complex) (hflip : ∀ p, w (flip p) = -w p) :
    (∑ p, w p) = 0 := by
  classical
  have hperm := hinv.bijective.sum_comp w
  have hneg : (∑ p, w p) = -(∑ p, w p) := by
    calc
      (∑ p, w p) = ∑ p, w (flip p) := hperm.symm
      _ = ∑ p, -w p := Finset.sum_congr rfl (fun p _ => hflip p)
      _ = -(∑ p, w p) := Finset.sum_neg_distrib w
  linear_combination (1 / 2 : Complex) * hneg

def normFactor (q d : Nat) : Polynomial Complex :=
  (1 + X) ^ q * ∑ j ∈ Finset.range d, (1 + X) ^ j

theorem difference_factor (q d : Nat) :
    (1 + X : Polynomial Complex) ^ (q + d) - (1 + X) ^ q =
      X * normFactor q d := by
  have hgeom :
      (X : Polynomial Complex) * (∑ j ∈ Finset.range d, (1 + X) ^ j) =
        (1 + X) ^ d - 1 := by
    (convert mul_geom_sum (1 + X : Polynomial Complex) d using 1; ring)
  rw [pow_add]
  calc
    (1 + X : Polynomial Complex) ^ q * (1 + X) ^ d - (1 + X) ^ q =
        (1 + X) ^ q * ((1 + X) ^ d - 1) := by ring
    _ = (1 + X) ^ q *
        (X * (∑ j ∈ Finset.range d, (1 + X) ^ j)) := by rw [hgeom]
    _ = X * normFactor q d := by unfold normFactor; ring

theorem shifted_pow_zero (n : Nat) :
    ((1 + X : Polynomial Complex) ^ n).coeff 0 = 1 := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [pow_succ, Polynomial.mul_coeff_zero, ih]
      simp

theorem normFactor_zero (q d : Nat) :
    (normFactor q d).coeff 0 = (d : Complex) := by
  change Polynomial.constantCoeff (normFactor q d) = (d : Complex)
  simp [normFactor, shifted_pow_zero]

def amplitude (c : Nat) (q d : Fin c -> Nat) : Polynomial Complex :=
  ∏ j, normFactor (q j) (d j)

theorem amplitude_zero (c : Nat) (q d : Fin c -> Nat) :
    (amplitude c q d).coeff 0 = ((∏ j, d j : Nat) : Complex) := by
  change Polynomial.constantCoeff (amplitude c q d) = _
  simp [amplitude, normFactor, shifted_pow_zero]

theorem oriented_group_factor (c : Nat) (q d : Fin c -> Nat) :
    (∏ j, C (-Complex.I) *
      ((1 + X : Polynomial Complex) ^ (q j + d j) - (1 + X) ^ (q j))) =
      C ((-Complex.I) ^ c) * (X ^ c * amplitude c q d) := by
  simp_rw [difference_factor]
  rw [Finset.prod_mul_distrib, Finset.prod_mul_distrib]
  simp [amplitude, Finset.prod_const, map_pow]

def grouped {G : Type*} (S : Finset G) (c : G -> Nat)
    (B : G -> Polynomial Complex) : Polynomial Complex :=
  ∑ g ∈ S, C ((-Complex.I) ^ c g) * (X ^ c g * B g)

def minMass {G : Type*} (S : Finset G) (c b : G -> Nat) (m : Nat) : Nat :=
  ∑ g ∈ S, if c g = m then b g else 0

theorem coefficient_at_min {G : Type*} (S : Finset G)
    (c : G -> Nat) (B : G -> Polynomial Complex) (b : G -> Nat) (m : Nat)
    (hc : ∀ g ∈ S, m ≤ c g)
    (hB : ∀ g ∈ S, (B g).coeff 0 = (b g : Complex)) :
    (grouped S c B).coeff m = (-Complex.I) ^ m * (minMass S c b m : Complex) := by
  classical
  calc
    (grouped S c B).coeff m =
        ∑ g ∈ S, if c g = m then (-Complex.I) ^ m * (b g : Complex) else 0 := by
      unfold grouped
      rw [Polynomial.finsetSum_coeff]
      apply Finset.sum_congr rfl
      intro g hg
      rw [Polynomial.coeff_C_mul]
      by_cases h : c g = m
      · simp [Polynomial.coeff_X_pow_mul', h, hB g hg]
      · have hn : ¬ c g ≤ m := by have := hc g hg; omega
        simp [Polynomial.coeff_X_pow_mul', hn, h]
    _ = (-Complex.I) ^ m *
        (∑ g ∈ S, if c g = m then (b g : Complex) else 0) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro g _
      split_ifs <;> simp
    _ = (-Complex.I) ^ m * (minMass S c b m : Complex) := by
      congr 1
      simp [minMass]

theorem coefficients_below_min {G : Type*} (S : Finset G)
    (c : G -> Nat) (B : G -> Polynomial Complex) (m k : Nat)
    (hc : ∀ g ∈ S, m ≤ c g) (hk : k < m) :
    (grouped S c B).coeff k = 0 := by
  classical
  unfold grouped
  rw [Polynomial.finsetSum_coeff]
  apply Finset.sum_eq_zero
  intro g hg
  rw [Polynomial.coeff_C_mul]
  have hn : ¬ c g ≤ k := by have := hc g hg; omega
  simp [Polynomial.coeff_X_pow_mul', hn]

theorem minMass_pos {G : Type*} (S : Finset G) (c b : G -> Nat) (m : Nat)
    (hb : ∀ g ∈ S, 0 < b g)
    (hmin : ∃ g ∈ S, c g = m) :
    0 < minMass S c b m := by
  classical
  obtain ⟨g, hg, hm⟩ := hmin
  unfold minMass
  refine Finset.sum_pos' (fun _ _ => Nat.zero_le _) ?_
  exact ⟨g, hg, by simpa [hm] using hb g hg⟩

theorem grouped_nonzero {G : Type*} (S : Finset G)
    (c : G -> Nat) (B : G -> Polynomial Complex) (b : G -> Nat) (m : Nat)
    (hc : ∀ g ∈ S, m ≤ c g)
    (hB : ∀ g ∈ S, (B g).coeff 0 = (b g : Complex))
    (hb : ∀ g ∈ S, 0 < b g)
    (hmin : ∃ g ∈ S, c g = m) :
    grouped S c B ≠ 0 := by
  have hm := minMass_pos S c b m hb hmin
  have hm' : (minMass S c b m : Complex) ≠ 0 := by
    exact_mod_cast (ne_of_gt hm)
  have hcoeff : (grouped S c B).coeff m ≠ 0 := by
    rw [coefficient_at_min S c B b m hc hB]
    exact mul_ne_zero (pow_ne_zero _ (neg_ne_zero.mpr Complex.I_ne_zero)) hm'
  intro hz
  apply hcoeff
  simp [hz]

def cycleSum {G : Type*} (S : Finset G) (c : G -> Nat)
    (q d : (g : G) -> Fin (c g) -> Nat) : Polynomial Complex :=
  ∑ g ∈ S, ∏ j, C (-Complex.I) *
    ((1 + X : Polynomial Complex) ^ (q g j + d g j) - (1 + X) ^ q g j)

theorem cycleSum_nonzero {G : Type*} (S : Finset G) (c : G -> Nat)
    (q d : (g : G) -> Fin (c g) -> Nat)
    (hne : S.Nonempty) (hd : ∀ g ∈ S, ∀ j, 0 < d g j) :
    cycleSum S c q d ≠ 0 := by
  classical
  obtain ⟨g0, hg0, hmin⟩ := S.exists_min_image c hne
  have heq : cycleSum S c q d =
      grouped S c (fun g => amplitude (c g) (q g) (d g)) := by
    unfold cycleSum grouped
    exact Finset.sum_congr rfl (fun g _ => oriented_group_factor (c g) (q g) (d g))
  rw [heq]
  apply grouped_nonzero S c (fun g => amplitude (c g) (q g) (d g))
    (fun g => ∏ j, d g j) (c g0) hmin
  · intro g _
    exact amplitude_zero (c g) (q g) (d g)
  · intro g hg
    exact Finset.prod_pos (fun j _ => hd g hg j)
  · exact ⟨g0, hg0, rfl⟩

end PairedState
