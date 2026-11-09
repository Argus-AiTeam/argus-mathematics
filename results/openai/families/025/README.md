# 025. Short Egyptian fractions.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Divisor moment bound with one threshold S0(D) uniform over 1<=r<=log S/(200000 loglog S) (manuscript: fixed r, S0(D,r)); primorial obstruction at r=C log S/loglog S, C>1/2 | openai-math/preprints/Short-Egyptian-fractions-September-25-2026/build/divisors.tex:22-33 lem:divisor 'For every fixed pair of real numbers D,r>=1, there is S_0(D,r) ... sum d_X(N+h)^r <= Y exp(S^{1/4})' | Baseline confirmed; read quantifier order in report (S0 chosen before r, Main.lean:1652-1718); lean_check.json status success, grep finds 0 sorry/axiom in Main.lean; checked A_k<=16(4k)^k derivation and k log(4k)<L/100 arithmetic |

Main files:

- [`first-pass/growing_divisor_moments/Main.lean`](first-pass/growing_divisor_moments/Main.lean)
- [`first-pass/divisor_moment/Main.lean`](first-pass/divisor_moment/Main.lean)
- [`first-pass/growing_divisor_moments/proof.md`](first-pass/growing_divisor_moments/proof.md)
- [`first-pass/divisor_moment/statement_fidelity.md`](first-pass/divisor_moment/statement_fidelity.md)
- [`first-pass/growing_divisor_moments/statement_fidelity.md`](first-pass/growing_divisor_moments/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
