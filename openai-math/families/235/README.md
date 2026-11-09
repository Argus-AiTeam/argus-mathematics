# 235. Limiting random SAT thresholds, sharp variance and computability.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | ct:old-records/ct:new-record with simultaneous estimate sum_j int\|A_j-S_b(phi_j)\|^2 <= 2J gamma, without ct:ordering | openai-math/preprints/Computing-the-Random-3-SAT-Threshold-September-27-2026/build/sections/transition.tex:988-996 ct:new-record; ct:ordering is a proved lemma at :546 | Checked that ct:ordering is a lemma established in the manuscript, not a hypothesis |

Main files:

- [`first-pass/pathwise-record-transfer/Main.lean`](first-pass/pathwise-record-transfer/Main.lean)
- [`first-pass/pathwise-record-transfer/statement_fidelity.md`](first-pass/pathwise-record-transfer/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
