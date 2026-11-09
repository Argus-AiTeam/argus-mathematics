import Mathlib

open MeasureTheory

namespace AffineTransport

theorem le_of_small_error (a d : ℝ)
    (h : ∀ ε : ℝ, 0 < ε → a ≤ d + ε) : a ≤ d := by
  by_contra hn
  have hg : 0 < (a - d) / 2 := by linarith
  have hh := h ((a - d) / 2) hg
  linarith

theorem exhausted_comparison (a : ℕ → ℝ) (b d : ℝ)
    (hfinite : ∀ n ε, 0 < ε → a n ≤ d + ε)
    (hexhaust : ∀ ε, 0 < ε → ∃ n, b ≤ a n + ε) : b ≤ d := by
  apply le_of_small_error
  intro ε hε
  obtain ⟨n, hn⟩ := hexhaust (ε / 2) (by linarith)
  have hf := hfinite n (ε / 2) (by linarith)
  linarith

theorem box_factor_bound (h v ε : ℝ)
    (hh : 0 ≤ h) (hv : 0 ≤ v) (hε : 0 < ε) (hε1 : ε ≤ 1)
    (hhε : h ≤ ε / 4) (hvε : v ≤ ε / 4) :
    (1 + h) * (1 + v) ≤ 1 + ε := by
  have hm := mul_le_mul hhε hvε hv (by linarith : 0 ≤ ε / 4)
  nlinarith [mul_nonneg hε.le (sub_nonneg.mpr hε1)]

theorem strict_gain_forces_zero
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (pos neg gain : Ω → ℝ)
    (ipos : Integrable pos μ) (ineg : Integrable neg μ)
    (igain : Integrable gain μ)
    (hpos : ∀ᵐ ω ∂μ, 0 ≤ pos ω)
    (hneg : ∀ᵐ ω ∂μ, 0 ≤ neg ω)
    (hle : ∀ᵐ ω ∂μ, pos ω ≤ gain ω)
    (hstrict : ∀ᵐ ω ∂μ, 0 < pos ω → pos ω < gain ω)
    (htransport : (∫ ω, gain ω ∂μ) ≤ ∫ ω, neg ω ∂μ)
    (hbalance : (∫ ω, pos ω ∂μ) = ∫ ω, neg ω ∂μ) :
    (pos =ᵐ[μ] 0) ∧ (neg =ᵐ[μ] 0) := by
  have hmono := integral_mono_ae ipos igain hle
  have heq : (∫ ω, pos ω ∂μ) = ∫ ω, gain ω ∂μ := by linarith
  have hpg : pos =ᵐ[μ] gain :=
    (integral_eq_iff_of_ae_le ipos igain hle).mp heq
  have hz : pos =ᵐ[μ] 0 := by
    filter_upwards [hpos, hstrict, hpg] with ω hp hs he
    change pos ω = 0
    by_contra hn
    have hp0 : 0 < pos ω := lt_of_le_of_ne hp (Ne.symm hn)
    have hh := hs hp0
    linarith
  have hpint : (∫ ω, pos ω ∂μ) = 0 := by
    calc
      (∫ ω, pos ω ∂μ) = ∫ ω, (0 : Ω → ℝ) ω ∂μ := integral_congr_ae hz
      _ = 0 := by simp
  have hnint : (∫ ω, neg ω ∂μ) = 0 := by linarith
  exact ⟨hz, (integral_eq_zero_iff_of_nonneg_ae hneg ineg).mp hnint⟩

theorem inverse_square_endpoint (β j : ℝ)
    (hβ : 1 ≤ β) (hj : j ≤ 0)
    (hmoment : ((β + 3) / 4) ^ 2 * j = (β + 3) * (β - 1) / 16) :
    β = 1 := by
  have hleft : ((β + 3) / 4) ^ 2 * j ≤ 0 :=
    mul_nonpos_of_nonneg_of_nonpos (sq_nonneg _) hj
  by_contra hn
  have hβ1 : 1 < β := lt_of_le_of_ne hβ (Ne.symm hn)
  have hright : 0 < (β + 3) * (β - 1) / 16 :=
    div_pos (mul_pos (by linarith) (by linarith)) (by norm_num)
  linarith

theorem inverse_first_endpoint (β j : ℝ)
    (hβ : (1 : ℝ) / 4 ≤ β) (hj : j ≤ 0)
    (hmoment : ((β + 2) / 3) ^ 2 * j = (4 * β - 1) * (β + 2) / 9) :
    β = (1 : ℝ) / 4 := by
  have hleft : ((β + 2) / 3) ^ 2 * j ≤ 0 :=
    mul_nonpos_of_nonneg_of_nonpos (sq_nonneg _) hj
  by_contra hn
  have hβ1 : (1 : ℝ) / 4 < β := lt_of_le_of_ne hβ (Ne.symm hn)
  have hright : 0 < (4 * β - 1) * (β + 2) / 9 :=
    div_pos (mul_pos (by linarith) (by linarith)) (by norm_num)
  linarith

noncomputable def quadratic (t : ℝ) (z : ℂ) : ℂ :=
  ((z - (t : ℂ)) ^ 2 - (Complex.I - (t : ℂ)) ^ 2) /
    (2 * (Complex.I - (t : ℂ)))

theorem quadratic_denominator_ne_zero (t : ℝ) :
    2 * (Complex.I - (t : ℂ)) ≠ 0 := by
  apply mul_ne_zero (by norm_num)
  intro h
  have him := congrArg Complex.im h
  norm_num at him

theorem quadratic_at_i (t : ℝ) : quadratic t Complex.I = 0 := by
  simp [quadratic]

theorem quadratic_injective_on_upper_half_plane (t : ℝ) :
    Set.InjOn (quadratic t) {z : ℂ | 0 < z.im} := by
  intro z hz w hw heq
  have hd := quadratic_denominator_ne_zero t
  have hnum :
      (z - (t : ℂ)) ^ 2 - (Complex.I - (t : ℂ)) ^ 2 =
      (w - (t : ℂ)) ^ 2 - (Complex.I - (t : ℂ)) ^ 2 := by
    have hh := congrArg (fun v : ℂ => v * (2 * (Complex.I - (t : ℂ)))) heq
    simpa [quadratic, hd] using hh
  have hprod : (z - w) * (z + w - 2 * (t : ℂ)) = 0 := by
    calc
      (z - w) * (z + w - 2 * (t : ℂ)) =
          ((z - (t : ℂ)) ^ 2 - (Complex.I - (t : ℂ)) ^ 2) -
          ((w - (t : ℂ)) ^ 2 - (Complex.I - (t : ℂ)) ^ 2) := by ring
      _ = 0 := sub_eq_zero.mpr hnum
  rcases mul_eq_zero.mp hprod with hzw | hsum
  · exact sub_eq_zero.mp hzw
  · have him := congrArg Complex.im hsum
    have hsumim : z.im + w.im = 0 := by simpa using him
    change 0 < z.im at hz
    change 0 < w.im at hw
    linarith

end AffineTransport
