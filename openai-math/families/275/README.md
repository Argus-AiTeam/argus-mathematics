# 275. QMA-hardness of continuum Coulomb energy.

**Result:** improvement over the stated OpenAI result.

| Kind | Verdict | Claim | OpenAI baseline | Check |
| :--- | :--- | :--- | :--- | :--- |
| A | PLAUSIBLE | prop:nuclear-replacement first bound improved lambda^{-2/3} -> lambda^{-1} for all H^1 u; complement loss lambda^{-4/3} -> lambda^{-9/5} (conditional) | preprints/QMA-hardness-of-continuum-Coulomb-energy-with-unit-nuclear-charges-September-24-2026/build/sections/nuclei.tex:71-80 "\|<u,(L_p-L_c)u>\| <= p(n,D) lambda^{-2/3}(\|\|u\|\|^2+\|\|grad u\|\|^2); \|\|P(L_p-L_c)P\|\|_P <= p(n,D) lambda^{-4/3}" | Heuristic re-derivation: with node mass 1/lambda ~ h^3, writing each point-minus-smeared charge potential as the divergence of a vector field bounded by C h^3 near the node and decaying ~h^7/r^4, bounded-overlap summation gives \|form\| <= C h^3 \|\|u\|\| \|\|grad u\|\|, i.e. lambda^{-1}; manuscript's absolute-potential route only gives h^2. |

Main files:

- [`first-pass/unit_charge_replacement/proof.md`](first-pass/unit_charge_replacement/proof.md)
- [`first-pass/unit_charge_replacement/lean/Main.lean`](first-pass/unit_charge_replacement/lean/Main.lean)
- [`first-pass/unit_charge_replacement/Main.lean`](first-pass/unit_charge_replacement/Main.lean)
- [`first-pass/unit_charge_replacement/statement_fidelity.md`](first-pass/unit_charge_replacement/statement_fidelity.md)
- [`first-pass/unit_charge_replacement/lean/statement_fidelity.md`](first-pass/unit_charge_replacement/lean/statement_fidelity.md)

- `first-pass/`: Argus first-pass drafts (proof graph `MATH_STATE.json`, reports, Lean, verifiers).

`refutes` records in these files refute statements proposed by Argus itself (shortcuts, extensions, tests), not statements of the OpenAI manuscript.
