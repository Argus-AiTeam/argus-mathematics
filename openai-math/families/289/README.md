# 289. Strong Kadison–Kastler stability and its spatial boundaries.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | lem:free-words: bound 5*sqrt((r-1)!)d^{-(r-1)/2} for all multisets W (manuscript: 7 for distinct labels, unspecified C_r otherwise), scalar-free partitions without matrix units, explicit threshold D_r | Universal-strong-Kadison-Kastler-stability-September-23-2026/build/sections/03-amplification.tex:129-151 lem:free-words: beta_W = 7 sqrt((r-1)!) d^{-(r-1)/2} if labels distinct, C_r d^{-(r-1)/2} otherwise, for d>=d_r (existential) | Baseline quoted correctly. Sanity-checked r=1,2 by hand using the free-projection norm formula \|\|pq\|\|~2/sqrt(d) for trace-1/d free projections (within the bound 5/sqrt d). The general r free-product norm argument was not checked independently. |

Main files:

- [`first-pass/free_word_audit/report.md`](first-pass/free_word_audit/report.md)
- [`first-pass/free_word_audit/Main.lean`](first-pass/free_word_audit/Main.lean)
- [`first-pass/free_word_audit/statement_fidelity.md`](first-pass/free_word_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
