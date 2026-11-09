import research.certificates.hypergraph_influence.Block

open scoped BigOperators Classical
open OAI.Problem313 OAI.Problem313.BiasedFourier

set_option maxHeartbeats 1500000

namespace HypergraphInfluence

noncomputable section

def forgetEdge {n r : ℕ} : Edge n r ↪ Finset (Fin n) :=
  ⟨Subtype.val, fun _ _ h => Subtype.ext h⟩

def support {n r : ℕ} (S : Finset (Edge n r)) : Finset (Finset (Fin n)) :=
  S.map forgetEdge

@[simp] theorem support_card {n r : ℕ} (S : Finset (Edge n r)) :
    (support S).card = S.card := Finset.card_map _

theorem support_captured {n r : ℕ} (S : Finset (Edge n r))
    (B : Finset (Fin n)) :
    HypergraphCapture.captured (support S) B = support (retained B S) := by
  simp [HypergraphCapture.captured, support, retained, Touches, Finset.filter_map,
    forgetEdge]

theorem capture_probability_nonneg {n r : ℕ} (m : ℕ) (k : ℝ)
    (S : Finset (Edge n r)) : 0 ≤ captureProbability m k S :=
  div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)

theorem capture_probability_lower {n r m : ℕ} {k : ℝ}
    (hr : 3 ≤ r) (hrn : r ≤ n) (hm : 1 ≤ m) (hmn : m ≤ n)
    (hk : 0 < k) (S : Finset (Edge n r)) (hne : S.Nonempty)
    (hsl : (S.card : ℝ) ≤ (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)))
    (hc : (r : ℝ) * (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) *
      ((m : ℝ) - 1) / ((n : ℝ) - 1) ≤ 1 / 2) :
    (m : ℝ) / (2 * n) ≤ captureProbability m k S := by
  have hne' : (support S).Nonempty := Finset.map_nonempty.mpr hne
  have hunif : ∀ e ∈ support S, e.card = r := by
    intro e he
    obtain ⟨a, _, rfl⟩ := Finset.mem_map.mp he
    exact a.property
  have hsl' : ((support S).card : ℝ) ≤
      (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1)) := by
    simpa using hsl
  have h := HypergraphCapture.hypergraph_capture
    hr hrn hm hmn hk (support S) hne' hunif hsl' hc
  have hcap (B : Finset (Fin n)) :
      (HypergraphCapture.captured (support S) B).card = (retained B S).card := by
    rw [support_captured, support_card]
  simpa only [HypergraphCapture.goodBlocks, hcap, captureProbability] using h

theorem captured_mass {n r m : ℕ} {p : ℝ}
    (hr : 3 ≤ r) (hrm : r + 1 ≤ m) (hmn : m ≤ n)
    (hp : 0 < p) (hp1 : p < 1) (f : Config n r → Bool) (hf : IsInvariant f)
    (hk : 0 < Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64)
    (hc : (r : ℝ) *
      ((Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64) / (r : ℝ)) ^
        ((r : ℝ) / ((r : ℝ) - 1)) *
      ((m : ℝ) - 1) / ((n : ℝ) - 1) ≤ 1 / 2) :
    lowMass p f
      (((Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64) / (r : ℝ)) ^
        ((r : ℝ) / ((r : ℝ) - 1))) ≤
      2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) * totalInfluence p f := by
  let k := Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64
  let L := (k / (r : ℝ)) ^ ((r : ℝ) / ((r : ℝ) - 1))
  have hm : 1 ≤ m := by omega
  have hrn : r ≤ n := by omega
  have hm0 : (0 : ℝ) < m := by exact_mod_cast (show 0 < m by omega)
  have hn0 : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
  have hfactor : 0 < (m : ℝ) / (2 * n) := by positivity
  have htransfer : (m : ℝ) / (2 * n) * lowMass p f L ≤ blockMass p f m k := by
    unfold lowMass blockMass
    rw [Finset.mul_sum]
    apply Finset.sum_le_sum
    intro S _
    by_cases hS : S.Nonempty ∧ (S.card : ℝ) ≤ L
    · rw [if_pos hS]
      exact mul_le_mul_of_nonneg_right
        (capture_probability_lower hr hrn hm hmn hk S hS.1 hS.2 hc) (sq_nonneg _)
    · rw [if_neg hS, mul_zero]
      exact mul_nonneg (capture_probability_nonneg m k S) (sq_nonneg _)
  have hscaled : (m : ℝ) / (2 * n) * lowMass p f L ≤
      (m : ℝ) / (2 * n) *
        (2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) * totalInfluence p f) := by
    calc
      (m : ℝ) / (2 * n) * lowMass p f L ≤ blockMass p f m k := htransfer
      _ ≤ (m : ℝ) ^ (-1 / 4 : ℝ) * ((r : ℝ) * m / n) * totalInfluence p f :=
        averaged_block hr hrm hmn hp hp1 f hf
      _ = (m : ℝ) / (2 * n) *
          (2 * (r : ℝ) * (m : ℝ) ^ (-1 / 4 : ℝ) * totalInfluence p f) := by
        field_simp
  nlinarith [hscaled]

theorem variance_eq_indicator_mass {n r : ℕ} {p : ℝ}
    (hp : 0 < p) (hp1 : p < 1) (f : Config n r → Bool) :
    variance p f = ∑ S : Finset (Edge n r),
      if S.Nonempty then fourier p f S ^ 2 else 0 := by
  rw [variance_eq_mass hp hp1 f]
  have hfilter : (Finset.univ : Finset (Finset (Edge n r))).filter
      (fun S => S.Nonempty) = Finset.univ.erase ∅ := by
    ext S
    simp [Finset.nonempty_iff_ne_empty]
  rw [← hfilter, Finset.sum_filter]

theorem variance_le_low_add_tail {n r : ℕ} {p L : ℝ}
    (hp : 0 < p) (hp1 : p < 1) (f : Config n r → Bool) (hL : 0 < L) :
    variance p f ≤ lowMass p f L +
      p * (1 - p) / L * totalInfluence p f := by
  rw [variance_eq_indicator_mass hp hp1 f]
  calc
    (∑ S : Finset (Edge n r), if S.Nonempty then fourier p f S ^ 2 else 0) ≤
        ∑ S : Finset (Edge n r),
          ((if S.Nonempty ∧ (S.card : ℝ) ≤ L then fourier p f S ^ 2 else 0) +
            (S.card : ℝ) * fourier p f S ^ 2 / L) := by
      apply Finset.sum_le_sum
      intro S _
      by_cases hne : S.Nonempty
      · rw [if_pos hne]
        by_cases hcard : (S.card : ℝ) ≤ L
        · rw [if_pos ⟨hne, hcard⟩]
          exact le_add_of_nonneg_right (by positivity)
        · rw [if_neg (by simp [hcard]), zero_add]
          apply (le_div_iff₀ hL).mpr
          nlinarith [mul_le_mul_of_nonneg_right (le_of_not_ge hcard)
            (sq_nonneg (fourier p f S))]
      · simp only [hne, false_and, if_false]
        positivity
    _ = lowMass p f L +
        (∑ S : Finset (Edge n r), (S.card : ℝ) * fourier p f S ^ 2) / L := by
      simp [lowMass, Finset.sum_add_distrib, Finset.sum_div]
    _ = lowMass p f L + p * (1 - p) / L * totalInfluence p f := by
      rw [weighted_mass hp hp1 f]
      ring

theorem variance_le_dirichlet {n r : ℕ} {p : ℝ}
    (hp : 0 < p) (hp1 : p < 1) (f : Config n r → Bool) :
    variance p f ≤ p * (1 - p) * totalInfluence p f := by
  rw [variance_eq_indicator_mass hp hp1 f, ← weighted_mass hp hp1 f]
  apply Finset.sum_le_sum
  intro S _
  by_cases hne : S.Nonempty
  · rw [if_pos hne]
    have hcard : (1 : ℝ) ≤ S.card := by
      exact_mod_cast (Finset.card_pos.mpr hne)
    nlinarith [mul_le_mul_of_nonneg_right hcard (sq_nonneg (fourier p f S))]
  · rw [if_neg hne]
    positivity

theorem empty_low_range {n r : ℕ} {p L : ℝ} (f : Config n r → Bool)
    (hL : L < 1) : lowMass p f L = 0 := by
  unfold lowMass
  apply Finset.sum_eq_zero
  intro S _
  apply if_neg
  intro hS
  have hcard : (1 : ℝ) ≤ S.card := by exact_mod_cast Finset.card_pos.mpr hS.1
  linarith [hS.2]

#print axioms captured_mass
#print axioms variance_le_low_add_tail

end

end HypergraphInfluence
