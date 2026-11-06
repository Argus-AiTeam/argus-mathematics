# Complete literal extraction and finite bounded-description hierarchy

## Scope and role

This is Engineer implementation evidence for the **unchanged natural
statements** of `C_TFC_PROTOCOL_EXTRACTION` and `C_TFC_HISTORY`, in `CTX_TFC`.
It is not an independent Reviewer judgement. It proves the structural
hierarchy theorem, not the polynomial-time scheduling algorithm.

The final declaration is:

```lean
LiteralHierarchy.thm_structure (P : Precedence Job) (σ : Schedule P T) :
  Nonempty (LiteralHierarchy.BoundedHierarchy P T σ 0 ((T : ℤ) + 1))
```

`BoundedHierarchy` is an actual inductive finite branching hierarchy.
It is not a predicate postulating a hierarchy, a list of path invariants,
or a progress/certificate-existence oracle. Its constructors are described
below, and their existence is proved by well-founded cardinal induction.

Other central declarations are:

* `LiteralHierarchy.literal_protocol_extraction`;
* `LiteralHierarchy.literal_history_preservation`;
* `LiteralHierarchy.bounded_hierarchy_exists`;
* `LiteralHierarchy.batch_exists`;
* `LiteralHierarchy.Batch.every_gap_realized`;
* `LiteralHierarchy.Batch.every_mark_described`;
* `LiteralHierarchy.Batch.original_marks`;
* `LiteralHierarchy.Batch.original_child`;
* `LiteralHierarchy.Batch.every_child_smaller`.

## Resolved encoding limitation: final switched threshold

The unchanged preparation source's `RawSwitchData.rank_attained` requires
`r = 0` or an actually attained promoted X-job rank. This excludes the
literal source's final threshold `h = |J| + 1` if the last X rank is
smaller than `|J|`, or X is empty initially. This is a limitation of our
former encoding, **not a false manuscript assertion**. No `F_` refutation
claim is appropriate or recorded.

`compose.py` reads the **unmodified**
`formal_protocol/Main.lean`, whose SHA-256 is
`662a1770644db33a1d534d78c15d878a2bb96dd3a70fd5ffe7e1424e4d0be086`.
It checks its official certificate and makes one explicit exact replacement:

```lean
-- old
rank_attained : r = 0 ∨ ∃ x ∈ parent, x ∉ D ... ∧ rank x = r

-- new
rank_attained : r = 0 ∨ r = Fintype.card Job ∨
  ∃ x ∈ parent, x ∉ D ... ∧ rank x = r
```

The full exact old and new texts are in `composition.json`. The composer
checks that the old guard and the identifier `rank_attained` each occur
exactly once in the entire input: no preceding theorem uses that guard.
All the raw semantics and bounds continue to use `rank_bound`.
Nevertheless the old certificate is **not** claimed to certify altered
code. Every preceding theorem body and every new theorem is recompiled
and axiom-audited in the new standalone `Main.lean`.

The new theorems `switch_final_sentinel` and
`switch_exhausted_sentinel` prove, as equalities of actual job sets, that
the cutoff at rank `|J|` is X, and that an exhausted attained cutoff
equals it. `switch_exhausted_transport` transports both the separator
and the actual `ExceptionWalk` across this equality.

The collector's terminal switched segment uses rank `|J|`, not the last
attained X rank. `switched_final_threshold` proves that its raw child uses
the exact pre-pruning list
`[.first (Fintype.card Job + 1), .second none]`.
Thus empty initial X and a maximum X rank below the global maximum are
covered without changing the manuscript's final rule.

## Complete promotion collection, not one-step existence

`SideSystem.Run` is an inductive trace of **all** successive promotions.
Its `State` includes an attained outgoing cutoff, the actual boundary
and time, a separator, and an actual `ExceptionWalk` from the exterior
boundary. Its `Event` records the promoted job, the next state, the
whole-parent single-job growth identity, minimality among remaining
jobs, and the old-cutoff separator at the new position.

`SideSystem.run_exists` uses strong induction on the cardinality of the
actual finite remaining job set. `remaining_erase` proves that every
promotion deletes exactly the promoted job.

* `Run.all_promotions` proves exact enumeration, with no repetitions.
* `Run.promotions_in_order` proves the literal key/rank order.
* `Batch.all_same_promotions` identifies the enumerated set with the
  entire parent O, including jobs outside its normalized open side.
* `Batch.all_switched_promotions` identifies it with the entire parent X.
* `Run.every_position_collected` accounts for every trace position,
  even across repeated final positions.

The two `SideSystem` instances are constructed, not assumed.
`sameSystem` derives its next key from `next_same_cut_exists` and an
actually attained parent key. `switchedSystem` uses
`next_switched_rank_exists`. Both derive their low-prefix laws from
the exact compatible priorities in `NodePreparation`. The initial
same cutoff selects every parent qualifier; the initial switched
cutoff is rank zero.

For a strict promotion step, `strictSegment` uses the **old** state's
cutoff, old state's walk, and the shared theorem's old-cutoff separator
at the new position. The next state uses the new cutoff and new walk.
This is not the erroneous assignment of the new cutoff to the preceding
gap. Equal positions emit no geometric segment; the next strict step
still uses its own outgoing state's label.

At exhaustion `terminalSegment` transports the current separator and
walk to the final cutoff and appends the chosen center. Same-direction
exhaustion uses `none`, hence an empty carry. Switched exhaustion uses
the global-rank sentinel described above. The field `Segment.final_label`
also proves that every center-ending segment has this final label.

All actual walks come from the already proved `shared_cutoff_walk`,
which uses real earliest advances. No new assumed exchange principle,
normalization surrogate, walk-existence oracle, or progress axiom occurs
in the final theorem's inputs.

## Every gap and every mark

`sameRaw` packages each nonempty same-direction segment into
`RawSameData`. `switchedRaw` packages each nonempty switched-direction
segment into the visibly generalized `RawSwitchData`. The exact
prepared schedule, priority, center, center separator, cutoff,
endpoint separators, old outgoing walk and literal normalization
come from the prepared node and its collected trace.

For a switched edge, `switched_gap_incoming` obtains the actual preceding
`Creation` from the same root-connected `RootedHistory`. Its chronology
equation is a raw field. It does not substitute an unrelated creation
with the same endpoint triple. At the root, a supposed nonempty switched
gap contradicts `root_switched_side_empty`.

`all_gap_histories` and `RawGap.rooted` **derive** every child's
`RootedHistory` by the appropriate constructor. Child histories are
not batch inputs. The raw constructors have no field requiring I1,
I2, I3, a description, a list bound, or a compression conclusion.

`same_segment_mark` certifies every same-direction right endpoint.
An endpoint at the center uses its actual center certificate.
`switched_segment_left_mark` certifies the internal left endpoints
that become right endpoints on reversal. These applications use the
original `same_mark_certified` / `switched_mark_certified`, actual
placements, and attained cutoff certificates.

Marks are certified **before** testing whether a gap is nonempty.
Thus internal marks with empty gaps on one or both sides are retained.

`TwoWaySplit.ofSource` keeps both original source split predicates.
Its backward predicate is exactly
`(reverseSplitSyntax Z F).flip`, including exclusion of the marked
triple. `reverseBack` swaps the two proved descriptions, using the
double-reversal frame theorem. `Orientation.mark_description` then
transports the appropriate formula to the original root precedence.
Complementation alone is never used as a reversed earlier-set formula.

## Ordered covering and actual finite tree

`Run.tiles` and `Batch.tiling` prove adjacency, not just coverage by
arbitrary overlapping subsets. The parent gap list is the same-side
strict segment list followed by the reversed opposite-side list,
with endpoints and frozen triples transported back into the tag frame.
The center is the joining boundary, so it is marked once.

`Tiling.sorted` proves distinct chronological right endpoints.
`Tiling.adjacent_boundaries` proves that each left endpoint is the
parent boundary or a previous mark and that no mark lies strictly
inside a listed gap. `Tiling.partition_jobs` and `unique_part` prove
coverage and a unique chronological cell for each parent job.
`Batch.no_mark_in_child` and `child_gaps_disjoint` prove separation
of marked triples and open child gaps.

`Batch.every_child_smaller` first proves actual child-domain inclusion.
It chooses an actual center job, proves that every child omits it,
and proves strict finite-cardinal decrease. This is not a depth
bound or a presumed termination property.

`BoundedHierarchy` is indexed by an actual **original-frame complete
schedule** and its two interval times. An empty constructor proves
that its interval job set is empty. A branch contains:

1. an actual complete feasible witnessing schedule and a confined
   `Reorders` certificate from its input schedule;
2. an allowed global formula with fewer than 500 leaves, equal
   globally to the node job set;
3. the complete ordered gap tiling;
4. at least one internal mark, with an actual triple and an allowed
   original-time relative split formula with fewer than 500 leaves;
5. a child hierarchy for **every** nonempty gap, indexed by a subtype
   of `Fin gaps.length`.

Every child's input is the very same complete parent witness.
Children may subsequently normalize independently in their own copies;
their exterior schedules remain fixed by each child's `Reorders`.
`finiteNonemptyGapIndex` certifies finite branching and
`BoundedHierarchy.nodeCount` gives an actual natural-number node count.

`bounded_hierarchy_exists` constructs these branches by strong induction
on `jobCount N.domain`, using `Batch.original_child`. That theorem
derives the exact child raw history, strict decrease, original witness
equality and original endpoint equalities. Switching toggles the
`Orientation`; same-direction descent retains it.
Thus the recursive children are type-correct with exactly the required
parent witness, not merely isomorphic interval sets.

`thm_structure` starts at the real root, in the direct original frame.
It has no history, hierarchy, list, local-certificate existence or
compression premise. It includes the empty full schedule case.

## Quantification, assumptions and non-goals

There is no bound on finite job count, recursion depth, switching
frequency, or number of feasible reorderings. Inputs are an arbitrary
finite decidable job type, a `Precedence` (strict transitive global
precedence with an injective compatible rank in `1..|J|`), and a
`Schedule` (complete feasible integer slots `1..T`, three jobs per
slot). These encode the manuscript's full-schedule model.

For local arbitrary-node statements, `RootedHistory` is the actual
inductive protocol-path definition, not an invariant or success
assumption. The hierarchy theorem itself starts from its root
constructor and derives all descendant histories.

Retiring `A_MODEL` and `A_HISTORY` means that their **definitions are
now encoded** in the standalone formalization. It does not mean that
full-schedule feasibility or rank compatibility has been proved for
arbitrary unrelated data. Neither item is used as an unproved
mathematical theorem input. The original natural claim statements
are not weakened.

Only Mathlib is imported. Ordinary Lean foundational dependencies
such as classical choice, propositional extensionality, and quotient
soundness are permitted by the axiom audit. There is no `sorry`,
`admit`, new axiom, unsafe proof, finite-example substitution, external
literature assumption, or assumed invariant.

This establishes the manuscript's `thm:structure`-level existence
assertion and arbitrary-depth literal-history preservation. It does
not establish the main scheduling algorithm, its polynomial runtime,
the padding reduction, or efficient construction of lexicographic
minima. Independent Reviewer acceptance remains Host-owned.

## Reproducible evidence

`Main.lean` binds every theorem body, including all earlier modules.
`compose.py --check` checks the immutable upstream input, visible
guard transformation, extension, manifest and combined-source hashes.
No project lakefile or opaque local import is used.

`certify.py` invokes the official Lean evidence verifier on each of
the two unchanged full claims, and runs both official state/graph
checks immediately after every ledger mutation. It checks that source
and fidelity do not change during either verification.

`verify.py` is a standalone rerun: it checks both official archived
certificates and their exact source copies, recompiles all combined
theorems with Lean 4.31.0, reruns the axiom audit, and writes
`exact_certificate.json`. It does not mutate the ledger.
The durable direct-runner receipts and results are retained here.

Only this directory and the official shared math ledger are writable
by this work. Existing modules, manuscript, proof graph, progress and
activity files, and git are not modified.
