# Review of the old family-009 drafts

**Both substantive local proof units are supported at their exact preserved scope.** The review accounts for all **35 inventory artifacts**, **18 versions of 15 historical claims**, **13 evidence entries**, three contexts and four routes. The Engineer has not accepted this review: the native Host-invoked independent Reviewer must assess the complete index and both units.

The official current-project gate is **blocked**, not passed: checks using `$WORKSPACE/argus-live-update/.venv/bin/python` against `campaigns/9200009` returned **0** for `math_state check` and **2** for `proof_graph_check check`, because this campaign has no `research/PROOF_GRAPH.json`. The historical graph is an input, not a substitute current graph. No graph or success-shaped replacement was created.

## Whole-objective final submission

The native Reviewer recorded `status: done` in [handoff 1555e8a2fde1, round 1]($WORKSPACE/.argus-campaign-9200009/projects/050127806a97/handoffs/1555e8a2fde1/round-0001.json), accepting the complete coverage and both local assessments at **bounded review scope**. That decision expressly did not require the missing current graph for the bounded review. It is not the Host-recognized final certification of the entire exploratory objective requested here. Final certification remains pending; the Engineer has not issued it.

The current submission's direct mapping was checked: every inventory path appears exactly once, all 18 claim/version keys are unique, unit and claim dependencies and duplicate references resolve, and both report/verdict pairs agree with their indexed main claim versions and hashes. The accepted mathematical assessments and source bindings are reused; no conflicting dependency was identified by this mapping check, and no new source-integrity audit, compiler run, diagnostic replay, snapshot, manifest, or certificate was produced.

| Required deliverable under `OBJECTIVE.md` | Completed evidence submitted |
| --- | --- |
| Complete grouping, claim/evidence accounting, dependencies, duplicates and exclusions | [DRAFT_REVIEW_INDEX.json](DRAFT_REVIEW_INDEX.json): `artifacts`, `claim_versions`, `ledger_evidence`, `contexts`, `routes`, and `reference_inputs_and_tooling`. |
| Intersection unit assessment and verdict | [Report](draft_reviews/char-p-intersection/report.md) and [verdict](draft_reviews/char-p-intersection/verdict.json), bound to `V_CHARP_INTERSECTION@3`. |
| Dependent line-recovery unit assessment and verdict | [Report](draft_reviews/char-p-line-recovery/report.md) and [verdict](draft_reviews/char-p-line-recovery/verdict.json), bound to `V_CHARP_LINE_RECOVERY@2` and its unchanged intersection dependency. |
| Exact statements, hypotheses, attribution, decisive arguments, toolchain, assumptions and statement fidelity | Both unit reports and verdicts; the index's `binding_results` and `ledger_evidence`. Historical compilation is distinguished from fidelity, prose bridges and bounded diagnostics. Neither unit identifies a decision-relevant replay obligation. |
| Every-unit summary and concrete unresolved scope, without a new error search or novelty claim | This summary and both reports: the two local units are supported; projective lifting, multiplicative normalization, perfect-core recovery and complete reconstruction remain outside their certificates. |
| Independent decision on completion of the entire old-draft review | **Outstanding:** native Host-invoked final exploratory certification. The earlier bounded acceptance is supporting review evidence, not this final decision. |

## Coverage and sources

The complete machine-readable accounting is [DRAFT_REVIEW_INDEX.json](DRAFT_REVIEW_INDEX.json). It assigns every inventory artifact and every historical claim version a disposition, including obsolete prose versions, the inconclusive scanner record, duplicate fidelity documents, the imported intersection proof, binary cache, logs, receipts, and downstream claims for which no Argus proof draft was supplied.

The mathematical comparison uses manuscript **Reconstruction from Milnor K-theory modulo the characteristic**, revision `4eaee87548250b2682affda7d05d947c05554bae`, identified by the read-only reference manifest. All seven listed TeX files match that manifest in both the primary source directory and the historical reference copy. All 20 family-009 entries in the preserved snapshot manifest match both the live historical files and the archive bytes; the archive was read without extraction. All 35 inventory entries exist at their listed sizes. The other 15 entries are not falsely represented as snapshot-hashed.

The historical workspace and snapshot were not modified. No old certificate was regenerated, no Lean source was created or changed, and neither old checker was executed. In particular, the line-recovery checker was not run in its historical directory, where it writes logs and replay artifacts.

| Unit | Assessment | Exact supported scope | Boundary |
| --- | --- | --- | --- |
| [char-p-intersection](draft_reviews/char-p-intersection/report.md) ([verdict](draft_reviews/char-p-intersection/verdict.json)) | Supported | `prop:intersection`, common \(0<n<p\), nonzero affine coefficients, uniqueness from either single inclusion; removal of ambient finiteness | Formal `intersection_exponent` assumes all ambient p-th powers lie in the coefficient field. The weaker coordinate-powers-only form is a justified prose localization, not a separately compiled signature. |
| [char-p-line-recovery](draft_reviews/char-p-line-recovery/report.md) ([verdict](draft_reviews/char-p-line-recovery/verdict.json)) | Supported; depends on intersection | Unique scalar line-onto correction on the actual multiplicative and Steinberg quotients of fields with finite degrees over their p-th-power subfields, both at least \(p^2\); includes \(p=2\) | Function-field specialization, p-rank terminology and the separately named Milnor-K comparison have explicit prose bridges, not separate Lean declarations. Full reconstruction is not certified. |

These are two units, not copies counted as contributions. `ReviewedIntersection.lean` is byte-identical to the first unit's source. Each underscore/hyphen fidelity-document pair is identical. The `.olean` is a runtime cache, not an independent proof or a snapshot-bound source certificate. No substantive Argus draft for either of the other two family-009 manuscripts occurs in this inventory; their presence in the reference tree does not imply they were verified.

## Decisive mathematical assessments

**Intersection.** For \(C=F^p\), nonzero p-independent \(X,Y\), nonmonomial \(U\in C(X)^\times,V\in C(Y)^\times\), and an actual nonzero intersection witness, the coordinate Euler derivations produce nonconstant nonzero corrections \(A=U/D_XU-1\), \(B=V/D_YV-1\). The witness equations and their derivative give
\[
(B D_XA-A D_YB)D_XZ=0,\qquad D_XZ\ne0.
\]
Thus the two logarithmic weights agree, lie in \(C(X)\cap C(Y)=C\), and force a common nonzero residue \(m\). Integration with \(n=p-m\) proves both nonzero-coefficient affine-power identities. A competing inclusion for either input forces its correction weight to be \(-r\), hence \(r=n\); both inclusions are not required.

All relevant objects lie in the degree-\(p^2\) field \(C(X,Y)\), so ambient finite p-rank is unnecessary. For the still weaker prose form, \(X^p,Y^p\in k\) makes the p-monomial span a field: every element has its p-th power in \(k\), and a nonzero element has inverse \(w^{p-1}/w^p\). This verifies the claimed localization while preserving the distinction from the literal global-`hpowers` Lean signature.

**Line recovery.** The actual Steinberg quotient admits a logarithmic determinant descended through its actual relations. Constructed Euler derivations make this determinant nonzero on an independent pair, proving the required zero-symbol implication without assuming logarithmic-symbol injectivity. For \(u=x+a,v=y+b\), the nonzero identity witness \(z=bx-ay=bu-av\), symbol compatibility, and proved nonmonomial conditions satisfy every intersection-theorem hypothesis. Single-inclusion uniqueness synchronizes the exponents across all affine parameters and the connected multipartite graph. Containment for the inverse and scalar rigidity then prove actual line-image equality and uniqueness, rather than inferring onto-ness from ambient bijectivity. The argument includes characteristic two and competing corrections that send lines onto arbitrary target lines, not merely pre-normalized endpoint lines.

The finite-p-degree generalization is literally formalized. Its function-field specialization is supported in prose: for a transcendence basis with rational field \(F_0\) over a perfect base, \([F_0:F_0^p]=p^d\), and Frobenius identifies \(F/F_0\) with \(F^p/F_0^p\). The finite tower formula gives
\[
[F:F_0]p^d=[F:F^p][F:F_0],
\]
so \([F:F^p]=p^d\), even when \(F/F_0\) is inseparable. Algebraically closed bases and \(d\ge2\) supply the exact formal hypotheses.

Two terminology bridges must not be hidden. A finite exponent-one extension is built by strict adjunctions of degree \(p\); hence its degree is \(p^e\), where \(e\) is its p-basis rank. Also, for the abelian multiplicative group \(M=F^\times\),
\[
(M/pM)\otimes_{\mathbb F_p}(M/pM)
 \simeq (M\otimes_{\mathbb Z}M)/p(M\otimes_{\mathbb Z}M).
\]
Quotienting by the images of the Steinberg generators therefore gives \(K_2^{\mathrm M}(F)/p\). These elementary prose identifications explain the manuscript terminology; the root Lean theorem already uses the literal quotient and proves the needed representative-level projective incidence.

## Reconciled historical evidence

The decisive historical support is:

| Claim/version | Exact claim hash | Applicable historical Reviewer entry |
| --- | --- | --- |
| `V_CHARP_INTERSECTION@3` | `bc454725f6e3913984e01e96fb83ae34f15ce44a47d81fa073dac264680d9bcb` | `judgement-V_CHARP_INTERSECTION-d2a910e000f2` |
| `V_CHARP_LINE_RECOVERY@2` | `2dec3ca27a700e683844670f57f98b34c7f1b7d0483439ce103208e86f7706e1` | `judgement-V_CHARP_LINE_RECOVERY-b3db4b875762` |

For each claim, the certificate subject, mechanical record, Reviewer subject and certificate path agree exactly. The embedded source equals both the ledger's formal string and the live preserved source; embedded fidelity equals the preserved reading, and source/fidelity hashes match. Each live `lean_check.json` equals the corresponding archived compiler record. The line dependency's source and certificate bindings also match the reviewed intersection source and certificate.

The successful records are historical **Lean 4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`, using the built Mathlib workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`. Both compiler and axiom-audit exits are 0, with no proof holes and only `propext`, `Classical.choice`, `Quot.sound` in the reported final axiom closures. Reusing these unchanged reviewed records is not a fresh compiler run. Compilation establishes encoded statements; the present reports separately assess their fidelity to sections 03 and 04.

Consequently, the old reports' progress text, `pending_host_reviewer` strings in generated exact certificates, and open graph labels are not evidence that these exact local versions lack historical independent support. They also do not authorize current acceptance: the present review still needs native independent examination. Engineer opinions on helper claims are not mislabeled as independent review, nor are separate mechanical records invented for prose-only helper placeholders.

The earlier intersection v2 record did **not** run the compiler. Its lexical scanner flagged the identifier `constant`; v3 changes only that helper name and five calls to `scalar_of_zero`. There is no changed theorem or mathematical repair to infer. Similarly, the two retired prose-goal routes were superseded by formal-source bindings, not refuted mathematical approaches. Their exact reasons are retained in the index/current-ledger provenance.

The strongest prior result already contained both local formal proofs and applicable Reviewer support. **This review adds no stronger theorem.** Its improvement is complete artifact/version accounting, source-faithful verification of the already-claimed strengthenings, and explicit separation of local proofs from the remaining reconstruction obligations.

## Diagnostics, assumptions and unresolved scope

The preserved intersection computations cover primes 2, 3, 5 and 7, 6,246 basis-product checks, 13 constructed witness/exponent cases, and one negative control. The preserved line diagnostics cover 16, 81, 625 and 2401 affine assignments and 61 binomial-coefficient checks. These are supplementary exact experiments, not universal proofs. A historical `state=submitted` receipt is not a terminal mathematical result.

The old typed Jacobian checks are likewise bounded: a nullspace for \(D_X+D_Y\) over \(\mathbb F_2\), and a coefficientwise polynomial identity at modulus 2. One new, isolated **scope diagnostic**, not a replay of either old operation payload, computes the stacked joint operator \((D_X,D_Y)\) on formal coordinates \((1,x,y,xy)\). It has nullity 1 and basis \((1,0,0,0)\), unlike the old sum operator's nullity 2 and basis \((1,xy)\). This supports the diagnostic-scope distinction only; it proves no field-theoretic proposition. The exact payload, inspected typed contract, complete output, operation id, server `0.14.0`, protocol `2025-11-25`, adapter exit 0, null error and no-timeout status are retained in the index and dedicated JSON files. No theorem-dependent replay was needed.

The source propositions and methodological antecedents belong to the manuscript; the Argus work is a reproduction/alternate formal reconstruction with the stated broader hypothesis envelope. Cadoret-Pirutka is reported as the manuscript's attribution, not an independently checked priority claim or an external proof premise. No novelty is claimed. Local unpublished sources are identified by their actual paths, revision and existing source bindings; the current ledger openly labels them `uncited` in the bibliographic-registry sense rather than inventing a DOI or arXiv identifier.

The concrete remaining **draft-evidence** gap is beyond the two local theorems: no supplied Argus certificate implements the projective semilinear lift, its multiplicative normalization, perfect-core recovery, or the complete reconstruction bijection. Thus `L_CHARP_PROJECTIVE_LIFT@1`, `L_CHARP_PERFECT_CORE@1`, and `C_CHARP_RECONSTRUCTION_UNVERIFIED@1` remain unresolved by these drafts. No defect in the manuscript's separate proofs is alleged, and no new reconstruction project was attempted.

**Native disposition requested:** examine this submission against the entire `OBJECTIVE.md`, including the complete coverage index and both substantive assessments, and persist the Host-recognized final exploratory certification or return a precise remaining gap. Reuse the earlier accepted findings unless a dependency changed or conflicts. The missing current proof graph remains a recorded official-gate failure, not a mathematical failure; the earlier bounded acceptance neither changes its exit status nor supplies final certification.
