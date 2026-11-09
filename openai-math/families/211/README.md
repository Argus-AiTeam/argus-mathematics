# 211. The geometric phase diagram, diffusion, and spectra of random planar maps.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | gr:green-bound for all rho<2/3 with p-th moments (p<3, rho<1-1/p) plus critical m^{2/3} log^beta bound | openai-math/preprints/A-Linear-Clock-for-Random-Walk-on-Tree-Weighted-Planar-Maps-October-5-2026/build/sections/06-green.tex:26-39: 'For each fixed rho in (0,1/2) ... sup E A_n < inf'; rho<1/2 is forced at :467 by a second-moment geometric sum | Exact Dyck-bridge computation of E(1+D)^{-p} * d^{p/2} for p = 2, 2.5, 2.9 (s up to 2000) stays bounded, growing like 1/(3-p) as claimed in (3.2). Checked that the scale sum sum_M h_M^{1-rho-1/p} converges iff rho < 1-1/p. |

Main files:

- [`first-pass/green_estimate/theorem.md`](first-pass/green_estimate/theorem.md)
- [`first-pass/green_estimate/Main.lean`](first-pass/green_estimate/Main.lean)
- [`first-pass/green_estimate/statement_fidelity.md`](first-pass/green_estimate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
