# 246. Cannon's conjecture.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Separated-capacity lemma quantified: capacity >= c min{a^{d-gamma D}, a^{tau D-(Q-2)d}/M(D-d)} >= c' a^{gamma D} | preprints/A-Modulus-Proof-of-Cannons-Conjecture-September-23-2026/build/sections/04_flow.tex:195-203 "sum_{y in Y'} min{a^{-gamma D} t_y, a^{tau D} t_y^2} >= 1" (proof by contradiction at :307-329) | Read manuscript proof end-to-end and Argus report; compared the energy-comparison step (04_flow.tex:307-329) with Argus finite weighted-cover theorem (4)/(9). |

Main files:

- [`first-pass/separated_capacity/report.md`](first-pass/separated_capacity/report.md)
- [`first-pass/separated_capacity/Main.lean`](first-pass/separated_capacity/Main.lean)
- [`first-pass/separated_capacity/statement_fidelity.md`](first-pass/separated_capacity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
