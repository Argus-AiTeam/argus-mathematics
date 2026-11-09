# 166. The higher-dimensional Erdős distinct-distances conjecture.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Unspecified C_e in conc:degree made explicit: C_e=2 (1 in codim>=2), exceptional case = Pfaffian cylinders | preprints/The-higher-dimensional-Erdos-distinct-distances-conjecture-September-23-2026/build/sections/concentration.tex:511 'deg Lambda <= C_e deg V' (C_e enters via fiber count d_Gamma<=C_e at :670-694) | Located where C_e enters the manuscript proof: the generic-fiber point count d_Gamma. Read Argus Section 5: tangent-direction solution space has dim<=2 and the tangency test is quadratic in tau, so there are <=2 points. The dim<=2 claim was not independently checked. |

Main files:

- [`first-pass/concentration_degree/report.md`](first-pass/concentration_degree/report.md)
- [`first-pass/concentration_degree/statement_fidelity.md`](first-pass/concentration_degree/statement_fidelity.md)
- [`first-pass/concentration_degree/Main.lean`](first-pass/concentration_degree/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
