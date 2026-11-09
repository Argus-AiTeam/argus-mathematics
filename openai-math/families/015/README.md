# 015. Torus-packet equidistribution in prime, quartic, and sextic degrees.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Theorem B: sup norm vol(R) at odd primes, support p^{-c} h d^{-1} (vs p^{-4(g+1)} h d^{-1}), dyadic 2^{-max(c+3,4)} | openai-math/preprints/Equidistribution-of-Primitive-Quartic-Torus-Packets-for-Arbitrary-Orders-October-5-2026/build/manuscript/local-fourier.tex:423-436 '\|\|K\|\| <= p^{3 iota_p} vol(R_E)' and 'supp K subset p^{-4(g_p+1)} h_p d_E^{-1}' | Checked period step algebraically: (alpha+t)^{-1}-beta = -t beta^2/(1+t beta) in p^c h subset C when t in p^c h^{-1}, beta in h; 1+t beta a square unit for odd p. |
| A | CONFIRMED | Theorem C: explicit family with K_h value (1-1/p)^2 p^{-c}, showing odd support exponent c sharp | Same file local-fourier.tex:433-436 (manuscript support exponent 4(g+1)); sharpness is for Argus's improved exponent c | Recomputed the final integral int_{a,b in Z_p^x} F_c(a-b) psi(-(a-b)/p^c) by exact finite sums mod p^c for p in {2,3,5,7}, c in {2,3}: matches (1-1/p)^2 p^{-c} exactly ((check script)). |
| A | PLAUSIBLE | Two profile inequalities improved from G_0^24 to G_exp^3, constant 13,824,000 | openai-math/preprints/Equidistribution-of-Primitive-Quartic-Torus-Packets-for-Arbitrary-Orders-October-5-2026/build/manuscript/additive.tex:157-207 'prod p^{12(g_p+1)} <= 30^12 G_0^24' (lem:add-profile-bounds) | Checked ideal-norm bookkeeping (Norm(pR_F)=p^3, 2^{3N_2}<=2^12 2^{3c_2}) and 2^12*3^3*5^3=13,824,000. |

Main files:

- [`first-pass/quartic_shell/theorem.md`](first-pass/quartic_shell/theorem.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
