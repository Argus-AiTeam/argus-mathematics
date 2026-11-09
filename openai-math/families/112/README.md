# 112. Beyond the square-root exponent for depth-three circuits.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Restriction lemma E W <= 1/(1-theta) -> E W <= 1 for theta<=1 | Beyond-the-Square-Root-Exponent-for-Depth-Three-Boolean-Circuits-September-23-2026/build/latex/sections/02_restriction.tex:26: 'E W(H,T,rho) <= 1/(1-theta)' (theta<1) | Hand-checked the clause-insertion mass identity: averaging over S gives q^{\|S\|}(sum_{D subset S,\|D\|>b}(p/q)^{\|D\|}-1) m_F(r_a) with p/q=2p/(1-p), so the sum is <= theta. Lean Main.lean exit 0, no holes, formalizes the actual construction. |

Main files:

- [`first-pass/restriction_certificate/Main.lean`](first-pass/restriction_certificate/Main.lean)
- [`first-pass/restriction_certificate/report.md`](first-pass/restriction_certificate/report.md)
- [`first-pass/restriction_certificate/statement_fidelity.md`](first-pass/restriction_certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
