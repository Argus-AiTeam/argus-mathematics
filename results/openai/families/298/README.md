# 298. Two notions of free entropy differ even when both are finite.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Fisher deficit g(u) <= (4/3)K^8 p u^-5 (vs 2K^6 p^{3/2} u^-4), entropy deficit K^8 p/(6a^4); exact asymptotics | A-finite-entropy-separation-of-microstates-and-nonmicrostates-free-entropy-September-25-2026/build/sections/04-signal.tex:79-83 eq:specialfisher: 0<=Phi*(V_u)-sum 1/(u+c_i) <= 2K^6 p^{3/2} u^{-4} for u>2K^2 sqrt p, K=128 (line 46); :103 chi* >= L(a)-K^6p^{3/2}/(3a^3) | Checked the load-bearing steps. (i) Odd cumulants vanish because Y is symmetric (the manuscript's uniform p-point Y on [-1,1]). (ii) Cumulants with fewer than two Y letters vanish, giving support <= 5^m p^{(m-2)/2} and \|\|kappa_m\|\|^2 <= K^{2m}p^{(m-2)/2}. (iii) The series sum_{k>=2} u^{-2}K^{4k}p^{k-1}u^{-(2k-1)} = K^8 p u^-5/(1-K^4p/u^2) <= (4/3)K^8p u^-5 for u>2K^2 sqrt p. Recomputed by hand. Lean exit 0, no holes. |

Main files:

- [`first-pass/analytic_fisher/report.md`](first-pass/analytic_fisher/report.md)
- [`first-pass/analytic_fisher/statement_fidelity.md`](first-pass/analytic_fisher/statement_fidelity.md)
- [`first-pass/analytic_fisher/Main.lean`](first-pass/analytic_fisher/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
