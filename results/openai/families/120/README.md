# 120. Almost-linear-time exact matching and prescribed-degree factors in general graphs.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Raw-length transfer 14ZA max{L,O} -> 5ZA max{L,O} | Almost-Linear-Time-Maximum-Cardinality-Matching-in-Sparse-General-Graphs-September-24-2026/build/sections/07-backend-quality.tex:702-703: '<= 2Z_*A_*L_best+12Z_*A_*OPT(J) <= b^2 max{L_best,OPT(J)}' | Checked 2Z+6beta+3 = 182(p+1)+3 <= 200(p+1) = 5Z with beta=17(p+1), Z=40(p+1). |

Main files:

- [`first-pass/raw-length-core/report.md`](first-pass/raw-length-core/report.md)
- [`first-pass/raw-length-core/Main.lean`](first-pass/raw-length-core/Main.lean)
- [`first-pass/raw-length-core/statement_fidelity.md`](first-pass/raw-length-core/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
