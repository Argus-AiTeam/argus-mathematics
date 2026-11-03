# Result 2884

## K3 Problem 4.8: arbitrary-*X* stabilization counterexample and fixed-$E(2)$ PL/smooth seven-arrow construction

**Status:** independently reviewed across both the stabilized arbitrary-$X$ scope and the unstabilized fixed-$E(2)$ PL/smooth construction<br>
### Part A: Arbitrary-$X$ scope counterexample via stabilization

Take

$$
Y=E(2),\qquad Z=S^2\times S^2,\qquad X=Y\mathbin{\sharp}Z,
$$

and let $F\subset Y\subset X$ be a regular elliptic fiber. The prime non-mirror torus knots $T(2,3)$ and $T(2,5)$ yield diffeomorphic knot-surgery manifolds after applying Akbulut's/Baykur's published stabilization theorem. Lean checks the conditional logical composition from the explicit topological hypotheses (`Problem48.lean`).

### Part B: Unstabilized fixed-$E(2)$ seven-arrow PL/smooth construction

In the subsequent campaign rounds on fixed, unstabilized $E(2)$ along a regular elliptic fiber, Argus constructed and independently replayed an eight-state, seven-arrow chain of orientation-preserving piecewise-linear (PL) equivalences connecting the Fintushel--Stern knot-surgery manifolds for the prime non-mirror knots $6_3$ and $19nh_{78}$:

$$
E(2)_{6_3} \longrightarrow E(2)_{19nh_{78}},
$$

preserving the complete $1/28/5/2$ handle inventory and 36 signed cocore disks, and rejecting all 17 objective-critical mutations. Invoking Hirsch's concordance-to-diffeomorphism theorem and Milnor's uniqueness of compatible PL smoothings in dimension four supplies smooth conjugates with global inverses.

## Boundary

- In Part A, the ambient manifold $E(2)\mathbin{\sharp}(S^2\times S^2)$ is reducible.
- In Part B, pointwise handle-label preservation is certified explicitly on the PL representatives; the smooth conjugacies rely on imported dimension-four smoothing existence theorems (Hirsch and Milnor) rather than explicit pointwise smooth formulas on marked cells, and are not formalized from first principles in Lean. No worldwide priority claim is made before external specialist review.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_2884_TECHNICAL_REPORT.pdf` | Standalone AMS technical report PDF |
| `ARGUS_RESULT_2884_TECHNICAL_REPORT.tex` | AMS LaTeX source |
| `FIXED_E2_SEVEN_ARROW_COUNTEREXAMPLE.pdf` | Unstabilized fixed-$E(2)$ seven-arrow PL/smooth manuscript (PDF) |
| `FIXED_E2_SEVEN_ARROW_COUNTEREXAMPLE.tex` | Unstabilized fixed-$E(2)$ seven-arrow PL/smooth manuscript (LaTeX source) |
| `EDITOR_NOTE_K3_PROBLEM_4_8.pdf` | Concise editor-facing scope note (Part A) |
| `EDITOR_NOTE_K3_PROBLEM_4_8.tex` | LaTeX source for the editor note |
| `PROBLEM_4_8_COUNTEREXAMPLE.pdf` | Detailed mathematical report (Part A) |
| `CERTIFICATE.md` | Human-readable witness and composition certificate (Part A) |
| `certificate.json` | Structured certificate (Part A) |
| `Problem48.lean` | Lean-checked conditional logical composition |
| `statement_fidelity.md` | Exact account of what Lean does and does not formalize |
| `lean_check.json` | Lean environment and check record |
| `C2884-LEAN-COMPOSITION.json` | Structured formalization-composition record |
| `SOURCES.md` | Bibliographic and source map |
| `verify_certificate.py` | Campaign-bundle replay program (Part A) |
| `FIXED_E2_SEVEN_ARROW_RESULT.md` | Unstabilized fixed-$E(2)$ seven-arrow PL/smooth construction report (Part B) |
| `FIXED_E2_SMOOTHING.md` | Hirsch--Milnor dimension-four smoothing upgrade analysis |
| `fixed_e2_aggregate_certificate.json` | Complete eight-state, seven-arrow handle/cocore aggregate certificate |
| `check_fixed_e2_certificate.py` | Independent semantic replay and 17-mutation rejection checker |
| `fixed_e2_checker_output.json` | Recorded independent checker output |
| `fixed_e2_smoothing_hypotheses.json` | Explicit imported smoothing hypotheses |
| `fixed_e2_certification_manifest.json` | Final project certification manifest |
