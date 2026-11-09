# 012. Independent largest prime factors of consecutive integers.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Quantitative conditional refinement of eq.(45): E0+rho_B+O(B^{-3/200}) vs E0+eps2+o(1) | openai-math/preprints/The-joint-Dickman-law-for-consecutive-integers-September-24-2026/build/sections/sampling.tex prop:sampling-comparison eq.(45): 'E\|\|E(S;s)\|\| <= E0+eps2+o(1)' for every fixed eps2>0 (quoted in review) | Read review's rate calculation; compared with manuscript form. |

Main files:

- [`first-pass/adaptive-cut-transfer/report.md`](first-pass/adaptive-cut-transfer/report.md)
- [`first-pass/adaptive-cut-transfer/Main.lean`](first-pass/adaptive-cut-transfer/Main.lean)
- [`first-pass/adaptive-cut-transfer/statement_fidelity.md`](first-pass/adaptive-cut-transfer/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
