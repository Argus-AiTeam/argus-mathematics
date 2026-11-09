# Statement fidelity: TangentBox algebraic core

This document describes `Main.lean`, namespace `TangentBox`, and claim
`C_ALG_CORE`. Its conclusions are algebraic theorems with unrestricted
quantifiers, not a formalization of complex manifolds or of Proposition
`prop:box`. The geometric theorem and the translations into these algebraic
statements are proved separately in `argument.md`; their correctness still
requires independent review.

The declaration names, all inside namespace `TangentBox`, are `cauchy_iff`,
`chart_covariance`, `complementary_killing`, `exceptional_killing`,
`causal_recurrence_unique`, `cauchySeq`, `cauchySeq_recurrence`,
`causal_cauchy_exists_unique`, `nonzero_kernel_of_dimension`,
`cancel_normal_factor`, `normal_derivative_factor`, `wedge_sign`,
`odd_sum`, `even_sum`, `reconstruction_bound_even`,
`reconstruction_bound_odd`, `filtration_bound`, `blowup_preimage`,
and `colength_drop`.

## Fields, modules, and projections

`TangentBox.cauchy_iff` quantifies over every commutative ring K, K-module V,
K-linear endomorphism P, and vectors du,dv. Its only hypothesis on P is
P composed with P equals P. It equates
dv=P(du) with the two conditions P(dv)=dv and P(du-dv)=0.
In the geometric application P=P2, du is the u-derivative, and dv the
v-derivative. The first source-factor derivative is du-dv; the second is
dv. Thus this statement encodes the correct factor orientation. It imposes
no finite-dimensionality or nonzero-derivative hypothesis.

`TangentBox.chart_covariance` uses the same ring, idempotent, and vectors satisfying
dv=P(du). For every two scalars a,b, it proves
P(a du+(b-a)dv)=b dv. This is the algebra in the source-change formula
u'=h(u), v'=h(u+v)-h(u), with a=1/h'(u), b=1/h'(u+v).
The scalar identity itself does not need a or b to be units. It therefore
applies directly to modules over holomorphic formal-series rings.
Identification of the scalars and the derivation transformation are
geometric steps, not assertions checked by Lean.

`TangentBox.complementary_killing` quantifies over every field and vector
space and two endomorphisms P,Q whose sum is the identity. If two nonzero
scalars annihilate P(v) and Q(v), it proves v=0. Idempotence is unnecessary
for this conclusion.

`TangentBox.exceptional_killing` specializes those nonzero scalars to
alpha*h and beta*k, with arbitrary positive natural numbers alpha,beta,
nonzero field elements h,k, and characteristic zero. It proves v=0 for
every vector satisfying the two resulting annihilation equations.
In geometry v=dF'(w), where w is tangent to an exceptional component, and
the equations result from normal-factor cancellation and wedge evaluation.
The theorem neither assumes nor proves that alpha or beta equals one, and
it does not assume F' is immersive.

## All orders of the formal coefficient recursion

`TangentBox.causal_recurrence_unique` quantifies over every
characteristic-zero field K, K-vector space V, and function
rhs: Nat -> (Nat -> V) -> V. The explicit `causal` hypothesis says rhs(n,f)
depends only on f(0),...,f(n). Any two sequences with the same initial
coefficient and satisfying (n+1) f(n+1)=rhs(n,f) for every n are equal.

`TangentBox.cauchySeq` is a well-founded recursive construction: start at
x0 and obtain coefficient n+1 by division by n+1, extending a previously
known finite prefix by zero only while evaluating rhs. This extension is
not a convergence assertion or a fallback for unspecified coefficients.
The causal hypothesis is precisely what makes the temporary extension
irrelevant.

`TangentBox.cauchySeq_recurrence` proves that this constructed sequence
satisfies the recurrence for every natural n when rhs is causal.
`TangentBox.causal_cauchy_exists_unique` combines construction and uniqueness:
there exists exactly one entire coefficient sequence with the given x0
and recurrence. No truncation bound occurs in this theorem.

For the geometric equation, V is the vector space of holomorphic
coordinate-function tuples on a diagonal disk and rhs(n,f) is the
coefficient of v^n in P2(F) times the u-derivative of F. Holomorphic Taylor
substitution and differentiation make this rhs causal. Those analytic
facts, the change of target coordinates, and the sheaf gluing are NOT
defined in this Lean file. The theorem supplies the unrestricted
recursion once those facts have been established.

## Reconstruction, cancellation, and surface termination

`TangentBox.nonzero_kernel_of_dimension` quantifies over every linear map
between finite-dimensional vector spaces over any field. If the dimension
of its target is strictly smaller than that of its source, there exists
a nonzero source vector sent to zero. This applies to the coordinate-pair
section map after the geometric filtration bound is proved.

`TangentBox.cancel_normal_factor` quantifies over every commutative domain
R and R-module M with no zero scalar divisors. For every nonzero r and
every natural n, r^n v=0 implies v=0. Smooth local rings and locally free
modules meet these hypotheses. Lean does not prove that the local rings
in the manuscript are domains or that the indicated sheaves are locally
free.

`TangentBox.normal_derivative_factor` proves for every field K, polynomial
h, and natural n that
derivative(X^(n+1)h)=X^n(C(n+1)h+X derivative(h)).
It is the polynomial model for the product rule at arbitrary positive
normal order. It is not a definition of derivatives of analytic functions.

`TangentBox.wedge_sign` proves the scalar equality
a(0*hz)-b(c*h+0*hr)=-(c*h*b), for every six field elements.
This fixes the dr-wedge-dz orientation at r=0 after cancellation.
Changing to the ordered pair (tangent,normal) changes the sign, but not
the vanishing conclusion.

`TangentBox.odd_sum` and `TangentBox.even_sum` prove, for every natural n,
the sums of 2k+1 and 2k+2 over 0<=k<=n are respectively
(n+1)^2 and (n+1)(n+2). Reversing the finite list yields the even-degree
and odd-degree section counts. Identification with sections of O(e) on
P1 is an analytic/geometric input proved in `argument.md`, not in Lean.

`TangentBox.reconstruction_bound_even` and
`TangentBox.reconstruction_bound_odd` prove for every natural q that
(5q+2)^2 < 2(4q+2)^2 and
(5q+4)(5q+5) < 2(4q+4)^2.
Writing d=2q or 2q+1 and choosing m=2d+1 gives the strict
coordinate-pair dimension surplus. In particular these are all-degree
theorems, not finite numerical observations.

`TangentBox.filtration_bound` concerns two arbitrary natural-valued
sequences D,b and arbitrary K. If D(K)=0 and
D(k)<=D(k+1)+b(k) for k<K, it proves D(0)<=sum(k<K)b(k).
Application to an infinite separated sheaf filtration requires first
proving stabilization at zero and finite-dimensionality from finite
successive quotients; those steps are in `argument.md`.

`TangentBox.blowup_preimage` proves, for every natural k,a,b with b<k,
(a+k-b)+b-k=a and (a+k-b)+b>=k.
These equalities check that x^(a+k-b)y^b is in m^k and transforms to
x^a z^b. Existence of a spanning set with b<k and the well-definedness
of the formal transform on an ideal quotient are separate proofs.

`TangentBox.colength_drop` quantifies over arbitrary natural
old,child,k. If k>0 and child+k(k+1)/2<=old, it proves child<old.
It formalizes strict descent once the surjective transform and the
colength identity supply that inequality. It does not formalize blowups,
Noetherian geometry, or the finite-branching tree argument.

## Deliberate exclusions

There is no axiom asserting integrability, Frobenius, projectivity,
rational connectedness, analytic convergence, formal algebraization,
resolution of indeterminacy, transport, or the geometric conclusion.
No geometric theorem is claimed to be kernel-certified by this file.
A successful Lean run certifies only the declarations described above,
paired with this unchanged reading of their statements.
