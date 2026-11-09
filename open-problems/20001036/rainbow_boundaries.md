# Exact restricted counterexample searches

The target remains the unordered Seymour-Sullivan formulation recorded in
`MATH_STATE.json` and the open `PROOF_GRAPH.json`. The following are
restricted computations, not a resolution of that conjecture. No Lean or other
kernel proof is claimed.

## Exact witness certificate

`scripts/rainbow.py` computes states `(endpoint, used_label_mask)` separately for
each starting vertex. Only `(start, 0)` is initially present. Every unused
available label on an outgoing arc gives a transition. The mask strictly
increases, so there are finitely many states. Reachable endpoints are extracted
only from nonzero masks.

`scripts/verify_rainbow_certificate.py` does not call the producer. It checks
every state's predecessor, every possible outgoing transition, the unique
empty-path seed, and the degree and endpoint data. Induction on mask cardinality
proves both directions of exact state reachability. A nonempty state returning
to its starting vertex is a rainbow closed walk. Every such walk contains a
rainbow simple directed cycle; conversely every rainbow cycle is such a walk.
Thus absence of a returning state at every start proves absence of all rainbow
cycles. Each vertex, including auxiliary vertices, must have `D(v)-|R(v)| >= 1`.

The Jacobian payload `jacobian-matching-payload.json` encodes the label-assignment
bipartite graph for a triangle labelled `{1}`, `{1}`, `{2,3}`. The preserved
typed response in `jacobian-matching-output.json` has maximum matching size two
and a matching upper-bound certificate. It confirms only this triangle's
injective-label obstruction, not the campaign goal. The archived discovery
found no rainbow-specific or satisfiability operation. The archived sidecar run
used the `argus-latest` interpreter and returned adapter exit status zero,
no timeout, no structured error, server version `0.14.0`, and MCP protocol
`2025-11-25`. The operation was inspected before that execution. These are
historical observations reused by the core search, not a new availability
probe or a claim that matching solves the synthesis problem.

## All graphs with at most four vertices and three labels

`scripts/enumerate_rainbow.cpp` exhausts all `n=1,2,3,4` with three available
labels. Unused labels include the cases with fewer than three labels.

For each unordered pair, write `A` and `B` for the two directed label sets.
A rainbow digon exists exactly when both are nonempty and two distinct labels
can be chosen, one from each. Consequently the only digon-free possibilities
are an absent direction, or two identical singleton sets. There are
`1 + 2*(2^3-1) + 3 = 18` possibilities per unordered pair. No orientation,
symmetry, ordering, or cited positive-case restriction is imposed.

A strict-deficit witness must have a multiply labelled outgoing arc at every
vertex: otherwise `D(v)` is its number of outneighbors, which is at most
`|R(v)|`. The enumerator first applies this necessary condition, then computes
all rainbow states and all vertex deficits exactly.

| n | Digon-free patterns | Missing outgoing multiple label | Rainbow cycle | Cycle-free retained |
|---|---:|---:|---:|---:|
| 1 | 1 | 1 | 0 | 0 |
| 2 | 18 | 18 | 0 | 0 |
| 3 | 5,832 | 5,704 | 122 | 6 |
| 4 | 34,012,224 | 32,498,752 | 1,485,776 | 27,696 |

The best minimum deficit among the retained graphs is zero for both `n=3` and
`n=4`, never one. Original outputs are `exhaustive-n*-k3.json`. This is a finite
exclusion of `n<=4, k<=3`, not a counterexample and not a general proof.

## Asymmetric independent-set blow-ups

This is a different construction mechanism: the number of expanded vertices
is not bounded by four. Replace each template vertex `t` by `m_t >= 1`
independent vertices. Each template arc becomes the complete directed
bipartite set of arcs between its two parts, carrying the same label set.
Multiplicities are arbitrary positive integers, not equal-size or sampled
weights.

Every rainbow cycle in an expansion projects to a rainbow closed walk in the
template, hence contains a template rainbow cycle. Every template rainbow cycle
also lifts. For a rainbow-cycle-free template, a rainbow walk cannot repeat a
template vertex. Every clone of a positively reachable type is reachable, and
no clone of the starting type is reachable. Therefore for every clone of `t`,

```
D_t = sum_s |L(t,s)| m_s
|R_t| = sum_s 1[s in R_T(t)] m_s
D_t - |R_t| = (A m)_t,
A[t,s] = |L(t,s)| - 1[s in R_T(t)].
```

The earlier two pruning steps remain necessary for all multiplicities. All
retained templates yield two distinct coefficient matrices at `n=3`, and 1,852
at `n=4`. Templates with the same matrix have exactly the same weighting
constraints; their multiplicities in the enumeration are retained.

`scripts/coalescing_search.py` asks whether `A m >= 1, m >= 1` is feasible over
the rationals. A rational feasible point can be scaled to positive integer
multiplicities, because these inequalities are homogeneous apart from their
positive normalization. A claimed infeasibility is not trusted merely because
the solver says UNSAT: the search must produce a nonzero nonnegative integer
vector `y` with `A^T y <= 0`. For positive `m`, a hypothetical strict deficit
would imply

```
0 < sum_t y_t <= y^T A m = (A^T y)^T m <= 0,
```

a contradiction. These integer inequalities are independently checkable.

`scripts/verify_coalescing.py` replays the entire finite template enumeration,
compares the complete coefficient-system multiplicities, computes every
representative's coefficients by a separate simple-path traversal, and checks
every dual inequality using only integer arithmetic. The output's scope is
explicitly restricted to independent-set blow-ups of templates with at most
four vertices and three labels. Larger templates, internal part edges, and
nonuniform edges between parts are not covered.

**Computed outcome:** all 1,854 coefficient systems have exact dual
certificates. The separate traversal and integer replay passed, including
coverage of all 27,702 retained three- and four-vertex templates. The persistent
results are `coalescing/dual-certificates.json` and
`coalescing/replay-result.json`. Unlike the first finite-vertex enumeration,
this excludes arbitrarily large expanded graphs within the stated construction
class. It does not exclude arbitrary larger graphs. Independent mathematical
Reviewer acceptance was recorded at 2026-09-05 09:33:41 UTC, with a separate
complete replay in `reviewer-round-1/coalescing-result.json`.

## Reproduction

From this campaign directory, compile the enumerator:

```bash
c++ -O3 -std=c++17 scripts/enumerate_rainbow.cpp -o research/enumerate_rainbow
```

Replay the completed exclusion without a solver:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python scripts/verify_coalescing.py \
  research/coalescing/dual-certificates.json \
  --enumerator research/enumerate_rainbow \
  --replay-dir research/coalescing/replay \
  --output research/coalescing/replay-result.json
```

The optional synthesis environment is campaign-local at `research/search-env`;
its sole added dependency is pinned in `scripts/requirements.txt`.

## Larger finite constraint synthesis

`scripts/constraint_search.py` uses one Boolean per arc-label incidence and
exact equivalences for all rainbow states. It forbids every nonempty return
state and enforces strict deficit at each vertex. Saved `.smt2` inputs permit
independent solver replay.

The first sweep reported UNSAT at `(n,k)=(5,3)` and `(5,4)`. Those reports remain
unreplayed and are not counted in the exact exclusions above. The cases
`(6,3), (7,3), (6,4), (8,3)` each returned UNKNOWN after a 45-second timeout.
They remain unresolved; a timeout is not evidence against a witness.

## Nonuniform overlapping-label switches

After the two restricted exclusions, a different route was opened and actually
run: `scripts/hall_switch_search.py` makes nonuniform multi-incidence toggles
and endpoint-coalescing switches. It preserves the necessary outgoing
multilabel condition and rejects every trial with a rainbow cycle. This is not
restricted to uniform independent-set blow-ups. Each batch contains 20,000
seeded trials; repeated graphs are possible, so these are not distinct-graph
counts or exhaustive results.

| n | k | Seed | Heterogeneous profiles outside the almost-functional case | Best minimum deficit |
|---|---|---|---:|---:|
| 6 | 3 | 20001036 | 6,088 | 0 |
| 7 | 4 | 20001037 | 5,956 | 0 |
| 9 | 4 | 20001038 | 6,736 | 0 |
| 10 | 5 | 20001039 | 6,110 | 0 |

"Outside" means that at least two label graphs have outdegree at least two
somewhere; heterogeneous overlap also requires two different, intersecting
multilabel sets. All four saved profiles have exact state certificates with
`qualifies=false`. They are not candidate counterexamples.

The three zero-deficit vertices in each saved graph form an outgoing-closed
directed triangle with the same two labels on each of its arcs. The vertex
sets are `{3,4,5}`, `{1,4,5}`, `{0,1,8}`, and `{0,4,9}` in the table's order.
Each of those vertices has `D=2` and `|R|=2`. Thus large positive surplus at
other vertices does not repair the auxiliary core's failure of strictness.
This is an exact observation about these four saved graphs, not an exclusion
of the switching mechanism. Its ledger route remains open.

The campaign goal remains open and unconfirmed. The earlier source-grounded
round retired only `exact-small-domain` and `asymmetric-small-templates` with
the precise restricted reasons above, in addition to the pre-existing
source-mismatched ordered-variant route. Its larger constraint route,
larger-template coalescing route, and nonuniform-switching route remain
unresolved. The subsequent results below do not broaden those exclusions.

## Lossless terminal-component reduction

Take strongly connected components in the **ordinary labelled support**:
an arc is present precisely when its label set is nonempty. Connectivity here
does not require rainbow paths. The condensation is a finite acyclic digraph,
so it has a sink component `S`.

For every `v in S`, all outgoing arcs stay in `S`. Consequently the induced
labelled graph on `S` retains every summand of `D(v)`. Every directed path
starting in `S` also stays there, by induction on its length; its available
labels are unchanged. Thus the positive-length unordered rainbow endpoint set
is exactly the same: `R_{G[S]}(v) = R_G(v)`. Deleting vertices cannot introduce a
rainbow cycle. A counterexample therefore contains a strongly connected
counterexample, on any sink component of its support. Conversely a strongly
connected counterexample is already an admissible counterexample.

The equality of `D` and `R` uses **outgoing closure**, not just strong
connectivity. An arbitrary nonterminal component may lose both outgoing
incidences and endpoints. No such extraction is used here.

`scripts/terminal_core_search.py` makes simultaneous row changes at a
minimum-deficit vertex and its support neighbors, rather than changing only a
fitness tie-break. Endpoint coalescence, coordinated label changes, and block
toggles are tested as single proposals. Every retained proposal has strongly
connected ordinary support, the necessary outgoing multilabel incidence at
every vertex, and no rainbow cycle. The lexicographic fitness is unchanged
from the archived Hall-switching search. This is heuristic sampling over
cores, not exhaustive synthesis and not a proof that a stalled core cannot
be repaired.

## Matched core-only experiment

The archived baseline was reused, not rerun. Both experiments use `n=9`,
`k=4`, seed `20001038`, and 20,000 proposal trials. Results and both new exact
state certificates are in `terminal-core-r3/n9-k4-seed20001038.json`.

| Profile | Full deficit vector, vertex order 0 through 8 | Nonpositive vertices | Terminal support | Exterior deficit sum |
|---|---|---|---|---:|
| Archived heterogeneous baseline | `[0,0,12,16,9,9,8,13,0]` | `{0,1,8}` | Triangle `{0,1,8}`, deficits `[0,0,0]` | 67 |
| Best core-only profile | `[0,0,0,0,0,0,0,0,0]` | All nine | All nine vertices | 0 |
| Best heterogeneous core-only profile | `[0,1,1,-1,1,0,0,0,-1]` | `{0,3,5,6,7,8}` | All nine vertices | 0 |

The scores are respectively `[0,-3,67,107]`, `[0,-9,0,18]`, and
`[-1,-6,1,46]`. Of the 20,000 new proposals, 2,293 were cycle-free strongly
connected cores with an outgoing multilabel arc at every vertex; 1,163 also
had heterogeneous overlap and at least two branching labels. There were
2,065 outgoing-multilabel rejections, 5,910 non-strong-support rejections,
and 9,732 rainbow-cycle rejections. The three proposal counts are
6,657 endpoint-coalescence, 6,632 coordinated label changes, and 6,711 block
toggles. Repeated graphs are possible.

This removes exterior surplus from the measured core but does **not** improve
the required strict minimum deficit. In particular, the heterogeneous core's
positive total deficit of one is compatible with two negative deficits and
four zero deficits. The original terminal triangle has not been repaired into
a witness, and no class has been exhausted by this experiment.
The best overall core is just a directed nine-cycle carrying `{1,2}` on every
arc; feasible initializations are included in that best-overall statistic.
It is not an improvement over a known zero-deficit construction.

## Simultaneous boundary and whole-core replacement

The next mechanism, `scripts/core_constraint_search.py`, does not require a
sequence of feasible local edits. All permitted arc-label incidences are solved
for simultaneously. In `incident-repair` mode, every arc with at least one
endpoint in `{0,1,8}` is free; this includes incoming arcs, not just outgoing
rows. Only exterior-to-exterior arcs remain fixed to the archived baseline.
In `full-core` mode, all arc-label incidences are free at the same `n=9,k=4`.
Neither domain bounds the unrestricted conjecture.

The encoding synthesizes *upper* certificates of rainbow reachability. It
includes each one-edge rainbow state, closes the state set under every
unused-label extension, forbids positive-length return states, and places
every nonempty state's vertex in an endpoint upper set. The pseudo-Boolean
degree condition is `D(v) - |upper_endpoints(v)| >= 1`. These conditions
imply the required inequalities for the actual endpoints. Conversely, the
exact rainbow states and endpoints of any qualifying graph satisfy every such
condition. Thus using one-sided closure, rather than exact predecessor
equivalences in the earlier encoder, loses no graph in the declared domain.
It does not by itself imply that solving the constraints is easier.

Two ordinary-support reachability recurrences, from vertex zero in the graph
and in its reversal, impose strong connectivity within at most `n-1` steps.
For the fully free domain only, `0->1` may be required to carry labels 1 and 2:
every strict-deficit witness has an outgoing multilabel arc, and its endpoints
and two labels can be renamed accordingly. No such renaming restriction is
imposed on the fixed-exterior domain.

Every SAT graph is passed to the existing exact certificate producer and
separate checker. A saved SMT input and an UNSAT solver report still require
independent replay and mathematical review of the encoding; an UNKNOWN report
does not exclude even its fixed finite domain.

The fixed-exterior instance returned `UNSAT` after 3.582 seconds including
encoding; its result is `core-constraint-r3/incident-repair.json` and is not
independently accepted. Fully free synthesis returned `UNKNOWN` after a
75-second solver timeout (`core-constraint-r3/full-core.json`).
An additional proof-producing re-encoding with the older exact-predecessor
formulation was interrupted after the overall process exceeded 120 seconds
without publishing a verdict or proof. That interrupted operation is recorded
in `core-constraint-r3/exact-predecessor-replay.json` and supplies no
mathematical conclusion. The phase responsible for its overrun was not
determined. Reproduction of long operations uses the durable runner's external
wall limit; a solver's internal timeout is not a bound on the whole operation.
The revised exact-predecessor replay, with proof production disabled and an
external durable-runner wall limit, returned UNSAT in 2.445 seconds including
encoding. It imposes no strong-connectivity assumption and no label
normalization, so its reported exclusion covers the same fixed exterior even
without those restrictions. The input and report are
`core-constraint-r3/exact-predecessor-no-proof.smt2` and
`core-constraint-r3/exact-predecessor-no-proof.json`.
This is a second exact encoding with a solver report, not a checked proof
object or an independent Reviewer verdict.

## Counterexample-guided rainbow clauses

`scripts/core_cut_search.py` is a different symbolic mechanism on the same
fully free `n=9,k=4` core domain. It starts with strong support connectivity,
one-edge reachability, and strict degree-versus-declared-endpoint constraints.
For each solver model the existing exact analyzer reconstructs rainbow walks.
A rainbow closed walk contributes a clause forbidding its simultaneous
arc-label incidences. A rainbow path from `s` to `v` contributes the implication
that, if all its incidences exist, `v` must be a declared reachable endpoint.
Every learned clause is therefore necessary for a counterexample; no
heuristic graph block is used as an exclusion. A graph is a candidate only
after the existing exact checker accepts all vertices and excludes all
rainbow cycles.

The 180-second run inspected 817 models, of which 141 had no rainbow cycle,
and learned 2,761 closed-walk clauses and 16,601 endpoint implications.
It ended `UNKNOWN` with the solver reason `canceled`, not UNSAT.
Its best cycle-free core has deficits
`[1,-1,-1,0,1,0,0,0,0]`, score `[-1,-7,0,40]`, and all nine vertices in
one support component. The graph is not a counterexample.
The result, exact best-core certificate, final SMT input, and explicit
short-walk clauses are in `core-cuts-r3/`.

## Exact obstructions to weighting the two saved nonuniform cores

A third construction mechanism changes the positive integer part sizes of
the two saved nonuniform nine-vertex cores. It is not the already retired
`n<=4,k<=3` template class. The established blow-up formula still applies:
each clone of template vertex `t` has deficit `(A m)_t`.
Strong connectivity of either template's ordinary support is preserved under
positive independent-set blow-up: support paths lift between distinct parts,
and a nonempty support cycle through a part connects two of its clones.

`terminal-core-r3/saved-core-weights.json` contains the exact coefficient
matrices and the following nonnegative integer separation vectors. The
matrix-vector products were replayed without a solver by
`scripts/core_weight_search.py replay`.

| Explicit template | Nonzero entries of y | Exact row-vector product y^T A |
|---|---|---|
| Best heterogeneous paired-rewrite core | `y_0=y_5=y_8=1` | `[0,0,0,-1,0,0,0,0,0]` |
| Best cycle-free learned-clause core | `y_1=12, y_2=10, y_5=5, y_6=8, y_8=11` | `[0,0,0,0,-22,0,0,0,0]` |

Thus every positive weighting of the first template satisfies
`delta_0+delta_5+delta_8=-m_3<0`. Every positive weighting of the second
satisfies
`12 delta_1+10 delta_2+5 delta_5+8 delta_6+11 delta_8=-22 m_4<0`.
In each case at least one displayed template type has a negative deficit.
This exactly excludes **all positive integer part sizes for these two
specified templates only**. It does not exclude other nine-vertex templates,
internal part edges, or nonuniform changes between parts. Independent
Reviewer acceptance of this scoped result and the outgoing-closed reduction
was recorded at 2026-09-05 10:10:54 UTC in `roles/reviewer/progress.json`.
No counterexample or nonuniform-repair exclusion was accepted.
Compared with the accepted 1,854-system small-template boundary, this adds
certificates for two explicit nine-vertex/four-label templates; it does not
raise the exhaustively covered template-size or label-count bound.

The resulting new nonuniform mechanism is
`scripts/core_dual_repair.py`: it frees every arc incident to the support of
each obstruction vector, namely `{0,5,8}` and `{1,2,5,6,8}`, while retaining
the other incidences of that template. The old matrix identity is not
assumed to hold after these edits. All required strict deficits and rainbow
cycle exclusions are imposed simultaneously, so an old dual certificate
is not mistaken for an obstruction to a changed graph.
Both of these simultaneous nonuniform repairs returned `UNKNOWN` after their
75-second solver limits, recorded in `dual-core-repair-r3/result.json`.
Neither repair domain is refuted or retired. There is still no strict-deficit
counterexample, and the campaign goal is not complete.

The saved-core integer certificates can be replayed without Z3:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  scripts/core_weight_search.py replay \
  research/terminal-core-r3/saved-core-weights.json
```

For the matched experiment, the archived baseline is an input, not a command
to rerun:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  scripts/terminal_core_search.py --n 9 --k 4 --seed 20001038 \
  --trials 20000 --seconds 75 \
  --baseline research/hall-switch-r2/n9-k4-seed20001038-certificate.json \
  --output-dir research/terminal-core-r3
```

The constraint, learned-clause, exact-predecessor, and dual-supported runs have
dedicated durable-runner receipts in `research/*-r3-receipt.json`.
Their task records and logs are under `research/.argus_subagents/`. The
receipts retain the submitted state, task ID, run ID, and status
query; the exact commands are retained in the task records. Query them from
`research/`, where those tasks were submitted.

## Checked clause reuse in the `{0,5,8}` incident-repair domain

The Reviewer-directed continuation uses the first domain in
`dual-core-repair-r3/`: the saved heterogeneous paired-rewrite core with
`n=9,k=4`, free incident vertices `{0,5,8}`, and fixed exterior
`{1,2,3,4,6,7}`. All 30 ordered exterior vertex pairs retain their entire
four-label masks, including absent labels. This fixes 120 Boolean incidences
and leaves 168 incidences free. Both incoming and outgoing boundary arcs may
change. Ordinary-support strong connectivity and strict deficit at every
vertex remain required. Canonical label normalization is disabled.

`scripts/core_cut_search.py --repair-domain ... --reuse-cuts ...` imports only
the saved short-walk records in
`core-cuts-r3/n9-k4-seed20001038.cuts.json`, not the previous SMT input or its
normalization constraints. Before use, every record is checked for legal
vertices and labels, consecutive incident endpoints, distinct labels, and
the claimed open or closed endpoints.

These checks suffice to justify transfer independently of the old
normalization: a realized rainbow closed walk contains a forbidden rainbow
cycle; a realized open rainbow walk either is a path to its endpoint or
contains a forbidden rainbow cycle. Hence the corresponding cycle prohibition
or endpoint implication is necessary in every admissible counterexample,
not just the normalized graph in which the walk was first found.

The implementation records separately the number of imported clauses,
duplicates, new clauses, and imported clauses made tautological by an
explicitly absent fixed incidence. It compares the complete frozen exterior
against the saved repair domain before solving and against every model after
solving. Any putative witness is written as an exact state certificate and
passed to `scripts/verify_rainbow_certificate.py --require-counterexample`;
the command and its exit status are retained. This is a candidate gate, not
independent Reviewer acceptance. The archived baseline search is not rerun.

**Bounded outcome:** the single continuation experiment returned `UNKNOWN`
with solver reason `canceled`, after 72.471 seconds of synthesis and 2.148
seconds of setup. It stopped on the solver's non-conclusive return, not by
exhausting the 180-second overall synthesis budget. No witness was found.
The durable task exited zero; this operational success is not a mathematical
verdict.

All 19,362 saved clauses passed the short-walk checks and were reused, with no
duplicates: 2,761 cycle clauses and 16,601 endpoint implications.
An absent frozen incidence made 13,773 of them tautological in this repair
domain; 5,589 were not made tautological by that direct test. The experiment
inspected 51 models, found 50 with a rainbow cycle, and added 187 cycle clauses
and 582 endpoint implications. The final input contains 20,131 distinct
walk-derived clauses.

The only cycle-free model had one ordinary-support component on all nine
vertices and the following exact profile:

```text
D       = [9, 3, 9, 8, 7, 4, 3, 5, 3]
|R|     = [8, 4, 8, 8, 6, 4, 3, 5, 4]
deficit = [1,-1, 1, 0, 1, 0, 0, 0,-1]
score   = [-1,-6,1,51]
```

Its nonpositive vertices are `{1,3,5,6,7,8}` and there is no exterior surplus.
Compared with the saved heterogeneous core's score `[-1,-6,1,46]`, only the
last tie-break value increased; minimum deficit, nonpositive-vertex count,
and total deficit did not improve. It does not improve the best overall
core minimum of zero, much less reach the required minimum of one. No
putative witness reached the candidate-only CLI gate.

The fixed-exterior existence claim remains unresolved. Neither this domain,
the other dual-supported repair domain, nor the unrestricted counterexample
goal is refuted or retired. `UNKNOWN` is not an external blocker.
The result, complete learned-clause input, and exact non-witness state
certificate are in `incident-cuts-r4/`; the submitted task receipt is
`incident-cuts-r4-receipt.json`. The existing durable task is
`rainbow-incident-cuts-r4`, queried from `research/`. Its command adds these
options to the existing learned-clause search:

```text
--n 9 --k 4 --seed 20001038 --iterations 20000 --seconds 180
--repair-domain research/dual-core-repair-r3/core-0/incident-repair.json
--reuse-cuts research/core-cuts-r3/n9-k4-seed20001038.cuts.json
--output-dir research/incident-cuts-r4
```

These displayed paths are relative to the campaign root; the durable task
record retains the exact absolute-path command executed from `research/`.

## Arbitrary sparse expansions of the saved cores

**New restricted obstruction, awaiting independent Reviewer acceptance.**
Neither of the two templates indexed by
`terminal-core-r3/saved-core-weights.json` can yield a counterexample through
arbitrary finite nonempty independent fibres and arbitrary label-preserving
cross-fibre relations. This includes deleting different labels from different
expanded arcs and using unequal degrees within each fibre. No complete-join
formula, regular-cover assumption, or bound on fibre sizes is used.

This strictly extends the accepted complete-blow-up exclusions for these two
templates. It does not exclude other templates, internal fibre arcs, or arcs
and labels absent from the template. The original counterexample goal and the
earlier unrestricted repair domains remain open.

### Projection and the previously cited positive cases

Let `pi` map each expanded vertex to its template type. Every expanded arc
`x->y` must satisfy `L(x,y) subseteq L_T(pi(x),pi(y))`; each fibre is
independent. A rainbow directed cycle would project to a nonempty rainbow
closed walk in the template with the same distinct labels. A shortest
nonempty closed segment of that walk is a simple directed rainbow cycle.
The saved rainbow-cycle-free templates therefore exclude expanded rainbow
cycles for every such choice of relations.

The accepted S1 almost-functional positive case is not automatically
preserved: independent relations can give at least two label graphs
outdegree greater than one. Nor does a label-preserving expansion impose the
common-group Cayley hypothesis. These observations do not assert existence
of a witness outside those positive cases. The obstruction below is
elementary and uses neither cited positive theorem.

### A minimum-outdegree obstruction

Write `B_t` for the complete set of ordinary outneighbor **types** of template
type `t`, including types outside the set considered below. Suppose a
nonempty type set `S` has these properties:

1. Every outgoing arc of a type in `S` has at most three available labels.
   Every outgoing template arc with at least two labels leads to another
   type in `S`.
2. For every such multilabel step `t->s`, the sets `B_t` and `B_s` are
   disjoint and `t notin B_s`.
3. For every prefix `t->s->r` whose first arc has three labels and whose
   second has at least two, the types `t,s,r` are distinct, all lie in `S`,
   the three sets `B_t,B_s,B_r` are pairwise disjoint, and
   `B_r` contains neither `t` nor `s`.

Then every permitted finite expansion has a vertex over `S` with
`D(v) <= |R(v)|`.

**Proof.** Suppose instead that all vertices over `S` have strict positive
deficit. For an expanded vertex `x`, let `N(x)` be its full ordinary
outneighbor set and `d(x)=|N(x)|`. Since `N(x) subseteq R(x)`, every vertex
over `S` must have an outgoing arc carrying at least two labels. Choose `x`
of minimum `d(x)` among all vertices over `S`; this minimum exists since
the expansion is finite and all its fibres are nonempty.

If no outgoing arc at `x` has three labels, then `D(x)<=2d(x)`. Select a
multilabel arc `x->y`. Its target lies over `S`. Every `z in N(y)` is
rainbow-reachable from `x`: choose a label for `y->z`, then a different
label on `x->y`. Property 2 ensures that these are simple paths and that
`N(x)` and `N(y)` are disjoint. Hence

```text
|R(x)| >= d(x)+d(y) >= 2d(x) >= D(x),
```

contradicting strict deficit.

Otherwise select a three-label arc `x->y`. Our assumption of strict deficit
at `y` supplies a multilabel arc `y->z`, and both targets lie over `S`.
Every vertex of `N(y)` is again reachable in two rainbow steps. Every
`w in N(z)` is reachable in three: select a label on `z->w`, then a
different label on `y->z`, then a label on `x->y` different from both.
The respective cardinalities `1`, `>=2`, and `3` ensure each choice.
Properties 2 and 3 make these paths simple and make `N(x),N(y),N(z)`
pairwise disjoint. Minimality of `d(x)` now gives

```text
|R(x)| >= d(x)+d(y)+d(z) >= 3d(x) >= D(x),
```

again a contradiction. This proves the obstruction.

Importantly, `S` need not be outgoing-closed. The proof keeps all outgoing
arcs and all side-fibre neighbors; it does not extract an induced component.
It is consistent with, and does not weaken, the accepted outgoing-closed
component reduction.

### Exact support certificates

For the first indexed template, take `S={0,5,8}`. Its full neighbor-type
sets are `B_0={3,5}`, `B_5={8}`, and `B_8={0}`. The only multilabel steps
from `S` are `0->5->8->0`, each with two labels. Property 3 is vacuous.

For the second indexed template, take `S={1,2,5,6,7}`. The multilabel steps
form `1->2->7->5->6->1`, each carrying `{1,2,4}`. Its full neighbor-type
sets are `B_1={2}`, `B_2={7}`, `B_7={4,5}`, `B_5={6}`, and `B_6={1}`.
All five consecutive three-set comparisons satisfy property 3. In
particular, the side type `4` is counted, not discarded.

The saved R4 incident-repair graph also has this obstruction, with
`S={1,5,6,8}`, multilabel cycle `1->5->6->8->1` carrying `{1,3,4}`, and
neighbor sets `{5}`, `{0,6}`, `{8}`, and `{1}` in that cycle order.
This is a supplemental exclusion of that exact saved graph's expansions,
not an exclusion of the R4 repair domain, which permits changing its
projected support and labels. It is not a materially different escape
from the new obstruction.

`sparse-expansion-r5/obstructions.json` gives the critical type sets and
exact template references. `scripts/sparse_expansion_obstruction.py`
recomputes all the support hypotheses, including the side neighbors and
all triple-multilabel prefixes, directly from those saved graphs. It uses
their existing certificates as inputs without rebuilding their earlier
state certificates or integer duals. The universal argument is the proof
above; executing the script checks its finite template hypotheses, not
every expansion separately.

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  scripts/sparse_expansion_obstruction.py \
  research/sparse-expansion-r5/obstructions.json \
  --output research/sparse-expansion-r5/replay.json
```

The bounded local label-selection move was also sent to the already
discovered and inspected Jacobian operation
`graph.invariant.maximum_matching.compute`. The dedicated payload combines
two minimal `(2,1)` label-set instances over `{1,2}` and nine minimal
`(3,2,1)` instances over `{1,2,4}` as disjoint bipartite graphs. Adding
labels preserves an injective selection, and renaming the latter palette
covers `{1,3,4}` as well. The typed output supplies 31 matching edges
covering all 62 vertices; direct edge-membership and endpoint-disjointness
replay confirms the perfect matching. This is a finite check of the local
move, not the universal expansion argument or a counterexample.

The exact contract, payload, and typed output are the dedicated
`sparse-expansion-r5/jacobian-matching-*.json` files. The new invocation
used the pinned native executable, exited zero, and returned no timeout
or structured error. Its output records 51 milliseconds of operation
runtime. Native CLI transport has no MCP server/protocol handshake and
does not expose a version field in this result; the historical sidecar
version above is not asserted as new runtime metadata. The operational
record in `activity.jsonl` preserves these distinctions.

```bash
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian run \
  graph.invariant.maximum_matching.compute \
  --file research/sparse-expansion-r5/jacobian-matching-payload.json
```

No qualifying expanded graph is delivered. This is a structural blocker
for the specified saved-template route, not an unsuccessful sampled
search or a solver `UNKNOWN`. After independent review, continuation
requires a genuinely different template structure or another unresolved
mechanism; adding fibre vertices or changing these cross-fibre incidences
cannot evade the obstruction. The campaign remains open.
