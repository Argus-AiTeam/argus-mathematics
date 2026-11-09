# Field conjugation preserves the generic geometric fan

**Claim C9; retained independent judgement
`judgement-C9-571e6ead95aa` supports the current claim.** This is a
conditional reduction, not the component existence claim C10 and not a
counterexample to the campaign goal.

Let X and Y be distinct irreducible components of
Hilb^d(A^n_C), and suppose that an automorphism sigma of C fixing Q
sends X to Y. Coordinates x_1,...,x_n are fixed. Then X and Y have
nonempty dense opens, avoiding all other components, with the same
geometric Groebner fan in the convention of FJT Definition 2.8.

## Exact invariance, including non-monomial initial ideals

Apply sigma coefficientwise to polynomials, leaving every monomial
unchanged. For every real weight w and ideal I,

    sigma(in_w(I)) = in_w(sigma(I)).

Indeed, sigma preserves nonzero coefficients, hence the support of
every polynomial and the set of its terms of maximal w-weight. It also
preserves addition, multiplication, and generated ideals. Applying its
inverse gives equality rather than just containment.

Consequently

    in_u(I) = in_v(I)  iff  in_u(sigma(I)) = in_v(sigma(I)).

Thus the equivalence classes in the SAME real weight space agree.
Taking the classes meeting the strictly positive orthant, their
closures, and their faces preserves equality. This proves equality of
the full FJT geometric fans, not just a restriction, a labeled fan,
or a sampled set of monomial orders. No action on real weights is used.

## Constancy on an open of an entire component

Here is a finite construction of such an open for any irreducible
component X. Work on an affine open W of its reduced structure over
which the universal rank-d quotient bundle is trivial. Let

    T = {x^alpha : |alpha| <= d}.

The residue classes of T are columns of a finite matrix A of regular
functions on W. Over the function field K=C(X), consider every minor
of A. Discard the minors that are zero in K; let Delta be the product
of all the others (the empty product is 1). Then Delta is nonzero
in the integral coordinate ring of W, and W_Delta is nonempty. All
column-dependence data of A agree there with the generic data.

Why does this finite matrix suffice? For any monomial term order,
the d standard monomials of a colength-d ideal form a divisor-closed
set. A standard monomial of degree r has at least r+1 distinct
successive divisors. Therefore every standard monomial has degree
at most d-1, and every minimal generator of its initial ideal has
degree at most d.

There are only finitely many divisor-closed sets B of d monomials in
degree at most d-1. On W_Delta, each such set is either a quotient
basis everywhere or nowhere. For a basis B, the unique expressions
of the degree-at-most-d monomials in B have coefficients given by
ratios of minors. Their zero/nonzero pattern is constant on W_Delta.
In particular, every possible reduced Groebner basis has constant
support there.

More explicitly, for a fixed term order, a candidate B is the standard
basis precisely when, for every minimal generator m of the complement
monomial ideal, all nonzero terms in its B-expression are smaller
than m. If these conditions hold, division terminates and the resulting
monic relations have quotient basis B; dimension d proves their ideal
is the given ideal. Thus both the set of realized initial monomial
ideals and their reduced-basis supports are constant.

For a reduced Groebner basis with marked leading monomials m, the
closure of its full-dimensional weight class is described by the
inequalities

    w . (exponent(m) - exponent(t)) >= 0

for every nonzero tail monomial t. Only the supports enter these
inequalities. Such cones which meet the strictly positive orthant,
together with their faces, form the fan in question. Equivalently,
inside a cone the usual initial-basis description distinguishes
relative interiors of its faces by the tied supports. This includes
the non-monomial classes, not merely monomial initial ideals.

It follows that the entire FJT fan is constant on W_Delta.

## Simultaneous open and exclusion of intersections

Remove from W_Delta the intersections of X with all the other
irreducible components. There are finitely many components, and
each intersection is a proper closed subset of X, so the remaining
open U is nonempty and dense in X. Put V=sigma(U). This is a
nonempty dense open in Y and avoids all other components.

The preceding exact invariance gives a single fan F for every point
of U or V. The nonempty specialization condition is explicitly the
finite minor product Delta != 0, together with the complements of
component intersections. Its actual polynomials cannot be specialized
until the component data required by C10 are supplied.

## Scope

This proof reduces a generic fan collision to a different component
construction problem. It does not exhibit X, Y, n, or d. In particular,
an isolated pair of conjugate ideals on the same component, or a pair
of conjugate proper strata, would not complete it.

The fan convention is the definition in `ctx-generic-components`,
from Fukuda-Jensen-Thomas,
**arXiv:math/0509544v1**, Section 2 and Definition 2.8.
The cone and face-interior criterion used here is additionally
Propositions 2.6 and 2.16 of that version. The current C9 assumption
`fjt-reduced-basis-cones` is independently attributed by
`citation-fjt-reduced-basis-cones-1572a6d73d7e`. Its retained passage,
`research/literature/b614539191392da4e0cfad04c6f44f8b.json`,
includes Definition 2.8 as well as both propositions. Thus this
argument uses the directly read definition and cone criterion,
not C2, the eight-point classification, or the Salmon-Turnbull
criterion. The earlier passage also remains in
`research/sources/c6_followup/fjt_generic_cones_excerpt.txt`.
No claim of novelty or formal-kernel verification is made.
