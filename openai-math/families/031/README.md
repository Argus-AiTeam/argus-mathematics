# 031. Uchida’s conjecture for open homomorphisms of Galois groups.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Uniform-Kummer missed-prime bound extended from target Q(i) to general N subset Q^s; finite class number replaces principality; +g_l(N) | openai-math/preprints/Open-Homomorphisms-of-Global-Solvably-Closed-Galois-Groups-October-5-2026/build/sections/matching.tex:7 'B=Q(i)'; :89-97 prop:uniform-missed-primes '#M_l<=2[K:Q]+2'; proof: 'choose a_w in B^x and h_w>0 with (a_w)=w^{h_w}' | Read manuscript proof and main theorem (introduction.tex:11-17, already for every open homomorphism) |
| A | DOWNGRADED | Same bridge for open-image maps instead of surjections (restriction injective on char-0 H^1) | openai-math/preprints/Open-Homomorphisms-of-Global-Solvably-Closed-Galois-Groups-October-5-2026/build/sections/matching.tex:105 'Pullback along the surjection beta_B is injective on H^1' | Checked the core/inflation-restriction argument (finite-group H^1 with Q_l coefficients vanishes) |

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
