# 334. A smooth surface metric with no local isometric immersion in ℝ<sup>3</sup>.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Proposition cap extended to curvature kappa(x^{2m}-h(y)), drift mu>1/2, weight exponent p>=4 (manuscript p=8) | A-Smooth-Metric-with-No-Local-Isometric-Immersion-into-Three-Space-September-24-2026/build/sections/caps.tex Proposition cap (p=8 auxiliary weight) | Located where p enters (report lines 191-371): p>=4 is only needed for d^{p-4} to be bounded, i.e. an auxiliary weight exponent. |

Main files:

- [`first-pass/cap_audit/report.md`](first-pass/cap_audit/report.md)
- [`first-pass/cap_audit/statement_fidelity.md`](first-pass/cap_audit/statement_fidelity.md)
- [`first-pass/cap_audit/Main.lean`](first-pass/cap_audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
