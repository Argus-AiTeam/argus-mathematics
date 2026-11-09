# 247. An infinite finitely presented residually finite 2-group and a finitely presented nil algebra.

**Result:** issue in the OpenAI manuscript.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| B | CONFIRMED | fr:rollback last sentence "A boundary-cursor region can always be released inside its acquired interval" fails for a truncated one-letter word B at C(2), l=b=1 | preprints/An-infinite-finitely-presented-periodic-group-September-23-2026/build/sections/finite-rules.tex:580-581 "A boundary-cursor region can always be released inside its acquired interval."; truncation allowed at :188-189 and :269-274 ("At the ends of the whole word an interface for which no neighbor is present is not checked") | Checked interface table (:244-258: B left interface "external at first; otherwise internal from L" is unchecked at a word end), endpoint zeros only for R/L (:231-235), acquisition moves only create B at C(1) (:362-375), so a lone B@C(2) has no applicable move; manuscript itself uses analogous nonzero one-letter words (:895-897). Nilpotent 2x2 representation argument read. |

Main files:

- [`first-pass/finite_rule_core/proof.md`](first-pass/finite_rule_core/proof.md)
- [`first-pass/finite_rule_core/Main.lean`](first-pass/finite_rule_core/Main.lean)
- [`first-pass/finite_rule_core/statement_fidelity.md`](first-pass/finite_rule_core/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
