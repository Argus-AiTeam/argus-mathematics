# 315. The four-dimensional Singer conjecture.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | pret:invariant-class generalized to an iff criterion (D_P(B) point <=> invariant finite-interval class) under weaker group hypotheses | The-Singer-conjecture-in-dimension-four-September-25-2026/build/pretree.tex pret:invariant-class (finitely presented, torsion-free, one-ended, no splittings => invariant finite-interval class) | Baseline confirmed. The ordinal-induction argument was not re-derived. Lean covers only an order-theoretic fixed-point lemma. |

Main files:

- [`first-pass/all-parabolic-reduction/report.md`](first-pass/all-parabolic-reduction/report.md)
- [`first-pass/all-parabolic-reduction/Main.lean`](first-pass/all-parabolic-reduction/Main.lean)
- [`first-pass/all-parabolic-reduction/statement_fidelity.md`](first-pass/all-parabolic-reduction/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
