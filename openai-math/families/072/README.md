# 072. Brennan's conjecture and the integral-means spectrum.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Affine transport/law/escape/pairing chain for general p | preprints/Brennans-conjecture-and-sharp-inverse-square-integral-means-September-24-2026 and A-strict-inverse-first-power-bound-for-univalent-functions-September-24-2026 Sections 2-5 (p=2, p=1) | Read review summary only |
| A | PLAUSIBLE | Zero-Jacobian rigidity for all k>0; k=1 classified as affine/quadratic F_t | preprints/A-strict-inverse-first-power-bound-for-univalent-functions-September-24-2026/build/sections/06-equality-barrier.tex:8 lem:no-zero-J (k=3/4) | Symbolically checked converse: for F_t, q=-iy/(z-t) gives Re q+\|q\|^2=0 so J=0 at k=1 |
| A | PLAUSIBLE | Explicit critical Cauchy-quadratic law and uniqueness on the rigid locus | same manuscripts (inverse-square affine law) | Read review summary only |

Main files:

- [`first-pass/affine_transport/report.md`](first-pass/affine_transport/report.md)
- [`first-pass/affine_transport/Main.lean`](first-pass/affine_transport/Main.lean)
- [`first-pass/affine_transport/statement_fidelity.md`](first-pass/affine_transport/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).
- `argus-review/`: Argus second-pass review (`OLD_ROUND_REVIEW.md`, per-unit reports and verdicts).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
