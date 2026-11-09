# 239. Sharp singularity rates for symmetric random sign matrices.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Low-height cover for log H(W) <= N(log N)^{1/9}, radius N(log N)^{-2/3}, log2 size <= 1e5 N^2 (log N)^{-1/9} (vs H <= exp(N l^D), l=loglogN) | openai-math/preprints/The-sharp-exponential-rate-of-singularity-for-symmetric-Bernoulli-matrices-October-3-2026/build/sections/04-low-height-cover.tex:28-41 thm:low-height-cover (\|C\| <= 2^{N^2 l^{-A}}, H(W) <= exp(N l^D), distance N l^{-A}, l=log log N per 02-framework.tex:38) | Derived Corollary R from Theorem Q with a = L^{-2/9}: distance b/(aL) = N L^{-2/3}, the b^2/(a^3 L) and aNb terms are about N^2 L^{-1/9}, the N^{2-2a} term is negligible, and the total is about 2e4 N^2 L^{-1/9} <= 1e5. This dominates the manuscript bound for every fixed D, A. |

Main files:

- [`first-pass/low_height_audit/report.md`](first-pass/low_height_audit/report.md)
- [`first-pass/low_height_audit/Main.lean`](first-pass/low_height_audit/Main.lean)
- [`first-pass/low_height_audit/statement_fidelity.md`](first-pass/low_height_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
