# 335. Gromov’s integral scalar-curvature bound for simplicial volume.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Explicit cardinality-free constants (7m^2, 14m^3) in eq:entropy-BC-expansion/sharp-T plus nonperturbative reserve T >= Phi_n(m)=2[m-n(1-e^{-m/n})], sharp over rank-one ordered updates | preprints/An-integral-scalar-curvature-bound-for-real-simplicial-volume-October-5-2026/build/sections/04-entropy.tex:595-612: 'B_i=sum_{j<i}A_j^2 xi_ij+O(m^2)' and 'T_0 >= tr[(sum A_i^2 e_i e_i^T)^2] - C_n(m^3+m^2\|r-1\|+m sum A_i^2(1-sigma_i)_+)' (unspecified C_n) | Random test (2e4 cases, n<=5, up to 11 rank-one updates, scales 0.01-3): exact loss identity sum s_iB_i = m - m_f holds to 1e-6 and baseline 2d+2sum s_i(L_i-1) - Phi_n(m) >= -2e-16; hand-checked the AM-GM/f_n Lipschitz step |

Main files:

- [`first-pass/entropy_increment_audit/proof.md`](first-pass/entropy_increment_audit/proof.md)
- [`first-pass/entropy_increment_audit/Main.lean`](first-pass/entropy_increment_audit/Main.lean)
- [`first-pass/entropy_increment_audit/statement_fidelity.md`](first-pass/entropy_increment_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
