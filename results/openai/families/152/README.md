# 152. Zero entropy does not guarantee a smooth positive-volume model.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | thm:switching measure inequality extended from smooth to C^{1,alpha} maps with continuous positive density, with factor K_k->1 instead of 2 | preprints/A-finite-entropy-system-without-a-smooth-positive-volume-model-September-25-2026/build/sections/04-switching.tex:19-39 thm:switching 'smooth diffeomorphism ... (z_k)_*(rho_k\|G_k) <= 2 nu' | Confirmed the manuscript uses second-derivative bounds (04-switching.tex:300,307). This makes C^{1,alpha} a real relaxation. The Hoelder-distortion Jacobian estimate was not independently checked. There is no Lean proof, only a scalar verify.py. |

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
