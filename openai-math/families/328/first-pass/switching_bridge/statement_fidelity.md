# Statement fidelity: the nonlinear switching bridge

## Target and principal declaration

Claim `C_SWITCHING_BRIDGE` concerns the conditional implication in the staged
September 24, 2026 OpenAI manuscript, `build/sections/04-switching.tex`,
Proposition `prop:finite-witness` and the final branch contradiction.
The principal declaration is
`SwitchingBridge.switching_bridge_from_manuscript` in `Main.lean`.
Its conclusion is `False` under the tree-data, prediction, terminal-sequence,
dense-detector, and weak-unit-ball-compactness hypotheses listed below.
It does not assume block detection, a finite witness, an infinite branch,
or pointwise vanishing.

This is a universal conditional verification theorem. It does not construct
these inputs from a fixed-point-free nonexpansive map. In particular it does
not certify the manuscript's anchor, adaptive selection, compact-detector
lemma, or tree producer, and does not by itself prove the main fixed-point
theorem. It makes no originality or literature-novelty claim.

## Ambient space and original norm

The coded `X` is a real normed vector space. To apply the theorem to the
manuscript, take the coded `X` to be its closed difference subspace
`Y = closure(span(K-K))`, with the inherited original norm. Translate the
manuscript's `K`, anchor, labels, terminal points, predictions, and maps by
minus its anchor so that the translated set lies in `Y`. Conjugation by
translation preserves the exact nonlinear evaluation rule, differences,
convexity, nonexpansiveness, and detector inequalities. Restrict each
functional to `Y`; its norm remains at most one. Test-point differences
and normalized root increments are unchanged by this translation.

No equivalent norm, strictly convex renorming, affine-map hypothesis, or
norm-compactness hypothesis is introduced. Completeness and reflexivity
are used here only through the weak compactness of the entire original-norm
closed unit ball, already an explicit conclusion of `01-preliminaries.tex`,
Lemma `lem:reduction`.

The argument assumes distances between points of the coded convex `K` are
at most one. The manuscript's diameter-one normalization supplies this.
The coded dense-span equality says that the closure of the linear span of
all pairwise differences of the fixed test sequence is all the coded `X`;
this is precisely the reason for using the manuscript's `Y`.

## Tree representation

`PlaneTree.Node k` is `Fin (count k)`, in its ordinary order.
Every count is positive and the root level has exactly one node.
`parent`, positive sibling coefficients `alpha`, and their parentwise sums
encode the finite nonempty ordered child lists of `03-tree.tex`.
`ancestor i n` is the canonical ancestor map for `i <= n`.
The self, composition, top-step, and bottom-step laws in the record describe
iteration of the parent map; they are structural tree laws, not detector
or analytic estimates.

The fields `lo k n v` and `hi k n v` are the endpoints of the consecutive
descendant block at terminal level `n`. The `before_cut` and `after_cut`
equivalences state, respectively, that a terminal index is below `hi`
exactly when its level-`k` ancestor is at or left of `v`, and below `lo`
exactly when that ancestor is strictly left of `v`. Their bounds keep the
interval inside the terminal level. These encode the ordered-tree block
description at the beginning of `04-switching.tex`. There is no lower
bound on sibling weights other than their individual strict positivity.

Path weights are defined recursively, not assumed as free estimates.
`sum_weight`, `weight_pos`, `weight_le_one`, `weighted_ancestor`, and
`block_mass` prove their normalization and descendant-mass identities.

## Exact nonlinear evaluation and orientation

`Evaluation.map k v : K -> K` is arbitrary and nonexpansive.
`average` forms the genuine sibling convex combination in `K`, and
`collapse` applies the actual map to that combination.
`eval h i` performs `h` such levels starting at depth `i`.
Its zero case returns the prescribed cutoff value, so the cutoff's own
map is not reapplied.

The map at the manuscript's root is the identity. The formal theorem
allows even a general nonexpansive root satisfying the same path
displacement bound, so it applies in particular to that identity root.
This relaxation is not an extra hypothesis on the manuscript.

`leafFamily t b` uses the label at indices strictly below `t` and the
common point `b` elsewhere. Starting at the number of terminal leaves
and decreasing `t` switches leaves right to left.
`switchVector n s b` is exactly

    weight(n,s)^(-1) * (root(s+1) - root(s)).

It is the before-minus-after increment, with the original norm.
`beforeBlock` and `afterBlock` evaluate the same actual tree with the
corresponding ancestor cutoffs; their equality with the endpoint root
states is proved. `block_telescope` sums consecutive actual root
differences. It does not expand a nonlinear map over a convex sum.

`root_sensitivity`, `eval_congr_descendants`, `label_error`,
`constant_error`, `before_block_error`, and `after_block_error` derive
the required sensitivity and subtree bounds from these evaluations.

## Budgets, tolerances, and terminal choice

The raw principal theorem assumes positive nonroot budgets, extended by
zero at the root, summability, and the bound `1/128` on every finite
truncation's sum. These are the manuscript's global positive summable
budget condition, expressed with finite levels and a zero root term.

`PlaneTree.manuscriptTolerance` is exactly `tau_0 = 1/2` and, for positive
`k`, `(1/2)^(k+1)` times the minimum nonroot budget at depths one through
`k`. `manuscriptTolerance_le` proves its comparison with each earlier
budget. `Evaluation.Bounds.fromManuscript` supplies the exact child-average
and proper-ancestor path displacement hypotheses of `prop:tree-data`.
It does not supply or assume any block-detection conclusion.

The terminal sequence has vanishing displacement under every fixed tree
map, as in `02-anchor.tex`, `eq:terminal-displacement`. A proper filter
finer than `atTop` is sufficient in the formal theorem; the manuscript's
fixed free ultrafilter is such a filter. Zero-based sequence indices are
only a reindexing of its positive-integer sequence.

The proof makes a legitimate stronger finite choice than the manuscript:
for a depth `N > 0`, let `m` be the smallest truncation budget, and choose
one terminal index at which *every internal map* has displacement at
most `m/N`, simultaneously with all prediction detector inequalities.
Finite intersection and the given displacement limits prove this choice.
`constant_error` accumulates at most one such error per depth, so every
transmitted subtree has error at most `m`. This replaces the manuscript's
use of the sum of all map displacements by an explicitly proved common
per-map choice. It adds no terminal-sequence assumption.

## Predictions and weak limits

`Evaluation.prediction k v b` is the actual root evaluation at cutoff `k`
with labels strictly left of `v` and `b` at `v` and to its right.
The manuscript identifies this with `Q_v(b;theta^v)` in
`eq:prediction-cutoff`.

The raw theorem assumes weak convergence of these already evaluated
predictions to `q k v`, and the corresponding detector inequality
`f_v(y_v-q_v) >= 1-e_v`. Membership of the manuscript's `q_v` in `E_v`
supplies that inequality. `detector_limit_from_weak` proves the scalar
convergence from continuity of the linear functional in `WeakSpace`;
`TerminalData.fromWeakPredictions` constructs the scalar interface used
by `common_terminal`. No nonlinear map is assumed weakly continuous.

## Conclusions proved inside the implication

`Evaluation.block_detection` derives the exact lower bound
`W_v - 5 e_v` for each actual block increment from the before/after
errors and terminal detection.
`switchVector_norm` proves that every normalized leaf increment lies
in the entire original-norm unit ball. `deficit_nonneg` proves
nonnegativity of each detector deficit.
`block_deficit` and `total_deficit` derive the total weighted path deficit
bound `5/128` by telescoping and interchanging finite sums.

The internal helper `finite_witness` takes block detection as an argument.
This is not a premise of the principal theorem:
`finite_witness_from_inputs` first proves block detection from the actual
tree inputs, and then calls that helper. It yields one actual normalized
leaf increment on which all its positive-depth path detectors are
strictly greater than `1/2`.

`finite_witnesses_to_common_branch` proves existence of one compatible
infinite branch and one vector in the closed unit ball detected at least
`1/2` at every positive depth. It uses compactness of the weak unit ball
times the product of the finite levels. Closed compatibility and detector
constraints have the finite intersection property by the proved finite
witnesses. This is a joint compactness proof of the manuscript's
finite-branching and nested-half-ball steps.

`pointwise_null_detectors` derives convergence to zero on every vector of
the coded `X`. The budgets along a branch form an injective subsequence
of the summable node budgets. Dense test-pair evaluations tend to zero;
`vanishing_on_closed_span` proves the extension using linearity, density,
and the uniform operator-norm bound. The common vector then gives the
final contradiction.

## Trust and review boundary

The only import is Mathlib from the prebuilt Lean 4.31.0 workspace.
The source contains no asserted axiom, proof hole, oracle result,
import of the official Nonexpansive implementation, or unproved
block/witness premise in its principal theorem. The printed dependencies
of `switching_bridge_from_manuscript` are the standard Lean axioms
`propext`, `Classical.choice`, and `Quot.sound`.

Compilation checks this encoded conditional theorem. The identification of
its objects and explicit hypotheses with the manuscript, as explained
above, remains a statement-fidelity judgement for the independent Reviewer.
Neither compiler success nor the separate exact rational LP replay is an
independent review, a novelty check, or a certification of the input
construction.
