# 073. The Falconer distance conjecture.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Sharper count n<=3K+2+N/q in scheduled recursion | preprints/The-Falconer-distance-conjecture-in-all-dimensions-September-23-2026/build/sections/09_ledger.tex:135 lem ledger:termination '<=20/kappa non-low transitions' (internal count 5K+2) | Compared Argus count with manuscript internal count 5K+2 |

Main files:

- [`first-pass/statement_fidelity.md`](first-pass/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
