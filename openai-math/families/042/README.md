# 042. Oka classification for minimal compact complex surfaces: Kodaira dimension zero and class VII.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Explicit sewing constants (b=r/4, N=8(A+2), K=1024N^6, e*=d^7/(1024K)) and holomorphic dependence on passive parameters T for sew:chain | openai-math/preprints/Every-complex-K3-surface-is-Oka-September-23-2026/build/sections/sewing.tex:24-66 sew:chain 'There are b>0 and e_*>0, depending only on h,r,A ... such that, if e<e_*' | Verified the quadratic-recurrence bookkeeping: x_n=B2^{6(n+1)}e_n satisfies x_{n+1}<=x_n^2, x_0=theta<d/16, and K delta_n^{-7} e_n <= 2^{n-6}theta^{2^n-1}/16 <= 1/1024; Newton-step estimate e_new<=38N^3 delta^{-5} e^2 not rechecked |

Main files:

- [`first-pass/sewing-audit/report.md`](first-pass/sewing-audit/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
