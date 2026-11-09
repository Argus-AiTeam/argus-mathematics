import Mathlib

open scoped BigOperators

namespace FiniteGreen

theorem weighted_cut_transport
    {T E X : Type*} [Fintype T] [Fintype E]
    (prob : T → ℝ) (term : T → E → X → ℝ) (weight : T → E → ℝ)
    (modulus : ℝ)
    (hprob : ∀ t, 0 ≤ prob t)
    (hbound : ∀ t e x, |term t e x| ≤ weight t e * modulus) :
    ∀ x, |∑ t, prob t * ∑ e, term t e x| ≤
      (∑ t, prob t * ∑ e, weight t e) * modulus := by
  intro x
  calc
    |∑ t, prob t * ∑ e, term t e x| ≤
        ∑ t, |prob t * ∑ e, term t e x| :=
      Finset.abs_sum_le_sum_abs _ _
    _ = ∑ t, prob t * |∑ e, term t e x| := by
      apply Finset.sum_congr rfl
      intro t ht
      rw [abs_mul, abs_of_nonneg (hprob t)]
    _ ≤ ∑ t, prob t * ∑ e, weight t e * modulus := by
      apply Finset.sum_le_sum
      intro t ht
      apply mul_le_mul_of_nonneg_left _ (hprob t)
      exact (Finset.abs_sum_le_sum_abs _ _).trans
        (Finset.sum_le_sum (fun e he => hbound t e x))
    _ = (∑ t, prob t * ∑ e, weight t e) * modulus := by
      simp only [Finset.sum_mul, mul_assoc]

theorem simultaneous_cut_transport
    {F T E X : Type*} [Fintype T] [Fintype E]
    (admissible : F → Prop) (prob : T → ℝ)
    (term : F → T → E → X → ℝ) (weight : T → E → ℝ)
    (modulus : F → ℝ)
    (hprob : ∀ t, 0 ≤ prob t)
    (hbound : ∀ f, admissible f → ∀ t e x,
      |term f t e x| ≤ weight t e * modulus f) :
    ∀ f, admissible f → ∀ x,
      |∑ t, prob t * ∑ e, term f t e x| ≤
        (∑ t, prob t * ∑ e, weight t e) * modulus f := by
  intro f hf
  exact weighted_cut_transport prob (term f) weight (modulus f)
    hprob (hbound f hf)

theorem overlapping_small_sides_do_not_cover
    {V : Type*} [Fintype V] [DecidableEq V]
    (mu : V → ℝ) (hpos : ∀ v, 0 < mu v)
    (hnorm : ∑ v, mu v = 1)
    (S R : Finset V)
    (hS : ∑ v ∈ S, mu v ≤ (1 : ℝ) / 2)
    (hR : ∑ v ∈ R, mu v ≤ (1 : ℝ) / 2)
    (x : V) (hxS : x ∈ S) (hxR : x ∈ R) :
    S ∪ R ≠ Finset.univ := by
  intro hcover
  have hlower : mu x ≤ ∑ v ∈ S ∩ R, mu v :=
    Finset.single_le_sum (fun v hv => (hpos v).le)
      (Finset.mem_inter.mpr ⟨hxS, hxR⟩)
  have hid :
      (∑ v ∈ S ∪ R, mu v) + (∑ v ∈ S ∩ R, mu v) =
        (∑ v ∈ S, mu v) + (∑ v ∈ R, mu v) :=
    Finset.sum_union_inter
  rw [hcover, hnorm] at hid
  linarith [hpos x]

end FiniteGreen
