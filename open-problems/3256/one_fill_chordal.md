# Dijoin packing in one-edge deletions of chordal graphs

## Statement and source boundary

The target is the following statement, not the general Woodall conjecture.
For every finite loopless digraph D with unit arc capacities, if its underlying
simple undirected graph becomes chordal upon adding at most one edge and its
minimum dicut size tau is finite, then D has tau pairwise arc-disjoint dijoins.
Parallel arcs are allowed; in particular the statement includes simple
digraphs.

The proof below establishes the stronger statement with arbitrary
nonnegative integer capacities. A capacity-w packing consists of dijoins
J_1,...,J_tau with each arc a belonging to at most w(a) sets. Zero-capacity
arcs remain part of the digraph and determine its dicuts.

This is a complete prose proof, not a formal verification or a counterexample.
The independent review in handoff 3c1c3db901b4 accepted its mathematical
correctness and independently attributed its five original assumptions.
Originality and publishable significance remain unverified. Section 7 compares
the proof with a broader proposed theorem and states exactly what its core
reduction supplies; no campaign completion is claimed.

### Results read before developing the proof

1. Gerard Cornuejols, Siyue Liu, and R. Ravi, *A Min-Max Relation on Dicuts and
   Dijoins in Weighted Chordal Digraphs*, arXiv:2501.10918v2,
   Theorem 1.1 and Sections 2.1-2.3.
   <https://arxiv.org/html/2501.10918v2>.
   The theorem permits arbitrary nonnegative integer capacities on chordal
   underlying graphs. Its proof supplies the local simplicial
   deletion/transfer/lifting argument. Section 4 explicitly notes the
   corresponding local obstruction in a minimal weighted counterexample.
2. A. Schrijver, *Min-max relations for directed graphs*, Annals of Discrete
   Mathematics 16 (1982), 261-280, Theorem 4, printed page 271.
   DOI: 10.1016/S0304-0208(08)72456-3.
   <https://ir.cwi.nl/pub/10048/10048D.pdf#page=11>.
   In an acyclic source-sink-connected digraph, an active arc set meeting
   every dicut at least k times partitions into k dijoins. Retaining passive
   arcs and making parallel active capacity copies gives the nonnegative
   integer weighted formulation, including zero capacities.
3. Ahmad Abdi, Gerard Cornuejols, and Maxwell Zlatin, *On packing dijoins in
   digraphs and weighted digraphs*, arXiv:2202.00392v3, Section 1.1, P1-P4.
   <https://arxiv.org/html/2202.00392v3#S1.SS1>.
   P1 supplies a dijoin disjoint from a (tau-1)-dijoin in the unit-capacity
   case. Thus two disjoint dijoins for minimum dicut at least two are already
   known. P2-P3 give full weighted packing at discrepancy parameter rho at
   most two; P4 is the stated unit-capacity tau=3, rho=3 result.

The old objective's assertion that the unit-capacity two-dijoin case is open
is incorrect. The operator-owned OBJECTIVE.md has not been altered.

### Excluded shortcuts

Deleting zero-capacity arcs is not a reduction: it can introduce dicuts.
Likewise, adding a zero-capacity completion arc between incomparable vertices
can remove dicuts. For example, take two parallel unit arcs x->z and two
parallel unit arcs y->z. The minimum dicut size is two. After adding x->y
with capacity zero, the two singletons consisting of the respective x->z
arcs form a packing of two dijoins of the completion, but both miss the
original dicut at y. This is an obstruction to that lifting shortcut, not a
counterexample to Woodall's conjecture.

Adding a zero-capacity completion arc is cut-equivalent when its orientation
is already implied by a directed path. Proving only that comparable-terminal
case does not establish the target.

### Literature comparison boundary

A separate bounded literature investigation opened Schrijver's original
Theorem 4 and searched for one-fill, almost-chordal, and local-closure packing
results. It located no explicit one-fill theorem. This is a search outcome,
not verification of novelty. The 2025 paper's Section 4 conjectures the much
broader 4-/5-chordal extension; it does not prove that extension.

The subsequent independent review located Michael Floros's July 29, 2026
preprint [4], whose Theorem 1.1 proposes the full nonnegative-integer weighted
packing equality on 5-chordal graphs. Every one-fill graph is already
4-chordal, as proved in Proposition 7.1 below. Thus the absence of an explicitly
named one-fill theorem in the earlier search does not establish a new packing
consequence. The proposed-proof label is not a reason to disregard this overlap.
Floros's theorem is not a premise of the proof in Sections 2-5.

## 1. Precise weighted theorem

Write G(D) for the simple undirected graph underlying a finite loopless
digraph D=(V,A). For a nonempty proper U subset V with no entering arc,
the set of leaving arcs is a dicut. A dijoin meets every dicut. For
w:A -> Z_{\geq 0}, let tau(D,w) be the minimum weight of a dicut, with
tau=infinity if there is no dicut. Let nu(D,w) be the maximum size of a
capacity-w packing of dijoins. The empty family is a packing of size zero.

**Theorem.** Suppose G(D) is chordal, or G(D)+xy is chordal for some
nonedge xy. For every nonnegative integer capacity function w for which
tau(D,w) is finite,

    nu(D,w) = tau(D,w).

In particular, setting every capacity to one proves the full requested
one-fill chordal Woodall theorem, for every graph size and every finite
minimum dicut size. The weighted statement includes zero capacities without
deleting their arcs.

The only external packing theorems used are the weighted chordal theorem
[1, Theorem 1.1] and the source-sink-connected theorem [2, Theorem 4].
The local transfer lemma is included in full, adapting [1, Sections
2.1-2.3]; the structural reduction does not assume a two-terminal
capacity invariant.

## 2. Strong components and parallel arcs

**Lemma 2.1.** Contracting the strong components preserves dicuts, their
weights, and weighted dijoin packings through the external arcs. It also
preserves the existence of a chordal completion adding at most one edge.

**Proof.** A shore of a dicut cannot split a strong component: a directed
path from its excluded portion to its included portion would have an
entering arc. Conversely, expanding a dicut shore of the condensation
gives a dicut shore of D. Internal arcs belong to no dicut and can be
removed from every member of a packing. Keeping the external arcs,
including multiplicities and zero capacities, therefore gives the stated
correspondence.

For completeness, chordal graphs are closed under edge contraction. If
contracting uv created an induced cycle of length at least four, let a,b
be the two neighbors of the contracted vertex on that cycle. Its other
vertices are adjacent to neither u nor v. If a and b have a common
neighbor in {u,v}, lift using that vertex to obtain the same induced
cycle. Otherwise, after interchanging u and v, the edges au and bv
exist and av and bu do not. Lift using the path a-u-v-b to obtain an
induced cycle one vertex longer. Both contradict chordality.

Each strong component is connected in the underlying graph, so its
contraction can be performed along a spanning tree. Apply these
contractions to a chordal completion H of G(D). The contracted H differs
from the underlying condensation by at most the image of the one added
edge; that image can also disappear or already be present. This proves
the completion assertion. QED.

In the condensation, opposite arcs cannot occur. Parallel arcs can be
replaced by one arc of capacity equal to their capacity sum. They cross
exactly the same dicuts. Conversely, occurrences of the merged arc in
different packing members can be assigned to original parallel arcs up
to their individual capacities. These operations preserve all relevant
quantities. Zero-capacity arcs are still retained.

## 3. Local weighted simplicial elimination

This lemma is the local content of the baseline induction. The proof
records explicitly why no global chordality assumption is needed.

**Lemma 3.1.** Let D be an acyclic digraph with nonnegative integer
capacities w and every dicut of weight at least q, where q>=1. Let v
have a clique neighborhood in G(D). There are nonnegative integer
capacities w' on the existing arcs of D-v such that:

1. every dicut of (D-v,w') has weight at least q;
2. every capacity-w' packing of q dijoins can be lifted to a
   capacity-w packing of q dijoins of D.

**Proof.** Merge parallel arcs for the duration of the argument. Write
the neighbors as a_1,...,a_d in their acyclic tournament order, so
a_i->a_j exists whenever i<j. Acyclicity also gives an index s such that
a_i->v for i<=s and v->a_i for i>s. Let u_i be the capacity of this
incident arc. Since q>0, v is not isolated.

A sink is handled by reversing all arcs, so it suffices to handle a
source or a vertex with both incoming and outgoing arcs. In the latter
case reverse all arcs if necessary to arrange

    p = sum_{i<=s} u_i <= sum_{j>s} u_j.

There are nonnegative integers x_{ij}, i<=s<j, with row sums u_i
and column sums u'_j<=u_j: distribute the p incoming capacity units
among the outgoing capacities. When s=0 this array is empty and u'_j=0.
Put b_j=u_j-u'_j.

Delete v. For every i<=s<j, increase the capacity of a_i->a_j by
x_{ij}. For j>=s+2, also increase the capacity of
a_{s+1}->a_j by b_j. Leave every other capacity unchanged. These are
existing arcs. In particular, topology is exactly that of D-v, even
when some capacities are zero. All new capacities are integral.

Let U be a dicut shore in D-v. Its intersection with the ordered
neighbors is a prefix {a_1,...,a_t}. If t<=s, U itself is a dicut
shore in D: no outgoing neighbor of v lies in U. The matching increments
crossing this cut total sum_{i<=t}u_i, precisely the deleted capacity
from U to v. The fan increments do not cross. Thus

    w'(delta^+_{D-v}(U)) = w(delta^+_D(U)) >= q.

If t>=s+1, U union {v} is a dicut shore in D, since all incoming
neighbors of v are already in U. The matching increments crossing
total sum_{j>t}u'_j, and the fan increments total
sum_{j>t}(u_j-u'_j). Together they replace exactly the deleted
capacity sum_{j>t}u_j. Consequently

    w'(delta^+_{D-v}(U)) = w(delta^+_D(U union {v})) >= q.

This includes t=0 and t=d and proves the cut bound.

Now let J'_1,...,J'_q be any resulting packing. First suppose
0<s<d. Every original dicut restricts to a dicut with a proper
nonempty shore in D-v: the only possible exceptions would isolate v,
which is neither a source nor a sink. Hence each J'_h initially meets
every original dicut.

For each matching arc a_i->a_j, replace min(x_{ij},z_{ij}) of its
z_{ij} packing occurrences by the two arcs a_i->v and v->a_j.
Such replacement preserves meeting any original dicut, since a
directed path between the shortcut's endpoints crosses every dicut
containing that shortcut. For each fan arc a_{s+1}->a_j, replace
min(b_j,z_j) occurrences by v->a_j. This also preserves coverage:
a dicut containing a_{s+1}->a_j has v on the same side as
a_{s+1}, because the arc v->a_{s+1} is present.

The remaining occurrences of every neighborhood arc fit its original
capacity. The incoming arc at a_i is used at most
sum_j x_{ij}=u_i times. The outgoing arc at a_j is used at most
u'_j+b_j=u_j times. Repeated insertion of one arc into the same
packing member can only reduce these counts. This proves lifting in
the nonsource case.

It remains to consider a source, s=0. Only its singleton dicut may
fail to be covered by an initial J'_h. Before doing replacements,
prune each J'_h to contain at most one fan arc a_1->a_j, retaining
the one with largest j. This preserves its dijoin property in D-v:
if i<j, every dicut containing a_1->a_i also contains a_1->a_j.
Indeed, a_i->a_j prevents a_j from being inside that shore when a_i
is outside.

For every j>=2 replace min(u_j,z_j) occurrences of a_1->a_j by
v->a_j. Because of pruning, the packing members selected for distinct
j are disjoint. If T replacements were made, precisely T members
now contain an incident arc at v. There are q-T remaining members
and at least

    sum_j u_j - T >= q-T

unused incident capacity units, since the singleton dicut at v has
weight at least q. Assign one such unit to each remaining member.
All q members now cover that dicut, and the safe replacements and
additions preserve all other dicuts. The same occurrence count gives
original capacity feasibility. For d=1 the fan is empty and this last
assignment is the whole reconstruction. Reversal gives the sink case.
Finally split merged parallel capacities if necessary. QED.

This proves closure under generated capacities and reconstruction of
*every* required reduced packing, not merely existence of a specially
chosen packing.

## 4. Peeling to a common-neighborhood core

A vertex set S is called induced-path convex here if every induced
path with both endpoints in S is entirely contained in S.

**Lemma 4.1.** If H is chordal and xy is an edge, then

    S = N_H[x] intersect N_H[y]
      = {x,y} union (N_H(x) intersect N_H(y))

is induced-path convex. All vertices outside S can be eliminated in an
order in which each removed vertex is simplicial in the current H.
They are also simplicial in the current H-xy.

**Proof.** In a chordal graph every closed neighborhood N_H[z] is
induced-path convex. To see this, consider an induced path with both
endpoints in that neighborhood. If it contains z, inducedness forces
the whole path into N_H[z]. Otherwise, any nonempty block of vertices
outside N_H[z], between consecutive neighbors of z along the path,
would together with z form an induced cycle of length at least four.
This is impossible. Intersections of induced-path convex sets are
induced-path convex, proving the assertion for S.

Let C be a connected component of H-S and let Q=N_H(C), a subset
of S. The set Q is a clique. Otherwise two nonadjacent vertices
of Q can be joined by an induced path with its interior in C
(take a shortest such path), contrary to convexity of S.

We use the elementary chordal fact that a perfect elimination order
can end at any prescribed clique Q. Here is a proof to make the
extra quantifier explicit. Every noncomplete chordal graph has two
nonadjacent simplicial vertices. Induct on its order. In the
disconnected case use simplicial vertices in different components.
In the connected noncomplete case choose a minimal separator T of
two nonadjacent vertices. It is a clique: if two members of T were
nonadjacent, shortest paths joining them through the two separated
components would form an induced cycle of length at least four.
Minimality ensures every member of T has a neighbor in each of
those two components. Apply induction to each component together
with T. A complete such subgraph has a simplicial vertex outside T;
otherwise its two nonadjacent simplicial vertices cannot both lie
in the clique T. Such a vertex has no neighbors outside its
component and T, so it is simplicial in the original graph. The
vertices obtained from the two components are nonadjacent.

Consequently, when a prescribed clique is a proper subset, a
simplicial vertex outside it exists: use the preceding pair, or
any outside vertex in a complete graph. Repeated deletion proves
the clique-last elimination fact.

Apply this fact to H[C union Q], eliminating C and retaining Q.
No vertex of C has any neighbor outside C union Q, so these
vertices are also simplicial in the whole current H. Do this for
each component of H-S, retaining all of S.

Every eliminated vertex was outside the original S and thus was
not adjacent to both x and y. Removing the edge xy therefore
removes no edge from any eliminated vertex's clique neighborhood.
Each deletion is simplicial in the current H-xy as claimed. QED.

**Lemma 4.2.** Let F be an acyclic digraph with distinct nonadjacent
vertices x,y, at least one other vertex, and every other vertex
adjacent to both x and y. If neither terminal reaches the other,
then every source reaches every sink.

**Proof.** Each other vertex z has either z->x,z->y, or
x->z,y->z. Either mixed orientation would give a directed path
between the terminals. Let L and R be these two sets, respectively.

If both are nonempty, every source lies in L and every sink in R.
For any such source l and sink r, l->x->r is a directed path.
If L is empty, the sources are x,y and every sink is in the
nonempty set R; each required path is a single arc. If R is
empty, the reverse statement holds. QED.

No chordality hypothesis on the other vertices is needed in Lemma 4.2.
This is why the missing incomparable neighborhood edge need not be
assigned a virtual capacity.

## 5. Completing the packing proof

**Proof of the theorem.** Every capacity-w packing has size at most
tau(D,w): count its mandatory intersections with a minimum-weight
dicut. If tau=0, the empty packing attains this bound. Hence suppose
tau=q>=1. A disconnected underlying graph would have an empty
dicut and tau=0, so G(D) is connected.

By Lemma 2.1 contract the strong components and merge parallel
capacities. The result is acyclic, has the same q, and still has
a chordal completion using at most one edge. If its underlying
graph is chordal, use [1, Theorem 1.1] and lift through the
contractions.

Otherwise fix a nonedge xy such that H=G(D)+xy is chordal.
If x reaches y, add x->y with capacity zero; if y reaches x,
use the reverse orientation. This creates no new restrictions
on dicut shores, because the implied directed path already
forbids a shore containing the head but not the tail. All shores
and their weights are therefore preserved. The completion is
chordal, so [1, Theorem 1.1] gives q packed dijoins, none using
the zero-capacity added arc. They are the required original
dijoins.

Now suppose the endpoints are incomparable. Define S as in
Lemma 4.1. The set S has a vertex other than x,y. Indeed, a
shortest x-y path in the connected G(D), together with xy,
would be an induced cycle in H if its length were at least
three. Thus their distance is two.

Eliminate every vertex outside S using the order in Lemma 4.1,
applying Lemma 3.1 at every deletion. The remaining graph is
exactly D[S]; only integer capacities on existing arcs have
changed. Every dicut still has weight at least q. Deletion adds
no directed paths, so x and y remain incomparable. Every other
vertex of D[S] is adjacent to both terminals. Lemma 4.2 makes
this core source-sink connected.

Apply [2, Theorem 4] in its nonnegative integer weighted form.
For clarity, that form follows directly from the stated
active-arc theorem: retain all original arcs as passive arcs
and put w(a) active parallel copies alongside each arc a.
Source-sink reachability and dicut shores do not change, even
when w(a)=0. Each dicut contains at least q active copies.
Theorem 4 partitions the active copies into q dijoins; mapping
copies to original arcs gives a capacity-feasible packing.
Thus the core has q packed dijoins.

Lift this packing back through the eliminations in reverse
order by Lemma 3.1, then split parallel capacities and expand
strong components by Lemma 2.1. This gives q capacity-w
dijoins of the original D. Together with the upper bound,
nu(D,w)=tau(D,w). QED.

The argument covers arbitrary size, arbitrary finite q, cyclic
input digraphs, incomparable terminals, all generated capacities,
and unrestricted reconstruction. It makes no unproved packing
conjecture, finite-exhaustion hypothesis, or numerical assumption.

## 6. A strict structural comparison and an exact example

Here is an explicit simple unit-capacity family demonstrating
what is added beyond the directly applicable results cited above.
Fix k>=4 and m>=4. Start with vertices

    u, v, w_1,...,w_{k-2}, x, y

in that displayed order. Include all forward arcs except u->v
and x->y. Attach m otherwise disjoint transitive cliques

    a_{b,1} -> ... -> a_{b,k} -> y,    1<=b<=m,

where "transitive clique" means all forward arcs of that order,
not just the consecutive arcs. Every arc has capacity one.

Adding xy makes the underlying core K_{k+2} minus uv, a chordal
graph; each attached clique meets it only at y. An explicit
perfect elimination order deletes the branch vertices in their
orders, then u,v,w_1,...,w_{k-2},x,y. The original graph has the
induced four-cycle x,u,y,v,x, so it is not chordal. It contains
the K4 on {u,x,w_1,w_2}, so it is not series-parallel. A branch
source cannot reach the sink x, so the original graph is not
source-sink connected.

The minimum dicut size is exactly k. Here is a packing certificate,
independent of the theorem just proved. Index the core order by
0,...,k+1 and give an arc i->j the color (j-i) mod k. In each
attached transitive clique index its order by 0,...,k and use
the same rule.

At either core source u,v, all k colors occur exactly once;
the same is true entering either core sink x,y. A dicut shore
other than a singleton source or the complement of a singleton
sink consists of both sources and a prefix of the middle
chain, with neither sink. Every distance 1,...,k+1 has a forward
arc crossing such a prefix, so every color occurs. These
observations also cover the shore consisting of both sources
and the shore consisting of all vertices except both sinks.
For an attached transitive clique, its dicut shores are
prefixes, and every distance 1,...,k has a crossing arc.
Thus each block has a dijoin of each color.

The union of same-colored block dijoins is a dijoin of the
whole graph. A nontrivial dicut shore restricts nontrivially
to some block: otherwise its membership is constant on every
block, and the common vertex y forces the same constant
globally. Its restriction there is a dicut shore and has every
color. All colors are arc-disjoint. The singleton cut at u
has exactly k arcs, proving the upper bound as well.

This family also avoids the directly stated full-packing
discrepancy cases P2-P4 of [3]. Put

    rho = (1/k) sum_z ((outdegree(z)-indegree(z)) mod k),

where residues are in {0,...,k-1}, and let rho_bar use reversed
arcs. A branch changes y's indegree by k and hence does not
change its residue. Its k new vertices have imbalances
k+2-2i, for i=1,...,k. For odd k their residues run through
0,...,k-1, contributing (k-1)/2 to rho. For even k, each
even residue occurs twice, contributing k/2-1. Negating
these residues gives the same multiset, so each branch has
the same contribution to rho_bar. In either case the
contribution is at least one for k>=4. The core itself has
nonnegative integral rho and rho_bar. Thus rho,rho_bar>=m>=4.
Neither P2 nor P3 applies in either orientation, and P4
requires k=3. P1 remains applicable but does not assert a
full packing of k dijoins when k>=4.

This comparison establishes a strict extension of the *stated*
chordal, series-parallel, source-sink-connected, and low-rho
full-packing hypotheses. It is not a claim that every possible
consequence or closure of all earlier literature has been
excluded. The bounded literature search did not locate an
explicit one-fill theorem. However, the entire family is 4-chordal
and is covered by the statement of Floros's proposed Theorem 1.1.
It therefore does not separate this work from that broader claim.

`research/verify_one_fill.py` generates the k=4,m=4 instance
and checks it by a method separate from the coloring construction.
An independent reader can replay the saved construction with:

```bash
python3 research/verify_one_fill.py --certificate research/one_fill_example.json
```

Its certificate contains the complete graph, an explicit packing,
a minimum dicut, a chordal completion/elimination order, an
induced four-cycle, and a K4. Dijoin validation uses exact
strong-connectivity checks after adding reverse arcs for each
color; this is equivalent to meeting every dicut. The example
has 22 vertices, 53 arcs, and rho=rho_bar=5.

The archived Jacobian operation
`graph.directed.reachability.compute` checks only the
three-vertex topology used in the excluded shortcut. Its
payload, inspected typed contract, output, server version,
protocol, and adapter exit status are under
`research/jacobian/`. It contributes no premise to the
universal theorem.

No computational output is a premise of Sections 2-5. The
finite certificate illustrates the distinction from the three
baseline sources; it is not substituted for the proof or for an
originality assessment. No Lean compilation or formal verification
is claimed. The original proof and its five cited assumptions
passed independent review; the publication-level obstruction
and the new source comparison remain unresolved.

## 7. Comparison with Floros and the exact reduction postcondition

The primary source inspected here is Michael Floros, *Packing Dijoins in
5-Chordal Digraphs: A Weighted Min-Max Theorem and a Strongly Polynomial
Algorithm*, version 1.0, July 29, 2026, DOI
10.5281/zenodo.21695426. The unchanged companion `MANUSCRIPT.md` is retained
as `research/literature/floros_2026_MANUSCRIPT.md`; its original archive is
`research/literature/floros_2026_companion.zip`. The manuscript is licensed
CC-BY-4.0, copyright 2026 Michael Floros. The theorem statement and the
existence argument, rather than only the repository description, were read.
The source explicitly labels its proof proposed and not independently verified
by a human expert. Nothing below certifies that proof or any of its external
interfaces.

### 7.1 Exact containment of the packing statement

**Proposition 7.1.** If adding at most one edge to G makes it chordal,
then G has no induced cycle of length at least five. This class is a
proper subclass of the 4-chordal graphs.

**Proof.** An induced cycle C of length ell>=5 in G must acquire a
chord in the chordal completion H. With at most one added edge, that
edge is its only possible chord. The two cycles obtained by splitting
C along that chord have lengths at least three, with sum ell+2>=7.
At least one has length at least four. That cycle is induced in H:
among the vertices of C the only edges of H are the cycle edges
and the one splitting chord. This contradicts chordality.

For strictness use K_{3,3}. A cycle of length at least six has a chord,
so this graph is 4-chordal. Any added nonedge joins two vertices in
one bipartition class. Choose a different pair in that class and any
two vertices in the other class. They still induce a four-cycle.
Thus no single added edge makes K_{3,3} chordal. QED.

Floros's Theorem 1.1 (`MANUSCRIPT.md`, lines 1-33) permits finite
loopless digraphs with parallel and opposite arcs, capacities in
Z_{\geq 0}, empty dicuts of value zero, and a finite minimum over
at least one dicut. These are the conventions of the theorem in
Section 1 here. Its hypothesis is 5-chordality, not one-fill
chordality, and its conclusion is exactly nu(D,w)=tau(D,w).
Proposition 7.1 therefore proves statement-level subsumption for
the entire weighted theorem here, not just for comparable
completion endpoints, positive capacities, or the unit-capacity
examples. This implication does not assume that Floros's proof
is correct; it compares the assertions.

The auxiliary Jacobian execution
`graph.induced_vertex_subset_pattern.count` counts six induced
four-cycles after adding one fixed nonedge to K_{3,3}. Its
inspected contract, exact payload, typed output, and adapter
status are under `research/jacobian/strict_inclusion_*`.
Symmetry and the preceding proof handle every possible nonedge.
This finite operation is not evidence of originality or a premise
of the universal packing theorem.

### 7.2 The decisive existence argument is different

Floros's Section 13, not its later compact-algorithm sections,
composes the following transformations. Lemmas 3.1-3.4 contract
strong components, retain zero-capacity topology, take transitive
closure, and assert a 4-chordal reachability-poset instance.
Lemmas 4.1-4.3 split this into a chordal-bipartite height-one
instance with an exact packing correspondence. Lemmas 5.1-5.4
give a class-preserving sink regularization and project every
resulting capacity-feasible packing back to the original instance.

The decisive packing interface in that composition is Theorem
12.1. Lemma 12.2 characterizes an ACZ M_1-basis by a perfect
matching in an anchored graph, using Lemmas 9.2 and 10.2 and
the support trees of Sections 7-10. Equation (12.3) asks for
one integral aggregate b-matching; feasibility is supplied by
ACZ's basis-partition theorem, cited there as Theorem 4.8.
Lemma 12.3 turns that flow and the positive arcs into a
tau-regular bipartite multigraph. Its perfect-matching colors
project to arc sets J_i. Equation (12.5) expresses the number
of J_i-arcs crossing a dicut as the M_1-basis inequality;
Lemmas 12.6 and 12.7 conclude that the projected colors are
dijoins and are disjoint. Section 13 lifts them through the
earlier transformations.

There is also a shorter alternative in Theorem 11.1 and
Corollary 11.2, using strong base orderability and ACZ
Theorem 5.14. It is not the route Section 13 invokes. Thus a
criticism confined to that alternative would not settle
Floros's decisive existence argument.

In contrast, Sections 3-5 here use the known simplicial
capacity transfers and stop at an induced common-neighborhood
core to which Schrijver's source-sink-connected theorem
applies. They do not use ACZ matroids, support-tree
factorization, module regularization, or anchored flows.
The inspected Floros manuscript does not state this
common-neighborhood peeling lemma. These facts distinguish
proof architectures; they do not establish priority or
publishable significance for the resulting special case.

### 7.3 What can actually be reused

**Proposition 7.2 (core reduction, without a novelty claim).**
Let D be finite and acyclic, let x,y be nonadjacent and
incomparable by directed reachability, and let
H=G(D)+xy be chordal. Suppose w is nonnegative integral and
every dicut has weight at least q>=1. Put

    S = N_H[x] intersect N_H[y]
      = {x,y} union (N_G(D)(x) intersect N_G(D)(y)).

Then there are nonnegative integral capacities w_S on
the existing arcs of D[S] such that:

1. D[S] has at least three vertices and is source-sink connected.
2. Every dicut of (D[S],w_S) has weight at least q.
3. Every capacity-w_S packing of q dijoins can be lifted
   to a capacity-w packing of q dijoins of D.

The reduction deletes exactly V(D) minus S and introduces
no new adjacency. Its remaining vertex count is exactly
2+|N_G(D)(x) intersect N_G(D)(y)|. Zero-capacity arcs in the
remaining induced digraph are retained. The assertion is
one-way lifting; it does not claim that every original
packing projects, that w_S is bounded coordinatewise by w,
or that the reduced minimum dicut equals the original one.

**Proof.** Positive q rules out a disconnected underlying
graph, because a union of components would give an empty
dicut. In the connected G(D), a shortest x-y path of
length at least three, together with xy, would give an
induced cycle of length at least four in H. Hence there
is a common neighbor and |S|>=3.

Lemma 4.1 supplies an order deleting every vertex outside
S simplicially in the current G(D), not merely in its
completion. Apply Lemma 3.1 along that order. At each
step the capacities are integral, the dicut lower bound
q is retained, and every reduced q-packing lifts. The
topology after all deletions is exactly D[S]. Deletion
cannot create directed paths, so x and y remain
incomparable. Every remaining nonterminal is adjacent
to both terminals. Lemma 4.2 therefore makes D[S]
source-sink connected. Composing the local lifting maps
in reverse order gives the universal lifting assertion.
The displayed description of S gives the vertex count.
QED.

This states the precise structural postcondition that
the reviewed proof supplies beyond merely invoking
Floros's Theorem 1.1. It is a useful description of a
smaller terminal-preserving instance. It is not a new
local packing-preservation rule: the transfers and
mapping-back argument already appear in [1, Sections
2.2-2.3], with a compact implementation in [1, Section
3, Algorithms 1-2]. In [1, Section 4, Conclusion and
discussion], the authors explicitly observe that their
proofs exclude a vertex with chain neighborhood from a
minimal weighted counterexample. The terminal core
packing theorem used here is the already cited [2,
Theorem 4]. Universal packing reconstruction also
appears in Floros's Lemmas 4.2 and 5.4; that quantifier
alone is not a distinguishing new principle.

The additional ingredient here selects where to stop
those known local moves and recognizes the resulting
core. In the work currently proved, its only packing
consequence is the weighted one-fill equality already
subsumed at statement level by [4]. No application
outside that hypothesis, new obstruction, or improved
algorithmic bound has been established. Nor has an
independent originality or significance assessment of
Proposition 7.2 been obtained.

Accordingly, the supported outcome is an elementary
independent proof of a subsumed special case and an
explicit restatement of its reduction, not a certified
new publishable reduction. Absence of the named lemma
from one inspected manuscript is not verified novelty;
the preprint's proposed-proof status, or a gap someone
might find in it, would not supply that missing
contribution either. The attempt to meet the campaign's
publication bar by the present peeling/core mechanism
alone is retired as insufficiently established, not
mathematically refuted. Replanning toward a materially
different consequence is required after Host-invoked
independent review of this comparison. The sound proof
and its earlier review remain intact.

## References

[1] Gerard Cornuejols, Siyue Liu, and R. Ravi. *A Min-Max
Relation on Dicuts and Dijoins in Weighted Chordal Digraphs*.
arXiv:2501.10918v2. Theorem 1.1, Sections 2.1-2.3, and Section 4.
<https://arxiv.org/html/2501.10918v2>.

[2] A. Schrijver. *Min-max relations for directed graphs*.
Annals of Discrete Mathematics 16 (1982), 261-280. Theorem 4,
printed page 271 (PDF page 11).
DOI: <https://doi.org/10.1016/S0304-0208(08)72456-3>.
Original institutional text:
<https://ir.cwi.nl/pub/10048/10048D.pdf>.

[3] Ahmad Abdi, Gerard Cornuejols, and Maxwell Zlatin.
*On packing dijoins in digraphs and weighted digraphs*.
arXiv:2202.00392v3. Section 1.1, P1-P4; Section 1,
the paragraph following Question 1.1.
<https://arxiv.org/html/2202.00392v3>.

[4] Michael Floros. *Packing Dijoins in 5-Chordal Digraphs:
A Weighted Min-Max Theorem and a Strongly Polynomial
Algorithm*. Version 1.0, July 29, 2026. Proposed proof,
not independently verified here. Theorem 1.1; Lemmas
3.1-3.4, 4.1-4.3, 5.1-5.4, 9.2, 10.2, and 12.2-12.7;
Theorem 12.1 and Section 13.
DOI: <https://doi.org/10.5281/zenodo.21695426>.
Companion `MANUSCRIPT.md`:
<https://zenodo.org/records/21695426>.
