import Mathlib

namespace CriticalResolventComparison

theorem tiltedMeanNumerator (t u s : ℝ) :
    ((1 + t) / 2) * (1 + u * s) -
        ((1 - t) / 2) * (1 - u * s) = t + u * s := by
  ring

theorem tiltedMass (t u s : ℝ) :
    ((1 + t) / 2) * (1 + u * s) +
        ((1 - t) / 2) * (1 - u * s) = 1 + u * s * t := by
  ring

theorem varianceNumerator (t u s : ℝ) (hs : s ^ 2 = 1) :
    (1 + u * s * t) ^ 2 - (t + u * s) ^ 2 =
      (1 - t ^ 2) * (1 - u ^ 2) := by
  calc
    _ = (1 - t ^ 2) * (1 - u ^ 2 * s ^ 2) := by ring
    _ = _ := by rw [hs]; ring

theorem unnormalizedEndpointVariance (t u s : ℝ) (hs : s ^ 2 = 1)
    (hd : 1 + u * s * t ≠ 0) :
    (1 + u * s * t) * (1 - ((t + u * s) / (1 + u * s * t)) ^ 2) =
      (1 - t ^ 2) * ((1 - u ^ 2) / (1 + u * s * t)) := by
  have h := varianceNumerator t u s hs
  calc
    _ = ((1 + u * s * t) ^ 2 - (t + u * s) ^ 2) /
        (1 + u * s * t) := by
          field_simp [hd]
          <;> ring
    _ = _ := by rw [h]; ring

theorem halfDifferenceResidual (t s gp gm : ℝ) :
    s * (gp + gm) / 2 + s * t * ((gp - gm) / 2) =
      s * (((1 + t) / 2) * gp + ((1 - t) / 2) * gm) := by
  ring

theorem finiteEndpointResidual {ι : Type*} [Fintype ι]
    (weight slope mean other plus minus : ι → ℝ) :
    (∑ k, weight k * slope k *
      (other k * (plus k + minus k) / 2 +
        other k * mean k * ((plus k - minus k) / 2))) =
    ∑ k, weight k * slope k * other k *
      (((1 + mean k) / 2) * plus k +
        ((1 - mean k) / 2) * minus k) := by
  apply Finset.sum_congr rfl
  intro k hk
  rw [halfDifferenceResidual]
  ring

theorem binaryJensenIdentity (t gp gm : ℝ) :
    ((1 + t) / 2) * gp ^ 2 + ((1 - t) / 2) * gm ^ 2 -
      (((1 + t) / 2) * gp + ((1 - t) / 2) * gm) ^ 2 =
      (1 - t ^ 2) * ((gp - gm) / 2) ^ 2 := by
  ring

theorem binaryJensen (t gp gm : ℝ) (ht : t ^ 2 ≤ 1) :
    (((1 + t) / 2) * gp + ((1 - t) / 2) * gm) ^ 2 ≤
      ((1 + t) / 2) * gp ^ 2 + ((1 - t) / 2) * gm ^ 2 := by
  have h := binaryJensenIdentity t gp gm
  have hn : 0 ≤ (1 - t ^ 2) * ((gp - gm) / 2) ^ 2 :=
    mul_nonneg (by linarith) (sq_nonneg _)
  linarith

theorem twoEndpointCauchy (a b x y : ℝ) :
    (a * x + b * y) ^ 2 ≤ (a ^ 2 + b ^ 2) * (x ^ 2 + y ^ 2) := by
  nlinarith [sq_nonneg (a * y - b * x)]

theorem endpointCoefficientRecurrence (a : ℝ) (k : ℕ) :
    ((-a) ^ (k + 2) - (-a) ^ k) +
      a * ((-a) ^ (k + 1) - (if k = 0 then 0 else (-a) ^ (k - 1))) =
      if k = 0 then -1 else 0 := by
  cases k with
  | zero => norm_num; ring
  | succ k =>
    simp only [Nat.succ_ne_zero, ↓reduceIte, Nat.succ_sub_one]
    simp only [pow_add, pow_succ]
    ring

section BilinearCompletion

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

theorem residualEquation
    (M : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (b : V →ₗ[ℝ] ℝ) (v y : V)
    (hv : ∀ g, M v g = b g) :
    ∀ g, M (v - y) g = (b - M y) g := by
  intro g
  simp only [map_sub, LinearMap.sub_apply, hv]

theorem variationalCompletion
    (M : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (b : V →ₗ[ℝ] ℝ) (v y : V)
    (hsym : ∀ f g, M f g = M g f)
    (hv : ∀ g, M v g = b g) :
    b v = 2 * b y - M y y + (b - M y) (v - y) := by
  have hcross : M y v = b y := (hsym y v).trans (hv y)
  simp only [map_sub, LinearMap.sub_apply, hcross]
  ring

theorem variationalCompletionEnergy
    (M : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (b : V →ₗ[ℝ] ℝ) (v y : V)
    (hsym : ∀ f g, M f g = M g f)
    (hv : ∀ g, M v g = b g) :
    b v = 2 * b y - M y y + M (v - y) (v - y) := by
  rw [residualEquation M b v y hv]
  exact variationalCompletion M b v y hsym hv

end BilinearCompletion

end CriticalResolventComparison
