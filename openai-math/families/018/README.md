# 018. The Margulis–Platonov conjecture over global fields.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Block-supported shears for arbitrary finite disjoint parameter tuples over separable quadratic global extensions (no conjugacy/division-algebra/odd-count/degree-6 restrictions) | openai-math/preprints/The-Margulis-Platonov-conjecture-over-number-fields-September-23-2026/build/sections/characters.tex:113-140 'Suppose ... d lies in a *-stable maximal subfield E subset D ... the n conjugates t_1..t_n of d are distinct and disjoint from bar t_1..bar t_n' then lem:chars-pure-shears | Checked by hand: N(z)=(ab-2a+1)z-ab+2b-1 has coefficient sum 2(b-a)!=0 in odd char and equals (ab+1)(z+1) in char 2; commutator [diag(u^-2,u^2),U(x)]=U((u^-4-1)x). |

Main files:

- [`first-pass/exact_transitivity/report.md`](first-pass/exact_transitivity/report.md)
- [`first-pass/exact_transitivity/Main.lean`](first-pass/exact_transitivity/Main.lean)
- [`first-pass/exact_transitivity/statement_fidelity.md`](first-pass/exact_transitivity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
