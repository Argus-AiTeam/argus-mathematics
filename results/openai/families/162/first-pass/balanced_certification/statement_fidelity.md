# Statement fidelity: independent deterministic core, Lean 4.31.0

This document describes only `research/balanced_certification/Main.lean`.
It does not describe the separate native Lean 4.34.1 endpoint.

## Objects and quantifiers

`Audit162.PartiteHypergraph r n` has a finite *set* of functions
`Fin r -> Fin n`. Its vertices are pairs `(i,v)` in
`Fin r x Fin n`; the two coordinates are the part and its label.
`Covers` quantifies over every finite set of these vertices, not only
sets contained in one part. `Intersecting` requires a nonempty edge set
and a common coordinate for every pair of edges. `Nonisolated` requires
every pair `(i,v)` to occur. `HasCoverNumber k` requires an actual cover
of size k and a lower bound k for every cover.

`edgeGraph` maps a function to its set of coordinate/value pairs.
`edgeGraph_card` proves that this is an ordinary r-element vertex set.
`edgeGraph_injective` proves that distinct functions give distinct sets.
`ordinary_cover_iff` proves that hitting the ordinary set-hypergraph's
edges is equivalent to `Covers`. The parts `{i} x Fin n` are disjoint,
each has n vertices, and every edge contains exactly the pair `(i,e i)`
in part i, directly from `mem_edgeGraph`. Thus the functional encoding
does not replace ordinary hypergraph covers with a weaker notion.

`BlocksCover blocks C` means that every point x belongs to a block
whose label lies in C. The label type and point type in the budget
lemmas are arbitrary types with decidable equality; all point and
label sets appearing in their hypotheses are finite.

## Certified construction steps

`capacity_bound` proves the exact finite union bound
`|U| <= a + |T| m` when U is covered by a set Z of size at most a
and blocks indexed by T, each of size at most m.

`residual_coverage` proves that if labels C cover all points, and
labels F cover only points in Z on a residual set U, then
`U` is covered by Z and the restricted blocks from `C \ F`.
It does not assume that F and C are disjoint.

`occupancy_forces_label` formalizes the numerical forcing step in
construction.tex: `rho*q > 2*(1+B)`, at most `rho*q/4` outside
labels, and occupancy at least `rho*q` contradict omission of a
label whenever omission leaves capacity at most `1+B` from the
pencil and at most two points per outside label. The geometry
establishing those capacity hypotheses is not assumed proved by
this declaration. Natural q and B are cast into the real numbers.

`parallel_pencil_impossible` certifies the parallel case: q-3 forced
labels, eight residual points missed by those labels, and capacity
two per additional label are incompatible with a cover of size at
most q. Its exact hypothesis `|F|+3=q` avoids truncated subtraction.

`affine_pencil_impossible` certifies every finite-center budget case,
with `F subset C` and `|F|+b=q+1`. For b=0 the forced labels already
exceed q. For b=1 there are four residual points, at most three
precovered, and no additional label. For b=2 there are eight residual
points, at most two precovered, and capacity at most four for the
one remaining label. For b>=3 the stated local noncover condition
excludes all families of at most b-1 additional labels. That last
condition is an explicit hypothesis, matching the role of the
manuscript's local condition, not a purported proof of its probability.
The b=1 capacity three allows both a designated center and its two
cycle neighbors; the external-center subcase has the stronger bound
one and is included. `four_cycle_repair` exhausts the four positions:
two positions are in the same opposite-pair block or are consecutive.

`balanced_realization` quantifies over every natural q and finite
point type X, with q+1 partitions into q+1 nonempty blocks. It assumes
each pair of points shares some block, and assumes the block-cover
lower bound q+1. It concludes the existence of a finite intersecting
partite hypergraph with no isolated vertices and covering number
q+1. The proof constructs its edges from partition codes, proves
cover equivalence, and supplies the upper cover from a whole part.
The pencil budget declarations independently certify the indicated
load-bearing way to prove that lower bound. No claim is made here
that partition-code images of distinct *points* must be distinct;
duplicate codes coalesce in a finite set and cover equivalence is
proved without that unnecessary assumption.

## What this certificate does not prove

This is a universal deterministic construction-core verification,
not the asymptotic existence of the geometric data. It does not
certify the candidate, selection, deletion or local-probability
arguments; those belong to the full native theorem replay.
It does not establish a numerical prime threshold, the extension-field
theorem, novelty, or independent Reviewer acceptance. No mathematical
axiom beyond Lean/Mathlib's reported foundational axioms is introduced.
