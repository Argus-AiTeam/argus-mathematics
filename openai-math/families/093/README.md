# 093. Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | lem:entropy-loss without exponential-square moment on p; robust to sublinear-rank adaptive projections | preprints/A-dimension-free-logarithmic-Sobolev-inequality-for-subgaussian-log-concave-measures-September-23-2026/build/sections/04-prediction.tex:186 lem:entropy-loss (assumes E_p e^{c\|Y\|^2}<inf) | Checked the strictness example p=2/(pi(1+x^2)^2), q~e^{-sqrt(1+x^2)}: score bounded so I<inf, H<inf, but no exp-square moment |

Main files:

- [`first-pass/entropy-loss-audit/report.md`](first-pass/entropy-loss-audit/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
