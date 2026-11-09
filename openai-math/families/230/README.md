# 230. Exact Hausdorff gauges for SLE.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | Mesh tail extended to all bounded simply connected locally-connected-boundary domains with arbitrary marked prime ends; simultaneous-in-mesh envelope for 4<kappa<8 | openai-math/preprints/An-explicit-exact-Hausdorff-gauge-for-SLE-September-26-2026/build/sections/mesh-tails.tex:75-88 mesh:tail (the input's citation of the Sept-25 mass.tex is the wrong file; the report targets this Sept-26 proposition) | Baseline located and confirmed. The long prose proof was not checked. |

Main files:

- [`first-pass/mesh-tail-audit/report.md`](first-pass/mesh-tail-audit/report.md)
- [`first-pass/mesh-tail-audit/Main.lean`](first-pass/mesh-tail-audit/Main.lean)
- [`first-pass/mesh-tail-audit/statement_fidelity.md`](first-pass/mesh-tail-audit/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
