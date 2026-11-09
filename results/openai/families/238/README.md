# 238. Optimal logarithmic mixing of the Thorp shuffle.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | eq:h-2 one-sweep energy identity extended to conditional last-occurrence energy for any deterministic coordinate word; joint independence upgrade of eq:h-3 | openai-math/preprints/Optimal-order-mixing-of-the-Thorp-shuffle-September-26-2026/build/main.tex:294-298 lem:energy-memory, E_t = sum_{j=1}^d 2^{-j} b_{t-j} for cyclic sweeps | Baseline confirmed and Lean exit 0. Not independently checked. |

Main files:

- [`first-pass/thorp_energy/report.md`](first-pass/thorp_energy/report.md)
- [`first-pass/thorp_energy/Main.lean`](first-pass/thorp_energy/Main.lean)
- [`first-pass/thorp_energy/statement_fidelity.md`](first-pass/thorp_energy/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
