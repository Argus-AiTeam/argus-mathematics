# 024. An asymptotic formula for the number of totients.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Quantitative prop:collisions with explicit tail C e^{-kappa B/m^4}+C sum_{h>=H} h^4 e^{-kappa rho^{-h}/h^3}, uniform in 0<=t<=x | openai-math/preprints/An-asymptotic-formula-for-the-number-of-totients-September-25-2026/build/source/collisions.tex:26-38 'For t=x or t=x/c ... K(t)<=(eps_H+o(1)) xG_m/log x'; proof :317-326 'C sum_{h>=H} h^4 exp{-c_4 rho^{-h}/h^3}' and 'O((x/log x)exp{-c_2 B/m^4})' | Compared Argus bound (T) to the manuscript proof's explicit displays; checked monotonicity of K(t) in t |

Main files:

- [`first-pass/prefix-collisions/proof.md`](first-pass/prefix-collisions/proof.md)
- [`first-pass/prefix-collisions/Main.lean`](first-pass/prefix-collisions/Main.lean)
- [`first-pass/prefix-collisions/statement_fidelity.md`](first-pass/prefix-collisions/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
