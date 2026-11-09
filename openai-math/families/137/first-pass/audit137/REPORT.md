# One shared pool, weighted suspended guesses, and epoch paths

## Result and scope

We give a universal formal verification of the **implemented recursive
schedule**, not just its interpolation identity. The target is
`evaluation.tex`, Lemma `lem:weighted-evaluation`, and the epoch
dependency specialization in `simulation.tex`, Lemma `lem:epoch-weight`.
The code is `Main.lean`; its exact reading and limits are in
`STATEMENT_FIDELITY.md`. The real compiler result recorded by
`lean_evidence verify --claim C137_WEIGHTED` is authoritative.
Independent Reviewer acceptance remains pending.

The official Lean 4.31.0 compiler and axiom audit both exited zero, with
`proof_holes=[]`. The claim-bound certificate is
`research/audit137/certificates/C137_WEIGHTED-27839afb29348646.json`;
`exact_certificate.json` records its actual invocation and the finite
diagnostics. The persisted source/fidelity freshness check also passed.
The derived ledger status is `conditional_kernel`, explicitly retaining
`A137_UNIFORM_BITS`.

Both official campaign-local validators exited zero against
`campaigns/9000137`.
Proof-graph nodes remain open and `reviewer_confirmed=false` until the
Host Reviewer independently checks replay and statement fidelity.

The source is the staged September 25, 2026 manuscript under
`research/openai_manuscript/Simulating-One-Tape-Time-in-Two-Fifths-Power-Space-September-25-2026/build/source/`.
No false assertion was identified in the targeted evaluator. This result
does not certify the complete Turing-machine theorem or claim to refute it.

## Verification theorem

Let `K` be any field, let each register be a vector of length `n >= 1`,
and let there be exactly `p` shared registers. Consider a well-founded
dependency system whose ordinary local kernels are separately
homogeneous of degree `d`. Supply distinct-node interpolation stencils
for every required degree; the manuscript's field-cardinality bound
ensures their existence. At a history vertex there are `2^g` candidates,
`g+1 <= n`, one distinguished history dependency, and `N` array roles.
Its output kernel has history degree `d`; each predicate has degree `d`
in history and separately in its own array argument. Distinct slots are
required within an invocation, but dependency identifiers may repeat.

Fix semantic vectors independently of all working registers, satisfying
the local rules at these fixed vectors. Give ordinary and distinguished
history edges weight one, and history-to-array edges weight `g+1`.
Let `W(V)` be the maximum weighted dependency path.

**Theorem.** For every scalar, target, and initial contents of the entire
pool, the recursively defined `evaluate` schedule adds
`scalar * value(V)` to precisely its target and restores every other
register. Its live local/suspended storage is at most `2*n + W(V)` units,
with no ancestor vector copies. Including the shared pool, the bound is
`p*n + 2*n + W(V)` units.

This is proved in `certified_acyclic_weighted_evaluator`,
`certified_entry_registers`, and `weighted_evaluator_bit_bound`.
`maximumHeight_is_maximum` constructs and proves the path maximum.
For positive ordinary arity, `maximumHeight_attained_at_base` identifies
it with the manuscript's base-ending maximum.

For the original Boolean lookup construction with fixed positive fan-in
bound `r`, `n=d+1` and
`p=max(3,r+1)`. `exact_pool_capacity` constructs the required input and
target slots for exactly this pool size. The Boolean lookup factories
prove every local algebraic premise of the theorem, including
augmentation, rather than assuming an interpolation oracle.

The structural theorem permits arbitrary fields and fixed field-vector
semantics, not only augmented Boolean vectors over characteristic two.
This extension requires the same fixed-argument semantic identity; it
does not assert that a characteristic-two identity holds in other fields.
The generic arithmetic proof also permits well-founded finitely branching
identifier systems beyond finite graphs. Uniform bit bounds still require
the original short-description and local-computation hypotheses.

## Why this proves the schedule

The homogeneous basis and complete Boolean lookup are defined directly.
Their line polynomials are constructed using sums and products of linear
forms. `Stencil.extract` then applies Mathlib's kernel-checked Lagrange
coefficient theorem. Constant-one coordinates retain their homogeneous
extensions, and no augmentation coordinate is assumed nonzero. No
factorials or derivatives are used.

The ordinary program actually nests the sample loops, shifts the chosen
child slot recursively, executes the next level, and reverses the shift.
The history program actually loops over outer history samples,
coordinates, candidates, array factors, and inner array samples in that
order. It retains the predicate scalar across the reverse array call and
multiplies completed factors into one scalar. Nonbase outputs are never
computed by reading a semantic-value oracle.

The register proof is simultaneous over all targets, scalars, and entry
assignments. A reverse call therefore need not see the original contents
of other registers. In particular, descendants may borrow a caller's
partial target or shifted history and restore them before the caller
reads them again. `evaluate_correct` closes the child contracts by
induction on the implemented recursion; they are not a global assumption
of the final theorem.

The implementation has one mutable pool. Scalar local reads use one
reusable scratch area. The formal scope `frame 1` retains short caller
data. At a history vertex, `frame g` encloses only the
coordinate/candidate/factor loops, with both distinguished-history calls
outside it. Thus the monitored caller cost is one on a history edge and
`g+1` on an array edge. Sequential peaks are combined by maximum, not
addition. The current frame plus scratch costs at most `2*n`; induction
gives `2*n+W`. This argument charges the suspended and current guesses
separately, rather than silently putting either into disposable scratch.

The space semantics describes the source's in-place algorithm, not the
memory consumption of a Lean executable evaluating pure functions or
materializing mathematical enumerations. Loop lists denote finite
counter enumerations. With the provided local kernels, navigation, field
arithmetic, and short descriptions, a sufficiently large
`ell=polylog(T)` bit budget represents one unit. The exact formal integer
bound then gives `O((d+W+1) polylog(T))` bits. These implementation/encoding
promises remain explicit as `A137_UNIFORM_BITS`, not hidden in a claim
of complete kernel certification of a Turing machine.

## Epoch specialization

The formal relation includes all five edge forms from the source:
preceding history, history to array, extraction to the previous epoch,
checkpoint to previous array, and checkpoint to previous final history.
Set `B=k+g+2` and define

`P(A[e,i]) = e*B`,

`P(H[e,j]) = e*B + j + g + 1`.

Every edge satisfies `weight + P(child) <= P(parent)`. A separate
zero/one credit for each fixed epoch is spent on that epoch's
history-to-array edge and cannot be replenished by another permitted
edge. `at_most_one_guess_per_epoch` proves the one-expensive-edge claim,
and `epoch_weight_bound` gives

`W(H[E-1,k]) <= E*(k+g+2)`.

`certified_epoch_evaluator` applies that relation to the actual recursive
evaluator, and `epoch_navigation_wellFounded` derives acyclicity from
the same potential. There is no assumption about independence of blocks.

For `g=k*c`, `b=k^2`, and the exact source ceiling count

`E = ceil((1 + ceil(T/k^2))/k^2)`,

`epochCount_le` proves `E <= k+1` whenever `k>=1` and `T<=k^5`.
With three registers, `certified_two_fifths_mechanism` proves, for the
same arbitrary-entry execution, the explicit bit-model bound

`(5*(d+1) + 4*k^2*(c+1))*ell`.

The manuscript has `k=ceil(T^(1/5))`,
`d=O(k^2 log(T+2))`, and `c=O(log(T+2))`. The displayed bound therefore
has the asserted two-fifths exponent, conditional on the separate
simulation and uniform-local-kernel obligations. It is not merely a
re-optimization of a presumed space estimate.

## Exact diagnostic replay

`verify.py --finite-only` replays the source schedule over GF(4) and GF(8)
and checks the saved finite certificate. The recorded run passed 8,480
entry-pool test cases under independently computed expected semantics.
For one ordinary
and one factored-history instance, all 4,096 GF(4) pool assignments were
enumerated at target zero and scalar one. Further cases vary every target
and scalar on nested borrowing instances and on width-two, zero-guess
histories. Array roles repeat the same dependency identifier and therefore
have fully correlated values.

The run made 2,719,584 recursive GF(4) calls and 19,392 GF(8) calls.
There were 640,968 lookup evaluations with a zero augmentation coordinate.
Every checked output satisfies both target translation and exact
non-target restoration. The abstract stack monitor agrees with the
weighted-path bound. These are **finite diagnostics**, not the proof of
the universal theorem or measurements of Python heap memory.

Before custom field computations, the authorized Jacobian adapter was
used to discover and inspect
`finite_field.polynomial_map.table.compute`. Its exact input is in
`jacobian_payload.json` and unmodified typed response in
`jacobian_output.json`. Server version is 0.14.0, protocol 2025-11-25;
the bounded GF(4) cubic-map computation completed with adapter exit zero,
no timeout, and no error. The replay independently matches its four map
entries. The operation has no recursive-register or storage contract, so
this is an arithmetic cross-check only, not support for a nearby but
different mathematical postcondition.

## Comparison, exclusions, and remaining dependencies

The strongest prior result in the initial campaign artifacts was the
manuscript's prose proof of the evaluator. There was no prior
claim-bound formal proof of its recursive schedule or weighted storage in
the campaign ledger. This work adds those proofs and an exact epoch
corollary, rather than only testing local coefficient formulas.
Its publication significance and novelty are not self-certified;
independent Reviewer assessment remains required.

The known scale-only route, recorded before implementation, was retired:
optimizing `B+L+T/(Bq)+Tq/(BL)` cannot decide whether recursive borrowing
preserves caller data or whether the guess is actually suspended.
Section `sec:balance` already treats that estimate. No bounded no-witness
search has been promoted into campaign completion.

The full-machine theorem still requires the concrete visit/access
implementation, raw replay uniqueness, the semantic factored-history
identity for actual machine checkpoints, and the remaining uniform
bit-encoding and field-construction arguments. The real-power rounding
and unknown-running-time clauses are not Lean conclusions here.
These dependencies remain visible in `PROOF_GRAPH.json` and the ledger.
No independent Reviewer verdict, `verified_new` novelty status, or final
campaign acceptance is claimed by the Engineer.

To replay all evidence, run
`$WORKSPACE/argus-live-update/.venv/bin/python research/audit137/verify.py`.
The default replays the finite certificate, invokes the real official
Lean verifier with `--claim C137_WEIGHTED`, and checks the campaign-local
ledger and proof graph. `--formal-only` or `--finite-only` selects one
component without repeating unchanged work.
