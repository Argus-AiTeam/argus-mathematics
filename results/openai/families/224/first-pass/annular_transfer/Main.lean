import Mathlib

open scoped BigOperators

namespace AnnularTransfer

theorem colour_flip_identity {ι : Type*} [Fintype ι]
    (flip : Equiv.Perm ι) (a k : ι → ℝ)
    (odd : ∀ i, a (flip i) = -a i) :
    (∑ i, a i * k i) =
      (1 / 2 : ℝ) * ∑ i, a i * (k i - k (flip i)) := by
  have h := Equiv.sum_comp flip (fun i => a i * k i)
  have hcross : -(∑ i, a i * k (flip i)) = ∑ i, a i * k i := by
    simpa only [odd, neg_mul, Finset.sum_neg_distrib] using h
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib]
  linarith

theorem invariant_reindex {ι : Type*} [Fintype ι]
    (rot : Equiv.Perm ι) (a k : ι → ℝ)
    (invariant : ∀ i, a (rot i) = a i) :
    (∑ i, a i * k (rot i)) = ∑ i, a i * k i := by
  simpa only [invariant] using
    (Equiv.sum_comp rot (fun i => a i * k i))

theorem colour_rotation_identity {ι : Type*} [Fintype ι]
    (m : ℕ) (flip : Equiv.Perm ι) (rot : Fin m → Equiv.Perm ι)
    (a k : ι → ℝ)
    (odd : ∀ i, a (flip i) = -a i)
    (invariant : ∀ j i, a (rot j i) = a i) :
    (∑ j : Fin m, ∑ i,
      a i * (k (rot j i) - k (flip (rot j i)))) =
      (m : ℝ) * (2 * ∑ i, a i * k i) := by
  have hbase :
      (∑ i, a i * (k i - k (flip i))) = 2 * ∑ i, a i * k i := by
    have h := colour_flip_identity flip a k odd
    linarith
  calc
    _ = ∑ _j : Fin m, ∑ i, a i * (k i - k (flip i)) := by
      apply Finset.sum_congr rfl
      intro j _
      exact invariant_reindex (rot j) a
        (fun i => k i - k (flip i)) (invariant j)
    _ = _ := by
      simp only [hbase, Finset.sum_const, Finset.card_univ,
        Fintype.card_fin, nsmul_eq_mul]

theorem geometric_identity (q : ℝ) (n : ℕ) :
    (1 - q) * (∑ i ∈ Finset.range n, q ^ i) = 1 - q ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, pow_succ]
      nlinarith

theorem geometric_bound (q : ℝ) (hq0 : 0 ≤ q) (hq1 : q < 1)
    (n : ℕ) :
    (∑ i ∈ Finset.range n, q ^ i) ≤ 1 / (1 - q) := by
  apply (le_div_iff₀ (sub_pos.mpr hq1)).2
  nlinarith [geometric_identity q n, pow_nonneg hq0 n]

theorem double_geometric_bound (q : ℝ) (hq0 : 0 ≤ q) (hq1 : q < 1)
    (n : ℕ) :
    (∑ i ∈ Finset.range n, ∑ j ∈ Finset.range n, q ^ (i + j)) ≤
      (1 / (1 - q)) ^ 2 := by
  have heq :
      (∑ i ∈ Finset.range n, ∑ j ∈ Finset.range n, q ^ (i + j)) =
        (∑ i ∈ Finset.range n, q ^ i) ^ 2 := by
    rw [pow_two, Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro i _
    rw [Finset.mul_sum]
    simp_rw [pow_add]
  rw [heq]
  have hs : 0 ≤ ∑ i ∈ Finset.range n, q ^ i :=
    Finset.sum_nonneg fun i _ => pow_nonneg hq0 i
  have hb := geometric_bound q hq0 hq1 n
  have hd : 0 ≤ 1 / (1 - q) := by positivity
  have hdiff := sub_nonneg.mpr hb
  nlinarith [mul_nonneg hs hdiff, mul_nonneg hd hdiff]

theorem polynomial_absorption (q : ℝ) (hq0 : 0 ≤ q) (hq1 : q < 1)
    (n : ℕ) :
    ((n + 1 : ℕ) : ℝ) ^ 2 * q ^ (2 * n) ≤
      (1 / (1 - q)) ^ 2 := by
  have hlower :
      ((n + 1 : ℕ) : ℝ) * q ^ n ≤
        ∑ i ∈ Finset.range (n + 1), q ^ i := by
    calc
      _ = ∑ _i ∈ Finset.range (n + 1), q ^ n := by simp
      _ ≤ _ := by
        apply Finset.sum_le_sum
        intro i hi
        exact pow_le_pow_of_le_one hq0 hq1.le
          (Nat.le_of_lt_succ (Finset.mem_range.mp hi))
  have hb := hlower.trans (geometric_bound q hq0 hq1 (n + 1))
  have hs : 0 ≤ ((n + 1 : ℕ) : ℝ) * q ^ n := by positivity
  have hd : 0 ≤ 1 / (1 - q) := by positivity
  have hdiff := sub_nonneg.mpr hb
  have hsq :
      (((n + 1 : ℕ) : ℝ) * q ^ n) ^ 2 ≤
        (1 / (1 - q)) ^ 2 := by
    nlinarith [mul_nonneg hs hdiff, mul_nonneg hd hdiff]
  simpa only [mul_pow, ← pow_mul, Nat.mul_comm n 2] using hsq

end AnnularTransfer
