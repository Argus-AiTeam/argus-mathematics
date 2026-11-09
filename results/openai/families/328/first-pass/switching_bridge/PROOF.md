# The nonlinear switching implication

## Statement and scope

The target is the implication in OpenAI, *Fixed Points of Nonexpansive Maps
in Reflexive Banach Spaces* (staged September 24, 2026 version),
`build/sections/04-switching.tex`, Proposition `prop:finite-witness` and the
subsequent final contradiction. The inputs are exactly the ordered tree,
positive sibling weights, nonexpansive selfmaps, labels, budgets, tolerances,
and prediction sets of `03-tree.tex`, together with the common terminal
sequence of `02-anchor.tex`. The ambient norm is unchanged.

The existence of these inputs from a fixed-point-free map is a separate
obligation. In particular this work does not independently establish the
anchor, adaptive selection, compact-detector lemma, or the tree construction.
An implication conditional on these inputs is not a certification of the
whole fixed-point theorem. Official `openai/math` Nonexpansive sources are
attributed comparison material, not independent compiler evidence or a claim
of novelty.

## Exact input propositions

1. `03-tree.tex`, `prop:tree-data`: finite nonempty ordered levels, finite
   nonempty child lists, positive sibling weights summing to one, maps
   `G_v : K -> K` that are nonexpansive, labels `y_v = G_v(x)`, and root map
   equal to the identity. The set `K` is convex and has diameter one.
2. The same proposition, `eq:tree-budget`--`eq:tree-conditions`:
   positive budgets with total at most `1/128`; the stated tolerance
   schedule; child-label averages within the parent tolerance of `x`;
   total proper-ancestor displacement at `y_v` at most `e_v`; and
   norm-at-most-one linear detectors satisfying
   `f_v(y_v-z) >= 1-e_v` throughout `E_v`.
3. `03-tree.tex`, `eq:prediction-definition`, `eq:tree-detector-set`,
   `eq:prediction-cutoff`: the predictions are the actual nonlinear root
   evaluations of the ideal left-label/right-terminal cutoff. The weak
   limit of each such evaluated sequence belongs to the corresponding
   detector set. No weak continuity of any nonlinear map is asserted.
4. `02-anchor.tex`, `eq:terminal-sequence`--`eq:terminal-displacement`:
   every fixed finite family of maps has total displacement tending to
   zero at a common sequence `b_j`. A fixed free ultrafilter is used for
   the prediction limits.
5. `01-preliminaries.tex`, `lem:reduction`: the norm-closed span
   `Y = closure(span(K-K))` has weakly compact closed unit ball. Pairwise
   differences of the fixed dense test sequence span a dense subspace
   of `Y`.

These are mathematical hypotheses to be tracked, not independently proved
construction results.

## Proof

Fix a truncation of positive depth `N`. There are finitely many prediction detectors.
For each nonroot node, apply its functional to the weak ultrafilter limit
of the already evaluated prediction. The limit is at least `1-e_v`;
therefore the inequality with right side `1-2e_v` holds on an ultrafilter
member. Intersect these finitely many members with the cofinite condition
that the total map displacement is at most the smallest truncation budget.
This gives one terminal point `b` for all nodes. No limit is taken through a
nonlinear map.

For each integer cutoff, evaluate the actual tree with labels at leaves to
the left and `b` at leaves on or to the right. Consecutive cutoffs implement
right-to-left switching. Nonexpansiveness at each internal node bounds
output differences by the weighted sum of child differences. Iteration
gives the weighted root sensitivity estimate for arbitrary positive
weights, without a uniform positive lower bound.

An untouched subtree rooted at nonroot depth `k` differs from its label by at most
`sum_{d=k}^{N-1} tau_d`. The tolerance schedule bounds this by
`2^(-k) M_k`, hence by every budget at that level. A fully switched subtree
differs from `b` by at most the total truncation displacement: each internal
map contributes its displacement multiplied by a product of weights, at
most one.

For a node `v`, immediately before its descendant block switches, propagate
distance to `y_v` along its ancestor path. At a proper ancestor `p` the
off-path children contribute at most one times their total weight. These
contributions telescope to `1-W_v`. The untouched-subtree error contributes
at most `W_v e_v`, and the ancestor displacements at most `e_v`. Thus
`norm(U_v-y_v) <= 1-W_v+2e_v`.

Immediately after that block switches, the entire cutoff level is within
`e_v` of its ideal assignment: earlier blocks are untouched and all other
blocks are fully switched. Weighted root sensitivity and the exact
prediction-cutoff identity give
`norm(V_v-Q_v(b;theta^v)) <= e_v`. Consequently,

    f_v(U_v-V_v) >= (1-2e_v) - (1-W_v+2e_v) - e_v
                 = W_v-5e_v.

For a leaf `s`, set `d_s = (U_s-V_s)/W_s`. Both root outputs lie in `K`,
so their difference lies in `Y`; sensitivity gives `norm(d_s) <= 1`.
Consecutive actual root differences telescope over every descendant block.
Linearity is used only for the functionals and sums of these differences,
never for the tree maps. Hence

    0 <= sum_{s below v} W_s (1-f_v(d_s)) <= 5e_v.

Summing and interchanging finite sums yields total weighted path deficit at
most `5/128`. Every summand is nonnegative. Leaves with any path detector at
most `1/2` have total weight at most `5/64 < 1`. Some leaf therefore has
all path detectors strictly greater than `1/2` on its single vector `d_s`.

The feasible prefixes form a finitely branching tree with a node at every
depth. The usual finite-branching argument gives an infinite feasible
branch. Its finite intersections of closed detector half-balls are
nonempty, weakly closed, and nested in the weakly compact unit ball of `Y`.
Their intersection contains one vector detected at least `1/2` by every
functional on that branch.

Finally, for each fixed pair of dense test points and sufficiently deep
branch node, the two detector values against its label both belong to
`[1-e_v,1]`. Their difference has absolute value at most `e_v`. Summability
of the positive budgets implies that branch budgets tend to zero.
Linearity, density of the span of test-point differences, and the common
operator-norm bound extend this convergence to every vector of `Y`.
This contradicts detection of the common vector by at least `1/2`.

## Independent formal derivation

`Main.lean` implements the entire conditional implication independently in
Lean 4.31.0, with only Mathlib imported. Its principal declaration is
`SwitchingBridge.switching_bridge_from_manuscript`. The formal proof uses
a stronger attainable common terminal choice: every internal map has
displacement at most the smallest truncation budget divided by the
truncation depth.
This controls transmission by induction on remaining depth. It also
extracts the common branch and vector jointly by compactness of the weak
unit ball times the product of finite levels. Neither variation adds an
assumption to the manuscript.

The exact objects, quantifiers, original-norm difference-space translation,
and these two proof variations are explained in `STATEMENT_FIDELITY.md`.
`verify.py` replays the source-coordinate exact rational LP certificate
and obtains fresh official Lean evidence, including the axiom audit and
both campaign-local ledger checks. The recorded arithmetic bound `5/64`
is not a substitute for the Lean proof of its nonlinear premises.

No counterexample or false manuscript assertion has been established.
Independent statement-fidelity review and construction of the input data
remain separate obligations. A successful current `exact_certificate.json`
certifies this conditional core, not the campaign's final publishability
or novelty gate.

## Attributed official comparison

Primary source retrieval on November 5, 2026 located the actual official
implementation under
[`lean/OAI/Analysis/Nonexpansive/`](https://github.com/openai/math/tree/main/lean/OAI/Analysis/Nonexpansive).
The comparator-only link in `lean/docs/328.md` is not a description of all
the current source files.
`SwitchingTreeData.lean` contains `SwitchingTreeData`;
`SubtreeEvaluation.lean` defines `subtreeOutput` and its actual nonlinear
recurrence; `BlockEstimates.lean` contains `actual_block_detection`;
`TreeFiniteWitness.lean` contains `exists_finite_terminal`,
`finite_block_detection`, and `finite_witness`; and
`BranchContradiction.lean` contains `tree_finite_witnesses_contradiction`.
The inspected interfaces derive the central conclusions from constructed
tree data rather than postulating those conclusions as public main-theorem
hypotheses. The official `lean/lean-toolchain` reports Lean 4.34.1.

These are source-presence and signature observations only. That library was
not imported, compiled, ported, or treated as an independent proof here.
The local 4.31.0 source and the joint compactness/per-map-terminal derivation
above are separate evidence. No originality claim is inferred from this
comparison.
