# 228. Continuum phase transitions for radial pair potentials.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | k:range error improved from C sqrt(R0/R) to C min{a, sqrt(a R0/R)} | openai-math/preprints/A-radial-continuum-phase-transition-with-algebraic-decay-September-24-2026/build/sections/range.tex:13-33 eq k:range-estimate '<= C_{D,t} sqrt(R0/R)' uniform in a | Checked that the manuscript's own proof already carries the new-kernel error as beta*a*eta with eta=C_w s/R (range.tex:149, 300-345), so the error is B1 R0/s + B2 a s/R. Choosing s ~ sqrt(R0 R/a), plus the trivial \|Q_full - T_a Q_0\| = O(a), gives the min. Since min{a, sqrt(a R0/R)} <= sqrt(A+1) sqrt(R0/R), the new bound implies the old. |

Main files:

- [`first-pass/range_audit/report.md`](first-pass/range_audit/report.md)
- [`first-pass/range_audit/Main.lean`](first-pass/range_audit/Main.lean)
- [`first-pass/range_audit/statement_fidelity.md`](first-pass/range_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
