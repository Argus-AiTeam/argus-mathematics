import Mathlib

namespace LensSharpness

def starEnergy (u v w : ℝ) : ℝ :=
  max (u ^ 2 + v ^ 2 + w ^ 2)
    (max ((u + v) ^ 2 + w ^ 2) ((u + w) ^ 2 + v ^ 2))

def HasSquaredDualNorm (a b c n : ℝ) : Prop :=
  0 ≤ n ∧
    (∀ u v w : ℝ, (a * u + b * v + c * w) ^ 2 ≤ n * starEnergy u v w) ∧
    ∃ u v w : ℝ, 0 < starEnergy u v w ∧
      (a * u + b * v + c * w) ^ 2 = n * starEnergy u v w

lemma singleton_energy_le (u v w : ℝ) :
    u ^ 2 + v ^ 2 + w ^ 2 ≤ starEnergy u v w :=
  le_max_left _ _

lemma left_energy_le (u v w : ℝ) :
    (u + v) ^ 2 + w ^ 2 ≤ starEnergy u v w :=
  le_trans (le_max_left _ _) (le_max_right _ _)

lemma starEnergy_swap (u v w : ℝ) :
    starEnergy u w v = starEnergy u v w := by
  unfold starEnergy
  rw [show u ^ 2 + w ^ 2 + v ^ 2 = u ^ 2 + v ^ 2 + w ^ 2 by ring]
  rw [max_comm ((u + w) ^ 2 + v ^ 2) ((u + v) ^ 2 + w ^ 2)]

lemma center_bound (u v w : ℝ) :
    (4 * u) ^ 2 ≤ 16 * starEnergy u v w := by
  have h := singleton_energy_le u v w
  nlinarith [sq_nonneg v, sq_nonneg w]

lemma tail_bound (u v w : ℝ) :
    (3 * v - 3 * w) ^ 2 ≤ 18 * starEnergy u v w := by
  have h := singleton_energy_le u v w
  nlinarith [sq_nonneg u, sq_nonneg (v + w)]

lemma plus_bound (u v w : ℝ) :
    (4 * u + 3 * v - 3 * w) ^ 2 ≤ 25 * starEnergy u v w := by
  have hleft := left_energy_le u v w
  have hsingle := singleton_energy_le u v w
  have hf : (4 * (u + v) - 3 * w) ^ 2 ≤ 25 * starEnergy u v w := by
    nlinarith [sq_nonneg (3 * (u + v) + 4 * w)]
  have hg : (4 * u - 3 * w) ^ 2 ≤ 25 * starEnergy u v w := by
    nlinarith [sq_nonneg v, sq_nonneg (3 * u + 4 * w)]
  have identity :
      4 * (4 * u + 3 * v - 3 * w) ^ 2 =
        3 * (4 * (u + v) - 3 * w) ^ 2 + (4 * u - 3 * w) ^ 2 -
          12 * v ^ 2 := by ring
  nlinarith [sq_nonneg v]

lemma minus_bound (u v w : ℝ) :
    (4 * u - 3 * v + 3 * w) ^ 2 ≤ 25 * starEnergy u v w := by
  calc
    (4 * u - 3 * v + 3 * w) ^ 2 = (4 * u + 3 * w - 3 * v) ^ 2 := by ring
    _ ≤ 25 * starEnergy u w v := plus_bound u w v
    _ = 25 * starEnergy u v w := by rw [starEnergy_swap]

theorem center_squared_norm : HasSquaredDualNorm 4 0 0 16 := by
  refine ⟨by norm_num, ?_, ?_⟩
  · intro u v w
    simpa using center_bound u v w
  · refine ⟨1, 0, 0, ?_, ?_⟩ <;> norm_num [starEnergy]

theorem tail_squared_norm : HasSquaredDualNorm 0 3 (-3) 18 := by
  refine ⟨by norm_num, ?_, ?_⟩
  · intro u v w
    simpa [sub_eq_add_neg] using tail_bound u v w
  · refine ⟨0, 3, -3, ?_, ?_⟩ <;> norm_num [starEnergy]

theorem plus_squared_norm : HasSquaredDualNorm 4 3 (-3) 25 := by
  refine ⟨by norm_num, ?_, ?_⟩
  · intro u v w
    simpa [sub_eq_add_neg] using plus_bound u v w
  · refine ⟨4, 0, -3, ?_, ?_⟩ <;> norm_num [starEnergy]

theorem minus_squared_norm : HasSquaredDualNorm 4 (-3) 3 25 := by
  refine ⟨by norm_num, ?_, ?_⟩
  · intro u v w
    simpa [sub_eq_add_neg] using minus_bound u v w
  · refine ⟨4, -3, 0, ?_, ?_⟩ <;> norm_num [starEnergy]

theorem exact_star_certificate :
    HasSquaredDualNorm 4 0 0 16 ∧
    HasSquaredDualNorm 0 3 (-3) 18 ∧
    HasSquaredDualNorm 4 3 (-3) 25 ∧
    HasSquaredDualNorm 4 (-3) 3 25 :=
  ⟨center_squared_norm, tail_squared_norm, plus_squared_norm, minus_squared_norm⟩

theorem exact_lens_ratio : (18 : ℝ) = 2 * (25 - 16) := by norm_num

theorem excludes_smaller_constant (k : ℝ) (hk : k < 2) :
    ¬ ((18 : ℝ) ≤ k * (25 - 16)) := by
  nlinarith

theorem joint_scalar_bound (a b c : ℝ) (h : a ^ 2 + b ^ 2 = 2 * c ^ 2) :
    (a + b) ^ 2 ≤ 4 * c ^ 2 := by
  nlinarith [sq_nonneg (a - b)]

theorem joint_scalar_coefficient_not_two :
    ¬ (∀ a b c : ℝ, 0 ≤ a → 0 ≤ b → 0 ≤ c →
      a ^ 2 + b ^ 2 = 2 * c ^ 2 → (a + b) ^ 2 ≤ 2 * c ^ 2) := by
  intro h
  have bad := h 1 1 1 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  norm_num at bad

end LensSharpness
