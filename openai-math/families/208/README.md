# 208. Finite symmetric tensor categories and the Verlinde tower.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Comparison lemma generalized to Ext-rigidity criterion Ext^1_G(T,Sym^j V*⊗T)=0 | openai-math/preprints/Fiber-functors-for-finite-symmetric-tensor-categories-in-positive-characteristic-September-24-2026/build/sections/restricted.tex:227-235 lem:formal-comparison (tilting origin fibre T) | Read the manuscript's proof (restricted.tex:254-290): it uses tilting only to obtain exactly this Ext^1 vanishing through good filtrations |

Main files:

- [`first-pass/geometric_fibre_comparison/proof.md`](first-pass/geometric_fibre_comparison/proof.md)
- [`first-pass/geometric_fibre_comparison/Main.lean`](first-pass/geometric_fibre_comparison/Main.lean)
- [`first-pass/geometric_fibre_comparison/statement_fidelity.md`](first-pass/geometric_fibre_comparison/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
