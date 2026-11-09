# Statement fidelity: C_ROW_CORE

This document describes `research/row_maximal/Main.lean`. It does not
relabel its declarations as a formal proof of either measure-theoretic
maximal theorem or of an ergodic convergence theorem.

## Objects, hypotheses and quantifiers

`CatalogRows.state_support_local` quantifies over arbitrary types of
spatial points, support-cell labels, observation-cell labels and states.
The functions `support n` and `observe n` label cells; equality of
observation labels implies equality of current support labels, and
equality of next support labels implies equality of current observation
labels. These are exactly the two refinement directions in the source.
The initial state is spatially constant. The update at a point depends
only on its observation label and its previous state. For every natural
round and every pair of points in one support cell, their states agree.
No finiteness, geometric dyadic property or dimension bound is assumed.

`bucketStep` has a natural-number bucket and an accumulator in any
normed additive commutative group. Buckets are numbered from zero.
`T` is the inactive sentinel, not a bucket receiving further additions.
For an active bucket the current increment is added before a strict
norm-threshold test. A hit advances by one and resets the accumulator.
`bucketStep_mono`, `bucketStep_bound`, `bucketStep_residual`,
`bucketState_mono`, `bucketState_bound` and `bucketState_residual` prove
the corresponding chronology, cap and unfinished-remainder bounds.
The remainder bounds require a nonnegative real threshold. They do
not say the discarded original sum stays small after the sentinel.

`bucketState_support_local` specializes the first theorem to these
updates and observation-constant coefficient increments.
`whole_row_bucket` quantifies over an arbitrary row index type, a round
for every row and a representative point for every row. At every point
in the representative's support cell, its bucket equals the
representative's bucket. Thus selecting a bucket selects the whole
support cell of a row, not a spatial restriction of that row. Nonempty
dyadic support cells in the manuscript provide the representatives.
Catalog uniqueness supplies the observation-constant increments.

`completed_bucket_no_future` and `completed_prefix_identity` quantify
over an arbitrary finite row set, a natural-number time and owner for
each row, a monotone bucket chronology, and row values in any additive
commutative monoid. The compatibility hypothesis says that every
nonzero row value has its globally assigned owner equal to the bucket
at its time. The exact conclusion at every cutoff is:

    sum of rows at earlier times
      = sum of all rows in buckets strictly below the current bucket
        + sum of earlier rows in the current bucket.

In particular, no later nonzero row contaminates a completed bucket.
For the manuscript, apply this at a fixed spatial point; locality makes
rows outside their support zero, and `whole_row_bucket` supplies
compatibility. The finite proof is dimension-free and not an experiment
at any particular row count.

`disjoint_mask_energy` quantifies over any finite row set, any finite
bucket type, row values in any normed additive commutative group,
nonnegative real row budgets and an optional global bucket for each
row. `none` means omitted. Its hypothesis is the subset-sum Bessel
inequality for every subset of rows. Its conclusion bounds the sum of
squared norms of the disjoint bucket sums by the total row budget.
For the manuscript, the ambient group is the Hilbert space
`L2(R; H)`, the row value is the tested adjoint, and the budget is
`B^2 * ||c_nu||^2`. The adjoint of the original joint bounded operator
proves this subset inequality; it is not assumed for spatially cut
rows. That functional-analytic bridge is proved in the report, not
encoded in this Lean declaration.

`improved_constant` proves, for every real `L >= 6`, the strict
comparison between the squared constants
`81 + (324/49) L^2` and `(64/9)(9 + L^2)`.
The condition holds for the manuscript's `D >= 2`.

## What remains outside the compiler

The report proves the catalog frame inequalities, the connection of
the evolving accumulator to coefficient sums, the measurable-space
realization, binary-prefix estimate, Chebyshev and layer-cake steps,
and blockwise Abel summation and Hilbert duality. In particular, the
Lean declarations do not encode Lebesgue integration, Hilbert
adjoints, the catalog birth budget, logarithms, or the full conclusions
of `lem:row-maximal` and `lem:row-depth`. Their verification is a
mathematical proof subject to independent review. The certificate
attaches only to C_ROW_CORE, whose scope is the universal combinatorial
core, with the extra constant comparison explicitly identified here.

No external mathematical axiom, numeric enumeration, or fixed finite
model is introduced in this Lean source. Standard Lean/Mathlib
foundations are used; the printed axiom lists expose them.
