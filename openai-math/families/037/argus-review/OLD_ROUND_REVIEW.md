# Family 037: final exploratory old-draft submission

**The five mathematical units are assessed; neither full volume-gap
manuscript is thereby verified.** This is the final exploratory Engineer
submission under `OBJECTIVE.md`, reusing both native substantive-review and
provenance-repair acceptances, not asserting Host-recorded final certification.
The lifting and lattice-strip arguments are supported in their explicit hypotheses;
saturation is conditional on exact lifting and canonical interiority.
The Lean evidence proves only conditional finite-facet integer algebra.
The quadric calculation supports an example and rejects an inadmissible
Argus attack. No novelty or new manuscript counterexample is claimed.

## Final submission and objective-to-result mapping

The existing coverage index maps every inventoried artifact, supporting
input, dependency, duplicate and exclusion. The five report/verdict pairs
below supply the exact claims, hypotheses, versions, attribution, decisive
arguments and evidence limits; the manuscript-targets pair gives each
broader target a concrete non-establishment disposition. This summary
integrates those results. The active `research/MATH_STATE.json` records
assumptions, retired routes and Engineer/native Reviewer opinions; its
prose assessments do not turn archived compilation into active kernel
evidence.

The accepted bounded native handoff is
`$WORKSPACE/.argus-campaign-9200037/projects/6b8f4b2d7ab2/handoffs/e02db4aca413/round-0001.json`.
Its `review.status` is `done`, and its reason expressly covers all 22
artifacts, nine snapshot counterparts, reference inputs, all 23 claim
versions and the substantive assessments with their conditional boundaries.
It is reused as prior independent evidence, not relabelled as final project
certification. The later native final-review receipt is
`$WORKSPACE/.argus-campaign-9200037/projects/6b8f4b2d7ab2/handoffs/ef824c82f603/round-0001.json`.
Its `review.status` is `done`, and its reason explicitly certifies the full
exploratory review while preserving the conditional and formal boundaries.
That is acceptance of the substantive submission, not evidence that the
persisted stage advanced. The subsequent bounded provenance-repair acceptance is
`$WORKSPACE/.argus-campaign-9200037/projects/6b8f4b2d7ab2/handoffs/450300ae762d/round-0001.json`.
Its `review.status` is also `done`; the native Reviewer confirms the passing
state check, both persisted source attributions without citation blockers,
faithful archival attribution and unchanged conditional conclusions. Its
judgement concerns the current assessment, not fresh compiler evidence.

These two acceptances are reused at their recorded scopes for the complete
corrected submission: the coverage index, all five report/verdict pairs,
this summary and active provenance. The Host-invoked independent Reviewer
must decide final acceptance of that combined submission; the Host must
durably record final certification. Neither action is manufactured here.
No new snapshot, manifest, audit packet, mathematical replay or
manuscript-error search is part of this handoff.

## Complete coverage

The controlling contract is `OBJECTIVE.md`; read-only inputs are enumerated
in `PRIOR_DRAFTS.json`. `DRAFT_REVIEW_INDEX.json` was written before
substantive assessment and is the coverage/cross-reference index.

| Coverage object | Disposition |
| --- | --- |
| All 22 inventory artifacts | Individually assigned to units or explicitly excluded as empty coordination files; every expected byte size matches. |
| Nine family entries in the existing snapshot manifest | Nine counterparts of listed artifacts, not nine extra results. All counterpart hashes match the existing manifest; neither manifest nor archive was rebuilt. |
| Thirteen additional inventory artifacts | Sources, compiler/adapter metadata and diagnostics; explicitly distinguished from the nine preserved manifest entries. |
| One reference-input bundle | Two read-only manuscript symlinks, with all 15 accessible files individually classified. All 12 manifest-listed TeX hashes match. |
| All 23 old claim-version records, 17 distinct IDs | Exactly one unit assignment per version, with exact statements/version changes in unit verdicts. |
| Fourteen historical evidence records and six routes | All mapped, with mechanical evidence distinguished from Engineer/old Reviewer opinion and stale route-version bindings disclosed. |
| Five mathematical units | Each has `research/draft_reviews/<unit>/report.md` and `verdict.json`; none is silently omitted or counted twice. |

Empty lock files are covered but excluded from mathematical results.
PDF/text pairs, compiler certificate/check/log/submission, and overlapping
script/Jacobian outputs are not counted as independent arguments.
The sole substantive shared old draft is split by mathematical obligations,
not duplicated by filename or claim-version count.

## Unit assessments

| Unit | Strongest old formulation and Engineer assessment |
| --- | --- |
| [adjoint-lifting](draft_reviews/adjoint-lifting/report.md) | **Supported within the explicit geometric hypotheses:** `C_AJL_GENERAL@5` and its `C_AJL_LIFT@1` specialization; all GENERAL versions 1-4 are assessed in their shared report scope. |
| [lattice-strip-saturation](draft_reviews/lattice-strip-saturation/report.md) | **Supported:** `C_AJL_POLYHEDRAL@2`, including lineality, and its version-1 specialization. `C_AJL_SAT@1` is supported **conditionally** on exact lifting and independently supplied `c in Int K`. |
| [facet-kernel](draft_reviews/facet-kernel/report.md) | **Supported conditional algebra:** both versions of `C_AJL_FACET_KERNEL`; version 2 adds formal evidence, not a stronger natural statement. Archived compilation and human statement fidelity are separately assessed. |
| [quadric-mixed-index](draft_reviews/quadric-mixed-index/report.md) | **Supported auxiliary example and failed attack:** all-degree normal forms, complete finite replay, and rejection of `R_AJL_QUADRIC_MIXED` because strict interior fails. No separately versioned old claim is invented. |
| [manuscript-targets](draft_reviews/manuscript-targets/report.md) | **Partial support of the historical umbrella only.** All eleven broader manuscript propositions are explicitly not established by the listed Argus drafts, with concrete missing obligations; no new correctness verdict is imposed on the papers. |

### Lifting: what the strongest proof actually establishes

For an integral smooth effective proper complex orbifold of dimension at
least two, projective coarse space, ample L, faithful cyclic local character,
and algebraic equivariant coordinates/frame, let M be a line bundle and
`t>0` rational with `M-K_B-tL` nef. A compatible nonnegative integral
exponent alpha with `(t,alpha+1) in Int K(L)` is an exact Taylor initial of
a global section of M, in total-degree-then-increasing-lexicographic order.
The proof uses finite weight separation, a weighted stack blowup retaining
inertia, a local multiplier-ideal calculation, coarse Weil-divisor vanishing,
an actual restriction surjection, and regular pushdown.

Under `-K_B=rL`, set `M=jL`, `t=j+r`. Shifted interior itself supplies
positive t and nonnegative alpha; no separate canonical-interiority
assumption is needed for lifting. Original section degree is essential.
The strongest prior natural statement, version 5, genuinely allows an
independent nef twist and rational parameter; versions 2-4 primarily added
dependency declarations to the earlier adjoint-only statement.
This review evaluates that strongest proof rather than substituting a
weaker finite test.

### Cone rigidity and saturation: exact dependency order

For a proper full-dimensional closed convex cone C, a full lattice and an
interior lattice vector c, the strip condition
`(Int C-c) intersect Lambda subset C` forces rational polyhedrality and
primitive facet height one. Version 2 does not need bounded degree slices
or pointedness. Its decisive steps force smooth boundary supports to be
primitive integral using torus recurrence, bound normalized supports in a
compact dual slice, and recover the whole cone from finitely many such
supports. This is a proof, not a bounded exclusion.

For the geometric application, exact lifting and containment give the
strip condition only after the separate premise `c in Int K` is supplied.
Height-one facets then give

```
Gamma = K intersect Lambda,
Int K intersect Lambda = c + Gamma.
```

The full congruence lattice, not a substituted standard lattice after the
integration-coordinate rescaling, is used throughout. The finite-facet
Lean theorem checks only the last integer-shift argument with its inputs
already assumed. It cannot provide canonical interiority or facet existence.

### Quadric: proof versus experiment and failed attack

For `Q^4={X0*Y=X1^2+X2^2+X3^2+X4^2}` in projective 5-space, in the
stated chart and Taylor order, the exact all-degree formula is

```
j >= alpha1 + alpha2 + alpha3 + ceil(alpha4/2).
```

The all-degree proof uses a unique homogeneous normal form with X4 exponent
zero or one and pairwise distinct Taylor initials; the least surviving
initial cannot cancel. The bounded replay in degrees 0-4 returns dimensions
`1,6,20,50,105`; it is not substituted for this proof.

The missing mixed index `(1,0,0,1,1)` has complete Taylor-prefix ranks
`6 -> 6`, but after adding `(4,1,1,1,1)` its primitive noncoordinate facet
value is zero. It is a boundary point, so absence does not contradict
interior lifting. One fresh inspected adapter operation,
`matrix.rank.compute`, returned rank 6 for the exact original 15-by-6
rational matrix. Server 0.14.0, protocol 2025-11-25, exact payload, typed
output and exit/error/timeout status are preserved in dedicated unit JSON
files; exit is 0, with no error or timeout. This is auxiliary atomic
evidence, not a proof strategy or a geometric certificate.

### Formal and computational toolchains

The archived Lean receipt is bound to the exact source, fidelity document
and `C_AJL_FACET_KERNEL@2`; all nine consistency tests pass. Both archived
compiler and axiom-audit exits are 0, with no proof holes. A current read-only
probe confirms the recorded Lean 4.31.0 commit and Lake 5.0.0-src+68218e8.
The unchanged historical receipt is reused as requested, not relabelled as
a fresh compilation. No new Lean file or new active kernel certificate was
created. Imported compiled dependencies are not individually hashed by the
old receipt, a limit disclosed in the unit assessment.

The quadric script was inspected for side effects before execution and only
its selected functions were replayed from review-local copies. No old
write-producing entry point was run. The legacy interpreter lacked SymPy;
the existing live-update interpreter, Python 3.13.5 with SymPy 1.14.0,
passed without installing packages. Formal symbolic cancellations do not
establish geometric positivity, vanishing or lifting.

## Attribution, assumptions, and known failed routes

Before substantive review, the active ledger recorded the exact old cited
assumptions HOWALD, KV_WEIL and PRINCIPALIZATION, and the known failed
mixed-index and asymptotic-substitute routes with reasons. The latter route
cannot turn asymptotic Newton-Okounkov comparisons or generic semigroup-hole
remarks into an exact fixed-degree theorem or admissible counterexample.
The old targeted search found no exact applicable primary theorem; it does
not establish novelty and was not repeated as a new literature campaign.

The lifting assessment read the actual relevant primary-source passages:
Howald's monomial multiplier-ideal theorem; Fujino's version 0.00
Theorem 3.2.4 allowing integral Q-Cartier Weil divisors, with the lc-center
condition vacuous for klt; and Kollár's smooth-functorial principalization
with SNC boundary. Their hypotheses, orbifold application and bibliographic
qualifications are explicit in that report. They are external geometric
inputs, not compiler-certified conclusions.

Historical Reviewer opinions are indexed with their exact old subjects;
the bounded substantive, final substantive and provenance-repair native
receipts are identified above. Reusing them creates no new Reviewer decision
or Host certification.

The completed bounded repair was authorized to modify the active ledger and
`research/literature/`; this final-submission mission owns only this summary.
The supported `citation_check attribute` operation
records HOWALD and PRINCIPALIZATION as **confirmed**, under
`engineer:repair-active-review-provenance`, not a Reviewer identity.
The unchanged supplied Howald excerpt is archived at
`research/literature/610edcfcc82266a99db680e761c5866d.json`.
An ASCII transcription of the already reviewed Kollár passages, retaining
their hypotheses, descent qualification and header-date discrepancy, is
archived at `research/literature/dabdaf604132aaa3f850408dab6ac68d.json`.
Both operations returned `ok: true` with no refusals. The original assumption
filer, source identifiers, locators and mathematical statements are unchanged.
KV_WEIL remains **uncited**, with its disclosed prose-only versioned source;
no DOI or lookup was invented. These are persisted source assessments, not
new independent Reviewer verdicts or discharges of the geometric assumptions.

## Validation boundary and native handoff

JSON and cross-reference validation covers all reports/verdicts, inventory
and reference assignments, exact old claim/version/statement bindings,
historical evidence/route coverage, dependency acyclicity and the typed
adapter request/result bindings. The existing integrated check returned **PASS**
(exit 0), parsing 22 JSON files and matching all 23 old claim versions.
These coverage, hash-binding and mathematical checks are previously
reviewed evidence, not fresh runs for this final submission.
The old workspaces, ledgers and snapshot
remain read-only; the current artifact counterparts match all nine existing
snapshot manifest hashes. No shared-batch-root result substitutes for a
campaign-local check.

The exact active project root is:

```
campaigns/9200037
```

The required campaign-local math-state and graph commands were run once
for this handoff, using
`$WORKSPACE/argus-latest/.venv/bin/python` at that root.
The accepted repair's unchanged citation-status result is reused, not rerun:

| Official check | Evidence scope and actual exit |
| --- | --- |
| `argus_skill.verticals.math.math_state check --project-root <root>` | Current handoff: **0**, `ok: true`, no issues. |
| `argus_skill.verticals.math.proof_graph_check check --project-root <root>` | Current handoff: **2**, `no proof graph at <root>/research/PROOF_GRAPH.json`; not a passing graph check. |
| `argus_skill.verticals.math.citation_check status --project-root <root>` | Previously accepted repair: **0**, `ok: true`, HOWALD and PRINCIPALIZATION confirmed, KV_WEIL uncited, `blocking: {}`; not a fresh run. |

The unit reports' embedded check results describe earlier bounded runs;
they do not override the accepted repair or the current handoff results.
The earlier `judgement_certificate_retired` defect concerned
`judgement-C_AJL_FACET_KERNEL-6c9c9ea978df`, by
`reviewer:e02db4aca413`, using the old
`9000037/research/adjoint_jet_lifting/certificates/C_AJL_FACET_KERNEL-1ade0225935d5908.json`.
Its active artifact now points to the already reviewed
`research/draft_reviews/facet-kernel/report.md`, which explicitly preserves
the original certificate path, compiler attribution and historical Reviewer
receipt. The existing judgement's id, subject, tier, verdict and producer
were not changed. The Engineer repair filed no new judgement under a
Reviewer identity.
The current version-1 prose assessment has judgement-tier support, including
`judgement-C_AJL_FACET_KERNEL-b0a58627f8f4` by
`reviewer:450300ae762d`, bound to the current unit report. This native
repair-review opinion is not mechanical evidence or a new formal statement.
The archived compiler result remains evidence for the old version-2 formal
claim, not a current mechanical certificate.

The bounded repair's math-state and citation-delivery checks were accepted;
the fresh math-state check still passes.
No two-zero claim is made: the graph command reports absence with exit 2.
The live final-submission objective expressly excludes fabricating a proof graph for
this nonapplicable exploratory-review check, and the prior native final
review also identifies that additional gate as outside `OBJECTIVE.md`.
No checker, mathematical statement or applicable requirement was weakened.

The index still records
`review_state=final_exploratory_submission_blocked_on_campaign_checks_and_native_certification`
and `review_acceptance_granted=false`. Those submission-status fields have
not been reconciled with the two recorded native acceptances; they are
disclosed, not silently overridden. This mission cannot edit the index or
Host certification metadata. The acceptance/recorded-certification mismatch
therefore remains explicitly unresolved pending native final review and
Host recording; no runtime cause is claimed.

The entire index and all five substantive assessments remain the submission;
their mathematical conclusions and limitations are unchanged. Only active
provenance and source-attribution persistence were changed by the accepted
repair; this handoff updates only the summary to include that acceptance
and distinguish it from final certification. Old workspaces, certificates,
ledgers, snapshots and native review receipts remain read-only. The Host
must now invoke the required native independent Reviewer on the complete
corrected review and persist its final disposition. Engineer does not
self-accept the findings or alter final certification metadata.
