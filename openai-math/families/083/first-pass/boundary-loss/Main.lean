import Mathlib

open Finset

noncomputable section

namespace BoundaryLoss

def partialSum (a : ℕ → ℝ) (k : ℕ) : ℝ :=
  ∑ i ∈ range k, a i

theorem prefix_succ (a : ℕ → ℝ) (k : ℕ) :
    partialSum a (k + 1) = partialSum a k + a k := by
  exact sum_range_succ a k

theorem offset_telescope (a : ℕ → ℝ) (k r : ℕ) :
    (∑ i ∈ range k, (a i - a (i + r))) =
      partialSum a r - ∑ j ∈ range r, a (k + j) := by
  have hkr := sum_range_add a k r
  have hrk := sum_range_add a r k
  rw [Nat.add_comm r k] at hrk
  have hs : (∑ i ∈ range k, a (i + r)) = ∑ i ∈ range k, a (r + i) := by
    apply sum_congr rfl
    intro i hi
    rw [Nat.add_comm]
  rw [sum_sub_distrib, hs]
  dsimp [partialSum]
  linarith

theorem prefix_truncate (a : ℕ → ℝ) (k r : ℕ)
    (hz : ∀ i, k ≤ i → a i = 0) :
    partialSum a r = partialSum a (min r k) := by
  by_cases hr : r ≤ k
  · rw [min_eq_left hr]
  · have hkr : k ≤ r := by omega
    rw [min_eq_right hkr]
    exact eventually_constant_sum hz hkr

theorem stopped_telescope (a : ℕ → ℝ) (k r : ℕ)
    (hz : ∀ i, k ≤ i → a i = 0) :
    (∑ i ∈ range k, (a i - a (i + r))) = partialSum a (min r k) := by
  rw [offset_telescope]
  have ht : (∑ j ∈ range r, a (k + j)) = 0 := by
    apply sum_eq_zero
    intro j hj
    exact hz (k + j) (by omega)
  rw [ht, sub_zero, prefix_truncate a k r hz]

theorem geometric_layers (q : ℝ) (a : ℕ → ℝ) (k : ℕ) :
    (∑ r ∈ range k, (q ^ r - q ^ (r + 1)) * partialSum a (r + 1)) +
        q ^ k * partialSum a k =
      ∑ j ∈ range k, q ^ j * a j := by
  induction k with
  | zero => simp [partialSum]
  | succ k ih =>
      rw [sum_range_succ, sum_range_succ, prefix_succ]
      nlinarith [ih]

theorem stopped_layers (q : ℝ) (a : ℕ → ℝ) (k : ℕ)
    (hz : ∀ i, k ≤ i → a i = 0) :
    (∑ r ∈ range k, (q ^ r - q ^ (r + 1)) *
        (∑ i ∈ range k, (a i - a (i + (r + 1))))) +
        q ^ k * partialSum a k =
      ∑ j ∈ range k, q ^ j * a j := by
  have hs :
      (∑ r ∈ range k, (q ^ r - q ^ (r + 1)) *
          (∑ i ∈ range k, (a i - a (i + (r + 1))))) =
        ∑ r ∈ range k, (q ^ r - q ^ (r + 1)) * partialSum a (r + 1) := by
    apply sum_congr rfl
    intro r hr
    rw [stopped_telescope a k (r + 1) hz,
      min_eq_left (Nat.succ_le_of_lt (mem_range.mp hr))]
  rw [hs, geometric_layers]

theorem geometric_sum_identity (q : ℝ) (k : ℕ) :
    (1 - q) * (∑ i ∈ range k, q ^ i) = 1 - q ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [sum_range_succ, pow_succ]
      nlinarith [ih]

theorem geometric_sum_finite (q : ℝ) (k : ℕ) (hq : q < 1) :
    (∑ i ∈ range k, q ^ i) = (1 - q ^ k) / (1 - q) := by
  apply (eq_div_iff (ne_of_gt (sub_pos.mpr hq))).2
  nlinarith [geometric_sum_identity q k]

theorem geometric_sum_uniform (q : ℝ) (k : ℕ) (hq0 : 0 ≤ q) (hq1 : q < 1) :
    (∑ i ∈ range k, q ^ i) ≤ 1 / (1 - q) := by
  apply (le_div_iff₀ (sub_pos.mpr hq1)).2
  nlinarith [geometric_sum_identity q k, pow_nonneg hq0 k]

theorem potential_finite (q A : ℝ) (a : ℕ → ℝ) (k : ℕ)
    (hq0 : 0 ≤ q) (hq1 : q < 1) (ha : ∀ i < k, a i ≤ A) :
    (∑ i ∈ range k, q ^ i * a i) ≤ A * (1 - q ^ k) / (1 - q) := by
  calc
    (∑ i ∈ range k, q ^ i * a i) ≤ ∑ i ∈ range k, q ^ i * A := by
      apply sum_le_sum
      intro i hi
      exact mul_le_mul_of_nonneg_left (ha i (mem_range.mp hi)) (pow_nonneg hq0 i)
    _ = A * (∑ i ∈ range k, q ^ i) := by rw [← sum_mul]; ring
    _ = A * (1 - q ^ k) / (1 - q) := by rw [geometric_sum_finite q k hq1]; ring

theorem potential_uniform (q A : ℝ) (a : ℕ → ℝ) (k : ℕ)
    (hq0 : 0 ≤ q) (hq1 : q < 1) (hA : 0 ≤ A) (ha : ∀ i < k, a i ≤ A) :
    (∑ i ∈ range k, q ^ i * a i) ≤ A / (1 - q) := by
  calc
    (∑ i ∈ range k, q ^ i * a i) ≤ ∑ i ∈ range k, q ^ i * A := by
      apply sum_le_sum
      intro i hi
      exact mul_le_mul_of_nonneg_left (ha i (mem_range.mp hi)) (pow_nonneg hq0 i)
    _ = A * (∑ i ∈ range k, q ^ i) := by rw [← sum_mul]; ring
    _ ≤ A * (1 / (1 - q)) :=
      mul_le_mul_of_nonneg_left (geometric_sum_uniform q k hq0 hq1) hA
    _ = A / (1 - q) := by ring

theorem boundary_log_compare {x u v e : ℝ}
    (hu : 0 < u) (hux : u ≤ x) (he : 0 ≤ e) (hev : e ≤ v - u) :
    Real.log ((x + e) / x) ≤ Real.log (v / u) := by
  have hx : 0 < x := lt_of_lt_of_le hu hux
  have hvu : 0 ≤ v - u := le_trans he hev
  have hmul := mul_le_mul_of_nonneg_right hev (le_of_lt hu)
  have hprod := mul_nonneg (sub_nonneg.mpr hux) hvu
  have hratio : (x + e) / x ≤ v / u := by
    apply (div_le_div_iff₀ hx hu).2
    nlinarith
  exact Real.log_le_log (div_pos (by linarith) hx) hratio

theorem central_log_cancel (n m : ℕ → ℝ) (k : ℕ) :
    Real.log (n 0) - Real.log (n k) +
        (∑ i ∈ range k, (Real.log (n (i + 1)) - Real.log (m i))) =
      ∑ i ∈ range k, (Real.log (n i) - Real.log (m i)) := by
  have ht := sum_range_sub (fun i => Real.log (n i)) k
  simp only [sum_sub_distrib] at ht ⊢
  linarith

theorem abel_suffix {V : Type*} [AddCommGroup V] [Module ℝ V]
    (e : ℕ → ℝ) (x : ℕ → V) (n : ℕ) :
    (∑ l ∈ range n, partialSum e (l + 1) • x l) =
      ∑ j ∈ range n, e j • (∑ l ∈ Ico j n, x l) := by
  symm
  simp_rw [smul_sum]
  simpa only [Nat.Ico_zero_eq_range, partialSum, sum_smul] using
    sum_Ico_Ico_comm 0 n (fun j l => e j • x l)

theorem abel_suffix_bound {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V]
    (e : ℕ → ℝ) (x : ℕ → V) (n : ℕ) (H D : ℝ)
    (he : ∀ j < n, 0 ≤ e j) (hH : 0 ≤ H)
    (hs : ∀ j < n, ‖∑ l ∈ Ico j n, x l‖ ≤ H)
    (hD : partialSum e n ≤ D) :
    ‖∑ l ∈ range n, partialSum e (l + 1) • x l‖ ≤ D * H := by
  rw [abel_suffix]
  calc
    ‖∑ j ∈ range n, e j • (∑ l ∈ Ico j n, x l)‖ ≤
        ∑ j ∈ range n, ‖e j • (∑ l ∈ Ico j n, x l)‖ := norm_sum_le _ _
    _ = ∑ j ∈ range n, e j * ‖∑ l ∈ Ico j n, x l‖ := by
      apply sum_congr rfl
      intro j hj
      rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (he j (mem_range.mp hj))]
    _ ≤ ∑ j ∈ range n, e j * H := by
      apply sum_le_sum
      intro j hj
      exact mul_le_mul_of_nonneg_left (hs j (mem_range.mp hj)) (he j (mem_range.mp hj))
    _ = partialSum e n * H := by rw [← sum_mul]; rfl
    _ ≤ D * H := mul_le_mul_of_nonneg_right hD hH

theorem monotone_deficit_bound {V : Type*} [NormedAddCommGroup V] [NormedSpace ℝ V]
    (delta : ℕ → ℝ) (x : ℕ → V) (n : ℕ) (H : ℝ)
    (hd0 : delta 0 = 0) (hmono : ∀ j < n, delta j ≤ delta (j + 1))
    (hH : 0 ≤ H) (hs : ∀ j < n, ‖∑ l ∈ Ico j n, x l‖ ≤ H) :
    ‖∑ l ∈ range n, delta (l + 1) • x l‖ ≤ delta n * H := by
  let e : ℕ → ℝ := fun j => delta (j + 1) - delta j
  have hp (r : ℕ) : partialSum e r = delta r := by
    simpa only [partialSum, e, hd0, sub_zero] using sum_range_sub delta r
  have he : ∀ j < n, 0 ≤ e j := by
    intro j hj
    exact sub_nonneg.mpr (hmono j hj)
  have hb := abel_suffix_bound e x n H (delta n) he hH hs (by rw [hp])
  simpa only [hp] using hb

end BoundaryLoss
