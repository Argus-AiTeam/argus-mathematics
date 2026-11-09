# 036. Numerical semiampleness and generalized minimal models.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Effective thm:finite-data: explicit C_0, C_gamma, threshold P_* so conclusion holds at every good prime >= P_* | openai-math/preprints/Numerical-Semiampleness-of-Nef-Adjoint-Divisors-October-3-2026/build/sections/frobenius.tex:29-78 thm:finite-data, conclusion 'These data cannot coexist.' (proof uses 'sufficiently large residual characteristic p', l.136) | Recomputed leading coefficient: prod d_i = Lambda^n h^{n-1}, a^n/prod d_i = 7^n h = A <= (14eps)^n < 1/4; threshold logic floor(x)+1 > x fine |

Main files:

- [`first-pass/frobenius_core/REPORT.md`](first-pass/frobenius_core/REPORT.md)
- [`first-pass/frobenius_core/Main.lean`](first-pass/frobenius_core/Main.lean)
- [`first-pass/frobenius_core/statement_fidelity.md`](first-pass/frobenius_core/statement_fidelity.md)
- [`first-pass/frobenius_core/STATEMENT_FIDELITY.md`](first-pass/frobenius_core/STATEMENT_FIDELITY.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
