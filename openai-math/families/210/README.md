# 210. Foulkes' conjecture for sixth powers and quadratic stabilization.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | Canonical Foulkes-Howe map surjective for b >= (a-1)^2 instead of b >= a(a-1) | openai-math/preprints/Quadratic-Stabilization-of-the-Canonical-Foulkes-Howe-Map-September-25-2026/build/paper.tex:100 thm:main 'every integer b >= a(a-1)'; prop:vanishing at :303-430 | Checked the load-bearing step. In Step 4, whole powers (x.d_{v_i})^r are applied, and sl2 injectivity D^L on weight w >= L (proved in Main.lean, exit 0, no sorry) needs only b-(i-1)r >= r, i.e. b >= r^2. The manuscript's per-operator strict-degree argument needed m >= r^2. The induction range m = b-r >= r(r-1) >= (r-1)^2 holds. Exact rank mod 32003 at below-old-threshold cases (a,b,dimV)=(3,4,3) and (4,9,2) gives full rank 680/680 and 715/715 (surjective). |

Main files:

- [`first-pass/square_stabilization/report.md`](first-pass/square_stabilization/report.md)
- [`first-pass/square_stabilization/Main.lean`](first-pass/square_stabilization/Main.lean)
- [`first-pass/square_stabilization/statement_fidelity.md`](first-pass/square_stabilization/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
