import HypergraphBlockSupport.Orbit
import HypergraphBlockSupport.RestrictionInfluence
import HypergraphBlockSupport.RestrictionMassSubtype

open scoped BigOperators Classical
open OAI.Problem313 OAI.Problem313.BiasedFourier

set_option maxHeartbeats 1500000

namespace HypergraphInfluence.Block

noncomputable section

theorem pivotal_interfaces {ι : Type*} [Fintype ι] [d : DecidableEq ι]
    (p : ℝ) (f : (ι → Bool) → Bool) (i : ι) :
    RestrictionInfluence.influence p f i = Reindex.influence p f i := by
  cases Subsingleton.elim d (Classical.typeDecidableEq ι)
  rfl

theorem average_pivotal {n r : ℕ} (B : Finset (Fin n)) (p : ℝ)
    (f : Config n r → Bool) (e : {d : Edge n r // Touches B d}) :
    (∑ y : {d : Edge n r // ¬ Touches B d} → Bool,
      weight p y * Reindex.influence p (restrictCube (Touches B) f y) e) =
        Reindex.influence p f e.val := by
  have h := RestrictionInfluence.average_influence (Touches B) p f e
  unfold RestrictionInfluence.join at h
  unfold restrictCube pasteCube
  simpa only [pivotal_interfaces, RestrictionInfluence.weight, weight, scalarWeight] using h

theorem average_total_pivotal {n r : ℕ} (B : Finset (Fin n)) (p : ℝ)
    (f : Config n r → Bool) :
    (∑ y : {d : Edge n r // ¬ Touches B d} → Bool, weight p y *
      ∑ e : {d : Edge n r // Touches B d},
        Reindex.influence p (restrictCube (Touches B) f y) e) =
      ∑ e : Edge n r, if Touches B e then Reindex.influence p f e else 0 := by
  classical
  calc
    _ = ∑ e : {d : Edge n r // Touches B d}, Reindex.influence p f e.val := by
      simp_rw [Finset.mul_sum]
      rw [Finset.sum_comm]
      exact Finset.sum_congr rfl (fun e _ => average_pivotal B p f e)
    _ = _ := by
      simpa only [Finset.sum_filter] using
        (Finset.sum_subtype (Finset.univ.filter (Touches B))
          (by intro e; simp) (Reindex.influence p f)).symm

theorem restriction_fourier_mass {n r : ℕ} (B : Finset (Fin n))
    {p : ℝ} (hp : 0 < p) (hp1 : p < 1) (f : Config n r → Bool) (k : ℝ) :
    (∑ S : Finset (Edge n r),
      if 1 ≤ (retained B S).card ∧ ((retained B S).card : ℝ) ≤ k
      then fourier p f S ^ 2 else 0) =
    ∑ y : {d : Edge n r // ¬ Touches B d} → Bool, weight p y *
      ∑ A : Finset {d : Edge n r // Touches B d},
        if A.Nonempty ∧ (A.card : ℝ) ≤ k
        then coeff p (fun x => boolReal (restrictCube (Touches B) f y x)) A ^ 2
        else 0 := by
  have h := restriction_low_degree_mass_subtype (Touches B) hp hp1
    (fun x => boolReal (f x)) k
  unfold restrictCube at h ⊢
  simpa only [retained, Finset.one_le_card, fourier] using h

theorem single_block {n r m : ℕ} (B : Finset (Fin n)) (hB : B.card = m)
    (hrm : r < m) (hm : 1 ≤ m)
    {p : ℝ} (hp : 0 < p) (hp1 : p < 1)
    (f : Config n r → Bool) (hf : IsInvariant f) :
    (∑ S : Finset (Edge n r),
      if 1 ≤ (retained B S).card ∧ ((retained B S).card : ℝ) ≤
          Real.sqrt (p * (1 - p)) * Real.log (m : ℝ) / 64
      then fourier p f S ^ 2 else 0) ≤
      (m : ℝ) ^ (-1 / 4 : ℝ) *
        ∑ e : Edge n r, if Touches B e then Reindex.influence p f e else 0 := by
  classical
  rw [restriction_fourier_mass B hp hp1]
  calc
    _ ≤ ∑ y : {d : Edge n r // ¬ Touches B d} → Bool, weight p y *
        ((m : ℝ) ^ (-1 / 4 : ℝ) *
          ∑ e : {d : Edge n r // Touches B d},
            Reindex.influence p (restrictCube (Touches B) f y) e) := by
      apply Finset.sum_le_sum
      intro y hy
      apply mul_le_mul_of_nonneg_left _ (weight_nonneg hp.le hp1.le y)
      apply low_degree_estimate hp hp1 (restrictCube (Touches B) f y) (m : ℝ)
        (by exact_mod_cast hm)
      intro e
      simpa only [hB] using
        restricted_influence_le B (by omega) hp.le hp1.le f hf y e
    _ = (m : ℝ) ^ (-1 / 4 : ℝ) *
        (∑ y : {d : Edge n r // ¬ Touches B d} → Bool, weight p y *
          ∑ e : {d : Edge n r // Touches B d},
            Reindex.influence p (restrictCube (Touches B) f y) e) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro y hy
      ring
    _ = _ := by rw [average_total_pivotal]

end

end HypergraphInfluence.Block
