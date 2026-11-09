# 260. Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter extensions.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | prop:scalar:coercivity with explicit C_k=32+4k^2; (1+N)^2 shown necessary (k=2,v=1/4 ratio p^2/44+4p/11+21/11); stationary constants 1/16, 3 | preprints/The-spacetime-Penrose-inequality-and-enclosing-area-September-27-2026/build/sections/scalar-identity.tex:333-347 "\|T\|^2+\|M\|^2+d j^2+F^2+\|dt\|^2_{A_d} <= C_k(1+N)^2 T" with unspecified C_k | Random test ((check script)): 200 parameter draws x 2e5 vectors of the exact quadratic form eq:scalar:quadratic (:162-167), k=2..7, p up to 1e3: form never negative, max LHS/((32+4k^2)(1+p)^2 T) = 0.041. Generalized eigenvalue computation for k=2,v=1/4 gives sup ratio 7.8187, 265.545, 23092.82 at p=10,100,1000, matching p^2/44+4p/11+21/11. |

Main files:

- [`first-pass/scalar_identity_certificate/report.md`](first-pass/scalar_identity_certificate/report.md)
- [`first-pass/scalar_identity_certificate/lean/Main.lean`](first-pass/scalar_identity_certificate/lean/Main.lean)
- [`first-pass/scalar_identity_certificate/lean/statement_fidelity.md`](first-pass/scalar_identity_certificate/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
