# 265. Area laws and tensor networks for two-dimensional gapped systems.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | lem:symbol range extended from 0<t<1/4 to 0<t<1/2 with rate (log k)^{-beta(t)}; fails at t=1/2, unbounded for t>1/2 | preprints/A-two-dimensional-area-law-from-a-global-spectral-gap-September-24-2026/build/sections/05-replicas.tex:615-618 "Fix a partition P,Y,F of V, 0<t<1/4, and a one-copy operator h supported on PY" | Recomputed the sharpness family alpha_k from the stated gamma formula: alpha_k -> 0.13304 = 512/(1225 pi) at t=1/2 (k=1e6), -> 0 at t=0.24, grows like k^{2t-1} at t=0.6. Main t<1/2 calculus proof (marked-ratio approximation, rate) not re-derived. |

Main files:

- [`first-pass/replica_symbol_audit/theorem.md`](first-pass/replica_symbol_audit/theorem.md)
- [`first-pass/replica_symbol_audit/Main.lean`](first-pass/replica_symbol_audit/Main.lean)
- [`first-pass/replica_symbol_audit/statement_fidelity.md`](first-pass/replica_symbol_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
