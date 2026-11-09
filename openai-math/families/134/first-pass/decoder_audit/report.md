# Exact decoder audit

## Scope and sources

The target is `decode:anchor-list`, `decode:sparsity`, and `decode:decoder`
in the staged *Generalized Star Height at Most Three*, dated September 25,
2026. A counterexample to these assertions is not automatically a
counterexample to the numerical star-height bound. Conversely, verifying
the decoder does not verify the two split constructions or their
height-one compilation.

The sources are the complete local `build/sections/*.tex` trees under
`research/openai_manuscript/`. They are authoritative for this audit.
The directory names and dates identify the versions examined; no immutable
upstream commit was supplied. No claim is made that the sources are
published, peer reviewed, or externally formally verified. The reported
`sorry` in an upstream comparator is not mathematical evidence against any
of these statements, and this work does not rely on that comparator.

The wiki index contains no star-height, decoder, or stencil entry. No
external literature theorem is needed for the integer/counting argument
below. In particular, Krieger's marker lemma is not silently substituted
for `marker:local`: the manuscript gives the exact finite-window marker
statement and its proof. The robust clock is likewise a separately proved
manuscript lemma, not an automatic consequence of ordinary clock
compatibility.

The application to words uses the following explicitly separated inputs.

* `marker:local`: markers are separated by at least the relevant integer
  scale; absence of markers in the prescribed neighbourhood gives a
  short-period seed.
* `marker:periodic`: sufficiently overlapping short-period seeds determine
  the same two-sided continuation.
* `schedule:clock-roster`: the realized roster has a uniform
  distinct-ordered-pair obstruction bound at **every** clock translate.
* `schedule:stencil-properties`, `schedule:width-spacing`,
  `episode:marker-parameters`, and `episode:end-widths`: the actual
  displacement separation, distinct residues, search widths, and margins
  are hypotheses, not a relaxed freely chosen marker model.
* `schedule:margins`: all candidate and shifted inspections are internal
  to the first actual episode and available after an early cut.
* `episode:seed`, `episode:endpoint`, and `episode:clock-anchor`: the
  mismatch anchor defining the endpoint is distinguished from the clock
  anchor. An absent smaller search and a present larger search are legal.

These are not conclusions supplied by a counterexample search. Their
status and their role in applying an abstract theorem are kept separate
in the claim ledger. Mandatory-window rejection, the reference end guard
in the absent-larger-search branch, and the final decoded-origin end guard
in **both** branches are part of the decoder being audited. Removing any
of them changes the question.

## Main dependency chains

All labels below are manuscript labels, not inferred theorem numbers.
Paths are relative to the indicated manuscript's `build/sections/`.

### Height three

`introduction.tex`, `thm:main`, asserts the bound three over the original
alphabet. Its chain is:

1. `algebra.tex`: `alg:split`, `alg:affine-recovery`,
   `alg:homogeneous-lift`, and `alg:shift-table`.
2. `clock.tex`: `clock:robust`; `markers.tex`: `marker:local` and
   `marker:periodic`.
3. `schedule.tex`: finite choices, `schedule:inner-cuts`,
   `schedule:periodic-cuts`; `episodes.tex`: `schedule:margins`,
   `episode:prefix-code`, and `episode:shared-end`.
4. `outer-split.tex`: `outer:split`, with the intrinsic skip domain
   `outer:exceptional-domain`.
5. `decoder.tex`: `decode:anchor-list` -> `decode:sparsity` ->
   `decode:decoder`, also depending on marker separation, width/residue
   spacing, the uniform roster estimate, and the actual end guards.
6. `inner-split.tex`: `inner:total-table`, `inner:actual-table-entry`,
   `inner:split`; these depend on the decoder and arbitrary-function
   shift tables, not merely on a feasible-prefix table.
7. `compilation.tex`: `compile:templates`, `compile:components`,
   `compile:remainder`; the final assembly uses two splits, with height
   progression `0 -> 2 -> 3`, then affine recovery and the unique
   episode/remainder factorization.

### Height four

`01-introduction.tex`, `thm:main`, asserts the bound four. Its chain is
`02-algebra.tex` (`lem:split`, `lem:affine-recovery`, `lem:affine-line`)
and `03-clock.tex` (`lem:clock`) -> `04-scales.tex`
(`lem:markers`, `lem:periodic-extension`, `lem:boundary-transport`,
`prop:inner-ambiguity`) -> `05-episodes.tex` (`lem:end-ambiguity`,
`lem:placement`, `lem:prefix-code`, `lem:end-guard`) ->
`06-splits.tex` (`prop:main-split`, `lem:table-lift`,
`lem:sequence-lift`, `prop:aligned-splits`,
`prop:recursive-recovery`) -> `07-compilation.tex`
(`lem:templates`, `prop:components`, `lem:remainder`) and the final
recursive assembly. This is a multiscale/product-transport construction,
not the height-three whole-stencil decoder.

### Height thirteen

`introduction.tex`, `thm:main`, asserts the bound thirteen. Its chain is
`algebra.tex` (`lem:split`, `lem:affine-recovery`, `lem:prediction`)
and the clock -> `geometry.tex` (`lem:markers`,
`lem:periodic-overlap`, `lem:search-crossings`, `lem:prefix-code`,
`lem:shared-anchor`, `lem:decoded-end`) -> `outer.tex`
(`lem:main-split`, `lem:periodic-split`, `lem:witness-coverage`) ->
`aligned.tex` (`lem:total-tables`, `lem:time-decoder`,
`lem:bad-histories`, `lem:aligned-stage`), with simultaneous parameter
existence supplied by `parameters.tex`, `prop:parameters` ->
`compilation.tex` (`lem:template`, `prop:component-cost`,
`lem:final-suffix`) and five aligned stages followed by the two outer
splits. The numerical results of the companions are comparison statements,
not premises in one another's proofs.

## Baseline and exclusions

The initial ledger had only the campaign objective and no mathematical
evidence or decomposition. Thus no prior proved decoder theorem is being
silently reused. A finite marker search, an invalid relaxed-model witness,
and an incomplete comparator cannot certify this mission. None is used as
a terminal result here.

## Universal verification theorem and strengthening

Let `P` be the actual finite stencil, let `J=g+1`, and let `C` be an
integer upper bound for the clock obstruction count at every translate.
For every finite restriction of the actual inner and end marker sets
containing all inspected positions, the decoder has the following bounds:

    distinct larger-search returns <= 2
    clock anchors, including the shared mismatch if used, <= 3
    false ordered distinct-slot exceptional pairs <= 4 + 3(C + 3J).

The hypotheses are the actual marker separation, distinct displacement
residues, displacement and width spacings, uniform clock estimate, and
seed/endpoint rules stated above. No anchor census, per-cause failure
count, correct metadata, correct proposed endpoint, or successful actual
reference guard is assumed.

This improves the manuscript's twenty-anchor census. The proof does not
alter the schedule. In particular, its original multiplicity choice
still implies the strict inequality needed here. On actual suffixes
fewer than `mu` rows have an additional witness, so every kind retains
a copy with exactly one witness. A successful arbitrary proposed suffix
decodes the true slot and consumes exactly the first episode.

### Proof of the improved anchor census

Write `c=z_bullet(t)`, `A=3d_bullet`, and
`s=(B-1)S_bullet`. Every eligible marker at a translated origin with
`|delta|<=h` lies in

    [c-A-h-s, c+A+h+s].

Every marker in the common core

    [c-A+h, c+A-h]

is eligible at every such origin, whatever its residue. Each fringe has
width `2h+s<d_bullet`, so each contains at most one marker.

If the core contains a marker, let `q` be its first one. A least eligible
return is either the unique left-fringe marker or `q`: it cannot lie
after `q`, and a return in the core must equal `q`. If the core contains
no marker, a return lies in one of the two fringes. Thus there are at
most two present returns in either case. Adding the single common
mismatch gives at most three anchors. This proof works for arbitrary
residue-dependent eligibility between the same inner and outer
intervals, a structural generalization of the stated search rule.

`anchor_returns_le_two`, `eligibility_sandwich`, and
`actual_anchor_list_le_three` certify these steps in Lean. In particular,
the number three is a conclusion, not a formal premise.

### Four end-instability contributions

A changed least-search return implies a change of at least one marker's
eligibility. During a shift divisible by `B`, that marker's residue index
is fixed. The changed membership therefore puts the marker within `w`
of the old left or right boundary. For each fixed search and sign,
all possible such markers lie in a strip of diameter at most

    2h + (B-1)S_bullet + 2w < d_bullet.

There is at most one marker in that strip. At this fixed marker, distinct
ordered-pair displacements have distinct width indices. Their target
positions are separated by at least `S_bullet-2h>2w`, so at most one
ordered pair is charged. The two searches and two signs give four.
`end_change_has_crossing`, `end_cross_le_one`, and
`end_failures_le_four` prove this from the actual least-search definition.

### Three inner-marker contributions at a fixed anchor and label

For a fixed anchor `Q`, the indices `(Q-t-delta) mod B` are distinct.
The left-endpoint sweep enlarged by `w0` has diameter
`2h+2w0<d`; hence it contains at most one marker. Displacement spacing
permits that marker to cause a left-endpoint failure for at most one
ordered pair.

Without such a crossing, the first marker on or after the left endpoint
is unchanged by every permitted shift. A changed bounded search, or an
absent search followed by a marker in its extension, therefore puts
that first marker within `max(H_ext,w0)` of the right endpoint.
Across the unexpanded left-endpoint sweep, the possible first markers
are a marker in the sweep and the first marker after it: at most two
values. The actual width spacing separates all the right endpoints by
more than twice the stated radius. Each of these two marker values
therefore charges at most one pair. This proves `1+2=3`.

`inner_bad_cover` proves the failure classification, and
`first_values_le_two` derives the number of possible first markers.
`inner_failures_le_three` is the resulting census. The width is held
fixed during a shift, exactly as required in `A_*`.

### Uniform clock count and the combined bound

For a fixed actual anchor,

    phi(Q-t-(p-p')) = phi(Q-t) + phi(p') - phi(p).

The recorded uniform roster estimate bounds its clock failures by `C`
regardless of the value of `Q`; it is valid for an unbounded mismatch
anchor too. There are at most three actual anchors and `J` labels.
Taking unions with the end-instability set proves
`4+3(C+3J)`. This includes all ordered distinct-slot pairs; no slot kind,
table, or independent suffix metadata filters the census.

For the manuscript take `C=floor(c_cl log(2m))`. Its original condition
`mu>20(c_cl log(2m)+4J)+10` implies
`mu>4+3(C+3J)`. The purely real/natural comparison is
`manuscript_budget`; `whole_stencil_bound` derives the combined
cardinality theorem.

### The true witness is evaluated before endpoint uniqueness

All candidate origins at a genuine early cut are `t+p-p'`; all their
bounded and shifted inspections are mandatory and internal to the first
episode by `schedule:margins`. Restricting the two-sided marker set to
these finite intervals preserves every search, by `search_locality`
and `end_search_locality`. An unavailable window rejects the proposed
suffix instead of removing the true candidate.

If any larger search is absent, a marker eligible for any smaller
search would be eligible for that absent larger search, since

    max D^0 + 2h < min D^1.

Thus all the smaller searches are absent. Their periodic seeds overlap
in at least `d_bullet^2` positions. Two continuations with positive
periods below `d_bullet` which agree on the overlap agree everywhere:
their period product is a common period, and every integer has a
representative in any interval of that length.

The actual and reference seeds consequently agree with a single
continuation on their union. The first mismatch after either seed is the
same. In a proposed suffix the reference exact-end rule must therefore
use the actual first mismatch, so it already forces the true endpoint
in this branch. This is proved in `reference_guard_forces_endpoint`,
not assumed. Conversely `actual_reference_guard_passes` proves that
this guard really passes on the actual suffix.

If all larger searches are present, every clock anchor is a bounded
return already supplied by mandatory data. In particular, the true
candidate's clock value is independent of the proposed endpoint. Its
smaller search **can still be absent**; the actual endpoint need not be
bounded. `decoder_pre_uniqueness` proves true-witness survival in both
branches directly from membership in `D`.

Only after survival has been established does uniqueness force the true
slot. The final decoded-origin end guard then forces the actual
endpoint. It is imposed in both branches.
`decoder_success_and_endpoint` proves this composition with the actual
residue-indexed end-search and first-mismatch definitions.

### Completeness and one surviving copy per kind

On an actual suffix, the mandatory windows are present, the reference
guard passes whenever called, and the true candidate's final guard
passes. Only an additional witness can defeat uniqueness. The set of
failed actual slots is exactly the first-coordinate projection of the
set of additional witnessing ordered pairs. Projection cannot increase
finite cardinality. The bound just proved therefore leaves fewer than
`mu` failed actual slots.

If every copy of a kind failed, its `mu` distinct copies would lie in
that smaller set, a contradiction. `failed_slots_le_false_pairs`,
`stencil_completeness`, and `surviving_copy_has_unique_witness` certify
this argument. True diagonal witness existence comes from the
pre-uniqueness proof, not from correct guesses at false origins.

## Classification, replay, and remaining dependencies

The result is a universal verification theorem with a strengthened
anchor bound, not a finite-search exclusion and not a refutation.
No false literal manuscript assertion has been established in this
audit; consequently there is no invented `F_` refutation claim.

Run:

    $WORKSPACE/argus-live-update/.venv/bin/python research/decoder_audit/verify.py

The script first replays deterministic boundary diagnostics and the saved
typed Jacobian congruence result, then runs the prescribed real Lean
verifier with `--claim C_DA_CORE`, and finally runs both official checks
against this campaign root. `exact_certificate.json` distinguishes these
finite diagnostics from the universal proof. The diagnostics are not
claimed to instantiate the entire enormous clock/metadata schedule or a
legal full episode. They are not counterexamples of any kind.

The Jacobian adapter's inspected operation was
`integer.counting.congruence_box.compute`, server `0.14.0`, protocol
`2025-11-25`. Its exact dedicated payload and typed output are preserved.
The bounded congruence answer is independently replayed as count `39`.
It is a diagnostic of a small residue configuration, not support for a
universal theorem.

The staged decoder's prior anchor bound was twenty; the new bound is
three, with an explicit interval-sandwich generalization. A bounded web
lookup found no independent source for this particular strengthening or
formal decoder certificate. The search returned the manuscript itself
and secondary descriptions, not an independently checked novelty
theorem. Failure to find a source is **not** proof of global novelty.
Publication significance and novelty remain for independent review.

The word-level application retains the explicitly recorded local marker,
uniform clock, and mandatory-window inputs. Their precise mapping is in
`statement_fidelity.md`. The construction of the clock and marker rule,
the split/shift-table algebra, standalone height-one compilation, and
the height-three, height-four, and height-thirteen main theorems remain
open nodes, not silently certified by this decoder result.

The final prescribed compiler run succeeded with Lean 4.31.0, exit code
zero and `proof_holes=[]`. Its axiom audit also exited zero. The three
printed principal declarations use only the ordinary trusted axioms
`propext`, `Classical.choice`, and `Quot.sound`, with no `sorryAx`.
The source and this statement-fidelity reading are archived together at
`certificates/C_DA_CORE-03990cc5da90b571.json`; the hash binding is produced
by the official verifier, not supplied by an author.

Both official campaign-local checks exited zero at
`campaigns/9000134`.
Independent Reviewer replay and statement-fidelity approval have **not**
been supplied by this Engineer. This is a ready-for-review result, not a
claim that the publishable campaign or any manuscript main theorem has
already passed independent review.
