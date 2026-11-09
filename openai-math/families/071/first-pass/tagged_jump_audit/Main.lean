import Mathlib

open scoped BigOperators ENNReal

noncomputable section

namespace TaggedJumpAudit

theorem per_visit_glue {A I J : Type*} (w : A → ℝ≥0∞)
    (left : I → A) (p : A) (right : J → A) :
    (∑' t : I ⊕ (Unit ⊕ J),
      w (Sum.elim left (Sum.elim (fun _ : Unit => p) right) t)) =
      (∑' i, w (left i)) + w p + (∑' j, w (right j)) := by
  rw [ENNReal.summable.tsum_sum ENNReal.summable]
  simp only [Sum.elim_inl, Sum.elim_inr]
  rw [ENNReal.summable.tsum_sum ENNReal.summable]
  simp [add_assoc]

theorem junction_paid {A I J : Type*} (w : A → ℝ≥0∞)
    (left : I → A) (p : A) (right : J → A)
    (budget : ℝ≥0∞) (hp : w p ≤ budget) :
    (∑' t : I ⊕ (Unit ⊕ J),
      w (Sum.elim left (Sum.elim (fun _ : Unit => p) right) t)) ≤
      (∑' i, w (left i)) + budget + (∑' j, w (right j)) := by
  rw [per_visit_glue]
  exact add_le_add (add_le_add le_rfl hp) le_rfl

theorem normalization_identity (k : ℝ) (hk : 1 < k) :
    k * (1 - 2 * ((k - 1) / (4 * k))) - 1 = (k - 1) / 2 := by
  have hk0 : k ≠ 0 := ne_of_gt (lt_trans zero_lt_one hk)
  field_simp [hk0]
  ring

theorem normalization_positive (k : ℝ) (hk : 1 < k) :
    0 < k * (1 - 2 * ((k - 1) / (4 * k))) - 1 := by
  rw [normalization_identity k hk]
  linarith

theorem sharpness_deficit (n : ℝ) (hn : 0 < n) :
    1 - (n / (n + 1)) ^ 2 = (2 * n + 1) / (n + 1) ^ 2 := by
  have hn1 : n + 1 ≠ 0 := ne_of_gt (by linarith)
  field_simp [hn1]
  ring

theorem sharpness_error_bound (n : ℝ) (hn : 0 < n) :
    1 - (n / (n + 1)) ^ 2 < 2 / (n + 1) := by
  rw [sharpness_deficit n hn]
  have hn1 : 0 < n + 1 := by linarith
  apply (div_lt_div_iff₀ (sq_pos_of_pos hn1) hn1).2
  nlinarith

end TaggedJumpAudit
