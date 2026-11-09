# 195. A counterexample to the small Cohen–Macaulay module conjecture.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | thm:obstruction sharpened to K^2-2c_2 < 6H^2 (so <= 6h-1), and <= 3h for rank-one modules | openai-math/preprints/A-Complete-Local-Domain-Without-a-Small-Cohen-Macaulay-Module-September-23-2026/build/paper.tex:119-125: 'K_X^2-2c_2(X) <= 6H^2'; lem:balance (paper.tex:405-445) only gets HN slope width <= 1 | Checked the load-bearing step: running the manuscript's elementary modification whenever width >= 1 (not only > 1). The max-slope bound mu_max(G(H)) = mu_min+1 <= mu_max(P) still holds at equality, and termination is via average slope. So width < 1, the weighted variance V <= delta^2/4 < 1/4, and the bound is K^2-2c_2 <= (3+3delta^2)h < 6h. For rank one, V=0 gives <= 3h. |

Main files:

- [`first-pass/nongraded-obstruction/REPORT.md`](first-pass/nongraded-obstruction/REPORT.md)
- [`first-pass/nongraded-obstruction/lean/Main.lean`](first-pass/nongraded-obstruction/lean/Main.lean)
- [`first-pass/nongraded-obstruction/Main.lean`](first-pass/nongraded-obstruction/Main.lean)
- [`first-pass/nongraded-obstruction/statement_fidelity.md`](first-pass/nongraded-obstruction/statement_fidelity.md)
- [`first-pass/nongraded-obstruction/lean/statement_fidelity.md`](first-pass/nongraded-obstruction/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
