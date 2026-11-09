# An explicit counterexample to the source-scope-v6 rainbow-reachability claim

This is a finite, source-scope-v6 construction under **unordered injective
label choices**, not a numerical near-solution or an exhaustion argument.
The capacity matrix and six-label palette are unchanged from the independently
reviewed `../complete-strict/recovery.json`.

**Independent witness admission is accepted.** The independent literal
strict replay in `reviewer-strict-replay.json` exited **0** with
`VERIFIED_COUNTEREXAMPLE`, no rainbow directed cycle, all **5,454**
actual vertex rows checked, and minimum actual deficit **1**. Reviewer
`reviewer:copilot-region-19157-admission` accepted source fidelity,
full materialization, all exact copy inequalities, and verifier
equivalence on **2026-09-09 at 03:21:10 UTC**. The reviewed handoff is
`e6814c5f5c25/round-0001.json`.

**Whole-objective scientific certification is also independently accepted**
in `6a41f7e1b649/round-0001.json`. The bounded admission repairs are
accepted in `d8e530fb4f0c/round-0001.json`. This submission preserves
both decisions and the **exploratory** research target.

**The post-repair citation prerequisite is now cleared.** The official
source-attribution operation reports `confirmed`, and the campaign-local
math-state, proof-graph, and actual review-stage checks all exited **0**.
Normal final independent review and certified settlement remain pending;
this Engineer update issues no new Reviewer verdict.

## Exact statement and source fidelity

For a finite nonempty simple digraph, each present arc `e` carries a
nonempty set `L(e)` contained in `{1,...,k}`. Simplicity means at most one
arc for each ordered pair; antiparallel arcs are permitted. The labelled
edge sets may overlap. A rainbow path or cycle admits an injective
choice of one available label per traversed arc, in **any order**. Put

```text
D(v) = sum_i d^+_{G_i}(v) = sum_{w: v->w} |L(v,w)|,
R(v) = {w: a positive-length rainbow directed path goes from v to w}.
```

The original goal `counterexample-20001036` asks for an explicit graph
with no rainbow directed cycle and `D(v)-|R(v)| >= 1` for **every actual
vertex**. The graph below supplies this negative witness, not a
restricted-family exclusion.

The source is Blair D. Sullivan, *A Summary of Results and Problems
Related to the Caccetta-Haggkvist Conjecture*,
[arXiv:math/0605646v1](https://arxiv.org/abs/math/0605646v1),
Notations and Definitions, pp. 1-2, and Section 6.1.1, Conjecture 6.1
and Notes, p. 6; Section 6.1.2, Conjecture 6.2, provides the recorded
interpretative context. The **positive-length** convention is the
explicit source-scope-v6 reading motivated by that implication, not a
separate definition quoted verbatim from Conjecture 6.1. The source's
negative note about *increasing* labels concerns a different statement
and is not evidence for this witness.

The existing ledger retains source-scope version **6** and all four
independently confirmed S1 propositions, including the two restricted
positive cases used during search. No new assumption or source
interpretation is introduced here. The S2 audit is a bounded retrieval
result with `resolution_status=unclear`, not evidence of present-day
openness. Neither novelty nor minimum graph size is claimed.

## The actual graph

With rows and columns indexed by `0,...,15`, the exact matrix `C` in
`copies-6000.json` is

```text
0 4 3 2 2 2 1 2 2 0 0 0 0 0 0 0
0 0 4 2 2 2 2 2 2 0 0 0 0 0 0 0
0 0 0 3 2 2 2 2 2 0 0 0 0 0 0 0
0 0 0 0 4 3 2 2 2 0 0 0 0 0 0 0
0 0 0 0 0 4 2 2 2 0 0 0 0 0 0 0
0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0
0 0 0 0 0 0 0 2 2 2 2 2 0 0 0 0
0 0 0 0 0 0 0 0 6 2 2 2 0 0 0 2
0 0 0 0 0 0 0 0 0 2 2 2 2 2 0 2
0 0 0 0 0 0 0 0 0 0 5 5 2 2 2 0
2 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2
2 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2
2 2 0 2 2 2 0 0 0 0 0 0 0 2 2 2
2 2 2 2 0 0 0 0 0 0 0 0 0 0 2 3
2 2 2 1 0 0 0 0 0 0 0 0 0 0 0 5
2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0
```

Use the positive integer vector

```text
m = [1096, 8, 23, 69, 244, 755, 1, 1059,
     1, 1, 1131, 1, 1, 1, 1, 1062].
```

Replace prototype `u` by the independent fibre `F_u` of `m[u]` actual
vertices. Number the fibres consecutively, with boundary offsets

```text
[0, 1096, 1104, 1127, 1196, 1440, 2195, 2196, 3255,
 3256, 3257, 4388, 4389, 4390, 4391, 4392, 5454].
```

For each `C[u][v] > 0`, include every ordered pair in `F_u x F_v`, with
the set of available labels `{1,...,C[u][v]}`. There are no other arcs.
The zero diagonal of `C` makes the graph loopless. Each ordered pair
appears once; multiple available labels are not parallel arcs.

The full graph has **5,454 vertices**, **11,792,572 arcs**, and
**24,094,765 outgoing label incidences**, summed over all vertices.
`full-certificate.json` explicitly lists every arc and its label set,
and contains **5,454 distinct actual-vertex rows** with **273,052,739
explicit state pairs**. It is a 3,216,231,615-byte ordinary JSON file:
there are no weighted, quotient, row-reference, or compressed-state
substitutions in the certificate.

The strongest relevant prior result was the reviewed feasible pair with
109,080 integer copies, 4,665,618,789 prospective arcs and minimum deficit
20, but no complete materialized certificate or strict entry-point result.
The improvement over that result is a fully materialized graph and an
independently accepted strict certificate, not a discovery that the
already reviewed pair is feasible. The smaller minimum of 1 still meets
the original strict threshold. This final submission adds exposition
and reconciles records; it makes no further mathematical improvement
over the accepted 5,454-vertex witness.

## Exact inequalities and the lift

Let `R_C[u][v]` indicate positive-length rainbow reachability in the
six-label prototype graph, with no restriction on the order of labels.
The previously reviewed endpoint masks and absence of positive returns
are unchanged. Every lifted rainbow walk projects to such a prototype
walk with the same injective label choices. A positive return in the
lift would therefore give a positive prototype return, which the
reviewed exact closure excludes.

Conversely, any positive prototype walk from `u` to `v` lifts from
each chosen vertex of `F_u` to every chosen vertex of `F_v`, because all
required cross-fibre arcs are present. Thus, for every actual vertex
`a` in `F_u`,

```text
D(a) = sum_v C[u][v] m[v],
|R(a)| = sum_v R_C[u][v] m[v],
D(a) - |R(a)| = ((C - R_C)m)[u].
```

The independent exact copy replay records the following values, constant
on each fibre. These are counts for each actual vertex, not aggregated
prototype degrees.

| Type `u` | Copies `m[u]` | Label incidences `D(a)` | Reachable endpoints | Deficit |
|---|---:|---:|---:|---:|
| 0 | 1096 | 4358 | 4357 | 1 |
| 1 | 8 | 4350 | 4349 | 1 |
| 2 | 23 | 4327 | 4326 | 1 |
| 3 | 69 | 5363 | 5362 | 1 |
| 4 | 244 | 5142 | 5141 | 1 |
| 5 | 755 | 4388 | 4386 | 2 |
| 6 | 1 | 4386 | 4385 | 1 |
| 7 | 1059 | 4396 | 4394 | 2 |
| 8 | 1 | 4394 | 4393 | 1 |
| 9 | 1 | 5666 | 5453 | 213 |
| 10 | 1131 | 4324 | 4322 | 2 |
| 11 | 1 | 4322 | 4321 | 1 |
| 12 | 1 | 6472 | 5453 | 1019 |
| 13 | 1 | 5580 | 5452 | 128 |
| 14 | 1 | 7633 | 5451 | 2182 |
| 15 | 1062 | 4390 | 4389 | 1 |

Every row is strict, with minimum **1**. The expansion has 24,082,828
positive endpoint entries across all actual vertices. Their difference
from the total labelled incidences is exactly
`sum_u m[u] ((C-R_C)m)[u] = 11937`.

In a graph without a rainbow directed cycle, a rainbow walk cannot
repeat a vertex: the segment between two repetitions contains a
rainbow directed cycle. Hence the positive-walk endpoint convention
used by the state certificate agrees with the requested positive-path
endpoint convention here.

The native integer query in `jacobian-integer-6000-payload.json` only
proposed the copies. Its displayed model was parsed as sixteen explicit
positive integers and every row was replayed with integer arithmetic
before materialization. No integer size optimality is claimed.

## Why the optimized admission predicates are equivalent

`baseline_verifier.py` preserves the admission implementation before
the measured performance change. The new verifier still validates
every actual arc, endpoint, label set, row identifier, state domain,
duplicate, empty-path state, degree, endpoint list, deficit and verdict.
It never reads `C`, fibre sizes, or the producer's prototype closure.

For a source `s`, let `P_S` be the actual vertices reached using exactly
the label set `S`. The exact recurrence is

```text
P_empty = {s},
P_S = union over c in S of E_c(P_(S minus {c})),   S nonempty.
```

The implementation represents each `P_S` as a bitset over **actual
vertices**, initializes every one-label image from the checked actual
arcs, and extends with every unused label. Adding a bit strictly
increases the integer mask, so its increasing-mask evaluation is a
topological evaluation even when the underlying graph has directed
cycles.

The old two state predicates are equivalent to equality with this
table. Justification repeatedly removes a used label, and therefore
shows every submitted state is truly reachable from the sole empty
state. Extension closure and the initial state give the converse by
induction on walk length. Thus both predicates together hold exactly
when every submitted nonempty layer equals the recurrence's layer.

The single-entry cache is keyed by the complete tuple
`(E_1({s}),...,E_k({s}))`, derived from actual arcs. These one-label
images determine all positive layers by the recurrence, so equal keys
have equal positive closures. The source's empty state and its own
positive-return membership are still checked separately for every
row. No row is skipped on a cache hit. A malformed certificate violating
several predicates can encounter a different first error, but it is
still rejected.

The validated sorted row identifiers equal `0,...,n-1` under the
original comparison. Indexed access therefore uses the corresponding
enumeration index, rather than introducing a new type restriction on
the supplied identifier. This preserves the original acceptance of
integral floating-point and Boolean row-identifier aliases. A new
differential fixture exposed and corrected this compatibility issue
before any full-certificate acceptance.

The controlled profiles use the same fixed `C`, uniform copy counts
1, 2, and 4, and fully expanded certificates:

| Vertices | Arcs | States | Baseline seconds | Optimized seconds |
|---|---:|---:|---:|---:|
| 16 | 93 | 2,236 | 0.069671 | 0.007145 |
| 32 | 372 | 8,912 | 0.839602 | 0.019246 |
| 64 | 1,488 | 35,584 | 9.451002 | 0.057168 |

These are profiled wall times on this host, not a hardware-independent
performance guarantee. The baseline's 64-vertex predecessor generator
made 49,733,200 calls. `baseline-performance.json` and
`optimized-performance.json` retain the hot functions, CPU times, and
resource measurements. `test_admission.py` compares accepted outputs
and malformed-input rejection against the preserved implementation,
including all 4,096 three-vertex two-label graphs, 200 seeded graphs,
all admission predicates, positive returns with equal first steps, and
tampering in a cached clone row. All 21 targeted tests, including the
existing rainbow and capacity tests and the legacy identifier aliases,
passed during admission. The independent Reviewer subsequently accepted
the equivalence argument and ran all eight methods in `test_admission.py`
successfully, including its exhaustive and malformed-input comparisons.
That accepted verdict is preserved in `reviewer-strict-replay.json`;
equivalence review is no longer an outstanding admission obligation.

The initial full run was deliberately interrupted to repair that
compatibility boundary; `full-certificate.verification.json` retains
its exit status -15, not a mathematical verdict. Its 578.551 wall
seconds and 63.866 CPU seconds are distinct measurements. A subsequent
one-second probe of the already allowed CPU set observed CPU 0 fully
busy and CPU 5 idle. The corrected replay uses one CPU, 5; this is not
a long-term availability guarantee. The full graph was not rebuilt.
The actual-row JSON-loading control in `json-loading-performance.json`
showed only a modest cyclic-GC effect, and **no GC change was adopted**.

## Independent admission and post-repair certification

The accepted evidence covers the whole graph rather than only the
sixteen-type arithmetic:

| Existing evidence | Independently accepted conclusion |
|---|---|
| `reviewer-strict-replay.json` and its `.output.json` | Literal strict command exited 0; all 5,454 actual rows satisfy the certificate predicates, no positive return exists, and minimum deficit is 1. |
| `reviewer-materialization-audit.json` | Every one of 11,792,572 arcs and every actual row was audited against the fixed matrix and fibres; all 273,052,739 explicit state pairs were counted. |
| `reviewer-exact-copy-replay.json` | Direct composition of all 1,956 positive injective label words, without producer or verifier imports, confirms every prototype endpoint, no positive return, and all sixteen integer inequalities. |
| Source-fidelity and verifier-equivalence findings in `reviewer-strict-replay.json` | The frozen source reading and the optimized verifier's acceptance predicates were independently accepted. |

The independent strict run took 540.114 wall seconds and 523.271 CPU
seconds, with peak RSS 44,416,328 KiB. These are recorded measurements,
not a promise of current resource availability. The earlier Engineer
run in `strict-replay.json` took 483.382 wall seconds and 481.961 CPU
seconds, with peak RSS 44,418,188 KiB. Neither run is being repeated
merely to refresh a timestamp.

`research/MATH_STATE.json` already contains the independent Reviewer's
supporting judgments for both `region-19157-full-certificate-admission`
and the unchanged original goal `counterexample-20001036`. Both have
derived status `supported`; this is exact computational evidence plus
independent mathematical review, **not Lean kernel verification**.
The proof graph now reflects those judgments without restating the
goal or changing source-scope version 6. Its historical
`reviewer-proof-gap.json` receipt predates acceptance and is preserved,
not treated as a current mathematical objection. Other uncompleted
search routes need not be proved or exhausted once the explicit witness
route succeeds; none of their exclusions is enlarged here.

The separate whole-objective independent verdict in
`6a41f7e1b649/round-0001.json` already covers every original hypothesis,
no rainbow directed cycle, and `D(v)-|R(v)| >= 1` at every actual vertex.
The subsequent bounded-repair acceptance in
`d8e530fb4f0c/round-0001.json` preserves that scientific conclusion.
Neither historical verdict is rewritten here; the remaining task is
post-repair final review and normal certified settlement.

The preceding review on 2026-09-09 found a single citation-attribution
prerequisite for
`S1-incoming-completion-r33`, attached to the unchanged historical claim
`incoming-completion-witness-r33`: Sullivan,
`arxiv:math/0605646v1`, Section 6.1.2, Conjecture 6.4 and its Notes,
pp. 6-7. The original document-resolution record and the supporting
**judgment** by `reviewer:copilot-r33` remain intact. Neither is relabeled
as a source-attribution record.

The current mission authorizes the required `research/literature/`
archive. After a fresh reading of the original read-only source and its
exact-distance neighborhood definitions, `engineer:copilot-citation-admission`
used the pinned official `citation_check attribute` operation. It recorded
literature-tier support for the unchanged assumption as
`citation-S1-incoming-completion-r33-acf4d9a6d440`, with status `confirmed`,
no refusals, and no retirements. The content-bound archive is
`research/literature/d325a84c7fbd46c373b9c1164f6f116e.json`; its readable
input is `research/literature/sullivan-conjecture-6-4-attribution.txt`.

The excerpt retains the source's printed `G' = H` and unrestricted
notation for `E3`. Its attribution note explicitly distinguishes those
words from the already recorded omitted-loop and expanded-support
interpretations required by the `n-1` identity and the new arcs. It
attributes the conditional transfer construction and reversal argument,
not a strict witness or a known resolution. No assumption, source-scope
version, mathematical statement, or historical judgment was changed.

At **2026-09-09 04:45:25 UTC**, the official math-state and proof-graph
checks against
`/home/argustest/zimo/counterexample-batch-1/campaigns/20001036`
both exited **0**; the proof graph has 119 nodes. The actual
`stage_completion_issues('review', campaign_root)` check also exited
**0** with no issues. The required shared-root precheck had already
exited 0, but is not being substituted for these campaign-local results.

This clears the reported prerequisite, not the remaining independent
decision. The normal Reviewer path must assess this attribution delta,
confirm the original no-rainbow-cycle and every-vertex strict-deficit
conditions using the accepted handoffs above, and persist final
certification through the Host lifecycle. The unchanged witness,
source-fidelity, materialization, strict-replay, verifier-equivalence,
and admission-repair acceptances are reused; no full replay or new
mathematical result is claimed.

## Reproduction

Work from the campaign directory. The already accepted independent
run used the following exact strict entry point:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  scripts/verify_rainbow_certificate.py \
  research/global-palette-compression/source-coupled/capacity-regions/joint-completion/region-19157/admission/full-certificate.json \
  --require-counterexample \
  > research/global-palette-compression/source-coupled/capacity-regions/joint-completion/region-19157/admission/independent-native-output.json
```

The complete native output is intentionally redirected: it includes
the endpoint list for every actual vertex, not only a summary.
Successful termination must return `VERIFIED_COUNTEREXAMPLE`; a timeout,
an interrupted process, or an incomplete output is not acceptance.

For a fresh construction without overwriting the submitted certificate:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/global-palette-compression/source-coupled/capacity-regions/joint-completion/region-19157/admission/materialize.py \
  --copies research/global-palette-compression/source-coupled/capacity-regions/joint-completion/region-19157/admission/copies-6000.json \
  --output research/global-palette-compression/source-coupled/capacity-regions/joint-completion/region-19157/admission/replay-certificate.json
```

`replay_entrypoint.py <certificate> --report <owned-report.json>` invokes the literal strict command
from the campaign directory, retains its full output and actual exit
status, measures resource use, and publishes progress while it runs.
Commands that can exceed two minutes must be submitted through the
pinned Argus durable runner. Run that submit from this `admission/`
directory, keep its task cwd here, and put `cd` to the campaign directory
inside the submitted command, so the runner's own records stay in the
owned subtree. `corrected-replay-submit.json` is the current strict
replay receipt; `admission-submit.json` preserves the earlier construction
and interrupted replay. Both retain `state`, `task_id`, `run_id`, and
`check_with`. The corrected outcome is recorded in `strict-replay.json`,
with its complete native output in `strict-replay.output.json`.

The fixed-copy native operations use the pinned Jacobian 0.14.0 strict
JSON CLI, not an MCP server. Their dedicated payload, exact response
envelope, operation id, runtime, executable version and error status
are retained beside the construction. The LP call's `INVALID_ARGUMENT`
is a tool-level non-conclusion, despite satisfying its published JSON
schema. The separate 1,024-copy integer bound returned `UNSAT`; no
regional or original-problem exclusion is claimed from it. The
6,000-copy query returned the exact positive vector above.
