# Conditional ring-class descent

## Claim, hypotheses, and source version

This is the arithmetic application of abstract descent, not a second proof
of unit 02. Historical `CITS-DESCENT` has **four** versions: its natural
assertion persists while scalar, Heegner-relation and local-descent inputs
are made explicit. The unchanged assertion hash cannot certify an
unchanged assumption set. The latest claim must be assessed with all
three arithmetic inputs and the target-diagram obligation.

The source is the companion dated October 7, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`,
`ring-determinants.tex`, `rd:derivative`, with `rd:heegner-relations`
and the finite-stage target construction after `rl:finite-limits`.
For a fixed curve, modular parametrization and fixed bad local types,
the claim is the existence of **one nonzero integer L**, working for
every finite switched set I, such that the actual classes P_I satisfy

    f(P_(I union {l}))=0;   s(P_(I union {l}))=J*f(P_I),

and retain previously imposed singular conditions. The Selmer conditions
include Kummer at 2N, the specified full conditions, singular conditions
at I, and the unramified finite plane at a new derivative prime.
These are not identities for arbitrary collections of abstract classes.

The old argument additionally uses:

1. A fixed nonidentity scalar u*I in the 2-adic Tate image,
   u in 1+4*Z_2, with the needed group-level scope for the fixed curve.
2. Actual normalized CM points, integral trace and good-reduction
   relations for every translated derivative, with fixed cuspidal
   annihilator L0.
3. Connected unramified descent at each fixed bad local type and a
   uniform component-group annihilator C.
4. The actual finite-stage arithmetic contractions, transfers,
   dualities and compatible limits of unit 05.

These are obligations/hypotheses, not consequences of the Lean identities.

## What the uniform torsion argument really proves

Conditional on the scalar, let g act by u*I and let tau be rational
complex conjugation. For every allowed imaginary quadratic K, g^2
fixes K. In an abelian ring-class quotient over K, conjugation acts
by inversion, so

    z=g^2*tau*g^2*tau^-1

fixes the ring-class field H. On the Tate module it acts by u^4.
Consequently u^4-1 annihilates E(H)[2-infinity]. Since 1+4*Z_2
has no nontrivial torsion, e=val_2(u^4-1) is finite and fixed.
Thus h=2^e is independent of conductor and derivative support.
This deduction is sound once the stated scalar and ring-class
conjugation action are available; it does not prove scalar existence.

Inflation-restriction for the **whole** conductor extension has kernel
in H^1(G,M^H) and cokernel embedded in H^2(G,M^H). If h kills M^H,
it kills the coefficient cochains and hence both groups, regardless
of the order or number of factors of G. Unit 02 then supplies one
h^2-clearing. For twisted finite coefficients this requires the
character to be trivial over the upper field; the scalar argument
then gives the same annihilation directly on invariants. It is not
legitimate simply to commute arbitrary invariants with tensor products.

Together with the fixed arithmetic factors, the proposed initial
multiplier is L=L0*C*h^2. Applying h^2 separately at every prime would
give a different, nonuniform statement and is not the argument reviewed.

## Local switch identities and ambiguity

With X,Y denoting the lower and upper points after every other
derivative, the actual trace/reduction relations give, for
2^a*Q=L*X,

    f=(a_l*F-(l+1))*Q;  s=(a_l-(l+1)*F)*Q;
    F^2-a_l*F+l=0.

Unit 01 proves the exact operator comparison. Reducing a_l=0 at the
retained precision gives s=F*f, and the limiting F is J. The existence
and normalization of X,Y,Q and these formulas are arithmetic inputs;
the formal ring identity alone does not supply them.

The report does not merely discard descent ambiguity. For a descended
cocycle b and 2^a*Z=L*D_l*Y it uses
`U=(sigma-1)Z-b(sigma)` and the crossed-cocycle comparison to make U
upper-field rational. The point

    U0=L*((l+1)/2^a)*Y - L*(a_l/2^a)*X

is defined using **integer** quotients under the auxiliary-prime
congruences. It has the same 2^a-multiple as U. Hence U-U0 is
upper-field torsion killed by the fixed h. An arbitrary division point
in place of U0 would not establish this bound.

For the new finite coordinate, reduction of the derivative is
`l*(l+1)/2 * F*X`. Under l+1=2^(a+1)*k this equals
`2^a*(l*k*F*X)`. Provided this point and the coefficient module are
F^2-fixed at retained precision, the finite Kummer coordinate vanishes:
any two division points differ by torsion on which F^2-1 vanishes.
The extra power of 2 is a precision condition, not a new scalar per prime.

Projecting from a to m multiplies a discrepancy killed by 2^e by
2^(a-m); it disappears when a-m>=e. For **each finite** set of primes
one may choose a common sufficiently large precision. The proof does
not require, or establish, one finite precision for infinitely many
primes. Absorbing the other derivatives into X,Y is what preserves
previous singular conditions, conditional on their actual relations.

## Retrieved sources, gaps, and recommendation

The old source-reader note names Bogomolov, *Points of finite order on
an Abelian variety*, English translation (1981), alleged section 2,
Theorem 3 and paragraph 7. It reports access only to metadata/abstract,
not that proposition. A Lie-algebra scalar abstract is not by itself
the asserted group-level theorem or its CM scope. This review retains
that precise access limitation; it neither claims the proposition false
nor silently checks a DOI in place of its hypotheses.

The Heegner relations and connected Neron-model assertion are stated
as assumptions in the old package, without independent proofs of the
uniform arithmetic forms needed here. Howard's odd-prime comparison,
as described in the old source-reader note, cannot discharge a
coefficient-prime-2 global hypothesis. Unit 05 handles the remaining
target-diagram gap.

**Recommendation: conditional support, not unconditional certification
of CITS-DESCENT.** The whole-map h^2 argument is a genuine improvement
over per-prime clearing, and its conditional scalar deduction and
precision bookkeeping are coherent. The concrete unresolved tasks
are to establish the exact scalar theorem for the fixed curve, the
normalized trace/reduction relations for all translates, uniform local
descent, and the compatible arithmetic target maps. No hypothesis-complete
elliptic-curve counterexample is exhibited. These gaps are not a proof
that the manuscript is wrong.
