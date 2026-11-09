# 113. Approximate counting and entropy of perfect matchings.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Pair-energy constant (10^4 N D)^100 -> 44040192 N^12 (1000D)^6 | A-Fully-Polynomial-...-Perfect-Matchings-...-September-23-2026/build/main.tex:1595-1596 'T=(10N)^30, L=(10^4ND)^100'; proof l.2122-2131 actually gives 1000N^4A_0^6 T = 10^51 N^34 D^6 | Checked 44040192 = 336*2^17 (from 12N^2A0+324N^4A0^6T <= 336 N^4 A0^6 T) and tag count 3*2*2*2*2*4*2*2^8 = 98304 <= 2^17. Injective decoding was read, not proved independently. |

Main files:

- [`first-pass/pair_energy_audit/proof.md`](first-pass/pair_energy_audit/proof.md)
- [`first-pass/pair_energy_audit/statement_fidelity.md`](first-pass/pair_energy_audit/statement_fidelity.md)
- [`first-pass/pair_energy_audit/lean/statement_fidelity.md`](first-pass/pair_energy_audit/lean/statement_fidelity.md)
- [`first-pass/pair_energy_audit/lean/Main.lean`](first-pass/pair_energy_audit/lean/Main.lean)
- [`first-pass/pair_energy_audit/Main.lean`](first-pass/pair_energy_audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
