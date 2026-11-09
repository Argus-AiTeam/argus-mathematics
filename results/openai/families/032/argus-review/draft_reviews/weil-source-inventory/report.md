# Weil source-inventory assessment

**Unit:** `weil-source-inventory`  
**Result:** source attribution/dependency inventory, with separate historical audit evidence distinguished.  
**Independent acceptance:** **pending native Host Reviewer**; Engineer assessment only.

## 1. Source, version, authorship and coverage reconciliation

The manuscript is OpenAI, *Weil classes and Hodge classes on abelian powers*, dated **October 6, 2026** as printed. The accessible source is:

`families/032/first-pass/openai_manuscript/Weil-classes-and-Hodge-classes-on-abelian-powers-October-6-2026/build/paper.tex`

Its old and reference copies match the five-paper manifest in campaign `9100032/MANUSCRIPTS.json`, source revision `4eaee87548250b2682affda7d05d947c05554bae`, SHA-256 `1ff56b1b900b70df2a8817ae90725f45ae74b267bb1568025bc4bcaa598c1c23`. This is content identity, not independent revision-history or theorem verification.

The substantive catalog is old `research/actual_group_audit/weil_tail_claims.json`, plus `populate_source_claims.py` and the old ledger/graph. The catalog explicitly covers **lines 1611–8285**, not the whole source. Its 28 contiguous logged ranges cover these **6,675 lines**; the actual accessible tail checksum agrees with `2c248b84aab0f94185ff96ffc7c8724b0411173cb1ada5e6c645704f86bf9a05`.

The required **49 distinct IDs** reconcile as:

* **16 earlier declarations**, extracted from source before line 1611 by the population script;
* **33 tail declarations**: one theorem, 14 lemmas and 18 propositions;
* **three detached tail proofs of already-existing earlier IDs**, not three additional claims:
  * `weil:p3ab:quadratic-five`: declaration 88–94, proof 1672–1722;
  * `weil:p3ab:split-sixfolds`: declaration 79–86, proof 1724–1834;
  * `weil:p3sw:weil-plane`: declaration 900–913, proof 8004–8024.

Thus 33 tail records alone would omit 16 indexed claims; counting the detached proofs again would duplicate existing claims. Their null earlier-declaration spans in the tail catalog are an explicit reading boundary, not evidence that the theorems are absent. This review matched all 16 earlier declarations to the actual accessible source and indexed text. All **49** statements/versions/spans, old ledger hashes and graph nodes/dependencies reconcile; no duplicate/superseded indexed versions occur.

The catalog also inventories **28 definitions, 36 proof environments, 60 citation commands/61 key occurrences/25 distinct cited keys, and 41 bibliography entries**. These counts describe the tail-reading exercise, not certification. Current direct reading was bounded to the main statements, tensor/CM-supply setup, detached deductions, the existing geometric bottlenecks and version-sensitive bibliography passages. Exact ranges are in `verdict.json`; structural extraction of the remaining declarations is not represented as a new full-source proof review.

## 2. Principal claims and exact conditional inputs

### Main low-dimensional assertions

**`weil:p3ab:split-sixfolds`** asserts rational HC in every codimension on every self-power of a complex abelian sixfold with a **unital imaginary-quadratic action** and an **actual compatible rational homological Hermitian form that is hyperbolic**, of signature `(3,3)`. Mere signature, an abstract unrelated form or a general-period assertion is insufficient. Product decompositions, special periods and extra endomorphisms are not excluded.

**`weil:p3ab:quadratic-five`** asserts rational HC on every self-power of every complex abelian variety of dimension at most five with a unital imaginary-quadratic action. The source obtains a compatible polarization by averaging; it does not demand hyperbolicity of every lower-dimensional proper summand.

These are source assertions whose printed proofs invoke independent actual groups, determinant supply, the tensor criterion and the **additional companion CM-Hodge theorem**. Catalog registration is not a proof of any of those inputs.

### The distinct Weil-plane theorem

**`weil:p3sw:weil-plane`** asserts algebraicity of the **whole rational Weil plane in `H⁶(A,Q)`**, in the image of `CH³(A)_Q`, for the actual hyperbolic sixfold setting. It does **not by itself** assert HC for all Hodge classes or all powers.

The source explicitly credits Markman2025Secant Theorem 1.5.1 and Markman2026ICM Theorem 1.2 (915–920), and follows a secant-sheaf/spin construction in its long geometric branch. This is source-reported attribution; the external Markman versions were not read or independently verified by this inventory assessment. No novelty is claimed for the catalog or inferred from the source's reproduction.

### Tensor criterion and CM supply

**`weil:p3:tensor-criterion`** (558–620) assumes:

1. a rational toric Hodge summand `H₀` and a **fixed geometry-chosen list** of CM embedding lines, including distinguished repeated occurrences;
2. admissible actual classical blocks and pair tensors;
3. **(c)** containment of the product of independent `Sp/SO/SL` standard factors in the **actual derived Hodge-group image**;
4. **(d)** CM supply for **every** determinant list, with arbitrary repetitions, whose bidegrees balance with one list of those fixed CM lines in **every scalar Galois conjugate**.

The conclusion is algebraicity of the corresponding balanced tensors and HC on all powers. The stronger saturated variant, not automatic, is needed for adjoining arbitrary CM factors. Fixed lists cannot be chosen anew to solve each balance equation.

CM supply is the image of **full cohomology** of CM varieties under rational correspondences, not only their Hodge classes. Source 280–334 distinguishes closure operations from the final step: a rational Hodge lift is algebraized using **OpenAICM2026 Theorem 1.1**. The fact that `p3:cm-operations` has no old graph prerequisites does not remove that additional-manuscript input.

## 3. What is catalog work, and what belongs to separate audits?

The inventory reproduces/decomposes source declarations, proofs' dependency lists, definitions, citation roles and ambiguities. All 49 indexed records are source assertions, many explicitly conditional on hypotheses; the external theorems and companion CM input remain distinct bibliographic/dependency roles. All 49 old formal-statement fields are empty. This catalog is not an independent proof of the geometric branch.

There are, however, **seven hash-bound historical supporting judgement links**, which must not be silently erased or misattributed to the catalog:

| Source IDs | Historical evidence provenance | Limited scope |
|---|---|---|
| `p3ab:albert-columns`, `p3ab:minuscule`, `p3ab:small-projections`, `p3ab:small-columns`, `p3ab:independence` | Old actual-group report; five Reviewer-labelled judgement records | Actual-column classification and independence, **condition (c)** |
| `p3ab:hyperbolic`, `p3ab:determinant-supply` | Old determinant-supply report; two Engineer-labelled judgement records | Hermitian/determinant-supply steps with that audit's imported inputs |

All seven judgement subjects match the exact old claim hashes. They are historical data, **not current native Host Reviewer acceptance**. The old source graph still labels these 49 nodes `open`; no current verdict is inferred from that label either.

The scope boundary is explicit in the actual-group report at 787–819: its dimension-at-most-six result addresses condition **(c)**, not determinant balance, CM supply, central-character independence, the CM theorem, HC, or the cycle construction. The separate determinant-supply report at 71–173 obtains all-powers CM-supply/rational-Hodge-lift conclusions for the two low-dimensional families, with HC conditional on the separate CM theorem. Crucially, it **imports Markman's Weil-plane theorem**; it does not audit the manuscript's geometric proof.

The routes therefore remain separate:

* actual columns/independence → **(c)**;
* the Weil-plane input → determinant supply and all-degree balance → **(d)**;
* the long geometric branch → local algebraicity/spread → the Weil-plane theorem.

The geometric proof does **not** invoke `p3ab:independence`. Neither actual-group nor determinant-supply support certifies that geometric branch, the companion CM theorem, or KS/Milne statements.

## 4. Decisive geometric obligations, not certified defects

The following describes the existing submitted source argument and its unresolved independent-verification obligations. It is not a new original-paper error search.

1. **Actual seed and sheaf, not numerical replacements.** The seed uses `d≥3`, `n=d+1`; the two Abel-orbit unions are each internally disjoint, not asserted disjoint from one another. Vanishing is for **all `Pic⁰` twists**. The marked trilinear lemma counts indices, the elliptic star uses order at least four and coordinate injectivity, and the finite-model lemma requires a regular finite-dimensional Noetherian base and a flat coherent sheaf. Local Tor/product-ideal assertions feed arbitrary base change and a genuine perfect coherent sheaf of rank `8d`, not just a K-theory class (2001–2022, 2055–2181, 2500–2798).
2. **Coherent action and full obstruction space.** Associative unital line-kernel compositors and the free finite quotient are required (2889–3010); separate isomorphisms, simplicity or reflexivity do not substitute. The Abel character, invariant orbit Ext and Künneth calculations assert
   `dim Ext²(source,source)^G = 6+36+6 = 48`
   for **full derived Ext**, with contraction rank 48 (4218–4240, 4331–4349, 4477–4486, 4584–4644). The rank sandwich and `σ∘ob=c` then assert full semiregularity (4695–4815). These are source calculations; this review did not replay them as independent exact certificates. `H²(End)` is insufficient.
3. **HH/Atiyah/Betti/spin dictionaries.** The raw jet is `a=-At_BF`; Betti characters carry `(2πi)^k`, and semiregularity target normalization is by **form degree**, not half total degree. HH left interior and finite Clifford contraction are distinct conventions. Enhanced Fourier–Mukai transport preserves evaluation and contraction kernels; it is not asserted equal to a separately normalized Betti transform or to arbitrary naturality of `σ` on Ext (3074–3271, 3500–3525, 3818–3849). The fixed Fourier/spin identity applies to all algebraic spin elements, not only those realized geometrically or Hodge-preserving (4899–5136).
4. **Actual polarized seed and exceptional character.** The source uses `a=-λ`, `u²=-d` and the actual second-linear homological form
   `h(x,y)=e(x,uy)+u e(x,y)`,
   not a guessed trace-dual convention. It distinguishes the ordered line stabilizer `{(g,t):t²=det g}` from the pointwise stabilizer `SL`; no rational square root of every determinant is asserted. Nonzero rational Weil components and Hodge type on the full compatible domain are separate assertions (5258–5697). This geometric spin stabilizer is not the actual derived-group independence theorem.
5. **Twisted descent and ordinary conversion.** Full derived duality, determinant-normalized finite-band descent, rationality by finite trace, and positive-rank trace/unit splitting need verification (5728–6110). Ordinary conversion uses a projective bundle of **lines**, an inverse-twisted `O(1)` and the construction `m=r¹²`; algebraic pushforward must recover the normalized character (6132–6195).
6. **Restricted projective-germ theorem.** Source 6380–6416 concerns an **ordinary coherent sheaf**, a smooth analytic base, a proper holomorphic submersion with relative ample line, injective full central semiregularity, and flat rational de Rham classes themselves in `F^k`. It is not a theorem about arbitrary perfect complexes or nonprojective deformations. BF coefficients/one-step/Artin character statements (6459–6936) concern the specific successive smooth-germ thickenings, not all Artinian extensions. Effectivity through analytic Quot/Artin approximation preserves the central quotient, not necessarily the complete formal tower (7044–7146).
7. **Local algebraicity, two generators, spread and all lattices.** Source 7520–7633 uses the above premises and ordinary projective extraction, then a suitable algebraic quadratic-field endomorphism to obtain two rational generators of the Weil plane, not merely one nonzero class. Analytic Hilbert spread (7666–7903) needs whole flat classes, proper good images through singular/nonreduced parameters and Baire. It does not require the compatible domain to be an algebraic Weil locus or a global algebraic quadratic action on the ambient fine family. The endpoint (7930–8024) uses a rational hyperbolic-basis isometry, a lattice-clearing algebraic isogeny and `u=2u₀`, `d=4d₀≥4`; it includes all compatible periods, not only general ones. The isogeny may scale the polarization by a square, and no rational spin lift is needed.

Each claim's exact source statement, proof ranges, explicit/contextual prerequisites, source citations and uncited standard inputs are retained separately in the JSON assessment. The absence of an independent Argus proof is not a claim that the source proof is false.

## 5. All eight existing source ambiguities

1. **Range boundary:** 1611 begins mid-exposition. Earlier declarations and three detached proofs are reconciled above, without pretending the tail reader read the head.
2. **Condition routing:** joint references to (a)–(c) do not collapse actual-group **(c)** into determinant supply **(d)**, and neither proves the geometric tail.
3. **Bibliographic locator scope:** “not cited in the tail” is not “unused in the manuscript.” The fine-level assertion at 7340–7341 cites **P3SWChai1985**, not `ChaiOortModuli`. No replacement locator was invented.
4. **Version metadata:** BF locators specify `math/0606730v1`; Etingof `2201.09397v4`; Floccari `2501.02315v2`; Floccari–Fu `2504.13607v2`; GLO `math/9812003v2`; Markman secant `2502.03415v2`; Moonen–Zarhin `math/9901113v2`. Milne's 2017 book uses corrected online **2022** numbering; Peters–Sterk has both “June 2024” and “16 September 2024”; Schrijver and van Geemen use author versions. The Stacks consultation date is a **manuscript assertion**, not this review's browsing event. No external version was retrieved or verified.
5. **Overloaded notation:** `d,n,K,J,I` have local meanings; in particular the spin stabilizer `J` is not actual Hodge-group independence.
6. **Signs/normalizations:** the seed `a=-λ`, homology/cohomology transpose, raw versus normalized Betti classes, BF sign, form-degree factors and two contraction conventions require explicit dictionaries; they are not silently identified.
7. **Uncited standard inputs:** duality, convolution, regular-local dimension arguments, Ehresmann, Baire and the analytic identity principle remain cataloged prerequisites where used. No imaginary theorem locator or externally verified assumption was manufactured for them.
8. **Certification boundary:** the catalog disclaims mathematical/citation certification. Neither that disclaimer nor external-source unread status establishes a proof or a defect. Historical separate audit evidence is bounded as in §3.

## 6. Exhaustive claim/source mapping

Every suffix below has prefix **`weil:`**; locators are in `build/paper.tex`. The full per-ID JSON contains the exact indexed statement and proof/dependency evidence. The first 16 entries are earlier declarations; the remaining 33 are tail declarations.

| ID suffix | Declaration lines |
|---|---|
| `p3ab:split-sixfolds` | 79–86; detached proof 1724–1834 |
| `p3ab:quadratic-five` | 88–94; detached proof 1672–1722 |
| `p3:cm-operations` | 289–296 |
| `p3:admissible-operations` | 372–380 |
| `p3:tensor-stabilizer` | 465–470 |
| `p3:toric-cm-factor` | 498–504 |
| `p3:tensor-criterion` | 558–620 |
| `p3:correspondence-transfer` | 731–751 |
| `p3sw:weil-plane` | 900–913; detached proof 8004–8024 |
| `p3ab:hyperbolic` | 935–946 |
| `p3ab:determinant-supply` | 982–999 |
| `p3ab:albert-columns` | 1128–1148 |
| `p3ab:minuscule` | 1232–1237 |
| `p3ab:small-projections` | 1288–1300 |
| `p3ab:small-columns` | 1355–1386 |
| `p3ab:independence` | 1495–1502 |
| `p3sw:seed` | 2001–2022 |
| `p3sw:support-trilinear` | 2055–2071 |
| `p3sw:support-elliptic-star` | 2109–2124 |
| `p3sw:support-finite-model` | 2162–2181 |
| `p3sw:support-local-tor` | 2658–2673 |
| `p3sw:relative-kernel` | 2699–2724 |
| `p3sw:coherent-sheaf` | 2782–2798 |
| `p3sw:coherent-action` | 2889–2927 |
| `p3sw:hh-triangle` | 3221–3271 |
| `p3sw:hh-transport` | 3818–3849 |
| `p3sw:abel-character` | 4218–4240 |
| `p3sw:invariant-orbit-ext` | 4331–4349 |
| `p3sw:invariant-ext` | 4477–4486 |
| `p3sw:invariant-one-factor-rank` | 4584–4587 |
| `p3sw:invariant-product-rank` | 4638–4644 |
| `p3sw:invariant-injectivity` | 4695–4727 |
| `p3sw:fourier-matrix` | 4899–4906 |
| `p3sw:spin-identity` | 5026–5040 |
| `p3sw:polarized-seed` | 5258–5288 |
| `p3sw:ordered-stabilizer` | 5442–5465 |
| `p3sw:exceptional-character` | 5560–5570 |
| `p3sw:hodge-circle` | 5640–5646 |
| `p3sw:descent-duality` | 5803–5820 |
| `p3sw:twisted-descent` | 5862–5901 |
| `p3sw:ordinary-conversion` | 6132–6195 |
| `p3sw:projective-germ` | 6380–6416 |
| `p3sw:bf-coefficients` | 6459–6484 |
| `p3sw:bf-one-step` | 6568–6578 |
| `p3sw:bf-artin-character` | 6916–6936 |
| `p3sw:local-algebraicity` | 7520–7525 |
| `p3sw:endpoint-two-generators` | 7600–7606 |
| `p3sw:spread` | 7666–7680 |
| `p3sw:endpoint-all-lattices` | 7930–7937 |

## 7. A concrete dependency-graph limitation

The population script uses only tail `proof_dependencies.claim_labels`, **not** `contextual_claim_labels`, equation/section links, citation roles or uncited inputs. For example, `p3sw:endpoint-all-lattices` has only `p3ab:hyperbolic` as an explicit old graph prerequisite, while the catalog records contextual dependence on the polarized seed, local algebraicity, two generators and spread. Its short graph edge list is not a short proof of the endpoint. Similarly, `p3:cm-operations` has no graph edge but explicitly uses the companion CM theorem.

The script's successful ledger/graph registration checks identity, schema and cycles, not mathematical soundness. Old empty assumption arrays do not override the source's printed imports. All cataloged substantive claims and the dropped contextual obligations remain visible in this assessment.

## 8. Outcome

The ledger-worthy factual findings are **49 reconciled IDs = 16 earlier + 33 tail**, three correctly deduplicated detached proofs, seven disclosed hash-bound separate judgements, matching accessible source/tail hashes, and the explicit dependency-projection limitation. No new mathematical theorem, manuscript defect or novelty is certified. The geometric seed/local-algebraicity tail, external inputs and full criterion cannot inherit acceptance from actual-group/determinant-supply work. These four inventory assessments do not complete the family. Acceptance remains pending native Host Reviewer.
