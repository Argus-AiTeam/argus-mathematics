# 215. Canonical $`O(3)`$ continuum limit and exact $`O(4)`$ mass asymptotics.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:annulus generalized to signed strengths, rotation-invariant unit-ball measures, n>=3, arbitrary boundary textures with explicit constant | openai-math/preprints/Exponential-decay-in-two-dimensional-classical-On-models-September-23-2026/build/sections/annulus.tex:31-44: min Z/max Z >= 1 - C_beta/log N | Baseline confirmed. The proof was not independently checked. |

Main files:

- [`first-pass/annular-ward-audit/report.md`](first-pass/annular-ward-audit/report.md)
- [`first-pass/annular-ward-audit/Main.lean`](first-pass/annular-ward-audit/Main.lean)
- [`first-pass/annular-ward-audit/statement_fidelity.md`](first-pass/annular-ward-audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
