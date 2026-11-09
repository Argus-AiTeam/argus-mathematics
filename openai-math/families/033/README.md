# 033. Iitaka subadditivity, variation, and logarithmic additivity.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | nu(sum c_j L_j + tH)=nu(sum c_j L_j)=nu(L_0+L_1) for rational c0,c1>0, c_j>=0, t>=0 (manuscript: P=sum L_j, t=1) | openai-math/preprints/The-reverse-logarithmic-Kodaira-inequality-and-additivity-September-26-2026/build/sections/boundary-rank.tex:681-715 prop:tail-rank 'P=-sum_j det U_j ... nu(P+pi^*h^*H)=nu(P)' | Read manuscript proof (lines 740-875): it derives A^*G_i=0 for all i from Theta_P null, then uses only xG_1=0, xs=0. Checked that positive reweighting of nef classes cannot change nu (trivial part) |
| A | PLAUSIBLE | Local: ker(Theta_L0+Theta_L1)=intersection of all ker Theta_Lj on constant-rank locus | openai-math/preprints/The-reverse-logarithmic-Kodaira-inequality-and-additivity-September-26-2026/build/sections/boundary-rank.tex:762-790 eq:tail-curvature and eq:tail-zero-actions (all-tail nullity assumed) | Confirmed the curvature formula matches the manuscript; A G_i=0 follows from A ell=0 and Higgs commutativity, but the A^*G_i=0 and B_j=0 parts were not rechecked |

Main files:

- [`first-pass/higgs-tail-audit/report.md`](first-pass/higgs-tail-audit/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
