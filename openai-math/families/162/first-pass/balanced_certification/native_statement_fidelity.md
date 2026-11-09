# Statement fidelity: full balanced theorem, native Lean 4.34.1

The declaration `balanced_manuscript_statement` in `NativeMain.lean`
states the balanced manuscript's entire Theorem `thm:main`, not a
fixed finite example and not an extension-field result. Its proof
is the pinned upstream declaration `OAI.Balanced.main_result`.

The quantifiers are `exists q0 : Nat, forall q : Nat,
q0 <= q -> q.Prime -> exists H`. The threshold is chosen before q
and does not depend on q. No numerical threshold is asserted.
The field order is a natural prime q, not an arbitrary prime power.
The number of parts and the size of each part are both q+1.

The definitions printed by the compiler and present in the pinned
`Model.lean` are:

* `PartiteHypergraph r n`: a finite set of functions `Fin r -> Fin n`.
* `Vertex r n`: `Fin r x Fin n`. Part i is `{i} x Fin n`.
* `Covers H C`: for every edge function e, some `(i,e i)` lies in C.
  C is any finite vertex set, with no one-part restriction.
* `Intersecting H`: the edge set is nonempty and every two edge
  functions agree in some coordinate.
* `Nonisolated H`: every pair `(i,v)` occurs on an edge.
* `HasCoverNumber H k`: there exists a cover of cardinality k and
  every cover has cardinality at least k.

Replace each edge function e by its graph `{(i,e i) : i in Fin r}`.
The parts are disjoint, each part has cardinality n, and every edge
contains exactly one vertex from each part and has cardinality r.
The graph map is injective, so these are ordinary finite
set-hypergraphs. Two graph edges meet exactly when their functions
agree in a coordinate. A vertex set hits every graph edge exactly
when `Covers` holds. Nonisolated means every declared vertex belongs
to a graph edge. Hence the printed formal conclusion gives exactly
the ordinary finite-hypergraph conclusion in the manuscript.

The independent Lean 4.31.0 source `Main.lean` proves the generic
graph-cardinality, graph-injectivity and ordinary-cover equivalence
statements in `Audit162.PartiteHypergraph`. Its definitions are the
same displayed finite-function definitions, rather than a weaker
proxy. The coordinate argument above supplies the direct reading
of the upstream namespace as an ordinary hypergraph. No claim is
made that the Lean 4.31.0 source reproves the asymptotic construction.

`NativeMain.lean` prints the transitive axiom answer for the full
statement. The replay gate allows only `propext`, `Classical.choice`
and `Quot.sound`; source scans alone are not substituted for that
answer. The 668 upstream source modules are bound to their public
revision before being compiled. Mathlib and its packages retain
their native pinned versions. Their standard cache is a trusted
library-build input, not a purported independent rebuild of Mathlib.

This document states the intended reading, not an independent
Reviewer verdict. It asserts neither a new construction nor novelty
or publishable significance; those are not compiler conclusions.
