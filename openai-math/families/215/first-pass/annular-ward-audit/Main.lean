import Mathlib

open scoped BigOperators

namespace AnnularWard

variable {I E : Type*} [Fintype I]

def gram (u : I → E → ℂ) (e l : E) : ℂ :=
  ∑ i, u i e * star (u i l)

def kernel (u : I → E → ℂ) (e₁ e₂ e₃ e₄ : E) : ℂ :=
  ∑ i, ∑ j, u i e₁ * star (u i e₂) * star (u j e₃) * u j e₄

theorem gram_swap (u : I → E → ℂ) (e l : E) :
    gram u l e = star (gram u e l) := by
  simp only [gram, star_sum, star_mul, star_star]

theorem kernel_factor (u : I → E → ℂ) (e₁ e₂ e₃ e₄ : E) :
    kernel u e₁ e₂ e₃ e₄ = gram u e₁ e₂ * gram u e₄ e₃ := by
  simp only [kernel, gram]
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  ring

theorem contraction_table (u : I → E → ℂ) (e l m : E) :
    kernel u e l e m = gram u e l * star (gram u e m) ∧
    kernel u e l m e = gram u e l * gram u e m ∧
    kernel u l e e m = star (gram u e l) * star (gram u e m) ∧
    kernel u l e m e = star (gram u e l) * gram u e m ∧
    kernel u e l e l = gram u e l * star (gram u e l) ∧
    kernel u e l l e = gram u e l * gram u e l ∧
    kernel u e e e l = gram u e e * star (gram u e l) ∧
    kernel u e e l e = gram u e e * gram u e l ∧
    kernel u e l e e = gram u e e * gram u e l ∧
    kernel u l e e e = gram u e e * star (gram u e l) ∧
    kernel u e e e e = gram u e e * gram u e e := by
  have hle := gram_swap u e l
  have hme := gram_swap u e m
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals simp only [kernel_factor, hle, hme]
  all_goals ring

theorem row_gradient (u f₀ f₁ : I → ℂ) :
    (∑ i, u i * star (f₁ i - f₀ i)) =
      (∑ i, u i * star (f₁ i)) - ∑ i, u i * star (f₀ i) := by
  simp [mul_sub, Finset.sum_sub_distrib]

noncomputable def wedge (fx fy gx gy : ℂ) : ℂ := (fx * gy - gx * fy) / 2

theorem wedge_skew (fx fy gx gy : ℂ) :
    wedge gx gy fx fy = -wedge fx fy gx gy := by
  unfold wedge
  ring

theorem wedge_star (fx fy gx gy : ℂ) :
    star (wedge fx fy gx gy) =
      wedge (star fx) (star fy) (star gx) (star gy) := by
  simp [wedge]

theorem diagonal_wedge_star (fx fy : ℂ) :
    star (wedge fx fy (star fx) (star fy)) =
      -wedge fx fy (star fx) (star fy) := by
  rw [wedge_star]
  simp only [star_star]
  exact wedge_skew fx fy (star fx) (star fy)

theorem cross_pairing_star (fx fy gx gy : ℂ) :
    wedge (star gx) (star gy) (star fx) (star fy) =
      -star (wedge fx fy gx gy) := by
  rw [wedge_star]
  exact wedge_skew (star fx) (star fy) (star gx) (star gy)

theorem gradient_adjustments (fx fy gx gy : ℂ) :
    wedge fx fy gx gy + (fy * gy - fx * gx) / 2 =
      (fx + fy) * (gy - gx) / 2 ∧
    wedge fx fy gx gy - (fy * gy - fx * gx) / 2 =
      -(gx + gy) * (fy - fx) / 2 := by
  constructor <;> unfold wedge <;> ring

theorem parity_cancellation (x y z : ℝ)
    (halfturn_a : y = -y ∧ z = -z)
    (halfturn_b : x = -x ∧ z = -z) :
    x = 0 ∧ y = 0 ∧ z = 0 := by
  constructor
  · linarith [halfturn_b.1]
  constructor
  · linarith [halfturn_a.1]
  · linarith [halfturn_a.2]

theorem eleven_term_lower
    (p t c e₁ e₂ e₃ e₄ e₅ e₆ e₇ e₈ e₉ e₁₀ e₁₁ : ℝ)
    (hp : 0 ≤ p)
    (h₁ : -(t ^ 4 * c) ≤ e₁) (h₂ : -(t ^ 4 * c) ≤ e₂)
    (h₃ : -(t ^ 4 * c) ≤ e₃) (h₄ : -(t ^ 4 * c) ≤ e₄)
    (h₅ : -(t ^ 4 * c) ≤ e₅) (h₆ : -(t ^ 4 * c) ≤ e₆)
    (h₇ : -(t ^ 3 * c) ≤ e₇) (h₈ : -(t ^ 3 * c) ≤ e₈)
    (h₉ : -(t ^ 3 * c) ≤ e₉) (h₁₀ : -(t ^ 3 * c) ≤ e₁₀)
    (h₁₁ : -(t ^ 2 * c) ≤ e₁₁) :
    -((6 * t ^ 4 + 4 * t ^ 3 + t ^ 2) * c) ≤
      p + e₁ + e₂ + e₃ + e₄ + e₅ + e₆ + e₇ + e₈ + e₉ + e₁₀ + e₁₁ := by
  nlinarith

end AnnularWard
