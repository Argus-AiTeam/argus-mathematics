import Mathlib

namespace HighMomentAudit

theorem weighted_drift
    (A T F D v l Fnext Dnext : Real)
    (hA : 0 <= A) (hT : 0 <= T) (hF : 0 <= F)
    (hD : 0 <= D) (hv : 0 <= v) (hl : 0 < l)
    (hFnext : Fnext <= (1 + A / l) * F + T * D / l ^ 2 + v * (1 + F + D))
    (hDnext : Dnext <= (1 + A / l) * D + T * F / l + v * (1 + F + D)) :
    let k : Real := 1 / (1 + T)
    let u : Real := T / (k * l ^ 2) + (1 + k) * v / k
    1 + Fnext + k * Dnext <=
      (1 + (A + 1) / l + u) * (1 + F + k * D) := by
  let k : Real := 1 / (1 + T)
  let u : Real := T / (k * l ^ 2) + (1 + k) * v / k
  change 1 + Fnext + k * Dnext <=
    (1 + (A + 1) / l + u) * (1 + F + k * D)
  have hden : 0 < 1 + T := by linarith
  have hk : 0 < k := by dsimp [k]; positivity
  have hraw :
      1 + Fnext + k * Dnext <=
        1 + (1 + A / l) * F + T * D / l ^ 2
          + k * ((1 + A / l) * D + T * F / l)
          + (1 + k) * v * (1 + F + D) := by
    have hweighted := mul_le_mul_of_nonneg_left hDnext (le_of_lt hk)
    nlinarith
  have hidentity :
      (1 + (A + 1) / l + u) * (1 + F + k * D) =
        (1 + (1 + A / l) * F + T * D / l ^ 2
          + k * ((1 + A / l) * D + T * F / l)
          + (1 + k) * v * (1 + F + D))
        + ((A + 1) / l + T / (k * l ^ 2) + (1 + k) * T * v
          + F * (k / l + T / (k * l ^ 2) + (1 + k) * T * v)
          + k * D / l) := by
    dsimp [u, k]
    field_simp [ne_of_gt hden, ne_of_gt hl]
    ring
  have hgap :
      0 <= (A + 1) / l + T / (k * l ^ 2) + (1 + k) * T * v
        + F * (k / l + T / (k * l ^ 2) + (1 + k) * T * v)
        + k * D / l := by
    positivity
  rw [hidentity]
  linarith

end HighMomentAudit
