# 080. The exact Sobolev endpoint for Schrödinger convergence.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Quartic growth eq:src22 via two-curvature-derivative argument, no fixed temporal support | preprints/Endpoint-convergence-for-the-planar-Schrodinger-equation-September-24-2026/build/sections/05-frame.tex:541 lem:frame-quartic eq:src22 '<=_K lambda^2 D' | Baseline confirmed; Argus report compares proof methods |

Main files:

- [`first-pass/quartic-core/report.md`](first-pass/quartic-core/report.md)
- [`first-pass/quartic-core/lean/Main.lean`](first-pass/quartic-core/lean/Main.lean)
- [`first-pass/quartic-core/lean/statement_fidelity.md`](first-pass/quartic-core/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
