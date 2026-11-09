# 350. Yau’s nodal bounds: surfaces and higher dimensions.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | lem:corrugation strengthened: pointwise amplification inf_R\|grad v\|>=rho sup_P\|grad h\| giving all r-moment and convex-energy gains | preprints/Power-law-violations-of-Yaus-nodal-upper-bound-September-23-2026/build/sections/envelopes.tex:131-160 (lem:corrugation, mass gain int_R\|grad v\| >= (1+zeta) int_P\|grad h\|) and :520 prop:envelope | Checked that (A2)/(convex) follow from (A1) plus the mass gain: int_R\|grad v\|^r >= rho^{r-1}(sup)^{r-1}(1+zeta)int_P\|grad h\| >= ... Did not check (A1) itself, which needs the corrugation pattern construction |

Main files:

- [`first-pass/corrugation_audit/theorem.md`](first-pass/corrugation_audit/theorem.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
