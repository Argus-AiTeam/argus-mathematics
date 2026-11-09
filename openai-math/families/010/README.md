# 010. Unrestricted pro-modularity at the prime two.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Full primary decomposition, nilradical, nilpotence index u+1, generic multiplicity 2^r of the completed tame special fiber | openai-math/preprints/Fontaine-Mazur-modularity-at-the-prime-2-October-6-2026/build/sections/deformation.tex:~912-920 remark 'The common raw special fiber need not be reduced ... a(d+g') can be nonzero with square zero ... do not make either of these stronger assertions.' | Groebner bases over GF(2) (sympy, (check script)): I=(a^2+bc,bt,ct,bf+ce) equals (a^2,b,c) cap (t,F,G); at notin I, (at)^2 in I; for two places a1t1*a2t2 notin I_2 (so nilpotence index >=3=u+1). |

Main files:

- [`first-pass/tame_local_model/report.md`](first-pass/tame_local_model/report.md)
- [`first-pass/tame_local_model/statement_fidelity.md`](first-pass/tame_local_model/statement_fidelity.md)
- [`first-pass/tame_local_model/reviewer_lean_run/statement_fidelity.md`](first-pass/tame_local_model/reviewer_lean_run/statement_fidelity.md)
- [`first-pass/tame_local_model/reviewer_lean_run/Main.lean`](first-pass/tame_local_model/reviewer_lean_run/Main.lean)
- [`first-pass/tame_local_model/Main.lean`](first-pass/tame_local_model/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
