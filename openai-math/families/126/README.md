# 126. Exponential semidefinite complexity of perfect matching.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Orthogonal splitting C_L=2^{L-1} -> L/4; potential 2^t -> (9/8)^t, Fourier mass 2^{t/2} -> (9/8)^{t/2} | Exponential-PSD-rank-of-positively-shifted-matching-matrices-October-5-2026/build/source/sections/splitting.tex:15-18 'C_L=2^{L-1}'; fourier-smoothing.tex:64-66 'L lambda^2 C_L theta<=1', l.306 factor 2 | Implemented the recursive balanced splitting in numpy and tested (S2) on 6000 random PSD families (L=2,4,8, dimension <=6, low-rank/correlated): max ratios 0.495/0.487/0.424 against bounds 0.5/1/2. The binary constant 1/2 is attained, and the (S4) induction algebra was checked. Also checked g<=1+(L-1)/2^{L+1}<=9/8. |

Main files:

- [`first-pass/fourier-transfer/theorem.md`](first-pass/fourier-transfer/theorem.md)
- [`first-pass/fourier-transfer/lean-evidence/Main.lean`](first-pass/fourier-transfer/lean-evidence/Main.lean)
- [`first-pass/fourier-transfer/lean-evidence/statement_fidelity.md`](first-pass/fourier-transfer/lean-evidence/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
