# 326. The cotype–cotype conjecture under the approximation property.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Compactness constant c_* in lem:coefficient replaced by explicit \|Psi_hat(P)\| >= 2^{m^2+1}(640d+504)/(3^{m^2}-1) > (2/3)^{m^2} | The-cotype-cotype-conjecture-under-the-approximation-property-September-23-2026/build/coefficient.tex:54-79 lem:coefficient: "There is c_*>0, depending only on m,a,b ... \|Psi_hat(P)\|>=c_*" (via compactness, line ~91) | Checked the mechanism. The rank<=1 part Q satisfies the same projections; \|E R(S)\| <= eps*W_N with W_N=((3/2)^N-(1/2)^N)/2; the manuscript chain then gives AB/2 <= 4D(A+B)+5KDL with K<=8+eps W_N. Recomputed: at A=B=80L the bound (AB/2-4D(A+B))/(5DL)-8 = 640d+504, increasing in A,B. 2(640d+504)/W_N = 2^{N+1}(640d+504)/(3^N-1). Lean exit 0 (parity core). |

Main files:

- [`first-pass/coefficient_certificate/report.md`](first-pass/coefficient_certificate/report.md)
- [`first-pass/coefficient_certificate/lean_evidence/Main.lean`](first-pass/coefficient_certificate/lean_evidence/Main.lean)
- [`first-pass/coefficient_certificate/Main.lean`](first-pass/coefficient_certificate/Main.lean)
- [`first-pass/coefficient_certificate/statement_fidelity.md`](first-pass/coefficient_certificate/statement_fidelity.md)
- [`first-pass/coefficient_certificate/lean_evidence/statement_fidelity.md`](first-pass/coefficient_certificate/lean_evidence/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
