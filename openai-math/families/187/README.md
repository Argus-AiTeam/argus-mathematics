# 187. Snaky in 21 Maker moves.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | REJECTED | Finite-board 21-move Snaky policy confined to T_727 (251 cells) inside 17x17 box | preprints/Snaky-in-21-Maker-moves-September-25-2026/build/strategy.tex:64-68 cor:finite-board 'Maker wins ... within 21 actual Maker claims on the initially empty 251-cell board T_727, and also on the initially empty 17x17 board' (proof :73-92 notes T_727 subset {0..16}^2 and handles Breaker replies outside T_727) | Read the manuscript corollary and the OpenAI lean/docs/187.md scope note ('does not impose the paper's smaller finite-board restriction') |

Main files:

- [`first-pass/finite_board/Main.lean`](first-pass/finite_board/Main.lean)
- [`first-pass/finite_board/REPORT.md`](first-pass/finite_board/REPORT.md)
- [`first-pass/finite_board/statement_fidelity.md`](first-pass/finite_board/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
