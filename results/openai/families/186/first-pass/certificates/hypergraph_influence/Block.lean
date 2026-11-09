import HypergraphBlockSupport.Restriction
import HypergraphBlockSupport.BlockAverage
import HypergraphBlockSupport.BlockCounting

open scoped BigOperators Classical
open OAI.Problem313 OAI.Problem313.BiasedFourier

set_option maxHeartbeats 1500000

namespace HypergraphInfluence

noncomputable section

namespace Block

theorem mass_eq_average {n r : ℕ} (p : ℝ) (f : Config n r → Bool)
    (m : ℕ) (k : ℝ) :
    blockMass p f m k =
      ∑ B : HypergraphCapture.blocks n m,
        ((1 : ℝ) / (HypergraphCapture.blocks n m).card) *
          ∑ S : Finset (Edge n r),
            if 1 ≤ (retained B.val S).card ∧ ((retained B.val S).card : ℝ) ≤ k
            then fourier p f S ^ 2 else 0 := by
  classical
  symm
  calc
    _ = ∑ S : Finset (Edge n r),
        (∑ B : HypergraphCapture.blocks n m,
          if 1 ≤ (retained B.val S).card ∧ ((retained B.val S).card : ℝ) ≤ k
          then (1 : ℝ) / (HypergraphCapture.blocks n m).card else 0) *
          fourier p f S ^ 2 :=
      BlockAverage.weighted_incidence_sum _ _ _
    _ = blockMass p f m k := by
      unfold blockMass
      apply Finset.sum_congr rfl
      intro S hS
      rw [BlockAverage.uniform_incidence_sum (HypergraphCapture.blocks n m)
        (fun B => 1 ≤ (retained B S).card ∧ ((retained B S).card : ℝ) ≤ k)]
      rfl

theorem edge_touch_probability {n r m : ℕ} (hm : 1 ≤ m) (hmn : m ≤ n)
    (e : Edge n r) :
    (∑ B : HypergraphCapture.blocks n m,
      if Touches B.val e then (1 : ℝ) / (HypergraphCapture.blocks n m).card else 0) ≤
      (r : ℝ) * m / n := by
  classical
  rw [BlockAverage.uniform_incidence_sum (HypergraphCapture.blocks n m)
    (fun B => Touches B e)]
  change blockProbability (Finset.univ : Finset (Fin n)) m (fun B => Touches B e) ≤ _
  simpa only [Touches, Finset.inter_comm, e.property, Finset.card_univ, Fintype.card_fin]
    using blockProbability_inter_nonempty_le (Finset.univ : Finset (Fin n)) e.val
      (Finset.subset_univ _) hm (by simpa using hmn)

end Block

theorem averaged_block {n r m : ℕ} (hr : 3 ≤ r) (hrm : r + 1 ≤ m)
    (hmn : m ≤ n) {p : ℝ} (hp : 0 < p) (hp1 : p < 1)
    (f : Config n r → Bool) (hf : IsInvariant f) :
    blockMass p f m (Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64) ≤
      (m : ℝ) ^ (-1 / 4 : ℝ) * ((r : ℝ) * m / n) * totalInfluence p f := by
  classical
  have hm : 1 ≤ m := by omega
  rw [Block.mass_eq_average]
  apply BlockAverage.block_upper_bound
    (fun _ : HypergraphCapture.blocks n m =>
      (1 : ℝ) / (HypergraphCapture.blocks n m).card)
    (fun S : Finset (Edge n r) => fourier p f S ^ 2)
    (Reindex.influence p f)
    (fun B S => 1 ≤ (retained B.val S).card ∧ ((retained B.val S).card : ℝ) ≤
      Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64)
    (fun B e => Touches B.val e)
    ((m : ℝ) ^ (-1 / 4 : ℝ)) ((r : ℝ) * m / n)
  · intro B
    positivity
  · intro e
    exact Reindex.influence_nonneg hp.le hp1.le f e
  · exact Real.rpow_nonneg (Nat.cast_nonneg _) _
  · intro B
    have hB : B.val.card = m := (Finset.mem_powersetCard.mp B.property).2
    exact Block.single_block B.val hB (by omega) hm hp hp1 f hf
  · exact Block.edge_touch_probability hm hmn

end

end HypergraphInfluence

#print axioms HypergraphInfluence.averaged_block
