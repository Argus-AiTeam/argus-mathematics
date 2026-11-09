# 046. Shafarevich counterexamples in dimension two and with large fundamental group.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Infinite-quotient construction extended from multiplication by 4 to every dyadic n=2^r, r>=2 | openai-math/preprints/A-surface-counterexample-to-Shafarevich-holomorphic-convexity-September-23-2026/build/sections/03-family.tex:21 'q o [4] = f o q'; 05-quotient.tex:173 prop:infinite-quotient | Recomputed Golod-Shafarevich margin: G_4(49/200)=65806513251003/64e12, 1-G_4+2/100<0; G_n increasing in n (G_8..G_32 ~1.0357); least J for n=4 with (1+6n^2)t(4t)^J/(1-4t)<1/100 is 579 (matches) |
| A | PLAUSIBLE | Non-holomorphically-convex surface for every dyadic n>=4, exact dual-graph incidence formula, profinite local detection | openai-math/preprints/A-surface-counterexample-to-Shafarevich-holomorphic-convexity-September-23-2026/build/sections/06-*.tex thm:main (n=4 case) | Read report; Lean surface_geometry_audit exit 0, no sorry but only abstract descent core (4 small lemmas) |

Main files:

- [`first-pass/surface_weighted_audit/REPORT.md`](first-pass/surface_weighted_audit/REPORT.md)
- [`first-pass/surface_geometry_audit/REPORT.md`](first-pass/surface_geometry_audit/REPORT.md)
- [`first-pass/surface_geometry_audit/statement_fidelity.md`](first-pass/surface_geometry_audit/statement_fidelity.md)
- [`first-pass/surface_geometry_audit/Main.lean`](first-pass/surface_geometry_audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
