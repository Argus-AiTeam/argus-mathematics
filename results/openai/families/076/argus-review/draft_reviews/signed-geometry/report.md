# Strict closed-arc containment and packing synthesis

## Claims and hypotheses

`C_PACK_GEOMETRY@1` assumes a compatible slot matching of size
`H=(1+o(1))q/(2L)` and fixed widths `w_i<L_i/(2L)` for positive
odd lengths `L_i`. It asserts that the desired signed closed arcs,
each of length `w_i/H`, lie strictly inside distinct slot containers'
open interiors, including at the half-circle boundary.

`C_PACKING@1` and v2 assert: for nonzero pairwise nonparallel
`a_1,...,a_r in Z^m`, `r>=2`, and positive widths with
`2 sum_i w_i<1`, some integer `H>=1` and torus points
`theta_1,...,theta_H` make all `2rH` closed arcs centered at
`+/- a_i.theta_h`, of length `w_i/H`, pairwise disjoint.
V2 exposes `PS_PACKING_EDGE_COLORING`, an alias of the same
Alon--Yuster Lemma 2.1 input used for matching. It is not an
unconditional Lean theorem simply because the natural-statement hash
is unchanged from v1.

The proof is the old snapshot-bound `report.md`, section "Strict
closed-interval containment", completing its moments-to-matching
chain. The manuscript conclusion is attributed to the OpenAI sources;
the old Argus contribution is its verification and separate counting
formalization. Neither a new geometric theorem nor verified-new
literature novelty is claimed.

## Width selection and strictness

Choose positive `alpha_i>2w_i` summing to one, possible because the
total width budget is strict. Positive odd integers
`L_i=T alpha_i+O(1)` have ratios `L_i/sum L_j -> alpha_i`.
A sufficiently large fixed choice therefore has `w_i<L_i/(2L)`,
without assuming rational widths.

Let `rho=min_i L_i/(2Lw_i)>1`. Since `2LH/q -> 1`, eventually
`2LH/q>1/rho`, giving `w_i/H<L_i/q` for every type.
This is the strict inequality needed for **closed** arcs. A
nonstrict length bound would not by itself prevent intersection at
container endpoints.

## Containers, reflection and compatibility

A retained positive slot with sites `t,...,t+L_i-1` has container

    [(t-1/2)/q, (t+L_i-1/2)/q].

Oddness of `L_i` makes its midpoint the integer center divided by q.
Retained slots have disjoint interiors, not necessarily disjoint
closures. Positive containers lie in `[1/(2q),1/2]`; reflections
lie in `[1/2,1-1/(2q)]`. In particular a container and a reflected
one may share `1/2`. The old proof does not falsely declare these
closed containers disjoint.

The desired closed arc is concentric with its container and strictly
shorter, hence is contained in the container's **open** interior.
The matching cannot reuse an oriented vertex. Each physical retained
slot contributes exactly one oriented center, so it cannot be reused
under its reflected sign either; different types already occupy
different slots. Taking both signs for every matched center therefore
produces distinct desired arcs in disjoint interiors.

Strict containment avoids both zero and `1/2`; positive containers
also leave a gap at zero. Thus reflection cannot make an arc coincide
with itself, and the argument checks circular, not merely linear,
disjointness. Each matched compatible center tuple has a generating
vector `y`; set `theta=y/q` in the torus. This uses precisely the
compatibility established for the hypergraph edges.

## What the finite geometry fixture establishes

The unchanged replay, exit zero, includes the exact `q=101` fixture
with forms `(1,0),(0,1),(1,1),(1,2)`, `H=2`, vectors
`(1,25),(5,11)` and `w_i=1/1000`. Exact rational endpoint comparisons
check all sixteen signed desired closed arcs, strict containment,
the circular gap and the half-circle shared-container endpoint.
This is a nontrivial concrete construction satisfying every stated
fixture condition, not a proof of universal or asymptotic packing.
The universal geometric implication is the width-slack argument above.

## Supported scope and remaining boundary

No gap was found in the strict-containment implication. Combined
with the [moments](../conditional-moments/report.md) and
[conditional matching](../matching/report.md) assessments, it
supports the historical packing conclusion with the exposed
edge-coloring input and its source-reading caveat. The independent
old judgements are `judgement-C_PACK_GEOMETRY-7e889823b6e8`
and `judgement-C_PACKING-86f43d8f9b41`, on the exact subjects;
`judgement-PS_PACKING_EDGE_COLORING-206409dc6d8a` concerns
the external-input alias. Stale open graph labels do not cancel
these judgements.

The finite packing data are fixed before any subsequent polynomial
length `N` is chosen; there is no divisibility restriction on `N`
from this lemma. That observation does not verify subsequent all-length
sampling, rounding or completion estimates. Geometry, matching and
probability have no Lean certificate here. The original analytic
main-theorem nodes remain unreviewed, and the present review still
requires native independent acceptance.
