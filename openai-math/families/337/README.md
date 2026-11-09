# 337. Sharp Cartan–Hadamard isoperimetry and rigidity.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | thm:extrinsic-sobolev extended from hypersurfaces to C^{1,1} immersions of arbitrary codimension with \|H\|^2 (mean curvature vector) | preprints/Generalized-Cartan-Hadamard-isoperimetry-and-Euclidean-equality-rigidity-September-23-2026/build/sections/03-sobolev.tex:9-40: hypersurface Sigma^m in M^n with m=n-1>=3, Q(v)=int(c\|grad v\|^2+m(h^2-b^2)v^2) >= Y_m \|\|v\|\|_q^2, Y_m=m s_m^{2/m} | Hand-verified the load-bearing square (sec.4, eq.9-10): traced Hess u bound with tangent/normal split beta=(grad u)^perp gives m(\|H\|^2-b^2) >= mf^2+m\|H+beta\|^2+(m-2)\|grad_Sigma u\|^2+2 Delta u exactly. Checked that the balancing (sec.3) and Hersch-type argument (sec.6) use n+1 coordinates with no codimension-one input |

Main files:

- [`first-pass/lean/statement_fidelity.md`](first-pass/lean/statement_fidelity.md)
- [`first-pass/lean/Main.lean`](first-pass/lean/Main.lean)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
