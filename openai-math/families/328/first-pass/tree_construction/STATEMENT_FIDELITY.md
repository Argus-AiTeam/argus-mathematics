# Normalized tree construction and contradiction

## Principal declarations and scope

`TreeConstruction.tree_construction` has the statement

```lean
{X : Type*} [NormedAddCommGroup X] [NormedSpace Real X] [CompleteSpace X]
(D : OAI.ReflexiveFixedPoints.NormalizedMinimalData (X := X)) :
TreeConstruction.ManuscriptInputs D
```

`TreeConstruction.normalized_contradiction`, with exactly the same ambient
parameters and input `D`, concludes `False`. It first obtains the above
constructed record and then applies the previously reviewed declaration
`SwitchingBridge.switching_bridge_from_manuscript` to every field.

The first declaration produces data; the second is a nonexistence theorem
for the normalized data. Neither statement assumes an anchor, a successful
adaptive run, compact prediction families, detectors, a tree, finite
switching witnesses, or a branch/vector contradiction. These are not a
finite experiment or a counterexample.

This certifies the normalized construction and its composition, not the
arbitrary-domain reduction of manuscript Lemma `reduction`. The latter
remains the separate open claim `C_NORMALIZED_REDUCTION`; the full original
fixed-point claim remains open in this campaign. Independent fidelity review
of these new declarations is still required. Compilation is not a claim
of novelty or publishability.

## Exact normalized hypotheses

The imported structure `NormalizedMinimalData` supplies the following data
and propositions in the **given ambient norm**:

1. A set `K : Set X` which is nonempty, norm closed, norm bounded, convex,
   norm separable and weakly compact.
2. A selfmap `T : K -> K`, `LipschitzWith 1 T`, with no fixed point.
3. Minimality: every nonempty norm-closed convex subset of `K` invariant
   under `T` is all of `K`.
4. `Metric.diam K = 1`, a norm-dense sequence `z : Nat -> K`, and
   metrizability of the weak topology on `K`.
5. Weak compactness, in the ambient weak topology, of
   `{x : X | x in closure(span(K-K)) and norm x <= 1}`.

These are the normalized conclusions of the staged
`build/sections/01-preliminaries.tex`, Lemma `reduction`, including its
chosen dense sequence and difference-space unit ball. They are hypotheses
of the present theorem, not a proved reduction from a general reflexive
Banach-space counterexample. No ambient reflexivity assumption, weak
continuity of `T`, or intrinsic difference-space compactness assumption
has been added.

`LipschitzWith 1` is the metric formulation of nonexpansiveness. The
derived `D.norm_sub_le_one` gives the diameter bound for every pair of
points. The natural-number indices of sequences begin at zero in Lean;
the terminal sequence uses resolvent number `j+1`.

## Where the construction comes from

The producer-side proofs are an attributed, locally compiled Lean 4.31.0
port of the Apache-2.0 implementation at

`openai/math@4eaee87548250b2682affda7d05d947c05554bae`,
`lean/OAI/Analysis/Nonexpansive/`.

The license, upstream source, revision, modification notices, dependency
inspection and port diff are retained under `producer/`. This is not an
independently invented proof of the anchor or adaptive construction. In
particular, the upstream Lean 4.34.1 toolchain and upstream source presence
are not treated as compiler evidence. The replay builds the local
producer modules with the host's Lean 4.31.0 Mathlib workspace.

The dependency chain actually constructs:

- The resolvents and their nonexpansiveness and displacement estimates,
  the generated family of maps, tail families, and pointwise-weak closure
  semigroups.
- Finite simultaneous norm approximation and the compact-semigroup
  idempotent anchor, including the closed-convex-hull tail property.
- Legal adaptive selections for thresholds depending on all previous
  choices; termination and convex return are proved, not assumed.
- Compact parameter spaces of earlier-candidate weights, weak limits of
  **already evaluated** predictions, their norm-Lipschitz dependence on
  the parameters, and the simultaneous compact detectors.
- Finite parent groups, retained positive coefficients, injective global
  candidate numbering, and a recursively constructed infinite frontier
  tower with the required order, maps, functionals and limits.

Relevant source files include `Resolvents.lean`, `GeneratedMaps.lean`,
`CompactMapSemigroup.lean`, `Anchor.lean`, `AdaptiveSelection.lean`,
`CandidateSelection.lean`, `CandidatePredictions.lean`,
`CandidateDetectors.lean`, `FrontierTower.lean`, and `TreeProducer.lean`.
`exists_switchingTreeData D` derives existence from `D` alone;
`tree_construction` chooses this derived record and transports it.

The producer closure does not import the upstream final fixed-point,
normalized-contradiction or branch-contradiction modules. The new
`inputsOfTree` and `tree_construction` do not invoke either reviewed
switching contradiction or the new `normalized_contradiction`. Ordinary
local contradictions proving order/injectivity facts are not a
fixed-point contradiction used to manufacture the tree.

## Original-norm difference-space transport

Let `Y = differenceSpan D.K = closure(span(K-K))`, with its inherited
subspace norm, and take `a` to be the constructed anchor. `DifferenceSpace`
proves that

```text
K' = {y : Y | (y : X) + a belongs to K},
e : K <-> K',  e(x) = x-a
```

is an affine, distance-preserving equivalence. There is no renorming.
Convexity, finite convex averages and point differences are preserved.
The map attached to a node is conjugated as `e o G o e^{-1}`, rather
than being distributed over a convex combination. Functionals are
restricted to `Y`; their norms do not increase and

```text
(f restricted to Y)(e(x)-e(y)) = f(x-y).
```

`tendsto_shiftEquiv_weak` proves passage of weak limits through this
**affine translation**, using the actual Hahn--Banach extension of
subspace functionals. It does not claim weak continuity of any nonlinear
node map. `normalized_shifted_dense_differences_span` proves that pairwise
differences of `e(z_i)` have dense linear span in `Y`.
`normalized_intrinsicWeakUnitBall_compact` derives compactness of the
intrinsic weak unit ball of `Y` from the supplied ambient weak compactness,
using the proved identification of the subspace weak topology.

The ambient space passed to the reviewed switching theorem is therefore
`Y`, not the original `X`. This is what makes its dense-span and unit-ball
compactness hypotheses valid, even when `span(K-K)` is not dense in `X`.

## Every argument of the reviewed bridge

`ManuscriptInputs D` spells out all the arguments of
`research/switching_bridge/Main.lean:1171-1196`, in the same mathematical
order. `inputsOfTree` supplies all its fields:

| Bridge input | Actual construction and identification |
|---|---|
| Ordered tree, descendant blocks, weights | `planeTree` uses the produced monotone surjective parent maps and their interval lemmas. Child weights are positive and sum to one. The total ancestor function has arbitrary values only for `i > n`, outside every ancestor law used by the theorem. |
| Convex set and actual nonexpansive evaluation | `bridgeEvaluation` on `K'` uses conjugated maps and the translated anchor. `average_shift`, `collapse_shift`, and `rootOutput_shift` identify the complete nonlinear evaluations. |
| Nonnegative budgets, positive away from the root, root budget zero | `A.budget`; nonroot values are `2^(-label(v)-9)` with injective candidate labels. |
| Exact tolerance schedule | `tolerance_eq_manuscript` proves equality, not just comparable decay, with `tau_0=1/2` and `tau_k=2^(-k-1)` times the minimum over levels 1 through k. The producer's initial minimum with 1 is redundant because every candidate budget is at most 1. |
| Child-average tolerance | The produced child-average law, affine-average identification and the above exact schedule equality. |
| Sum of proper-ancestor displacements | `pathDisplacement_plane` identifies the recursive producer displacement with the bridge's range sum; isometry transports each term. |
| Diameter at most one | Isometry and `D.norm_sub_le_one`. |
| Linear detectors of norm at most one | Restrictions of the produced continuous linear functionals, with the proved restriction bound. |
| One terminal sequence and proper cofinal filter | Translated resolvents `b_j=R_(j+1)(a)` and the produced free ultrafilter. |
| Every fixed map's terminal displacement tends to zero | `terminalSequence_generated_displacement_tendsto`, using that every produced map is generated. The same terminal sequence serves all nodes. |
| Weak limits of evaluated predictions | `prediction_shift` identifies the bridge cutoff evaluation with the already evaluated producer prediction, followed only by weakly continuous affine translation. |
| Detection of those weak limits | The produced prediction-detector inequalities and exact restriction identities. |
| Prefix budget sum at most 1/128 | `budget_prefix` reindexes each finite level prefix injectively into the global candidate labels. The stronger bound is 1/256. |
| Summability over all levels, including the root | `budget_summable` splits the index type into the finite root level and the summable nonroot budgets. |
| Dense test points and full dense difference span | The translated dense points and `normalized_shifted_dense_differences_span`. |
| Detection of every sufficiently early dense point | The produced dense-detector inequalities, preserved by restriction. |
| Weak compactness of the intrinsic original-norm unit ball | `normalized_intrinsicWeakUnitBall_compact`. |

The compact prediction sets cover all possible eventual retained sibling
weights before those weights are assigned. Deleted candidates retain their
history, and only after completing a group are zero weights discarded.
Thus neither the weights nor later nonlinear maps are anticipated in the
choice of a detector.

## Evidence and comparison with the prior result

The earlier accepted result was a conditional switching implication with
four explicitly unconstructed classes of inputs. This result supplies
those inputs from the precise normalized data and proves their composition
with that same reviewed implication. The reviewed source, fidelity
document and certificates remain unchanged; its existing independent
supports receipt is reused, not replaced by another review.

`verify.py` rebuilds the producer and transport modules, checks the reviewed
bridge snapshot, and obtains fresh official claim-bound Lean evidence for
`C_TREE_CONSTRUCTION` and `C_NORMALIZED_CONTRADICTION`. Both principal
declarations must have only `propext`, `Classical.choice`, and `Quot.sound`
as axioms. The source and this document must match the compiler record.

The Jacobian inverse-series requests are preserved with their typed
validation errors and are **non-conclusions**. A separate exact rational
replay checks the finite geometric-budget identity directly. That finite
diagnostic does not establish summability, the infinite tree, or the
fixed-point result; those obligations are proved in Lean.

No false manuscript assertion or explicit counterexample is claimed.
This is a formal verification of an attributed construction and its
normalized consequence. The novelty and publishability assessment against
the existing full upstream implementation remains open.
