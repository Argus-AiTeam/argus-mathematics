# 039. Nagata’s conjecture and maximal Seshadri constants.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Reshaping proposition under dw<1/3 (vs dw<1/16) with backward transfer of mixed-order max jet ranks | openai-math/preprints/Maximal-multipoint-Seshadri-constants-in-positive-characteristic-October-5-2026/build/build/sections/04-reshape.tex:20 prop:reshape 'For every w>0 with dw<1/16'; lem:primitive-height l.193 uses j = power of two <= 1/(2dw) | Checked the load-bearing fixed-three lemma: with u=(i,3), need R-3W>0 (iff dw<1/3) and an integer i not divisible by 3 in an open interval of length 3T/(1+T)>=18/7>2; area/height-range argument (l.264-275) is independent of j. Random test 2e5 (A,B,w) with dw<1/3: 0 failures. Lean fixed-three exit 0, no sorry. |

Main files:

- [`first-pass/reshaping_audit/report.md`](first-pass/reshaping_audit/report.md)
- [`first-pass/reshaping_audit/lean/Main.lean`](first-pass/reshaping_audit/lean/Main.lean)
- [`first-pass/reshaping_audit/Main.lean`](first-pass/reshaping_audit/Main.lean)
- [`first-pass/reshaping_audit/statement_fidelity.md`](first-pass/reshaping_audit/statement_fidelity.md)
- [`first-pass/reshaping_audit/lean/statement_fidelity.md`](first-pass/reshaping_audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
