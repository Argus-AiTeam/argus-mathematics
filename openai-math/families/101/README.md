# 101. The sharp simplex conjecture for isotropic constants.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | 42/37 in noncommutative commutator lemma is optimal | A-sharp-entropy-bound-.../build/manuscript/matrix.tex:359: '<= (1+s/8)\|\|w\|\|^2' with s=40/37 | Numerically evaluated LHS/energy from the explicit 2x2 matrices: matches q(x,y) formula, tends to 1.1351351=42/37 at x,y->sqrt37; random test 2e4 instances of inequality (1) (max ratio 1.064<42/37). |

Main files:

- [`first-pass/noncommutative-core/formal/Main.lean`](first-pass/noncommutative-core/formal/Main.lean)
- [`first-pass/noncommutative-core/report.md`](first-pass/noncommutative-core/report.md)
- [`first-pass/noncommutative-core/formal/statement_fidelity.md`](first-pass/noncommutative-core/formal/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
