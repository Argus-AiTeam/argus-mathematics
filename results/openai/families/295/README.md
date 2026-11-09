# 295. The Kadison–Ringrose cohomology conjecture.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | thm:rigidity hypothesis weakened to distinct-index good words (positive-ended, no adjacent negatives) plus adjoints; quantitative \|\|a-b\|\|_2 bound | Vanishing-of-higher-bounded-Hochschild-cohomology-September-23-2026/build/sections/04-rigidity.tex:8-31 thm:rigidity (R(w)=aw / bw on all distinct-index signed words) and :428 lem:rigidity-unitary | Read the sign-invariant argument: deletion preserves "good" words. It observes that the manuscript's block words z(z*z)^d are good. |

Main files:

- [`first-pass/rigidity/report.md`](first-pass/rigidity/report.md)
- [`first-pass/rigidity/Main.lean`](first-pass/rigidity/Main.lean)
- [`first-pass/rigidity/statement_fidelity.md`](first-pass/rigidity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
