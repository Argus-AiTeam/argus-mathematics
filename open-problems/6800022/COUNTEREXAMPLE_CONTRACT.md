# Counterexample certificate contract

## Exact target

Produce one of the following exact witnesses in Euclidean three-space:

1. A connected minimal surface \(M\subset\mathbb R^3\) whose induced metric is
   complete, whose inclusion is globally injective, and whose image is not
   proper.
2. A connected minimal surface \(M\subset\mathbb R^3\) whose induced metric is
   complete, whose inclusion is globally injective and proper, whose total
   curvature is finite, and whose compactification has genus \(g\) and exactly
   \(k\) ends with \(k>g+2\).

The present bounded route tests branch 2 at the smallest possible integer
violation \(g=1,\ k=4\), specifically in the family attributed to Costa in DOI
`10.1090/S0002-9939-1993-1160295-2`.

## Candidate certificate

A candidate is admissible only if a clean replay establishes all of:

- the complete parameter domain and the exact selected parameter;
- the punctured genus-one conformal surface and exact Weierstrass data;
- vanishing of every real period required for a single-valued immersion;
- no common zero or pole defect in the Weierstrass forms (regularity);
- completeness of the induced metric;
- finite total curvature;
- exactly four ends and the type/multiplicity of each end;
- global injectivity of the map into \(\mathbb R^3\), not merely embedded ends,
  symmetry-fundamental-domain injectivity, or an embedded quotient;
- properness of the image.

Numerical sampling, a near-zero period, an immersed member, or an assertion
that only the ends are embedded is not a certificate.

## Exhausted-family certificate

The bounded route is exhausted only by a replayable exact argument covering the
entire parameter domain and proving that every member either is inadmissible
(period failure, branch point, incompleteness, wrong topology/end count, or
nonproperness) or has a global self-intersection. A finite parameter grid,
solver timeout, interval boundary not shown to cover the domain, or inability
to locate a source is an unresolved boundary rather than exhaustion.

## Stop boundary

This mission stops with exactly one of:

- an exact member satisfying the candidate certificate;
- an exact full-domain obstruction satisfying the exhausted-family
  certificate; or
- a documented unresolved parameter boundary, without counterexample or
  exhaustion language.
