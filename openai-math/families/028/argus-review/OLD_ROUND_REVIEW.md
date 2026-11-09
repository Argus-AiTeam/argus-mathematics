# Review of the old family 028 Argus drafts

**All thirteen listed artifacts have explicit dispositions and both review
units have reports and verdicts.** The artifact/claim coverage check and exact
checker replay pass. The native Reviewer accepted the prior bounded review;
final project-level exploratory certification of the entire `OBJECTIVE.md`
is still outstanding. The separate campaign handoff gate is blocked: the current ledger
check exits 0, but the proof-graph check exits 2 because the campaign has no
`research/PROOF_GRAPH.json`.
Neither current family acceptance nor an all-gates-passed milestone is claimed.

The existing native [reviewed handoff](
$WORKSPACE/.argus-campaign-9200028/projects/421d37ad86ed/handoffs/5aa446614d80/round-0001.json)
records `status=done` because the coverage and source-grounded assessments
satisfy the **bounded exploratory review objective**. The current ledger also
contains independent Reviewer support for all four review claims. That is
stronger than Engineer-only or historical support, but does not supply the
missing final exploratory certification. This submission reuses the accepted
mathematics and replay evidence without changing either unit's report or
verdict. Their original pending-review labels are not a final acceptance
record and do not erase the later bounded native review.

## Coverage and sources

[`DRAFT_REVIEW_INDEX.json`](DRAFT_REVIEW_INDEX.json) was the first project
artifact written. It maps all thirteen `PRIOR_DRAFTS.json` artifacts,
both historical contexts, all **23** ledger claim identities and graph nodes,
all **16** ledger routes, and all **16** historical judgement records.
A direct structured comparison verified each claim/version/context hash,
literal graph/ledger statement equality, all dependency references and
judgement subjects, all unit assignments and all exclusions.
There are no duplicate old ledger IDs with different content hashes in this
input; the index nevertheless retains version/hash identity rather than
deduplicating by textual ID. The graph has no separate route records.

There is **one developed mathematical argument**, not thirteen results or
twenty-three theorems independently proved by Argus. Fourteen manuscript
dependency restatements are a second, reference-only review unit; the remaining
`C9000028` is a historical task/whole-family goal, not another theorem.
The zero-byte lock is administrative. Conrad's PDF/text are two
representations of one supporting source; the three Jacobian JSON files
describe one local algebra operation; snapshot copies are not new results.

The existing November 6 snapshot manifest contains only six family artifacts,
not all thirteen. All six hashes match; all thirteen old file sizes match the
input inventory. The other seven files have explicit measured source
identities and are marked **not listed**, not falsely described as snapshot
matches. All eight staged manuscript TeX sources also match the existing
`9100028/MANUSCRIPTS.json` and reference sources at revision
`4eaee87548250b2682affda7d05d947c05554bae`.
The manuscript credits OpenAI and is dated September 26, 2026.
Neither manifest was rebuilt. Old drafts, ledgers, graph and reference inputs
were kept read-only; the replay confirms unchanged content, sizes and
modification times for all thirteen old files.

## Every review unit

| Unit | Disposition and decisive reason |
|---|---|
| [`signed_rectangle`](draft_reviews/signed_rectangle/report.md) ([verdict](draft_reviews/signed_rectangle/verdict.json)) | **Supported as a universal prose proof in its stated scope.** The arithmetic/fixed-line tail and determinant separation combine with cube concentration and a two-union partition to prove \(3e^{-d^2r/32}\), with the trivial probability bound handling small parameters. The exact checker replay passes but is not a kernel proof. Global priority is not established, and independent Reviewer acceptance is pending. |
| [`manuscript_dependencies`](draft_reviews/manuscript_dependencies/report.md) ([verdict](draft_reviews/manuscript_dependencies/verdict.json)) | **Reference-only, with concrete old-Argus support gaps.** All fourteen claims have exact source labels/hypotheses and individual dispositions, but no separate old Argus proof, supporting opinion or computational certificate. The rectangle result alone does not establish sampling enrichment, coverage transfer/scheduling, information costs/telescoping, a finite sieve obstruction, periodic component bounds, or the full Gaussian-prime theorem. Their truth is neither certified nor refuted by this review. |

### What the rectangle argument actually establishes

For \(r\ge1,T\ge5\), distinct primes \(p_i\equiv1\bmod4\) in
\([T,2T]\), supplied norm-\(p_i\) Gaussian factors, independent fair
conjugate choices, and a **fixed-before-signs**, origin-centered rectangle
of arbitrary orientation with \(R\ge W\ge1\),
\(RW\le P^{1-d}\), \(P=\prod p_i\), \(0<d<1/4\), the old draft proves
\[
\Pr\{Q\cap(\textstyle\prod_i\pi_i)\mathbb Z[i]\ne\{0\}\}
\le \min\{1,3e^{-d^2r/32}\}.
\]
The event includes all nonzero multiples, not just the signed product.
The eight related ledger claims are one proof and its supporting lemmas.

The supplied manuscript's `geometry.tex`, `lem:rectangle`, asks for
\(Ce^{-cd^3r}\) when \(d^3r\ge C_0\).
The quadratic bound implies it with \((C,c,C_0)=(3,1/32,1)\).
The mathematical improvement is relative to that original cubic statement;
this review does not improve the already stronger old Argus theorem.
Replacing \(\Theta(dr)\) edge-neighborhood growth steps of rate
\(\Theta(d^2)\) with a separated-two-set concentration bound removes the
additional factor of \(d\). This is not a refutation of the original
weaker lemma.

The failed `R_FIXED_LINE_UNION_ONLY` route is explicitly retained: a fixed-line
tail alone supplies no parameter-uniform bound on the number of directions
to sum over. The completed proof avoids that failure through separated
classes. Likewise, orienting a rectangle after seeing the product, with
\(R=\sqrt P,W=1\), disproves only a different simultaneous/adaptive
quantifier statement, not the actual fixed-rectangle assertion.

### What the reference-only unit leaves uncertified

The unit covers `C_MAIN`, `C_SIEVE`, `C_PERIODIC`, `C_DIFFERENCES`,
`C_ENRICHMENT`, `C_DISPLACEMENT`, `C_TRANSFER`, `C_SCHEDULE`,
`C_COVERAGE`, `C_INFORMATION`, `C_TELESCOPE`, `C_LIST`,
`C_CONTINUITY`, and `C_CONDITIONING`. Its report identifies each missing
old-Argus argument, rather than calling the source correct without reviewing
it or declaring an error from lack of certification.
Exact labeled statements, including all transfer parameter inequalities, are
retained in [source_statements.txt](draft_reviews/manuscript_dependencies/source_statements.txt).
The source's list-entropy event is slightly more general than the ledger's
globally bounded-list wording; the latter is a special case, not a
counterexample. `C_SCHEDULE` refers to the whole prescribed schedule, not just
one future-shift lemma or arbitrary schedules.

## Evidence and historical Reviewer support

The replay in [replay.json](draft_reviews/signed_rectangle/replay.json) uses
Python 3.13.5 at `$WORKSPACE/miniconda3/bin/python`, SymPy 1.14.0,
and disables bytecode writes. It exits 0 with empty stderr in approximately
0.319 seconds, reproducing the old JSON output exactly: ten symbolic
identities, five coefficient certificates, a universal multi-affine
determinant interpolation, and the archived typed Jacobian multiplication.
The finite Gaussian regression has one bad sign vector out of sixteen,
176 primitive vectors including opposite signs, and seven multipliers.
Its \(d^2r=4/25\) lies in the trivial-bound branch; it is not evidence
for an asymptotic decay theorem.

The archived Jacobian operation is `matrix.symbolic.multiply.compute`,
server 0.14.0, protocol 2025-11-25. Exact input/output/status remain in the
old dedicated JSON files. They support only the polynomial
\((r\lambda-2s)^2\); the recorded historical status is completed,
exit 0, empty stderr. No fresh Jacobian service invocation was needed.
There is no listed Lean source or compiler evidence, and no new one was
introduced. No `closed_kernel` result is claimed.

The eight historical Reviewer and eight Engineer `supports` records all bind
to the matching rectangle-claim hashes. In particular,
`judgement-C_RECTANGLE_SHARP-bd2aa0e8377c` binds to sharp claim v1
`e08622009d2d4b8cd2d5bf8b178255e5e1d818690cc8c64edcaca5e4fa5a6dfb`
in the matching `CTX_RECTANGLE` context, and cites
`STATEMENT_FIDELITY.md`. Its dependencies have matching claim hashes and
their own historical Reviewer opinions. This is reusable historical support.
The opinions do not store artifact hashes or timestamps, so they cannot
prove which artifact bytes the historical reviewer read.
All 23 old graph nodes still say `open`, `reviewer_confirmed=false`,
and the old certificate/stdout say review pending. These facts are recorded
together; neither metadata stream is silently substituted for current family
acceptance.

## Current ledger, assumptions and checks

The **current** [`MATH_STATE.json`](MATH_STATE.json)
contains four source-bound review claims, four Engineer judgements and four
independent Reviewer judgements, and
records the failed fixed-line-only route with its mathematical reason.
The current ledger is unchanged in this final submission. No statuses were
authored, old opinions relabeled as current independent review, or Engineer
judgements counted as independent acceptance.

The explicit review assumptions are the operator-supplied review universe
and version manifests, standard split-prime factor existence (the supplied
factors are theorem inputs), and ordinary real-series/finite-probability
background. Conrad Theorem 9.7(ii) was inspected in the archived source;
the PDF's `pdftotext -layout` extraction, Poppler 22.02.0, equals the
112,927-byte text copy exactly. The report also checks the stated Gaussian
arithmetic locators. No unread Hoeffding theorem, prime-density theorem,
entropy enrichment result or Gaussian-moat result is an assumption of
the rectangle proof.

`citation_check status` exits 0 with no blocking canonical citations.
The three unique assumptions are explicitly source-only and therefore
reported as `uncited`, not registry-resolved or independently attributed;
the mutable notes have no invented canonical identifier. The native Reviewer
must judge the locally inspected source use. No self-supporting citation
verdict was filed.

For this final submission, both official checks were run once with
`$WORKSPACE/argus-latest/.venv/bin/python`, against the exact
campaign root
`campaigns/9200028`:

| Check | Measured outcome |
|---|---|
| `argus_skill.verticals.math.math_state check --project-root <campaign root>` | **Exit 0**, `{"ok": true, "issues": []}`. |
| `argus_skill.verticals.math.proof_graph_check check --project-root <campaign root>` | **Exit 2**, `no proof graph at .../9200028/research/PROOF_GRAPH.json`. |

The missing graph is an administrative gate blocker, not a
mathematical refutation or missing-access rationale for the unit assessments.
The current mission is final submission of an exploratory old-draft review,
not construction of a new theorem or speculative proof graph. No old graph
was copied into the current project, and no substitute graph or batch-root
check was used. The required all-zero campaign gate therefore remains
unsatisfied; resolving the absent campaign graph within authorized scope is
necessary before that gate can pass.

The native Host-invoked Reviewer receives this as the **final deliverable for
the entire `OBJECTIVE.md`**, not another bounded-cycle submission. Its decision
must account for all thirteen artifacts, all 23 claim identities, both unit
assessments, supporting evidence and exclusions. It must preserve the
distinctions between the supported rectangle proof and uncertified manuscript
dependencies, prior support and final acceptance, and exact computation and
universal or kernel proof. If final certification is withheld, the native
decision must name the precise unmet requirement and correction; repeating the
previous bounded acceptance does not complete this objective. Engineer does
not supply that certification.
