# Free contact lines: positive quotient and smooth evaluation

**Assessment:** supported at the exact conditional, prose-proof scope below.
These are two subsidiary arguments in one descent dossier, not new contact-line
existence or classification results. Native independent review is pending.

## Claim, hypotheses and attribution

The old source is `9000062/research/contact_value_descent/report.md`,
section 2 (lines 88-134), preserved-manifest SHA-256
`f1fd9f36b11cf2c4e44bc3c7a82504ec17a64b097186bfcd7d25a2ac883f3313`.
Both claims are version 1 against `CTX_CONTACT_VALUE@1`, hash
`914303e5e82e89e8edf8a1f770b0006b73daef2d4246c4fa7d67679592faf731`.
That context fixes a smooth simply connected complex projective contact Fano
manifold X of dimension 2n+1, n>=1, the given contact sequence
`0 -> F -> T_X --theta--> L -> 0`, `Pic(X)=Z[L]`, and a dense-covering
family of free maps `f:P1 -> X` with `f*L=O(1)`.

| Old claim | Exact assertion assessed | Source interface |
|---|---|---|
| C_POSITIVE | For every such free contact line, the intrinsic positive part P of `E=f*T_X` has trivial quotient E/P, and theta kills P. | Manuscript `lines:positive`; descent uses `des:line-quotient`. |
| C_FREE_EVALUATION | An **already given** covering family of free L-degree-one maps supplies a smooth irreducible open Hom family H with smooth dominant evaluation `H x P1 -> X`. | The deformation upgrade in `lines:free-cover`, not its separate primitive-case existence input. |

The reference manuscript is the September 23, 2026 source at revision
`4eaee87548250b2682affda7d05d947c05554bae`, identified by
`9100062/MANUSCRIPTS.json`. The comparator worker matched all twelve TeX
hashes. The precise source interfaces and measurements are in
`../classification_outline/report.md`, not inferred from a live branch.
`lines.tex:97-132` states additional isotropy/rank conclusions; those are not
silently added to the narrower old C_POSITIVE assertion assessed here.

These are reproductions of manuscript arguments and standard deformation
inputs. No original mathematical contribution or independently checked
novelty is claimed.

## Decisive argument: C_POSITIVE

Split E into line bundles on P1. Freeness makes every splitting degree
nonnegative. Let P be the sum of positive summands. Given two splittings,
every map from a positive summand in one to the degree-zero quotient in the
other vanishes. Thus each proposed P lies in the other, proving intrinsicness;
E/P is trivial. This does not require the special standard splitting of a
contact line.

The differential `df:O(2) -> E` is nonzero in characteristic zero, and
`theta df=0` because `Hom(O(2),O(1))=0`. Contracting df with the
nondegenerate L-valued Levi form gives a nonzero morphism
`f*F -> Hom(O(2),O(1))=O(-1)`. It need not be nonzero at every point.
A globally generated bundle admits no nonzero map to O(-1), so f*F is not
globally generated.

If theta were nonzero on P, some positive summand would map nontrivially to
O(1). A summand of degree greater than one cannot do so; an O(1) summand
would map isomorphically. It would split `E -> O(1)`, making its kernel
f*F a direct summand of globally generated E and hence globally generated.
This contradiction proves `theta(P)=0`.

The argument checks the possible nonimmersed free map as well: only a
nonzero differential as a bundle morphism is needed, not an everywhere
injective differential. There is no missing step at n=1 in this argument.

## Decisive argument: C_FREE_EVALUATION

L is ample since the contact determinant gives `-K_X=L^(n+1)`.
After embedding by a very ample power of L, maps of L-degree one have fixed
projective degree and form a finite-type Hom locus. Thus there are finitely
many components to consider, and the dense-covering hypothesis supplies a
dominant-evaluation component with nonempty free locus.

At a free map, `H1(P1,E)=0`; the cited Hom criterion makes Hom smooth there
with tangent space H0(E). Freeness is open, so one can take a smooth
irreducible open H inside that component. For every (f,t), evaluation of
global sections `H0(E) -> E_t` is surjective by freeness. These are already
tangent directions coming from H. The differential of evaluation is
therefore surjective; between smooth complex varieties this makes evaluation
smooth. Dominance survives restriction to this open.

This proves smooth **dominant**, not proper or everywhere-surjective,
evaluation. It does not construct an initial covering family on an arbitrary
primitive contact Fano manifold. That separate C_LINES_COVER obligation is
explicitly assessed in the outline unit.

## Sources and evidence scope

Bundle splitting is the paragraph before Definition 8 in Araujo-Kollar,
*Rational Curves on Varieties*, supplied copy labelled
`arxiv:math/0203173v2`, section 3, **printed p. 8**. The old p. 7 locator
is an inherited pagination error, not a defect in the splitting statement.
Theorem 5(1)-(2), printed p. 6, identifies the Hom tangent space and gives
smoothness under H1 vanishing for a projective source without embedded points
and a smooth quasi-projective target. P1 and X satisfy these hypotheses.
Surjectivity of the evaluation differential is an extra argument given
above, not a conclusion misquoted from that theorem.

The current independent source readings, including corrected assumption
`A_P1_SPLITTING_P8` and `A_HOM_SMOOTHNESS` on C_REVIEW_DESCENT, are in
`../contact_value_descent/sources.md`. The supplied PDF/text are not
preserved-manifest byte-authenticated. Its arXiv v2 label and internal 2018
date are reported there without claiming an unexplained live-PDF identity.
The elementary line-bundle cohomology used here is the P1 calculation
described in the old proof; no stable-map obstruction theorem is used.

The old independent reviewer `reviewer:copilot-cb07e28d5d45` supplied:

| Claim and subject hash | Matching independent judgment |
|---|---|
| C_POSITIVE, `80c4c480b678b9aedbf22f75ee0e56de1f155c9ced1b5b0fbc54b241e7344b9f` | `judgement-C_POSITIVE-f750cd8ecb3a` |
| C_FREE_EVALUATION, `2161d88824b4b8c6b19086a99088b4b53634448a930547ad3896b3151451e2d1` | `judgement-C_FREE_EVALUATION-554ecb0687cc` |

Both bind the unchanged version-1 subject and the old report path.
They are reusable historical opinions, not kernel certificates or current
native acceptance. The ledger does not record a digest of the report in
those judgments; the report's independently measured preserved-manifest
identity is a separate provenance fact. The graph's open labels do not erase
these matching judgments.

No identified mathematical gap remains in these two conditional arguments.
The existence of a covering family, the geometry of its tangent directions,
and every downstream construction remain separate obligations; accepting
this unit does not resolve them.
