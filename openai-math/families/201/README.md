# 201. A counterexample to Kurosh’s division-ring problem.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Hub-nullspace identified exactly without rank bound; rank defect after arbitrarily many columns; projector argument with nonzero orthogonal idempotents | openai-math/preprints/A-Counterexample-to-Kuroshs-Division-Ring-Problem-September-23-2026/build/sections/cyclic-obstruction.tex:24-47 thm:cyclic-compatibility; lem:hub-nullspace at :272-286 | Compared the manuscript's lem:hub-nullspace with the report's Theorem 2.1. The Lean hub core compiles. |

Main files:

- [`first-pass/word_transfer/report.md`](first-pass/word_transfer/report.md)
- [`first-pass/global_relations/report.md`](first-pass/global_relations/report.md)
- [`first-pass/cyclic_compatibility/report.md`](first-pass/cyclic_compatibility/report.md)
- [`first-pass/cyclic_compatibility/Main.lean`](first-pass/cyclic_compatibility/Main.lean)
- [`first-pass/global_relations/lean/Main.lean`](first-pass/global_relations/lean/Main.lean)
- [`first-pass/global_relations/Main.lean`](first-pass/global_relations/Main.lean)
- [`first-pass/global_relations/statement_fidelity.md`](first-pass/global_relations/statement_fidelity.md)
- [`first-pass/global_relations/lean/statement_fidelity.md`](first-pass/global_relations/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
