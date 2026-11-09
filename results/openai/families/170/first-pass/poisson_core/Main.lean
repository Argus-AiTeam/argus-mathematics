import Mathlib

namespace PoissonCore

variable {α Ω β : Type*} [DecidableEq α]

noncomputable def vacant (u hits : Finset α) : ℝ :=
  if Disjoint u hits then 1 else 0

theorem vacant_empty (hits : Finset α) : vacant ∅ hits = 1 := by
  simp [vacant]

theorem vacant_union (u v hits : Finset α) :
    vacant (u ∪ v) hits = vacant u hits * vacant v hits := by
  classical
  by_cases hu : Disjoint u hits <;> by_cases hv : Disjoint v hits <;>
    simp [vacant, Finset.disjoint_union_left, hu, hv]

noncomputable def mixed (b : ℝ) (z : Finset α → ℝ) :
    List (Finset α) → Finset α → ℝ
  | [], u => z u
  | h :: hs, u => mixed b z hs (u ∪ h) - b * mixed b z hs u

theorem mixed_atom (b : ℝ) (hits : Finset α) (hs : List (Finset α))
    (u : Finset α) :
    mixed b (fun v => vacant v hits) hs u =
      vacant u hits * (hs.map (fun h => vacant h hits - b)).prod := by
  induction hs generalizing u with
  | nil => simp [mixed]
  | cons h hs ih =>
      simp only [mixed, ih, vacant_union, List.map_cons, List.prod_cons]
      ring

theorem mixed_sum (b : ℝ) (sample : Finset Ω) (w : Ω → ℝ)
    (z : Ω → Finset α → ℝ) (hs : List (Finset α)) (u : Finset α) :
    mixed b (fun v => ∑ ω ∈ sample, w ω * z ω v) hs u =
      ∑ ω ∈ sample, w ω * mixed b (z ω) hs u := by
  induction hs generalizing u with
  | nil => simp [mixed]
  | cons h hs ih =>
      simp only [mixed, ih]
      rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
      apply Finset.sum_congr rfl
      intro ω hω
      ring

theorem exact_centered_mixed_moment (b : ℝ) (sample : Finset Ω)
    (w : Ω → ℝ) (hits : Ω → Finset α) (hs : List (Finset α)) :
    mixed b (fun u => ∑ ω ∈ sample, w ω * vacant u (hits ω)) hs ∅ =
      ∑ ω ∈ sample, w ω *
        (hs.map (fun h => vacant h (hits ω) - b)).prod := by
  rw [mixed_sum]
  apply Finset.sum_congr rfl
  intro ω hω
  rw [mixed_atom, vacant_empty, one_mul]

theorem restricted_pair_sum_le_product (s : Finset α) (t : Finset β)
    (w : α → ℝ) (v : β → ℝ) (keep : α → β → Prop) [DecidableRel keep]
    (hw : ∀ i ∈ s, 0 ≤ w i) (hv : ∀ j ∈ t, 0 ≤ v j) :
    (∑ i ∈ s, ∑ j ∈ t, if keep i j then w i * v j else 0) ≤
      (∑ i ∈ s, w i) * (∑ j ∈ t, v j) := by
  classical
  calc
    (∑ i ∈ s, ∑ j ∈ t, if keep i j then w i * v j else 0) ≤
        ∑ i ∈ s, ∑ j ∈ t, w i * v j := by
      apply Finset.sum_le_sum
      intro i hi
      apply Finset.sum_le_sum
      intro j hj
      split_ifs
      · exact le_rfl
      · exact mul_nonneg (hw i hi) (hv j hj)
    _ = (∑ i ∈ s, w i) * (∑ j ∈ t, v j) := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro i hi
      rw [Finset.mul_sum]

theorem root_exponent (h r : ℤ) (hr : 10 * r ≤ h) :
    5 * (2 * r - h) ≤ -4 * h := by
  omega

theorem nonsimple_margin (k : ℚ) (hk : 2 ≤ k) :
    (17 / 50 : ℚ) * k ≤ 17 / 25 + (k - 2) := by
  linarith

theorem final_exponent_margin (z overhead : ℝ) (hz : 0 ≤ z)
    (ho : overhead ≤ z / 10) :
    -(17 / 50 : ℝ) * z + overhead ≤ -(1 / 10 : ℝ) * z := by
  linarith

end PoissonCore
