# 131. Rapid mixing of graph switches for every degree sequence.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Coefficient 1 on equality-projection errors is optimal | Polynomial-Mixing-of-the-Switch-Chain-...-September-25-2026 disjoint.tex dis:interaction (coefficient 1) | Read the explicit family. The ratio -I_m/E_m = m/(m+2) -> 1 is consistent with the stated deviations. |

Main files:

- [`first-pass/disjoint_core/lean_evidence/Main.lean`](first-pass/disjoint_core/lean_evidence/Main.lean)
- [`first-pass/disjoint_core/Main.lean`](first-pass/disjoint_core/Main.lean)
- [`first-pass/disjoint_core/report.md`](first-pass/disjoint_core/report.md)
- [`first-pass/disjoint_core/statement_fidelity.md`](first-pass/disjoint_core/statement_fidelity.md)
- [`first-pass/disjoint_core/lean_evidence/statement_fidelity.md`](first-pass/disjoint_core/lean_evidence/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
