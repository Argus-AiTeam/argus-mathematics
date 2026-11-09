# 044. The equivariant cohomological Hikita conjecture.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | prop:filtration-bound for the abstract invariant algebra over every commutative Q-algebra instead of C | openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026/build/sections/laurent.tex:237-243 prop:filtration-bound 'Hilb(B_0;q) <= sum q^{C(v)-D_m+w.(v-l)} h_m(q)', with P=C[x_ia] (l.22) | Base-change analysis: structure constants c(alpha,beta) are integral; with \|W\| invertible, invariants commute with any base change (Reynolds), quotient B is right exact, so B_K=B_Q (x) K; surjectivity over C descends to Q (faithfully flat) and then base-changes to any Q-algebra. Lean cut_symbol exit 0, no sorry (partial). |

Main files:

- [`first-pass/cut_symbol/proof.md`](first-pass/cut_symbol/proof.md)
- [`first-pass/cut_symbol/lean/statement_fidelity.md`](first-pass/cut_symbol/lean/statement_fidelity.md)
- [`first-pass/cut_symbol/lean/Main.lean`](first-pass/cut_symbol/lean/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
