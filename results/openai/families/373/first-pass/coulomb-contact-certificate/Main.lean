import Mathlib

open Set MeasureTheory
open scoped ENNReal NNReal

namespace CoulombContact

variable {α β ι : Type*} [MeasurableSpace α] [MeasurableSpace β]
  [Fintype ι] [DecidableEq ι]

noncomputable def weightedMixture (ν : Measure α) (H : ι → α → β)
    (w : ι → ℝ≥0) : Measure β :=
  ∑ i, (w i : ℝ≥0∞) • Measure.map (H i) ν

omit [Fintype ι] in
theorem component_image_measure (ν : Measure α) (H : ι → α → β)
    (hH : ∀ i, MeasurableEmbedding (H i))
    (hdisj : ∀ i j, i ≠ j → Disjoint (range (H i)) (range (H j)))
    (i j : ι) (s : Set α) (hs : MeasurableSet s) :
    (Measure.map (H i) ν) (H j '' s) = if i = j then ν s else 0 := by
  rw [Measure.map_apply (hH i).measurable ((hH j).measurableSet_image.mpr hs)]
  split_ifs with hij
  · subst i
    rw [(hH j).injective.preimage_image]
  · have hempty : H i ⁻¹' (H j '' s) = ∅ := by
      apply Set.eq_empty_iff_forall_notMem.mpr
      intro x hx
      rcases hx with ⟨y, hy, heq⟩
      exact Set.disjoint_left.mp (hdisj i j hij) ⟨x, rfl⟩ ⟨y, heq⟩
    rw [hempty, measure_empty]

theorem mixture_image_measure (ν : Measure α) (H : ι → α → β)
    (w : ι → ℝ≥0) (hH : ∀ i, MeasurableEmbedding (H i))
    (hdisj : ∀ i j, i ≠ j → Disjoint (range (H i)) (range (H j)))
    (j : ι) (s : Set α) (hs : MeasurableSet s) :
    weightedMixture ν H w (H j '' s) = (w j : ℝ≥0∞) * ν s := by
  classical
  simp only [weightedMixture, Measure.finsetSum_apply, Measure.smul_apply, smul_eq_mul]
  simp_rw [component_image_measure ν H hH hdisj _ j s hs]
  simp

theorem no_weighted_preserving_selector [MeasurableEq β]
    (ν : Measure α) [IsProbabilityMeasure ν] (H : ι → α → β)
    (w : ι → ℝ≥0) (i₀ : ι)
    (hH : ∀ i, MeasurableEmbedding (H i))
    (hdisj : ∀ i j, i ≠ j → Disjoint (range (H i)) (range (H j)))
    (hw : ∀ i, i ≠ i₀ → w i < w i₀)
    (T : β → β) (hT : Measurable T)
    (hpres : Measure.map T (weightedMixture ν H w) = weightedMixture ν H w)
    (hselect : ∀ᵐ x ∂ν, ∃ i, i ≠ i₀ ∧ T (H i₀ x) = H i x) : False := by
  classical
  let S : ι → Set α := fun i => {x | i ≠ i₀ ∧ T (H i₀ x) = H i x}
  have hSm : ∀ i, MeasurableSet (S i) := by
    intro i
    by_cases hi : i = i₀
    · simp [S, hi]
    · simpa [S, hi, Function.comp_def] using
        measurableSet_eq_fun (hT.comp (hH i₀).measurable) (hH i).measurable
  have hnull : ∀ i, ν (S i) = 0 := by
    intro i
    by_cases hi : i = i₀
    · simp [S, hi]
    · have hsub : H i₀ '' S i ⊆ T ⁻¹' (H i '' S i) := by
        rintro _ ⟨x, hx, rfl⟩
        exact ⟨x, hx, hx.2.symm⟩
      have him : MeasurableSet (H i '' S i) := (hH i).measurableSet_image.mpr (hSm i)
      have hpre :
          weightedMixture ν H w (T ⁻¹' (H i '' S i)) =
            weightedMixture ν H w (H i '' S i) := by
        rw [← Measure.map_apply hT him, hpres]
      have hle : (w i₀ : ℝ≥0∞) * ν (S i) ≤ (w i : ℝ≥0∞) * ν (S i) := by
        calc
          _ = weightedMixture ν H w (H i₀ '' S i) :=
            (mixture_image_measure ν H w hH hdisj i₀ (S i) (hSm i)).symm
          _ ≤ weightedMixture ν H w (T ⁻¹' (H i '' S i)) := measure_mono hsub
          _ = weightedMixture ν H w (H i '' S i) := hpre
          _ = _ := mixture_image_measure ν H w hH hdisj i (S i) (hSm i)
      have hfin : (w i : ℝ≥0∞) * ν (S i) ≠ ∞ := by finiteness
      have hre := ENNReal.toReal_mono hfin hle
      simp only [ENNReal.toReal_mul, ENNReal.coe_toReal] at hre
      have hwi : (w i : ℝ) < (w i₀ : ℝ) := by exact_mod_cast hw i hi
      have hz : (ν (S i)).toReal = 0 := by
        by_contra hn
        have hp : 0 < (ν (S i)).toReal :=
          lt_of_le_of_ne ENNReal.toReal_nonneg (Ne.symm hn)
        exact (not_lt_of_ge hre) (mul_lt_mul_of_pos_right hwi hp)
      rcases (ENNReal.toReal_eq_zero_iff _).mp hz with hz | ht
      · exact hz
      · exact (measure_ne_top ν (S i) ht).elim
  have hunion : ν (⋃ i, S i) = 0 := measure_iUnion_null hnull
  have hcover : ∀ᵐ x ∂ν, x ∈ ⋃ i, S i := by
    filter_upwards [hselect] with x hx
    rcases hx with ⟨i, hi, heq⟩
    exact mem_iUnion.mpr ⟨i, hi, heq⟩
  have hcompl : ν ((⋃ i, S i)ᶜ) = 0 := ae_iff.mp hcover
  have htotal := measure_union_le (⋃ i, S i) ((⋃ i, S i)ᶜ) (μ := ν)
  simp only [union_compl_self, hunion, hcompl, zero_add, measure_univ] at htotal
  norm_num at htotal

noncomputable def coulombWeights (i : Fin 5) : ℝ≥0 :=
  if i = 0 then 1 / 3 else 1 / 6

theorem no_coulomb_preserving_selector [MeasurableEq β]
    (ν : Measure α) [IsProbabilityMeasure ν] (H : Fin 5 → α → β)
    (hH : ∀ i, MeasurableEmbedding (H i))
    (hdisj : ∀ i j, i ≠ j → Disjoint (range (H i)) (range (H j)))
    (T : β → β) (hT : Measurable T)
    (hselect : ∀ᵐ x ∂ν, ∃ i : Fin 5, i ≠ 0 ∧ T (H 0 x) = H i x) :
    Measure.map T (weightedMixture ν H coulombWeights) ≠
      weightedMixture ν H coulombWeights := by
  intro hpres
  apply no_weighted_preserving_selector ν H coulombWeights 0 hH hdisj ?_ T hT hpres hselect
  intro i hi
  norm_num [coulombWeights, hi]

end CoulombContact
