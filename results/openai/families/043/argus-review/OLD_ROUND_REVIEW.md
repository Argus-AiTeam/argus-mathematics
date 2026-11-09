# Family 043: review of the old mathematical drafts

**The complete five-unit old-draft review received native independent
exploratory acceptance.** The Reviewer granted final certification in
`handoffs/284c719bf4f8/round-0001.json`; `events.jsonl:509` records the
independent findings. Acceptance covers the old-draft coverage and assessments,
not full P=W or whole-manuscript correctness. Framework completion admission
is not asserted. The command results below describe the earlier Engineer
submission, not current citation-attribution or independent-acceptance status.

## Coverage and provenance

[`DRAFT_REVIEW_INDEX.json`](DRAFT_REVIEW_INDEX.json) maps all **17**
`PRIOR_DRAFTS.json` artifacts, the manuscript reference/tooling tree
(one directory containing one manuscript-source symlink, thirteen files),
all **17 historical claim IDs / 27
claim versions**, three context versions, ten distinct cited assumptions
in thirteen claim-version instances, all **36 historical opinion records**,
five routes, and fifteen proof-graph nodes with their dependency sets.
Each supporting file, copy, absent referenced PDF and non-result has an
explicit disposition. The old lock file is infrastructure, not a draft.

The old source root is
`campaigns/9000043`.
The preserved snapshot manifest is dated 2026-11-06T10:20Z. The reference
manuscript is OpenAI's 2026-09-24 fixed-determinant composite-rank preprint,
registry-reported revision `4eaee87548250b2682affda7d05d947c05554bae`.
Those are provenance claims, not a fresh Git or snapshot-integrity check.
No old source, ledger, snapshot, manifest, or manuscript source was edited;
all seventeen current source sizes still match the input manifest.

The manuscript source symlink is the nested
`research/openai_manuscript/P-equals-W-in-composite-rank-for-fixed-determinant-September-24-2026`,
not its parent directory. Exact graph locators, the symlink target, and
all thirteen source-file sizes were checked; the index's file list is
relative to that title subdirectory.

Arguments, not filenames, define the units. The general transfer theorem,
its moduli application and its executable algebra share one old report but
have different scopes. Embedded adapter data are not additional results.
The manuscript source is a reference for the target and outstanding
dependencies, not a fresh manuscript-error-search assignment.

## Every substantive unit

Each linked directory contains both `report.md` and `verdict.json`.

| Unit | Engineer assessment | Exact supported scope / remaining duty |
|---|---|---|
| [General finite-etale transfer](draft_reviews/finite-etale-transfer/report.md) | Supported conditional prose theorem | Smooth separated finite-type family over a smooth complex base, prescribed relative torus-affine closed refinements, and one common-class/common-center auxiliary filtration. All finite-cover components are retained. Rational MHS/Lefschetz assertions coexist with integral local constancy and **natural** base change; integral pullback isomorphisms are not claimed. Applications must supply those exact geometric hypotheses. |
| [Full fixed-determinant Betti curious Lefschetz](draft_reviews/full-betti-lefschetz/report.md) | Supported full-cohomology prose application | For \(g\ge2\), composite \(n\ge4\), \(\gcd(n,d)=1\), full rational cohomology is Hodge--Tate and \(e^i:\operatorname{Gr}^W_{2R-2i}H^m\to\operatorname{Gr}^W_{2R+2i}H^{m+2i}\) is an isomorphism, \(R=(n^2-1)(g-1)\). Includes nontrivial \(\Gamma\)-characters; it is not just invariant cohomology and not full P=W. |
| [Koszul/Kummer certificate](draft_reviews/koszul-kummer/report.md) | Universal identities and finite example replay exactly | \(Dh+hD=I\) for the stated blocks with a central unit, plus universal weight-polynomial arithmetic. Separately, one \(n=4,g=2\) cover has 32 components, 32 surviving characters (31 nontrivial), 224 acyclic characters, Betti numbers \((32,64,32)\), and Smith factors \((1,2,4,4)\). No geometry is machine-checked. |
| [Collision-only objection](draft_reviews/collision-objection/report.md) | Correctly retired failed attack | The distinct-last-eigenvalue hypothesis of Mellit Theorem 7.5 does not disprove the different flagged relative statement in Proposition 8.7. This retires the Argus inference; it does not refute an original manuscript assertion or certify the entire paper. |
| [Full-P=W boundary and known baselines](draft_reviews/full-pw-boundary/report.md) | Known results attributed; proposed strengthening unresolved, not refuted | All-rank GL P=W and prime-rank SL results do not settle composite-rank variant P=W. One actual common lowerer on full cohomology, simultaneous perverse/weight bounds, the double commutator and all comparison identifications remain to be established by the separate route. |

The positive transfer proof uses componentwise torus-cover pullback,
strict localization, Thom shifts and integral derived Verdier duality.
The Betti application additionally checks the actual determinant-root
torsor, weight-four transport, the signed flag correspondence
\(AB=(-1)^b n!\,\mathrm{id}\), low cohomology and homogeneous Jordan-string
tensor cancellation. Their decisive arguments and hypotheses are in the
reports, rather than replaced by historical status labels.

All middle weights in the shift ledger are **actual** weights until
explicit conversion to half weights:
\(\delta+2b\to\delta\to\delta-2b\), then center
\((\delta-2b)/2-g=R\), where \(\delta=2R+2b+2g\).
This distinction and retention of every cover component are necessary to
the claimed full-cohomology scope.

## Literature, versioning, and unresolved mathematics

[Primary-source readings](draft_reviews/full-betti-lefschetz/primary_sources.md)
identify the published Mellit locators and the exact versions
`arxiv:2002.03336v1` and `arxiv:2209.02568v2`.
The Maulik--Shen published abstract was accessible; its full-text redirect
was not. The versioned primary preprint supplies the coprime setup.
Deligne and Saito passages and the coefficient-sensitive Verdier formulas
were read from the retained old text/image sources. Missing referenced
PDFs are explicitly disclosed, not treated as either proofs or disproofs.

Mellit's relative refinement bases are products with the parameter space;
this is not a claim that every total vector bundle is globally trivial.
Proposition 8.7 alone is not a smooth-morphism theorem. The old report
supplies a separate commutator-submersion/free-quotient argument.
Only the weight-four image is transported; section 8.5 says the class
is flat modulo \(W_2\), not necessarily flat as an entire degree-two class.
These qualifications preserve, rather than expand, the argument's scope.

For full P=W, old `L_COMMON_LOWERING` still asks for a degree-\(-2\)
operator on the **same full cohomology** with
\[
fP_k\subset P_{k-2},\qquad fW_j\subset W_{j-4},
\qquad [[f,e],e]=-2e.
\]
The logarithmic restriction, moving-pole translation, diagram-weight,
Hitchin specialization and lattice Riemann--Roch identifications must
deliver those equations, including on nontrivial deck-character summands.
Then `L_COMPARISON` must apply with the specified normalizations.
The Betti transfer proof and Koszul contraction do not discharge these
duties. They were not pursued as a new proof project.

The strongest prior positive result already asserted the full Betti theorem.
This review makes **no mathematical strengthening** of it. Its improvement
is complete claim/version/evidence coverage and explicit separation from
the unresolved stronger theorem. None of the units establishes novelty or
priority. The known inputs retain their original authors; no
`verified_new` or publishable-breakthrough claim is made.

The review itself asserts no new mathematics, so its review-level
`novelty_status=not_applicable` follows `OBJECTIVE.md`. The earlier Reviewer
outcome at `events.jsonl:509` recorded `novelty_status=unverified`; that
historical record is unchanged. Neither this clarification nor independent
acceptance changes any historical claim's separate novelty assessment.

## Exact replay and actual environment

The required old script was run read-only, without `--write-certificate`:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python -B families/043/first-pass/determinant_cover_transfer/verify.py
```

Its actual exit was **0**, output `verified_exact_core`.
The recorded environment is CPython **3.13.5**, GCC 11.2.0,
Linux `6.8.0-1068-azure-x86_64-with-glibc2.35`; the verifier uses only
the standard library, with bytecode writes disabled.
The [Koszul unit](draft_reviews/koszul-kummer/report.md) links the exact
stdout, toolchain and exit records.

One inspected bounded Jacobian Smith operation was also replayed through
the required `argus-live-update` isolated adapter, never by importing
Jacobian into Argus. Dedicated JSON files preserve operation
`matrix.normal_form.smith.certified.compute`, exact payload, complete typed
output, server 0.14.0, protocol 2025-11-25, exit 0 and 45-second bound.
The existing historical `check_jacobian` function verified its complete
unimodular transformations. This is supplementary replay of the same
example, not a new checker or new mathematical search.

No Lean source is among the family inputs, so no compilation or
statement-fidelity certificate is asserted. Exact Python algebra is not
kernel certification of geometry.

## Engineer-submission ledger and command results (historical)

At Engineer submission, `research/MATH_STATE.json` recorded a new review
context, eight selected assertions, all ten reused cited assumptions with their original
`filed_by=engineer:copilot` attribution, the collision route's explicit
retirement reason, and **Engineer opinions only at that point**. The official
typed model produced the serialization; it was published to the owned
JSON path without creating the CLI's out-of-scope sibling lock file.
No derived status was typed in, and no old Reviewer opinion was
relabelled as current independent or mechanical evidence.

The old ledger's 36 opinions and the old graph's open,
`reviewer_confirmed=false` labels are both preserved in the coverage
assessment. Their disagreement does not by itself decide mathematical
correctness or current family acceptance.

At that submission, both official checks were run with the explicit
`$WORKSPACE/argus-live-update/.venv/bin/python` interpreter,
against **exactly**
`campaigns/9200043`:

| Official command module | Actual exit | Result |
|---|---:|---|
| `argus_skill.verticals.math.math_state check --project-root <above>` | **0** | `{"ok": true, "issues": []}` |
| `argus_skill.verticals.math.proof_graph_check check --project-root <above>` | **2** | No `research/PROOF_GRAPH.json` at this campaign root |

At that submission, the active graph path was outside the mission's writable
paths. The inspected checker exposed no alternate graph-file or allow-missing
option. No new graph was invented, no sibling mission's file was altered,
no old graph was substituted under another root, and no two zero exits were
claimed. The subsequent Reviewer explicitly found the absent active proof
graph **not to be a mathematical defect in this review task**. That finding
does not turn the historical exit 2 into a passing check or establish
framework completion admission.

At Engineer submission, `citation_check status` also returned exit **1**:
all ten reused cited assumptions were formally `unchecked` in the new ledger.
No independent attribution record had been imported or fabricated; this did
**not** mean the primary readings were skipped. The inspected `attribute`
command necessarily archives into `research/literature/`, outside the
then-assigned paths. No source was downgraded or assumption removed to hide
that submission-time queue.

Independent attribution was subsequently supplied: `events.jsonl:509`
records **ten confirmed independent citation attributions**, five supporting
and three inconclusive independent claim opinions, independent matching of
all 17 artifacts and 27 claim versions, and checking of the decisive prose
arguments. These are the subsequent independent findings, not a relabelling
of historical Engineer opinions. The handoff and event references are under
`$WORKSPACE/.argus-campaign-9200043/projects/d4b3b5732d24`.
