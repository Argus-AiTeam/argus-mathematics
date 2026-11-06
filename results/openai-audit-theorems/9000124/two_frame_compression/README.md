# Alternating-frame compression: exact model

The target is the construction in the staged September 24, 2026 manuscript
*A Polynomial-Time Algorithm for Three-Machine Unit-Job Scheduling*,
not the truth or falsity of the underlying scheduling complexity conjecture.
Source paths below are relative to
`research/openai_manuscript/A-polynomial-time-algorithm-for-three-machine-unit-job-scheduling-September-24-2026/build/`.

## Source facts and scope

`paper.tex`, Section 2, specifies a finite strict precedence order on a
padded set J of 3T jobs. A full schedule partitions J into antichain triples;
every precedence is strict in slot time. Restricted orders use global
transitive reachability. Reordering an interval preserves all exterior
positions. The second frame reverses time, precedence, and the fixed linear
extension. The two ranks sum to |J|+1. Sentinel cones are constants, not
reachability cones of invented jobs.

`separators.tex`, Definition `def:separator` and Lemma `lem:shared`,
specify the shared-cutoff walk on an exactly lexicographically least full
schedule. Normalization is over feasible full schedules, not greedy
list schedules. Intermediate walk positions need not be marked.

`construction.tex`, Invariants I1-I3 and equations `eq:center-cutoff`
through `eq:edge-data`, specify the admissible root-reachable histories.
The root has both sentinels, list (J), original frame, and the last
actual slot as center. Every child inherits the complete exterior
schedule and has the working frame of its creating edge. A non-root
center separates W intersect P_b in the parent's tag frame. Each side
is normalized separately, using the specified priority order.

`lists.tex`, Lemmas `lem:flatten`, `lem:old-low`, and `lem:G`, specify
the historical extension and new switched upset. Predicate membership
is frozen on all J. Flattening asserts agreement on the earlier parent
U, not global equality. The switch upset must cover all the current
parent's X, not just the child, and exclude all jobs at or before its
left boundary.

`boundary.tex`, Lemmas `lem:past` and `lem:swap`, assert propagation
of global I2 and I3. I3 quantifies over every feasible future reordering
of the child and tests exchanges in the complete schedule. An exchange
need not preserve the hierarchy.

`descriptions.tex`, Lemmas `lem:global-child` and `lem:final-count`,
assert global equality of the high and low formulas with the child
parts and fewer than 500 leaves for node and split predicates.
`paper.tex`, Theorem `thm:structure` and Lemma `lem:hierarchy-dp`,
use these assertions for algorithmic completeness.

These are definitions and assertions being audited, not assumptions that
the compression theorem is true. No comparator or cited subexponential
algorithm proves the required polynomial-time theorem.

## Certification target

Either exhibit a root-reachable failure of a literal assertion, including
all of its antecedents, or prove the full arbitrary-depth recursive
compression theorem. A bounded search without a witness establishes
neither. In particular, an isolated carry identity is not this target.

The inherited Wiki index was searched for scheduling, three-machine,
two-frame, compression, and this campaign ID. It contains no matching
project fact to reuse. The source's historical references are not
needed for the finite-model replay; no uninspected external theorem
is used as a correctness premise.

## Exact future-exchange test

Let a be an actual left boundary, W its open interval, y a job at a,
and x a job of W outside D_a. A feasible direct exchange after a
feasible reordering of W exists if and only if both of the following hold:

1. x has no predecessor in W.
2. W has a full schedule after adding the constraints x precedes z
   for every z in W that is a successor of y.

For necessity, moving x to a requires all its predecessors to be
strictly before a. Moving y to x's former slot requires each successor
of y in W to be strictly later than x. For sufficiency, every exterior
predecessor of x is already before a: feasibility excludes exterior
predecessors after W, and x outside D_a excludes predecessors at a.
The added constraints put every interior successor of y strictly
after x. Exterior successors of y after W remain later. Moving x
earlier and y later preserves their other constraints. The slots
retain their cardinalities, so the exchange is feasible.

This elementary reduction is used to test the *quantified* invariant
on each encountered finite node. It does not replace arbitrary-depth
induction. `test_model.py` compares it against all full two-slot
reorderings of a six-job interior in both frames.

`model.py` obtains a lexicographic normalization by exhaustive
memoized recursion over all triples of currently minimal jobs in
priority order. The first feasible completed branch is exactly the
lexicographic minimum. Work-limit exhaustion raises an explicit
exception; it is not interpreted as infeasibility.

## Measurements, not a universal conclusion

The initial scatter experiment completed 600 instances (36, 48, 60,
or 72 jobs), examining 4,808 nodes, 1,202 switched edges, and 132
nonvacuous future-exchange feasibility queries. It found no witness.
Ten encountered nodes had a switch, a genuinely restrictive carry,
and a later switch in their ancestry.

The first local-layer experiment completed 581 of 600 instances at
the same sizes; 19 exceeded the exact solver's work bound and remain
unresolved. Its completed histories contained 6,479 nodes, 2,557
switched edges, 206 future-exchange queries, 47 surviving first switch
entries, and three applications of historical flattening to a carried
first switch entry. No tested assertion failed. These are bounded,
uncertified experiments, not proofs of the universal construction.

An exploratory critical-chain command was stopped after exceeding
the interactive execution window. Its unfinished output is not
mathematical evidence. Distinct seed ranges for the critical-chain
and targeted local-layer families were submitted through the durable
runner; their receipts are retained in this directory.

The targeted local-layer run (seeds 600 through 3599; 30, 36, 42,
or 48 jobs) completed 2,981 instances and left 19 work-limited.
Its completed cases contained 25,310 nodes, 8,868 switched edges,
634 future-exchange queries, 225 surviving first switch entries,
and seven flattenings of carried first entries. The separate
critical-chain run (seeds 600 through 1099; 24, 30, 36, or 42 jobs)
completed 455 cases and left 45 work-limited. It found no witness
in its 3,832 completed nodes. The two instance families differ;
an equal numeric seed does not identify an equal instance.

A final, materially different local-layer run varied the linear extensions
used to select centers and the choice among valid centers at each node,
instead of always using the fixed rank order within the center's two
priority groups. Seeds 3600 through 7599 completed 3,759 cases and left
241 work-limited. Completed cases contained 41,299 nodes, 15,759
switched edges, 1,350 quantified I3 queries, 28 historical flattenings,
and 107,975 split-formula checks. Fifteen nodes had a restrictive
carry of a surviving first switch entry followed by another switch.
Again no tested assertion failed.

Across the five completed search batches, 8,376 runs completed and
324 were explicitly work-limited. The completed runs examined
81,728 nodes and 2,464 nonvacuous future-exchange queries.
This is neither an exhaustive classification of posets of these sizes
nor an exclusion of other root-reachable histories.

### A replayable nontrivial ancestry

`finite_certificate.json` records local-layer seed 3307, with 48 jobs,
all edges, the original feasible schedule, and the complete generated
hierarchy. Its relevant ancestry is below. Job identifiers are
zero-based in the certificate; the source's identifiers can be
obtained by adding one.

| Path | Frame | Interior jobs | Surviving entries | Change |
|---|---|---:|---|---|
| 0 | original | 45 | none | first root child |
| 0,1 | reversed | 33 | first, second | switch |
| 0,1,3 | reversed | 6 | first, second | genuinely restrictive carry of the first entry |
| 0,1,3,7 | original | 3 | second | another switch |

This improves on a mere switch-count test: the complicated first switch
entry actually survives, is restricted, and is used in historical
flattening before the next switch. That does not establish anything
about arbitrary recursion depth.

The replay checks 11 nodes, 10 edges, four switched edges, two
nonvacuous quantified I3 queries, and 27 center/split formulas.
Both frames' ranks, sentinel cones, global reachability, exact
normalizations, frozen predicates, full-parent switch coverage,
ancestry, and the high/low global formulas are computed rather than
assumed. It also checks the stated entry, list, and formula bounds
for this finite hierarchy.

Run from the campaign root:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/two_frame_compression/verify.py
```

### Jacobian evidence and its limits

The discovery and inspected contracts are under `jacobian/`.
The server identifies itself as Jacobian 0.14.0, protocol
2025-11-25. The inspected `sat.solve` operation is suitable for the
finite augmented-scheduling feasibility question, not a proof of
recursive compression.

An initial direct submission was rejected because its clause order was
not the canonical order required by the typed contract.
`exchange_noncanonical_payload.json`, `exchange_invalid_request.json`,
and `exchange_invalid_status.json` preserve that non-conclusion
(adapter exit 2). The inspected `sat.cnf.canonicalize` operation was
then used; its exact request and typed output are preserved. The
canonical clause set is checked against the original signed clause set
before constructing the solver payload.

`exchange_certificate.json` separately replays critical-chain seed
600. Its bounded query has x=6, y=3 in the reversed frame and
interior jobs {6,15,21}, all in one slot. Delaying y requires x to
precede its interior successor 21, which is impossible in that one
slot. Exact exhaustive scheduling and Jacobian both report
infeasibility. The final adapter exit is 0; `sat.solve` reports
UNSAT, no exhaustion, and runtime 467 ms. This is only an elementary
finite obstruction, not a manuscript refutation or an arbitrary-size
UNSAT certificate.

The verifier binds the canonicalizer request, canonical signed clause
set, solver request, and typed solver `source` to the exact mathematical
query reconstructed from the root-reachable history:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/two_frame_compression/verify.py --certificate research/two_frame_compression/exchange_certificate.json --canonical-output research/two_frame_compression/jacobian/canonicalize_output.json --jacobian-result research/two_frame_compression/jacobian/exchange_output.json
```

## Remaining mathematical obstruction

No false manuscript assertion has been established, so there is no
`F_...` refutation judgement to file. The main scheduling theorem,
the hierarchy theorem, and arbitrary-depth preservation remain open
in this audit. In particular, successful replay of the finite ancestry
does not prove that the local flattening and boundary arguments compose
at every depth with the uniform global description bound.

There is no full Lean formalization in this deliverable. A universal
certificate would still have to derive every preservation obligation
and construct the hierarchy, rather than take them as hypotheses.
These experiments and the finite certificates are checkpoints only.
They do not meet the publishable campaign completion criterion, and
independent Reviewer acceptance has not occurred.

The proof graph now displays the unresolved universal-verification
alternative through its actual separator, list, boundary, and description
obligations, rather than treating the finite replay as an obligation
discharged for that alternative. The counterexample alternative is parked,
not refuted or retired. Both alternatives remain in the claim ledger.
The source-reading obligations A_MODEL and A_HISTORY also still require
an independent reader: `citation_check status` reports them unchecked.
The Engineer has not self-confirmed them under a second identity.

The final campaign-local `math_state check` and `proof_graph_check check`
both exited 0 at project root
`/home/argustest/zimo/counterexample-batch-1/campaigns/9000124`.
The gap command still identifies the separator, global-boundary, and
global-list obligations as unproved. Structural validity of this ledger
does not certify those mathematical assertions.
