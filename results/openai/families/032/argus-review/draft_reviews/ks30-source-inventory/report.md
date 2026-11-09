# KS30 source-inventory assessment

**Unit:** `ks30-source-inventory`  
**Result:** source attribution/dependency inventory, not an independent proof of the K3 results.  
**Independent acceptance:** **pending native Host Reviewer**; Engineer assessment only.

## 1. Source and version access

The manuscript is OpenAI, *Algebraic Kuga–Satake correspondences and Hodge conjectures on a K3 quadratic locus*, dated **September 30, 2026** as printed. The accessible source is:

`families/032/first-pass/openai_manuscript/Algebraic-Kuga-Satake-correspondences-and-Hodge-conjectures-on-a-K3-quadratic-locus-September-30-2026/build/paper.tex`

The five-paper reference manifest in campaign `9100032/MANUSCRIPTS.json` lists source revision `4eaee87548250b2682affda7d05d947c05554bae`. Both old and reference TeX copies match the manifest hash `9db1b5c004f313afa269e1cd2a918842460623df711c3b8500d36a5a024155d9`. Content access is available; external theorem versions and revision history were not independently verified.

The Argus draft being assessed is its portion of old `research/actual_group_audit/other_manuscript_claims.json`, its population code and indexed ledger/graph entries. The old catalog documents **5,391 source lines, 58 records, 39 formal declarations, 11 context records and 43 bibliography entries**. Its logged ranges cover the accessible file exactly by line count. This review instead directly read bounded main/flagged passages: the opening through line 220; exact exterior premise 439–467; cover/period and lattice/descent statements at 1293–1506, 1625–1630, 2411–2419, 2487–2577 and 2699–2846; the two-square argument at 3290–3325, 3417–3525, 3720–3985 and 4075–4157; full-spin recovery at 4307–4615; whole-class specialization at 4709–4895; and transfer/assembly at 5047–5255. Precise disjoint ranges and hashes are retained in `verdict.json`; this is not a full independent proof audit.

## 2. Exact principal claims

For a projective complex K3 surface, write `(T_S,q)` for its **actual transcendental space with the cup-product form**. Put

`P=U⊕D₈(-1)⊕D₄(-1)`,  
`V_P=(U⊕U(2)⊕D₄(-1))_Q ≅ U_Q² ⊥ ⟨-1⟩⁴`,

a rank-eight rational form of signature `(2,6)`.

* **`ks30:main:theorem` (179–198)** assumes a rational **isometric** embedding `(T_S,q)→V_P`. It asserts algebraicity of every stipulated standard full even-Clifford tensor and rational HC and GHC in every degree on every self-power of `S`. Ample `P`-polarized K3 surfaces, including Picard jumps, are included. Rank/signature alone, a rescaled form or an arbitrary Hodge embedding is not this quadratic-locus hypothesis.
* **Exact tensor convention:** `W=C⁺(T_S,q)=H¹(A,Q)` is the full realization, and a rational nonisotropic right vector `w` gives `j_w(v)(a)=vaw` on `T_S(1)`. A prescribed rational weight-one polarization `E` converts the dual slot into the exact tensor `ι_(w,E):T_S→H¹(A)⊗H¹(A)⊂H²(A²)`. The source requires a cycle in `CH²(S×A²)_Q` inducing this map. The vector `w` need not itself be Hodge.
* **`ks30:ext:criterion` (151–158)** is a separate conditional assertion for **any projective K3**, not just the rank-eight locus: algebraicity of **one exact tensor** of the above form implies HC/GHC for all self-powers. An arbitrary nonzero embedding or motivated/absolute-Hodge KS class does not meet its premise.
* **`ks30:ext:conditional` (439–467)** spells out algebraic injective exterior-power maps `∧ᵏT_S(1)→End(W)` with algebraic cohomological left inverses, for every `1≤k≤dim T_S`, under that exact-cycle hypothesis. The subsequent coniveau/carrier machinery is part of the proof obligation for the general criterion.
* **`ks30:transfer:moduli` (5216–5232)** retains the same K3 locus and asserts the conclusions for powers of Hilbert schemes and the specified **smooth projective** twisted Gieseker or generic Bridgeland moduli spaces; its birational extension additionally concerns smooth projective hyperkähler varieties. It is not a theorem about arbitrary moduli spaces or arbitrary K3 surfaces.

The general HC, GHC and KS algebraicity conjectures are separately inventoried. A restricted-locus theorem does not prove their unrestricted formulations.

## 3. Actual catalog contribution and reconciliation

The catalog contributes source-only reproduction, context decomposition, citation-role inventory, explicit premise separation and flagged bottlenecks:

| Catalog role | Records |
|---|---:|
| Manuscript assertion | 23 |
| Conditional conclusion | 16 |
| Established import **as cited** | 14 |
| Conjecture | 3 |
| Explicit assumption | 2 |

All **58 distinct index IDs** occur once at version 1. Their statements and spans agree with the catalog; old ledger statements/hashes/versions and graph statements/spans/dependencies agree with the index. All 58 old formal fields are empty, and there are no old evidence-ID links for these source records. Historical graph statuses are `open`; none is treated as current acceptance. The introductory premise records intentionally overlap their theorem locators; this is role decomposition, not an additional mathematical proof.

`populate_source_claims.py` registers these texts and source edges; it does not prove them. It deliberately makes `ext:conditional` depend on `input:one-exact-tensor`, not the later criterion. Input/import/conjecture nodes can have no graph prerequisites by construction; section/equation and context references are filtered. Acyclicity, registration, an empty assumption array or a Chern-character expression is not a mathematical certificate.

## 4. Decisive evidence and all existing bottleneck flags

These are **unverified source/application obligations**, not certified defects:

1. **`flag:ks30-quotient-and-period`.** Cover structure 1293–1485 distinguishes the involutions and their eigenspaces and the factor **two** between pairings on the quotient models. Twisted Hodge eigensheaves and the period derivative (1487–1506) feed the rank-six period assertion (1625–1630). The integral overlattice, discriminant action, root monodromy and descent over the original pencil line (2411–2846) need their precise integral/Hodge hypotheses. A cited period-contraction theorem does not by itself prove the manuscript's additional Hodge-line and stabilizer-kernel arguments.
2. **`flag:ks30-two-square-cylinder`.** The fixed original pencil first undergoes `t=s+u²`; the models, open `G` and relative codimension-three correspondence are fixed **before choosing `b`**; then `s=b+v²`. The difference-cylinder identity is `transpose(d)d=-4 id`, leading to
   `Θ_b=-(1/4)e_b (transpose D_X) Ĉ D_S`.
   Source 3720–3985 and 4075–4157 uses canonical affine-derived/Leray coefficient comparisons, localization and fixed boundary Hodge structures to remove errors away from countably many parameters. Each compatibility and quantifier matters. In particular, the invariant-cycle lift in 3505–3525 supplies a Hodge class/map; its algebraicity uses further source arguments, not simply the word “Hodge.”
3. **`flag:ks30-full-spin`.** The rank-eight full Clifford space has rational dimension 128 and complex multiplicities eight in **each** half-spin. Both ordered tensor orientations and the full rational Hom space are needed (4307–4615). The ordinary tensor flip is **minus** geometric factor interchange in mixed `H¹⊗H¹`; rational descent cannot be replaced by assuming each half-spin separately rational. Compression at special fibers must respect the prescribed right vector and duality.
4. **`flag:hilbert-whole-class`**, shared with KS10. The source specializes the whole fixed rank-eight source, including new `(1,1)` directions at Picard jumps, not just the generic transcendental map (4709–4895). Universal coherent sheaves, perfectness, leading Chern characters, multiplicities and singular/nonreduced parameter spaces are substantive obligations. At 5047–5125 the second-slot compression is the duality-corrected map, not naively `p⊗p`, and the right multiplier is changed before restriction.

The main assembly is explicit at 5138–5212: rational orthogonal density enters an ample period patch, the exact period is realized, Witt extension gives a full rational Hodge isometry, and Buskin algebraizes both directions; Clifford transport then preserves the **specified** tensor. This is not a claim that arbitrary Hodge maps are algebraic. The general HC/GHC deduction further depends on exterior carriers, all-degree invariant generation and geometric-coniveau support/shift arguments, not on catalog registration.

External references remain **as cited**, not externally checked or adopted. Buskin locators use `arXiv:1510.02852v3`; Huybrechts uses a linked prepublication copy; Peters–Sterk carries both “JUNE 2024” and “16 September 2024” metadata. Motive transfers cite de Cataldo–Migliorini, Bülles, Arapura and Rieß; all their applicability conditions remain obligations. Contextual Weil/OG6 citations do not make a proved standalone Weil theorem an input here. The catalog's KS10→KS30 comparison is expressly a logical composition of unverified assertions, not a source citation or an independently certified dependency.

## 5. Exhaustive source/claim mapping

All locators below are in `build/paper.tex`; each suffix has prefix **`ks30:`**. The JSON supplies each exact indexed statement, separate role, source/catalog/graph locators, citations and concrete unresolved obligations.

| ID suffix | Lines |
|---|---|
| `ext:criterion` | 151–158 |
| `main:theorem` | 179–198 |
| `main:lattice` | 328–335 |
| `ext:conditional` | 439–467 |
| `ghc:lem:cycle-support` | 613–621 |
| `ghc:prop:exterior-coniveau` | 631–643 |
| `ghc:lem:orthogonal-carriers` | 872–885 |
| `ghc:lem:k3-carriers` | 944–955 |
| `geom:structure` | 1293–1328 |
| `geom:twisted-hodge` | 1487–1506 |
| `geom:period` | 1625–1630 |
| `geom:gauss-generic` | 1808–1822 |
| `geom:halves` | 1933–1944 |
| `geom:relations` | 2010–2017 |
| `geom:domination` | 2071–2084 |
| `geom:genericity` | 2272–2297 |
| `pencil:realization` | 2386–2403 |
| `pencil:lattice` | 2411–2419 |
| `pencil:monodromy` | 2487–2495 |
| `pencil:periodstack` | 2699–2719 |
| `pencil:descent` | 2798–2846 |
| `pencil:uniruledcriterion` | 3075–3080 |
| `comp:twosquares` | 3290–3325 |
| `comp:uniruled` | 3337–3343 |
| `comp:affine` | 3417–3434 |
| `comp:hodgelift` | 3482–3502 |
| `comp:models` | 3549–3568 |
| `comp:surface` | 4146–4157 |
| `final:curves` | 4196–4210 |
| `final:spin` | 4307–4341 |
| `final:generic` | 4617–4629 |
| `specialization:ambient` | 4709–4721 |
| `final:hilbert` | 4730–4754 |
| `specialization:rational-density` | 4896–4901 |
| `transfer:compression` | 5047–5064 |
| `transfer:ample` | 5082–5087 |
| `transfer:period` | 5138–5147 |
| `transfer:tensor` | 5171–5175 |
| `transfer:moduli` | 5216–5232 |
| `conjecture:hc` | 79–86 |
| `conjecture:ghc` | 87–97 |
| `conjecture:ks-algebraicity` | 112–116 |
| `input:one-exact-tensor` | 151–155 |
| `input:quadratic-embedding` | 179–185 |
| `import:absolute-motivated-ks` | 109–116 |
| `import:zarhin` | 674–710 |
| `import:buskin` | 4643–4666 |
| `import:invariant-generation` | 799–817 |
| `import:period-contraction` | 2722–2734 |
| `import:bdpp` | 3098–3106 |
| `import:invariant-cycles` | 3505–3525 |
| `import:fixed-part-lowest-weight` | 3650–3702 |
| `import:mhs-localization` | 4050–4078 |
| `import:leading-chern-character` | 4815–4834 |
| `import:hilbert-motive` | 5236–5240 |
| `import:moduli-motive` | 5240–5244 |
| `import:motivic-hc-ghc-transfer` | 5244–5249 |
| `import:birational-hyperkahler` | 5250–5254 |

## 6. Outcome

The justified factual result is a **58-record attribution and coverage reconciliation**, preserving the quadratic-form hypothesis, exact tensor premise and geometric dependency bottlenecks. No source/version access failure was observed for this paper; external theorem applicability and mathematical verification remain open to independent assessment. Separate Weil actual-group condition-(c) and determinant-supply condition-(d) work does not certify the K3 arguments. No original manuscript defect, novelty, unrestricted conjecture solution or family completion is claimed. Native Host Reviewer acceptance is pending.
