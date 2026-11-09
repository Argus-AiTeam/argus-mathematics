# 048. A characteristic-zero counterexample to Lipman–Zariski.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Upper bound p_g<=39 added to manuscript's p_g>=33, p_g=39-rank d2-rank d3-rank d4, stabilization at 5C | openai-math/preprints/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026/build/05-analytic.tex:410-421 'h^1(O_{2C})=12+21=33 ... p_g(X,x) >= 33' | Recomputed: g=21, deg L=10, L^4=K_C: h^1(O_C)=21, h^1(L)=12, h^1(L^2)=3 (h^0=3, chi=0), h^1(L^3)=h^0(L)=2, h^1(L^4)=1, h^1(L^n)=0 for n>=5 (deg>40); sum 39; sequences give stabilization from 5C |
| A | DOWNGRADED | prop:jets extended from N=7 to every N>=2 with coefficientwise stable formal limit | openai-math/preprints/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026/build/04-jets.tex:573-581 prop:jets 'match through row index seven'; induction 402-562 is for general k, stop at 7 chosen at 564 | Read manuscript induction: invariant is proved for every k>=3 and later steps leave earlier equations unchanged; stopping at 7 is a choice |

Main files:

- [`first-pass/jet_audit/report.md`](first-pass/jet_audit/report.md)
- [`first-pass/algebraization_audit/report.md`](first-pass/algebraization_audit/report.md)
- [`first-pass/curve_trace_audit/report.md`](first-pass/curve_trace_audit/report.md)
- [`first-pass/analytic_audit/report.md`](first-pass/analytic_audit/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
