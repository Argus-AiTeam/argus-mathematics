import Mathlib.Data.ENNReal.BigOperators

open scoped BigOperators ENNReal

namespace FiniteConvexity

theorem sector_rank_bound
    {E : Type*} (s : Finset E) (active : E → Prop) [DecidablePred active]
    (N : E → ℕ) (r : E → ℝ≥0∞) (b : ℝ≥0∞)
    (hzero : ∀ e ∈ s, ¬active e → r e = 0)
    (hbound : ∀ e ∈ s, active e → r e ≤ (N e : ℝ≥0∞) * b) :
    (∑ e ∈ s, r e) ≤
      ((∑ e ∈ s, if active e then N e else 0 : ℕ) : ℝ≥0∞) * b := by
  calc
    (∑ e ∈ s, r e) ≤
        ∑ e ∈ s, ((if active e then N e else 0 : ℕ) : ℝ≥0∞) * b := by
      apply Finset.sum_le_sum
      intro e he
      by_cases h : active e
      · simpa only [if_pos h] using hbound e he h
      · simp only [if_neg h, Nat.cast_zero, zero_mul, hzero e he h, le_refl]
    _ = _ := by rw [← Finset.sum_mul, Nat.cast_sum]

theorem zero_controller_rank
    {E : Type*} (s : Finset E) (active : E → Prop) [DecidablePred active]
    (N : E → ℕ) (r : E → ℝ≥0∞)
    (hzero : ∀ e ∈ s, ¬active e → r e = 0)
    (hbound : ∀ e ∈ s, active e → r e ≤ (N e : ℝ≥0∞) * 0) :
    (∑ e ∈ s, r e) = 0 := by
  apply le_antisymm
  · simpa only [mul_zero] using sector_rank_bound s active N r 0 hzero hbound
  · exact zero_le

theorem cap_rank_bound
    {E : Type*} (s : Finset E) (active : E → Prop) [DecidablePred active]
    (N : E → ℕ) (r : E → ℝ≥0∞) (b : ℝ≥0∞)
    (hzero : ∀ e ∈ s, ¬active e → r e = 0)
    (hbound : ∀ e ∈ s, active e → r e ≤ (N e : ℝ≥0∞) * b)
    (hb : b ≤ 1) :
    (∑ e ∈ s, r e) ≤
      ((∑ e ∈ s, if active e then N e else 0 : ℕ) : ℝ≥0∞) := by
  calc
    (∑ e ∈ s, r e) ≤
        ((∑ e ∈ s, if active e then N e else 0 : ℕ) : ℝ≥0∞) * b :=
      sector_rank_bound s active N r b hzero hbound
    _ ≤ ((∑ e ∈ s, if active e then N e else 0 : ℕ) : ℝ≥0∞) * 1 :=
      mul_le_mul_right hb _
    _ = _ := mul_one _

theorem cap_rank_finite
    {E : Type*} (s : Finset E) (active : E → Prop) [DecidablePred active]
    (N : E → ℕ) (r : E → ℝ≥0∞) (b : ℝ≥0∞)
    (hzero : ∀ e ∈ s, ¬active e → r e = 0)
    (hbound : ∀ e ∈ s, active e → r e ≤ (N e : ℝ≥0∞) * b)
    (hb : b ≤ 1) :
    (∑ e ∈ s, r e) < ⊤ :=
  lt_of_le_of_lt (cap_rank_bound s active N r b hzero hbound hb)
    (ENNReal.natCast_lt_top _)

theorem inactive_zero_cannot_be_omitted :
    ¬ ((1 : ℝ≥0∞) ≤ (0 : ℝ≥0∞) * 0) := by
  simp

end FiniteConvexity
