# Review of the old mathematical drafts

**Final exploratory submission: all 239 inventory artifacts and 24 claim versions are covered by seven report/verdict pairs.** Native whole-project review `451502dea011` accepted that dossier; native reconciliation review `71de3214912b` subsequently accepted the correction of five evidence bindings. This submission presents the corrected evidence and adds the requested [family synthesis](FAMILY_REPORT.md), which was absent, using those unchanged assessments. Renewed whole-project acceptance and Host certification are requested, not claimed; there is no new mathematical result or error search.

## Objective-to-evidence mapping

| Requirement in `OBJECTIVE.md` | Existing evidence submitted for the whole-project decision |
|---|---|
| Review every substantive old draft; preserve the old workspace and snapshot; do not follow old objectives | `DRAFT_REVIEW_INDEX.json` maps all 239 inventory paths to seven units. Its `source_preservation` records the existing read-only comparison. The historical audit objective is explicitly excluded as a theorem; no old writing entrypoint was executed. |
| Map every claim and its proof/checker/evidence; explain dependencies, duplicates and exclusions | The index contains 24 claim versions, 17 historical evidence records, seven ledger routes, two graph routes, 20 graph nodes, 92 source/object pairs and 81 named symbolic checks. Its artifact roles, unit dependencies, `deduplication` and `excluded_claims` prevent copies and supporting files from becoming extra results. |
| Supply a report and verdict for every unit, with exact claims, hypotheses, source/version and attribution | All seven pairs are linked in the unit table below and indexed by path. The reports state their quantifiers and hypotheses; the provenance unit identifies the supplied manuscript revision and attribution. |
| Check decisive arguments and replay relevant computations or formal proofs where possible | The unit reports contain the substantive arguments, including September and the full surface family. The index's `checker_map` and the replay table below identify the existing 81-check algebra replay, Lean wrapper replay, source audit and bounded Jacobian calculation, with their actual scope and outcomes. |
| Distinguish support, partial support, invalid arguments and unresolved obligations; separate reproductions, failed attacks and proposed strengthenings | The per-unit verdicts distinguish six scope-qualified supported mathematical assessments from partial provenance/known-status support. The failed historical v2 formal artifact is not accepted. The three extensions are compared with the inspected October statements, not claimed globally new. The citation correction concerns Argus commentary, not a refutation of an original manuscript. |
| Separate Lean compilation, statement fidelity, exact theorem scope, toolchain and external assumptions | The obstruction report's declaration/dependency map and the formal-evidence boundary below distinguish eight printed axiom roots from the surrounding prose. They identify Lean 4.31.0, reused compiled imports, helper hypotheses and their discharged callers. Neither September nor the all-polynomial surface family is claimed as a direct Lean theorem. |
| Give concrete, honest limitations rather than fabricated success, blanket source correctness or failure-only review | The unit reports supply algebraic/prose arguments beyond the finite checks. No unresolved mathematical step is identified within their assessed scope; the absent family-specific formalization, absent fresh full dependency rebuild, limited source comparison and unestablished global novelty remain explicit. No claim is made that every assertion in either manuscript is thereby certified. |
| Summarize every unit and obtain native independent review of the entire objective | This summary, `FAMILY_REPORT.md` and all seven pairs are submitted with the prior whole-project acceptance and independently accepted binding correction identified below. The requested decision covers the complete corrected dossier, not just the bounded repair. Engineer does not supply acceptance or Host certification. |

## Coverage and source identity

`DRAFT_REVIEW_INDEX.json` maps every inventory ordinal/path, supporting role, shared argument, exclusion, source/object pair, claim version, old evidence record, dependency and replay check. Its integrity check accounts for **239 artifacts, 24 claim versions / 20 identifiers, 17 old evidence records, seven old ledger routes, two old graph routes, 20 old graph nodes, 92 formal dependency source/object pairs, and 81 named symbolic checks**. All seven report/verdict pairs exist. The historical audit objective is explicitly not counted as a theorem. Locks, empty logs, job receipts and copied arguments are not counted as mathematical results.

The existing campaign 9100049 manuscript manifest identifies the reviewed revision as `4eaee87548250b2682affda7d05d947c05554bae`. Its six October TeX files and one September TeX file match the source digests. Both manuscripts attribute authorship to OpenAI and carry their stated October 5 and September 24, 2026 dates. This establishes the supplied source version, not publication or priority.

The existing preserved-snapshot manifest contains 103 family-049 entries, all of which match the read-only old workspace; none is missing or changed. The other 136 inventory artifacts are explicitly indexed but are not claimed to have snapshot-manifest fingerprints. The original source, old ledgers, compiled objects, snapshot and manuscript manifest were not modified. No archive or full formal closure was rebuilt. The old writing entrypoints were inspected and not run.

## All unit assessments

| Unit and report | Engineering finding | Important qualification |
|---|---|---|
| [October literal polynomial, stabilization and fibres](draft_reviews/october-polynomial-stabilization/report.md) | **supported**: exact signed polynomial presentation; degree five; one-stability; every fibre is affine three-space; noncoordinate and nonrectifiable conclusions | Noncoordinateness depends on the unrestricted obstruction. The eight printed Lean roots do not themselves assert total degree or the full fibre/embedding corollary; the report checks their algebraic proofs. |
| [October unrestricted obstruction](draft_reviews/october-unrestricted-obstruction/report.md) | **supported**: separated integer filtration, actual graded modification, coordinate-to-invariant transfer, both bundle charts, every-action lift, rigidity specialization and all-LND exclusion | Negative shifts, nonzero descent, invariant denominators and coefficient regularity are checked. The formal lift is algebraic; the abstract line-bundle interpretation is separately checked prose. |
| [September construction and critical point](draft_reviews/september-construction-critical-point/report.md) | **supported**: arbitrary-ring lifting lemma, cusp translation, explicit Bezout and inverse maps, affine-three-space zero fibre, exact critical point and obstruction after any finite polynomial extension | September's polynomial is **not stably a coordinate**. It is not the October one-stable polynomial, and is not proved by the October Lean prints. |
| [Universal principalization](draft_reviews/universal-principalization/report.md) | **supported**: \((t-(dc-abt)^2,bd-(dc-abt)ab)=(a^2t-d^2)\) whenever \(ac-bd=1\), in every commutative unital ring | Includes arbitrary \(t\), zero divisors, all characteristics and the zero ring. Integral witnesses prove ideal equality, not merely equality of radicals. It does not by itself prove a geometric lift. |
| [Arbitrary lower-degree perturbation rigidity](draft_reviews/lower-perturbation-rigidity/report.md) | **supported**: every fibre-weight-preserving LND killing \(W+a^2u^2-d^2\) is zero when actual auxiliary degrees of \(W\) are at most one | Requires a characteristic-zero field and the exact quotient gradings, but no homogeneity of \(W\), nonnegative leading shift, or assumed polynomiality of the vertical coefficient. |
| [Strongest uniform surface theorem](draft_reviews/uniform-surface-family/report.md) | **supported in prose** for every \(\psi\), including zero and repeated roots: exact quotient, injective invariant restriction, no nonzero LND preserving the entire embedded subscheme | Uses arbitrary-\(t\) principalization, arbitrary-\(W\) rigidity and the **unconditional** lift, not the fixed-\(I\) theorem applied beyond its scope. It has no family-specific Lean declaration. |
| [Provenance and known status](draft_reviews/provenance-known-status/report.md) | **partial** historical support: versions, attribution and relative scope improvements are established; a concrete citation-scope error is corrected | Kaliman-Makar-Limanov's domain convention already applies to Proposition 2.1. The actual domain proof is unaffected. Global novelty, publication significance and inherited acceptance are not established. |

Each directory contains `verdict.json` as well as its linked report. The mathematical unit partition is not an assertion that all seven units were independent inventions: the obstruction and surface corollary deliberately share proved ingredients. Shared dependencies are marked as such, rather than counted as extra results.

## Decisive findings and historical distinctions

The October literal formula is the one actually transported by the determinant-preserving inverse; eliminating \(u'=-J\) gives the printed \(s'+J\) sign. The independent fifth variable and unrestricted ambient automorphism in the formal definition match one-stability. The nonzero-fibre argument eliminates \(u\) using a nonzero constant, while the zero-fibre argument uses the determinant-one linear change, so no localization silently deletes \(p=0\). The prime-fibre ideal argument supplies nonrectifiability after noncoordinateness is established.

The universal obstruction is not inferred from finitely many derivations. The assessed proof constructs the actual associated graded algebra, keeps arbitrary-sign integer leading components locally nilpotent, proves the descended base derivation nonzero, lifts every base action with a group law and correct fibre weights, and uses factorial closure in the **fixed domain** \(C\). The two coefficient charts prove regularity of the vertical coefficient before its impossible negative weight is used.

The strongest surface theorem is not reduced to a few values of \(\psi\). In \(W_\psi=a^2\psi(ab)\), a monomial \(a^{n+2}b^n\) has auxiliary degree \(-n\leq0\). Exact ideal principalization and the unconditional lift therefore apply uniformly. The quotient maps are mutually inverse without cancelling \(X\); the \(\psi=0\) quotient is reducible but retained. A stable nonzero ideal would contain a nonzero last LND iterate, contradicting invariant restriction. The conclusion concerns the whole embedded subscheme, not the absence of actions on the abstract surface or on each component separately.

In September, the three-relation lifting algebra is reduced to \(B[T]\) by explicit ideal combinations and inverses, without cancelling \(h\) or requiring a domain. The cusp translation and explicit Bezout identity supply the needed comaximality. The exact point \((h,u,v,w)=(2,0,-1/2,1/2)\) has \(F=-1\) and zero gradient. The inverse chain rule, not just five evaluations, excludes a coordinate in every polynomial extension. An affine-space zero fibre is not being mistaken for an ambient coordinate system.

Primary PDFs for Brion's published Lemma 2.9 and Kaliman-Makar-Limanov's author-version Proposition 2.1(3) were opened and retained in the provenance unit. Brion's pullback-isomorphism condition is essential and is discharged in the actual lift. In the latter PDF **Lemma 2.2 physically precedes Proposition 2.1**, so the old report's contrary reading-order warning is wrong. The reviewed factorial-closure application expressly uses a characteristic-zero domain and is independently proved; this is a correction to Argus commentary, not a refutation of an original manuscript.

The three principalization/perturbation/surface statements are broader than the inspected October statements in the exact ways their reports identify. No global originality claim follows. The old scope assumption `A_SUPPLIED_UPSTREAM` and its reasoned retirement remain visible, as does the sole explicitly retired old route `R_STABLE_UNIVERSAL`: it was superseded by a claim-version change, not killed by a mathematical contradiction. Compiler port failures are not mathematical route exclusions.

## Replay and formal-evidence boundary

These are retained outcomes from the completed dossier, not new runs for this final submission.

| Evidence | Actual outcome | What it does not establish |
|---|---|---|
| [Single common symbolic replay](draft_reviews/september-construction-critical-point/exact_replay_run.json) | Exit **0**, **81/81** exact checks, byte-identical certificate; Python 3.13.5, SymPy 1.14.0, mpmath 1.3.0; bounded child 0.646 seconds | No enumeration of all LNDs, no kernel theorem for the arbitrary surface family, no proof of every giant inverse composite by brute-force expansion |
| [Fresh Lean wrapper replay](draft_reviews/october-unrestricted-obstruction/main_replay.json) | Actual Lean **4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`, `lean --stdin`, exit **0**, 7.223 seconds; eight foundational-only axiom lists | No fresh 92-import rebuild, no inherited independent statement-fidelity approval, and no direct Lean statement of September or the entire surface/fibre package |
| [Bounded live Jacobian result](draft_reviews/provenance-known-status/jacobian_result.json) | Canonical live-update interpreter, operation `polynomial.multivariate.gcd.compute`; exact payload retained; monic \(\gcd(a,bd+1)=1\) over \(\mathbb Q[a,b,d]\); adapter exit **0**, no timeout/error; server 0.14.0, protocol 2025-11-25 | One coefficient-coprimeness calculation does not prove quotient geometry, universal ideal equality, action lifting, or a whole paper |
| Historical v2 wrapper certificate | Compiler exit **1**, failed specialization and error-recovery `sorryAx`; **invalid as a completed formal artifact** | Does not refute the unchanged natural-language theorem |
| Historical v3 wrapper certificate | Exit **0**, no holes, foundational axioms; source and fidelity text match the current old files | Does not retroactively certify v2, global novelty, or every prose assertion |

The 92-module source audit lists 13,162 source lines, declarations, imports, exact helper assumptions and their discharged callers. It finds no proof-hole or added-axiom tokens. Source reading and printed axioms are meaningful evidence, but matching source/object fingerprints and timestamps are not a fresh kernel rebuild. The latest historical module-build record itself says all 92 are `unchanged`.

No new `.lean` artifact was created and no current claim was assigned mechanical status by hand. The current `MATH_STATE.json` records 15 scoped assertions, engineering opinions, exact known-status limitations, an explicitly retired historical interface assumption and reasoned historical route retirement. Status remains derived by the ledger. The old reviewer's judgements are indexed as historical evidence, not inherited as acceptance of this dossier.

## Campaign-local check and proof-graph applicability

The applicable installed math-state checker was run for this submission at the exact campaign root:

```
campaigns/9200049
```

The interpreter is `$WORKSPACE/argus-latest/.venv/bin/python`. The proof-graph outcome below is retained historical evidence, not a repeated run:

| Official command | Provenance | Exit | Output |
|---|---|---:|---|
| `-m argus_skill.verticals.math.math_state check --project-root <root above>` | Fresh run for this submission | **0** | `{"ok": true, "issues": []}` |
| `-m argus_skill.verticals.math.proof_graph_check check --project-root <root above>` | Historical run, unchanged non-applicability | **2** | `no proof graph at .../9200049/research/PROOF_GRAPH.json` |

These exit statuses are retained honestly: no two-zero result is claimed. The prior native review explicitly found that the missing proof graph **is not a blocker for this review**, and the live final-submission objective directs that this non-applicable check must not cause creation of a proof graph. This is an exploratory corpus review, not a new independent counterexample campaign or a targeted proof-development project. The historical `gate_accepted: false` in the index describes the earlier engineer measurement, not a current unresolved acceptance condition.

The generic module named in the older finishing instruction is not installed in this interpreter: the contract probe returned `No module named argus_skill.verticals.math.check`. The live objective calls for the installed applicable checker; the available math-state check above passes. No runtime or dependency repair was attempted.

No graph was created or copied, no schema or mathematical statement was weakened, and no check against another directory was substituted. Neither `MATH_STATE.json` nor any assessment was changed for this submission. Apart from the required current ledger check, unaffected mathematical investigations and replays were not repeated.

## Corrected bindings and renewed final decision

The prior native **whole-project acceptance** is:

```
$WORKSPACE/.argus-campaign-9200049/projects/6ed5aa8ad212/handoffs/451502dea011/round-0001.json
```

Its `review.status` is `done`, and its reason explicitly calls the decision final project-level exploratory acceptance of all 239 artifacts, 24 historical claim versions and seven assessments, not a bounded-subtask verdict. The retained Host outcome at `events.jsonl:685` nevertheless records `stage_certification: not_certified` and `final_submission_certified: false`. That pre-repair outcome is not a verdict on the corrected submission.

The independently accepted **bounded reconciliation** is:

```
$WORKSPACE/.argus-campaign-9200049/projects/6ed5aa8ad212/handoffs/71de3214912b/round-0001.json
```

Its `review.status` is `done`; its reason expressly limits acceptance to the reconciliation. The evidence delta is the removal of the five rejected historical-certificate bindings and five renewed `supports` judgments filed by **`reviewer:71de3214912b`**, attached as follows:

| Current claim | Replacement judgment artifact |
|---|---|
| `GLOBAL_PRINCIPALIZATION` | [Universal principalization report](draft_reviews/universal-principalization/report.md) |
| `LOWER_PERTURBATION_RIGIDITY` | [Lower-perturbation rigidity report](draft_reviews/lower-perturbation-rigidity/report.md) |
| `OCT_UNRESTRICTED` | [Unrestricted obstruction report](draft_reviews/october-unrestricted-obstruction/report.md) |
| `OCT_COORDINATE_TRANSFER` | [Unrestricted obstruction report](draft_reviews/october-unrestricted-obstruction/report.md) |
| `OCT_COMPOSITE` | [Literal presentation and stabilization report](draft_reviews/october-polynomial-stabilization/report.md) |

Inspection of the current ledger finds these five report-backed judgments and **no certificate-backed artifact among its 30 judgment records**. These are mathematical reading judgments, not mechanical compiler evidence or certificate-backed fidelity approvals. The reconciliation Reviewer independently confirmed unchanged statements, versions, historical provenance, unaffected evidence and accepted non-applicability decisions. Engineer has added no judgments or certification.

The earlier acceptance therefore remains evidence for the unchanged seven assessments; the later acceptance supports the corrected bindings only. The newly supplied family report is a reader-facing synthesis of those assessments and is submitted for its own faithful reading, not retrospectively labelled accepted.

The **native Host-invoked independent Reviewer** is asked to accept or reject the complete corrected dossier under the Manager's old-draft-review scope, rather than return another bounded repair verdict. New scrutiny is limited to the corrected bindings, continued applicability of the existing acceptance, and fidelity of the family synthesis. Host/Manager owns final exploratory certification. Any rejection should identify a concrete remaining objective gap; no Reviewer subagent, certification packet or Host-state edit has been made.
