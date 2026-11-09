import OAI.Algebra.Drinfeld.Ihara

namespace Audit9000008

open OAI.DeligneDrinfeld

def manuscriptSolution (p : L) : Prop :=
  p + eval y x p = 0 ∧
  p + eval y (-x-y) p + eval (-x-y) x p = 0 ∧
  eval (t 0 1) (t 1 2 + t 1 3) p + eval (t 0 2 + t 1 2) (t 2 3) p =
    eval (t 1 2) (t 2 3) p + eval (t 0 1 + t 0 2) (t 1 3 + t 2 3) p +
      eval (t 0 1) (t 1 2) p

theorem solution_fidelity (p : L) :
    manuscriptSolution p ↔ IsSolution p := by
  rfl

theorem membership_fidelity (p : L) :
    p ∈ W ↔ manuscriptSolution p := by
  rfl

theorem upper_bound_gt_two (n : ℕ) (hn : 2 < n) :
    Module.finrank ℚ (Wn n) ≤ Module.finrank ℚ (Fn n) :=
  RationalBound.finrank_Wn_le n hn

end Audit9000008

set_option pp.fullNames true

#check Audit9000008.upper_bound_gt_two
#print axioms Audit9000008.upper_bound_gt_two
#print OAI.DeligneDrinfeld.L
#print OAI.DeligneDrinfeld.BraidFree
#print OAI.DeligneDrinfeld.chord
#print OAI.DeligneDrinfeld.eval
#print OAI.DeligneDrinfeld.IsSolution
#print OAI.DeligneDrinfeld.W
#print OAI.DeligneDrinfeld.Wn
#print OAI.DeligneDrinfeld.Ln
#print OAI.DeligneDrinfeld.Fn
#print OAI.DeligneDrinfeld.oddWeight
#print OAI.DeligneDrinfeld.weightPiece
#print OAI.DeligneDrinfeld.WeightedWord
#print OAI.DeligneDrinfeld.braidRelations
#print OAI.DeligneDrinfeld.braidIdeal
#print OAI.DeligneDrinfeld.T4
#print OAI.DeligneDrinfeld.t
