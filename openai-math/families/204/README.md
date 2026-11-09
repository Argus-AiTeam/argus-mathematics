# 204. Tensor saturation for even spin groups.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Initial-state continuation-or-rank-drop theorem: prop:continuation without the local-link forgetting condition | openai-math/preprints/Tensor-Saturation-for-Even-Spin-Groups-September-24-2026/build/sections/03-lattice-continuation.tex:332-335 prop:continuation ('a local link cannot exist'; the local-link definition with its forgetting condition is at lines 302-313) | Confirmed the baseline and that the forgetting condition is a hypothesis of the local-link definition. The long continuation argument was not checked. |

Main files:

- [`first-pass/continuation/report.md`](first-pass/continuation/report.md)
- [`first-pass/continuation/Main.lean`](first-pass/continuation/Main.lean)
- [`first-pass/continuation/statement_fidelity.md`](first-pass/continuation/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
