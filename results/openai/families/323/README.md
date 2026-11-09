# 323. Independence of the separable quotient problem.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Prescribed-weight estimate (2112/7)L/m_J improved to (1794/7)L/m_J via 2 partial blocks (6 marks instead of 8) | Relative-independence-of-the-separable-quotient-problem-September-23-2026/build/sections/exact-pairs.tex:387 "sum\|f(x_i)\| <= (2112/7) L/m_J < 500 L/m_J"; :269-271 "a rectangle has at most four [boundary blocks] ... at most eight marked indices"; :324 K_0=64 | Verified the crop lemma: blocks successive in every order, and an intersection of convex intervals that meets S_a and S_c contains S_b, so at most 2 partial blocks. Recomputed 12+34/8+(1/8)(130/7)=130/7, 194/(7/8)+130/7=1682/7, and 1682/7+16=1794/7. |

Main files:

- [`first-pass/ch_exact_pair/theorem.md`](first-pass/ch_exact_pair/theorem.md)
- [`first-pass/ch_exact_pair/lean/Main.lean`](first-pass/ch_exact_pair/lean/Main.lean)
- [`first-pass/ch_exact_pair/lean/statement_fidelity.md`](first-pass/ch_exact_pair/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
