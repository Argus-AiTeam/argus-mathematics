# Full compact, Stein neighborhoods, and small factorialization

**Assessment: the construction is supported with its full-compact safeguards.**
This unit reviews CP_COMPACT versions 1-4 and A07 Section 2, not four
separate constructions.

## Exact claim and background

Keep the normal ordinary-terminal compact complex fourfold, the specified
projective resolution g with smooth source, SNC exceptional divisor,
isomorphism over Yreg and principalized singular ideal, and the connected
smooth finite-punctured singular curve T0. From CP_MONODROMY take b flat
sections sigma_i of W whose images in V are fiberwise independent.
The assertion is the existence of a full loop compact K, a larger Stein
compact Kprime, a small projective crepant terminal model ell over a
neighborhood of Kprime, and line bundles N_i on that model agreeing on the
regular locus with one common positive multiple of the lifted classes.
It does not assert Q-factoriality over every smaller compact.

A07 Section 2 is the proof. October 7 `06-curve-places.tex:203-285` already
uses the full-compact construction and divisors before restriction.
The manifest identifies manuscript revision
`4eaee87548250b2682affda7d05d947c05554bae`. No originality claim is justified
by reproducing those steps.

## Topological lifts and actual divisors

Remove another point if necessary so T0 is noncompact. Its finite-graph
homotopy type kills the possible Leray obstruction groups in base degrees
at least two. Thus H^2(g^{-1}T0,Q)->H^0(T0,W) is surjective.
Finite algebraic triangulation type, available from the projective-family
algebraization, permits clearing denominators to get integral lifts.
Multiplying the sigma_i individually by positive integers preserves the
independence used later.

Take K in the smooth compactification by deleting small discs at the
punctures. Its interior carries all loops, and each complementary component
escapes a puncture, so K is Runge in T0. Mere loop retention would not imply
holomorphic convexity. Delete the unwanted singular components and punctures
from the ambient space to make T0 closed. Its Stein neighborhood Omega
exists in this possibly singular ambient; the hull statement transfers
convexity of K to Omega.

The compact semianalytic g^{-1}K is locally contractible. Cech continuity
and agreement with singular cohomology extend the finitely many integral
classes to a common neighborhood. Properness supplies an ambient U0 with
full inverse image in that neighborhood. Convexity of K gives a connected
Stein K-containing U relatively compact in Omega intersect U0.
Rationality, Cartan B and the exponential sequence realize the extensions
by line bundles L_i on g^{-1}U.

This step needs actual divisors, not just reflexive line classes.
The proper direct image g_*L_i is a coherent rank-one sheaf on Stein U.
Cartan A gives a section nonzero at a regular point; its pullback is
nonzero, so its zero divisor A_i is Cartier on the smooth g^{-1}U.
Their pushforwards are actual globally defined analytic Weil divisors
on this U.

## Factorialization without shrinking the hypothesis away

Fujino Section 1.11 permits a semianalytic Stein compact Kprime inside U
containing all of K in its interior. The identity U->U is projective,
U is normal klt, and K_U is Q-Cartier. Fujino Remark 2.43 supplies an
actual canonical Weil representative on a space projective over a Stein
base, including U itself. Theorem 1.24 therefore applies after shrinking
around all of Kprime.

The resulting small projective ell:Y'->U is crepant: canonical comparisons
agree on the codimension-one isomorphism locus and extend reflexively.
Hence Y' is terminal and rational. It is an isomorphism over Ureg.
Indeed, on a smooth base the reflexive trace of a relatively ample line
bundle is invertible; smallness identifies the original bundle with its
pullback. A positive-dimensional projective fiber would then have an
ample bundle of degree zero on its curves, a contradiction. A finite
birational morphism to a normal smooth base is an isomorphism.

The strict transforms D_i' of g_*A_i are defined near the whole inverse
image of Kprime. Local finiteness and compactness leave only finitely many
prime components there. Q-factoriality over Kprime tests precisely such
divisors. Lemma 2.42, using normality and rational singularities of Y',
gives a common n>0 making all nD_i' Cartier on one neighborhood. Properness
makes that neighborhood contain ell^{-1}U1 for a base neighborhood U1
of Kprime. Restrict N_i=O(nD_i') only now. On the regular open it agrees
with L_i^n. This uses already constructed Cartier multiples, not an
invalid inheritance of Q-factoriality by a smaller compact.

## Source assessment and full-compact requirements

Reader `analytic-source-reader` checked Forstneric, DOI
`10.5802/aif.2112`, Theorem 2.1 and hull discussion (A08:162-206;
A09:8-23). Closedness of T0 in the chosen punctured ambient is necessary;
the empty-compact application does not say T0 is closed in the original Y.
The sources allow a reduced paracompact singular ambient.

The same reader checked **Fujino arXiv:2201.11315v1**:
condition (P) (A10:110-137), Section 1.11 (255-275), Theorem 1.24
(503-508), Definitions 2.32/2.38 and Remark 2.39 (1157-1167),
Lemma 2.42 (1185-1196), and Remark 2.43 (1359-1367).
Condition (P4) requires that **W intersect Z have finitely many connected
components**, for every analytic subset Z defined near W (A10:119-120).
Direct comparison confirms that A11:8-11 states this same intersection
condition: "finitely many connected components of W intersect Z".
In the construction W is the full Kprime; its semianalytic Stein property
satisfies (P4). The October 7 text at 203-213 uses the same condition.
The preserved source note agrees with Fujino here.

The Lemma 2.42 application also needs rational singularities, not just a
label saying Q-factorial. Crepancy plus terminality supplied that requirement
above. The verifier checks none of this geometry. The topological continuity,
Stein theory and coherent arguments remain explicit unformalized inputs;
no additional concrete gap was found in the full-compact construction under
them. Current independent acceptance is pending.
