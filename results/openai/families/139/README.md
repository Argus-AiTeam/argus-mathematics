# 139. Subpolynomial query complexity for log-concave sampling.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | thm:tensor-divergence via general non-Gaussian transfer theorem | Subpolynomial-query-complexity-for-well-conditioned-log-concave-sampling-September-26-2026/build/sections/divergence.tex:195-210 (bound for xi_rho) | Read Theorems A/B. Hypotheses (B) are exactly the all-order split bounds the manuscript derives for its law (prop:gaussian-jets). |

Main files:

- [`first-pass/divergence_audit/report.md`](first-pass/divergence_audit/report.md)
- [`first-pass/divergence_audit/lean/Main.lean`](first-pass/divergence_audit/lean/Main.lean)
- [`first-pass/divergence_audit/Main.lean`](first-pass/divergence_audit/Main.lean)
- [`first-pass/divergence_audit/statement_fidelity.md`](first-pass/divergence_audit/statement_fidelity.md)
- [`first-pass/divergence_audit/lean/statement_fidelity.md`](first-pass/divergence_audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
