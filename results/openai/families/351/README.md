# 351. Scalar curvature and finite-time Ricci-flow singularities.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Reaction estimate c <= [2(q-1)+C_sharp]/r^2 with numerical C_sharp=8+4E (manuscript: 2(q-1)+C sqrt q) | preprints/A-closed-Ricci-flow-with-bounded-scalar-curvature-and-finite-time-curvature-blowup-September-24-2026/build/sections/05-reaction.tex:217 'c <= (2(q-1)+C sqrt q)/r^2' and :254-255 'largest eigenvalue at most q-1+C sqrt q' | Hand-checked the Schur/Young step: separated diagonal <= q+3, block <= D_low, coupling \|v\|^2 <= Eq; 2\|x\|\|v\|\|y\| <= 2E x^2+(q/2)\|y\|^2 is exact AM-GM, so lambda_max <= q+3+2E once q/2 >= D_low-3-2E |

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
