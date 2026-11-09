import Mathlib

namespace AveragedHolonomy

def Feasible (p q sigma : ℝ) : Prop :=
  ∃ a b : ℝ, 0 < a ∧ 1 < p * b ∧ sigma < 1 - b - a ∧ sigma < q * a

theorem feasible_iff {p q sigma : ℝ}
    (hp : 0 < p) (hq : 0 < q) (hs : 0 < sigma) :
    Feasible p q sigma ↔ 1 / p + sigma / q < 1 - sigma := by
  constructor
  · rintro ⟨a, b, _, hpb, hcoefficient, hremainder⟩
    have hb : 1 / p < b := (div_lt_iff₀ hp).2 (by nlinarith)
    have ha : sigma / q < a := (div_lt_iff₀ hq).2 (by nlinarith)
    linarith
  · intro h
    let d : ℝ := (1 - sigma - 1 / p - sigma / q) / 3
    have hd : 0 < d := by
      dsimp [d]
      linarith
    have hsdiv : 0 < sigma / q := div_pos hs hq
    have hpinv : p * (1 / p) = 1 := by
      field_simp [ne_of_gt hp]
    have hqcancel : q * (sigma / q) = sigma := by
      field_simp [ne_of_gt hq]
    refine ⟨sigma / q + d, 1 / p + d, by positivity, ?_, ?_, ?_⟩
    · have hpd : 0 < p * d := mul_pos hp hd
      nlinarith
    · dsimp [d]
      linarith
    · have hqd : 0 < q * d := mul_pos hq hd
      nlinarith

theorem quarter_polynomial_iff {p q : ℝ} (hp : 0 < p) (hq : 0 < q) :
    Feasible p q (1 / 4) ↔ 4 * q < p * (3 * q - 1) := by
  rw [feasible_iff hp hq (by norm_num)]
  have hden : 0 < 4 * p * q := by positivity
  have hleft :
      (1 / p + (1 / 4 : ℝ) / q) * (4 * p * q) = 4 * q + p := by
    field_simp [ne_of_gt hp, ne_of_gt hq]
    <;> ring
  have hright :
      (1 - (1 / 4 : ℝ)) * (4 * p * q) = 3 * p * q := by ring
  constructor
  · intro h
    have hmul := mul_lt_mul_of_pos_right h hden
    rw [hleft, hright] at hmul
    nlinarith
  · intro h
    by_contra hn
    have hge : 1 - (1 / 4 : ℝ) ≤ 1 / p + (1 / 4 : ℝ) / q :=
      le_of_not_gt hn
    have hmul := mul_le_mul_of_nonneg_right hge (le_of_lt hden)
    rw [hleft, hright] at hmul
    nlinarith

theorem fixed_order_iff {p : ℝ} {N : ℕ} (hp : 0 < p) (hN : 3 ≤ N) :
    Feasible p ((N : ℝ) - 2) (1 / 4) ↔
      4 * ((N : ℝ) - 2) / (3 * (N : ℝ) - 7) < p := by
  have hNr : (3 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
  have hq : 0 < (N : ℝ) - 2 := by linarith
  have hden : 0 < 3 * (N : ℝ) - 7 := by linarith
  rw [quarter_polynomial_iff hp hq]
  constructor
  · intro h
    apply (div_lt_iff₀ hden).2
    nlinarith
  · intro h
    have hh := (div_lt_iff₀ hden).1 h
    nlinarith

theorem finite_order_iff {p : ℝ} (hp : 0 < p) :
    (∃ N : ℕ, 3 ≤ N ∧ Feasible p ((N : ℝ) - 2) (1 / 4)) ↔
      (4 / 3 : ℝ) < p := by
  constructor
  · rintro ⟨N, hN, hf⟩
    have hNr : (3 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
    have hq : 0 < (N : ℝ) - 2 := by linarith
    have hpoly := (quarter_polynomial_iff hp hq).1 hf
    by_contra hn
    have hle : p ≤ (4 / 3 : ℝ) := le_of_not_gt hn
    have hnonpos : 3 * p - 4 ≤ 0 := by linarith
    have hprod : (3 * p - 4) * ((N : ℝ) - 2) ≤ 0 :=
      mul_nonpos_of_nonpos_of_nonneg hnonpos (le_of_lt hq)
    nlinarith
  · intro h
    have hd : 0 < 3 * p - 4 := by linarith
    obtain ⟨N, hNreal⟩ := exists_nat_gt (p / (3 * p - 4) + 2)
    have hdiv : 0 < p / (3 * p - 4) := div_pos hp hd
    have htwo : (2 : ℝ) < (N : ℝ) := by linarith
    have hNnat : 2 < N := by exact_mod_cast htwo
    have hN : 3 ≤ N := by omega
    have hq : 0 < (N : ℝ) - 2 := by linarith
    refine ⟨N, hN, (quarter_polynomial_iff hp hq).2 ?_⟩
    have hfrac : p / (3 * p - 4) < (N : ℝ) - 2 := by linarith
    have hmul := (div_lt_iff₀ hd).1 hfrac
    nlinarith

theorem original_constants :
    (2 : ℝ) * (17 / 32) - 1 = 1 / 16 ∧
      1 - (17 / 32 : ℝ) - 1 / 16 = 13 / 32 ∧
      ((18 : ℝ) - 2) * (1 / 16) = 1 ∧
      1 + (1 / 16 : ℝ) - 17 / 32 = 17 / 32 := by
  norm_num

theorem original_feasible : Feasible 2 (18 - 2) (1 / 4) := by
  refine ⟨1 / 16, 17 / 32, ?_, ?_, ?_, ?_⟩ <;> norm_num

end AveragedHolonomy
