# Complete review of the old Family 063 drafts

**The Engineer assessment covers all 14 listed artifacts, all 17 old claim
identifiers and all 24 claim-version records, with no unexplained omissions.**
The three units below each have a report and a machine-readable verdict.
This deliverable reviews existing work; it neither proves nor refutes a new
mathematical statement. **Native independent Host Reviewer acceptance is
pending.** `research_target_level=exploratory`;
**`novelty_status=not_applicable`** for the review's final research result.

The [coverage index](DRAFT_REVIEW_INDEX.json) was written before substantive
assessment. It accounts for every inventoried file, both old contexts, all
three routes, all seven old foundational assumptions and all 27 evidence
records. The latter are judgments, not kernel certificates. Four claim IDs
have assumption-only revisions; no revision, source text, repeated judgment
or typed protocol file is counted as another result.

| Unit | Assessment | Deliverables |
|---|---|---|
| `marked-descendant-bound` | The shared geometric prose argument supports the Fano point-descendant bound under the declared foundations. Its arbitrary-embedding/non-Fano and delta formulations are a proposed extension supported by the same reasoning, not separately certified originality. Nine claim IDs, sixteen version records. | [report](draft_reviews/marked-descendant-bound/report.md), [verdict](draft_reviews/marked-descendant-bound/verdict.json) |
| `exact-algebra-support` | The retained verifier passes all nine stated groups; the same Smith instance also has a complete live typed replay. Exact identities and bounded samples are distinguished, and neither certifies virtual geometry. One claim/version. | [report](draft_reviews/exact-algebra-support/report.md), [verdict](draft_reviews/exact-algebra-support/verdict.json) |
| `excluded-manuscript-chain` | Six manuscript claims remain explicitly unverified by the old proof: main Mukai theorem, free-degree density, recurrence, spectral tuple, trace extraction and equality geometry. Each is attributed and has a concrete uncovered obligation. This is scope accounting, not another manuscript-error search. | [report](draft_reviews/excluded-manuscript-chain/report.md), [verdict](draft_reviews/excluded-manuscript-chain/verdict.json) |

`C9000063@1` is the historical audit mission, not a mathematical theorem;
it is indexed and explicitly excluded as a separate draft result.
The zero-byte lock is the only purely administrative file exclusion.
The original manuscript/tooling is a reference input, not a new audit target.

## Mathematical conclusion and attribution

The supported bound is
\(\langle\tau_{d-2}(\mathrm{pt})\rangle_\beta\geq b^{-(d-1)}\).
For the original proposition, \(X\) is smooth complex Fano of pseudoindex at
least two, \(\beta\) has a nonconstant free representative, and
\(H=-aK_X\) is very ample, so \(b=ad\). The proposed extension allows any
very ample \(H\) and non-Fano \(X\), but **still assumes**
\(-K_X\cdot C\geq2\) for every irreducible rational curve and the free
representative. Under the stronger degree hypothesis \(\delta\geq2\),
its boundary image has dimension at most \(d-2-(\delta-1)u\).
No concrete gap was found in that scoped prose argument; it is not formalized.

The decisive geometric mechanism is the unobstructed free open, the ambient
marked-component contraction, preservation of the positive cotangent line
and stack stabilizers, strict boundary-image dimension, rational Chow
localization and weighted degree with its generic-gerbe factor. The unit
report checks those applications, including constant roots, covers, \(b=1\),
\(h=0\) and non-flat base changes. Standard geometry is declared as external
input, not credited to the finite script.

The exact supplied manuscript, author OpenAI, dated September 24, 2026,
revision `4eaee87548250b2682affda7d05d947c05554bae`, already contains the
same descendant-bound proof architecture. Relative to that source, the old
prose is a reconstruction/explication, not an established new Argus proof
contribution. The explicit generality is the relevant extension; no novelty
or publishable significance has been established for it. No failed attack,
counterexample or manuscript refutation is contained in the inventory.
Supporting this lower-bound input does not establish the downstream chain.

## Source and replay evidence

All fourteen input byte counts match the read-only inventory. The five
core files actually listed in the preserved snapshot manifest match its
existing size/digest entries; the nine others are not claimed to have that
snapshot authentication. All seven referenced TeX files match the supplied
manuscript revision manifest. Old drafts, ledgers, graph, sources, manifests
and preserved snapshot were not modified.

Nine current foundational/attribution assumptions were recorded **before**
substantive assessment and source delegation. The separate source reader's
readings were archived and attributed with the transcription provenance
explained in [source notes](draft_reviews/marked-descendant-bound/source_checks/source-notes.md).
`citation_check status` reports all nine confirmed and no blocking entries.
The official cited Stacks Vistoli summary is distinguished from the unread
original Vistoli PDF and from the proof's own stabilizer-rule derivation.
No new novelty survey was substituted for the review.

The original verifier ran read-only under
`$WORKSPACE/argus-latest/.venv/bin/python -B`, Python **3.13.5**,
with standard-library dependencies only. It returned `ok=true`,
`exact_checks=9`, exit **0**, empty stderr, no timeout, in **0.289100 s**;
all old input size/mtime metadata was unchanged. The live adapter used the
operator-required `argus-live-update` interpreter, discovered and inspected
`matrix.normal_form.smith.certified.compute`, and executed one 3 by 4
integer payload: server **0.14.0**, protocol **2025-11-25**, exact complete
transformations, exit **0**, no error/timeout. Local replay gives Smith
factors \(1,2,12\), coarse degree \(24\), generic stabilizer \(2\) and
stack degree \(48\). Full payloads, outputs and runtime records are in the
algebra unit. No Lean artifact occurs in the inventory.

Historical reviewer `supports` judgments are reading evidence. The old
graph's `open`/`reviewer_confirmed=false` flags are manual graph state.
The retained certificate's `independent_review=pending` is frozen metadata
that the verifier explicitly expects. None automatically overwrites the
others; none was rewritten to manufacture closure. Historical judgments
bind statement hashes rather than explicit version numbers or artifact byte
digests, so their dependency/provenance limits are retained in the index.

## Delivery checks and remaining authority

The coverage checker is `research/verify_review.py`; it verifies inventory,
claim/version/statement, context, assumption, route, evidence and per-unit
coverage against the actual old ledger and graph, plus the existence of all
reports/verdicts and the recorded computational scope. It does not purport
to machine-check the prose mathematics.

The checker exited **0**: 14 artifacts, 17 old claim IDs, 24 versions
(23 assessed and the historical mission explicitly excluded), 27 historical
judgments, three routes and all three report/verdict pairs were covered.
It continues to report `native_independent_review=still_required`.

Official structural checks use the exact current project root
`campaigns/9200063`, never the
shared batch root, and the explicit `argus-latest` interpreter.
`math_state check --project-root <that root>` and
`proof_graph_check check --project-root <that root>` both returned **0**
after the source-evidence ledger writes. After the final graph evidence update
and the Engineer's claim-linked `supports` opinion, the final handoff run again
returned **0** for each official check: no ledger issues and four valid graph
nodes. No node was self-confirmed by a Reviewer, and the Engineer opinion is
not kernel evidence or final acceptance.

The suggested umbrella command
`$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.check`
was probed once and reported `No module named argus_skill.verticals.math.check`.
It was not retried or repaired; the two available official campaign-local
checks above were used. An initially missing current review graph was added
without copying or changing the old graph; its nodes remain unconfirmed
pending native review, not falsely marked proved.

The remaining acceptance obligation is the Host-invoked independent
Reviewer's judgment of this **whole** indexed review. The six excluded
manuscript claims and extension novelty remain mathematically unverified in
the old work; resolving them is not required to complete the requested review
and would be a different task.
