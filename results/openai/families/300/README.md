# 300. Approximation and quadratic strong-operator paving.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | lem:assignment pinning holds with any beta>=12 (cost 23m) instead of beta=80; non-uniform probabilities, dimension-free | Quadratic-Strong-Operator-Paving-over-Arbitrary-Maximal-Abelian-Subalgebras-September-25-2026/build/source/sections/polynomials.tex:502-511 lem:assignment: "With beta=80, there is i ... d_v^i-d_v<=24m_v" (proof gives 21m / 7m) | Re-derived Argus's chain: tests sum b/(D0+lambda)<=2m+e+/2 with D0=8m+4a and sum b/(L+\|lambda\|)<=6m+4a; pick a color at twice the mean; side-arrow increments <=4m+e+ and <=e-+eps; diagonal shift from -(20m+12a) to -beta*a costs <=20m when beta>=12; total minus (m+e++e-) <=23m. Lean exit 0. |

Main files:

- [`first-pass/pinning/Main.lean`](first-pass/pinning/Main.lean)
- [`first-pass/pinning/report.md`](first-pass/pinning/report.md)
- [`first-pass/pinning/statement_fidelity.md`](first-pass/pinning/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
