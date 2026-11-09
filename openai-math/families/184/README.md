# 184. Correspondence coloring with a fixed forbidden subgraph.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | thm:weighted-triangles generalized from profile s(x+log(1/s)) to s(x+log+(1/s))^p for all p>=1, with strict hierarchy | preprints/A-Logarithmic-Independence-Bound-for-Clique-Free-Graphs-September-25-2026/build/sections/invariant.tex:14-31 eq:cross-mass and thm:weighted-triangles (g_x(s)=s(x+log(1/s))) | Checked the new p-dependent steps (7)-(9) by hand. Applying (P) at 20x^2 gives w(B_v) <= C21^p x^{2p-k} s_v. g_{p,x}(b) <= (2x)^p(b+e^{-x}). P(u in B_v\|v) <= C^2 42^p x^{-4} + C2^p x^{p+2}e^{-x} <= E x^{-4} for x >= (p+6)^2. The entropy-increment, splitting and iteration parts, and the hierarchy example, were not checked. Lean covers only the finite core. |

Main files:

- [`first-pass/triangle_audit/proof.md`](first-pass/triangle_audit/proof.md)
- [`first-pass/triangle_audit/Main.lean`](first-pass/triangle_audit/Main.lean)
- [`first-pass/triangle_audit/statement_fidelity.md`](first-pass/triangle_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
