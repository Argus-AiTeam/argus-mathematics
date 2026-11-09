import Mathlib

open Finset

namespace AlignmentRationalization

universe u

theorem rational_below {x δ : ℝ} (hx : 0 ≤ x) (hδ : 0 < δ) :
    ∃ q : ℚ, 0 ≤ (q : ℝ) ∧ (q : ℝ) ≤ x ∧ x - q < δ := by
  by_cases hzero : x = 0
  · exact ⟨0, by simp [hzero, hδ]⟩
  · have hpos : 0 < x := lt_of_le_of_ne hx (Ne.symm hzero)
    have hlow : max 0 (x - δ) < x := by
      rw [max_lt_iff]
      exact ⟨hpos, by linarith⟩
    obtain ⟨q, hqlo, hqhi⟩ := exists_rat_btwn hlow
    refine ⟨q, (le_max_left _ _).trans hqlo.le, hqhi.le, ?_⟩
    have := (le_max_right 0 (x - δ)).trans_lt hqlo
    linarith

theorem finite_rational_l1_approximation {α : Type u} [Fintype α] [Nonempty α]
    (w : α → ℝ) (hw : ∀ i, 0 ≤ w i) (hsum : ∑ i, w i = 1)
    {ε : ℝ} (hε : 0 < ε) :
    ∃ q : α → ℚ, (∀ i, 0 ≤ q i) ∧ (∑ i, q i = 1) ∧
      ∑ i, |(q i : ℝ) - w i| < ε := by
  classical
  let c : ℝ := Fintype.card α
  have hc : 0 < c := by dsimp [c]; exact_mod_cast Fintype.card_pos
  let δ : ℝ := ε / (4 * c)
  have hδ : 0 < δ := by dsimp [δ]; positivity
  have hbelow : ∀ i, ∃ q : ℚ, 0 ≤ (q : ℝ) ∧ (q : ℝ) ≤ w i ∧ w i - q < δ :=
    fun i => rational_below (hw i) hδ
  choose v hv using hbelow
  let a : α := Classical.choice inferInstance
  let S : ℚ := ∑ i, v i
  have hSreal : (S : ℝ) ≤ 1 := by
    calc
      (S : ℝ) = ∑ i, (v i : ℝ) := by simp [S]
      _ ≤ ∑ i, w i := Finset.sum_le_sum fun i _ => (hv i).2.1
      _ = 1 := hsum
  have hS : S ≤ 1 := by exact_mod_cast hSreal
  let q : α → ℚ := fun i => v i + if i = a then 1 - S else 0
  have hqnonneg : ∀ i, 0 ≤ q i := by
    intro i
    have hvnonneg : 0 ≤ v i := by exact_mod_cast (hv i).1
    dsimp [q]
    split_ifs <;> linarith
  have hqsum : ∑ i, q i = 1 := by
    simp [q, Finset.sum_add_distrib, S]
  let R : ℝ := 1 - S
  have hR : 0 ≤ R := sub_nonneg.mpr hSreal
  have hRsum : R = ∑ i, (w i - (v i : ℝ)) := by
    simp [R, S, Finset.sum_sub_distrib, hsum]
  have hpoint : ∀ i, |(q i : ℝ) - w i| ≤
      (w i - (v i : ℝ)) + if i = a then R else 0 := by
    intro i
    have hvle : (v i : ℝ) - w i ≤ 0 := sub_nonpos.mpr (hv i).2.1
    by_cases hi : i = a
    · have hdiff : (q i : ℝ) - w i = (v i : ℝ) - w i + R := by
        simp [q, hi, R]
        ring
      rw [hdiff]
      calc
        _ ≤ |(v i : ℝ) - w i| + |R| := abs_add_le _ _
        _ = (w i - (v i : ℝ)) + if i = a then R else 0 := by
          rw [abs_of_nonpos hvle, abs_of_nonneg hR]
          simp only [hi, ite_true]
          ring
    · simp [q, hi, abs_of_nonpos hvle]
  have herrors : ∑ i, (w i - (v i : ℝ)) ≤ c * δ := by
    calc
      _ ≤ ∑ _i : α, δ := Finset.sum_le_sum fun i _ => (hv i).2.2.le
      _ = c * δ := by simp [c]
  have hbudget : 2 * c * δ < ε := by
    have heq : 2 * c * δ = ε / 2 := by
      dsimp [δ]
      field_simp
      ring
    rw [heq]
    linarith
  refine ⟨q, hqnonneg, hqsum, ?_⟩
  calc
    ∑ i, |(q i : ℝ) - w i| ≤
        ∑ i, ((w i - (v i : ℝ)) + if i = a then R else 0) :=
      Finset.sum_le_sum fun i _ => hpoint i
    _ = (∑ i, (w i - (v i : ℝ))) + R := by simp [Finset.sum_add_distrib]
    _ = 2 * (∑ i, (w i - (v i : ℝ))) := by rw [hRsum]; ring
    _ ≤ 2 * (c * δ) := by gcongr
    _ < ε := by nlinarith [hbudget]

theorem rationalize_uniformly {α : Type u} [Fintype α] [Nonempty α]
    (w : α → ℝ) (hw : ∀ i, 0 ≤ w i) (hsum : ∑ i, w i = 1)
    {ξ η : ℝ} (hmargin : ξ < η) :
    ∃ q : α → ℚ, (∀ i, 0 ≤ q i) ∧ (∑ i, q i = 1) ∧
      ∀ b : α → ℝ, (∀ i, 0 ≤ b i ∧ b i ≤ 1) →
        (∑ i, w i * b i) ≤ ξ → (∑ i, (q i : ℝ) * b i) < η := by
  obtain ⟨q, hqnonneg, hqsum, hdist⟩ :=
    finite_rational_l1_approximation w hw hsum (sub_pos.mpr hmargin)
  refine ⟨q, hqnonneg, hqsum, ?_⟩
  intro b hb hwb
  have heq : (∑ i, (q i : ℝ) * b i) - (∑ i, w i * b i) =
      ∑ i, (((q i : ℝ) - w i) * b i) := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro i _
    ring
  have hdiff : |(∑ i, (q i : ℝ) * b i) - (∑ i, w i * b i)| < η - ξ := by
    rw [heq]
    calc
      _ ≤ ∑ i, |((q i : ℝ) - w i) * b i| := Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ i, |(q i : ℝ) - w i| := by
        apply Finset.sum_le_sum
        intro i _
        rw [abs_mul, abs_of_nonneg (hb i).1]
        exact mul_le_of_le_one_right (abs_nonneg _) (hb i).2
      _ < η - ξ := hdist
  have hupper := (abs_lt.mp hdiff).2
  linarith

end AlignmentRationalization
