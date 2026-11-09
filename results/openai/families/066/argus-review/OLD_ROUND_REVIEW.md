# Family 066: complete old-draft review

The Engineer has assessed all **11 grouped units**, reconciling all
**16 inventoried artifacts**, **15 distinct ledger/graph claim IDs** and
**26 historical claim versions**. This is a review of the existing Argus
work, not a new manuscript-error search or proof of either full manuscript.
**Native Host-invoked independent Reviewer acceptance is pending.**
The review result has **`novelty_status=not_applicable`**; each old claim's
separate novelty, attribution and audit-open status is in its unit verdict.

## Coverage and provenance

[`DRAFT_REVIEW_INDEX.json`](DRAFT_REVIEW_INDEX.json) maps every artifact,
claim version, assumption version, route, proof/checker and prior evidence
record. Counts are not interchangeable: the jet/local-ring argument is
one unit with two claims; the undeveloped main-theorem/scope records are
one unit; the failed route has no separate claim ID. `C9000066` is
explicitly excluded as old administrative mission text, and both empty
locks are excluded as mathematical content, without omitting them from
coverage. The manuscript source tree is reference input, not a new draft.

All 16 old-workspace sizes match the inventory. All ten inventoried files
present in the preserved snapshot manifest match its size and SHA-256;
the six absent entries are the two locks, compiler log, Jacobian
request/response and Lean submission receipt, not hash mismatches.
The two relevant manuscript sections and both introductions match
the reference manifest's hashes for revision
`4eaee87548250b2682affda7d05d947c05554bae`. No old input was edited.

## Every unit

| Unit | Assessment and supported scope | Paired outputs |
|---|---|---|
| `scalar-penalty` | Universal real scalar inequality supported; v3 freshly compiles. v1/v2 natural claims follow from the scalar argument, but v2 proof text is not retroactively compiler-certified. No geometry is formalized. | [Report](draft_reviews/scalar-penalty/report.md), [verdict](draft_reviews/scalar-penalty/verdict.json) |
| `jet-retraction-comparison` | Degree-linear logarithmic jet loss and simultaneous all-functions/volume comparison supported in the quasi-monomial, bounded-discrepancy, uniformly centred domain. An unrestricted valuation extension is not certified. | [Report](draft_reviews/jet-retraction-comparison/report.md), [verdict](draft_reviews/jet-retraction-comparison/verdict.json) |
| `competitor-sublevels` | Uniform small defect, bounded volume and positive centering for every relevant quasi-monomial competitor; no circular assumption of constrained attainment. Not exactness from convergence alone. | [Report](draft_reviews/competitor-sublevels/report.md), [verdict](draft_reviews/competitor-sublevels/verdict.json) |
| `boundary-encodings` | Both effective rational lc constructions preserve exactly the required zero cones and permit effective small perturbations, using resolved sufficiently general transverse members. | [Report](draft_reviews/boundary-encodings/report.md), [verdict](draft_reviews/boundary-encodings/verdict.json) |
| `uniform-exact-bridge` | The precise rational-coefficient compact-family theorem is supported. “Every height” in ledger shorthand must not be promoted to arbitrary irrational coefficients. Proposed compact-family strengthening has unverified originality. | [Report](draft_reviews/uniform-exact-bridge/report.md), [verdict](draft_reviews/uniform-exact-bridge/verdict.json) |
| `complements-exact-application` | Proposition `a:exact-penalization` reproduced in the complex local rational setting: actual minimizer, unique ray, finite generation and torus invariance. No global complement theorem or field descent. | [Report](draft_reviews/complements-exact-application/report.md), [verdict](draft_reviews/complements-exact-application/verdict.json) |
| `cartier-exact-application` | Rational realization part of `thm:E-exact-minimizer` reproduced. Does not verify its real-height continuity or central-slice conclusions, let alone uniform Cartier sections. | [Report](draft_reviews/cartier-exact-application/report.md), [verdict](draft_reviews/cartier-exact-application/verdict.json) |
| `ordinary-minimizer-inputs` | Known external results with applicable prior independent source reading. All ten versions mapped; v9's ambiguous/wrong dimension normalization is superseded by v10's filtration-index normalization. | [Report](draft_reviews/ordinary-minimizer-inputs/report.md), [verdict](draft_reviews/ordinary-minimizer-inputs/verdict.json) |
| `monomial-sharpness` | Exact infinite family proves degree dependence and failure of a uniform `o(e)` strengthening. Geometric formulas checked; not a finite search or manuscript counterexample. | [Report](draft_reviews/monomial-sharpness/report.md), [verdict](draft_reviews/monomial-sharpness/verdict.json) |
| `limit-only-route` | Retirement justified: `e(lambda)=lambda` satisfies the proposed small-defect bound but never vanishes. Refutes an inference, not either manuscript. | [Report](draft_reviews/limit-only-route/report.md), [verdict](draft_reviews/limit-only-route/verdict.json) |
| `manuscript-scope` | Both main theorems remain unverified and unrefuted by the old audit. The reduction/degeneration/rank/trace and central-transfer/character/pinning chains are concrete unreviewed obligations. | [Report](draft_reviews/manuscript-scope/report.md), [verdict](draft_reviews/manuscript-scope/verdict.json) |

## Evidence reconciliation and decisive replay

The strongest prior result already included independent human support
for the geometric bridge, its obligations, both rational applications
and sharpness. It was not just scalar compilation. The unchanged
source hashes and exact claim/assumption hashes make that evidence
reusable within its actual hypotheses; it is not current acceptance.
The old graph's all-open/all-unconfirmed labels do not mathematically
refute those arguments. Conversely, neither labels nor local
support establish either main theorem.

The historical `L_LC_ORDINARY` statement hash is unchanged across v1-v10,
but the assumptions accumulate and the volume-limit assumption changes
hash at v10. Its prior reviewer judgment supports the corrected
`length(R/I_m)/m^n`, not v9's “length/n^n” with `n` the dimension.
The scalar v2-v3 change is a proof-elaboration change; the archived
mechanical evidence binds v3 only. These are historical record/fidelity
distinctions, not newly discovered manuscript flaws.

Fresh bounded replay in
[`draft_reviews/scalar-penalty/replay/`](draft_reviews/scalar-penalty/replay/)
records four exact polynomial identities with zero residuals and a
successful read-only compilation of the unchanged old source:
Lean 4.31.0, commit `68218e876d2a38b1985b8590fff244a83c321783`,
Mathlib revision `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`,
exit 0 in 4.144668 seconds. The source and fidelity hashes match the
old immutable certificate. The fresh run did not repeat the historical
axiom audit or attach any kernel certificate to this review claim.
The exact-arithmetic replay used Python 3.13.5 and standard-library
`fractions.Fraction` through the explicitly assigned Argus interpreter.

One inspected Jacobian replay through the isolated live adapter,
`polynomial.box.enclosure.compute`, returned `[1/2,1]` for `1-t`
on `[0,1/2]`: server 0.14.0, protocol 2025-11-25, no timeout or
structured error. Exact payload and complete typed outputs are retained
in dedicated JSON files. This is arithmetic sanity evidence only.
The compiler log/result/certificate are one historical run plus its
axiom audit; the submission receipt is not a second proof.

The eight primary known-result inputs and their restrictions are
explicit in the ordinary-input report. Existing independent primary
excerpts are reused; no new paper retrieval or novelty search is
claimed. Old official citation-attribution records remain outstanding:
the preserved judgments are not falsely relabelled as native
`literature` records. The construction also exposes its fixed
characteristic-zero log-resolution/general-member setup assumptions.

## Active ledger and validation boundary

The coverage index was written first, then the active
`research/MATH_STATE.json` recorded the scoped archived inputs and
the retired limit-only approach before substantive unit assessment.
The active review is not a new kernel-certified mathematical theorem.
Its old certificate is reading material, not mechanical support for
`C_REVIEW_066`.

The campaign-local root is exactly
`campaigns/9200066`.
The official `math_state check --project-root` runs after scope
recording and after the final ledger judgments both exited **0**,
with no issues. The corresponding official
`proof_graph_check check --project-root` runs both exited **2**:

```
no proof graph at families/066/argus-review/PROOF_GRAPH.json
```

The active exploratory review has no proof graph, and that path is
outside the Engineer's authoritative writable paths. No graph was
invented, old graph copied, or shared batch root substituted to obtain
a passing status. The prescribed delivery module was also probed and
is absent from the required legacy interpreter:

```
$WORKSPACE/argus-latest/.venv/bin/python: No module named argus_skill.verticals.math.check
```

The exact commands used for the final official pair were, with the
explicit campaign root above:

```
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root campaigns/9200066
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root campaigns/9200066
```

Final measured statuses: **ledger 0; graph 2**. The requested pair of
zero statuses was therefore **not obtained**. Creating a graph outside
the authorized paths or modifying Argus is not a permitted repair.
This operational gate remains a handoff blocker, while the substantive
review and coverage artifacts are ready for native independent examination.

The final exact coverage/provenance validator,
`$WORKSPACE/argus-latest/.venv/bin/python research/draft_reviews/check_coverage.py`,
exited **0**: 16 artifacts, ten snapshot matches, six documented
non-archived entries, 15 IDs, 26 claim versions, 44 historical
assumption/version bindings, all 29 old evidence records, and all
11 report/verdict pairs in the summary. It also checked the exact
v3 ledger formal text against the compiled old source, the four
manuscript hashes, unchanged old inputs, parseable JSON and pending
independent-acceptance flags. It is not a substitute for the official
gate or native independent review. No failed execution or missing
access was used as a substantive unit assessment.

No manuscript source, old ledger, preserved snapshot, shared toolchain,
research target or framework was changed. No acceptance, publishable
novelty, full-paper certificate or new error search is claimed.
