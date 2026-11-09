import Mathlib

namespace MeshTail

theorem envelope_step
    (S A Snext Anext alpha C Lambda err : ℝ)
    (hS : 0 ≤ S) (ha : 0 ≤ alpha) (ha' : alpha ≤ 1 / 2)
    (hC : 0 ≤ C) (hLambda : 1 ≤ Lambda) (hCL : 2 * C ≤ Lambda)
    (he : 0 ≤ err)
    (hfirst : Snext ≤ S + alpha * A + err)
    (hsecond : Anext ≤ C * S + alpha * A + err) :
    max Snext (Anext / Lambda) ≤
      (1 + Lambda * alpha) * max S (A / Lambda) + err := by
  let U := max S (A / Lambda)
  have hLpos : 0 < Lambda := by linarith
  have hSU : S ≤ U := le_max_left _ _
  have hU : 0 ≤ U := le_trans hS hSU
  have hAU : A ≤ Lambda * U := by
    have h := (div_le_iff₀ hLpos).mp (show A / Lambda ≤ U from le_max_right _ _)
    nlinarith
  have haA : alpha * A ≤ alpha * (Lambda * U) :=
    mul_le_mul_of_nonneg_left hAU ha
  have hCS : C * S ≤ C * U := mul_le_mul_of_nonneg_left hSU hC
  have hcoeff : C + alpha * Lambda ≤ Lambda := by nlinarith
  have hcoeffU := mul_le_mul_of_nonneg_right hcoeff hU
  have herr : err ≤ Lambda * err := by nlinarith
  have hAstep : Anext / Lambda ≤ U + err := by
    apply (div_le_iff₀ hLpos).mpr
    nlinarith
  have hpositive : 0 ≤ Lambda * alpha * U :=
    mul_nonneg (mul_nonneg (le_of_lt hLpos) ha) hU
  apply max_le
  · change Snext ≤ (1 + Lambda * alpha) * U + err
    nlinarith
  · change Anext / Lambda ≤ (1 + Lambda * alpha) * U + err
    nlinarith

theorem scalar_product_bound
    (u a e : ℕ → ℝ)
    (ha : ∀ j, 0 ≤ a j) (he : ∀ j, 0 ≤ e j)
    (hu : ∀ j, u (j + 1) ≤ (1 + a j) * u j + e j) (n : ℕ) :
    u n ≤ (u 0 + ∑ j ∈ Finset.range n, e j) *
      ∏ j ∈ Finset.range n, (1 + a j) := by
  have aux : ∀ n : ℕ,
      1 ≤ ∏ j ∈ Finset.range n, (1 + a j) ∧
      u n ≤ (u 0 + ∑ j ∈ Finset.range n, e j) *
        ∏ j ∈ Finset.range n, (1 + a j) := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
      have hP0 : 0 ≤ ∏ j ∈ Finset.range n, (1 + a j) := by linarith [ih.1]
      have hPa := mul_nonneg hP0 (ha n)
      have hP : 1 ≤ (∏ j ∈ Finset.range n, (1 + a j)) * (1 + a n) := by
        nlinarith [ih.1]
      have hfactor : 0 ≤ 1 + a n := by linarith [ha n]
      have hmul := mul_le_mul_of_nonneg_left ih.2 hfactor
      have hcorrection := mul_nonneg (he n) (sub_nonneg.mpr hP)
      rw [Finset.prod_range_succ, Finset.sum_range_succ]
      constructor
      · exact hP
      · have hstep := hu n
        nlinarith
  exact (aux n).2

theorem uniform_scalar_bound
    (u a e : ℕ → ℝ) (E B : ℝ)
    (hu0 : 0 ≤ u 0) (hE : 0 ≤ E)
    (ha : ∀ j, 0 ≤ a j) (he : ∀ j, 0 ≤ e j)
    (hu : ∀ j, u (j + 1) ≤ (1 + a j) * u j + e j)
    (hsum : ∀ n, (∑ j ∈ Finset.range n, e j) ≤ E)
    (hprod : ∀ n, (∏ j ∈ Finset.range n, (1 + a j)) ≤ B) :
    ∀ n, u n ≤ (u 0 + E) * B := by
  intro n
  have hp0 : 0 ≤ ∏ j ∈ Finset.range n, (1 + a j) := by
    apply Finset.prod_nonneg
    intro j hj
    linarith [ha j]
  calc
    u n ≤ (u 0 + ∑ j ∈ Finset.range n, e j) *
        ∏ j ∈ Finset.range n, (1 + a j) :=
      scalar_product_bound u a e ha he hu n
    _ ≤ (u 0 + E) * ∏ j ∈ Finset.range n, (1 + a j) :=
      mul_le_mul_of_nonneg_right (by linarith [hsum n]) hp0
    _ ≤ (u 0 + E) * B :=
      mul_le_mul_of_nonneg_left (hprod n) (by linarith)

theorem fifth_power_bound (n : ℕ) : (n + 1) ^ 5 ≤ 32 ^ n := by
  induction n with
  | zero => norm_num
  | succ n ih =>
    calc
      (n + 1 + 1) ^ 5 ≤ (2 * (n + 1)) ^ 5 := by gcongr <;> omega
      _ = 32 * (n + 1) ^ 5 := by ring
      _ ≤ 32 * 32 ^ n := Nat.mul_le_mul_left 32 ih
      _ = 32 ^ (n + 1) := by rw [pow_succ]; omega

theorem geometric_over_fourth
    (B : ℝ) (hB : 32 ≤ B) (n : ℕ) :
    (n : ℝ) + 1 ≤ B ^ n / ((n : ℝ) + 1) ^ 4 := by
  have hc : ((n : ℝ) + 1) ^ 5 ≤ (32 : ℝ) ^ n := by
    exact_mod_cast fifth_power_bound n
  have hpow : (32 : ℝ) ^ n ≤ B ^ n := by gcongr
  apply (le_div_iff₀ (by positivity : 0 < ((n : ℝ) + 1) ^ 4)).mpr
  calc
    ((n : ℝ) + 1) * ((n : ℝ) + 1) ^ 4 = ((n : ℝ) + 1) ^ 5 := by ring
    _ ≤ (32 : ℝ) ^ n := hc
    _ ≤ B ^ n := hpow

end MeshTail
