# 079. Local smoothing for the Euclidean wave equation.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:energy-flux extended with explicit moving-wall term and iff cancellation criterion | preprints/Local-smoothing-for-the-Euclidean-wave-equation-*/build/sections/energy.tex:200 prop:energy-flux | Baseline identity read; Argus theorem statement read |

Main files:

- [`first-pass/energy_bridge/theorem.md`](first-pass/energy_bridge/theorem.md)
- [`first-pass/energy_bridge/lean/statement_fidelity.md`](first-pass/energy_bridge/lean/statement_fidelity.md)
- [`first-pass/energy_bridge/lean/Main.lean`](first-pass/energy_bridge/lean/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
