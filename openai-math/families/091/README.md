# 091. Logarithmic and <i>L</i><sub><i>p</i></sub> Brunn–Minkowski inequalities and the B-conjecture.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | REJECTED | Exact invariant defect identity for lem:tensor; strict for f!=0; 'without evenness/commutativity/lower Hessian bound' | preprints/The-logarithmic-Brunn-Minkowski-conjecture-September-23-2026/build/tensor.tex:10 lem:tensor; proof ends with exact sum of squares eq:tensor-squares '2\|\|S+Sym J\|\|^2+(1/6)\|\|J-J^(12)\|\|^2' plus tr(MRMR) | Read the manuscript proof: it already gives an exact pointwise sum-of-squares identity, and the lemma has no evenness/commutativity/lower-Hessian hypotheses |

Main files:

- [`first-pass/analytic_closure/report.md`](first-pass/analytic_closure/report.md)
- [`first-pass/tensor_audit/report.md`](first-pass/tensor_audit/report.md)
- [`first-pass/tensor_audit/Main.lean`](first-pass/tensor_audit/Main.lean)
- [`first-pass/tensor_audit/statement_fidelity.md`](first-pass/tensor_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
