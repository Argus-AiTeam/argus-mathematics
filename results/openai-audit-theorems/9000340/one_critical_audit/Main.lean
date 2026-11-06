import Mathlib

namespace OneCriticalAudit

/-- Exact Taylor cutoff error remainder identity on `r ≤ 2 a` from `verify.py`:
`(K1 + 2 C_chi K0) r^2 - (K1 r^2 + C_chi K0 r^3 / a) = C_chi K0 r^2 (2 - r / a) ≥ 0`. -/
theorem taylor_cutoff_error_remainder (K0 K1 C_chi r a : ℝ) (ha : 0 < a)
    (hC : 0 ≤ C_chi) (hK0 : 0 ≤ K0) (hr : r ≤ 2 * a) :
    (K1 + 2 * C_chi * K0) * r ^ 2 - (K1 * r ^ 2 + C_chi * K0 * r ^ 3 / a) =
      C_chi * K0 * r ^ 2 * (2 - r / a) ∧
    0 ≤ C_chi * K0 * r ^ 2 * (2 - r / a) := by
  constructor
  · field_simp [ne_of_gt ha]
    ring
  · have h1 : 0 ≤ C_chi * K0 * r ^ 2 :=
      mul_nonneg (mul_nonneg hC hK0) (sq_nonneg r)
    have h2 : 0 ≤ 2 - r / a := by
      have : r / a ≤ 2 := (div_le_iff₀ ha).mpr (by linarith)
      linarith
    exact mul_nonneg h1 h2

/-- Modified handle derivative positivity on `mup ∈ [-3/4, 0]` from `verify.py`:
for `hx = -2 (1 + mup)` and `hy = 2 (1 - 2 mup)`, both `-hx ≥ 1/2 > 0` and `hy ≥ 2 > 0`. -/
theorem modified_handle_derivative_margins (mup : ℝ)
    (hlo : -3 / 4 ≤ mup) (hhi : mup ≤ 0) :
    1 / 2 ≤ 2 * (1 + mup) ∧ 2 ≤ 2 * (1 - 2 * mup) := by
  constructor <;> linarith

end OneCriticalAudit
