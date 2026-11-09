# 071. Koebe’s circle-domain conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Barrier coefficient 8 / budget 4m -> any kappa>1 with budget kappa*m, size <= kappa(\|\|g\|\|+\|\|m\|\|)+eta | preprints/Koebes-Circle-Domain-Conjecture-September-23-2026/build/sections/03-barriers.tex:193 thm:barrier 'C_bar=8', 'a_u=4m' | Baseline constants confirmed; checked the delta=(kappa-1)/(4kappa) margin kappa(1-2delta)-1=(kappa-1)/2 |
| A | CONFIRMED | No coefficient below 1 possible (annulus example) | same thm:barrier | Recomputed \|\|g0\|\|^2=2pi/log2 for g0=1/(Lambda r log2) and the annulus capacity 2pi/log(2+1/n) |

Main files:

- [`first-pass/tagged_jump_audit/proof.md`](first-pass/tagged_jump_audit/proof.md)
- [`first-pass/tagged_jump_audit/statement_fidelity.md`](first-pass/tagged_jump_audit/statement_fidelity.md)
- [`first-pass/tagged_jump_audit/lean/statement_fidelity.md`](first-pass/tagged_jump_audit/lean/statement_fidelity.md)
- [`first-pass/tagged_jump_audit/lean/Main.lean`](first-pass/tagged_jump_audit/lean/Main.lean)
- [`first-pass/tagged_jump_audit/Main.lean`](first-pass/tagged_jump_audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
