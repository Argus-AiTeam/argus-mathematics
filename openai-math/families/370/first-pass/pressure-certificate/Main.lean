import Mathlib

open MeasureTheory

namespace PressureCertificate

noncomputable def overlapProfile (L M r : ℝ) : ℝ :=
  max 0 (min L (min M ((L + M) / 2 - r)))

theorem overlapProfile_antitone (L M : ℝ) :
    Antitone (overlapProfile L M) := by
  intro r s hrs
  dsimp [overlapProfile]
  exact max_le_max le_rfl
    (min_le_min le_rfl (min_le_min le_rfl (by linarith)))

theorem paired_midpoint_sign (F : ℝ → ℝ) (h d : ℝ)
    (hF : Antitone F) (hh : 0 ≤ h) :
    0 ≤ d * (F |h - d| - F |h + d|) := by
  by_cases hd : 0 ≤ d
  · have habs : |h - d| ≤ |h + d| := by
      rw [abs_of_nonneg (by linarith : 0 ≤ h + d)]
      exact abs_le.mpr ⟨by linarith, by linarith⟩
    exact mul_nonneg hd (sub_nonneg.mpr (hF habs))
  · have hd' : d ≤ 0 := le_of_not_ge hd
    have habs : |h + d| ≤ |h - d| := by
      rw [abs_of_nonneg (by linarith : 0 ≤ h - d)]
      exact abs_le.mpr ⟨by linarith, by linarith⟩
    exact mul_nonneg_of_nonpos_of_nonpos hd'
      (sub_nonpos.mpr (hF habs))

theorem midpoint_integral_sign (μ : Measure ℝ) (F k : ℝ → ℝ)
    (d : ℝ) (hF : Antitone F)
    (hk : ∀ h, 0 ≤ h → 0 ≤ k h)
    (hs : ∀ᵐ h ∂μ, 0 ≤ h)
    (_hint : Integrable
      (fun h => k h * (F |h - d| - F |h + d|)) μ) :
    0 ≤ d * ∫ h, k h * (F |h - d| - F |h + d|) ∂μ := by
  have hnonneg :
      0 ≤ ∫ h, d * (k h * (F |h - d| - F |h + d|)) ∂μ := by
    apply integral_nonneg_of_ae
    filter_upwards [hs] with h hh
    have hproduct :=
      mul_nonneg (hk h hh) (paired_midpoint_sign F h d hF hh)
    simpa [mul_assoc, mul_left_comm, mul_comm] using hproduct
  simpa only [integral_const_mul] using hnonneg

theorem weighted_endpoint_reduction (A BI BJ T cI cJ : ℝ)
    (hcI : 0 ≤ cI) (hcJ : 0 ≤ cJ)
    (hBI : 0 ≤ BI) (hBJ : 0 ≤ BJ)
    (hbase : 2 * A - BI - BJ ≤ T) :
    (cI + cJ) * A ≤
      cI * BI + cJ * BJ + min cI cJ * T + |cI - cJ| * A := by
  by_cases hc : cI ≤ cJ
  · rw [min_eq_left hc, abs_of_nonpos (sub_nonpos.mpr hc)]
    have h1 := mul_nonneg hcI (sub_nonneg.mpr hbase)
    have h2 := mul_nonneg (sub_nonneg.mpr hc) hBJ
    nlinarith
  · have hc' : cJ ≤ cI := le_of_not_ge hc
    rw [min_eq_right hc', abs_of_nonneg (sub_nonneg.mpr hc')]
    have h1 := mul_nonneg hcJ (sub_nonneg.mpr hbase)
    have h2 := mul_nonneg (sub_nonneg.mpr hc') hBI
    nlinarith

end PressureCertificate
