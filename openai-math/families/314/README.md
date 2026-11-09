# 314. Cyclic length and chromatic fixed-point loss.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Effective congruence D_d c_h == p^{bd} mod p^{h-b+1}, v_p(c_h)=bd for h>=b(d+1), replacing qualitative nonzero-limit contradiction | Cyclic-Length-and-Chromatic-Fixed-Point-Loss-September-24-2026/build/sections/05-profinite.tex:8 thm:procyclic, :219 lem:kernel-abelianization, :272 eq:graph-subgroup-count (qualitative limit argument) | Python check ((check script)): D_d a_j(d) == 1 mod p^{j+1} for p=2,3, d=1..3, j<6. Congruence (4) and v_p(c_h)=bd for h>=b(d+1) hold for cyclic abelianization b=1,2, with s_i from Sur(Z_p^d,C_{p^i}) summing to p^{bd}. Goursat bijection (1) read and correct. Lean exit 0. |

Main files:

- [`first-pass/profinite_rigidity/report.md`](first-pass/profinite_rigidity/report.md)
- [`first-pass/profinite_rigidity/Main.lean`](first-pass/profinite_rigidity/Main.lean)
- [`first-pass/profinite_rigidity/statement_fidelity.md`](first-pass/profinite_rigidity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
