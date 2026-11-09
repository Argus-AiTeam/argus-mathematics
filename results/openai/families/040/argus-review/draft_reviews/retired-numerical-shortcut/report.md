# retired-numerical-shortcut

**Assessment: invalid as a proof route for the retained-output claim.**
This rejects an Argus shortcut, not EGL's theorem or the manuscript.

## What is being reviewed

`R40_NUMERICAL_SHORTCUT` has goal `C40_BRIDGE` and the circular obligation
`C40_BRIDGE`. Its recorded retirement reason is:

> Numerical EGL universality integrates away both output factors and
> therefore does not identify a selected coefficient in a possibly
> nonunique Chow diagonal decomposition; the marked recursion must be
> proved before numerical comparison.

The evidence is old `MATH_STATE.json`, the boundary in `sources.md`, and
`REPORT.md`, Sections 1, 5 and 8. EGL, `arxiv:math/9904095v1`,
Section 3 Proposition 3.1 and Section 4 Theorems 4.1-4.2, is mentioned by
the old draft as numerical prior art, **not** as an input implying the
retained-output result. This review does not re-certify all those
numerical theorems. Their precise applicability would not repair the
logical mismatch of targets.

## Decisive obstruction

Fully integrating a correspondence discards its retained Chow class.
Moreover, even knowing a realized Chow class can fail to determine its
coefficient in a diagonal-plus-external-products presentation. For
\(\mathbb P^2\),
\[
[\Delta_{\mathbb P^2}]
=h^2\boxtimes1+h\boxtimes h+1\boxtimes h^2.
\]
Thus
\(c[\Delta]+\Gamma=(c+a)[\Delta]+(\Gamma-a[\Delta])\) for every rational
\(a\), with the second remainder still external. Numerical integrals
cannot choose between these presentations.

This is a proof of non-identifiability in the proposed inference. It
does not assert that the desired bridge is false. It shows why its
selected coefficient requires a surface-independent formal rule that
retains both outputs before evaluation. The supported marked recursion
and graph selection supply that extra argument; scalar EGL universality
alone does not.

The old Wiki analogue is prior guidance for another manuscript, not a
second independent result for this one. The shortcut has no separate
surviving manuscript draft or certificate in the inventory. Keeping it
as one failed-route review unit prevents silently omitting a mathematical
failure while avoiding counting it as another theorem.

## Current disposition

The current ledger records the non-implication claim
`C_NUMERICAL_NONIMPLICATION` and the reasoned retired route
`R_RETIRED_NUMERICAL_ONLY`. No new counterexample search, larger-bound
experiment, or reopening of this route was undertaken. The route's
invalidity is compatible with the legacy Reviewer support for the
different, retained-output proof.
