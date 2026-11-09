# 172. Classification of finite Euclidean Ramsey configurations.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Supported-fraction inclusion strengthened from N^(s-2) to gamma_{s-1}(N), giving derived depth ceil(log2(s-1)) instead of s-2; index s-1 sharp | preprints/A-classification-of-finite-Euclidean-Ramsey-configurations-September-23-2026/build/sections/06-groups.tex:104-106 'N^{(s-2)} subset L_i' | Checked the key step by hand. x in M with x_i=b, x_j=1 exists because the pair projection M_ij is a group containing N x N. x z^-1 x^-1 is a pair-supported actual fraction, and z(x z^-1 x^-1)=e_i([a,b]). Checked N^(r)<=gamma_{2^r}. Lean: lower_inclusion, derived_le_lower_pow and endpoint_bridge_depth compile with standard axioms only. |

Main files:

- [`first-pass/endpoint_bridge/Main.lean`](first-pass/endpoint_bridge/Main.lean)
- [`first-pass/lower_central_bridge/Main.lean`](first-pass/lower_central_bridge/Main.lean)
- [`first-pass/lower_central_bridge/theorem.md`](first-pass/lower_central_bridge/theorem.md)
- [`first-pass/endpoint_bridge/statement_fidelity.md`](first-pass/endpoint_bridge/statement_fidelity.md)
- [`first-pass/endpoint_bridge/STATEMENT_FIDELITY.md`](first-pass/endpoint_bridge/STATEMENT_FIDELITY.md)
- [`first-pass/lower_central_bridge/statement_fidelity.md`](first-pass/lower_central_bridge/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
