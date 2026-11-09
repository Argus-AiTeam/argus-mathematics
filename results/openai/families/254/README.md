# 254. Classifying spaces and geometric obstructions for Artin groups.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Finite-witness version of null:obstruction with witness length <= (N+1)L(w_J), "without universal-coset hypothesis or adjacency of f and I" | preprints/Parabolic-intersections-in-Artin-groups-September-23-2026/build/sections/05_null.tex:10-30 (null:obstruction: "It is impossible that every representative z in A_J x capped at q on I satisfies m_j^q(z)>c_j"); :359 "No adjacency of f to I, and no sign restriction on q, was used." | Read the manuscript statement and its proof (05_null.tex:311-420) against Argus theorem section 1. |

Main files:

- [`first-pass/null_layer_audit/theorem.md`](first-pass/null_layer_audit/theorem.md)
- [`first-pass/null_layer_audit/lean/Main.lean`](first-pass/null_layer_audit/lean/Main.lean)
- [`first-pass/null_layer_audit/Main.lean`](first-pass/null_layer_audit/Main.lean)
- [`first-pass/null_layer_audit/statement_fidelity.md`](first-pass/null_layer_audit/statement_fidelity.md)
- [`first-pass/null_layer_audit/lean/statement_fidelity.md`](first-pass/null_layer_audit/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
