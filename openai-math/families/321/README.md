# 321. A counterexample to Wall's finite D(2) problem.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Exact relation gap one for explicit balanced presentations G5,G6 (d_F(R)=n, d_ZG(R_ab)=n-1, Def=0) | A-Counterexample-to-Walls-D2-Problem-October-6-2026/build/sections/01-introduction.tex:63-70 (relation gaps discussed only as background; no relation-gap theorem stated) | Confirmed that the manuscript states no relation-gap result. Read the theorem statement. The lower bound d_F(R)=n, derived from the manuscript's D(2)/torsion obstruction, was not re-derived. |
| A | PLAUSIBLE | Tower theorem extended from rank-one characters to finite-rank local systems; second D(2) example invisible to rank-one characters | A-Counterexample-to-Walls-D2-Problem-October-6-2026/build/sections/02-tower.tex (rank-one character obstruction, eq:obstruction-overview) | Baseline confirmed (rank-one only). The extension proof was not checked. The Lean certificate covers only a Fox-torsion core. |

Main files:

- [`first-pass/torsion_fox_certificate/Main.lean`](first-pass/torsion_fox_certificate/Main.lean)
- [`first-pass/wall_d2_audit/report.md`](first-pass/wall_d2_audit/report.md)
- [`first-pass/relation_gap/theorem.md`](first-pass/relation_gap/theorem.md)
- [`first-pass/torsion_fox_certificate/proof.md`](first-pass/torsion_fox_certificate/proof.md)
- [`first-pass/integral_plus_certificate/Main.lean`](first-pass/integral_plus_certificate/Main.lean)
- [`first-pass/integral_plus_certificate/proof.md`](first-pass/integral_plus_certificate/proof.md)
- [`first-pass/torsion_fox_certificate/statement_fidelity.md`](first-pass/torsion_fox_certificate/statement_fidelity.md)
- [`first-pass/integral_plus_certificate/statement_fidelity.md`](first-pass/integral_plus_certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
