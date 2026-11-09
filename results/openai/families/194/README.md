# 194. Lech’s multiplicity conjecture.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Explicit A_h=max{h,3(h-1)h^{h-1}/(2(h-1)!)} in thm:complex; leading coefficient 1 sharp (non-Noetherian Koszul family) | openai-math/preprints/Lechs-multiplicity-conjecture-September-23-2026/build/sections/complex.tex:55-80 thm:complex: 'There is a constant A_h, depending only on h ... lambda H_0(F) >= mu s^h (b_0 - A_h/s sum b_i)'; standing setting (lines 16-30) is an arbitrary commutative ring C | Recomputed the Riemann-sum error (eq. 28) exactly for h=2..7 and several s: max error/(E_h/s)=0.33, so the explicit A_h is valid |

Main files:

- [`first-pass/complex_estimate/proof.md`](first-pass/complex_estimate/proof.md)
- [`first-pass/complex_estimate/lean/statement_fidelity.md`](first-pass/complex_estimate/lean/statement_fidelity.md)
- [`first-pass/complex_estimate/lean/certificates/statement_fidelity.md`](first-pass/complex_estimate/lean/certificates/statement_fidelity.md)
- [`first-pass/complex_estimate/lean/certificates/Main.lean`](first-pass/complex_estimate/lean/certificates/Main.lean)
- [`first-pass/complex_estimate/lean/Main.lean`](first-pass/complex_estimate/lean/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
