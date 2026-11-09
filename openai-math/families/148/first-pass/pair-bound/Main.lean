/-
Adapted from the translated-grid argument in OpenAI/math, revision
4eaee87548250b2682affda7d05d947c05554bae, under Apache-2.0; see LICENSE.
This audit version supplies the full refinement-to-capacity proof in one
Lean 4.31.0 source, without importing the upstream target theorem.
-/
import OAI.MeasureTheory.SelfSimilar.ProductLaw

open scoped BigOperators ENNReal
open MeasureTheory
open OAI.EntropyRateDimension
open OAI.EntropyRateDimension.FiniteEntropy
open OAI.EntropyRateDimension.FairPairs

namespace PairBoundCertificate

noncomputable section

universe u v

namespace Circle

local instance unitCircleProbability :
    IsProbabilityMeasure (volume : Measure (AddCircle (1 : ℝ))) := ⟨by simp⟩

def hit (c : AddCircle (1 : ℝ)) (r : ℝ) (u : AddCircle (1 : ℝ)) : ℝ :=
  if dist u c ≤ r then 1 else 0

theorem hit_eq_indicator (c : AddCircle (1 : ℝ)) (r : ℝ) :
    hit c r = (Metric.closedBall c r).indicator (fun _ => (1 : ℝ)) := by
  classical
  ext u
  rfl

theorem hit_integrable (c : AddCircle (1 : ℝ)) (r : ℝ) : Integrable (hit c r) := by
  rw [hit_eq_indicator]
  exact (integrable_const 1).indicator measurableSet_closedBall

theorem integral_hit (c : AddCircle (1 : ℝ)) {r : ℝ} (hr : 0 ≤ r) :
    (∫ u, hit c r u) = min 1 (2 * r) := by
  rw [hit_eq_indicator, integral_indicator_const _ measurableSet_closedBall]
  simp only [Measure.real, AddCircle.volume_closedBall, smul_eq_mul, mul_one]
  exact ENNReal.toReal_ofReal (le_min (by norm_num) (mul_nonneg (by norm_num) hr))

theorem circle_norm_le_of_floor_ne {x y : ℝ} (h : ⌊x⌋ ≠ ⌊y⌋) :
    ‖(x : AddCircle (1 : ℝ))‖ ≤ |y - x| := by
  rw [AddCircle.norm_eq]
  simp only [inv_one, one_mul, mul_one]
  rcases lt_or_gt_of_ne h with hxy | hxy
  · apply (round_le x (⌊x⌋ + 1)).trans
    have hy : (⌊x⌋ : ℝ) + 1 ≤ y := by
      have hh : ⌊x⌋ + 1 ≤ ⌊y⌋ := hxy
      have hh' : (⌊x⌋ : ℝ) + 1 ≤ (⌊y⌋ : ℝ) := by exact_mod_cast hh
      exact hh'.trans (Int.floor_le y)
    have hx := Int.lt_floor_add_one x
    rw [Int.cast_add, Int.cast_one, abs_of_nonpos (by linarith), abs_of_nonneg (by linarith)]
    linarith
  · apply (round_le x ⌊x⌋).trans
    have hy : y ≤ (⌊x⌋ : ℝ) := by
      have hh : ⌊y⌋ + 1 ≤ ⌊x⌋ := hxy
      have hh' : (⌊y⌋ : ℝ) + 1 ≤ (⌊x⌋ : ℝ) := by exact_mod_cast hh
      exact (Int.lt_floor_add_one y).le.trans hh'
    have hx := Int.floor_le x
    rw [abs_of_nonneg (by linarith), abs_of_nonpos (by linarith)]
    linarith

end Circle

def shift (u : AddCircle (1 : ℝ)) : ℝ := (AddCircle.equivIco 1 0 u).val

def label (δ : ℝ) (u : AddCircle (1 : ℝ)) (x : ℝ) : ℤ :=
  ⌊x / δ + shift u⌋

theorem shift_zero : shift 0 = 0 := by
  have h := AddCircle.equivIco_coe_of_mem (p := (1 : ℝ)) (a := (0 : ℝ))
    (y := (0 : ℝ)) (by norm_num : (0 : ℝ) ∈ Set.Ico 0 (0 + 1))
  simpa only [shift, AddCircle.coe_zero] using h

theorem equal_labels_close {δ x y : ℝ} (hδ : 0 < δ)
    (u : AddCircle (1 : ℝ)) (h : label δ u x = label δ u y) :
    |x - y| < δ := by
  have hx := Int.floor_le (x / δ + shift u)
  have hx' := Int.lt_floor_add_one (x / δ + shift u)
  have hy := Int.floor_le (y / δ + shift u)
  have hy' := Int.lt_floor_add_one (y / δ + shift u)
  change ⌊x / δ + shift u⌋ = ⌊y / δ + shift u⌋ at h
  rw [h] at hx hx'
  have hxy : (x - y) / δ < 1 := by rw [sub_div]; linarith
  have hyx : (y - x) / δ < 1 := by rw [sub_div]; linarith
  have h₁ := (div_lt_iff₀ hδ).mp hxy
  have h₂ := (div_lt_iff₀ hδ).mp hyx
  rw [abs_lt]
  constructor <;> linarith

theorem changed_label_margin {δ x m : ℝ} (hδ : 0 < δ)
    (u : AddCircle (1 : ℝ)) (h : label δ u x ≠ label δ u m) :
    δ * dist u (-(m / δ : ℝ) : AddCircle (1 : ℝ)) ≤ |x - m| := by
  have hn := Circle.circle_norm_le_of_floor_ne (Ne.symm h)
  have hc : ((m / δ + shift u : ℝ) : AddCircle (1 : ℝ)) =
      u + (m / δ : ℝ) := by
    rw [AddCircle.coe_add]
    simp only [shift, AddCircle.coe_equivIco, add_comm]
  change ‖((m / δ + shift u : ℝ) : AddCircle (1 : ℝ))‖ ≤ _ at hn
  rw [hc] at hn
  have he : |x / δ + shift u - (m / δ + shift u)| = |x - m| / δ := by
    rw [show x / δ + shift u - (m / δ + shift u) = (x - m) / δ by ring,
      abs_div, abs_of_pos hδ]
  rw [he] at hn
  rw [dist_eq_norm, sub_neg_eq_add]
  simpa only [mul_comm] using (le_div_iff₀ hδ).mp hn

theorem label_range {δ x m : ℝ} (hδ : 0 < δ)
    (u : AddCircle (1 : ℝ)) (hx : |x - m| ≤ 4 * δ) :
    label δ u x ∈ Finset.Icc (label δ u m - 5) (label δ u m + 5) := by
  have hd : |x / δ + shift u - (m / δ + shift u)| ≤ 4 := by
    rw [show x / δ + shift u - (m / δ + shift u) = (x - m) / δ by ring,
      abs_div, abs_of_pos hδ]
    exact (div_le_iff₀ hδ).mpr hx
  have hx₀ := Int.floor_le (x / δ + shift u)
  have hx₁ := Int.lt_floor_add_one (x / δ + shift u)
  have hm₀ := Int.floor_le (m / δ + shift u)
  have hm₁ := Int.lt_floor_add_one (m / δ + shift u)
  obtain ⟨hl, hr⟩ := abs_le.mp hd
  apply Finset.mem_Icc.mpr
  constructor <;> unfold label
  · have : (⌊m / δ + shift u⌋ : ℝ) - 5 ≤ (⌊x / δ + shift u⌋ : ℝ) := by linarith
    exact_mod_cast this
  · have : (⌊x / δ + shift u⌋ : ℝ) ≤ (⌊m / δ + shift u⌋ : ℝ) + 5 := by linarith
    exact_mod_cast this

theorem alphabet_log_bound {α : Type u} (s : Finset α) (k : ℕ)
    (X : α → Fin k → ℝ) (m : Fin k → ℝ) {δ : ℝ} (hδ : 0 < δ)
    (u : AddCircle (1 : ℝ)) (hs : s.Nonempty)
    (hX : ∀ x ∈ s, ∀ i, |X x i - m i| ≤ 4 * δ) :
    Real.log (s.image (fun x i => label δ u (X x i))).card ≤
      4 * k * Real.log 2 := by
  classical
  let T := Fintype.piFinset
    (fun i : Fin k => Finset.Icc (label δ u (m i) - 5) (label δ u (m i) + 5))
  have hc : (s.image (fun x i => label δ u (X x i))).card ≤ 11 ^ k := by
    calc
      _ ≤ T.card := Finset.card_le_card (by
        intro f hf
        obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hf
        apply Fintype.mem_piFinset.mpr
        intro i
        exact label_range hδ u (hX x hx i))
      _ = 11 ^ k := by
        simp only [T, Fintype.card_piFinset, Int.card_Icc]
        simp [show ∀ n : ℤ, n + 5 + 1 - (n - 5) = 11 by intro n; ring]
  have hp : (0 : ℝ) < (s.image (fun x i => label δ u (X x i))).card := by
    exact_mod_cast Finset.card_pos.mpr (hs.image _)
  calc
    _ ≤ Real.log ((16 : ℝ) ^ k) := by
      apply Real.log_le_log hp
      exact_mod_cast hc.trans (Nat.pow_le_pow_left (by norm_num) k)
    _ = _ := by
      rw [Real.log_pow, show (16 : ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
      ring

theorem flag_bound {α : Type u} (s : Finset α) (p : α → ℝ)
    (k : ℕ) (hk : 1 ≤ k) (X : α → Fin k → ℝ) (m : Fin k → ℝ)
    (δ : ℝ) (hδ : 0 < δ) (u : AddCircle (1 : ℝ)) (a : ℝ)
    (ha : ∀ i, a ≤ δ * dist u (-(m i / δ : ℝ) : AddCircle (1 : ℝ)))
    (hp : ∀ x ∈ s, 0 ≤ p x) (hp1 : ∑ x ∈ s, p x = 1)
    (hX : ∀ x ∈ s, ∀ i, |X x i - m i| ≤ 4 * δ)
    (hind : ∀ i j : Fin k, i ≠ j →
      (∑ x ∈ s, if a / (4 * k) ≤ |X x i - m i| ∧
        a / (4 * k) ≤ |X x j - m j| then p x else 0) =
      (∑ x ∈ s, if a / (4 * k) ≤ |X x i - m i| then p x else 0) *
      (∑ x ∈ s, if a / (4 * k) ≤ |X x j - m j| then p x else 0)) :
    conditionalEntropy s p (fun x i => label δ u (X x i)) (fun x => ∑ i, X x i) ≤
      11 * k * (∑ i, ∑ x ∈ s, if a / (4 * k) ≤ |X x i - m i|
        then p x else 0) * Real.log 2 := by
  classical
  let Ex := fun (i : Fin k) x => a / (4 * k) ≤ |X x i - m i|
  let E : α → Bool := fun x => decide (∃ i j, i ≠ j ∧ Ex i x ∧ Ex j x)
  let B : ℝ → Prop := fun y => a / 2 ≤ |y - ∑ i, m i|
  let Y := fun x => ∑ i, X x i
  let C := fun x i => label δ u (X x i)
  let t := ∑ i, ∑ x ∈ s, if Ex i x then p x else 0
  let q := ∑ x ∈ s, if ∃ i j, i ≠ j ∧ Ex i x ∧ Ex j x then p x else 0
  let b := ∑ x ∈ s, if B (Y x) then p x else 0
  have hkR : (0 : ℝ) < k := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hk)
  have ht : 0 ≤ t := Finset.sum_nonneg (fun _ _ =>
    Finset.sum_nonneg (fun x hx => by split_ifs <;> first | exact hp x hx | exact le_rfl))
  have hq : 0 ≤ q := Finset.sum_nonneg
    (fun x hx => by split_ifs <;> first | exact hp x hx | exact le_rfl)
  have hb : 0 ≤ b := Finset.sum_nonneg
    (fun x hx => by split_ifs <;> first | exact hp x hx | exact le_rfl)
  have hq1 : q ≤ 1 := by
    rw [← hp1]
    apply Finset.sum_le_sum
    intro x hx
    split_ifs <;> first | exact le_rfl | exact hp x hx
  have hqt : q ≤ t ^ 2 ∧ q ≤ t := by
    convert two_exceptions_bound s p Ex hp hind using 2 <;>
      apply Finset.sum_congr rfl <;> intro x hx <;> split_ifs <;> rfl
  have hbt : b ≤ t := by
    apply le_trans _ (event_union_bound s p Ex hp)
    apply Finset.sum_le_sum
    intro x hx
    by_cases hbx : B (Y x)
    · rw [if_pos hbx]
      have he : ∃ i, Ex i x := by
        by_contra hn
        have hi : ∀ i, |X x i - m i| < a / (4 * k) :=
          fun i => lt_of_not_ge (fun h => hn ⟨i, h⟩)
        have ha' : 0 < a := by
          have h := (abs_nonneg (X x ⟨0, by omega⟩ - m ⟨0, by omega⟩)).trans_lt
            (hi ⟨0, by omega⟩)
          exact (div_pos_iff_of_pos_right (by positivity : (0 : ℝ) < 4 * k)).mp h
        have hh : |∑ i, (X x i - m i)| ≤ a / 4 := by
          apply (Finset.abs_sum_le_sum_abs _ _).trans
          calc
            (∑ i, |X x i - m i|) ≤ ∑ _i : Fin k, a / (4 * k) :=
              Finset.sum_le_sum (fun i _ => (hi i).le)
            _ = a / 4 := by
              simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
              field_simp
        dsimp only [B, Y] at hbx
        rw [Finset.sum_sub_distrib] at hh
        linarith
      rw [if_pos he]
    · rw [if_neg hbx]
      split_ifs <;> first | exact hp x hx | exact le_rfl
  have hf := conditionalEntropy_rare_flag s p C Y E B
    (fun i => label δ u (m i)) hp hp1 ?_
  · have heq : mass s p E true = q := by
      simp only [mass, Finset.sum_filter, E, decide_eq_true_eq, q]
    have hbeq : (∑ x ∈ s.filter (fun x => B (Y x)), p x) = b := by
      simp only [Finset.sum_filter, b]
    rw [heq, hbeq] at hf
    have hs : s.Nonempty := by
      by_contra hn
      rw [Finset.not_nonempty_iff_eq_empty.mp hn, Finset.sum_empty] at hp1
      norm_num at hp1
    have hcard := alphabet_log_bound s k X m hδ u hs hX
    have hm := mul_le_mul_of_nonneg_left hcard (add_nonneg hq hb)
    have hsqrt : Real.sqrt q ≤ t := (Real.sqrt_le_left ht).mpr hqt.1
    have hbin : Real.binEntropy q ≤ 3 * t * Real.log 2 := by
      apply (div_le_iff₀ (Real.log_pos (by norm_num : (1 : ℝ) < 2))).mp
      exact (binEntropy_bits_le_three_sqrt hq hq1).trans (by linarith)
    have hqb : q + b ≤ 2 * t := by linarith [hqt.2]
    have hqb' := mul_le_mul_of_nonneg_right hqb
      (by positivity : 0 ≤ 4 * (k : ℝ) * Real.log 2)
    have hk1 : (1 : ℝ) ≤ k := by exact_mod_cast hk
    have hlast := mul_nonneg (sub_nonneg.mpr hk1)
      (mul_nonneg ht (Real.log_pos (by norm_num : (1 : ℝ) < 2)).le)
    change conditionalEntropy s p C Y ≤ 11 * k * t * Real.log 2
    nlinarith
  · intro x hx hEx hBx
    have hm : |∑ i, (X x i - m i)| < a / 2 := by
      simpa only [Finset.sum_sub_distrib] using lt_of_not_ge hBx
    have ha' : 0 < a := by linarith [abs_nonneg (∑ i, (X x i - m i))]
    have hn : ¬∃ i j, i ≠ j ∧ Ex i x ∧ Ex j x := by
      simpa only [E, decide_eq_false_iff_not] using hEx
    funext i
    by_contra hne
    have hfar := (ha i).trans (changed_label_margin hδ u hne)
    have hnear := no_large_coordinate (fun i => X x i - m i) ha'
      (by simpa only [Fintype.card_fin] using hn) hm i
    linarith

theorem hit_nonneg (c : AddCircle (1 : ℝ)) (r : ℝ) (u : AddCircle (1 : ℝ)) :
    0 ≤ Circle.hit c r u := by unfold Circle.hit; split_ifs <;> norm_num

theorem refinement_hit_bound {α : Type u} (s : Finset α) (p : α → ℝ)
    (k : ℕ) (hk : 1 ≤ k) (X : α → Fin k → ℝ) (m : Fin k → ℝ)
    (δ : ℝ) (hδ : 0 < δ) (u : AddCircle (1 : ℝ))
    (hp : ∀ x ∈ s, 0 ≤ p x) (hp1 : ∑ x ∈ s, p x = 1)
    (hX : ∀ x ∈ s, ∀ i, |X x i - m i| ≤ 4 * δ)
    (hind : ∀ a : ℝ, ∀ i j : Fin k, i ≠ j →
      (∑ x ∈ s, if a / (4 * k) ≤ |X x i - m i| ∧
        a / (4 * k) ≤ |X x j - m j| then p x else 0) =
      (∑ x ∈ s, if a / (4 * k) ≤ |X x i - m i| then p x else 0) *
      (∑ x ∈ s, if a / (4 * k) ≤ |X x j - m j| then p x else 0)) :
    conditionalEntropy s p (fun x i => label δ u (X x i)) (fun x => ∑ i, X x i) ≤
      11 * k * (∑ x ∈ s, p x * ∑ i, ∑ j,
        Circle.hit (-(m j / δ : ℝ) : AddCircle (1 : ℝ))
          (4 * k * |X x i - m i| / δ) u) * Real.log 2 := by
  classical
  have hkR : (0 : ℝ) < k := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hk)
  let d : Fin k → ℝ := fun i => dist u (-(m i / δ : ℝ) : AddCircle (1 : ℝ))
  have hne : (Finset.univ : Finset (Fin k)).Nonempty :=
    ⟨⟨0, by omega⟩, Finset.mem_univ _⟩
  obtain ⟨j₀, _, hj₀⟩ := Finset.exists_min_image Finset.univ d hne
  let a := δ * d j₀
  have ha : ∀ i, a ≤ δ * d i :=
    fun i => mul_le_mul_of_nonneg_left (hj₀ i (Finset.mem_univ i)) hδ.le
  apply (flag_bound s p k hk X m δ hδ u a ha hp hp1 hX (hind a)).trans
  apply mul_le_mul_of_nonneg_right _ (Real.log_pos (by norm_num : (1 : ℝ) < 2)).le
  apply mul_le_mul_of_nonneg_left _ (by positivity : 0 ≤ (11 : ℝ) * k)
  rw [Finset.sum_comm]
  apply Finset.sum_le_sum
  intro x hx
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro i _
  by_cases he : a / (4 * k) ≤ |X x i - m i|
  · rw [if_pos he]
    have hdist : d j₀ ≤ 4 * k * |X x i - m i| / δ := by
      apply (le_div_iff₀ hδ).mpr
      have hh := (div_le_iff₀ (by positivity : (0 : ℝ) < 4 * k)).mp he
      dsimp only [a] at hh
      nlinarith
    have hone : Circle.hit (-(m j₀ / δ : ℝ) : AddCircle (1 : ℝ))
        (4 * k * |X x i - m i| / δ) u = 1 := if_pos hdist
    have hs : 1 ≤ ∑ j, Circle.hit (-(m j / δ : ℝ) : AddCircle (1 : ℝ))
        (4 * k * |X x i - m i| / δ) u := by
      have hh := Finset.single_le_sum (s := (Finset.univ : Finset (Fin k)))
        (f := fun j => Circle.hit (-(m j / δ : ℝ) : AddCircle (1 : ℝ))
          (4 * k * |X x i - m i| / δ) u)
        (fun j _ => hit_nonneg _ _ _) (Finset.mem_univ j₀)
      simpa only [hone] using hh
    simpa only [mul_one] using mul_le_mul_of_nonneg_left hs (hp x hx)
  · rw [if_neg he]
    exact mul_nonneg (hp x hx) (Finset.sum_nonneg (fun j _ => hit_nonneg _ _ _))

attribute [local instance] Circle.unitCircleProbability

theorem select_shift {α : Type u} (s : Finset α) (w : α → ℝ)
    (c : α → AddCircle (1 : ℝ)) (r : α → ℝ)
    (hw : ∀ x ∈ s, 0 ≤ w x) (hr : ∀ x ∈ s, 0 ≤ r x) :
    ∃ u : AddCircle (1 : ℝ),
      (∑ x ∈ s, w x * Circle.hit (c x) (r x) u) ≤
        ∑ x ∈ s, w x * (2 * r x) := by
  have hi : ∀ x ∈ s, Integrable (fun u => w x * Circle.hit (c x) (r x) u) :=
    fun x _ => (Circle.hit_integrable (c x) (r x)).const_mul (w x)
  obtain ⟨u, hu⟩ := exists_le_integral (integrable_finsetSum s hi)
  refine ⟨u, hu.trans ?_⟩
  rw [integral_finsetSum s hi]
  apply Finset.sum_le_sum
  intro x hx
  rw [integral_const_mul, Circle.integral_hit (c x) (hr x hx)]
  exact mul_le_mul_of_nonneg_left (min_le_right _ _) (hw x hx)

theorem select_variation {α : Type u} (s : Finset α) (p : α → ℝ)
    (k : ℕ) (X m : α → Fin k → ℝ) (δ : ℝ) (hδ : 0 < δ)
    (hp : ∀ x ∈ s, 0 ≤ p x) :
    ∃ u : AddCircle (1 : ℝ),
      (∑ x ∈ s, p x * ∑ i, ∑ j,
        Circle.hit (-(m x j / δ : ℝ) : AddCircle (1 : ℝ))
          (4 * k * |X x i - m x i| / δ) u) ≤
      (8 * k ^ 2 / δ) * (∑ x ∈ s, p x * ∑ i, |X x i - m x i|) := by
  classical
  let T : Finset (α × Fin k × Fin k) := s ×ˢ (Finset.univ ×ˢ Finset.univ)
  obtain ⟨u, hu⟩ := select_shift T (fun z => p z.1)
    (fun z => (-(m z.1 z.2.2 / δ : ℝ) : AddCircle (1 : ℝ)))
    (fun z => 4 * k * |X z.1 z.2.1 - m z.1 z.2.1| / δ)
    (fun z hz => hp z.1 (Finset.mem_product.mp hz).1) (fun z _ => by positivity)
  refine ⟨u, ?_⟩
  have he : (∑ z ∈ T, p z.1 * Circle.hit
      (-(m z.1 z.2.2 / δ : ℝ) : AddCircle (1 : ℝ))
      (4 * k * |X z.1 z.2.1 - m z.1 z.2.1| / δ) u) =
      ∑ x ∈ s, p x * ∑ i, ∑ j, Circle.hit
        (-(m x j / δ : ℝ) : AddCircle (1 : ℝ))
        (4 * k * |X x i - m x i| / δ) u := by
    simp only [T, Finset.sum_product, Finset.mul_sum]
  rw [he] at hu
  apply hu.trans
  have he' : (∑ z ∈ T, p z.1 * (2 * (4 * k * |X z.1 z.2.1 - m z.1 z.2.1| / δ))) =
      (8 * k ^ 2 / δ) * (∑ x ∈ s, p x * ∑ i, |X x i - m x i|) := by
    simp only [T, Finset.sum_product, Finset.sum_const, Finset.card_univ,
      Fintype.card_fin, nsmul_eq_mul, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _
    apply Finset.sum_congr rfl
    intro i _
    ring
  exact he'.le

section ConditionalRefinement

variable {α : Type u} {β : Type v} [Fintype α] [DecidableEq β]

def center (p : α → ℝ) (X : α → ℝ) (g : α → β) (b : β) : ℝ :=
  ∑ x, ((if g x = b then p x else 0) / mass Finset.univ p g b) * X x

theorem average_distance (p X : α → ℝ) (z R : ℝ)
    (hp : ∀ x, 0 ≤ p x) (hp1 : ∑ x, p x = 1)
    (hR : ∀ x, p x ≠ 0 → |z - X x| ≤ R) :
    |z - ∑ x, p x * X x| ≤ R := by
  have he : z - ∑ x, p x * X x = ∑ x, p x * (z - X x) := by
    simp only [mul_sub, Finset.sum_sub_distrib, ← Finset.sum_mul, hp1, one_mul]
  rw [he]
  apply (Finset.abs_sum_le_sum_abs _ _).trans
  calc
    (∑ x, |p x * (z - X x)|) ≤ ∑ x, p x * R := by
      apply Finset.sum_le_sum
      intro x _
      rw [abs_mul, abs_of_nonneg (hp x)]
      by_cases hx : p x = 0
      · simp only [hx, zero_mul, le_refl]
      · exact mul_le_mul_of_nonneg_left (hR x hx) (hp x)
    _ = R := by rw [← Finset.sum_mul, hp1, one_mul]

theorem positive_mass (p : α → ℝ) (g : α → β) (hp : ∀ x, 0 < p x)
    {b : β} (hb : b ∈ Finset.univ.image g) : 0 < mass Finset.univ p g b := by
  classical
  obtain ⟨x, _, rfl⟩ := Finset.mem_image.mp hb
  apply (hp x).trans_le
  apply Finset.single_le_sum (fun y _ => (hp y).le)
  simp

theorem conditional_center (p X : α → ℝ) (g : α → β)
    {k : ℕ} (c : Fin k → β) (i : Fin k) :
    (∑ x, ProductLaw.conditional (fun _ : Fin k => p) (fun _ => g) c i x * X x) =
      center p X g (c i) := by
  simp only [center, ProductLaw.conditional, ProductLaw.cellMass, mass, Finset.sum_filter]

theorem center_distance (p X : α → ℝ) (g : α → β)
    (hp : ∀ x, 0 ≤ p x) {k : ℕ} (c : Fin k → β) (i : Fin k)
    (hc : mass Finset.univ (ProductLaw.weight (fun _ : Fin k => p))
      (fun x i => g (x i)) c ≠ 0) (x : α) (hx : g x = c i) (R : ℝ)
    (hd : ∀ x y, g x = g y → |X x - X y| ≤ R) :
    |X x - center p X g (c i)| ≤ R := by
  rw [← conditional_center p X g c i]
  apply average_distance _ _ _ R
    (ProductLaw.conditional_nonneg _ _ _ (fun _ x => hp x) i)
    (ProductLaw.conditional_sum _ _ _ hc i)
  intro y hy
  have hgy : g y = c i := by
    by_contra hn
    exact hy (by simp only [ProductLaw.conditional, if_neg hn, zero_div])
  exact hd x y (hx.trans hgy.symm)

theorem cellwise_refinement (p X : α → ℝ) (g : α → β)
    (hp : ∀ x, 0 < p x) (k : ℕ) (hk : 1 ≤ k) (δ : ℝ) (hδ : 0 < δ)
    (hd : ∀ x y, g x = g y → |X x - X y| ≤ 4 * δ)
    (u : AddCircle (1 : ℝ)) (c : Fin k → β)
    (hc : c ∈ (Finset.univ : Finset (Fin k → α)).image (fun x i => g (x i))) :
    conditionalEntropy (Finset.univ.filter (fun x : Fin k → α => (fun i => g (x i)) = c))
      (fun x => ProductLaw.weight (fun _ : Fin k => p) x /
        mass Finset.univ (ProductLaw.weight (fun _ : Fin k => p)) (fun x i => g (x i)) c)
      (fun x i => label δ u (X (x i))) (fun x => ∑ i, X (x i)) ≤
    11 * k * (∑ x ∈ Finset.univ.filter (fun x : Fin k → α => (fun i => g (x i)) = c),
      (ProductLaw.weight (fun _ : Fin k => p) x /
        mass Finset.univ (ProductLaw.weight (fun _ : Fin k => p)) (fun x i => g (x i)) c) *
      ∑ i, ∑ j, Circle.hit (-(center p X g (c j) / δ : ℝ) : AddCircle (1 : ℝ))
        (4 * k * |X (x i) - center p X g (c i)| / δ) u) * Real.log 2 := by
  classical
  let w := ProductLaw.weight (fun _ : Fin k => p)
  let G := fun (x : Fin k → α) i => g (x i)
  have hw : ∀ x : Fin k → α, 0 < w x :=
    fun x => Finset.prod_pos (fun i _ => hp (x i))
  have hP : 0 < mass Finset.univ w G c :=
    positive_mass w G hw hc
  have hnc := ne_of_gt hP
  let s := Finset.univ.filter (fun x : Fin k → α => G x = c)
  let q := fun x => w x / mass Finset.univ w G c
  let V := fun (x : Fin k → α) i => X (x i)
  let m := fun i => center p X g (c i)
  have hq : ∀ x ∈ s, 0 ≤ q x := fun x _ => div_nonneg (hw x).le hP.le
  have hq1 : ∑ x ∈ s, q x = 1 := by
    rw [show (∑ x ∈ s, q x) = mass Finset.univ w G c / mass Finset.univ w G c by
      exact (Finset.sum_div _ _ _).symm]
    exact div_self hnc
  have hV : ∀ x ∈ s, ∀ i, |V x i - m i| ≤ 4 * δ := by
    intro x hx i
    have he : G x = c := (Finset.mem_filter.mp hx).2
    exact center_distance p X g (fun x => (hp x).le) c i hnc (x i)
      (congrFun he i) (4 * δ) hd
  have hind : ∀ a : ℝ, ∀ i j : Fin k, i ≠ j →
      (∑ x ∈ s, if a / (4 * k) ≤ |V x i - m i| ∧
        a / (4 * k) ≤ |V x j - m j| then q x else 0) =
      (∑ x ∈ s, if a / (4 * k) ≤ |V x i - m i| then q x else 0) *
      (∑ x ∈ s, if a / (4 * k) ≤ |V x j - m j| then q x else 0) := by
    intro a i j hij
    let E := fun (i : Fin k) x => a / (4 * k) ≤ |X x - center p X g (c i)|
    have h := ProductLaw.two_coordinate_events
      (ProductLaw.conditional (fun _ : Fin k => p) (fun _ => g) c) E
      (ProductLaw.conditional_sum _ _ _ hnc) i j hij
    rw [← ProductLaw.conditional_event (fun _ : Fin k => p) (fun _ => g) c
      (fun x => E i (x i) ∧ E j (x j)),
      ← ProductLaw.conditional_event (fun _ : Fin k => p) (fun _ => g) c (fun x => E i (x i)),
      ← ProductLaw.conditional_event (fun _ : Fin k => p) (fun _ => g) c (fun x => E j (x j))] at h
    exact h
  exact refinement_hit_bound s q k hk V m δ hδ u hq hq1 hV hind

theorem disintegrated_refinement (p X : α → ℝ) (g : α → β)
    (hp : ∀ x, 0 < p x) (k : ℕ) (hk : 1 ≤ k) (δ : ℝ) (hδ : 0 < δ)
    (hd : ∀ x y, g x = g y → |X x - X y| ≤ 4 * δ)
    (u : AddCircle (1 : ℝ)) :
    conditionalEntropy Finset.univ (ProductLaw.weight (fun _ : Fin k => p))
      (fun x i => label δ u (X (x i))) (fun x => (∑ i, X (x i), fun i => g (x i))) ≤
      11 * k * (∑ x : Fin k → α, ProductLaw.weight (fun _ : Fin k => p) x *
        ∑ i, ∑ j, Circle.hit
          (-(center p X g (g (x j)) / δ : ℝ) : AddCircle (1 : ℝ))
          (4 * k * |X (x i) - center p X g (g (x i))| / δ) u) * Real.log 2 := by
  classical
  let w := ProductLaw.weight (fun _ : Fin k => p)
  let G := fun (x : Fin k → α) i => g (x i)
  let Y := fun (x : Fin k → α) => ∑ i, X (x i)
  let C := fun (x : Fin k → α) i => label δ u (X (x i))
  let P := mass Finset.univ w G
  let cost := fun (c : Fin k → β) (x : Fin k → α) => ∑ i, ∑ j,
    Circle.hit (-(center p X g (c j) / δ : ℝ) : AddCircle (1 : ℝ))
      (4 * k * |X (x i) - center p X g (c i)| / δ) u
  have hw : ∀ x : Fin k → α, 0 < w x :=
    fun x => Finset.prod_pos (fun i _ => hp (x i))
  have hP : ∀ c ∈ Finset.univ.image G, 0 < P c :=
    fun c hc => positive_mass w G hw hc
  rw [conditionalEntropy_disintegrate Finset.univ w C G Y (fun x _ => (hw x).le)]
  calc
    _ ≤ ∑ c ∈ Finset.univ.image G, P c *
        (11 * k * (∑ x ∈ Finset.univ.filter (fun x => G x = c),
          (w x / P c) * cost c x) * Real.log 2) := by
      apply Finset.sum_le_sum
      intro c hc
      exact mul_le_mul_of_nonneg_left
        (cellwise_refinement p X g hp k hk δ hδ hd u c hc) (hP c hc).le
    _ = 11 * k * (∑ c ∈ Finset.univ.image G,
        ∑ x ∈ Finset.univ.filter (fun x => G x = c), w x * cost (G x) x) * Real.log 2 := by
      simp only [Finset.sum_mul, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro c hc
      apply Finset.sum_congr rfl
      intro x hx
      rw [(Finset.mem_filter.mp hx).2]
      field_simp [ne_of_gt (hP c hc)]
    _ = _ := by
      rw [Finset.sum_fiberwise_of_maps_to
        (fun x (_ : x ∈ Finset.univ) => Finset.mem_image_of_mem G (Finset.mem_univ x))]

theorem expected_center_deviation (p X : α → ℝ) (g : α → β)
    (hp1 : ∑ x, p x = 1) (k : ℕ) :
    (∑ x : Fin k → α, ProductLaw.weight (fun _ : Fin k => p) x *
      ∑ i, |X (x i) - center p X g (g (x i))|) =
      k * ∑ x, p x * |X x - center p X g (g x)| := by
  classical
  simp only [Finset.mul_sum]
  rw [Finset.sum_comm]
  have h : ∀ i : Fin k,
      (∑ x : Fin k → α, ProductLaw.weight (fun _ : Fin k => p) x *
        |X (x i) - center p X g (g (x i))|) =
      ∑ x, p x * |X x - center p X g (g x)| := by
    intro i
    simpa only [Finset.prod_singleton] using ProductLaw.moment (fun _ : Fin k => p)
      (fun _ x => |X x - center p X g (g x)|) {i} (fun _ => hp1)
  simp only [h, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  rw [Finset.mul_sum]

theorem choose_refinement (p X : α → ℝ) (g : α → β)
    (hp : ∀ x, 0 < p x) (hp1 : ∑ x, p x = 1)
    (k : ℕ) (hk : 1 ≤ k) (δ : ℝ) (hδ : 0 < δ)
    (hd : ∀ x y, g x = g y → |X x - X y| ≤ 4 * δ) :
    ∃ u : AddCircle (1 : ℝ),
      conditionalEntropy Finset.univ (ProductLaw.weight (fun _ : Fin k => p))
        (fun x i => label δ u (X (x i))) (fun x => (∑ i, X (x i), fun i => g (x i))) ≤
      (88 * k ^ 4 / δ) * (∑ x, p x * |X x - center p X g (g x)|) * Real.log 2 := by
  classical
  obtain ⟨u, hu⟩ := select_variation Finset.univ
    (ProductLaw.weight (fun _ : Fin k => p)) k (fun x i => X (x i))
    (fun x i => center p X g (g (x i))) δ hδ
    (fun x _ => ProductLaw.weight_nonneg _ (fun _ x => (hp x).le) x)
  refine ⟨u, (disintegrated_refinement p X g hp k hk δ hδ hd u).trans ?_⟩
  have hm := mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_left hu (by positivity : 0 ≤ (11 : ℝ) * k))
    (Real.log_pos (by norm_num : (1 : ℝ) < 2)).le
  rw [expected_center_deviation p X g hp1 k] at hm
  convert hm using 1 <;> ring

theorem append_refinement (p X : α → ℝ) (g : α → List ℤ)
    (hp : ∀ x, 0 ≤ p x) (k : ℕ) (δ : ℝ) (u : AddCircle (1 : ℝ)) :
    conditionalEntropy Finset.univ (ProductLaw.weight (fun _ : Fin k => p))
      (fun x i => label δ u (X (x i)) :: g (x i)) (fun x => ∑ i, X (x i)) =
    conditionalEntropy Finset.univ (ProductLaw.weight (fun _ : Fin k => p))
      (fun x i => g (x i)) (fun x => ∑ i, X (x i)) +
    conditionalEntropy Finset.univ (ProductLaw.weight (fun _ : Fin k => p))
      (fun x i => label δ u (X (x i))) (fun x => (∑ i, X (x i), fun i => g (x i))) := by
  classical
  let w := ProductLaw.weight (fun _ : Fin k => p)
  let G := fun (x : Fin k → α) i => g (x i)
  let C := fun (x : Fin k → α) i => label δ u (X (x i))
  let Y := fun (x : Fin k → α) => ∑ i, X (x i)
  have hw : ∀ x ∈ (Finset.univ : Finset (Fin k → α)), 0 ≤ w x :=
    fun x _ => ProductLaw.weight_nonneg _ (fun _ x => hp x) x
  have he := conditionalEntropy_eq_of_fibers Finset.univ w
    (fun x i => C x i :: G x i) (fun x => (C x, G x)) Y hw (by
      intro x _ y _
      constructor
      · intro h
        apply Prod.ext
        · funext i
          exact (List.cons.inj (congrFun h i)).1
        · funext i
          exact (List.cons.inj (congrFun h i)).2
      · intro h
        rw [Prod.mk.injEq] at h
        rw [h.1, h.2])
  rw [he, conditionalEntropy_chain Finset.univ w C G Y hw,
    conditionalEntropy_condition_swap Finset.univ w C G Y hw]

end ConditionalRefinement

def bands (ν : Law) : Finset ℤ :=
  (ν.support ×ˢ ν.support).image (fun e => bandIndex |e.2 - e.1|)

def distanceCost (ν : Law) (R : ℝ) : ℝ :=
  ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ R),
    (2 : ℝ) ^ (1 - ℓ) * capacity ν ℓ

theorem fractional_band_witness (ν : Law) (ℓ : ℤ) (π : ℝ → ℝ → ℝ)
    (hn : ∀ x ∈ ν.support, ∀ y ∈ ν.support, 0 ≤ π x y)
    (hs : ∀ x ∈ ν.support, ∀ y ∈ ν.support, π x y = π y x)
    (hr : ∀ x ∈ ν.support, ∑ y ∈ ν.support, π x y ≤ ν.prob x) :
    ∃ w : ν.edges ℓ → ℝ, Feasible w ∧
      (∀ e, w e = 2 * π e.val.1 e.val.2) ∧
      (∑ e, w e) = ∑ x ∈ ν.support, ∑ y ∈ ν.support,
        if (2 : ℝ) ^ (-ℓ) ≤ |y - x| ∧ |y - x| < (2 : ℝ) ^ (1 - ℓ)
        then π x y else 0 := by
  classical
  let w : ν.edges ℓ → ℝ := fun e => 2 * π e.val.1 e.val.2
  refine ⟨w, ?_, fun _ => rfl, ?_⟩
  · constructor
    · intro e
      exact mul_nonneg (by norm_num) (hn _ (edge_mem_left e) _ (edge_mem_right e))
    · intro x hx
      rw [coupling_incident ℓ π hs hx]
      apply le_trans _ (hr x hx)
      apply Finset.sum_le_sum
      intro y hy
      split_ifs
      · exact le_rfl
      · exact hn x hx y hy
  · rw [← incident_sum w]
    apply Finset.sum_congr rfl
    intro x hx
    exact coupling_incident ℓ π hs hx

theorem band_mass_bound (ν : Law) (ℓ : ℤ) (π : ℝ → ℝ → ℝ)
    (hn : ∀ x ∈ ν.support, ∀ y ∈ ν.support, 0 ≤ π x y)
    (hs : ∀ x ∈ ν.support, ∀ y ∈ ν.support, π x y = π y x)
    (hr : ∀ x ∈ ν.support, ∑ y ∈ ν.support, π x y ≤ ν.prob x) :
    (∑ x ∈ ν.support, ∑ y ∈ ν.support,
      if (2 : ℝ) ^ (-ℓ) ≤ |y - x| ∧ |y - x| < (2 : ℝ) ^ (1 - ℓ)
      then π x y else 0) ≤ capacity ν ℓ := by
  obtain ⟨w, hw, _, he⟩ := fractional_band_witness ν ℓ π hn hs hr
  rw [← he]
  exact total_le_capacity hw

theorem coupling_cost_bound (ν : Law) (π : ℝ → ℝ → ℝ) (R : ℝ)
    (hn : ∀ x ∈ ν.support, ∀ y ∈ ν.support, 0 ≤ π x y)
    (hs : ∀ x ∈ ν.support, ∀ y ∈ ν.support, π x y = π y x)
    (hr : ∀ x ∈ ν.support, ∑ y ∈ ν.support, π x y ≤ ν.prob x)
    (hd : ∀ x ∈ ν.support, ∀ y ∈ ν.support, R < |y - x| → π x y = 0) :
    (∑ x ∈ ν.support, ∑ y ∈ ν.support, π x y * |y - x|) ≤ distanceCost ν R := by
  classical
  let B := (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ R)
  let M := fun (ℓ : ℤ) (x y : ℝ) =>
    if (2 : ℝ) ^ (-ℓ) ≤ |y - x| ∧ |y - x| < (2 : ℝ) ^ (1 - ℓ)
    then π x y else 0
  have hM : ∀ ℓ x y, x ∈ ν.support → y ∈ ν.support → 0 ≤ M ℓ x y := by
    intro ℓ x y hx hy
    dsimp [M]
    split_ifs <;> first | exact hn x hx y hy | exact le_rfl
  calc
    _ ≤ ∑ x ∈ ν.support, ∑ y ∈ ν.support,
        ∑ ℓ ∈ B, (2 : ℝ) ^ (1 - ℓ) * M ℓ x y := by
      apply Finset.sum_le_sum
      intro x hx
      apply Finset.sum_le_sum
      intro y hy
      by_cases hz : |y - x| = 0
      · rw [hz, mul_zero]
        exact Finset.sum_nonneg (fun ℓ _ =>
          mul_nonneg (zpow_pos (by norm_num) _).le (hM ℓ x y hx hy))
      by_cases hR : R < |y - x|
      · rw [hd x hx y hy hR, zero_mul]
        exact Finset.sum_nonneg (fun ℓ _ =>
          mul_nonneg (zpow_pos (by norm_num) _).le (hM ℓ x y hx hy))
      have hu : 0 < |y - x| := lt_of_le_of_ne (abs_nonneg _) (Ne.symm hz)
      have hb := mem_bandIndex hu
      have hm : bandIndex |y - x| ∈ B :=
        Finset.mem_filter.mpr
          ⟨Finset.mem_image.mpr ⟨(x, y), Finset.mem_product.mpr ⟨hx, hy⟩, rfl⟩,
            hb.1.trans (le_of_not_gt hR)⟩
      apply le_trans _ (Finset.single_le_sum (fun ℓ _ =>
        mul_nonneg (zpow_pos (by norm_num) _).le (hM ℓ x y hx hy)) hm)
      dsimp only [M]
      rw [if_pos hb]
      simpa only [mul_comm] using mul_le_mul_of_nonneg_left hb.2.le (hn x hx y hy)
    _ = ∑ ℓ ∈ B, (2 : ℝ) ^ (1 - ℓ) *
        ∑ x ∈ ν.support, ∑ y ∈ ν.support, M ℓ x y := by
      conv_lhs =>
        arg 2
        intro x
        rw [Finset.sum_comm]
      rw [Finset.sum_comm]
      simp only [Finset.mul_sum]
    _ ≤ _ := by
      apply Finset.sum_le_sum
      intro ℓ _
      exact mul_le_mul_of_nonneg_left (band_mass_bound ν ℓ π hn hs hr)
        (zpow_pos (by norm_num : (0 : ℝ) < 2) _).le

theorem center_jensen {α : Type u} {β : Type v} [Fintype α] [DecidableEq β]
    (p X : α → ℝ) (g : α → β) (hp : ∀ x, 0 < p x) :
    (∑ x, p x * |X x - center p X g (g x)|) ≤
      ∑ x, ∑ y, (if g x = g y then p x * p y / mass Finset.univ p g (g x) else 0) *
        |X x - X y| := by
  classical
  apply Finset.sum_le_sum
  intro x _
  have hP : 0 < mass Finset.univ p g (g x) :=
    positive_mass p g hp (Finset.mem_image.mpr ⟨x, Finset.mem_univ x, rfl⟩)
  let q : α → ℝ := fun y => (if g y = g x then p y else 0) / mass Finset.univ p g (g x)
  have hq : ∀ y, 0 ≤ q y := by
    intro y
    exact div_nonneg
      (by split_ifs <;> first | exact (hp y).le | exact le_rfl) hP.le
  have hq1 : ∑ y, q y = 1 := by
    dsimp only [q]
    rw [← Finset.sum_div]
    simpa only [mass, Finset.sum_filter] using div_self (ne_of_gt hP)
  have he : X x - center p X g (g x) = ∑ y, q y * (X x - X y) := by
    simp only [mul_sub, Finset.sum_sub_distrib, ← Finset.sum_mul, hq1, one_mul]
    rfl
  rw [he]
  calc
    p x * |∑ y, q y * (X x - X y)| ≤ p x * ∑ y, |q y * (X x - X y)| :=
      mul_le_mul_of_nonneg_left (Finset.abs_sum_le_sum_abs _ _) (hp x).le
    _ = _ := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro y _
      rw [abs_mul, abs_of_nonneg (hq y)]
      dsimp only [q]
      by_cases hg : g x = g y
      · simp only [hg, ite_true]
        ring
      · simp only [hg, Ne.symm hg, ite_false, zero_div, mul_zero, zero_mul]

theorem support_nonempty (ν : Law) : ν.support.Nonempty := by
  by_contra h
  have hp := ν.prob_sum
  rw [Finset.not_nonempty_iff_eq_empty.mp h, Finset.sum_empty] at hp
  norm_num at hp

theorem support_total (ν : Law) : ∑ x : ν.support, ν.prob x = 1 := by
  simpa only [Finset.sum_coe_sort] using ν.prob_sum

theorem support_mass {β : Type v} [DecidableEq β] (ν : Law) (g : ℝ → β) (b : β) :
    mass Finset.univ (fun x : ν.support => ν.prob x) (fun x => g x) b =
      mass ν.support ν.prob g b := by
  classical
  simp only [mass, Finset.sum_filter]
  exact Finset.sum_coe_sort ν.support (fun x => if g x = b then ν.prob x else 0)

theorem support_double_sum (ν : Law) (f : ℝ → ℝ → ℝ) :
    (∑ x : ν.support, ∑ y : ν.support, f x y) =
      ∑ x ∈ ν.support, ∑ y ∈ ν.support, f x y := by
  calc
    _ = ∑ x : ν.support, ∑ y ∈ ν.support, f x y := by
      apply Finset.sum_congr rfl
      intro x _
      exact Finset.sum_coe_sort ν.support (f x)
    _ = _ := Finset.sum_coe_sort ν.support (fun x => ∑ y ∈ ν.support, f x y)

theorem center_cost_bound {β : Type v} [DecidableEq β] (ν : Law) (g : ℝ → β) (R : ℝ)
    (hd : ∀ x ∈ ν.support, ∀ y ∈ ν.support, g x = g y → |x - y| ≤ R) :
    (∑ x : ν.support, ν.prob x *
      |(x : ℝ) - center (fun y : ν.support => ν.prob y) (fun y => (y : ℝ))
        (fun y => g y) (g x)|) ≤ distanceCost ν R := by
  classical
  have hj := center_jensen (fun x : ν.support => ν.prob x) (fun x => (x : ℝ))
    (fun x => g x) (fun x => ν.prob_pos x x.property)
  have he : (∑ x : ν.support, ∑ y : ν.support,
      (if g x = g y then ν.prob x * ν.prob y /
        mass Finset.univ (fun z : ν.support => ν.prob z) (fun z => g z) (g x) else 0) *
        |(x : ℝ) - (y : ℝ)|) =
      ∑ x ∈ ν.support, ∑ y ∈ ν.support, conditionalCoupling ν g x y * |y - x| := by
    simp only [support_mass, conditionalCoupling, abs_sub_comm]
    exact support_double_sum ν (fun x y =>
      (if g x = g y then ν.prob x * ν.prob y / mass ν.support ν.prob g (g x) else 0) *
        |x - y|)
  rw [he] at hj
  apply hj.trans
  apply coupling_cost_bound ν (conditionalCoupling ν g) R
    (fun x hx y hy => conditionalCoupling_nonneg ν g hx hy)
    (fun x _ y _ => conditionalCoupling_symm ν g x y)
    (fun x hx => (conditionalCoupling_row ν g hx).le)
  intro x hx y hy hxy
  apply conditionalCoupling_eq_zero_of_ne
  intro heq
  have hh := hd x hx y hy heq
  rw [abs_sub_comm] at hh
  exact (not_le_of_gt hxy) hh

def partitionEntropy (ν : Law) (k : ℕ) (g : ℝ → List ℤ) : ℝ :=
  conditionalEntropy Finset.univ
    (ProductLaw.weight (fun _ : Fin k => fun x : ν.support => ν.prob x))
    (fun x i => g (x i)) (fun x => ∑ i, (x i : ℝ))

def stepCost (ν : Law) (k : ℕ) (R : ℝ) : ℝ :=
  (352 * k ^ 4 / R) * distanceCost ν R * Real.log 2

theorem capacity_refinement (ν : Law) (g : ℝ → List ℤ)
    (k : ℕ) (hk : 1 ≤ k) (R : ℝ) (hR : 0 < R)
    (hd : ∀ x ∈ ν.support, ∀ y ∈ ν.support, g x = g y → |x - y| ≤ R) :
    ∃ g' : ℝ → List ℤ,
      (∀ x ∈ ν.support, ∀ y ∈ ν.support, g' x = g' y → |x - y| ≤ R / 4) ∧
      partitionEntropy ν k g' ≤ partitionEntropy ν k g + stepCost ν k R := by
  classical
  let p : ν.support → ℝ := fun x => ν.prob x
  have hp : ∀ x, 0 < p x := fun x => ν.prob_pos x x.property
  obtain ⟨u, hu⟩ := choose_refinement p (fun x => (x : ℝ)) (fun x => g x)
    hp (support_total ν) k hk (R / 4) (by positivity) (by
      intro x y heq
      simpa only [mul_div_cancel₀ _ (by norm_num : (4 : ℝ) ≠ 0)] using
        hd x x.property y y.property heq)
  refine ⟨fun x => label (R / 4) u x :: g x, ?_, ?_⟩
  · intro x _ y _ heq
    exact (equal_labels_close (by positivity) u (List.cons.inj heq).1).le
  · dsimp only [partitionEntropy, stepCost]
    rw [append_refinement p (fun x => (x : ℝ)) (fun x => g x)
      (fun x => (hp x).le) k (R / 4) u]
    apply add_le_add le_rfl
    apply hu.trans
    have hh := mul_le_mul_of_nonneg_right
      (mul_le_mul_of_nonneg_left (center_cost_bound ν g R hd)
        (by positivity : 0 ≤ (88 : ℝ) * k ^ 4 / (R / 4)))
      (Real.log_pos (by norm_num : (1 : ℝ) < 2)).le
    convert hh using 1 <;> ring

theorem finite_refinements (ν : Law) (k : ℕ) (hk : 1 ≤ k)
    (ρ : ℝ) (hρ : 0 < ρ) (J : ℕ) :
    ∃ g : ℝ → List ℤ,
      (∀ x ∈ ν.support, ∀ y ∈ ν.support, g x = g y → |x - y| ≤ ρ / 4 ^ J) ∧
      partitionEntropy ν k g ≤ partitionEntropy ν k (fun x => [⌊x / ρ⌋]) +
        ∑ h ∈ Finset.range J, stepCost ν k (ρ / 4 ^ h) := by
  classical
  induction J with
  | zero =>
    refine ⟨fun x => [⌊x / ρ⌋], ?_, ?_⟩
    · intro x _ y _ heq
      have hh : label ρ 0 x = label ρ 0 y := by
        simpa only [label, shift_zero, add_zero] using (List.cons.inj heq).1
      simpa only [pow_zero, div_one] using (equal_labels_close hρ 0 hh).le
    · simp only [Finset.range_zero, Finset.sum_empty, add_zero, le_refl]
  | succ J ih =>
    obtain ⟨g, hd, hg⟩ := ih
    obtain ⟨g', hd', hg'⟩ := capacity_refinement ν g k hk (ρ / 4 ^ J) (by positivity) hd
    refine ⟨g', ?_, ?_⟩
    · intro x hx y hy heq
      simpa only [pow_succ, div_div] using hd' x hx y hy heq
    · rw [Finset.sum_range_succ]
      linarith

theorem separating_depth (ν : Law) (ρ : ℝ) :
    ∃ J : ℕ, ∀ x ∈ ν.support, ∀ y ∈ ν.support, x ≠ y → ρ / 4 ^ J < |x - y| := by
  classical
  have ht : Filter.Tendsto (fun n : ℕ => ρ / (4 : ℝ) ^ n) Filter.atTop (nhds 0) := by
    have hh := (tendsto_pow_atTop_nhds_zero_of_lt_one
      (by norm_num : (0 : ℝ) ≤ 1 / 4) (by norm_num : (1 : ℝ) / 4 < 1)).const_mul ρ
    simpa only [div_pow, one_pow, mul_zero, div_eq_mul_inv, one_mul, inv_pow] using hh
  have he : ∀ᶠ J : ℕ in Filter.atTop,
      ∀ x ∈ ν.support, ∀ y ∈ ν.support, x ≠ y → ρ / 4 ^ J < |x - y| := by
    apply (Filter.eventually_all_finset ν.support).mpr
    intro x hx
    apply (Filter.eventually_all_finset ν.support).mpr
    intro y hy
    by_cases hxy : x = y
    · exact Filter.Eventually.of_forall (fun _ h => (h hxy).elim)
    · exact (ht.eventually
        (isOpen_Iio.mem_nhds (abs_pos.mpr (sub_ne_zero.mpr hxy)))).mono (fun J h _ => h)
  exact he.exists

theorem finite_geometric_charge (s : Finset ℕ) {a : ℝ} (ha : 0 ≤ a)
    (hs : ∀ h ∈ s, a * (4 : ℝ) ^ h ≤ 2) :
    (∑ h ∈ s, a * (4 : ℝ) ^ h) ≤ 8 / 3 := by
  by_cases hn : s.Nonempty
  · let m := s.max' hn
    have hm : m ∈ s := Finset.max'_mem s hn
    have hsub : s ⊆ Finset.range (m + 1) := by
      intro h hh
      exact Finset.mem_range.mpr (Nat.lt_succ_of_le (Finset.le_max' s h hh))
    have hsum := Finset.sum_le_sum_of_subset_of_nonneg
      (f := fun h => a * (4 : ℝ) ^ h) hsub
      (fun h _ _ => mul_nonneg ha (pow_nonneg (by norm_num) h))
    have hg := geom_sum_mul (4 : ℝ) (m + 1)
    have he : (∑ h ∈ Finset.range (m + 1), a * (4 : ℝ) ^ h) * 3 =
        4 * (a * (4 : ℝ) ^ m) - a := by
      rw [← Finset.mul_sum, mul_assoc]
      norm_num only [show (4 : ℝ) - 1 = 3 by norm_num] at hg
      rw [hg, pow_succ]
      ring
    linarith [hs m hm]
  · simp only [Finset.not_nonempty_iff_eq_empty.mp hn, Finset.sum_empty]
    norm_num

theorem dyadic_upper (ℓ : ℤ) :
    (2 : ℝ) ^ (1 - ℓ) = 2 * (2 : ℝ) ^ (-ℓ) := by
  rw [sub_eq_add_neg, zpow_add₀ (by norm_num : (2 : ℝ) ≠ 0), zpow_one]

theorem band_charge (ρ : ℝ) (hρ : 0 < ρ) (ℓ : ℤ) (J : ℕ) :
    (∑ h ∈ (Finset.range J).filter (fun h => (2 : ℝ) ^ (-ℓ) ≤ ρ / 4 ^ h),
      (2 : ℝ) ^ (1 - ℓ) / (ρ / 4 ^ h)) ≤
      if (2 : ℝ) ^ (-ℓ) ≤ ρ then 8 / 3 else 0 := by
  classical
  let s := (Finset.range J).filter (fun h => (2 : ℝ) ^ (-ℓ) ≤ ρ / 4 ^ h)
  have hpow : ∀ h : ℕ, (0 : ℝ) < 4 ^ h := fun h => pow_pos (by norm_num) h
  have hs : ∀ h ∈ s, ((2 : ℝ) ^ (1 - ℓ) / ρ) * 4 ^ h ≤ 2 := by
    intro h hh
    have he := (le_div_iff₀ (hpow h)).mp (Finset.mem_filter.mp hh).2
    rw [dyadic_upper]
    have he' : (2 * (2 : ℝ) ^ (-ℓ) * 4 ^ h) / ρ ≤ 2 :=
      (div_le_iff₀ hρ).mpr (by nlinarith)
    convert he' using 1 <;> ring
  have hg := finite_geometric_charge s
    (div_nonneg (zpow_pos (by norm_num : (0 : ℝ) < 2) _).le hρ.le) hs
  have heq : (∑ h ∈ s, (2 : ℝ) ^ (1 - ℓ) / (ρ / 4 ^ h)) =
      ∑ h ∈ s, ((2 : ℝ) ^ (1 - ℓ) / ρ) * 4 ^ h := by
    apply Finset.sum_congr rfl
    intro h _
    field_simp
  change (∑ h ∈ s, _) ≤ _
  rw [heq]
  by_cases hℓ : (2 : ℝ) ^ (-ℓ) ≤ ρ
  · rw [if_pos hℓ]
    exact hg
  · rw [if_neg hℓ]
    have hempty : s = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro h hh
      have he := (le_div_iff₀ (hpow h)).mp (Finset.mem_filter.mp hh).2
      have hone : (1 : ℝ) ≤ 4 ^ h := one_le_pow₀ (by norm_num)
      have hlower : (2 : ℝ) ^ (-ℓ) ≤ (2 : ℝ) ^ (-ℓ) * 4 ^ h :=
        le_mul_of_one_le_right (zpow_pos (by norm_num : (0 : ℝ) < 2) _).le hone
      exact hℓ (hlower.trans he)
    simp only [hempty, Finset.sum_empty, le_refl]

theorem total_charge (ν : Law) (k : ℕ) (ρ : ℝ) (hρ : 0 < ρ) (J : ℕ) :
    (∑ h ∈ Finset.range J, stepCost ν k (ρ / 4 ^ h)) ≤
      1000 * k ^ 4 * Real.log 2 *
        ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ 2 * ρ), capacity ν ℓ := by
  classical
  let C : ℝ := 352 * k ^ 4 * Real.log 2
  have hC : 0 ≤ C := by dsimp [C]; positivity
  have he : (∑ h ∈ Finset.range J, stepCost ν k (ρ / 4 ^ h)) =
      C * ∑ ℓ ∈ bands ν, capacity ν ℓ *
        ∑ h ∈ (Finset.range J).filter (fun h => (2 : ℝ) ^ (-ℓ) ≤ ρ / 4 ^ h),
          (2 : ℝ) ^ (1 - ℓ) / (ρ / 4 ^ h) := by
    simp only [stepCost, distanceCost, Finset.sum_filter, Finset.mul_sum, Finset.sum_mul]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro ℓ _
    apply Finset.sum_congr rfl
    intro h _
    dsimp only [C]
    split_ifs <;> ring
  rw [he]
  have hp := Finset.sum_le_sum (s := bands ν) (fun ℓ _ =>
    mul_le_mul_of_nonneg_left (band_charge ρ hρ ℓ J) (capacity_nonneg ν ℓ))
  calc
    _ ≤ C * ∑ ℓ ∈ bands ν, capacity ν ℓ *
        (if (2 : ℝ) ^ (-ℓ) ≤ ρ then 8 / 3 else 0) :=
      mul_le_mul_of_nonneg_left hp hC
    _ = (C * (8 / 3)) *
        ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ ρ), capacity ν ℓ := by
      simp only [Finset.sum_filter, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro ℓ _
      split_ifs <;> ring
    _ ≤ (1000 * k ^ 4 * Real.log 2) *
        ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ ρ), capacity ν ℓ := by
      apply mul_le_mul_of_nonneg_right _ (Finset.sum_nonneg (fun ℓ _ => capacity_nonneg ν ℓ))
      dsimp only [C]
      have hn : 0 ≤ (k : ℝ) ^ 4 * Real.log 2 := by positivity
      nlinarith
    _ ≤ _ := by
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro ℓ hℓ
        exact Finset.mem_filter.mpr ⟨(Finset.mem_filter.mp hℓ).1,
          (Finset.mem_filter.mp hℓ).2.trans (by linarith)⟩
      · intro ℓ _ _
        exact capacity_nonneg ν ℓ

theorem support_observable {β : Type v} [DecidableEq β] (ν : Law) (g : ℝ → β) :
    observableEntropy Finset.univ (fun x : ν.support => ν.prob x) (fun x => g x) =
      observableEntropy ν.support ν.prob g := by
  classical
  have he : (Finset.univ : Finset ν.support).image (fun x : ν.support => g (x : ℝ)) =
      ν.support.image g := by
    ext b
    constructor
    · intro hb
      obtain ⟨x, _, hxb⟩ := Finset.mem_image.mp hb
      exact Finset.mem_image.mpr ⟨x, x.property, hxb⟩
    · intro hb
      obtain ⟨x, hx, hxb⟩ := Finset.mem_image.mp hb
      exact Finset.mem_image.mpr ⟨⟨x, hx⟩, Finset.mem_univ _, hxb⟩
  simp only [observableEntropy, he, entropy, support_mass]

def sumset (ν : Law) (k : ℕ) : Finset ℝ :=
  Finset.univ.image (fun x : Fin k → ν.support => ∑ i, (x i : ℝ))

def bitsEntropy (ν : Law) : ℝ := entropy ν.support ν.prob / Real.log 2

def gridBits (ν : Law) (ρ : ℝ) : ℝ :=
  observableEntropy ν.support ν.prob (fun x => ⌊x / ρ⌋) / Real.log 2

theorem capacity_zero_outside_bands (ν : Law) {ℓ : ℤ} (hℓ : ℓ ∉ bands ν) :
    capacity ν ℓ = 0 := by
  classical
  apply capacity_eq_zero_of_edges_eq_empty
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro e he
  obtain ⟨hmem, hlt, hlo, hup⟩ := Finset.mem_filter.mp he
  apply hℓ
  apply Finset.mem_image.mpr
  refine ⟨e, hmem, ?_⟩
  rw [abs_of_pos (sub_pos.mpr hlt)]
  exact bandIndex_eq (sub_pos.mpr hlt) hlo hup

theorem pair_bound_natural (ν : Law) (k : ℕ) (hk : 1 ≤ k) (ρ : ℝ) (hρ : 0 < ρ) :
    k * (entropy ν.support ν.prob -
      observableEntropy ν.support ν.prob (fun x => ⌊x / ρ⌋)) ≤
      Real.log (sumset ν k).card + 1000 * k ^ 4 * Real.log 2 *
        ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ 2 * ρ), capacity ν ℓ := by
  classical
  obtain ⟨a, ha⟩ := support_nonempty ν
  have : Nonempty ν.support := ⟨⟨a, ha⟩⟩
  let p : ν.support → ℝ := fun x => ν.prob x
  let w := ProductLaw.weight (fun _ : Fin k => p)
  let Y : (Fin k → ν.support) → ℝ := fun x => ∑ i, (x i : ℝ)
  let C₀ : (Fin k → ν.support) → Fin k → List ℤ := fun x i => [⌊(x i : ℝ) / ρ⌋]
  have hp : ∀ x, 0 ≤ p x := fun x => (ν.prob_pos x x.property).le
  have hw : ∀ x ∈ (Finset.univ : Finset (Fin k → ν.support)), 0 ≤ w x :=
    fun x _ => ProductLaw.weight_nonneg _ (fun _ x => hp x) x
  have hw1 : ∑ x, w x = 1 := ProductLaw.weight_sum _ (fun _ => support_total ν)
  obtain ⟨J, hJ⟩ := separating_depth ν ρ
  obtain ⟨g, hd, hg⟩ := finite_refinements ν k hk ρ hρ J
  let G : (Fin k → ν.support) → Fin k → List ℤ := fun x i => g (x i)
  have hi : Function.Injective (fun x : ν.support => g x) := by
    intro x y he
    apply Subtype.ext
    by_contra hxy
    exact (not_lt_of_ge (hd x x.property y y.property he))
      (hJ x x.property y y.property hxy)
  have hG : Function.Injective G := by
    intro x y he
    funext i
    exact hi (congrFun he i)
  have hent : observableEntropy Finset.univ w G = k * entropy ν.support ν.prob := by
    rw [observableEntropy_of_injective Finset.univ w G hw hG,
      ProductLaw.entropy _ (fun _ => support_total ν)]
    have he : entropy Finset.univ p = entropy ν.support ν.prob :=
      Finset.sum_coe_sort ν.support (fun x => Real.negMulLog (ν.prob x))
    simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    exact congrArg (fun z => (k : ℝ) * z) he
  have hinit : observableEntropy Finset.univ w C₀ =
      k * observableEntropy ν.support ν.prob (fun x => ⌊x / ρ⌋) := by
    rw [ProductLaw.observable_entropy p (fun x : ν.support => [⌊(x : ℝ) / ρ⌋])
      hp (support_total ν)]
    simp only [Fintype.card_fin]
    rw [support_observable ν (fun x => [⌊x / ρ⌋])]
    congr 1
    apply observableEntropy_eq_of_fibers _ _ _ _ (fun x hx => (ν.prob_pos x hx).le)
    intro x _ y _
    simp only [List.cons.injEq, and_true]
  have hy : observableEntropy Finset.univ w Y ≤ Real.log (sumset ν k).card :=
    observableEntropy_le_log_on_superset Finset.univ (sumset ν k) w Y
      (fun x _ => Finset.mem_image.mpr ⟨x, Finset.mem_univ x, rfl⟩) hw hw1
  have hjoint := observableEntropy_fst_le Finset.univ w G Y hw
  have hcinit := conditionalEntropy_le Finset.univ w C₀ Y hw hw1
  have hcost := total_charge ν k ρ hρ J
  change conditionalEntropy Finset.univ w G Y ≤ conditionalEntropy Finset.univ w C₀ Y + _ at hg
  rw [hent] at hjoint
  rw [hinit] at hcinit
  unfold conditionalEntropy at hg hcinit
  linarith

theorem pair_bound_1000 (ν : Law) (k : ℕ) (hk : 1 ≤ k) (ρ : ℝ) (hρ : 0 < ρ) :
    k * (bitsEntropy ν - gridBits ν ρ) ≤
      Real.log (sumset ν k).card / Real.log 2 + 1000 * k ^ 4 *
        ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ 2 * ρ), capacity ν ℓ := by
  have hl : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h := (div_le_div_iff_of_pos_right hl).mpr (pair_bound_natural ν k hk ρ hρ)
  dsimp only [bitsEntropy, gridBits]
  calc
    _ = (k * (entropy ν.support ν.prob -
        observableEntropy ν.support ν.prob (fun x => ⌊x / ρ⌋))) / Real.log 2 := by ring
    _ ≤ (Real.log (sumset ν k).card + 1000 * k ^ 4 * Real.log 2 *
        ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ 2 * ρ), capacity ν ℓ) /
        Real.log 2 := h
    _ = _ := by field_simp

theorem pair_bound_60000 (ν : Law) (k : ℕ) (hk : 1 ≤ k) (ρ : ℝ) (hρ : 0 < ρ) :
    k * (bitsEntropy ν - gridBits ν ρ) ≤
      Real.log (sumset ν k).card / Real.log 2 + 60000 * k ^ 4 *
        ∑ ℓ ∈ (bands ν).filter (fun ℓ => (2 : ℝ) ^ (-ℓ) ≤ 2 * ρ), capacity ν ℓ := by
  apply (pair_bound_1000 ν k hk ρ hρ).trans
  apply add_le_add le_rfl
  apply mul_le_mul_of_nonneg_right
  · have hn : 0 ≤ (k : ℝ) ^ 4 := by positivity
    nlinarith
  · exact Finset.sum_nonneg (fun ℓ _ => capacity_nonneg ν ℓ)

#print axioms pair_bound_1000
#print axioms pair_bound_60000

end
end PairBoundCertificate
