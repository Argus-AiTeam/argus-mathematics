# 009. Function-field reconstruction from Milnor K-theory and Galois data.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | prop:intersection without finite p-rank hypothesis; uniqueness from either single inclusion | openai-math/preprints/Reconstruction-from-Milnor-K-theory-modulo-the-characteristic-October-5-2026/build/build/sections/03-intersection.tex:17-37 'Let F be a field of characteristic p with [F:F^p]<infty ... In fact, either inclusion ... determines n uniquely. In each inclusion, both coefficients are nonzero.' | Read manuscript statement/proof; lean_check.json status success exit_code 0, 0 sorry in Main.lean. |
| A | DOWNGRADED | Line recovery for every char-p field of finite p-degree >= p^2, incl. p=2 | openai-math/preprints/Reconstruction-from-Milnor-K-theory-modulo-the-characteristic-October-5-2026/build/build/sections/04-lines.tex:32-37 prop:lines 'finitely generated extensions of algebraically closed fields of characteristic p, both of transcendence degree at least two ... unique n in F_p^x such that Psi=n Theta sends every projective line over K^p onto a projective line over L^p' | Read manuscript proof of prop:lines; grep shows no p=2 exclusion anywhere in the manuscript. |

Main files:

- [`first-pass/char-p-line-recovery/Main.lean`](first-pass/char-p-line-recovery/Main.lean)
- [`first-pass/char-p-intersection/Main.lean`](first-pass/char-p-intersection/Main.lean)
- [`first-pass/char-p-line-recovery/report.md`](first-pass/char-p-line-recovery/report.md)
- [`first-pass/char-p-intersection/report.md`](first-pass/char-p-intersection/report.md)
- [`first-pass/char-p-line-recovery/statement_fidelity.md`](first-pass/char-p-line-recovery/statement_fidelity.md)
- [`first-pass/char-p-intersection/statement_fidelity.md`](first-pass/char-p-intersection/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
