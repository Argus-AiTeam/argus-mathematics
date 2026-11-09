# Statement fidelity: ReversalAudit

This document describes the declarations in `Main.lean`. They form an
exact, universally quantified technical core of the mathematical proof
in `proof.md`, not a formalization of the full AEC reversal theorem.
There are no AECs, categoricity spectra, EM functors, or constructed
ordinal-support closures in the formal statement. Those objects and
the discharge of the four manuscript obligations are proved in prose
in Sections 1-6 of `proof.md` and still require independent review.

## Coefficient codes

`ReversalAudit.SamePattern x y` means that two families of ordinal
positions, indexed by the same arbitrary type I, have identical strict
order comparisons for every ordered pair of indices. The formal
positions range over arbitrary ordered types, so ordinals are a valid
instance. `ReversalAudit.equality_transport` proves that this also
preserves equality when those types are linear orders.

`ReversalAudit.LeadingLT positions c d` says that at some index i
the coefficient of c is strictly less than that of d, while the
coefficients agree at every position strictly greater than position i.
`ReversalAudit.leadingLT_transport` proves its equivalence before and
after a SamePattern change of positions, for arbitrary coefficient
types equipped with strict comparison.

`ReversalAudit.NestedLT` applies this comparison to integer rank
codes, then compares rational coefficients at a greatest differing
rank. `ReversalAudit.nestedLT_transport` proves exact equivalence
under the position change. `ReversalAudit.InSlot` requires strict
comparison above every lower parameter and below every upper
parameter, with the sides specified by an arbitrary predicate on an
arbitrary parameter type. `ReversalAudit.slot_transport` proves
equivalence of all these inequalities simultaneously.

For the H(T) application, I enumerates the union of ordinal positions
in all parameter and witness codes; J enumerates their distinct
integer rank vectors. The families of positions are injective, each
integer row has finite support, and each rational vector has finite
support. On these instances LeadingLT and NestedLT are precisely the
manuscript's greatest-differing-coordinate orders. The formal
transport identities do not require finiteness, and are consequently
stronger as identities about codes. The passage from finite codes to
actual group elements, and the existence of the matching position
family in T, are explained and proved in `proof.md`, Section 4.
They must not be inferred from the compiler verdict.

## Ordinal capture, with its cardinal hypothesis visible

`ReversalAudit.bounded_stages` quantifies over an arbitrary ordinal
delta in universe u and an arbitrary type T in the same universe.
Its hypotheses are mk(T)<cf(delta) and a stage below delta for each
t in T. Its conclusion gives one ordinal i<delta above all stages.
It uses Mathlib's kernel-checked ordinal supremum/cofinality theorem.

`ReversalAudit.tuple_capture` takes an increasing family of subsets
A indexed by ordinals and a tuple indexed by T. If every coordinate
lies in some A_i with i<delta and mk(T)<cf(delta), it proves that
all coordinates lie in one A_i with i<delta. No continuity of A is
assumed. In the proof application delta is the initial ordinal of
theta^+, T indexes theta coordinates, and regularity of theta^+
supplies the displayed strict inequality. The theorem does not impose
cofinality restrictions on either categoricity size a or mu.

## Orbit arrows and the two-scale conclusion

`ReversalAudit.Excluded R p q` is exactly not R(q,p). In this
section Q is any type of names, not a finite set.
`ReversalAudit.excluded_forward` proves preservation along a direct
R-arrow using transitivity. `ReversalAudit.eliminate_orbit` assumes
reflexivity, transitivity, R(p,r), and not R(r,p); for every q it
constructs q' with R(q,q') and not R(q',p).

`ReversalAudit.limit_persistence` quantifies over an arbitrary
preordered stage type. It explicitly requires a direct transition
R(name_i,name_j) for every i<=j, not just for consecutive stages.
It proves exclusion at every later stage. For the manuscript this
direct-arrow hypothesis is furnished by strong inclusion into a
mu-sized categorical union, including at a limit, as proved in
`proof.md`, Section 6. Successor-only preservation is not assumed to
imply limit preservation.

`ReversalAudit.covered_union_exclusion` assumes a covering family
of stage tuple sets, an excluded processed name for each covered
tuple, and a handoff consisting of an arrow to an aligned small
name followed by an arrow to its final small name. It proves all
final names are excluded. `ReversalAudit.elimination_contradiction`
adds reflexivity and occurrence of p among final names and derives
False.

`ReversalAudit.ordinal_elimination_contradiction` incorporates
tuple_capture, rather than assuming tuple capture as an unexplained
property. Its arbitrary type C indexes coordinates and satisfies
mk(C)<cf(delta). T indexes the tuples under consideration; X is
the element type, and coordinates:T->C->X gives each tuple.
The increasing sets A_i cover every coordinate before delta.
The processed and aligned names have stages i<delta. The theorem
assumes the explicit cleared and handoff conditions and occurrence
of p in the final model, then derives False. Sections 5-6 of
`proof.md` supply, rather than merely postulate, those conditions
for the AEC construction.

The compiler establishes these conditional technical theorems with
their stated hypotheses. It does not independently establish the
existence of aligned models, the palette pigeonhole construction,
or the infinite round construction. Therefore only the combined
technical-core claim receives mechanical evidence. The unrestricted
reversal claim receives a separate mathematical judgement based on
the complete prose argument and must be independently reviewed.
