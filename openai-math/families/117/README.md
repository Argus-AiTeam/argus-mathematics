# 117. Uniform sparsest cut: hardness and semidefinite gaps.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | lem:quadratic-correction to degree d<q-1 with 27gamma+3delta<1 | Constant-factor-hardness-of-uniform-sparsest-cut-September-24-2026/build/source/sections/02-bit-tests.tex:442-448: 'gamma=10^{-3} ... 27gamma+5delta<1' | Read the manuscript proof: the condition comes from (18g+2d)+3(3g+d). With gamma=10^-3 and delta < gamma/4 forced by the other hypotheses, 27gamma+5delta<1 is never binding. |

Main files:

- [`first-pass/quadratic_correction/report.md`](first-pass/quadratic_correction/report.md)
- [`first-pass/quadratic_correction/Main.lean`](first-pass/quadratic_correction/Main.lean)
- [`first-pass/quadratic_correction/statement_fidelity.md`](first-pass/quadratic_correction/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
