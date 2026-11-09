import OAI.Combinatorics.SharpThreshold.LowDegree
import OAI.Combinatorics.SharpThreshold.FourierDirichlet
import OAI.Combinatorics.SharpThreshold.FourierRestrictionMass
import research.certificates.hypergraph_capture.Main

open scoped BigOperators Classical
open OAI.Problem313 OAI.Problem313.BiasedFourier

set_option maxHeartbeats 1000000

namespace HypergraphInfluence

noncomputable section

abbrev Edge (n r : ℕ) := {e : Finset (Fin n) // e.card = r}

abbrev Config (n r : ℕ) := Edge n r → Bool

def edgePerm {n r : ℕ} (σ : Equiv.Perm (Fin n)) : Edge n r ≃ Edge n r where
  toFun e := ⟨σ.finsetCongr e.val, by simp [e.property]⟩
  invFun e := ⟨σ.symm.finsetCongr e.val, by simp [e.property]⟩
  left_inv e := Subtype.ext (σ.finsetCongr.left_inv e.val)
  right_inv e := Subtype.ext (σ.finsetCongr.right_inv e.val)

@[simp] theorem edgePerm_val {n r : ℕ} (σ : Equiv.Perm (Fin n)) (e : Edge n r) :
    (edgePerm σ e).val = e.val.map σ.toEmbedding := rfl

def IsInvariant {n r : ℕ} (f : Config n r → Bool) : Prop :=
  ∀ (σ : Equiv.Perm (Fin n)) (x : Config n r),
    f (Reindex.config (edgePerm σ) x) = f x

def totalInfluence {n r : ℕ} (p : ℝ) (f : Config n r → Bool) : ℝ :=
  ∑ e, Reindex.influence p f e

def fourier {n r : ℕ} (p : ℝ) (f : Config n r → Bool)
    (S : Finset (Edge n r)) : ℝ :=
  coeff p (fun x => boolReal (f x)) S

def variance {n r : ℕ} (p : ℝ) (f : Config n r → Bool) : ℝ := by
  letI : DecidableEq (Edge n r) := Classical.decEq _
  exact ∑ x, weight p x * (boolReal (f x) - fourier p f ∅) ^ 2

def lowMass {n r : ℕ} (p : ℝ) (f : Config n r → Bool) (L : ℝ) : ℝ :=
  ∑ S : Finset (Edge n r),
    if S.Nonempty ∧ (S.card : ℝ) ≤ L then fourier p f S ^ 2 else 0

def Touches {n r : ℕ} (B : Finset (Fin n)) (e : Edge n r) : Prop :=
  (e.val ∩ B).Nonempty

def retained {n r : ℕ} (B : Finset (Fin n)) (S : Finset (Edge n r)) :
    Finset (Edge n r) :=
  S.filter (Touches B)

def captureProbability {n r : ℕ} (m : ℕ) (k : ℝ) (S : Finset (Edge n r)) : ℝ :=
  (((HypergraphCapture.blocks n m).filter fun B =>
    1 ≤ (retained B S).card ∧ ((retained B S).card : ℝ) ≤ k).card : ℝ) /
      (HypergraphCapture.blocks n m).card

def blockMass {n r : ℕ} (p : ℝ) (f : Config n r → Bool) (m : ℕ) (k : ℝ) : ℝ :=
  ∑ S : Finset (Edge n r), captureProbability m k S * fourier p f S ^ 2

theorem totalInfluence_nonneg {n r : ℕ} {p : ℝ}
    (hp : 0 ≤ p) (hp1 : p ≤ 1) (f : Config n r → Bool) :
    0 ≤ totalInfluence p f := by
  unfold totalInfluence
  exact Finset.sum_nonneg fun e _ => Reindex.influence_nonneg hp hp1 f e

theorem variance_eq_mass {n r : ℕ} {p : ℝ}
    (hp : 0 < p) (hp1 : p < 1) (f : Config n r → Bool) :
    variance p f =
      ∑ S ∈ (Finset.univ : Finset (Finset (Edge n r))).erase ∅,
        fourier p f S ^ 2 := by
  classical
  simpa [variance, fourier] using
    (variance_eq_nonempty hp hp1 (fun x => boolReal (f x)))

theorem weighted_mass {n r : ℕ} {p : ℝ}
    (hp : 0 < p) (hp1 : p < 1) (f : Config n r → Bool) :
    (∑ S : Finset (Edge n r), (S.card : ℝ) * fourier p f S ^ 2) =
      p * (1 - p) * totalInfluence p f := by
  simpa [fourier, totalInfluence] using boolean_dirichlet hp hp1 f

end

end HypergraphInfluence
