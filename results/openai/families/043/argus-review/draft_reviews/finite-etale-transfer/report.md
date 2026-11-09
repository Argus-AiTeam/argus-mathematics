# General finite-etale transfer: Engineer assessment

**Disposition:** supported as a conditional prose theorem at the stated scope.
This is not a kernel-checked theorem, a novelty finding, or current independent
Reviewer acceptance.

## Statement, hypotheses, and provenance

The source is section 2 of
`families/043/first-pass/determinant_cover_transfer/report.md`,
preserved in the 2026-11-06T10:20Z snapshot manifest. It represents old
`C_FINITE_ETALE_TRANSFER` versions 1-3, `L_TORUS_COVER` version 1, and
`L_RELATIVE_DUALITY` versions 1-2. Versions 2-3 add citations; they do not
silently enlarge the theorem.

Let \(f:T\to S\) be a smooth separated finite-type complex algebraic morphism,
with smooth base and fibers of complex dimension \(\delta\). Require:

1. A rank-\(b\) auxiliary complex affine bundle \(E\to T\), with a finite
   **closed filtration**, whose differences are vector bundles over
   \(\mathbb A^a\times(\mathbb C^*)^s\times S\), mapped to \(S\) by projection.
   The integers and ranks can vary between pieces.
2. At a specified parameter, a possibly different rank-\(b\) auxiliary bundle
   with such a torus-affine filtration, on whose pieces the restrictions of
   **one common degree-two class** satisfy compact-support curious Lefschetz
   with middle **actual Deligne weight** \(\delta+2b\). Its action has actual
   weight shift four, not two.

For any finite etale cover \(p:T'\to T\), including disconnected covers and
disconnected inverse images of pieces, the claimed conclusions are:
Hodge--Tate rational cohomology of every fiber; finitely generated integral
local systems \(R^j f'_!\mathbb Z\) and \(R^j f'_*\mathbb Z\); the **natural**
ordinary fiber-base-change isomorphism; and ordinary curious Lefschetz with
middle actual weight \(\delta\) at the specified parameter. No assertion
about arbitrary smooth nonproper families without these stratifications is made.

For a Galois cover with group \(G\), the piecewise assertion is
\[
H^j(p^{-1}F,\mathbb Q)\simeq
\mathbb Q[\pi_0(p^{-1}F)]\otimes H^j(F,\mathbb Q),
\]
and similarly for compact supports, equivariantly with \(G\) acting by
permutation on components and trivially on the second factor.

## Decisive argument checked

For a vector bundle \(F\) over an affine space times an \(s\)-torus,
\(\pi_1(F)=\mathbb Z^s\); affine and vector-bundle fibers are contractible.
A connected finite cover corresponds to a finite-index lattice
\(L\subset\mathbb Z^s\). Restriction
\(\operatorname{Hom}(\mathbb Z^s,\mathbb Q)\to\operatorname{Hom}(L,\mathbb Q)\)
is an isomorphism, and so are all its exterior powers. These are algebraic
pullbacks, hence isomorphisms of rational mixed Hodge structures. The
identification is by pullback, not a chosen homeomorphism of two tori.

Finite proper pushforward and Poincare duality give the compact-support
assertion: pushforward is dual to ordinary pullback, and its composite with
compact-support pullback is multiplication by the cover degree. This argument
requires rational coefficients for the isomorphism. It does **not** make an
integral lattice inclusion unimodular. Retaining every connected component
gives the permutation module above; no invariant projector is used.
The character/Koszul formulation is assessed separately in `../koszul-kummer/`.

Pullback preserves the finite closed filtration. Localization is exact in
mixed Hodge structures and strict for weights. Comparing its weight-graded
long exact sequences with a fixed power of the common class, the five lemma
propagates the Lefschetz isomorphisms. The common center hypothesis is essential:
different unaligned piece centers would not support this argument.
Hodge--Tate structures are closed under subquotients and extensions.
For the auxiliary bundle,
\[
H_c^j(E'_t,\mathbb Q)\simeq H_c^{j-2b}(T'_t,\mathbb Q)(-b).
\]
Removing it lowers actual weight by \(2b\); duality reflects weights by
\(w\mapsto2\delta-w\). Thus the ordinary center is
\((\delta+2b)-2b=\delta\), not \(\delta/2\) in actual-weight notation.

The integral argument is stronger than the rational pullback argument and
uses a different mechanism. Over a sufficiently small contractible analytic
open \(U\subset S\), vector bundles over \(F_0\times U\) are topologically
pulled back in the \(U\) direction. The same holds for finite covers by
covering-space classification. Complex orientations trivialize the Thom
orientation systems. Localization then yields bounded, finitely generated,
lisse integral compact-support cohomology. Kernels, cokernels and extensions
are locally constant on such small opens. In the derived statement, locally
constant finite stalk complexes are perfect: finitely generated
\(\mathbb Z\)-modules have finite free resolutions and
\(\mathbb Z\) has global dimension one.

Put \(K=Rf'_!\mathbb Z\). Oriented relative Verdier duality gives
\[
Rf'_*\mathbb Z\simeq R\mathcal Hom(K,\mathbb Z_S)[-2\delta].
\]
Local perfection permits derived stalks to commute with this dual. Compact
support base change and fiberwise duality identify the result with
\(R\Gamma(T'_t,\mathbb Z)\), including integral Ext terms. Finally, the
isomorphism is adjoint to relative cup product and orientation trace.
Both restrict to the fiber pairing, so the resulting fiber map is the
**usual restriction/base-change morphism**, not merely an abstract
isomorphism between groups of equal ranks. This addresses the nonproperness
issue without assuming ordinary smooth base change.

## Sources and historical evidence

The following are external inputs, not products of the exact Python run.
The old ledger filed them under `engineer:copilot`; its
`reviewer:copilot` opinions remain historically attributed.

| Input | Exact source/version and locator | Reading retained in the old tree |
|---|---|---|
| Strictness and exact weight gradeds | Deligne, *Theorie de Hodge II*, `doi:10.1007/BF02684692`, Theorem 2.3.5(i)-(iii) and rational variant 2.3.8 | `literature/deligne_hodge_ii.txt`, lines 1183-1221; part (iv) also explicitly states exactness |
| Hodge-theoretic derived functors | Saito, *Mixed Hodge Modules*, `doi:10.2977/prims/1195171082`, Theorem 0.1, printed p. 222 | `literature/saito_mhm.txt`, introduction |
| Integral relative duality | Verdier, `numdam:SB_1964-1966__9__337_0`, section 1; section 3 equation (3.3) and theorem, pp. 343-344; section 5 (5.1)-(5.2), p. 348 | `literature/verdier_duality.txt` and all three `verdier_*.png` images |

These passages were read for this assessment. Verdier's coefficient ring is
an arbitrary commutative ring, so the integral use is legitimate. The image
on p. 344 actually states that the sheaf-valued map is an isomorphism;
the p. 348 image supplies the submersive/product formulas. Text extraction
alone omits those mathematical glyphs. No preserved PDF is invented:
the PDF filenames in old evidence references are absent from the enumerated
old tree, whereas these texts/images are present.

Old supporting judgments attach to the same statement hashes. They are useful
provenance, but neither erase the explicit external assumptions nor override
the old graph's open/reviewer-unconfirmed labels. There is no Lean source.

## Supported scope and remaining boundary

The component, localization, Thom, and derived-duality arguments support the
stated theorem under its full hypotheses. The original exact replay succeeded,
but certifies only the algebra and shift identities described in
`../koszul-kummer/report.md`; it does not certify these geometric hypotheses
or the sheaf arguments.

No unresolved internal mathematical step was identified within this conditional
prose theorem during this bounded review. For any proposed application, the
remaining concrete duties are to supply the actual relative closed
stratification, the specified-parameter common-class/common-center
stratification, and smoothness/separatedness/dimension/orientation hypotheses.
Dropping these is an unsupported strengthening. Integral pullback
isomorphisms are explicitly **not** supported.

This is an Argus synthesis/reconstruction using published inputs, not a verified
new theorem. The present review does not strengthen the strongest old
prose result; it makes its hypotheses and evidence boundary explicit.
Final mathematical and citation acceptance belongs to the native Reviewer.
