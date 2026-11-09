# 217. The low-temperature Sherrington–Kirkpatrick fluctuation law.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Exact PSD decrement identity (Hessian kernels Loewner-decreasing; matrix supermartingale) upgrading entrywise weighted bound | openai-math/preprints/The-low-temperature-Sherrington-Kirkpatrick-free-energy-limiting-law-September-24-2026/build/sections/05-inverse.tex inv:sector-response (H2) | Read the Gram identity (8)-(10) and (E2): B(A)-B(A') = int alpha E[v v^T] ds >= 0 follows from the Ito/linearized-PDE representation with alpha >= 0 |

Main files:

- [`first-pass/pair_response/report.md`](first-pass/pair_response/report.md)
- [`first-pass/pair_response/lean/Main.lean`](first-pass/pair_response/lean/Main.lean)
- [`first-pass/pair_response/Main.lean`](first-pass/pair_response/Main.lean)
- [`first-pass/pair_response/statement_fidelity.md`](first-pass/pair_response/statement_fidelity.md)
- [`first-pass/pair_response/lean/statement_fidelity.md`](first-pass/pair_response/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
