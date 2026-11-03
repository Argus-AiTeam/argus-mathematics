# Batch 001 First Tranche

Completion date: 2026-08-27 UTC.

Argus revision used: `33da786bbc6787a2eeb63a5f492498eae87c78c7` as pinned in `OBJECTIVE.md`; validation used `/home/argustest/zimo/argus-latest/.venv/bin/python`.

Jacobian revision used: `7df85cac75e3a249cb69c6bae685c42b75a31390` as pinned in `OBJECTIVE.md`; command probe used `/home/argustest/zimo/references/jacobian/.venv/bin/jacobian --help`.

## Accepted Results

This tranche materializes 8 accepted rows in `outputs/results.csv`: seven source-theorem refutations and one explicit confirmed counterexample.

- `20000255`: Totaro gives terminal 3-fold singularities that are not Cohen-Macaulay. Accepted only for the Cohen-Macaulay branch; rationality remains separate.
- `20000256`: Cascini-Tanaka give a characteristic-two Q-factorial three-dimensional plt pair `(Z,E)` with non-normal prime divisor `E`.
- `20000332`: Wang-Xu give families, including smooth hypersurfaces in `P^3` of large degree, whose Chow semistable pluricanonical limits do not stabilize.
- `20000443`: Ax gives a cohomological-dimension-one field and a degree-five form in 10 variables with no nontrivial zero. An exact resultant check makes the associated hypersurface in `P^9` smooth; adjunction and Campana's Fano theorem make it rationally connected.
- `20000472`: Looi gives a measurable Fock-space Toeplitz symbol with bounded operator and unbounded heat transform at `t=1/4`.
- `20000496`: de Dios Pont gives smooth centrally symmetric convex domains in sufficiently high dimensions with interior hot spots.
- `20000731`: Vlasenko-Zwegers give counterexamples to Nahm Conjecture 4.1: modular functions exist although the torsion condition fails.
- `20000778`: Krah gives a rational surface, the blow-up of `P^2_C` at 10 general points, with a universal phantom subcategory.

## Rejected Near-Misses

`outputs/rejected.csv` records 3 rejected rows:

- `1900020`: Jacobi-Perron periodicity evidence is heuristic, partial, or numerical and does not provide a proved explicit nonperiodic witness for the exact universal statement.
- `9400114`: the AIM note gives a conditional Lenstra proposition and heuristic expectation, but no concrete coprime `n,r` witness meeting the objective's evidence bar.
- `20000364`: the Massarenti source concerns higher-dimensional quartic hypersurfaces and singular quartic threefolds, not smooth surfaces `X_d` in `P^3_k`.

## Jacobian Operations

One exact Jacobian operation was used for `20000443`: `polynomial.multivariate.resultant.compute`. With `f(z)=(z^2-s)(z^3+s)`, it returned `Res_z(f,f')=-108 s^7(s-1)^2`, proving the binary quintic is squarefree over the relevant function field and grounding the hypersurface smoothness argument. The exact payload and typed output are in `evidence/20000443/`.

The pinned Argus checkout did not contain the advertised `argus_skill.tools.jacobian` adapter module; the failed adapter command and error are recorded in `evidence/20000443/adapter-status.json`. The bounded operation was therefore run through the operator-pinned Jacobian 0.14.0 CLI after catalog discovery and contract inspection.

For `20000472`, the installed catalog was searched for Toeplitz, Fock, Bargmann-Fock, heat-transform, and Bargmann operations; no applicable operation was present. Catalog and operation inspection used:

```bash
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian --help
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian catalog
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian inspect polynomial.multivariate.resultant.compute
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian run polynomial.multivariate.resultant.compute --file evidence/20000443/jacobian-request.json
```

## Reproducibility Commands

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python scripts/validate_outputs.py
/home/argustest/zimo/argus-latest/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root /home/argustest/zimo/counterexample-batch-1
/home/argustest/zimo/argus-latest/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root /home/argustest/zimo/counterexample-batch-1
/home/argustest/zimo/argus-latest/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check gap --project-root /home/argustest/zimo/counterexample-batch-1
```

## Remaining Risks

- These rows are source-theorem refutations, not independently formalized proofs.
- Reviewer still needs to check exact proposition alignment for each accepted subclaim and limitation.
- The full `OBJECTIVE.md` target is 20 accepted rows unless the priority pool is exhausted; this bounded node deliberately reports the honest smaller count of 8 accepted rows.
