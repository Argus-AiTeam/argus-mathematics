# 274. Parity is not in QAC<sup>0</sup>.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | thm:localization generalized from (C^2)^N with rank-one counts to arbitrary local dimensions and arbitrary-rank local projections, uniformly | preprints/Product-projection-localization-and-the-QAC0-parity-lower-bound-September-24-2026/build/sections/localization.tex:75-88 (thm:localization on H_N=(C^2)^{tensor N}, counts M=sum (I-\|v_i><v_i\|)_i) | Confirmed baseline is qubit/rank-one; read Argus replacement of the scalar Bernoulli base case by an operator inequality. Noted depth-0 case reduces to qubit-like 2x2 Jordan blocks, but at depth>=1 the reflections mix blocks so the generalization is not a trivial embedding (qudit local unitaries are not one-qubit gates). |

Main files:

- [`first-pass/Main.lean`](first-pass/Main.lean)
- [`first-pass/statement_fidelity.md`](first-pass/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
