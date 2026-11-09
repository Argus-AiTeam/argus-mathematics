# Statement fidelity: C_PP_CORE

This file describes only the declarations in `PartialPathCore` in `Main.lean`.
It does not translate the full coherator theorem into Lean.

`Shape.node p children` is a finite recursively branching string of p suspended
inner shapes; p=0 denotes one vertex. This is the recursive description of
nonempty finite globular-sum shapes used in `lem:spine`. `Cell 0` is the set
of p+1 outer vertices. `Cell (k+1)` is the disjoint union of the k-cells
of the p inner shapes. Thus `Cell` denotes actual generating cells of the
finite raw shape, not all cells of its free algebraic model.

`spine m` replaces every inner shape at depth m+1 by its first vertex, as in
the manuscript recursion. For every shape, every m,k with k<=m,
`lowCellEquiv` supplies mutually inverse maps `retain` and `recover` between
the generating k-cell sets of the shape and its spine.
`recover_retain` and `retain_recover` prove the inverse laws.
`source` and `target` are the actual globular face maps in the recursive
shape. `source_globular` and `target_globular` prove their globular
identities in every dimension. For k+1<=m, `retain_source` and
`retain_target` prove that the low-cell bijections commute with both
faces, so these bijections preserve the entire globular structure
through m, not only the cardinalities.
For every shape and m,k with k>m+1, `noHighCell` proves that the spine has
no k-cells. The formal file does not prove that the spine inclusion is
a composite of globular source pushouts; that part is proved in Section 2
of the report and replayed in the finite script.

`uniqueFillerOperation` quantifies over arbitrary types A,B,C, a bijective
boundary map C->B and any prescribed boundary function A->B. It proves
existence and uniqueness of an operation A->C with that boundary. In the
application, A is a tuple type of any arity and C->B is a unique-filler
boundary map above a cutoff. No bound on A or an arity dimension occurs.
The theorem does not construct the coskeletal globular completion itself.

`naturality_comp` proves that two composable commuting function squares
give the commuting composite square, with six arbitrary object types.
`naturality_of_jointly_injective_legs` proves equality of two maps into an
arbitrary tuple type T when all jointly injective component functions agree.
Neither declaration assumes that a composite face has small arity.
They certify the congruence calculations used for already interpreted
composites and matching tuples, not the free-globular-completion universal
property or the Yoneda representation theorem.

`WeakRules` is a morphism property on an arbitrary category, with identity,
composition, and both cancellation directions of two-out-of-three.
`generatorPromotion` assumes only these rules, W(a0), and the four equations
from the manuscript's duplicate-generator diagram:
a0;r=id, a1;r=id, a0;h=id, a1;h=gf, where semicolon is diagrammatic
composition. It concludes W(gf). The existence and correct boundaries of
these diagram maps are not premises claimed to have been constructed in Lean.
They are established in Section 3 of the report. In particular W(gf), path
functor existence, and tree contractibility are not assumed by this declaration.

`DomainRetractClosed` states closure under an arrow retract with identity
codomain maps. For every category and W satisfying `WeakRules` and this
closure, `expansionRetract` assumes i;r=id, W(u), and W(r;u;i), and concludes
W(i). These are exactly the final retract and cancellation consequences in
the descending induction. This is not a proof of the existence of the
endpoint sections or the lifted map supplying W(r;u;i).

The kernel therefore checks a conjunction of universal combinatorial and
categorical core lemmas. It does not check the whole report, the geometric
completion, any literature attribution, the specialization to actual
coherator models, or novelty and significance. Independent Reviewer approval
of this reading and of the remaining mathematical proof is still required.
