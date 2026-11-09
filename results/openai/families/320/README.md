# 320. Nonhomeomorphic closed aspherical four-manifolds.

**Result:** issue in the OpenAI manuscript.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| B | CONFIRMED | formal.tex:785 cites [MT, Lemma 3.9] which does not exist; intended MT Lemma 6.7 "Correction over the full parameter algebra" | Nonhomeomorphic-closed-aspherical-four-manifolds-with-the-same-homotopy-type-October-4-2026/build/sections/formal.tex:785 "Apply the nilpotent correction of \cite[Lemma~3.9]{MT}." | Counted shared-counter theorem environments in A-marked-tensor-obstruction...Sept-24 (numberwithin section, intro is Section 1). Section 3 (02-tensor.tex) has exactly 8 items (3.1-3.8). "Correction over the full parameter algebra" (05-vertices.tex:746) is the 7th item of Section 6, i.e. Lemma 6.7. |

Main files:

- [`first-pass/formal_data_bridge/report.md`](first-pass/formal_data_bridge/report.md)
- [`first-pass/formal_data_bridge/Main.lean`](first-pass/formal_data_bridge/Main.lean)
- [`first-pass/formal_data_bridge/statement_fidelity.md`](first-pass/formal_data_bridge/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
