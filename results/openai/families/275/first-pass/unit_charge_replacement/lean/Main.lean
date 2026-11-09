import Mathlib

noncomputable section

namespace UnitChargeReplacement

def intervalMoment (p : ℕ) : ℝ :=
  if p % 2 = 0 then 1 / (p + 1 : ℝ) else 0

def twoPointMoment (t : ℝ) (p : ℕ) : ℝ :=
  (t ^ p + (-t) ^ p) / 2

theorem twoPoint_exact (t : ℝ) (ht : t ^ 2 = (1 : ℝ) / 3)
    (p : ℕ) (hp : p ≤ 3) :
    twoPointMoment t p = intervalMoment p := by
  interval_cases p <;> norm_num [twoPointMoment, intervalMoment] <;> nlinarith [ht]

def tensorRule (t : ℝ) (a b c : ℕ) : ℝ :=
  (t ^ a * t ^ b * t ^ c
    + t ^ a * t ^ b * (-t) ^ c
    + t ^ a * (-t) ^ b * t ^ c
    + t ^ a * (-t) ^ b * (-t) ^ c
    + (-t) ^ a * t ^ b * t ^ c
    + (-t) ^ a * t ^ b * (-t) ^ c
    + (-t) ^ a * (-t) ^ b * t ^ c
    + (-t) ^ a * (-t) ^ b * (-t) ^ c) / 8

theorem tensor_factorization (t : ℝ) (a b c : ℕ) :
    tensorRule t a b c =
      twoPointMoment t a * twoPointMoment t b * twoPointMoment t c := by
  unfold tensorRule twoPointMoment
  ring

theorem tensor_cubic_exact (t : ℝ) (ht : t ^ 2 = (1 : ℝ) / 3)
    (a b c : ℕ) (ha : a ≤ 3) (hb : b ≤ 3) (hc : c ≤ 3) :
    tensorRule t a b c = intervalMoment a * intervalMoment b * intervalMoment c := by
  rw [tensor_factorization, twoPoint_exact t ht a ha,
    twoPoint_exact t ht b hb, twoPoint_exact t ht c hc]

theorem square_completion_identity (alpha beta x y : ℝ) (ha : 0 < alpha) :
    alpha * y ^ 2 - 2 * beta * x * y + beta ^ 2 / alpha * x ^ 2 =
      (alpha * y - beta * x) ^ 2 / alpha := by
  field_simp [ne_of_gt ha]
  ring

theorem normalized_complement_bound (alpha beta x y energy : ℝ)
    (ha : 0 < alpha) (hx : x ^ 2 ≤ 1)
    (he : alpha * y ^ 2 - 2 * beta * x * y ≤ energy) :
    -(beta ^ 2 / alpha) ≤ energy := by
  have hsq : 0 ≤ (alpha * y - beta * x) ^ 2 / alpha :=
    div_nonneg (sq_nonneg _) (le_of_lt ha)
  rw [← square_completion_identity alpha beta x y ha] at hsq
  have hcoef : 0 ≤ beta ^ 2 / alpha :=
    div_nonneg (sq_nonneg _) (le_of_lt ha)
  have hscale : 0 ≤ beta ^ 2 / alpha * (1 - x ^ 2) :=
    mul_nonneg hcoef (sub_nonneg.mpr hx)
  nlinarith only [he, hsq, hscale]

theorem rounding_denominator (H S : ℝ) (hH : 0 ≤ H) (hS : 0 ≤ S) :
    H ^ 3 * S ^ 2 ≤ (1 + H) ^ 3 * (1 + S) ^ 2 := by
  have hcube : H ^ 3 ≤ (1 + H) ^ 3 := by
    gcongr
    linarith
  have hsquare : S ^ 2 ≤ (1 + S) ^ 2 := by
    nlinarith
  exact mul_le_mul hcube hsquare (sq_nonneg S) (by positivity)

theorem rounding_ratio (H S : ℝ) (hH : 0 < H) (hS : 0 < S) :
    H ^ 2 * S / ((1 + H) ^ 3 * (1 + S) ^ 2) ≤ 1 / (H * S) := by
  apply (div_le_div_iff₀ (by positivity) (by positivity)).2
  calc
    H ^ 2 * S * (H * S) = H ^ 3 * S ^ 2 := by ring
    _ ≤ (1 + H) ^ 3 * (1 + S) ^ 2 :=
      rounding_denominator H S (le_of_lt hH) (le_of_lt hS)
    _ = 1 * ((1 + H) ^ 3 * (1 + S) ^ 2) := (one_mul _).symm

#print axioms tensor_cubic_exact
#print axioms normalized_complement_bound
#print axioms rounding_ratio

end UnitChargeReplacement
