# 310. Quillen's conjecture in rational homology.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | lem:frame-marked-factor strengthened from D C >= (DP)C to (D-2)C >= (DP)C (capacity h-2) | Rational-homology-and-Quillens-conjecture-September-24-2026/build/sections/04-frames.tex:513-571 lem:frame-marked-factor; proof line ~562: "the relation label itself occupies another summand of dimension two. The sum of the dimensions of all factors that could have been marked is thus at most dim W_0" | Read the manuscript proof. |

Main files:

- [`first-pass/frame_kernel/REPORT.md`](first-pass/frame_kernel/REPORT.md)
- [`first-pass/frame_kernel/Main.lean`](first-pass/frame_kernel/Main.lean)
- [`first-pass/frame_kernel/statement_fidelity.md`](first-pass/frame_kernel/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
