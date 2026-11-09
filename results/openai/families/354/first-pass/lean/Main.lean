import Mathlib

namespace NestingAudit

def cubicCost (a C P w : ℝ) : ℝ :=
  a * (P - w) ^ 2 + C * w ^ 3

def cappedCost (a C P d w : ℝ) : ℝ :=
  a * (P - w) ^ 2 + C * (min d (max w 0)) ^ 3

theorem cubic_tangent_factor (a C P q w : ℝ)
    (hcrit : 3 * C * q ^ 2 = 2 * a * (P - q)) :
    cubicCost a C P w - cubicCost a C P q =
      (w - q) ^ 2 * (a + C * (w + 2 * q)) := by
  unfold cubicCost
  calc
    _ = (w - q) ^ 2 * (a + C * (w + 2 * q)) +
        (w - q) * (3 * C * q ^ 2 - 2 * a * (P - q)) := by ring
    _ = _ := by rw [sub_eq_zero.mpr hcrit]; ring

theorem cubic_stationary_minimum (a C P q w : ℝ)
    (ha : 0 ≤ a) (hC : 0 ≤ C) (hq : 0 ≤ q) (hw : 0 ≤ w)
    (hcrit : 3 * C * q ^ 2 = 2 * a * (P - q)) :
    cubicCost a C P q ≤ cubicCost a C P w := by
  have hfactor := cubic_tangent_factor a C P q w hcrit
  have hn : 0 ≤ (w - q) ^ 2 * (a + C * (w + 2 * q)) := by positivity
  linarith

theorem capped_global_minimum (a C P d q : ℝ)
    (ha : 0 < a) (hC : 0 < C) (hP : 0 < P) (hd : 0 < d)
    (hq : 0 ≤ q) (hqP : q ≤ P)
    (hcrit : 3 * C * q ^ 2 = 2 * a * (P - q)) :
    (∀ w : ℝ, w ≤ P →
      min (C * d ^ 3) (cubicCost a C P q) ≤ cappedCost a C P d w) ∧
    (∃ w : ℝ, w ≤ P ∧
      cappedCost a C P d w = min (C * d ^ 3) (cubicCost a C P q)) := by
  have hmin (w : ℝ) (hw : 0 ≤ w) :=
    cubic_stationary_minimum a C P q w ha.le hC.le hq hw hcrit
  constructor
  · intro w _
    by_cases hw : w ≤ 0
    · have hzero := hmin 0 le_rfl
      have hzero' : cubicCost a C P q ≤ a * P ^ 2 := by
        simpa [cubicCost] using hzero
      have hsquare : P ^ 2 ≤ (P - w) ^ 2 := by nlinarith
      have hscaled := mul_le_mul_of_nonneg_left hsquare ha.le
      have hcap : cappedCost a C P d w = a * (P - w) ^ 2 := by
        simp [cappedCost, max_eq_right hw, min_eq_right hd.le]
      rw [hcap]
      exact le_trans (min_le_right _ _) (le_trans hzero' hscaled)
    · have hw0 : 0 ≤ w := le_of_lt (lt_of_not_ge hw)
      by_cases hwd : d ≤ w
      · have hnonneg : 0 ≤ a * (P - w) ^ 2 := by positivity
        have hcap : cappedCost a C P d w =
            a * (P - w) ^ 2 + C * d ^ 3 := by
          simp [cappedCost, max_eq_left hw0, min_eq_left hwd]
        rw [hcap]
        exact le_trans (min_le_left _ _) (by linarith)
      · have hwd' : w ≤ d := le_of_lt (lt_of_not_ge hwd)
        have hcap : cappedCost a C P d w = cubicCost a C P w := by
          simp [cappedCost, cubicCost, max_eq_left hw0, min_eq_right hwd']
        rw [hcap]
        exact le_trans (min_le_right _ _) (hmin w hw0)
  · by_cases hcase : C * d ^ 3 ≤ cubicCost a C P q
    · have hdP : d ≤ P := by
        by_contra hn
        have hPd : P < d := lt_of_not_ge hn
        have hcube : C * P ^ 3 < C * d ^ 3 := by gcongr
        have hpmin := hmin P hP.le
        simp only [cubicCost, sub_self, zero_pow (by decide : 2 ≠ 0),
          mul_zero, zero_add] at hpmin
        have hcase_expanded : C * d ^ 3 ≤ a * (P - q) ^ 2 + C * q ^ 3 := hcase
        linarith
      refine ⟨P, le_rfl, ?_⟩
      simp [cappedCost, max_eq_left hP.le, min_eq_left hdP,
        min_eq_left hcase]
    · have hcase' : cubicCost a C P q ≤ C * d ^ 3 :=
        le_of_lt (lt_of_not_ge hcase)
      have hqd : q ≤ d := by
        by_contra hn
        have hdq : d < q := lt_of_not_ge hn
        have hcube : C * d ^ 3 < C * q ^ 3 := by gcongr
        have hnonneg : 0 ≤ a * (P - q) ^ 2 := by positivity
        unfold cubicCost at hcase'
        linarith
      refine ⟨q, hqP, ?_⟩
      rw [min_eq_right hcase']
      simp [cappedCost, cubicCost, max_eq_left hq, min_eq_right hqd]

theorem semiconcave_uniform_bound (f : ℝ → ℝ) (a b x K : ℝ)
    (hab : a < b) (hax : a ≤ x) (hxb : x ≤ b) (hK : 0 ≤ K)
    (hf : ConcaveOn ℝ (Set.Icc a b) (fun z => f z - K * z ^ 2 / 2)) :
    min (f a) (f b) - K * (b - a) ^ 2 / 8 ≤ f x := by
  let l : ℝ := (b - x) / (b - a)
  let r : ℝ := (x - a) / (b - a)
  have hba : 0 < b - a := sub_pos.mpr hab
  have hne : b - a ≠ 0 := ne_of_gt hba
  have hl : 0 ≤ l := div_nonneg (sub_nonneg.mpr hxb) hba.le
  have hr : 0 ≤ r := div_nonneg (sub_nonneg.mpr hax) hba.le
  have hsum : l + r = 1 := by dsimp [l, r]; field_simp [hne]; ring
  have hcombo : l * a + r * b = x := by dsimp [l, r]; field_simp [hne]; ring
  have hc := hf.2 (show a ∈ Set.Icc a b from ⟨le_rfl, hab.le⟩)
    (show b ∈ Set.Icc a b from ⟨hab.le, le_rfl⟩) hl hr hsum
  simp only [smul_eq_mul] at hc
  rw [hcombo] at hc
  have hm := add_le_add
    (mul_le_mul_of_nonneg_left (min_le_left (f a) (f b)) hl)
    (mul_le_mul_of_nonneg_left (min_le_right (f a) (f b)) hr)
  rw [← add_mul, hsum, one_mul] at hm
  have hloss :
      l * (K * a ^ 2 / 2) + r * (K * b ^ 2 / 2) - K * x ^ 2 / 2 =
        K / 2 * ((x - a) * (b - x)) := by
    dsimp [l, r]
    field_simp [hne]
    ring
  have hchord :
      min (f a) (f b) - K / 2 * ((x - a) * (b - x)) ≤ f x := by
    nlinarith [hc, hm, hloss]
  have hproduct : (x - a) * (b - x) ≤ (b - a) ^ 2 / 4 := by
    nlinarith [sq_nonneg (2 * x - a - b)]
  have herror := mul_le_mul_of_nonneg_left hproduct (show 0 ≤ K / 2 by positivity)
  nlinarith [hchord, herror]

end NestingAudit
