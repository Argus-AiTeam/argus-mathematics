# 086. An <i>L</i><sup>3</sup> bound for the trilinear Hilbert transform.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | lem:finite-sparse-count exponent delta^{1/2080} -> delta^{1/810} | preprints/An-L3-bound-for-the-trilinear-Hilbert-transform-October-5-2026/build/sections/counting.tex:393 'C l L^29 delta^{1/2080} M^2'; :797 choice alpha=delta^{1/1040}, kappa=alpha^2 | Re-optimized the manuscript's own displayed bound C(L kappa/alpha + sqrt(L alpha) + l L^29 alpha^-4 kappa^-24 delta^{1/10}) (counting.tex:787-794): alpha=x^2,kappa=x^3,delta=x^810 balances to exponent 1/810, which is optimal for that expression |

Main files:

- [`first-pass/frequency_tests/proof.md`](first-pass/frequency_tests/proof.md)
- [`first-pass/sparse_count/proof.md`](first-pass/sparse_count/proof.md)
- [`first-pass/sparse_count/Main.lean`](first-pass/sparse_count/Main.lean)
- [`first-pass/sparse_count/statement_fidelity.md`](first-pass/sparse_count/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
