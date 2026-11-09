# 127. Average sensitivity of polynomial threshold functions.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Coupling lemma 8a sigma -> 4a E\|U-c\|; I(sign p) <= 4d sqrt n instead of 8d sqrt n | Average-Sensitivity-of-Polynomial-Threshold-Functions-September-25-2026/build/sections/02-coupling.tex:18 'E(U-V)^2<=8a sigma'; 01-introduction.tex:26 'I(f)<=8d sqrt n' | Random test of E(U-V)^2 <= 4a E\|U-c\| (c=median and mean) over 2e5 equal-marginal permutation couplings: max ratio 0.833. Checked the main-theorem propagation: I<=2E(U-V)^2<=2*4*d*(sqrt n/2)=4d sqrt n. |

Main files:

- [`first-pass/shifted-coupling/report.md`](first-pass/shifted-coupling/report.md)
- [`first-pass/shifted-coupling/Main.lean`](first-pass/shifted-coupling/Main.lean)
- [`first-pass/shifted-coupling/statement_fidelity.md`](first-pass/shifted-coupling/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
