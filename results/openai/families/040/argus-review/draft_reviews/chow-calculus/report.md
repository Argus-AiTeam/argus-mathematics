# chow-calculus

**Assessment: supported as external, known mathematical inputs.** This is
not a new theorem, a kernel proof, or acceptance of the manuscript.

## Claim, versions, and attribution

`C40_CALCULUS`, versions 1-4, has the unchanged statement:

> Rational Chow projection, flat base change, regular-embedding
> self-intersection, projective bundle pushdown, and smooth-variety GRR apply
> to the perfect complexes and smooth projective varieties used in the
> marked recursion.

The draft is old `research/marked-chow-audit/REPORT.md`, Section 2, together
with `sources.md` and the two Vakil PDF/text pairs. All old paths resolve
under the `9000040` root in `DRAFT_REVIEW_INDEX.json`. The application is to
OpenAI's September 24, 2026 manuscript, manifest revision
`4eaee87548250b2682affda7d05d947c05554bae`, principally `relation.tex`.
The foundational results belong to intersection theory, not to Argus.

Version 1 recorded no assumptions. Version 2 added `A_GRR_READ`, version 3
added `A_SELF_INTERSECTION_READ`, and version 4 added `A_CHOW_STANDARD`.
The statement hashes coincide; the versions document dependency disclosure,
not four distinct results.

## Hypotheses and decisive source checks

The varieties in the recursion are smooth projective products of a smooth
connected projective complex surface, its point Hilbert schemes, and
consecutive nested schemes. Universal ideals and their derived operations
are perfect. Smoothness of the Hilbert spaces is a standard geometric input,
recorded by EGL, not established by the arithmetic verifier.

Vakil, Math 245 Class 19, November 24, 2004, Section 2, printed page 3,
states GRR for a proper map of smooth varieties and any K-class:
\[
\operatorname{ch}(f_*\alpha)\operatorname{td}(TY)
=f_*(\operatorname{ch}(\alpha)\operatorname{td}(TX)).
\]
The notes' finite-resolution discussion supplies the additive
perfect-complex reading. The maps needed here are projective. Stacks 02UO's
more restricted locally-free-cohomology statement would not suffice alone;
the mature draft explicitly replaces that attempted attribution.

Vakil Class 17, November 17, 2004, Section 1.2, printed page 4, gives the
refined excess formula and its closed regular-embedding specialization
\(i^*i_*\alpha=c_d(N)\cap\alpha\). This does not require transverse
self-intersection. The two stars have different types; the PDF and the
surrounding refined-Gysin construction disambiguate the OCR.

Stacks 02TX/02U6 apply the projective-bundle formula and quotient-line
Chern relation to locally free resolution bundles, not directly to a
possibly non-locally-free ideal. Stacks 02RG requires a proper/flat
Cartesian square; the auxiliary surface projections supply these squares.
No flatness of the residual map or of \(\sigma\) is asserted.

There is one attribution precision worth recording: Stacks 02SU directly
covers a first-Chern-class projection formula. The general Chow-class
projection formula actually used is supplied by Stacks 0B2X for
nonsingular projective varieties. This supplements the source attribution,
not the mathematical argument. The identity
\(\operatorname{ch}_k(F^\vee)=(-1)^k\operatorname{ch}_k(F)\) follows from
finite resolutions and the splitting principle; it is not quoted as a
verbatim assertion of these tags.

## Evidence and boundary

`reader:source-reader` independently read the primary passages. Their
qualified readings are preserved in `research/literature/*-excerpt.md`.
The current bridge ledger records the four geometric input bundles before
the assessments. EGL has a versioned, confirmed citation; the dated notes
and mutable Stacks URLs honestly remain registry-`uncited`, with independent
reader judgements and explicit prose locators. No DOI was invented.

The old ledger contains both Engineer and Reviewer `supports` judgements
for this claim, plus Reviewer judgements on its three mature assumptions.
Pending labels in the old report and open graph labels do not erase those
judgements. Conversely, neither the judgements nor the local algebra replay
prove these foundational theorems in a kernel or validate virtual geometry.
The present assessment preserves that exact conditional scope.
