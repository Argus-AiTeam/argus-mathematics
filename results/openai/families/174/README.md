# 174. Deterministic construction of strong thin spanning trees.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | thm:extraction resistance threshold 4r^{-1/2} -> r^{-1/2}/(1-40r^{-3/16}) = (1+o(1))r^{-1/2} | preprints/The-strong-thin-tree-conjecture-September-23-2026/build/source/sections/extraction.tex:20 'the edges with R_X(e)<=4r^{-1/2} contain q edge-disjoint spanning trees' | Checked the key step by hand. The manuscript uses a 1/2-weight Markov split, giving 2r^{-1/2}, and then s<4r^{-1/2}. Argus uses the threshold theta=1-delta/u with delta=40r^{-1/4}, u=r^{-1/16}. Then bad edges <= delta M/(1-theta) = uM, good edges >= (1-u)M >= q(d-1), which contradicts packing-parts (iii), and R <= r^{-1/2}/theta = r^{-1/2}/(1-40r^{-3/16}). |

Main files:

- [`first-pass/extraction_consistency/Main.lean`](first-pass/extraction_consistency/Main.lean)
- [`first-pass/extraction_consistency/proof.md`](first-pass/extraction_consistency/proof.md)
- [`first-pass/extraction_consistency/statement_fidelity.md`](first-pass/extraction_consistency/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
