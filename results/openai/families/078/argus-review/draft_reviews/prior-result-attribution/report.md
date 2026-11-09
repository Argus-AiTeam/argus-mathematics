# Engineer review: prior-result attribution and current source readings

**Assessment: supported bounded attribution, with an unversioned OSW
limit.** This unit covers **DB_PRIOR_RESULTS v1–3** and the graph-only
obligation **DB_CITATION_ATTRIBUTION**. It is not a novelty survey, new
error search, mathematical repair, or native acceptance review.
The review result has `novelty_status=not_applicable` and awaits the
native Host-invoked independent Reviewer.

## Contribution classification and attribution rationale

**Classification: `confirmed_reproduction`.** The supported contribution
is the bounded attribution and hypothesis comparison, not a new
projection theorem. OpenAI already names Ren-Wang as its geometric input
(`01-introduction.tex:126-143`, `03-projection.tex:23-49`) and
Shmerkin-Wang/Orponen-Shmerkin-Wang as bootstrap precedents
(`07-rate-transfer.tex:819-825`). The manuscript itself says that it
proves the retained conditional-pair version needed here. Argus checks
and explains that existing source relationship against the preserved
versioned propositions. The predecessor theorems belong to their named
authors; the manuscript's use is OpenAI's; the source-reading and
comparison work is Argus's. This label covers only that supported
comparison: it does not independently confirm the unversioned OSW
proposition, transfer attribution across RW41 hashes, or establish
literature novelty.

## Inputs and identities

Read current `OBJECTIVE.md`, `PRIOR_DRAFTS.json` and
`research/DRAFT_REVIEW_INDEX.json`; old report Scope and Sections 8–10;
old `ren_wang_excerpt.txt`, `reviewer_primary_source_excerpts.txt`, and:

* `research/literature/714292b2c007a65401fa0de58178eee3.json`:
  `arxiv:2308.08819v3`, Theorem 4.1 and Definition 3.1.
* `research/literature/81b80a192a240260e1da997538b9a3b8.json`:
  `arxiv:2112.09044v3`, Lemma 5.12 and Corollary 5.14.

Both old records contain the same complete two-paper transcription,
explicitly naming each paper and locator. It matches the preserved
3,078-character excerpt file except that the JSON text omits its final
newline (3,077 characters). The source-specific blocks copied into this
unit's exact excerpt files were verified as unchanged substrings of the
appropriate records. This is quotation reuse, not two new external
retrievals or two historical independent readers.

The historical attribution remains **reviewer:copilot-independent**,
with evidence `citation-RW41-17b7e6e7b8e1` and
`citation-SW_PRECEDENT-4bef407d7795`. The old research worker
`projection-literature` retrieved the passages. This worker actually
read them for the current review as **reader:draft-source-worker**,
distinct from the parent assumption-filer `engineer:copilot`; no
historical reviewer identity is impersonated.

The staged manuscript inspected is revision
**4eaee87548250b2682affda7d05d947c05554bae** in the canonical
`Bochner-Riesz-Multipliers-in-Three-Dimensions-September-24-2026`
directory. Its weighted tagged statement is
`03-projection.tex:61–195`; application interfaces are the specified
`07-rate-transfer.tex` ranges and the finite homogenization/profile
statements of `02-entropy.tex`. This bounded comparison does not audit
other manuscript arguments.

## Ren–Wang: exact versioned theorem, not just an exponent

The complete reused quotation, including Definition 3.1 and Theorem 4.1,
is in **ren_wang_v3_exact_passages.txt**. It retains dyadic precision,
the ranges \(s\in(0,1]\), \(t\in(0,2]\), selected tube families at
each point, comparable fiber cardinality \(M\), point/tube
nonconcentration losses, the small-scale threshold, and the order
“for every epsilon … there exists eta.” Its conclusion is
\[
 |\mathcal T|_\delta\ge c_\epsilon
 \delta^{-\min\{t,(s+t)/2,1\}+\epsilon}M.
\]

With source \(s=u,\ t=d,\ \epsilon=\alpha,\ \delta=\rho\),
this supports the **exact current RW41 statement**. In particular,
the multiplicative \(M\) cannot be dropped, and Definition 3.1 allows
selected rather than all incident tubes. The desired output loss is
chosen before the admissible input loss and precision.

It does **not** directly state the manuscript's weighted probability
population/whole-tag theorem. That reduction is the old report's
Section 8 argument: sample whole tags and points, bound occupancy,
remove coincidences, obtain comparable nice-configuration fibers, and
compare \(CQM\) with the Ren–Wang lower bound involving \(M_0\).
It preserves tags with repeated slopes. Checking that analytical
reduction belongs to the analytical-bridges unit; source attribution is
not its proof.

### Hash-specific binding

The old literature evidence binds the detailed RW41 hash
**95d5f6fb8ffa3609af348397524a6ef9e63ceaad7add890ca4f5ecd22f839606**.
The later abbreviated formulation has a distinct hash,
**1d5e25e2664a55b01aa708fb684c01ed1119522f2f2d5f1592d0cec72f619fa8**,
and no independently attributed evidence in the index. Its wording also
mentions the report's weighted reduction, which the external theorem
does not itself state.

More precisely, the index binds DB_MAIN v2 to the abbreviated hash;
DB_MAIN v3, DB_ASYMMETRIC v2 and DB_PROJECTION_INPUT v2 use the
detailed hash. The current OLD_DRAFT_REVIEW assumption likewise uses
the detailed hash. No historical or current citation is silently
transferred to the abbreviated hash or its additional reduction clause.

## Shmerkin–Wang: complete hypotheses and a necessary missing-clause read

The unchanged archived Lemma 5.12 and Corollary 5.14 quotations are in
**shmerkin_wang_v3_exact_passages.txt**. Lemma 5.12 requires
\(0<s<t\le1\), uniformly separated supports, and **both** upper and
lower dyadic cell masses
\[
 K^{-1}2^{-m(t+\eta/C)}
 \le\mu_i(Q)\le K2^{-m(t-\eta/C)}
\]
through depth \(M\), on every occupied cell. Its assumed strong
thin-tube estimate at \(2^{-M/2}\) improves the reversed ordered pair
to exponent \(s+\eta\) at \(2^{-M}\), with retained-mass loss
\(1-6\sqrt c\) and the stated parameter-dependent \(K'\).

Corollary 5.14 retains separated supports, two-sided masses through
\(\widetilde M\), a small line-neighborhood mass hypothesis at
\(\delta_0\), and a minimum depth. Its conclusion has exponent
\(t-\zeta\), retained mass \(1-c\), and
\(K=K(t,\zeta,C,c,\delta_0)\). Those fixed-parameter constants are
not a uniform subpower assertion as inputs vary.

The exact current SW_PRECEDENT statement additionally says robust
entropy and graph-fiber projections occur elsewhere in the source.
The two archived bootstrap statements **alone did not quote that
clause**. Rather than silently treating it as read, this worker obtained
only the genuinely missing statements from the same versioned primary
HTML: **Definition 2.4** (`S2.Thmtheorem4`) and **Theorem 4.8**
(`S4.Thmtheorem8`). Their full statements, with unchanged prose and
verbatim mathematical HTML alttext (layout whitespace normalized), are
appended to the same excerpt file.

Definition 2.4 defines robust entropy by an infimum over
\(\nu\le\Theta\mu\). Theorem 4.8 gives robust pushforwards on large
graph fibers \(X_y\), assuming a regular projection family,
Frostman bounds, adapted derivative-direction measures on large
\(Y_x\), compact incidence sets and the specified scale thresholds.
This confirms the extra descriptive clause without importing that
theorem into the arbitrary conditional-pair problem. The current
SW_PRECEDENT hash
**51ab33551a43f87ed32653ffa4582c6ee18817ffd3257e9a9fd80dbad66691ad**
is consequently supported in its entirety. No unchanged bootstrap
passage was re-fetched and no novelty survey was performed.

## Orponen–Shmerkin–Wang and the conditional-interface boundary

The old OSW_PRECEDENT is explicitly **unversioned source prose**:
arXiv:2209.00348, Definition 2.1, Lemma 2.8 and Corollary 2.18,
retrieved from unversioned HTML. Its `source_id` and canonical locator
fields are empty; no version-specific excerpt or independent literature
evidence is indexed for hash
`27b3317e720c09a60a7cbd2ece3fefd8c0e9db0a1f3886f6e8aeaf405e5a9c35`.
Retain this as historical background attribution to the existing
worker, not as a freshly confirmed versioned theorem. No third source
lookup or citation write was made.

The reported separated Frostman/product-graph improvement and the
versioned separated near-Ahlfors bootstrap are known precedents.
Neither by itself verifies an arbitrary dominated law
\(P\le K\mu_A\otimes\mu_B\), its normalized restrictions, simultaneous
original conditional bins under both pins, actual retained marginals,
or subpower retention/constant control. Upper domination does not
supply the predecessors' lower cell masses. The current arbitrary-law
interface therefore still needs its separately reviewed finite core,
retained-marginal, two-pin and weighted arguments.

This is a distinction of hypotheses, not evidence of novelty or a
refutation of either source or the manuscript.

## Old versions, historical labels and current citation results

DB_PRIOR_RESULTS v1–3 all have hash
**75985c3c12e5281e32e601679bcf80c3d37a3aa5afa79927ae86d7f84b933651**
and the same bounded-literature-distinction statement. v1 has no typed
external assumptions; v2 adds OSW_PRECEDENT; v3 adds SW_PRECEDENT.
`judgement-DB_PRIOR_RESULTS-12b1f95e4a1b` supports that statement
historically. An unchanged claim hash does not resolve the later
unversioned dependency or establish novelty.

DB_CITATION_ATTRIBUTION has **no ledger claim versions**: it is an
open historical graph obligation, not an additional mathematical result.
The old report's “citation pending” prose and graph's open labels
predate/lag the exact-hash independent records. Retain those records
without calling them current native acceptance.

Official current attributes for OLD_DRAFT_REVIEW recorded:

| Assumption | Current evidence / archive | Result |
|---|---|---|
| RW41, detailed hash | `citation-RW41-20bda673fbbb`; `research/literature/11ffb5cfeda07b6974958ab9e6679ac7.json` | supports; confirmed; exit 0 |
| SW_PRECEDENT | `citation-SW_PRECEDENT-ae9775bba048`; `research/literature/b2f109fa17149285c5eeebc1bd821d2e.json` | supports; confirmed; exit 0 |

Both were attributed by **reader:draft-source-worker**, with note:
“Independent current review reading of unchanged versioned passage;
preserved old attribution reused, not native acceptance.”
The supplemented SW file makes the otherwise missing descriptive clause
auditable. Existing historical identities and old files remain untouched.

After these writes, at exact project root
`campaigns/9200078`,
official `math_state check` exited **0** with
`{"ok":true,"issues":[]}`, and `proof_graph_check check` exited **0**
with `proof graph valid: 9 node(s)`. Full commands are in the verdict.
No old computation was executed, current graph written, or node
self-accepted. These checks validate structure, not native acceptance,
the upstream application assumptions, novelty, or the whole manuscript.
