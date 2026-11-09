# 221. The Mézard–Parisi formula for diluted spin glasses.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Exact normalized extension mass sum\|c_E\|/J = 2s^2 + 1/L replacing unspecified C_{k,eta}; removes interior-depth (eta) dependence | openai-math/preprints/The-Mezard-Parisi-formula-for-diluted-spin-glasses-September-23-2026/build/sections/decorrelation.tex:352-356 eq decor:relative-absolute-cost: (1/\|J\|) sum \|c\| <= C_{k,eta} | Baseline confirmed. The combinatorial normal-form proof was not independently re-run. The Lean core compiled (lean_check exit 0). |

Main files:

- [`first-pass/shifted_tree_core/proof.md`](first-pass/shifted_tree_core/proof.md)
- [`first-pass/shifted_tree_core/Main.lean`](first-pass/shifted_tree_core/Main.lean)
- [`first-pass/shifted_tree_core/statement_fidelity.md`](first-pass/shifted_tree_core/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
