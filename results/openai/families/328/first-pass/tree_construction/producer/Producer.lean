import OAI.Analysis.Nonexpansive.TreeProducer

/-!
Lean 4.31.0 entry point for the attributed OpenAI producer-side library port.
See ATTRIBUTION.md and upstream/LICENSE for provenance and license.
No contradiction or final fixed-point theorem is imported here.
-/

open Filter
open scoped Topology BigOperators

namespace OAI.ReflexiveFixedPoints.TreeEvaluation

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X]
variable {T : OrderedTree} {W : WeightedTree T} {K : Set X}

/-- Convert the recursive proper-ancestor displacement to an indexed sum. -/
theorem pathDisplacement_eq_sum (E : TreeEvaluation W K) (k : ℕ)
    (v : T.Node k) (z : K) :
    E.pathDisplacement k v z =
      ∑ i : Fin k,
        ‖(E.map i.val (T.ancestorLE (Nat.le_of_lt i.isLt) v) z : X) - z‖ := by
  induction k with
  | zero => simp [pathDisplacement]
  | succ k ih =>
      rw [E.pathDisplacement_succ, ih]
      conv_rhs => rw [Fin.sum_univ_castSucc]
      congr 1
      · apply Finset.sum_congr rfl
        intro i _
        exact congrArg (fun w => ‖(E.map i.val w z : X) - z‖)
          (T.ancestorLE_step_apply (Nat.le_of_lt i.isLt) v).symm
      · exact congrArg (fun w => ‖(E.map k w z : X) - z‖)
          (T.ancestorLE_succ_apply k v).symm

end OAI.ReflexiveFixedPoints.TreeEvaluation

namespace OAI.ReflexiveFixedPoints.SwitchingTreeData

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]
variable {D : NormalizedMinimalData (X := X)} (A : SwitchingTreeData D)

/-- Every fixed finite truncation uses the same actual terminal sequence. -/
theorem terminalDefect_tendsto (N : ℕ) :
    Tendsto (fun j => A.evaluation.terminalDefect N (A.terminal j)) atTop (𝓝 0) := by
  have h := tendsto_finsetSum (Finset.range N) fun d _ =>
    tendsto_finsetSum Finset.univ fun v _ =>
      terminalSequence_generated_displacement_tendsto
        D.closed D.convex D.T D.nonexpansive D.norm_sub_le_one
        (A.generated d v) A.anchor
  simpa only [TreeEvaluation.terminalDefect, terminal, Finset.sum_const_zero] using h

end OAI.ReflexiveFixedPoints.SwitchingTreeData

#print axioms OAI.ReflexiveFixedPoints.switchingTreeDataOfAnchor
#print axioms OAI.ReflexiveFixedPoints.exists_switchingTreeData
#print axioms OAI.ReflexiveFixedPoints.SwitchingTreeData.terminalDefect_tendsto
#print axioms OAI.ReflexiveFixedPoints.TreeEvaluation.pathDisplacement_eq_sum

#check OAI.ReflexiveFixedPoints.switchingTreeDataOfAnchor
#check OAI.ReflexiveFixedPoints.exists_switchingTreeData
#print OAI.ReflexiveFixedPoints.MinimalInvariantData
#print OAI.ReflexiveFixedPoints.NormalizedMinimalData
#print OAI.ReflexiveFixedPoints.MinimalInvariant
#print OAI.ReflexiveFixedPoints.differenceSpan
#print OAI.ReflexiveFixedPoints.differenceBall
#print OAI.ReflexiveFixedPoints.WeakCarrier
#print OAI.ReflexiveFixedPoints.OrderedTree
#print OAI.ReflexiveFixedPoints.WeightedTree
#print OAI.ReflexiveFixedPoints.TreeEvaluation
#print OAI.ReflexiveFixedPoints.SwitchingTreeData
