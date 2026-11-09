import Mathlib

open scoped BigOperators

namespace InnerAverageCorrection

theorem mixing_contraction
    (theta x y lambda : ℝ)
    (hx : 0 ≤ x) (hy : 0 ≤ y)
    (htheta : (1 : ℝ) / 8 ≤ theta)
    (hsmall : x ≤ theta / 2)
    (hlambda : lambda ≤ (1 : ℝ) / 64)
    (hmix : theta * y ≤ x * y + lambda * Real.sqrt (x * y)) :
    y ≤ x / 16 := by
  have hs : 0 ≤ Real.sqrt (x * y) := Real.sqrt_nonneg _
  have hsq : (Real.sqrt (x * y)) ^ 2 = x * y :=
    Real.sq_sqrt (mul_nonneg hx hy)
  have hgap : (1 : ℝ) / 16 ≤ theta - x := by linarith
  have hproduct : 0 ≤ (theta - x - 1 / 16) * y :=
    mul_nonneg (by linarith) hy
  have hl := mul_le_mul_of_nonneg_right hlambda hs
  have hroot : 4 * y ≤ Real.sqrt (x * y) := by
    nlinarith
  have hsquares : 0 ≤ (Real.sqrt (x * y) - 4 * y) *
      (Real.sqrt (x * y) + 4 * y) :=
    mul_nonneg (sub_nonneg.mpr hroot) (by nlinarith)
  by_cases hyzero : y = 0
  · subst y
    linarith
  · have hypos : 0 < y := lt_of_le_of_ne hy (Ne.symm hyzero)
    by_contra hgoal
    have hnegative : x - 16 * y < 0 := by linarith
    have hnegative_product := mul_neg_of_neg_of_pos hnegative hypos
    nlinarith

theorem product_support_accounting (s delta : ℝ) (hs : 0 < s) :
    2 * (s * delta / 4) / s + delta / 2 = delta := by
  field_simp [ne_of_gt hs]
  ring

theorem weighted_exceptional_mass
    {X : Type*} [Fintype X] [Nonempty X]
    (q R : X → ℝ) (C T delta : ℝ)
    (hC : 0 ≤ C)
    (hR : ∀ x, 0 ≤ R x)
    (hq : ∀ x, q x ≤ C / (Fintype.card X : ℝ))
    (hsum : (∑ x, R x) ≤ (Fintype.card X : ℝ) * T * delta) :
    (∑ x, if (1 : ℝ) / 8 < R x then q x else 0) ≤ 8 * C * T * delta := by
  classical
  have hN : 0 < (Fintype.card X : ℝ) := by
    exact_mod_cast Fintype.card_pos
  have hcoefficient : 0 ≤ 8 * C / (Fintype.card X : ℝ) := by positivity
  have hpoint : ∀ x,
      (if (1 : ℝ) / 8 < R x then q x else 0) ≤
        (8 * C / (Fintype.card X : ℝ)) * R x := by
    intro x
    split_ifs with hbad
    · calc
        q x ≤ C / (Fintype.card X : ℝ) := hq x
        _ ≤ (8 * C / (Fintype.card X : ℝ)) * R x := by
          have hscaled : 1 ≤ 8 * R x := by linarith
          have hnonnegative : 0 ≤ C / (Fintype.card X : ℝ) := by positivity
          have hmul := mul_le_mul_of_nonneg_left hscaled hnonnegative
          calc
            C / (Fintype.card X : ℝ) ≤
                (C / (Fintype.card X : ℝ)) * (8 * R x) := by
              simpa using hmul
            _ = (8 * C / (Fintype.card X : ℝ)) * R x := by ring
    · exact mul_nonneg hcoefficient (hR x)
  have hfirst := Finset.sum_le_sum (fun x (_ : x ∈ Finset.univ) => hpoint x)
  rw [← Finset.mul_sum] at hfirst
  have hsecond := mul_le_mul_of_nonneg_left hsum hcoefficient
  have hcancel :
      (8 * C / (Fintype.card X : ℝ)) *
        ((Fintype.card X : ℝ) * T * delta) = 8 * C * T * delta := by
    field_simp [ne_of_gt hN]
  exact hfirst.trans (hsecond.trans_eq hcancel)

theorem common_exceptional_set
    {X Forms : Type*} [Fintype X] [Nonempty X]
    (q R : X → ℝ) (p : X → Forms → ℝ) (C T delta : ℝ)
    (hC : 0 ≤ C)
    (hR : ∀ x, 0 ≤ R x)
    (hq : ∀ x, q x ≤ C / (Fintype.card X : ℝ))
    (hsum : (∑ x, R x) ≤ (Fintype.card X : ℝ) * T * delta)
    (hp : ∀ x f, p x f ≤ (1 : ℝ) / 32 + R x) :
    ∃ E : Set X,
      (∀ x, x ∈ E ↔ (1 : ℝ) / 8 < R x) ∧
      (∀ x, x ∉ E → ∀ f, p x f ≤ (5 : ℝ) / 32) ∧
      (∑ x, if (1 : ℝ) / 8 < R x then q x else 0) ≤ 8 * C * T * delta := by
  classical
  refine ⟨{x | (1 : ℝ) / 8 < R x}, ?_, ?_, ?_⟩
  · intro x
    rfl
  · intro x hx f
    change ¬ (1 : ℝ) / 8 < R x at hx
    have hsmall : R x ≤ (1 : ℝ) / 8 := le_of_not_gt hx
    linarith [hp x f]
  · exact weighted_exceptional_mass q R C T delta hC hR hq hsum

theorem fixed_radius_before_accuracy
    (B T nu zeta : ℝ)
    (hB : 0 < B) (hT : 0 < T) (hnu : 0 < nu) (hzeta : 0 < zeta) :
    ∃ rho : ℝ, 0 < rho ∧ rho = nu * zeta / (64 * B * T) ∧
      ∀ C eta : ℝ, 1 ≤ C → 0 < eta →
        ∃ delta : ℝ, 0 < delta ∧
          T * B * rho / (nu * zeta) = (1 : ℝ) / 64 ∧
          8 * C * T * delta = eta / 2 := by
  let rho := nu * zeta / (64 * B * T)
  refine ⟨rho, ?_, rfl, ?_⟩
  · dsimp [rho]
    positivity
  · intro C eta hC heta
    have hCpos : 0 < C := by linarith
    refine ⟨eta / (16 * T * C), by positivity, ?_, ?_⟩
    · dsimp [rho]
      field_simp [ne_of_gt hB, ne_of_gt hT, ne_of_gt hnu, ne_of_gt hzeta]
    · field_simp [ne_of_gt hT, ne_of_gt hCpos]
      ring

end InnerAverageCorrection
