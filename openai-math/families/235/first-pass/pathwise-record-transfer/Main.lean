import Mathlib

open MeasureTheory Set
open scoped InnerProductSpace

namespace RecordTransfer

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℝ H]
  [MeasurableSpace H] [BorelSpace H]

theorem pair_interval_on_support
    (μ : Measure H) (a b : ℝ)
    (h : ∀ᵐ v ∂μ, ∀ᵐ w ∂μ, ⟪v, w⟫_ℝ ∈ Icc a b) :
    ∀ v ∈ μ.support, ∀ w ∈ μ.support, ⟪v, w⟫_ℝ ∈ Icc a b := by
  have hsections : ∀ᵐ v ∂μ, ∀ w ∈ μ.support, ⟪v, w⟫_ℝ ∈ Icc a b := by
    filter_upwards [h] with v hv
    exact μ.support_subset_of_isClosed
      (isClosed_Icc.preimage (continuous_const.inner continuous_id)) hv
  intro v hv w hw
  have hw_ae : ∀ᵐ x ∂μ, ⟪x, w⟫_ℝ ∈ Icc a b :=
    hsections.mono fun x hx => hx w hw
  exact μ.support_subset_of_isClosed
    (isClosed_Icc.preimage (continuous_id.inner continuous_const)) hw_ae hv

theorem old_record_on_support
    (μ : Measure H) (δ : ℝ)
    (h : ∀ᵐ v ∂μ, ∀ᵐ w ∂μ, |⟪v, w⟫_ℝ| ≤ δ ^ 2) :
    ∀ v ∈ μ.support, ‖v‖ ^ 2 ≤ δ ^ 2 := by
  have hp : ∀ᵐ v ∂μ, ∀ᵐ w ∂μ, ⟪v, w⟫_ℝ ∈ Icc (-(δ ^ 2)) (δ ^ 2) := by
    filter_upwards [h] with v hv
    filter_upwards [hv] with w hw
    exact abs_le.mp hw
  intro v hv
  have hdiag := (pair_interval_on_support μ _ _ hp v hv v hv).2
  simpa only [real_inner_self_eq_norm_sq] using hdiag

theorem band_diameter_on_support
    (μ : Measure H) (a ε : ℝ)
    (h : ∀ᵐ v ∂μ, ∀ᵐ w ∂μ, ⟪v, w⟫_ℝ ∈ Icc a (a + ε)) :
    ∀ v ∈ μ.support, ∀ w ∈ μ.support, ‖v - w‖ ^ 2 ≤ 2 * ε := by
  have hp := pair_interval_on_support μ a (a + ε) h
  intro v hv w hw
  have hvv := (hp v hv v hv).2
  have hww := (hp w hw w hw).2
  have hvw := (hp v hv w hw).1
  rw [real_inner_self_eq_norm_sq] at hvv hww
  rw [norm_sub_sq_real]
  linarith

theorem band_center_on_support
    (μ : Measure H) (a ε : ℝ) (hε : 0 ≤ ε)
    (h : ∀ᵐ v ∂μ, ∀ᵐ w ∂μ, ⟪v, w⟫_ℝ ∈ Icc a (a + ε))
    (m : H) (hm : m ∈ closedConvexHull ℝ μ.support) :
    ∀ v ∈ μ.support, ‖v - m‖ ^ 2 ≤ 2 * ε := by
  intro v hv
  have hrad : 0 ≤ 2 * ε := mul_nonneg (by norm_num) hε
  have hsqrt := Real.sq_sqrt hrad
  have hsqrtn := Real.sqrt_nonneg (2 * ε)
  have hball : μ.support ⊆ Metric.closedBall v (Real.sqrt (2 * ε)) := by
    intro w hw
    have hdist := band_diameter_on_support μ a ε h v hv w hw
    have hn := norm_nonneg (v - w)
    have hle : ‖v - w‖ ≤ Real.sqrt (2 * ε) := by nlinarith
    simpa only [Metric.mem_closedBall, dist_eq_norm, norm_sub_rev] using hle
  have hm_ball : m ∈ Metric.closedBall v (Real.sqrt (2 * ε)) :=
    closedConvexHull_min hball (convex_closedBall v _) Metric.isClosed_closedBall hm
  have hnorm : ‖v - m‖ ≤ Real.sqrt (2 * ε) := by
    simpa only [Metric.mem_closedBall, dist_eq_norm, norm_sub_rev] using hm_ball
  have hn := norm_nonneg (v - m)
  nlinarith

theorem old_record_ae
    [SecondCountableTopology H] (μ : Measure H) (δ : ℝ)
    (h : ∀ᵐ v ∂μ, ∀ᵐ w ∂μ, |⟪v, w⟫_ℝ| ≤ δ ^ 2) :
    ∀ᵐ v ∂μ, ‖v‖ ^ 2 ≤ δ ^ 2 := by
  have hs : ∀ᵐ v ∂μ, v ∈ μ.support := μ.support_mem_ae
  exact hs.mono fun v hv => old_record_on_support μ δ h v hv

theorem band_center_ae
    [SecondCountableTopology H] (μ : Measure H) (a ε : ℝ) (hε : 0 ≤ ε)
    (h : ∀ᵐ v ∂μ, ∀ᵐ w ∂μ, ⟪v, w⟫_ℝ ∈ Icc a (a + ε))
    (m : H) (hm : m ∈ closedConvexHull ℝ μ.support) :
    ∀ᵐ v ∂μ, ‖v - m‖ ^ 2 ≤ 2 * ε := by
  have hs : ∀ᵐ v ∂μ, v ∈ μ.support := μ.support_mem_ae
  exact hs.mono fun v hv => band_center_on_support μ a ε hε h m hm v hv

theorem advertised_tolerance
    (errorSq J γ δ : ℝ) (hJ : 0 < J)
    (herror : errorSq ≤ 2 * J * γ)
    (hγ : γ ≤ δ ^ 2 / (2 * J)) :
    errorSq ≤ δ ^ 2 := by
  have hden : 0 < 2 * J := mul_pos (by norm_num) hJ
  have hbound := (le_div_iff₀ hden).mp hγ
  nlinarith

end RecordTransfer

#print axioms RecordTransfer.pair_interval_on_support
#print axioms RecordTransfer.old_record_ae
#print axioms RecordTransfer.band_center_ae
#print axioms RecordTransfer.advertised_tolerance
