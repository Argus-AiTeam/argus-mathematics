# The compact Kahler curve bound

**Assessment: supported as a conditional analytic proof of the stated
bound, not as a finite or kernel verification.** This reviews CP_BOUND
versions 1-2, A07 Theorem A in its original Kahler scope, and the shared
argument behind it.

## Exact claim and source version

Y is a normal irreducible compact Kahler complex fourfold with ordinary
terminal singularities. The canonical sheaf is Q-Cartier. The **specified**
globally projective resolution g has smooth source, is an isomorphism over
Yreg, has SNC exceptional divisor, and principalizes the singular ideal
with support the full inverse image of Sing(Y). T is an irreducible
singular curve. On a connected smooth finite-punctured T0, the relevant
direct images are local systems. With

    W=(R^2g_*Q)|T0,  V=(R^2j_*Q)|T0,
    b=dim_Q H_c^2(T0,V),
    N_T=#{E prime in Exc(g): g(E)=T, a(E;Y,0)=2},

the claim is b<=N_T. Here a is **ordinary log discrepancy**; the relative
canonical coefficient is a-1. Global places are primes on models of
the whole compact Y, not locally separated branches.

The October 7 manuscript already states this result as `prop:curve-places`,
`06-curve-places.tex:11-26`. Its setup is in
`05-branch-topology.tex:294-305,545-590`; global-place and discrepancy
conventions appear in `01-introduction.tex:11-23` and
`02-preliminaries.tex:53-69`. Those passages agree with the old draft's
retained resolution and log convention. The recorded manuscript revision
is `4eaee87548250b2682affda7d05d947c05554bae`. This is a reproduction,
not a new bound, a manuscript refutation, or a termination proof.

## The actual chain of implications

The reviewed [link map](../link-map/report.md) provides the canonical
monodromy-equivariant quotient W->V. The
[parameter argument](../finite-monodromy/report.md) proves finite monodromy
and yields b flat sections of W with independent images in V. It does
not infer invariant lifts from surjectivity alone.

The [full-compact construction](../full-compact-model/report.md) lifts
these sections to integral classes, represents them by actual divisors,
and gets fixed Cartier multiples N_i on a small projective crepant
terminal model near the entire compact Kprime. Its later restriction to
a core does not assert Q-factoriality over that smaller compact.
The semianalytic Stein compact satisfies (P4), correctly stated in the
supporting Fujino note as finiteness of the connected components of
W intersect Z for analytic Z defined near W.

The [degree argument](../degree-injection/report.md) checks every
irreducible curve in the at-most-one-dimensional generic fibers, including
all sheets of the normalized surface families. Vanishing degrees kill the
fiber H^2 class; regular-locus agreement and the original independent
images then force the combination to vanish. Consequently b<=s.

At the general point of each of the s surfaces, standard terminal
codimension-two smoothness permits the ordinary codimension-two blowup.
It defines a local place of log discrepancy two. Different surface centers
give different places. The [globalization argument](../globalization/report.md)
uses the positive relative canonical coefficients on the fixed resolution
to put every such place on g. The pi1-surjective core prevents a global
prime from splitting into several counted local primes. Therefore
s<=N_T. Combining the inequalities proves b<=N_T under the stated inputs.
For b=0 the bound is immediate.

## What remains assumed, rather than certified

The explicit analytic inputs are local projective decomposition, rational
singularities, proper-scheme GAGA, fixed-polynomial Quot, Stein-neighborhood
and hull theory, and Fujino full-compact factorialization. The primary-source
readings in the linked reports checked their exact versions and hypotheses.
Base change, Cartan A/B, the exponential sequence, compact continuity,
triangulation, generic smoothness, curve topology and covering theory
remain standard mathematical background, not Python assertions.

The [Appendix A assessment](../terminal-appendix/report.md) supports its
surface and sign arguments but identifies an unproved simultaneous
transverse-slicing/adjunction bridge in the fourfold reconstruction.
Here terminal smoothness in codimension two is an **explicit external
standard theorem**, also stated as October 6 canonical Lemma 2.3. We do
not silently promote that sketch to a self-contained proof or claim that
the standard theorem has been refuted.

The unchanged finite verifier passed in 0.3054997632279992 seconds under
Python 3.13.5. Its four chart checks, 617 permutation-generator pairs,
S3 quotient, 624 sign instances and saved rank replay do not establish
any of the above analytic implications. No Lean source or compiler
certificate is supplied by the inventory.

## Comparison with the strongest prior result

The old state already contained the prose proof, proposed bijection and
non-Kahler extension, sharp example and finite certificate. Its ledger
also contained eight Engineer and fourteen separately named historical
support opinions; the old graph nevertheless remained open. This review
does not improve the inequality. It makes the claim versions and
non-node results fully visible, replays the finite evidence with a measured
runtime, checks source scope, and states the appendix dependency precisely.
Current whole-family acceptance is solely the native independent Reviewer's
decision.
