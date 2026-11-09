# 089. Bounded-distortion <i>L</i><sub>1</sub> embeddings of planar and bounded-treewidth graphs.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Restricted packing constant 1600000002 -> 800160050 | preprints/Planar-Graph-Metrics-Embed-into-L1-with-Constant-Distortion-*/build/sections/main-packing.tex:331 'M_pack=2+ceil(1600R/g)'; proof :489 '2+16R/b_0=2+1600R/g' | Recomputed with R=1e-8,g=1e-14,b=g/100,rho=j+eps+2a: 2+floor(2L/(b-2rho))=800160050 |

Main files:

- [`first-pass/packing_audit/Main.lean`](first-pass/packing_audit/Main.lean)
- [`first-pass/packing_audit/statement_fidelity.md`](first-pass/packing_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
