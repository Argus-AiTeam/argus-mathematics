# Old Argus draft family 001: final exploratory certification submission

The existing complete index, all seven units' `report.md` / `verdict.json`
pairs and this summary are submitted for **final independent project-level
certification** against `OBJECTIVE.md` and `PRIOR_DRAFTS.json` at the preserved
**exploratory** research target. **Final family acceptance remains pending.**
The native Host-invoked independent Reviewer must decide whether the entire
operator objective is satisfied, and the Host must persist that verdict.

The prior native Reviewer completed the bounded mission with `status: done`
in
`$WORKSPACE/.argus-campaign-9200001/projects/072f28d2b762/handoffs/78995a91b007/round-0001.json`,
finding: "All 26 artifacts, the reference directory, repeated versions and
supporting evidence are covered; all seven assessment pairs and the complete
summary are present and substantively supported." That accepted handoff is
reused, not promoted to final project certification. All seven assessment
pairs, mathematical dependencies and replay evidence remain unchanged;
their contributor-time pending-review labels are retained as authored.

## Inventory and versions

`DRAFT_REVIEW_INDEX.json` was written before unit assessments. It accounts
for all **26** `PRIOR_DRAFTS.json` artifacts and the **one** reference/tooling
directory, including its **10** regular files. All 26 declared byte sizes
matched. The existing preserved snapshot manifest contains 11 of those
artifacts, and all 11 existing digests matched; the other 15 must not be
described as snapshot-digest-verified. No archive or manifest was rebuilt.
All nine manuscript TeX files match the existing reference-manifest digests
for OpenAI's October 7, 2026 revision
`4eaee87548250b2682affda7d05d947c05554bae`.

The coverage includes **30 ledger entries / 23 distinct claim IDs**,
**25 graph nodes** (including two graph-only shortcut claims), **20 historical
evidence records**, **eight routes**, and **six distinct external assumption
IDs**. The two Lean copies and two fidelity-document copies are one formal
unit, not independent proofs. Submission, compile log, check metadata and
certificate describe one historical compiler event. Empty locks are explicitly
excluded as nonmathematical. Source texts, overlapping excerpts, headers,
bibliography and manuscript TeX are supporting/reference inputs, not extra
Argus results. The September 23 manuscript is a bibliographic predecessor
linked from the README, not a second supplied draft.

The existing coverage check **passed**: exact inventory mapping, all claim-version
pairs, graph IDs/dependencies, evidence-subject/version bindings, routes,
assumptions, and all 14 required assessment files agree. All 20 current JSON
files parsed in that check. This accepted evidence is reused without repeating
unchanged validation; it does not replace final independent certification.

Every unit below has both files at
`research/draft_reviews/<unit>/`. Individual reports give exact statements,
hypotheses, attribution, source versions, locators, decisive reasoning and
limitations; their verdicts are machine-readable.

## All unit assessments

| Unit | Claims and kind of existing work | Assessment and exact boundary |
|---|---|---|
| [realization](draft_reviews/realization/report.md) | PF-REALIZATION v1; PF-FLAG v1-v2; PF-INTEGRAL v1-v4; PF-SAME-MARKING v1-v2. Developed Argus connecting argument. | **Supported relative to the named geometric inputs.** The framed integral point supplies one algebraic universal \(b\); its prime-to-\(p\) discrepancies become locally constant finite sections. Compatible actual Hecke witnesses meet every component and vanish for all tensor indices, so this same \(b\) preserves the tensors and gives the prescribed period. This is not a geometric kernel certificate. |
| [lean-core](draft_reviews/lean-core/report.md) | PF-CORE v1-v2; all four declarations. Abstract formal proof. | **Supported exactly as encoded.** Both Frobenius identities, injective central preimage, and simultaneous propagation have the stated quantifiers. Source/fidelity/claim/certificate bindings match PF-CORE **v2**. No geometric space, quasi-isogeny, admissibility or Hecke witnesses are constructed by these declarations. |
| [symbolic-frobenius](draft_reviews/symbolic-frobenius/report.md) | Exact frame equations, determinant, dual/Frobenius convention, quadratic \(p=2\) diagnostic. Reproduction, not an extra ledger theorem. | **Exact calculations reproduce.** \(A=[[-v,1],[-p-uv,u]]\), \(\det A=p\). The quadratic comparison detects the omitted outer-sigma basis convention; it does not contradict the manuscript. A generic rational-function solve is not a specialization case split or a proof of geometry. |
| [lattice-obstruction](draft_reviews/lattice-obstruction/report.md) | PF-LATTICE-OBSTRUCTION v1; retired arbitrary-lattice route. Local counterexample. | **Supported for every \(s\in\mathbf Z_2\).** The displayed lattice is preserved invertibly by \(\operatorname{diag}(1,1+2s)\), while the invariant projector has entry \(-1/2\) in that lattice. The standard lattice works. This refutes the shortcut, not existential abelian realization or the manuscript. |
| [weak-admissibility](draft_reviews/weak-admissibility/report.md) | PF-WA v1-v2; Step 6. Application of Colmez-Fontaine. | **Supported rational implication, including \(p=2\).** Stipulated full finite local-field descent lets every descended Frobenius subobject be tested after scalar extension, preserving normalized Hodge/Newton numbers. CF Theorem A with \(N=0\) gives crystalline admissibility. It supplies no canonical integral tensor lattice or abelian marking. |
| [failed-shortcuts](draft_reviews/failed-shortcuts/report.md) | Both graph-only F001 citation claims; proposed/failed Argus inference routes. | **Reject the citation shortcuts, not their sources or the manuscript.** Available Milne **v2.4** section 5.21 leaves the required extra-structure lifting task unfinished; the literal **v2.2** text named in the graph remains unchecked. Kisin 2017 Proposition 1.4.15 gives existence of a simultaneous tensor-preserving isogeny in its original \(p>2\), hyperspecial setting, not identity with a separately fixed crystalline marking. |
| [manuscript-context](draft_reviews/manuscript-context/report.md) | C9000001 and all 15 MR-* IDs. Source dependencies and undeveloped source context. | **All 16 individually classified**, with exact hypotheses and a concrete undischarged obligation for each. They are not 16 developed Argus proofs or new attacks. Lack of independent Argus evidence is not a refutation. The companion CM Hodge assertion is an unverified input only to the stronger algebraic-specialization consequence. |

No mathematical improvement over the old claimed realization theorem, new
counterexample to the manuscript, or verified novelty is asserted by this
review. Its improvement is complete, scope-correct assessment and replay,
including the geometric applications the abstract certificate does not check.
The old draft's additional explicit fixed-marking argument is distinguished
from the weaker abstract core and from Milne's conditional prior discussion.

## Geometric, prime-two, and dependency qualifications

The realization report checks the actual versioned passages in Kisin-Zhou
`arxiv:2505.02165v1`, Pappas-Rapoport `arxiv:2106.08270v6`, and
Gleason-Lim-Xu `arxiv:2208.07195v3`. It retains the full connected stabilizer,
neat level, adapted closed self-dual embedding, R-smoothness, Kottwitz and
center-rank conditions. At \(p=2\), **reduced relative roots remain a
hypothesis**. GLX's earlier restricted CM-lifting applications are not
silently substituted for its separate global-Hodge-type uniformization
Corollary 6.3. KZ's own Theorem 2.2.5 applies that corollary in the strongly
admissible setting, corroborating the restricted \(p=2\) reading.

The essential marking argument is not "some tensor-preserving isogeny
exists." The marked Siegel point fixes the algebraic \(b\); the same
universal \(b\) trivializes the prime-to-\(p\) local systems and is evaluated
at the compatible Hecke points. The resulting quantifiers are
\(\exists b\,\forall\alpha,\ell,n\), not separately chosen local isogenies.
Its inverse remains the crystalline period marking. The report explains
the quotient construction and why this does not assert algebraicity of all
automorphisms of a fixed \(p\)-divisible group.

The remaining graph is source context, with important limits:
MR-AUX-DATUM is an input construction not independently supplied by the
local Argus proof; MR-PRESCRIBED-TRANSPORT additionally needs descended
tensor data and common rational normalization. **CM transport uses the
unprescribed transport clause and the special-point theorem, not
PF-REALIZATION.** MR-WEIL also uses the source's divisor-filtration corollary,
not separately indexed as an old node. The constrained filtration, both
balanced-Weil branches, divisor span, lifting of specified algebraic
homomorphisms, CM reduction and pullback assembly remain separately
undeveloped Argus checks. The index preserves historical graph edges and
adds source-dependency cautions instead of editing the old graph.

MR-CM-HODGE-EXTERNAL is **not** an assumption of PF-REALIZATION or MR-MAIN.
It is the additional unverified companion input to
MR-ALGEBRAIC-SPECIALIZATION. No companion-theorem investigation, proof of
the surrounding manuscript, or new error search was commissioned.

Milne's supplied extract is v2.4, October 9, 2026; the manuscript
bibliography names v2.2, November 2, 2025. Section 12 discusses the
September 23 manuscript and uses that numbering. Neither its conditional
comments nor the chatbot-conversation tail preceding the extracted
section is independent verification of the October 7 realization lemma.

## Reused replays, assumptions, and historical checks

The matched historical Lean certificate is for PF-CORE v2 only. The real
supplemental stdin run used **Lean 4.31.0** in the existing built Mathlib
workspace and printed axioms for all four declarations, with no `sorryAx`.
The axiom printouts retain standard foundational dependencies; "axiom audit"
does not mean all transitive imports are axiom-free. The delivered no-Git
receipt driver was replayed after removing an initial contributor
provenance probe contrary to the no-Git instruction; the caveat and
manifest-only dependency identification are explicit in the core report.
No new persistent Lean source, claim-bound certificate or ledger entry
was created.

The copied historical exact checker passed under **Python 3.13.5 /
SymPy 1.14.0**, with bytecode writing disabled and all writes confined to
current review paths. The current bounded adapter replay used
`$WORKSPACE/argus-live-update/.venv/bin/python`,
operation `matrix.symbolic.linear_system.solve`, Jacobian **0.14.0**,
protocol **2025-11-25**. The inspected contract, exact payload, typed
`UNIQUE` output and explicit success/no-timeout/no-error status are in
dedicated JSON files in `symbolic-frobenius/`. The exact checker verifies
the returned residuals. The sidecar and checker are not independent
foundational kernels and neither certifies geometry.

External geometric results, CF Theorem A, and the standard comparison,
rigid-point and lattice facts remain external mathematical inputs.
Historical Engineer/Reviewer opinions and source judgements are
inventoried, not adopted as this delivery's independent acceptance.
The current task's owned paths do not permit rewriting either ledger.

Both official checks were run at the original submission with
`$WORKSPACE/argus-latest/.venv/bin/python` against the exact
campaign root, **not** the shared batch root. These historical results are
retained, not rerun on unchanged mathematical evidence:

| Project root | Official module | Actual exit |
|---|---|---|
| `campaigns/9200001` | `argus_skill.verticals.math.math_state check` | **0**, `ok: true`, no issues |
| Same root | `argus_skill.verticals.math.proof_graph_check check` | **2**, `no proof graph at .../9200001/research/PROOF_GRAPH.json` |

**No two-zero checker result is claimed.** This review project has no current
`research/PROOF_GRAPH.json`; creating or copying one is outside the
authoritative writable paths. No historical graph was modified, no graph
was fabricated to make a checker pass, and the empty/current claim-state
check is not evidence that the old mathematics is closed. The original
submission reported the missing graph as an ownership blocker. The current
final-submission contract instead directs reuse of the accepted bounded
review and forbids creating a proof graph merely to satisfy an unrelated
check; no new graph or mathematical investigation is commissioned.

The remaining certification question is the **whole review objective**,
not another bounded unit: whether all inventoried work is accounted for and
the substantive assessments honestly delimit claims, versions, hypotheses,
dependencies, formal scope and unresolved obligations. If a substantive gap
remains, it must be identified by its precise claim, artifact and unmet
requirement. Otherwise the Host must persist the native independent
Reviewer's explicit final exploratory project verdict. Engineer submission
alone does not close that requirement.
