# 105. Perfect completeness for 2-to-1 games.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | prop:upper agreement gamma_j: remove factor 2^{-ell} | Perfect-completeness-for-2-to-1-games-September-23-2026/build/04-upper-decoding.tex:517: 'gamma_j:=b 2^{-ell} tau^2/2 2^{-r}' | Read the manuscript proof (lines 455-610): the 2^{-ell} comes from picking one good sigma out of 2^ell characters. Checked Argus Theorem B: \|c_sigma\| <= 1_bad + 1_{good,\|c\|>=t} + t gives fraction T >= q-rho, and E[p(q-rho)]>=b then gives E T>=b; list membership for good sigma holds on all good data since slice mass >= h0/2 there. |

Main files:

- [`first-pass/upper-decoder-certification/theorem.md`](first-pass/upper-decoder-certification/theorem.md)
- [`first-pass/upper-decoder-certification/Main.lean`](first-pass/upper-decoder-certification/Main.lean)
- [`first-pass/upper-decoder-certification/statement_fidelity.md`](first-pass/upper-decoder-certification/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
