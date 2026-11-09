# 225. Gaussian free field limits throughout the balanced six-vertex regime.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | lem:overlap-asymptotic I_L/B -> 1/(2 lambda(pi-lambda)) for all pi/2<lambda<pi (manuscript range 2pi/3<lambda<pi) | openai-math/preprints/The-Gaussian-free-field-limit-of-the-balanced-six-vertex-model-with-variance-multiplier-1-over-arcsin-c-over-2-September-23-2026/build/sections/05-normalization.tex:3 ('0<c<1, so 2pi/3<lambda<pi') and :325-333 lem:overlap-asymptotic | Verified the Fourier identity s^/(1+K^) = 1/(2cosh(lambda p/2)) and the negativity of K^ for lambda>pi/2. The ordered-limit analysis was not checked. |

Main files:

- [`first-pass/lean/statement_fidelity.md`](first-pass/lean/statement_fidelity.md)
- [`first-pass/lean/Main.lean`](first-pass/lean/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
