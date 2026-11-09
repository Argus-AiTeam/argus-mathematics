# 374. Sharp one-third stability of Brenier maps.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Stationary-site moment estimate constant C_0=162 improved to optimal 1 (finite two-intercept form), potential constant 2R instead of (1+sqrt162)R | preprints/Sharp-One-Third-Stability-of-Brenier-Maps-September-25-2026/build/source/sections/moments.tex:8-17 'sum \|DB_i[q,0]\|^2/M_i <= C_0R^2 sum \|DM_i[q,0]\|^2/M_i, C_0=162' | Sympy: identity (4) \|ax-bz\|^2/h+2aPhi(x)+2bPhi(z)-(4ab/h)Phi((x+z)/2) = (a-b)^2R^2/h verified symbolically in R^3. Monte-Carlo 1D Laguerre cells (3000 random configs, N<=5): max ratio LHS/RHS of finite inequality (1) = 0.957 <= 1 |

Main files:

- [`first-pass/cell_moment_audit/Main.lean`](first-pass/cell_moment_audit/Main.lean)
- [`first-pass/cell_moment_audit/statement_fidelity.md`](first-pass/cell_moment_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
