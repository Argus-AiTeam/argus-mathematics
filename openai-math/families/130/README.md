# 130. Exact Fourier transforms below $`n\log n`$.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Network h=100 -> any h>=22 (h=25): 1-theta 2.1e-13 -> 3.5e-10 | An-explicit-power-saving-for-the-exact-discrete-Fourier-transform-September-25-2026/build/sections/network.tex:25 'h=100'; introduction.tex:81 'theta=0.99999999999978935...'; network.tex:333 general 'Delta=2v^2(v-3h(h+1))>0' | Recomputed for h=100 (reproduces the manuscript's W, Delta, W*=2^71, theta) and for h=25: v=2300, deg=1606, W=58645352620000, Delta=3703000000, W*=2^46, 1-theta=3.4876e-10 (ratio about 1656x). |

Main files:

- [`first-pass/network-audit/report.md`](first-pass/network-audit/report.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
