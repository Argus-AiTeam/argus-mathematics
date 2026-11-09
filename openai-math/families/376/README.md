# 376. Universal computation in forced Navier–Stokes flows.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Scale schedule criterion: all-order rapid decay iff K_{n+1}/K_n -> infinity (manuscript uses K_n=(p_0+10)2^{n(n+1)}) | preprints/Computation-under-Rapidly-Vanishing-Navier-Stokes-Forcing-September-27-2026/build/lattice.tex:148 'K_n=(p_0+10)2^{n(n+1)}' | Confirmed the baseline schedule. Heuristic check: stage-n derivatives ~eps_n^{-k}, force ~eps_{n+1}, giving b^{kK_n-K_{n+1}}, which needs K_{n+1}-kK_n -> infinity for all k, i.e. a divergent ratio. Consistent with the claim; the explicit necessity table was not checked |

Main files:

- [`first-pass/rapid_lattice/report.md`](first-pass/rapid_lattice/report.md)
- [`first-pass/rapid_lattice/Main.lean`](first-pass/rapid_lattice/Main.lean)
- [`first-pass/rapid_lattice/statement_fidelity.md`](first-pass/rapid_lattice/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
