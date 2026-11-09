import Mathlib

namespace LinearAlignment

theorem perturbed_rayleigh_polynomial (r R e : ℝ)
    (he : 0 ≤ e) (he_small : e ≤ 1 / 4) (hr : r ≤ R) (hR : 0 ≤ R) :
    r + R * (2 * e + e ^ 2) ≤ (r + 8 * R * e) * (1 - e) ^ 2 := by
  have hfirst : 0 ≤ e * (2 - e) * (R - r) :=
    mul_nonneg (mul_nonneg he (by linarith)) (by linarith)
  have hsecond : 0 ≤ 4 * R * e * (1 - 4 * e + 2 * e ^ 2) :=
    mul_nonneg (mul_nonneg (mul_nonneg (by norm_num) hR) he)
      (by nlinarith [sq_nonneg e])
  have identity :
      (r + 8 * R * e) * (1 - e) ^ 2 - (r + R * (2 * e + e ^ 2)) =
        e * (2 - e) * (R - r) + 4 * R * e * (1 - 4 * e + 2 * e ^ 2) := by
    ring
  apply sub_nonneg.mp
  rw [identity]
  exact add_nonneg hfirst hsecond

theorem projection_energy (r R delta p : ℝ)
    (hdelta : 0 < delta) (hr : r ≤ R) (hdeltaR : delta ≤ R)
    (hp : 0 ≤ p) (henergy : (r + delta) * (1 - p) ≤ r + delta / 2) :
    delta / (4 * R) ≤ p := by
  have hR : 0 < R := lt_of_lt_of_le hdelta hdeltaR
  apply (div_le_iff₀ (by positivity : 0 < 4 * R)).2
  have hproduct := mul_le_mul_of_nonneg_right (show r + delta ≤ 2 * R by linarith) hp
  nlinarith

theorem bootstrap_tail (n A d j : ℝ)
    (hA : 0 < A) (hd : 0 < d) (hj : 0 < j)
    (hgate : 256 * n ^ 3 * A ^ 2 ≤ d ^ 2 * j) :
    16 * n ^ 3 * A / (d ^ 2 * j ^ 3) ≤ 1 / (16 * A * j ^ 2) := by
  apply (div_le_div_iff₀ (by positivity : 0 < d ^ 2 * j ^ 3)
    (by positivity : 0 < 16 * A * j ^ 2)).2
  have hproduct := mul_le_mul_of_nonneg_right hgate (sq_nonneg j)
  nlinarith

section GraphExtension

variable {E V : Type*} [AddCommGroup E] [Module ℂ E]
  [AddCommGroup V] [Module ℂ V]

def graphExtension (R S : E →ₗ[ℂ] V) (Y : E →ₗ[ℂ] E) : E →ₗ[ℂ] V :=
  R + S.comp (LinearMap.id - Y)

theorem graphExtension_projection (P : V →ₗ[ℂ] E)
    (R S : E →ₗ[ℂ] V) (Y : E →ₗ[ℂ] E)
    (hR : P.comp R = Y) (hS : P.comp S = LinearMap.id) :
    P.comp (graphExtension R S Y) = LinearMap.id := by
  ext x
  change P (R x + S (x - Y x)) = x
  have hRx : P (R x) = Y x := LinearMap.congr_fun hR x
  have hSx : P (S (x - Y x)) = x - Y x := LinearMap.congr_fun hS (x - Y x)
  rw [map_add, hRx, hSx]
  abel

theorem graphExtension_contains (R S : E →ₗ[ℂ] V) (Y : E →ₗ[ℂ] E)
    (hY : Y.comp Y = Y) (hR : R.comp Y = R) :
    (graphExtension R S Y).comp Y = R := by
  ext x
  change R (Y x) + S (Y x - Y (Y x)) = R x
  have hYx : Y (Y x) = Y x := LinearMap.congr_fun hY x
  have hRx : R (Y x) = R x := LinearMap.congr_fun hR x
  rw [hYx, sub_self, map_zero, add_zero, hRx]

theorem graphExtension_nested (Z : Submodule ℂ V)
    (R S : E →ₗ[ℂ] V) (Y : E →ₗ[ℂ] E)
    (hR : ∀ x, R x ∈ Z) (hS : ∀ x, S x ∈ Z) (x : E) :
    graphExtension R S Y x ∈ Z := by
  exact Z.add_mem (hR x) (hS (x - Y x))

end GraphExtension

end LinearAlignment
