# 021. A quadratic bound for Jacobsthal’s function.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Coefficient-independent nonlinear lattice-point bound 512 d^3(1+ceil(S^{2/3})) vs manuscript O(D_0^4(1+S^{2/3})) | openai-math/preprints/A-quadratic-bound-for-Jacobsthals-function-September-25-2026/build/sections/inverse.tex:151-163 lem:nonlinear-points 'is O(D_0^4(1+S^{2/3}))'; proof lines 226-230: 'proves the bound O(d^3(1+S^{2/3})) for this component ... the asserted, slightly looser, bound with D_0^4 follows' | Read manuscript proof; recomputed T^2 vector count and Jarnik-type M^{3/2}/8 total-length bound numerically (M<=2000); sum j^3<=d^3 |
| A | DOWNGRADED | Structural step valid for every fixed alpha<1/5 (manuscript alpha<=1/100) | openai-math/preprints/A-quadratic-bound-for-Jacobsthals-function-September-25-2026/build/sections/inverse.tex:68 'alpha_max=1/100'; :693-697 'R^4 S_q^{-1/3} Z^4 = z^{(13alpha-2)/3+o(1)}=o(1), using alpha<=1/100' | Recomputed exponent with cubic bound: 3alpha-(2-alpha)/3=(10alpha-2)/3<0 iff alpha<1/5 |

Main files:

- [`first-pass/inverse_certificate/REPORT.md`](first-pass/inverse_certificate/REPORT.md)
- [`first-pass/inverse_certificate/Main.lean`](first-pass/inverse_certificate/Main.lean)
- [`first-pass/inverse_certificate/statement_fidelity.md`](first-pass/inverse_certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
