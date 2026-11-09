# 370. The Lane–Emden and Hénon–Lane–Emden conjectures.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:pressure extended to Riesz kernels 0<sigma<n, n>=2, annular log-Lipschitz weights, explicit constants | preprints/The-Subcritical-Henon-Lane-Emden-Conjecture-September-24-2026/build/sections/05-pressure.tex:9-21 (prop:pressure, n>=3, Newton kernel, constant C_eps) | Confirmed the baseline scope (n>=3, Newtonian potentials). Read the Theorem 1 hypotheses. The analytic proof was not checked |

Main files:

- [`first-pass/pressure-certificate/REPORT.md`](first-pass/pressure-certificate/REPORT.md)
- [`first-pass/pressure-certificate/statement_fidelity.md`](first-pass/pressure-certificate/statement_fidelity.md)
- [`first-pass/pressure-certificate/Main.lean`](first-pass/pressure-certificate/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
