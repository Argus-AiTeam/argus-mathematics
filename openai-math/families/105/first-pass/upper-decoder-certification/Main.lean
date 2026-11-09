import Mathlib

open scoped BigOperators

namespace UpperDecoder

theorem two_response_fiber (a b : ℝ) :
    (a + b) ^ 2 / 2 ≤ a ^ 2 + b ^ 2 := by
  nlinarith [sq_nonneg (a - b)]

theorem slice_mass (p h u lam : ℝ)
    (hp : u - lam ≤ p) (hu : h ≤ u) (hlam : lam ≤ h / 2) :
    h / 2 ≤ p := by
  linarith

theorem positive_difference (k alpha q h v : ℝ)
    (hk : 0 ≤ k) (ha : 0 ≤ alpha) (ha1 : alpha ≤ 1)
    (hq : 0 ≤ q) (hh : q ≤ h) (hv : v ≤ alpha * q / 16) :
    k * alpha * q / 4 ≤
      (k * alpha - k * alpha / 4) * h - (k + k * alpha / 4) * v := by
  have hmargin :
      0 ≤ (3 / 4 : ℝ) * k * alpha * (h - q) +
        k * (1 + alpha / 4) * (alpha * q / 16 - v) +
        k * alpha * q * (28 - alpha) / 64 := by
    have : 0 ≤ h - q := sub_nonneg.mpr hh
    have : 0 ≤ alpha * q / 16 - v := sub_nonneg.mpr hv
    have : 0 ≤ 28 - alpha := by linarith
    positivity
  nlinarith only [hmargin]

theorem heavy_list_bound (m tau lam : ℝ)
    (hm : 0 < m) (htau : 0 < tau)
    (hlam : lam ≤ tau ^ 2 / 2)
    (hgram : m ^ 2 * tau ^ 2 ≤ m + m ^ 2 * lam) :
    m ≤ 2 / tau ^ 2 := by
  have hslack : 0 ≤ m ^ 2 * (tau ^ 2 / 2 - lam) :=
    mul_nonneg (sq_nonneg m) (sub_nonneg.mpr hlam)
  have hbound : m * tau ^ 2 ≤ 2 := by
    by_contra hn
    have hprod : 0 < m * (m * tau ^ 2 - 2) :=
      mul_pos hm (sub_pos.mpr (lt_of_not_ge hn))
    nlinarith only [hgram, hslack, hprod]
  exact (le_div_iff₀ (sq_pos_of_pos htau)).mpr hbound

theorem excess_domination (p q rho productive : ℝ)
    (hp : 0 ≤ p) (hp1 : p ≤ 1) (ht : 0 ≤ productive)
    (hq : q - rho ≤ productive) :
    p * (q - rho) ≤ productive := by
  by_cases h : q ≤ rho
  · exact le_trans (mul_nonpos_of_nonneg_of_nonpos hp (sub_nonpos.mpr h)) ht
  · calc
      p * (q - rho) ≤ 1 * (q - rho) :=
        mul_le_mul_of_nonneg_right hp1 (sub_nonneg.mpr (le_of_not_ge h))
      _ ≤ productive := by simpa using hq

theorem productive_characters {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (bad : ι → Prop) [DecidablePred bad]
    (corr : ι → ℝ) (p q rho threshold : ℝ)
    (hn : 0 < (s.card : ℝ))
    (hp : 0 ≤ p) (hp1 : p ≤ 1) (hthreshold : 0 ≤ threshold)
    (hcorr : ∀ i ∈ s, |corr i| ≤ 1)
    (haverage : q * (s.card : ℝ) ≤ ∑ i ∈ s, |corr i|)
    (hbad : ((s.filter bad).card : ℝ) + threshold * (s.card : ℝ) ≤
      rho * (s.card : ℝ)) :
    p * (q - rho) ≤
      ((s.filter fun i => ¬bad i ∧ threshold ≤ |corr i|).card : ℝ) /
        (s.card : ℝ) := by
  classical
  let productive : ι → Prop := fun i => ¬bad i ∧ threshold ≤ |corr i|
  have hpoint (i : ι) (hi : i ∈ s) :
      |corr i| ≤ (if bad i then (1 : ℝ) else 0) +
        (if productive i then (1 : ℝ) else 0) + threshold := by
    by_cases hb : bad i
    · simp only [productive, hb, not_true_eq_false, false_and, if_true, if_false]
      linarith [hcorr i hi]
    · by_cases ht : threshold ≤ |corr i|
      · simp only [productive, hb, ht, not_false_eq_true, true_and, if_true, if_false]
        linarith [hcorr i hi]
      · simp only [productive, hb, ht, not_false_eq_true, true_and, if_false]
        simpa using le_of_lt (lt_of_not_ge ht)
  have hcount (test : ι → Prop) [DecidablePred test] :
      (∑ i ∈ s, if test i then (1 : ℝ) else 0) =
        ((s.filter test).card : ℝ) := by
    rw [← Finset.sum_filter]
    simp
  have hsum : (∑ i ∈ s, |corr i|) ≤
      ((s.filter bad).card : ℝ) +
      ((s.filter productive).card : ℝ) + threshold * (s.card : ℝ) := by
    calc
      _ ≤ ∑ i ∈ s, ((if bad i then (1 : ℝ) else 0) +
          (if productive i then (1 : ℝ) else 0) + threshold) :=
        Finset.sum_le_sum hpoint
      _ = _ := by
        simp only [Finset.sum_add_distrib]
        rw [hcount bad, hcount productive]
        simp [mul_comm]
  have hraw : (q - rho) * (s.card : ℝ) ≤
      ((s.filter productive).card : ℝ) := by
    linarith
  have hquot : q - rho ≤
      ((s.filter productive).card : ℝ) / (s.card : ℝ) :=
    (le_div_iff₀ hn).mpr hraw
  exact excess_domination p q rho _ hp hp1
    (div_nonneg (Nat.cast_nonneg _) (le_of_lt hn)) hquot

theorem averaged_decoder_bound {D : Type*} [DecidableEq D]
    (ds : Finset D) (weight p q productive success : D → ℝ)
    (rho b hit : ℝ)
    (hw : ∀ d ∈ ds, 0 ≤ weight d) (hhit : 0 ≤ hit)
    (hdom : ∀ d ∈ ds, p d * (q d - rho) ≤ productive d)
    (hdecoder : ∀ d ∈ ds, productive d * hit ≤ success d)
    (hexcess : b ≤ ∑ d ∈ ds, weight d * (p d * (q d - rho))) :
    b * hit ≤ ∑ d ∈ ds, weight d * success d := by
  calc
    b * hit ≤ (∑ d ∈ ds, weight d * (p d * (q d - rho))) * hit :=
      mul_le_mul_of_nonneg_right hexcess hhit
    _ = ∑ d ∈ ds, weight d * ((p d * (q d - rho)) * hit) := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro d hd
      ring
    _ ≤ ∑ d ∈ ds, weight d * success d := by
      apply Finset.sum_le_sum
      intro d hd
      apply mul_le_mul_of_nonneg_left _ (hw d hd)
      exact le_trans (mul_le_mul_of_nonneg_right (hdom d hd) hhit) (hdecoder d hd)

theorem bias_from_bit_balance (p : ℝ)
    (hp : (1 / 16 : ℝ) ≤ p) (hp1 : p ≤ 15 / 16) :
    |1 - 2 * p| ≤ (7 / 8 : ℝ) := by
  rw [abs_le]
  constructor <;> linarith

end UpperDecoder
