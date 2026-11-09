# Family 025: review of the old Argus drafts

The complete inventory has **77 listed artifacts, 14 historical claim
versions, 22 evidence records, seven routes, and two mathematical draft
units**. The coverage index is `research/DRAFT_REVIEW_INDEX.json`.
Every listed artifact occurs exactly once in its artifact groups; shared
arguments, embedded source copies, and reference-only upstream files are
not counted as independent Argus results.

| Unit | Assessment | Important boundary |
|---|---|---|
| [Fixed-order reproduction and real-exponent bridge](draft_reviews/fixed_order/report.md) | Supported at the exact fixed-order scope; upstream reproduction plus an Argus bridge | `forall D,r exists S0(D,r)`, not a threshold uniform in a growing range |
| [Growing-order upper theorem and primorial obstruction](draft_reviews/growing_order/report.md) | Series estimate and upper theorem supported by exact archived formal evidence; infinite obstruction supported by the elementary prose argument; paired scale supported | Upper constant `1/200000`; failure for each fixed `C>1/2`; no sharp constant or verified novelty |

Each unit has a substantive `report.md` and a machine-readable `verdict.json`.
These are Engineer-origin assessments, not self-acceptance. The native
Reviewer subsequently accepted their substantive coverage, mathematical
calibration, review-level classification, and completion of the entire
objective. A later independent acceptance confirms the bounded evidence-binding
repair. **This submission requests native final certification of the entire
`OBJECTIVE.md` against the persisted exploratory target, using whole-objective
acceptance `65b340fab33d` and accepted repair `4593b6136ccc`, not another
bounded acceptance. Engineer cannot supply the independent decision or certify
the project.**

## Classification of the review, not of the old mathematical results

`OBJECTIVE.md` explicitly assigns a review of existing Argus work, not a new
manuscript-error search, and requires a complete index and per-unit assessments.
`PRIOR_DRAFTS.json` identifies `task_kind: old_draft_review`, the read-only old
workspace, the partial preserved snapshot, and the 77-artifact corpus.
`campaign.json` and `.argus/PIPELINE_STATE.json` retain the operator's
`research_target_level: exploratory`. Old objectives and status labels remain
review data, not a replacement objective.

The review's contribution is exhaustive accounting and a calibrated assessment
of those supplied drafts. The index's artifact groups and claim-assessment map
cover all 77 artifacts and 14 claim versions, including shared dependencies,
copies, exclusions, failed reasoning, and unresolved claims. Its two units
link to both substantive reports and verdicts; classifying this deliverable
does not replace those assessments with a generic literature summary.

The [fixed-order assessment](draft_reviews/fixed_order/report.md) attributes
the natural-order theorem to upstream work and the real-order bridge to Argus,
without claiming novelty. The [growing-order assessment](draft_reviews/growing_order/report.md)
supports the exact formal upper bound and informal infinite obstruction, but
its `verdict.json` retains `result_class: review_of_existing_theorem_candidate`,
`novelty_status: unestablished`, `significance_status: unestablished`, and an
`unresolved` verdict for `C_GROWING_DIVISOR_NOVELTY` v1. Those are assessments
of the old mathematical results. "Existing Argus work" does **not** mean that
the growing-order paired theorem is already known in the literature.

The independently accepted correction distinguishes the **review-level**
classification `result_class: literature_review` with
`novelty_status: not_applicable` **only for this existing-work review**.
The justification is the assigned object and delivered review evidence, not
an inference that an exploratory target waives mathematical novelty.
This mission produces no new theorem, counterexample, improved constant,
or priority result. Native handoff `9233dae0850a/round-0001.json` accepts
that distinction after considering the objective, complete index, both
assessments, and prior native decisions. This prose does not edit structured
Host records or turn that bounded acceptance into project certification.

The old growing-order novelty obligation remains concrete and unresolved,
as detailed below. Review-level `not_applicable` cannot discharge it, relabel
it `verified_new` or `known`, or upgrade its publishable significance.
All mathematical statements, unit verdicts, coverage mappings, archived
evidence, old inputs, and independent judgments remain unchanged.

### Review-level significance: rationale for independent assessment

The Engineer recommends **exploratory significance for the completed review**,
not for the old growing-order theorem. The contribution is a source-specific
mathematical assessment that establishes what this corpus supports and what
cannot responsibly be inferred from it. Its significance is not established
by the artifact count, successful compilation, or previous acceptance alone:

| Accepted review contribution | Why it is substantively useful at the exploratory level |
|---|---|
| `DRAFT_REVIEW_INDEX.json` maps all 77 artifacts and 14 historical claim versions into two argument units, separating shared proofs, source-free predecessors, exact formal bindings, and reference-only modules. | It identifies which mathematical assertions the evidence actually supports, without counting copies or transferring a certificate to an unsupported version. Subsequent work can use a specified claim and proof dependency rather than a historical status label. |
| The fixed-order report, Sections 1-3 and 7, and growing-order report, "Decisive upper-bound argument" and "Paired conclusion, failed substitution, and metadata", distinguish `forall r exists S0(D,r)` from a simultaneous `exists S0(D) forall r` theorem. They substantiate the separate uniform argument and retain the invalid substitution as invalid. | This resolves a consequential interpretation of the drafts: the growing-order range needs its own proof, while neither that failed inference nor finite witnesses refute the original fixed-order lemma. The review establishes that boundary without claiming a newly discovered counterexample. |
| The growing-order report separates the formal upper bound with constant `1/200000`, the informal infinite obstruction for each fixed `C>1/2`, and the finite replays. Its literature section specifies the unresolved parameter-tracked comparison, including growth parameter `2^r` and potentially shrinking `log(Y)/log(N)`. | It makes the up-to-constants conclusion usable at its justified scope and locates the actual remaining obligation. A sharp constant, a formally checked obstruction, and a priority/significance result cannot be inferred from these different kinds of evidence. |

This is substantive exploratory synthesis and critical assessment of the
assigned existing work, not new mathematics or a claim that the old theorem
is publishable. Relative to the strongest prior result, no theorem is improved
and no old mathematical obligation is newly discharged. The review's value is
the complete, evidence-grounded account of supported results, failed reasoning,
and concrete uncertainty required by `OBJECTIVE.md`. That supports an
exploratory review rating without claiming publishable or doctoral significance.

The installed `argus_skill/core/research_contract.py` was inspected read-only.
Its `RESULT_FIELD_CHOICES` permits `literature_review`, novelty
`not_applicable`, and significance `exploratory`; its
`ACCEPTED_SIGNIFICANCE["exploratory"]` admits `exploratory`, `publishable`,
and `doctoral`, but not `not_applicable`. The `literature_review` branch of
`research_completion_issue` applies that significance bar even when novelty
is not applicable. Thus review-level novelty being inapplicable does not make
review-level significance inapplicable.

Project events `1349` and `1358` record the previous significance rejection
and the otherwise verified correctness and statement fidelity.
Handoff `1993ea0972a1/round-0001.json` independently accepts the complete
review while leaving Host certification separate. On the existing evidence,
the proposed **review-only** assessment is:

    result_class: literature_review
    correctness_status: verified
    novelty_status: not_applicable
    significance_status: exploratory
    statement_fidelity_status: verified

A read-only, in-memory call under
`$WORKSPACE/argus-latest/.venv/bin/python -B` at the current campaign
root confirmed that this proposed tuple, with the index and both reports as
evidence, has no `research_completion_issue` at target `exploratory` and
scope `final_submission`. The same call with significance `not_applicable`
returned `survey_significance_below_exploratory:not_applicable`.
This checks vocabulary and gate admissibility, not the truth of the rating,
independent acceptance, or other certification requirements; the bounded-scope
exemption was not used.

The Host-invoked native Reviewer must independently judge this rationale and
supply its own supported assessment. This bounded amendment adds only that
rationale; it does not revise any previous independent judgment or certify the
project. Old-result `C_GROWING_DIVISOR_NOVELTY` v1 remains unresolved, and the
old growing-order verdict's novelty and significance remain `unestablished`.
In particular, this recommendation establishes neither `verified_new` nor
publishable significance for the paired theorem, nor that it is already known.

## Accepted substantive handoffs and their limits

The following native Reviewer records are read-only, under
`$WORKSPACE/.argus-campaign-9200025/projects/15cc55241db3/handoffs/`:

| Accepted handoff | What its `review.status: done` and reason establish |
|---|---|
| `5429fa9a7873/round-0001.json` | All 77 artifacts and 14 claim versions are accounted for in two consistent assessments; fixed-order thresholds, the simultaneous `1/200000` upper bound, and the informal obstruction for each fixed `C>1/2` are distinguished correctly. Novelty is explicitly unresolved. It treats the unassigned proof graph as non-blocking for that bounded review. |
| `11ac2d145543/round-0001.json` | The Reviewer accepts the substantive project-level review against `OBJECTIVE.md` and the persisted exploratory target, preserving both-unit coverage, mathematical scope, old inputs, and unresolved novelty. Its reason says "I certify final project completion." |
| `9233dae0850a/round-0001.json` | The Reviewer independently accepts the existing-work review classification while preserving the mathematical claims and concrete growing-order novelty obligation. Its reason expressly limits acceptance to the bounded correction, not project certification. |
| `65b340fab33d/round-0001.json` | The Reviewer explicitly accepts completion of the entire `OBJECTIVE.md` and persisted exploratory target, covering all 77 artifacts and 14 claim versions with faithful assessments and honest limitations. This whole-objective acceptance did not itself obtain Host certification. |
| `4593b6136ccc/round-0001.json` | The Reviewer independently accepts recoverable archival of exactly six obsolete certificate-bound judgments, with all 16 current ledger claim versions and eight accepted report-bound judgments preserved. The campaign-local math-state check exits zero. This clears the admission prerequisite, not project completion. |

These are independent substantive decisions, not Engineer verdicts.
The second record's certification prose does not by itself establish
Host-recognized completion or settle the subsequent classification hold.
The third record supplies independent acceptance of the classification
correction, but explicitly does not certify the whole project. The fourth
accepts the whole objective; the fifth accepts the subsequent repair of the
specific obsolete-binding admission failure. Neither records final Host
certification after that repair. The current request is a whole-objective
decision and final certification using all five records and the substantive
review artifacts together. The index and unit verdicts'
pending-acceptance fields describe their Engineer-era submissions; later
acceptance is evidenced by these handoffs, not by rewriting those fields or
independent judgments.

## What was reviewed and what was not duplicated

The fixed-order unit accounts for the natural-order theorem, the compatibility
port, and the real-order/shift/floor bridge. It distinguishes nine incorporated
upstream modules from 19 reference-only upstream modules. There are 28 upstream
files in the manifest, not 27. The reference-only files are original upstream
library context, not additional Argus manuscripts or claims to have certified
the Egyptian-fraction main theorem.

The growing-order unit also accounts for the explicit infinite series bound,
the paired threshold conclusion, the limited literature comparison, and the
explicitly unresolved novelty/significance claim. It reuses the same finite
arithmetic infrastructure, not an independent copy of the fixed-order result.
The new source is an exact reconstruction from its historical preparation
recipe. No genuinely distinct third Argus mathematical draft was found.

The three empty lock files are explained nonmathematical exclusions.
Licensing, preparation scripts, compiler logs, source and port receipts,
historical Jacobian contracts/payloads/results, campaign-check receipts,
and the original-manuscript reference directory are supporting evidence
or provenance, not additional theorems.

The preserved snapshot is partial: all **17** family entries match the
assigned old workspace exactly. The other **60** listed files are absent
from that snapshot, not mismatches. All 77 listed byte counts match.
The original-manuscript manifest's ten TeX sources match both the old
reference copy and the manifest's source directory at revision
`4eaee87548250b2682affda7d05d947c05554bae`.

## Mathematical conclusions

For `d_X(n)` counting positive divisors at most `X`, the manuscript-facing
fixed-order claim is supported for real `D,r>=1`, real `X>0,Y`, and natural
`N`, with

    S/(2 log(S)) <= log(X) <= D*S,
    sqrt(X) <= Y <= X,
    N <= exp(D*S).

For sufficiently large `S` depending on `D,r`, its shifted real moment is
at most `Y exp(S^(1/4))`. The real-order bridge is not a theorem about an
`S`-dependent range of orders.

The growing-order upper proof genuinely strengthens the quantifier order:
one `S0(D)>e` works for every
`1<=r<=log(S)/(200000 log(log(S)))`. It bounds the finite inequality's
order-dependent premises before choosing the natural ceiling of `r`.
The series estimate is valid for every natural order, including zero.
Its proof and the upper theorem are formal; compilation and statement
fidelity are separately assessed.

For every fixed `C>1/2`, the dyadic primorial family in the growing report
is admissible and eventually violates the moment bound at
`r=C log(S)/log(log(S))`. The argument proves its prime estimates,
small-divisor count, and limiting strict inequality elementarily.
It is a supported **informal infinite-family proof**, not a Lean theorem
or an extrapolation from finite witnesses.

The conjunction identifies the growth order up to constants. It does not
give the optimal constant, the endpoint `C=1/2`, or a counterexample to
the original fixed-order manuscript statement. The finite witnesses at
`S=32` and `S=512` do not refute an unspecified eventual fixed-order
threshold.

The actual failed route is `R_GROW_FIXED_SUBSTITUTION`: exchanging
`forall fixed r exists S0(D,r)` with a single threshold for a growing
range is invalid without control of the threshold's dependence.
The other retired routes are source/version bookkeeping, with some
inaccurate source-free wording even where their stored hash is current.
The index preserves exact references rather than treating stale labels
as mathematical refutations.

## Evidence and remaining mathematical uncertainty

The evidence described here was gathered for the existing unit assessments.
This final submission reuses it without regenerating evidence, repeating
mathematical replays, or claiming a fresh compilation.

Both source-bearing historical Lean certificates match their current old
source and fidelity text, recorded hashes, and exact claim hashes. They
record Lean 4.31.0 with the host's built Mathlib workspace, successful
compilation and proof-hole audits, and only the standard foundational
axioms `propext`, `Classical.choice`, and `Quot.sound`.
No fresh compilation is claimed, and no new `.lean` file was created.
Historical independent judgments are identified separately from Engineer
opinions. Path-only prose judgments are not falsely presented as originally
source-hashed certificates.

The relevant scripts were inspected before execution. Write-producing
historical entry points were not run. The fixed-order finite replay
passed its shift, product, exponent-ceiling, gcd-witness, multiples, and
divisor-count checks. The growing-order `--finite-only` replay exactly
matches its old certificate, including 65 exact series values and both
finite witnesses. A fresh inspected Jacobian divisor enumeration at
`30030` returned `COMPLETE` and matched all 64 positive divisors, 28
below the truncation at 128; it certifies no infinite statement.

The two independently attributed Nair--Tenenbaum/Henriot passages retain
the parameter dependencies described by the old comparison. The additional
Luca--Toth v2 and de la Breteche--Tenenbaum v1 statements were read directly
from their versioned primary PDFs. None directly supplies the target
simultaneous growing-order/full-shift theorem in its displayed form.
This is a bounded comparison, not a proof that their methods cannot do so.

**Novelty and publishable significance of the old growing-order results remain
unestablished.** `C_GROWING_DIVISOR_NOVELTY` v1 remains unresolved. The concrete
missing obligation is a checked comparison of the exact paired theorem
(the simultaneous upper range with constant `1/200000` and the eventual
primorial obstruction for every fixed `C>1/2`) against possible prior
quantitative results and their consequences, together with a justified
priority/significance assessment. That comparison must track growth-class,
interval-length, and coefficient constants as the order grows and the allowed
intervals become short relative to the shift. The growing-order assessment
identifies the required growing class parameter `2^r` and the possible decay
of `log(Y)/log(N)` like `1/(4D log(S))`; its four-source displayed-theorem
comparison does not rule out stronger parameter-tracked consequences.
There is no missing arithmetic step being concealed as a tool failure,
and no claim that the original manuscript is false. Completing an honest
review of this gap is not completing the missing novelty argument.

Compared with the strongest historically reviewed result, this review makes
no mathematical improvement: it delivers complete source/version coverage,
reuses matching reviewed evidence, and calibrates the conclusions.

## Current-project validation and handoff boundary

The current campaign root is exactly
`campaigns/9200025`.
The existing coverage/input checker is

    $WORKSPACE/argus-latest/.venv/bin/python -B research/draft_reviews/verify_review.py

It verifies exhaustive artifact and claim-version mappings, the partial
snapshot and manuscript sources, exact archived formal bindings, unchanged
old input fingerprints, and the presence of both assessments and this summary.
Its prior coverage outcome is supported by the accepted handoffs above; the
unchanged input checks and mathematical replays were not rerun for this
final submission.

The independently accepted repair in `4593b6136ccc/round-0001.json` and its
`CHECKPOINT.md` records both official checks under
`$WORKSPACE/argus-latest/.venv/bin/python`, against that exact
campaign root:

| Check | Accepted repair's recorded outcome |
|---|---|
| `argus_skill.verticals.math.math_state check` | Exit **0**, `ok: true`, no issues |
| `argus_skill.verticals.math.proof_graph_check check` | Exit **2**, `research/PROOF_GRAPH.json` absent; not a passing graph check |

The earlier whole-objective submission had recorded six
`judgement_certificate_retired` findings and math-state exit **1**.
That is the pre-repair result, not the current accepted result. Exactly those
six obsolete bindings were recoverably archived in
`research/retired_judgements/obsolete_certificate_bindings.json`.
The accepted repair preserves all 16 current ledger claim versions, all
26 retained evidence records, and all eight accepted report-bound judgments.
No new mathematical conclusion follows from this bookkeeping repair.

The proof graph remains absent. The exploratory old-draft review was not
assigned that file, and prior independent acceptances did not identify its
absence as a material mathematical review gap. Neither those decisions nor
this amendment supplies a passing project-level structural check.

Both zero exit statuses have **not** been obtained. This submission updates
only the aggregate's account of the accepted decisions and validation, and
the current mission's `CHECKPOINT.md`. The ledger, old drafts, independent
judgments, coverage index, unit reports, verdicts, and completion flags are
unchanged. Because their check dependencies have not changed, the accepted
repair's validation is reused, not rerun or represented as a fresh check.
No graph, alternative root, substituted output, or invented zero status is
used to claim certification.

## Whole-objective decision requested

The native independent Reviewer is asked to assess this summary together with
`research/DRAFT_REVIEW_INDEX.json`, both
`research/draft_reviews/{fixed_order,growing_order}/report.md` and
`verdict.json` pairs, and all five accepted handoffs above, particularly the
whole-objective acceptance and independently accepted repair. The decision must
explicitly address the entire `OBJECTIVE.md` and persisted exploratory
target: all 77 artifacts and 14 claim versions, faithful statements,
justified arguments, exhaustive coverage, and honest limitations.

The accepted review-level classification does not settle old-result novelty
or erase the reported structural failures. If final completion is withheld,
the decision should identify the precise unmet objective requirement and any
remaining certification gate, including whether the absent proof graph is
required for this exploratory old-draft review, rather than accept only the
already accepted classification or binding correction again. Engineer requests
the native whole-objective decision and Manager/Host final certification after
the accepted repair; neither is supplied by this amendment.
