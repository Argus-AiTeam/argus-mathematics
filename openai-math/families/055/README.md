# 055. Gepner symmetry and large-volume stability on threefolds.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Comparison radius 1/200000 -> 1/4000; explicit refinement radius 1/500000, support constant 3e7, sufficient range u<13/46 | preprints/A-Gepner-stability-condition-on-every-smooth-quintic-threefold-September-24-2026/build/sections/aisles.tex:447 'Omega={\|eta_0\|,\|eta_1\|<5*10^-6}' (with delta=10^-5, s0=553/1000 at :157; margins use loosened envelope f(1/2)=-3/100, :35) | Recomputed all four margins exactly at delta=1/2000, s=13/23, u<138197/500000 (539/2000, 2857/125000, 62469/11500000, 61719/6500000 >0); checked max over [1/2,13/23] of Xu's g(x)-x/2 = -13/46; checked Argus's boundary margin 3/10-u uses Xu's exact g(1/2)=-1/20 which the manuscript itself quotes (aisles.tex:45-50) before loosening to f; Lean core exit 0 no holes |

Main files:

- [`first-pass/gepner-aisle-audit/report.md`](first-pass/gepner-aisle-audit/report.md)
- [`first-pass/gepner-aisle-audit/lean-evidence/Main.lean`](first-pass/gepner-aisle-audit/lean-evidence/Main.lean)
- [`first-pass/gepner-aisle-audit/Main.lean`](first-pass/gepner-aisle-audit/Main.lean)
- [`first-pass/gepner-aisle-audit/statement_fidelity.md`](first-pass/gepner-aisle-audit/statement_fidelity.md)
- [`first-pass/gepner-aisle-audit/lean-evidence/statement_fidelity.md`](first-pass/gepner-aisle-audit/lean-evidence/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
