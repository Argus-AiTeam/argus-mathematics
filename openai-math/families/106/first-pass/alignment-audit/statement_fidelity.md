# Fidelity of `Main.lean`

This source proves the **three-layer special case**, not the full
`lem:alignment` for arbitrary \(s\). Its ledger target is
`A_THREE_UPPER`, not `A_ALIGNMENT` or `A_THREE_SHARP`.

All indices are natural numbers. The manuscript's \([r]\) is renamed
as `Finset.range r`; this changes no order or separation condition.
The label type `M : Type u` is arbitrary: it need not be finite,
countable, inhabited, or equipped with a computable equality test.
Lists are finite sets `A I`. Values at empty sets, at sets larger than
three, or outside the ambient interval are irrelevant.

`Aligned A B` means there is one function `a : M -> Nat` whose values
all lie in `B` and which sends every label in `A I` into `I`, for every
nonempty `I` contained in `B`. Thus labels absent from all relevant lists
are also mapped into `B`, exactly as in the manuscript. `RootFor A B x`
means that the intersection of the occurrence sets of the label `x`
inside `B` contains a point. `aligned_iff_roots` proves the equivalence;
it does not assume that equivalence.

`SeparatedOn A U` is the manuscript's separation hypothesis on nonempty
subsets of `U` of size at most three. It uses
`forall i in I, forall j in J, i < j`, which for nonempty finite sets
is precisely `max I < min J`. No separation is imposed on overlapping
or merely disjoint nonseparated sets.

`bad_triple_witness` proves that failure on `{lo,mid,hi}`, where
`lo < mid < hi`, supplies a label on `A {lo,hi}` with both a left
occurrence contained in `{lo,mid}` and a right occurrence contained in
`{mid,hi}`. `witness_middle_unique` proves that the same label cannot
witness two distinct middle indices. Their proofs use separation only
on the admissible finite lists.

`card_badMiddles_le` quantifies over an arbitrary finite collection `W`
of middle indices strictly between fixed endpoints, with every sampled
triple inside `U`. It proves

    card {mid in W : not Aligned A {lo,mid,hi}}
      <= card (A {lo,hi}).

This is stronger than assuming all list sizes are bounded by `d`;
only the endpoint-pair list needs that bound.

`uniformMass W mid` is the rational number `1 / card W` on `W` and zero
elsewhere. `uniformMass_nonneg` and `sum_uniformMass` prove its
nonnegativity and normalization when `W` is nonempty.
`triple_card` and `triple_injective_on` show that the increasing triples
are distinct three-element sampling outcomes, so pushing this law
forward to triples gives a rational probability distribution.

`rationalBadMass` is the rational bad-count divided by `card W`.
`rationalBadMass_eq_expectation` identifies it with the expectation
of the failure indicator under the normalized rational law.
`rationalBadMass_le` bounds it by `d / card W`.

The principal declaration `three_rational_sampler` says:

    forall d : Nat, forall eta : Real, 0 < eta ->
      exists N : Nat, 0 < N and
        forall M : Type u, forall A,
          SeparatedOn A (range (N+2)) ->
          card (A {0,N+1}) <= d ->
          rationalBadMass A 0 (N+1) (Icc 1 N) < eta.

The existential `N` occurs **before** the universally quantified label
type and lists. Set `r=N+2` and sample
`B={0,mid,N+1}` uniformly over `1 <= mid <= N`. The preceding
declarations give a finite rational distribution independent of `M`
and `A`. This proves the claimed three-layer special case for every
`d` and every positive real tolerance, not just finitely tested inputs.

The file does **not** prove the lower bound in the sharp minimax
formula, the four-layer uniform-sampling obstruction, finite minimax,
Ramsey extraction, the invariant-cut limit argument, or alignment for
`s >= 4`. Those assertions must not inherit this compiler result.
There are no project-defined axioms or imported manuscript claims.
The only library dependencies are Mathlib's ordinary finite-set,
classical-choice, rational/real arithmetic, and Archimedean results.
