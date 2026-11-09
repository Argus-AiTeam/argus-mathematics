import Mathlib

open scoped BigOperators

namespace SharedInterpolation

variable {K : Type*} [Field K]

theorem leading_residue
    {r : ℕ} (A : ℕ → Matrix (Fin r) (Fin r) K)
    (y : ℕ → Fin r → K) (n : ℕ)
    (hprev : ∀ j < n, y j = 0)
    (heq : (n : K) • y n =
      ∑ j ∈ Finset.range (n + 1), (A (n - j)).mulVec (y j)) :
    (A 0).mulVec (y n) = (n : K) • y n := by
  have hsum :
      (∑ j ∈ Finset.range (n + 1), (A (n - j)).mulVec (y j)) =
        (A 0).mulVec (y n) := by
    rw [Finset.sum_eq_single n]
    · simp
    · intro j hj hjn
      have hjlt : j < n := by
        have := Finset.mem_range.mp hj
        omega
      simp [hprev j hjlt]
    · intro hn
      simp at hn
  exact hsum.symm.trans heq.symm

theorem horizontal_leading_eigenpair
    {r : ℕ} (A : ℕ → Matrix (Fin r) (Fin r) K)
    (y : ℕ → Fin r → K)
    (hsolve : ∀ n : ℕ, (n : K) • y n =
      ∑ j ∈ Finset.range (n + 1), (A (n - j)).mulVec (y j))
    (hzero : ∃ n, y n ≠ 0) :
    ∃ n, y n ≠ 0 ∧ (∀ j < n, y j = 0) ∧
      (A 0).mulVec (y n) = (n : K) • y n := by
  classical
  let n := Nat.find hzero
  have hn : y n ≠ 0 := Nat.find_spec hzero
  have hprev : ∀ j < n, y j = 0 := by
    intro j hj
    by_contra h
    have hmin : n ≤ j := Nat.find_min' hzero h
    omega
  exact ⟨n, hn, hprev, leading_residue A y n hprev (hsolve n)⟩

theorem horizontal_order_bound
    {r : ℕ} (A : ℕ → Matrix (Fin r) (Fin r) K)
    (y : ℕ → Fin r → K) (bound : ℕ)
    (hsolve : ∀ n : ℕ, (n : K) • y n =
      ∑ j ∈ Finset.range (n + 1), (A (n - j)).mulVec (y j))
    (hzero : ∃ n, y n ≠ 0)
    (hspectrum : ∀ (n : ℕ) (v : Fin r → K), v ≠ 0 →
      (A 0).mulVec v = (n : K) • v → n ≤ bound) :
    ∃ n ≤ bound, y n ≠ 0 ∧ ∀ j < n, y j = 0 := by
  obtain ⟨n, hn, hprev, heigen⟩ :=
    horizontal_leading_eigenpair A y hsolve hzero
  exact ⟨n, hspectrum n (y n) hn heigen, hn, hprev⟩

theorem layer_count_uniform (k B B' r L : ℕ)
    (hL : 0 < L)
    (hthreshold :
      (k + 2).factorial * B' * r * (2 + B * r + B) ^ k < L) :
    (k + 2).factorial * B' * (r * L) *
      (1 + L + B * (r * L) + B) ^ k < L ^ (k + 2) := by
  have hBL : B ≤ B * L := by nlinarith
  have hbase :
      1 + L + B * (r * L) + B ≤ (2 + B * r + B) * L := by
    nlinarith
  have hp :
      (1 + L + B * (r * L) + B) ^ k ≤
        ((2 + B * r + B) * L) ^ k :=
    Nat.pow_le_pow_left hbase k
  calc
    (k + 2).factorial * B' * (r * L) *
        (1 + L + B * (r * L) + B) ^ k
        ≤ (k + 2).factorial * B' * (r * L) *
          ((2 + B * r + B) * L) ^ k :=
      Nat.mul_le_mul_left _ hp
    _ = ((k + 2).factorial * B' * r * (2 + B * r + B) ^ k) *
          L ^ (k + 1) := by
      rw [mul_pow, pow_succ]
      ring
    _ < L * L ^ (k + 1) :=
      Nat.mul_lt_mul_of_pos_right hthreshold (pow_pos hL _)
    _ = L ^ (k + 2) := by
      rw [show k + 2 = (k + 1) + 1 by omega, pow_succ]
      ring

end SharedInterpolation
