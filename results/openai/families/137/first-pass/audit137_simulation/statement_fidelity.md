# Statement fidelity: C137_REALIZATION

This document describes `Main.lean`, namespace `Simulation137`. The claim is
an exact semantic realization and composition theorem, not an extracted or
compiled Turing-machine implementation. The imported `AcceptedEvaluator.lean`
is a byte-identical copy of the independently reviewed
`research/audit137/Main.lean`; its archived certificate is
`research/audit137/certificates/C137_WEIGHTED-27839afb29348646.json`.

## Objects and hypotheses

`Machine Q S U rho` has one writable head, `rho` read-only heads, a halting
predicate, and a deterministic transition. Its `Instruction.unit` proves that
every head moves by an integer of absolute value at most one. `Q`, `S`, and `U`
are arbitrary types in the semantic theorems; no finiteness or effective
encoding of these types is silently supplied by Lean. The finite-machine
interpretation uses finite alphabets and finite control.

`Controller Q (rho+1)` contains state, natural elapsed time, signed head
displacements, and a running/halted/timeout flag. `Safe T z` means
`z.elapsed <= T` and every displacement has absolute value at most elapsed
time. It does NOT mean reachable. `T` is a supplied natural cap. The
realization proofs also cover zero and small caps; the manuscript's
asymptotic application uses its stated cap convention.

`Raw c = Fin c -> Bool`; equality is equality of all literal bits. A
`RawCodec R C` supplies a total optional decoder, encoder, and the law
`decode z = some c -> encode c = z`. The whole-tape iteration and final-output
theorems additionally quantify the explicit safe-output roundtrip law
`Safe T c -> decode (encode c) = some c`. These are encoding laws, not an
assumption that visits or replay are correct. A symbol decoder is total on
every raw symbol word, including malformed ones. The separate theorem
`tape_run_decodes` assumes `decode (encode s) = s` to identify raw-tape
semantics with ordinary symbol-tape semantics. No such law is claimed for a
raw malformed word.

A `Partition` has positive natural width and any signed offset. Its block
index uses mathematical floor division, including at negative positions.
`point`, `slot`, and `Partition.reconstruct` give the physical coordinate
convention. Offsets used for averaging are exactly `Fin b`, represented as
integers `0,...,b-1`. `blockLow`, `blockHigh`, and `blockCount` select exactly
the blocks meeting `[-T,T]`; `finiteSelector` is their increasing relabeling.

## Total visits and access

`checkedDecode` rejects either a malformed controller or a controller that
fails `Safe T`. `rawSelector` then selects the origin block, and `rawVisit`
returns the fixed dummy controller and the incoming block unchanged. For the
concrete `finiteVisit`, that dummy is `dummyController q0 (rho+1)`: time zero,
all positions zero, timeout. An accepted terminal raw controller and its
buffer are returned unchanged.

For accepted running controllers, `visitLoop` and `tapeVisitLoop` first
check halting, then the cap. A transition reads and writes the OLD writable
position, moves the heads, updates elapsed time, and only then tests block
departure. There is no destination-block read. `finish`, `halt_has_priority`,
and `timeout_at_cap` express halt-before-timeout; terminal inputs remain
absorbing even if their speculative flag/state combination is unreachable.

`raw_queries_confined` proves that every recorded writable or read-only
query has absolute position at most `T`, for EVERY raw controller and
incoming raw block. `visitQueries`/`rawQueries` are a specification of the
positions queried by this recursion, not a stored execution log or an extra
space charge. `small_departure_owned`, `visit_preserves_exterior`, and
`raw_preserves_exterior` express old-block write ownership and preservation
of unaccessed exterior entries. The functions take an abstract symbol
accessor on integers; the theorem proves that the calls use only its original
radius-`T` domain, not a broadened domain.

`visit_agrees_with_one_tape`, `raw_one_tape_agreement`, and
`raw_serial_one_tape` identify local block execution with the capped
whole-tape recursion `tapeRun`. These equalities include raw buffer contents,
not just their decoded symbols.

## Replay and complete raw suffixes

`replay_exact` is universal over a deterministic total visit function,
arbitrary raw incoming controller, arbitrary initial block family, and ANY
finite proposed list. Every block scans the whole proposed list, including
after a failed comparison; the selector uses the proposed incoming raw
controller and comparisons use raw equality. All final flags pass if and
only if the list equals the serial reference transcript. When they pass,
every replayed final block equals the reference final block.

`concrete_raw_replay` instantiates this theorem with the manuscript-style
`finiteSelector` and packed `finiteVisit`. It assumes neither controller
reachability nor a well-formed initial controller or initial block.
`unique_raw_suffix` proves uniqueness after an arbitrary correct prefix by
replaying that prefix FROM THE EPOCH-START blocks. It does not substitute a
round-start block for an epoch-start block.

## Boolean epoch words and evaluator interface

`pack` flattens raw controllers and zero-pads to `d` bits; `slice` and
`parsedOut` are total even for malformed words or out-of-width slices.
`blockPacking` is a bijection between grouped raw symbol bits and the
literal `b*ell` block bits. It does not decode symbols.

For every epoch-start controller and block family, every prefix length `m`,
and every round length `k`, `round_unique` proves that exactly ONE complete
`k*c`-bit suffix passes all block predicates, provided the semantic prefix
fits: `(m+1)*c <= d`. `candidateList` enumerates all `2^(k*c)` raw suffixes
bijectively. This finite enumeration is expressed with a finite equivalence;
an efficient binary implementation of its ordering is not compiled here.

For every field `K`, `round_factored_identity` proves the augmented
coordinate-wise sum-product identity, including augmentation coordinate
one, at the padded reference prefix and epoch-start blocks.
`round_instantiates_reviewed_history` invokes the imported
`Audit137.semantic_only_history_identity` with this PROVED premise. No
identity is assumed or asserted for a malformed prefix, an arbitrary
Boolean tuple inconsistent with reference data, or off-Boolean field
vectors. The Boolean lookup functions themselves remain total there.

For `k >= 1`, let `b=k*k`, `R=1+ceilDiv T b`, and
`E=ceilDiv R b = Audit137.epochCount T k`. The common word width satisfies
`b*ell <= d` and `(b+1)*c <= d`; the manuscript may choose their maximum
with one. `guess_fits` proves `k*c <= d`. `epochRules` actually defines the
base, history, block-checkpoint, and controller-extraction rules on
`Vertex E N k`, with three register slots. `epoch_rules_semantic` proves
their fixed reference values; `epoch_rules_navigation` maps every actual
dependency to the imported epoch edge relation, including repeated rule
identifiers. The graph is not an assumed simulation-kernel oracle.

`certified_raw_epoch_evaluator` instantiates these rules with the concrete
finite raw kernels. For all scalars, target slots, and arbitrary entry pools,
the imported recursive evaluator changes exactly the target by the scalar
times the augmented semantic last-epoch word and restores every other slot.
Its explicit model charge is at most

`(5*(d+1) + E*(k+k*c+2))*unitBits`.

`certified_two_fifths_realization` additionally assumes `c>=1` and
`T <= k^5`, and bounds this by

`(5*(d+1) + 4*k^2*(c+1))*ellCost`.

Here `ellCost` names the formal theorem's final scalar argument `ell`; it is
a resource-pricing parameter, NOT the raw symbol width. These are bounds on
the imported charged execution model. Pricing arithmetic, lookup
generation, navigation, and encodings by actual work bits is the explicit
remaining implementation boundary.

## Actual averaging, padding, and finite-control output

`physical_crossing_event` proves that a nonstationary unit move crosses a
boundary for exactly its residue offset, including left moves and negative
positions. `actual_crossing_sum` bounds the sum of crossing counts of the
ACTUAL shared capped execution over all offsets by the step fuel.

`visit_outcome_and_crossing_credit`, `actual_macro_completion`, and
`macro_outcome_invariant` prove, rather than assume, the completion
connection: a nonterminal local visit spends a remaining crossing, and each
local visit preserves the complete remaining capped outcome. Consequently
`supplied_cap_completed_offset` gives an offset whose `R` actual visits
are terminal and equal the full `T`-step capped execution, for every safe
elapsed-zero initial controller and every raw initial tape.
`epoch_padding_capacity` and `completed_epoch_padding` justify padding to
`E*b` visits. The older abstract `completion_budget` helpers are not
premises of this result.

`finite_reference_embeds`, `reference_change_blocks`, and
`packed_reference_one_tape` prove the finite block relabeling and raw-bit
packing connection. `represented` obtains initial tape bits only inside
`[-T,T]` and uses the supplied filler outside it, including in the exterior
part of boundary blocks. `assemble_represented` and
`tape_run_radius_extensional` prove that this replacement does not change
the capped controller outcome.

Finally `capped_epoch_output_correct` universally quantifies the above
machine and controller interfaces, `k>=1`, the history-width inequality, a
safe decoded elapsed-zero raw controller, any initial raw tape, any filler,
and the safe-controller roundtrip law. It provides an actual offset for
which the last raw controller slice in the padded final epoch equals the
canonical encoding of `tapeRun`'s capped controller, and that controller is
terminal. With the symbol roundtrip law, `tape_run_decodes` identifies this
with the ordinary symbol-tape machine's controller. This output is finite
control, head/time bookkeeping, and halt/timeout; it is NOT a procedure for
materializing the final tape.

## Limits of the certification

The compiler checks these semantic equalities and the explicit charged
resource-model inequalities. It does not verify machine-code extraction,
uniform bit costs, finite controller-field layouts, construction of the
interpolation stencils in a bit machine, the access procedure's stated cost,
or a binary low-space enumerator matching the abstract finite equivalence.
Those are retained as implementation obligations, not hidden under
`A137_SIMULATION_KERNELS`. The finite Python experiments are diagnostics,
not a proof of these universally quantified assertions. Compilation is not
an independent judgement of this translation, its novelty, or its
publishability; that remains for the Host-invoked Reviewer.
