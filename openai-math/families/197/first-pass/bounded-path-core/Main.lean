import Mathlib

namespace BoundedPathCore

open Finset

theorem occurrence_multiplicity_bound
    {O B : Type*} [Fintype O] [DecidableEq O] [DecidableEq B]
    (block : O → B) (mate : O → O)
    (hinv : Function.Involutive mate)
    (hnoself : ∀ x, mate x ≠ x → block (mate x) ≠ block x)
    (b : B) :
    2 * (univ.filter (fun x => block x = b)).card ≤
      Fintype.card O + (univ.filter (fun x => mate x = x)).card := by
  classical
  let A := univ.filter (fun x => block x = b)
  let P := A.filter (fun x => mate x ≠ x)
  let F := A.filter (fun x => mate x = x)
  have hdis : Disjoint P F := by
    apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (mem_filter.mp hx).2 (mem_filter.mp hy).2
  have hcup : P ∪ F = A := by
    ext x
    simp only [P, F, mem_union, mem_filter]
    tauto
  have hcards : P.card + F.card = A.card := by
    rw [← card_union_of_disjoint hdis, hcup]
  have hsub : P.image mate ⊆ univ \ A := by
    intro y hy
    obtain ⟨x, hx, rfl⟩ := mem_image.mp hy
    have hxA : block x = b := (mem_filter.mp (mem_filter.mp hx).1).2
    have hxM : mate x ≠ x := (mem_filter.mp hx).2
    have hne : block (mate x) ≠ b := by
      simpa only [hxA] using hnoself x hxM
    simp only [mem_sdiff, mem_univ, true_and]
    intro hyA
    exact hne (mem_filter.mp hyA).2
  have hpc : P.card ≤ Fintype.card O - A.card := by
    have hh := card_le_card hsub
    rw [card_image_of_injective P hinv.injective] at hh
    simpa only [card_sdiff, inter_univ, card_univ] using hh
  have hfixed : F.card ≤ (univ.filter (fun x => mate x = x)).card := by
    apply card_le_card
    intro x hx
    exact mem_filter.mpr ⟨mem_univ x, (mem_filter.mp hx).2⟩
  have hsize : A.card ≤ Fintype.card O := card_le_univ A
  change 2 * A.card ≤ _
  omega

theorem stage_coarea
    {E : Type*} [Fintype E]
    (m : E → ℕ) (M : ℕ) (hm : ∀ e, m e ≤ M) :
    (∑ j ∈ range M, (univ.filter (fun e => j < m e)).card) =
      ∑ e, m e := by
  classical
  calc
    _ = ∑ j ∈ range M, ∑ e, if j < m e then (1 : ℕ) else 0 := by
      apply sum_congr rfl
      intro j hj
      simp only [card_eq_sum_ones, sum_filter]
    _ = ∑ e, ∑ j ∈ range M, if j < m e then (1 : ℕ) else 0 := by
      rw [sum_comm]
    _ = ∑ e, m e := by
      apply sum_congr rfl
      intro e he
      have hh : (range M).filter (fun j => j < m e) = range (m e) := by
        ext j
        simp only [mem_filter, mem_range]
        have hme := hm e
        omega
      calc
        _ = ((range M).filter (fun j => j < m e)).card := by
          simp only [card_eq_sum_ones, sum_filter]
        _ = m e := by rw [hh, card_range]

theorem component_budget_bound
    (s tau A c S z b d : ℝ)
    (hs : 0 ≤ s) (hA : tau ≤ A) (hc : 0 ≤ c) (hb : 0 ≤ b)
    (hmatch : 2 * z ≤ S + b)
    (hlo : tau * s - c ≤ d) (hhi : d ≤ A * s) :
    z * (2 * d - 2 * tau * s + 2 * c) - S * d ≤
      -tau * s * S + (A - tau) * s * b + c * (S + b) := by
  let B := (A - tau) * s + c
  let D := d - tau * s + c
  have hB : 0 ≤ B := by
    dsimp [B]
    exact add_nonneg (mul_nonneg (sub_nonneg.mpr hA) hs) hc
  have hD : 0 ≤ D := by dsimp [D]; linarith
  have hDB : D ≤ B := by dsimp [D, B]; nlinarith
  by_cases ht : 2 * z - S ≤ 0
  · have h1 := mul_nonneg (show 0 ≤ S - 2 * z by linarith) hD
    have h2 := mul_nonneg hb hB
    dsimp [D, B] at h1 h2
    nlinarith
  · have h1 := mul_nonneg hB (show 0 ≤ b - (2 * z - S) by linarith)
    have h2 := mul_nonneg (show 0 ≤ 2 * z - S by linarith)
      (sub_nonneg.mpr hDB)
    dsimp [B, D] at h1 h2
    nlinarith

def weightLambda : ℚ := 71589573988 / 72026254783

theorem weight_contraction :
    0 < weightLambda ∧ weightLambda < 1 ∧
    ((16534 : ℚ) * (129 / 16513) ^ 2 + 3 / 2) / 4 ≤ weightLambda ∧
    (16533 : ℚ) / 16641 + 7 * (129 / 16513) ^ 2 = weightLambda ∧
    (16530 : ℚ) / 16641 + 7 * (129 / 16513) ^ 2 ≤ weightLambda := by
  norm_num [weightLambda]

end BoundedPathCore
