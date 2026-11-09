# 227. Critical SK autocorrelation processes and dynamics across the temperature transition.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Critical SK autocorrelation functional limit extended to centered variance-one zero-third-moment disorder with two-sided exponential moment | openai-math/preprints/Functional-universality-of-critical-SK-autocorrelations-October-5-2026/build/sections/01-introduction.tex:44-55 thm:main ('for each of the two choices of D', Gaussian or Rademacher); 09-functional.tex:83-88 | Baseline confirmed (only Gaussian/sign). The comparison argument was not checked. |

Main files:

- [`first-pass/critical_resolvent_comparison/report.md`](first-pass/critical_resolvent_comparison/report.md)
- [`first-pass/critical_resolvent_comparison/Main.lean`](first-pass/critical_resolvent_comparison/Main.lean)
- [`first-pass/critical_resolvent_comparison/statement_fidelity.md`](first-pass/critical_resolvent_comparison/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
