# Scope, attribution and historical review boundary

## Assessment

The inventory contains one coherent dependent-form signed-packing draft, not
eighteen mathematical results. Its counting, moments, matching and geometry
arguments warrant separate assessments. The three manuscripts are reference
inputs, not three additional Argus proofs. Nothing here proves or refutes their
analytic main theorems.

The authoritative coverage is [the index](../../DRAFT_REVIEW_INDEX.json).
All 18 live artifact sizes agree with `PRIOR_DRAFTS.json`. Nine, and only nine,
are members of the preserved `2026-11-06T10:20Z` snapshot manifest. Their live
contents match that manifest's existing SHA-256 bindings. The other nine are
the two empty locks, three compiler logs, three Jacobian files and one source
reading. They are listed inputs but not members of that manifest. The archive
exists; it was not unpacked, rebuilt or modified. Matching manifest bindings
is not a claim that a new archive extraction was performed.

All historical paths below are relative to the read-only workspace
`campaigns/9000076`.
The shared substantive draft is `research/packing-audit/report.md`.
Embedded source, certificates, transcript copies and the Wiki copy of that
report do not add results.

## Exact source statement and attribution

`C_PACK_SCOPE@1` asserts that the three staged manuscripts use the same signed
packing conclusion, with the detailed dependent-form proof in the
lower-envelope manuscript, and that this does not certify their main theorems.
The source-mapping check supports that assertion. The manuscripts name OpenAI
as author; the historical verification/formalization is attributed to the old
Argus Engineer (`engineer:copilot`), not to the manuscripts' authors.

The reference manifest is
`campaigns/9100076/MANUSCRIPTS.json`,
revision `4eaee87548250b2682affda7d05d947c05554bae`. A read-only
source-mapping worker checked the following three packing-source bindings
against it, with no mismatch:

| Reference source | Statement and use |
|---|---|
| `Asymptotically-minimal-maxima-of-real-Littlewood-polynomials-September-23-2026/build/packing.tex`, `lem:signed-packing` (statement around lines 37-48) | Nonzero pairwise nonparallel integer forms, positive widths and `2 sum w_i < 1` give disjoint signed closed arcs of length `w_i/H`. `sampling.tex` uses this for `prop:almost-signs`; `reduction.tex` combines sampling and rounding. |
| `Nearly-minimal-maxima-and-positive-minima-of-Littlewood-polynomials-October-5-2026/build/sections/packing.tex`, statement lines 19-32 and proof lines 70-323 | Same conclusion, with arbitrary `r>=2` and no `r<=m` hypothesis. `sampling.tex` uses the negated centers and coefficient widths for `prop:starting`; correction and completion are further dependencies. The introduction to packing attributes the argument to the September manuscript. |
| `Ultraflat-real-Littlewood-polynomials-October-5-2026/build/sections/waves.tex`, lines 28-38 and 64-114 | Cites lower-envelope Lemma 3.1, rather than proving packing anew. Uses representatives of sign-pairs, `w_-a=w_a`, and centers congruent to `-a.theta_h` to place inverse-curvature wave intervals; `prop:waves` feeds completion. |

These are source-fidelity observations, not an independent review of sampling,
correction, waves or completion. The sign choice is harmless for a lemma
including both signs, but does not check the later analytic transformations.
The staged files contain the relevant citation commands; a bibliography entry
itself was not found in the inspected staged reference files. The external
proposition is assessed separately in [matching](../matching/report.md).

## Reconcile the old records, not just their labels

The old ledger has ten claim versions and sixteen evidence rows. Its
`reviewer:65ff03c5a5e8` judgements support exactly six claim subjects:
`C_PACK_SCOPE@1`, `C_PACK_COUNT@2`, `C_PACK_MOMENTS@1`,
`C_PACK_MATCH@2`, `C_PACK_GEOMETRY@1` and `C_PACKING@2`;
two further judgements concern the matching-assumption aliases. The index
records their exact subject bindings and evidence ids. The actual report,
formal source and certificate bindings were checked, rather than inferred
from an unqualified reviewer name.

`C_PACK_COUNT@1` is superseded by the encoded v2 statement with a different
binding. For matching and packing, v1/v2 have the same natural-statement hash;
v2 adds the exposed external assumption. Consequently a hash match there
does not justify forgetting the assumption attachment or calling v1 a
separately reviewed theorem.

All thirteen old proof-graph nodes still say `open` and
`reviewer_confirmed=false`. The report also says review remains pending.
For the six packing subjects these are stale relative to the bound ledger
judgements. They are not grounds for erasing existing human review. Conversely,
the judgements do not close `C9000076@1`, certify the entire paper, supply
official literature-tier attribution, or constitute this review's independent
acceptance. The original objective is historical data, not today's task.

## Concrete analytic exclusions

The following six proof-graph nodes have no proof in this packing draft.
Their open status is substantive, not merely stale bookkeeping:

| Nodes | Exact outstanding mathematical scope |
|---|---|
| `P_MINIMAL_MAIN`, `P_MINIMAL_ANALYSIS` | September `thm:main`: for every `eta>0`, every sufficiently large integer `N` admits real signs with maximum modulus at most `(1+eta)sqrt(N)` (equivalently `m_N -> 1`). Auxiliary polynomial, quadratic sampling, almost-signs estimates and rounding are not established by packing. |
| `P_LOWER_MAIN`, `P_LOWER_ANALYSIS` | October lower-envelope `thm:main`: simultaneously `sqrt(N)/16 <= abs(P(z)) <= (1+eta)sqrt(N)` for every `abs(z)=1`, at all sufficiently large lengths. Starting construction, correction and completion estimates remain unreviewed. |
| `P_ULTRA_MAIN`, `P_ULTRA_ANALYSIS` | October ultraflat `thm:main`: for every `epsilon in (0,1)`, all sufficiently large lengths admit real signs with `(1-epsilon)sqrt(N) <= abs(P(z)) <= (1+epsilon)sqrt(N)` everywhere on the circle. Balanced construction, inverse-curvature waves, gap joins, coefficient tails and rounding remain unreviewed. |

Thus `C9000076@1`, whose graph depends on these main theorems, is not
established by verifying packing. No binary merit-factor conclusion is
independently certified here.

## Retrieval and comparison with prior work

The old report records an unsuccessful inherited Wiki lookup. The present
Wiki `INDEX.md` also has no hit for `076`, `Littlewood`, `Pippenger`,
`Alon-Yuster`, `dependent-form` or `signed-interval`. A more specific full-text
page search did find `pages/c9000076/packing-audit_report.md`: it is
byte-for-byte the old report, not independent mathematical support. Its only
other Littlewood-name hit concerned Hardy--Littlewood prime tuples and was
irrelevant. The configured reviewed-facts digest
`$WORKSPACE/.argus-campaign-9200076/reviewed-facts.md`
had zero matches for the packing, author and campaign queries. This is a
bounded retrieval result, not a claim that the literature contains nothing.

The strongest prior result is already the historically human-reviewed
dependent-form packing chain with a separately compiled counting core.
This review adds coverage, statement-fidelity analysis and reconciliation;
it makes no mathematical improvement or verified-new novelty claim.
Independent acceptance of the present five-unit review remains the native
Host-invoked Reviewer's decision.
