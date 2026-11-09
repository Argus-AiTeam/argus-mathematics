# 373. Nonattainment of the three-marginal Coulomb Monge problem.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Explicit parameters K=16, r=1e-6, delta=1e-8, beta=1e-10 for lem:local/prop:certificate; Lean selector obstruction generalized to finite families of disjoint embeddings | preprints/A-counterexample-to-the-Monge-ansatz-for-the-three-marginal-Coulomb-cost-September-25-2026/build/sections/local.tex:21 (lem:local, existential small parameters) and certificate.tex:9 (prop:certificate) | Recomputed center Hessian blocks at (0,a,-a): c=5/2, d2_xx=2D, d2_xz=-D, d2_zz=(9/8)D. Delta_d(16)=361 and 829/4, giving DX=37/361 and -59/829 as stated. The global supporting-inequality slack on the five balls was not checked |

Main files:

- [`first-pass/coulomb-contact-certificate/report.md`](first-pass/coulomb-contact-certificate/report.md)
- [`first-pass/coulomb-contact-certificate/Main.lean`](first-pass/coulomb-contact-certificate/Main.lean)
- [`first-pass/coulomb-contact-certificate/statement_fidelity.md`](first-pass/coulomb-contact-certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
