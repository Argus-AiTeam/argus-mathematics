# Family 056: review of the old Argus drafts

**The 29 inventoried artifacts and the reference-input/tooling entry are
mapped into 14 assessed units. Native whole-family acceptance is pending.**
This is an exploratory, staged old-draft review, not a new manuscript-error
search, new theorem, or self-accepted mathematical result. The
[coverage index](DRAFT_REVIEW_INDEX.json) records every artifact, all
17 old claim records, sources, dependencies, duplicates and exclusions.

The curve argument is supported as prose **under its explicit analytic
and standard local inputs**. The all-place globalization argument retains
the pi1-surjective core and specified principalizing SNC resolution; the
non-Kahler strengthening retains global projectivity of that resolution.
The finite verifier passed, but does not certify these geometric arguments.
The appendix's fourfold slicing reconstruction is only partially supplied,
and the downstream branch/junction assertions are conditional on separate
antecedents.

## Final-submission scope and objective map

The submitted result is a **literature review** (`result_class=literature_review`),
with `research_target_level=exploratory` and
`novelty_status=not_applicable`. These describe this review, not the novelty
or truth of any old claim. The unit verdicts retain their individual
attributions, supported scopes and open obligations. No new mathematics,
whole-paper certification or Lean certification is submitted.

The sealed native
[round-0002 verdict]($WORKSPACE/.argus-campaign-9200056/projects/c77b2f6845af/handoffs/3d38d0ea1ecb/round-0002.json)
accepted the bounded review after correction of the unsupported (P4)
criticism. It explicitly confirmed coverage of 29 artifacts, the reference
entry and 14 units, while stating: "The bounded review is accepted, not
every old theorem." That verdict and the existing replay/source evidence
are reused, not rebuilt or relabeled as final certification.

| Requirement in OBJECTIVE.md | Evidence submitted for whole-objective review |
|---|---|
| Review every inventoried substantive draft; map claims, proofs, checkers, supporting files, dependencies, duplicates and exclusions | [Index](DRAFT_REVIEW_INDEX.json): `units`, `artifacts`, `old_assumptions`, `old_routes`, `historical_evidence`, `reference_inputs_and_tooling`, and `duplicates_and_exclusions`; [provenance assessment](draft_reviews/reference-provenance/report.md) accounts for all 17 old claim records |
| Supply an assessment and verdict for every unit, with exact claims, hypotheses, source/version, attribution and decisive reasoning | All **14 report/verdict pairs** linked in the next table; each index unit identifies its claims, proof locator, support and dependencies |
| Distinguish supported scope, partial reconstruction, invalid arguments and concrete unresolved obligations without starting a new research project | [Terminal appendix](draft_reviews/terminal-appendix/report.md) identifies the slicing gap; the curve/globalization/extension assessments retain explicit inputs; the two shortcut assessments refute only the Argus inferences; the branch assessment retains its separate antecedents |
| Replay relevant computations where possible; distinguish local certificates, geometry, compilation and statement fidelity; state actual tools and external inputs | [Finite-checker assessment](draft_reviews/finite-checker/report.md), [verdict](draft_reviews/finite-checker/verdict.json), [runtime](draft_reviews/finite-checker/runtime.json), and preserved typed adapter files; the index and unit reports identify source assumptions and the absence of inventoried Lean evidence |
| Separate reproductions, proposed strengthenings, failed attacks, attribution and novelty; assert no new mathematics in the final review result | Index attribution fields and every unit's `verdict.json`; the review-level novelty is `not_applicable`, not a claim that the old results are new or that the original manuscripts have been refuted |
| Summarize every unit, preserve the old workspace/snapshot read-only, and obtain native independent acceptance of the entire objective | This summary's 14-unit table and provenance boundary, the unchanged accepted evidence, and this `final_submission` handoff; **final certification remains for the Host-invoked independent Reviewer to decide and persist** |

## Every unit and its disposition

| Unit | Assessment and supported scope | Files |
|---|---|---|
| link-map | Supported analytic quotient W->V via the canonical IC comparison in degree -2; no global splitting or finite monodromy inferred | [report](draft_reviews/link-map/report.md), [verdict](draft_reviews/link-map/verdict.json) |
| finite-monodromy | Supported with explicit projective-family algebraization, whole scheme fibers, countable fixed-polynomial Quot loci, finite multisections and path transport; prior parameter argument identified | [report](draft_reviews/finite-monodromy/report.md), [verdict](draft_reviews/finite-monodromy/verdict.json) |
| full-compact-model | Supported full-Kprime construction and fixed Cartier multiples before restriction; the supporting Fujino note correctly states (P4) for connected components of W intersect Z | [report](draft_reviews/full-compact-model/report.md), [verdict](draft_reviews/full-compact-model/verdict.json) |
| degree-injection | Supported conditional degree-kernel argument using all fiber curves and every normalized-cover sheet; the example matrix alone is insufficient | [report](draft_reviews/degree-injection/report.md), [verdict](draft_reviews/degree-injection/verdict.json) |
| globalization | Supported all-place bijection on a pi1-surjective core; all log-discrepancy-two places lie on the fixed resolution. Surface extraction also uses terminal codimension-two smoothness | [report](draft_reviews/globalization/report.md), [verdict](draft_reviews/globalization/verdict.json) |
| curve-bound | Supported conditional reproduction of b<=s<=N_T for compact Kahler Y and distinct global primes, not a new bound or termination proof | [report](draft_reviews/curve-bound/report.md), [verdict](draft_reviews/curve-bound/verdict.json) |
| complex-extension | Supported conditional hypothesis audit for the curve bound and bijection without ambient Kahlerness; specified g remains globally projective. No branch-Hodge or termination extension | [report](draft_reviews/complex-extension/report.md), [verdict](draft_reviews/complex-extension/verdict.json) |
| branch-impact | Supported conditional summation and implication. The c_2 terms are surface-cycle ranks, not Chern numbers; topology, bracket/weight and later program antecedents are not independently certified | [report](draft_reviews/branch-impact/report.md), [verdict](draft_reviews/branch-impact/verdict.json) |
| sharpness-example | Supported global projective quadric-cone product with every resolution hypothesis checked and b=N_T=1; bundle/link topology is prose, chart/rank arithmetic replayed | [report](draft_reviews/sharpness-example/report.md), [verdict](draft_reviews/sharpness-example/verdict.json) |
| terminal-appendix | Partial as a self-contained reconstruction: surface minimality and discrepancy formulas supported; adapted transverse slicing, normality and no added exceptional multiplicities need justification or an explicit standard-theorem assumption | [report](draft_reviews/terminal-appendix/report.md), [verdict](draft_reviews/terminal-appendix/verdict.json) |
| disc-shortcut | Invalid Argus shortcut, exactly controlled by a two-sheet cover losing transitivity on a disc; not a realized fourfold counterexample | [report](draft_reviews/disc-shortcut/report.md), [verdict](draft_reviews/disc-shortcut/verdict.json) |
| infinite-invariants-shortcut | Invalid Argus shortcut: a surjective unipotent quotient has invariant-lift image zero. Prove finite monodromy before averaging; no geometric refutation | [report](draft_reviews/infinite-invariants-shortcut/report.md), [verdict](draft_reviews/infinite-invariants-shortcut/verdict.json) |
| finite-checker | Successful exact bounded replay, not geometric/kernel verification; exact live adapter payload, typed result and status separately preserved | [report](draft_reviews/finite-checker/report.md), [verdict](draft_reviews/finite-checker/verdict.json) |
| reference-provenance | All claim versions, old opinions/routes, metadata, source copies and five staged manuscript inputs disposed of; old campaign objective and whole-paper certification excluded | [report](draft_reviews/reference-provenance/report.md), [verdict](draft_reviews/reference-provenance/verdict.json) |

## Decisive mathematical distinctions

The log discrepancy is a; the coefficient on the resolution is a-1.
Terminality makes that coefficient positive. A hypothetical new exceptional
place above the smooth resolution has log discrepancy at least two, plus
a positive term forced by the **full principalized singular preimage**.
It therefore cannot have log discrepancy two. Representation on the
specified global g is what makes finiteness possible. Retaining all curve
loops then prevents one global prime from being counted as several local
branches. Neither dropping loops nor a finite permutation sweep replaces
that argument.

The monodromy proof genuinely needs the projective scheme family and
actual universal line bundles. GAGA does not algebraize arbitrary proper
analytic families, and unrestricted Quot is not one finite-type space.
The revised SGA1 edition and Bourbaki erratum were checked at their exact
versions. The invariant-lift step is justified only after finite monodromy.

Fujino's condition (P4) requires finitely many connected components of
W intersect Z for every analytic Z defined near W. The preserved source
note states that condition correctly, and the construction's semianalytic
Stein Kprime satisfies it. Q-factoriality is used over the **entire**
compact, and a common Cartier multiple is fixed before a smaller-core
restriction.

Appendix A correctly reduces a positive relative canonical divisor on a
minimal surface resolution to an impossible exceptional (-1)-curve.
Its fourfold reduction still needs an adapted analytic slicing/adjunction
statement ensuring normality, a smooth restricted resolution and no
extra exceptional multiplicities from the cuts. The standard
terminal-codimension-two theorem is retained as an explicit external
input, not declared false or silently proved by the appendix.

## Replay and source evidence

The original verifier and its original sibling inputs were run unchanged
under `$WORKSPACE/argus-latest/.venv/bin/python`, Python 3.13.5,
with active assertions and bytecode writes disabled. It exited **0** in
**0.3054997632279992 seconds**: four sharpness charts, **617** ordered
permutation-generator pairs on one through four sheets, one S3
invariant-lift example, **624** bounded rational sign cases, both controls,
and independent row reduction of the saved Gysin-column result.
The exact command/output is in
[runtime.json](draft_reviews/finite-checker/runtime.json).
No Lean source or compiler evidence is inventoried or claimed.

After discovery and typed-contract inspection, one separate live Jacobian
adapter call computed only the rank of the same 2-by-1 QQ column.
It returned rank **1**, pivot **[0]**, server **0.14.0**, protocol
**2025-11-25**, exit **0**, error **null**, timeout **false**.
The [payload](draft_reviews/finite-checker/jacobian_payload.json),
[typed envelope](draft_reviews/finite-checker/jacobian_output.json) and
runtime/status are preserved separately from the human-readable proof.
Client wall time was 3.2545889681205153 seconds; server runtime was 1 ms.
This is not a geometry result or a performance claim.

Engineer source readers checked the exact primary passages for Saito
1988, Fujino arXiv v1, Forstneric 2005, Raynaud's revised SGA1 arXiv v2,
Bourbaki 221 and its 1962 erratum, using all nine scan companions as
duplicate representations/OCR disambiguation. Reports identify the
passages and hypotheses. Their readings are not falsely relabeled as
official citation-attribution certificates or native Reviewer acceptance.
The original Grauert source and individually sourced background topology
remain source-only inputs. No source archive or manifest was rebuilt.

## Coverage relative to the strongest prior result

The old ledger had 17 claim records and 22 support opinions: eight by its
Engineer and fourteen under a separately named historical reviewer/reader.
The old graph remained open. The old work already supplied the bound's
prose argument, proposed bijection/non-Kahler extension, sharp example and
finite certificate. This review does **not** improve its numerical bound.
It improves the assessment by covering the non-node results and every
version, checking source scope and original attribution, identifying the
slicing obligation, and separating measured finite evidence from geometry.

All 29 files exist with inventory-matching sizes. Only five are enumerated
in the supplied snapshot manifest; the other 24 are reviewed from the
read-only old workspace, not omitted. Size agreement is not a fresh
content-identity certificate. The five staged manuscript directories are
reference inputs with explicit bounded dispositions, not five additional
Argus draft results or a mandate to audit new targets. The old workspace,
snapshot, ledgers and reference inputs were not modified.

## Final certification boundary

The current review ledger records explicit assumptions and two reasoned
shortcut retirements without inheriting the old campaign objective.
The accepted review's campaign-local checks and coverage results are preserved in
[the provenance verdict](draft_reviews/reference-provenance/verdict.json).

Fresh campaign-local checks again returned **0** for the claim ledger
and **2** for the standalone proof-graph checker, which reports no
`research/PROOF_GRAPH.json`. No two-zero-status result is claimed.
The supported native review-stage policy resolves the current objective
as **exploratory**, with profile `certify` and `graph_required_for=false`;
it does not require a targeted proof graph for this review. A historical
graph, alternate root or fabricated graph has not been substituted.

The native review-stage gate nevertheless reports **16 unchecked citation
uses across seven cited propositions** in RV_BOUND, RV_COMPACT, RV_LINK,
RV_MONODROMY and RV_TERMINAL. The existing source readings and bounded
acceptance do not constitute independent citation-attribution records.
Those records remain necessary before final delivery; the Engineer has
not manufactured them, removed the citations or self-accepted the mission.
The cross-round checkpoint identifies the exact claim/assumption pairs,
check outcomes and the Host's existing missing-certification diagnostic.

The native Host-invoked independent Reviewer must examine the index and
**all 14 unit assessments** to decide whole-family completion. An unresolved
mathematical antecedent with an exact conditional disposition is part of
this review; it is not permission to start a new error search or to claim
the original papers correct. A further bounded-cycle acceptance, this
submission, and the Engineer's handoff are not substitutes for persisted
whole-objective final certification.
