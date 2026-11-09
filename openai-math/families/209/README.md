# 209. Integral counterexamples to Gersten’s conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Integral degree-three Gersten counterexample for every odd prime p and unramified degree d prime to p; plus dyadic example B=Z_2[x,y]/(2-2x+x^2+xy-y^2) | openai-math/preprints/An-Integral-Degree-Three-Gersten-Counterexample-September-26-2026/build/sections/introduction.tex:16-40: only p=5, L=Q_5(zeta), (X-Z)^5-XY^4+Y^5+zeta Z^5; no general-p statement anywhere in the manuscript (grep) | Checked by hand: the special fiber reduces to X^p - XY^{p-1} + Y^p (Artin-Schreier, irreducible over F_{p^d} iff p does not divide d). The y=0 divisor (t-1)^p+zeta_p is Eisenstein in t with norm pi (p odd), and eta^p=zeta_p. For the dyadic ring, f is not in m^2 (so B is regular), 2 is in m_B^2, and the initial form x^2+xy+y^2 is irreducible mod 2. |

Main files:

- [`first-pass/degree_three_audit/report.md`](first-pass/degree_three_audit/report.md)
- [`first-pass/dyadic_audit/theorem.md`](first-pass/dyadic_audit/theorem.md)
- [`first-pass/dyadic_audit/Main.lean`](first-pass/dyadic_audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
