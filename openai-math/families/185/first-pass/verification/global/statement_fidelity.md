# Statement fidelity: the unconditional main theorem

`Main.lean` verifies `thm:main` of the staged September 24, 2026 manuscript,
not the intersection corollary or the separate universal conjectures.
All imported construction proofs are from `openai/math` commit
`4eaee87548250b2682affda7d05d947c05554bae`. They are proof implementations,
not additional assumptions. The approved local interval sources and their
compiler artifacts are reused unchanged. The global import closure is
compiled with Lean 4.31.0. Generated proof-only compatibility edits
are recorded by `verify.py`: the old set-membership lemma name is
`Set.mem_setOf_eq`, positive dependent/nondependent conditional reduction
uses `dif_pos`/`if_pos`, and the well-founded minimum bound is
`WellFounded.min_le wellFounded_lt`. These are the corresponding
v4.31.0 library lemmas; no theorem statement or hypothesis changes.

## Objects and hypotheses

`D = (m : Nat) times ((Fin m -> Bool) -> Bool)` is the manuscript's
disjoint union of finite truth-table blocks, of size `2^(2^m)`.
`E0 = D times Bool` has `false = L` and `true = R`;
`E = Int times D` is the countably infinite labelled double-ray ground
set. `Countable E` and `Infinite E` are both conclusions, not hypotheses.
Matroids are Mathlib's actual infinite `Matroid` structures, including
maximal extension, not a basis-exchange proxy.

`KSmall X` means that `X` intersected with finitely many positive
`AColumn` columns has block density tending to zero. `KIdeal` is this
proper ideal. `CIndex` is the order type of the initial ordinal of the
continuum, not a regular-cardinal assumption. `rank` takes values in
this well-order; its values on ultrafilter nonmembers are never used
by an admissibility or descent assertion.

`concrete_rank_certificate` existentially supplies the ultrafilter
avoiding this concrete ideal, containing all `GColumn`s, satisfying
the finite-column condition, and its actual `RankModel`. Its proof uses
finite-intersection ultrafilter extension and the least-index rank,
not a postulated `RankModel`. `ordinalRank_thinning` and
`finite_union_small` are separately included in the transitive axiom
audit. These proofs use choice, but neither MA, CH, nor regularity
of the continuum.

`reservation_certificate` quantifies over every type of cardinality
strictly below the continuum and every family of positive doubled-block
sets indexed by it. It returns one index whose two concrete cells are
disjoint, small for the larger two-slice ideal, and each meet every
family member positively for the density-zero ideal. Empty families
are permitted. `HCell t false` and `HCell t true` are precisely the
lifts of `A_t^c intersect B_t^c` and `A_t^c intersect B_t`.

## Assembly and maximal extension

`unconditional_local_matroid` has no hypotheses. It existentially
constructs both the concrete rank model and a `BasisSystem` using
`RankModel.exists_basisSystem`, whose proof carries out the continuum
recursion. It does not assume either object's existence. Every base
is admissible. Single balanced swaps and the interval alternative
supply exchange and maximal extension, including the finite-gap case.
The displayed conclusion spells out (IM) for every independent
`I subset Y`, with a maximal independent `J` between them.

The theorem also proves `S.matroid.dual = S.matroid` as equality on
`E0`, not isomorphism. Its basis inequality is
`rank (complement (slice B true)) < rank (slice B false)` whenever
the left slice is large. Both ranks are then evaluated on large sets.
The first admissibility case is exactly this inequality; the second
case cannot occur when the left slice is large.

## Coordinates and minor conventions

`orientation_bridge` proves the manuscript's complete coordinate table:
at negative vertices, `L=e_n, R=e_(n-1)`; at nonnegative vertices,
`L=e_(n-1), R=e_n`. In particular both middle vertices have `e_(-1)`
as their left coordinate. The bijection used by `rayMatroid` retains
the same `d : D` label in each bundle. The imported component
independence and ray-step lemmas use these precise maps.

`contraction_onto_bridge` proves, for full-ground matroids,

    M.contract (univ \ C) = (M.dual restricted to C).dual.

Thus contraction is onto `C`, not contraction of `C`. The hypothesis
`M.E = univ` is explicit and is proved for both matroid witnesses.
`ManuscriptPackingCovering` uses actual restrictions, closure equal
to `P`, and independence in the actual contractions of `univ \ C`.
`packing_covering_bridge` proves its equivalence with the implementation's
`HasPackingCovering`, including all subset and disjointness conditions.
No equality or minor convention is replaced by an isomorphism.

## Final conclusion and limits of certification

`manuscript_main` unconditionally constructs two full-ground matroids
on the *same* `E`. Each is equal to its dual on these labels. For every
pair of independent sets, their union differs from `univ`; they need
not be disjoint or bases. The proof reduces a hypothetical covering
to a partition, propagates the ultrafilter along one of the two outward
rays, and obtains a strictly decreasing sequence in the well-order
`CIndex`. The mixed packing/covering exclusion uses the complete
self-dual reduction, not just the two pure cases.

Lean checks the full infinite theorem and its transitive axioms.
The rational finite-pattern computations in `verify.py` are supplementary
experiments only; they do not prove an ultrafilter or a transfinite
recursion. The source-to-manuscript identification in this document
still requires the independent Reviewer's mathematical reading.
This is independent machine checking of an existing manuscript result
with explicit statement bridges, not a claim that the mathematical
counterexample or its proof strategy is new.
