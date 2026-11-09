# Candidate 3110: explicit finite counterexample

## Result

`confirmed_counterexample` is justified for the exact graph-theoretic statement in the supplied CSV.

The CSV proposition is:

> 设 `L` 为简单、正则、有序的二阶段图。若对某个 `m >= 1`，`L^m` 外部连通，则猜想 `L^(2m)` 可重排。

Take `m = 2` and the explicit graph `L_5` in `witness.json`. It is a simple 5-regular ordered two-stage graph, `L_5^2` is externally connected, and `L_5^4` is not rearrangeable. Thus it directly falsifies the displayed implication, without changing any quantifier or convention.

## Explicit graph

Let

```text
X = {x0,x1,x2,x3,x4}
Y = {y0,y1,y2,y3,y4}.
```

The 50 directed left-to-right edges are given explicitly in `witness.json`. Equivalently, they obey these four rules:

```text
x0 -> yj for every j
xi -> xj for every i=1,...,4 and every j
y0 -> xj for every j
yi -> yj for every i=1,...,4 and every j.
```

There is at most one edge for each ordered pair, and every vertex has indegree and outdegree 5. Labels such as `x1 -> x1` connect the left and right copies of `x1`; they are permitted edges of an ordered two-stage graph and do not violate simplicity.

The exact checker composes the adjacency relation twice and obtains all `10*10 = 100` source-target pairs. Hence `L_5^2` is externally connected. It also finds only 50 pairs in one stage, so this witness has `F(L_5) = 2`.

## Unroutable mask

For each `i=0,...,4`, request five parallel paths `xi -> yi` and five parallel paths `yi -> xi`. This is a valid 5-regular mask: every source and every target has degree 5.

The `X -> Y` half contains 25 requests. In each stage, the only base edges from `X` to `Y` are the five edges `x0 -> yj`. Therefore the four-stage network contains only `4*5 = 20` such edge slots. Every plain path starting in `X` and ending in `Y` must use at least one of them. Twenty edges cannot support 25 mutually edge-disjoint paths, so the mask is not routable and `L_5^4` is not rearrangeable.

The checker additionally enumerates all 1,360 four-stage plain paths from an `X` source to a `Y` target and confirms that none avoids an `X -> Y` edge.

## Jacobian cross-check

Jacobian has a matching typed operation, `graph.cut.minimum_st.compute`. The archived payload expands all four stages, adds a super-source with capacity 5 to each layer-0 `X` vertex, and adds capacity-5 edges from each layer-4 `Y` vertex to a super-sink. It has 52 vertices and 210 directed capacity edges.

Any routing of the 25 `X -> Y` requests would induce an integral source-sink flow of value 25 in this aggregate network. Jacobian 0.14.0 returns a minimum cut of 16. The standard-library checker independently computes the same maximum-flow/minimum-cut value and recomputes capacity 16 from Jacobian's returned 26+26 vertex partition. This layered cut is stronger than the simpler 20-edge class-crossing count; either one proves non-routability.

Artifacts:

- `witness.json`: all vertices, all 50 base edges, the full mask by multiplicity, and both certificates.
- `check_counterexample.py`: deterministic exact verifier using only the Python standard library.
- `checker-output.txt`: archived successful verifier output.
- `jacobian-mincut-input.json`: exact MCP operation payload.
- `jacobian-mincut-output.json`: full structured MCP response, including echoed payload and typed cut result.

## Reproduction

From this directory, run the independent checker and validate the archived Jacobian result:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  check_counterexample.py \
  --jacobian-output jacobian-mincut-output.json
```

Regenerate the typed payload and rerun Jacobian through the Argus MCP adapter:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  check_counterexample.py \
  --emit-jacobian-payload jacobian-mincut-input.json

ARGUS_SKILL_JACOBIAN_MCP_BIN=/home/argustest/zimo/references/jacobian/.venv/bin/jacobian-mcp \
PYTHONPATH=/home/argustest/zimo/argus-live-update \
/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.tools.jacobian run \
  --operation graph.cut.minimum_st.compute \
  --payload-file jacobian-mincut-input.json \
  > jacobian-mincut-output.json

/home/argustest/zimo/argus-latest/.venv/bin/python \
  check_counterexample.py \
  --jacobian-output jacobian-mincut-output.json
```

## Proposition and source alignment

- Candidate source row: `inputs/priority_pool.csv`, ID 3110, priority 81, marked `exact`, source grade `A`.
- Primary source: Przemek Chojecki, *Beneš and Shuffle-Exchange Counterexamples*, arXiv:2607.15296v1.
- Exact location: Section 1, Theorem 1 and proof, PDF pages 1-2. The paragraph immediately after the proof explicitly identifies the Open Problem Garden implication and takes `N >= 5` to refute it.
- Source checked: 2026-08-27 UTC.
- Primary URL: https://arxiv.org/abs/2607.15296

The paper's general family has `F(L_N)=2` and `R(L_N)>=N`. Choosing `N=5` is the smallest member of that family for which `R(L_N)>4=2F(L_N)`. This package independently verifies only what candidate 3110 needs: `L_5^2` externally connected and one valid mask not routable in `L_5^4`. It does not determine the exact value of `R(L_5)` or claim global minimality among all possible graphs.

## Tool revisions

- Jacobian: `7df85cac75e3a249cb69c6bae685c42b75a31390` (reported server version 0.14.0).
- Argus pinned research checkout: `33da786bbc6787a2eeb63a5f492498eae87c78c7`.
- Argus MCP adapter checkout used for the sidecar bridge: `0c62099d1d9511f2fc3ec00f51c0d4cfe8f8e890`.
