# 134. Generalized star height at most three.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | decode:anchor-list at most 20 -> at most 3 anchors | Generalized-Star-Height-at-Most-Three-September-25-2026/build/sections/decoder.tex:63-80: 'belong to a set Q of at most 20 positions' (proof gives <=7 markers + 1) | Read the core/fringe argument: each fringe has width 2h+s<d_bullet, so it holds at most one marker, giving at most 2 returns plus 1 mismatch. |

Main files:

- [`first-pass/decoder_audit/Main.lean`](first-pass/decoder_audit/Main.lean)
- [`first-pass/decoder_audit/report.md`](first-pass/decoder_audit/report.md)
- [`first-pass/decoder_audit/statement_fidelity.md`](first-pass/decoder_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
