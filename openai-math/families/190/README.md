# 190. Polynomial removal fails for ordered binary matrices.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Exact distance min edits = m^2 = 4^h and exact copy count N_H(A_h)=2m^130 (manuscript: >= m^2 and <= m n^130) | preprints/Polynomial-removal-fails-for-ordered-binary-matrices-September-25-2026/build/sections/04-distance.tex:12-17 prop:distance 'differs from A in at least m^2 entries'; 03b-count.tex:8-21 prop:copy-count 'N_H(A_h) <= m n^{2k-2}' | Checked the index bookkeeping: m (leaf p=q) * m (dummy row) * 2 (columns) * m^128 (anchors) accounts for all 132 indices. The repair size is 2(m/2)m = m^2. The rigidity analysis (Sections 3-4) was not independently checked. verify.py rebuilds the exact certificate. Lean: core success, one run type_error. |

Main files:

- [`first-pass/certification/lean/Main.lean`](first-pass/certification/lean/Main.lean)
- [`first-pass/certification/lean/statement_fidelity.md`](first-pass/certification/lean/statement_fidelity.md)
- [`first-pass/STATEMENT_FIDELITY.md`](first-pass/STATEMENT_FIDELITY.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
