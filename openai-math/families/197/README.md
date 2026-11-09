# 197. A torsion-free group algebra that is not directly finite.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | thm:bounded-patterns with explicit error budget and admissible epsilon < tau/(A-tau) vs manuscript min(1/4, delta/(16(1+a0))) | openai-math/preprints/A-Torsion-Free-Group-Algebra-That-Is-Not-Directly-Finite-October-4-2026/build/sections/patterns.tex:28-44 ('There is a constant epsilon>0 ...'); the choice epsilon:=min{1/4, delta/(16(1+a_0))} is at patterns.tex:561-569, with a_0 and delta at lines 392-398 | Confirmed that the baseline epsilon is a proof-internal choice and that tau~delta (word-mass decay) and A~a_0 (minimum turn weight) correspond. The Lean core compiled with exit 0 and has no sorry. The analytic stage product was not re-derived. |

Main files:

- [`first-pass/bounded-path-core/theorem.md`](first-pass/bounded-path-core/theorem.md)
- [`first-pass/bounded-path-core/Main.lean`](first-pass/bounded-path-core/Main.lean)
- [`first-pass/bounded-path-core/statement_fidelity.md`](first-pass/bounded-path-core/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
