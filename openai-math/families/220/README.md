# 220. Directional zero–one laws beyond iid environments and iid ballisticity.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | prop:first-contact with explicit constant 192(2d-1)kappa^{-dR}/(p+p-)...; finite-anchor generalization; abstract posterior inequality sharp up to constants | openai-math/preprints/A-directional-zero-one-law-for-finite-range-dependent-random-environments-October-5-2026/build/manuscript/posteriors.tex:109-135 prop:first-contact ('There is a constant C, independent of ...') | Baseline confirmed. Explicit constant not rechecked. |

Main files:

- [`first-pass/finite_range_first_contact/report.md`](first-pass/finite_range_first_contact/report.md)
- [`first-pass/finite_range_first_contact/Main.lean`](first-pass/finite_range_first_contact/Main.lean)
- [`first-pass/finite_range_first_contact/statement_fidelity.md`](first-pass/finite_range_first_contact/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
