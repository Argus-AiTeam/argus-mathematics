# Family 012: review of all old Argus mathematical drafts

The five substantive units have Engineer assessments, not final acceptance.
The main mathematical finding is a **literal report/ledger mismatch**:
the prose proves the ledger's additive finite expectation bound, not the
product printed in equation (3). The conditional \(B^{-3/200}\) sampling
rate survives with the additive bound. The deterministic Lean core and
the finite checks replay successfully, but neither establishes arithmetic
inputs or the joint Dickman law.

The review is **exploratory**. No new manuscript-error search, research
campaign, verified-new result, manuscript refutation, or whole-paper proof
was undertaken. The Host-invoked independent Reviewer must examine the
coverage and the substantive assessments and decide final project-level
completeness. The prior bounded native review accepted these findings,
but did not supply that final certification. The absent active proof graph
and its actual checker result are retained below, not treated as an
additional mathematical obligation under `OBJECTIVE.md`.

## Complete inventory and provenance

`DRAFT_REVIEW_INDEX.json` was the first review artifact written. It accounts
for all **20/20** artifacts in `PRIOR_DRAFTS.json`, all **23/23 old ledger
claim versions** across **16 distinct IDs**, all **16 old graph nodes**,
all **22 old ledger evidence records**, all six recorded routes, all four
external-assumption registrations and their versions, and the reference
input directory with its **15 files**. Versions of one argument are not
counted as separate results.

All 20 inputs exist with their inventory byte sizes. The 11 members of the
existing `2026-11-06T10:20Z` family snapshot manifest match its existing
digests. The other nine listed artifacts are old-workspace sidecars absent
from that manifest: two empty lock files, `compile.log`, four Jacobian
JSON files, `lean_run.json`, and `lean_runner_receipt.json`. They were
examined and indexed, but not relabeled as authenticated snapshot members.
The empty locks contain no mathematical claims.

The original unpublished reference is OpenAI, *The joint Dickman law for
consecutive integers*, September 24, 2026. `../9100012/MANUSCRIPTS.json`
records revision `4eaee87548250b2682affda7d05d947c05554bae`.
Current bytes match **13/13 existing TeX digests**. This compares bytes
to the existing manifest, not independently authenticated Git history.
The old reference directory is a live symlink to the manuscript source,
not a second preserved copy. README, assembly, preamble, bibliography
and arithmetic section context are accounted for as reference/support
inputs, not independent Argus results.

The old workspace, snapshot, manifests, sources and ledgers remain read-only.
Replays and their necessary compiler copies are confined to active
`research/draft_reviews/`; no new snapshot or source repair was made.
The historical `C9000012` adversarial-audit mission text is explicitly
excluded as a mathematical theorem/current instruction, not silently
omitted. Its sampling dependency is reviewed.

## Assessment of every substantive unit

| Unit and assessment files | Covered assertions | Engineer assessment and exact boundary |
|---|---|---|
| [finite-adaptive-transfer/report.md](draft_reviews/finite-adaptive-transfer/report.md), [verdict.json](draft_reviews/finite-adaptive-transfer/verdict.json) | `C_ADAPTIVE_TRANSFER v1`; all five `L_CUT_* v1` obligations | Additive ledger expectation and probability (4) supported by the universal prose argument. Literal product-form equation (3) not proved by that argument and not refuted here. |
| [finite-cut-core/report.md](draft_reviews/finite-cut-core/report.md), [verdict.json](draft_reviews/finite-cut-core/verdict.json) | `C_CUT_FINITE_CORE v1-v4`; all three compiler-certificate versions and run sidecars | Fresh real compile/audit succeeds for arbitrary finite square real arrays. Deterministic response, deletion and arbitrary-good-endpoint inequalities only; fidelity was read separately. |
| [finite-models-shortcuts/report.md](draft_reviews/finite-models-shortcuts/report.md), [verdict.json](draft_reviews/finite-models-shortcuts/verdict.json) | Non-ledger finite regressions, signed/rare models, disconnected extension, two excluded shortcuts, exponent/nonvacuity checks, illustrative Jacobian moment | Seven finite result fields exactly reproduced. Concrete shortcuts fail; neither failure refutes the original manuscript. Finite tests are not a universal probability proof. |
| [sampling-specialization/report.md](draft_reviews/sampling-specialization/report.md), [verdict.json](draft_reviews/sampling-specialization/verdict.json) | `C_SAMPLING_45 v1-v5`, assumptions A23/A24/A44/AMROW, comparison with original (45) | Conditional \(\mathbb EC\le E_0+\rho_B+O(B^{-3/200})\) follows using the additive finite formula. No polynomial rate for \(\rho_B=o(1)\), no arithmetic verification. |
| [arithmetic-boundary/report.md](draft_reviews/arithmetic-boundary/report.md), [verdict.json](draft_reviews/arithmetic-boundary/verdict.json) | `U_EQ23`, `U_EQ24`, `U_EQ44`, `U_M_ROW`, `U_ROOT21`, `U_LABEL_REDUCTION`, `C_JOINT_DICKMAN`, all v1 | Source attribution and conditional-use boundary supported. Concrete arithmetic, root-coupling, label/energy and density obligations remain; none is discharged by the old local certificates. |

### The decisive finite-formula reconciliation

Use the old theorem's definitions and put
\[
 G=b+a+2\sqrt{Mq/m},\quad D=2md/M,\quad
 T=\sqrt{(C_0^2+q)(p+\delta)}.
\]
The report prints \(\mathbb EC\le G+DT\); the ledger states
\(\mathbb EC\le G+D+T\). The good-event deletion error \(D\) and
bad-event Cauchy--Schwarz bound \(T\) are separate contributions.
Their integration gives the additive ledger inequality, not their product.
The right sides are not globally ordered over all nonnegative parameters;
at the manuscript's small-error scales the product is the smaller one.
No exact counterexample to the printed formula is claimed. Its concrete
gap is the absent justification for replacing two additive errors by a
product. It requires a distinct proof/counterexample or a source correction,
not another finite regression success.

The degree, skeleton, fixed-mean, capped extension and finite-family union
arguments support their stated roles, with the original independence and
normalization hypotheses. The bounded-differences and extension arguments
are checked directly in prose, not imported from unread literature.

For the specialization, the additive deletion is \(O(B^{-11/100})\)
and exceptional mass is \(O(B^{-3/200})\); retaining them preserves
the stated \(3/200\) rate. The floor in \(m\), \(p<1\), bounded cap,
logarithmic entropy factor and fixed-parameter uniformity are accounted
for. The full error still includes the unspecified arithmetic \(\rho_B\).
Compared with the strongest supported old result, this review adds no
stronger theorem: it identifies exactly which version has a valid argument.

### Formal versions, real toolchains and finite replay

All three historical certificates were examined. Old natural-only core
v1 has no compile. Version 2 corresponds to `d03f1859834768ea` and a
failed compile; v3 to `96d3e0892fc0cbfb` and a failed compile; v4 to
`ff9737a934d9878c` and a successful compile/audit. The aggregate
syntax/type labels do not erase the actual diagnostics. Failed runs with
empty hole lists are not proofs. The successful log/check/run sidecars
duplicate v4; a submitted runner receipt alone proves no completion.

The fresh source and fidelity copies are byte-identical to the current
old originals. Lean **4.31.0**, Lake **5.0.0-src+68218e8**, the built
Mathlib workspace at
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`,
and Python **3.13.5** were actually used. Compile exit **0**, audit
exit **0**, and no reported proof holes support precisely the finite
deterministic declarations. The first runner attempt failed before
compilation on the legacy timeout-default bug; the documented explicit
`--timeout 300` allowed the real run without source/tool changes.
The new compiler certificate is
`draft_reviews/finite-cut-core/replay/certificates/RV_CUT_CORE-e13acc53d96d1029.json`.
No unchanged Lean run was repeated.

The finite checker was safely imported with bytecode writes disabled;
its original `certify()` ran without its output-writing entry point.
All **seven finite fields match** the old exact certificate, including
729 matrices, 186624 bilinear sign pairs, the three binary-site models,
180 frozen-type cases, disconnected-good-set extension, exponents and
the illustrative large-\(B\) nonvacuity budget. That budget uses additive
errors. Its finite and historical metadata assertions are not universal
proofs or a fresh formal compile.

One bounded Jacobian operation was discovered, its exact typed contract
inspected, then executed through the isolated **live-update adapter**:
`probability.finite_distribution.raw_moment.compute`. Dedicated
`draft_reviews/finite-models-shortcuts/jacobian/{payload,output,status}.json`
retain the exact input, typed output, server **0.14.0**, protocol
**2025-11-25**, exit **0**, and no timeout/error. The moment is exactly
**3/128**, independently linked to the rare-positive triangle's mass
distribution. It duplicates that illustrative calculation and is not
a concentration result or a proof of transfer.

### Assumptions, failed attacks and unresolved mathematics

The active ledger records the conditional sampling inputs with citations
to the accessible unpublished primary source. The assumption statements
retain their original scope; the arithmetic report supplies exact
locations and the fixed-grid/tolerance and model-law qualifications.
These are local unpublished citations, not fabricated canonical
published references or independently proved arithmetic propositions.

The first moment (23) is every-type; (24) integrates both endpoints;
(44) allows separate local tests including zero; comparator row estimates
are deterministic. Independence belongs to the **model**, not actual
consecutive-integer residue sites. The correct kernel locator is
`kernel.tex:736-820`; the old broad citation through 850 exceeds EOF.
The actual root-comparison label is `prop:graph-root-comparison`,
`graph.tex:295-313`, and its source proof also uses (23).

Two known failed approaches are retained as retired routes with reasons:
conditioning on the realized optimizer changes a model marginal from
\(1/2\) to \(1/4\); integrated square control cannot be upgraded to uniform
conditional square control, as the rare-type family has
\(q=1/(2r^2)\to0\) but conditional row squares \(1/2\).
These are rejected shortcuts, not accusations against the manuscript's
actual fixed-assignment proof. Current finite replay and source citations
support both distinctions.

The concrete unverified arithmetic obligations are the split-product and
sieve estimates behind (23), tilted weighted multiplicity behind (24),
the uniform cutoff/channel/projection approximation behind (44), the
comparator feature and lag-mean inputs, and the root/site couplings and
fluctuation bounds behind (21). Beyond these, the source requires label
short-average cancellation and its external short-interval inputs,
divisor/amplification moments, positive-energy reduction, feature and
periodic approximations, comparator-energy vanishing, ordered parameter
choices and final distribution deductions. The arithmetic report locates
each bundle rather than declaring the rest of the paper correct.

The final attributed joint-law statement is ordinary unweighted natural
density through **all real endpoints**, for fixed \(0<a,b<1\), with
thresholds \(P^+(n)\le n^a\) and \(P^+(n+1)\le n^b\).
It is not logarithmic density, an almost-all-scales statement, or a
quantitative theorem. The old Argus work explicitly does not establish it.

No graphon sampling theorem is an external premise of the reviewed
abstract proof. The manuscript's related-work references are not treated
as evidence of novelty or as automatically applicable black boxes.
A targeted search of the supplied Wiki index found no applicable
family/Dickman/adaptive-cut entry; no Wiki fact was used as a proof input.

## Coverage verification and campaign gate

The final structural review validation **passed all 62 consistency
assertions**. It checked the index against the actual
inventory, both old ledgers, all historical evidence IDs and assumption
versions, all three certificate filenames, the nine nonmanifest sidecars,
all 15 reference files and all five pairs of assessment files. The measured
coverage is 20 artifacts, 23 claim versions, 16 distinct claims/graph nodes,
22 evidence records, six old routes, four assumptions with ten version
occurrences, and ten assessment files. This is a
coverage/consistency check, not another proof of the mathematics.

The official check root is exactly:

```
campaigns/9200012
```

Both official modules use
`$WORKSPACE/argus-live-update/.venv/bin/python`, never the shared
batch root or bare system Python. The checks run once for this final
submission returned **math_state exit 0** (`ok: true; issues: []`) and
**proof_graph_check exit 2**, consistent with the previously recorded
outcomes:

```
no proof graph at families/012/argus-review/PROOF_GRAPH.json
```

The file remains absent. No old graph, alternate root, fabricated passing
output or new proof graph is substituted; no zero exit for that check is
claimed. The exact results remain in `DRAFT_REVIEW_INDEX.json`.

The accepted bounded handoff is
`$WORKSPACE/.argus-campaign-9200012/projects/f9b178cfdc39/handoffs/b423732b5d2b/round-0001.json`.
Its native Reviewer recorded `review.status: done`, accepted the coverage
and additive/product distinction, and explicitly stated:
"OBJECTIVE.md does not require the missing proof graph."
The earlier description of that absence as a delivery blocker is therefore
superseded by this bounded review, not by an Engineer-created waiver.

Final **project-level** certification remains pending. The decision now
requested from the Host-invoked independent Reviewer covers all 20 listed
artifacts, 23 claim versions and five substantive units, including statement
fidelity, decisive arguments, retained replay evidence and honest
limitations. The five unit reports and verdicts, coverage, mathematical
assessments and replay evidence are unchanged. Completing this exploratory
review does not prove the joint Dickman law, settle the printed product
bound or every upstream claim, or establish novelty.
