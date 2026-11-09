# 028. Uniformly bounded components of Gaussian-prime graphs.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Rectangle lemma Pr <= min{1, 3 e^{-d^2 r/32}} for all r (manuscript C e^{-c d^3 r} when d^3 r>=C_0) | openai-math/preprints/Bounded-Step-Walks-on-Gaussian-Primes-September-26-2026/build/geometry.tex:84-102 lem:rectangle 'absolute positive constants c,C,C_0 such that, if d^3 r>=C_0 ... <= C e^{-c d^3 r}' | Hand-checked each step: Hoeffding tail with t=d log P/2, L=log 2T<=2 log T gives e^{-d^2 r/8}; det(w,w') divisible by N(c*)>=P/(2T)^h and \|det\|<=2RW forces collinearity for h<=dr/4; Doob-martingale two-set concentration mu(A)mu(B)<=e^{-s^2/r}; separated-classes aggregation b<=3max(m,e^{-s^2/2r}) with s=dr/4 gives 3e^{-d^2 r/32} |

Main files:

- [`first-pass/signed_rectangle/PROOF.md`](first-pass/signed_rectangle/PROOF.md)
- [`first-pass/signed_rectangle/STATEMENT_FIDELITY.md`](first-pass/signed_rectangle/STATEMENT_FIDELITY.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
