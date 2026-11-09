# 132. A superquadratic separation of sensitivity and block sensitivity.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Explicit bs(F_m,0) >= s(F_m)^{161/80} (exponent 2.0125) | A-superquadratic-separation-...-September-25-2026/build/sections/03-separation.tex:219-262 cor:power-separation: 'There exist alpha>2 ... bs(F_m,0)>=s(F_m)^alpha', alpha=log B/log A with d=9, M>=9^10 (about 2.00025); lem:quantitative-profiles needs M>=9^{d+1} | Iterated the manuscript's recurrences (prop:recurrences) exactly with d=20, M=16*3^20, r=4*3^10, t=16, L=22: max(M S_{20,0},S_{20,1}) = 34.37 M^21 <= 36 M^21. Exact integer check B^80 >= A^161, alpha=2.01280. Manuscript d=9 alpha=2.000252. Construction itself only needs M>=3 (01-construction.tex:9). |

Main files:

- [`first-pass/quantitative_profile/lean/Main.lean`](first-pass/quantitative_profile/lean/Main.lean)
- [`first-pass/quantitative_profile/Main.lean`](first-pass/quantitative_profile/Main.lean)
- [`first-pass/quantitative_profile/REPORT.md`](first-pass/quantitative_profile/REPORT.md)
- [`first-pass/quantitative_profile/lean/statement_fidelity.md`](first-pass/quantitative_profile/lean/statement_fidelity.md)
- [`first-pass/quantitative_profile/STATEMENT_FIDELITY.md`](first-pass/quantitative_profile/STATEMENT_FIDELITY.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
