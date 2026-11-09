# Literal protocol preparation and shared-cutoff existence

## Claim boundary

**C_TFC_PROTOCOL_PREPARATION_LEAN**, context **CTX_TFC**, is an Engineer
implementation claim, not an independent Reviewer judgement. Its new namespace
is `LiteralProtocol`.

The central existence theorems are:

* `node_preparation_exists`;
* `root_preparation_exists`;
* `shared_cutoff_walk`;
* `ideal_center_exists`;
* `normalized_sides_exists`;
* `next_same_cut_exists`;
* `next_switched_rank_exists`.

This closes substantial local existence obligations, but **does not close
C_TFC_PROTOCOL_EXTRACTION, C_TFC_HISTORY, or the manuscript's hierarchy or
scheduling theorem**. No statement or assumption of those claims is revised.
In particular, this source does not yet construct every child of every node,
or a covering terminating branching hierarchy.

## Quantification and objects

All results quantify over an arbitrary finite job type, with decidable equality,
a `TemporalBoundary.Precedence`, and complete feasible three-job integer-slot
schedules. Ranks are injective in 1 through the global job count and strictly
increase along global transitive precedence. There is no bound on job count,
depth, number of switches, or number of feasible reorderings.

The model, sentinels, frozen triples, cones, ranks, actual exchanges, literal
sorted-triple lexicographic words, `Normalized`, `LowPrefix`, `EarliestAdvance`,
`ExceptionWalk`, and `Separator` are the original certified definitions.
Nothing is replaced by a greedy scheduling rule, a local-exchange surrogate
for normalization, an abstract progress oracle, or a finite evaluation.

For a nonroot node, `node_preparation_exists` takes its **already established
root-connected raw history** as an input. It applies the certified raw
induction to derive the list facts needed to construct the priority. It
does not assume list/order/boundary invariants separately, but it does not
prove that every literal future child has such a raw history.
`root_preparation_exists` has no history input: every feasible complete
schedule of positive length has the asserted root preparation.
An empty interval is not required to have an actual center.

## Exact normalization and compatible priorities

`finite_schedules` proves that the type of complete feasible schedules is
finite, by injecting its time functions into `Job -> Fin (T+1)`.
`normalized_exists` then minimizes the **entire** sorted-triple word over
all feasible interval-confined reorderings. It returns literal `Normalized`.

`interval_priority_extension` handles any injective local key into any
linear order, provided it respects precedence on the interval. Its global
key puts exterior-before jobs, interval jobs, and exterior-after jobs into
three blocks. Exterior jobs are ordered by global rank. Feasibility proves
that precedence cannot run backwards through the blocks. Counting smaller
global keys gives an injective natural-index `Priority`, and its restriction
agrees exactly with the requested local order.

`samePriority_respects`, `sameOrderKey_order`, and
`raw_same_priority_exists` derive compatibility for the literal same
priority: nonqualifying predecessors of the right boundary, then qualifiers
by their **largest membership index / rank** key, then the remaining jobs.
They use derived parent I1 and upward closure of entries.
`switch_priority_exists` constructs the literal opposite-frame priority:
jobs outside the strict left descendant cone first, then its complement,
each by the switched rank. This order actually extends precedence globally.

`normalized_sides_exists` fixes **one center** and the two side job sets,
and minimizes the lexicographically ordered pair of full side words over
all feasible schedules preserving those sets. Reordering either side is
an admissible competitor. A right-side reordering leaves the left word
unchanged. Thus the returned witness simultaneously satisfies the two
literal `Normalized` predicates, one in each working frame.

`Prepared` records only the preserved interval and side job sets. It is
not a preservation, description, hierarchy, or local-certificate assumption.
`prepared_center_placed` and `prepared_center_separator` prove that this
normalization retains the actual center and its separator.

## Actual shared-cutoff walk, including both consecutive prefixes

`earliest_advance_exists` selects the earliest actual low exception by its
time among all global jobs in the side, and constructs the existing
`EarliestAdvance` with the actual target triple `slotJobs`.

`advance_preserves_earlier` proves the earlier-high condition at that target.
It uses the original `earliest_exception_ready` for all global predecessors,
literal `lex_prefix_no_exchange`, `successor_forced_by_no_exchange`, and
`trace_strict_successors`. Every high job in the relevant time strip is
traced through strictly increasing successor times to the actual target.
Earlier high jobs are first connected to the previous boundary.
The exterior and both sentinel cases are treated, not postulated.

`finish_separator` repeats these actual earliest advances by strong
induction on `(v-s).toNat`. Its terminal position has no later low exception.
Its continuation conclusion constructs an `ExceptionWalk` from any supplied
prior actual walk whenever the intermediate low prefix is contained in the
outgoing final cutoff. This is a proved provenance conclusion, not an
assumed constructor-existence or progress certificate.

`shared_cutoff_walk` takes two low prefixes whose restrictions differ by one
promoted job, a separator for the old prefix, and its actual prior walk.
It returns a position at or to the right of that separator, strictly before
the side endpoint, which separates **both** prefixes, together with the
actual `ExceptionWalk` at the new prefix.

The proof includes the essential two-prefix argument. If an advance is
needed, its first exception is the promoted job; it lies at the first
target, and so introduces no earlier old-high job there. In every subsequent
advance that promoted job is already at or before the current position.
Consequently each subsequent exception is old-low, and the same exact
successor tracing preserves the old earlier-high condition as well.
`finish_two_prefixes` proves termination while preserving both conditions.
`shared_cutoff_outside` proves explicitly that an outside promotion permits
keeping the existing position.

These are local assertions about specified consecutive prefixes. They do
not themselves enumerate the entire manuscript promotion process.

## Ideal centers and source root convention

`ideal_priority_exists` derives a compatible priority putting any domain
ideal first. `actual_separator_of_lowPrefix` starts at the first actual
domain slot, where the earlier-high condition is vacuous, and applies the
same earliest-advance termination proof. It returns an **actual** interior
separator, not a sentinel. `ideal_center_exists` therefore constructs a
feasible parent-confined reordering and an actual separator for any ideal
of a nonempty interval.

`node_center_exists` applies this to the actual right predecessor cone.
`rooted_center_exists` overrides the general choice at the root:
`root_last_center` uses the last slot of the supplied complete schedule.
`NodePreparation.root_last` retains that choice through both side
normalizations. `root_switched_side_empty` proves that the root's opposite
side contains no jobs.

`separator_reverse_complement` proves the required low/high exchange under
time and precedence reversal. Thus the **same chosen center** separates
the source's same center-low set and switched center-low set in their
respective working frames.

`NodePreparation` consists only of constructed scheduling choices:
the prepared schedule and actual parent reordering, exact compatible
priorities, the actual center, both center separators, and both full
lexicographic normalization certificates. `node_preparation_exists`
constructs this structure for every nonempty root-connected raw node.
It has no raw child, endpoint separator, list bound, compression bound,
or hierarchy field.

`prepared_centers_certified` applies the unchanged raw integration to the
constructed center and obtains both existing `SourceSplitCertificate`s.
Their source-language and size conclusions, including opposite-time
marked-triple exclusion, are the certified base module's conclusions.
This only covers the center, not every future internal mark.

## Literal cutoffs and individual next promotions

`initial_same_cut_exists` chooses the least parent qualifier key, with the
source's zero-based carry offset `largestIndex - 1`; if no parent qualifier
exists it chooses `none`. It proves `CutAttained` and that the initial
carry selects every parent qualifier. `initial_same_separator` derives
the source initial-low separator at the actual exterior boundary from
derived parent I1, and constructs the starting `ExceptionWalk`.

`same_low_prefix` proves that **every** actual `sameLow` cutoff restricts
to a priority prefix of the normalized side. It does not assert that every
arbitrary numerical cutoff is source-attained. `switched_low_prefix`
proves the analogous switched-rank prefix assertion.
`initial_switched_separator` uses rank zero and strict positive ranks;
its low set is empty, and its actual exterior starting walk is constructed.

`next_same_cut_exists` starts with a parent qualifier p as the first
unpromoted key. It minimizes over the parent qualifiers of strictly larger
old key, takes that actual next key as the next attained cut, or takes
`none` when none remains. On the **whole parent**, the new low set is exactly
the old low set plus p. `raw_key_injective` uses the actual injective rank.

`next_switched_rank_exists` starts with any rank cutoff r for which some
parent X-job remains above r. It chooses the least such rank p, proves its
rank bound, and proves that the new low set on the whole parent is exactly
the old low set plus p. No arbitrary rank-prefix existence is assumed.

These next-promotion results supply the concrete local consecutive-prefix
choices for `shared_cutoff_walk`. They have not yet been assembled into
the complete finite marked sequence and all raw child constructors.

## Exact remaining bridge

The following are **not proved** here:

1. A single finite recursion over all remaining O-jobs / X-jobs that
   collects every final shared-walk position with its attained key/rank
   label, includes the final center endpoint, and provides a jointly
   indexed provenance trace for every outgoing cutoff.
2. Packaging every nonempty strict gap of that collected sequence into
   `RawSameData` / `RawSwitchData`, including the switched child's exact
   chronological incoming `Creation`. The center and priority choices
   needed for this packaging now exist; the global all-gaps packaging
   theorem is still absent.
3. Source-correct split certificates for **every** internal mark, including
   marks adjacent only to empty gaps, and conversion to original root time.
4. Deduplicating repeated positions, proving that marks plus all nonempty
   gaps cover the parent, proving strict child cardinal decrease using the
   omitted center, and using well-founded cardinal induction to construct
   a finite covering hierarchy with independent descendant witnesses.

These are remaining formal mathematical obligations, not an environmental
failure or a claimed impossibility. No false literal manuscript assertion
or counterexample is asserted in this implementation.

## Standalone evidence

`compose.py` reads the **unmodified**
`formal_construction/Main.lean` and this directory's `Protocol.lean`.
It verifies the former against its official evidence hash
`5a113abf3f4854aa3e66fd46660671f4712b9818313fd014f7ebe593236f7267`.
It concatenates unchanged theorem bodies, explicitly hoisting initial
`import Mathlib` lines, and rejects any other import.
`composition.json` records both input hashes and the resulting source hash.
`Main.lean` has only `import Mathlib`.

Development may read the previously compiled base module, but final
certification compiles and audits this **standalone combined source**.
`verify.py` checks the immutable official copies, hashes and certificate,
then reruns Lean 4.31.0 and the axiom audit, producing
`exact_certificate.json`. No `sorry`, `admit`, new axiom, unsafe theorem,
pure finite evaluation, or unproved progress principle is used.

The original modules, manuscript, proof graph, progress/activity files,
checkpoint, and git are not edited. Ledger changes are confined to the new
scoped claim through official commands. Independent Reviewer acceptance
remains Host-owned.
