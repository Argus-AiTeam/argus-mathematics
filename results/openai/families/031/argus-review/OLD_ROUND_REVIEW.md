# Family 031: final exploratory old-draft review

**Final exploratory submission prepared; native independent project certification remains pending.** The old work supports a conditional uniform-Kummer bridge and exact stabilizer formula, not the manuscript's main theorem. The prior native Reviewer accepted the bounded review and ruled that no current proof graph is required by `OBJECTIVE.md`. This submission preserves that reviewed mathematics and its limitations; it does not resume the old adversarial error-search objective or claim a new publishable result.

## Coverage and provenance

`DRAFT_REVIEW_INDEX.json` accounts for **all 25 listed artifacts**, the **one reference-input directory**, **two old context versions**, **17 old claim IDs / 22 claim versions**, **17 evidence records**, and **four routes**. It groups the material into **11 mathematical review units**, each with `research/draft_reviews/<unit>/report.md` and `verdict.json`. Copies, source excerpts, citation metadata, checker data and the zero-byte lock are assigned explicit supporting or excluded roles, not counted as independent discoveries. The historical mission `C9000031@v1` is excluded as an objective, not silently omitted.

The preserved snapshot manifest records **five** family-031 members: the old ledger, graph, proof draft, exact certificate and verifier. Their archive sizes, existing manifest digests and exact live bytes match. The other twenty inventory artifacts and the reference directory are supplemental old-workspace inputs; this review does not pretend the snapshot preserved them. All 25 live artifact sizes match `PRIOR_DRAFTS.json`.

The reference manuscript is **OpenAI, *Open Homomorphisms of Global Solvably Closed Galois Groups*, October 5, 2026**, revision **`4eaee87548250b2682affda7d05d947c05554bae`**, as recorded in the existing campaign-9100031 `MANUSCRIPTS.json`. All eight local TeX sources match that manifest's existing digests and the corresponding canonical-source bytes. Neither manifest nor snapshot was rebuilt; all old inputs remain read-only.

The manuscript directory is a **symlink to the canonical source**, not an independent preserved copy. Following that specific reference yields the eight TeX files and one bibliographic `README.md`, with no Lean source. The old graph/assumption records also name three binary PDFs (Bass, Milne and Uchida) that are absent from this workspace and not inventoried. Their pointers are explicitly reconciled in the index; the actual source checks here use the available archived transcriptions, Bass page image and reviewer excerpts, not a fictional fresh reading of those PDFs.

## Every review unit

| Unit | Assessment and decisive reason |
|---|---|
| [kummer-completion](draft_reviews/kummer-completion/report.md) | **Supported conditional written lemma.** Finite-level Kummer plus the S-class exact sequence; multiplication by \(\ell\), not identity, on obstruction transitions kills the compatible finite-class obstruction. Bounded-cocycle rationalization and equivariance are justified without finite support. Covers `L_KUMMER_COMPLETE@v1-v4`. |
| [inverse-twist](draft_reviews/inverse-twist/report.md) | **Supported conditional written lemma.** Valuation independence, surjective inflation and finite-group restriction preserve independence. The natural Tate-twisted action gives \(\epsilon^{-1}\), with an explicit coboundary and a nonquadratic orientation check. Covers `L_TWIST_INJECT@v1`. |
| [missed-prime-ramification](draft_reviews/missed-prime-ramification/report.md) | **Supported conditional written lemma.** A surviving pro-\(\ell\) inertia subgroup forces Uchida's local case (ii); the target prime cannot be missed. The twist degree divides \(\ell-1\), so ramification of the twist extension causes no problem. Covers `L_RAMIFICATION@v1-v2`. |
| [stabilizer-multiplicity](draft_reviews/stabilizer-multiplicity/report.md) | **Supported exact formula under the classical S-unit input.** Each orbit contributes iff its stabilizer is killed by the character, and the added trivial representation must be subtracted. Complete splitting, real-to-complex places and the trivial twist are handled correctly. Covers `L_MULTIPLICITY@v1-v2`. |
| [uniform-missed-primes](draft_reviews/uniform-missed-primes/report.md) | **Supported conditional assembly.** Independent classes for every finite missed-prime set lie in that finite eigenspace; the nonnegative signature identity gives \(2[K:\mathbb Q]\), then \(+2\) for the target primes of \(\mathbb Q(i)\) above \(\ell\). Covers `C_UNIFORM@v1`. |
| [finite-support-shortcut](draft_reviews/finite-support-shortcut/report.md) | **False shortcut; valid explicit counterexample to the shortcut.** The compatible finite-level products \(\prod_{j<n}p_j^{\ell^j}\) have infinitely many nonzero valuation coordinates. They are not unramified outside finite \(S\), so they do not refute the Kummer lemma or manuscript. Covers the retired `R_FINITE_VALUATION_SUPPORT`. |
| [general-target-extension](draft_reviews/general-target-extension/report.md) | **Supported with explicit inherited hypotheses.** Finite class number replaces principality, radicals still factor through \(P_N\) for finite \(N\subset\mathbb Q^s\), and the final constant becomes \(+g_\ell(N)\), not always \(+2\). This extension was not separately versioned or judged in the old ledger. |
| [open-map-extension](draft_reviews/open-map-extension/report.md) | **Supported with logarithmic compatibility retained.** Restriction to an open image is injective on characteristic-zero \(H^1\), using its normal core and averaging. No target-prime relabelling or index factor is needed; openness alone does not supply the logarithmic hypothesis. |
| [character-normalization-context](draft_reviews/character-normalization-context/report.md) | **Not certified by the old bridge.** Exact log-rank, character-detection, signed-character, amplification and normalized-map obligations are identified. Rational S-unit multiplicity cannot substitute for the actual local logarithm-rank argument. Covers four old claim versions. |
| [arithmetic-matching-context](draft_reviews/arithmetic-matching-context/report.md) | **Partial contextual support, not certification.** The finite-fiber mechanism is conditional on the character prerequisites; simultaneous overlapping-list power separation, local norm exponents and the same-characteristic deduction remain concrete obligations. Covers four old claim versions. |
| [anabelian-identification-context](draft_reviews/anabelian-identification-context/report.md) | **Not certified by the old bridge.** Identify the normalized map up to conjugation, check the distinct external anabelian inputs and reductions, and obtain full cyclotomic equality plus embedding existence/uniqueness. Selected logarithmic equalities permit finite twists and are not the full adelic criterion. Covers three old claim versions and accounts for the excluded historical objective. |

These are seven supported conditional arguments/extensions, one refuted shortcut and three explicitly uncertified context groups. The latter are not access failures or blanket opinions about the manuscript: each report states the actual proposition, hypotheses, dependency and missing certification. No fresh search for manuscript errors was undertaken.

## Strongest result retained, not inflated

For the specified continuous surjection \(f:G_K\to P_{\mathbb Q(i)}\), odd \(\ell\), and equality of cyclotomic logarithms, let \(\epsilon=(\chi_\ell f)/\chi_{K,\ell}\), \(F=\overline K^{\ker\epsilon}\). Then the reviewed written proof gives
\[
 \#\{w\text{ missed}:w\nmid\ell\}
 \le r_{1,\mathrm{split}}(F/K)+r_2(K)
       +g_{\ell,\mathrm{split}}(F/K)-[\epsilon=1].
\]
The underlying strongest character formula is
\[
 \dim(U_S\otimes\mathbb Q_\ell)^\theta
 =\sum_{v\in S/\Delta}[\theta|_{D_v}=1]-[\theta=1].
\]
The inverse-character orientation, inertia at ramified twist primes, simultaneous outside-\(S\) valuation kernel, and augmentation correction are essential, and have been checked as written mathematics. None is replaced by a count of examples.

This is the same strongest conditional mathematical result already supported by the old reviewer-tagged evidence and the subsequent native bounded acceptance. The review added exhaustive scope/version reconciliation and the recorded replay, **not a new theorem or novelty claim**. Relative to that accepted review, this final submission changes only the submission status and reconciles the obsolete graph blocker with the native ruling; no mathematical claim, hypothesis, attribution or evidence is strengthened. The proposed extensions retain their explicit hypotheses. Full normalization, same-characteristic matching and the unrestricted main theorem remain separate.

## Sources and old review reconciliation

| Input actually used | Exact cited proposition and preserved evidence |
|---|---|
| Finite Kummer theory | Stacks `stacks:03PK`, Lemma 59.28.1 / tag 03PL and the following \(H^1\)-Picard sequence; invertibility of \(\ell\) holds on the S-integer scheme. Old `reviewer-finite-kummer.txt` and `c0277005786d7c14e39a0bb319be4497.json`. |
| Finite class number | Milne, ANT **v3.08, July 19, 2020**, Theorem 4.4, p. 70; S-class finiteness follows by quotient. Old `reviewer-class-finiteness.txt` and `27ccd20493b8fe8c80cefed0afe5f3f4.json`. |
| S-unit finite generation and representation | Bass, DOI `10.1017/S0027763000026258`, Section 3, Lemma (Dirichlet, Artin--Tate), pp. 402-403. Old `reviewer-bass-units.txt`, page-402 image, `7076545e94dc543e6ca89d45d260ab2d.json` and `e7f1e2ab1777d1012d8420f664fb0c1d.json`. No unramifiedness or total-imaginarity hypothesis is inserted. |
| Local correspondence | Uchida, DOI `10.2969/jmsj/03340595`, Section 1, pp. 595-596, uniqueness and case (ii), with case (iii) excluded for odd \(\ell\). Old `reviewer-uchida-local.txt` and `c973a66be116b913f3670513826e22fd.json`. Global cofinite Proposition 1 is not an input. |

The archived primary passages were checked against the reviewer excerpts. The two older DOI-resolution records are only **inconclusive** existence checks; the five later `reviewer:copilot` literature records supply the actual proposition attributions. The current ledger retains those historical records with their original producer and absolute old-artifact paths, rather than fabricating a new current Reviewer approval.

The old ledger also has ten supports judgements, one engineer and one reviewer for each latest bridge/lemma version. The graph still leaves all 17 nodes open and has no routes. These graph labels are stale with respect to the written-proof support, but not a license to assert a kernel proof or close the manuscript. Earlier lemma versions record progressively fewer assumptions and do not inherit later judgements silently.

## Computation, formal evidence and limits

The existing verifier was inspected and executed read-only with the mandated legacy interpreter. Its initial missing-SymPy failure is retained, and was resolved without installation or shared changes by explicitly using the already installed live-update SymPy package path. `draft_reviews/uniform-missed-primes/replay.json` records **Python 3.13.5 / SymPy 1.14.0 / mpmath 1.3.0**, the exact command/environment, exit **0**, **33 exact checks**, **7 boundary fixtures**, and **16 rejected built-in corruptions**. Those fixtures do not construct the required maps or refute the manuscript.

That local run validates **archived** Jacobian output. Separately, a small discovery, exact contract inspection and **one fresh** `matrix.symbolic.multiply.compute` operation were performed through the mandated live-update adapter, never by importing Jacobian. The exact payload, typed result and status are under `draft_reviews/stabilizer-multiplicity/jacobian_*.json`: server **0.14.0**, protocol **2025-11-25**, adapter exit **0**, no timeout, no structured error, output equal to the archive. The product checks only the geometric-sum successor residual.

No relevant Lean source or Lean certificate is claimed by this inventory. Consequently there is **no compiler theorem or kernel closure** to report. Manuscript statement fidelity was assessed separately in prose; it was not inferred from a symbolic calculation. The external arithmetic inputs and the full manuscript context remain outside the checker's mechanical scope.

## Campaign-local validation and prior native ruling

The preserved official checks were run against exactly
`campaigns/9200031`, not the shared batch root. `draft_reviews/validation.json` preserves both commands, stdout/stderr and the actual statuses:

| Official command, using `$WORKSPACE/argus-live-update/.venv/bin/python` | Historical exit |
|---|---|
| `-m argus_skill.verticals.math.math_state check --project-root campaigns/9200031` | **0** |
| `-m argus_skill.verticals.math.proof_graph_check check --project-root campaigns/9200031` | **2** |

The second check reports **no `research/PROOF_GRAPH.json`**; both zero statuses have **not** been achieved. The subsequent native reviewed handoff at `$WORKSPACE/.argus-campaign-9200031/projects/ced420d3eb42/handoffs/630676dd6f4c/round-0001.json` has status **done** and explicitly rules: "The missing current proof graph is not required by OBJECTIVE.md and does not block acceptance." That ruling resolves the earlier applicability conflict for this exploratory old-draft review. No graph is constructed, no checker result is relabelled, and no mathematical statement is weakened.

The preserved citation-status command exits **0**, reports no blocking citations, and confirms all current cited assumptions through the five reused historical Reviewer records (`draft_reviews/citation_status.json`). The coverage/JSON reconciliation is recorded in `draft_reviews/coverage_check.json`. Its graph-blocker and acceptance fields describe the pre-ruling state, not the current submission. These historical receipts remain unchanged; their checks, the source lookups, the verifier and the Jacobian operation are not repeated for unchanged dependencies.

The bounded native acceptance supports this submission but does **not** constitute the explicit final exploratory project certification now requested.

## Acceptance boundary

The final submission is the existing coverage index, all eleven paired unit assessments, this synthesis and `research/MATH_STATE.json`, with their already reviewed source and replay evidence. The ledger records only the scoped review findings and their classical assumptions, with engineer judgements distinguished from reused historical literature evidence. It does not import the old objective, declare novelty, lower the Manager's exploratory target, or self-accept the family.

The native Host-invoked independent Reviewer must explicitly certify the entire review as the **final exploratory project submission**: complete artifact and claim-version coverage, substantive assessment of every unit, faithful hypotheses and attribution, justified decisive arguments and dependencies, and the separation between supported conditional results, the failed shortcut and uncertified manuscript obligations. This certifies the review's completeness and faithfulness, not the manuscript's unrestricted main theorem. The project remains incomplete until that final Reviewer **done** verdict and explicit exploratory certification are durably persisted by the Host in the final-submission record; the earlier bounded receipt and Engineer's submission preparation cannot substitute for them.
