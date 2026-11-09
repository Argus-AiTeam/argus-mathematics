# 269. Uniform Laughlin gap and stability under bounded scalar disorder.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | prop:retained-blocks: retain all pair deficits except l=4,10,12,14 (vs only l>=23), for every c<0.04785933319001 | preprints/Uniform-Stability-of-the-Spherical-Laughlin-Gap-October-5-2026/build/appendices/retained-blocks.tex:41-51 "For every fixed 0<c_0<1/25 ... H_q^2 >= c_0 H_q + L_4(W_4 R_q^hi W_4^dagger)" with R_q^lo = sum_{l=0}^{22} P_{q,l} | Replayed Argus exact-rational verifier in an isolated copy ((check script), upstream rows.txt linked read-only): recomputed certificate matches stored one; all exact PSD checks for the manuscript and selective allowances pass; consumed D={5,11,13,15} (l=4,10,12,14), gamma=4785933319001/1e14, gain 423/250000 over the companion 0.04616733319001. |

Main files:

- [`first-pass/retained_blocks/theorem.md`](first-pass/retained_blocks/theorem.md)
- [`first-pass/retained_blocks/statement_fidelity.md`](first-pass/retained_blocks/statement_fidelity.md)
- [`first-pass/retained_blocks/lean/statement_fidelity.md`](first-pass/retained_blocks/lean/statement_fidelity.md)
- [`first-pass/retained_blocks/lean/Main.lean`](first-pass/retained_blocks/lean/Main.lean)
- [`first-pass/retained_blocks/Main.lean`](first-pass/retained_blocks/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
