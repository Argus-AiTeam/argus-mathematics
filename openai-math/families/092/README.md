# 092. The optimal order of convex-body covering density.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | prop:pattern-tail for arbitrary indexed real centers with log-loss (2k0+5/2)log n | preprints/Translative-covering-densities-of-order-n-log-n-*/build/sections/07-targets.tex:140 prop:pattern-tail (retained grid patterns, exp[-exp(gamma n - C_tail log n)]) | Read Argus section 9: 'sections 2-8 use only these properties of P and G' |

Main files:

- [`first-pass/certificates/arbitrary_center_tail/report.md`](first-pass/certificates/arbitrary_center_tail/report.md)
- [`first-pass/certificates/arbitrary_center_tail/Main.lean`](first-pass/certificates/arbitrary_center_tail/Main.lean)
- [`first-pass/certificates/arbitrary_center_tail/statement_fidelity.md`](first-pass/certificates/arbitrary_center_tail/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
