# 205. Saxl’s conjecture and universal tensor squares.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Single explicit integral conjugator Q=[[1,1],[1,2]] gives nonzero odd-path contraction epsilon*prod r_j! (epsilon in {±1,±3}) for every ordered column list | openai-math/preprints/A-Cyclic-Polytabloid-Proof-of-Saxls-Conjecture-September-24-2026 path:segment / path:generator-sign (existential, list-dependent conjugator; genericity for finite collections) | Exact integer computation of the pairing [X1 J X2^T J X3 ...]_{11} summed over signed segment alternations of N_i = Q M_i Q^{-1}, for all 284 ordered lists with parts in {1..4} and odd sum k <= 9. Every value is in {±1,±3} times prod r_j!, with none zero. |

Main files:

- [`first-pass/odd_path/REPORT.md`](first-pass/odd_path/REPORT.md)
- [`first-pass/odd_path/Main.lean`](first-pass/odd_path/Main.lean)
- [`first-pass/odd_path/statement_fidelity.md`](first-pass/odd_path/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
