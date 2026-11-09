# 332. Metric Markov cotype of <i>ℓ</i><sub>1</sub> and Hilbert-space Lipschitz extension.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | N_2(l1)^2 <= 504 (vs 3024), flatness constant 18 (vs 108), 18 optimal | Metric-Markov-Cotype-Two-of-l1-October-5-2026/build/main.tex:88-91 thm:main N_2(l1)<=12 sqrt(21); :96 C^2=3024; :291-296 lem:flat constant 108; :545 108*28 | Sympy-verified identity 2R-DS=(B-A)^2+4(A-C)^2. Random test of the weighted flatness inequality on 2e5 cases (max ratio 15.8 < 18). Sharpness family at m=1000 gives ratio 17.96. Checked \|phi(y)-phi(x)\|<=3\|y^2-x^2\| and 18*28=504. Lean flat18 exit 0, no holes. |

Main files:

- [`first-pass/lean/Main.lean`](first-pass/lean/Main.lean)
- [`first-pass/lean/statement_fidelity.md`](first-pass/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
