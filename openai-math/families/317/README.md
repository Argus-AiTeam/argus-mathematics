# 317. Thomason model structures in all strict higher dimensions.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Exact iff criterion (f(x)=g(x) or g(x)=g(y)) for the append-prism formula to give chain maps | Thomason-Model-Structures-in-Every-Strict-Higher-Dimension-September-25-2026/build/sections/05-couniversality.tex lem:relative-prism (upper map constant off the old sieve) | Read the report. The edge criterion is Lean-checked (exit 0). The overall C_COUNIVERSAL is inconclusive and the exact certificate is explicitly partial_result. |

Main files:

- [`first-pass/couniversality_audit/report.md`](first-pass/couniversality_audit/report.md)
- [`first-pass/couniversality_audit/lean/Main.lean`](first-pass/couniversality_audit/lean/Main.lean)
- [`first-pass/couniversality_audit/lean/statement_fidelity.md`](first-pass/couniversality_audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
