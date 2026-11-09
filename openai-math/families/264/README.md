# 264. Strong cosmic censorship near two-ended Kerr data.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:averaged-holonomy extended from L^2 to every finite p>=1 connection with exponent criterion; conditional category transfer for p>4/3 | preprints/Generic-Future-Inextendibility-with-Square-Integrable-Connection-Near-a-Fixed-Kerr-Spacetime-September-23-2026/build/sections/holonomy_category.tex:252-271 (prop:averaged-holonomy, L^2 Christoffel setting, nu_T(N_T)<=Ce^{-kappa T/16}) | Read the exceptional-set step: Jensen on the unit s-interval (I_e^p <= int \|Gamma\|^p), change of variables dx <= C r^{-1}dy, Markov => nu{I_e>R} <= C/(rR^p). Logic is sound; exponent-feasibility criterion not re-solved. |

Main files:

- [`first-pass/holonomy_certification/report.md`](first-pass/holonomy_certification/report.md)
- [`first-pass/holonomy_certification/Main.lean`](first-pass/holonomy_certification/Main.lean)
- [`first-pass/holonomy_certification/statement_fidelity.md`](first-pass/holonomy_certification/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
