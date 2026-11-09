# 142. Deterministic polynomial factorization over prime fields.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | norm:solve precision M=10q^2(N+D+1) -> L=N+D+2 | Deterministic-Polynomial-Factorization-over-Prime-Fields-October-4-2026/build/sections/03-norms.tex:427,552 'M=10q^2(N+D+1)'; theorem statement l.11-36 asserts only polynomial bounds | Read the verification theorem statement. M is an internal algorithm precision parameter. |

Main files:

- [`first-pass/norm_solver/report.md`](first-pass/norm_solver/report.md)
- [`first-pass/norm_solver/Main.lean`](first-pass/norm_solver/Main.lean)
- [`first-pass/norm_solver/statement_fidelity.md`](first-pass/norm_solver/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
