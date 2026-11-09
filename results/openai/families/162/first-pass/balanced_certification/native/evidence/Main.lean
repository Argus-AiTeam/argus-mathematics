import OAI.Combinatorics.BalancedRyser.Results

theorem balanced_manuscript_statement :
    ∃ q₀ : ℕ, ∀ q : ℕ, q₀ ≤ q → q.Prime →
      ∃ H : OAI.Balanced.PartiteHypergraph (q + 1) (q + 1),
        H.Intersecting ∧ H.Nonisolated ∧ H.HasCoverNumber (q + 1) :=
  OAI.Balanced.main_result

#print axioms balanced_manuscript_statement
#print OAI.Balanced.MainResult
#print OAI.Balanced.BalancedCounterexample
#print OAI.Balanced.PartiteHypergraph.Covers
#print OAI.Balanced.PartiteHypergraph.Intersecting
#print OAI.Balanced.PartiteHypergraph.Nonisolated
#print OAI.Balanced.PartiteHypergraph.HasCoverNumber
