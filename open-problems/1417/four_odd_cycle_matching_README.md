# Four unequal odd cycles with unrestricted cross-cycle matching

Let F be the disjoint cycles on the inclusive vertex intervals [0,8],
[9,19], [20,32], and [33,49], each in increasing cyclic order. Let M be any
perfect matching of the 50 vertices whose edges join distinct cycles of F.
The question is whether a connected F union M avoids simple cycles of
length 4, 8, 16, and 32. Chords do not invalidate a cycle.

Every completion is simple and cubic. In fact every completion is connected.
A component must contain whole fixed cycles, and cannot contain just one,
since matching edges join different cycles. A disconnected completion would
therefore partition the four cycles into two pairs. Within either component
the perfect matching would be a bijection between two cycles of unequal
orders, which is impossible. No connectivity clauses or restrictions are
needed. There are 920 allowed matching edges, with no restriction on the
numbers assigned to the six cycle pairs.

The prior independent review at
`../efgs_cross_block_voltage/review.json` accepts a nine-witness cover of
all 3^16 assignments in a different, frozen spoke-shift family. That
obstruction depends on two fixed port images and their relative shifts.
It is not an exclusion of this matching family and will not be rerun.

A focused web search on 2026-09-05 for this exact C9+C11+C13+C17
matching family did not obtain a primary-source theorem or complete
computation deciding it. The returned material discussed the general
conjecture, cubic bipartite bounds, and other special classes, not an
applicable result for this domain. This is a retrieval limitation,
not evidence of novelty or a claim that no such result exists.
No external theorem is used to constrain the matching domain.

The Engineer replay now supplies an exact finite-family refutation,
recorded in `cached-verification.json`; Host-invoked independent Reviewer
acceptance is still pending. This is not a counterexample to C1417 or
a proof of the general conjecture. Absence of short cycles in an
intermediate model, a timeout, or incomplete enumeration is not a
candidate or an exclusion. Any candidate must pass the complete
CTX1417 v3 dual-verifier contract.

## Exact encoding and full-cycle refinement

Associate a Boolean variable with each of the 920 cross-cycle edges, ordered
lexicographically by their two integer endpoints. At every vertex, one
at-least-one clause and all pairwise at-most-one clauses express exactly one
selected edge. These 33,215 clauses describe **every** matching in the
question. The implementation reuses `build_cnf` and semantic cycle checks
from the existing odd-subdivision matching certificate machinery; it does
not reuse that construction's restricted edge domain.

For two disjoint matching edges between a pair of fixed cycles, the four
choices of rim arcs give four explicit simple cycles. If any has length
4, 8, 16, or 32, the two edges cannot both be selected. All such two-edge
blockers are generated without a symmetry quotient. A separate exploratory
maximum-clique calculation gave cycle-pair capacities 8,4,8,8,11,12 in
pair order (9,11),(9,13),(9,17),(11,13),(11,17),(13,17). These local
bounds do not exclude the full family and are not premises of the complete
certificate. Their attaining edge sets are in `pair-capacities.json`.

The SAT loop reconstructs each complete matching model and searches for
simple cycles at all four forbidden lengths. A cycle is recorded as its
full ordered vertex sequence together with the matching edges it uses.
The negation of the conjunction of precisely those matching-edge variables
is a sound clause: every completion containing those edges contains the
displayed cycle, regardless of its other matching edges or chords.
This also handles cycles using three or four matching edges and cycles
visiting the same fixed cycle more than once.

### Lossless rotation representatives

Write \(m_{ij}\) for the number of matching edges joining fixed cycles
\(i,j\), ordered C9,C11,C13,C17. Perfect coverage gives
\(\sum_{j\ne i}m_{ij}=n_i\). Subtracting the equations for the complementary
pair of cycles yields the exact identities

\[
m_{03}=m_{12}+1,\qquad m_{13}=m_{02}+3,\qquad
m_{23}=m_{01}+5.
\]

Thus **every** matching has an edge between C17 and each of C9,C11,C13.
Rotate C17 and C9 independently to take any C9-C17 matching edge to
`0--33`. Next, find the smallest-labelled C17 vertex matched into C11,
and rotate C11 so its partner becomes 9. Independently do the same for
C13, making the partner of its first C17 incidence be 20.
Neither of the last two rotations changes the C17 labels or `0--33`.
These are graph isomorphisms preserving the labelled fixed-factor edge
set and every simple-cycle length. The result is still in the original
family.

The corresponding 377 CNF clauses state `x[0,33]`, require vertices 9
and 20 to match into C17, and, for each of C11 and C13, forbid a nonroot
outer vertex from matching a C17 vertex unless that outer cycle already
has an incidence at a smaller C17 label. Every matching therefore has
at least one representative satisfying these clauses. No allocation
\(m_{ij}\), voltage, motif, or matching neighborhood is fixed. No
reflection or unproved orbit-count assertion is used.

`normal_form.py` constructs a representative and the explicit vertex
permutation. `verify.py` independently reconstructs the 377 clauses.
The identities and rotation argument above are the coverage proof;
finite representative fixtures are implementation checks, not a
replacement for that proof. A refutation of this representative domain,
together with sound cycle blockers, excludes the full original domain.
A surviving normalized model still requires all four forbidden-cycle
checks and the unchanged native candidate acceptance contract.

For example, the ordered C8
`0,1,9,10,20,21,33,34` uses the four distinct matching edges
`1--9,10--20,21--33,0--34`. It is not a two-matching-edge obstruction.
The three-matching-edge C8 `0,1,9,10,20,21,22,23` is another explicit
fixture. Neither is asserted to occur in every completion.

Cycle search uses a minimum-labelled root, pairwise distinct vertices,
and the two orientations' endpoint order. These remove duplicate
representations of a cycle, not matching assignments. A limit on the number
of **found** cycles per model only limits the clauses added in that
iteration; absence is returned only when the complete search finds none.
A timeout produces `INCOMPLETE`, never an absence or UNSAT verdict.

## Certificate and replay

`blockers.jsonl` retains every semantic cycle clause. An UNSAT execution
also writes `final.cnf` and `final.drup`. The final CNF is the unrestricted
matching formula, the 377 rotation-normal-form clauses when that mode is
declared, followed by exactly the retained semantic clauses.
All clauses added during incremental solving are sound axioms of this
final formula, so earlier derived RUP clauses remain valid under its
stronger premises.

`verify.py` imports neither the search nor the pairwise generator. It
independently reconstructs the fixed factor, all 920 matching variables,
and all 33,215 exact-one clauses. It checks every cycle vertex, cycle edge,
length, and matching-edge support, compares the reconstructed CNF
clause-for-clause with the retained DIMACS file, and runs the existing
`class10592_global_topology/check_drup` executable on the actual proof.
The optional normal-form clauses are independently reconstructed as well,
and their full-domain coverage is given by the rotation argument above.
A missing proof, an unchecked solver verdict, or a failing replay is not
an exclusion. No assumption about the completeness of the cycle-blocker
catalog is needed: checked UNSAT of any such sound relaxation excludes
every matching in the full domain.
The search uses no solver assumptions or allocation-specific axioms.
A regression rejects a raw assumption-scoped UNSAT transcript for a
satisfiable global formula; such a transcript is not a family refutation.

If a model has no forbidden cycle, the search writes `candidate.json` and
runs the unchanged strict DFS and independent position-SAT implementations
from the read-only batch source, with outputs relocated inside this owned
directory. `candidate.edges` is derived in the JSON edge order.
The native parser requires the JSON string `"1417"` for `conjecture_id`,
not the integer `1417`; the candidate serializer is exercised directly
against that parser.
The replay script additionally reconstructs the matching and graph and
requires all CTX1417 v3 report postconditions and native input-digest
bindings. Independent Reviewer replay and acceptance remain mandatory.

After a complete search result is available, from the campaign directory:

```bash
PYTHONDONTWRITEBYTECODE=1 .venv/bin/python -B research/four_odd_cycle_matching/verify.py --output research/four_odd_cycle_matching/engineer-verification.json
```

The earlier unrestricted execution is recorded in `durable-resume-receipt.json`.
It reached its declared boundary after 18,044 models; the result is
preserved in `unrestricted-cegar-boundary.json`. Its 183,860 retained
semantic blockers were independently reconstructed in
`boundary-prefix-verification.json`. Empty stderr and the explicit
`INCOMPLETE` result identify a time boundary, not a crash or an exclusion.

The first receipt is retained in `durable-receipt.json`. Only this new
worker was interrupted to load the native string-ID serialization fix;
`blocker-prefix-verification.json` confirms all 42,496 retained clauses
were valid before resuming the unchanged matching domain. That prefix is
not a complete family exclusion, and an execution boundary is not a
mathematical family boundary.
The subsequent 60-second rotation-normalized pilot completed 7,749 models
and retained 235,080 sound semantic blockers in total; it also remained
`INCOMPLETE`. Its exact result is in `rotation-pilot.json`. These model
counts are execution observations, not a coverage percentage or a
controlled performance comparison.
The 2026-09-05 continuation is recorded in `durable-rotations-receipt.json`.
It resumes from that prefix using the proved rotation representatives;
it does not broaden a time boundary into a family-exclusion claim.
The global-rematching work is a separate assignment and was not
restarted, cancelled, or modified.

### Recovery and finite short-cycle saturation

On 2026-11-03 the active Argus interface reported the rotation task
terminated with exit -15 and `live=false`. Neither recorded PID existed
and no matching-search process was present. The old `result.json` still
described the pilot, not that interrupted continuation.
`rotation-worker-recovery.json` records that distinction.
Fresh independent reconstruction in `recovered-prefix-verification.json`
validated all 293,099 retained clauses: 1,840 C4, 224,999 C8, and
66,260 C16 witnesses. No records were discarded, and the separate
global-rematching assignment was not changed.

The next mathematical step is finite C8 saturation rather than another
unchanged timed CEGAR execution. `short_cycles.cpp` traverses simple
eight-vertex paths in the fixed rims plus all 920 allowed matching edges.
It retains only paths whose matching-edge endpoints are disjoint, closes
them by a valid edge, and uses the minimum vertex and one orientation.
It prunes a partial support only when two of its edges already imply a
forbidden cycle through the two rims. The corresponding two-edge
clauses are regenerated before saturation, so these prunings remove
only redundant constraints. A C8 has at most four matching edges.
Two-edge supports are already covered; every remaining C8 with three
or four matching edges is enumerated. Chords are not a rejection rule.

The `--saturate-c8` search mode independently validates each emitted
cycle support before appending it to the retained journal, then solves
the strengthened formula and continues exact checks at every required
length. The root-zero pilot emitted 402,152 distinct supports in
3.77 seconds; all were checked by `verify.semantic_clause`, including
the three- and four-matching-edge fixtures above. This measurement is
not a family decision or a comparison with another algorithm.
The eventual exclusion still requires the actual final CNF, a checked
DRUP refutation, and independent Reviewer acceptance. Completeness of
the enumerator is not needed to justify a refutation: each added clause
has its own retained, independently reconstructible cycle witness.

Full C8 generation emitted 2,065,224 cycles. After incorporating those
supports and further C16 witnesses, the owned worker was interrupted
with SIGINT to incorporate the completed finite three-edge C16 catalog.
Its exact PID, process start time, argv, and campaign cwd were checked
before signalling. Argus recorded exit 130; this was not a solver
verdict. `c8-saturated-prefix-verification.json` independently validates
all 2,219,378 preserved clauses, including 2,074,094 C8 and 143,444 C16
supports. No competing matching solver was run.

A simple cycle using exactly three matching edges must visit three
distinct fixed rims in a triangle. Its three nonempty rim paths have
lengths p,q,r, strictly below their respective rim orders; for C16,
p+q+r=13. The `--triangle16` generator enumerates all four rim triples,
all such path-length triples, all starting vertices, and both directions
on each rim. The catalog contains 3,620,680 ordered cycles, with possible
duplicate matching supports. Its count agrees with the independent
parameter enumeration in `triangle16-parameter-count.json`.
The exact three-edge C16 fixture in the tests has no C8.

In fact no three-edge C16 support can also support a C8 in this family.
Two even cycles on the same triangle support differ on an even number
of odd rims, so distinct such cycles must change exactly two rim arcs.
The sum of their lengths is then at least 9+11+2+6=28: two complete
changed rims, twice a nonempty unchanged rim path, and the six counted
matching-edge occurrences. C8+C16 would instead sum to 24.
This observation is not used to remove matching assignments.

The final search continuation, recorded in
`durable-triangle16-saturation-receipt.json`, validates every input cycle
before adding its three-edge clause to the recovered prefix. All domain,
rotation, full-length checking, native candidate serialization, and
independent acceptance requirements remain unchanged. The separate
global-rematching assignment remains untouched.

That continuation returned `UNSAT_AWAITING_INDEPENDENT_REPLAY` after one
complete matching model and 128 further C16 clauses. It retained
5,490,549 semantic clauses and the actual 5,524,141-clause `final.cnf`,
plus `final.drup`. The refutation uses only valid C4, C8, and C16
obstructions; no C32 exclusion is assumed. The independent replay is
recorded in `durable-certificate-replay-receipt.json`. A solver report
alone is not the family verdict.

The full forward native replay is expensive. A separate bounded operation,
`trim_refutation.py`, uses the MIT-licensed DRAT-trim source pinned at
commit `2e3b2dc0ecf938addbd779d42877b6ed69d9a985`, retained with its
license in `drat_trim/`, to extract RUP-only dependency lemmas. Its
`trimmed.drup` is a **derived proof**, not a replacement for the immutable
`final.drup` solver transcript; the actual `final.cnf` is unchanged.
`proof-trimming.json` binds the source, executable, and input bytes.
Neither extraction success nor the presence of that file is a family
verdict: a strict native RUP checker must still check any derived
refutation against the actual final CNF, with the independent semantic
and rotation coverage checks intact.

Extraction completed in 545 seconds and produced 585,125 additions and
1,068,077 deletions. The retained native checker ignores deletions.
The new optional proof selection changes only the refutation input,
not any reconstruction or acceptance condition:

```bash
PYTHONDONTWRITEBYTECODE=1 .venv/bin/python -B research/four_odd_cycle_matching/verify.py \
  --proof-file research/four_odd_cycle_matching/trimmed.drup \
  --output research/four_odd_cycle_matching/derived-verification.json
```

The report binds the checked proof and unchanged final CNF by SHA-256,
and refuses a successful verdict if either changes during replay.
The original full-transcript replay remains separate. It reached its
configured 7,200-second operational limit without a verdict, as recorded
in `certificate-replay-status.json`; neither that timeout nor the
consumed proof prefix is an exclusion. The smaller native replay is
recorded in `durable-derived-certificate-replay-receipt.json`.

The unmodified replay's measured throughput also projected beyond its
scheduled window. It was preserved while a campaign-local, cache-only
variant was prepared in `cached_check_drup.cpp`. The exact source diff,
build command, and source/executable hashes are in
`cached-checker-build.json`. The change stores a blocking literal with
each watch, avoiding a clause-memory lookup when that literal is true.
Every blocker is a member of its clause, including after a watch moves;
therefore a true blocker means the clause is already satisfied. Its
truth value is evaluated anew, not cached across assignments. No RUP
addition, empty-clause check, unit assumption, or deletion rule changes.
Both backends still ignore deletions and require a checked empty clause.

The 19-test suite includes legacy/cache agreement against exhaustive
truth tables on all 512 two-variable clause sets, 24 seeded ten-variable
formulas, and a twelve-variable pigeonhole formula. These finite
implementation checks do not replace the cache invariant or the full
campaign refutation replay. The default backend remains `legacy`.
The explicit cached replay is:

```bash
g++ -std=c++17 -O3 -Wall -Wextra -Werror \
  research/four_odd_cycle_matching/cached_check_drup.cpp \
  -o research/four_odd_cycle_matching/cached_check_drup
PYTHONDONTWRITEBYTECODE=1 .venv/bin/python -B research/four_odd_cycle_matching/verify.py \
  --checker cached --proof-file research/four_odd_cycle_matching/trimmed.drup \
  --output research/four_odd_cycle_matching/cached-verification.json
```

`durable-cached-certificate-replay-receipt.json` identifies this bounded
execution. It repeats the complete semantic and actual-CNF reconstruction,
then checks every retained derived-proof addition. Its report additionally
binds the selected checker executable and cached source, and refuses a
verdict if any bound input changes during replay. Independent Reviewer
acceptance remains required regardless of backend.

The preserved unmodified derived-proof replay subsequently reached its
own 7,200-second limit without a complete report. Its exact terminal status
is in `derived-certificate-replay-status.json`. Neither legacy timeout
is used as mathematical evidence; the complete cached replay below is
the Engineer certificate.

### Checked Engineer boundary

The completed replay independently reconstructed all 5,490,549 semantic
blockers and the actual 5,524,141-clause CNF. It checked all 585,125
derived-proof additions, including the empty clause, and returned zero:

```text
VERIFIED_DRUP additions=585125 deletions_ignored=1068077 final_line=1653202
```

`cached-verification.json` binds that proof, the final CNF, the selected
native executable, and its source. The complete replay took 1,972.37
seconds; this is an execution measurement, not a controlled speedup
claim. Its official successful completion is retained in
`cached-certificate-replay-completed-status.json`.

For the contradiction, suppose a completion avoids all four forbidden
lengths. The lossless rotations above give a representative satisfying
the unrestricted matching and normal-form clauses. It satisfies every
semantic blocker too: selecting a displayed cycle's whole matching
support would force that forbidden simple cycle. It would therefore
satisfy the actual final CNF. Each checked RUP addition is implied by
earlier clauses, since unit propagation under its negation reaches a
contradiction. Induction through the checked empty clause proves the
CNF inconsistent. Hence no such completion exists. No complete cycle
catalog or C32 clause is a premise of this argument.

The improvement over the earlier unchecked UNSAT transcript is a
completed replay-backed refutation of the full frozen matching domain,
not merely more blocked models. This is a finite verification checkpoint,
not completion of the publishable counterexample campaign. The Reviewer
must independently replay the retained certificate and scrutinize both
rotation coverage and the cache invariant. No acceptance flag or route
retirement is supplied by Engineer. After acceptance, Planner must move
to a materially different unresolved construction; C1417 remains open.

The intermediate model is retained as `low-arity-model.json`, not as a
counterexample. Twenty-four matching edges were reconstructed from
that model's last 128 cycle records; its final edge is uniquely forced
by the two uncovered vertices. Native strict DFS completely excludes
C4 and C8 but exhibits C16. The exact fixture test independently checks
all two-edge supports and all 60 matching-edge triangles, while
`low-arity-model-obstruction.json` displays a four-matching-edge C16.
This is a negative witness for stopping at low-arity constraints, not
for C1417; the continuing full-cycle refinements are essential.

The live prefix-loading phase was also profiled without restarting its
worker. On the same first 20,000 retained records, native support
validation took 0.366 seconds with a fresh 920-edge set per call and
0.091 seconds with that immutable set reused; outputs were identical.
`blocker-validation-profile.json` records the scope. New executions reuse
the set and publish progress during prefix loading. This is not a
whole-search speedup claim.

## Installed Jacobian scope

The retained exact contracts are `jacobian-cycle-contract.json`,
`jacobian-sat-contract.json`, and `jacobian-refutation-contract.json`.
The graph operation accepts at most 20 vertices, and the SAT operations
accept at most 8,192 canonical clauses. Neither accepts this full
50-vertex, 33,215-base-clause encoding. The typed refutation checker
also requires LPR/ASCII-v1 steps, not the reused solver's raw DRUP stream.

The bounded pinned-CLI call in `jacobian-execution.json` checks the actual
C4 on vertices `0,1,10,9`, formed by fixed edges `0--1,9--10` and allowed
matching edges `0--9,1--10`. The exact payload and typed `EXISTS` output
are retained separately. It checks one valid obstruction, not the whole
family. No timeout, unavailable operation, or solver UNKNOWN is used as
mathematical evidence.

The recovery also used the Argus sidecar, with the freshly inspected
contract in `jacobian-recovery-contract.json`, to check the actual
four-matching-edge C8 fixture. The exact payload, typed `EXISTS` response,
server version 0.14.0, protocol 2025-11-25, and adapter exit status zero
are retained in `jacobian-recovery-{payload,output,execution}.json`.
That bounded operation validates only the displayed eight-vertex
obstruction, not the 50-vertex family.
