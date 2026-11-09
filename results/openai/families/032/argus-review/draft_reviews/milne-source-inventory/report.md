# Milne source-inventory assessment

**Unit:** `milne-source-inventory`  
**Result:** attributed statement/dependency inventory, not an independent proof of rationality or specialization.  
**Independent acceptance:** **pending native Host Reviewer**; this is an Engineer assessment.

## 1. Source, authorship and a genuine version limitation

The paper is **OpenAI**, *Milne's rationality conjecture for abelian varieties*, dated **October 7, 2026** as printed. The conjecture's attribution to J. S. Milne is not authorship of this manuscript. Its accessible old source root is:

`families/032/first-pass/openai_manuscript/Milnes-rationality-conjecture-for-abelian-varieties-October-7-2026/`

Milne is an explicit input of the old source inventory, but **is absent from the five-paper reference manifest** at `campaigns/9100032/MANUSCRIPTS.json`. The manifest's commit `4eaee87548250b2682affda7d05d947c05554bae` therefore cannot be assigned to this paper. All nine old TeX files are accessible, and their observed hashes are recorded in `verdict.json`; this does not establish an upstream revision or equivalence to an unlisted reference edition.

The reviewed Argus draft is the Milne portion of old `research/actual_group_audit/other_manuscript_claims.json`, its registration script and its old ledger/graph records. It documents **nine files, 3,065 lines, 44 records, 21 formal declarations, 15 context records and 35 bibliography entries**. Logged ranges and accessible file lengths agree. This review directly read the main/header and introduction; preliminaries 50–62 and 144–204; transport 35–150, 229–308, 404–574 and 620–793; filtration 38–155, 160–241 and 315–463; internal Weil section 1–112, 205–265 and 330–439; and reduction 1–80, 160–244, 252–320 and 370–448. This is bounded attribution/dependency reading, not certification of every proof or external citation.

## 2. Principal assertions and their different strengths

Fix `Qbar⊂C`, a prime `p`, a place `w`, `F=Fbar_p`, `K₀=Frac W(F)` and the corresponding completion `C_w`. Statements are at this fixed place; no comparison between different places is being asserted.

### Main rationality statement

**`milne:thm:main`**, introduction 29–56: for an abelian variety `A/Qbar` of dimension `d` with good reduction `A₀/F`, a rational Hodge class `γ∈H²ʳ(A(C),Q(r))`, `0≤r≤d`, and **any** complementary list of Cartier divisors `D₁,…,D_(d-r)` on `A₀`, there is **one `q∈Q`** such that

`Tr_ℓ(γ_(0,ℓ) ∏c₁,ℓ(D_i)) = q` for every `ℓ≠p`,

and the crystalline trace equals the same `q` in `C_w`, after extending the crystalline class from `K₀`. This includes **`p=2`**, divisors that do not lift, complementary rational Lefschetz classes by linearity, and the zero/top-degree cases (empty product when `r=d`). It is a simultaneous **rational pairing** theorem, not general algebraicity of Hodge classes.

### Transport, filtration and internal Weil reduction

* **`milne:prop:transport`**, transport 35–87, starts with a connected reductive Hodge embedding `G⊂GSp(V,ψ)` containing the Hodge homomorphism, and the exact semi-invariance `γ(gv₁,…,gv₂ᵣ)=c(g)^rγ(v₁,…,v₂ᵣ)`. It asserts one special-fiber quasi-isogeny `a:A₀ⁿ→B₀` and a rational Hodge class `κ` with `(aj)*κ₀=γ₀` simultaneously in all realizations (`j` is the first-factor inclusion).
* Its alternatives are distinct: **(1)** a CM auxiliary `B/Qbar`; or **(2)** a local auxiliary realizing a prescribed degree-`(0,1)` weakly admissible filtration over finite `K/K₀`, with **finite local-field descent of the tensor data** and membership in the original geometric `G`-orbit. In (2), `B` need not be CM. No generic-fiber isogeny between `A` and `B` is claimed, and the two auxiliaries need not coincide.
* **`milne:thm:filtration`**, filtration 38–79, assumes a rational CM-field action `E`, Rosati conjugation, rank `2s` over `E⊗K₀`, and an **invertible** endomorphism `u` satisfying `u†=u` and `ue=bar(e)u`. It asserts an `E,u`-stable, balanced, polarization-Lagrangian weakly admissible filtration after finite extension, finite local-field tensor descent and the specified determinant/multiplier group orbit. Avoidance, descent and orbit membership are separate requirements.
* **`milne:prop:weil`**, the **internal** section `04_weil`, concerns balanced CM-field Weil classes and rational Lefschetz pairings: no invertible `u` gives the zero-pairing branch; invertible `u` gives a simultaneous rational Lefschetz representative by filtration/transport. This is not a general characteristic-zero split-Weil algebraicity theorem.
* **`milne:lem:cm-reduction`** uses actual rational-idempotent abelian factors of powers, balanced signatures `(r,r)` and the full rational determinant sum. It does not merely select individual complex embedding lines.

### Two specialization conclusions that must not be conflated

**`milne:cor:all-hodge-specialization`** (reduction 281–304) first fixes **one good rational Tate-class theory** before `A,γ` vary. It gives the unique cohomological member in that theory with the specified realizations, not a unique algebraic cycle or a uniqueness statement in Chow.

**`milne:cor:algebraic-specialization`** (375–399) additionally invokes **OpenAI's October 6 CM-Hodge manuscript, Theorem 1.1**, to obtain one algebraic cycle on the special fiber with the simultaneous classes. This extra manuscript is correctly cataloged as `additional_manuscript_input`, not an established external import. It is not a premise of the main rationality theorem. The consequence does not claim a unique Chow representative, a generic-fiber cycle lift, or general characteristic-zero HC.

## 3. Catalog contribution and structural reconciliation

The catalog contributes source-only reproduction, context/import separation and dependency checkpoints:

| Catalog role | Records |
|---|---:|
| Established import **as cited** | 18 |
| Manuscript assertion | 11 |
| Conditional conclusion | 9 |
| Conjecture/historical question | 3 |
| Explicit assumption | 2 |
| Additional-manuscript input | 1 |

All **44 IDs occur exactly once**, version 1, with exact catalog/index statement agreement. Old ledger natural statements/hashes/versions and graph statements/spans/dependencies reconcile to the index. No duplicate/superseded indexed version is present. Introductory theorem, historical conjecture and independently cataloged premises can share source passages without constituting independent proofs.

All 44 old formal fields are empty and these source records have no old evidence-ID links. The population script performs registration and a filtered source-claim dependency projection; it is not a proof. In particular **`milne:input:uniformization-condition` is classified as an established import as cited**, despite its ID prefix. Empty graph dependencies/old assumption arrays for an import do not discharge that import.

The historical weak-rationality conjecture and simultaneous-lift question remain inventoried at the source's printed precision. Their external full formulations were not checked. The main rationality assertion is a manuscript assertion, not a proof manufactured by changing the classification of the historical conjecture.

## 4. All substantive existing flags and decisive limits

None of the following is a certified manuscript defect:

1. **`flag:milne-all-prime-citations`.** Transport 101–150, 229–308 and 404–574 uses strong admissibility, an adapted self-dual Hodge embedding, reduced relative roots including `p=2`, the center split-rank condition, `(U_x)`, admissible-period image and integral uniformization with one marked quasi-isogeny. Applicability of the precise external versions remains unverified. A period flag alone is not yet a globally marked abelian auxiliary.
2. **`flag:milne-rational-normalization`.** Transport 620–793 uses a rational divisor-intersection ratio to make the local similitude factors **one `λ∈Q×`**, and scales `κ=λ^(-r)η_B/[P:Q]`. Separately, preliminaries 144–204 lifts a **specified rational algebraic special-fiber map** through filtered Dieudonné, Tate, specified-map Serre–Tate and formal existence. It does not algebraize an arbitrary `Q_p`-linear map. Common normalization, simultaneous realization compatibility and exact map lifting are concrete audit obligations.
3. **`flag:milne-filtration-descent`.** Filtration 87–155 avoids polynomials of bounded degree over **fixed `K₁` before adjoining `θ`**, not coefficients in `K₁(θ)`. The subsequent largest-defect-maximizer argument reduces all subobjects to stable ones; uniform minor bounds, all `K₀`-subisocrystal inequalities, finite local-field descent of tensors, and the balanced group orbit must each be established before applying weakly-admissible-implies-admissible.
4. **`flag:milne-weil-rational-descent`.** Internal Weil 205–265 and 330–439 descends the **whole Galois-stable determinant sum**, not each embedding line, and separates the no-invertible-`u` and invertible-`u` branches. Reduction 18–80 and 160–205 uses actual abelian factors and rational projectors. These steps, including lifting the specified algebraic endomorphisms/divisor, are source arguments rather than independently submitted Argus proofs.
5. **`flag:milne-additional-cm-input`.** Reduction 370–448 adds the CM-Hodge theorem only for algebraic specialization, then uses spreading, good-reduction specialization and rational Chow pullback. Neither the CM theorem nor its applicability is established in this source-inventory unit. No unseen dependency expansion into the standalone Weil geometric tail is justified.

Version qualifications matter: Kisin–Zhou locators are tied to the printed preprint/PDF dates, including a cataloged `v1` deposit/PDF-date distinction; Pappas–Rapoport uses `arXiv:2106.08270v6`; Gleason–Lim–Xu uses `arXiv:2208.07195v3`; Milne1999 explicitly includes the author's correction to Theorem 5.9; Milne2009 pagination is the author's version. These are **source-reported locators, not independently verified bibliographic facts or adopted assumptions**.

The bibliography also retains `Hartl2008`, `Kim2012`, `Kisin2006`, `Kisin2017`, `MilneAG2022` and `Wintenberger1997` without inventing claim-level dependencies from their mere presence. A contextual Markman reference does not prove that the manuscript's internal balanced-Weil section imports the entire standalone Weil construction.

## 5. Exhaustive source/claim mapping

Paths are relative to the source root with `build/` suppressed. Each suffix has prefix **`milne:`**. The JSON gives every exact indexed statement, source/catalog/graph evidence, classification, cataloged import and unresolved obligation.

| ID suffix | Source and lines |
|---|---|
| `thm:main` | `sections/00_intro.tex:29–56` |
| `lem:comparison` | `sections/01_preliminaries.tex:50–62` |
| `lem:pairing-functorial` | `sections/01_preliminaries.tex:119–122` |
| `lem:lift-hom` | `sections/01_preliminaries.tex:158–169` |
| `prop:transport` | `sections/02_transport.tex:35–87` |
| `lem:auxiliary-datum` | `sections/02_transport.tex:116–150` |
| `lem:admissible-realization` | `sections/02_transport.tex:330–353` |
| `cor:cm-transport` | `sections/02_transport.tex:777–793` |
| `thm:filtration` | `sections/03_filtration.tex:38–79` |
| `lem:avoidance` | `sections/03_filtration.tex:87–97` |
| `lem:lagrangian-intersection` | `sections/03_filtration.tex:130–142` |
| `cor:filtration-admissible` | `sections/03_filtration.tex:437–442` |
| `cor:filtration-divisor` | `sections/03_filtration.tex:450–463` |
| `prop:weil` | `sections/04_weil.tex:55–61` |
| `lem:weil-orthogonality` | `sections/04_weil.tex:70–74` |
| `lem:weil-divisor-span` | `sections/04_weil.tex:205–225` |
| `lem:weil-group` | `sections/04_weil.tex:280–289` |
| `lem:cm-reduction` | `sections/05_reduction.tex:18–35` |
| `cor:cm-pairing` | `sections/05_reduction.tex:207–212` |
| `cor:all-hodge-specialization` | `sections/05_reduction.tex:281–304` |
| `cor:algebraic-specialization` | `sections/05_reduction.tex:375–399` |
| `conjecture:rationality` | `sections/00_intro.tex:3–15` |
| `conjecture:weak-rationality` | `sections/00_intro.tex:66–71` |
| `question:simultaneous-lift` | `sections/00_intro.tex:149–157` |
| `input:prescribed-filtration` | `sections/02_transport.tex:64–79` |
| `input:invertible-rosati` | `sections/03_filtration.tex:40–52` |
| `import:cm-hodge-theorem` | `sections/05_reduction.tex:370–373` |
| `import:absolute-hodge` | `sections/00_intro.tex:116–123` |
| `import:lefschetz-algebra` | `sections/01_preliminaries.tex:86–106` |
| `import:filtered-dieudonne` | `sections/01_preliminaries.tex:172–178` |
| `import:tate-extension` | `sections/01_preliminaries.tex:178–186` |
| `import:serre-tate-formal` | `sections/01_preliminaries.tex:188–204` |
| `import:adapted-embedding` | `sections/02_transport.tex:229–249` |
| `import:canonical-tensors` | `sections/02_transport.tex:251–301` |
| `import:special-point` | `sections/02_transport.tex:304–308` |
| `import:admissible-period-map` | `sections/02_transport.tex:404–442` |
| `input:uniformization-condition` | `sections/02_transport.tex:474–480` |
| `import:integral-uniformization` | `sections/02_transport.tex:461–494` |
| `import:marked-specialization` | `sections/02_transport.tex:506–566` |
| `import:weakly-admissible` | `sections/02_transport.tex:569–574` |
| `import:split-weil-reduction` | `sections/05_reduction.tex:11–16` |
| `import:markman-weil` | `sections/00_intro.tex:142–147` |
| `import:good-rational-tate-theory` | `sections/00_intro.tex:80–96` |
| `import:ordinary-cm-case` | `sections/00_intro.tex:74–77` |

## 6. Outcome

The persistent factual result is a **44-record reconciliation**, explicit rationality-versus-algebraicity separation, and disclosure that the available Milne source is **not revision-pinned by the five-paper manifest**. An adopted proof would still need the exact all-prime import applications, common rational normalization, filtration/descent/orbit argument, determinant descent and rational CM reduction. Algebraic specialization additionally needs the separate CM theorem. No novelty, original error, blanket correctness/refutation or family completion is claimed. Weil condition-(c)/(d) audits do not certify these Milne claims. Acceptance remains pending native Host Reviewer.
