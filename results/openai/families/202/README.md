# 202. The blockwise Alperin weight conjecture.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | thm:inseparable-genus generalized to rank-profile inequality over any perfect field; sharper threshold N > p^a U_p(a,h) vs p^{s-h} > m(h+log_p m); strictness N>dE needed | openai-math/preprints/The-Blockwise-Alperin-Weight-Conjecture-September-23-2026/build/sections/differentials.tex:35-54: threshold p^{s-h} > m(h+log_p m), conclusion nu(Z)/d >= sum(1-1/r_i) | Brute force over all ordered stage-rank compositions for p in {2,3,5}, h=0..5, a=1..8: the maximum error profile equals U_p(a,h) exactly and U_p <= h+a. Reproduced the example p=2,h=1,m=8, where the threshold drops from 32 to 16. |

Main files:

- [`first-pass/genus-bound-audit/report.md`](first-pass/genus-bound-audit/report.md)
- [`first-pass/genus-bound-audit/lean/Main.lean`](first-pass/genus-bound-audit/lean/Main.lean)
- [`first-pass/genus-bound-audit/lean/statement_fidelity.md`](first-pass/genus-bound-audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
