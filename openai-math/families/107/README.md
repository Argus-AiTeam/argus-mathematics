# 107. Matrix multiplication with exponent at most 9/4.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | omega_F <= 9/4 for every field F (incl. positive characteristic) | Matrix-Multiplication-Nine-Fourths-October-2-2026/build/paper.tex:45-48: 'two n x n complex matrices ... O(n^{9/4+eps}) ... omega<=9/4' (complex model, remark l.690); Staggered-extraction.../sections/parameters.tex:186-188 every-field bound 2.371054886... | Read sections 1,3,9 of the Argus report: restriction descent via a linear functional ell:E->F with ell(1)=1 (e^2 copies, standard), convolution asymptotic rank via interpolation over an extension, spectral duality from Christandl-Vrana-Zuiddam (arbitrary field). Did not check sections 4-8 (characteristic-safe separation, determinant filtration, profile) line by line. |

Main files:

- [`first-pass/all_fields_nine_fourths/report.md`](first-pass/all_fields_nine_fourths/report.md)
- [`first-pass/all_fields_nine_fourths/lean_certificates/Main.lean`](first-pass/all_fields_nine_fourths/lean_certificates/Main.lean)
- [`first-pass/all_fields_nine_fourths/Main.lean`](first-pass/all_fields_nine_fourths/Main.lean)
- [`first-pass/all_fields_nine_fourths/statement_fidelity.md`](first-pass/all_fields_nine_fourths/statement_fidelity.md)
- [`first-pass/all_fields_nine_fourths/lean_certificates/statement_fidelity.md`](first-pass/all_fields_nine_fourths/lean_certificates/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
