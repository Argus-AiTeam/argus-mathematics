import Mathlib

open scoped BigOperators

namespace RangeAudit

theorem symmetric_kernel_domination
    {ι : Type*} [Fintype ι] (K : ι → ι → ℝ) (n : ι → ℝ) (r : ℝ)
    (hK : ∀ i j, 0 ≤ K i j)
    (hsym : ∀ i j, K i j = K j i)
    (hrow : ∀ i, ∑ j, K i j ≤ r) :
    (∑ i, ∑ j, K i j * n i * n j) ≤ r * ∑ i, (n i) ^ 2 := by
  have hp (i j : ι) :
      2 * (K i j * n i * n j) ≤
        K i j * (n i) ^ 2 + K i j * (n j) ^ 2 := by
    nlinarith [mul_nonneg (hK i j) (sq_nonneg (n i - n j))]
  have hsum :
      2 * (∑ i, ∑ j, K i j * n i * n j) ≤
        (∑ i, ∑ j, K i j * (n i) ^ 2) +
        (∑ i, ∑ j, K i j * (n j) ^ 2) := by
    calc
      2 * (∑ i, ∑ j, K i j * n i * n j) =
          ∑ i, ∑ j, 2 * (K i j * n i * n j) := by
            simp_rw [Finset.mul_sum]
      _ ≤ ∑ i, ∑ j, (K i j * (n i) ^ 2 + K i j * (n j) ^ 2) :=
        Finset.sum_le_sum fun i _ => Finset.sum_le_sum fun j _ => hp i j
      _ = _ := by simp_rw [Finset.sum_add_distrib]
  have hswap :
      (∑ i, ∑ j, K i j * (n j) ^ 2) =
        ∑ i, ∑ j, K i j * (n i) ^ 2 := by
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    rw [hsym j i]
  have hdiag :
      (∑ i, ∑ j, K i j * (n i) ^ 2) ≤ r * ∑ i, (n i) ^ 2 := by
    calc
      (∑ i, ∑ j, K i j * (n i) ^ 2) =
          ∑ i, (∑ j, K i j) * (n i) ^ 2 := by
            simp_rw [Finset.sum_mul]
      _ ≤ ∑ i, r * (n i) ^ 2 :=
        Finset.sum_le_sum fun i _ =>
          mul_le_mul_of_nonneg_right (hrow i) (sq_nonneg (n i))
      _ = r * ∑ i, (n i) ^ 2 := by rw [Finset.mul_sum]
  linarith

theorem count_cutoff_bound
    {ι : Type*} (s : Finset ι) (w : ι → ℝ) (cap tail : ℝ)
    (hcap : 1 ≤ cap) (htail : tail ≤ 1) (hw : ∀ i ∈ s, w i ≤ cap) :
    (∑ i ∈ s, w i) + tail ≤ ((s.card : ℝ) + 1) * cap := by
  have hsum : (∑ i ∈ s, w i) ≤ (s.card : ℝ) * cap := by
    calc
      (∑ i ∈ s, w i) ≤ ∑ _i ∈ s, cap := Finset.sum_le_sum hw
      _ = _ := by simp
  nlinarith

theorem independent_pair_lower
    {ι : Type*} [Fintype ι] (K : ι → ι → ℝ) (d r : ℝ)
    (hrow : ∀ i, r ≤ ∑ j, K i j) :
    (Fintype.card ι : ℝ) * r * d ^ 2 ≤
      ∑ i, ∑ j, K i j * d ^ 2 := by
  calc
    (Fintype.card ι : ℝ) * r * d ^ 2 =
        ∑ _i : ι, r * d ^ 2 := by simp; ring
    _ ≤ ∑ i, (∑ j, K i j) * d ^ 2 :=
      Finset.sum_le_sum fun i _ =>
        mul_le_mul_of_nonneg_right (hrow i) (sq_nonneg d)
    _ = _ := by simp_rw [Finset.sum_mul]

theorem arbitrary_box_density_lower
    (c η d u D q qb qs T δ : ℝ)
    (hc : 0 ≤ c) (hη : 0 ≤ η) (hd : d ^ 2 ≤ D ^ 2)
    (hbox : qs - δ ≤ qb)
    (hbase : qb + c * (-u * d + (1 - η) / 2 * d ^ 2) - δ ≤ q)
    (hactive : T = qs - c / 2 * u ^ 2) :
    T - 2 * δ - c * η / 2 * D ^ 2 ≤ q := by
  have hid :
      qb + c * (-u * d + (1 - η) / 2 * d ^ 2) - δ -
          (T - 2 * δ - c * η / 2 * D ^ 2) =
        (qb - (qs - δ)) + c / 2 * (d - u) ^ 2 +
          c * η / 2 * (D ^ 2 - d ^ 2) := by
    rw [hactive]
    ring
  have hsq : 0 ≤ c / 2 * (d - u) ^ 2 :=
    mul_nonneg (by positivity) (sq_nonneg _)
  have herr : 0 ≤ c * η / 2 * (D ^ 2 - d ^ 2) :=
    mul_nonneg (by positivity) (sub_nonneg.mpr hd)
  linarith

theorem balanced_ratios
    (r p s : ℝ) (hr : 0 < r) (hp : 0 < p)
    (hlower : r * p / 2 ≤ s) (hupper : s ≤ r * p) :
    r / s + s / (r * p ^ 2) ≤ 3 / p := by
  have hs : 0 < s := lt_of_lt_of_le (by positivity : 0 < r * p / 2) hlower
  have hden : 0 < r * p ^ 2 := by positivity
  have hfirst : r / s ≤ 2 / p := by
    apply (div_le_div_iff₀ hs hp).2
    nlinarith
  have hsecond : s / (r * p ^ 2) ≤ 1 / p := by
    apply (div_le_div_iff₀ hden hp).2
    nlinarith [mul_le_mul_of_nonneg_right hupper (le_of_lt hp)]
  calc
    r / s + s / (r * p ^ 2) ≤ 2 / p + 1 / p := add_le_add hfirst hsecond
    _ = 3 / p := by ring

theorem two_sided_pressure_balance
    (q T C r p s : ℝ) (hC : 0 ≤ C) (hr : 0 < r) (hp : 0 < p)
    (hlower : r * p / 2 ≤ s) (hupper : s ≤ r * p)
    (hlo : T - C * (r / s + s / (r * p ^ 2)) ≤ q)
    (hhi : q ≤ T + C * (r / s + s / (r * p ^ 2))) :
    |q - T| ≤ 3 * C / p := by
  have hb := mul_le_mul_of_nonneg_left
    (balanced_ratios r p s hr hp hlower hupper) hC
  have hnorm : C * (3 / p) = 3 * C / p := by ring
  rw [hnorm] at hb
  apply abs_le.mpr
  constructor <;> linarith

theorem small_mass_crossover
    (e a ε L B : ℝ) (ha : 0 < a) (hε : 0 < ε)
    (hL : 1 ≤ L) (hB : 0 ≤ B)
    (hsmall : e ≤ B * a)
    (hlarge : L * ε ≤ a → e ≤ B * Real.sqrt (a * ε)) :
    e ≤ B * Real.sqrt L * min a (Real.sqrt (a * ε)) := by
  have ha0 : 0 ≤ a := le_of_lt ha
  have hε0 : 0 ≤ ε := le_of_lt hε
  have hL0 : 0 ≤ L := le_trans (by norm_num) hL
  have hsL : 1 ≤ Real.sqrt L := by
    have hs := Real.sq_sqrt hL0
    have hn := Real.sqrt_nonneg L
    nlinarith
  have hs : 0 ≤ Real.sqrt (a * ε) := Real.sqrt_nonneg _
  have hs2 : (Real.sqrt (a * ε)) ^ 2 = a * ε :=
    Real.sq_sqrt (mul_nonneg ha0 hε0)
  by_cases h : a ≤ ε
  · have ham : a ≤ Real.sqrt (a * ε) := by
      nlinarith [mul_nonneg ha0 (sub_nonneg.mpr h)]
    rw [min_eq_left ham]
    calc
      e ≤ B * a := hsmall
      _ ≤ B * Real.sqrt L * a := by
        nlinarith [mul_nonneg (mul_nonneg hB ha0) (sub_nonneg.mpr hsL)]
  · have hεa : ε < a := lt_of_not_ge h
    have ham : Real.sqrt (a * ε) ≤ a := by
      nlinarith [mul_nonneg ha0 (le_of_lt (sub_pos.mpr hεa))]
    rw [min_eq_right ham]
    by_cases hla : L * ε ≤ a
    · have hprod : B * Real.sqrt (a * ε) ≤
          B * Real.sqrt L * Real.sqrt (a * ε) := by
        nlinarith [mul_nonneg (mul_nonneg hB hs) (sub_nonneg.mpr hsL)]
      exact le_trans (hlarge hla) hprod
    · have haL : a ≤ L * ε := le_of_lt (lt_of_not_ge hla)
      have hroot : a ≤ Real.sqrt L * Real.sqrt (a * ε) := by
        have hprod0 : 0 ≤ Real.sqrt L * Real.sqrt (a * ε) :=
          mul_nonneg (Real.sqrt_nonneg _) hs
        have hprod2 :
            (Real.sqrt L * Real.sqrt (a * ε)) ^ 2 = L * (a * ε) := by
          rw [mul_pow, Real.sq_sqrt hL0, hs2]
        nlinarith [mul_nonneg ha0 (sub_nonneg.mpr haL)]
      exact le_trans hsmall (by nlinarith [mul_le_mul_of_nonneg_left hroot hB])

end RangeAudit
