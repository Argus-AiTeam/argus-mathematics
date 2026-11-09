# 013. Ostmann’s inverse Goldbach conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Explicit C_l=16^r in tree estimate \|E W1 conj W2\| <= 16^r(eps+q^{-1/4}); cycle criterion | openai-math/preprints/the-additive-indecomposability-of-the-primes-September-24-2026/build/sections/06-tree.tex:72-88 'E\|W\|^2<=3^r ... If l>=2 and b<=3r/4 ... at most C_l(eps_q+q^{-1/4}) for a constant depending only on l.' | Recomputed final constant chain: K=2^20, delta=eps^2+q^{-1/2}, 3^{r/2} sqrt(2^{r/4}K^{r/4} delta) = 3^{r/2}2^{21r/8}sqrt(delta) <= 16^r(eps+q^{-1/4}) since 81*2^21 <= 2^32; majorant constants 532480<2^20 checked. |

Main files:

- [`first-pass/tree_comparison/report.md`](first-pass/tree_comparison/report.md)
- [`first-pass/tree_comparison/Main.lean`](first-pass/tree_comparison/Main.lean)
- [`first-pass/tree_comparison/statement_fidelity.md`](first-pass/tree_comparison/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
