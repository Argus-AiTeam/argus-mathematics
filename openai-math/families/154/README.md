# 154. Pointwise multiple ergodic averages for mixing transformations.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Row maximal/depth constant (8/3)sqrt(9+L_D^2) -> sqrt(81+(324/49)L_D^2) | preprints/Pointwise-convergence-of-triple-ergodic-averages-for-mixing-transformations-October-4-2026/build/paper/sections/rows.tex:263-264 'L_D=1+ceil(5log2 D), C_D=(8/3)sqrt(9+L_D^2)' | Recomputed both constants for D=2..1e6. The new constant is smaller by 0.15% (D=2) to about 3.6% (large D). |

Main files:

- [`first-pass/row_maximal/report.md`](first-pass/row_maximal/report.md)
- [`first-pass/row_maximal/Main.lean`](first-pass/row_maximal/Main.lean)
- [`first-pass/row_maximal/statement_fidelity.md`](first-pass/row_maximal/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
