# 026. Positive lower density of large prime gaps.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Mixed-moment remainder O(L^{-t-1}(log L)^A) instead of O(L^{-t-1/2}(log L)^A), B>=1 | openai-math/preprints/Positive-lower-density-of-large-prime-gaps-September-25-2026/build/sections/03-moments.tex prop:mixed-moments eq:mixed-moment '=L^{-t}{S(H)C+O(L^{-1/2}(log L)^A)}'; source of loss eq:zero-safe-comparison and eq:zeta-kernel '{1+O_M(L^{-1/2})}' from bounding \|z\| by L^{-1/2} on the core | Located where manuscript loses L^{-1/2} (sup of \|z_gamma\| over \|u\|<=sqrt L); checked that Argus's fix (keep \|z\|<<(1+\|u\|)/L and integrate against Schwartz Phi times polynomially bounded kernel) addresses exactly that step |
| A | DOWNGRADED | Singular-series box mean with elementary Chebyshev cutoff replacing PNT | openai-math/preprints/Positive-lower-density-of-large-prime-gaps-September-25-2026/build/sections/03-moments.tex lem:singular-average (y=(log h)/4 with PNT for Q<=h^{1/2}) | Checked theta(y)<=4 log2 y gives Q<=h^{(log 2)/4}; tail estimate O(1/loglog h) unchanged |

Main files:

- [`first-pass/audit026/moments/statement_fidelity.md`](first-pass/audit026/moments/statement_fidelity.md)
- [`first-pass/audit026/moments/Main.lean`](first-pass/audit026/moments/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
