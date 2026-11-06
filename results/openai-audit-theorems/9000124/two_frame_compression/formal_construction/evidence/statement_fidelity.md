# Raw exact construction integration: statement fidelity

## Claim and scope

Claim **C_TFC_RAW_CONSTRUCTION_INTEGRATION_LEAN**, context
**CTX_TFC_RAW_CONSTRUCTION_LEAN**, is an Engineer implementation result,
not an independent Reviewer judgement. The main new namespace is
`LiteralConstruction`.

The principal theorem is
`LiteralConstruction.RootedHistory.construction_integration`.
It proves a joint, arbitrary-depth induction for root-connected histories
whose lists and incoming metadata are **computed by the raw constructors**.
Both same-frame edges and any finite number of frame reversals are covered.
There is no bound on depth, number of jobs, or number of switches.

The following are also part of this claim:

* `RawHistory.future_invariants`;
* `RawHistory.injection_bound`, `RawHistory.list_bounds`,
  `RawHistory.entry_certificates`;
* `RawHistory.global_parts`, `RawHistory.global_node_description`,
  `RawHistory.global_node_source_language`,
  `RawHistory.future_global_description`;
* `RootedHistory.two_frames`, `RootedHistory.original_global_description`;
* `RawHistory.same_cutoff_certificate`;
* `RawHistory.same_mark_certified`, `RawHistory.switched_mark_certified`,
  `RawHistory.same_center_certified`,
  `RawHistory.switched_center_certified`.

All names in this document lacking a namespace prefix are in
`LiteralConstruction`, unless stated otherwise.

This closes the list, extension, size, and chronological-incoming interfaces
**for this raw-history class**. It does not prove existence of every raw
local scheduling certificate, construction of the entire marked hierarchy,
or a formal extraction of these certificates from the manuscript's complete
promotion protocol. **C_TFC_HISTORY is not revised or closed.**

## Source composition and trust boundary

`Main.lean` is standalone except for `import Mathlib`. `compose.py`
concatenates the complete bodies of the two previously certified sources
and `Integration.lean`, merely hoisting their duplicate initial Mathlib
imports. It does not alter any existing theorem text. Before composition
it checks each original source against its own official evidence hash.

* `formal_lists/Main.lean`:
  `cccf1085708b246f63471f31f5ee5f12a866e876f482f8da72699e0c2db58c0a`.
* `formal_boundary/Main.lean`:
  `6311d2c812d199ca0854afe0bde27177389a8fa33116785aef449cb86d88eff8`.

`composition.json` records every input hash and the combined source hash.
`compose.py --check` checks the same composition without writing any files.
The official certificate therefore binds all non-Mathlib theorem bodies
used here, not just imports of mutable local `.olean` files.

The original modules, their fidelity documents, the proof graph, existing
progress/activity files, and the staged manuscript are not modified.

## Literal objects and raw construction choices

The global finite job type, strict transitive precedence, injective rank in
1 through |J|, feasible complete three-job-per-slot schedules, frozen actual
boundary triples, both sentinels, open intervals, feasible reorderings,
strict/weak cones, and actual exchange feasibility are exactly the objects
of `TemporalBoundary`. Entries, largest membership indices, carries,
rank-threshold tightening, pruning, and same-frame `Run` are exactly the
objects of `SameFrameHistory`.

`frameData` identifies the models: rank is the current precedence rank,
D is the global strict descendant cone, and P is the global strict
predecessor cone. `frame_laws` proves, rather than assumes, the required
closure/rank laws.

`rawRoot` has the two sentinels and the one-entry list `(J)`.
`RawSameData.child` computes

    prune(child, carry(parent.list, cut) ++ [D(parent.left) \ P(parent.right)]).

`RawSwitchData.child` computes, in the reversed frame,

    prune(child, [G AND rank >= r+1, D(working-left)]).

Here r is zero or an actual promoted X-job's rank, and r <= |J|.
`CutAttained` requires a nonempty same-frame cut to be the actual key
(d+1,r) of a parent qualifier. Defining the promoted prefix by strict
comparison with that key is precisely the literal old-key prefix;
the carry uses the zero-based offset d.

`samePriority` is S0 first by rank, then O by its old largest-index key,
then Y by rank. `switchPriority` is X first and D(a) second, each by rank.
The raw priority-protocol fields require exact agreement with these orders
on the entire current parent. Priorities are global compatible extensions;
normalization reads only the side restriction.

The nontrivial local data supplied by a raw edge are:

1. an actual feasible prepared schedule, obtained by reordering the parent;
2. its literal priority and lexicographic `Normalized` certificate;
3. an actual center and its separator at the prescribed center-low set;
4. actual child endpoints, positions, a nonempty child, and the two
   separators at the **same edge cutoff**;
5. an `ExceptionWalk` containing the actual `EarliestAdvance` traces,
   with its intermediate low prefixes contained in the final low cutoff;
6. the literal cut/rank guards just described.

These are scheduling/protocol choices, not list or boundary conclusions.
In particular there are **no raw fields** requiring I1, I2, I3,
`ListOrderInterface`, G coverage/exclusion, closure of G, run flattening,
historical agreement, capacity, formula size, or an equivalent semantic
compression invariant.

## Chronological incoming provenance, not a freely chosen certificate

`Creation` stores the witness, outer boundaries, center, cutoff and formulas
of a creating edge. Its extension/direct formulas are stored as syntax
without assuming their correctness. The record's mathematical correctness,
`Creation.Valid`, is a **derived** conclusion, never a raw edge premise.

Every child constructor overwrites `incoming` with `some` of the record
computed from that very edge:

* a same edge computes the extension from the parent list's terminal carry;
* a switched edge computes `NOT D(a) AND rank <= r`.

An outgoing switch's `chronology` equation requires its creation record to
equal the actual `incoming` field of its parent. The root has `incoming =
none`, so it cannot produce a switched edge in this model.

`Creation.incoming` builds `TemporalBoundary.IncomingAncestor` from that
stored record, its independently derived validity, and the actual outgoing
preparation. Its old witness is the creating witness reversed; the
intervening reordering is exactly the current preparation confined to W.
The inequalities u < v <= a < b <= w are derived by reversing the actual
creating-edge positions.

`RawSwitchData.origin_properties` applies
`IncomingAncestor.G_properties` to this derived object. Its G is exactly

    D(ancestor-left) AND NOT weakP(a) AND NOT weakP(old-center)
      AND flipped(historical-extension).

Thus coverage of **all** of the current parent's X, global upward closure,
and exclusion of every job at or before a are conclusions. No unrelated
ancestor certificate or prior run's complicated G atom is supplied.

## Derived list interfaces and simultaneous induction

`lex_key_precedence` proves strict largest-index/rank key increase along
precedence. `carryAt_index` proves the exact index shift on selected jobs;
`carry_key_order` proves the global suffix-carry order equivalence.
`prune_comparison` proves the asymmetric comparison with x inside the child
and y an arbitrary global surviving qualifier.

`same_high_union` and `switch_pair_union` prove the pre-pruning high-union
identity on **every parent job**, not only on the child or side.
`same_pre_priority` and `switch_pre_priority` derive agreement of actual
pre-list key comparisons with the literal priority. The two actual
separators then give `localI1_of_exact_update`.
Both `RawSameData.list_order` and `RawSwitchData.list_order` construct the
actual `ListOrderInterface`, including pruning comparison and local I1.

`InjectionSeparated` is a proved inductive property of the actual list.
Carrying only restricts old predicates. The fresh injection is disjoint on
the current parent from every old qualifier, by the already derived parent
I1. Pruning and shrinking preserve this separation.

For each surviving injection, pruning supplies a child witness x.
The right separator makes x precede a job z of the actual ending triple.
Global upward closure places z in the same injection, and the ending
triple is inside the current parent. Pairwise separation forces these
witnesses to be distinct. `injection_length_le_card` proves the finite
cardinality argument; `injection_capacity` specializes it to three jobs.
`Run.base_bound` independently derives at most two non-injection entries
from the exact root/switch/carry/prune constructors. Hence five entries,
including the case of six entries immediately before same-edge pruning.

`flatUnion` is an explicit deterministic implementation of run flattening,
not a choice of a formula postulated to satisfy the desired invariant.
`flat_union_properties` applies the already proved actual `Run.shape`.
`historical_syntax_properties` derives the global downset extension,
its <=21-leaf bound, and agreement on the entire incoming parent.
`Creation.incoming` converts this downset to an upset in the next frame.

### A necessary localization of the old temporal interface

The old module's `SameTemporalData.carry_comparison` asks for a comparison
of appended pre-list keys on **all** pairs of global carry jobs.
An appended injection can override keys outside the parent; no such
unrestricted comparison is used by the literal boundary proof.
The existing conditional theorem is not altered or asserted false.

`same_update_I3_literal` proves the needed version directly, using
`TemporalBoundary.advanced_child_I3` for an interior left endpoint.
At the exterior endpoint it compares only x outside D(a) and y in the
actual boundary triple. These two guards exclude the fresh injection.
The actual suffix-carry order theorem therefore applies. There is no
extra raw comparison premise and no attempt to identify raw histories
with the old, more restrictive `TemporalHistory` class.

`RawHistory.derived` is the simultaneous root-derived induction.
Its `Derived` record collects **conclusions**, not constructor inputs:
actual Run, origin laws, I1-I3, injection separation, five entries,
the exact child high identity, and validity of the preceding creation.
`RawHistory.future_invariants` quantifies over every feasible complete
reordering of the terminal interval.

## Source syntax, global equalities, and counts

`Syntax` is a Boolean AST with literals and binary AND/OR. Its only tests
are constants, strict/weak D/P cones, boundary-triple membership, and
rank >= / <= thresholds. Every literal has a current/opposite-frame bit.
There is no arbitrary-set atom, G atom, ancestor-interval membership atom,
or schedule-time atom.

Complement is normalized by De Morgan's laws and preserves leaves.
Frame flipping preserves leaves and has proved global semantics.
`RawHistory.language` derives that every referenced actual boundary has
three jobs and every threshold is in 0 through |J|+1. The source predicates
allow the sentinel constants. These are not just semantic set
representations with an unspecified description language.

The historical extension has <=21 leaves; the three extra G factors give
<=24; the first switch entry adds one rank leaf and has <=25.
Later same-frame trims combine thresholds by maximum in the unchanged
`Entry.trim`. All entries have <=25 leaves, in particular fewer than 40.
The other simple entries have <=3 leaves.

`global_high` and `global_low` implement exactly the localization formulas
in `build/descriptions.tex`:

    high = Qual(child-list) AND P(child-right) AND NOT weakP(child-left)
    low  = D(child-left) AND P(parent-right) AND NOT weakD(child-right)
             AND NOT weakD(center) AND direct-cutoff.

Their equalities are on **all global J**. Positive cones first localize a
candidate inside the domain on which cutoff agreement is known.
The high proof uses derived global I2, not a hidden parent-membership
predicate.

The actual fold with its one-leaf false terminator gives a union of
<=126 leaves. The same direct cutoff has <=127 leaves, hence <=205;
the switched cutoff has two. Consequently the high part has <=128
(and therefore <=197), the low <=209, and the node union <=337 <500.

`separatorSyntax` is P(z) OR (H AND NOT weakD(z)).
`relativeSyntax` intersects the center separator description with the
mark's separator description. The mark theorems quantify over any actual
center/mark separators with the literal cutoff, including marks which
do not bound a nonempty child. The center has three leaves; an internal
split has <=210. `reverseSplitSyntax` is NOT F AND NOT triple(z):
the essential marked-triple exclusion is proved, and conversion has
<=211 leaves. All are strictly below 500 in either frame.

`RootedHistory` fixes an arbitrary initial precedence and complete
schedule. `two_frames` proves that every descendant frame has the same
global relation and rank as that root frame or its reversal.
`original_global_description` consequently gives the node's global set
as an allowed <500-leaf formula evaluated in the fixed original frame.

## Source correspondence

The staged manuscript family is
`research/openai_manuscript/A-polynomial-time-algorithm-for-three-machine-unit-job-scheduling-September-24-2026/build/`.

* `construction.tex`: I1-I3, root list, literal priorities, cutoffs, centers,
  actual edge endpoints and the two shared-cutoff separator implications.
* `lists.tex`: carry, pruning, update-labels, capacity-three/five-entry
  bound, flattening, old-low extension, G and ancestry formulas.
* `boundary.tex`: same/switch I2/I3, the first exterior exchange obstruction
  and subsequent normalized-side successor tracing.
* `separators.tex`: literal lex normalization and actual separator
  descriptions; existence of the full promotion walk is not supplied here.
* `descriptions.tex`: exact global high/low, center/internal splits,
  reversal with marked-triple exclusion, and depth-independent counts.

No false literal manuscript assertion has been established by this work.
There is therefore no new refutation claim or refutes judgement.

## Exact remaining obstruction to full C_TFC_HISTORY

The remaining condition is **not** local I1, ordering, G coverage,
capacity, extension agreement, description complexity, or an arbitrary
incoming certificate. Those are now derived for every raw history.

What is not proved is a construction-existence / protocol-extraction
theorem taking an arbitrary feasible initial schedule and the manuscript's
whole branching center-and-promotion process and producing all raw local
certificates and the covering marked tree. Specifically:

1. choose a center separator and normalize both fixed sides, extending the
   prescribed parent priority to a global `Priority`;
2. construct the complete ordered sequence of promotions and final shared
   walk positions, with both endpoint separators at every strict gap and
   the required `ExceptionWalk` trace;
3. extract the `CutAttained` / rank-prefix data and assemble the exact
   `RawSameData` / `RawSwitchData` for every nonempty gap, using the same
   actual center on the two opposite sides;
4. prove that all these gaps and marks form the claimed covering,
   terminating hierarchy.

The raw choices are legitimate inputs to this conditional safety and
compression theorem, but their existence for every literal manuscript
construction has not been silently inferred. This is a new honestly
scoped claim; the main scheduling theorem, full hierarchy existence,
C_TFC_HISTORY, and independent Reviewer acceptance remain separate.

## Reproduction

From the campaign root:

```sh
python research/two_frame_compression/formal_construction/compose.py --check
python research/two_frame_compression/formal_construction/verify.py
```

`verify.py` checks composition, pinned source/fidelity hashes and official
archives, then reruns standalone Lean compilation and the official axiom
audit with Lean 4.31.0 in the prebuilt Mathlib workspace. It writes only
inside this directory.

Official evidence is produced by `certify.py`, submitted to the requested
durable runner in direct (non-LLM) mode. Its underlying command is:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python -m \
  argus_skill.verticals.math.lean_evidence verify \
  research/two_frame_compression/formal_construction/Main.lean \
  --statement-fidelity research/two_frame_compression/formal_construction/statement_fidelity.md \
  --claim C_TFC_RAW_CONSTRUCTION_INTEGRATION_LEAN \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/9000124 \
  --artifact-dir research/two_frame_compression/formal_construction/evidence \
  --lean-bin /home/argustest/.elan/bin/lean \
  --lake-bin /home/argustest/.elan/bin/lake --lake
```

`certify.py` checks the exact campaign math ledger and proof graph
immediately after the official evidence mutation, even on failure, and
checks that source and fidelity were unchanged during verification.
