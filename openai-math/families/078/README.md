# 078. The three-dimensional Bochner–Riesz conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Unequal-rate directional bootstrap targets min{s_B,(s_A+s_B)/2}, min{s_A,(s_A+s_B)/2} | preprints/Bochner-Riesz-Multipliers-in-Three-Dimensions-September-24-2026/build/sections/07-rate-transfer.tex:841 prop:directional-bootstrap (one common rate s) | Verified the fixed point of T_A=min{s_B,(s_B+y)/2}, T_B=min{s_A,(s_A+x)/2} equals the stated targets and contraction factor 1/2 |

Main files:

- [`first-pass/directional_bootstrap/report.md`](first-pass/directional_bootstrap/report.md)
- [`first-pass/directional_bootstrap/Main.lean`](first-pass/directional_bootstrap/Main.lean)
- [`first-pass/directional_bootstrap/statement_fidelity.md`](first-pass/directional_bootstrap/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
