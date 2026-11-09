# All discrepancy-two places and distinct global primes

**Assessment: the bijection is supported as a prose argument under the
specified resolution hypotheses.** The surface-extraction application
additionally uses the standard terminal-codimension-two input assessed
separately in Appendix A.

## Exact statement and dependencies

This is CP_GLOBAL version 1, A07 Theorem B and Section 4.
Y is a normal irreducible compact complex analytic fourfold with locally
ordinary terminal singularities and Q-Cartier canonical sheaf. Keep the
specified projective resolution g, smooth source, isomorphism over Yreg,
SNC exceptional divisor, and

    I_Sing(Y) O_Ytilde = O_Ytilde(-E_sing),
    Supp(E_sing) = g^{-1}(Sing(Y)).

After the stated finite puncturing of T, require the smooth connected-fiber
Stein factorizations E|T0->That_E^0->T0. If B is connected and
pi_1(B)->pi_1(T0) is surjective, and B is the closed intersection with T
of an ambient U_B, restriction is a bijection between all global log-
discrepancy-two places centered at T and all local such places centered
at B. A global place is a prime on a proper bimeromorphic model of the
whole Y modulo common-model strict transform, not just a local branch.

The bijection itself does not use small factorialization, the degree map,
or finite monodromy of W. It is a proposed strengthening of the bound's
global-prime injection. Its novelty has not been checked.

## Why every place is on this fixed resolution

Use the intrinsic relative canonical divisor
K_Ytilde/Y=sum kappa_E E. Terminality gives kappa_E=a(E;Y,0)-1>0.
It can be defined by a meromorphic pluricanonical comparison without an
actual global canonical divisor on compact Y.

Suppose a local place v centered at B is exceptional over g^{-1}U_B.
Its center exists there by properness/common-model comparison.
Smoothness gives a(v;g^{-1}U_B,0)>=2. The principalized full singular
preimage puts its center in at least one exceptional E, so ord_v(E)>0;
all other orders are nonnegative. Hence

    a(v;U_B,0)
      = a(v;g^{-1}U_B,0) + sum kappa_E ord_v(E) > 2.

This contradicts a(v)=2. Thus v is a prime on g^{-1}U_B. Being centered
at B makes it a component of a restriction of a global exceptional prime.
On a nonempty open of that irreducible prime the image has dimension one;
generic rank and proper irreducible image then show the global image is
exactly T, not a larger center inferred from a germ. The discrepancy
coefficient is unchanged under restriction. The identical argument for
a global place centered at T puts it on g. There are finitely many such
primes because this is one proper resolution over compact Y.

The full singular-support hypothesis is essential to this proof of
strictness: without it the positive-order term has not been justified.
The proof is not an assertion about an arbitrary resolution.

## Why one global prime does not split on the core

Each global E dominating T is smooth and irreducible by the SNC condition.
Its proper Stein factor is a normal irreducible compact curve finite over T.
Generic smoothness and finite branching permit simultaneous finite
puncturing for the finite list of E's. The cover That_E^0->T0 is connected
and finite etale. Its monodromy action on a fiber is transitive.

Surjectivity of pi_1(B)->pi_1(T0) preserves that transitive permutation
image. Thus That_E^0|B is connected. The inverse image E|B is a smooth
proper family with connected fibers over that connected cover, hence is
connected; a connected complex manifold is irreducible. Therefore each
global E gives exactly one local prime. Distinct global E cannot give the
same local prime because a common nonempty open would identify the global
irreducible divisors. Combined with representation of all places on g,
this proves surjectivity and uniqueness in both directions.

This is the step that a simply connected disc would lose. It does not
deduce equality of global divisors from equality of abstract meromorphic
function-field valuations.

## Application to the surface families

For each S_alpha on the crepant small terminal model, standard smoothness
in codimension two makes its general point smooth in the ambient fourfold.
Blow up its coherent ideal and normalize. Above the dense smooth
codimension-two part, there is one prime with relative canonical
coefficient one, hence log discrepancy two. Its closure defines a local
place centered at B. Crepancy transfers the discrepancy to U_B.
Different S_alpha have different centers on Y', so these local places
are different. The bijection now gives different global primes on g.

The codimension-two input in this last paragraph is explicitly external
unless the slicing bridge in the [appendix assessment](../terminal-appendix/report.md)
is supplied. It is not needed for the preceding all-places bijection.

## Evidence boundary

A07 Section 4 supplies the geometric argument. The local smooth-discrepancy
bound, canonical composition, proper Stein factorization and covering-space
theory are standard inputs. The fixed resolution and finite-cover
conditions also match October 7 `05-branch-topology.tex:294-305,571-590`.
A04/A29's 624 rational sign instances and permutation controls are useful
checks of signs and branch-counting logic, not proofs of these analytic
facts. No concrete defect was found in the representation or transitivity
arguments under their exact hypotheses. Native independent review and any
novelty determination remain outstanding.
