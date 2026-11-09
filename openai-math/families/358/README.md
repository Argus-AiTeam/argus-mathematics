# 358. A three-manifold without conjugate points or nonpositive curvature.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Attained necessary-and-sufficient endpoint reduction for returning passages, quantitative normal-energy gap, explicit delta_* interval | preprints/A-Three-Manifold-Without-Conjugate-Points-and-Without-a-Nonpositively-Curved-Metric-September-24-2026/build/sections/turning.tex:11-17 'For all sufficiently small positive delta, every returning geodesic passage ... has nonnegative perpendicular index form' | Confirmed the baseline is qualitative (nonnegativity, delta sufficiently small). Spot-checked the arithmetic m=144/3^12=16/59049. The Schur-complement reduction was not checked |

Main files:

- [`first-pass/returning_passage/REPORT.md`](first-pass/returning_passage/REPORT.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
