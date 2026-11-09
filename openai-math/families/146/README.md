# 146. Positive metric entropy for the standard map.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | can:local-scarcity extended from c=99/100, tolerance 3/5 to all 2/3<c<1, 2alpha<3c-1 | preprints/Positive-Metric-Entropy-for-the-Standard-Map-at-Large-Parameters-September-23-2026/build/sections/local-scarcity.tex:6 'c=99/100'; cancellation.tex:239-241 '\|tau^+ - tau^-\| <= 3/5' (lemma can:local-scarcity at cancellation.tex:326) | Confirmed baseline parameters; read proof sections 1-2; Lean (exit 0, no holes, standard axioms) checks only scalar exponent margins (10-15c<0, 2-3c<0, 1-3c+2alpha<0), the eighth-chain exponent inequality, and a 4x4 linear system |

Main files:

- [`first-pass/local_scarcity/proof.md`](first-pass/local_scarcity/proof.md)
- [`first-pass/local_scarcity/Main.lean`](first-pass/local_scarcity/Main.lean)
- [`first-pass/REPORT.md`](first-pass/REPORT.md)
- [`first-pass/local_scarcity/statement_fidelity.md`](first-pass/local_scarcity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
