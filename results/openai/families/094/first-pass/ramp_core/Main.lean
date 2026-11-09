import Mathlib

open scoped BigOperators ENNReal
open Finset MeasureTheory

noncomputable section

namespace RampCore

def weight (p : ℝ) (k : ℕ) : ℝ := ((2 : ℝ) ^ k) ^ (p - 2)

def capConstant (p : ℝ) : ℝ := (4 : ℝ) ^ (p - 1) / (1 - (2 : ℝ) ^ (2 - p))

def errorConstant (p : ℝ) : ℝ := (2 : ℝ) ^ (p - 1) * capConstant p * (p / (p - 2))

lemma capConstant_pos (p : ℝ) (hp : 2 < p) : 0 < capConstant p := by
  have hq : (2 : ℝ) ^ (2 - p) < 1 :=
    Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  exact div_pos (Real.rpow_pos_of_pos (by norm_num) _) (by linarith)

lemma weight_nonneg (p : ℝ) (k : ℕ) : 0 ≤ weight p k := by
  exact Real.rpow_nonneg (by positivity) _

lemma reciprocal_weight (p : ℝ) (k : ℕ) :
    ((2 : ℝ) ^ k) ^ (2 - p) * weight p k = 1 := by
  unfold weight
  rw [← Real.rpow_add (by positivity), show (2 - p) + (p - 2) = 0 by ring,
    Real.rpow_zero]

lemma decay_as_geometric (p : ℝ) (k : ℕ) :
    ((2 : ℝ) ^ k) ^ (2 - p) = ((2 : ℝ) ^ (2 - p)) ^ k := by
  rw [← Real.rpow_natCast_mul (by norm_num), mul_comm (k : ℝ),
    Real.rpow_mul_natCast (by norm_num)]

lemma weighted_cauchy (p : ℝ) (s : Finset ℕ) (x : ℕ → ℝ) :
    (∑ k ∈ s, x k) ^ 2 ≤
      (∑ k ∈ s, ((2 : ℝ) ^ k) ^ (2 - p)) *
        ∑ k ∈ s, weight p k * (x k) ^ 2 := by
  apply Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul s
    (fun k _ => Real.rpow_nonneg (by positivity) _)
    (fun k _ => mul_nonneg (weight_nonneg p k) (sq_nonneg _))
  intro k _
  rw [← mul_assoc, reciprocal_weight, one_mul]

lemma cap_sum_le (B : ℝ) (hB : 0 < B) (N : ℕ) (a : ℕ → ℝ)
    (ha : ∀ k < N, |a k| ≤ B * (2 : ℝ) ^ k) :
    ∑ k ∈ range N, |a k| ≤ B * (2 : ℝ) ^ N := by
  calc
    ∑ k ∈ range N, |a k| ≤ ∑ k ∈ range N, B * (2 : ℝ) ^ k := by
      exact sum_le_sum (fun k hk => ha k (mem_range.mp hk))
    _ = B * ((2 : ℝ) ^ N - 1) := by
      rw [← mul_sum, geom_sum_eq (by norm_num : (2 : ℝ) ≠ 1)]
      ring
    _ ≤ B * (2 : ℝ) ^ N := by nlinarith

theorem signed_dyadic_cap (p : ℝ) (hp : 2 < p) (B : ℝ) (hB : 0 < B)
    (N : ℕ) (a : ℕ → ℝ) (ha : ∀ k < N, |a k| ≤ B * (2 : ℝ) ^ k) :
    |∑ k ∈ range N, a k| ^ p ≤
      capConstant p * B ^ (p - 2) * ∑ k ∈ range N, weight p k * (a k) ^ 2 := by
  let S := ∑ k ∈ range N, |a k|
  let W := ∑ k ∈ range N, weight p k * (a k) ^ 2
  let q := (2 : ℝ) ^ (2 - p)
  have hr : 0 ≤ p - 2 := by linarith
  have hS : 0 ≤ S := sum_nonneg (fun _ _ => abs_nonneg _)
  have hW : 0 ≤ W := sum_nonneg (fun k _ => mul_nonneg (weight_nonneg p k) (sq_nonneg _))
  have hq0 : 0 ≤ q := Real.rpow_nonneg (by norm_num) _
  have hq1 : q < 1 := by
    exact Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  have hden : 0 < 1 - q := by linarith
  obtain ⟨m, hmN, hlow, hscale⟩ :
      ∃ m : ℕ, m ≤ N ∧ (∑ k ∈ range m, |a k|) ≤ S / 2 ∧
        S ≤ (4 * B) * (2 : ℝ) ^ m := by
    by_cases hsmall : S ≤ 4 * B
    · refine ⟨0, Nat.zero_le _, ?_, ?_⟩
      · simpa using (div_nonneg hS (by norm_num : (0 : ℝ) ≤ 2))
      · simpa using hsmall
    · have hbig : 4 * B < S := lt_of_not_ge hsmall
      have hnear : 1 ≤ S / (2 * B) := by
        apply (le_div_iff₀ (by positivity)).mpr
        nlinarith
      obtain ⟨m, hmlo, hmhi⟩ :=
        exists_nat_pow_near hnear (by norm_num : (1 : ℝ) < 2)
      have hmhalf : B * (2 : ℝ) ^ m ≤ S / 2 := by
        have := (le_div_iff₀ (by positivity : 0 < 2 * B)).mp hmlo
        nlinarith
      have htotal : S ≤ B * (2 : ℝ) ^ N := cap_sum_le B hB N a ha
      have hmN : m ≤ N := by
        by_contra hmn
        have hpow : (2 : ℝ) ^ N ≤ (2 : ℝ) ^ m :=
          pow_le_pow_right₀ (by norm_num) (by omega)
        have hmul := mul_le_mul_of_nonneg_left hpow hB.le
        nlinarith
      refine ⟨m, hmN, ?_, ?_⟩
      · exact (cap_sum_le B hB m a (fun k hk => ha k (lt_of_lt_of_le hk hmN))).trans hmhalf
      · rw [pow_succ] at hmhi
        have := (div_lt_iff₀ (by positivity : 0 < 2 * B)).mp hmhi
        nlinarith
  let T := ∑ k ∈ Ico m N, |a k|
  have hT : 0 ≤ T := sum_nonneg (fun _ _ => abs_nonneg _)
  have hsplit : (∑ k ∈ range m, |a k|) + T = S :=
    sum_range_add_sum_Ico (fun k => |a k|) hmN
  have hhalf : S / 2 ≤ T := by linarith
  have hsqhalf : (S / 2) ^ 2 ≤ T ^ 2 := by
    exact pow_le_pow_left₀ (div_nonneg hS (by norm_num)) hhalf 2
  have htailW :
      (∑ k ∈ Ico m N, weight p k * (a k) ^ 2) ≤ W := by
    apply sum_le_sum_of_subset_of_nonneg
      (fun k hk => mem_range.mpr (mem_Ico.mp hk).2)
    intro k _ _
    exact mul_nonneg (weight_nonneg p k) (sq_nonneg _)
  have hgeo : (∑ k ∈ Ico m N, ((2 : ℝ) ^ k) ^ (2 - p)) ≤
      ((2 : ℝ) ^ m) ^ (2 - p) / (1 - q) := by
    simp_rw [decay_as_geometric]
    exact geom_sum_Ico_le_of_lt_one hq0 hq1
  have hcauchy : T ^ 2 ≤
      (∑ k ∈ Ico m N, ((2 : ℝ) ^ k) ^ (2 - p)) *
        ∑ k ∈ Ico m N, weight p k * (a k) ^ 2 := by
    simpa [T, sq_abs] using weighted_cauchy p (Ico m N) (fun k => |a k|)
  have htail : T ^ 2 ≤ (((2 : ℝ) ^ m) ^ (2 - p) / (1 - q)) * W := by
    exact hcauchy.trans (mul_le_mul hgeo htailW
      (sum_nonneg (fun k _ => mul_nonneg (weight_nonneg p k) (sq_nonneg _)))
      (div_nonneg (Real.rpow_nonneg (by positivity) _) hden.le))
  have hSsq : S ^ 2 ≤ (4 * (((2 : ℝ) ^ m) ^ (2 - p) / (1 - q))) * W := by
    nlinarith
  have hpower : S ^ (p - 2) ≤ (4 * B) ^ (p - 2) * weight p m := by
    have := Real.rpow_le_rpow hS hscale hr
    rwa [Real.mul_rpow (by positivity) (by positivity)] at this
  have hSp : S ^ p = S ^ (p - 2) * S ^ 2 := by
    calc
      S ^ p = S ^ ((p - 2) + 2) := by congr 1; ring
      _ = S ^ (p - 2) * S ^ (2 : ℝ) :=
        Real.rpow_add_of_nonneg hS hr (by norm_num)
      _ = S ^ (p - 2) * S ^ 2 := by rw [Real.rpow_two]
  have hfour : (4 : ℝ) ^ (p - 1) = (4 : ℝ) ^ (p - 2) * 4 := by
    rw [show p - 1 = (p - 2) + 1 by ring, Real.rpow_add_one (by norm_num)]
  have hidentity :
      ((4 * B) ^ (p - 2) * weight p m) *
          ((4 * (((2 : ℝ) ^ m) ^ (2 - p) / (1 - q))) * W) =
        capConstant p * B ^ (p - 2) * W := by
    calc
      _ = ((4 : ℝ) ^ (p - 2) * 4 / (1 - q)) * B ^ (p - 2) * W *
          (((2 : ℝ) ^ m) ^ (2 - p) * weight p m) := by
        rw [Real.mul_rpow (by norm_num) hB.le]
        ring
      _ = ((4 : ℝ) ^ (p - 2) * 4 / (1 - q)) * B ^ (p - 2) * W := by
        rw [reciprocal_weight, mul_one]
      _ = _ := by rw [capConstant, hfour]
  calc
    |∑ k ∈ range N, a k| ^ p ≤ S ^ p :=
      Real.rpow_le_rpow (abs_nonneg _) (abs_sum_le_sum_abs _ _) (by linarith)
    _ = S ^ (p - 2) * S ^ 2 := hSp
    _ ≤ ((4 * B) ^ (p - 2) * weight p m) *
          ((4 * (((2 : ℝ) ^ m) ^ (2 - p) / (1 - q))) * W) :=
      mul_le_mul hpower hSsq (sq_nonneg S)
        (mul_nonneg (Real.rpow_nonneg (by positivity) _) (weight_nonneg p m))
    _ = capConstant p * B ^ (p - 2) * W := hidentity

theorem signed_dyadic_lintegral {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (p : ℝ) (hp : 2 < p) (B : ℝ) (hB : 0 < B) (N : ℕ) (f : ℕ → Ω → ℝ)
    (hf : ∀ k, Measurable (f k))
    (hcap : ∀ x k, k < N → |f k x| ≤ B * (2 : ℝ) ^ k) :
    (∫⁻ x, ENNReal.ofReal (|∑ k ∈ range N, f k x| ^ p) ∂μ) ≤
      ENNReal.ofReal (capConstant p * B ^ (p - 2)) *
        ∑ k ∈ range N, ENNReal.ofReal (weight p k) *
          ∫⁻ x, ENNReal.ofReal ((f k x) ^ 2) ∂μ := by
  let C := capConstant p * B ^ (p - 2)
  let G := fun k x => ENNReal.ofReal (weight p k) * ENNReal.ofReal ((f k x) ^ 2)
  have hC : 0 ≤ C :=
    mul_nonneg (capConstant_pos p hp).le (Real.rpow_nonneg hB.le _)
  have hpoint (x : Ω) :
      ENNReal.ofReal (∑ k ∈ range N, weight p k * (f k x) ^ 2) =
        ∑ k ∈ range N, G k x := by
    rw [ENNReal.ofReal_sum_of_nonneg
      (fun k _ => mul_nonneg (weight_nonneg p k) (sq_nonneg _))]
    apply sum_congr rfl
    intro k _
    exact ENNReal.ofReal_mul (weight_nonneg p k)
  calc
    _ ≤ ∫⁻ x, ENNReal.ofReal (C * ∑ k ∈ range N, weight p k * (f k x) ^ 2) ∂μ := by
      apply lintegral_mono
      intro x
      exact ENNReal.ofReal_le_ofReal (signed_dyadic_cap p hp B hB N
        (fun k => f k x) (hcap x))
    _ = ENNReal.ofReal C *
        ∫⁻ x, ENNReal.ofReal (∑ k ∈ range N, weight p k * (f k x) ^ 2) ∂μ := by
      simp_rw [ENNReal.ofReal_mul hC]
      rw [lintegral_const_mul' _ _ (by simp)]
    _ = ENNReal.ofReal C * ∫⁻ x, ∑ k ∈ range N, G k x ∂μ := by
      simp_rw [hpoint]
    _ = ENNReal.ofReal C * ∑ k ∈ range N, ∫⁻ x, G k x ∂μ := by
      rw [lintegral_finsetSum _ (fun k _ => by dsimp [G]; fun_prop)]
    _ = _ := by
      congr 1
      apply sum_congr rfl
      intro k _
      exact lintegral_const_mul' _ _ (by simp)

theorem signed_dyadic_energy_bound {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (p : ℝ) (hp : 2 < p) (B : ℝ) (hB : 0 < B) (N : ℕ) (f : ℕ → Ω → ℝ)
    (hf : ∀ k, Measurable (f k))
    (hcap : ∀ x k, k < N → |f k x| ≤ B * (2 : ℝ) ^ k)
    (D : ℝ≥0∞)
    (hquad : ∀ k < N, ENNReal.ofReal (weight p k) *
      (∫⁻ x, ENNReal.ofReal ((f k x) ^ 2) ∂μ) ≤ D) :
    (∫⁻ x, ENNReal.ofReal (|∑ k ∈ range N, f k x| ^ p) ∂μ) ≤
      ENNReal.ofReal (capConstant p * B ^ (p - 2)) * (N : ℝ≥0∞) * D := by
  calc
    _ ≤ ENNReal.ofReal (capConstant p * B ^ (p - 2)) *
        ∑ k ∈ range N, ENNReal.ofReal (weight p k) *
          ∫⁻ x, ENNReal.ofReal ((f k x) ^ 2) ∂μ :=
      signed_dyadic_lintegral μ p hp B hB N f hf hcap
    _ ≤ ENNReal.ofReal (capConstant p * B ^ (p - 2)) * ∑ _k ∈ range N, D := by
      exact mul_le_mul_right (sum_le_sum (fun k hk => hquad k (mem_range.mp hk))) _
    _ = _ := by simp [nsmul_eq_mul, mul_assoc]

def signedCutoff {Ω : Type*} (A : ℕ → Ω → ℝ) (ell k : ℕ) (x : Ω) : ℝ :=
  if k < ell then -A k x else A k x

def rampError {Ω : Type*} (A : ℕ → Ω → ℝ) (ell : ℕ) (x : Ω) : ℝ :=
  ∑ k ∈ range (2 * ell), signedCutoff A ell k x

lemma signedCutoff_abs {Ω : Type*} (A : ℕ → Ω → ℝ) (ell k : ℕ) (x : Ω) :
    |signedCutoff A ell k x| = |A k x| := by
  unfold signedCutoff
  split_ifs <;> simp

lemma signedCutoff_sq {Ω : Type*} (A : ℕ → Ω → ℝ) (ell k : ℕ) (x : Ω) :
    (signedCutoff A ell k x) ^ 2 = (A k x) ^ 2 := by
  unfold signedCutoff
  split_ifs <;> simp

theorem ramp_error_energy {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (p : ℝ) (hp : 2 < p) (H : ℝ) (hH : 1 ≤ H) (ell : ℕ)
    (A : ℕ → Ω → ℝ) (hA : ∀ k, Measurable (A k))
    (hcap : ∀ x k, k < 2 * ell → |A k x| ≤ (2 * H) * (2 : ℝ) ^ k)
    (hquad : ∀ k < 2 * ell, ENNReal.ofReal (weight p k) *
      (∫⁻ x, ENNReal.ofReal ((A k x) ^ 2) ∂μ) ≤ ENNReal.ofReal (p / (p - 2))) :
    (∫⁻ x, ENNReal.ofReal (|rampError A ell x| ^ p) ∂μ) ≤
      ENNReal.ofReal (errorConstant p * H ^ (p - 2) * (ell : ℝ)) := by
  have hH0 : 0 ≤ H := by linarith
  have hf : ∀ k, Measurable (signedCutoff A ell k) := by
    intro k
    unfold signedCutoff
    split_ifs <;> fun_prop
  have hcap' : ∀ x k, k < 2 * ell →
      |signedCutoff A ell k x| ≤ (2 * H) * (2 : ℝ) ^ k := by
    simpa only [signedCutoff_abs] using hcap
  have hquad' : ∀ k < 2 * ell, ENNReal.ofReal (weight p k) *
      (∫⁻ x, ENNReal.ofReal ((signedCutoff A ell k x) ^ 2) ∂μ) ≤
        ENNReal.ofReal (p / (p - 2)) := by
    simpa only [signedCutoff_sq] using hquad
  have hbound := signed_dyadic_energy_bound μ p hp (2 * H) (by linarith)
    (2 * ell) (signedCutoff A ell) hf hcap' (ENNReal.ofReal (p / (p - 2))) hquad'
  have hM : 0 ≤ capConstant p * (2 * H) ^ (p - 2) :=
    mul_nonneg (capConstant_pos p hp).le (Real.rpow_nonneg (by positivity) _)
  have htwo : (2 : ℝ) ^ (p - 1) = (2 : ℝ) ^ (p - 2) * 2 := by
    rw [show p - 1 = (p - 2) + 1 by ring, Real.rpow_add_one (by norm_num)]
  have hconstant :
      (capConstant p * (2 * H) ^ (p - 2)) * ((2 * ell : ℕ) : ℝ) * (p / (p - 2)) =
        errorConstant p * H ^ (p - 2) * (ell : ℝ) := by
    unfold errorConstant
    rw [Real.mul_rpow (by norm_num) hH0, htwo]
    push_cast
    ring
  calc
    _ ≤ ENNReal.ofReal (capConstant p * (2 * H) ^ (p - 2)) *
          ((2 * ell : ℕ) : ℝ≥0∞) * ENNReal.ofReal (p / (p - 2)) := hbound
    _ = ENNReal.ofReal ((capConstant p * (2 * H) ^ (p - 2)) *
          ((2 * ell : ℕ) : ℝ) * (p / (p - 2))) := by
      rw [ENNReal.ofReal_mul (mul_nonneg hM (Nat.cast_nonneg _)),
        ENNReal.ofReal_mul hM, ENNReal.ofReal_natCast]
    _ = _ := by rw [hconstant]

theorem weighted_quadratic_contraction {E : Type*} [Fintype E]
    (sigma x y : E → ℝ) (hsigma : ∀ e, 0 ≤ sigma e)
    (horth : ∑ e, sigma e * y e * (x e - y e) = 0) :
    (∑ e, sigma e * (x e - y e) ^ 2) ≤ ∑ e, sigma e * (x e) ^ 2 := by
  have hid : (∑ e, sigma e * (x e) ^ 2) =
      ∑ e, (sigma e * (y e) ^ 2 + sigma e * (x e - y e) ^ 2 +
        2 * (sigma e * y e * (x e - y e))) := by
    apply sum_congr rfl
    intro e _
    ring
  rw [sum_add_distrib, sum_add_distrib, ← mul_sum, horth] at hid
  have hnonneg : 0 ≤ ∑ e, sigma e * (y e) ^ 2 :=
    sum_nonneg (fun e _ => mul_nonneg (hsigma e) (sq_nonneg _))
  linarith

theorem row_cutoff_cap {E : Type*} [Fintype E]
    (row x : E → ℝ) (e : E) (H T : ℝ) (hH : 1 ≤ H) (hT : 0 ≤ T)
    (hrow : ∑ f, |row f| ≤ H) (hx : ∀ f, |x f| ≤ T) :
    |(∑ f, row f * x f) - x e| ≤ (2 * H) * T := by
  have hsum : |∑ f, row f * x f| ≤ H * T := by
    calc
      _ ≤ ∑ f, |row f * x f| := abs_sum_le_sum_abs _ _
      _ = ∑ f, |row f| * |x f| := by simp only [abs_mul]
      _ ≤ ∑ f, |row f| * T :=
        sum_le_sum (fun f _ => mul_le_mul_of_nonneg_left (hx f) (abs_nonneg _))
      _ = (∑ f, |row f|) * T := by rw [sum_mul]
      _ ≤ H * T := mul_le_mul_of_nonneg_right hrow hT
  calc
    _ ≤ |∑ f, row f * x f| + |x e| := abs_sub _ _
    _ ≤ H * T + T := add_le_add hsum (hx e)
    _ ≤ (2 * H) * T := by nlinarith

theorem linear_ramp_identity {V : Type*} [AddCommGroup V] [Module ℝ V]
    (P : V →ₗ[ℝ] V) (T : ℕ → V) (ell : ℕ) :
    P (∑ k ∈ range ell, (T (k + ell) - T k)) -
        (∑ k ∈ range ell, (T (k + ell) - T k)) =
      (∑ k ∈ range ell, (P (T (k + ell)) - T (k + ell))) -
        ∑ k ∈ range ell, (P (T k) - T k) := by
  simp only [map_sum, map_sub, sum_sub_distrib]
  abel

theorem projection_tail_identity {V : Type*} [AddCommGroup V] [Module ℝ V]
    (P : V →ₗ[ℝ] V) (v w : V) (hv : P v = v) :
    P w - w = (v - w) - P (v - w) := by
  rw [map_sub, hv]
  abel

theorem rampError_eq_blocks {Ω : Type*} (A : ℕ → Ω → ℝ) (ell : ℕ) (x : Ω) :
    rampError A ell x =
      (∑ k ∈ range ell, A (k + ell) x) - ∑ k ∈ range ell, A k x := by
  unfold rampError
  rw [show 2 * ell = ell + ell by omega, sum_range_add]
  have hlo : (∑ k ∈ range ell, signedCutoff A ell k x) =
      -(∑ k ∈ range ell, A k x) := by
    rw [← sum_neg_distrib]
    apply sum_congr rfl
    intro k hk
    simp [signedCutoff, mem_range.mp hk]
  have hhi : (∑ k ∈ range ell, signedCutoff A ell (ell + k) x) =
      ∑ k ∈ range ell, A (k + ell) x := by
    apply sum_congr rfl
    intro k _
    simp [signedCutoff, Nat.not_lt.mpr (Nat.le_add_right ell k), Nat.add_comm]
  rw [hlo, hhi]
  ring

def multiplicity (ell j : ℕ) : ℕ :=
  ((range ell).filter (fun k => k ≤ j ∧ j < k + ell)).card

theorem multiplicity_formula (ell j : ℕ) :
    multiplicity ell j = min ell (j + 1) - (j + 1 - ell) := by
  have hset : (range ell).filter (fun k => k ≤ j ∧ j < k + ell) =
      Ico (j + 1 - ell) (min ell (j + 1)) := by
    ext k
    simp only [mem_filter, mem_range, mem_Ico]
    omega
  rw [multiplicity, hset, Nat.card_Ico]

theorem multiplicity_rising (ell j : ℕ) (hj : j < ell) :
    multiplicity ell j = j + 1 := by
  rw [multiplicity_formula]
  omega

theorem multiplicity_falling (ell j : ℕ) (hlo : ell ≤ j + 1) (hhi : j + 1 ≤ 2 * ell) :
    multiplicity ell j = 2 * ell - (j + 1) := by
  rw [multiplicity_formula]
  omega

end RampCore
