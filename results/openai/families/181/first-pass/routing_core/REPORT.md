# Root-labelled routing core

## Statement and scope

Let P be a finite simple undirected graph on r >= 2 vertices, with cut
expansion at least h > 0. Let S be nonempty, let F be a common set of
deleted edges, and attach to each s in S a forbidden vertex set W_s with
s not in W_s. Assume

    |W_s| <= h/4,    |F| <= h|S|/4,    |F| <= hr/64.

Put g = ceil(8(r/h) log_2(2r)). The target is a root s whose radius
g(1 + ceil(log_2 |S|)) ball in (P-F)-W_s contains more than r/2
vertices. Every union below retains the original graph of each root.
This is the graph-level dependency in `routing.tex`, from
`eq:routing-union-growth` through `eq:routing-restart-budget`.
It is not a verification of the full cycle-decomposition theorem.

The staged source specifies base-two logarithms in `main.tex` and
`preliminaries.tex`, and counts edges, not vertex neighbours, in its cut
expansion. The supplied previous finding supported the matching theorem,
but did not certify the graph-growth dependency. The present route
addresses that dependency directly. The inherited Wiki contains no
applicable root-labelled growth result; the finite-cut page inspected
concerns a different, geodesic argument. No prior novelty claim is made.

## Graph-level proof

Write B_t(A) for the union, over s in A, of the radius-t ball in
(P-F)-W_s. The balls and their graphs are never replaced by a ball in
a graph with a common forbidden set.

Suppose 0 < |B_t(A)| <= r/2 and |F| <= h|B_t(A)|/4. For each vertex
v in B = B_t(A), select one label s(v) that reaches it. Orient every
boundary edge from B to its complement. At most |F| of these oriented
edges are deleted: this orientation is injective on undirected edges.
For each fixed v, at most |W_{s(v)}| <= h/4 boundary edges end in
that label's forbidden set, because P is simple. Thus at least
h|B| - |F| - (h/4)|B| >= (h/2)|B| boundary edges extend a
valid labelled path. Their outside endpoints lie in B_{t+1}(A)-B.
Each outside endpoint has at most r incident counted edges, giving

    |B_{t+1}(A)| >= (1 + h/(2r)) |B_t(A)|.

This is a count in the actual graph, not an assumed numerical recurrence.
Overlaps of balls and differences among forbidden sets cause no loss:
only the selected label of the inside vertex is used.

Monotonicity preserves both the positive starting size and the
edge-deletion threshold. Iterating the inequality for g steps would,
if the union stayed at most r/2, force it above r/2. For completeness,
put a = h/(2r). Singleton cuts imply h <= r, so 0 < a <= 1/2.
The elementary natural-log bound ln(1+a) >= a/2, together with
ln(2) <= 1, gives

    g ln(1+a) >= 2 ln(2r) > ln(r/2).

Since the starting cardinality is at least one, this contradicts the
assumed final cardinality. The natural ceiling in g can only increase
the left side. Consequently any nonempty union meeting the threshold
exceeds r/2 after another g steps.

Initially B_0(S) = S, so the first deletion budget starts this growth
block. If |B_t(A)| > r/2, partition A into halves of size at most
ceil(|A|/2). One half A' has |B_t(A')| > r/4, by the union bound
for cardinalities. The other budget yields

    |F| <= hr/64 < h|B_t(A')|/4.

Apply the growth block with the same root labels, the same sets W_s,
and the same deleted edges F. After at most ceil(log_2 |S|) halvings,
one root remains and its ball exceeds r/2 at the required radius.
An equivalent induction partitions a set of at most 2^(m+1) roots
into two sets of at most 2^m roots; it avoids rounding ambiguities.

## Connection to the indexed-team routing lemma

For a failed matching condition on a nonempty indexed demand set I,
the manuscript constructs a matching of size at most 2 ell (|I|-1).
Each resource hyperedge contains at most ell graph edges and ell
team-labelled internal-vertex tokens. Therefore

    |F| <= 2 ell^2 |I|,
    sum_c |Y_c| <= 2 ell^2 |I|.

Since every team has at most b demands, at least |I|/2 demands have
|Y_{c(p)}| <= 4b ell^2. A maximal selection of disjoint endpoint
pairs has at least |I|/(4k) demands. Also 2|I| <= kr.
These counts concern indexed demands, so repeated pairs are allowed.

For each selected demand p use
W_p = (Z_p union Y_{c(p)}) - {x_p,y_p}. Both endpoints survive,
including when Z_p contains them. If both endpoint balls of radius
T = ell/2 exceeded r/2, their intersection would give a walk of
length at most ell. Removing closed subwalks gives a simple path
avoiding F and with internal vertices avoiding Z_p and Y_{c(p)}.
Its resource hyperedge could augment the matching, a contradiction.
Thus each selected pair supplies one small-ball endpoint; their
distinctness gives a root set S with |S| >= |I|/(4k).

Under h >= 64(ell^2(k+b)+z), the exact budgets are

    |W_p| <= z + 4b ell^2 <= h/16 <= h/4,
    |F| <= 8k ell^2 |S| <= h|S|/4,
    |F| <= ell^2 kr <= hr/64.

The root theorem contradicts every selected radius-T ball being small,
because |S| <= r and
g(1+ceil(log_2 |S|)) <= g(1+ceil(log_2 r)) = T.
The matching condition follows. Applying the bounded-rank
Aharoni--Haxell theorem with rank 2 ell gives disjoint representatives.
Edge resources impose global edge-disjointness; tokens (v,c) impose
internal vertex-disjointness only within each team. Endpoints carry no
tokens, and different teams share vertices without competing for tokens.

The sole non-elementary input to this final routing inference is
Bucic--Montgomery, arXiv:2211.07689v2, Theorem 6, the matching theorem
restated in `preliminaries.tex`. It is not an assumption of the
graph-level root theorem. Sampling, folding, scale splitting, and the
global induction remain outside this certification.

## Exact certification and replay

The universal graph-level assertion is verified by Lean 4.31.0.
`Main.lean` derives graph boundary growth, the ceiling-defined growth
block, and label-preserving root halving. Its principal declaration
`RoutingCore.routing_root` concludes the result for actual bounded-walk
balls in each root's graph. `mem_ball_iff_walk` proves both directions
of the graph-ball interpretation. `obstruction_budgets` separately
formalizes the inequalities connecting the matching obstruction to
the root theorem. The printed theorem dependencies are precisely
Lean's standard foundational axioms, with no custom axioms or holes.

The official verifier returned `status=success`, `exit_code=0`, and
`proof_holes=[]`, and attached mechanical evidence to V_ROUTING_ROOT
version 2. Its immutable claim certificate is
`certificates/V_ROUTING_ROOT-fa23589cc74773a0.json`; the raw command
answer is `official_verification.json`. The ledger reports
`closed_kernel`, with no undischarged assumptions for this graph theorem.
That status does not certify the translation into natural language:
the independent statement-fidelity reading is still required.

Both official structural checks passed against the exact campaign root
`campaigns/9000181` at
2026-11-05T17:27:29Z: math_state exit 0 and proof_graph_check exit 0.
Binding the completed formal source changed the goal's version;
the checker-required stale route references were rebound to that
unchanged natural assertion's formal version. The historical discovery
route retains its explicit supersession reason, not a false claim of
mathematical failure.

From the campaign directory, replay with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/routing_core/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/routing_core/Main.lean --project-root . --claim V_ROUTING_ROOT --statement-fidelity research/routing_core/STATEMENT_FIDELITY.md
```

The installed verifier takes the source positionally, rather than via
the `--source` spelling in the mission brief. It creates the canonical
lowercase `statement_fidelity.md` as an identical copy of the requested
uppercase fidelity document. Both are retained; neither source nor
fidelity text was changed after the recorded compiler run.

The standalone script uses only Python's standard library and the
installed Lean/Mathlib toolchain. It performs a fresh real Lean compile,
checks the printed axiom dependencies, and independently replays the
exact finite and algebraic certificates. Its recorded run in
`verification_results.json` returned:

| Exact check | Measured result |
|---|---|
| All simple labelled graphs of orders 2 through 5 | 1,098 graphs, including 771 connected graphs |
| Eligible labelled-union growth tests on those graphs | 12,122 passed |
| K_16, two common edge deletions, three different forbidden sets | all three roots have majority balls; exact g = 80 |
| K_63 plus a degree-eight vertex, six common edge deletions, different two-vertex forbidden sets | root 0 stays isolated; roots 9 and 10 have majority balls; exact g = 448 |
| Rounded halving bounds | all starting root counts 1 through 256 passed |
| Obstruction-budget polynomial identities | all three exact nonnegative coefficient identities passed |
| Independent replay of the bounded Jacobian cut | cut capacity 11, matched by eleven explicit edge-disjoint paths |
| Universal theorem | fresh Lean compile, exit code 0, no proof holes |

These finite checks are supplementary, not the proof of the universal
statement. The isolated-root construction disproves only the unasked
strengthening "every root has a majority ball". It does not refute any
assertion in the manuscript. Some other roots explicitly forbid vertex
0, so treating the forbidden sets as one common deletion would not
preserve the hypotheses. No false manuscript assertion was found in
this routing core, and no F_ claim is being suppressed or repaired.

## Jacobian and source provenance

The authorized Argus adapter was queried for graph-distance and cut
operations and the exact `graph.cut.minimum_st.compute` input/output
schema was inspected before the finite checks were written.
The selected operation accepts at most 64 vertices and 512 directed
capacitated edges. The actual request is the root-0 graph from the K_16
case, with 178 unit-capacity directed edges; forbidden vertices 1 and 2
remain isolated. This matches the rootGraph convention in Lean.

`jacobian_request.json` preserves the exact typed request.
`jacobian_result.json` preserves the exact output, operation id, server
version 0.14.0, protocol 2025-11-25, and source-bound request.
`jacobian_status.json` records adapter exit 0 and no timeout.
The operation returned minimum cut 11; verify.py independently checks
both its cut capacity and eleven disjoint paths. No timeout, unknown
answer, or nearby operation is used as evidence for the universal
theorem.

The matching theorem was read at the primary source
https://arxiv.org/html/2211.07689v2#Thmtheorem6.
`BM_THEOREM6.txt` preserves its proposition, including all hypotheses,
and notes the immediately following explicit permission for repeated
endpoint pairs. It is recorded as assumption AH_BM6 of D_TEAM_ROUTING.
The Engineer cannot independently confirm their own citation;
independent attribution remains a Reviewer obligation. This assumption
is absent from V_ROUTING_ROOT.

## Remaining frontier and result classification

Compared with the prior state, the new result is a kernel-checked,
universal theorem about the actual root-specific graphs, not merely a
numerical exponent check, bounded search, or an assumed growth
recurrence. It verifies the shared routing dependency used in
small-residue construction and simple-cycle lifting. It establishes
no new global decomposition bound and makes no verified-new novelty
claim; the manuscript already contains the mathematical argument.

Independent Reviewer replay and statement-fidelity review remain
required. The team-routing inference additionally requires independent
confirmation of the cited matching proposition. Sampling, scale
splitting, pair folding, batch-resolution costs, and the final induction
are still open in PROOF_GRAPH.json. This bounded Engineer milestone
does not complete the publishable campaign or certify thm:main.
