# 076. Real ultraflat Littlewood polynomials and unbounded binary merit factors.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | All-order conditional moments \|E[Z^u\|V]-p^k\|<=k tau_q+2C(k,2)(2R+1)/q | preprints/Nearly-minimal-maxima-and-positive-minima-of-Littlewood-polynomials-October-5-2026/build/sections/packing.tex:229-231 'E[Z\|V]=p^{r-1}+O(q^-1/2), E[Z^2\|V]=p^{2(r-1)}+O(q^-1/2)' | Baseline confirmed (first and second moments only); checked the good/bad tuple union bound structure |

Main files:

- [`first-pass/packing-audit/report.md`](first-pass/packing-audit/report.md)
- [`first-pass/packing-audit/formal/statement_fidelity.md`](first-pass/packing-audit/formal/statement_fidelity.md)
- [`first-pass/packing-audit/formal/Main.lean`](first-pass/packing-audit/formal/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
