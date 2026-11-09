# 175. Talagrand’s expectation thresholds, discrete convexity, and graph decompositions.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Main theorem constant q_f <= 25*512^4 q improved to q_f <= 25*96^4 q (selector D=256 -> 48) | preprints/Integral-and-fractional-expectation-thresholds-are-equivalent-September-23-2026/build/source/sections/rounding.tex:19 'D=256, B=512, C=25B^4' and :124 'q_f(F) <= 25*512^4 q(F)' (also introduction.tex:56) | Checked the full selector proof by hand. Steps: the truncation-maximality bound d\|T\|<=m; the one-level delay contradiction giving (8); the injective encoding count; the exact likelihood identity (9); the multinomial sum giving (t^t/t!)R^t; and t^t/t! <= 3^{t-1} (numerically for t<60). Recomputed R<2/(D-2) and 2R/(1-3R)=1/10 at D=48. The rounding step only needs B=2D and P(success)>=9/10 (rounding.tex:60-120). Lean (exit 0) covers the reconstruction core. |

Main files:

- [`first-pass/selector_certificate/lean/Main.lean`](first-pass/selector_certificate/lean/Main.lean)
- [`first-pass/selector_certificate/Main.lean`](first-pass/selector_certificate/Main.lean)
- [`first-pass/selector_certificate/proof.md`](first-pass/selector_certificate/proof.md)
- [`first-pass/selector_certificate/statement_fidelity.md`](first-pass/selector_certificate/statement_fidelity.md)
- [`first-pass/selector_certificate/lean/statement_fidelity.md`](first-pass/selector_certificate/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
