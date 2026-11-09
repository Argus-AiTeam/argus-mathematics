# 084. The geometric case of the Erdős similarity conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | lem:conditional-scales miss probability [1+k(1+2c/q^{2r})](1-p/2)^k | preprints/The-geometric-case-of-the-Erdos-similarity-conjecture-October-5-2026/build/sections/05-scales.tex:12 lem:conditional-scales, D=4+2(M-1)r(1+2cq^{-2r}), bound D e^{-p(M-1)r/2} | Checked the monotone lifted-floor argument (distinct floor vectors <= 1+s(2)-s(1)) and that (1-p/2)^k is the manuscript's own exact test-failure value (04-routing.tex:161-165) |

Main files:

- [`first-pass/geometric-bridge/lean-evidence/Main.lean`](first-pass/geometric-bridge/lean-evidence/Main.lean)
- [`first-pass/geometric-bridge/Main.lean`](first-pass/geometric-bridge/Main.lean)
- [`first-pass/geometric-bridge/proof.md`](first-pass/geometric-bridge/proof.md)
- [`first-pass/geometric-bridge/lean-evidence/statement_fidelity.md`](first-pass/geometric-bridge/lean-evidence/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
