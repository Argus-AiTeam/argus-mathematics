# Family 020: review of the old adaptive-prime draft

## Result and acceptance boundary

The Engineer review accounts for **all 26 inventoried artifacts, all 19
claim versions representing 16 distinct claims, all 16 proof-graph nodes,
18 historical evidence records and seven old routes**. One substantive
Argus draft family is assessed in six mathematical units, rather than
counting duplicate source files or compiler runs as independent results.
The complete path/version/dependency map is
[DRAFT_REVIEW_INDEX.json](DRAFT_REVIEW_INDEX.json).

The finite deletion argument is supported in its intended integer-record
scope. The actual-kernel, patch-height and constant-selection bridges also
have substantive supporting arguments, with the separate residue-cut
input kept explicit. The line-family construction invalidates an
alternative independence proof, **not the manuscript**. None of this
certifies the whole affine-counting or density theorem.

**Final project-level exploratory certification is pending.** The
[prior native independent review]($WORKSPACE/.argus-campaign-9200020/projects/cdb37a3112a3/handoffs/70a61f7e0e5e/round-0001.json)
accepted coverage of all 26 artifacts, 19 claim versions and 16 graph
nodes, and the six substantive assessments. It also explicitly determined
that a current campaign proof graph is not an acceptance requirement of
`OBJECTIVE.md`. That bounded acceptance is not the final project-level
certification requested here.

This final submission reuses the index, all six report/verdict pairs and
their accepted replay evidence. The native Host-invoked independent
Reviewer must decide explicitly whether the entire old-draft review
satisfies `OBJECTIVE.md` at the preserved **exploratory** target.
Certification concerns review completeness, not a proof of the unresolved
full manuscript; Engineer does not make that decision.

## All units

| Unit and report | Claims/versions | Engineer assessment | Important boundary |
|---|---|---|---|
| [Finite deletion](draft_reviews/finite-deletion/report.md) | `C_ADAPTIVE_SAMPLING@1`, `C_ADAPTIVE_FINITE@1`, `C_ADAPTIVE_FORMAL@1-4` | Sound human incidence/indicator/telescoping proof; final generic Lean core compiles afresh. | Integral \(B_0\) is needed for the \(B_0-1\) span. Concrete subset sampling, normalization and composition are checked human mathematics, not an end-to-end Lean probability theorem. |
| [Actual kernels](draft_reviews/actual-kernels/report.md) | `C_ADAPTIVE_KERNELS@1` | Full rational kernel nesting, equality induction and mixed-radix encoding support the actual insertion/deletion comparison. | Equal ranks on unrelated incomparable paths do not identify their kernels. Deterministic normalized patch choices must agree on equal inputs. |
| [Patch height](draft_reviews/patch-height/report.md) | `C_ADAPTIVE_HEIGHT@1` | Projection, bounded integer evaluation nullspaces and lower-dimensional recursion explain coefficient-free uniform minor heights and divisor budgets. | This is prose algebraic geometry, not Lean certification. The required sum-over-all-components degree convention is explicitly present in the source, not a remaining gap. |
| [Cumulative products](draft_reviews/cumulative-products/report.md) | `C_ADAPTIVE_PRODUCTS@1`, `C_ADAPTIVE_MECHANISM@1` | The ordered constants, elementary growing pools, conditional expectations, Markov/union bound and cumulative thresholds check. | Fixed cut degrees are supplied conditionally by the separate residue-cut statement; that theorem and the counting tree are not proved by the probability argument. |
| [Failed independence](draft_reviews/independence-failure/report.md) | `C_ADAPTIVE_NO_INDEPENDENCE@1` | Actual line evaluation kernels can make a singleton's full minor its selected prime while the deleted minors are units. | A permitted deterministic-patch example and a failed alternative proof, not a counterexample to the manuscript or to its final large-block schedule. |
| [Manuscript boundary](draft_reviews/manuscript-boundary/report.md) | `C9000020@1` and seven broader claims | Every larger statement has an explicit unresolved disposition and exact missing dependency. | No new manuscript-error search, no blanket source-correctness assertion, and no completion of density by verifying one local mechanism. |

Every unit has a companion `verdict.json`; each requires independent
review and sets `independent_acceptance=false`.

The direct coverage comparison passed: exact artifact and claim-version
sets, all old graph dependency lists, all seven version-specific routes,
all 18 evidence bindings, six report/verdict pairs and the typed replay
bindings agree with the inventoried inputs. All 14 current JSON files
parsed successfully. This is structural coverage validation, not an
independent mathematical verdict.

## Exact finite conclusion and application

For a finite pool of \(n\) distinct primes, a nonincreasing integer record
\(0\le R(U)<B_0\), stable-edge equality of the adaptive integers, and a
uniform distinct-pool-divisor cap \(D\), positive \(\ell,T\) with
\(\ell+T-1\le n\) give
\[
\mathbb E(\text{full-path bad fraction})
\le \frac{F(\ell-1)-F(\ell+T-1)}T+
       \frac DT\sum_{t=\ell}^{\ell+T-1}\frac1{n-t+1}
\le \frac{B_0-1}T+\frac D{n-\ell-T+2}.
\]
The deleted subset, not record stability, is the conditioning object.
The last denominator is positive, including the full-pool endpoint.
Primality and nonzero products are needed to obtain a height-based
divisor cap, not for the generic edge indicator inequality itself.

In the manuscript application \(B_0=\prod_i(M_i+1)\) is already an
integer. Full rational kernels on nested residue point sets, fixed
normalized patch choices, and the complete mixed-radix record give the
stable-path equality the theorem needs. Failed expected dimension drops
do not truncate the path or invalidate the argument.

The patch proof uses total geometric degree, not only top-dimensional
degree. The manuscript expressly defines degree as the sum over all
geometric components (`03-affine-counting.tex:20-24`), resolving the
initial matching question. Bounded-size cofactors of integer evaluation
matrices control coefficient heights independently of the number of
sample points or the initial equations. Proper cuts, conjugate
intersections and nonzero-minor boundaries recurse in smaller dimension.
The standard degree and field-theoretic inputs are exposed in the unit
report; they are not claimed to have been checked by Lean.

The constant schedule fixes \(\gamma\), degrees, \(B_0,K\), then
\(\xi,T,\zeta,\ell_i\), and finally \(X\). The budget
\(D=\lfloor K/\zeta\rfloor\) can depend on \(\zeta\) without depending
on \(X\). Uniform conditional estimates supply common regular points,
and avoiding every full-path minor licenses the use of earlier primes
for the current parent. The resulting product is at least
\(X^{\delta_{h_i}+\gamma/2}\) at every scheduled step.

## Preservation, duplicates and versions

All **15** family-020 entries in the existing snapshot manifest match
their old-workspace sizes and existing digests. The other **11** listed
supporting files are available with their listed sizes, but are not
represented as manifest-preserved: three empty locks, two compile logs,
two Jacobian files and four submission receipts. Empty locks are excluded
as nonmathematical; the other supports are individually assessed.
No snapshot, manuscript, old ledger or old draft was modified.

Both `Main.lean` copies and both fidelity documents are byte-identical.
The two final certificates with the same basename are **not** identical:
their 13,692/13,732-byte records differ in nine evidence-ID/path/output/
timing metadata fields, while agreeing on the mathematical source,
fidelity, claim subject and successful compiler/audit outcome.

The four formal natural-language statements agree. Version 1 has no
formal source. Version 2 has failed addition/elaboration and heartbeat
checks; version 3 still has a tactic "No goals to be solved" error.
Version 4 repairs proof tactics without changing mathematical hypotheses.
Failed compiles are not theorem refutations or supporting proofs.
The old finite route still references formal **v1**; v4 evidence was
not silently assigned to it.

All four old run receipts merely say `state=submitted`. They are not
completion records, and no historical task was restarted or polled.
Historical supportive Engineer/Reviewer ledger judgements coexist with
an all-open old proof graph. Neither label is current acceptance.

## Replays and their actual scope

After inspecting side effects, the old `verify.py` ran **once**, from
the current campaign, with bytecode disabled and without `--write`.
It exited **0** and matched the parsed historical certificate exactly:
194 monotone records on pools of sizes 1-3, 4,224 optimized cases,
actual rational kernel experiments in degrees 1-3, and three exact
constant regressions. These remain finite experiments. Details and
actual commands are in
[verify_replay.json](draft_reviews/finite-deletion/verify_replay.json)
and [regression_results.json](draft_reviews/finite-deletion/regression_results.json).
The verifier's historical Lean-summary check is not a new compiler run.

A separate **fresh real Lean 4.31.0** compilation of the read-only
canonical source exited **0**, as did the installed local-declaration
axiom audit. It used the existing Mathlib v4.31.0 workspace and no new
source, lakefile or toolchain. The source declares no local proof holes
or nonstandard axioms; this is not a claim that imported mathematics
has no foundational axioms. The exact commands, tool versions, durations
and logs are in
[lean_replay.json](draft_reviews/finite-deletion/lean_replay.json).
This is a compiler replay, not a new official claim-bound certificate or
a newly earned `closed_kernel` ledger status.

One freshly inspected, bounded Jacobian adapter operation,
`prime_field.matrix.rank.compute`, replayed the old 4-by-6 matrix over
\(\mathbb F_7\). It returned **rank 1**, exit **0**, server **0.14.0**,
protocol **2025-11-25**, without timeout or structured error. Exact
payload and complete typed response are
[jacobian_payload.json](draft_reviews/independence-failure/jacobian_payload.json)
and [jacobian_result.json](draft_reviews/independence-failure/jacobian_result.json).
The corresponding rational rank is 3. This local bad-reduction check
neither refutes the manuscript nor certifies its geometry.

## Remaining mathematics, novelty and validation

The residue-cut determinant proof, counting-tree argument, Sections 4-10
uniform arithmetic/geometric inputs, Section 11 tail assembly, and exact
sieve transfer remain outside the old adaptive result. The boundary
report identifies the precise statements and hypotheses, including
content-prime Euler factors. Their proofs were not supplied by the
inventoried draft; they were not replaced by a failed run or a generic
claim of correctness.

There is **no new theorem or stronger bound than the strongest old
adaptive result**. The improvement is a complete, source-qualified
assessment of all arguments and evidence versions, with the missing
formal composition and upper-level obligations made explicit. The
historical prior-art lookup established no novelty; no priority claim
or unverified external proposition is imported here.

Current campaign-local official checks were invoked against exactly
`campaigns/9200020`,
using `$WORKSPACE/argus-live-update/.venv/bin/python`,
not the shared batch root:

| Check | Observed exit | Meaning |
|---|---:|---|
| `argus_skill.verticals.math.math_state check --project-root <campaign>` | 0 | Ledger structurally valid. |
| `argus_skill.verticals.math.proof_graph_check check --project-root <campaign>` | 2 | No current campaign `research/PROOF_GRAPH.json`; this is not a passing graph check. |

These are the observed exits, not a claim of two successful checks.
The prior native review explicitly adjudicated the missing current graph
as outside this retrospective review's acceptance requirements. The old
graph's 16 nodes remain covered in the index; no current graph was
created, no old graph was copied, and no mathematical statement or
checker was weakened. The unit assessments, replay evidence, ledger and
acceptance flags remain unchanged.

The remaining delivery requirement is the native independent Reviewer's
explicit **final project-level exploratory decision** on this complete
submission, rather than another bounded completion report.
