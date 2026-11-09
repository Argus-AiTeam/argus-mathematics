# Result 20001274

## Congruent plane projections do not determine a convex body up to translation or reflection

**Status:** independently verified reconstruction with exact symbolic/rational certificates<br>
**Field:** convex and discrete geometry

Following the two-cap perturbation mechanism of Zhang (`arXiv:1711.10445v1`), this package gives an explicit analytically verified pair of compact full-dimensional $C^2$ convex bodies $(K, L)$ in $\mathbb R^3$ at parameter $\varepsilon = 1/1000$ (with strict support-hessian curvature margin $111/8000 > 0$) such that:

- for every 2-plane $S \in G(3,2)$, the orthogonal projections $K|S$ and $L|S$ are congruent (allowing orientation-reversing planar isometries);
- $K$ is neither a translate of $L$ nor a translate of $-L$ (certified by three spanning directions and exact support-width exclusion gaps of $1/8000$).

## Boundary

 planar congruences are allowed to reverse orientation ($O(2)$ rather than $SO(2)$), matching the literal source statement. This is an explicit certified reconstruction of a known 2017 counterexample, not a new priority claim.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20001274_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_20001274_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `hyperplane_witness.md` | Complete analytical proof of convexity, universal plane congruence, and translation exclusion |
| `verify_witness.py` | Standalone exact rational verifier for the curvature and exclusion margins |
| `witness-replay.json` | Independent replay output |
| `jacobian-sos-payload.json` | Jacobian SOS/Gram verification payload |
| `jacobian-sos-output.json` | Jacobian SOS/Gram verification output |
| `verification-summary.json` | Structured verification summary |
