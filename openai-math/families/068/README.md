# 068. Anticanonical nonvanishing in every dimension.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Toroidal volume/positivity result for sources of locally klt type | preprints/Metric-descent-and-rank-preserving-contractions-September-26-2026/build/source/sections/toroidal-volume.tex:30 thm g:toroidal-volume (toroidal W) | Checked the decisive comparison A_{W,Theta_0}=A_{W,Delta}+v(Delta-Theta_0)>0 is valid given effective Cartier difference |
| A | CONFIRMED | Exact integrability chamber b_Q<min(lambda_Q,1) with endpoint sharpness family | same toroidal-volume.tex:30 (a_Q=max(0,min(1+a_E)/e_E-1)) | Verified lambda_Q-a_Q=min(lambda_Q,1) and coeff_E<1 <=> a_Q+b_Q<(1+a_E)/e_E |

Main files:

- [`first-pass/toroidal_volume_audit/report.md`](first-pass/toroidal_volume_audit/report.md)
- [`first-pass/toroidal_volume_audit/statement_fidelity.md`](first-pass/toroidal_volume_audit/statement_fidelity.md)
- [`first-pass/toroidal_volume_audit/Main.lean`](first-pass/toroidal_volume_audit/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
