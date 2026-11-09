# 359. Negative Kähler curvature without bounded holomorphic coordinates.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Explicit pinching threshold Lambda=max(1,C,1+2e+41C^2+16e^2/c,8B0^2(B0+C)/c^3) and extension to all horizontal dimensions (manuscript: existence of lambda_0 by contradiction) | preprints/A-negatively-pinched-Kahler-threefold-without-bounded-holomorphic-coordinates-September-25-2026/build/sections/09-pinching.tex:165-186 'There is a finite lambda_0=lambda_0(c,C,C_e)>0 ...' with proof by contradiction/compactness | Confirmed the baseline is a non-effective existence statement. Did not numerically test the coercive mixed-block inequality |

Main files:

- [`first-pass/certificates/hartogs_real_planes/proof.md`](first-pass/certificates/hartogs_real_planes/proof.md)
- [`first-pass/certificates/hartogs_real_planes/Main.lean`](first-pass/certificates/hartogs_real_planes/Main.lean)
- [`first-pass/certificates/hartogs_real_planes/statement_fidelity.md`](first-pass/certificates/hartogs_real_planes/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
