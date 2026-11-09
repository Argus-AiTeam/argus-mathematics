import Mathlib

open Finset

namespace AlignmentMinimax

universe u v

noncomputable def payoff {P : Type u} {Q : Type v} [Fintype P] [Fintype Q]
    (b : P → Q → ℝ) (x : P → ℝ) (y : Q → ℝ) : ℝ :=
  ∑ p, x p * ∑ q, y q * b p q

noncomputable def leftLinear {P : Type u} {Q : Type v} [Fintype P] [Fintype Q]
    (b : P → Q → ℝ) (y : Q → ℝ) : (P → ℝ) →ₗ[ℝ] ℝ where
  toFun x := payoff b x y
  map_add' x z := by simp [payoff, add_mul, Finset.sum_add_distrib]
  map_smul' c x := by
    simp [payoff, Pi.smul_apply, smul_eq_mul, Finset.mul_sum, mul_assoc]

noncomputable def rightLinear {P : Type u} {Q : Type v} [Fintype P] [Fintype Q]
    (b : P → Q → ℝ) (x : P → ℝ) : (Q → ℝ) →ₗ[ℝ] ℝ where
  toFun y := payoff b x y
  map_add' y z := by
    simp [payoff, add_mul, mul_add, Finset.sum_add_distrib]
  map_smul' c y := by
    simp [payoff, Pi.smul_apply, smul_eq_mul, Finset.mul_sum,
      mul_comm, mul_left_comm]

theorem payoff_single_right {P : Type u} {Q : Type v} [Fintype P] [Fintype Q]
    [DecidableEq Q] (b : P → Q → ℝ) (x : P → ℝ) (q : Q) :
    payoff b x (Pi.single q 1) = ∑ p, x p * b p q := by
  simp [payoff, Pi.single_apply]

theorem payoff_single_left {P : Type u} {Q : Type v} [Fintype P] [Fintype Q]
    [DecidableEq P] (b : P → Q → ℝ) (p : P) (y : Q → ℝ) :
    payoff b (Pi.single p 1) y = ∑ q, y q * b p q := by
  simp [payoff, Pi.single_apply]

theorem randomized_adversary {P : Type u} {Q : Type v}
    [Fintype P] [Fintype Q] [Nonempty P] [Nonempty Q]
    (b : P → Q → ℝ) (ξ : ℝ)
    (hbad : ∀ x ∈ stdSimplex ℝ P, ∃ q, ξ < ∑ p, x p * b p q) :
    ∃ y ∈ stdSimplex ℝ Q, ∀ p, ξ < ∑ q, y q * b p q := by
  classical
  obtain ⟨p₀⟩ := ‹Nonempty P›
  obtain ⟨q₀⟩ := ‹Nonempty Q›
  have hX : (stdSimplex ℝ P).Nonempty :=
    ⟨Pi.single p₀ 1, single_mem_stdSimplex ℝ p₀⟩
  have hY : (stdSimplex ℝ Q).Nonempty :=
    ⟨Pi.single q₀ 1, single_mem_stdSimplex ℝ q₀⟩
  have hleft : ∀ y ∈ stdSimplex ℝ Q,
      LowerSemicontinuousOn (fun x : P → ℝ => payoff b x y) (stdSimplex ℝ P) := by
    intro y _
    have hc : Continuous (fun x : P → ℝ => payoff b x y) := by
      unfold payoff
      fun_prop
    exact hc.continuousOn.lowerSemicontinuousOn
  have hright : ∀ x ∈ stdSimplex ℝ P,
      UpperSemicontinuousOn (fun y : Q → ℝ => payoff b x y) (stdSimplex ℝ Q) := by
    intro x _
    have hc : Continuous (fun y : Q → ℝ => payoff b x y) := by
      unfold payoff
      fun_prop
    exact hc.continuousOn.upperSemicontinuousOn
  have hconvex : ∀ y ∈ stdSimplex ℝ Q,
      QuasiconvexOn ℝ (stdSimplex ℝ P) (fun x => payoff b x y) := by
    intro y _
    exact ((leftLinear b y).convexOn (convex_stdSimplex ℝ P)).quasiconvexOn
  have hconcave : ∀ x ∈ stdSimplex ℝ P,
      QuasiconcaveOn ℝ (stdSimplex ℝ Q) (fun y => payoff b x y) := by
    intro x _
    exact ((rightLinear b x).concaveOn (convex_stdSimplex ℝ Q)).quasiconcaveOn
  obtain ⟨x, hx, y, hy, hxy⟩ := Sion.exists_isSaddlePointOn
    hX (convex_stdSimplex ℝ P) (isCompact_stdSimplex ℝ P) hleft hconvex
    (convex_stdSimplex ℝ Q) hY (isCompact_stdSimplex ℝ Q) hright hconcave
  obtain ⟨q, hq⟩ := hbad x hx
  refine ⟨y, hy, ?_⟩
  intro p
  have h₁ := hxy x hx (Pi.single q 1) (single_mem_stdSimplex ℝ q)
  have h₂ := hxy (Pi.single p 1) (single_mem_stdSimplex ℝ p) y hy
  rw [payoff_single_right] at h₁
  rw [payoff_single_left] at h₂
  exact hq.trans_le (h₁.trans h₂)

end AlignmentMinimax
