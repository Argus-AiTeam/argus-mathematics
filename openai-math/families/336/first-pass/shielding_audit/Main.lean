import Mathlib

namespace ShieldingAudit

noncomputable def bulkCoefficient (e : ℝ) : ℝ :=
  (4 / 5 : ℝ) * (9 - 18 * e)

noncomputable def cylinderCoefficient (e : ℝ) : ℝ :=
  (17 / 10 : ℝ) * (25 / 4 - 55 / 4 * e) - (288 / 85 : ℝ) * (1 + e)

noncomputable def localCoefficient (upper : ℝ) : ℝ :=
  (29 / 25 : ℝ) * upper * (1001 / 1000 : ℝ) ^ 3 / (719 / 100 : ℝ)

theorem riccati_square (a c y : ℝ) :
    2 * a * ((a / 2) * y ^ 2 - y + c / 2) =
      (a * y - 1) ^ 2 + (a * c - 1) := by
  ring

theorem riccati_positive (a c y : ℝ) (ha : 0 < a) (hc : 1 < a * c) :
    0 < (a / 2) * y ^ 2 - y + c / 2 := by
  apply (mul_pos_iff_of_pos_left (by linarith : 0 < 2 * a)).mp
  rw [riccati_square]
  nlinarith [sq_nonneg (a * y - 1)]

theorem radial_chain (a c y : ℝ) :
    2 * ((a / 2) * y ^ 2 - y + c / 2 + y) = a * y ^ 2 + c := by
  ring

theorem original_profile_gap :
    (29 / 50 : ℝ) * 2 - 1 = 4 / 25 := by
  norm_num

theorem refined_profile_gap :
    (59 / 100 : ℝ) * (17 / 10) - 1 = 3 / 1000 := by
  norm_num

theorem refined_profile_below_stage (a : ℝ) (ha : (3 / 5 : ℝ) ≤ a) :
    (59 / 100 : ℝ) < a := by
  linarith

theorem rank_eight_trace (u : ℝ) (hu : u ≤ 1) :
    (7 : ℝ) ≤ 8 - u := by
  linarith

theorem bulk_jet_bound (e trace ratio : ℝ)
    (ht : 8 - e ≤ trace) (hr : ratio ≤ 1 + e) :
    bulkCoefficient e ≤ (4 / 5 : ℝ) * (3 * trace - 15 * ratio) := by
  unfold bulkCoefficient
  nlinarith

theorem cylinder_jet_bound (e trace ratio vertical : ℝ)
    (ht : 7 - e ≤ trace) (hr : ratio ≤ 1 + e)
    (hv : vertical ≤ (288 / 85 : ℝ) * (1 + e)) :
    cylinderCoefficient e ≤
      (17 / 10 : ℝ) * ((5 / 2 : ℝ) * trace - (45 / 4 : ℝ) * ratio) -
        vertical := by
  unfold cylinderCoefficient
  nlinarith

theorem bulk_uniform_margin (e : ℝ) (he : e ≤ (1 / 10000 : ℝ)) :
    (719 / 100 : ℝ) < bulkCoefficient e := by
  unfold bulkCoefficient
  nlinarith

theorem cylinder_uniform_margin (e : ℝ) (he : e ≤ (1 / 10000 : ℝ)) :
    (719 / 100 : ℝ) < cylinderCoefficient e := by
  unfold cylinderCoefficient
  nlinarith

theorem cylinder_limit_margin :
    cylinderCoefficient 0 - (36 / 5 : ℝ) = 5 / 136 := by
  norm_num [cylinderCoefficient]

theorem vertical_square_coefficient :
    (17 / 10 : ℝ) * (((4 / 5 : ℝ) / (17 / 10)) * 3) ^ 2 = 288 / 85 := by
  norm_num

theorem seam_flux (a z : ℝ) (hz : |z| ≤ a) :
    0 ≤ -(4 / 5 : ℝ) * z +
      (17 / 10 : ℝ) * (((4 / 5 : ℝ) / (17 / 10)) * a) := by
  have hza : z ≤ a := le_trans (le_abs_self z) hz
  nlinarith

theorem matching_seam_flux (a z vb vc : ℝ) (hz : |z| ≤ a) (hm : vb = vc) :
    0 ≤ -(4 / 5 : ℝ) * z * vb ^ 2 +
      (17 / 10 : ℝ) * (((4 / 5 : ℝ) / (17 / 10)) * a) * vc ^ 2 := by
  subst vc
  have h := mul_nonneg (seam_flux a z hz) (sq_nonneg vb)
  nlinarith

theorem forcing_branch (a ar u p cost d : ℝ)
    (ha : a ≤ ar) (hp : 0 ≤ p) (hd : cost ≤ d) :
    a * u ^ 2 + cost ≤ ar * u ^ 2 + p + d := by
  have h := mul_nonneg (sub_nonneg.mpr ha) (sq_nonneg u)
  nlinarith

theorem cap_branch (ar u floor p d : ℝ)
    (ha : (3 / 5 : ℝ) ≤ ar) (hp : floor ≤ p) (hd : 0 ≤ d) :
    (29 / 50 : ℝ) * u ^ 2 + floor ≤ ar * u ^ 2 + p + d := by
  have h := mul_nonneg (by linarith : 0 ≤ ar - (29 / 50 : ℝ)) (sq_nonneg u)
  nlinarith

theorem maximum_cost (theta k t : ℝ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    theta * t + k * (1 - t) ≤ max theta k := by
  calc
    theta * t + k * (1 - t) ≤
        max theta k * t + max theta k * (1 - t) :=
      add_le_add
        (mul_le_mul_of_nonneg_right (le_max_left theta k) ht0)
        (mul_le_mul_of_nonneg_right (le_max_right theta k) (by linarith))
    _ = max theta k := by ring

theorem guard_count_gap (m : ℕ) (hm : 8 ≤ m) :
    m - 8 < m - 2 := by
  omega

theorem face_guard_count (m d k : ℕ) (hk : m - 2 ≤ k) :
    (m - d) - 2 ≤ k := by
  omega

theorem product_capacity_gap (m a : ℤ) :
    (m + a - 3) - (m + a - 8) = 5 := by
  ring

theorem sobolev_trace_exponent (m : ℝ) (hm : 2 < m) :
    2 * (2 * (m - 1) / (m - 2) - 1) = 2 * m / (m - 2) := by
  have h : m - 2 ≠ 0 := by linarith
  field_simp
  ring

theorem sobolev_bulk_exponent (m : ℝ) (hm : 2 < m) :
    (2 * (m - 1) / (m - 2)) * m / (m - 1) = 2 * m / (m - 2) := by
  have h1 : m - 1 ≠ 0 := by linarith
  have h2 : m - 2 ≠ 0 := by linarith
  field_simp

theorem sobolev_interpolation_exponent (m : ℝ) (hm : 2 < m) :
    2 * (m - 1) / (m - 2) = (2 * m / (m - 2) + 2) / 2 := by
  have h : m - 2 ≠ 0 := by linarith
  field_simp
  ring

theorem sobolev_absorption_gap (m : ℝ) (hm : 2 < m) :
    (1 / 2 : ℝ) < (m - 1) / m := by
  have hm0 : 0 < m := by linarith
  apply (lt_div_iff₀ hm0).mpr
  linarith

theorem dyadic_budget (d : ℝ) (n : ℕ) :
    (∑ k ∈ Finset.range n, d / (2 : ℝ) ^ (k + 1)) =
      d * (1 - 1 / (2 : ℝ) ^ n) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, ih]
      simp only [pow_succ]
      have h : (2 : ℝ) ^ n ≠ 0 := by positivity
      field_simp
      ring

theorem dyadic_budget_upper (d : ℝ) (hd : 0 ≤ d) (n : ℕ) :
    (∑ k ∈ Finset.range n, d / (2 : ℝ) ^ (k + 1)) ≤ d := by
  rw [dyadic_budget]
  have h := mul_nonneg hd (show 0 ≤ (1 : ℝ) / (2 : ℝ) ^ n by positivity)
  nlinarith

theorem original_local_bound :
    localCoefficient (53 / 25) < (344 / 1000 : ℝ) := by
  norm_num [localCoefficient]

theorem refined_local_bound :
    localCoefficient (171 / 100) < (277 / 1000 : ℝ) := by
  norm_num [localCoefficient]

theorem manuscript_local_bound :
    (29 / 25 : ℝ) * (53 / 25) * (26 / 25) / (7 / 2) <
      (731 / 1000 : ℝ) := by
  norm_num

theorem original_total_budget :
    (78 / 100 : ℝ) + 1 / 10 = 22 / 25 := by
  norm_num

theorem refined_total_budget :
    (277 / 1000 : ℝ) + 3 / 1000 = 7 / 25 := by
  norm_num

theorem limiting_threshold :
    (29 / 25 : ℝ) * (5 / 3) / (36 / 5) = 29 / 108 := by
  norm_num

end ShieldingAudit
