# Scheme fibers, countable Quot spaces, and finite invariant lifts

**Assessment: supported under the stated projectivity, rationality, and
topological inputs.** CP_MONODROMY versions 1-4 enrich the recorded assumptions;
they are not four different results. A07 Section 1, after (4) through (6),
contains the argument. Artifact references resolve in the
[index](../../DRAFT_REVIEW_INDEX.json).

## Exact scope and prior attribution

Use the normal ordinary-terminal compact complex fourfold, the specified
globally projective principalizing SNC resolution g, and the smooth connected
finite-punctured singular curve T0 of the index. W=(R^2g_*Q)|T0,
V=(R^2j_*Q)|T0, and b=dim H_c^2(T0,V); q:W->V is the canonical quotient
reviewed in [link-map](../link-map/report.md). The claim is finite monodromy
of W, hence of V, and b invariant sections of W with fiberwise independent
images. Global Kahlerness is not used.

This is not an original monodromy theorem attributed to Argus. In the
September 24 projective manuscript, `04-local-valuations.tex`, subsection
on resolution fibers, Lemma `local:generic-lines`, lines 169-228 and 239-278,
already gives the parameter, path, finite-cover, norm and averaging argument.
That manuscript's surrounding setting is a projective Q-factorial fourfold
with a rational effective terminal pair, stronger than the present ambient
setting. The recorded manuscript revision is
`4eaee87548250b2682affda7d05d947c05554bae`; attribution is not verification
of its termination conclusion.

## Checking the geometric-to-parameter bridge

The compact reduced curve T is projective: positive degree on each component
gives an ample bundle, with normalization and finite jet conditions accounting
for singular points. The projective analytic family
F=Ytilde x_Y T includes its nilpotent structure. A global relatively ample
bundle and compactness give one relative embedding into P_T(E), E coherent.
GAGA algebraizes E on T. After an ample twist, a finite free presentation
embeds this projectivization, and hence F, into T x P^M. GAGA on this proper
algebraic ambient algebraizes the coherent ideal and its inclusion. Thus it
algebraizes F with its nilpotents. No assertion that arbitrary proper analytic
families algebraize is used.

For any t, an integral fiber H^2 class lifts to H^2(g^{-1}U,Z) on a
sufficiently small neighborhood by proper base change and the neighborhood
colimit. For Stein U, rational singularities, Leray and Cartan B give
H^2(g^{-1}U,O)=0. The exponential sequence supplies a line bundle.
Its restriction to the whole scheme fiber algebraizes by GAGA. Finite
triangulation permits clearing denominators, giving
Pic(F_t) tensor Q -> H^2(F_t,Q) surjectively. Replacing the whole scheme
fiber by its reduction in a coherent-cohomology argument would not establish
this step; the draft does not do that.

After finite puncturing the algebraized family is flat. Each fiber line
bundle is a quotient of some O(-n)^r. Fixed (n,r,P) gives a finite-type
relative Quot space with a universal quotient flat over that parameter
space. Flatness of F and of this quotient makes rank-one local freeness
lift near the fiber. Properness makes the image of the nonfree locus closed.
Consequently an open parameter space carrying an actual universal line
bundle contains every such presentation point. There are countably many
triples and finitely many components for each triple, not one finite-type
space covering all Picard data.

## Why finite monodromy follows

A nondominating parameter component has finite image closure on the algebraic
curve. A very general complex t avoids the countable union of those finite
sets. Choose finitely many line bundles at t spanning W_t. Each lies on a
dominating irreducible component H. The universal Chern class is a section
of the pullback of W; this uses proper base change for the pulled-back
family, not constancy of an arbitrarily assigned vector.

A closed point of the generic fiber of H has finite residue extension.
Normalization and spreading yield a finite etale cover after deleting
finitely many base points. The universal line bundle exists on that cover.
The complex analytification of H is connected and locally path connected.
A path from the original point to this multisection transports the same
Chern class. The cover's fundamental-group image has finite index and fixes
that transported class. Inclusion after finite puncturing surjects on the
old curve fundamental group, and conjugation by the projected path gives
a finite-index stabilizer at the original basepoint. Intersect the finitely
many stabilizers for a spanning list: the monodromy image fixes a basis on
a finite-index subgroup and is therefore finite.

For an oriented connected curve, Poincare duality gives H_c^2(T0,V) as
coinvariants, not automatically invariants. For the finite image G, rational
averaging identifies their dimensions and makes W^G->V^G surjective:
q(average(w))=average(q(w)). Lifting a basis of V^G gives the b required
sections. This also covers b=0 without constructing unnecessary bundles.

## Primary sources and finite evidence

Engineer reader `algebraic-source-reader` inspected A12-A19, A21, A27-A28.
Michele (Mme M.) Raynaud's Expose XII in **arXiv:math/0206203v2 (2004-01-04)**,
Corollary 4.3 and Theorem 4.4, revised p. 249, gives coherent-cohomology
comparison and coherent-sheaf equivalence for proper complex schemes,
without reducedness (A27:11938-11963). Sections 1.1-1.3 supply exactness
and compatibility (11464-11486,11524-11556). This is not an inspected copy
of the 1971 printing. A28 resolves p>=0 and the old pagination marker 329.
The attribution is Mme M. Raynaud, not Michel Raynaud, who helped update
the later edition.

Grothendieck's Bourbaki Expose 221, NUMDAM
`SB_1960-1961__6__249_0`, Section 2 (A13:278-312) and Theorems 3.1-3.2
(574-623), fixes a noetherian base, projective morphism and coherent source.
Flatness is a condition on parameterized quotients; each fixed-polynomial
Quot is projective/finite type, while the unrestricted union is only
locally finite type. The 1962 erratum, NUMDAM
`SB_1961-1962__7__302_1` (A14:41-55, A15), corrects Theorem 2.1 to a
necessary-and-sufficient criterion and several proof inequalities.
It affects the written proof used for quasi-compactness but does not replace
the statements of 3.1-3.2. A16-A19 visually confirm the presentation and
Quot statements; they are not independent results.

Reader `analytic-source-reader` checked Fujino v1 Remark 3.8/Theorem 3.12
(A10:1454-1465,1507-1516): use relatively compact klt neighborhoods to
obtain local rationality, not a global dlt assertion.

The finite verifier replay passed, but its 617 permutation-generator pairs
and one S3 quotient are illustrations, not a test of geometric W. The
algebraization, local-system, multisection and transport bridges above
remain prose deductions using the explicit standard inputs. No concrete
gap was found in this chain under those inputs; novelty and native
independent acceptance are not supplied by that assessment.
