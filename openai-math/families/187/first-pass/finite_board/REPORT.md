# Finite-support certification of the 21-move Snaky certificate

## Result

The new mathematical assertion is a support-sensitive extraction theorem:
a composition certificate of height `h`, empty required set, and envelope
`T` with `|T| >= 2h-1` admits one Maker policy confined to `T`, winning within
`h` actual fresh claims against arbitrary legal lattice replies. The policy
is selected before Breaker plays. Victory ends the game, so it requires at
most `h-1` intervening replies and no reply after the winning claim.

For the staged certificate this yields a policy confined to the **actual**
251-cell envelope `T_727`, winning within 21 claims. Its envelope is contained
in `[0,16]^2`. The same policy therefore works on the 251-cell board and the
17-by-17 board.

This supplies a formal certification of the finite-support semantic boundary,
not a new construction or an improved move bound. Independent assessment of
statement fidelity, significance, and novelty remains with the Host's
Reviewer.

## Source and comparison with the strongest prior result

The immutable input is OpenAI, *Snaky in 21 Maker moves*, September 25, 2026:
`research/openai_manuscript/Snaky-in-21-Maker-moves-September-25-2026/`.
The propositions used to establish scope are the six-base and combination
lemmas in `build/templates.tex`, the endpoint in
`build/certificate-proof.tex`, and the finite-board corollary in
`build/strategy.tex`. The input data and short reconstruction program are
`verification/certificate.txt` and `verification/verify_certificate.py`.

The existing upstream theorem
`OAI.SnakyPrototype.snaky_winning_strategy_21_with_legal_states`,
in `lean/OAI/GameTheory/SnakyTwentyOne/Main.lean`, already gives an ordinary
fresh 21-claim infinite-board policy. Its scope document `lean/docs/187.md`
explicitly excludes the smaller finite-board restriction. That theorem alone
cannot establish confinement: its replacement move and its abstract
policy selector may choose cells outside the envelope. It is not assumed in
the proof here. The finite-support semantics, capacity invariant, stopping
semantics, and source-bound certificate transcription close that remaining
boundary.

No relevant Snaky or Maker--Breaker result was found in the supplied project
Wiki. No claim is made that the composition method itself is new. The proof
does not depend on Sieben's or Halupczok--Schlage-Puchta's results cited
elsewhere in the manuscript.

## Resource-sensitive composition proof

Write a card as `(A,T,h)`. Its strengthened interpretation is:
for every finite master envelope `U` containing `T`, and arbitrary finite
disjoint ownership sets `M,B`, if

    A subset M,   B disjoint T,
    |M| + |B| + 2h <= |U| + 1,

then Maker can win within `h` fresh claims in `U`.
Breaker ownership and future replies outside `U` are allowed.

For a base card `(S erase p,S,1)`, either `p` is owned and the shape is already
complete, or claiming the fresh, unblocked `p` wins immediately. There is no
Breaker-turn hypothesis after that claim.

For nonempty children `(A_i,T_i,h_i)`, set

    n = max_i h_i,
    A = ((union_i A_i) union (intersection_i T_i)) erase p,
    T = insert p (union_i T_i),  h = n+1.

All children have positive height. Since `p` is in the parent envelope,
it is not Breaker-owned. Claim `p` if it is fresh. If it is already owned,
choose a fresh cell of `U`; the resource inequality implies
`|M|+|B| < |U|`, so such a cell exists. Either choice is one actual claim
and puts `insert p A` inside the new Maker set.

After any legal reply `b`, at least one child envelope avoids `b`.
Otherwise `b` belongs to every child envelope, hence to `insert p A`,
which Maker owns, contradicting reply legality. The chosen child still has
all required Maker cells and no Breaker cell in its envelope. Inserting a
fresh Maker cell and a fresh Breaker cell increases the total count by exactly
two. Reducing the budget from `n+1` to `n` preserves the capacity inequality.
Child heights below `n` are weakened to `n`. This proves composition.

Signed coordinate permutations and translations preserve both Snaky and this
interpretation by pulling all three finite sets `U,M,B` back through the
corresponding equivalence. Image cardinalities are preserved. The eight
orientations use the short checker's bit convention, explicitly converted
to the coordinate convention of the formal geometry.

The root inequality is very slack: `2*21 <= 251+1`. The relevant sharp
resource issue is not asymptotic size, but charging every replacement and
keeping it in the master envelope.

## A single policy and actual play

The proposition `WinIn` expresses supported bounded winning with an explicit
immediate-victory constructor. From an unwon state with positive budget,
it supplies a supported fresh good move, either immediately winning or
preserving bounded winning for every legal reply.

Choose a good move as a function only of the remaining budget and the two
ownership sets. This defines `policy` once. The proof `fixed_policy` shows
the same policy works throughout the entire branching game tree; no policy
is selected after seeing the Breaker continuation.

`Execution` provides an early-stopping transcript against each legal
continuation. It records every Maker claim as a fresh insertion, including
replacement claims, and every intervening Breaker reply as a fresh insertion.
Its summary proves disjointness and the exact terminal cardinalities.
Starting empty, the numbers `c,d` satisfy `c=d+1`, `c<=21`, and `d<=20`.
The trace stops before requesting a reply when a claim wins.

The formal quantification over lattice replies includes, rather than
excludes, replies outside the certificate envelope. Restriction to a finite
superboard is therefore immediate. It is nonvacuous: at most 40 cells are
occupied before claim 21, and at most 39 before any requested reply, whereas
the common envelope has 251 cells.

## Exact source replay and adversarial checks

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/finite_board/verify.py

The standard-library verifier reuses the staged short checker's `verify`
function, independently parses the original backward references and inline
compositions, and checks all local set obligations. It checks injectivity
of each finite placement and the eight orientation signatures, including
closure, inverses, and negative-coordinate probes. These finite checks are
not represented as a proof of universal play; the quantified theorem is
proved separately in Lean.

The replay covers 728 numbered cards and 1,620 composition nodes (including
inline nodes). It checks 35,422 local unowned reply classes plus one outside
class per composition. The endpoint is

    A_727 = empty, h_727 = 21, |T_727| = 251,
    T_727 subset [0,16]^2.

`exact_certificate.json` contains the exact root envelope and these counts.
The verifier compares all certificate expression declarations in `Main.lean`
with the staged text; it does not regenerate or substitute precomputed set
snapshots. `--emit-lean` is an explicit source-generation mode and is not
needed for replay.

The Lean source names earlier cards directly and uses eager checked vectors
for each nonempty child family. Whole-program kernel reduction exceeded a
1,200-second bound; this was a computational obstruction, not a mathematical
counterexample. The replacement is proof-producing local normalization:
`cacheCard` proposes literal finite data using evaluation, proves every field
equality by kernel reduction, and transports the original semantic proof
through `cached`. Named multiset equalities retain the checked local proofs;
`copyFinset` transports distinctness from the original finite set, avoiding a
second quadratic distinctness computation. Runtime-erased quotient wrappers
are read only in the unsafe metaprogram to propose representatives; no
logical proof relies on that cast or on native evaluation.
The resulting proof still checks the exact source DAG,
including every inline node, without accepting native-computation axioms.

Jacobian 0.14.0, protocol 2025-11-25, was discovered and its
`game.deterministic_terminal.solve` contract inspected before custom code.
That operation accepts a fully materialized arena of at most 4,096 states,
not a compressed recursive certificate. One bounded, exactly matching
one-gap Snaky base arena was solved. Its exact payload, typed output,
contract, discovery response, and exit status are retained in the dedicated
`jacobian_*.json` files. Its one-move result supports only that base arena;
it is not used as evidence for the 21-move policy.

No literal false manuscript assertion was established. Accordingly no
`F_...` refutation claim is asserted or inferred from an implementation
error, a failed compiler attempt, or the limited Jacobian contract.

## Certification boundary

`Main.lean` imports only Mathlib, not the upstream Snaky library.
The geometric and semantic proofs are ordinary Lean proofs; endpoint
computations use `decide +kernel`, not native-computation axioms.

The authoritative compilation is the Argus `lean_evidence verify` run
attached to `C9000187_FINITE_BOARD`, with the statement-fidelity document
bound to that source. The tool on this host accepts the source as a
positional argument, rather than a `--source` option.
The authoritative Lean 4.31.0 run completed successfully: compiler exit 0,
`proof_holes=[]`, and separate axiom-audit exit 0. Its archived certificate is
`certificates/C9000187_FINITE_BOARD-c7525ab06cab5759.json`.
The source and statement-fidelity hashes were checked against the persistent
files after the run. The ledger reports `C9000187_FINITE_BOARD` as
`closed_kernel`, with no undischarged assumptions.

Both principal declarations depend only on the standard logical axioms
`propext`, `Classical.choice`, and `Quot.sound`; no native-computation axiom
or recovery `sorryAx` occurs in their dependencies. The full compile and
audit took 2,194.071 seconds. This is the complete source-bound quantified
policy certification, not just the earlier finite replay or profiling
checkpoints.

The manuscript base, combination, and endpoint assumptions are discharged
by `base_valid`/`base`, `compose_valid`/`combine`, and `endpoint`,
respectively, together with the exact source replay. The comparison with
the prior upstream infinite-board theorem is not a premise of this proof;
its independent citation attribution remains a Reviewer obligation.
Independent Reviewer replay and acceptance remain pending.
