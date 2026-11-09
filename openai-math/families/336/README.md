# 336. Spectral scalar curvature, Urysohn width, and macroscopic dimension.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | shield:global form coefficient theta_* = .88 improved to .28 (any theta > 29/108) | preprints/Positive-scalar-curvature-and-uniform-codimension-two-width-September-23-2026/build/appendices/shield-global.tex:524-528 'For one common theta_*<.9 ... <= theta_*(N(v)+e_0\|\|v\|\|^2) <= .9(...)' and :557 'We may consequently take theta_*=.88' | Read baseline; grep shows theta_* is used downstream only as '<.9' (countable-partitions.tex:446-449). Read Argus README sec.1-3; the geometric construction (Hardy field, two-pole profile) is prose only; C_SHIELD_CORE has one inconclusive mechanical run |

Main files:

- [`first-pass/shielding_audit/Main.lean`](first-pass/shielding_audit/Main.lean)
- [`first-pass/shielding_audit/statement_fidelity.md`](first-pass/shielding_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
