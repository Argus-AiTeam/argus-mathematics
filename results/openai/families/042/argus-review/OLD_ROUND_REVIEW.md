# Family 042: complete old-draft assessment for independent review

**Engineer assessment is complete across the inventory; acceptance is pending
final project-level certification by the native Host-invoked independent
Reviewer against the entire `OBJECTIVE.md` contract at the exploratory research
target.** Eight artifacts represent one shared analytic draft and its supporting
records, divided into four mathematical assessment units. They do not represent
eight independent results. The accepted native handoff
`8e0c4598e8f4/round-0001.json` already confirms complete coverage, substantive
conditional sewing assessments, and the explicit broader unresolved obligations.
It also determines that an active proof graph is unnecessary for that bounded
objective. This submission preserves that decision and the accepted evidence;
it does not treat bounded acceptance as final project certification.

`DRAFT_REVIEW_INDEX.json` maps every artifact, 19 historical claim identifiers,
22 claim versions, both contexts, all four historical routes, and the 19-node,
23-edge proof-graph dependency structure. Every artifact has a disposition.
The zero-byte lock is nonmathematical; the certificate, verifier and paired
Jacobian files are shared evidence, not additional drafts. Source inputs and
other families' snapshot entries are explicitly excluded as Argus results.

| Unit | Assessment | Reports |
|---|---|---|
| `annular-sewing` | The exact degree-one annular-chain theorem is supported as a reconstruction in analytic prose. The assessment covers uniform infinite Fourier splitting, shear-conjugated Newton estimates, domains, all-stage induction, moving limits, composed-coordinate convergence and locally finite global coverage. It is not a kernel proof or an assertion about every K3. | [report](draft_reviews/annular-sewing/report.md), [verdict](draft_reviews/annular-sewing/verdict.json) |
| `effective-passive` | The explicit threshold and radius \(b=r/4\), and arbitrary passive complex-manifold dependence with uniformly bounded jointly holomorphic input data, are supported by the same construction. Symplecticity is relative to the active variables. Originality is not established. | [report](draft_reviews/effective-passive/report.md), [verdict](draft_reviews/effective-passive/verdict.json) |
| `failed-attacks` | The missing-shear-term objection is invalid; nonzero constant transverse drift violates exactness. The local exact Fourier family and saved Jacobian calculation support identities, not an admissible counterexample, exhaustive search, or entire-paper correctness. | [report](draft_reviews/failed-attacks/report.md), [verdict](draft_reviews/failed-attacks/verdict.json) |
| `manuscript-obligations` | Source/dependency scope is supported. Nine specific geometric or analytic obligations remain outside the sewing draft, including continued center buffers, the exact two-family criterion, trace gluing without normal thickness, and L-to-CAP in all source dimensions. The K3 main theorem is neither established nor refuted by this audit. | [report](draft_reviews/manuscript-obligations/report.md), [verdict](draft_reviews/manuscript-obligations/verdict.json) |

## Source and snapshot correspondence

The manuscript is OpenAI, *Every complex K3 surface is Oka*, September 23,
2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, as recorded
by the supplied `9100042/MANUSCRIPTS.json`. All 13 listed TeX sources,
both through the old staged path and the manifest source path, match the
existing manifest hashes. The staged directory resolves to that same
source directory. No source revision mismatch was found; no manifest was
rebuilt. The bibliography is not one of those 13 entries and is not
claimed to have been byte-bound. The author/date and revision are the
provided manuscript's attribution and manifest label, not a new verification
of institutional authorship, publication authenticity or a Git tree.

All eight old artifacts have their inventory byte sizes. The preserved
snapshot manifest contains five: the old ledger, graph, report,
certificate and verifier. All five match its recorded sizes and hashes.
The empty lock and the two Jacobian files have **no entries** in that
snapshot manifest. This is absent archival binding, not a measured hash
mismatch or evidence of changed mathematics. They are reviewed as the
read-only inventory inputs actually supplied; no archive was altered.

A separate bounded source-attribution reader obtained Chen-Gounelas
Theorem A at DOI `10.1017/fms.2022.24`, Xie-Zhao Theorems A/B/E at
`arxiv:2608.24392v2`, and Verbitsky Theorem 2.5 at
`arxiv:1708.05802v1`. The manuscript itself gives the first two
theorem-letter attributions. The primary-source scope and the separate
vector-stabilizer density obligation are explained in the broader report.
These external propositions are not black boxes in the sewing proof.
No exact infinite-chain novelty claim was checked or made. A targeted
wiki-index search found no relevant inherited K3/sewing page; the old
report's unsuccessful precise-theorem lookup is historical data, not a
new finding of novelty.

## Actual computation and its limits

The required unchanged read-only `verify.py` replay passed **146 checks**
with exit zero in 0.262347 seconds. The initial required-interpreter run
failed because SymPy was missing. The successful run used that same
`argus-latest` interpreter, Python 3.13.5, with the existing live-update
SymPy 1.14.0 and mpmath 1.3.0 exposed read-only through `PYTHONPATH`.
No installation, old-input edit, shared-environment modification or
replacement checker was used.

[checker-replay.json](draft_reviews/failed-attacks/checker-replay.json)
records the exact command, actual paths, failure, stdout and limits.
The saved `polynomial.map.jacobian` evidence was reused, not rerun;
its original payload/output files remain dedicated JSON inputs.
Its recorded server/protocol are `0.14.0` / `2025-11-25`, with a
complete \(2\times3\) typed derivative and recorded zero exit, no timeout
and no errors. The fresh checker independently checks all six derivatives
and the payload binding, not the historical execution provenance.

Crucially, the verifier never reads the analytic report. Scalar identities,
typed-data consistency and selected source-fragment matches do not
certify Cauchy estimates, domains, convergence, global coverage, passive
holomorphicity, or statement fidelity. Those were assessed as prose.
There is no Lean source, fresh compiler evidence or proof-kernel claim.

## Reconciliation with the strongest prior result

The old report already claimed a complete uniform sewing proof and the
same effective/passive strengthening. This review supplies no stronger
mathematical theorem. It examines that strongest argument rather than
substituting a failed attack or algebraic pass, preserves the source's
exact hypotheses, and makes the broader unresolved dependencies explicit.
The certificate's `new_theorem` label and historical judgements are not
inherited as novelty, publishability or current acceptance.

The five analytic auxiliary nodes belong to the sewing unit, not five
additional discoveries. The effective and passive claims reuse that
proof. The four versions of `C_SCOPE_EXTERNAL` change assumptions, not
their assertion. The historical adversarial objective is not a theorem.
Every unresolved broader claim has a concrete mathematical obligation
in its report and parseable verdict; none is disposed of merely by
missing access or a failed run.

## Campaign-local validation and handoff

The active `research/MATH_STATE.json` records review claims, cited local
scope assumptions, and the documented failed routes with mathematical
retirement reasons. It does not import historical acceptance or modify
the old ledger. Current review assertions are opinions supported by the
unit reports, not additional mathematical discoveries. The retired
`R042_OLD_SHEAR`, `R042_OLD_DRIFT`, and `R042_OLD_BOUNDED_FLUX` routes
record the explicit obstructions described in the failed-attacks unit.

The exact checked root was:

```text
campaigns/9200042
```

In the accepted prior handoff, after the ledger writes, both official commands
were run once at that root:

```bash
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root campaigns/9200042
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root campaigns/9200042
```

The ledger check exited **0**, stdout `{"ok": true, "issues": []}`,
with empty stderr. The graph check exited **2**, with no stdout and stderr:

```text
no proof graph at families/042/argus-review/PROOF_GRAPH.json
```

No check against the old or shared batch root was substituted. Accordingly
**two zero exit statuses cannot be claimed**. The accepted native Reviewer
decision states: "The absent active graph is not required by this bounded
objective." This resolves the prior handoff's applicability question; the
historical exit 2 remains recorded as a failure, not relabelled as a pass.
`campaign.json` identifies this project as an exploratory `old_draft_review`,
not an independent counterexample search. The live objective expressly forbids
adding the graph already deemed unnecessary. The complete old graph remains
covered in the index.

No mathematical analysis, computation, source input, claim ledger, or graph was
changed for this final-scope submission. The accepted checker replay, source
readings, and validation results above are reused without repeating unchanged
runs. Only the index and this summary's certification scope and stale graph-gate
wording have been reconciled with the actual prior native decision.

The independent coverage-consistency measurement exited **0**: all eight
artifacts, four reports and verdicts, 19 old claim IDs / 22 versions,
19 graph nodes / 23 edges, and nine concrete broader obligations reconcile.
Every verdict retains required, unaccepted independent-review status.

`citation_check status` exited **0**, reporting no blocking registry-backed
citations and nine **uncited** prose-source assumptions. Those assumptions
cite the provided local manuscript/drafts or explicitly identified
classical background, without a registry identifier. In particular the
external-attribution assumptions are assertions about the local source's
scope, not importation of the external theorems into sewing. The bounded
primary-source readings are reported in the broader unit; they are not
misrepresented as `citation_check attribute` certificates or kernel evidence.

The requested native determination is whether `PRIOR_DRAFTS.json`,
`DRAFT_REVIEW_INDEX.json`, all four unit reports and verdicts, this summary,
and the accepted handoff
`$WORKSPACE/.argus-campaign-9200042/projects/9987b796f0b9/handoffs/8e0c4598e8f4/round-0001.json`
together satisfy **the entire `OBJECTIVE.md` acceptance contract at
`research_target_level=exploratory`**. This is certification of a complete,
substantive old-draft review, not certification of the K3 theorem, novelty,
publishability, or resolution of the nine broader mathematical obligations.

If satisfied, the independent Reviewer must have final project-level
certification persisted and recognized through the normal Host pathway, rather
than recording another bounded-only acceptance. If not satisfied, the decision
must identify the specific unmet objective criterion and evidence needed.
Engineer does not issue this certification or set the unit verdicts to accepted.
No new manuscript-error search, theorem-solving project, formalization, or
self-acceptance is part of this submission.
