# 331. Reflexive midpoint convexity and diamond distortion.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Squared lens constant cannot be below 2 (exact 3-node example); manuscript proves 4 | Midpoint-lenses-in-segment-spaces-September-27-2026/build/sections/introduction.tex:54-61 thm:main-tail: \|\|Q_H y\|\| <= 2 sqrt(R^2-\|\|x\|\|^2) (squared constant 4) | Numerically computed dual norms on the 3-vertex tree ((check script)): \|\|x\|\|^2=16, \|\|y\|\|^2=18, \|\|x+-y\|\|^2=25, so the ratio is 18/(25-16)=2. |

Main files:

- [`first-pass/lens_sharpness/report.md`](first-pass/lens_sharpness/report.md)
- [`first-pass/lens_sharpness/Main.lean`](first-pass/lens_sharpness/Main.lean)
- [`first-pass/lens_sharpness/statement_fidelity.md`](first-pass/lens_sharpness/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
