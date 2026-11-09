# 122. Quantitative trace-reconstruction bounds with a uniform decoder.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:multiscale loss 7.98 -> 7.84 and 4k<=D -> 2k<=D | Uniform-quasipolynomial-time-trace-reconstruction-October-5-2026/build/manuscript/multiscale.tex:20-29: '4k<=D' ... '\|S_{f'}\| >= e^{-7.98E}'; lem:balanced-product l.317 e^{-7.94E} | Recomputed the Cauchy-matching constants: (atan(-0.003)+atan(4.003))/pi=0.42112>0.421, M(2)=0.73904>0.739, 1.0001/0.421=2.3755<2.376, 2(1.0001)/0.738=2.7103<2.711. Numerically checked the alternating remainder Fourier formula. Exponent chain 7.81-5.424=2.386>2.376 is OK. |

Main files:

- [`first-pass/Main.lean`](first-pass/Main.lean)
- [`first-pass/statement_fidelity.md`](first-pass/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
