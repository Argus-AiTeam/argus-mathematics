# Family 015: review of the old Argus drafts

**The family-wide submission now explicitly separates the review deliverable
from inherited mathematics: this review claims no new mathematical contribution;
the inherited proposals' novelty remains unverified.** The substantive
classification correction has independent native acceptance; final review
and Host-persisted certification of this corrected complete submission remain
outstanding. The native bounded review at
`$WORKSPACE/.argus-campaign-9200015/projects/c6494b7c7ffe/handoffs/67cf4b5b17b2/round-0001.json`
accepted coverage of all thirteen artifacts and thirty-five claim versions,
direct proof support for Theorems A-C, and exactly the two Section 7 profile
inequalities. Its `review.status=done` is a bounded handoff decision, not
final project certification. The native final-submission review at
`$WORKSPACE/.argus-campaign-9200015/projects/c6494b7c7ffe/handoffs/bfd5c591c9f9/round-0001.json`
also supported the complete scope-qualified review under `OBJECTIVE.md`;
that accepted handoff does not itself establish persisted certification or
inherited originality. The native correction review at
`$WORKSPACE/.argus-campaign-9200015/projects/c6494b7c7ffe/handoffs/8576640c9641/round-0001.json`
accepted the distinction between this review's lack of new mathematical claims
and inherited results whose novelty remains unverified, with coverage,
supported scopes, attribution and unresolved obligations preserved. These
three accepted handoffs are reused, not treated as a final Host certificate.
The supported
mathematical assessments and replay evidence are reused without a new
manuscript-error search or a stronger mathematical conclusion.

## Complete coverage, without duplicate results

`DRAFT_REVIEW_INDEX.json` was written before the assessments. It accounts
for all thirteen `PRIOR_DRAFTS.json` entries, all 27 old claim ids and all
35 versions, both old contexts, four ledger routes, the graph dependencies,
and every proof/checker/supporting dependency. One proof source is divided
into three substantive mathematical units; the scope/map unit is not an
additional theorem. The coverage integrity check passed for the exact
artifact/version sets, route references, graph edges, four assessment pairs,
and consistent replay records. Final submission integrity checking again
matched the exact artifact and claim-version sets: no missing or extra
entries, and all four report/verdict pairs and referenced replay records
are present. The current read-only mapping audit also accounts for all
nineteen manuscript maps, four old routes, 27 graph dependency lists with
31 edges, and 59 resolvable ledger/graph evidence references. Its exact
artifact and claim-version comparisons found no missing, extra or duplicate
entries. The three substantive mathematical assessments remain unchanged;
their historical pending-review wording does not replace the accepted native
handoffs. The scope/map assessment and this summary carry the independently
accepted originality-classification correction; final review concerns the
complete corrected submission, not another bounded assessment.

| Unit | Engineer assessment | Exact conclusion and limit |
|---|---|---|
| [local-shell](draft_reviews/local-shell/report.md) ([verdict](draft_reviews/local-shell/verdict.json)) | Supported | Theorems A-B: literal all-depth shell lemma, sharper odd support `p^(-c)h d^(-1)`, dyadic `2^(-max(c+3,4))h d^(-1)`, odd norm and boundary extension. Not all surrounding geometry or global equidistribution. |
| [sharpness-family](draft_reviews/sharpness-family/report.md) ([verdict](draft_reviews/sharpness-family/verdict.json)) | Supported | Theorem C: exact positive value `(1-1/p)^2 p^(-c)` for every prime `p`, `k>=1` and `c>=2`, also at fully nonzero outputs. Proves odd local exponent sharpness, not dyadic or global optimality. |
| [denominator-profile](draft_reviews/denominator-profile/report.md) ([verdict](draft_reviews/denominator-profile/verdict.json)) | Supported | Section 7: the two profile norm/support bounds improve from `G_0^24` to `G_exp^3<=G_0^3`, including the original boundary convention with explicit constant. Not the full finite expansion or downstream exponents. |
| [scope-and-maps](draft_reviews/scope-and-maps/report.md) ([verdict](draft_reviews/scope-and-maps/verdict.json)) | Scope classification supported | All nineteen manuscript maps, versions, duplicate claims, literature and tool records receive explicit dispositions. No correctness verdict on the three complete manuscripts follows. |

Theorems A and B share the same Gaussian/period/boundary argument, so are
one unit rather than duplicate claimed discoveries. `QS_CERT@1,2` is an
aggregate, not another result. Early local v1 proof requests and v2
assertions have the same quantitative content. Sharpness v2 adds arbitrary
integral third coordinate to v1's zero coordinate; aggregate v2 adds the
Section 7 corollary. This review does not claim to improve on the strongest
old mathematical statement.

## Review deliverable versus inherited contributions

`OBJECTIVE.md` asks for a complete review of existing drafts, not a new
mathematical contribution or manuscript-error search. Its requirements to
separate original contributions, reproductions, failed attacks and proposed
strengthenings, and not to claim unchecked novelty, apply to the inherited
results being assessed. The coverage index, reports and verdicts are the
review deliverable; they are not another theorem or a `verified_new`
mathematical result.

The accepted assessments classify Theorem A as reproduction of the OpenAI
manuscript lemma, Theorem B as an inherited proposed bound strengthening,
Theorem C as an inherited construction and local support-optimality result,
and Section 7 as an inherited dependent corollary and proposed improvement
of exactly two profile inequalities. The old Argus attribution remains
`engineer:copilot`; the comparison manuscript remains attributed to OpenAI.
Support for these proofs and quantitative comparisons does not establish
their publication originality. The three substantive verdicts retain
`novelty_status="unverified"`; no inherited proposal is promoted to a
verified original contribution, and no new result is attributed to this review.

The accepted correction is substantive to what the submission claims, not a
relaxation of acceptance. Coverage of all thirteen
artifacts and thirty-five claim versions, supported mathematical scopes,
attribution, relevant replay, concrete unresolved obligations and honest
novelty limits remain required. No separate failed manuscript attack is added,
and no full-manuscript correctness or downstream equidistribution conclusion
is inferred. The native independent Reviewer must assess the complete corrected review
against `OBJECTIVE.md` before final certification.

The final-scope research result must describe the **review deliverable**,
not substitute an inherited theorem or one unit's verdict for the whole task.
`literature_review` describes this assessment of existing mathematical drafts;
its review-level novelty is `not_applicable`, while inherited contributions'
novelty remains `unverified` in the substantive verdicts and in the result's
limitations. This does not claim that those contributions are known, original,
or formally verified. The native Reviewer must supply its own
`RESEARCH_RESULT=<JSON>` with evidence and limitations for the complete
submission. A schema-compatible classification is not independent acceptance.

## Decisive mathematics

The reciprocal Gaussian identity is justified by stabilization on fixed
compact contributing cosets, differencing and completion of the square.
The inverse-integral bound uses the exponent of the actual lattice quotient.
For odd primes the new period is `p^c h^(-1)`; at 2 the extra powers
ensure both the square-root inequality and an inverse difference in `2C`.
The boundary proof uses at most eight square-class Fourier terms without
assuming independence of the common unit average. These arguments retain
the trace different and self-dual volumes and do not bound conductor depth.

The sharpness construction has its actual claimed multiplier order,
self-dual integral hyperbolic lattice and cyclic quotient. Its kernel is
evaluated by the two surviving valuation shells, not inferred from finite
instances. Choosing the third coordinate 1 keeps every output component
nonzero.

For Section 7, nonzero `z` in a cubic **field**, integral outside `S`,
lies in an explicit fractional ideal `b`. The integer index
`[b:(z)]` gives the norm lower bound, while `Norm(p R_F)=p^3`
explains the new exponent. The dyadic cost is at most `2^12` relative
to `G_exp^3`. Under the original boundary convention the small-prime
cost is `3^3 5^3`, giving total constant **13,824,000**.
The common ideal is independent of `z` because boundary exponents
`h_nu-1` are nonnegative before they are dropped.

No decisive mathematical gap was found in the submitted Theorems A-C or
the precisely stated Section 7 corollary. Publication originality of the
inherited proposed strengthenings and construction is **unverified**, not
a missing claim of mathematical originality by this review. This is a prose
proof assessment, not formal verification.

## Sources, attribution and replay

The existing preserved manifest contains five relevant old entries; all
five size/hash identities match. The other eight listed entries have
matching supplied byte counts but no corresponding preserved-manifest hash.
All 29 manuscript TeX entries match the existing reference manifest both
in the reference directories and at the exact old manuscript paths.
No input, old ledger, snapshot or manifest was modified or rebuilt.
The comparison sources have manifest revision
`4eaee87548250b2682affda7d05d947c05554bae`.

The unchanged default `verify.py` completed with exit **0**, PASS:
8,376 frequency tests, 25,128 period tests, 28 direct finite kernel counts,
seven finite Fourier instances and 48 family instances. The interpreter
was `$WORKSPACE/argus-latest/.venv/bin/python`, Python 3.13.5;
`-B` prevented old-source bytecode writes and `--write-certificate` was
not used. Exact command, durable receipt, actual stdout and replay limits
are recorded in the local-shell assessment. The tests cover a hyperbolic
subclass, not every form, ramification type or depth; the universal
conclusions rely on the reviewed proof.

The isolated Jacobian replay discovered and inspected the exact finite
spectral-pair operation before executing the old six-unit `Z/9Z` example
once. Its retained typed output gives character sum **-3**,
not a p-adic theorem verdict. Server 0.14.0, protocol `2025-11-25`,
adapter exit 0, error null, no timeout. Payloads and outputs are dedicated
JSON files, not substituted for proof notes.

ELMV Proposition 9.9 is a multiplicative local-period antecedent, not a
premise for the submitted shell theorem. Its actual supplied statement was
read. The old ledger's text-line pointer is stale, and the short transcription
omits some constant details; the canonical proposition/page citation supports
the qualitative scope distinction. The draft's own proof removes any
dependence on its historically unread Weil source. No publication novelty
is inferred from the old limited negative search.

There is no listed Lean source or formal certificate. The unrelated comparator
mention and fifteen inherited opinions are not fresh kernel or independent
acceptance evidence. The open prime and sextic maps, and quartic Poisson,
sieve, rigidity and global maps, remain explicitly uncertified. This is
scope-qualified coverage, not an access-failure report and not a blanket
assertion that those sources are correct.

## Active validation and native handoff

The exact checked root is
`campaigns/9200015`,
not the shared batch directory. The active ledger records four review
claims, their Engineer assessments, and supporting native Reviewer
judgements from the accepted reviews; it imports no
external theorem assumptions. These opinions are not kernel evidence or
publication-originality evidence or final project certification.
At this handoff each official check was run once with the
required legacy interpreter
`$WORKSPACE/argus-latest/.venv/bin/python -B`.
No unchanged mathematical replay was repeated. The current results are:

| Check | Exit | Meaning |
|---|---:|---|
| `argus_skill.verticals.math.math_state check --project-root <root>` | 0 | Structurally valid active ledger, no issues. |
| `argus_skill.verticals.math.proof_graph_check check --project-root <root>` | 2 | No active `research/PROOF_GRAPH.json`. |

No two-zero-exit success is claimed. The persisted objective mode is
`exploratory`, separately from the exploratory research target; the installed
`graph_required_for("certify", "exploratory")` returns false. This establishes
the targeted-only graph gate's applicability, not a passing standalone graph
check. The accepted native bounded handoff
explicitly found that the absent active graph did not block its old-draft
review objective. The current final-submission mission likewise prohibits
building optional proof-graph infrastructure: no old graph was copied, no
new one was fabricated, and no checker result or Host-owned record was
altered. If the final Host gate independently requires a passing active
graph, its absence remains an explicit unmet criterion, not an Engineer
waiver.

The installed legacy research-result contract normalized the proposed
review-level classification and reported no final-scope type/completion issue
for `literature_review`, `correctness_status="verified"`,
`novelty_status="not_applicable"`, `significance_status="exploratory"` and
`statement_fidelity_status="not_applicable"`, with evidence and limitations.
That check validates a candidate's contract only: the correctness rating is
for the native Reviewer to decide, and no final decision or Host record was
written by the Engineer.

The native Host-invoked independent Reviewer must now examine
`OBJECTIVE.md`, `DRAFT_REVIEW_INDEX.json`, all four report/verdict pairs,
this summary, the retained replay evidence and all three accepted handoffs
as the **complete original-objective submission**, rather than accepting
another bounded mathematical assessment. Final certification must account
for every listed artifact and claim version and retain the unverified
novelty, finite-replay limits, absence of formal verification, and open
downstream manuscript obligations stated above. This revised scope report,
verdict and summary carry the accepted classification evidence to assess in
the complete submission,
not a replacement for any of those obligations. Only the Host-recorded final
independent decision can close the project.
