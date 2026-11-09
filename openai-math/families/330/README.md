# 330. A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Explicit forest-coupling error c_r^2/(N-c_r) and adaptive transfer bound replacing qualitative lem:local-limit / lem:rare-walks | Lipschitz-free BAP manuscript (Sept 26) blocks.tex lem:local-limit, walks.tex lem:rare-walks (qualitative) | Read the exploration bound: at most c_r=2(1+dU_r) discovered vertices, so the collision probability is <= c_r^2/(N-c_r), a standard permutation-model estimate. The baseline file was not located by grep (the manuscript directory name was not found); baseline taken from the report. |

Main files:

- [`first-pass/signed_continuation/Main.lean`](first-pass/signed_continuation/Main.lean)
- [`first-pass/adaptive_support/report.md`](first-pass/adaptive_support/report.md)
- [`first-pass/adaptive_support/Main.lean`](first-pass/adaptive_support/Main.lean)
- [`first-pass/signed_continuation/report.md`](first-pass/signed_continuation/report.md)
- [`first-pass/adaptive_support/statement_fidelity.md`](first-pass/adaptive_support/statement_fidelity.md)
- [`first-pass/signed_continuation/statement_fidelity.md`](first-pass/signed_continuation/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
