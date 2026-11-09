import research.certificates.hypergraph_influence.Block

open HypergraphInfluence

example {n r m : ℕ} (hr : 3 ≤ r) (hrm : r + 1 ≤ m) (hmn : m ≤ n)
    {p : ℝ} (hp : 0 < p) (hp1 : p < 1)
    (f : Config n r → Bool) (hf : IsInvariant f) :
    blockMass p f m (Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64) ≤
      (m : ℝ) ^ (-1 / 4 : ℝ) * ((r : ℝ) * m / n) * totalInfluence p f :=
  averaged_block hr hrm hmn hp hp1 f hf

#check HypergraphInfluence.averaged_block
#print axioms HypergraphInfluence.Block.le_choose_of_one_le_lt
#print axioms HypergraphInfluence.Block.orbitFamily_card
#print axioms HypergraphInfluence.Block.blockPerm_fixes_exterior
#print axioms HypergraphInfluence.Block.restricted_influence_eq_of_exterior_eq
#print axioms HypergraphInfluence.Block.restricted_influence_le
#print axioms HypergraphInfluence.Block.average_pivotal
#print axioms HypergraphInfluence.Block.average_total_pivotal
#print axioms HypergraphInfluence.Block.restriction_fourier_mass
#print axioms HypergraphInfluence.Block.single_block
#print axioms HypergraphInfluence.Block.mass_eq_average
#print axioms HypergraphInfluence.Block.edge_touch_probability
#print axioms HypergraphInfluence.averaged_block
