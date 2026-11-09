# 005. Irrationality of Catalan’s constant.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Odd-prime valuation bounds eq:odd-lower-pair-range / eq:odd-two-layer-bound for arbitrary p-integral rows with stated supports, arbitrary gamma, singular matrices | openai-math/preprints/Catalans-constant-is-irrational-September-24-2026/build/sections/odd-primes.tex:324 'v_p(Delta_N) >= -2n+(d_0-q)_+' and :401 'v_p(Delta_N) >= -min(2n,n+R,2R+S)' | Read manuscript Lemmas odd-digit-reductions, central-layer, odd-local-elimination (odd-primes.tex:1-500) and Argus report. |

Main files:

- [`first-pass/odd-prime-bound/report.md`](first-pass/odd-prime-bound/report.md)
- [`first-pass/odd-prime-bound/Main.lean`](first-pass/odd-prime-bound/Main.lean)
- [`first-pass/odd-prime-bound/statement_fidelity.md`](first-pass/odd-prime-bound/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
