# Exact five-terminal routing reduction

This is a standard finite-state counting reduction, specialized to the live
question. It is **not** a proof of the treewidth-four exclusion, not a novelty
claim, and not by itself a completed saturation certificate. The original
obligation is stated at the end; the separate pointed-support proof in
`marked_support.md` and `treewidth_four_theorem.md` has since been independently
accepted by `reviewer:e04396ae5d6f` at 2026-11-03T15:29:48Z.

## 1. Partial graphs and their signatures

A partial graph has a labeled boundary B of size b <= 5. All vertices outside
B have their full degree four; vertices in B have current degrees at most
four. A future graph may add edges incident to boundary vertices, introduce
vertices, or glue another partial graph along exactly B. Interior vertices
are never identified with vertices in the other operand.

Record:

1. The current degree g(v) in the underlying graph, for every v in B.
2. The set A of already present edges with both endpoints in B.
3. A truncated counting vector N for the routing types defined below.

Consider edge subsets P in the partial graph such that every interior vertex
has degree two in P and every boundary vertex has degree zero, one or two.
Keep only subsets of one of these forms:

* A disjoint union of paths, possibly with isolated boundary vertices. The
  degree-one endpoints of every nontrivial path lie in B.
* Exactly one cycle, possibly with isolated boundary vertices.

All other subsets can be discarded. A cycle already uses degree two at every
one of its vertices, so it can never be joined to another selected component
by future selected edges. Thus multiple cycles, or a cycle together with a
nontrivial path, cannot be restrictions of a final Hamiltonian cycle.

An open routing type records the boundary degrees h(v) and the pairing of the
degree-one boundary vertices by the paths. The all-zero open type represents
the empty edge subset and occurs only when there are no interior vertices.
An open type with no degree-one vertex and some degree-two vertex is
impossible: a nonempty finite path must have endpoints.

A closed routing type records a cycle flag and the subset of B lying on that
cycle. Its boundary degrees are two on that subset and zero elsewhere.
Some such types can never complete, because an isolated boundary vertex
cannot later attach to the cycle; retaining them does no harm.

For each type q, put

    N(q) = min(2, number of edge subsets P of type q).

Here 2 means "at least two", not a parity residue. A path is not oriented, a
cycle is not rooted, and no representation of an edge subset is counted twice.

For b <= 5, an open type has zero, two or four degree-one vertices. Therefore
the number s_b of possible routing types, including some unrealizable types,
is

    s_b = 1 + C(b,2) 2^(b-2) + 3 C(b,4) 2^(b-4) + 2^b,

where a term with a negative exponent and zero binomial coefficient is
understood to be zero. The first term is the empty open type; the middle
terms choose and pair endpoints and assign degree zero or two to other
vertices; the last term is for closed types. In particular s_5 = 143.

## 2. Why the compression is sound

A boundary vertex of selected degree two cannot receive another selected
edge. Its location inside one of the recorded paths cannot affect any future
connection. Every future connection to an existing path is at a degree-one
endpoint, and those endpoints are paired explicitly. This proves that the
pairing, rather than a record of every internal vertex along a path, carries
exactly the connectivity information needed for future operations.

The degree vector g carries all remaining quartic-degree capacity. The set A
prevents the introduction or gluing of a duplicate boundary edge. No other
duplicate edge is possible when interiors are disjoint. Thus this structural
part of the signature also preserves simplicity.

The following operations compute the signature of their resulting graph
using only the operand signatures.

**Introduce a vertex.** Add a new boundary label with g = h = 0 and no
incident edge. Extend every routing type by a zero coordinate.

**Introduce an edge uv.** Require uv not in A and g(u),g(v) < 4. Increase both
underlying degrees and add uv to A. For each old selected edge subset, either
do not select uv, or select it if both selected degrees are below two.
Selecting it joins two path endpoints, creates a path from two previously
unused vertices, extends a path, or closes one path into a cycle. Reject a
cycle with any other nontrivial component. Distinct choices differ in whether
uv belongs to the selected edge subset, so their counts are added.

**Forget a vertex v.** Require g(v) = 4. Keep precisely the routing types
with h(v) = 2, and remove v from the boundary. An open path's endpoint
pairing does not change, since v is not an endpoint. The vertex and its edges
remain in the graph; only its boundary status changes. Remove its incident
edges from the boundary-edge set A, without decreasing other degrees.

**Relabel the boundary.** Permute all coordinates, pairs and boundary edges
by the same bijection.

**Join.** The operands have the same labeled boundary and disjoint interiors.
Require A_1 intersect A_2 to be empty and g_1(v)+g_2(v) <= 4. Add the degree
vectors and take the union of the boundary-edge sets.

For selected routing types, require h_1(v)+h_2(v) <= 2. Replace each recorded
path by a virtual edge between its endpoints, retaining parallel virtual
edges. Their union has maximum degree two. Its path components determine
the new pairing. A cycle component is allowed only if it is the only
nontrivial selected component; it gives a closed type. A child already
containing a closed cycle can join only with the empty open type of the
other child. That empty type has nonzero count only when the other child
has no interior vertex.

Virtual parallel edges need not be original parallel edges: they can be
two internally disjoint paths. An actual two-edge cycle cannot arise in
the underlying simple graph, because duplicate underlying boundary edges
are rejected by A_1 intersect A_2 = empty. The same observation applies
when introducing an edge that closes a path.

Every selected edge subset of a join has a **unique** restriction to the
two disjoint child edge sets. Its count is therefore the product of the
two child counts. Add such products over all routing-type pairs yielding
the same parent type.

All these formulas use only sums and products of nonnegative integers.
The map t(n) = min(2,n) satisfies

    t(a+b) = t(t(a)+t(b)),   t(ab) = t(t(a)t(b)).

Truncating after every operation consequently preserves exactly whether
each true count is zero, one or at least two. This establishes the claimed
counting and compression soundness, including joins, by induction on a term.

The finite checker `routing_signatures.py` independently realizes routing
types as explicit unions of paths or a cycle, and compares the join rule
with connected-component analysis for all boundary sizes zero through five.
For a type with two paths and a degree-two boundary vertex, it checks both
possible assignments of that vertex to a path. This is a finite check of the
join implementation, not a saturation of graph signatures.

## 3. Coverage of arbitrary width-four decompositions

Take any width-four tree decomposition of a finite simple quartic graph.
Root it and add empty bags above the root and below leaves. Along each
original decomposition edge, first forget child-only vertices and then
introduce parent-only vertices. All intermediate bags are subsets of one
of the two original bags, so none has more than five vertices.

At a branching node, use copies of its bag and a binary tree of joins.
Introduce any missing bag vertices separately in child branches as isolated
boundary vertices. This preserves the connected occurrence condition.
Assign each underlying graph edge to exactly one bag containing both its
endpoints, and insert a duplicate-bag edge-introduction node there. These
assignments are disjoint even when both endpoints occur in several branches.

A vertex can be forgotten only after every bag containing it in that subtree
and every assigned incident edge have been processed. At that time its
underlying degree is exactly four. Edges between child interiors would
require a bag containing vertices in both interiors and so are impossible.
Thus every join identifies exactly the common bag and has disjoint interiors
and disjoint assigned edge sets.

This constructs a term using the legal operations above for **every** input
decomposition, including arbitrary branching, with at most five boundary
labels. Conversely a legal term produces a finite simple graph, has a
decomposition with those boundary bags, and has degree four at every vertex
after the root boundary is emptied.

At empty boundary, the closed routing count is precisely the number of
undirected Hamiltonian cycles, truncated at two. It is a count of edge
subsets in one fixed resulting graph. Different decompositions or different
terms realizing that graph are **not added** to this count.

## 4. The original finite obligation and its subsequent discharge

For each b there are at most

    5^b * 2^C(b,2) * 3^s_b

signatures. The least set R containing the empty-graph signature and closed
under all legal operations, especially **all binary joins and all boundary
relabelings**, is therefore finite. Its elements are exactly the realizable
term signatures. This is a mathematical finiteness statement, not a claim
that enumerating this very large universe is currently practical.

The target theorem is equivalent to:

    No signature in R with empty boundary has closed-cycle count one.

One sufficient certificate would be an explicitly specified finite set S
containing the leaf signature, closed under every legal operation, and
excluding every such accepting signature. A symbolic invariant with a
complete closure proof would also suffice. Conversely a reachable accepting
signature, with its construction term, would yield an exact counterexample.

At the reduction-only checkpoint, neither an accepting term nor a closed
separating S had been obtained. The subsequently accepted pointed-support
collection induces just such a full-signature S, without enumerating the
entire realizable-signature set R. Its exact operation closure, not routing-type
enumeration or a bounded graph search, discharges the obligation. The standard
reduction alone is still not claimed to be a new or publishable result.
