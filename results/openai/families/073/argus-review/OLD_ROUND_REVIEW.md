# Complete old-draft review: family 073

The five listed artifacts have been indexed into five substantive assessment
units, with reports and parseable verdicts for all units. The strongest old
result is **C_ENGINE version 3, a source-bound, conditional formal theorem**,
not the finite no-witness experiment and not a proof of the Falconer
conjecture. This is an engineering handoff for native independent Reviewer
acceptance, not self-acceptance.

## Coverage and attribution

`DRAFT_REVIEW_INDEX.json` maps every one of the ten old claim records
(eight identifiers), twelve evidence records and seven routes, as well as
supporting files, copies and exclusions. The four substantive listed files
match the preserved snapshot manifest; the fifth is the empty ledger lock,
excluded as nonmathematical. The old workspace, snapshot and their ledgers
were not modified. No archive or inventory was rebuilt.

| Unit | Assessment | Detailed artifacts |
| --- | --- | --- |
| Scheduled recursion | Supported abstract conditional engine; includes its four constituent obligations and weighted-rank strengthening | [Report](draft_reviews/scheduled-recursion/report.md), [verdict](draft_reviews/scheduled-recursion/verdict.json) |
| Finite payment experiment | Existing exact replay reproduced within its stated finite domain | [Report](draft_reviews/finite-payment-experiment/report.md), [verdict](draft_reviews/finite-payment-experiment/verdict.json) |
| Rejected linear optimization | Both historical requests failed admission; neither supplied a mathematical conclusion | [Report](draft_reviews/rejected-linear-optimization/report.md), [verdict](draft_reviews/rejected-linear-optimization/verdict.json) |
| Analytic reductions | Actual analytic hypotheses identified concretely, but not established or refuted by the old draft | [Report](draft_reviews/analytic-reductions/report.md), [verdict](draft_reviews/analytic-reductions/verdict.json) |
| Global assembly | Entry, restoration and scalar reconstruction assessed conditionally; complete global claim remains unestablished | [Report](draft_reviews/global-assembly/report.md), [verdict](draft_reviews/global-assembly/verdict.json) |

The manuscript is OpenAI, *The Falconer distance conjecture in all dimensions*,
2026-09-23, revision `4eaee87548250b2682affda7d05d947c05554bae`, pinned by
`9100073/MANUSCRIPTS.json`. All fourteen reference and old staged TeX files
match their pinned hashes. Its global statement concerns compact
`E subset R^d`, integer `d>=2`, and `dim_H(E)>d/2`, with positive Lebesgue
measure of the original Euclidean distance set. It is not the encoded
formal statement.

The block policy, potential and intended saving are manuscript arguments.
Argus supplied their formal encoding, the explicit weighted resource and
integer-budget strengthening, and the finite experiment/tool attempts.
The per-unit verdicts separate those attributions and leave global novelty
unverified or inapplicable. **This review asserts no new mathematics;
its overall novelty_status is not_applicable.**

## What the strongest certificate establishes

C_SCHEDULE, C_PAYMENT, C_TERMINATION and C_TELESCOPING are constituents of
one argument, not four additional independent results. C_ENGINE@1 and @2
are source-free predecessor records; @1's prose was already conditional,
while @2 records the analytic assumption explicitly. @3 binds the full
formal source. These are not three separate theorems or failed proofs.

For `N>0`, `0<sigma<=kappa<=1`, let `q=ceil(kappa*N)`,
`s=ceil(sigma*N)`, `f=ceil(10*sigma*N)`. The principal theorem quantifies over
fixed legal block representatives/choices, a Lipschitz profile with constant
`D>=0`, a valid root of smoothing index zero **with an attained root
potential V**, nonnegative overheads epsilon/eta, and a real state-value
function satisfying the stated local stopping/transition inequalities.
It proves

```text
value(root) <= 2*A(start_root)-V(root)+20*D*q+B
               +(20/kappa)*epsilon+(1/sigma)*eta.
```

The inherited-origin argument genuinely handles an origin not containing
the current interval. Positive cost forces its minimizer left of `b+2*q`,
and direct geometry places the current right endpoint below `u+2*q`;
these put the separated child pair into the origin's domination range.
Payment is derived, not assumed.

Strictly decreasing width proves well-foundedness. The additional resource
`q*(3*unreached_anchors+credit)+finish` proves
`q*n<=q*(3*K+2)+N` and `s*m<=N`, hence the sharper real bound
`n<=3*K+2+N/q` before the manuscript's `20/kappa` estimate.
A near step crossing no anchor loses credit because its remaining list
is unchanged. Short final children have zero cost; telescoping uses the
last defined potential. Local max-plus inequalities yield a stopping branch
by well-founded induction, rather than assuming global branch domination.

One wording qualification is material: the old report's “every valid initial
state” is too broad without the root-potential premise, which requires
width at least `10*q`. The intended nonterminal manuscript root satisfies
it. This is a scope qualification of Argus prose, not a manuscript
counterexample. Separate width lemmas supply child-potential definedness
for suffix/high/direct rows; the C_PAYMENT natural statement does not
silently require definedness for all short zero-cost rows.

## Mechanical evidence and historical reconciliation

The old source, root/research fidelity copies, current receipt, embedded
C_ENGINE@3 statement and immutable current archive all match.
The historical Lean 4.31.0 compile and axiom audit exited zero with no
proof holes; only `propext`, `Classical.choice`, `Quot.sound` are printed
for the principal declarations. A current probe confirms the same Lean
build in the existing Mathlib v4.31.0 Lake workspace. This review reuses
that source-bound run: no fresh Lean compilation or current dependency
re-audit is claimed, and no new `.lean` file was introduced.

The read-only ledger command derives `conditional_kernel` for C_ENGINE@3,
with A_ANALYTIC_REDUCTIONS still undischarged and no stale evidence.
The old ledger contains five current-bound supporting judgements by
`reviewer:copilot:f37ea3c4566f` for the engine and its four constituents,
plus an **inconclusive** analytic-assumption judgement. Old graph open/false
review labels and pending-review prose are therefore not evidence of an
absent scoped review; neither are those ledger entries acceptance of the
global manuscript or this complete draft review. Their timestamp-free
records do not establish an acceptance date.

The earlier compiler archive has the same formal source and an older
fidelity document. The current reading adds the safe low-row enlargement
at suffix parents. This is certificate/translation revision, not a
mathematical failure. R_SCHEDULED_CORE's retirement explanation says
“superseded source-free digest”, although its stored goal already binds
@3; that historical inconsistency is explicit in the index. The retired
route remains retired. R_FALCONER actually retains the source-free engine
obligation and is superseded by R_FALCONER_CURRENT; the analytic and assembly
gaps persist in both decompositions.

These old archives are **reading material**, not mechanical certificates
for the current review claims. Current ledger judgements cite current
assessment reports and do not manufacture a kernel-closed review theorem.

## Finite and solver evidence

The existing default `verify.py` was invoked with
`$WORKSPACE/argus-latest/.venv/bin/python -B` from the current
campaign, without `--write` or `--lean`. Exit 0 reproduced twenty
profile/parameter instances, 29,624 suffix/high row checks, 437 direct
checks and 485 inherited-origin memberships; seven direct checks and six
inherited memberships have positive cost. The misleading legacy field
`positive_cost_cases` includes zero costs. The 1,704 descriptor count is
a sum of deduplicated dictionary sizes, not generating origins. These
are bounded exact experiments, not exhaustive universal or geometric
verification.

Both historical general-LP requests retain their exact payloads, server
0.14.0/protocol 2025-11-25 and structured admission errors. They were not
rerun. A separately discovered and inspected bounded
`linear.rational_solution.compute` operation checked only the already-used
three-row coefficient identity. Its complete typed `SOLUTION`, exit 0,
payload and independent rational replay are retained. This verifies
adding three weak inequalities with weights `(1,1,1)`; it does not repair
the old optimization attempts or prove policy/analytic hypotheses.

## Concrete limits and review handoff

The analytic unit names the exact missing bridge: supported Fourier-energy
reductions with uniform symbols and derivative budgets, numerical child
aggregation, subpower coefficients, correct zero-cost low overhead,
terminal bounds and arbitrary-power errors; a finite state-wise max-plus
envelope must handle unrealized shapes, zero values and symbol suprema.
Sections 03/04/06/07/08 are not certified by the combinatorial proof.

The assembly unit separately assesses entry-profile cancellation, original
mass and unnormalized-fiber restoration, spatial-product losses, the
positive monotone limiting measure and scalar shell reconstruction.
Their necessary prepared data and actual shell bounds are not supplied
by the engine. Unestablished does not mean false; no blanket claim that
the manuscript is correct, no manuscript refutation, and no Falconer
theorem is delivered.

No external theorem or novelty search was needed for this bounded draft
review. The supplied manuscript was available and read; local source-only
assumptions are identified as such, without inventing registry identifiers
or independent citation approvals. The shared Wiki index contained no
relevant Falconer/scheduled-recursion review page. No open analytic project,
broadened search, framework maintenance or pipeline-state edit was undertaken.

The native Host-invoked independent Reviewer must assess the index, all five
reports/verdicts, source fidelity and coverage before final acceptance.

The official `math_state check` and `proof_graph_check check` both returned
exit 0 against the exact project root
`campaigns/9200073`, including after
the current review-ledger updates. `draft_reviews/project_checks.json`
records their commands, outputs and zero statuses. The graph deliberately
keeps review obligations open pending independent acceptance.
The exact inventory/claim/evidence/route comparison and verdict parsing are
recorded in `draft_reviews/coverage_check.json`.

The documented legacy command
`$WORKSPACE/argus-latest/.venv/bin/python -B -m argus_skill.verticals.math.check --help`
returned `No module named argus_skill.verticals.math.check`.
No runtime repair was attempted. The installed delivery-gate entry point
`argus_skill.verticals.math.stages.stage_completion_issues("review", root)`
returned no issues, and the canonical bounded research-result contract
passed with `novelty_status=not_applicable`. These are engineering checks,
not independent Reviewer acceptance.
