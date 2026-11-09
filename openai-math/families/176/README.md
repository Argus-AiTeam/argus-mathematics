# 176. The second Kahn–Kalai conjecture with an edge-count bound.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | lem:reduction capacity separation m_{j+1}>=16m_j weakened to >=3m_j | preprints/The-second-Kahn-Kalai-conjecture-September-24-2026/build/source/sections/trees.tex:58 'm_{j+1}>=16m_j' (bound at :162-167 uses sum_{h<j}m_h<=m_j/15) | Recomputed: with ratio 3, sum_{h<j} m_h <= m_j/2, so 12m_j/2 - 8m_j = -2m_j and sum_{m>=1} e^{-2m} = 0.157 < 1/4. Argus's induction E D_v <= e^{-8m}+e^{-9m} <= e^{-7m} also checks. |

Main files:

- [`first-pass/tree-reduction/Main.lean`](first-pass/tree-reduction/Main.lean)
- [`first-pass/tree-reduction/report.md`](first-pass/tree-reduction/report.md)
- [`first-pass/tree-reduction/statement_fidelity.md`](first-pass/tree-reduction/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
