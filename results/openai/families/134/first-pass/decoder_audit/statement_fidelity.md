# Statement fidelity: the separated-marker decoder

## What is and is not certified

`Main.lean` proves a universally quantified decoder theorem package in
namespace `DecoderAudit`. Its inputs are finite sets of integer marker
positions, integer search parameters, finite candidate/slot sets, periodic
continuations, and a uniform clock obstruction estimate. It is not a
formalization of generalized regular expressions, finite-monoid split
identities, the local priority algorithm constructing markers, the torus
clock construction, or the height-three main theorem.

The abstract marker sets are not an arbitrary relaxation used to produce
a counterexample. Every actual manuscript configuration restricts to
these finite sets on its finitely many inspected marker-position
intervals. `search_locality` and `end_search_locality` prove that adding or
removing markers outside the eligible search intervals cannot alter a
search. Marker decisions inside those intervals still require the
manuscript's full letter inspection windows. Their availability on the
suffix side is an upstream application obligation, not a result of Lean
compilation.

The top-level ledger claim `C_DA_CORE` is this conditional-in-its-formal-
hypotheses mathematical theorem package. There are no additional
unrecorded external mathematical assumptions in that claim. The claim
`C_DA_APPLICATION` applies the package to the staged manuscript and retains
the local marker, clock, and internal-window inputs explicitly.

## Integer objects and search semantics

All positions, displacements, widths, periods in the seed lemmas, and
endpoints are integers (`ℤ`), not natural-number truncations. Finite
cardinalities and copy counts are naturals (`ℕ`). The clock budget comparison
uses real numbers only to match the manuscript's real logarithmic bound.

`Separated markers d` says that any distinct marker positions are at
distance **at least** `d`. `First markers z m` says that `m` is a marker
on or after `z` and is no later than any other such marker.
`firstAfter` returns that least marker or `none`. `search markers z width`
returns it exactly when it is on or before `z + width`.
`search_as_least` proves that this is precisely the least marker in the
inclusive interval `[z,z+width]`, including empty intervals and absent
searches.

`Eligible center base step B m` is exactly

    abs(m - center) <= base + ((m - center) % B) * step.

The end-search radius is indexed by the **marker's displacement residue**,
not by a guessed endpoint or a residue chosen independently of the marker.
`endSearch` returns the least eligible marker. The application takes
`base = d_bullet` or `3*d_bullet`, `step = S_bullet`, and positive modulus
`B`. Positive-modulus integer remainder is the manuscript's representative
in `{0,...,B-1}`.

`clockAnchor ... mismatch` is the larger-search return when present and
the supplied mismatch otherwise. No theorem equates a present larger-
search return with the smaller-search return or the mismatch.

## The anchor bound, without assuming an anchor census

`anchor_returns_le_two` starts with separation of the marker set and
eligibility sandwiched between an outer interval and a common inner
interval. Its hypotheses state that the left and right fringe widths
are each less than the marker separation. They do **not** bound the
number of returned markers. Its conclusion bounds the set of all
possible least eligible returns by two.

`eligibility_sandwich` derives those interval hypotheses for the actual
residue-indexed eligibility rule, using only
`-h <= delta <= h`, `B > 0`, and `step >= 0`.
`actual_anchor_list_le_three` then proves that the possible larger-search
returns, together with a single shared mismatch, number at most three,
provided `2*h + (B-1)*step < d`.

The returned set is taken over **all** members of the supplied finite
index set. It need not have injective displacements for this result, so
the same theorem includes all identical-slot pairs at displacement zero.
This improves, rather than assumes, the manuscript's bound twenty.

## The four end-instability contributions

`EndBad` means that one of the two actual least-eligible end searches
changes under some integer shift divisible by `B` with absolute value
at most `wiggle`.

`interval_boundary_crossing` proves that a change in fixed-radius
eligibility under such a shift has a marker within `wiggle` of one of
the two unshifted interval boundaries. `end_change_has_crossing`
derives the applicable residue-indexed crossing event from an actual
change in the least search return. It uses divisibility by `B` to keep
that marker's width index fixed.

`end_cross_le_one` proves a bound one for each fixed search and sign.
Its inputs are marker separation, displacement range, injectivity of
displacement residues on the index set, the short crossing strip
inequality, and `step > 2*h + 2*wiggle`. No per-sign cardinality bound
is a premise.
`end_failures_le_four` derives the union bound four for the two searches
and their two signs.
`end_schedule_constraints` proves these inequalities, and the nested-
search gap, from the manuscript's actual lower bounds on `S_bullet`
and `d_bullet`.

## The three inner-marker contributions per fixed anchor and label

`InnerBad` is precisely the disjunction of:

1. a change of the inclusive first-marker search under some shift
   of absolute value at most `wiggle`, with the width fixed;
2. an absent search whose interval extended on the right by `ext`
   contains a marker.

`inner_bad_cover` derives that such a failure either has a marker within
`wiggle` of the left endpoint (`LeftFailure`), or has the first marker
on or after the unshifted left endpoint within `radius` of the right
endpoint (`RightFailure`). Here `radius >= wiggle, ext`.

`left_failure_le_one` derives the single left-endpoint contribution
from the short marker sweep and the displacement spacing.
`first_values_le_two` derives at most two possible first-marker values
over a sweep shorter than the marker separation. It does not assume
their number. `right_failure_le_two` combines that result with
pairwise right-endpoint spacing to derive the other two contributions.
`inner_failures_le_three` combines these results.

`residue_injective` proves that distinct displacement residues remain
distinct after the transformation `delta -> (Q-t-delta) % B`.
`width_endpoint_spacing` derives spacing of the actual right endpoints
from the schedule's width spacing and displacement range. Thus width
injectivity is not replaced by a hypothesis about correct metadata.

## Whole-stencil bound and clock contribution

`whole_stencil_bound` is quantified over an arbitrary finite index set
`s`, which in the manuscript is the set of all ordered **distinct**
slot pairs. `delta (p,p') = p-p'`.

Its clock premise is a raw uniform per-translate roster bound by a
natural number `C`. It does not assume any combined exceptional-origin
bound. `clock_pair_formula` proves the additive identity converting
`phi(Q-t-delta)` into the roster expression
`phi(Q-t)+phi(p')-phi(p)`. The torus clock lemma and realization of the
roster are upstream, explicitly open application dependencies.

For each fixed actual anchor and each label, the theorem invokes the
derived inner bound three. It constructs its own anchor set and invokes
the derived bound three on that set. Taking the finite unions gives

    exceptional ordered distinct-slot pairs
        <= 4 + 3 * (C + 3 * labels.card).

Neither the anchor count nor the end or inner failure counts is a
formal premise. `card_biUnion_le_mul` supplies the finite-union
cardinality argument.

For the manuscript `labels = {0,...,g}` and
`C = floor(c_cl * log(2*m))`. A natural-number count bounded by that
real clock bound is bounded by its floor. `manuscript_budget` proves
that the manuscript's original strict multiplicity inequality implies
the strict bound needed for the stronger census. The theorem does not
silently replace `mu > ...` by a non-strict inequality.

## Pre-uniqueness survival and endpoint rules

`periodic_agree_interval` proves, for arbitrary alphabet type, that
two bi-infinite periodic functions with positive integer periods `a,b`
which agree on `a*b` consecutive positions agree everywhere. Its proof
uses their common period `a*b` and integer Euclidean division.
`seed_continuations_equal` derives a common continuation from the
actual overlapping seed intervals and short periods.
`seed_overlap_schedule` derives the needed overlap inequality from
`K > 3*d*d` and `2*h < d`.

`FirstMismatch word continuation start q` says that `q >= start`,
the letter at `q` differs, and every letter from `start` up to but
not including `q` agrees. `first_mismatch_unique`,
`first_mismatch_transport`, and `reference_mismatch_sound` derive
uniqueness and transfer across overlapping seeds.

`EndRule` distinguishes its two branches exactly: a present smaller
search fixes `endpoint = returned_marker + tail`; an absent one fixes
`endpoint = first_mismatch + tail`. It does not use the larger search
as an endpoint.

`absent_large_forces_absent_small` proves the nested-search implication
over every pair of candidate origins, using the actual residue-indexed
eligibility rule and `small+(B-1)*step+2*h < large`.
`reference_guard_forces_endpoint` then derives equality of proposed and
actual endpoints in the absent-larger-search branch from seed agreement,
periodicity, the actual episode rule, and the reference end guard.
`actual_reference_guard_passes` proves the converse required on actual
suffixes; a successful actual reference guard is not assumed.

`decoder_pre_uniqueness` proves true-candidate witness survival from
membership in the actual exceptional domain. If some larger search is
absent, it invokes the reference-guard theorem. Otherwise the true larger
search is present, and `anchor_before_uniqueness` shows that its return
is independent of any proposed endpoint. This branch imposes **no**
marker-present requirement on the smaller search, no bounded endpoint
assumption, and no correctness requirement on independently chosen
metadata.

`decoder_success_and_endpoint` derives the actual decoded slot by
uniqueness using that pre-uniqueness theorem. Only then does it use the
mandatory final decoded-origin `EndRule`; `end_rule_unique` proves exact
endpoint consumption. The final guard is required in both branches.
The simpler helper `decoder_sound` is not being used to assume witness
survival: the substantive theorem derives it through
`decoder_pre_uniqueness`.

## Surviving every kind

`failed_slots_le_false_pairs` proves the cardinality bound by identifying
unsuccessful rows with the first-coordinate projection of the set of
additional witnesses. `every_kind_survives` uses exactly `mu` copies of
a kind and fewer than `mu` bad rows.
`stencil_completeness` and `surviving_copy_has_unique_witness` combine
these facts, giving a copy of every kind with exactly one witness when
the true diagonal is always a witness. That diagonal property is
supplied by the already proved actual-suffix pre-uniqueness theorem
and the definition of the exceptional domain, not by guessing correct
metadata at false origins.

## Remaining reading obligation

`end_margin_internal` verifies the decisive endpoint margin arithmetic.
`missing_window_rejects` records the rejection semantics, rather than
permitting a candidate with unavailable data to disappear.

The Reviewer must still check that the staged word construction supplies
the recorded upstream marker, clock, and mandatory-window premises and
that this document faithfully describes the declarations. Lean verifies
the statements encoded here; it does not adjudicate novelty, publication
significance, the correctness of this reading, or the remaining
star-height proof graph.
