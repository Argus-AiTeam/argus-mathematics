# Historical umbrella and corpus provenance

**Assessment.** `C9000026` v1 is a historical task objective, not a mathematical theorem, current instructions, or evidence that the whole manuscript has been verified. All 22 enumerated artifacts and the reference-input directory are assigned dispositions in the coverage index; the eight mathematical units have individual substantive reports.

## What this record actually says

The old ledger's context is `CTX9000026` v1, "OpenAI Math Audit #026: Positive lower density of large prime gaps," with definition `openai_family=026`. Its claim asks for either a certified flaw in the manuscript or independent, machine-checkable verification/repair/generalization of a core theorem with Reviewer certification. This is a goal description with alternative deliverables, not a proposition whose truth follows from the present local certificates.

Current authority is `OBJECTIVE.md` and the complete inventory `PRIOR_DRAFTS.json` in `campaigns/9200026`. The old root `campaigns/9000026`, its preserved snapshot and ledgers were read only. No historical instruction was executed as a new search mandate.

The separate manuscript main theorem has quantifiers: for every fixed \(C>0\), there exist \(c(C)>0,N_0(C)\) such that every integer \(N\ge N_0(C)\) has at least \(c(C)N\) indices \(n\le N\) with \(p_{n+1}-p_n>C\log p_n\). The moment package is not this theorem. The inherited Argus draft explicitly leaves the function-family cancellation choice and downstream ordinary-index counting outside its verified branch. Neither that theorem nor its ratio corollary receives a blanket correctness or refutation verdict here.

## Inventory, units and exclusions

The index was the first output written. It groups by arguments, not file count:

| Unit | Claim/version | Classification |
|---|---|---|
| `euler_core` | `L026_EULER_CORE` v4 | Universal formal rational algebra, with a separate human interpretation |
| `density` | `L026_DENSITY` v2 | Prose arithmetic reduction using ordinary BV when marked |
| `fourier` | `L026_FOURIER` v1 | Prose zero-safe density-sum evaluation |
| `box_mean` | `L026_BOX_MEAN` v1 | Self-contained prose box mean |
| `uniform_moments` | `C026_UNIFORM_MOMENTS` v2 | Assembly/reproduction of the mixed-moment proposition |
| `weight_moments` | `C026_WEIGHT_MOMENTS` v4 | Fixed-family transfer/reproduction of the weight proposition |
| `strong_error` | `C026_STRONG_ERROR` v2 | Proposed quantitative strengthening, novelty not assessed |
| `relative_euler_obstruction` | `O026_RELATIVE_EULER_OBSTRUCTION` v1 | Exact failed-route obstruction, not a manuscript counterexample |
| `historical_umbrella` | `C9000026` v1 | Historical objective and reference provenance, not another result |

Two zero-byte lock files have no mathematical content. The three Lean certificates concern successive sources of one Euler-core argument; two failed and were superseded. Compiler summaries, successful `compile.log`, and the old submission receipt are not additional proofs. `exact_certificate.json` contains finite checks plus prose/status strings: its assertions about analytic review or campaign completion are not executable evidence. The six-item Jacobian profile is one example, not another universal result. These are explicit exclusions from result counting, not omitted artifacts.

## Source-version identity and reference directory

The authoritative reference manifest is `campaigns/9100026/MANUSCRIPTS.json`. It identifies OpenAI's *Positive lower density of large prime gaps*, September 25, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`. All six listed TeX sources matched their manifest SHA-256 values; all six staged copies under the old `research/openai_manuscript/Positive-lower-density-of-large-prime-gaps-September-25-2026/` were byte-equal to those sources.

The reference directory has exactly these eight regular files:

| Reference file | Disposition in this review |
|---|---|
| `README.md` | OpenAI attribution, title/date and manuscript link; not an Argus mathematical draft |
| `build/main.tex` | Source assembly and global abstract; not independently certified by local algebra |
| `build/references.bib` | Bibliographic reference input, not a collection of additional Argus claims |
| `build/sections/01-introduction.tex` | Main theorem/corollary and historical scope; full theorem not assessed by this branch |
| `build/sections/02-counting.tex` | Downstream counting reference; no separate inherited Argus proof of it is asserted |
| `build/sections/03-moments.tex` | Decisive comparison source for mixed moments, arithmetic lemmas, box mean and weight transfer |
| `build/sections/04-weights.tex` | Exact fixed-family statement, cumulative functions and prime-deletion identity compared substantively |
| `build/sections/05-cancellation.tex` | Separate high-dimensional family construction; not silently inferred from fixed-family moment estimates |

Only the six TeX files are covered by this manuscript manifest's hash list. No manifest attestation is invented for the README or bibliography. Treating the input directory as reference material is not a request to audit every cited paper or every manuscript theorem.

The inherited prose also reports looking at public OpenAI Lean interfaces, naming `LaplaceTransform.lean`, `EulerProducts.lean`, `EulerFactors.lean`, `ContourSums.lean`, `ContourIntegrals.lean`, `BoxMeans.lean`, `Detectors.lean`, `WeightMoments.lean`, and `DetectorMoments.lean`, and reports Lean 4.34.1 there. Those files are not in the supplied eight-file reference tree or the manifest's versioned TeX list. This contextual inspection/version claim was not independently replayed and is not used as a theorem or transitive formal certificate. The local, actually replayed toolchain is Lean 4.31.0.

The listed Wiki's divisor-chain normalization page concerns a different affine-to-additive transfer. It supplies no assumption for these additive-shift moments and was not imported into their proofs.

The preserved snapshot manifest at `$WORKSPACE/.copilot/session-state/<id>/files/openai-audit-drafts-20261106T1020Z-manifest.json` contains 13 of the 22 inventory files. Each of those 13 matched both size and SHA-256; none mismatched. Nine inventory files lack entries: the two locks, BFI PDF, three Jacobian files, `compile.log`, `lean_submit.json`, and `lean_verification.json`. They were examined but are not claimed to have preserved-snapshot identity. The archive itself was not modified or unpacked.

## Reconciling judgements, assumptions and pending labels

All eight mathematical families have reviewer-produced `supports` receipts bound to their current claim identities in the preserved ledger. The four live BV assumption identities also have reviewer-produced supporting readings, all pointing to `reviewer_BV_excerpt.md`. Exact IDs and subject mappings are in the index. The prose proof, reviewer excerpt, source and fidelity document match the snapshot; the successful official certificate additionally embeds identity-bound source and fidelity text.

Claim versions 1/2 of uniform moments, density and strong error, and versions 1-4 of weight moments, retain the same mathematical statement hashes. Their assumption bookkeeping does not create new mathematical results. The weight ledger's replacement of a duplicate BV identifier is not a discharge of BV: v3's retirement reason explicitly preserves the dependency, and v4 supplies the unique live ID; empty lists in v1/v3 cannot support an unconditional reading. Euler-core v1 had no formal statement; v2/v3 certificates have obsolete source/claim identities and are not reused as support for v4. Its natural algebraic assertion stayed unchanged across all four versions.

The graph has eight `in_progress` mathematical nodes with `reviewer_confirmed:false`, and an open historical umbrella. It records density/Fourier and weight-transfer routes; those are the ledger's only route records and neither has a retirement reason. The relative-comparison failure is instead recorded as the obstruction claim, and is not retroactively retired through a write to the immutable ledger. The old exact certificate and prose still use "pending independent review"/"attribution pending" strings; the compiler's fidelity field is null. The ledger, however, already contains the matching human judgements. These are separate evidence channels, not a license to discard either side or rewrite old metadata.

A `produced_by="reviewer:..."` receipt at tier `judgement` is inherited independent human support, not a native literature-tier `citation_check attribute` receipt, formal statement-fidelity checker, or current Host acceptance. Most prose judgements identify an artifact path rather than embed a digest of every proof passage; snapshot matching anchors the preserved corpus, not an invented signed review transcript.

The four assumption IDs name one theorem: ordinary endpoint BV as recorded in BFI, DOI `10.1007/BF02399204`, p. 206 (1.4), with notation on p. 204. The source attributes it to Bombieri and A. I. Vinogradov. The current Engineer opened the primary PDF passage and checked the exact range and hypotheses; the derived weighted/shifted form is assessed in the density report. No new assumption, citation-tool approval, ledger status or reviewer identity was fabricated.

## New checks versus inherited receipts

New evidence is deliberately local: exact finite replay in Python 3.13.5/SymPy 1.14.0; direct read-only Lean 4.31.0 compilation plus axiom checks; one inspected, bounded current Jacobian operation with the exact six-item payload; primary-source BV reading; and the mathematical assessments in each report. These do not replace the identity-matched inherited official certificate or human opinions.

The first finite-replay invocation failed because the legacy Argus environment lacked SymPy. An existing independently probed runtime completed the same bounded functions; no package was installed. Both attempted follow-ups to synchronous reading agents were refused by the messaging tool; missing exact metadata was then obtained directly rather than pretending a follow-up review occurred. An initial adapter-output redirection failed before invocation because its output directory did not yet exist; after creating the authorized directory, inspection and the sole execution succeeded. None of these tooling facts is a mathematical verdict.

No old checker `--write`, old submission handle, old ledger update, citation archival write, new counterexample search, or new public-Lean audit was launched.

## Campaign-local gate and handoff

The exact checked root is `campaigns/9200026`, not the batch root. Current official records are:

| Check | Exit | Recorded outcome |
|---|---:|---|
| `argus_skill.verticals.math.math_state check --project-root <this root>` | 0 | `ok:true`, no issues |
| `argus_skill.verticals.math.proof_graph_check check --project-root <this root>` | 2 | No `research/PROOF_GRAPH.json` at this root |

Commands used the explicit live-update interpreter, and the complete commands/stdout/stderr are in `math_state_check.json` and `proof_graph_check.json`. The active project has no new mathematical ledger or proof graph: the old ones are immutable references. A passing empty/local ledger check does not certify the old claims. The graph failure is reported, not converted to exit zero or replaced by a check against the old or batch root.

**Outstanding blocker:** the requested graph gate cannot pass while the active graph is absent. Its path is outside this mission's authoritative writable paths, so the Engineer cannot create/copy/repair it or weaken a mathematical claim to hide the failure. Scope-stage/exploratory applicability or an authorized metadata-owner repair must be resolved by Host/Planner; the Engineer does not self-waive the failed command. No further unchanged check is useful until that material fact changes.

The coverage and substantive assessments are delivered for the native Host-invoked independent Reviewer to examine. Neither inherited support nor Engineer completion of these files self-accepts the family. The Reviewer should assess the stronger error, source attribution and whole-corpus coverage; any out-of-boundary metadata action belongs to its authorized owner, not a request for this Engineer to edit forbidden paths.
