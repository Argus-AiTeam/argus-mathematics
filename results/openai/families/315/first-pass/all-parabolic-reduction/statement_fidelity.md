# Statement fidelity: the all-parabolic reduction

## What is formally asserted

The namespace is `AllParabolicReduction`. All type parameters are arbitrary
and may be infinite. There is no finite enumeration assumption.

`SequentialChainComplete T` says that every monotone sequence indexed by
all natural numbers has a least upper bound in T. It does not merely say
that a bounded sequence has one. `SemilinearBelow T` says that any two
points with a common upper bound are comparable. The order is partial,
not assumed linear or a complete lattice.

`increasing_orbit_fixed` takes a partial order, this countable-chain
completeness, an order automorphism f, and x <= f(x). It proves the
existence of z >= x with f(z)=z, by taking a least upper bound of the
entire infinite orbit.

`fixed_above_meet` takes a meet semilattice, semilinearity below points,
the same completeness, an arbitrary order automorphism f and arbitrary y.
It proves that some fixed z lies above y meet f(y). Either f or its
inverse supplies the increasing orbit. Fixed-point existence is a
conclusion, not a hypothesis.

`second_fixed_point_outside` adds nonempty subsets U,V, forward invariance
of U, closure of U under meets, disjointness of U,V, and downward closure
of V. It proves that f has a fixed point outside V. It does not assume
that U is itself complete or that an infinite orbit has an endpoint in U.
Nor does it assert that the resulting fixed point belongs to U.

For the manuscript application, root Phi at its fixed facing point p:
a <= b means a belongs to [p,b], and a meet b is med(p,a,b).
An automorphism fixing p is an order automorphism. Fullness of U makes
it meet-closed; fullness of V and p in V make V downward closed.
Completeness and medianity of Phi imply the countable-chain condition
and semilinearity. The mathematical report proves this translation.
The compiler checks the intrinsic order theorem; it does not check
the construction of Bowditch's Phi from a topological continuum.

`facing_terminal_class_singleton` takes any set-valued interval operation,
disjoint U,V with U nonempty, p in V, p on every U-to-V interval, and
the explicit terminality property that membership of p in an interval
forces p to equal an endpoint. It proves V={p}. Terminality is a
hypothesis of this small theorem: in the manuscript application it must
be supplied separately by convergence dynamics after the two fixed
points are shown to be infinitely separated.

`finite_eventual_stage` has an arbitrary linearly ordered index set,
an index called limit, a finite family of obligations, monotonicity of
each obligation in the index, and a witness below limit for each
obligation. It proves that all obligations hold at one index below
limit. A separate hypothesis supplies at least one index below limit,
so even an empty generating family is handled without an illicit
maximum of the empty set.

`relationStabilizer` and `generators_fix_class` use an arbitrary group
acting on a type and an invariant equivalence relation R. They prove
that the elements carrying x into its R-class form a subgroup, and
that containing a generating set forces that subgroup to be the
whole group.

`no_first_fixed_at_limit` combines the preceding results. For an
arbitrary linearly indexed increasing family of invariant equivalence
relations, a finite generating set, and generator-wise witnesses below
limit, it gives one index below limit at which the whole group preserves
the class of x. In application the index order is the ordinals, and
the witnesses come from the union definition at a nonzero limit.
No regularity or countable-cofinality assumption on that ordinal is made.

`doubling_fixed_iff` proves, for every rational x, that 2*x=x exactly
when x=0. It is the algebraic part of the incomplete-ray boundary
example, not a refutation of the complete-pretree statement.

## What is not formally asserted

This file does not formalize the topological construction of Phi,
full-equivalence quotient construction, the convergence-action
classification, one-ended groups' tree fixed-point theorem, or the
whole ordinal induction and subsequent simplicial-tree construction.
Those are given a separate source-faithful mathematical proof and
remain subject to independent review. This formalization cannot by
itself certify the Singer conjecture, novelty, or publication significance.
