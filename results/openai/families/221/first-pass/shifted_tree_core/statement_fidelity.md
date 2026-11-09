# Statement fidelity: ShiftedTree

The source is `Main.lean`, namespace `ShiftedTree`, intended for Lean 4.31.0
with the installed Mathlib. All declarations are universal theorems; no
bounded enumeration, evaluator oracle, additional axiom, or unfinished proof
is part of this source.

## Actual trees and coefficients

`Tree` is an arbitrary finite rooted tree. Its node constructor has an
arbitrary natural child count and a child for every index in `Fin arity`;
there is no binary or fixed-arity restriction. A leaf's Boolean marks it as
protected (`true`) or eligible old (`false`). Unary vertices are present.
`Full L d t` requires every leaf below the depth-d root to end at L and
every internal vertex to have a positive child count and depth less than L.
Thus invalid empty internal trees are excluded whenever full-tree theorems
use them. `unused t` means no leaf is protected.

`freshSigned m d t` recursively sums the manuscript's coefficient
`m d - arity * m (d+1)` over every internal vertex. `oldLeaves` counts
exactly the unprotected leaves, and `choiceSigned` adds one for each such
leaf to the full internal sum. `freshAbsolute` sums the absolute values of
the same internal coefficients. Depth indices refer to vertices, not
sampled values; coincident values never merge vertices.

`full_fresh_signed` assumes only `Full L d t` and `m L = 1`, and proves
that the internal signed sum is `m d - leaves t`. `reference_free_total`
additionally assumes `unused t` and proves that every old or fresh choice
in the subtree sums to `m d`. `reference_total` considers arbitrary n
children rooted at d+1, an arbitrary finite subset `refs` of excluded
child indices, fullness of all children, and the hypothesis that all
nonexcluded children are unused. It proves the exact allowed row sum
`m d - refs.card * m (d+1)`. It neither counts reference leaves in place
of reference-containing children nor excludes old-leaf choices.

`fresh_absolute` assumes that all m values are nonnegative, that m is
nondecreasing up to L, and that `m L = 1`. It proves that the internal
absolute sum is `leaves t - m d`. `unrestricted_absolute_le` additionally
uses `m 0 = 0` and a full tree rooted at zero to bound the complete
eligible-old-plus-fresh row by twice the leaf count. The uniform mesh
`m i = i/L` meets all these assumptions when L is positive.

`unaryAt r t` counts unary internal vertices at relative depth r, not
distinct depth coordinates or equivalence classes of vertices.
`leaves_positive`, `unaryAt_le`, and `charged_row_le` hold for all full
trees. The last theorem bounds the sum of delta over all unary vertices
at depths in an arbitrary finite set D by `D.card * leaves t * delta`,
assuming delta is nonnegative. It does not impose distinct vertex depths.

## Arbitrary finite extension histories

`History k` is an arbitrary finite, k-step weighted decision tree; each
node may have a different arbitrary finite number of allowed choices.
Zero-choice nodes represent dead prefixes. Its edge weights are real
and its edge marks are Boolean. `mass` sums the product of edge weights
over complete histories. In the signed calculation weights are the
literal extension coefficients; in the absolute calculation they are
their absolute values.

`iterated_reference_product` assumes `constantRows`: at each node, the
sum of allowed weights equals the prescribed factor for that step,
independently of the preceding history. It proves that total mass is the
product of all step factors. The actual row identity is separately proved
by `reference_total` for the tree choices above. Identifying which row
of a prescribed reference tree occurs at each step is explained in
`proof.md`, Section 1, rather than encoded as a tree-update function.

`charging_history_bound` assumes `0 < delta <= 1`, `0 <= C`,
nonnegative edge weights, `boundedRows` (every row, after dividing marked
weights by delta, has sum at most C), and `enoughCharges` (each completed
history has at least b marked edges). It proves
`mass <= C^k * delta^b`. It does NOT assume this desired mass bound.
`charge_power` handles both b=0 and the marked/unmarked exponent step.
`normalized_row_bound` converts an unmarked row bound `U <= 2*s` and
marked row bound `M <= t*s*delta` into the rescaled bound `(2+t)*s`.

The manuscript application takes s here at most q+k, marks unary
divergences at specified depths, and uses `charged_row_le` with at most
k distinct specified depths. Its rescaled constant is
`C = (2+k)*(q+k)`. The fact that every required branching vertex is
created at a distinct unary-divergence step, and that the actual extension
operation preserves fullness and adds at most one leaf, are proved in
`proof.md`, Section 4, not encoded as transition constructors in `History`.
The formal bound has a coarser size-dependent constant than the stronger
assignment-counting bound also proved there.

## Retention and normalization

`retained_class_factor` is factorization of a finite real weighted sum
when the retained expectation is constant on the class.
`prune_normalized_kernel` works for an arbitrary retained-state type and
an arbitrary finite deleted-state type, with prefix-dependent normalized
weights. It proves deletion of an unused child leaves the retained
observable unchanged. Nonnegative probability kernels are a special case.
Pruning general measurable probability kernels and establishing the
retained coordinate identifications are the explicit arguments in
`proof.md`, Section 3, not a formal measure-theoretic theorem.

`prefix_class_coefficients` proves the residual old-prefix coefficient
from the fresh-prefix coefficients and the total signed coefficient,
with r the number e-d-1 of strictly intermediate stem depths; hence
e=d+r+1. The proof in `proof.md`, Section 2, also derives the old-prefix
coefficient directly by subtree cancellation.

`branchFactor delta x extra` is the full branching-vertex product for
arity `extra+2`: its first factor is `-delta`, and all subsequent factors
are `x - (j+2)*(x+delta)` with j ranging from zero to extra-1.
`multiway_factor_lower` and `branch_factor_bound` assume positive delta
and eta and `eta <= x`, and bound the absolute vertex product below by
`delta * eta^extra`. `full_denominator_bound` ranges over an arbitrary
finite vertex type V and arbitrary functions x and extra. It proves
the product lower bound `delta^card(V) * product(eta^extra)`.
There is deliberately no injectivity assumption on x: aligned copies
and repeated depths at distinct vertices are included.

`normalized_absolute_bound` combines `A <= C*D` and `D*B <= abs(J)`
with D and B positive and C nonnegative to prove `A/abs(J) <= C/B`.
The application has `D=delta^(2*b(S))`,
`B=product(eta^(arity-2))` over both target copies, and the preceding
history bound as C.

## Exact absolute mass and the one-old-leaf normal form

`Move State` is a shape-state transformation and a state-dependent real
coefficient. `evaluate` composes a finite ordered list of these moves and
multiplies their coefficients at the states where they occur.
`stationaryOld` is the identity state transformation of coefficient one.
`commute_old_selection` proves that deleting this move anywhere in the
list leaves the final state and coefficient unchanged, for arbitrary
state types and arbitrary surrounding moves. Applying this to a selected
old leaf uses the *uncolored shape* as state; it does not assert that
protection flags are unchanged.

`absolute_from_reuse_normal_form` has an arbitrary finite history type H,
real coefficients c, a finite subset P, a nonnegative K, and a real T.
Its hypotheses are exactly: c is K on P, c is nonpositive off P, and the
signed sum is T*K. It proves that the absolute sum is
`(2*P.card - T)*K`. `reference_free_exact_absolute` specializes
`P.card=q*r` to obtain `(2*q*r-x)*K`. For the arbitrary-mesh theorem
in the prose proof, first multiply all coefficients by the sign of kappa,
take K=abs(kappa), and x=m_u.

`shifted_exact_absolute` assumes J positive, `P.card=s*s`, coefficient
J on P, nonpositive coefficients off P, and signed sum `-delta*J`.
It proves the normalized absolute sum is **exactly** `2*s^2+delta`,
not just an upper bound. It has no interior-depth or eta hypothesis.
`uniform_fresh_negative` proves strict negativity of every uniform-mesh
fresh coefficient for positive delta, natural depth d, and positive
child count n.

The correspondence between P and the old-II-leaf / target-II-color pairs
is proved geometrically in `proof.md`, Section 6: disjoint old and target
branching depth sets permit at most one old selection; after commuting
that selection to the start, anchored rigidity gives one history and
its full kappa coefficient. Neither this graph-theoretic bijection nor
its cardinality is silently claimed to be a Lean theorem about a
fully encoded manuscript state-transition system. They are the explicit
prose inputs to the checked normal-form algebra.

## Certification boundary

The compiler checks precisely these combinatorial, finite-sum, and
normalization declarations, including their stated hypotheses.
It does not check this document, the prose assembly into the universal
retained-kernel theorem, the encoding fidelity of the Python enumerator,
the manuscript's probabilistic perturbation identities, any asymptotic
limit, originality, or publishable significance. Those are not silently
promoted to kernel-certified conclusions.
