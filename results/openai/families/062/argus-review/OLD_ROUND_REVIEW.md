# Complete retrospective review of old family 062 drafts

**Result:** retrospective review, not a new mathematical result.
**novelty_status:** `not_applicable`.
**Acceptance:** The native independent Reviewer accepted the substantive
five-unit assessment in handoff `029b49fe5c83`. Project-level exploratory
certification remains pending through the Host's final-submission path.

## Coverage and provenance

[`DRAFT_REVIEW_INDEX.json`](DRAFT_REVIEW_INDEX.json) accounts for **all 26**
manifest artifacts and the designated reference tooling: 13 reference files
(twelve TeX inputs and README), **34 distinct old claims / 45 versions**,
three contexts, nine distinct old assumptions, 27 evidence records, 23
ledger routes and 34 graph nodes. Each claim version has exactly one unit
owner, source/context/hash binding, proof/evidence references and dependency
mapping. Both empty lock files are explicitly excluded from mathematical
content. Source PDF/text pairs, compiler wrappers, repeated claim versions
and the manuscript symlink are not counted as separate results.

All 26 measured file sizes match PRIOR_DRAFTS.json. Nine are members of the
supplied preserved manifest and match its SHA-256 values; the other seventeen
have presence/size provenance, not preserved-byte identity. No snapshot was
reconstructed. The old workspace, old ledgers and manuscript sources remained
read-only, including during the unmodified checker replay.

The exact reference is the September 23, 2026 manuscript at revision
`4eaee87548250b2682affda7d05d947c05554bae`, identified by
`9100062/MANUSCRIPTS.json`. The comparator worker measured twelve of twelve
TeX hash matches, 146,579 bytes, in one pass without version-control access.
The detailed manifest comparison is in the outline report. A live symlink's
existence alone was not treated as revision evidence.

## All units and dispositions

| Unit | Assessment and exact scope | Reports |
|---|---|---|
| `free_line_inputs` | Both old claims supported as prose arguments: intrinsic positive quotient/annihilation and smooth dominant evaluation **given** a free covering family. Does not prove that such a family exists in the primitive case. | [report](draft_reviews/free_line_inputs/report.md), [verdict](draft_reviews/free_line_inputs/verdict.json) |
| `contact_value_descent` | Six old claim IDs, including all ten descent versions, supported as the exact geometric prose proof. All-sheet splitting, both divisor cases, actual transverse ramification germs, purity at nonclosed points and connected degree-one descent are assessed. No added restrictions on Y or p; no geometric kernel proof. | [report](draft_reviews/contact_value_descent/report.md), [verdict](draft_reviews/contact_value_descent/verdict.json), [sources](draft_reviews/contact_value_descent/sources.md) |
| `integer_order` | One old claim, three versions. Natural arithmetic is correct; v2's Boolean inequality translation fails; final v3 uses propositional Not and has matching old and fresh compiler evidence. Only the abstract integer-order obstruction is formalized. | [report](draft_reviews/integer_order/report.md), [verdict](draft_reviews/integer_order/verdict.json) |
| `cubic_ramification` | Three nonledger assertions for the fixed polynomial z^3-t are supported: exact discriminant -27t^2, smooth total curve, projection index 3. Not a counterexample, universal ramification result or global descent certificate. | [report](draft_reviews/cubic_ramification/report.md), [verdict](draft_reviews/cubic_ramification/verdict.json) |
| `classification_outline` | All 25 assigned version-1 records assessed: historical objective plus 24 programme assertions. Determinant and unmarked-tree arguments have elementary support; several implications have only conditional support. The remaining old classification and metric programme was not established. Each assertion has exact hypotheses, source locator, missing bridges and novelty/open disposition. | [report](draft_reviews/classification_outline/report.md), [verdict](draft_reviews/classification_outline/verdict.json) |

The outline is deliberately included rather than silently discarded because
its assertions occur in the ledger/graph. It is not falsely represented as
25 completed proofs or a fresh audit of every reference-manuscript theorem.
Conversely, an unresolved old Argus obligation does not refute that manuscript.

## Strongest prior result and reconciliation

The strongest relevant old result was already a local geometric proof of
`des:descent`, eight matching independent geometric judgments (two free-line
inputs plus six descent claims), nine matching independent source judgments,
and a narrower arithmetic compiler certificate with its own matching
independent judgment. This review does **not** substitute the earlier empty
umbrella ledger as its baseline or claim a mathematical improvement on that
result. Its improvement is complete retrospective coverage, exact source and
version reconciliation, explicit evidence limits and concrete dispositions
for the uncompleted programme.

All 18 old independent judgments by
`reviewer:copilot-cb07e28d5d45` are mapped to their actual subject hashes and
artifacts. Human report judgments are path-bound; the report's preserved
byte identity is separate. The old arithmetic certificate also binds actual
formal-source and fidelity hashes. It is reading material here, not a
mechanical certificate of the review claim.

Stored `citation_status.json` unchecked labels, graph open/false labels and
report/exact-certificate pending wording conflict with actual matching
supports records. They are not authority to ignore those records; undated
status files alone do not establish chronological order. None of the old
opinions is current native acceptance.

The exact manuscript comparator found no altered hypothesis or quantifier
in the old descent statement. Current independent source reading confirmed
the cited mathematical inputs but found two inherited citation-identity
errata: P1 splitting is on **printed p. 8**, not p. 7, and Serre's old
Numdam `/article/` URL is broken. Only the current ledger was corrected:
both inherited current assumptions were retired with reasons, and the same
propositions were independently attributed at the corrected page and
canonical DOI `10.5802/aif.59`. The old evidence remains untouched.
Supplementary-source authentication limits, including the labelled arXiv
copy's unexplained internal 2018 date, remain explicit.

## Actual computational and formal support

The unmodified old standard-library `verify.py` exited **0**. It computes
the cubic exactly and validates stored typed Jacobian and compiler records;
it invokes neither Lean nor Jacobian and does not check geometric prose.
The seven negative controls mentioned by the old report lack listed
per-control transcripts and are not claimed as freshly replayed.

A separate fresh official Lean run compiled the exact final arithmetic
source with compiler/audit exits **0/0**, no proof holes, and foundational
axioms `propext`, `Classical.choice`, `Quot.sound` only. Real Lean is
**4.31.0**, Lake **5.0.0-src+68218e8**; the assigned workspace's non-version-
control manifest declares Mathlib
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`.
This authenticates neither the old library tree nor a geometric theorem.
Only current reproduction claim `C_REPLAY_INTEGER` earned that mechanical
evidence. The fresh source and final fidelity note were not edited after
the successful run.

Exactly one fresh bounded Argus/Jacobian operation, after discovery and typed
contract inspection, returned the complete rational-polynomial discriminant
`-27*t^2`. The isolated adapter reports server **0.14.0**, protocol
**2025-11-25**, exit **0**, no timeout or structured error. Exact payload,
contract, typed output and statuses remain in the cubic unit's dedicated
JSON files. The operation has no global-descent or smoothness contract.

The initial old arithmetic failure was a different Boolean translation, not
a mathematical refutation. Its failed source/fidelity hashes do not match
v3. The actual old compile.log records final success. The current first
official replay also compiled but required a material fidelity-name
correction before its final fresh successful verification; both outcomes
are disclosed in the integer unit.

## Remaining mathematics versus review acceptance

No identified gap remains in the developed local descent proof at its stated
prose/standard-input scope, or in the narrow arithmetic/cubic assertions.
This is not a classification proof. In particular, free evaluation does not
produce the initial covering lines, descent does not construct the
moving-pair space and its full-family map, and neither a local order theorem
nor a cubic supplies boundary extension, jet transitivity, homogeneous
identification or metric recovery. The outline records the concrete missing
arguments, not a blanket claim that the source is correct or incorrect.

There is no new error search, repaired manuscript, classification theorem or
claim of novelty in this deliverable. The remaining project-level
certification action belongs to the Host-invoked native independent Reviewer.

## Whole-objective final submission

The persisted submission assessment is
[`DRAFT_REVIEW_INDEX.json#research_result`](DRAFT_REVIEW_INDEX.json).
It covers this synthesis, the complete index and all five report/verdict
pairs, without reopening their mathematical assessments. It declares
`result_class=literature_review`, `correctness_status=verified`,
`novelty_status=not_applicable`, `significance_status=exploratory` and
`statement_fidelity_status=not_applicable`. The last field concerns this
nonformalized retrospective claim; the old arithmetic theorem's fidelity
is assessed separately in its unit.

Current claim `C_REVIEW_F062` version 7 is supported by matching Engineer
and native independent judgments, with no stale evidence. The independent
support is `judgement-C_REVIEW_F062-0e11ef54eb8e`. The accepted substantive
handoff is
`$WORKSPACE/.argus-campaign-9200062/projects/237826985aca/handoffs/029b49fe5c83/round-0001.json`.
Its Reviewer returned `done` for all 26 artifacts and 45 claim versions.
That mission was `bounded`, and its completion event explicitly recorded
`final_submission_certified=false`; it is not project-final certification.
The pending acceptance labels in the unit verdicts preserve that distinction.

The installed `argus_skill.core.research_contract` accepts
`literature_review` with this novelty and exploratory significance at
`final_submission` scope. The previous bounded result's
`honest_final_report` class is not exploratory-terminal at project scope.
Changing the result classification records the nature of the deliverable,
not a new mathematical result or an increase in its evidence strength.

The submission block remains an Engineer assessment for independent
inspection. The installed Reviewer contract supplies the final
`RESEARCH_RESULT` output; only the Host's normal settlement of that native
verdict can record final certification. No certification flag, runtime
journal entry, stage certificate or Reviewer approval is authored here.
All existing source-provenance, prose-proof, arithmetic, cubic and unresolved
classification limitations remain in the submitted result.

## Campaign-local validation

Exact project root:
`campaigns/9200062`.

| Executed check | Interpreter | Exit / result |
|---|---|---|
| `research/review_inventory.py check` | `$WORKSPACE/argus-latest/.venv/bin/python` | **0**; all 26 artifacts, 45 versions, 27 evidence records, 23 routes and five unit assessments covered, no errors |
| `-m argus_skill.verticals.math.math_state check --project-root <exact root above>` | Same legacy interpreter | **0**, `issues=[]`, after final ledger judgments |
| `-m argus_skill.verticals.math.proof_graph_check check --project-root <exact root above>` | Same legacy interpreter | **0**, six current review nodes structurally valid, after final ledger judgments |
| `-m argus_skill.verticals.math.check --project-root <exact root above>` | `$WORKSPACE/argus-live-update/.venv/bin/python` | **0**, stage `review`, `issues=[]` |

The legacy environment has no `argus_skill.verticals.math.check` entrypoint;
the provided live interpreter ran that delivery gate. No framework or
environment was repaired. These successful checks do not set any native
Reviewer judgment or current `reviewer_confirmed=true` flag. There are no
outstanding compiler handles or durable jobs.
