# 047. Zariski cancellation and affine fibrations over the complex numbers.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:rigidity (m=3, e<=0, k=C) generalized to odd m>=3, any char-0 k, lower-auxiliary perturbations P, shift e<2; threshold 2 sharp | openai-math/preprints/An-explicit-failure-of-complex-affine-space-cancellation-September-23-2026/build/sections/06-rigidity.tex:3-6 prop:rigidity 'no nonzero locally nilpotent k-derivation E of R_t with a fixed fiber shift e<=0 and E^2(v)=0' (auxiliary degrees 0,3,-3,0,2) | Checked Mason-Stothers step: D^2+A^2U^m of degree <=1 with coprimality gives 2d_D<=d_D+d_A+d_U and 2d_A+m d_U<=d_D+d_A+d_U, hence (m-2)d_U<=0. Lean rigidity Main.lean exit 0, no sorry (m=3 core only). |

Main files:

- [`first-pass/rigidity/report.md`](first-pass/rigidity/report.md)
- [`first-pass/rigidity/Main.lean`](first-pass/rigidity/Main.lean)
- [`first-pass/rigidity/statement_fidelity.md`](first-pass/rigidity/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
