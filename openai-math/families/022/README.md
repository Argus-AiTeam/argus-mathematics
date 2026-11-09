# 022. The weak inhomogeneous Duffin–Schaeffer conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Oriented mixed roundoff O(W) -> O(W^2); remaining first joins O_{k0}(W^{201/200}) | openai-math/preprints/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections/joins.tex:25-28 prop: total 'O(W)+O_{k_0}(W^{1+c})'; :769-775 'The resulting contribution is O(W) ... the oriented mixed roundoffs are O(W)' | Confirmed baseline; read the load-bearing step (R9): count of smaller-band centres <= eW e^{4 theta B_j} from disjoint original assignments with total mass <= W, then sum m_j e^{-eta B_j/2} <= W giving W^2 |

Main files:

- [`first-pass/remaining-first-joins/report.md`](first-pass/remaining-first-joins/report.md)
- [`first-pass/backward-charge/report.md`](first-pass/backward-charge/report.md)
- [`first-pass/backward-charge/Main.lean`](first-pass/backward-charge/Main.lean)
- [`first-pass/backward-charge/statement_fidelity.md`](first-pass/backward-charge/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
