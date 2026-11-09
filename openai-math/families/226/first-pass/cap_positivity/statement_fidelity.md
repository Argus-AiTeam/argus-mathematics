# Reading of Main.lean

The namespace is `CapPositivity`. Scalars in the chain and bilinear
theorems are arbitrary real numbers; the local orientation-count matrices
have rational entries. Lists and finite sets have arbitrary finite size.
There is no bound on a rectangle, number of loops, or number of seam hits
in these formal statements.

`Decays r xs` says that every list entry is nonnegative, the tail has the
same property, and the next entry (zero at the end) is at most r times
the current entry. `alternating` is x1-x2+x3-..., and `head0` is the
outermost weight or zero for an empty list. `alternating_bounds` proves
its bounds between (1-r) times the head and the head, for 0 <= r <= 1.

A chain is a list of pairs (U,V). `Good` imposes the decay separately on
the two projections. `within` is the outer-member decomposition of the
distinct-loop expression inside one alternating-sign chain, including
the manuscript factor 1/4. `twoChains` adds both within-chain
contributions and the cross term for chains with opposite initial signs.
`within_nonneg` and `twoChains_nonneg` assume no positivity of the target
expression. They prove it from the decay hypotheses.
`twoChains_cross_detection` proves the lower bound
(1-r)^2 q^2/2 when each of the four outermost U,V weights is at least
q >= 0. `within_head_detection` proves (1-r) q^2/2 when the first two
members of one chain each have U,V at least q. These are precisely the
thresholds extracted in the report from two loops with eligible arches
in both caps. Empty chains are included in the nonnegativity theorem.

`same_loop_nonneg` and `same_loop_detection` quantify over integers u,v
with -1 <= u-v <= 1. They prove uv >= 0, and uv >= 1 if neither
integer is zero. `same_sink_sign` cancels the common rank/orientation
sign e under the explicit hypothesis e^2=1.
`same_color_sum` and `distinct_color_sum` prove the finite bilinear
summations, with the respective ordinary-color divisors 2 and 4.

`source` is the transition from incoming traversal orientation - to
outgoing orientation +. `sink` is its reverse. `one_source_one_sink`,
`alternating_sources_sinks`, `adjacent_sources`, and `adjacent_sinks`
verify the local trace counts 1,1,0,0. Identity transitions on ordinary
strands and cyclic placement are justified in the report, not encoded as
a theorem about embedded lattice graphs.

**Formal boundary.** Lean does not encode square-lattice perfect
matchings, cap diagrams, polygonal containment, the marked-vector norm,
the equality of `twoChains` with the original ordered double sum, or
extraction of head thresholds from remote eligible arches. Those
unbounded reductions are proved in the mathematical report and
independently exercised by the exact Python verifier. The Lean claim is
the algebraic/color core under the hypotheses just stated, not the
complete geometric detector or the CLE4 convergence theorem. Compilation
does not validate the prose reductions or any novelty claim.
