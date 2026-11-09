# 226. The double-dimer loop ensemble converges to CLE<sub>4</sub>.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Cap weights B^{-b(A)}, B>M-1; with B=M detection constant 1/(2M^{2M}) vs (2M)^{-2(M-1)}/16 (ratio 2^{2M+1}/M^2); decay (M-1)/B | openai-math/preprints/The-curve-scaling-limit-of-half-plane-double-dimers-September-23-2026/build/sections/30-short-segment.tex:378-383 (w=(2M)^{-b}, q_M=(2M)^{-(M-1)}), :396-438 lem:cap-weight-decrease (factor 1/2), :511 eq:pointwise-detection X >= q_M^2/16 | Checked the key step. Inner arches number at most M-1 because the outer loop uses at least one of the at most M eligible arches, giving decay r=(M-1)/B. An alternating sum with ratio <= r is >= (1-r) times its head, giving coefficient (1-r)^2 q^2/2. Recomputed: B=M gives 1/(2M^{2M}), the ratio to the manuscript is 2^{2M+1}/M^2, and B=2M gives (M+1)^2/(8M^2) q_M^2 >= q_M^2/16. |

Main files:

- [`first-pass/cap_positivity/report.md`](first-pass/cap_positivity/report.md)
- [`first-pass/cap_positivity/Main.lean`](first-pass/cap_positivity/Main.lean)
- [`first-pass/cap_positivity/statement_fidelity.md`](first-pass/cap_positivity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
