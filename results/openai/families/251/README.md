# 251. Amenability, unitarizability, and strong Ulam stability.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:comparison with explicit constants 40h+16N eta+30N h eta (h<=1/128, eta<=1/4), plus nested-configuration version | preprints/Strong-Ulam-Stability-Characterizes-Amenability-October-5-2026/build/strong-ulam-stability.tex:895-905 "\|\|V^{p,q}_{qp}-V^{p,q,r}_{qp}\|\| <= Ch+CN eta+CN h eta" with unspecified numerical C, h_0 | Verified baseline form; read Argus theorem statement and metric/Gram prerequisites; did not re-derive the 40/16/30 constants. |

Main files:

- [`first-pass/circuit-comparison/lean/Main.lean`](first-pass/circuit-comparison/lean/Main.lean)
- [`first-pass/circuit-comparison/lean/statement_fidelity.md`](first-pass/circuit-comparison/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
