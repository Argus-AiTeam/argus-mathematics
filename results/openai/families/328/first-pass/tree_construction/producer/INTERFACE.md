# Producer consumer interface

Import `Producer`. All names below are in `OAI.ReflexiveFixedPoints`, with the
indicated nested namespaces. Unless stated otherwise, the ambient assumptions
are `{X : Type u} [NormedAddCommGroup X] [NormedSpace ℝ X]`; construction,
`Generated`, terminal sequences, and `SwitchingTreeData` additionally use
`[CompleteSpace X]`. All points of a set use the original norm subtype.
Open `Filter`, `Topology`, `BigOperators`, and `Pointwise` as needed.

## Input data and separate weak carriers

These are the actual upstream definitions, not an adapter's replacement types:

```lean
abbrev WeakCarrier (K : Set X) :=
  {x : WeakSpace ℝ X // (toWeakSpace ℝ X).symm x ∈ K}
def WeaklyCompact (K : Set X) : Prop :=
  IsCompact ((toWeakSpace ℝ X) '' K)
def differenceSpan (K : Set X) : Submodule ℝ X :=
  (Submodule.span ℝ (K - K)).topologicalClosure
def differenceBall (K : Set X) : Set X :=
  {x | x ∈ differenceSpan K ∧ ‖x‖ ≤ 1}
def InvariantSubset (K : Set X) (T : K → K) (s : Set X) : Prop :=
  ∀ x : K, (x : X) ∈ s → (T x : X) ∈ s
def MinimalInvariant (K : Set X) (T : K → K) : Prop :=
  ∀ s : Set X, s ⊆ K → s.Nonempty → IsClosed s → Convex ℝ s →
    InvariantSubset K T s → s = K

structure MinimalInvariantData where
  K : Set X
  nonempty : K.Nonempty
  closed : IsClosed K
  bounded : Bornology.IsBounded K
  convex : Convex ℝ K
  separable : IsSeparable K
  weak_compact : WeaklyCompact K
  T : K → K
  nonexpansive : LipschitzWith 1 T
  no_fixed : ∀ x : K, T x ≠ x
  minimal : MinimalInvariant K T

structure NormalizedMinimalData extends MinimalInvariantData (X := X) where
  diam_one : Metric.diam K = 1
  z : ℕ → K
  dense_z : DenseRange z
  weak_metrizable : TopologicalSpace.MetrizableSpace (WeakCarrier K)
  weak_ball_compact : WeaklyCompact (differenceBall K)
```

`IsSeparable` is `TopologicalSpace.IsSeparable`. The dense sequence has the
**norm** subtype topology; only `WeakCarrier K` has the separate weak topology.
`normToWeak K : K ≃ WeakCarrier K` changes carriers algebraically, not norms.
`NormalizedMinimalData.norm_sub_le_one D x y` proves
`‖(x : X) - (y : X)‖ ≤ 1`.

## Actual infinite ordered tree and evaluator

```lean
structure OrderedTree where
  size : ℕ → ℕ
  size_pos : ∀ k, 0 < size k
  size_zero : size 0 = 1
  parent : ∀ k, Fin (size (k + 1)) → Fin (size k)
  parent_monotone : ∀ k, Monotone (parent k)
  parent_surjective : ∀ k, Function.Surjective (parent k)

abbrev OrderedTree.Node (T : OrderedTree) (k : ℕ) := Fin (T.size k)
abbrev OrderedTree.NonrootNode (T : OrderedTree) := Σ k : ℕ, T.Node (k + 1)

structure WeightedTree (T : OrderedTree) where
  weight : (k : ℕ) → T.Node (k + 1) → ℝ
  weight_pos : ∀ k c, 0 < weight k c
  weight_sum : ∀ k p,
    (∑ c ∈ Finset.univ.filter (fun c => T.parent k c = p), weight k c) = 1

structure TreeEvaluation {T : OrderedTree} (W : WeightedTree T) (K : Set X) where
  convex : Convex ℝ K
  map : (k : ℕ) → T.Node k → K → K
  nonexpansive : ∀ k v, LipschitzWith 1 (map k v)
```

`T.root : T.Node 0 := ⟨0, T.size_pos 0⟩`, and `T.eq_root v : v = T.root`.
For `W : WeightedTree T` and `E : TreeEvaluation W K`:

* `W.pathWeight 0 v = 1`;
  `W.pathWeight (k+1) c = W.pathWeight k (T.parent k c) * W.weight k c`.
* `W.pathWeight_pos k v`, `W.pathWeight_le_one k v`, and
  `W.sum_pathWeight k : (∑ v, W.pathWeight k v) = 1`.
* `E.childAverage k H p : K` has ambient value
  `∑ c ∈ Finset.univ.filter (fun c => T.parent k c = p),
    W.weight k c • (H c : X)` (`E.childAverage_val`).
* `E.collapse k H p := E.map k p (E.childAverage k H p)`.
* `E.evaluate 0 H := H T.root`;
  `E.evaluate (k+1) H := E.evaluate k (E.collapse k H)`.
  Cutoff values are outputs: their own maps are not reapplied.
* `E.idealCutoff k x b v u := if u < v then E.map k u x else b`.
* `E.pathDisplacement 0 v z = 0`;
  `E.pathDisplacement (k+1) v z =
    E.pathDisplacement k (T.parent k v) z +
    ‖(E.map k (T.parent k v) z : X) - z‖`.
* The added theorem `E.pathDisplacement_eq_sum k v z` states exactly
  ```lean
  E.pathDisplacement k v z =
    ∑ i : Fin k,
      ‖(E.map i.val (T.ancestorLE (Nat.le_of_lt i.isLt) v) z : X) - z‖
  ```

## Produced record: every field

```lean
structure SwitchingTreeData (D : NormalizedMinimalData (X := X)) where
  tree : OrderedTree
  weights : WeightedTree tree
  evaluation : TreeEvaluation weights D.K
  anchor : D.K
  label : tree.NonrootNode → ℕ
  label_injective : Function.Injective label
  generated : ∀ k v, Generated D.closed D.convex D.T D.nonexpansive
    (evaluation.map k v)
  root_map : evaluation.map 0 tree.root = id
  functional : (k : ℕ) → tree.Node (k + 1) → X →L[ℝ] ℝ
  functional_norm : ∀ k v, ‖functional k v‖ ≤ 1
  child_average : ∀ k p,
    ‖(evaluation.childAverage k (fun c => evaluation.map (k + 1) c anchor) p : X) -
      anchor‖ ≤ tree.tolerance (OrderedTree.retainedBudget label) k
  path_displacement : ∀ k v,
    evaluation.pathDisplacement (k + 1) v (evaluation.map (k + 1) v anchor) ≤
      OrderedTree.retainedBudget label ⟨k, v⟩
  ultrafilter : Ultrafilter ℕ
  ultrafilter_le_atTop : (ultrafilter : Filter ℕ) ≤ atTop
  predictionLimit : (k : ℕ) → tree.Node (k + 1) → D.K
  prediction_tendsto : ∀ k v, Tendsto
    (fun j => toWeakSpace ℝ X
      (evaluation.evaluate (k + 1)
        (evaluation.idealCutoff (k + 1) anchor
          (terminalSequence D.closed D.convex D.T D.nonexpansive anchor j) v)))
    (ultrafilter : Filter ℕ) (𝓝 (toWeakSpace ℝ X (predictionLimit k v)))
  prediction_detector : ∀ k v,
    1 - OrderedTree.retainedBudget label ⟨k, v⟩ ≤
      functional k v ((evaluation.map (k + 1) v anchor : X) - predictionLimit k v)
  dense_detector : ∀ k v i, i < k + 1 →
    1 - OrderedTree.retainedBudget label ⟨k, v⟩ ≤
      functional k v ((evaluation.map (k + 1) v anchor : X) - D.z i)
```

The actual constructors are:

```lean
def switchingTreeDataOfAnchor
    (D : NormalizedMinimalData (X := X))
    (A : AnchorPoint (tailFamily D.closed D.convex D.T D.nonexpansive))
    (U : Ultrafilter ℕ) (hU : (U : Filter ℕ) ≤ atTop) : SwitchingTreeData D

theorem exists_switchingTreeData (D : NormalizedMinimalData (X := X)) :
    Nonempty (SwitchingTreeData D)
```

Use `Classical.choice (exists_switchingTreeData D)` to consume the result.
The existence proof constructs the anchor with `resolventAnchorPoint` and
chooses `Ultrafilter.of atTop`; neither is an input to that existence theorem.

## Budgets, tolerance, and terminals

* `candidateBudget n : ℝ := (1/2 : ℝ) ^ (n+9)`.
* `OrderedTree.retainedBudget label v := candidateBudget (label v)`.
* `OrderedTree.summable_retainedBudget label label_injective`;
  `OrderedTree.tsum_retainedBudget_le label label_injective` bounds the sum
  by `1/256` (also `_le_one_div_128` is available).
* `OrderedTree.sum_retainedBudget_comp_le label label_injective node hnode`
  bounds `∑ i, retainedBudget label (node i)` by `1/256` for any finite type
  and injective `node : ι → T.NonrootNode`.
* For `e : T.NonrootNode → ℝ`, `T.levelMinimum e k` is the minimum over
  `v : T.Node (k+1)` of `e ⟨k,v⟩`.
  `T.cumulativeMinimum e 0 = 1`;
  `T.cumulativeMinimum e (k+1) =
    min (T.cumulativeMinimum e k) (T.levelMinimum e k)`.
  `T.tolerance e k := (1/2 : ℝ) ^ (k+1) * T.cumulativeMinimum e k`.
  `T.tolerance_zero e` gives `1/2`.
* `T.tolerance_tail_le_budget e he hik hkN v` states
  ```lean
  (∑ d ∈ Finset.Ico k N, T.tolerance e d) ≤ e ⟨i,v⟩
  ```
  where `he : ∀ v, 0 < e v`, `hik : i+1 ≤ k`, `hkN : k ≤ N`,
  and `v : T.Node (i+1)`.
* For `A : SwitchingTreeData D`, `A.budget 0 v := 0`,
  `A.budget (k+1) v := OrderedTree.retainedBudget A.label ⟨k,v⟩`;
  `A.functionalAt 0 v := 0`, `A.functionalAt (k+1) v := A.functional k v`;
  `A.nodeLabel k v := A.evaluation.map k v A.anchor`.
* `terminalSequence hclosed hconvex T hT x j :=
    resolvent hclosed hconvex T hT (j+1) (Nat.succ_le_succ (Nat.zero_le j)) x`.
  `A.terminal j := terminalSequence D.closed D.convex D.T D.nonexpansive A.anchor j`.
* `E.terminalDefect N b :=
    ∑ d ∈ Finset.range N, ∑ v : T.Node d, ‖(E.map d v b : X) - b‖`.
* The added `A.terminalDefect_tendsto N` states
  ```lean
  Tendsto (fun j => A.evaluation.terminalDefect N (A.terminal j)) atTop (𝓝 0)
  ```
* More generally, `terminalSequence_finite_displacement_tendsto` takes
  `hclosed hconvex T hT hdiam G hG x`, with `[Fintype ι]`,
  `hdiam : ∀ a b : K, ‖(a:X)-(b:X)‖ ≤ 1`,
  `G : ι → K → K`, `hG : ∀ i, Generated hclosed hconvex T hT (G i)`, and
  concludes convergence to zero of the sum of all `G i` displacements
  along that same terminal sequence.

## Ancestors and half-open descendant intervals

All these names are in `OrderedTree` and use the orientation **later to earlier**:

```lean
T.ancestorLE {i j : ℕ} (h : i ≤ j) : T.Node j → T.Node i
T.ancestorLE_refl i : T.ancestorLE (Nat.le_refl i) = id
T.ancestorLE_succ i : T.ancestorLE (Nat.le_succ i) = T.parent i
T.ancestorLE_trans hij hjk :
  T.ancestorLE (Nat.le_trans hij hjk) =
    T.ancestorLE hij ∘ T.ancestorLE hjk
T.ancestorLE_monotone h : Monotone (T.ancestorLE h)
T.ancestorLE_surjective h : Function.Surjective (T.ancestorLE h)
T.descendants h v := Finset.univ.filter (fun s => T.ancestorLE h s = v)
```

`T.descendantFirst h v` and `T.descendantLast h v` are respectively the minimum
and maximum of that proved nonempty descendant finset.
`T.descendantLo h v := (T.descendantFirst h v).val` and
`T.descendantHi h v := (T.descendantLast h v).val + 1`.

```lean
T.ancestorLE_eq_iff_interval h v s :
  T.ancestorLE h s = v ↔
    T.descendantLo h v ≤ s.val ∧ s.val < T.descendantHi h v
T.descendantLo_lt_hi h v : T.descendantLo h v < T.descendantHi h v
T.descendantHi_le_size h v : T.descendantHi h v ≤ T.size j
T.descendantHi_le_descendantLo_of_lt h v w hvw :
  T.descendantHi h v ≤ T.descendantLo h w
T.lt_descendantLo_iff_ancestorLE_lt h v s :
  s.val < T.descendantLo h v ↔ T.ancestorLE h s < v
T.lt_descendantHi_iff_ancestorLE_le h v s :
  s.val < T.descendantHi h v ↔ T.ancestorLE h s ≤ v
W.descendant_sum_pathWeight h v :
  (∑ s ∈ T.descendants h v, W.pathWeight j s) = W.pathWeight i v
```

`T.sum_descendants_eq_Ico h v f` reindexes a descendant sum as the natural
half-open interval sum, for any `f : ℕ → A` and `[AddCommMonoid A]`.
These interfaces suffice for a plane-tree adapter without reading the
finite-stage implementation.
