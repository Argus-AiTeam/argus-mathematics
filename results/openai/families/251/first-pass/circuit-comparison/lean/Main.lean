import Mathlib

namespace CircuitComparison

def descendingProduct {M : Type*} [Monoid M] (f : Nat -> M) : Nat -> M
  | 0 => 1
  | n + 1 => f n * descendingProduct f n

theorem descendingProduct_commute {M : Type*} [Monoid M]
    (f : Nat -> M) (x : M) (n : Nat)
    (h : forall i, i < n -> Commute (f i) x) :
    Commute (descendingProduct f n) x := by
  revert h
  induction n with
  | zero =>
      intro h
      simp [descendingProduct, Commute, SemiconjBy]
  | succ n ih =>
      intro h
      have hn := h n (Nat.lt_succ_self n)
      have hp := ih (fun i hi => h i (Nat.lt_trans hi (Nat.lt_succ_self n)))
      change (f n * descendingProduct f n) * x =
        x * (f n * descendingProduct f n)
      calc
        (f n * descendingProduct f n) * x =
            f n * (descendingProduct f n * x) := mul_assoc _ _ _
        _ = f n * (x * descendingProduct f n) := by rw [hp.eq]
        _ = (f n * x) * descendingProduct f n := (mul_assoc _ _ _).symm
        _ = (x * f n) * descendingProduct f n := by rw [hn.eq]
        _ = x * (f n * descendingProduct f n) := mul_assoc _ _ _

theorem interleaved_product {M : Type*} [Monoid M]
    (k m : Nat -> M)
    (h : forall i j, i < j -> Commute (k i) (m j)) (n : Nat) :
    descendingProduct (fun i => k i * m i) n =
      descendingProduct k n * descendingProduct m n := by
  induction n with
  | zero => simp [descendingProduct]
  | succ n ih =>
      have hc := descendingProduct_commute k (m n) n (fun i hi => h i n hi)
      change (k n * m n) * descendingProduct (fun i => k i * m i) n =
        (k n * descendingProduct k n) * (m n * descendingProduct m n)
      rw [ih]
      calc
        (k n * m n) * (descendingProduct k n * descendingProduct m n) =
            k n * ((m n * descendingProduct k n) * descendingProduct m n) := by
              simp only [mul_assoc]
        _ = k n * ((descendingProduct k n * m n) * descendingProduct m n) := by
              rw [hc.eq]
        _ = (k n * descendingProduct k n) * (m n * descendingProduct m n) := by
              simp only [mul_assoc]

def exchange {R : Type*} [Zero R] (c s : R) : Matrix (Fin 2) (Fin 2) R :=
  !![0, c; s, 0]

theorem post_error {R : Type*} [Ring R]
    (c ci si s : R) (h : c * ci = 1) :
    exchange c si * exchange s ci = !![1, 0; 0, si * s] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [exchange, Matrix.mul_apply, Fin.sum_univ_two, h]

theorem commute_of_annihilating_errors {R : Type*} [Ring R]
    (k m : R) (hkm : (k - 1) * (m - 1) = 0)
    (hmk : (m - 1) * (k - 1) = 0) : Commute k m := by
  change k * m = m * k
  calc
    k * m = (k - 1) * (m - 1) + k + m - 1 := by noncomm_ring
    _ = k + m - 1 := by rw [hkm]; simp
    _ = m + k - 1 := by rw [add_comm k m]
    _ = (m - 1) * (k - 1) + m + k - 1 := by rw [hmk]; simp
    _ = m * k := by noncomm_ring

def errorSum {R : Type*} [Ring R] (k : Nat -> R) : Nat -> R
  | 0 => 0
  | n + 1 => k n - 1 + errorSum k n

theorem mul_errorSum_zero {R : Type*} [Ring R]
    (a : R) (k : Nat -> R) (n : Nat)
    (h : forall i, i < n -> a * (k i - 1) = 0) :
    a * errorSum k n = 0 := by
  revert h
  induction n with
  | zero => simp [errorSum]
  | succ n ih =>
      intro h
      have hn := h n (Nat.lt_succ_self n)
      have hp := ih (fun i hi => h i (Nat.lt_trans hi (Nat.lt_succ_self n)))
      rw [errorSum, mul_add, hn, hp, add_zero]

theorem disjoint_error_product {R : Type*} [Ring R]
    (k : Nat -> R)
    (h : forall i j, Not (i = j) -> (k i - 1) * (k j - 1) = 0) (n : Nat) :
    descendingProduct k n = 1 + errorSum k n := by
  induction n with
  | zero => simp [descendingProduct, errorSum]
  | succ n ih =>
      have hz := mul_errorSum_zero (k n - 1) k n
        (fun i hi => h n i (Nat.ne_of_gt hi))
      rw [descendingProduct, ih, errorSum]
      calc
        k n * (1 + errorSum k n) =
            1 + (k n - 1 + errorSum k n) + (k n - 1) * errorSum k n := by
              noncomm_ring
        _ = 1 + (k n - 1 + errorSum k n) := by rw [hz, add_zero]

theorem common_right_cancel {G : Type*} [Group G] (p q c : G) :
    (q * c) * Inv.inv (p * c) = q * Inv.inv p := by
  simp [mul_assoc]

theorem rational_constants :
    And ((8 / 3 + 32 / 9 : Rat) < 7)
      (And ((9 / 8 * 14 : Rat) <= 16)
        (And ((9 / 8 * 4 : Rat) <= 5) ((16 + 15 / 4 : Rat) <= 20))) := by
  norm_num

theorem truncation_budget (h z : Real) (hh : 0 <= h) (hz : z <= 1 / 4) :
    16 * h + 15 * h * z <= 20 * h := by
  have hp : 0 <= h * (1 / 4 - z) := mul_nonneg hh (sub_nonneg.mpr hz)
  nlinarith

end CircuitComparison
