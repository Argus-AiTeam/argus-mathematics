import research.certificates.hypergraph_influence.Transfer
import research.certificates.hypergraph_influence.Constants

open scoped BigOperators Classical
open OAI.Problem313 OAI.Problem313.BiasedFourier

set_option maxHeartbeats 1500000

namespace HypergraphInfluence

noncomputable section

theorem uniform_influence (r : ℕ) (hr : 3 ≤ r) :
    ∃ C : ℝ, 0 < C ∧
      ∀ (n : ℕ), r ≤ n → ∀ (p : ℝ), 0 < p → p < 1 →
        ∀ (f : Config n r → Bool), IsInvariant f →
          variance p f ≤ C * totalInfluence p f /
            (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) := by
  obtain ⟨C, hC, hparameters⟩ := uniform_numerical_parameters r hr
  refine ⟨C, hC, ?_⟩
  intro n hrn p hp hp1 f hf
  have hI : 0 ≤ totalInfluence p f := totalInfluence_nonneg hp.le hp1.le f
  let σ := Real.sqrt (p * (1 - p))
  have hpp : 0 < p * (1 - p) := mul_pos hp (sub_pos.mpr hp1)
  have hσ : 0 < σ := Real.sqrt_pos.mpr hpp
  have hσsq : σ ^ 2 = p * (1 - p) := Real.sq_sqrt hpp.le
  have hpquarter : p * (1 - p) ≤ 1 / 4 := by
    nlinarith [sq_nonneg (p - 1 / 2)]
  have hσhalf : σ ≤ 1 / 2 := by nlinarith [hpquarter, hσsq]
  rcases hparameters n hrn with hsmall | ⟨m, hrm, hmn, hm⟩
  · calc
      variance p f ≤ p * (1 - p) * totalInfluence p f :=
        variance_le_dirichlet hp hp1 f
      _ ≤ (1 / 4 : ℝ) * totalInfluence p f :=
        mul_le_mul_of_nonneg_right hpquarter hI
      _ ≤ (C / (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))) *
          totalInfluence p f := mul_le_mul_of_nonneg_right hsmall hI
      _ = C * totalInfluence p f /
          (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) := by ring
  · obtain ⟨hk, hL, hcapture, hbound⟩ := hm σ hσ hσhalf
    let k := σ * Real.log (m : ℝ) / 64
    let L := (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))
    have hlow : lowMass p f L ≤
        2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) * totalInfluence p f :=
      captured_mass hr hrm hmn hp hp1 f hf hk hcapture
    have htail : variance p f ≤ lowMass p f L +
        σ ^ 2 / L * totalInfluence p f := by
      rw [hσsq]
      exact variance_le_low_add_tail hp hp1 f hL
    calc
      variance p f ≤ lowMass p f L + σ ^ 2 / L * totalInfluence p f := htail
      _ ≤ (2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) + σ ^ 2 / L) *
          totalInfluence p f := by nlinarith [hlow]
      _ ≤ (C / (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))) *
          totalInfluence p f := mul_le_mul_of_nonneg_right hbound hI
      _ = C * totalInfluence p f /
          (Real.log (n : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) := by ring

#check @uniform_influence
#print axioms uniform_influence
#print axioms averaged_block
#print axioms captured_mass
#print axioms variance_le_low_add_tail
#print axioms empty_low_range
#print axioms uniform_numerical_parameters
#print axioms OAI.Problem313.BiasedFourier.low_degree_estimate
#print axioms OAI.Problem313.BiasedFourier.boolean_dirichlet
#print axioms OAI.Problem313.BiasedFourier.restricted_low_degree_mass_average
#print axioms HypergraphCapture.hypergraph_capture

end

end HypergraphInfluence
