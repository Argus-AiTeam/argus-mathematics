# Statement fidelity: root-labelled routing

## Principal declaration and quantifiers

`RoutingCore.routing_root` quantifies over every natural order `r`, every
simple undirected graph `P : SimpleGraph (Fin r)`, every real expansion
parameter `h`, every finite set `F` of unordered vertex pairs, every
function `W : Fin r -> Finset (Fin r)`, and every root finset `S`.
The hypotheses are exactly:

- `2 <= r`, `0 < h`, and `RoutingCore.CutExpansion P h`;
- `S.Nonempty` and, for every `s` in `S`, `s` is not in `W s`;
- for every `s` in `S`, the real-valued cardinality of `W s` is at most
  `h/4`;
- the real-valued cardinality of `F` is at most `h * |S| / 4` and at most
  `h * r / 64`.

There is no common forbidden vertex set, no assumption that the balls
grow, and no assumption that some root is already good. The function W
is unchanged in every lemma and every halving. Other roots may belong
to `W s`, and different roots may have equal or different forbidden sets.
There is no restriction on overlaps of their balls.

Labelling the r vertices by `Fin r` does not restrict a finite graph:
any r-vertex graph has such a labelling. F may include nonedges or
diagonal unordered pairs, which only strengthens the formal result;
an actual deleted-edge subset is included in the quantification.

The conclusion is that some `s` in `S` has a ball of cardinality strictly
greater than the real number `r/2` at radius

    ceil_nat(8 (r/h) logb(2, 2r))
      * (1 + ceil_nat(logb(2, |S|))).

`Real.logb 2` is the base-two logarithm. All its arguments here are
positive; both expressions being rounded are nonnegative. Thus the
natural ceilings in Lean equal the ordinary integer ceilings in the
manuscript. `Real.natCeil_logb_natCast` identifies the second ceiling
with `Nat.clog 2 |S|` exactly, including the zero-halving case |S| = 1.
The theorem gives the ball at the full allowed radius; by monotonicity,
this is equivalent to existence of a suitable radius at most that bound.

## Graph and ball semantics

`RoutingCore.boundary P B` consists of adjacent ordered pairs (v,w)
with v in B and w outside B. Each undirected crossing edge occurs
exactly once in this orientation. `RoutingCore.CutExpansion` states

    h * min(|B|, r-|B|) <= |boundary P B|

for every vertex finset B. This is the manuscript's edge-cut expansion,
not vertex expansion or expansion only for connected subsets.

`RoutingCore.rootGraph P F W s` has adjacency precisely when the
original vertices are adjacent, their unordered pair is not in F,
and neither endpoint belongs to `W s`. It keeps forbidden vertices
as isolated labelled vertices. Since the root is not forbidden, these
isolated vertices never enter its ball; the reachable graph is exactly
the vertex-deleted graph `(P-F)-W_s`.

`RoutingCore.ball` starts at {s} and repeatedly adds the endpoints of
allowed edges from the previous ball, subject to that root's W.
`RoutingCore.ball_avoids` proves exclusion of W. Crucially,
`RoutingCore.mem_ball_iff_walk` proves both directions of the equivalence
with existence of a walk in `rootGraph` of length at most the radius.
Its constituent declarations `RoutingCore.ball_walk_witness` and
`RoutingCore.walk_mem_ball` construct and replay the walks.
`RoutingCore.walkBall` is the finite set defined directly by that
bounded-walk property, and `RoutingCore.ball_eq_walkBall` identifies it
with the recursive ball. The principal theorem concludes a cardinality
bound for `walkBall`, not an uninterpreted family of sets.
In an unweighted graph, existence of a bounded-length walk is equivalent
to graph distance at most that length; removing closed subwalks cannot
increase length.

## Derivation, not circular hypotheses

`RoutingCore.deleted_boundary_card` proves that deleted oriented
boundary edges inject into F, using equality of unordered pairs and
the fact that the second endpoint lies outside B.

`RoutingCore.union_growth` derives the claimed factor 1+h/(2r)
from actual graph boundaries. It chooses a reaching root for each
inside vertex, bounds that label's forbidden boundary edges by |W_s|,
and injects usable boundary pairs into B times the new vertices.
It does not receive a growth inequality as a hypothesis.

`RoutingCore.expansion_le_order` derives h <= r from a singleton cut.
`RoutingCore.log_growth_lower` proves the elementary logarithmic bound.
`RoutingCore.radius_log_bound` uses the actual ceiling in
`RoutingCore.growthRadius`. `RoutingCore.growth_block` iterates the
derived `union_growth` theorem, not an assumed numerical recurrence.

`RoutingCore.halve_large_union` inducts on m with at most 2^m roots.
Its two subsets retain their original root labels and W values;
one has a union larger than r/4 and the global F budget permits
another graph-growth block. `RoutingCore.root_growth_and_halving`
starts from `unionBall S 0 = S` and uses `Nat.le_pow_clog` for the
exact number of halvings. `RoutingCore.routing_root` then translates
this to the graph-walk balls and the displayed real-log ceilings.
The helper `RoutingCore.unionBall` means a union of labelled balls,
not a multi-source ball in any one altered graph.

## Obstruction budgets and limits

`RoutingCore.obstruction_budgets` is a separate universal arithmetic
theorem. Its real variables x,k,b,z,a,R are nonnegative; x denotes
ell squared, n denotes |I|, a denotes |S|, R denotes graph order,
f denotes |F| and w denotes |W_s|. It assumes

    64 (x(k+b)+z) <= h, f <= 2xn,
    n <= 4ka, 2n <= kR, w <= z+4bx,

and derives all three root-theorem budgets. It does not assert that
a hypergraph matching obstruction exists. The combinatorial extraction
of these quantities, intersection-to-simple-path argument, and
Aharoni--Haxell inference to team routes are proved in REPORT.md,
with their external matching input explicitly identified.

The Lean file contains no custom axioms, admitted statements, or
executable decision oracles. The printed dependencies of `union_growth`
and `routing_root` are checked against Lean's standard foundational
axioms only: `propext`, `Classical.choice`, and `Quot.sound`.
The trusted environment is Lean 4.31.0 with the supplied Mathlib.

The compiler checks these declarations, not this translation document.
An independent Reviewer must still read the translation and the
source-to-team-routing connection. No claim is made here to have
formalized the hypergraph matching theorem, the other manuscript
dependencies, the global cycle-decomposition theorem, or a new
literature theorem. This is an independent formal certification of
one graph-level dependency.
