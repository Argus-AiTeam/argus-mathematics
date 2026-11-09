# 083. Hilbert transforms along Lipschitz directions.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | boundary-loss bound 2eps(1-G^-k)/(1-1/G) log(n/h_T) | preprints/A-uniform-Hilbert-transform-estimate-for-Lipschitz-directions-September-25-2026/build/sections/11-assembly.tex:224 lem assembly:boundary-loss; proof :300-312 already computes the integral as eps/(1-G^-1), giving 2eps/(1-1/G) log(n/h_T) | Compared with manuscript's own computation |

Main files:

- [`first-pass/boundary-loss/proof.md`](first-pass/boundary-loss/proof.md)
- [`first-pass/boundary-loss/Main.lean`](first-pass/boundary-loss/Main.lean)
- [`first-pass/boundary-loss/statement_fidelity.md`](first-pass/boundary-loss/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
