# 188. The sharp terminal leave in random triangle removal.

**Result:** nothing substantive.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | prop:collision bound O(D^{-35}+n^{-1}) -> O(k^2(D^{-40}+n^{-1})) for any number of roots | preprints/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/witnesses.tex:342-355 prop:collision 'k in {1,2} ... O(D^{15-B}+n^{-1})=O(D^{-35}+n^{-1})=o(D^{-1})' | Read the manuscript proof (D^{-B}C_D^3 exp(24D mu) with C_D=1+2D, B=50) and Argus's change to C_D^2 |

Main files:

- [`first-pass/collision_certificate/report.md`](first-pass/collision_certificate/report.md)
- [`first-pass/collision_certificate/Main.lean`](first-pass/collision_certificate/Main.lean)
- [`first-pass/collision_certificate/statement_fidelity.md`](first-pass/collision_certificate/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
