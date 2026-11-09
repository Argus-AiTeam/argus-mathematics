import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Tactic.Ring

/-!
# Bounded terminal-order kernel algebra

Finite weighted bin kernels factor through the bin index set. The exact lag-one
twisted equality kernel is skew, vanishes for the identity permutation, and has
an order-sign factorization for involutions.
-/

noncomputable section

namespace TerminalOrderKernel

universe uI uJ uB uL

section Bins

variable {I : Type uI} {J : Type uJ} {B : Type uB}
variable [Fintype I] [Fintype J] [Fintype B] [DecidableEq B]

/-- An arbitrary real bin kernel with independent row and column weights. -/
def weightedBinMatrix (r : I → B) (c : J → B) (w : I → ℝ) (z : J → ℝ)
    (K : Matrix B B ℝ) : Matrix I J ℝ :=
  fun i j => w i * K (r i) (c j) * z j

/-- Weighted incidence matrix from rows to bins. -/
def rowLift (r : I → B) (w : I → ℝ) : Matrix I B ℝ :=
  fun i b => if r i = b then w i else 0

/-- Weighted incidence matrix from bins to columns. -/
def columnLift (c : J → B) (z : J → ℝ) : Matrix B J ℝ :=
  fun b j => if b = c j then z j else 0

omit [Fintype I] [Fintype J] in
theorem weightedBinMatrix_factorization (r : I → B) (c : J → B)
    (w : I → ℝ) (z : J → ℝ) (K : Matrix B B ℝ) :
    weightedBinMatrix r c w z K = rowLift r w * K * columnLift c z := by
  funext i j
  simp [weightedBinMatrix, rowLift, columnLift, Matrix.mul_apply, ite_mul, mul_ite]

omit [Fintype I] in
theorem weightedBinMatrix_rank_le_kernel (r : I → B) (c : J → B)
    (w : I → ℝ) (z : J → ℝ) (K : Matrix B B ℝ) :
    (weightedBinMatrix r c w z K).rank ≤ K.rank := by
  rw [weightedBinMatrix_factorization]
  exact (Matrix.rank_mul_le_left _ _).trans (Matrix.rank_mul_le_right _ _)

omit [Fintype I] in
theorem weightedBinMatrix_rank_le_bins (r : I → B) (c : J → B)
    (w : I → ℝ) (z : J → ℝ) (K : Matrix B B ℝ) :
    (weightedBinMatrix r c w z K).rank ≤ Fintype.card B := by
  exact (weightedBinMatrix_rank_le_kernel r c w z K).trans
    (Matrix.rank_le_card_width K)

end Bins

section TimeKernel

variable {L : Type uL} [DecidableEq L]

def ltIndicator (u v : ℝ) : ℝ :=
  if u < v then 1 else 0

/-- The sign of `v - u`, with zero at equal times. -/
def osign (u v : ℝ) : ℝ :=
  if u < v then 1 else if v < u then -1 else 0

def eqIndicator (y z : L) : ℝ :=
  if y = z then 1 else 0

theorem osign_eq_indicator_sub (u v : ℝ) :
    osign u v = ltIndicator u v - ltIndicator v u := by
  rcases lt_trichotomy u v with h | h | h
  · simp [osign, ltIndicator, h, lt_asymm h]
  · subst v
    simp [osign, ltIndicator]
  · simp [osign, ltIndicator, h, lt_asymm h]

theorem osign_swap (u v : ℝ) :
    osign u v = -osign v u := by
  rw [osign_eq_indicator_sub, osign_eq_indicator_sub]
  ring

theorem eqIndicator_comm (y z : L) :
    eqIndicator y z = eqIndicator z y := by
  simp only [eqIndicator, eq_comm]

theorem eqIndicator_apply (σ : Equiv.Perm L) (y z : L) :
    eqIndicator y (σ z) = eqIndicator z (σ.symm y) := by
  have h : (y = σ z) ↔ (z = σ.symm y) :=
    eq_comm.trans σ.apply_eq_iff_eq_symm_apply
  simp only [eqIndicator, h]

theorem eqIndicator_apply_symm (σ : Equiv.Perm L) (y z : L) :
    eqIndicator y (σ.symm z) = eqIndicator z (σ y) := by
  simpa only [Equiv.symm_symm] using eqIndicator_apply σ.symm y z

/-- The exact zero, plus-one, minus-one shift decomposition. -/
def twistedEqualityKernel (σ : Equiv.Perm L) (u : ℝ) (y : L)
    (v : ℝ) (z : L) : ℝ :=
  osign u v * eqIndicator y z
    + ltIndicator v u * eqIndicator y (σ z)
    - ltIndicator u v * eqIndicator y (σ.symm z)

theorem twistedEqualityKernel_skew (σ : Equiv.Perm L)
    (u : ℝ) (y : L) (v : ℝ) (z : L) :
    twistedEqualityKernel σ u y v z = -twistedEqualityKernel σ v z u y := by
  unfold twistedEqualityKernel
  rw [osign_swap v u, eqIndicator_comm z y,
    eqIndicator_apply σ z y, eqIndicator_apply_symm σ z y]
  ring

theorem twistedEqualityKernel_identity (u : ℝ) (y : L) (v : ℝ) (z : L) :
    twistedEqualityKernel (Equiv.refl L) u y v z = 0 := by
  simp only [twistedEqualityKernel, Equiv.refl_symm, Equiv.refl_apply,
    osign_eq_indicator_sub]
  ring

theorem twistedEqualityKernel_same_time (σ : Equiv.Perm L) (u : ℝ) (y z : L) :
    twistedEqualityKernel σ u y u z = 0 := by
  simp [twistedEqualityKernel, osign, ltIndicator]

theorem twistedEqualityKernel_of_symm_eq (σ : Equiv.Perm L)
    (hσ : σ.symm = σ) (u : ℝ) (y : L) (v : ℝ) (z : L) :
    twistedEqualityKernel σ u y v z =
      osign u v * (eqIndicator y z - eqIndicator y (σ z)) := by
  simp only [twistedEqualityKernel, hσ, osign_eq_indicator_sub]
  ring

omit [DecidableEq L] in
theorem perm_symm_eq_of_involutive (σ : Equiv.Perm L)
    (hσ : Function.Involutive σ) : σ.symm = σ := by
  apply Equiv.ext
  intro y
  calc
    σ.symm y = σ.symm (σ (σ y)) := congrArg σ.symm (hσ y).symm
    _ = σ y := σ.symm_apply_apply (σ y)

theorem twistedEqualityKernel_of_involutive (σ : Equiv.Perm L)
    (hσ : Function.Involutive σ) (u : ℝ) (y : L) (v : ℝ) (z : L) :
    twistedEqualityKernel σ u y v z =
      osign u v * (eqIndicator y z - eqIndicator y (σ z)) := by
  exact twistedEqualityKernel_of_symm_eq σ (perm_symm_eq_of_involutive σ hσ) u y v z

end TimeKernel

end TerminalOrderKernel
