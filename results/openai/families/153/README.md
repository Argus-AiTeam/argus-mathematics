# 153. Arithmetic classification and non-Pisot singularity for Bernoulli convolutions.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Singularity for quartic Salem beta extended from unbiased to arbitrary independent nonstationary biased signs | preprints/Arithmetic-classification-and-non-Pisot-singularity-for-Bernoulli-convolutions-October-3-2026/build/salem.tex:10-13 sal:main 'the unbiased Bernoulli convolution nu_{1/beta} is singular' | Checked the two load-bearing new steps by hand. (i) E exp(i pi u eps) = cos(pi u) + i(2p-1)sin(pi u), whose modulus^2 is >= cos^2(pi u), so the Fourier lower bound (18) is bias-uniform. (ii) Centered windows: W/B = exp(i pi sum d_l(eps_l-mu_l)) with variance 4p(1-p)<=1, so the L2 error is unchanged. The Lebesgue side is unaffected by bias. Lean (exit 0) covers the product inequality and the variance bound. |

Main files:

- [`first-pass/salem_audit/report.md`](first-pass/salem_audit/report.md)
- [`first-pass/salem_audit/Main.lean`](first-pass/salem_audit/Main.lean)
- [`first-pass/salem_audit/statement_fidelity.md`](first-pass/salem_audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
