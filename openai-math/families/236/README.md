# 236. The exact factor-of-IID threshold for free Ising spins on trees.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Critical comparison principle: V=0 under any positive local flatness and exceptional tail exp(-c log^q(1/t)), q>1; q=1 abstract nonuniqueness example | openai-math/preprints/The-sharp-factor-of-IID-threshold-for-the-free-Ising-model-on-regular-trees-September-26-2026/build/sections/08-critical-comparison.tex:378 prop 'Critical conditional-copy uniqueness' | Baseline confirmed and Lean exit 0. The abstract argument was not checked. |

Main files:

- [`first-pass/critical_endpoint/PROOF.md`](first-pass/critical_endpoint/PROOF.md)
- [`first-pass/critical_endpoint/Main.lean`](first-pass/critical_endpoint/Main.lean)
- [`first-pass/critical_endpoint/statement_fidelity.md`](first-pass/critical_endpoint/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
