# 023. Patterson's first moment for cubic Gauss sums.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | z in [7/5,19/10) with uniform gap 1/30 replacing qualitative 4/3<z<2; LP-optimal among width>=1/2 intervals | openai-math/preprints/An-unconditional-first-moment-for-cubic-Gauss-sums-September-25-2026/build/sections/dual.tex:430-434 'Some fixed integer multiple of a lies strictly between 4/3 and 2 ... 4/3<z<2'; :461-465 gaps '(2-z)/3; (3z-4)/6 for z<=3/2, (z-1)/6 for z>=3/2' | Grid check (1e5 points) of min gap on [7/5,19/10] = 1/30; checked LP dual multipliers; Lean lean_check.json status success, 0 sorry |

Main files:

- [`first-pass/exceptional_moments/report.md`](first-pass/exceptional_moments/report.md)
- [`first-pass/exceptional_moments/Main.lean`](first-pass/exceptional_moments/Main.lean)
- [`first-pass/exceptional_moments/statement_fidelity.md`](first-pass/exceptional_moments/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
