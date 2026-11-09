# 108. A cubic permanent–determinant lower bound.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Gradient codimension k^2+k-binom(q+2,2) -> k^2+k-(q+1)^2 (and (a+1)(b+1) any char) | A-cubic-lower-bound-for-border-determinantal-complexity-of-the-permanent-September-24-2026/build/source/sections/dimension.tex:14-27: 'T=binom(q+2,2) ... dim{X: grad G_D(X)=0} <= k^2+k-T' | Recomputed k=128,q=42: 15566 vs 14663 (matches). Checked a=b=q gives c=k-1-2q=r-1, consistent with the manuscript. The algebro-geometric rectangle (conductor/row-scheme) argument was not independently verified. |

Main files:

- [`first-pass/spectral_bridge/proof.md`](first-pass/spectral_bridge/proof.md)
- [`first-pass/spectral_bridge/formal/Main.lean`](first-pass/spectral_bridge/formal/Main.lean)
- [`first-pass/spectral_bridge/formal/statement_fidelity.md`](first-pass/spectral_bridge/formal/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
