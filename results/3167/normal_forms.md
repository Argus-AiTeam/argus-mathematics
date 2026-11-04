# Proper-adhesion join normal form

This is an auxiliary reduction, not a treewidth-five exclusion. Its finite
closure obligation is still open. In particular it does not freeze the
five-terminal carrier, discard closed entries, or replace treewidth by
pathwidth. No external theorem is needed for the argument below.

## Normal-form lemma

Let G be a finite simple partial quartic graph: vertices outside its
specified boundary B have degree four, and boundary degrees are at most
four. Suppose G has a tree decomposition of width at most five with a bag
containing B. There is a construction of exactly this boundaried graph,
using at most six boundary vertices, with the following operations:

1. The empty leaf, isolated introduction, absent-edge introduction,
   degree-four forgetting, and boundary relabeling.
2. Joins at which at least one operand has an isolated boundary vertex.

All relative boundary bijections remain allowed. Here isolated means
underlying degree zero, not merely selected degree zero.

**Proof.** Contract an edge of the decomposition tree whenever one
endpoint bag is contained in the other, keeping the larger bag. Every
graph edge formerly covered by the smaller bag is covered by the larger.
The image of a connected occurrence subtree under a tree-edge contraction
is connected. Thus this operation preserves the decomposition and does
not increase its width. Finitely many contractions leave a tree in which
adjacent bags are incomparable under inclusion. Root it at the image of
the original root. Its bag D still contains B.

Assign each graph edge to exactly one bag containing both its endpoints.
At a node with bag X, combine the constructions of its child subtrees.
For a child bag Y, first forget Y \ X and then introduce X \ Y. A vertex
of Y \ X cannot occur outside that child subtree: the path to any such
occurrence passes through X, contrary to running intersection. Hence all
its incident edges have already been assigned below, so its underlying
degree is four when forgotten. Conversely a vertex of X \ Y cannot
occur anywhere in the child subtree. It is therefore isolated on
introduction. Incomparability gives X \ Y nonempty.

Start the node's accumulation with the boundary-only graph on X and
introduce its assigned edges. Join child contributions one at a time,
always taking the newly lifted child as the isolated-vertex operand.
Distinct child interiors are disjoint by running intersection, and the
assigned edge sets are disjoint. Thus every join is legal and has the
required zero underlying degree. Intermediate bags are subsets of Y or
X; none has more than six vertices. At the root, forget D \ B. These
vertices are interior vertices of the specified boundaried graph, so
their full underlying degrees are four. The output is exactly G with
boundary B. This also handles a one-node decomposition. QED.

The contractions may turn two dense six-boundary operands of an original
join into several proper-adhesion branches. The lemma does not assert
that either dense operand is replaceable by one five-terminal state.
All the smaller-boundary computations, including returns from six
terminals and new joins, remain unrestricted.

## Sufficient exact certificate

Let R be a finite collection of realizable pointed supports with at most
six terminals. Each row has a genuine count-one marker, full live
positive support, actual boundary edges, and underlying boundary degrees.
Use the already stated simulation preorder: at aligned degrees and
marker, the representative has no more boundary edges or support.
Require:

1. Coverage of the pointed empty leaf and every pointed unary successor.
2. Coverage of every pointed relative join successor for which at least
   one operand has an underlying boundary degree zero.
3. Absence of the empty-boundary closed marker.

Boundary-only joins may still be discharged by successive edge
introductions. Closed marked nonboundary operands are still inert for
the previously proved reason. Every other join in item 2, at every
boundary size and relative permutation, must be checked.

Then R covers every live count-one entry of every partial quartic graph
with a width-five decomposition rooted at its boundary. To prove this,
use the normal form and induct over its construction. A distinguished
count-one parent contribution has count-one child contributions.
Replacing child supports by representatives preserves that contribution
and cannot introduce a competitor. Underlying degrees are fixed by the
preorder, so a zero degree stays zero. Edge inclusion preserves join
legality. The checked operation supplies the next representative.
Backward liveness and relabeling equivariance apply at every step.

In particular this proves coverage under **every** admissible relative
join of realizable rows, including two dense operands: materialize the
two rows with disjoint interiors, glue their root bags under the given
bijection, normalize that decomposition, and apply the preceding
induction. Thus the reduced operation criterion implies the original
full count-one continuation invariant; it is not an assumption that
unexamined dense joins are harmless.

With item 3 it excludes uniquely Hamiltonian finite simple quartic graphs
of treewidth at most five. Until all three items have exact evidence,
this is only a sufficient-certificate theorem.

## Executable scope

`normal_forms.py` performs the bag contractions and evaluates the resulting
construction with the full counting algebra. Its ten-vertex fixture has
four internal quartic stars. Before normalization, each of two
six-terminal branches has positive underlying degree at every boundary
vertex. After normalization each primitive branch omits two boundary
vertices. Direct enumeration of all edge subsets is compared with the
normalized full routing vector, including live closed entries.

`sparse_search.py` enumerates the sufficient operation domain, not a
certificate by itself. Importing an old raw-join frontier resets its
binary cursor; a cursor from a different schedule is not evidence that
the new schedule was visited. Completed sparse enumeration must be
followed by scalar counted replay and independent Host review. Generator
flags, finite prefixes, and this normal-form lemma alone do not complete
the live mission or establish publication novelty/significance.

The scalar checker selects this criterion with `--proper-adhesion`.
It reconstructs all full count vectors and checks every unary operation,
then partitions the unordered nonboundary pairs by selected/rejected
degree sums and the presence of a zero underlying degree. Every remaining
relative permutation is checked by scalar count multiplication. Dense
pairs, degree-ineligible pairs and inert closed pairs are accounted
separately. A prefix without `sparse_join_saturated` is refused; the raw
checker mode continues to require raw saturation.
