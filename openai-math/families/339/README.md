# 339. Katok's entropy rigidity conjecture.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | real:decay rate improved from c_0=b_u/4 to every c<b_u | preprints/Entropy-equality-and-local-symmetry-in-negative-curvature-September-23-2026/build/sections/06-realization.tex:542-545 'There exists c_0>0 ... \|\|D_s^jG_{n,k}\|\| <= C_{j,k}e^{-c_0kn}' and :625-627 'derivative bound is C e^{-b_u kn/2} ... for example, c_0=b_u/4 works' | Read manuscript proof lines 590-627: the fractions 7/8, 3/4, 1/2 come from free choices of epsilon, p and q |

Main files:

- [`first-pass/recurrent_jet_decay/report.md`](first-pass/recurrent_jet_decay/report.md)
- [`first-pass/recurrent_jet_decay/Main.lean`](first-pass/recurrent_jet_decay/Main.lean)
- [`first-pass/recurrent_jet_decay/statement_fidelity.md`](first-pass/recurrent_jet_decay/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
