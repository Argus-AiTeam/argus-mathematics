# 262. Sharp finite-matrix Lieb–Thirring inequalities and all equality cases.

**Category:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | CONFIRMED | thm:trace deficit extended to gapless PSD symbols and without N>=0; N converges iff sigma>(m-1)/(2m), sharp via nilpotent Jordan blocks; exact asymptotic constant | preprints/Sharp-one-dimensional-Lieb-Thirring-inequalities-for-matrix-potentials-October-5-2026/build/sections/trace.tex:25-45 (thm:trace: assumes X_s=(sI-B)^2+V >= bI, b>0, and N>=0; concludes tr(NV) >= tr(N^q)) | Numerics ((check script), jordan2.py): for Jordan blocks n=2,3, t^{1-1/(2n)}R(t)_{11} -> 0.7071, 0.6667 = (1/n)csc(pi/(2n)) as claimed; for gapless n=2 example (V=diag(-1/4,3/4), sigma=1/2) computed N numerically: N indefinite (eigs +-0.785), tr(NV)=0.785 >= tr(N_+^3)=0.484, consistent with the extended inequality. |

Main files:

- [`first-pass/trace_deficit_audit/report.md`](first-pass/trace_deficit_audit/report.md)
- [`first-pass/trace_deficit_audit/lean/checks/unattached/Main.lean`](first-pass/trace_deficit_audit/lean/checks/unattached/Main.lean)
- [`first-pass/trace_deficit_audit/lean/Main.lean`](first-pass/trace_deficit_audit/lean/Main.lean)
- [`first-pass/trace_deficit_audit/lean/statement_fidelity.md`](first-pass/trace_deficit_audit/lean/statement_fidelity.md)
- [`first-pass/trace_deficit_audit/lean/checks/unattached/statement_fidelity.md`](first-pass/trace_deficit_audit/lean/checks/unattached/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
