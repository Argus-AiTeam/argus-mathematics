# 049. A stable-coordinate counterexample in four variables.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Ideal identity (t-s^2, bd-sab)=(a^2t-d^2), s=dc-abt, whenever ac-bd=1, any commutative ring, any t | preprints/A-stable-coordinate-that-is-not-a-coordinate-in-four-variables-October-5-2026/build/source/sections/04-bundle.tex:75 lem bun:principalization 'The extended ideal IC is the principal ideal (v)' (proved by localizing at a over the field-based determinant domain, t=x+u^2) | Groebner-basis membership check both directions modulo ac-bd-1 over Q[a,b,c,d,t] (script (check script)); lean_check.json success, no holes |
| A | PLAUSIBLE | LND rigidity for W+a^2u^2-d^2 for any W with auxiliary degrees <=1 (manuscript: W=a^3b) | preprints/A-stable-coordinate-that-is-not-a-coordinate-in-four-variables-October-5-2026/build/source/sections/05-rigidity.tex:10 prop:rigidity, fixed v=a^3b+a^2u^2-d^2 | Baseline confirmed fixed polynomial; read review summary only |
| A | PLAUSIBLE | Uniform Danielewski-type family W_psi=a^2 psi(ab): no nonzero LND preserves J_psi, every psi | preprints/A-stable-coordinate-that-is-not-a-coordinate-in-four-variables-October-5-2026/build/source/sections/04-bundle.tex and 05-rigidity.tex (single fixed ideal I=J_T) | Baseline scope confirmed; prose not independently checked |

Main files:

- [`first-pass/stable_core_certificate/report.md`](first-pass/stable_core_certificate/report.md)
- [`first-pass/stable_core_certificate/Main.lean`](first-pass/stable_core_certificate/Main.lean)
- [`first-pass/stable_core_certificate/statement_fidelity.md`](first-pass/stable_core_certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
