# Family 041: complete old-draft coverage, scoped Engineer assessments

The review covers **all 57 artifacts in `PRIOR_DRAFTS.json`, all 21 versions
of the ten legacy claim IDs, all 25 legacy evidence records, both old
routes, and both reference manuscript packages**. There are ten substantive
review units, not ten new theorems. Every unit has `report.md` and
`verdict.json`; `DRAFT_REVIEW_INDEX.json` maps the full inventory,
claim/evidence versions, dependencies, alternatives, duplicates, sources,
and justified exclusions.

The research target remains **exploratory**. These are Engineer findings
submitted for the native Host-invoked independent Reviewer, not accepted
family conclusions. No new manuscript-error search, originality claim,
manuscript correction, or paper was undertaken.

## All-unit assessment matrix

| Unit and report | Legacy versions | Exact supported scope and remaining boundary |
|---|---|---|
| [Cartier-adjoint](draft_reviews/cartier-adjoint/report.md) | `C_ADJOINT@1-4` | The explicit conditional field/subring theorem is reproduced with a fresh hole-free Lean run. Supplied p-basis/Cartier data, the scalar identity and regular map formula are hypotheses; their geometric construction is not compiled. |
| [Differential identity](draft_reviews/differential-identity/report.md) | `C_DIFF@1-3` | The Hodge-module/Spencer and semisimplicity argument supports ordinary differential generation on the specified characteristic-zero charts. Application in characteristic p is conditional on simultaneous retention of the finite identities, denominators, etale locus and connection data. |
| [Frobenius trace and lift](draft_reviews/frobenius-trace-lift/report.md) | `C_TRACE@1-3` | Relative duality, the horizontal p-power lift and absolute trace give the scalar identity and `psi(r)=C_u(sr)` under their precise generic smooth-proper and compatibility hypotheses. Nonzero Cartier normalization remains a separate retained input. |
| [Completed trace](draft_reviews/completed-trace/report.md) | `C_COMPLETION@1-4` | The rational-scalar completion argument works with excellent normal completion, separability, common p-basis, regular base coefficients and branch degree `d<p`. Its final contradiction uses `d*delta` a unit. This is an alternative proof of the same clearing consequence, not another downstream theorem. |
| [Clearing application](draft_reviews/clearing-bridge/report.md) | `C_CLEARING@1` | Given those retained inputs and `psi(1)=delta` in `k*`, the explicit multiplier is regular at the chosen point and has image exactly `delta`. This is not arbitrary-module coefficient base change or existence of all retained reductions. |
| [Boundary controls](draft_reviews/boundary-controls/report.md) | Unledgered section of the shared draft | The nonregular coefficient and p-th Hasse-derivative examples exclude proposed extensions. Both violate the manuscript's actual operator hypotheses; neither is an admissible counterexample. Finite diagnostics and one QQ derivative were reproduced within their actual contracts. |
| [Semiampleness](draft_reviews/semiampleness/report.md) | `C_SEMIAMPLENESS@1-2` | Soldatenkov-Verbitsky v3 gives conditional propagation from an existing semiample pair/locus. It does not construct an initial semiample deformation in the prescribed class. This is a known-result attribution, not a new semiampleness theorem or a refutation of SYZ. |
| [Ordinary coefficient base change](draft_reviews/ordinary-base-change/report.md) | `C_ORDINARY@1` | Partial support: actual tensor-compatible homotopy equivalences would suffice for every ordinary module. Coefficient realization, chain-level Cartier splitting and simultaneous ordinary descent on overlaps/thickenings are concrete obligations beyond the old clearing certificate. |
| [Projective-space base](draft_reviews/projective-base/report.md) | `C_PROJECTIVE@1` | Unresolved globally. The old certificate does not establish residual tensor/stratum Euler calculations, fixed-base deformations, the rank-four cases, an actual abelian cover and stabilizer/inertia elimination needed before the smooth-base theorem. No false theorem is identified. |
| [Strong SYZ](draft_reviews/strong-syz/report.md) | `C_SYZ@1` | Unresolved globally. A prescribed-class polarized degeneration, quantitative full-cylinder extension, convergence in the actual logarithmic charts, angular-marked torus isotopy, rotation and a same-class semiample seed remain concrete obligations. An abstract or unmarked torus and propagation alone do not supply them. |

There are seven supported **qualified scopes**, one partially supported
broader argument and two unresolved global claims. The report-specific
hypotheses control those labels. "Supported" never means that every
geometric hypothesis has independently been constructed or that a
manuscript theorem was verified.

## Coverage and provenance

All listed old-workspace sizes match the input inventory. The eleven
Family 041 members of the 2026-11-06T10:20Z archive exist and match both
the preserved manifest and the old workspace. The remaining 46 listed
artifacts are explicitly marked old-workspace supplements, not falsely
represented as archive members. Other families in the global archive
manifest are outside this assignment.

The two `research/openai_manuscript/` entries are symlinks to the source
directories assigned by the reference `MANUSCRIPTS.json`, revision
`4eaee87548250b2682affda7d05d947c05554bae`. All 22 declared TeX source
files matched that manifest. The complete reference inventory also
accounts for two README metadata files and two bibliographies.
Reference versions are not historical Argus snapshot contents.
The old workspace, archive, manifests, sources and old ledgers were not
modified, rebuilt or used as writable compilation targets.

The two empty locks are operational, not mathematics. `C9000041@1` is
the old disjunctive audit objective, not an eleventh theorem or a current
instruction; its contents map to the broader units and its exclusion is
explicit. Multiple claim versions, compiler certificates, HTML/text
renderings, compilation summaries and submission receipts are not
additional results. The shared `proof.md` is partitioned by argument,
and the two clearing routes are not double-counted.

## Formal evidence, finite experiments and citation evidence

The strongest prior result is the final `C_ADJOINT@4` theorem. Versions 2
and 3 have inconclusive failed compiler records; the final version
succeeds. The new official run reproduces that same source and fidelity
document without strengthening the theorem.
Its certificate is
`draft_reviews/cartier-adjoint/replay/fresh/certificates/RV_ADJOINT-5c13ad9f38695718.json`.
Compiler and axiom audit exited 0, `proof_holes=[]`, using Lean 4.31.0
and the existing Mathlib workspace; recorded duration was 16,695 ms.
Both concluding declarations use only `propext`, `Classical.choice`,
and `Quot.sound`. Compiler axioms, explicit mathematical hypotheses,
human statement fidelity and geometric instantiation are separate
questions. The human reading in this round is an Engineer judgement,
not independent approval.

The isolated runtime ledger carried the exact current claim reference.
Only the actual record produced by `verify --claim RV_ADJOINT` is reused
in the active ledger, with its artifact reference rooted in this campaign.
The immutable certificate retains the isolated replay root for its own
relative source/fidelity paths. No compiler verdict was typed into
existence and no historical certificate was relabelled as a fresh run.

The inspected old checker was imported only from an isolated current
copy with bytecode writes disabled. Its finite functions reproduced
10 derivative, 75 word-adjoint, 208 Laurent coefficient, 3,158 tame
monomial trace and 10 reported control-group checks. Its normal
entrypoint, which would compile the same unchanged source again, was
not run. The fresh native compiler run is the universal formal evidence;
the bounded loops are not.

Jacobian discovery and contract inspection preceded one bounded replay
of `polynomial_field.scalar.directional_derivative.compute` through
the required **argus-live-update** adapter interpreter. The exact old
QQ payload returned `3*u^2*v^2`, server 0.14.0, protocol
`2025-11-25`, exit 0, no structured error/timeout, runtime 21 ms.
Dedicated JSON files preserve the schemas, payload, output and status.
This operation does not encode the Cartier or completion problem.

The active ledger recorded the exact inherited cited assumptions and
the inherited-evidence/excluded-hypothesis limitations before substantive
assessment. Eleven unchanged literature artifacts were retained with
their original producers: three registry-only inconclusive resolutions
and eight historical independent proposition readings. Source-mediated
assessments checked the propositions and application hypotheses;
registry existence was not promoted to attribution.

The sources are Saito `arxiv:1605.00435v3`, Theorem 1.4 and the named
strict-support/left-right/Spencer sections; Deligne
`doi:10.1007/BF02684692`, Conditions 4.2.2, Proposition 4.2.5(iii) and
Theorem 4.2.6; the exact archived Stacks Frobenius, duality,
completion, excellence and henselian propositions; and
Soldatenkov-Verbitsky `arxiv:2409.09142v3`, Theorems 3.7(v) and 3.8.
Stacks evidence uses the archived texts and recorded retrieval date,
not an invented upstream source revision. Source propositions do not
independently certify the manuscript's geometric instantiations.
No fresh native Reviewer identity is attributed to the old readings.

## Structural checks and handoff boundary

The authoritative root used for checks is
`campaigns/9200041`,
never the shared batch directory. Argus mathematical-state commands use
`$WORKSPACE/argus-latest/.venv/bin/python`.

The scope-stage official `math_state check --project-root` exited **0**,
with no issues. The official `proof_graph_check check --project-root`
exited **2** because this campaign has no `research/PROOF_GRAPH.json`.
This is an exploratory old-draft review, not a newly targeted
counterexample route; a current proof graph is also outside this
mission's authoritative writable paths. No substitute graph was
invented, no old graph was copied into active authority, and no claim
that both official checks passed is made.

After the final active-ledger update, mathematical-state validation again
exited **0** with no issues; coverage validation exited **0**, confirming
57 artifacts, 21 claim versions, 25 evidence records, ten assessments,
zero unexplained omissions and zero duplicate claim results.
All eight cited proposition checks are confirmed and the citation work
queue is empty; the two local scope/attack limitations are transparently
`uncited`, not pending literature lookups. The proof-graph check again
exited **2** for the same missing, unowned path. Exact commands, root
and outcomes are persisted in the index.

If the Host applies the independent-counterexample
campaign's two-zero-exit graph gate to this scope review, that gate
remains an authorization/structure blocker for the appropriate owning
role; it is not evidence for or against any mathematical claim and
must not be repaired by unauthorized output substitution.

`draft_reviews/review_inventory.py check` reconciles the complete
inventory, legacy claim/evidence coverage, distinct unit mapping,
per-unit assessment files and concrete unresolved obligations.
The native independent Reviewer must inspect both this coverage and
the substantive reports, decide findings and family completion, and
resolve the applicable handoff gate. Engineer has not self-accepted
any finding or the family.
