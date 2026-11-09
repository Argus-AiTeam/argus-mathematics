import Mathlib

open scoped BigOperators

namespace ThorpEnergy

theorem deterministic_matrix_preserves_centering
    {B I J : Type*} [Fintype B] [Fintype I] [Fintype J]
    (M : J → I → ℝ) (z : B → I → ℝ)
    (hz : ∀ i, ∑ b, z b i = 0) :
    ∀ j, ∑ b, (∑ i, M j i * z b i) = 0 := by
  intro j
  rw [Finset.sum_comm]
  simp_rw [← Finset.mul_sum, hz]
  simp

theorem centered_inner
    {A B I : Type*} [Fintype A] [Fintype B] [Fintype I]
    (p : A → I → ℝ) (z : A → B → I → ℝ)
    (hz : ∀ a i, ∑ b, z a b i = 0) :
    ∑ a, ∑ b, ∑ i, p a i * z a b i = 0 := by
  have hrow : ∀ a, ∑ b, ∑ i, p a i * z a b i = 0 := by
    intro a
    rw [Finset.sum_comm]
    simp_rw [← Finset.mul_sum, hz]
    simp
  simp_rw [hrow]
  simp

theorem centered_energy_row
    {B I : Type*} [Fintype B] [Fintype I]
    (p : I → ℝ) (z : B → I → ℝ)
    (hz : ∀ i, ∑ b, z b i = 0) :
    (∑ b, ∑ i, (p i + z b i) ^ 2) =
      (Fintype.card B : ℝ) * (∑ i, (p i) ^ 2) +
        ∑ b, ∑ i, (z b i) ^ 2 := by
  have hcoord : ∀ i,
      (∑ b, (p i + z b i) ^ 2) =
        (Fintype.card B : ℝ) * (p i) ^ 2 + ∑ b, (z b i) ^ 2 := by
    intro i
    calc
      _ = ∑ b, ((p i) ^ 2 + (2 * p i) * z b i + (z b i) ^ 2) := by
        apply Finset.sum_congr rfl
        intro b _
        ring
      _ = _ := by
        simp only [Finset.sum_add_distrib, ← Finset.mul_sum, hz,
          mul_zero, add_zero, Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  rw [Finset.sum_comm]
  simp_rw [hcoord]
  rw [Finset.sum_add_distrib, ← Finset.mul_sum]
  congr 1
  exact Finset.sum_comm

theorem finite_centered_energy
    {A B I : Type*} [Fintype A] [Fintype B] [Fintype I]
    (p : A → I → ℝ) (z : A → B → I → ℝ)
    (hz : ∀ a i, ∑ b, z a b i = 0) :
    (∑ a, ∑ b, ∑ i, (p a i + z a b i) ^ 2) =
      (Fintype.card B : ℝ) * (∑ a, ∑ i, (p a i) ^ 2) +
        ∑ a, ∑ b, ∑ i, (z a b i) ^ 2 := by
  calc
    _ = ∑ a, ((Fintype.card B : ℝ) * (∑ i, (p a i) ^ 2) +
        ∑ b, ∑ i, (z a b i) ^ 2) := by
      apply Finset.sum_congr rfl
      intro a _
      exact centered_energy_row (p a) (z a) (hz a)
    _ = _ := by rw [Finset.sum_add_distrib, ← Finset.mul_sum]

theorem finite_product_factorization
    {A B : Type*} [Fintype A] [Fintype B]
    (f : A → ℝ) (g : B → ℝ) :
    (∑ a, ∑ b, f a * g b) = (∑ a, f a) * (∑ b, g b) := by
  simp_rw [← Finset.mul_sum]
  exact (Finset.sum_mul ..).symm

theorem spread_dipole_energy (q : ℕ) (a : ℝ) :
    (∑ b : Bool, ∑ _u : Fin (2 ^ q),
      ((if b then a else -a) / (2 * (2 : ℝ) ^ q)) ^ 2) =
        a ^ 2 / (2 : ℝ) ^ (q + 1) := by
  have hpow : (2 : ℝ) ^ q ≠ 0 := pow_ne_zero _ (by norm_num)
  simp only [Fintype.sum_bool, Finset.sum_const, Finset.card_univ,
    Fintype.card_fin, nsmul_eq_mul, Nat.cast_pow, Nat.cast_ofNat]
  simp only [Bool.false_eq_true, reduceIte]
  rw [pow_succ]
  field_simp
  ring

end ThorpEnergy
