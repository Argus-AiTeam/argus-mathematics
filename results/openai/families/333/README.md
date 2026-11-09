# 333. Smooth isometric immersions of surfaces into ℝ<sup>4</sup>.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:exact-correction generalized to D>=4, polynomially degenerating second form, polynomial jet growth, varying metrics h_z, with R=440 | Smooth-isometric-immersions... exact-correction.tex prop:exact-correction (D=4, a=2,b=1,d=0, fixed h_*) | Read the statement and the reduction to the manuscript case (D=4, a=2, b=1, d=0). The Nash-Moser-type analytic proof was not checked. Lean covers only a scalar recurrence. |

Main files:

- [`first-pass/exact_correction_audit/theorem.md`](first-pass/exact_correction_audit/theorem.md)
- [`first-pass/exact_correction_audit/Main.lean`](first-pass/exact_correction_audit/Main.lean)
- [`first-pass/exact_correction_audit/statement_fidelity.md`](first-pass/exact_correction_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
