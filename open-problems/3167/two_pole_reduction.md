# A width-preserving two-terminal reformulation

This elementary reduction was independently accepted by
`reviewer:43471e4bc6cf` at 2026-11-03T14:25:18Z. The reduction alone does not
exclude the two-terminal graphs below and is not claimed new or publishable.
The separate exclusion and full-signature closure were subsequently accepted
by `reviewer:e04396ae5d6f` at 2026-11-03T15:29:48Z; see
`treewidth_four_theorem.md`. Publication eligibility remains uncertified.

## Statement

The following existence statements are equivalent:

1. A finite simple quartic uniquely Hamiltonian graph of treewidth at most
   four exists.
2. A finite simple graph H exists with distinct nonadjacent terminals u,v
   of degree two, at least one interior vertex, every interior vertex of
   degree four, a tree decomposition of width at most four with a bag
   containing both u and v, and exactly one undirected spanning u-v path.

More generally, if a graph in (2) has m such paths, joining two copies along
corresponding terminals yields a finite simple quartic graph of treewidth
at most four with exactly m^2 undirected Hamiltonian cycles.

## From a quartic graph to a two-terminal graph

Let G satisfy (1), with unique Hamiltonian cycle C. A width-four tree
decomposition contains a bag consisting of a vertex x and its four neighbors.
Indeed, delete leaf bags contained in their neighbor until none remain.
If there is just one bag the claim follows from degree four. Otherwise
choose a vertex x in a leaf bag but not its neighbor. It occurs in no other
bag, so all four of its neighbors are in that leaf bag. The bag has at most
five vertices, so it is exactly `{x} union N(x)`.

Write the neighbors as a,b,c,d so that C uses xa and xb. Remove x. Introduce
two terminals u,v and edges ua,uc,vb,vd. The resulting graph H is simple,
u and v are nonadjacent of degree two, and every old remaining vertex
still has degree four.

There is a bijection between spanning u-v paths of H and Hamiltonian cycles
of G that use one neighbor of x in `{a,c}` and one in `{b,d}`. Identify u
and v back to x to obtain the cycle; conversely split x in such a cycle
to obtain the path. This is a bijection of undirected edge subsets, not
oriented walks. C supplies one path, and uniqueness of C supplies no other.

To check the width and common-terminal-bag requirement, remove x from its
original leaf bag, leaving a bag N=`{a,b,c,d}` in a decomposition of G-x.
Attach to that bag the following path of bags:

    N union {u},    {u,v,b,d},    {u,v}.

All new edges have both ends in a listed bag. The occurrence sets of the
old vertices, u and v remain connected. The largest bag has five vertices.
Thus H has the required width-four decomposition with a terminal root bag.

This construction does not rely on a width-preserving transformation of
the whole graph into a 3-connected example or on a multigraph.

## From a two-terminal graph to a quartic graph

Take two otherwise disjoint copies H1,H2 and identify their corresponding
u terminals and their corresponding v terminals. No loop or duplicate edge
is created: the interiors are disjoint and uv is absent from both copies.
The common terminals now have degree four, as do all interior vertices.
Joining the two terminal-bag decompositions along their `{u,v}` bags
preserves width at most four.

Any Hamiltonian cycle of the joined graph must meet both nonempty interiors.
Its restriction to either child is one spanning u-v path. To justify this
without an orientation convention, an acyclic selected restriction can have
endpoints only at u,v; its interior vertices all have selected degree two,
so it must be exactly one path. A closed selected restriction could not
connect to the other nonempty interior. There cannot be two disjoint
nontrivial paths with only two distinct boundary endpoints.

Conversely the union of any spanning u-v path in H1 and any such path in H2
is one spanning cycle. Its two restrictions recover the pair of paths
uniquely. The two child interiors distinguish the factors, while reversing
the cycle changes neither factor. The count is exactly m^2, with no factor
of two and no rooting multiplicity. For m=1 this proves (1).

## The full-signature obstruction this isolates

At a two-vertex boundary u,v, consider g=(2,2), A empty and a nonempty
interior. There is only one possible open routing type: the u-v path
with selected degrees (1,1). A final Hamiltonian cycle joining two copies
can use only that open type in each child, so its count is m^2 regardless
of any closed routing entries.

At the reduction-only checkpoint, reachability of the abstract vector with
that entry equal to one and all other entries zero was unresolved. Asserting
its exclusion was not an invariant proof: the exclusion had to follow from
the leaf and all operations, not be assumed at a two-terminal state. The
subsequently accepted pointed-support invariant establishes exactly this
exclusion, including states with other nonzero closed entries.

Compared with the preceding sound five-terminal reduction, the result
identifies an equivalent special two-terminal obstruction and provides a
width-preserving conversion in both directions. It does **not** make a
claimed theorem out of an unproved path-exclusion assertion. No originality
or significance assessment has been completed for this elementary reduction.

## Exact finite replay and a parity obstruction

Run:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/verify_two_pole.py
```

Splitting a vertex of K5 gives a six-vertex two-terminal graph with **8**
spanning terminal paths. Doubling it gives a ten-vertex simple quartic graph
with **64** undirected Hamiltonian cycles. Direct permutation enumeration
and subset dynamic programming agree on the path count. An orientation-free
cycle DFS and a separate oriented path DP agree on the cycle count, with
128 oriented cycles corresponding to 64 undirected edge subsets. The full
signature and its per-operation live projection also agree.

The same script splits the first elimination vertex 0 of the previously
reviewed eight-vertex graph. The three neighbor partitions give path counts
**19, 21, 18**. Every resulting graph has nine vertices, nonadjacent degree-two
terminals 8,9, and seven degree-four interiors. Each count is independently
checked by permutations and subset DP. Explicit bags and their decomposition
tree are recorded and checked for edge coverage, running intersection,
tree connectivity, maximum bag size five, and a common-terminal bag.

Every Hamiltonian cycle through the split vertex crosses exactly two of
the three neighbor partitions, explaining the check `19+21+18 = 2*29`
against the previously established cycle count. In particular **evenness of
all two-terminal path counts is false already in this width-four class**.
The desired distinction is count one versus every other count, not odd
versus even. The 19-path and 21-path examples do not refute that distinction,
and do not constitute a target counterexample.
