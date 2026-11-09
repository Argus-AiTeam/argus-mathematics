# Endpoint-incidence cover and the exact obstruction to dropping cut compatibility

This is a structural reduction and a classification of a **relaxation**, not
the requested sharp eleven-point distortion theorem. The strongest verified
configuration remains `115/106`. The global lower bound is still missing.

## A complete cover by 66 endpoint graphs

In each of the five coordinates choose two distinct labels attaining the
minimum and maximum. If the coordinate is constant, choose any two distinct
labels. Record these pairs as the edges of a loopless multigraph on the eleven
labels. Parallel edges are allowed. There are exactly five edges, hence at
most ten nonisolated vertices.

Relabeling points gives graph isomorphism; permuting coordinates permutes
edges; reflecting a coordinate reverses its chosen endpoint pair. These
operations preserve all l1 distances. Thus one representative of every
unlabeled loopless five-edge multigraph, padded with isolated vertices to
eleven labels, covers all configurations.

`endpoint_chain_cover.py` enumerates **66** representatives. It starts with
the empty graph and adds an edge between two old vertices, an old and a new
vertex, or two new vertices. Every graph with one more edge is obtained this
way by deleting its last edge and temporarily deleting newly isolated
vertices. Exact canonicalization of each connected component removes only
isomorphic graphs. The successive numbers are `1, 1, 3, 8, 23, 66`.

The separate implementation `check_endpoint_chain_cover.py` does not import
that generator or its canonicalizer. It enumerates all **43,833** set
partitions of the ten ordered endpoint slots in which the two slots of each
edge differ. Its backtracking adjacency-preserving bijections check that
every partition matches exactly one representative, and that no two
representatives are isomorphic. This is an exhaustive combinatorial cover,
not sampling of coordinate orders.

Tied extrema are harmless because an attaining label can be chosen
arbitrarily. Constant coordinates have no positive gaps and are included by
the endpoint convention above.

## What remains inside each case: positive cuts must be a chain

Fix an edge `(a_j,b_j)` and orient it from coordinate minimum to maximum.
For every subset `S` containing `a_j` but not `b_j`, introduce a nonnegative
weight `w[j,S]`. Write `delta_S(i,k)` for the indicator that `S` separates
labels `i,k`. The distances are

```
d(i,k) = sum_{j,S} w[j,S] delta_S(i,k).
```

The **necessary and sufficient support condition** for these prescribed
coordinate cut families to be coordinate-gap families is that, separately
for each `j`, the sets with positive weight form a chain under inclusion.
An aggregate metric with a non-chain representation could have a different
line representation; rejection here concerns the prescribed supports, not
every possible decomposition of that metric.

For necessity, sort a real coordinate and take its prefix cuts at positive
gaps. Every such cut separates the chosen minimum and maximum, and these
prefixes are nested. Ties give zero gaps.

For sufficiency, define

```
x[i,j] = sum_{S: i not in S} w[j,S].
```

The sets containing a fixed label form a terminal segment of the chain.
For any two labels, the cuts containing exactly one label therefore all
have the same orientation. Consequently

```
abs(x[i,j]-x[k,j]) = sum_S w[j,S] delta_S(i,k).
```

Also `x[a_j,j]=0` and `x[b_j,j]=sum_S w[j,S]`. Zero weights impose no
nesting condition; an empty support gives a constant coordinate.
Thus this representation is exact, with no generic-position assumption.
The checker reconstructs the recorded rational witness and synthetic tied
and constant coordinates, accepts zero-weight incomparable cuts, and rejects
positive incompatible supports.

This replaces a huge permutation index with 66 endpoint cases, but does
**not** replace the ordering problem with 66 LPs. Dropping the chain
condition makes the live cases useless for any positive distortion gap.

## Complete classification of the endpoint-only cut relaxation

Here the chain condition is deliberately dropped. A cut need only separate
the endpoints of some coordinate to which it is assigned. Let `k` be the
number of nonisolated vertices of the endpoint graph. The exact relaxed
optima, normalized by minimum distance one, are

| Endpoint labels | Cases | Exact relaxed optimum |
|---|---:|---:|
| `k=2` | 1 | `2` |
| `k=3` | 4 | `26/21` |
| `k>=4` | 61 | `1` |

These are optima of the relaxation, not the original five-coordinate problem.

### Two endpoint labels

All five edges have the same endpoints `a,b`. Each allowed cut separates
them, so for every other label `u`,

```
d(a,u)+d(u,b)=d(a,b).
```

The left side is at least two; hence `D>=2`.
For attainment, take every cut containing `a`, excluding `b`, and containing
an arbitrary subset of the other nine labels, each with weight `1/256`.
The 512 cuts give `d(a,b)=2` and every other distance one.

### Three endpoint labels

Let `A` be the three endpoint labels and `B` the other eight. Every positive
cut splits `A`, since it separates some endpoint edge. Complement it if
necessary so that it contains exactly one label of `A`; let `h` be the
number of labels of `B` on that side. The cut separates respectively

```
2, 8+h, h(8-h)
```

pairs inside `A`, between `A` and `B`, and inside `B`.
For the integer `0<=h<=8`,

```
(8+h)+h(8-h) <= 28 = 14*2,
```

because `(h-4)(h-5)>=0`. Sum this cut inequality with its nonnegative
weights:

```
sum_{A,B} d + sum_{pairs in B} d <= 14 sum_{pairs in A} d.
```

The left side is at least `24+28=52`; the right side is at most `42D`.
Therefore `D>=26/21`. This argument retains every coordinate order, tie,
and zero gap.

For attainment in the relaxation, use all cuts with one label of `A` and
four labels of `B`, each of weight `1/1470`, together with all cuts with
one label of `A` and five labels of `B`, each of weight `1/98`. Assign
each cut to an endpoint edge incident with its single `A` label. Such an
edge exists because all three endpoint labels are nonisolated, and its
other endpoint is outside the cut. The total weights in the two families
are `1/7` and `12/7`. Distances inside `A` are `26/21`; all other
distances are one. The independent integer replay checks all 55 distances
for every one of the four graphs.

### At least four endpoint labels

Every loopless graph with at least four nonisolated vertices contains four
vertices whose induced subgraph has no isolated vertex. Indeed, two
disjoint edges suffice. If there are no two disjoint edges, fix an edge
`uv`. If all edges share an endpoint, the graph is a star and one center
with three neighbors suffices. Otherwise edges `uv,uw,vz` must have
`z=w`, to avoid disjoint edges. These three vertices form a triangle,
and any further edge must lie in it, or be disjoint from one of its
edges. That contradicts the assumed four nonisolated vertices.

Choose such a set `A` of four vertices; let `B` be the other seven labels.
For each `a in A` and each subset `T` of `B`, give the cut `{a} union T`
weight `1/256`. Assign it to an endpoint edge from `a` to another
vertex of `A`. This is always an allowed cut.

There are 512 atoms with total weight two. Two distinct `A` labels are
separated by 256 atoms; an `A` and a `B` label by 256 atoms; two `B`
labels also by 256 atoms. Thus all 55 distances equal one.
The trivial bound `D>=1` is attained in the relaxation for all 61 graphs.
The positive supports do not satisfy the coordinate-chain condition;
this is **not** an eleven-point equilateral configuration in l1^5.

Since `115/106 < 26/21 < 2`, a globally minimizing original configuration
can be sought among the 61 remaining endpoint cases. Every one of their
endpoint-only relaxations has optimum one. No refinement of a linear dual
for that same relaxation can give a strict lower bound.

## A second obstruction: no order-independent homogeneous dual

Suppose one fixed pair of nonnegative weights `p,q` has `sum(q)=1`
and nonpositive cut loads `sum_{i<k}(p-q)[i,k] delta_S(i,k)` for
**every** coordinate-order cone. Any nonempty proper subset can be
a coordinate prefix, so this applies to every singleton cut.
Summing the eleven singleton loads gives

```
2*(sum(p)-sum(q)) <= 0.
```

Consequently `sum(p)<=1`. A single order-independent dual of the usual
gap-LP form cannot prove any positive distortion gap. This does not rule
out a family of order-dependent duals with a proved cover, or a genuinely
nonlinear analytic argument.

## Exact replay and Jacobian boundary

```
python3 research/endpoint_chain_cover.py --output research/endpoint_chain_cover.json
python3 research/check_endpoint_chain_cover.py research/endpoint_chain_cover.json \
  --configuration research/configuration-115-106.json
```

The first is the generator; the second independently replays the endpoint
partition cover, integer relaxed primals for all 66 cases, and chain
reconstruction. The lower-bound proofs above are analytic and do not rely
on floating-point optimization.

Before this computation, the authorized Argus bridge discovered and
inspected `optimization.linear.rational_general_optimum.compute`.
The initial three-variable/four-inequality request was refused at
normalization admission because its internal possible-basis count exceeded
one million. The preserved structured refusal is not a mathematical
verdict. A smaller two-variable equality feasibility request succeeded:
`a=7/16,b=1/16`, with exact zero residuals and status `OPTIMAL`
(zero objective). These weights give a compact unit-metric relaxed
construction for the matching endpoint graph: singleton endpoint cuts have
weight `a`, and cuts consisting of label 0 and one endpoint have weight `b`.
This agrees with the separate exact 55-pair check.

The exact contracts, payloads, outputs, and first admission error are in
`jacobian/structural-lp-contract.json`,
`jacobian/endpoint-relaxation.{payload,result}.json`, and
`jacobian/endpoint-unit-feasibility.{payload,result}.json`. The successful
response records server `0.14.0`, protocol `2025-11-25`, adapter exit zero,
and runtime 107 ms. It does not certify the full nonlinear endpoint cases.

## Remaining obligation and result classification

The improvement over the previous state is a complete **66-case structural
cover**, an exact elimination of five endpoint cases above the known upper
bound, and an exact demonstration that **all 61 live endpoint-only
relaxations admit a unit metric**. The result is exploratory structural
progress. No novelty or publishability claim is made.

The next mathematical task is to retain and exploit the positive-support
chain compatibility in those 61 cases, or replace it with a universal
analytic inequality sharp at a rational witness. Merely solving their
endpoint-only LPs, averaging a fixed-cone dual, or adding more sampled cones
cannot settle the unrestricted optimum. No sharp lower bound, exact Delta,
or mission completion follows here.
