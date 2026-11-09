# 304. The Hilbert–Smith conjecture in every dimension.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | thm:bounded-comparison exponent e_j=3(9^j-1)/4 improved to j via natural two-sided 2^j-transfer | The-Hilbert-Smith-conjecture-in-every-finite-dimension-September-23-2026/build/sections/04-lattice.tex:126-136 thm:bounded-comparison (existential e_j) and :193-205 remark lat:exponent-bookkeeping e_j=9e_{j-1}+6=3(9^j-1)/4, "without optimizing", "Only existence ... will be used" | Checked the algebraic identity (2): with g iA=iB f, dB g=f dA, iA dA=2, iB dB=2, ft=tf=q, T=iA t dB gives gT=Tg=2q (by hand; also Lean). The geometric identifications (3) and naturality of the doubling reverse map were read but not checked. |

Main files:

- [`first-pass/generated_excision_audit/proof.md`](first-pass/generated_excision_audit/proof.md)
- [`first-pass/generated_excision_audit/Main.lean`](first-pass/generated_excision_audit/Main.lean)
- [`first-pass/generated_excision_audit/statement_fidelity.md`](first-pass/generated_excision_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
