# Family 072: complete old-draft review for native independent assessment

**Engineer assessment complete; native whole-family acceptance pending.**
This is an exploratory review, not a new manuscript-error search or new
mathematical result. `research_target_level=exploratory`;
`novelty_status=not_applicable`. Each old claim's separate attribution,
novelty, support, and open scope are recorded in its unit verdict.

## Coverage and provenance

[`DRAFT_REVIEW_INDEX.json`](DRAFT_REVIEW_INDEX.json) accounts for all
**18 artifact entries and the one reference-input/tooling entry** in
PRIOR_DRAFTS.json. It maps all **11 historical claim IDs in 23 versions**,
all 22 ledger evidence records, all seven ledger routes, and both old
contexts' mathematical roles. The old proof graph is explicitly used:
its ten nodes are open, its goal is `C9000072`, and its omission of
`C_AT_PRIOR` does not exclude that claim from this review.

There is one substantive affine-transport draft family, divided into
five argument-based assessment units, not eighteen independent results.
The two zero-byte lock files are excluded as nonmathematical; failed
and superseded compiler runs and overlapping success wrappers are
explained rather than counted as results.

All old workspaces, manuscript sources, and the preserved snapshot were
left read-only. The existing snapshot manifest was reused without
rebuilding or extracting its archive. All eighteen live files match
inventory byte counts. Ten also match their existing snapshot-manifest
digests; eight are live-only relative to that manifest. This comparison
does not independently certify the unextracted archive's member contents
or assign creation dates to live-only files.

The reference directory contains live symlinks to the two OpenAI source
trees dated September 24, 2026. All nineteen TeX entries match the supplied
MANUSCRIPTS.json revision manifest. That is a content comparison, not a
fresh Git verification. Their README authorship/date metadata, source
sections, illustrations, and bibliographies are references, not additional
Argus mathematical drafts; no original-paper PDF or unlisted Lean
comparator was replayed.

## All five units

| Unit and required files | Substantive assessment |
|---|---|
| [affine-transport/report.md](draft_reviews/affine-transport/report.md), [verdict.json](draft_reviews/affine-transport/verdict.json) | `C_AT_LAW`, `C_AT_ESCAPE`, `C_AT_PAIR`, `C_AT_COMPARE`, `C_AT_TRANSPORT`: coherent conditional prose proof of the shared law/escape/pairing/root-exception/box comparison chain. The actual density is dx dy/y, the affine inverse determinant is y^-3, and strict equality does not require a uniform gain. The law-construction threshold is strict; it does not supply p=2,beta=1 by dyadic cancellation. |
| [zero-jacobian-rigidity/report.md](draft_reviews/zero-jacobian-rigidity/report.md), [verdict.json](draft_reviews/zero-jacobian-rigidity/verdict.json) | `C_AT_RIGIDITY`: supported deterministic harmonic-barrier and reciprocal pre-Schwarzian argument. At k=1 the affine/real-vertex quadratic locus remains; at k=3/4 the barrier excludes equality. I already contains that special barrier. General-k priority is unresolved. |
| [critical-cauchy-law/report.md](draft_reviews/critical-cauchy-law/report.md), [verdict.json](draft_reviews/critical-cauchy-law/verdict.json) | `C_AT_QUADRATIC`, `C_AT_ENDPOINT`: the construction satisfies normalization, univalence, Borel probability, and exact all-Borel covariance. Tilted-measure translation invariance proves uniqueness on the rigid locus. Global classification additionally needs the entire transport/moment/rigidity reduction; it is supported as prose, not fully formalized, and not verified new. |
| [formal-core/report.md](draft_reviews/formal-core/report.md), [verdict.json](draft_reviews/formal-core/verdict.json) | `C_AT_FORMAL`: archived v1 failed on the missing noncomputable annotation; v2 and the fresh exact-source replay compile and pass the supplied axiom audit. The file proves abstract comparison/strict-gain lemmas, real endpoint algebra, and restricted quadratic injectivity, not the analytic classification. |
| [attribution-and-prior/report.md](draft_reviews/attribution-and-prior/report.md), [verdict.json](draft_reviews/attribution-and-prior/verdict.json) | `C_AT_PRIOR`, historical `C9000072`: exact BIPS v1 states the broader strict spectrum bound, but defers strict-proof details. Manuscript reconstruction, proposed strengthenings, and failed attacks are separated claim by claim. Bounded prior-art comparisons do not verify classification novelty or historical goal completion. |

These are Engineer judgements on the stated evidence. No unfilled
mathematical step was identified within the old analytic prose argument
after retaining its named classical inputs; that is not blanket
verification of the original papers or a machine proof of the analytic
theorem. The reports explain the actual decisive inferences so the
Reviewer can disagree at a specific step.

## Supported scope versus invalid or insufficient inferences

The strongest supported computational result is a replay of **exact
identities**, not a finite counterexample search or formal analytic
classification. The construction is an explicit probability law, not
empirical moment fitting. The Lean result is a proof of its encoded
supporting statements, not a proof strategy supplied by Jacobian.

Three important unsupported inferences are identified concretely:

1. `R_AT_MODULAR_ONLY` cannot refute transport by nonunimodularity alone:
   the displayed weighted density and ordered box limits are valid.
   The failed attack is not a flaw in the original manuscripts.
2. `R_AT_QUADRATIC_CORE` does not sufficiently reduce law construction
   and uniqueness solely to `C_AT_FORMAL`. Main.lean has no exact-law,
   affine-atom, tilted-measure, or uniqueness declarations. The missing
   sufficient dependencies are the Section 6 prose and pushforward
   identity, which this review separately assesses.
3. The old exact certificate's `new_theorem`/`C_AT_ENDPOINT` labels
   cannot promote algebraic identities to a formal theorem over all
   affine probability laws. The Lean endpoint reduction assumes the
   moment identity and nonpositivity as real-number hypotheses.

For a genuinely **full formal classification**, concrete remaining
obligations are exact-law construction, compact superlevels, the finite
index count, Borel strict pairing, root-exception transfer, the geometric
area comparison, moment differentiation, harmonic rigidity, and
measure classification. Their absence from Main.lean is not a claimed
counterexample to the prose proof. The current task does not repair
or extend that formalization.

## Attribution and unresolved priority

The p=1,2 transport mechanisms and I's k=3/4 barrier are manuscript
reconstructions. General-p transport, all-k rigidity, and unique critical
law classification are old proposed strengthenings, not `verified_new`.
The explicit affine-rebasing Koebe locus is not claimed to be a newly
discovered map family or a family of fixed-coordinate Koebe rotations.

BIPS v1 Section 1.4 supports `C_AT_PRIOR` as a statement already in the
literature before the old Argus result, not a fresh independent proof of
its deferred strict details. It also credits the OpenAI preprints.
A spectrum-exponent assertion is not silently equated with I's stronger
uniform estimate. The independently read statement and hypotheses are
preserved in the attribution unit and current literature archive.

The bounded existing-source comparison distinguishes snowflake
stationarity, restriction hull laws, and variance/spectrum results from
the exact inverse-square all-affine map law. Full Malliavin/Hallenbeck
comparison remains access-limited. The specific unresolved priority
question is equivalence of **covariance, normalization, support, and
uniqueness**, not merely whether a title mentions univalent measures.
No negative search is presented as proof of novelty.

The current review ledger records inherited Koebe/compact-family,
measure-theoretic, planar, and elementary complex/harmonic foundations,
the known failed approaches, and retrieval limitations. Original
textbook passages are retained as **uncited assumptions**, not fabricated
checked citations; the exact BIPS proposition has an independent
source-reader attribution.

## Replays and operational checks

| Evidence | Measured result and limit |
|---|---|
| [symbolic_replay.json](draft_reviews/formal-core/replay/symbolic_replay.json) | Existing checker passed 38 exact checks, exit 0, Python 3.13.5 / SymPy 1.14.0, 0.751 s. Argus-latest lacked SymPy; the separately probed existing SymPy interpreter was used only for the checker. No installation or old --write invocation. |
| [jacobian_result.json](draft_reviews/formal-core/replay/jacobian_result.json), [status](draft_reviews/formal-core/replay/jacobian_replay_status.json) | One inspected typed `matrix.symbolic.determinant.compute` replay, exact old JSON payload, server 0.14.0 / protocol 2025-11-25. Adapter exit 0, no timeout/error, output matches old result; determinant only. |
| [lean_verification.json](draft_reviews/formal-core/replay/lean_verification.json) | Exact old-source copy freshly compiled with Lean 4.31.0 and existing Mathlib; compiler/audit exits 0/0, no holes. Fresh certificate belongs to `C_REPLAY_FORMAL`, not the review claim. The first legacy wrapper invocation failed at float(None); explicit --timeout 300 resolved it without runtime edits. |

Authoritative project root for both official checks:
`campaigns/9200072`.
The successful durable replay already ran `math_state check` and
`proof_graph_check check` against this exact root with exits **0 and 0**.
Final post-recording checks against that same root also returned
**math_state exit 0** (`ok=true, issues=[]`) and
**proof_graph_check exit 0** (seven valid nodes).
The exact coverage check passed 18/18 artifact entries, 1/1 reference
entry, 11/11 claim IDs, 23/23 versions, 22/22 historical evidence
records, 7/7 routes, 2/2 contexts, and 5/5 report/verdict pairs; all
local report links resolve. `citation_check status` returned exit **0**
with `blocking={}` and A_REVIEW_BIPS independently confirmed.
The six explicitly source-only inherited assumptions/limitations remain
visible as `uncited`, not silently promoted to checked references.

The separately named delivery command
`$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.check`
was attempted and returned exit **1**:
`No module named argus_skill.verticals.math.check`.
It is not represented as a passing gate. No framework code was repaired,
and no accepted-review/framework-close failure has occurred that would
have a Host events.jsonl line to report.

## Acceptance boundary

All five report/verdict pairs and the complete index are submitted for
the native Host-invoked independent Reviewer to examine together.
Historical reviewer-labelled ledger opinions remain reading evidence;
the old graph's `C9000072` is not silently closed. The current graph
likewise retains reviewer_confirmed=false. The current review asserts
no new theorem and no certified manuscript refutation.

**Next owner: native Reviewer. Engineer self-acceptance: false.**
