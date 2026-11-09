# 261. Localization and delocalization in the Anderson model.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | lem:leverage-drift extended from scalar ridge tau to PD Hermitian ridge Lambda with S_B^* conj(Lambda) S_B <= Lambda, via dimension-free stochastic row-deletion theorem | preprints/Absolutely-Continuous-Spectrum-for-Weak-Disorder-Anderson-Models-in-Dimensions-at-Least-Three-September-23-2026/build/06-clearing.tex:391-418 (lem:leverage-drift, scalar ridge tau, V_tau=tau G_tau^{-1}) | Numerical check ((check script)), 3000 random symmetric unitaries S=UU^T: identity S_B^* conj(Gamma) S_B = Gamma-Gamma^2 holds to 1e-15, and for balanced nonscalar Lambda the key unitary-cancellation bound \|\|U^* S_Rx\|\|^2 <= m_x holds (max ratio 0.989). |

Main files:

- [`first-pass/ac-clearing-drift/report.md`](first-pass/ac-clearing-drift/report.md)
- [`first-pass/ac-clearing-drift/Main.lean`](first-pass/ac-clearing-drift/Main.lean)
- [`first-pass/ac-clearing-drift/statement_fidelity.md`](first-pass/ac-clearing-drift/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
