# 219. GOE bulk universality for regular graphs with weak Anderson disorder.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:gaussian-marks equality case under parity-preserving ergodicity and log inverse-covariance moment; two-phase example shows ordinary ergodicity insufficient | openai-math/preprints/Fixed-energy-universality-for-weak-Anderson-disorder-on-random-regular-graphs-October-5-2026/build/sections/05-rigidity.tex:278-294 prop:gaussian-marks | Baseline confirmed. The proof was not checked. |

Main files:

- [`first-pass/rigidity_certificate/report.md`](first-pass/rigidity_certificate/report.md)
- [`first-pass/rigidity_certificate/Main.lean`](first-pass/rigidity_certificate/Main.lean)
- [`first-pass/rigidity_certificate/statement_fidelity.md`](first-pass/rigidity_certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
