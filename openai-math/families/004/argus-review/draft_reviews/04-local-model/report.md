# Local finite/singular model and pairing

## Exact claim and source setting

Historical `CITS-LOCAL` v1 concerns the companion's `rd:local-model`,
not an arbitrary local representation. The reference is
`ring-determinants.tex`, local-model statement and its calculation,
October 7, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`.
The inert good primes have rational Frobenius lifts tending on the
2-adic representation to a specified complex conjugation J.
The coefficient action and tame relation are retained to a common
sufficient precision before passage to the target model.

For the retained coefficient module M the claimed free split model has

    H0=M;  H1=F+S=M+M;  H2=M,
    f(c)=c(gamma^2);  s(c)=c(sigma).

Here F is s=0 and S is f=0. Each plane condition retains H0 and
excludes H2. The strict condition is H0, and the relaxed condition
retains H0 and H1 but not H2; they are not the zero and full local
complexes. The pairing cross block is
`beta(x,y)=epsilon*<x,J*y>` with epsilon an integral unit and
the Weil form unimodular. The two plane conditions are self-complementary
under the local derived duality, and strict/relaxed are complementary.

## Decisive calculation and its limits

For the tame two-direction model, the finite-precision coefficients
include 1-q and binom(q,2). With b=2^a and q=1+2*b*k,

    1-q=-2*b*k;  binom(q,2)=b*k*q.

Both vanish modulo b, including the pure-tame term at 2. Thus one
cannot dismiss that term using an odd-prime division-by-two argument.
Under the required triviality of the retained action and the actual
local cochain comparison, the differentials are zero and the mixed
cup-product coefficients give the two transverse directions.

Conjugate transport is J on the finite direction and -J on the
tame direction. For a complex-conjugation involution on a symplectic
rank-two module, `J^t*Omega*J=-Omega`; transporting the Weil pairing
therefore gives the displayed cross form, not the untransported form.
In the explicit family of unit 07, J=diag(1,-1) and the cross block is

    Omega*J = [0,-1; -1,0].

It is unimodular even at 2. The **pure** plane blocks vanish by the
cochain calculation. This is stronger than observing skew symmetry:
at residue characteristic 2 that observation alone would not prove
the required isotropy or identify its null-homotopy.

Pairing H0 with H2 explains the otherwise easily missed degree-zero
condition: retaining H0 and omitting H2 is part of orthogonal
complementarity. Quotient triangles between strict, plane and relaxed
conditions then have precisely the degree-one plane as their quotient.
Discarding H0 changes those triangles and is not statement-faithful.

The old Python replay verifies the coefficient divisibilities and, in
one algebraic family, the full local pairing and integral duality
defect. The Lean matrix theorem verifies that family's identities.
Neither establishes the general comparison between arithmetic Galois
cochains and this split local model. In particular, vanishing
coefficients do not, on their own, prove that all comparison maps
or null-homotopies have the asserted values.

## Assessment

**Recommendation: support the local algebra with the retained action,
cochain and cup-product hypotheses; retain the arithmetic realization
boundary.** The source's convergent Frobenius/finite-precision setup
is essential. The calculation does not justify the same model for
an arbitrary representation, arbitrary prime, or an arbitrary pairing
chosen on isomorphic cohomology groups.

A complete arithmetic certification must supply the actual local
cochain comparison at the required precision, preserve the tame
orientation and the zero pure-plane homotopies, and transport the
retained H0/H2 duality through the same coefficient maps and limits.
Those are concrete realization obligations, assigned with the global
ones to unit 05. No contrary arithmetic example has been established.
The historical supports judgement is evidence of an earlier opinion,
not a replacement for these hypotheses or current independent review.
