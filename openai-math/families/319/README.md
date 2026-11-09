# 319. Counterexamples to finite generation at chromatic height two.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | obs:growth constant made explicit: v(n)^3 <= D^3 p^6 (3n+4L), c_0=Dp^2(3+4L)^{1/3} | Counterexamples-to-the-Hahn-Wilson-conjecture-at-height-two-September-26-2026/build/sections/obstruction.tex:606-621 obs:growth: "There is a constant c_0 ... dimension at most c_0(1+n)^{1/3}" | Checked the arithmetic chain: d+r_d<=3d (kappa<=2), B=3(n+L), J=B+L=3n+4L, minimal s with p^{3(s-1)}>J gives t^3<=p^6 J, and v<=D t. The divided-difference identity (3) is standard. No Lean. |

Main files:

- [`first-pass/joint_kernel/report.md`](first-pass/joint_kernel/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
