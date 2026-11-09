# 377. Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Quantitative three-point flatness D(U) <= min{L, 4096 L^{6/7} eps^{1/7}} (manuscript: qualitative -> 0) | preprints/Uniform-Interior-C1alpha-Estimates-for-Infinity-Harmonic-Functions-October-4-2026/build/manuscript/sections/02-flatness.tex:121-131 (sequence statement: \|\|U_i-l_i\|\|->0 implies sup ... -> 0) | Confirmed the baseline is qualitative. Checked the cutoff polynomial facts (P'=30t^2(1-t)^2 <= 15/8) and the maximum-location bounds (2)-(4) by reading. The theorem-of-sums step was not checked |

Main files:

- [`first-pass/three_point_flatness/report.md`](first-pass/three_point_flatness/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
