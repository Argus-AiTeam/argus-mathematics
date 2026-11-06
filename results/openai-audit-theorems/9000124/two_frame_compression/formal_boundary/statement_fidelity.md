# Temporal boundary preservation: statement fidelity

## Claim, declarations, and scope

The scoped Engineer claim is **C_TFC_TEMPORAL_BOUNDARY_LEAN**, context
**CTX_TFC_BOUNDARY_LEAN**. The source is `Main.lean`, namespace
`TemporalBoundary`, using Lean 4.31.0 and Mathlib.

The principal theorem is
`TemporalBoundary.TemporalHistory.future_boundary_invariants`.
`TemporalHistory.boundary_invariants` is its arbitrary-depth, root-derived
version before a final reordering. Both conclusions are **I2 and I3**.
The history is generated from the literal sentinel/root data and local
construction certificates, not from constructors requiring I2, I3, a
descendant-flow invariant, or G coverage/exclusion.

This is a **conditional temporal component**, not full C_TFC_HISTORY,
C_TFC_BOUNDARY, C_TFC_LISTS, or the manuscript's scheduling theorem.
In particular, this module does not construct the required list interfaces
from actual lists, prove existence of every separator walk, or automatically
extract each incoming ancestor certificate from the immediately preceding
history edge. Those integration obligations remain explicit below.
No existing campaign claim is weakened.

Important intermediate declarations:

* `lex_prefix_no_exchange`,
  `normalized_child_future_no_exchange`;
* `earliest_exception_ready`,
  `successor_forced_by_no_exchange`, `trace_strict_successors`;
* `walk_carry_transport`, `carry_past_at_walk_end`;
* `switchG_from_incoming_separators`,
  `IncomingAncestor.G_properties`,
  `IncomingAncestor.frozen_G_after_every_reordering`;
* `same_update_I2`, `same_update_I3`,
  `switch_update_I2`, `switch_update_I3`.

The staged source is
`research/openai_manuscript/A-polynomial-time-algorithm-for-three-machine-unit-job-scheduling-September-24-2026/build/`:

* `paper.tex`, Section 2: complete schedules, strict global precedence,
  reversal, actual triple cones, and sentinel constants;
* `construction.tex`: I1-I3, the same/switched working frames, side
  normalization, and actual walk positions;
* `separators.tex`, `def:separator`, `lem:lex-prefix`, `lem:shared`;
* `lists.tex`, `lem:G`, including the all-U historical agreement and
  `a_- < v_- <= a < b <= b_-` ancestry;
* `boundary.tex`, `lem:past` and `lem:swap`.

## Faithful global objects

`Job` is an arbitrary finite type. `Precedence` contains an irreflexive,
transitive relation on **all jobs**, an injective rank in 1 through |J|,
and strict rank increase along precedence. Thus restricted reasoning uses
global transitive precedence, not an induced-edge graph.

`Schedule P T` assigns every global job an integer time, respects strict
precedence, has times in 1 through T, and has exactly **three** jobs at
every such slot (`Complete.triple`). It is not a greedy schedule.

`Boundary.actual jobs` freezes a finite set of jobs. `Placed` requires it
to have cardinality three and to be exactly the full schedule's fiber at
its stated time. The left/right sentinels occur at 0 and T+1 and have no
boundary jobs. `D`, `Pred`, `WeakD`, and `WeakPred` use strict global
precedence and the frozen triple. Their sentinel values are:

* left: D = weak D = J, P = weak P = empty;
* right: D = weak D = empty, P = weak P = J.

Sets in predicates, historical low sets, qualifiers, and keys are frozen
global functions or subsets of `Job`, never re-evaluated reachability
cones of a newly occupying triple.

`Precedence.reverse` exchanges the precedence arguments and replaces rank
r by |J|+1-r; `reverse_ranks_sum` proves the rank-sum identity.
`Schedule.reverse` maps time t to T+1-t and proves that the result is
still a feasible complete schedule. Boundary reversal exchanges the
sentinels and preserves actual frozen triples. The four cone reversal
identities and `reorders_reverse` are proved.

`Inside` is the actual open integer-time interval. `Reorders` allows
**any feasible complete schedule** with exactly the same interior job
set in those slots and unchanged time for every exterior job.
It imposes neither a priority choice nor a hierarchy-preservation
condition. `reorders_enlarge` and `reorders_trans` justify viewing
preparatory and future child reorderings as reorderings of their parent.

`ExchangeFeasible` tests precedence for the actual transposition of two
jobs' times in the **complete schedule**. `complete_reindex` proves that
the transposition preserves all slot cardinalities and time bounds;
`exchanged` constructs the resulting complete schedule whenever this
precedence test holds. No hierarchy condition is imposed on the exchanged
schedule.

## Literal lexicographic normalization and immutable prefixes

A `Priority` is an injective natural-valued total order extending
precedence. Only its restriction to the side is read by normalization.
For an actual manuscript priority specified on a parent, a compatible
global extension must be supplied; no behavior of exterior priorities
is used.

`slotWord` sorts the **actual priority indices of the jobs in a slot**.
Injectivity prevents lost multiplicities. `sideSlots` enumerates all
integer slots strictly between the endpoints in increasing order.
`word` concatenates their sorted slot words.

`Normalized` is precisely absence of a smaller `List.Lex (<)` flattened
word among all feasible complete reorderings of the side. It is not
defined as I3, no-exchange stability, readiness, or a greedy algorithm.

`orderedInsert_improves` and `sort_insert_ordered` prove that replacing a
slot member by a better-priority job improves its sorted word.
`lex_append_arbitrary` preserves a strict first difference under arbitrary
later tails. `lex_prefix_no_exchange` uses these facts to derive the
no-exchange result from the literal lex-minimum.
`normalized_child_future_no_exchange` then quantifies over every feasible
child reordering: its prefix through the child's left boundary is
immutable, so an improving boundary exchange would improve the original
normalized word, regardless of the changed suffix.

## Actual earliest exceptions and the first exterior advance

`LowPrefix` says that low domain jobs have better priority than every
high domain job. `lowPrefix_ideal` **derives** idealness from this and
precedence compatibility.

`EarliestAdvance` contains only actual source/target placements, a strict
increase of time, a low target exception not in the source D-cone, and
the assertion that every strictly earlier low job between the positions
is in that source D-cone. These are the mathematical guards of an actual
earliest-low-exception advance. It contains no successor-transport or
boundary-invariant conclusion.

`earliest_exception_ready` proves that **every global predecessor** of
the exception is strictly before the source. A predecessor at the
source would directly put the exception in D. A predecessor strictly
between source and target lies in the contiguous side, is low by the
derived idealness, descends from the source by earliestness, and again
puts the exception in D by transitivity.

`exchange_feasible_of_ready` proves the complete-schedule exchange
criterion from readiness and the absence of an obstructing successor.
`successor_forced_by_no_exchange` takes its contrapositive.
`trace_strict_successors` uses strong induction on the nonnegative
integer time remaining to the target, not enumeration of schedules.
Each successor is strictly later and no later than the target.

`ExceptionWalk` is generated by zero or any finite number of these
actual advances, with low cutoffs contained in the final cutoff.
Its constructors do not assume any descendant-flow relation.

`walk_carry_transport` proves transport for a frozen upset carry:

* at the first exterior source, the exception is outside its D-cone,
  and the explicit promoted-old-key interface makes its old key
  strictly smaller than every carry key. Parent I3, after the actual
  preparatory reordering, excludes the complete-schedule exchange;
* carry jobs strictly inside the normalized side, and every later
  advance, use the proved lexicographic no-exchange lemma instead;
* forced successors stay in the carry by upward closure, and the
  strict-time induction reaches the actual target triple;
* induction over the **actual advances** gives a carry descendant at
  the final walk position.

`carry_past_at_walk_end` combines this derived transport with parent I2.
`same_update_I2` additionally excludes the literal new injection
D(a) minus P(b) from times at or before a, and uses the local separator
for jobs between a and a'. No propagation of I2 is an input.

## Deriving switched G from incoming ancestor facts

`IncomingAncestor` records the old feasible complete witness, its actual
center and endpoint triples, ancestor boundary placements, frozen
historical low set H, frozen center low set, and extension Hstar.
The facts supplied are the actual old center and endpoint separators,
H contained in the old right-boundary cone and center low set,
and Hstar agreeing with H on **every job of the ancestor interval U**.
Hstar must be a global upset in the new frame. No size or compression
property of Hstar, and no G coverage or exclusion, is a field.

The record also requires the literal ancestry
`u < v <= a < b <= w` and that all intervening changes are confined to
W=(a,b). The separator stability lemmas prove that these changes preserve
the relevant incoming separator implications; the old separators are
not silently reasserted for an unrelated current witness.

`switchG` is the manuscript formula

    D(ancestorLeft) AND NOT weakP(a) AND NOT weakP(oldCenter) AND Hstar.

`switchG_from_incoming_separators` and `IncomingAncestor.G_properties`
derive that it is an upset, covers **all** of W minus D(a), and contains
no job at or before a. Coverage first derives membership in H using
the old endpoint separator and reversal. Early exclusion first uses
D(ancestorLeft) to localize a candidate inside all of U, only then uses
Hstar agreement, and splits at the old center to apply the two actual
separators. The equality oldCenterTime = a is permitted.
`frozen_G_after_every_reordering` retains the same global G after any
further feasible reordering of W.

`switchQualifiers` is exactly the union of the two new entries,
(G intersect rank suffix) union D(a); no old qualifier is carried.
`switch_update_I2` derives early exclusion for this union and applies the
local separator. `switch_update_I3` is vacuous at a'=a, and uses the
immutable-prefix theorem at a'>a.

## Explicit list interfaces and remaining integration obligations

No temporal theorem assumes I2/I3 preservation, G-properties, a
descendant-flow relation, or a semantic compression bound.
The following non-temporal interfaces are, however, genuine hypotheses:

1. A carry is a global upset and a subset of the old qualifier union.
   Every finally low exception outside D(a) has strictly smaller old key
   than every retained carry job. Comparisons among carried jobs in the
   pre-pruning list imply the old comparisons.
2. The pre-pruning union on the side is exactly the complement of the
   edge cutoff. For a same update it is carry union the literal injection;
   for a switch it is exactly the two-entry union above.
3. `ListOrderInterface.pruning_subset` gives global inclusion after pruning.
   `pruning_comparison` is only the manuscript's asymmetric comparison:
   x lies in the child and qualifies, while y may be any global surviving
   qualifier. `priority_comparison` relates pre-pruning comparisons on
   the side to its actual normalization priority. These are **ordering**
   statements, not infeasibility or I3 assumptions.
4. `ListOrderInterface.localI1` supplies the needed local consequence
   x outside the child's D-cone implies that x qualifies. Full I1,
   upset-list construction, capacities, and predicate sizes remain with
   the list/construction integration.
5. The historical-extension interface supplies a global upset in the
   reversed frame agreeing on all U. The separately certified
   `formal_lists` module proves structural extensions under its explicit
   local-I1, origin-coverage, and capacity hypotheses. This module does
   **not** import it or claim a completed Lean adapter between the models.
   Bounded description size is not an assumption of this temporal theorem.
6. To identify every literal manuscript history with `TemporalHistory`,
   one must provide the actual centers, normalized sides, all the
   intermediate earliest-exception advances, shared-cutoff endpoint
   separators, these list interfaces, and the certificate for the
   **chronologically preceding** incoming edge at every switch.
   `SwitchTemporalData.incoming` requires the raw incoming separator
   certificate; this module does not automatically extract its provenance
   from the previous history constructor. The G proof itself is complete
   once those ancestor facts are supplied.

`SameTemporalData` and `SwitchTemporalData` contain these local certificates,
actual nonempty child intervals, and feasible prepared witnesses.
Same updates retain the frame; switched updates reverse **both**
precedence and the parent's complete schedule and exchange its boundaries.
Their constructors contain no temporal conclusion.
`SameTemporalData.preserves` and `SwitchTemporalData.preserves` derive I2/I3
by the edge theorems, not by accepting the desired invariants as fields.

`TemporalHistory` begins at list-union J, largest-index/rank key (1,rank),
and the two sentinels. Induction proves simultaneous I2/I3 for arbitrary
finite depth and any number of reversals in this interface-certified
history class. `future_boundary_invariants` additionally preserves both
under every feasible complete reordering of the terminal interval.

No finite search, SAT result, bounded-depth exhaustion, new axiom,
`sorry`, `admit`, unsafe proof, or replacement of compiler output is used.
The result is Engineer mechanical evidence, not independent Reviewer
acceptance or resolution of C_TFC_HISTORY.

## Reproduction

From the prebuilt Mathlib workspace:

```sh
cd /home/argustest/.local/share/argus-skill/mathlib-v4.31.0
/home/argustest/.elan/bin/lake env lean \
  /home/argustest/zimo/counterexample-batch-1/campaigns/9000124/research/two_frame_compression/formal_boundary/Main.lean
```

Official certification, from the campaign root:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python -m \
  argus_skill.verticals.math.lean_evidence verify \
  research/two_frame_compression/formal_boundary/Main.lean \
  --statement-fidelity research/two_frame_compression/formal_boundary/statement_fidelity.md \
  --claim C_TFC_TEMPORAL_BOUNDARY_LEAN \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/9000124 \
  --artifact-dir research/two_frame_compression/formal_boundary/evidence
```
