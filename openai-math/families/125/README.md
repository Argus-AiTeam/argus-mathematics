# 125. The metric <i>k</i>-median approximation threshold and recovery.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | thm:finite-inequality 2Theta -> 1.99Theta (row penalty 1.6->1.59, 656 Bernstein cells) | The-Approximation-Threshold-for-Metric-k-Median-September-24-2026/build/sections/inequality.tex:52-59: '... <= 2Theta' | Random test of the finite inequality (6e4 instances, n<=3, adversarial R_i): max ratio LHS/Theta 0.69, so no violation, but this does not stress near-extremal cases. The Bernstein certificates were not re-run. |

Main files:

- [`first-pass/finite_comparison/report.md`](first-pass/finite_comparison/report.md)
- [`first-pass/finite_comparison/lean/Main.lean`](first-pass/finite_comparison/lean/Main.lean)
- [`first-pass/finite_comparison/lean/statement_fidelity.md`](first-pass/finite_comparison/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
