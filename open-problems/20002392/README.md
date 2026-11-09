# Result 20002392

## Velocity-Only Exclusion of Backward Self-Similar Navier-Stokes Profiles in a Half-Space

**Status:** `independently_verified` (`publishable_theorem`, `novelty_status=verified_new`)<br>
**Resolved scope:** Complete exclusion of non-trivial smooth no-slip backward self-similar Leray profiles in R^3_+ under velocity decay |U(y)| <= C/(1+|y|) and Lamb-vector alignment, without a priori derivative decay or pressure hypotheses<br>
**Field:** partial differential equations and fluid mechanics

## Summary

We study smooth backward self-similar Leray profiles $- \nu \Delta U + a(U + y\cdot\nabla U) + (U\cdot\nabla)U + \nabla P = 0$, $\operatorname{div} U = 0$, on the three-dimensional half-space $\mathbb{R}^3_+$ with the no-slip boundary condition $U|_{y_3=0}=0$. Prior exclusion results in the half-space required independent assumptions on pointwise gradient decay or pressure boundary behavior to justify integration by parts. By combining interior annular Stokes-regularity estimates for the associated ancient mild solution with an even-reflection harmonic gradient vanishing theorem in $L^2+L^4$, we prove that the velocity decay $|U(y)| \le C/(1+|y|)$ alone automatically implies finiteness of the weighted second-derivative norm $\int_{\mathbb{R}^3_+} |y|\,|\Delta U|^2\,dy < \infty$ and uniquely recovers the canonical pressure, yielding a complete quantitative exclusion under the Lamb-vector alignment inequality.

## Open Boundaries

- Unrestricted half-space backward self-similar profiles without the Lamb-vector alignment inequality

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20002392_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_20002392_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `velocity-only-profile-exclusion.md` | Mathematical proof / verification artifact |
| `automatic-profile-pressure.md` | Mathematical proof / verification artifact |
| `velocity-only-contribution.md` | Mathematical proof / verification artifact |
| `radial-pressure-upper-bound.md` | Mathematical proof / verification artifact |
| `certify_planar_comparison.py` | Mathematical proof / verification artifact |
| `verification-summary.json` | Structured verification summary |
