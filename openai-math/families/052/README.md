# 052. Tangent splittings and product decompositions.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | lem:rational with explicit m=2d+1 for coordinate-pair relations | preprints/Integrability-of-split-tangent-bundles-on-rationally-connected-manifolds-*/build/sections/boxes.tex:187 lem:rational (statement has no m); eq:sectionbound line 264: dim V <= (m+q+1)^2 or (m+q+1)(m+q+2), 'm sufficiently large' | Recomputed surplus 2(m+1)^2 - bound at m=2d+1: 7q^2+12q+4 (d=2q), 7q^2+19q+12 (d=2q+1), both >0 |

Main files:

- [`first-pass/tangent_box_certificate/statement_fidelity.md`](first-pass/tangent_box_certificate/statement_fidelity.md)
- [`first-pass/tangent_box_certificate/Main.lean`](first-pass/tangent_box_certificate/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
