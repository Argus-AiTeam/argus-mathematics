# 106. Hardness of coloring three-colorable graphs.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Explicit sampler for s=3 with optimal failure d/(r-2) | Hardness-of-finding-large-independent-sets-in-three-colorable-graphs-September-24-2026/build/source/sections/alignment.tex:18-37 (lem:alignment, every s,d,eta); parameters.tex:17 'an integer s>=2 with (1-p_m)^s<eps' | Checked the upper-bound combinatorics by hand (bad middle index forces x in A_{l,h}; distinct middles need distinct labels by separation) and the lower-bound family. |

Main files:

- [`first-pass/alignment-audit/report.md`](first-pass/alignment-audit/report.md)
- [`first-pass/alignment-audit/Main.lean`](first-pass/alignment-audit/Main.lean)
- [`first-pass/alignment-audit/rationalization/Main.lean`](first-pass/alignment-audit/rationalization/Main.lean)
- [`first-pass/alignment-audit/finite-patterns/Main.lean`](first-pass/alignment-audit/finite-patterns/Main.lean)
- [`first-pass/alignment-audit/statement_fidelity.md`](first-pass/alignment-audit/statement_fidelity.md)
- [`first-pass/alignment-audit/minimax/Main.lean`](first-pass/alignment-audit/minimax/Main.lean)
- [`first-pass/alignment-audit/finite-patterns/statement_fidelity.md`](first-pass/alignment-audit/finite-patterns/statement_fidelity.md)
- [`first-pass/alignment-audit/minimax/statement_fidelity.md`](first-pass/alignment-audit/minimax/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
