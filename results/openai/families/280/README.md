# 280. Unitary vertex operator algebras and conformal nets.

**Result:** independent confirmation.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | DOWNGRADED | Energy-to-locality extended from strongly rational to simple unitary CFT-type C2-cofinite VOAs; explicit cutoff c_b=sum(d_i-1) | preprints/Strongly-rational-unitary-vertex-operator-algebras-and-conformal-nets-September-25-2026/build/02-energy.tex:11-24 (thm:energy for "simple unitary strongly rational" V), :561-563 (cor:locality); the only analytic input :184-188 is Zhu's one-point convergence, whose "Condition C holds here: besides C_2-cofiniteness ... spanning by Virasoro descendants of primary vectors follows from unitarity" | Grepped the section for every use of rationality; read Argus scope and the replacement of Zhu by Dong-Li-Mason Thm 3(i). |

Main files:

- [`first-pass/energy-bootstrap/report.md`](first-pass/energy-bootstrap/report.md)
- [`first-pass/energy-bootstrap/Main.lean`](first-pass/energy-bootstrap/Main.lean)
- [`first-pass/energy-bootstrap/statement_fidelity.md`](first-pass/energy-bootstrap/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
