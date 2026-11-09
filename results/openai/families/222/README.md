# 222. Perceptron free energies and microscopic jamming exponents.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Friedrichs eigenvalue enclosures narrowed to width 1e-10 (vs 2e-9) | openai-math/preprints/Microscopic-jamming-in-the-negative-spherical-perceptron-September-24-2026/build/main.tex:9200-9204 cert:lambda-window (lam ± 10)/1e10 | Compared the margins. Only lambda(a_-) > a_- = 0.2936533 and lambda(a_+) < a_+ = 0.2936535 are used, and the margin is about 2e-7, far larger than the manuscript's 2e-9 window. |

Main files:

- [`first-pass/jamming_spectral/report.md`](first-pass/jamming_spectral/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
