# 141. Existential–universal real sentences in the counting hierarchy.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:char-coeff level F_{a+8} -> F_{max(a+2,5)}; mult-determinant F_{max(a+3,5)} | Existential-universal-real-sentences-in-the-counting-hierarchy-October-4-2026/build/sections/03-algebra.tex:242 'uniformly computable in F_{a+8}'; proof l.311-319 (a+3, max(a+3,4)+2) | Read section 6: H(z) is one modular sum over tuple (k,j,u), giving F_{a+1}. The final sum over (z,h) is one tuple sum, giving F_{max(a+2,5)}. Did not re-derive the counting-hierarchy closure primitives. |

Main files:

- [`first-pass/determinant_core/report.md`](first-pass/determinant_core/report.md)
- [`first-pass/determinant_core/Main.lean`](first-pass/determinant_core/Main.lean)
- [`first-pass/determinant_core/statement_fidelity.md`](first-pass/determinant_core/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
