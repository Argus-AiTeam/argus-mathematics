# Provenance, known status, citations, and historical failures

**Engineering verdict: partial support for the historical presentation, with a specific citation-scope correction.** Source-bound mathematical reconstructions and the three precisely scoped strengthenings have separate assessments. This report does not certify publication, novelty, or acceptance.

## Corpus and source identity

`PRIOR_DRAFTS.json` is the complete 239-artifact inventory. Every entry existed with the listed byte count at initial inspection. The inventory includes 93 Lean sources (one wrapper plus 92 dependencies), 92 compiled objects, 35 JSON records, nine logs, three quoted library-source texts, two Python drivers, two Markdown drafts, two empty lock files, and one license. Thus most entries are supporting representations, not separate drafts.

The preserved snapshot manifest contains **103** `9000049/` entries. A direct read-only comparison found all **103/103** matching their recorded SHA-256 values, with no missing, changed, or extra out-of-inventory family entry. The 136 other inventory entries are not thereby claimed to have snapshot digests: they are explicitly accounted for as additional compiled objects, logs, locks and records in the coverage index. No archive was extracted or rebuilt. Old driver entrypoints that could write into campaign 9000049 were not executed.

All 24 old claim-version records, 20 distinct claim identifiers, 17 evidence records, seven ledger routes, two graph routes, and 20 graph nodes are mapped in `../../DRAFT_REVIEW_INDEX.json`. The old audit objective `C9000049` is retained as provenance but excluded as a theorem and is not obeyed as an instruction. Versions and copied arguments are not counted as new results.

The manuscript source manifest is the existing campaign `9100049/MANUSCRIPTS.json`, revision `4eaee87548250b2682affda7d05d947c05554bae`. Its October six-file and September one-file digests match the inspected sources. The supplied author/date are OpenAI, October 5 and September 24, 2026. A local manifest and matching source text establish the reviewed version, not peer-review status or global priority.

The retained Apache license attributes reused formal implementation material. The old work ports that material to Lean 4.31.0. The independent wrapper does not import the final upstream `Principal`, `NonCoordinate`, or `Rigidity` wrapper as its proof of the advertised extensions. This is a meaningful implementation/proof distinction, not a claim that the 92 helpers were independently reinvented.

## What was already known, and what is an extension

| Claim family | Status relative to inspected sources |
|---|---|
| Literal October polynomial, stabilization, fibres, unrestricted obstruction | Reconstruction of claims and arguments already present in the supplied October manuscript and its implementation; not a new counterexample produced here |
| September cusp construction, affine zero fibre, critical point and extensions | Reconstruction of the supplied September theorem and explicit maps; not an October Lean consequence |
| Universal principalization | Genuine enlargement relative to October's fixed field-based principalization: arbitrary commutative ring and arbitrary \(t\), with explicit global ideal witnesses |
| Arbitrary lower-degree perturbation | Genuine enlargement relative to the fixed \(a^3b\) term: any actual auxiliary-degree-at-most-one \(W\), even inhomogeneous for both gradings |
| Uniform surface theorem | Prose corollary for every polynomial \(\psi\), including zero and repeated roots, not merely the fixed October ideal |

An enlargement relative to inspected statements is not a verified-new result in the mathematical literature. The old report's three unsuccessful searches are historical assertions, not a reproducible comprehensive novelty search. This review makes no global novelty or significance claim and needs no such claim to finish the finite corpus assessment.

## Primary-source citation check

Two relevant cited propositions were opened in their primary PDFs. These are comparison sources; the operative algebraic facts are also proved in the reviewed arguments and imported implementation. They are not undisclosed unproved axioms of the October formal roots.

### Brion: supported with the pullback hypothesis

Michel Brion, *On linearization of line bundles*, **published** J. Math. Sci. Univ. Tokyo 22 (2015), 113-147, Lemma 2.9, printed p.120 and proof p.121:

> Let X be a reduced G-scheme, and L a line bundle on X. Then L admits a G-linearization if and only if the line bundles alpha*(L) and p2*(L) on G x X are isomorphic.

The primary PDF is preserved as `brion-2015.pdf`, obtained from `https://www.ms.u-tokyo.ac.jp/journal/pdf/jms220104.pdf`. Its printed p.116 conventions specify an arbitrary field, separated locally noetherian schemes, and a connected smooth finite-type algebraic group. Here the base is the smooth affine complex quadric times a line, and \(G=\mathbb G_a\), so these ambient conditions hold. Most importantly, reducedness alone does **not** give a lift: the pullback-isomorphism condition is essential. The checked chart/UFD/polynomial-unit argument discharges it, and normalization plus the two-parameter unit argument supplies the group law. The published lemma and its hypotheses agree with the old report's use.

### Kaliman-Makar-Limanov: concrete scope erratum

Sh. Kaliman and L. Makar-Limanov, *AK-invariant of affine domains*, **author-hosted version**, Proposition 2.1(3), printed p.3, states factorial closure for a nonzero LND and a nonzero invariant product. The PDF is preserved as `kaliman-makar-limanov-author.pdf`, obtained from `https://www.math.miami.edu/~kaliman/library/KM-L.miyanishi.pdf`. No unverified DOI, publication-version locator, or equivalence to another revision is asserted.

The source's printed pp.2-3 convention says:

> Beginning from Lemma 2.2 we shall suppose that X is irreducible, i.e. A is an affine domain.

**Lemma 2.2 appears before Proposition 2.1 in the actual document.** The domain convention therefore already applies to that proposition. The old `report.md` section 7 suggestion that this convention should not be moved “backwards to Proposition 2.1” is an incorrect interpretation of reading order; proposition and lemma numbering are separate. A broader reduced-ring factorial-closure assertion is not supported by this locator.

This is a provenance/scope error in the old Argus comparison paragraph, **not** a refutation of the October manuscript or of the reviewed rigidity proof. That proof explicitly uses a characteristic-zero domain and proves factorial closure there, using nonzero factors. The exact statement actually needed is supported. There is no need to change a mathematical theorem to repair the citation commentary.

Other bibliography entries in the manuscripts identify background, motivation, or origin of methods. This review does not take their historical priority statements or classifications as additional proved conclusions. No external classification theorem is needed in the decisive elementary September construction, and the actual October lift is constructed in the reused algebraic implementation. No literature source was silently substituted for a missing proof.

## Historical claim versions and retired route

`C_SCOPE_PRIOR_ART` has three versions. V1 records the distinction between source existence, kernel validity and novelty. V2 adds `A_SUPPLIED_UPSTREAM`, explicitly an operator-supplied interface-existence assumption without a compiler certificate. V3 retires it because the selected local proof closure and wrapper have actual compiler evidence. That retirement is about the evidence available, not an independent novelty or fidelity approval. The assumption, its filer, its prose source, and its retirement reason remain visible in the index; it is not silently deleted or promoted into a theorem.

`C_STABLE_CORE_VERIFY` also has three versions with unchanged natural statement. V1 has no attached formal text. V2's attached wrapper fails elaboration at the October-rigidity specialization: the historical compiler exits 1 and error recovery produces `sorryAx` in dependent printed declarations. Lexical `proof_holes=[]` does not turn that failure into a certificate. V3 changes the goal-handling tactic to provide the intended degree-bound and annihilation proofs, without changing the assertion. Its compiler and axiom audit succeed.

The sole explicitly retired old ledger route is `R_STABLE_UNIVERSAL`. Its reason is version-specific supersession when the formal source was attached, not a mathematical counterexample or a dead theorem. The six other old ledger routes and two graph routes are retained in the index as historical dependency decompositions; none is silently described as retired. Historical port failures and queued job receipts are not extra mathematical routes or evidence of falsity. The latest 92-module build record has all modules marked `unchanged`; it is not a fresh rebuild.

The known insufficiency of a bounded derivation search is also explicit: finitely many checked derivations, equations, or sampled parameters cannot prove an unrestricted LND exclusion without an additional structural proof. The actual draft supplies a structural proof; the 81-check driver is only exact algebra support. No new attack or search was opened.

## Fresh replay and tool boundaries

The one full symbolic replay is `../september-construction-critical-point/exact_replay.json`, with command and versions in `exact_replay_run.json`: Python 3.13.5, SymPy 1.14.0, mpmath 1.3.0, exit 0, 81/81 checks and a byte-identical result. The driver was loaded under a non-main run name and its unchanged read-only `compute()` called; its writing entrypoint was not invoked. An initial missing-SymPy-metadata preflight ran no mathematical checks and is not a failed theorem test.

The one fresh Lean replay is `../october-unrestricted-obstruction/main_replay.json`: Lean 4.31.0, commit `68218e876d2a38b1985b8590fff244a83c321783`, `lean --stdin`, exit 0, 7.223 seconds, all eight axiom outputs foundational only. It re-elaborates the unchanged wrapper using preserved selected `.olean` imports and installed Mathlib. It does not rebuild or independently kernel-recheck all 92 imported objects. No new Lean file, new kernel certificate, or inherited independent statement-fidelity approval is claimed.

The Jacobian adapter was independently discovered and its exact `polynomial.multivariate.gcd.compute` typed contract inspected through the required interpreter:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian
```

The bounded request in `jacobian_payload.json` asks for \(\gcd(a,bd+1)\) over \(\mathbb Q[a,b,d]\), a specific coefficient-coprimeness fact in the determinant-domain proof. `jacobian_result.json` preserves the exact echoed request and typed monic result \(1\), operation id, server **0.14.0**, MCP protocol **2025-11-25**, and 1 ms operation runtime. The adapter exits **0**, with no timeout or structured error. This one rational-polynomial computation does not certify a universal-ring ideal equality, the determinant quotient's geometry, a line-bundle lift, or an entire paper. The accompanying proof that \(a\) is prime and does not divide \(bd+1\) works over the stated arbitrary field; no characteristic-zero generalization is inferred just from the rational GCD.

The older Jacobian request/result files in the inventory are historical normal-form evidence. The 81-check replay checks their consistency but does not call the old service again. A delegated preliminary normal-form contract probe used the legacy wrapper, contrary to the current canonical-interpreter directive; it is not used as the authoritative live adapter invocation or as mathematical proof. Its exact record is retained rather than relabelled. The canonical live discovery/inspection/execution above is the operation used in this dossier.

## Delivery limits

There is a specific unsupported historical source-scope comment, now corrected here. No unresolved mathematical gap was found in the separately checked claims, but September, the uniform family, total degree, and the full fibre/embedding corollary are not all conclusions of the eight printed Lean declarations. Their prose proofs must be read as such. Matching source/object names, hashes and modification times do not prove a fresh dependency rebuild; old reviewer judgements do not accept this review; bibliographic comparisons do not verify novelty.

The current ledger records engineering judgements, not fabricated mechanical or independent-review evidence. Both required campaign-local structural checks are run against campaign 9200049, with their actual exit statuses recorded in the summary. This exploratory corpus audit does not require a new theorem or a new proof graph outside its writable boundary. Final acceptance of coverage and findings belongs exclusively to the native Host-invoked independent Reviewer.
