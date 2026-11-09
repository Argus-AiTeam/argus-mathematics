# 038. Fujita’s freeness conjecture.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Explicit threshold t > n+1 - a/(n+2) replacing qualitative choice I_*>1/t (eq:center-choose-t) | openai-math/preprints/Fujitas-freeness-conjecture-September-23-2026/build/sections/centers.tex:355-365 'I_*=int_0^1 s^n exp((1-s)a_*/(n+1)) ds > 1/(n+1). Choose ... t<n+1 ... sufficiently close to n+1 that I_*>1/t' | Rederived: tangent bound e^x>=1+x gives int s^n(1+u(1-s)) = 1/(n+1)+u/((n+1)(n+2)) with u=a/t, so 1/t < that iff t+a/(n+2) > n+1. Correct. |
| A | DOWNGRADED | Abstract implication sigma(t+a/(n+2)) <= n+1 under uniform-slope premises | openai-math/preprints/Fujitas-freeness-conjecture-September-23-2026/build/sections/centers.tex:363 eq:center-choose-t | Same computation as above |

Main files:

- [`first-pass/fujita_point_center/report.md`](first-pass/fujita_point_center/report.md)
- [`first-pass/fujita_point_center/Main.lean`](first-pass/fujita_point_center/Main.lean)
- [`first-pass/fujita_point_center/statement_fidelity.md`](first-pass/fujita_point_center/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
