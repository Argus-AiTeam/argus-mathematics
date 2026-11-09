# Canonical resolution-to-link quotient

**Assessment: supported as an analytic argument with explicit standard inputs,
not mechanically proved.** This reviews CP_LINK versions 1-2, not a new
theorem. Artifact identifiers below resolve in the
[coverage index](../../DRAFT_REVIEW_INDEX.json).

## Statement, hypotheses, and attribution

Let Y be a normal irreducible compact complex analytic fourfold with ordinary
terminal singularities. Keep the specified projective resolution g with smooth
source, an isomorphism over Yreg, SNC exceptional divisor, and principalized
singular ideal with full inverse-image support. On a connected smooth
finite-punctured singular curve T0, take W=(R^2 g_* Q)|T0 and
V=(R^2 j_* Q)|T0, j:Yreg->Y, to be local systems. The assertion is that
canonical restriction induces a monodromy-equivariant surjection q:W->V,
with the fiber map obtained through neighborhoods of the resolution fiber.
Neither global projectivity of Y nor a global splitting is an assumption.

The proof is A07, Section 1 through (4). The October 7 manuscript already
contains the quotient as `lem:link-quotient` in
`build/sections/05-branch-topology.tex:727-775`. Its recorded source revision
is `4eaee87548250b2682affda7d05d947c05554bae` in the preserved manuscript
manifest. This is a reproduction of that ingredient, not evidence for the
manuscript's termination theorem.

## Decisive argument

Write K=Rg_*Q[4]. The canonical map K->Rj_*Q[4] is fixed by restriction to
the regular open. Locally embed Y in a smooth ambient space and apply the
projective analytic decomposition theorem to the composite. Since g is a
resolution and is an isomorphism on the regular open, its perverse-degree-zero
full-support constituent is IC_Y(Q), normalized to restrict as the identity.
Its inclusion into K can be chosen with that normalization. By adjunction,
the composite IC_Y->K->Rj_*Q[4] is the canonical comparison, not an arbitrary
map between stalks.

At a generic curve stratum of a fourfold the complex codimension is three.
The middle-perversity attaching truncation retains unshifted degrees through
two. Equivalently, H^{-2}(IC_Y)->H^{-2}(Rj_*Q[4]) is an isomorphism there.
The split inclusion of IC_Y into K therefore makes H^{-2}(K)->R^2j_*Q
surjective. The normalization and degree shift are essential: retaining only
degrees below two would not prove the assertion. Further finite puncturing
puts the curve in the required stratification; constant rank then gives the
surjection on the stated connected local-system locus.

Proper base change identifies H^{-2}(K)_t with H^2(g^{-1}(t),Q).
The map is the colimit of restriction maps on inverse images of neighborhoods
to their regular parts. Because the map is a sheaf morphism on T0, its stalk
maps are monodromy-equivariant. A choice of unrelated surjective linear maps
on fibers would not suffice.

## Primary-source check and limits

Engineer source reader `analytic-source-reader` inspected A22 and all three
scan companions A23-A25. The source is Saito, *Modules de Hodge Polarisables*,
Publ. RIMS 24 (1988), DOI `10.2977/PRIMS/1195173930`.
Theorem 5.3.1, p. 977 (A22:5264-5276), concerns projective maps of smooth
complex analytic varieties and polarized Hodge modules. Introduction
Corollary 3 (A22:295-306,328-342), Lemma 5.1.10 (4481-4488), and Section 5.4
(5732-5769) supply the derived/strict-support and constant-module setup.
The p. 129 scan disambiguates the OCR's inequality as i>=0.

These are analytic projective results; they do not impose algebraicity or
global Kahlerness. The algebraic-case semisimplicity remark is not a license
to assert semisimplicity for every analytic local system. It is not needed
here. A26 correctly distinguishes the source theorems from the full-support,
adjunction, and attaching deductions above.

The IC attaching rule, proper base change, and compatible stratification are
standard unformalized inputs. The finite verifier checks none of them and
does not check this surjection. No concrete defect was found in the
degree/adjunction argument under these inputs. Acceptance of that prose
argument remains for the native Reviewer; historical support opinions do not
replace it.
