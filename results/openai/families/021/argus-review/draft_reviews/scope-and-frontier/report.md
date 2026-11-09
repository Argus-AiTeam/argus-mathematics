# Scope, attribution, and the unproved global frontier

**Engineer assessment: partial support, with a precise scope boundary.**
The old draft supports a conditional verification of the selected inverse
step, not a manuscript counterexample or a verification of the global
Jacobsthal bound. The generic inverse-sieve shortcut is correctly rejected.
The manuscript's other global obligations are not discharged by this draft.
Final acceptance of this retrospective belongs to the native independent
Reviewer.

## Sources and unit boundary

The old root is
`campaigns/9000021`.
The substantive source is `research/inverse_certificate/REPORT.md`, sections
"Scope and source limitations" and "Dependency frontier"; the historical
ledger and graph explain its targets, not additional proofs.

The original reference is *A quadratic bound for Jacobsthal's function*,
September 25, 2026, source revision
`4eaee87548250b2682affda7d05d947c05554bae`, identified by the read-only
`9100021/MANUSCRIPTS.json`. The needed staged statements were read in
`research/openai_manuscript/A-quadratic-bound-for-Jacobsthals-function-September-25-2026/build/sections/`.
This directory is reference input/tooling, not a twenty-third Argus draft.
Only the hypotheses and local arguments needed by the old report were
assessed; this was not a new search for errors elsewhere in the manuscript.

## Complete documentary coverage

The [index](../../DRAFT_REVIEW_INDEX.json) assigns every one of the 22 inventory
paths and the reference-input directory. Nine files are preserved archive
members; thirteen are supplementary live records, including two empty locks.
Read-only size and existing-manifest SHA-256 comparisons found all nine
archive members identical to both the manifest and live counterparts.
The archive and manifest were not rebuilt.

There are 17 historical claim IDs and 21 claim-version records, not 22 results.
`CTX9000021` v1 is the general audit context; `CTX_INVERSE` v1 defines
alignment, squarefree exceptional support, point-specific partial incidence,
and the pre-fixed whole-box list. The mathematical units are:

| Historical claim(s) | Versions | Assessment location |
|---|---|---|
| `C_INVERSE_FINITE` | 1, 2 | [Finite rigidity](../finite-rigidity/report.md) |
| `C_INVERSE_POLYNOMIAL` | 1 | [Polynomial concentration](../polynomial-concentration/report.md) |
| `C_INVERSE_NONLINEAR`, `C_INVERSE_CUBIC` | 1 each | [Nonlinear cubic bound](../nonlinear-cubic/report.md) |
| `C_INVERSE_SAMPLE` | 1, 2, 3 | [Analytic sampling](../analytic-sampling/report.md) |
| `C_INVERSE`, `C_INVERSE_APPLICATION` | 1, 2; 1 | [Inverse application](../inverse-application/report.md) |
| `C_INVERSE_EXTENDED` | 1 | [Structural extension](../structural-extension/report.md) |

The remaining nine IDs, each v1, are accounted for here:

| Claim | What the old draft actually supplies; remaining obligation |
|---|---|
| `C9000021` | An audit objective, not itself a mathematical theorem or a certified flaw. |
| `C_MAIN` | The manuscript's uniform quadratic-bound target. A local inverse proof does not establish it. |
| `C_SURVIVORS` | A dependency target; the full quantitative survivor estimate is not proved in the inverse report. |
| `C_REFERENCE` | A reference-margin obligation, explicitly excluded from the report's conclusion. |
| `C_PRIME_PATHS` | Prime-path occupation, tails, and witness-to-box obligations; no independent verification here. |
| `C_REGULAR` | Regular independent boxes, used conditionally; the global construction is not certified. |
| `C_VARIANCE` | Structured variance and hard endpoints, not established by the finite collision argument. |
| `C_STOPPING` | Stopped comparison and hard endpoints, not established by sampling or algebraic concentration. |
| `C_ASSEMBLY` | Global combination and divisor-prime removal, not established by the inverse implication. |

These are concrete unverified dependencies, not findings that the original
manuscript's statements are false. Their exact historical statements and
version mappings are retained in the index.

The graph's 17 nodes and ledger routes represent decompositions. `R_MAIN`
and `R_SURVIVORS` require the global obligations above. `R_INVERSE`,
`R_INVERSE_STRUCTURAL`, `R_CUBIC_BOUND`, and `R_EXTENDED_STRUCTURAL`
organize the local arguments. `R_AUDIT_INVERSE` and `R_AUDIT_EXTENSION`
point to the report; their existence proves nothing. The retired
`R_GENERIC_INVERSE_SIEVE` has a substantive recorded obstruction, discussed
below. None of these old records was changed.

## The failed shortcut and its actual logical status

The source comparison was checked against Miguel N. Walsh,
[*The algebraicity of ill-distributed sets*](https://arxiv.org/html/1307.0259),
Theorems 1.2 and 1.3, in the primary-source HTML obtained during this review.
Both require an occupancy bound for the **whole set** modulo each prime in
their specified range. Their conclusion is concentration on a nonzero
polynomial, with stated complexity and an allowed exceptional proportion.

The old inverse problem instead supplies only a partial relation: the primes
incident to one point need not be incident to another. It also requires a
bounded rational-intercept list selected before the failure set. Neither
the whole-set hypothesis nor that stronger conclusion follows merely by
renaming the objects in Walsh's statements. This invalidates a proposed
direct invocation of those theorems; it does not refute Walsh, the inverse
proposition, or the original manuscript. Indeed the staged `inverse.tex`
expressly proves the partial-incidence form rather than asserting it is a
direct consequence of Walsh.

The comparison is not an exhaustive literature search or a novelty
certificate. The HTML link is unversioned; no canonical version-specific
Walsh assumption is used to prove any local theorem here. The inherited Wiki
index had no matching Jacobsthal/partial-modular/inverse-sieve/rational-list
entry under the targeted search. Applicable Engineer Skill descriptions
were also absent. Both are bounded retrieval results, not mathematical
obstructions or claims of originality. The old report's inaccurate
secondary venue summary is not relied on.

## Evidence and attribution

The old ledger contains engineer and reviewer-labelled supporting opinions,
plus one mechanical certificate for the finite formalization. These are
historical evidence, not the current Host-invoked family's acceptance.
The report's "review pending" wording and those later ledger opinions must
not be silently turned into either "no historical opinion exists" or
"this family review is already accepted."

`C_INVERSE_FINITE` v1 and v2 have the **same natural statement**: v1 has no
formal statement, whereas v2 attaches the formal source. The mechanical
certificate binds to v2's content reference only. `C_INVERSE` v1/v2 share their natural statement and content
reference, while v2 adds `A_REGULAR_BOXES`. The three sample versions share
their natural statement and content reference; v2 adds `A_SMALL_SIEVE`, v3
also adds `A_PNT_MERTENS`. Evidence sharing a claim-content reference does
not independently verify newly recorded assumptions.

Compiler logs, `lean_check.json`, `compiler_record.json`,
`verification_result.json`, and the archived certificate are overlapping
records of a formal check, not separate mathematical contributions.
`exact_certificate.json` is fixture input with expected results;
`verify.py` is its replay. The archived 23,147-byte certificate is the
mechanical Lean evidence archive, not that fixture output.
The old validation and graph-check summaries certify structural consistency
at their recorded root, not theorem fidelity, novelty, or global correctness.
The old Jacobian records certify only the supplied determinant.

## Active assumptions and delivery limitation

Before substantive assessment, `research/MATH_STATE.json` recorded the review
context, bounded retrieval limitation, failed shortcut, local claims, and
source-only assumptions. They include the regular-box outputs, small-prime
upper sieve, PNT/Mertens, additive large sieve, affine intersection bound,
and real implicit-function/continuation input. Unpublished staged sources
have no invented DOI or arXiv identifier; the uncited source-only status is
intentional and disclosed. Checking their use is not independent
certification of the full regular-box construction or the global theorem.

The exact active root is
`campaigns/9200021`.
The campaign-local ledger check returned 0. The official graph checker
returned **2**, reporting no `research/PROOF_GRAPH.json`; the post-compile
run recorded the same distinction in
[run_status.json](../finite-rigidity/replay/run_status.json).
This mission is an exploratory, scope-stage old-draft retrospective, not a
new independent counterexample route. A new graph is neither required by
the exploratory proof-graph rule nor writable under this mission's four
owned path patterns. No graph was fabricated or copied from the old project.
If the independent-counterexample dual-zero gate is nevertheless imposed
on this retrospective, that administrative gate remains blocked pending
authorized scope/path resolution. No claim is made that both checks passed.

The mathematical assessments below do not depend on resolving that
administrative issue. Native independent review of coverage, fidelity, and
the prose arguments remains required.
