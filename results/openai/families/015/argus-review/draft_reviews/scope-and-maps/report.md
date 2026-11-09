# Scope, manuscript maps and supporting records

**Engineer assessment: the inventory and the restricted scope are
supported; this review claims no new mathematical contribution.** This
unit is not a fourth mathematical theorem. It accounts
for the open source maps, historical claim versions, citations, tooling and
exclusions that would otherwise make a local assessment look like family
completion. The prior assessments have native review support; acceptance
of this revised classification and persisted final project certification
are not claimed.

## Review deliverable and inherited mathematical novelty

`OBJECTIVE.md` defines the task as a "review of existing Argus work, not a
new manuscript-error search." It requires separating "original contributions,
reproductions, failed attacks and proposed strengthenings" and says "Do not
claim novelty without checking it." The deliverable is therefore the complete
coverage index and per-draft evidence assessments, not a newly authored
theorem, construction or improved bound. No mathematical originality is
claimed for the review itself; this is not a `verified_new` classification.

The inherited mathematics must nevertheless retain its own provenance and
unverified novelty. The unchanged substantive reports and verdicts distinguish
the following, rather than treating either all old results or the review as
new discoveries:

| Inherited result | Classification supported by its assessment | Originality limit |
|---|---|---|
| Theorem A, `local-shell` | Reproduction of the specified OpenAI manuscript lemma. | Reproduction is not a newly discovered theorem or manuscript error. |
| Theorem B, `local-shell` | Old Argus proposed strengthening of support and odd-prime bounds. | The quantitative comparison is supported; publication novelty remains unverified. |
| Theorem C, `sharpness-family` | Old Argus explicit construction and local support-optimality result. | Its stated local conclusion is supported; publication novelty remains unverified. |
| Section 7, `denominator-profile` | Old Argus dependent corollary and proposed improvement of two profile inequalities. | The two improvements are supported; publication novelty and global optimality remain unverified. |

The old proof source is `9000015/research/quartic_shell/theorem.md`; its
Argus attribution remains `engineer:copilot`, and the comparison manuscript
remains attributed to OpenAI. Exact claims, hypotheses, source revision and
limits remain in the three substantive assessment pairs. Relative to the
strongest old submission, this review adds no bound, construction or corollary.
Its contribution is the review and classification of those existing arguments.

The accepted native bounded handoff at
`$WORKSPACE/.argus-campaign-9200015/projects/c6494b7c7ffe/handoffs/67cf4b5b17b2/round-0001.json`
supports coverage of thirteen artifacts and thirty-five claim versions,
Theorems A-C, and exactly the two Section 7 inequalities. The accepted
final-submission review at
`$WORKSPACE/.argus-campaign-9200015/projects/c6494b7c7ffe/handoffs/bfd5c591c9f9/round-0001.json`
also supports those scope-qualified assessments under `OBJECTIVE.md`.
Neither decision establishes the inherited results' originality, and a
reviewed-handoff status is not itself persisted final project certification.
Neither is acceptance of the present revision.

This distinction does not relax the original acceptance boundary. Every
listed artifact and claim version still needs a disposition; decisive
arguments and relevant replay must be assessed; attribution, concrete gaps,
finite-versus-unbounded evidence and uncertified downstream obligations must
remain explicit. No unverified proposed strengthening is relabelled as a
verified original contribution. The native Host-invoked independent Reviewer
must examine this substantive classification correction before recertification.

## What actually constitutes a draft

`PRIOR_DRAFTS.json` lists thirteen artifacts. There is one substantive
proof source, `theorem.md`, containing three nonduplicative mathematical
units: the common A-B shell argument, the C sharpness construction, and
the Section 7 profile corollary. Each has a report and verdict. Section 8
and `verify.py` supply bounded support; they are not another all-depth
proof. `QS_CERT@1,2` packages the results rather than adding one.

The index accounts for all 27 old claim ids and 35 versions:
the historical goal, nineteen one-version manuscript maps, four
`QS_KNOWN` versions, two versions each of decay/support/boundary/sharpness,
one profile version, and two aggregate-certificate versions.
The early local proof requests become declarative in v2 without a new
bound. Sharpness v2 genuinely extends v1's zero third coordinate to any
integral coordinate. The aggregate v2 adds the profile result.
Only the current theorem text is preserved here; earlier ledger statements
are assessed as statements or special cases, not as reconstructed older
proof files.

The old `MATH_STATE.json` has fifteen judgement records: seven Engineer
and seven old Reviewer opinions on the current mathematical claims,
and one old Reviewer opinion on the ELMV assumption. Fourteen point to
the same proof text. They are not fourteen independent arguments and are
not kernel certificates. The old graph labels all its nodes open and
`reviewer_confirmed=false`, despite its route being called current.
Neither representation substitutes for this mission's native Reviewer.

Four ledger routes are indexed. `QS_R_UNIFORM` was retired because the
aggregate was strengthened to include the profile corollary, not because
its mathematics failed. Its stored goal reference actually resolves to
`QS_CERT@2`, while its retirement explanation calls it a version-1 plan;
the index records that historical bookkeeping detail without rewriting it.
`QS_R_LITERAL` still points to the v1 proof obligations;
`QS_R_PROFILE` and `QS_R_UNIFORM_V2` use the later local claims.
The separate graph route is `QS_UNIFORM_PROOF_AND_SHARP_CONDUCTOR`.
No route label proves its goal.

## Every manuscript-map disposition

The following are source-obligation maps, not nineteen completed Argus
drafts. Exact proposition labels, individual obligations and the
dependency edges are in the index.

| Old map(s), each v1 | Disposition and still-unestablished scope |
|---|---|
| `MAP_PRIME_PACKET` | No Argus proof of full-local-type packet unfolding. |
| `MAP_PRIME_LOCAL` | No Argus proof of the arbitrary-module shell mass and norm moment. |
| `MAP_PRIME_COUNT` | No Argus proof of residue-normalized weighted counts, exceptional-zero descent or uniform intervals. |
| `MAP_PRIME_GEOMETRY` | No Argus proof of tightness or the local ball estimate and their analytic inputs. |
| `MAP_PRIME_MAIN` | No Argus proof of componentwise entropy, rigidity and prime-degree Haar convergence. |
| `MAP_QUARTIC_ORDINARY` | No Argus proof of the ordinary packet/count/tightness/ball package. |
| `MAP_QUARTIC_STRUCTURE` | The local interface at `lem:ext-quadratic-structure` was compared directly; the full global products/order-scale/density package is not certified. |
| `MAP_QUARTIC_SHELL` | Exactly the submitted local reproduction, assessed in `local-shell`; do not count it again. |
| `MAP_QUARTIC_PROFILES` | The two norm/support inequalities are strengthened by Section 7. The finite expansion, cutoff and profile-count assertions are not separately certified. |
| `MAP_QUARTIC_ADDITIVE` | No Argus proof of full nonscalar Poisson estimates and trace-plane distribution. |
| `MAP_QUARTIC_EXTERIOR` | No Argus proof of sieve averaging or the exterior-count conclusion. |
| `MAP_QUARTIC_RIGIDITY` | No Argus proof of classification and exclusion of proper positive-entropy limits. |
| `MAP_QUARTIC_MAIN` | No Argus proof of the full quartic equidistribution theorem. |
| `MAP_SEXTIC_ARITHMETIC` | No Argus proof of the packet/cusp/ball/Bowen/trace-slice package. |
| `MAP_SEXTIC_PLAQUES` | No Argus proof of the intermediate-resolution construction, sampling or motion comparison. |
| `MAP_SEXTIC_PRODUCT` | No Argus proof of the product rule for those intermediate-resolution limits. |
| `MAP_SEXTIC_ACTIVITY` | No Argus proof of crossing-root activity from the product and arithmetic inputs. |
| `MAP_SEXTIC_FULL_ACTIVITY` | No Argus proof of almost-sure full activity and the root-array/convolution obligations. |
| `MAP_SEXTIC_MAIN` | No Argus proof of exclusion of proper components and sextic Haar convergence. |

These are not discovered counterexamples, nor findings that the original
manuscripts are correct or incorrect. Sources were accessible. The reason
for the exclusions is that no corresponding substantive Argus proof was
submitted, and a fresh audit of these papers is explicitly outside
`OBJECTIVE.md`. In particular, a local certificate cannot silently discharge
the downstream nodes of any of these maps.

## Identity and attribution

The existing preserved manifest contains five of the thirteen old paths:
ledger, graph, theorem, checker and exact certificate. All five existing
size/hash pairs match. The lock, five Jacobian JSONs and two literature
texts are not listed in that manifest; only their supplied byte counts
were confirmed. All thirteen match the `PRIOR_DRAFTS` sizes. The absence
of a manifest entry is not called a hash match.

The existing manuscript reference manifest names source revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its seven prime, eleven
quartic and eleven sextic TeX entries all match both the reference source
directories and the exact old `research/openai_manuscript` paths.
No missing source was reconstructed, no manifest was rebuilt, and no
Git command was used. This confirms these source identities, not the
correctness of the three manuscripts. The quartic manuscript's `main.tex`
explicitly attributes it to OpenAI. The local strengthening and construction
are old Argus submissions attributed in the ledger to `engineer:copilot`,
not results newly authored by this review.

`QS_KNOWN@1-4` repeats one scope statement. Version 2 adds
`ELMV_LOCAL_PRIOR`, version 3 also adds `WEIL_SOURCE_LIMIT`, and
version 4 also adds `FINITE_SEARCH_LIMIT`. These are attribution and
limitations, not assumptions used to prove Theorems A-C or Section 7.

The ELMV reference is Einsiedler--Lindenstrauss--Michel--Venkatesh,
*Distribution of periodic torus orbits and Duke's theorem for cubic
fields*, Annals 173 (2011), 815-885,
DOI `10.4007/annals.2011.173.2.5`, Proposition 9.9, equations (36)-(37),
pp. 853-854. The actual statement was read in the supplied primary-paper
text, lines **1807-1839**. It assumes a unitary multiplicative character
of `A^times` and a Schwartz function on `k^n`. Its normalized integral
has weight `|x|_A^(1/2)` and multiplicative Haar measure. Its two bounds
involve the local discriminants, distinct displayed normalizations of
`C_V`, and constants with the base-field-degree dependence noted there.
It is not the additive shell-support theorem about the quadratic map
from a rank-two module.

There are two precise supporting-record cautions. The old ledger's prose
pointer to text lines 1729-1785 does **not** reach Proposition 9.9 in the
current supplied text; it reaches preceding material. The canonical
proposition/page locator is nevertheless correct. Also the short
`ELMV2011_prop9_9.txt` is an ASCII transcription and scope note, not a
verbatim complete statement: it suppresses some constant-normalization
and base-field-degree details. It suffices for the qualitative
multiplicative-versus-additive distinction but must not be used as a
complete quantitative theorem citation. This does not invalidate the
shell proof, which never imports that proposition. The final sentence
of the old extract saying independent attribution is outstanding is
itself historical, not a current instruction or acceptance decision.

The old report of an anti-bot failure for Weil's DOI is also historical;
no present unavailability claim is made. The manuscript cites the
classical reciprocal Gaussian transformation, but the submitted draft
proves the needed identity directly. No unread Weil statement is taken
as an axiom. The old limited negative literature search does not establish
originality and was not upgraded into a novelty certificate here. The
targeted shared-Wiki index searches supplied no relevant additional
mathematical premise.

## Computation, formalization and exclusions

The unchanged default Python checker passed once. Counts, exact command,
receipt, actual stdout and limits are in the local-shell assessment. Its
formula labels such as `improved_bound` and its pending review/novelty fields
are descriptions, not evidence for those descriptions. All its finite
checks remain finite.

The two old discovery records and the spectral operation contract document
tool selection. The finite spectral-pair operation returns an exact
nonorthogonality witness with Ramanujan sum -3, not a counterexample to a
manuscript. The new isolated-adapter replay preserves its full typed input
and output, server 0.14.0, protocol `2025-11-25`, exit 0, error null and
no timeout. Only that bounded finite operation was executed; no nearby
operation was forced onto a p-adic claim.

There is **no** Lean source or Lean certificate among the listed artifacts.
The mention of an unrelated comparator formalization neither establishes
statement fidelity nor creates a formal proof for these results. No Lean
file was introduced, so no unverified formalization is being submitted.
The empty old lock file is excluded bookkeeping and was left untouched.
No separate failed manuscript attack exists in the listed submissions.

## Active state and validation boundary

The active ledger contains four explicitly prose-level review
claims, not copies of inherited acceptance labels. No external theorem
assumption is imported. Engineer judgements are opinions; they cannot
produce kernel status or native family acceptance. The recorded native
supporting judgements concern the assessed mathematical scopes, not
publication originality or acceptance of this revised classification.

The retained coverage integrity check passed: exact agreement with all thirteen
artifact entries, all thirty-five claim versions, all four ledger routes
and all twenty-seven graph dependency lists; all four assessment pairs
exist. Their original pending-review fields are not a substitute for the
accepted handoffs cited above or for independent review of this revision.
Replay receipts, reported
counts and the exact adapter payload/output are consistent. The active
citation-status command returned `ok=true` with no blocking imported
citations; this is not a novelty or whole-paper correctness check.

Both official checks were run against the exact project root
`campaigns/9200015`, using
`$WORKSPACE/argus-latest/.venv/bin/python`.
The math-state check returned **0**, `ok=true`, no issues. The graph
check returned **2**, reporting no active
`research/PROOF_GRAPH.json`. The old graph is an input in a different
workspace and was not substituted for an active graph.

This mission is a review-stage exploratory old-draft review, and its
authoritative writable-path list does not include an active proof graph.
No graph was fabricated or copied outside that boundary merely to obtain
a zero status. If the machine's two-zero-exit campaign gate is applied
to this review, that missing graph is a real handoff blocker requiring
resolution by an authorized owner; this report does not waive the gate
or claim it passed. It is not a mathematical gap in the reviewed proofs,
nor an access-failure-only substitute for doing the review.

The revised originality classification, mathematical assessments and coverage
are submitted for the native Reviewer to examine against the complete original
objective. Engineer grants no acceptance of the correction or final certification.
