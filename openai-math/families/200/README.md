# 200. Eisenbud–Green–Harris and lex-plus-powers.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | thm:division index proof works with any constant connected etale finite-group cover of a positive-genus curve | openai-math/preprints/Commuting-Division-Coefficient-Forms-and-the-Artinian-Eisenbud-Green-Harris-Conjecture-September-23-2026/build/sections/06-descent.tex:11-40 thm:division (k, Delta_0, b>=2, dim U>=3, W, h, M as in eq:division-parameters) | Read the statement and the report's scope section |

Main files:

- [`first-pass/division_index_audit/report.md`](first-pass/division_index_audit/report.md)
- [`first-pass/division_index_audit/lean/Main.lean`](first-pass/division_index_audit/lean/Main.lean)
- [`first-pass/division_index_audit/lean/statement_fidelity.md`](first-pass/division_index_audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
