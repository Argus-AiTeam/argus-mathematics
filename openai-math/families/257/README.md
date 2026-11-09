# 257. A hyperbolic group without a geometric CAT(0) action.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | diagram:fragment: kappa=min{beta-7alpha,alpha/5,delta}, A<=B/kappa improved to kappa4=min{beta-7alpha,alpha/4,delta}, A<=3B/(4 kappa4) | preprints/A-hyperbolic-group-with-no-geometric-CAT0-action-September-25-2026/build/sections/03-diagrams.tex:491-500 "kappa=min{beta-7alpha,alpha/5,delta}... A <= C_0 B, C_0=1/kappa"; Q<=5W used at :517-519; B=B_raw+B_rad at :334-335 | Checked the final aggregation: with B=B_raw+B_rad (03-diagrams.tex:335), 4 kappa4 A <= 2B_raw+3B_rad <= 3B is valid; read the q<=4 argument (two point representatives in K_{2,3}, each incident to <=2 triangle steps) and the new local inequality 4-2d<=q+p+3j. |

Main files:

- [`first-pass/diagram-deficit/Main.lean`](first-pass/diagram-deficit/Main.lean)
- [`first-pass/diagram-deficit/statement_fidelity.md`](first-pass/diagram-deficit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
