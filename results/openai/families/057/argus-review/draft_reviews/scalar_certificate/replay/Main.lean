import Mathlib

namespace WeightedInverse

theorem squared_comparison
    (delta B a H N energy lift : ℝ)
    (hdelta : 0 < delta) (hB : 0 ≤ B) (henergy : 0 ≤ energy)
    (hcauchy : H ^ 2 ≤ energy * lift)
    (hlift : delta * lift ≤ B * N)
    (hbochner : delta * N ≤ energy + a * H) :
    delta ^ 2 * H ^ 2 ≤ B * energy * (energy + a * H) := by
  calc
    delta ^ 2 * H ^ 2 ≤ delta ^ 2 * (energy * lift) :=
      mul_le_mul_of_nonneg_left hcauchy (sq_nonneg delta)
    _ = (delta * energy) * (delta * lift) := by ring
    _ ≤ (delta * energy) * (B * N) :=
      mul_le_mul_of_nonneg_left hlift (mul_nonneg hdelta.le henergy)
    _ = (B * energy) * (delta * N) := by ring
    _ ≤ (B * energy) * (energy + a * H) :=
      mul_le_mul_of_nonneg_left hbochner (mul_nonneg hB henergy)

theorem normalized_comparison
    (delta B a N energy lift : ℝ)
    (hdelta : 0 < delta) (hB : 0 ≤ B) (henergy : 0 ≤ energy)
    (hcauchy : 1 ≤ energy * lift)
    (hlift : delta * lift ≤ B * N)
    (hbochner : delta * N ≤ energy + a) :
    delta ^ 2 ≤ B * energy * (energy + a) := by
  simpa using
    squared_comparison delta B a 1 N energy lift
      hdelta hB henergy (by simpa using hcauchy) hlift (by simpa using hbochner)

theorem quadratic_gap_lower_bound
    (mu r a : ℝ) (hmu : 0 ≤ mu) (hr : 0 < r) (ha : 0 ≤ a)
    (hcomparison : r * (r + a) ≤ mu * (mu + a)) :
    r ≤ mu := by
  by_contra h
  have hlt : mu < r := lt_of_not_ge h
  have hpositive : 0 < (r - mu) * (r + mu + a) :=
    mul_pos (sub_pos.mpr hlt) (by linarith)
  nlinarith

theorem inverse_squared_bound
    (mu s a : ℝ) (hmu : 0 < mu) (hs : 0 < s) (ha : 0 ≤ a)
    (hcomparison : s ^ 2 ≤ mu * (mu + a)) :
    1 / mu ≤ 1 / s + a / s ^ 2 := by
  have htarget : s ^ 2 ≤ mu * (s + a) := by
    by_cases h : mu ≤ s
    · have hproduct : mu * mu ≤ mu * s :=
        mul_le_mul_of_nonneg_left h hmu.le
      nlinarith
    · have hsmu : s ≤ mu := le_of_lt (lt_of_not_ge h)
      have hproduct : s * s ≤ s * mu :=
        mul_le_mul_of_nonneg_left hsmu hs.le
      have hnonnegative : 0 ≤ mu * a := mul_nonneg hmu.le ha
      nlinarith
  calc
    1 / mu ≤ (s + a) / s ^ 2 :=
      (div_le_div_iff₀ hmu (sq_pos_of_pos hs)).2 (by nlinarith [htarget])
    _ = 1 / s + a / s ^ 2 := by
      field_simp

theorem completing_square (mu a : ℝ) :
    (2 * mu + a) ^ 2 = 4 * (mu * (mu + a)) + a ^ 2 := by
  ring

theorem curvature_sum_lower_bound
    {ι : Type*} [DecidableEq ι]
    (J : Finset ι) (eigenvalue : ι → ℝ) (c : ℝ)
    (hlower : ∀ j ∈ J, -c ≤ eigenvalue j) :
    -(J.card : ℝ) * c ≤ ∑ j ∈ J, eigenvalue j := by
  calc
    -(J.card : ℝ) * c = ∑ _j ∈ J, -c := by simp
    _ ≤ ∑ j ∈ J, eigenvalue j := Finset.sum_le_sum hlower

end WeightedInverse
