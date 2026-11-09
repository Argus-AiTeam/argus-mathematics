# 099. The sharp exponential scale of edit-distance distortion.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | prop:family separation 24^{-s} -> 9^{-s}; recurrence Q_s -> B_s=(2P)^{2h-2}/L+B_{s-1}/h; coprime/real-l1 generalization | Edit-Distance-in-l1-Matching-Bounds-up-to-Constants-in-the-Exponent-September-27-2026/build/sections/construction.tex:36-37,229: 'alpha_s=24^{-s}', 'Q_s=2(2P)^{2h}/L+Q_{s-1}/h', '>= alpha_{s-1}/24=alpha_s' | Re-derived a_s=mu a/(2C+mu a) from marked-payload bound 2Tdq/(d+q) with T=L,p=Cm,q=Cm; checked mu=b/2 is valid (fewer than b/2 primes divide delta => >=b/2 shifted slots, manuscript conservatively used b/3) and 1+2C/mu=9-4/b<9. |

Main files:

- [`first-pass/prime_product_certificate/theorem.md`](first-pass/prime_product_certificate/theorem.md)
- [`first-pass/prime_product_certificate/Main.lean`](first-pass/prime_product_certificate/Main.lean)
- [`first-pass/prime_product_certificate/statement_fidelity.md`](first-pass/prime_product_certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
