import research.certificates.hypergraph_influence.Constants

example : ∀ r : ℕ, 3 ≤ r →
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, r ≤ n →
      (1 / 4 : ℝ) ≤ C / (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) ∨
      ∃ m : ℕ, r + 1 ≤ m ∧ m ≤ n ∧
        ∀ σ : ℝ, 0 < σ → σ ≤ 1 / 2 →
          let k := σ * Real.log (m : ℝ) / 64
          let L := (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))
          0 < k ∧ 0 < L ∧
            (r : ℝ) * L * ((m : ℝ) - 1) / ((n : ℝ) - 1) ≤ 1 / 2 ∧
            2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) + σ ^ 2 / L ≤
              C / (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) :=
  HypergraphInfluence.uniform_numerical_parameters

#check HypergraphInfluence.uniform_numerical_parameters
#print axioms HypergraphInfluence.uniform_numerical_parameters
