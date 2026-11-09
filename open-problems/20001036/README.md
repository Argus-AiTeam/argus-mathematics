# Result 20001036

## A 5,454-vertex multi-label counterexample to Seymour--Sullivan Conjecture 6.1 and prototype optimality

**Status:** independently verified computational counterexample with exact LP/ILP prototype optimality certificate<br>
**Resolved scope:** positive-length reachability, unordered injective label sequences, and arcs carrying overlapping label subsets<br>
**Field:** directed graphs, rainbow paths, and combinatorial optimization<br>
**Novelty:** not independently certified

Under the source-aligned formulation of Sullivan's Conjecture 6.1 where a simple directed graph may carry multiple labels from $\{1,\ldots,k\}$ on each directed arc (`G_i = (V, E_i)`), $D(v) = \sum_{i=1}^k d^+_{G_i}(v)$ counts outgoing label incidences, and $R(v)$ denotes the set of vertices reachable from $v$ by a nonempty rainbow directed path (under unordered injective label sequences), Argus constructed an explicit 16-vertex prototype and a positive-integer independent-set blow-up (`copies-6000.json` / `full-certificate.construction.json`) materializing a directed graph with:

- **5,454 vertices** and **11,792,572 directed arcs** (`273,052,739` reachable state pairs);
- **no rainbow directed cycle** (no vertex has a positive-length rainbow walk returning to itself);
- **$D(v) - |R(v)| \ge 1$ at every vertex $v$** (minimum deficit across all 5,454 vertices is exactly $1$).
- **Exact LP and integer prototype optimality ($5{,}454$):** the nonnegative integer dual multipliers
  $y = (492,159,45,15,5,0,715,0,694,0,0,738,0,0,0,692)$ and $z = (0,0,0,0,0,0,1207,0,0,0,0,0,0,0,692,0)$
  satisfy $A^{\mathsf T}y + z = \mathbf{1}$ with $\sum_u y_u + \sum_v z_v = 3555 + 1899 = 5454$, proving that $\sum_{v=0}^{15} m_v \ge 5454$ for every real or integer blow-up vector $m \ge \mathbf{1}$ with $A m \ge \mathbf{1}$ (integrality gap $0$), independently checked via `verify_optimality.py`, Jacobian `matrix.farkas_certificate.check`, and `smt.solve` (`UNSAT` at $\le 5453$).

In addition, `rainbow_boundaries.md` records exhaustive finite exclusions for all digon-free patterns with $n\le4, k\le3$ ($34{,}012{,}224$ patterns at $n=4$) and exact nonnegative integer Farkas dual certificates excluding all $1{,}854$ coefficient systems ($27{,}702$ retained templates) under independent-set blow-ups of $n\le4$ templates.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_20001036_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `counterexample.md` | Full mathematical specification, blow-up projection proof, and deficit analysis |
| `rainbow_boundaries.md` | Exhaustive $n\le4, k\le3$ enumeration and 1,854 Farkas dual blow-up exclusions |
| `full-certificate.construction.json` | 16-vertex prototype, palettes, and positive integer copy multiplicities |
| `copies-6000.json` | Exact integer copy vector and per-type deficit certificate |
| `optimality-certificate.json` | Exact primal-dual integer optimality certificate (`optimal_vertices=5454`) |
| `verify_optimality.py` | Standalone verifier for primal feasibility and dual stationarity $A^{\mathsf T}y+z=\mathbf{1}$ |
| `jacobian-farkas-optimality-5453-payload.json` | Jacobian Farkas infeasibility payload for $\sum m_v \le 5453$ |
| `jacobian-farkas-optimality-5453-output.json` | Jacobian Farkas verification output (`valid=true, y_t_b=-1`) |
| `jacobian-integer-5453-payload.json` | Jacobian QF_LIA SMT payload for $\sum m_v \le 5453$ |
| `jacobian-integer-5453-output.json` | Jacobian QF_LIA SMT output (`UNSAT`) |
| `materialize.py` | Deterministic generator reconstructing the 5,454-vertex, 11,792,572-arc graph |
| `replay_entrypoint.py` | End-to-end materialization and strict verification entrypoint |
| `baseline_verifier.py` | Reference state-transition verifier |
| `full-certificate.verification.json` | Verification receipt (`VERIFIED_COUNTEREXAMPLE`, 5,454 vertices) |
| `reviewer-strict-replay.json` | Independent Reviewer strict replay summary |
| `reviewer-exact-copy-replay.json` | Independent Reviewer composition of all 1,956 positive injective label words |
| `reviewer-materialization-audit.json` | Streaming audit of the materialized graph |
| `jacobian-integer-6000-payload.json` | Jacobian SMT integer feasibility payload |
| `jacobian-integer-6000-output.json` | Jacobian SMT verified integer model |
| `rainbow.py` | Exact bitmask state-reachability solver |
| `verify_rainbow_certificate.py` | Standalone predecessor/transition certificate checker |
| `enumerate_rainbow.cpp` | Exhaustive $n\le4, k\le3$ C++ enumerator |
| `verify_coalescing.py` | Standalone integer dual verifier for the 27,702 $n\le4$ templates |
| `verification-summary.json` | Structured verification summary |
