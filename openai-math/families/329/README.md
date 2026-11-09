# 329. A counterexample to metric-entropy duality.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Optimal dilation loss over profiles on {0..H-1} is exactly 1/k (3^{k-1}<=H<3^k); k-level compression improves the leading entropy-ratio coefficient by factor k/H | Counterexamples-to-the-duality-conjecture-for-metric-entropy-September-24-2026/build/sections/03-compression.tex:56-73 lem:log-profile (loss log3/log(h+1)); 05-counterexample.tex:98-104 eq:entropy-ratio 2h^2 s/(r+h-1) | LP check ((check script)): the minimax value equals 1/k for every H=1..39. Checked the band partition j<a_{l+1}<=3j+2 <=> a_l<=j<a_{l+1}, disjointness of (3^l-1,3^{l+1}-1], and log Q ~ k s D_{H-1} log p => ratio 2Hks/(r+H-1). |

Main files:

- [`first-pass/sparse_profile/Main.lean`](first-pass/sparse_profile/Main.lean)
- [`first-pass/sparse_profile/report.md`](first-pass/sparse_profile/report.md)
- [`first-pass/sparse_profile/statement_fidelity.md`](first-pass/sparse_profile/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
