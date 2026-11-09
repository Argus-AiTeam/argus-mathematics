import OAI.Probability.MatroidProphet.Main

set_option autoImplicit false

open MeasureTheory ProbabilityTheory
open OAI OAI.MatroidProphet

namespace FullSeedCertification

noncomputable section

theorem prior_closure_eq_accepted {α : Type*} [DecidableEq α]
    (M : Matroid α) (hE : M.E = Set.univ) (E : Finset α)
    (base : ℤ → Set α) (layer : α → ℤ) (time : α → ℕ) (b : ℤ) (k : ℕ) :
    M.closure (base b ∪ layerPrior E layer time b k) =
      M.closure (base b ∪
        {e | e ∈ layerGreedy M E base layer time ∧ layer e = b ∧ time e < k}) := by
  apply Set.Subset.antisymm
  · apply M.closure_subset_closure_of_subset_closure
    rintro e (he | ⟨he, heb, het⟩)
    · exact M.mem_closure_of_mem' (Or.inl he) (by simp [hE])
    · have hs := layerGreedy_spans_prefix M E base layer time hE e he
      apply M.closure_subset_closure _ hs
      rintro f (hf | ⟨hf, hfb, hft⟩)
      · exact Or.inl (by simpa [heb] using hf)
      · exact Or.inr ⟨hf, hfb.trans heb, lt_of_le_of_lt hft het⟩
  · apply M.closure_subset_closure
    rintro e (he | ⟨he, heb, het⟩)
    · exact Or.inl he
    · exact Or.inr ⟨layerGreedy_subset M E base layer time he, heb, het⟩

theorem singleton_rank_one_iff {α : Type*} [Fintype α]
    (M : Matroid α) (hE : M.E = Set.univ) (X : Set α) (e : α) :
    conditionalRank M {e} X = 1 ↔ e ∉ M.closure X := by
  unfold conditionalRank
  rw [Set.singleton_union]
  by_cases he : e ∈ M.closure X
  · have hr : natRank M (insert e X) = natRank M X := by
      calc
        natRank M (insert e X) = natRank M (M.closure (insert e X)) :=
          (natRank_closure M _).symm
        _ = natRank M (M.closure X) := by
          rw [M.closure_insert_eq_of_mem_closure he]
        _ = natRank M X := natRank_closure M X
    simp [hr, he]
  · have hr := M.eRk_insert_eq_add_one (X := X) (e := e)
      (show e ∈ M.E \ M.closure X from ⟨by simp [hE], he⟩)
    have hn : natRank M (insert e X) = natRank M X + 1 := by
      unfold natRank
      rw [hr, ENat.toNat_add (rank_ne_top M X) (by simp)]
      simp
    simp [hn, he]

theorem manuscript_greedy_decision_iff {α : Type*} [Fintype α] [DecidableEq α]
    (M : Matroid α) (hE : M.E = Set.univ) (E : Finset α)
    (base : ℤ → Set α) (layer : α → ℤ) (time : α → ℕ) (e : α) :
    e ∈ layerGreedy M E base layer time ↔
      e ∈ E ∧ conditionalRank M {e}
        (base (layer e) ∪
          {f | f ∈ layerGreedy M E base layer time ∧
            layer f = layer e ∧ time f < time e}) = 1 := by
  classical
  conv_lhs => simp only [layerGreedy, Finset.mem_filter]
  rw [prior_closure_eq_accepted M hE E base layer time (layer e) (time e)]
  rw [singleton_rank_one_iff M hE]

theorem exists_full_seed_minimizer {n bits : ℕ} (A : HiddenRule n bits)
    (w : Weights n) :
    ∃ π : Seed bits → ArrivalOrder n,
      ∀ r, hiddenReward A r w (π r) = hiddenWorstReward A w r := by
  classical
  have h (r : Seed bits) :
      ∃ p : ArrivalOrder n, hiddenReward A r w p = hiddenWorstReward A w r := by
    obtain ⟨p, _, hp⟩ := Finset.exists_min_image
      (Finset.univ : Finset (ArrivalOrder n)) (hiddenReward A r w)
      Finset.univ_nonempty
    refine ⟨p, le_antisymm ?_ (hiddenWorstReward_le A w r p)⟩
    apply Finset.le_inf'
    exact hp
  choose π hπ using h
  exact ⟨π, hπ⟩

theorem expected_minimum_iff_full_seed_orders {n bits : ℕ} (A : HiddenRule n bits)
    (w : Weights n) (ν : Measure (Seed bits)) [IsProbabilityMeasure ν] (c : ℝ) :
    c ≤ (∫ r, hiddenWorstReward A w r ∂ν) ↔
      ∀ π : Seed bits → ArrivalOrder n,
        c ≤ ∫ r, hiddenReward A r w (π r) ∂ν := by
  constructor
  · intro h π
    exact h.trans (integral_mono Integrable.of_finite Integrable.of_finite
      (fun r => hiddenWorstReward_le A w r (π r)))
  · intro h
    obtain ⟨π, hπ⟩ := exists_full_seed_minimizer A w
    simpa only [hπ] using h π

theorem concrete_mask {n : ℕ} (M : Matroid (Fin n)) (hE : M.E = Set.univ)
    (r : Seed (mainSeedBits n)) :
    (completeHiddenRule M hE).mask r =
      if mainBranch r then
        (mainMasks r).H ∪ (mainMasks r).D ∪ (mainMasks r).C
      else (mainMasks r).H := rfl

theorem concrete_fixed_vector {n : ℕ} (M : Matroid (Fin n))
    (hE : M.E = Set.univ) (w : Weights n) (hw : ∀ e, 0 ≤ w e) :
    (∀ (r : Seed (mainSeedBits n)) (π : ArrivalOrder n) (t : ℕ),
      M.Indep (hiddenAcceptedThrough (completeHiddenRule M hE) r w π t :
        Set (Fin n))) ∧
    ((2 : ℝ) ^ 293)⁻¹ * optimum M w ≤
      ∫ r, hiddenWorstReward (completeHiddenRule M hE) w r ∂sourceSeedLaw n :=
  ⟨completeHiddenRule_feasible M hE w hw, complete_hidden_guarantee M hE w hw⟩

theorem seed_dependent_orders {n : ℕ} (M : Matroid (Fin n))
    (hE : M.E = Set.univ) (w : Weights n) (hw : ∀ e, 0 ≤ w e)
    (π : Seed (mainSeedBits n) → ArrivalOrder n) :
    ((2 : ℝ) ^ 293)⁻¹ * optimum M w ≤
      ∫ r, hiddenReward (completeHiddenRule M hE) r w (π r) ∂sourceSeedLaw n := by
  apply (complete_hidden_guarantee M hE w hw).trans
  exact integral_mono Integrable.of_finite Integrable.of_finite
    (fun r => hiddenWorstReward_le (completeHiddenRule M hE) w r (π r))

theorem concrete_one_sample.{u} {n : ℕ} (M : Matroid (Fin n))
    (hE : M.E = Set.univ)
    {Ω : Type u} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (S V : Ω → Weights n) (R : Ω → Seed (mainSeedBits n))
    (hS : Measurable S) (hV : Measurable V) (hR : Measurable R)
    (hSN : ∀ᵐ ω ∂μ, ∀ e, 0 ≤ S ω e)
    (hVN : ∀ᵐ ω ∂μ, ∀ e, 0 ≤ V ω e)
    (hi : iIndepFun (pairedCoordinates S V) μ)
    (hlaw : ∀ e, μ.map (fun ω => S ω e) = μ.map (fun ω => V ω e))
    (hseed : IndepFun (fun ω => (S ω, V ω)) R μ)
    (hRlaw : μ.map R = sourceSeedLaw n)
    (hopt : Integrable (fun ω => optimum M (V ω)) μ)
    (π : Ω → ArrivalOrder n) (hπ : Measurable π) :
    Integrable (fun ω => reward (sampleSimulation (completeHiddenRule M hE))
      (R ω) (S ω) (V ω) (π ω)) μ ∧
    ((2 : ℝ) ^ 293)⁻¹ * (∫ ω, optimum M (V ω) ∂μ) ≤
      ∫ ω, reward (sampleSimulation (completeHiddenRule M hE))
        (R ω) (S ω) (V ω) (π ω) ∂μ :=
  oneSample_of_hidden M (completeHiddenRule M hE) (sourceSeedLaw n)
    (((2 : ℝ) ^ 293)⁻¹) (completeHiddenRule_feasible M hE)
    (complete_hidden_guarantee M hE) μ S V R hS hV hR hSN hVN hi hlaw
    hseed hRlaw hopt π hπ

theorem public_one_sample.{u} : OneSampleChallenge.{u} := OAI.MatroidProphet.one_sample

#print axioms manuscript_greedy_decision_iff
#print axioms expected_minimum_iff_full_seed_orders
#print axioms concrete_fixed_vector
#print axioms seed_dependent_orders
#print axioms concrete_one_sample
#print axioms public_one_sample

end

end FullSeedCertification
