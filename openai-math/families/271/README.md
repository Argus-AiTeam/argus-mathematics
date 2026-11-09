# 271. Bloch's law, its lattice correction, and the spherical magnetization law.

**Category:** verification of the OpenAI result (no error, no improvement).

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Quantitative zero-free trace bound \|Tr K_0...K_{m-1}\| >= \|prod c_r prod M_00\| (1-1/R)^{mN}; physical trace >= c^k[2 sinh(h/2)]^{kN} | preprints/The-spherical-magnetization-law-for-the-three-dimensional-quantum-Heisenberg-ferromagnet-October-5-2026/build/sections/02-exchange.tex:390-403 (lem:trace-zero-free, qualitative "the trace of the cyclic product is nonzero"); proof :420-425 "\|D\| r_x r_y <= \|A\| ... so A+D != 0" | Random test ((check script)) of bound (1): 3000 cases, N=1..3 slots, m=1..3 layers, random admissible mean-permutation operators and slot maps with \|phi\|<1 on \|x\|<=R: min \|Tr\|/bound = 1.048 (never violated). |

Main files:

- [`first-pass/zero_free_traces/report.md`](first-pass/zero_free_traces/report.md)
- [`first-pass/zero_free_traces/Main.lean`](first-pass/zero_free_traces/Main.lean)
- [`first-pass/zero_free_traces/statement_fidelity.md`](first-pass/zero_free_traces/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
