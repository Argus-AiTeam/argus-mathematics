# 007. Ordinary two-point correlations and the corrected Elliott conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Explicit constant C=2048 in forest-coding bound exp(Ck), general bound 2^(10n+3)(2n)^((6r-4)B+I) | openai-math/preprints/Ordinary-two-point-correlations-of-multiplicative-functions-September-24-2026/build/quantitative/06-forest.tex:104 'a set of cardinality at most exp(Ck), for an absolute constant C. This set can be chosen independently of all numerical coefficients' | Rechecked specialization arithmetic (66 L^{23/25} * (25/2) L^{2/25} + 40L = 865L <= 1730k < 2048k with k=floor(L)); Lean: lean_check.json exit_code 0, no sorry, but only C_FOREST_FORMAL_CORE is formal. |

Main files:

- [`first-pass/forest_coding/report.md`](first-pass/forest_coding/report.md)
- [`first-pass/forest_coding/Main.lean`](first-pass/forest_coding/Main.lean)
- [`first-pass/forest_coding/statement_fidelity.md`](first-pass/forest_coding/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
