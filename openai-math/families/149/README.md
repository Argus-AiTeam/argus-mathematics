# 149. Classwise permanence for weakly reversible mass-action systems.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Classwise permanence for weakly reversible networks extended from fixed rates to measurable time-varying rates in [l_e,u_e], with one schedule-independent compact convex invariant K | preprints/Uniform-Permanence-in-Weakly-Reversible-Mass-Action-Systems-October-5-2026/build/sections/introduction.tex:43-58 thm:main 'fix positive rate constants ... compact convex set K_P' | Read the cut-flux estimate (5)-(6) of the report. Replacing min_e k_e and sum_e k_e by min l_e and sum u_e in the manuscript's plateau argument is uniform in the rate vector, so the step holds pointwise in time. The a.e.-derivative and Caratheodory parts were not checked. Lean checks only the affine lemma and a scalar core; one certificate run had a type_error. |

Main files:

- [`first-pass/affine-audit/Main.lean`](first-pass/affine-audit/Main.lean)
- [`first-pass/bounded-kinetics/report.md`](first-pass/bounded-kinetics/report.md)
- [`first-pass/affine-audit/report.md`](first-pass/affine-audit/report.md)
- [`first-pass/bounded-kinetics/lean/Main.lean`](first-pass/bounded-kinetics/lean/Main.lean)
- [`first-pass/bounded-kinetics/Main.lean`](first-pass/bounded-kinetics/Main.lean)
- [`first-pass/bounded-kinetics/certificates/Main.lean`](first-pass/bounded-kinetics/certificates/Main.lean)
- [`first-pass/affine-audit/statement_fidelity.md`](first-pass/affine-audit/statement_fidelity.md)
- [`first-pass/bounded-kinetics/statement_fidelity.md`](first-pass/bounded-kinetics/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
