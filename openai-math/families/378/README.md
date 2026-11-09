# 378. Disproof of the Exponential Time Hypothesis.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Tapered Hermite recovery with exact smaller precision P_t=p+hB(a-i,u-i)+(m_t-1)(a+1-i) instead of p+8hL/2^i+8M(a+1) | preprints/The-Exponential-Time-Hypothesis-is-False-October-25-2026/build/quantitative-contraction.tex:250-265 'p_t=p+8hD_t+8M(a+1)', D_t=L/2^i | Exhaustive exact check over a<=6, all u, h in {1,2,3}, all retained t (3132 cases): v_2(E_t(0)) = -hB(a-i,u-i) and the closed form of B(n,k) both hold. Since B<=6*2^n and m_t-1<4M, P_t <= p_t follows |

Main files:

- [`first-pass/tensor_modes/proof.md`](first-pass/tensor_modes/proof.md)
- [`first-pass/hermite_precision/proof.md`](first-pass/hermite_precision/proof.md)
- [`first-pass/tensor_modes/Main.lean`](first-pass/tensor_modes/Main.lean)
- [`first-pass/hermite_precision/Main.lean`](first-pass/hermite_precision/Main.lean)
- [`first-pass/hermite_precision/statement_fidelity.md`](first-pass/hermite_precision/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
