import OAI.Analysis.MarkovType.MarkovObstruction
import OAI.Analysis.MarkovType.OrderedNormStructural
import OAI.Analysis.MarkovType.OddEdgeTransfer

set_option autoImplicit false

namespace Campaign9000327.MainTheorem

open OAI.MarkovSuperreflexivity
open scoped BigOperators

noncomputable section

variable {X V : Type*}
variable [NormedAddCommGroup X] [NormedSpace ℝ X]
variable [NormedAddCommGroup V] [NormedSpace ℝ V]

theorem ordered_norm_construction (hnot : ¬ HasEquivalentUCNorm X) :
    ∃ N : OrderedNorm,
      (∀ x, N x = 0 → x = 0) ∧
      (∀ (m : ℕ) (ι : Fin m → ℕ), StrictMono ι →
        ∀ a, N (C00.place ι a) = N (C00.ofArray a)) ∧
      (∀ i x, N (C00.mergeAt i x) ≤ N x) ∧
      CoordinatesRepresentable X N := by
  obtain ⟨N, hN⟩ := orderedNorm_of_not_hasEquivalentUCNorm hnot
  exact ⟨N, N.definite, fun _ ι hι a => N.spreading ι hι a, N.merge_le, hN⟩

theorem finite_representation_transfer {p K : ℝ}
    (hX : MarkovTypeWith p K X) (hVX : FinitelyRepresentable V X) :
    MarkovTypeWith p K V :=
  hX.of_finitelyRepresentable hVX

theorem odd_edge_transfer {S E : Type*} [Fintype S] [Fintype E]
    {p K : ℝ} (hV : MarkovTypeWith p K V)
    (C : FiniteMarkedChain S E) (g : E → V) (hg : OddLabel C g)
    (n : ℕ) (hn : 1 ≤ n) :
    markedSumCost C g p n ≤ K ^ p * (n : ℝ) * stationaryEdgeCost C g p :=
  hV.odd_edge_bound C g hg n hn

theorem odd_edge_transfer_span {S E : Type*} [Fintype S] [Fintype E]
    {p K : ℝ} (hX : MarkovTypeWith p K X)
    (C : FiniteMarkedChain S E) (g : E → V) (hg : OddLabel C g)
    (hspan : ∀ η : ℝ, 0 < η →
      ∃ T : (Submodule.span ℝ (Set.range g)) →ₗ[ℝ] X,
        ∀ z, ‖z‖ ≤ ‖T z‖ ∧ ‖T z‖ ≤ (1 + η) * ‖z‖)
    (n : ℕ) (hn : 1 ≤ n) :
    markedSumCost C g p n ≤ K ^ p * (n : ℝ) * stationaryEdgeCost C g p := by
  let g' : E → Submodule.span ℝ (Set.range g) :=
    fun e => ⟨g e, Submodule.subset_span (Set.mem_range_self e)⟩
  have hg' : OddLabel C g' := by
    intro e
    exact Subtype.ext (hg e)
  have h := hX.odd_edge_bound_of_embeddings hspan C g' hg' n hn
  simpa [markedSumCost, markedExpect, stationaryEdgeCost, edgeSum, g'] using h

theorem main_implication [CompleteSpace X] (hX : HasNontrivialMarkovType X) :
    HasEquivalentUCNorm X := by
  obtain ⟨p, hp, K, hK⟩ := hX
  by_contra hnot
  obtain ⟨N, _, _, _, hN⟩ := ordered_norm_construction hnot
  exact hK.not_coordinatesRepresentable hp N hN

theorem main_explicit [CompleteSpace X] (hX : HasNontrivialMarkovType X) :
    ∃ (q : Seminorm ℝ X) (a b : ℝ), 0 < a ∧ 0 < b ∧
      (∀ x, a * ‖x‖ ≤ q x ∧ q x ≤ b * ‖x‖) ∧
      (∀ ε : ℝ, 0 < ε → ε ≤ 2 → ∃ δ : ℝ, 0 < δ ∧
        ∀ x y : X, q x ≤ 1 → q y ≤ 1 → ε ≤ q (x - y) →
          q ((1 / 2 : ℝ) • (x + y)) ≤ 1 - δ) := by
  obtain ⟨N, hN⟩ := main_implication hX
  exact ⟨N.p, N.lower, N.upper, N.lower_pos, N.upper_pos,
    fun x => ⟨N.lower_bound x, N.upper_bound x⟩, hN⟩

theorem zero_space_case [Subsingleton X] : HasEquivalentUCNorm X :=
  hasEquivalentUCNorm_of_subsingleton

#print axioms ordered_norm_construction
#print axioms odd_edge_transfer
#print axioms odd_edge_transfer_span
#print axioms main_implication
#print axioms main_explicit
#print axioms OAI.MarkovSuperreflexivity.exists_nonreflexive_finitelyRepresentable_of_not_hasEquivalentUCNorm

end

end Campaign9000327.MainTheorem
