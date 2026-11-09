# 087. The Mahler conjectures, functional inequalities and polar-product symplectic width.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Re F'>=2/pi on the disk, explicit eps_k in \|J_k\|/k<=(pi/4)\|g\|^{2k}+eps_k, pi/4 optimal | preprints/Symplectic-Balls-in-Symmetric-Polar-Products-September-22-2026/build/sections/planar.tex:152 prop:uniform-slice (qualitative eps_k->0). NOTE: input openai_ref (Mahler lens.tex:22 lem:planar-lens) is only the map definition, not the baseline | Monte Carlo 2e6 points + boundary sweep: min Re F'(z)=0.63662 -> 2/pi approached at \|z\|=1 |

Main files:

- [`first-pass/uniform_slice/REPORT.md`](first-pass/uniform_slice/REPORT.md)
- [`first-pass/uniform_slice/statement_fidelity.md`](first-pass/uniform_slice/statement_fidelity.md)
- [`first-pass/uniform_slice/Main.lean`](first-pass/uniform_slice/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
