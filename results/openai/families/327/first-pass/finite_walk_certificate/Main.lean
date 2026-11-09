import OAI.Analysis.MarkovType.FiniteWalk

set_option autoImplicit false

namespace Campaign9000327

open OAI.MarkovSuperreflexivity
open scoped BigOperators

noncomputable section

def AllConditions {N : OrderedNorm} {n : ℕ} (W : FiniteWalkWitness N n) : Prop :=
  letI := W.stateFintype
  letI := W.edgeFintype
  (∀ t, ∑ s, W.chain.π s * markedTransition W.chain s t = W.chain.π t) ∧
  (∑ ω : MarkedPath W.State W.Edge n, markedPathWeight W.chain n ω = 1) ∧
  (∀ e, W.label (W.chain.rev e) = -W.label e) ∧
  (∀ e k, W.coordinateBound ≤ k → W.label e k = 0) ∧
  (∀ e, N (W.label e) = 1) ∧
  (3 : ℝ) / 20 ≤ markedProb W.chain n
    (fun ω => (n : ℝ) / 24 ≤ N (edgeSum W.label ω))

theorem prop_walks (N : OrderedNorm) (n : ℕ) (hn : 0 < n) :
    ∃ W : FiniteWalkWitness N n, AllConditions W := by
  obtain ⟨W⟩ := finiteWalk N n hn
  refine ⟨W, ?_⟩
  letI := W.stateFintype
  letI := W.edgeFintype
  exact ⟨sum_π_mul_P W.chain.toStateChain, sum_markedPathWeight W.chain n,
    W.odd, W.support_bound, W.unit, W.escape⟩

#print axioms prop_walks
#print axioms OAI.MarkovSuperreflexivity.finiteWalk

end

end Campaign9000327
