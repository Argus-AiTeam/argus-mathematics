# Statement fidelity: finite noncrossing support kernel

This document describes precisely the declarations in `Main.lean` attached to
claim `AF_KERNEL`. Natural numbers `m`, `k`, `p`, and `t` are universally
quantified, including zero. Positions are `Fin m`; labels are `Fin p`.

`AnalyticFisher.NoncrossingPartition R` is the following relational property:
for ordered positions `a < b < c < d`, `R a c` and `R b d` imply `R a b`.
The intended application takes `R` to mean membership in the same block of a
noncrossing partition. The definition does not additionally demand that `R`
be an equivalence relation; the proved implication needs no such assumption.
`NoCrossing Q` forbids `Q a c` and `Q b d` at four such positions.

`AnalyticFisher.noncrossing_union` assumes that `Q` refines `R`, that `R`
has the displayed noncrossing-partition property, and that crossing `Q`
pairs cannot have their first endpoints in the same `R` block. It concludes
that `Q` has no crossing. In the application, `Q` is the union of pairings
chosen inside the blocks of a noncrossing partition; the last hypothesis is
exactly the noncrossingness of each chosen within-block pairing. No algebraic
moment or cumulant identity is assumed or proved in this declaration.

`AnalyticFisher.PairConstant a b f` says that a labeling `f` has equal values
at the two endpoints `a j`, `b j` of every listed pair.
`AnalyticFisher.pairing_label_bound` assumes that the `k` listed pairs cover
all `m` positions and proves that the finite type of pair-constant labelings
has cardinality at most `p^k`. It proves this by the injective map recording
one endpoint label per pair. Disjointness and distinct endpoints are not
required, so the theorem applies in particular to perfect pairings.

`AnalyticFisher.family_pairing_label_bound` takes `t` such covering lists
and proves that at most `t*p^k` labelings are constant on at least one of
them. Its proof uses a surjection from the disjoint union of the individual
types, followed by the preceding cardinality bound. This is the all-order
label-counting step used with `m=b`, `k=b/2`, and a family of noncrossing
pairings of the `B` positions.

These are load-bearing combinatorial statements, not numerical comparisons
of entropy bounds. They do **not** formalize the construction of
noncrossing lattices, Catalan enumeration, the moment-cumulant formula,
the tensor-product moment law, Wick testing, conditional expectations,
infinite-series convergence, Fisher information, or entropy. Those parts
are proved in `report.md` using the stated background results and remain
subject to independent mathematical review. A successful compiler run on
`AF_KERNEL` must not be reported as a kernel proof of the whole analytic
theorem or of the manuscript's main entropy separation.
