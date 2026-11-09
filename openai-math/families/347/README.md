# 347. Counterexamples to stable-Morse and strong Arnold fixed-point bounds.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Cyclic-integral-sharp fixed-point counterexamples in real dimension 22: #Fix=beta_cyc=80+5312m, SM=80+5344m (deficit 32m) | preprints/Hamiltonian-Fixed-Points-Below-the-Stable-Morse-Number-in-Dimension-Twenty-Two-October-5-2026/build/sections/introduction.tex:37-46 (SM=80+1968m, #Fix=80+1952m) and counts.tex:168-172 (cyclic bound 80+1920m, 32m below #Fix, so not cyclic-sharp); cyclic-sharp only in Sharpness-of-the-Cyclic-Integral-Floer-Bound...-October-5-2026/build/sections/introduction.tex:52-66 (complex dim 1666) | Independent Kunneth/blowup-formula script recomputed b, lambda and beta_cyc for M_m=X_m x Y from the stated centers (2m S_2xCP1, 3m S_3, 2m S_3xCP2 in CP^9, Y ranks (1,6,1)): got b=8(10+496m), lambda=80+5344m, beta_cyc=80+5312m for m=1,2,3, matching the claims |

Main files:

- [`first-pass/sharp22/theorem.md`](first-pass/sharp22/theorem.md)
- [`first-pass/sharp22/Main.lean`](first-pass/sharp22/Main.lean)
- [`first-pass/sharp22/statement_fidelity.md`](first-pass/sharp22/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
