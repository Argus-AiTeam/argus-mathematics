# 364. Kinetic limits and fluctuations over the Boltzmann lifespan.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Proof of exp:exposure plus power-complexity extension: p,J up to eps^{-eta} with bound A_p eps^{dp} (manuscript p<=P^a polylog) | preprints/The-Boltzmann-Grad-limit-for-stable-radial-potentials-on-regular-kinetic-intervals-September-23-2026/build/sections/05-exposure.tex:448-457 'p<=P^a labels ... bounded by A_p (pJ)^{Cp}(p^C eps^c)^{k/2}' | Checked the scalar inequality (13): with eta=alpha/(800(3B+1)), (2B+alpha B/2)eta - alpha/200 <= -3alpha/800. The deep part, uniformity of (12) in p up to eps^{-eta}, was not checked |

Main files:

- [`first-pass/audits/causal-exposure/report.md`](first-pass/audits/causal-exposure/report.md)
- [`first-pass/audits/causal-exposure/lean/Main.lean`](first-pass/audits/causal-exposure/lean/Main.lean)
- [`first-pass/audits/causal-exposure/Main.lean`](first-pass/audits/causal-exposure/Main.lean)
- [`first-pass/audits/causal-exposure/statement_fidelity.md`](first-pass/audits/causal-exposure/statement_fidelity.md)
- [`first-pass/audits/causal-exposure/lean/statement_fidelity.md`](first-pass/audits/causal-exposure/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
