# 014. Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Local step of lem:compact-conjugator without regular-nilpotent hypothesis and without coefficient extension (canonical F-rational cocharacter grading the whole r-eigenspace) | openai-math/preprints/Frobenius-Structures-on-Tame-Hecke-Eigensheaves-October-5-2026/build/sections/parameters.tex:249-260 'Suppose N_1 ... is regular nilpotent ... After a finite coefficient extension there exist a cocharacter c ... c(z)A=Ac(z), Ad(c(z))N_1=zN_1' | Checked by hand the decisive identity (a-r lambda)^m N = r^m N (a-lambda)^m from aN=rNa, the path/height construction (infinite order of r excludes cycles), traceless-lift scalar argument and Galois descent of height-graded sums. |

Main files:

- [`first-pass/arithmetic_boundary_gluing/theorem.md`](first-pass/arithmetic_boundary_gluing/theorem.md)
- [`first-pass/arithmetic_boundary_gluing/statement_fidelity.md`](first-pass/arithmetic_boundary_gluing/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
