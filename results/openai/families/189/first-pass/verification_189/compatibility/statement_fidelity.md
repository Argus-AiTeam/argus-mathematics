# Lean 4.31.0 compatibility propositions

`Main.lean` in this directory proves library facts missing from the older
Mathlib interface. It introduces no axioms and changes no graph definition
or manuscript hypothesis. The Ramsey proof itself remains the frozen
upstream source, with an additional import of these proved propositions.

`ite_eq_left`, `ite_eq_right`, `dite_eq_left`, and `dite_eq_right` specialize conditional
expressions under a proof of their condition or its negation.
`Set.mem_ofPred_eq` unfolds membership in the set defined by a predicate.
`List.Nodup.head_eq_getLast_iff` states that a nonempty duplicate-free list
has equal first and last entries exactly when it is a singleton. Its
quantifiers range over arbitrary lists and arbitrary element types.
`List.Nodup.getD_inj` gives injectivity of bounded list lookup for a
duplicate-free list; both indices must be strictly below its length.

`SimpleGraph.Walk.length_mapLe` preserves the length of a walk when
regarded as a walk in a supergraph on the same vertices. The existing
`support_mapLe_eq_support` is also made a simplification lemma.
`SimpleGraph.Walk.length_tail` gives the length after dropping the first
edge, using natural subtraction so that it also covers the empty walk.
`SimpleGraph.Walk.IsPath.map` preserves a path under an injective graph
homomorphism; injectivity is an explicit hypothesis, not an assumption
about arbitrary graph maps.
`SimpleGraph.Walk.getVert_append'` gives the vertex at index `i` of an
appended walk, using the first walk when `i <= p.length` and otherwise the
second walk at index `i-p.length`. At equality both walks give their
common endpoint, so this is equivalent to the older strict-inequality
version.

`SimpleGraph.cycleGraph_isContained_iff` states, for every natural `n > 2`
and every simple graph on any vertex type, that a non-induced copy of
`cycleGraph n` is equivalent to a closed walk that is a simple cycle and
has length exactly `n`. The reverse direction constructs an injective
adjacency-preserving map using the entries after the initial vertex of
the walk. This is a backport of the proposition and proof in Mathlib's
`Mathlib/Combinatorics/SimpleGraph/CycleGraph.lean`, lines 167--186, at
commit `d13f23b723b8a846827a245b89c10fc7d3f11612` (Apache-2.0). The source
passage is retained in the third-party source archive, and the backport
must itself compile; citing the newer library is not an assumption that
the backport is correct.

These are compatibility facts, not a new Ramsey result or independent
review. Their transitive axioms must be confined to `propext`,
`Quot.sound`, and `Classical.choice`, just like the main certificate.
