import Mathlib

open Filter Finset

namespace SalemAudit

noncomputable def r : ℝ := 20301 / 10000
noncomputable def g : ℝ := 21 / 10

theorem rates : 1 < r ∧ r < g := by
  norm_num [r, g]

theorem bias_identity (p c s : ℝ) :
    (p * c + (1 - p) * c) ^ 2 +
        (p * s - (1 - p) * s) ^ 2 =
      c ^ 2 + ((2 * p - 1) * s) ^ 2 := by
  ring

theorem bias_bounds (p c s : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (hcircle : c ^ 2 + s ^ 2 = 1) :
    c ^ 2 ≤ c ^ 2 + ((2 * p - 1) * s) ^ 2 ∧
      c ^ 2 + ((2 * p - 1) * s) ^ 2 ≤ 1 := by
  have hm : (2 * p - 1) ^ 2 ≤ 1 := by
    nlinarith [mul_nonneg hp0 (sub_nonneg.mpr hp1)]
  constructor
  · nlinarith [sq_nonneg ((2 * p - 1) * s)]
  · nlinarith [mul_nonneg (sub_nonneg.mpr hm) (sq_nonneg s)]

theorem finite_bias_product (n : ℕ) (p c s : ℕ → ℝ) :
    (∏ i ∈ range n, c i ^ 2) ≤
      ∏ i ∈ range n, (c i ^ 2 + ((2 * p i - 1) * s i) ^ 2) := by
  apply Finset.prod_le_prod
  · intro i hi
    exact sq_nonneg (c i)
  · intro i hi
    nlinarith [sq_nonneg ((2 * p i - 1) * s i)]

theorem centered_sign_variance (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    p * (1 - (2 * p - 1)) ^ 2 +
        (1 - p) * (-1 - (2 * p - 1)) ^ 2 =
      4 * p * (1 - p) ∧
      0 ≤ 4 * p * (1 - p) ∧ 4 * p * (1 - p) ≤ 1 := by
  constructor
  · ring
  constructor
  · positivity
  · nlinarith [sq_nonneg (2 * p - 1)]

theorem floor_partial_sum (a d : ℕ → ℝ)
    (hstep : ∀ n, a n - d n ≤ a (n + 1)) :
    ∀ n, a 0 - ∑ i ∈ range n, d i ≤ a n := by
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
      rw [sum_range_succ]
      linarith [hstep n]

theorem uniform_floor (a d : ℕ → ℝ)
    (hstep : ∀ n, a n - d n ≤ a (n + 1))
    (hbudget : ∀ n, (∑ i ∈ range n, d i) ≤ a 0 / 2) :
    ∀ n, a 0 / 2 ≤ a n := by
  intro n
  linarith [floor_partial_sum a d hstep n, hbudget n]

theorem affine_iteration (s : ℕ → ℝ) (R C B : ℝ) (hR : 0 ≤ R)
    (hshift : C + B ≤ R * B)
    (hstep : ∀ n, s (n + 1) ≤ R * s n + C) :
    ∀ n, s n + B ≤ R ^ n * (s 0 + B) := by
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
      calc
        s (n + 1) + B ≤ R * s n + C + B := by linarith [hstep n]
        _ ≤ R * (s n + B) := by nlinarith
        _ ≤ R * (R ^ n * (s 0 + B)) :=
          mul_le_mul_of_nonneg_left ih hR
        _ = R ^ (n + 1) * (s 0 + B) := by rw [pow_succ]; ring

theorem growth_iteration (L : ℕ → ℝ) (G : ℝ) (hG : 0 ≤ G)
    (hstep : ∀ n, G * L n ≤ L (n + 1)) :
    ∀ n, G ^ n * L 0 ≤ L n := by
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
      calc
        G ^ (n + 1) * L 0 = G * (G ^ n * L 0) := by rw [pow_succ]; ring
        _ ≤ G * L n := mul_le_mul_of_nonneg_left ih hG
        _ ≤ L (n + 1) := hstep n

theorem normalized_loss_bound (s L : ℕ → ℝ) (R G C : ℝ)
    (hR : 1 < R) (hG : 0 < G) (hC : 0 ≤ C)
    (hs : ∀ n, 0 ≤ s n) (hL0 : 0 < L 0)
    (hsstep : ∀ n, s (n + 1) ≤ R * s n + C)
    (hLstep : ∀ n, G * L n ≤ L (n + 1)) :
    ∀ n, 0 ≤ s n / L n ∧
      s n / L n ≤ (R / G) ^ n * ((s 0 + C / (R - 1)) / L 0) := by
  let B := C / (R - 1)
  have hB : 0 ≤ B := div_nonneg hC (by linarith)
  have hRB : C + B = R * B := by
    dsimp [B]
    field_simp [show R - 1 ≠ 0 by linarith]
    <;> ring
  have hS := affine_iteration s R C B (by linarith) hRB.le hsstep
  have hL := growth_iteration L G hG.le hLstep
  intro n
  have hD : 0 < G ^ n * L 0 := mul_pos (pow_pos hG n) hL0
  have hLn : 0 < L n := lt_of_lt_of_le hD (hL n)
  have hSn : s n ≤ R ^ n * (s 0 + B) := by linarith [hS n]
  have hnum : 0 ≤ R ^ n * (s 0 + B) :=
    mul_nonneg (pow_nonneg (by linarith) n) (add_nonneg (hs 0) hB)
  constructor
  · exact div_nonneg (hs n) hLn.le
  · calc
      s n / L n ≤ (R ^ n * (s 0 + B)) / L n :=
        (div_le_div_iff_of_pos_right hLn).mpr hSn
      _ ≤ (R ^ n * (s 0 + B)) / (G ^ n * L 0) :=
        div_le_div_of_nonneg_left hnum hD (hL n)
      _ = (R / G) ^ n * ((s 0 + C / (R - 1)) / L 0) := by
        rw [div_pow]
        dsimp [B]
        ring

theorem normalized_loss_tends_to_zero (s L : ℕ → ℝ) (R G C : ℝ)
    (hR : 1 < R) (hRG : R < G) (hC : 0 ≤ C)
    (hs : ∀ n, 0 ≤ s n) (hL0 : 0 < L 0)
    (hsstep : ∀ n, s (n + 1) ≤ R * s n + C)
    (hLstep : ∀ n, G * L n ≤ L (n + 1)) :
    Tendsto (fun n => s n / L n) atTop (nhds 0) := by
  have hG : 0 < G := by linarith
  have hb := normalized_loss_bound s L R G C hR hG hC hs hL0 hsstep hLstep
  have hq : 0 ≤ R / G := div_nonneg (by linarith) hG.le
  have hq1 : R / G < 1 := (div_lt_one hG).mpr hRG
  have ht := (tendsto_pow_atTop_nhds_zero_of_lt_one hq hq1).mul_const
    ((s 0 + C / (R - 1)) / L 0)
  apply squeeze_zero (fun n => (hb n).1) (fun n => (hb n).2)
  simpa using ht

theorem manuscript_loss_limit (s L : ℕ → ℝ) (C : ℝ)
    (hC : 0 ≤ C) (hs : ∀ n, 0 ≤ s n) (hL0 : 0 < L 0)
    (hsstep : ∀ n, s (n + 1) ≤ r * s n + C)
    (hLstep : ∀ n, g * L n ≤ L (n + 1)) :
    Tendsto (fun n => s n / L n) atTop (nhds 0) :=
  normalized_loss_tends_to_zero s L r g C rates.1 rates.2 hC hs hL0
    hsstep hLstep

theorem bootstrap_margins (L X L' : ℝ) (hL : 100 ≤ L) :
    ((29 / 10 : ℝ) * L - 3 ≤ L' → (14 / 5 : ℝ) * L ≤ L') ∧
    (X ≤ (11 / 10 : ℝ) * L →
      (29 / 10 : ℝ) * L - X - 4 ≤ L' → (7 / 4 : ℝ) * L ≤ L') ∧
    (X ≤ (3 / 4 : ℝ) * L →
      (29 / 10 : ℝ) * L - X - 4 ≤ L' → (21 / 10 : ℝ) * L ≤ L') := by
  constructor
  · intro h
    linarith
  constructor <;> intro hX h <;> linarith

theorem linear_term_absorption (D x : ℝ) (hD : 0 ≤ D)
    (hx : 16 * (D + 1) ≤ x) :
    D * x + 1 ≤ (9 / 64 : ℝ) * x ^ 2 := by
  have hx0 : 16 ≤ x := by linarith
  have hmul := mul_nonneg (sub_nonneg.mpr hx) (show 0 ≤ x by linarith)
  nlinarith

end SalemAudit
