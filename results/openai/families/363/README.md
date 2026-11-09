# 363. Nonuniqueness with local conservation for the hard-sphere Boltzmann equation.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Rank-seven a.e. of ordered gain history map already with three gains (OpenAI uses five); two gains have rank <=6 everywhere; extends to all m>=3 | preprints/Nonuniqueness-for-the-periodic-hard-sphere-Boltzmann-equation-September-23-2026/build/sections/08-nonconcentration.tex:657ff (lem:five-gain-rank: 'five positive scales ... has rank seven almost everywhere') and 01-introduction.tex:192 'Away from the axis, five gains suffice' | Python: implemented recursion (nc:rank-map) with random analytic axial profiles a_i(t,z)=c0+sin(c1 t+c2 z), finite-difference Jacobians at 200 random ordered histories: rank 6 for m=2, 7 for m=3, 7 for m=5 in every trial |

Main files:

- [`first-pass/three_gain/theorem.md`](first-pass/three_gain/theorem.md)
- [`first-pass/three_gain/statement_fidelity.md`](first-pass/three_gain/statement_fidelity.md)
- [`first-pass/three_gain/Main.lean`](first-pass/three_gain/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
