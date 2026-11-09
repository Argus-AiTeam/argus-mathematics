import Producer
import DifferenceSpace
import ReviewedSwitchingBridge

noncomputable section

open scoped BigOperators Topology
open Filter OAI.ReflexiveFixedPoints

namespace TreeConstruction

private def fullAncestor (T : OrderedTree) (i n : ℕ) (v : T.Node n) : T.Node i :=
  if h : i ≤ n then T.ancestorLE h v else ⟨0, T.size_pos i⟩

private def fullLo (T : OrderedTree) (i n : ℕ) (v : T.Node i) : ℕ :=
  if h : i ≤ n then T.descendantLo h v else 0

private def fullHi (T : OrderedTree) (i n : ℕ) (v : T.Node i) : ℕ :=
  if h : i ≤ n then T.descendantHi h v else 0

abbrev planeTree (T : OrderedTree) (W : WeightedTree T) : SwitchingBridge.PlaneTree where
  count := T.size
  count_pos := T.size_pos
  count_zero := T.size_zero
  parent := T.parent
  alpha := W.weight
  alpha_pos := W.weight_pos
  alpha_sum := by
    intro k p
    simpa only [Finset.sum_filter] using W.weight_sum k p
  ancestor := fullAncestor T
  ancestor_self := by
    intro n v
    simp [fullAncestor]
  ancestor_bottom := by
    intro i n hi v
    simp only [fullAncestor, dif_pos hi, dif_pos (hi.trans (Nat.le_succ n))]
    simpa only [Function.comp_apply, T.ancestorLE_succ] using
      congrFun (T.ancestorLE_trans hi (Nat.le_succ n)) v
  ancestor_top := by
    intro i n hi v
    have his : i + 1 ≤ n := hi
    simp only [fullAncestor, dif_pos his, dif_pos hi.le]
    simpa only [Function.comp_apply, T.ancestorLE_succ] using
      (congrFun (T.ancestorLE_trans (Nat.le_succ i) his) v).symm
  ancestor_comp := by
    intro i k n hik hkn v
    simp only [fullAncestor, dif_pos hik, dif_pos hkn, dif_pos (hik.trans hkn)]
    exact (congrFun (T.ancestorLE_trans hik hkn) v).symm
  lo := fullLo T
  hi := fullHi T
  lo_le_hi := by
    intro k n h v
    simpa only [fullLo, fullHi, dif_pos h] using (T.descendantLo_lt_hi h v).le
  hi_le := by
    intro k n h v
    simpa only [fullHi, dif_pos h] using T.descendantHi_le_size h v
  before_cut := by
    intro k n h v s
    simpa only [fullHi, fullAncestor, dif_pos h, Fin.le_def] using
      T.lt_descendantHi_iff_ancestorLE_le h v s
  after_cut := by
    intro k n h v s
    simpa only [fullLo, fullAncestor, dif_pos h, Fin.lt_def] using
      T.lt_descendantLo_iff_ancestorLE_lt h v s

variable {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X] [CompleteSpace X]
variable {D : NormalizedMinimalData (X := X)}

abbrev Space (D : NormalizedMinimalData (X := X)) := DifferenceSpace D.K

abbrev shiftedK (A : SwitchingTreeData D) : Set (Space D) :=
  shiftedSet D.K A.anchor

abbrev shift (A : SwitchingTreeData D) : D.K ≃ shiftedK A :=
  shiftEquiv A.anchor

abbrev bridgeTree (A : SwitchingTreeData D) : SwitchingBridge.PlaneTree :=
  planeTree A.tree A.weights

def bridgeEvaluation (A : SwitchingTreeData D) :
    SwitchingBridge.Evaluation (bridgeTree A) (shiftedK A) where
  convex := shiftedSet_convex D.convex A.anchor
  x := shift A A.anchor
  map := fun k v => shiftConjugate A.anchor (A.evaluation.map k v)
  nonexpansive := by
    intro k v a b
    simpa only [NNReal.coe_one, one_mul, Subtype.dist_eq, dist_eq_norm] using
      (shiftConjugate_nonexpansive A.anchor (A.evaluation.map k v)
        (A.evaluation.nonexpansive k v)).dist_le_mul a b

theorem evaluation_map (A : SwitchingTreeData D) (k : ℕ) (v : A.tree.Node k) (a : D.K) :
    (bridgeEvaluation A).map k v (shift A a) = shift A (A.evaluation.map k v a) := by
  simp [bridgeEvaluation, shiftConjugate]

theorem evaluation_label (A : SwitchingTreeData D) (k : ℕ) (v : A.tree.Node k) :
    (bridgeEvaluation A).label k v = shift A (A.evaluation.map k v A.anchor) := by
  simp [SwitchingBridge.Evaluation.label, bridgeEvaluation, shiftConjugate]

theorem average_shift (A : SwitchingTreeData D) (k : ℕ)
    (H : A.tree.Node (k + 1) → D.K) (p : A.tree.Node k) :
    (bridgeEvaluation A).average k (fun v => shift A (H v)) p =
      shift A (A.evaluation.childAverage k H p) := by
  apply Subtype.ext
  have hav : A.evaluation.childAverage k H p =
      convexAverage D.convex
        (Finset.univ.filter (fun v => A.tree.parent k v = p))
        (A.weights.weight k) (fun v _ => (A.weights.weight_pos k v).le)
        (A.weights.weight_sum k p) H := by
    apply Subtype.ext
    exact A.evaluation.childAverage_val k H p
  rw [hav, shiftEquiv_convexAverage_val]
  simp [SwitchingBridge.Evaluation.average, SwitchingBridge.PlaneTree.childWeight,
    bridgeTree, planeTree, Finset.sum_filter, ite_smul]

theorem collapse_shift (A : SwitchingTreeData D) (k : ℕ)
    (H : A.tree.Node (k + 1) → D.K) (p : A.tree.Node k) :
    (bridgeEvaluation A).collapse k (fun v => shift A (H v)) p =
      shift A (A.evaluation.collapse k H p) := by
  unfold SwitchingBridge.Evaluation.collapse
  rw [average_shift, evaluation_map]
  rfl

theorem rootOutput_shift (A : SwitchingTreeData D) (n : ℕ)
    (F : ∀ k, A.tree.Node k → D.K) :
    (bridgeEvaluation A).rootOutput n (fun k v => shift A (F k v)) =
      shift A (A.evaluation.evaluate n (F n)) := by
  induction n generalizing F with
  | zero => rfl
  | succ n ih =>
      have factor (H : ∀ k, A.tree.Node k → shiftedK A) :
          (bridgeEvaluation A).rootOutput (n + 1) H =
            (bridgeEvaluation A).rootOutput n
              (fun k => (bridgeEvaluation A).collapse k (H (k + 1))) := by
        unfold SwitchingBridge.Evaluation.rootOutput
        rw [SwitchingBridge.Evaluation.eval_add]
        rfl
      rw [factor]
      have hcollapse :
          (fun k => (bridgeEvaluation A).collapse k (fun v => shift A (F (k + 1) v))) =
            (fun k v => shift A (A.evaluation.collapse k (F (k + 1)) v)) := by
        funext k v
        exact collapse_shift A k (F (k + 1)) v
      rw [hcollapse]
      exact ih (fun k => A.evaluation.collapse k (F (k + 1)))

theorem prediction_shift (A : SwitchingTreeData D) (k : ℕ)
    (v : A.tree.Node k) (b : D.K) :
    (bridgeEvaluation A).prediction k v (shift A b) =
      shift A (A.evaluation.evaluate k (A.evaluation.idealCutoff k A.anchor b v)) := by
  unfold SwitchingBridge.Evaluation.prediction
  let F : ∀ j, A.tree.Node j → D.K :=
    fun j u => if u.val < v.val then A.evaluation.map j u A.anchor else b
  have hfamily : (bridgeEvaluation A).idealFamily k v (shift A b) =
      fun j u => shift A (F j u) := by
    funext j u
    by_cases h : u.val < v.val
    · simp [SwitchingBridge.Evaluation.idealFamily, F, h, evaluation_label]
    · simp [SwitchingBridge.Evaluation.idealFamily, F, h]
  rw [hfamily, rootOutput_shift]
  congr 1

theorem pathDisplacement_plane (A : SwitchingTreeData D) (k : ℕ)
    (v : A.tree.Node k) (y : D.K) :
    (∑ i ∈ Finset.range k,
      ‖(A.evaluation.map i ((bridgeTree A).ancestor i k v) y : X) - y‖) =
        A.evaluation.pathDisplacement k v y := by
  induction k with
  | zero => rfl
  | succ k ih =>
      rw [Finset.sum_range_succ]
      have hsum :
          (∑ i ∈ Finset.range k,
            ‖(A.evaluation.map i ((bridgeTree A).ancestor i (k + 1) v) y : X) - y‖) =
          ∑ i ∈ Finset.range k,
            ‖(A.evaluation.map i
              ((bridgeTree A).ancestor i k (A.tree.parent k v)) y : X) - y‖ := by
        apply Finset.sum_congr rfl
        intro i hi
        rw [(bridgeTree A).ancestor_bottom i k (Finset.mem_range.mp hi).le]
      rw [hsum, ih]
      have hlast : (bridgeTree A).ancestor k (k + 1) v = A.tree.parent k v := by
        simp [bridgeTree, planeTree, fullAncestor]
      rw [hlast]
      rfl

private theorem le_cumulativeMinimum (T : OrderedTree) (e : T.NonrootNode → ℝ)
    (k : ℕ) (a : ℝ) (ha : a ≤ 1) (he : ∀ i, i < k → ∀ v, a ≤ e ⟨i, v⟩) :
    a ≤ T.cumulativeMinimum e k := by
  induction k with
  | zero => exact ha
  | succ k ih =>
      change a ≤ min (T.cumulativeMinimum e k) (T.levelMinimum e k)
      refine le_min (ih (fun i hi => he i (by omega))) ?_
      unfold OrderedTree.levelMinimum
      apply Finset.le_inf'
      intro v _
      exact he k (by omega) v

theorem tolerance_eq_manuscript (A : SwitchingTreeData D) (k : ℕ) :
    A.tree.tolerance (OrderedTree.retainedBudget A.label) k =
      (bridgeTree A).manuscriptTolerance A.budget k := by
  by_cases hk : 0 < k
  · let m := (bridgeTree A).cumulativeMinimum A.budget k hk
    have hm (i : ℕ) (hi : i < k) (v : A.tree.Node (i + 1)) :
        m ≤ OrderedTree.retainedBudget A.label ⟨i, v⟩ := by
      exact Finset.inf'_le _ (Finset.mem_univ (⟨⟨i, hi⟩, v⟩ :
        Σ j : Fin k, A.tree.Node (j.val + 1)))
    let v : A.tree.Node 1 := ⟨0, A.tree.size_pos 1⟩
    have hv : OrderedTree.retainedBudget A.label ⟨0, v⟩ ≤ 1 := by
      change (1 / 2 : ℝ) ^ (A.label ⟨0, v⟩ + 9) ≤ 1
      exact pow_le_one₀ (by norm_num) (by norm_num)
    have hlower : m ≤ A.tree.cumulativeMinimum (OrderedTree.retainedBudget A.label) k :=
      le_cumulativeMinimum A.tree _ k m ((hm 0 hk v).trans hv) hm
    have hupper : A.tree.cumulativeMinimum (OrderedTree.retainedBudget A.label) k ≤ m := by
      unfold m SwitchingBridge.PlaneTree.cumulativeMinimum
      apply Finset.le_inf'
      intro v _
      exact A.tree.cumulativeMinimum_le_budget (OrderedTree.retainedBudget A.label)
        (Nat.succ_le_of_lt v.1.isLt) v.2
    have heq := le_antisymm hupper hlower
    unfold OrderedTree.tolerance SwitchingBridge.PlaneTree.manuscriptTolerance
    rw [dif_pos hk]
    exact congrArg (fun t => (1 / 2 : ℝ) ^ (k + 1) * t) heq
  · have hk0 : k = 0 := by omega
    subst k
    simp [OrderedTree.tolerance, OrderedTree.cumulativeMinimum,
      SwitchingBridge.PlaneTree.manuscriptTolerance]

private def splitLevels (T : OrderedTree) :
    (Σ k, T.Node k) ≃ T.Node 0 ⊕ T.NonrootNode where
  toFun := fun v => match v with
    | ⟨0, v⟩ => Sum.inl v
    | ⟨k + 1, v⟩ => Sum.inr ⟨k, v⟩
  invFun := fun v => match v with
    | Sum.inl v => ⟨0, v⟩
    | Sum.inr ⟨k, v⟩ => ⟨k + 1, v⟩
  left_inv := by
    rintro ⟨k, v⟩
    cases k <;> rfl
  right_inv := by
    intro v
    rcases v with v | ⟨k, v⟩ <;> rfl

theorem budget_summable (A : SwitchingTreeData D) :
    Summable (fun v : Σ k, (bridgeTree A).Node k => A.budget v.1 v.2) := by
  apply (splitLevels A.tree).symm.summable_iff.mp
  apply Summable.sum
  · simp [Function.comp_def, splitLevels, SwitchingTreeData.budget]
  · simpa [Function.comp_def, splitLevels, SwitchingTreeData.budget] using
      OrderedTree.summable_retainedBudget A.label A.label_injective

theorem budget_prefix (A : SwitchingTreeData D) (n : ℕ) :
    (∑ i ∈ Finset.range n, ∑ v, A.budget (i + 1) v) ≤ (1 : ℝ) / 128 := by
  let node : (Σ i : Fin n, A.tree.Node (i.val + 1)) → A.tree.NonrootNode :=
    fun v => ⟨v.1.val, v.2⟩
  have hnode : Function.Injective node := by
    rintro ⟨i, v⟩ ⟨j, w⟩ h
    have hij : i = j := Fin.ext (congrArg Sigma.fst h)
    subst j
    have hv : v = w := eq_of_heq (Sigma.mk.inj_iff.mp h).2
    subst w
    rfl
  have hb := OrderedTree.sum_retainedBudget_comp_le A.label A.label_injective node hnode
  have hsmall : (1 : ℝ) / 256 ≤ 1 / 128 := by norm_num
  calc
    (∑ i ∈ Finset.range n, ∑ v, A.budget (i + 1) v) =
        ∑ i : Fin n, ∑ v, A.budget (i.val + 1) v :=
      (Fin.sum_univ_eq_sum_range (fun i => ∑ v, A.budget (i + 1) v) n).symm
    _ ≤ (1 : ℝ) / 128 := by
      simpa [node, Fintype.sum_sigma, SwitchingTreeData.budget] using hb.trans hsmall

def detector (A : SwitchingTreeData D) (k : ℕ) (v : A.tree.Node k) :
    Space D →L[ℝ] ℝ :=
  restrictFunctional D.K (A.functionalAt k v)

def predictionLimit (A : SwitchingTreeData D) :
    ∀ k, A.tree.Node k → shiftedK A
  | 0, _ => shift A A.anchor
  | k + 1, v => shift A (A.predictionLimit k v)

structure ManuscriptInputs (D : NormalizedMinimalData (X := X)) where
  tree : SwitchingBridge.PlaneTree
  K : Set (Space D)
  evaluation : SwitchingBridge.Evaluation tree K
  budget : ∀ k, tree.Node k → ℝ
  budget_nonneg : ∀ k v, 0 ≤ budget k v
  budget_pos : ∀ k, 0 < k → ∀ v, 0 < budget k v
  budget_zero : ∀ v, budget 0 v = 0
  child_average : ∀ k v,
    ‖(evaluation.average k (evaluation.label (k + 1)) v : Space D) - evaluation.x‖ ≤
      tree.manuscriptTolerance budget k
  ancestor_displacement : ∀ k, 0 < k → ∀ v,
    (∑ i ∈ Finset.range k,
      ‖(evaluation.map i (tree.ancestor i k v) (evaluation.label k v) : Space D) -
        evaluation.label k v‖) ≤ budget k v
  diameter : ∀ a b : K, ‖(a : Space D) - b‖ ≤ 1
  functional : ∀ k, tree.Node k → Space D →L[ℝ] ℝ
  functional_norm : ∀ k v, ‖functional k v‖ ≤ 1
  terminal : ℕ → K
  ultrafilter : Filter ℕ
  proper : ultrafilter.NeBot
  le_atTop : ultrafilter ≤ atTop
  terminal_displacement : ∀ k v,
    Tendsto (fun j => ‖(evaluation.map k v (terminal j) : Space D) - terminal j‖)
      atTop (𝓝 0)
  predictionLimit : ∀ k, tree.Node k → K
  prediction_tendsto : ∀ k, 0 < k → ∀ v,
    Tendsto (fun j => toWeakSpace ℝ (Space D) (evaluation.prediction k v (terminal j)))
      ultrafilter (𝓝 (toWeakSpace ℝ (Space D) (predictionLimit k v)))
  prediction_detector : ∀ k, 0 < k → ∀ v,
    1 - budget k v ≤ functional k v ((evaluation.label k v : Space D) - predictionLimit k v)
  budget_prefix : ∀ n,
    (∑ i ∈ Finset.range n, ∑ v, budget (i + 1) v) ≤ (1 : ℝ) / 128
  budget_summable : Summable (fun v : Σ k, tree.Node k => budget v.1 v.2)
  dense : ℕ → K
  dense_difference_span : closure (Submodule.span ℝ
    (Set.range (fun ij : ℕ × ℕ => (dense ij.1 : Space D) - dense ij.2)) : Set (Space D)) =
      Set.univ
  dense_detector : ∀ k v i, i < k →
    1 - budget k v ≤ functional k v ((evaluation.label k v : Space D) - dense i)
  weak_ball_compact : IsCompact (SwitchingBridge.weakBall (X := Space D))

def inputsOfTree (A : SwitchingTreeData D) : ManuscriptInputs D where
  tree := bridgeTree A
  K := shiftedK A
  evaluation := bridgeEvaluation A
  budget := A.budget
  budget_nonneg := by
    intro k v
    cases k with
    | zero => exact le_rfl
    | succ k => exact (OrderedTree.retainedBudget_pos A.label ⟨k, v⟩).le
  budget_pos := by
    intro k hk v
    cases k with
    | zero => omega
    | succ k => exact OrderedTree.retainedBudget_pos A.label ⟨k, v⟩
  budget_zero := by intro v; rfl
  child_average := by
    intro k v
    have hlabels : (bridgeEvaluation A).label (k + 1) =
        fun c => shift A (A.evaluation.map (k + 1) c A.anchor) := by
      funext c
      exact evaluation_label A (k + 1) c
    rw [hlabels, average_shift]
    simpa only [bridgeEvaluation, shift, shiftEquiv_norm_sub, tolerance_eq_manuscript] using
      A.child_average k v
  ancestor_displacement := by
    intro k hk v
    cases k with
    | zero => omega
    | succ k =>
        simp_rw [evaluation_label, evaluation_map, shift, shiftEquiv_norm_sub]
        rw [pathDisplacement_plane]
        exact A.path_displacement k v
  diameter := by
    intro a b
    calc
      ‖(a : Space D) - b‖ =
          ‖((shift A).symm a : X) - ((shift A).symm b : X)‖ := by
        simpa only [shift, Equiv.apply_symm_apply] using
          shiftEquiv_norm_sub A.anchor ((shift A).symm a) ((shift A).symm b)
      _ ≤ 1 := D.norm_sub_le_one _ _
  functional := detector A
  functional_norm := by
    intro k v
    exact (norm_restrictFunctional_le D.K (A.functionalAt k v)).trans
      (A.functionalAt_norm k v)
  terminal := fun j => shift A (A.terminal j)
  ultrafilter := A.ultrafilter
  proper := by infer_instance
  le_atTop := A.ultrafilter_le_atTop
  terminal_displacement := by
    intro k v
    simpa only [evaluation_map, shift, shiftEquiv_norm_sub, SwitchingTreeData.terminal] using
      terminalSequence_generated_displacement_tendsto D.closed D.convex D.T
        D.nonexpansive D.norm_sub_le_one (A.generated k v) A.anchor
  predictionLimit := predictionLimit A
  prediction_tendsto := by
    intro k hk v
    cases k with
    | zero => omega
    | succ k =>
        have h := tendsto_shiftEquiv_weak A.anchor
          (fun j => A.evaluation.evaluate (k + 1)
            (A.evaluation.idealCutoff (k + 1) A.anchor (A.terminal j) v))
          (A.predictionLimit k v) (A.ultrafilter : Filter ℕ)
          (by simpa only [SwitchingTreeData.terminal] using A.prediction_tendsto k v)
        simpa only [prediction_shift, predictionLimit, shift] using h
  prediction_detector := by
    intro k hk v
    cases k with
    | zero => omega
    | succ k =>
        simpa only [evaluation_label, predictionLimit, detector,
          SwitchingTreeData.functionalAt, shift, restrictFunctional_shift_sub,
          SwitchingTreeData.budget] using A.prediction_detector k v
  budget_prefix := budget_prefix A
  budget_summable := budget_summable A
  dense := fun i => shift A (D.z i)
  dense_difference_span := by
    have h := congrArg (fun M : Submodule ℝ (Space D) => (M : Set (Space D)))
      (normalized_shifted_dense_differences_span D A.anchor)
    simpa [Submodule.topologicalClosure_coe, shiftedDenseDifferences, shift] using h
  dense_detector := by
    intro k v i hi
    cases k with
    | zero => omega
    | succ k =>
        simpa only [evaluation_label, detector, SwitchingTreeData.functionalAt, shift,
          restrictFunctional_shift_sub, SwitchingTreeData.budget] using A.dense_detector k v i hi
  weak_ball_compact := by
    simpa only [SwitchingBridge.weakBall, intrinsicWeakUnitBall, Space] using
      normalized_intrinsicWeakUnitBall_compact D

def tree_construction (D : NormalizedMinimalData (X := X)) : ManuscriptInputs D :=
  inputsOfTree (Classical.choice (exists_switchingTreeData D))

theorem normalized_contradiction (D : NormalizedMinimalData (X := X)) : False := by
  let A := tree_construction D
  exact SwitchingBridge.switching_bridge_from_manuscript A.evaluation
    A.budget A.budget_nonneg A.budget_pos A.budget_zero A.child_average
    A.ancestor_displacement A.diameter A.functional A.functional_norm
    A.terminal A.ultrafilter A.proper A.le_atTop A.terminal_displacement
    A.predictionLimit A.prediction_tendsto A.prediction_detector
    A.budget_prefix A.budget_summable A.dense A.dense_difference_span
    A.dense_detector A.weak_ball_compact

end TreeConstruction

#print axioms TreeConstruction.tree_construction
#print axioms TreeConstruction.normalized_contradiction
