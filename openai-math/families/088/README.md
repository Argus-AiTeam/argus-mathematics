# 088. Sharp projection-body inequalities and a counterexample to simplex maximization.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | 2W(z)-L(z) >= (41/360)(z-1)^2/max(1,z)^{2n} replacing qualitative strictness | preprints/Pettys-projection-volume-conjecture-in-dimensions-at-least-four-*/build/latex/sections/04_norm.tex:131 'L(z)<=2W(z), equality only at z=1' | Implemented manuscript definitions (k,c,beta,w,d*,I,G,D) and evaluated with 60-digit precision for n=4..39,50,100,200,1000 on ~750 z values incl. near 1 and up to 2^39: min ratio 0.289 > 41/360=0.114 |

Main files:

- [`first-pass/scalar_defect/Main.lean`](first-pass/scalar_defect/Main.lean)
- [`first-pass/scalar_defect/report.md`](first-pass/scalar_defect/report.md)
- [`first-pass/scalar_defect/statement_fidelity.md`](first-pass/scalar_defect/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
