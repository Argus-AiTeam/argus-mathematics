# 148. The entropy-rate dimension formula for self-similar measures.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Finite-law pair bound constant C_k=60000k^4 -> 1000k^4 | preprints/The-entropy-rate-dimension-formula-for-self-similar-measures-on-the-line-September-24-2026/build/sections/pairs.tex:223 'one may take C_k=60000k^4' (the manuscript's own proof gives 20160*8/3=53760, line 207) | Read the Lean statement pair_bound_1000 (Main.lean:1076): k(H(nu)-H^0_rho(nu)) <= log2\|kF\| + 1000k^4 * sum_{2^-l<=2rho} c_l(nu), over arbitrary finite laws, k>=1, rho>0. Compile log: exit 0, axioms only propext/Classical.choice/Quot.sound. No sorry in the vendored OAI imports. Definitions (capacity, bands) come from OpenAI's own Lean library. |

Main files:

- [`first-pass/pair-bound/Main.lean`](first-pass/pair-bound/Main.lean)
- [`first-pass/dimension-audit/proof.md`](first-pass/dimension-audit/proof.md)
- [`first-pass/pair-bound/proof.md`](first-pass/pair-bound/proof.md)
- [`first-pass/pair-bound/statement_fidelity.md`](first-pass/pair-bound/statement_fidelity.md)
- [`first-pass/dimension-audit/statement_fidelity.md`](first-pass/dimension-audit/statement_fidelity.md)
- [`first-pass/dimension-audit/certificates/statement_fidelity.md`](first-pass/dimension-audit/certificates/statement_fidelity.md)
- [`first-pass/dimension-audit/certificates/Main.lean`](first-pass/dimension-audit/certificates/Main.lean)
- [`first-pass/dimension-audit/Main.lean`](first-pass/dimension-audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
