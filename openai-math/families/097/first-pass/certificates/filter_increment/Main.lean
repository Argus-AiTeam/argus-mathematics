import Mathlib

set_option autoImplicit false

namespace FilterIncrement

theorem contraction_defect {R : Type*} [Ring R] (c ct z : R) :
    (1 + c * z * ct) - c * (1 + z) * ct = 1 - c * ct := by
  noncomm_ring

theorem unsaturated_conjugation {R : Type*} [Monoid R]
    (u r : Rˣ) (b : R) (h : Commute (r : R) b) :
    ((r : R) * (↑(u⁻¹) : R)) *
        ((u : R) * (b * (r : R)) * (↑(u⁻¹) : R)) *
        ((u : R) * (r : R)) = b * (r : R) ^ 3 := by
  calc
    _ = (r : R) * (b * ((r : R) * (r : R))) := by
      simp [mul_assoc]
    _ = b * (r : R) ^ 3 := by
      simpa [pow_succ, mul_assoc] using
        congrArg (fun x : R => x * (r : R) * (r : R)) h.eq

theorem saturated_conjugation {R : Type*} [Monoid R]
    (u r : Rˣ) (b : R) (h : Commute (r : R) b) :
    ((r : R) * (↑(u⁻¹) : R)) *
        (((u : R) * (b * (r : R)) * (↑(u⁻¹) : R)) *
          (((u : R) * (↑(r⁻¹) : R) * (↑(u⁻¹) : R)) ^ 3)) *
        ((u : R) * (r : R)) = b := by
  calc
    _ = (r : R) * (b * (↑(r⁻¹) : R)) := by
      simp [pow_succ, mul_assoc]
    _ = b := by
      rw [← mul_assoc, h.eq, mul_assoc, Units.mul_inv, mul_one]

theorem matrix_saturated_conjugation (d : ℕ)
    (u r : (Matrix (Fin d) (Fin d) ℝ)ˣ)
    (b : Matrix (Fin d) (Fin d) ℝ)
    (h : Commute (r : Matrix (Fin d) (Fin d) ℝ) b) :
    ((r : Matrix (Fin d) (Fin d) ℝ) *
        (↑(u⁻¹) : Matrix (Fin d) (Fin d) ℝ)) *
        (((u : Matrix (Fin d) (Fin d) ℝ) *
            (b * (r : Matrix (Fin d) (Fin d) ℝ)) *
            (↑(u⁻¹) : Matrix (Fin d) (Fin d) ℝ)) *
          (((u : Matrix (Fin d) (Fin d) ℝ) *
            (↑(r⁻¹) : Matrix (Fin d) (Fin d) ℝ) *
            (↑(u⁻¹) : Matrix (Fin d) (Fin d) ℝ)) ^ 3)) *
        ((u : Matrix (Fin d) (Fin d) ℝ) *
          (r : Matrix (Fin d) (Fin d) ℝ)) = b :=
  saturated_conjugation u r b h

theorem quartic_forward (u : ℝ) :
    3 * u ^ 4 - 4 * u ^ 3 + 1 =
      (u - 1) ^ 2 * (3 * u ^ 2 + 2 * u + 1) := by
  ring

theorem quartic_reverse (u : ℝ) :
    u ^ 4 - 4 * u + 3 =
      (u - 1) ^ 2 * (u ^ 2 + 2 * u + 3) := by
  ring

theorem budget_telescope (potential budget : ℕ → ℝ)
    (hzero : potential 0 = 0)
    (hstep : ∀ i, potential (i + 1) ≤ potential i + budget i)
    (N : ℕ) :
    potential N ≤ ∑ i ∈ Finset.range N, budget i := by
  induction N with
  | zero => simp [hzero]
  | succ N ih =>
      rw [Finset.sum_range_succ]
      linarith [hstep N]

theorem energy_threshold :
    (((3 : ℚ) / 2) * (1 / 24)) ^ 2 < (1 / 4) ^ 3 := by
  norm_num

end FilterIncrement
