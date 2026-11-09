# 164. Hindman’s finite sums and products conjecture.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:rough-step superpolynomial scale Z/S^a->inf weakened to Z>=kappa S^{A*}, A*=2Ds^{n-1}+2 | preprints/Monochromatic-finite-sums-and-products-in-the-positive-integers-September-23-2026/build/sections/06_rough_progressions.tex:279 'Z/S^a -> infinity for every fixed a>0' | Read the manuscript proof (it uses p_z/Z->0 and interpolation errors (S/Z)^e) and Argus Theorem 2. Not independently checked: whether the exponent A* suffices throughout the dimension induction. |

Main files:

- [`first-pass/rough_step/report.md`](first-pass/rough_step/report.md)
- [`first-pass/rough_step/Main.lean`](first-pass/rough_step/Main.lean)
- [`first-pass/rough_step/statement_fidelity.md`](first-pass/rough_step/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
