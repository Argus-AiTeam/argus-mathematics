import Mathlib

open scoped BigOperators

namespace FiniteComparison

theorem comparison_excess (P q R u D Z : ℝ)
    (hq0 : 0 ≤ q) (hq1 : q ≤ 1) (hu : u ≤ R * (1 - P))
    (hcomparison : q < 1 → R * (1 - P * q) ≤ D + Z) :
    (1 - q) * R + q * u - (D + Z) ≤
      if q = 1 then max (u - D - Z) 0 else 0 := by
  by_cases hq : q = 1
  · subst q
    simp only [sub_self, zero_mul, one_mul, zero_add, ite_true]
    have h := le_max_left (u - D - Z) (0 : ℝ)
    linarith
  · rw [if_neg hq]
    have hlt : q < 1 := lt_of_le_of_ne hq1 hq
    have hmul := mul_le_mul_of_nonneg_left hu hq0
    have hc := hcomparison hlt
    nlinarith

theorem row_excess {ι : Type*} [Fintype ι]
    (weight Z q : ι → ℝ) (P R u D C r F : ℝ)
    (hw : ∀ t, 0 ≤ weight t)
    (hw1 : ∑ t, weight t = 1)
    (hmean : ∑ t, weight t * Z t = 1)
    (hr : r = ∑ t, weight t * q t)
    (hC : 0 ≤ C)
    (hq0 : ∀ t, 0 ≤ q t) (hq1 : ∀ t, q t ≤ 1)
    (hu : u ≤ R * (1 - P))
    (hcomparison : ∀ t, q t < 1 → R * (1 - P * q t) ≤ D + Z t)
    (hrow : F ≤ C * ((1 - r) * R + r * u - (D + 1))) :
    F ≤ C * ∑ t, weight t *
      (if q t = 1 then max (u - D - Z t) 0 else 0) := by
  have hexp :
      (∑ t, weight t * ((1 - q t) * R + q t * u - (D + Z t))) =
        (1 - r) * R + r * u - (D + 1) := by
    calc
      _ = ∑ t, (weight t * (R - D) +
          (weight t * q t) * (u - R) - weight t * Z t) := by
            apply Finset.sum_congr rfl
            intro t _
            ring
      _ = (∑ t, weight t) * (R - D) +
          (∑ t, weight t * q t) * (u - R) -
          (∑ t, weight t * Z t) := by
            simp only [Finset.sum_sub_distrib, Finset.sum_add_distrib,
              Finset.sum_mul]
      _ = (1 - r) * R + r * u - (D + 1) := by
            rw [hw1, hmean, ← hr]
            ring
  have hsum :
      (∑ t, weight t * ((1 - q t) * R + q t * u - (D + Z t))) ≤
        ∑ t, weight t *
          (if q t = 1 then max (u - D - Z t) 0 else 0) := by
    apply Finset.sum_le_sum
    intro t _
    exact mul_le_mul_of_nonneg_left
      (comparison_excess P (q t) R u D (Z t)
        (hq0 t) (hq1 t) hu (hcomparison t)) (hw t)
  calc
    F ≤ C * ((1 - r) * R + r * u - (D + 1)) := hrow
    _ = C * ∑ t, weight t * ((1 - q t) * R + q t * u - (D + Z t)) := by
      rw [hexp]
    _ ≤ _ := mul_le_mul_of_nonneg_left hsum hC

theorem positive_radius (P r C F R u D : ℝ)
    (hr0 : 0 ≤ r) (hr1 : r ≤ 1)
    (hP : P < 1) (hden : 0 < 1 - P * r)
    (hC : 0 < C) (hF : 0 < F)
    (hrow : F ≤ C * ((1 - r) * R + r * u - (D + 1)))
    (hfirst : (1 - P * r) * u ≤ (D + 1) * (1 - P)) :
    D + 1 < (1 - P * r) * R ∧ u ≤ R * (1 - P) := by
  have hmix : 0 < (1 - r) * R + r * u - (D + 1) := by
    by_contra hn
    have hm := le_of_not_gt hn
    have hp := mul_nonpos_of_nonneg_of_nonpos (le_of_lt hC) hm
    linarith
  have hrad : D + 1 < (1 - P * r) * R := by
    by_contra hn
    have hR := le_of_not_gt hn
    have h1 := mul_le_mul_of_nonneg_left hR (sub_nonneg.mpr hr1)
    have h2 := mul_le_mul_of_nonneg_left hfirst hr0
    have hp := mul_pos hden hmix
    nlinarith
  have hbound := mul_le_mul_of_nonneg_right (le_of_lt hrad)
    (sub_nonneg.mpr (le_of_lt hP))
  have hh : (1 - P * r) * u ≤ (1 - P * r) * (R * (1 - P)) := by
    nlinarith [hfirst, hbound]
  refine ⟨hrad, ?_⟩
  by_contra hn
  have hp := mul_pos hden (sub_pos.mpr (lt_of_not_ge hn))
  nlinarith [hh]

theorem donor_threshold (C r G K L D H b beta z u : ℝ)
    (hC : 0 < C) (hr : 0 < r) (hG : 0 < G)
    (hL : 0 ≤ L) (hlocation : K ≤ D * G)
    (hcharge : 0 ≤ ((C * H - b) * r + beta * z) * G + K * L)
    (hidentity : C * r * (u - D) = b * r - beta * z - L * D) :
    u - D ≤ H := by
  have hKL := mul_le_mul_of_nonneg_right hlocation hL
  have hp : 0 ≤ (((C * H - b) * r + beta * z) + D * L) * G := by
    nlinarith [hcharge, hKL]
  have hnum : 0 ≤ ((C * H - b) * r + beta * z) + D * L := by
    by_contra hn
    have hn' := lt_of_not_ge hn
    have hnprod := mul_neg_of_neg_of_pos hn' hG
    linarith
  have hh : (C * r) * (u - D) ≤ (C * r) * H := by
    nlinarith [hidentity, hnum]
  by_contra hn
  have hp := mul_pos (mul_pos hC hr) (sub_pos.mpr (lt_of_not_ge hn))
  nlinarith [hh]

theorem paying_charges {ι : Type*} [Fintype ι]
    (weight F : ι → ℝ) (charge : ι → ι → ℝ)
    (hw : ∀ i, 0 ≤ weight i)
    (hsource : ∀ i t, F i ≤ 0 → charge i t = 0)
    (htarget : ∀ i t, 0 < F t → charge i t = 0)
    (hpositive : ∀ i, 0 < F i → F i ≤ ∑ t, weight t * charge i t)
    (hnonpositive : ∀ i, F i ≤ 0 →
      F i + (∑ t, weight t * charge t i) ≤ 0) :
    ∑ i, weight i * F i ≤ 0 := by
  have hrow : ∀ i, F i ≤
      (∑ t, weight t * charge i t) - (∑ t, weight t * charge t i) := by
    intro i
    by_cases hi : 0 < F i
    · have incoming : (∑ t, weight t * charge t i) = 0 := by
        apply Finset.sum_eq_zero
        intro t _
        rw [htarget t i hi, mul_zero]
      rw [incoming, sub_zero]
      exact hpositive i hi
    · have hi' : F i ≤ 0 := le_of_not_gt hi
      have outgoing : (∑ t, weight t * charge i t) = 0 := by
        apply Finset.sum_eq_zero
        intro t _
        rw [hsource i t hi', mul_zero]
      rw [outgoing]
      have h := hnonpositive i hi'
      linarith
  have swap :
      (∑ i, weight i * ∑ t, weight t * charge i t) =
        ∑ i, weight i * ∑ t, weight t * charge t i := by
    simp_rw [Finset.mul_sum]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro t _
    ring
  calc
    (∑ i, weight i * F i) ≤
        ∑ i, weight i *
          ((∑ t, weight t * charge i t) - (∑ t, weight t * charge t i)) := by
      apply Finset.sum_le_sum
      intro i _
      exact mul_le_mul_of_nonneg_left (hrow i) (hw i)
    _ = 0 := by
      simp only [mul_sub, Finset.sum_sub_distrib]
      rw [swap]
      ring

theorem quadratic_zero_constant (b1 b2 r : ℝ)
    (hr0 : 0 ≤ r) (hr1 : r ≤ 1) (h1 : 0 ≤ b1) (h12 : 0 ≤ b1 + b2) :
    0 ≤ b1 * r + b2 * r ^ 2 := by
  have hm : 0 ≤ (1 - r) * b1 + r * (b1 + b2) :=
    add_nonneg (mul_nonneg (sub_nonneg.mpr hr1) h1) (mul_nonneg hr0 h12)
  calc
    0 ≤ r * ((1 - r) * b1 + r * (b1 + b2)) := mul_nonneg hr0 hm
    _ = b1 * r + b2 * r ^ 2 := by ring

theorem quadratic_discriminant (b0 b1 b2 r : ℝ)
    (h0 : 0 ≤ b0) (hd : 0 < 4 * b0 * b2 - b1 ^ 2) :
    0 < b0 + b1 * r + b2 * r ^ 2 := by
  have h2 : 0 < b2 := by
    by_contra hn
    have hp := mul_nonpos_of_nonneg_of_nonpos h0 (le_of_not_gt hn)
    nlinarith [sq_nonneg b1]
  have hid : 4 * b2 * (b0 + b1 * r + b2 * r ^ 2) =
      (2 * b2 * r + b1) ^ 2 + (4 * b0 * b2 - b1 ^ 2) := by ring
  have hp : 0 < 4 * b2 * (b0 + b1 * r + b2 * r ^ 2) := by
    rw [hid]
    nlinarith [sq_nonneg (2 * b2 * r + b1)]
  by_contra hn
  have hc := mul_nonpos_of_nonneg_of_nonpos
    (show 0 ≤ 4 * b2 by positivity) (le_of_not_gt hn)
  linarith

theorem quadratic_endpoints (b0 b1 b2 r : ℝ)
    (hr0 : 0 ≤ r) (hr1 : r ≤ 1)
    (h0 : 0 ≤ b0) (hs : 0 ≤ b0 + b1 + b2) (hg : 0 ≤ b0 - b2) :
    0 ≤ b0 + b1 * r + b2 * r ^ 2 := by
  have hm : 0 ≤ (1 - r) * b0 + r * (b0 - b2) :=
    add_nonneg (mul_nonneg (sub_nonneg.mpr hr1) h0) (mul_nonneg hr0 hg)
  calc
    0 ≤ r * (b0 + b1 + b2) +
        (1 - r) * ((1 - r) * b0 + r * (b0 - b2)) :=
      add_nonneg (mul_nonneg hr0 hs) (mul_nonneg (sub_nonneg.mpr hr1) hm)
    _ = b0 + b1 * r + b2 * r ^ 2 := by ring

theorem bernstein_cubic_nonnegative (a0 a1 a2 a3 t : ℝ)
    (h0 : 0 ≤ a0) (h1 : 0 ≤ a1) (h2 : 0 ≤ a2) (h3 : 0 ≤ a3)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    0 ≤ a0 * (1 - t) ^ 3 + 3 * a1 * t * (1 - t) ^ 2 +
      3 * a2 * t ^ 2 * (1 - t) + a3 * t ^ 3 := by
  have hmt : 0 ≤ 1 - t := sub_nonneg.mpr ht1
  positivity

theorem bernstein_cubic_partition (t : ℝ) :
    (1 - t) ^ 3 + 3 * t * (1 - t) ^ 2 +
      3 * t ^ 2 * (1 - t) + t ^ 3 = 1 := by ring

#print axioms comparison_excess
#print axioms row_excess
#print axioms positive_radius
#print axioms donor_threshold
#print axioms paying_charges
#print axioms quadratic_discriminant

end FiniteComparison
