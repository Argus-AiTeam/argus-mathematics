import Mathlib

open scoped BigOperators

namespace LatePrefixTransfer

theorem quadratic_identity (r z : ℝ) :
    (r * z) ^ 2 = r ^ 2 + 2 * r ^ 2 * (z - 1) + r ^ 2 * (z - 1) ^ 2 := by
  ring

theorem pointwise_step (r z a B M e : ℝ)
    (hdev : (z - 1) ^ 2 ≤ a ^ 2 + M ^ 2 * e)
    (hbar : r ^ 2 * e ≤ B ^ 2 * e) :
    (r * z) ^ 2 ≤
      (1 + a ^ 2) * r ^ 2 + 2 * r ^ 2 * (z - 1) + B ^ 2 * M ^ 2 * e := by
  have hvar := mul_le_mul_of_nonneg_left hdev (sq_nonneg r)
  have hexc := mul_le_mul_of_nonneg_left hbar (sq_nonneg M)
  nlinarith [quadratic_identity r z]

theorem barrier_on_live_exception (r B e : ℝ) (he : 0 ≤ e)
    (hlive : e = 0 ∨ (0 ≤ r ∧ r ≤ B)) :
    r ^ 2 * e ≤ B ^ 2 * e := by
  rcases hlive with hzero | ⟨hr, hrB⟩
  · simp [hzero]
  · have hs : r ^ 2 ≤ B ^ 2 := by nlinarith
    exact mul_le_mul_of_nonneg_right hs he

theorem integrated_step {ι : Type*} (s : Finset ι)
    (p r z e : ι → ℝ) (a B M eps : ℝ)
    (hp : ∀ i ∈ s, 0 ≤ p i)
    (hdev : ∀ i ∈ s, (z i - 1) ^ 2 ≤ a ^ 2 + M ^ 2 * e i)
    (hbar : ∀ i ∈ s, r i ^ 2 * e i ≤ B ^ 2 * e i)
    (hmean : ∑ i ∈ s, p i * r i ^ 2 * (z i - 1) = 0)
    (hexc : ∑ i ∈ s, p i * e i ≤ eps) :
    (∑ i ∈ s, p i * (r i * z i) ^ 2) ≤
      (1 + a ^ 2) * (∑ i ∈ s, p i * r i ^ 2) + B ^ 2 * M ^ 2 * eps := by
  calc
    (∑ i ∈ s, p i * (r i * z i) ^ 2) ≤
        ∑ i ∈ s, p i * ((1 + a ^ 2) * r i ^ 2 +
          2 * r i ^ 2 * (z i - 1) + B ^ 2 * M ^ 2 * e i) := by
      apply Finset.sum_le_sum
      intro i hi
      exact mul_le_mul_of_nonneg_left
        (pointwise_step (r i) (z i) a B M (e i) (hdev i hi) (hbar i hi)) (hp i hi)
    _ = ∑ i ∈ s, ((1 + a ^ 2) * (p i * r i ^ 2) +
          2 * (p i * r i ^ 2 * (z i - 1)) + (B ^ 2 * M ^ 2) * (p i * e i)) := by
      apply Finset.sum_congr rfl
      intro i hi
      ring
    _ = (1 + a ^ 2) * (∑ i ∈ s, p i * r i ^ 2) +
          2 * (∑ i ∈ s, p i * r i ^ 2 * (z i - 1)) +
          (B ^ 2 * M ^ 2) * (∑ i ∈ s, p i * e i) := by
      simp only [Finset.sum_add_distrib, ← Finset.mul_sum]
    _ ≤ (1 + a ^ 2) * (∑ i ∈ s, p i * r i ^ 2) + B ^ 2 * M ^ 2 * eps := by
      rw [hmean]
      have h := mul_le_mul_of_nonneg_left hexc
        (mul_nonneg (sq_nonneg B) (sq_nonneg M))
      linarith

theorem iterated_bound (v : ℕ → ℝ) (q c : ℝ)
    (hq : 1 ≤ q) (hc : 0 ≤ c) (hzero : v 0 ≤ 1)
    (hstep : ∀ t, v (t + 1) ≤ q * v t + c) :
    ∀ t, v t ≤ q ^ t * (1 + (t : ℝ) * c) := by
  have hq0 : 0 ≤ q := by linarith
  have hpow : ∀ t : ℕ, 1 ≤ q ^ t := by
    intro t
    induction t with
    | zero => simp
    | succ t ih =>
      rw [pow_succ]
      nlinarith
  intro t
  induction t with
  | zero => simpa using hzero
  | succ t ih =>
    calc
      v (t + 1) ≤ q * v t + c := hstep t
      _ ≤ q * (q ^ t * (1 + (t : ℝ) * c)) + c := by
        have h := mul_le_mul_of_nonneg_left ih hq0
        linarith
      _ = q ^ (t + 1) * (1 + (t : ℝ) * c) + c := by
        rw [pow_succ]
        ring
      _ ≤ q ^ (t + 1) * (1 + ((t + 1 : ℕ) : ℝ) * c) := by
        have h := mul_nonneg (sub_nonneg.mpr (hpow (t + 1))) hc
        push_cast
        nlinarith

end LatePrefixTransfer
