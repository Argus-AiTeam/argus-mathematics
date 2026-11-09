# 179. The circulant Hadamard and Barker-sequence conjectures.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | lem:comparison extended to order-p^r characters with FK=p^s b, s<=e-r+1; sharp via F=p-aPhi_{p^r} | preprints/The-circulant-Hadamard-conjecture-September-23-2026/build/sections/products.tex:62-73 lem:comparison 'FK=p^e b ... primitive p-th root rho'; rem:exponent :111-121 | Ran a Smith normal form of multiplication by F=p-aPhi_{p^r} on Z[C_{p^e}] for (p,r,e) = (3,1,1),(3,1,2),(3,2,2),(3,2,3),(5,2,2),(3,1,3). The p-adic valuations exactly match the predicted multiplicities (1: p^e-(p-1)m, p^t: (p-2)m, p^{t+1}: m). F(zeta)/F(1)=1/(1-a) is a non-residue-1 unit. |

Main files:

- [`first-pass/sharp_character_comparison/report.md`](first-pass/sharp_character_comparison/report.md)
- [`first-pass/sharp_character_comparison/Main.lean`](first-pass/sharp_character_comparison/Main.lean)
- [`first-pass/odd_square_audit/report.md`](first-pass/odd_square_audit/report.md)
- [`first-pass/sharp_character_comparison/statement_fidelity.md`](first-pass/sharp_character_comparison/statement_fidelity.md)
- [`first-pass/sharp_character_comparison/lattice/statement_fidelity.md`](first-pass/sharp_character_comparison/lattice/statement_fidelity.md)
- [`first-pass/odd_square_audit/statement_fidelity.md`](first-pass/odd_square_audit/statement_fidelity.md)
- [`first-pass/sharp_character_comparison/lattice/Main.lean`](first-pass/sharp_character_comparison/lattice/Main.lean)
- [`first-pass/odd_square_audit/Main.lean`](first-pass/odd_square_audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
