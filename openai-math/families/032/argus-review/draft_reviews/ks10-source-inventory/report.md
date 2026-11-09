# KS10 source-inventory assessment

**Unit:** `ks10-source-inventory`  
**Result:** attributed source inventory; no independent mathematical proof supplied by the catalog.  
**Independent acceptance:** **pending native Host Reviewer**. This is an Engineer assessment, not acceptance.

## 1. Source, authorship, version and review boundary

The source is OpenAI, *A Conditional Reduction for Algebraic Kuga–Satake Correspondences*, dated **September 10, 2026** as printed. Its accessible old source root is:

`families/032/first-pass/openai_manuscript/A-Conditional-Reduction-for-Algebraic-Kuga-Satake-Correspondences-September-10-2026/`

The reference manifest `campaigns/9100032/MANUSCRIPTS.json` includes this paper at source revision `4eaee87548250b2682affda7d05d947c05554bae`. All ten old TeX files and their accessible reference copies match the manifest's corresponding hashes. For example, `build/paper.tex` has SHA-256 `2a4352880ca17efa86debef0bbd65700a82c7a6871715f0cae44ac7c00e63355`. This establishes content identity to the manifest, not an independently reconstructed revision history.

The reviewed Argus draft is the KS10 portion of old `research/actual_group_audit/other_manuscript_claims.json`, together with its registration by `populate_source_claims.py` and its old ledger/graph records. The original paper is reference material, not another authored Argus proof. The catalog calls its work `bounded_source_reading_and_decomposition`, `asserted_unverified`, with external sources unread and mathematical certification false. Those settings are neither a proof nor evidence of a manuscript error.

Its documented coverage comprises **10 files, 1,810 lines, 40 records, 21 formal theorem/lemma/proposition/corollary declarations, seven context records and 18 bibliography entries**. Logged ranges cover those accessible files without a line-count disagreement. This review directly read selected decisive passages, rather than independently repeating a full-source proof audit: introduction 1–75; cycles 1–116; Clifford 1–190; generic argument 129–377; specialization 75–220 and 354–423; special-data argument 1–243; dependency table 1–163; and the main-file header. File hashes and precise review ranges are in `verdict.json`.

## 2. Principal statements and indispensable hypotheses

Let `(S,h)` be a complex primitively amply polarized K3 surface, `h²=2d`, `V=h⊥⊂H²(S,Q)` with its cup form of signature `(2,19)`, and `T=NS(S)_Q⊥`.

* **`ks10:main:generic`** assumes `Hg(V)=SO(V,q)` (so here `T=V`). It asserts equivalence of: an actual rational codimension-two cycle on `S×B`, for some abelian variety `B`, acting nontrivially on `V`; a dominant generically finite morphism `Y→S` from a smooth projective surface with nonzero traced wedge of holomorphic one-forms; and algebraicity of every prescribed standard full Kuga–Satake tensor. No general-period hypothesis on `B` is imposed. The cover and the nonzero correspondence are genuine existence inputs, not merely Hodge tensors.
* **The exact target** is a rational codimension-two cycle on `S×A×A` inducing the specified `κ_S:T→H¹(A)⊗H¹(A)⊂H²(A²)`. The data include an arbitrary prescribed rational quadratic Hodge polarization on `T`, the **full even Clifford** weight-one realization, an invertible odd right multiplier, rational duality/polarization, and a stipulated isogenous abelian model. An arbitrary nonzero map or one simple spin constituent is not this assertion.
* **`ks10:main:specialization`** assumes actual nonzero input exists very generally in the chosen polarized component, and concludes the prescribed tensors are algebraic for every fiber in that component. Witnesses need not themselves form one algebraic family. The local formulation excludes countably many proper analytic subsets of full period charts before the Hilbert argument.
* **`ks10:main:all-degrees`** additionally requires the corresponding existence hypothesis in the required components in **every degree**. One component or one degree does not establish that conclusion for all K3 surfaces.

The unrestricted Kuga–Satake algebraicity conjecture is separately inventoried, not established by this conditional reduction. Absolute-Hodge or motivated realizations do not supply the actual algebraic-cycle existence premise.

## 3. What the Argus draft contributed

The draft contributes source reproduction, namespace/label attribution, context and import separation, a dependency decomposition, and existing unverified checkpoints. Its 40 records divide into:

| Catalog role | Records |
|---|---:|
| Conditional conclusion | 12 |
| Manuscript assertion | 8 |
| Established import **as cited** | 16 |
| Explicit assumption | 3 |
| Conjecture | 1 |

These are not 40 newly proved theorems. In particular, `cyc:h1` is classified as an import although the source also gives a standard argument. “Established import as cited” describes the manuscript's treatment, not external verification by this review. Examples include weight-one algebraicity, semisimplicity, representation theory, Hilbert representability, Cartier classes, proper analytic images and GAGA. Source bibliographic locators, including Huybrechts's linked prepublication version rather than an interchangeable book pagination, remain attributed inputs.

All **40 distinct indexed IDs occur exactly once**, at version 1. Indexed statements and declaration spans match the catalog; the old ledger's natural statements, hashes and versions and the old graph's statements, source spans and dependencies match the index. There are no duplicate/superseded indexed versions. Deliberate overlaps between an introductory theorem and its separately cataloged premise are not additional proofs or duplicate IDs.

All 40 old formal-statement fields are empty; these indexed source records have no old evidence-ID links. The graph's historical `open` statuses are not current verdicts. Conversely, no absence of a formal proof is treated as a defect in the source mathematics.

The population script registers claims and filters dependency references. It does not derive mathematical statements. Input-classified nodes receive no outgoing premise edges; introductory context references and nonclaim section/equation references are filtered. Thus an empty dependency list or empty old `external_assumptions` field does **not** make a theorem unconditional or externally verified. Old schema/acyclicity checks establish bookkeeping properties only.

## 4. Decisive source evidence and all existing flags

The following are dependency obligations, **not certified gaps or refutations**:

1. **`flag:ks10-input-existence`.** Introduction 36–65 explicitly retains the actual-cycle/cover and very-general existence hypotheses. The catalog does not construct such an input in even one component, much less every degree. This is the decisive boundary on unconditional conclusions.
2. **`flag:ks10-standard-data`.** Clifford 30–190 and special-data 15–243 distinguish left Clifford action, full parity multiplicities, the right odd multiplier, orientation, duality and ordered tensor slots. For polarization changes, the source uses signed square roots and connected spin lifts, then sign averaging and rational descent. The quadratic-change endomorphism is not assumed to be algebraic on the K3 factor. An audit would need to verify the Hodge intertwining, signs and low-rank/opposite-polarization cases, full multiplicities and exact final tensor, not just abstract representation equivalence.
3. **`flag:hilbert-whole-class`** (shared with KS30). Specialization 75–220 uses fundamental cycle multiplicities for nonpure/nonreduced fibers, marked classes, resolved Hilbert parameters and fixed rational coefficients; 354–423 constructs and specializes the **whole flat primitive/target-projected class** before restricting at Picard jumps. Algebraicity only of a generic transcendental action is insufficient. Proper images, singular/nonreduced parameter behavior, and the final exact-data restriction remain mathematical obligations.

Other central source steps are explicitly inventoried rather than omitted: the cover/correspondence equivalence (cycles 54–116); the joint-group and width restriction; vector multiplicity one and generation of the full target by independent slot maps with rational cycle-span descent (generic 129–377); and primitive-to-transcendental restriction at special fibers. Reading these passages establishes what argument the source submits and which hypotheses it uses, not that every step has been independently proved by Argus.

## 5. Exhaustive source/claim mapping

Paths below are relative to the source root; `build/` is suppressed. IDs have the common prefix **`ks10:`**. These are declaration/input locators, not an assertion that the corresponding proofs were all independently audited. `verdict.json` gives the exact indexed statement, source/catalog/graph evidence, role, imports and obligations separately for **every** ID.

| ID suffix | Source and lines |
|---|---|
| `main:generic` | `sections/introduction.tex:36–53` |
| `main:specialization` | `sections/introduction.tex:57–61` |
| `main:all-degrees` | `sections/introduction.tex:63–65` |
| `conjecture:unrestricted-ks` | `sections/introduction.tex:3–5` |
| `input:nonzero-correspondence` | `sections/introduction.tex:39–43` |
| `input:surface-cover` | `sections/introduction.tex:44–49` |
| `input:very-general-existence` | `sections/introduction.tex:57–61` |
| `cyc:h1` | `sections/cycles.tex:10–18` |
| `cyc:projectors` | `sections/cycles.tex:24–30` |
| `cyc:descent` | `sections/cycles.tex:41–48` |
| `cyc:equivalence` | `sections/cycles.tex:54–56` |
| `cliff:construction` | `sections/clifford.tex:30–40` |
| `cliff:slots` | `sections/clifford.tex:142–150` |
| `gen:genericity` | `sections/generic.tex:15–21` |
| `gen:joint-group` | `sections/generic.tex:78–87` |
| `gen:width` | `sections/generic.tex:129–145` |
| `gen:vector-multiplicity` | `sections/generic.tex:212–218` |
| `gen:generation` | `sections/generic.tex:254–269` |
| `spec:hilbert-map` | `sections/specialization.tex:12–25` |
| `spec:flat-cycle` | `sections/specialization.tex:75–87` |
| `spec:specialization` | `sections/specialization.tex:134–146` |
| `spec:local` | `sections/specialization.tex:230–258` |
| `spec:primitive` | `sections/specialization.tex:354–363` |
| `data:restriction` | `sections/special_data.tex:15–19` |
| `data:polarization` | `sections/special_data.tex:45–51` |
| `import:hodge-theory` | `references/dependency-table.tex:23–30` |
| `import:semisimplicity` | `references/dependency-table.tex:32–37` |
| `import:algebraic-groups` | `references/dependency-table.tex:39–47` |
| `import:k3-deformations` | `references/dependency-table.tex:49–57` |
| `import:classical-ks` | `references/dependency-table.tex:59–65` |
| `import:representation-theory` | `references/dependency-table.tex:67–76` |
| `import:weight-one` | `references/dependency-table.tex:78–84` |
| `import:albanese` | `references/dependency-table.tex:86–92` |
| `import:correspondences` | `references/dependency-table.tex:94–101` |
| `import:hilbert` | `references/dependency-table.tex:103–110` |
| `import:smoothness-ample` | `references/dependency-table.tex:112–121` |
| `import:cartier` | `references/dependency-table.tex:123–129` |
| `import:analytic-cohomology` | `references/dependency-table.tex:131–140` |
| `import:analytic-proper-images` | `references/dependency-table.tex:142–150` |
| `import:resolution-gaga` | `references/dependency-table.tex:152–160` |

## 6. Outcome and remaining obligations

The ledger-worthy findings are **identity, attribution and scope facts**: 40 reconciled version-1 records; consistent declared coverage; accessible pinned source content; explicit conditional existence inputs; and a dependency graph that is a lossy source projection, not a proof.

To turn the conditional reduction into an adopted mathematical result requires independent verification of its imports and source arguments; to obtain an unconditional K3 conclusion also requires the actual very-general input in every component/degree used. Neither the separate actual-group condition-(c) result nor determinant-supply condition-(d) work on the Weil source supplies these KS hypotheses. There is no novelty claim, blanket correctness verdict, refutation or family-completion claim. Acceptance remains pending native Host Reviewer.
