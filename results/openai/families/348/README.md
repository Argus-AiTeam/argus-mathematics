# 348. Nonnegative-curvature Einstein classification and an <i>L</i><sup>2</sup> topological gap.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Sharp spin-5/2 bound <B_F(T)Z,Z> <= (4x/5)\|Z\|^2 on G gives bracket >= (1/3+19y/12)e (manuscript: >= (7/12)(4+y-2x)e >= 0) | preprints/Zero-Plane-Rigidity-for-Einstein-Four-Manifolds-October-4-2026/build/sections/05-hessian.tex:591-597 (eq.14) and proof end: 'frac7{12}(4+y)e-frac54B >= frac7{12}(4+y-2x)e >= 0' | Built G (rank 8 Bianchi constraint, dim 12) from quaternion triples and computed max eigenvalue of the compression of B_F(T) over 2e4 random trace-free T: max ratio 0.791 < 0.8 (vs 0.989 on all of F). Algebra: (7/12)(4+y)-(5/4)(4x/5) with x<=2-y gives 1/3+19y/12 |

Main files:

- [`first-pass/hessian_bridge/statement_fidelity.md`](first-pass/hessian_bridge/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
