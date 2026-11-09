# 074. Kakeya in three and four dimensions.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Two-color matching: sharp pure-type bound d>=(m+1)/2 for order-m matching, attained with N=L^m | preprints/Every-four-dimensional-Kakeya-set-has-full-Hausdorff-dimension-*/build/sections/03-comparison.tex:278 lem:two-color-matching (no sequence with d<=d0<1) | Baseline statement read: it already allows non-algebraic functions and nonuniform marginals K pi_i dt; Lean core compiles |

Main files:

- [`first-pass/two_color_matching/report.md`](first-pass/two_color_matching/report.md)
- [`first-pass/two_color_matching/lean/Main.lean`](first-pass/two_color_matching/lean/Main.lean)
- [`first-pass/two_color_matching/lean/statement_fidelity.md`](first-pass/two_color_matching/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
