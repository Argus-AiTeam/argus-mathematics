# Same-frame historical list extension: statement fidelity

## Scope and claim

The scoped claim is **C_TFC_SAME_FRAME_HISTORY_EXTENSION_LEAN**, in the existing
context CTX_TFC. The source is `Main.lean`, namespace `SameFrameHistory`.
The principal declaration is
`SameFrameHistory.Run.priority_historical_cutoff_extension`.
Its algebraic version is
`SameFrameHistory.Run.historical_cutoff_extension`.

This is a conditional, arbitrary-depth structural theorem about the list
transformations in the staged manuscript. It is neither C_TFC_HISTORY nor
C_TFC_LISTS, and it does not prove the scheduling algorithm, the capacity-three
lemma, or either temporal boundary invariant. There is no finite enumeration
or fixed-depth restriction in the proof.

The source correspondence is:

* `build/construction.tex`, “Global lists and boundary conditions”: the global
  qualifier union, the largest-membership-index key, and local invariant I1.
* `build/lists.tex`, “Carry and pruning” and “The two updates”: suffix carry,
  the switch pair, simple injections, and ordered pruning.
* `build/lists.tex`, `lem:flatten`: local flattening of the surviving switch
  bases, proved here by an inductive invariant of the actual transformations.
* `build/lists.tex`, the same-edge part of `lem:old-low`: a bounded global
  upset agreeing with a historical carry on its parent and a bounded global
  downset extending the historical low cutoff.
* The switch-edge part of `lem:old-low` is separately formalized as
  `SameFrameHistory.switched_historical_cutoff_extension`.

The staged source directory is
`research/openai_manuscript/A-polynomial-time-algorithm-for-three-machine-unit-job-scheduling-September-24-2026/`.

## Objects and exact transformations

`Job` and `Boundary` are arbitrary types. A job type represents all global jobs
J, not just the current interval. `Data` freezes a natural-valued rank, global
cone sets D and P indexed by boundary labels, the origin boundary a₀, the
origin set Q₀, and the earlier global predicate G₀. Nothing restricts the
complexity of G₀ or gives it a Boolean-description leaf allowance.

`Entry` has four forms:

1. `first k`, denoting G₀ intersected with {rank ≥ k};
2. `root t`, denoting J with the optional rank suffix t;
3. `second t`, denoting D(a₀) with the optional rank suffix t;
4. `injection a b t`, denoting D(a) minus P(b), with optional rank suffix t.

`Entry.trim r` intersects the denotation with {rank ≥ r}.
`trim_denote` proves that identity. Trimming an already trimmed entry combines
its thresholds by **maximum**, not addition or a replacement that forgets an
earlier restriction. `trim_trim` proves the composition identity for every
entry; `first_many_trims` proves the fold-of-max identity for any finite list
of trims to the first switch base.

`Qual C L` is the union of the denotations of all entries of L. Entries need
not be disjoint, either locally or globally. `largestIndex` computes the
rightmost membership index, using indices 1 through length(L), and sentinel
zero for a nonqualifier. It recurses into a qualifying tail before considering
the head. `largest_index_rightmost` proves that every qualifying job has a
decomposition L = A ++ [e] ++ B with membership in e, no membership anywhere
in B, and returned index length(A)+1. `largest_index_pos` and
`largest_index_zero` characterize qualification. `key` pairs that index with
the unchanged rank. It is not a first-membership key.

`carryAt L d r` discards d entries, intersects the next entry with the rank
suffix r, and leaves all later entries unchanged. Thus d is a **zero-based
offset**: the manuscript's first retained index is d+1. `Cut.none` denotes an
empty carry, while `Cut.some (d,r)` denotes this suffix carry.
`carry_selected_by_key` proves globally, not only on a parent, that its union
is exactly the old global qualifiers whose old largest-index/rank key is
lexicographically at least (d+1,r). Overlapping entries are covered by this
theorem. The source does not prove the separate key-order-preservation or
pruning-comparison assertions used in boundary arguments.

`prune C U L` is precisely an order-preserving `List.filter`: an entry survives
if and only if its denotation intersects U. There is no arbitrary deletion
relation. `prune_local` proves that pruning preserves the qualifier union on U,
without asserting any equality outside U.

`Run` is an inductively generated relation on the current set and actual list:

* `Run.root` starts at global J with the **one-entry list (J)**.
* `Run.switched` starts at any U subset Q₀ by pruning the exact ordered pair
  (G₀ intersect {rank ≥ h₀}, D(a₀)) on U.
* `Run.same` chooses a child V subset U, takes a carry of the current list,
  appends the **untrimmed** injection D(a) minus P(b), then prunes on V.

These are the only constructors. The number of same updates is arbitrary.
Neither flattening, a formula-size bound, nor any extension is a constructor
or a hypothesis of `Run`. Allowing empty children, arbitrary cut positions,
and non-strict shrinking makes this relation more general than the manuscript
protocol, so actual valid runs are included without requiring normalization
or separator existence to prove the structural theorem.

## Derived history invariant and flattening

`Run.shape` is proved by induction over `Run`; `Run.carry_shape` then covers
every terminal unpruned carry, before a fresh injection is appended.
Its `Shape` conclusion has three alternatives:

* every entry is simple; or
* the list is `first k :: second none :: T`, with T consisting solely of
  injections, and the current set U contained in Q₀; or
* the list is `first k :: T`, with T consisting solely of injections,
  U contained in Q₀, and **every point of U outside D(a₀)**.

The last condition means D(a₀) is empty **on U**, not globally.
It is obtained from the failed pruning test for the second base and inherited
on all shrinking descendants. A suffix cut that trims or discards the second
base has already discarded the first. Consequently, no history retaining the
first base can produce a trimmed second base.

`Run.first_survives` states these last two alternatives whenever `first k`
is a member of the terminal carry. It therefore identifies the second base
as untrimmed if present, or certifies its emptiness on U if it has been
pruned. `Run.first_absent` gives simplicity of every carried entry if the
first base is absent.

Given origin coverage Q₀ minus D(a₀) subset G₀, `pair_flattening` and
`lone_flattening` prove the actual set identities on U. In the paired case,
the carried bases have union agreeing on U with

    D(a₀) union {rank ≥ k}.

In the lone case the same formula agrees with the remaining first base,
because D(a₀) is empty on U. Agreement outside U is neither required nor
asserted. These lemmas are applied to the derived `Run.shape`, rather than
taking either carried-pair identity as an input.

## External hypotheses, exactly separated

The main priority-cutoff theorem universally quantifies C, a relation R on
jobs, U, L, a terminal cutoff c, and current boundaries a,b. Its inputs are:

1. `FrameLaws C R`: rank is nondecreasing along R; every D(a) is an upset;
   every P(b) is a downset.
2. `history : Run C U L`: an actual derivation using the constructors above,
   at arbitrary finite depth.
3. `coverage : C.Q₀ \ C.D C.a₀ ⊆ C.G₀`: coverage of **all** the origin
   remainder, not just the first child.
4. `five : L.length ≤ 5`: the independent capacity-three lemma's current
   pruned-list bound. It is not proved here and is not assumed of an
   unpruned list after appending a new injection.
5. `localI1 : LocalI1 C U L a b`: U intersect Qual(L) subset P(b), and
   U minus Qual(L) subset D(a). This is an external local invariant, not a
   claimed preservation theorem. Only its old-high inclusion is needed to
   identify the priority low cutoff.

For a root-origin application the unused G₀ and Q₀ may both be instantiated
as J, making coverage automatic. The generic theorem writes the coverage
hypothesis uniformly; it is not deriving that origin coverage from scheduling.

The main extension proof does **not** need G₀ itself to be an upset: its
possibly complicated predicate disappears from the output formula. The
auxiliary `entry_up` proves the manuscript's global-entry closure when
`IsUp R C.G₀` is additionally supplied. This is an honest strengthening of
the structural extension result, not an omitted closure assumption.

No hypotheses assert the resulting flattened formula, the existence of an
extension, a bound on G₀, the twenty-/twenty-one-leaf conclusion, or an
equivalent semantic compression property.

## Priority cutoffs and conclusions

`KeyLT` is the strict lexicographic comparison with (d+1,r);
`key_lt_iff_not_ge` proves its complement relation with `KeyGE`.
`promotedByKey` is all old qualifiers in the empty-carry case, and the old
qualifiers with strictly smaller key in the nonempty-cut case.
`priorityLow` is the restriction to U of

    (P(b) minus Qual(L)) union promotedByKey(L,c).

This is the manuscript's initial same-direction low group followed by its
promoted old-high prefix. It does not include the fresh injection.
`selected_subset_qual` and `priority_low_eq_historical` derive, using local I1,
that this low set equals

    U intersect (P(b) minus Qual(carry(L,c))).

Thus this identity is not assumed in the main priority theorem.

`Run.priority_historical_cutoff_extension` produces two **Boolean ASTs**
`high` and `low` and proves all of the following:

* high denotes a global upset for R;
* high has at most **20 leaves**;
* low denotes a global downset for R;
* low has at most **21 leaves**;
* low is exactly the constructed AST `lowFormula b high`;
* for every x in U, membership in high is equivalent to membership in the
  terminal carry union;
* U intersect the global denotation of low is **equal** to `priorityLow`.

`lowFormula` is P(b) AND the normalized complement of high.
The AST has only literal tests and binary AND/OR nodes. Literal tests are
true/false, fixed D/P cone membership, and natural rank thresholds, with
optional negation on literals. Complement pushes negation to leaves using
De Morgan's laws; `compl_leaves` proves that it preserves the number of
leaves. **G₀ is not an allowed output atom.**

Untrimmed injections have exactly two leaves and trimmed injections exactly
three (`injection_untrimmed_leaves`, `injection_trimmed_leaves`).
Other simple entries have at most three leaves; the replacement pair has
two. `Shape.small_upset` constructs an actual formula with at most
1 + 3*length(carry) leaves, including a one-leaf false terminator.
`carry_length` derives length(carry) ≤ length(L). The five-entry premise
therefore gives an even stronger numerical estimate than the reported
twenty-leaf bound. The one additional P(b) leaf gives the reported
twenty-one-leaf low formula. Empty carries are covered using false, not a
zero-cost nonexistent formula.

For a switched incoming edge,
`switched_historical_cutoff_extension` constructs
NOT D(a) AND {rank ≤ r}, proves its leaf count is exactly two, proves it
globally downward closed, and proves its restriction to U is the indicated
rank prefix of U minus D(a).

## Remaining interfaces and nonclaims

An application to the full manuscript must still:

* instantiate global frozen cone sets and establish `FrameLaws`, and the
  additional G₀ closure if asserting that the historical entries are upsets;
* provide origin coverage from the switch construction;
* supply the independent five-entry capacity-three bound and local I1;
* translate a chosen schedule's promotion/walk data to `Cut`, and its
  same-frame path to `Run`;
* supply actual finite triples, the finite rank range 0..N+1, and rank/frame
  reversal conventions. The structural theorem generalizes to arbitrary
  job types and natural thresholds; it does not prove finite-family
  enumeration or the permitted threshold bounds;
* prove all temporal-boundary, feasible-exchange, I2/I3, cross-frame
  preservation, separator, and algorithmic completeness obligations.

In particular there is no assertion here that an arbitrary `Run` derivation
is schedulable, that a five-entry bound follows solely from suffix operations,
or that the whole alternating-frame history is correct.

## Toolchain and reproduction

The source compiles with Lean **4.31.0**, using the prebuilt Mathlib workspace,
without a campaign lakefile. The development command is:

```sh
cd /home/argustest/.local/share/argus-skill/mathlib-v4.31.0
/home/argustest/.elan/bin/lake env lean \
  /home/argustest/zimo/counterexample-batch-1/campaigns/9000124/research/two_frame_compression/formal_lists/Main.lean
```

Official certification, after recording the scoped claim with this source
as its formal statement, uses:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/two_frame_compression/formal_lists/Main.lean \
  --statement-fidelity research/two_frame_compression/formal_lists/statement_fidelity.md \
  --claim C_TFC_SAME_FRAME_HISTORY_EXTENSION_LEAN \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/9000124 \
  --artifact-dir research/two_frame_compression/formal_lists/evidence \
  --lean-bin /home/argustest/.elan/bin/lean \
  --lake-bin /home/argustest/.elan/bin/lake --lake
```

The evidence directory contains the canonical compiled source, this fidelity
document, the compiler result and log, and the official immutable certificate
archive. The original source and fidelity document must remain unchanged
during verification. Compilation establishes the Lean statements under their
explicit inputs; it does not constitute independent review of this
source-to-manuscript correspondence.
