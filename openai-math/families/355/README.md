# 355. Unique tangent flows at the first surface singularity.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Stokes/Gevrey core extended to radial weights 1<=m<=2 with c_m nonzero; claimed 'sharper' factorial lower bound n b_n >= 2^{n-1}(n-1)! | preprints/Tangent-flow-uniqueness-2026-09-24/build/sections/jump.tex:1356-1363 (lem jump:stokes, m=1: l_+-l_- = c_0 y^3 e^{-y^2/2}, c_0 != 0) and :1418-1419 '2^{n-1}(n-1)! <= b_n <= 3^{n-1}(n-1)!' | Sympy: recurrence (7) solves q(1-q)^2=x(1-(m+1)q+2Dq) through x^9. At m=1, b_n=1,2,11,90,943,... satisfies the manuscript's stronger b_n >= 2^{n-1}(n-1)! |

Main files:

- [`first-pass/stokes_audit/proof.md`](first-pass/stokes_audit/proof.md)
- [`first-pass/stokes_audit/lean/Main.lean`](first-pass/stokes_audit/lean/Main.lean)
- [`first-pass/stokes_audit/lean/statement_fidelity.md`](first-pass/stokes_audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
