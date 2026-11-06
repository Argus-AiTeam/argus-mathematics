<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/brand/argus-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/brand/argus-logo-light.svg">
    <img src="assets/brand/argus-logo-dark.svg" width="420" alt="Argus">
  </picture>
</p>

<h1 align="center">Argus Mathematics</h1>

<p align="center">
  <strong>Autonomous Mathematical Theorems, Exact Counterexamples, and Machine-Verified Certificates</strong><br>
  <a href="README.zh-CN.md">中文说明</a> ·
  <a href="results/">All 84 Result Packages (<code>results/</code>)</a> ·
  <a href="data/results.json">Structured Index (<code>data/results.json</code>)</a> ·
  <a href="runtime/">Frozen Runtime &amp; <code>math</code> Vertical</a> ·
  <a href="https://github.com/Argus-AiTeam/argus-counterexample-runtime">Standalone Runtime Repo</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Published_Result_Packages-84-174A7E?style=flat-square" alt="84 Result Packages">
  <img src="https://img.shields.io/badge/Standalone_AMS_LaTeX_Papers-84_PDFs-2E7D32?style=flat-square" alt="84 AMS Papers">
  <img src="https://img.shields.io/badge/Checksummed_Artifacts-730-6A1B9A?style=flat-square" alt="728 Artifacts">
  <img src="https://img.shields.io/badge/Verification-Jacobian_%7C_Lean_4_%7C_PARI%2FGP-C62828?style=flat-square" alt="Verification">
  <img src="https://img.shields.io/badge/Total_Billed_Cost-%24352.84_(%244.20%2FResult)-E65100?style=flat-square" alt="Billed Cost">
</p>

---

## Overview

This repository archives the completed, independently verified mathematical outputs of the **Argus** autonomous research program. Rather than publishing unverified model transcripts, every package in [`results/<ID>/`](results/) is organized around **explicit mathematical statements, exact rerunnable certificates, and explicit scope boundaries**, accompanied by a standalone compiled AMS LaTeX paper (`ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf` and `.tex`).

As of **November 5, 2026**, the archive contains **84 standalone open-problem result packages** (**748 SHA-256 checksummed artifacts**) plus the **Autonomous Audit, Refutation, and Lean 4.31.0 Formal Certification of OpenAI's `openai/math` Corpus** ([`docs/openai-math-audit-findings.md`](docs/openai-math-audit-findings.md)):

| Category | Count | Description |
|---|---:|---|
| **I. Flagship Counterexamples & Publishable Theorems on Open Conjectures** | **22** | Direct counterexamples and unconditional theorems advancing open problems in combinatorics, algebra, geometry, and number theory |
| **II. Millennium-Frontier & Structural Obstruction Theorems** | **12** | Unconditional theorems, spectral/geometric obstructions, and density bounds on concrete frontiers of Millennium-class problems |
| **III. Independently Verified Counterexamples & Literature Resolutions (Batch 001 & Audit)** | **31** | Exact counterexamples, Lean 4 formal refutations, and source-audited resolutions across 757 historical problem records |
| **IV. Symbolic, Algebraic & Polyhedral Boundary Certificates** | **19** | Computer-assisted exclusion certificates, Farkas dual proofs, and arithmetic reductions |
| **Total Archived Result Packages** | **84** | Every package includes `ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf`, `.tex`, `README.md`, and `verification-summary.json` |

---

## Comprehensive 5-Tier Credibility Audit, 42 Refuted Claims, 381 Lean 4.31.0 Certifications & 276 Families with Proof Repairs (101) or Stronger Theorems (243) on OpenAI's `openai/math` Collection (723 Manuscripts Across 376 Families)

Using Argus's **Lakatosian Proofs-and-Refutations** architecture and 24-way parallel `gpt-6.1-sol` daemons, we completed a full-collection audit across all **376 problem families (723 manuscripts)** of OpenAI's `github.com/openai/math` release (`3` families withdrawn by OpenAI on October 7, 2026 + **373 active families / 720 active manuscripts**), decomposing them into **9,597 formal claims** and **8,368 audited evidence records** at a total billed cost of **`$85.88` (`2,147` calls, `$0.23` per family)**.

- **📄 Full Audit Report (English):** **[`docs/openai-math-audit-findings.md`](docs/openai-math-audit-findings.md)**
- **📄 完整中文审计与超越报告：** **[`docs/openai-math-audit-findings.zh-CN.md`](docs/openai-math-audit-findings.zh-CN.md)**
- **📊 Machine-Readable 376-Family Audit Ledger:** **[`data/openai-math-373-audit.json`](data/openai-math-373-audit.json)**

### 0. Head-to-Head Comparison: OpenAI `openai/math` vs. `Argus + gpt-6.1-sol`

| Dimension | OpenAI `openai/math` Release (October 2026) | `Argus + gpt-6.1-sol` Autonomous Discovery & Audit Program |
| :--- | :--- | :--- |
| **Review Status & Verification Rigor** | Officially marked **`review: {status: unchecked}`** in `formalization.yaml`; 75.6% of papers unmapped in `formalization.yaml`; 128 families have zero Lean code; 144 of 245 Lean-tagged families carry partial/simplified-model disclaimers in `lean/docs/` | **Lakatosian Proofs-and-Refutations Double-Blind Audit (`Planner -> Engineer -> Reviewer`)**: Decomposed into **9,597 formal claims & 8,368 evidence records**; produced **381 zero-`sorry`, zero-custom-axiom Lean 4.31.0 certificates (520,095 lines, 41,751 theorems)**, newly formalizing 90 previously unformalized families from scratch |
| **Hidden Flaws & Red-Team Refutations** | Withdrew 3 Hodge/K3/Weil papers on Oct 7 after a cascading sign error ($I(f_1)-m=-2m\neq 0$) and patched 27 others; remaining active papers left unaudited | Caught **28 manuscript-level `refutes` across 21 active, un-withdrawn OpenAI families (42 papers)**—including a fake theorem citation in flagship paper `#001`, a false generation level ($\mathrm{level}_G(X)=2\neq 3$) in `#318`, cross-paper symbol collisions in Oct 7 hotfix `#341`, and an $L^1$ integrability contradiction in `#376`—plus 5 refuted theorems in cited external paper Li–Zhang (`#342`) |
| **Repairs & Theorem Strengthening** | Static preprint snapshots requiring manual withdrawals/errata when flaws surface | **Achieved constructive proof repairs (`101` families) or strictly stronger theorems (`243` families) across `276` of `373` active families (`74.0%`, covering `552` papers)**, including 4 `verified_new` original theorems (e.g., `#209` `D2_MAIN` first dyadic $\mathbb{F}_2$ degree-3 integral Gersten kernel) |
| **Open-Problem Breakthroughs & Cost Efficiency** | Undisclosed compute cost (estimated multi-million-dollar frontier run) | **Audited and Lean-certified all 373 families (720 papers) on `gpt-6.1-sol` for `$85.88` total (`$0.23`/family, `93.8%` cache hit rate)**, and independently produced **84 open-problem result packages for `$352.84` (`$4.20`/package)** (refuting the 20-year-old Seymour–Sullivan Conjecture 6.1, closing the 46-year Schrijver $\operatorname{def}(D)\le 2$ weighted Woodall threshold, and removing Benoist–Ottem's *very general* hypothesis in the Integral Hodge Conjecture) |

### 1. Panorama 5-Tier Credibility Matrix (All 376 Families / 723 Manuscripts)

| Credibility Tier | Families (%) | Manuscripts (%) | Verification & Epistemic Profile |
| :--- | :---: | :---: | :--- |
| **🟢 Tier 1: 100% Self-Contained & Unconditionally Verified** | **36** (`9.6%`) | **73** (`10.1%`) | 0 external assumptions, 0 `inconclusive` bridges, 0 `refutes`; end-to-end verified in Lean 4.31.0 and by independent Reviewer |
| **🔵 Tier 2A: Core Certified in Lean 4.31.0; Full Theorem Conditional on External Literature / Prose Bridge** | **264** (`70.2%`) | **490** (`67.8%`) | Load-bearing algebraic/combinatorial core passes Lean 4.31.0 with zero `sorry` (including **90 families** newly formalized from scratch where OpenAI had no Lean); top-level geometric/analytic passage relies on external theorems (`statement_fidelity.md`) |
| **🟡 Tier 2B: Computational Core Verified; Unformalized Prose Bridge or Inconclusive Citations** | **47** (`12.5%`) | **103** (`14.2%`) | Exact symbolic/computational scripts pass, but lacks machine formalization and includes **31 families with `inconclusive` literature citation checks** |
| **🟠 Tier 3: Cited External Literature Theorems Refuted or Candidate Shortcuts Refuted** | **5** (`1.3%`) | **12** (`1.7%`) | E.g., **`#342`**: OpenAI's self-dual 2-form construction on $T^4$ is valid and simultaneously **refutes 4 printed theorems in the cited paper Li–Zhang (*arXiv:0708.2520v4*)** |
| **🔴 Tier 4: Direct Flaws, False Lemmas, or Non-Existent Citations Caught in Active OpenAI Manuscripts** | **21** (`5.6%`) | **42** (`5.8%`) | **28 manuscript-level `refutes`** caught across 21 active OpenAI families (non-existent citations, symbol collisions, false cohomology/generation levels, explicit counterexamples); **14 families repaired by Argus** |
| **⚫ Tier 5: Withdrawn by OpenAI (October 7, 2026)** | **3** (`0.8%`) | **3** (`0.4%`) | `#045, #061, #070`: withdrawn due to cascading sign error $I(f_1)-m=-2m\neq 0$ |
| **Total** | **376** (`100%`) | **723** (`100%`) | **381 zero-`sorry` Lean 4.31.0 certificates (520,095 lines, 41,751 theorems/lemmas), 67 `refutes` judgements (42 unique refuted claims)** |

### 2. Representative Flaws Caught, Mathematical Repairs & Stronger Theorems (See [Full Report](docs/openai-math-audit-findings.md))
- **28 Manuscript-Level Refutations Across 21 Active OpenAI Families (42 Manuscripts):**
  1. **Non-Existent Literature Citations (`#001` & `#320`):** Caught `#001` citing Milne `SVp.pdf` §5.21 (an open problem) as a proved lifting theorem (repaired by Argus via **Gabber's affine-étale smoothness theorem**); caught `#320` (`formal.tex:785`) citing non-existent `[MT, Lemma 3.9]` (actual locator: Lemma 6.7).
  2. **False Cohomological Dimension, $\pi_{-3}$ Vanishing & Generation Level in `#318` (8 `refutes`):** Refuted finite 5-cohomological dimension (`C318EXTCD`); proved $L_0 X \to L_0 L_{K(2)} X$ is **nonzero** on $\pi_{-3}$ at $p=5$ (`C318TAUZERO`); proved the degree-$-5$ comparison vanishes so $Y \simeq B_2 \vee V$ splits and **$\mathrm{level}_G(X) = 2 \neq 3$** (`C318LEVEL3`, `C318LEVELGE3`, `C318QGHOST`, `C318GHOST2`); and improved the character-sum modulus bound by $4\times$ from $q>163$ to **$q>39$**.
  3. **Cross-Paper Symbol Collision & Sobolev Order Error in `#341`:** Caught `07-pencil.tex` conflating Oh–Zhu's infinite-dimensional Sobolev spaces $E_0,E_1$ with finite-dimensional evaluation-deficit bundles $E_i$, and repaired the proof directly via the first-order elliptic Cauchy–Riemann operator $(w-\zeta_r)\partial\xi=0$.
  4. **Explicit Algebraic, Combinatorial & Analytic Counterexamples (`#004, #046, #053, #067, #180, #201, #209, #247, #274, #316, #321, #340, #376`):** Including `#004`'s $\mathbb{Z}/9\mathbb{Z}[t]$ torsion counterexample refuting linear clearing by $h$ (repaired via quadratic $h^2$), `#180`'s 4-bipyramid forest-pair cancellation counterexample, `#209`'s vanishing $y=0$ dyadic cyclotomic slice, and `#376`'s $L^1([0,\infty))$ integrability refutation of rapidly decreasing clock rates with infinite accumulated time.
- **276 of 373 Active Families (`74.0%`, Covering 552 Manuscripts) Achieved Proof Repairs (`101` Families) or Strictly Stronger Theorems (`243` Families, Including `166` Headline Report-Header Strengthenings):** Including compressing `#113`'s perfect-matching preimage bound from $(10N)^{30}$ down to $2^{17}N^8$; reducing `#176`'s Kahn–Kalai capacity separation constant from $16$ to $3$ in Lean 4.31.0; replacing `#164`'s superpolynomial spatial scale in Hindman's conjecture with the explicit polynomial power $Z \ge \kappa S^{2Ds^{n-1}+2}$; removing the ambient compact Kähler hypothesis and proving a full bijection of discrepancy-two places in `#056`; removing the exponential-square moment hypothesis $\mathbb{E}_p[\exp(c|Y|^2)]<\infty$ in `#093`'s dimension-free log-Sobolev inequality; extending `#291`'s uniform property $\Gamma$ to mixed ultraproducts of nonseparable $C^*$-algebras; and constructing a scalar-invisible rank-2 local system $D(2)$ complex in `#321`.

---

## Compute Efficiency & Complete Per-Problem Billed Cost (`usage.jsonl` Audit)

All Argus campaigns execute as single-daemon staged workflows (`Planner -> Engineer -> Independent Reviewer`, `mission_width=1`) backed by deterministic symbolic/polyhedral sidecars (`Jacobian`, `PARI/GP`, `Lean 4`) and an append-only `Proof Ledger` (`MATH_STATE.json`). Across all **150 `usage.jsonl` ledgers** (see [`docs/usage-and-cost-audit.md`](docs/usage-and-cost-audit.md) and [`data/usage-audit.json`](data/usage-audit.json)), the entire **84-package** program consumed **8,877 model calls (`8,821.0` Premium Requests, `7.61B` total tokens)** for a **grand total billed cost of `$352.84` (`$4.20` average per published result package)**:

- **53 Dedicated Problem Campaigns (August–November 2026):** `8,096` calls (`8,005.0` Premium Requests, `6.37B` tokens) $	o$ **`$320.20` total (`$6.04` avg/campaign)**; the **20 November publishable-theorem campaigns** cost **`$71.68` total (`$3.58` avg/theorem)**.
- **31 Shared Batch-Audit & Screening Result Packages (Batch 001 & 757-Problem Audit Shards):** `781` calls (`816.0` Premium Requests, `1.24B` tokens) $	o$ **`$32.64` total (`$1.05` amortized per published result package)**.

<details open>
<summary><strong>Complete Per-Problem Billed Cost Ledger (All 53 Dedicated Campaigns + 31 Shared-Pool Packages = 84 Results)</strong></summary>

| ID | Result Package | Models | Calls | Prem. Req. | Total Tokens | Nov 2026 Run | Cumulative Billed Cost (`$0.04`/req) |
|---|---|---|---:|---:|---:|---:|---:|
| [`11000263`](results/11000263/) | Twist-compatible Burau quotient and universal finite-dimensionality for Bigelow's zipper algebra | `gpt-5.6-sol` | 6 | 6.0 | 6.48M | — | **`$0.24`** |
| [`2813`](results/2813/) | An explicit taut-foliation Euler-class obstruction on a hyperbolic mapping torus | `gpt-5.6-sol` | 10 | 10.0 | 1.77M | — | **`$0.40`** |
| [`1275`](results/1275/) | Essential-Spectrum Obstruction for Finite-Shift Dilation Restrictions in Hilbert-Polya Realizations | `gpt-6-astra` | 16 | 16.0 | 7.93M | $0.64 | **`$0.64`** |
| [`2457`](results/2457/) | Countermodel to the Arvidsson heat-trace bounded-kernel implication (Erdos Problem #1055) | `gpt-5.6-sol` | 20 | 23.0 | 0.00M | — | **`$0.92`** |
| [`2662`](results/2662/) | Reidemeister-II collapse of two-change local plat families for unknotting and Conway mutation (Kirby 1.3) | `gpt-5.6-sol, gpt-6-astra` | 23 | 23.0 | 9.62M | — | **`$0.92`** |
| [`2775`](results/2775/) | Complete solution classification of the (A_12, 1, A_12) projection fiber for braid and right-angled Artin groups | `gpt-5.6-sol, gpt-6-astra` | 25 | 25.0 | 44.79M | — | **`$1.00`** |
| [`2307015`](results/2307015/) | A translated-cusp boundary set of positive harmonic measure | `gpt-5.6-sol` | 26 | 26.0 | 22.34M | — | **`$1.04`** |
| [`1921`](results/1921/) | Uniform degree bounds excluding bounded offset-signature colorings for Erdos Problem #87 | `gpt-5.6-sol` | 27 | 27.0 | 0.67M | — | **`$1.08`** |
| [`40`](results/40/) | Conformal Transfer and Curvature-Response Closure for Axisymmetric Euler Flows in Periodic Variable-Radius Pipes | `gpt-6-astra` | 34 | 34.0 | 40.98M | $1.36 | **`$1.36`** |
| [`3102`](results/3102/) | The Support-At-Most-Five Pebbling Number of the Lemke Square Is 64 | `gpt-6.1-sol` | 36 | 36.0 | 22.80M | $1.44 | **`$1.44`** |
| [`7200051`](results/7200051/) | Quantitative Distortion Bounds and Formal Equilateral Exclusion for Eleven Points in Five-Dimensional l_1 | `gpt-6.1-sol` | 44 | 44.0 | 24.19M | $1.76 | **`$1.76`** |
| [`2800203`](results/2800203/) | Threshold discrepancy barriers for depth-three scalar planted-clique AMP schedules | `gpt-5.6-sol, gpt-6-astra` | 49 | 49.0 | 79.04M | — | **`$1.96`** |
| [`1994`](results/1994/) | Bottom-row quadratic reduction and scalar-span obstruction on rank-four parabolic Erdos-Ulam configurations | `gpt-5.6-sol, gpt-6-astra` | 49 | 50.0 | 12.14M | — | **`$2.00`** |
| [`3167`](results/3167/) | Sheehan's Conjecture for Four-Regular Simple Graphs of Bounded Treewidth | `gpt-6.1-sol` | 54 | 54.0 | 42.76M | $2.16 | **`$2.16`** |
| [`20001352`](results/20001352/) | Literal-scope counterexample for commutator width and involution factorization in Thompson's group F (AIMPL Problem 3.1) | `gpt-5.6-sol, gpt-6-astra` | 60 | 57.0 | 4.31M | — | **`$2.28`** |
| [`2884`](results/2884/) | K3 Problem 4.8: arbitrary-X stabilization counterexample and fixed-E(2) PL/smooth seven-arrow construction | `gpt-5.6-sol` | 60 | 60.0 | 100.90M | — | **`$2.40`** |
| [`20000278`](results/20000278/) | An irrational non-Q-Gorenstein F-jumping number in characteristic 13 (AIM Problem 1.3) | `gpt-6-astra` | 62 | 61.0 | 22.53M | — | **`$2.44`** |
| [`20001602`](results/20001602/) | Commensurated subgroups of branch groups: missing just-infinite hypothesis and Hanoi group counterexample | `gpt-6-astra` | 62 | 62.0 | 14.58M | — | **`$2.48`** |
| [`20001849`](results/20001849/) | Flying wings refute uniqueness of the collapsed product steady Ricci soliton (AIMPL Problem 6.7) | `gpt-5.6-sol, gpt-6-astra` | 65 | 63.0 | 11.20M | — | **`$2.52`** |
| [`20001516`](results/20001516/) | A CAT(0) free-by-cyclic group that is not ordinary RFRS (AIM Problem 5.3) | `gpt-6-astra` | 67 | 66.0 | 14.84M | — | **`$2.64`** |
| [`2669`](results/2669/) | Handle-slide unlink orbit reduction on staged-framing two-component link presentations (Property R) | `gpt-5.6-sol, gpt-6-astra` | 69 | 66.0 | 24.52M | — | **`$2.64`** |
| [`1900020`](results/1900020/) | Diagonal quadratic energy contraction on section returns of the cubic Jacobi-Perron algorithm | `gpt-5.6-sol, gpt-6-astra` | 71 | 71.0 | 85.89M | — | **`$2.84`** |
| [`3256`](results/3256/) | Weighted Dijoin Packing in One-Edge Deletions of Chordal Digraphs | `gpt-6.1-sol` | 72 | 72.0 | 52.53M | $2.88 | **`$2.88`** |
| [`1417`](results/1417/) | A Uniform Square-Root Edge-Deficit Bound for Strongly Critical Graphs Avoiding Four- and Eight-Cycles | `gpt-6-astra, gpt-6.1-sol` | 76 | 73.0 | 30.62M | $1.36 | **`$2.92`** |
| [`2862`](results/2862/) | Co-normalizer orthogonal join reduction and rational Chern-Simons volume on one-angle spherical bar cycles | `gpt-5.6-sol, gpt-6-astra` | 73 | 73.0 | 12.43M | — | **`$2.92`** |
| [`1413`](results/1413/) | Girth-five 77-matching prefix certificate in the search for a degree-57 Moore graph | `gpt-5.6-sol` | 82 | 81.0 | 100.77M | — | **`$3.24`** |
| [`20001904`](results/20001904/) | A six-point positive-weight obstruction to degree-four Hermite curvature repairs on manifolds without conjugate points | `gpt-5.6-sol, gpt-6-astra` | 82 | 82.0 | 75.04M | — | **`$3.28`** |
| [`6800022`](results/6800022/) | Complete Global Embeddedness Obstruction for the Reciprocal-Reflection Kato-Muroya Genus-One Four-Catenoidal-End Locus | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 88 | 88.0 | 102.65M | $1.16 | **`$3.52`** |
| [`20000786`](results/20000786/) | Hasse-Witt matrix vanishing and cubic scalar cancellation on the k=3 quartic reduction branch | `gpt-5.6-sol, gpt-6-astra` | 89 | 89.0 | 111.66M | — | **`$3.56`** |
| [`20001675`](results/20001675/) | Arbitrary-Depth Exponential HOMFLY-PT Fibers over Quiver Point-Counting Polynomials of Plabic Links and Knots | `gpt-6.1-sol` | 93 | 93.0 | 69.23M | $3.72 | **`$3.72`** |
| [`8`](results/8/) | Reduction of the minimal-101 root-4 odd perfect number branch to the single factor Phi_31(269) | `gpt-5.6-sol, gpt-6-astra` | 96 | 96.0 | 15.01M | — | **`$3.84`** |
| [`1138`](results/1138/) | Bielliptic Half-Fiber and Dyadic Picard-Torsion Obstructions on Enriques Surfaces | `gpt-6-astra` | 97 | 97.0 | 97.44M | $3.88 | **`$3.88`** |
| [`20001274`](results/20001274/) | Congruent plane projections do not determine a convex body up to translation or reflection | `gpt-6-astra` | 103 | 102.0 | 14.76M | — | **`$4.08`** |
| [`3059`](results/3059/) | The Alon-Jaeger-Tarsi Conjecture in Dimensions Eight and Nine over F_5 | `gpt-6.1-sol` | 111 | 111.0 | 106.72M | $4.44 | **`$4.44`** |
| [`3395`](results/3395/) | Centered Nuclear Duality and Relative-Mass Obstructions in Monotone Boolean Circuit Lower Bounds | `gpt-6-astra` | 122 | 119.0 | 129.04M | $4.76 | **`$4.76`** |
| [`9400078`](results/9400078/) | Unconditional Exceptional-Parameter Density Bounds for Ramified GL_4 Automorphic Representations | `gpt-6-astra` | 144 | 143.0 | 56.57M | $5.72 | **`$5.72`** |
| [`1380`](results/1380/) | Exact rational sign-cell exclusion on the balanced (2,2,2,2) Heilbronn configuration space | `gpt-5.6-sol, gpt-6-astra` | 145 | 144.0 | 121.94M | — | **`$5.76`** |
| [`20002392`](results/20002392/) | Velocity-Only Exclusion of Backward Self-Similar Navier-Stokes Profiles in a Half-Space | `gpt-6-astra` | 150 | 145.0 | 39.00M | $5.80 | **`$5.80`** |
| [`20000582`](results/20000582/) | Moving-window Engel Hilbert cocycles with Omega(sqrt(k)) homogeneous gauge distortion | `gpt-5.6-sol, gpt-6-astra` | 152 | 152.0 | 437.17M | — | **`$6.08`** |
| [`1285`](results/1285/) | An Unconditional Exponential Worst-Case Lower Bound for Adaptive Signed-Chain Elliptic Curve Factorization Programs | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 157 | 155.0 | 93.52M | $1.24 | **`$6.20`** |
| [`2305027`](results/2305027/) | A signed Cauchy-Green flux identity and linear residual lower bound on planar corona corrections | `gpt-5.6-sol, gpt-6-astra` | 161 | 165.0 | 84.57M | — | **`$6.60`** |
| [`20001578`](results/20001578/) | Exact quotient-multiplicity exclusion of 18-element equality candidates in Thompson's group F | `gpt-5.6-sol, gpt-6-astra` | 182 | 182.0 | 272.80M | — | **`$7.28`** |
| [`2338`](results/2338/) | Diophantine Obstructions, Degree-120 S-Unit Descent, and Affine Orthogonal Runge Theorems for Multiplicity Five in Pascal's Triangle | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 188 | 188.0 | 194.53M | $5.76 | **`$7.52`** |
| [`1243`](results/1243/) | Unconditional Global Squareclasses, Genus-161 Rational-Point Classification, and Map Rigidity on Bremner's Octic K3 Surface | `gpt-5.6-sol, gpt-6.1-sol` | 204 | 192.0 | 71.54M | $6.92 | **`$7.68`** |
| [`8200002`](results/8200002/) | A 39-dimensional Arb Krawczyk interval certificate for the third Fourier fibre in dimension six | `gpt-5.6-sol, gpt-6-astra` | 239 | 239.0 | 417.23M | — | **`$9.56`** |
| [`1187`](results/1187/) | Global Nonexistence of Twisted Bridges in F_2-Magnus Quotients and Six-Conjugate Primitive Exclusion for Andrews-Curtis Candidates | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 249 | 246.0 | 113.91M | $7.72 | **`$9.84`** |
| [`1518`](results/1518/) | An Unconditional Sixth-Energy Saving for Riemann Zeta Zeros and a Local Prime-Window Exceptional-Pair Bound | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 269 | 266.0 | 104.23M | $5.04 | **`$10.64`** |
| [`9400114`](results/9400114/) | Target-Free Prime-Power Reduction, Short-Arc Cubic Obstructions, and Inverse-Frobenius Classifications for Agrawal's Conjecture | `gpt-6-astra, gpt-6.1-sol, mai-code-1.1-flash` | 303 | 298.0 | 202.21M | $3.92 | **`$11.92`** |
| [`2248`](results/2248/) | Baier-Zhao dispersion scale barriers for quadratic-prime representations n = a p^2 + b (Erdos #676) | `gpt-5.6-sol, gpt-6-astra` | 309 | 311.0 | 500.20M | — | **`$12.44`** |
| [`20000715`](results/20000715/) | Differential equations and linear-ODE obstructions for eta-products (AIM Problem 1.2) | `gpt-5.6-luna, gpt-5.6-sol, gpt-6-astra` | 426 | 426.0 | 33.14M | — | **`$17.04`** |
| [`1465`](results/1465/) | Fu 2026 Theorem 2.8: regularity-premise local-finiteness gap | `gpt-5.6-sol, gpt-6-astra` | 777 | 778.0 | 1431.73M | — | **`$31.12`** |
| [`20001036`](results/20001036/) | A 5,454-vertex multi-label counterexample to Seymour-Sullivan Conjecture 6.1 and prototype optimality | `gpt-5.6-sol, gpt-6-astra` | 891 | 883.0 | 606.40M | — | **`$35.32`** |
| [`20000816`](results/20000816/) | Distinct Hilbert-scheme components sharing a complete unlabelled Grobner fan (AIM Problem 15 / 1.35) | `gpt-5.6-sol, gpt-6-astra` | 995 | 987.0 | 77.31M | — | **`$39.48`** |
| **31 Batch/Audit Packages** | Shared audit shards (`audit-shard-01`, `audit-shard-02`, `batch-001`, `open-audit`) producing 31 packages (`$1.05`/pkg) | `gpt-5.6-sol, gpt-6-astra` | 781 | 816.0 | 1,243.08M | — | **`$32.64`** |
| **Grand Total (All 84 Results)** | **53 Dedicated Campaigns + 31 Shared-Pool Packages (150 `usage.jsonl` ledgers)** | **Combined** | **8,877** | **8,821.0** | **7,613.25M (`7.61B`)** | **`$71.68` (`$3.58`/thm)** | **`$352.84` (`$4.20`/pkg)** |

</details>
---

## Featured Flagship Breakthroughs

### 1. [`#20001036`](results/20001036/) — Refutation of Seymour–Sullivan Conjecture 6.1 on Rainbow Reachability ([Paper PDF](results/20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf))
* **Problem:** Conjecture 6.1 of Sullivan (*arXiv:math/0605646*, posed by Paul Seymour and Blair Sullivan as a common generalization of Seymour's Second Neighborhood Conjecture and the Caccetta–Häggkvist Conjecture) asks whether every simple digraph $G$ with edge sets $E_1,\ldots,E_k \subseteq E(G)$ either contains a rainbow directed cycle or has a vertex $v$ reaching at least $\sum_{i=1}^k d^+_{G_i}(v)$ vertices via rainbow directed paths.
* **Result:** After proving via exhaustive enumeration ($34{,}012{,}224$ patterns) and $1{,}854$ integer Farkas dual certificates that no counterexample arises from independent-set blow-ups of $n \le 4$ templates, Argus constructed a **$16$-vertex digon-free oriented prototype** with $k=6$ labels and blow-up multiplicities $m=(1096,8,23,69,244,755,1,1059,1,1,1131,1,1,1,1,1062)$, yielding an explicit **$5{,}454$-vertex, $11{,}792{,}572$-arc loopless, digon-free oriented simple digraph** with **no rainbow directed cycle** where **every vertex $v$ violates the reachability bound** ($\sum_{i=1}^6 d^+_{G_i}(v) - |R(v)| \ge 1$). Exact LP/SMT duality (`optimality-certificate.json`) proves that $5{,}454$ is the absolute minimum vertex count on this prototype (integrality gap $0$).

### 2. [`#11000263`](results/11000263/) — Bigelow's Zipper Algebra Question: $X_3 \neq 0$ Counterexample and All-$n \ge 4$ Universal Finite-Dimensionality Theorem ([Paper PDF](results/11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf))
* **Problem:** Stephen Bigelow's Question 6 on braid-group zipper algebras $Q_n$.
* **Result:** (1) Under an unreduced twist-compatible Burau specialization at $u=q^3$, $\rho(X_3)=(q-u)(q^2-u)E_2 \neq 0$ while $X_4=0$, refuting the $n=3$ vanishing claim and producing a finite-dimensional quotient surjecting onto the BMW algebra with nonzero kernel. (2) For **every $n \ge 4$**, the universal quotient algebra $Q_n$ is proved to be **finite-dimensional** over its ground field, with explicit double-factorial dimension bounds $(2n-1)!! + 1 \le \dim Q_n \le (2n-1)!! + (n!/3)^2$.

### 3. [`#3059`](results/3059/) — The Alon–Jaeger–Tarsi Conjecture in Dimensions $8$ and $9$ over $\mathbb{F}_5$ ([Paper PDF](results/3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf))
* **Problem:** The Alon–Jaeger–Tarsi conjecture asserts that for every finite field $\mathbb{F}_q$ ($q \ge 4$) and every $A \in \mathrm{GL}_n(\mathbb{F}_q)$, there exists $x \in (\mathbb{F}_q^\times)^n$ such that $Ax \in (\mathbb{F}_q^\times)^n$; prime fields $5 \le p \le 61$ and $p=79$ remain open.
* **Result:** We prove the Alon–Jaeger–Tarsi conjecture unconditionally in **dimensions $n=8$ and $n=9$ over $\mathbb{F}_5$**. Three-copy horizontal permanent amplification settles all matrices of permanent rank $\ge 6$ (and $\ge 5$ for $n=8$), while an exact Schur-complement and zero-profile classification at the minimal permanent rank $5$ proves that either $A$ or $A^{-1}$ contains a column with at most three nonzero entries, reducing $n=9$ to $n=8$.

### 4. [`#3102`](results/3102/) — Graham's Pebbling Conjecture: Support-Five Threshold $64$ on the Lemke Square $L \mathbin{\square} L$ ([Paper PDF](results/3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf))
* **Problem:** Ronald Graham's 1989 conjecture $\pi(G_1 \mathbin{\square} G_2) \le \pi(G_1)\pi(G_2)$ on the $64$-vertex Cartesian square $L \mathbin{\square} L$ of the $8$-vertex Lemke graph $L$ (previously verified only for support size $\le 4$).
* **Result:** We prove that every $64$-pebble configuration on $L \mathbin{\square} L$ supported on **at most five vertices** reaches every target vertex, establishing $\pi_{\le 5}(L \mathbin{\square} L) = 64$ via split-arm fiber retention and a multistage integer discharge cover across all $181$ rooted-pair orbits and $701$ support templates.

### 5. [`#1243`](results/1243/) — Unconditional Genus-$161$ Rational-Point Classification and Map Rigidity on Bremner's Magic-Square K3 Surface ([Paper PDF](results/1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf))
* **Result:** On the Category 3 second-iterate branch of Bremner's octic K3 surface for $3\times 3$ magic squares of squares, we prove **without GRH or $\amalg$-finiteness** that the degree-$18$ two-division field $K/\mathbb{Q}$ has odd class number, the $12$ Simon generators span the full norm-square kernel, and the sextic elliptic cover $E/k$ satisfies $\dim_{\mathbb{F}_2}\mathrm{Sel}_2(E/k)=3$, $\operatorname{rank} E(k)=1$, and $\amalg(E/k)[2^\infty] \cong (\mathbb{Z}/2\mathbb{Z})^2$. Via $p=23$ Chabauty–Coleman closure, the genus-$161$ cover $X$ has exactly $8$ rational points (all above the collision locus $x=-1$), geometric gonality $8$, $\mathrm{Aut}_{\mathbb{Q}}(X)\cong(\mathbb{Z}/2\mathbb{Z})^3$, and admits no nonconstant rational morphism to Bremner's genus-$57$ cover.

### 6. [`#1138`](results/1138/) — Universal Isotropy ($\dim_{\mathbb{F}_2} D_C \ge g$) and Maximal Arithmetic Vanishing-Cycle Integral Hodge Defects ($\operatorname{Hdg}^4/\operatorname{cl}(\mathrm{CH}^2) \simeq (\mathbb{Z}/2\mathbb{Z})^4$) on Enriques Products ([Paper PDF](results/1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) · [`universal_isotropy.md`](results/1138/universal_isotropy.md) · [`arithmetic_defect.md`](results/1138/arithmetic_defect.md))
* **Result:**
  1. **Universal Isotropy Theorem (Eliminating Benoist–Ottem's *Very General* Hypothesis):** Strengthening Benoist–Ottem (2020, *Comment. Math. Helv.*), which required a *very general* curve $C$, we construct an explicit Enriques surface $S_{\text{new}}$ over $\mathbb{Q}(\sqrt{2})$ with smooth projective dyadic model and finite-flat Picard torsion $G_{\pi,\pi}$ ($\pi^2=2$), and prove via Knudsen–Mumford determinants of cohomology, Raynaud semistable Picard specialization, and SGA~7~I Poincaré biextensions that for **every smooth projective connected complex curve $C$ of genus $g \ge 1$** (with no generality or arithmetic assumption on $C$), the correspondence pullback $A_C = \{Z^*\alpha : Z \in \mathrm{CH}_1(C\times S_{\text{new}})\} \subset H^1(C,\mathbb{F}_2)$ is totally isotropic for the cup product. Consequently, $\dim_{\mathbb{F}_2} A_C \le g$, and the degree-$4$ integral Hodge defect of $C \times S_{\text{new}}$ satisfies **$\dim_{\mathbb{F}_2} D_C = 2g - \dim_{\mathbb{F}_2} A_C \ge g$ for every curve $C$ of genus $g \ge 1$**.
  2. **Arithmetic Vanishing-Cycle Bound & Full-Rank $(\mathbb{Z}/2\mathbb{Z})^4$ Defect Family ([`arithmetic_defect.md`](results/1138/arithmetic_defect.md)):** We further establish the arithmetic vanishing-cycle orthogonality bound $A \subseteq W^\perp$ ($\dim_{\mathbb{F}_2} D_C \ge \dim_{\mathbb{F}_2} W$) and prove that on the diagonal Enriques quotient $S = T/\langle\iota\rangle \subset \mathbb{P}^5_{\mathbb{Q}}$ and the explicit infinite genus-$2$ family $C_t : y^2 = x^5 - x - 1 + 1083t$ ($t\in\mathbb{Z}$, containing infinitely many geometric isomorphism classes), the complex correspondence pullback vanishes identically ($A_{C_t}=\{0\}$), attaining the **maximal possible degree-$4$ integral Hodge defect $\operatorname{Hdg}^4(C_{t,\mathbb{C}}\times S_{\mathbb{C}},\mathbb{Z})/\operatorname{cl}(\mathrm{CH}^2) \simeq (\mathbb{Z}/2\mathbb{Z})^4$**.

### 7. [`#20001675`](results/20001675/) & [`#1187`](results/1187/) & [`#1285`](results/1285/) & [`#1518`](results/1518/) & [`#1417`](results/1417/) & [`#3167`](results/3167/) & [`#3256`](results/3256/) & [`#7200051`](results/7200051/) & [`#9400114`](results/9400114/)
* **[`#20001675`](results/20001675/) ([PDF](results/20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf)):** For every jet depth $r\ge 1$ and word length $m\ge 1$, explicit families of $2^m$ connected simple plabic single-component knots sharing the exact same $\mathbb{F}_q$ quiver point-counting polynomial $R(q)$, Alexander polynomial, and all HOMFLY-PT derivatives of order $<r$ at $a=1$, while producing **$2^m$ pairwise distinct two-variable HOMFLY-PT polynomials** ($\log_2|\text{fiber}|\ge (N-8)/(74r^2)$), together with an exact two-variable interlace polynomial characterization.
* **[`#1187`](results/1187/) ([PDF](results/1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf)):** Unconditional nonexistence of solutions to the $P_2$ and $P_0$ Andrews–Curtis twisted bridge equations in $121$- and $3,906$-dimensional truncated $\mathbb{F}_2$-Magnus algebras, and six-conjugate primitive exclusion **$w_{\mathrm{prim}}(H) \ge 7$**.
* **[`#1285`](results/1285/) ([PDF](results/1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf)):** Unconditional exponential worst-case bit-operation lower bound for uniform adaptive signed-chain Elliptic Curve Method (ECM) factorization programs on balanced squarefree $n$-bit semiprimes.
* **[`#1518`](results/1518/) ([PDF](results/1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf)):** Unconditional sixth additive energy power saving $\delta = 1/200$ for Riemann zeta zeros near $\sigma = 7/8$ and local Second Hardy–Littlewood exceptional-pair bound $V(N,H) \ll_\varepsilon N^{19/15 - 1/10000 + \varepsilon}$.
* **[`#1417`](results/1417/) ([PDF](results/1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf)):** Parameter-uniform square-root edge-deficit theorem $n \le \max\{8d, 4d^2-8d\} \le 4d^2$ ($d=2n-m$) for strongly $\delta \ge 3$-critical $C_4,C_8$-free graphs, implying $m \le 2n - \max\{7, \lceil 1+\sqrt{n+4}/2\rceil\}$ for minimal Erdős–Gyárfás counterexamples.
* **[`#3167`](results/3167/) ([PDF](results/3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf)):** Unconditional proof of Sheehan's conjecture for all finite simple $4$-regular Hamiltonian graphs of **treewidth $\operatorname{tw}(G) \le 5$** (certified across $152{,}441$ active pointed states, $88{,}107{,}797$ routing entries, and $25{,}209{,}843{,}635$ relative boundary orders with zero uncovered targets).
* **[`#3256`](results/3256/) ([PDF](results/3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf)):** Sharp terminal-reachability threshold theorem for capacitated Woodall dijoin packing: $\nu(D,w)=\tau(D,w)$ holds universally for all nonnegative integral capacities $w$ and all $q\ge 1$ whenever the condensation reachability defect satisfies $\operatorname{def}(D)\le 2$ (whereas $\operatorname{def}(D)\ge 3$ fails by Schrijver's 1980 example), plus one-edge deletions of chordal digraphs.
* **[`#7200051`](results/7200051/) ([PDF](results/7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf)):** Quantitative eleven-point distortion bounds $\frac{3089}{3084} < \Delta_5(11) \le \frac{115}{106}$ in $\ell_1^5$ and Lean 4.33.1 kernel verification of $e(\ell_1^5)=10$.
* **[`#9400114`](results/9400114/) ([PDF](results/9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf)):** Target-free prime-power radical reduction, short-arc cross-ratio cubic lower bound $p \ge \max\{r^2+2, 1+N(\lfloor(r-1)/4\rfloor)\} \sim r^3/768$, and complete inverse-Frobenius classification for Agrawal's conjecture.

---

## Complete Catalog of All 84 Result Packages

### I. Flagship Counterexamples & Publishable Theorems on Open Conjectures (22 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`20001036`](results/20001036/) | [PDF](results/20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf) | A 5,454-vertex digon-free multi-label counterexample to Seymour–Sullivan Conjecture 6.1 and LP/SMT prototype optimality | Directed graphs & combinatorial optimization | Verified counterexample & optimality theorem |
| [`11000263`](results/11000263/) | [PDF](results/11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf) | Twist-compatible Burau quotient ($X_3\neq 0, X_4=0$) and universal finite-dimensionality of Bigelow's zipper algebra for all $n\ge 4$ | Braid groups & representation theory | Verified counterexample & all-$n$ theorem |
| [`3059`](results/3059/) | [PDF](results/3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf) | The Alon–Jaeger–Tarsi Conjecture in dimensions $8$ and $9$ over $\mathbb{F}_5$ (`C3059N9`, `H8C3059`) | Combinatorial algebra & finite fields | Verified publishable theorem |
| [`3102`](results/3102/) | [PDF](results/3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf) | The support-at-most-five pebbling number of the Lemke square $L\mathbin{\square} L$ is $64$ | Graph theory & combinatorial optimization | Verified publishable theorem |
| [`3167`](results/3167/) | [PDF](results/3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf) | Sheehan's Conjecture for $4$-regular simple graphs of treewidth at most five ($\operatorname{tw}(G)\le 5$) | Structural graph theory | Verified publishable theorem |
| [`3256`](results/3256/) | [PDF](results/3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf) | Sharp reachability-defect threshold $\operatorname{def}(D)\le 2$ for capacitated Woodall dijoin packing $\nu(D,w)=\tau(D,w)$ across all $q\ge 1$ and one-fill chordal digraphs | Combinatorial optimization & digraphs | Verified publishable theorem |
| [`7200051`](results/7200051/) | [PDF](results/7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf) | Quantitative $11$-point distortion bounds $3089/3084 < \Delta_5(11) \le 115/106$ in $\ell_1^5$ and Lean 4.33.1 audit of $e(\ell_1^5)=10$ | Discrete & metric geometry | Verified improved bounds & Lean 4 audit |
| [`1417`](results/1417/) | [PDF](results/1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf) | Uniform square-root edge-deficit bound $n \le \max\{8d,4d^2-8d\} \le 4d^2$ for critical $C_4,C_8$-free graphs (Erdős–Gyárfás) | Extremal & structural graph theory | Verified improved bound |
| [`1518`](results/1518/) | [PDF](results/1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf) | Unconditional sixth-energy saving ($\delta=1/200$) for Riemann zeta zeros near $\sigma=7/8$ and local prime-window bound | Analytic number theory | Verified publishable theorem |
| [`1243`](results/1243/) | [PDF](results/1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf) | Unconditional global squareclasses, $\operatorname{rank} E(k)=1$, $\amalg[2^\infty]\cong(\mathbb{Z}/2\mathbb{Z})^2$, genus-$161$ rational points, and map rigidity on Bremner's K3 surface | Arithmetic geometry & Diophantine equations | Verified publishable theorem |
| [`1187`](results/1187/) | [PDF](results/1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf) | Global nonexistence of $P_2,P_0$ twisted bridges in $\mathbb{F}_2$-Magnus quotients, all-$\mathrm{Aut}(F_2)$ join exclusion, and $w_{\mathrm{prim}}(H)\ge 7$ | Combinatorial & geometric group theory | Verified publishable theorem |
| [`9400114`](results/9400114/) | [PDF](results/9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf) | Target-free prime-power reduction, short-arc cubic obstruction $p \gg r^3$, and inverse-Frobenius classification for Agrawal's conjecture | Computational & algebraic number theory | Verified publishable theorem |
| [`2338`](results/2338/) | [PDF](results/2338/ARGUS_RESULT_2338_TECHNICAL_REPORT.pdf) | Multiplicity five in Pascal's triangle ($K(a)\ge 8, \omega(a)\ge 7, 14$), eventual uniform bound $m(a)\le \omega(a)$, affine orthogonal Runge theorem, and degree-$512$ genus-$1537$ extraspecial $2_+^{1+8}$ cover (Erdős #849) | Diophantine equations & number theory | Verified publishable theorem |
| [`6800022`](results/6800022/) | [PDF](results/6800022/ARGUS_RESULT_6800022_TECHNICAL_REPORT.pdf) | Complete global embeddedness obstruction for the reciprocal-reflection Kato–Muroya genus-one four-catenoidal-end locus | Differential geometry & minimal surfaces | Verified publishable theorem |
| [`1285`](results/1285/) | [PDF](results/1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf) | Unconditional exponential worst-case lower bound for adaptive signed-chain ECM shell-bank factorization programs | Computational number theory & complexity | Verified publishable theorem |
| [`20001675`](results/20001675/) | [PDF](results/20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf) | Arbitrary-depth exponential HOMFLY-PT fibers ($\log_2|\text{fiber}|\ge(N-8)/(74r^2)$) over quiver point-counting polynomials of plabic knots | Cluster algebras & knot polynomials | Verified publishable theorem |
| [`20000816`](results/20000816/) | [PDF](results/20000816/ARGUS_RESULT_20000816_TECHNICAL_REPORT.pdf) | Distinct irreducible components of $\mathrm{Hilb}^{4803}(\mathbb{A}^{20}_{\mathbb{C}})$ sharing a complete unlabelled Gröbner fan | Algebraic geometry & commutative algebra | Verified counterexample (AIM Problem 1.35) |
| [`20000278`](results/20000278/) | [PDF](results/20000278/ARGUS_RESULT_20000278_TECHNICAL_REPORT.pdf) | Irrational non-$\mathbb{Q}$-Gorenstein $F$-jumping number $\lambda=(53609-\sqrt{17})/48$ in characteristic $13$ | Commutative algebra & singularity theory | Verified counterexample (AIM Problem 1.3) |
| [`2884`](results/2884/) | [PDF](results/2884/ARGUS_RESULT_2884_TECHNICAL_REPORT.pdf) | Arbitrary-$X$ stabilization counterexample and fixed-$E(2)$ PL/smooth seven-arrow construction for K3 Problem 4.8 | Smooth $4$-manifolds & knot surgery | Verified counterexample & PL/smooth theorem |
| [`1465`](results/1465/) | [PDF](results/1465/ARGUS_RESULT_1465_TECHNICAL_REPORT.pdf) | Fu 2026 Theorem 2.8 regularity-premise local-finiteness gap with Lean 4 formal core | Model theory & o-minimal structures | Verified proof-premise counterexample |
| [`20001849`](results/20001849/) | [PDF](results/20001849/ARGUS_RESULT_20001849_TECHNICAL_REPORT.pdf) | Flying wings ($n=3,\alpha=1/2$) refute uniqueness of the collapsed product steady Ricci soliton | Differential geometry & Ricci flow | Verified counterexample (AIMPL Problem 6.7) |
| [`20000715`](results/20000715/) | [PDF](results/20000715/ARGUS_RESULT_20000715_TECHNICAL_REPORT.pdf) | Explicit $3$rd-order nonlinear ODE and all-order homogeneous $\mathbb{C}(q)$-linear ODE obstruction for $\eta^{24}$ | Modular forms & differential algebra | Verified obstruction theorem (AIM Problem 1.2) |

---

### II. Millennium-Frontier & Structural Obstruction Theorems (12 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`1138`](results/1138/) | [PDF](results/1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) | Universal isotropy ($\dim_{\mathbb{F}_2} A_C \le g$) and genus-proportional integral Hodge defect ($\dim_{\mathbb{F}_2} D_C \ge g$) on $C \times S_{\text{new}}$ for every curve $C$ | Algebraic geometry & Hodge theory | Verified publishable theorem |
| [`20002392`](results/20002392/) | [PDF](results/20002392/ARGUS_RESULT_20002392_TECHNICAL_REPORT.pdf) | Velocity-only exclusion of backward self-similar Navier–Stokes profiles in $\mathbb{R}^3_+$ under $|U(y)|\le C/(1+|y|)$ | PDE & fluid mechanics | Verified publishable theorem |
| [`40`](results/40/) | [PDF](results/40/ARGUS_RESULT_40_TECHNICAL_REPORT.pdf) | Cartesian logarithmic inverse obstruction and conformal curvature-response closure for axisymmetric Euler flows in curved pipes ($0<|\kappa|\le 1/10$) | PDE & fluid dynamics | Verified publishable theorem |
| [`1275`](results/1275/) | [PDF](results/1275/ARGUS_RESULT_1275_TECHNICAL_REPORT.pdf) | Full-line essential spectrum $\sigma_{\mathrm{ess}}(\widetilde{D})=\mathbb{R}$ for finite-shift dilation restrictions $P(S)C_c^\infty(0,\infty)$ | Spectral theory & Hilbert–Pólya realizations | Verified publishable theorem |
| [`9400078`](results/9400078/) | [PDF](results/9400078/ARGUS_RESULT_9400078_TECHNICAL_REPORT.pdf) | Unconditional exceptional-parameter density bound $\ll_\varepsilon q^{3-4\tau+\varepsilon}$ ($0<\tau\le 1/8$) for ramified $\mathrm{GL}_4$ representations | Automorphic forms & Ramanujan conjecture | Verified publishable theorem |
| [`3395`](results/3395/) | [PDF](results/3395/ARGUS_RESULT_3395_TECHNICAL_REPORT.pdf) | Centered nuclear-error dual charge equivalence and $O(M_n+N^2)$-gate refutation of uncentered relative-mass shortcuts | Computational complexity & circuit lower bounds | Verified equivalence & barrier theorem |
| [`2813`](results/2813/) | [PDF](results/2813/ARGUS_RESULT_2813_TECHNICAL_REPORT.pdf) | Explicit taut-foliation Euler-class obstruction $(-2,-2,2)$ on a hyperbolic genus-$3$ origami mapping torus | Low-dimensional topology & foliations | Verified explicit obstruction (Kirby 3.15) |
| [`20001836`](results/20001836/) | [PDF](results/20001836/ARGUS_RESULT_20001836_TECHNICAL_REPORT.pdf) | Unbounded negative curvature operator $\lambda_{\min}=1-2/\varepsilon^2$ in a collapsing circle quotient of $S^4$ | Riemannian geometry | Verified compact construction |
| [`2800203`](results/2800203/) | [PDF](results/2800203/ARGUS_RESULT_2800203_TECHNICAL_REPORT.pdf) | Threshold discrepancy barriers $O(1/\log n+n^{-1/2})$ for depth-three scalar planted-clique AMP schedules | High-dimensional probability | Verified impossibility theorem |
| [`20000582`](results/20000582/) | [PDF](results/20000582/ARGUS_RESULT_20000582_TECHNICAL_REPORT.pdf) | Moving-window Engel Hilbert cocycles with $\Omega(\sqrt{k})$ homogeneous gauge distortion | Metric geometry & bi-Lipschitz embeddings | Verified construction theorem |
| [`2457`](results/2457/) | [PDF](results/2457/ARGUS_RESULT_2457_TECHNICAL_REPORT.pdf) | Countermodel $H_N=\mathrm{diag}(0_K,(3/10)I_{N-K})$ to the Arvidsson heat-trace bounded-kernel implication | Spectral theory & analytic number theory | Verified proof-premise countermodel (Erdős #1055) |
| [`2307015`](results/2307015/) | [PDF](results/2307015/ARGUS_RESULT_2307015_TECHNICAL_REPORT.pdf) | Translated-cusp Jordan boundary set of positive harmonic measure across 471 normal forms | Complex analysis & potential theory | Verified exact construction |

---

### III. Independently Verified Counterexamples & Literature Resolutions — Batch 001 & Audit Shards (31 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`20000443`](results/20000443/) | [PDF](results/20000443/ARGUS_RESULT_20000443_TECHNICAL_REPORT.pdf) | Smooth rationally connected degree-$5$ hypersurface in $\mathbb{P}^9_K$ over a $\mathrm{cd}(K)\le 1$ field with no $K$-point | Arithmetic & algebraic geometry | Verified counterexample (Jacobian resultant) |
| [`20001224`](results/20001224/) | [PDF](results/20001224/ARGUS_RESULT_20001224_TECHNICAL_REPORT.pdf) | Explicit four-point rational design counterexample to AIM Question 47 | Algebraic statistics & commutative algebra | Verified counterexample |
| [`20001159`](results/20001159/) | [PDF](results/20001159/ARGUS_RESULT_20001159_TECHNICAL_REPORT.pdf) | Connected balanced circulant counterexample $K_{3,3}$ to the $G_B(k,m)$ conjecture and order-$\le 32$ census | Algebraic graph theory | Verified counterexample |
| [`3110`](results/3110/) | [PDF](results/3110/ARGUS_RESULT_3110_TECHNICAL_REPORT.pdf) | Explicit $5$-regular two-stage counterexample $L_5$ to the graph-theoretic Beneš conjecture ($16<25$) | Combinatorics & interconnection networks | Verified counterexample |
| [`1442`](results/1442/) | [PDF](results/1442/ARGUS_RESULT_1442_TECHNICAL_REPORT.pdf) | An $18$-vertex cubic bipartite counterexample to Teschner's bondage-number conjecture ($b(G)=5>9/2$) | Graph theory & domination | Verified counterexample |
| [`3117`](results/3117/) | [PDF](results/3117/ARGUS_RESULT_3117_TECHNICAL_REPORT.pdf) | Counterexample $(C_3\mathbin{\square} K_2)^{3/5}$ with $\chi=6>5=\omega$ for graph fractional powers | Graph coloring & fractional graph theory | Verified counterexample |
| [`7000029`](results/7000029/) | [PDF](results/7000029/ARGUS_RESULT_7000029_TECHNICAL_REPORT.pdf) | Smooth $C^\infty$ counterexamples to the Loewner and Carathéodory umbilic-index conjectures (index $3/2>1$) | Differential geometry & foliations | Verified Lean 4 formal artifact |
| [`1900`](results/1900/) | [PDF](results/1900/ARGUS_RESULT_1900_TECHNICAL_REPORT.pdf) | Refutation of both branches of Erdős Problem #43 on disjoint-difference Sidon sets | Additive combinatorics | Verified Lean 4.27 formal artifact |
| [`2141`](results/2141/) | [PDF](results/2141/ARGUS_RESULT_2141_TECHNICAL_REPORT.pdf) | Congruence sieve survivor set without logarithmic density ($\liminf\le 177/200<49/50\le\limsup$, Erdős #486) | Analytic & combinatorial number theory | Verified Lean 4 formal artifact |
| [`2215`](results/2215/) | [PDF](results/2215/ARGUS_RESULT_2215_TECHNICAL_REPORT.pdf) | Refutation of the linear-saving conjecture for triangle-free diameter-$4$ completion ($h_4(G)\ge(1-\eta)n$, Erdős #619) | Extremal graph theory | Verified Lean 4 formal artifact |
| [`20001068`](results/20001068/) | [PDF](results/20001068/ARGUS_RESULT_20001068_TECHNICAL_REPORT.pdf) | A $26$-vertex, $74$-arc counterexample to the literal weak-inequality form of AIM Conjecture 6.23 | Weighted digraphs | Verified counterexample |
| [`20000282`](results/20000282/) | [PDF](results/20000282/ARGUS_RESULT_20000282_TECHNICAL_REPORT.pdf) | Failure of upper semicontinuity of Hilbert–Kunz multiplicity on $k[a,b,c,d]/(ab,acd)$ | Commutative algebra | Verified counterexample (AIM Problem 1.5) |
| [`20001352`](results/20001352/) | [PDF](results/20001352/ARGUS_RESULT_20001352_TECHNICAL_REPORT.pdf) | Literal-scope counterexample for commutator width and involution factorization in Thompson's group $F$ | Geometric group theory | Verified domain correction (AIMPL 3.1) |
| [`20001602`](results/20001602/) | [PDF](results/20001602/ARGUS_RESULT_20001602_TECHNICAL_REPORT.pdf) | Missing just-infinite hypothesis and Hanoi branch-group counterexample $(G,G'')$ for commensurated subgroups | Group theory & branch groups | Verified literal-scope counterexample |
| [`20001760`](results/20001760/) | [PDF](results/20001760/ARGUS_RESULT_20001760_TECHNICAL_REPORT.pdf) | Rank-one lattice $L=\mathbb{Z}$ refutes the dimension-unrestricted all-shell $12$-design claim | Lattices & spherical designs | Verified literal-scope counterexample |
| [`4600048`](results/4600048/) | [PDF](results/4600048/ARGUS_RESULT_4600048_TECHNICAL_REPORT.pdf) | Irrational fixed point $x=1/(\beta-1)$ for a quartic Salem $\beta$-transformation | Dynamical systems & algebraic number theory | Verified catalogue correction |
| [`20001382`](results/20001382/) | [PDF](results/20001382/ARGUS_RESULT_20001382_TECHNICAL_REPORT.pdf) | Nonclosed-subgroup topological obstruction to the literal inverse arboreal Galois problem | Arithmetic dynamics & profinite groups | Verified scope correction |
| [`20001274`](results/20001274/) | [PDF](results/20001274/ARGUS_RESULT_20001274_TECHNICAL_REPORT.pdf) | Congruent plane projections do not determine a convex body up to translation or reflection ($\varepsilon=1/1000$ two-cap) | Convex & discrete geometry | Verified exact reconstruction |
| [`20001516`](results/20001516/) | [PDF](results/20001516/ARGUS_RESULT_20001516_TECHNICAL_REPORT.pdf) | A $\mathrm{CAT}(0)$ free-by-cyclic group $F_2\rtimes_\phi\mathbb{Z}$ that is not ordinary RFRS | Geometric group theory & topology | Verified reconstruction (AIM Problem 5.3) |
| [`20001862`](results/20001862/) | [PDF](results/20001862/ARGUS_RESULT_20001862_TECHNICAL_REPORT.pdf) | Explicit $8$-vertex half-turn symmetric obstruction to the standard pseudo-triangulation road map | Computational geometry & rigidity | Verified exact reconstruction |
| [`3206`](results/3206/) | [PDF](results/3206/ARGUS_RESULT_3206_TECHNICAL_REPORT.pdf) | A Cayley graph on $\mathbb{Z}_{15}$ whose core is $C_5$ | Algebraic graph theory | Verified exact reconstruction |
| [`1100501`](results/1100501/) | [PDF](results/1100501/ARGUS_RESULT_1100501_TECHNICAL_REPORT.pdf) | Identical complete axis sets do not imply ambient commensurability in Kleinian groups | Kleinian groups & hyperbolic geometry | Verified reconstruction |
| [`20000916`](results/20000916/) | [PDF](results/20000916/ARGUS_RESULT_20000916_TECHNICAL_REPORT.pdf) | The $\ell_1^d$ linear lower bound $(d+1)/2$ obstructing the arbitrary-norm Steinitz $O(\sqrt{d})$ claim | Convex geometry & vector balancing | Verified literature reconstruction |
| [`20000320`](results/20000320/) | [PDF](results/20000320/ARGUS_RESULT_20000320_TECHNICAL_REPORT.pdf) | Weak $\mathbb{Q}$-Gorensteinness does not force pluricanonical base change over $\mathrm{Spec}(k[t]/(t^2))$ | Algebraic geometry | Verified primary-source reconstruction |
| [`1350`](results/1350/) | [PDF](results/1350/ARGUS_RESULT_1350_TECHNICAL_REPORT.pdf) | GCH does not imply an $\aleph_2$-Suslin tree in relative consistency | Set theory | Verified published countermodel |
| [`1200029`](results/1200029/) | [PDF](results/1200029/ARGUS_RESULT_1200029_TECHNICAL_REPORT.pdf) | Dead ends can have positive ball density ($\ge 1/64$) in an infinite Cayley graph | Geometric group theory | Verified published counterexample |
| [`1100101`](results/1100101/) | [PDF](results/1100101/ARGUS_RESULT_1100101_TECHNICAL_REPORT.pdf) | A finite $K(G,1)$ without Baumslag–Solitar subgroups can be non-hyperbolic | Geometric group theory | Verified published counterexample |
| [`20000255`](results/20000255/) | [PDF](results/20000255/ARGUS_RESULT_20000255_TECHNICAL_REPORT.pdf) | Terminal three-fold singularities in positive characteristic need not be Cohen–Macaulay | Birational & algebraic geometry | Verified primary-source refutation (Totaro 2019) |
| [`20000256`](results/20000256/) | [PDF](results/20000256/ARGUS_RESULT_20000256_TECHNICAL_REPORT.pdf) | A characteristic-two $\mathbb{Q}$-factorial $3$-fold plt pair with a non-normal plt centre | Birational geometry | Verified primary-source refutation (Cascini–Tanaka) |
| [`20000332`](results/20000332/) | [PDF](results/20000332/ARGUS_RESULT_20000332_TECHNICAL_REPORT.pdf) | Non-stabilization of Chow semistable pluricanonical limits | Algebraic geometry & moduli | Verified primary-source refutation (Wang–Xu 2014) |
| [`20000472`](results/20000472/) | [PDF](results/20000472/ARGUS_RESULT_20000472_TECHNICAL_REPORT.pdf) | A bounded Fock-space Toeplitz operator with unbounded heat transform at $t=1/4$ | Operator theory & harmonic analysis | Verified primary-source refutation (Looi 2022) |

---

### IV. Symbolic, Algebraic & Polyhedral Boundary Certificates (19 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`20000496`](results/20000496/) | [PDF](results/20000496/ARGUS_RESULT_20000496_TECHNICAL_REPORT.pdf) | Smooth centrally symmetric convex domains in high dimensions with interior hot spots | Spectral geometry & PDE | Verified primary-source refutation (de Dios Pont 2024) |
| [`20000731`](results/20000731/) | [PDF](results/20000731/ARGUS_RESULT_20000731_TECHNICAL_REPORT.pdf) | Counterexamples to Nahm Conjecture 4.1 on $q$-hypergeometric modular functions | Modular forms & algebraic $K$-theory | Verified primary-source refutation (Vlasenko–Zwegers) |
| [`20000778`](results/20000778/) | [PDF](results/20000778/ARGUS_RESULT_20000778_TECHNICAL_REPORT.pdf) | A universal phantom subcategory on the blow-up of $\mathbb{P}^2_{\mathbb{C}}$ at $10$ general points | Algebraic geometry & derived categories | Verified primary-source refutation (Krah 2024) |
| [`1380`](results/1380/) | [PDF](results/1380/ARGUS_RESULT_1380_TECHNICAL_REPORT.pdf) | Exact $175$-leaf rational sign-cell exclusion on the balanced $(2,2,2,2)$ eight-point Heilbronn configuration space | Discrete geometry | Verified symbolic cell-exclusion certificate |
| [`1413`](results/1413/) | [PDF](results/1413/ARGUS_RESULT_1413_TECHNICAL_REPORT.pdf) | Girth-five $77$-matching prefix certificate ($3{,}192$ vertices, $7{,}448$ edges) in the search for a degree-$57$ Moore graph | Algebraic graph theory | Verified prefix certificate |
| [`1900020`](results/1900020/) | [PDF](results/1900020/ARGUS_RESULT_1900020_TECHNICAL_REPORT.pdf) | Diagonal quadratic energy contraction on section returns of the $D=229$ cubic Jacobi–Perron orbit | Number theory & dynamical systems | Verified method obstruction |
| [`1921`](results/1921/) | [PDF](results/1921/ARGUS_RESULT_1921_TECHNICAL_REPORT.pdf) | Uniform maximum-degree bounds excluding bounded offset-signature colorings for Erdős Problem #87 | Ramsey theory | Verified grammar exclusion |
| [`1994`](results/1994/) | [PDF](results/1994/ARGUS_RESULT_1994_TECHNICAL_REPORT.pdf) | Bottom-row quadratic reduction and scalar-span obstruction on rank-$4$ parabolic $\lambda=27$ Erdős–Ulam configurations | Discrete & arithmetic geometry | Verified algebraic reduction |
| [`20000786`](results/20000786/) | [PDF](results/20000786/ARGUS_RESULT_20000786_TECHNICAL_REPORT.pdf) | Hasse–Witt matrix vanishing and cubic scalar cancellation on the $k=3$ quartic reduction branch | Arithmetic geometry | Verified arithmetic lemma |
| [`20001578`](results/20001578/) | [PDF](results/20001578/ARGUS_RESULT_20001578_TECHNICAL_REPORT.pdf) | Exact right-quotient multiplicity exclusion ($8<15$) of $18$-element equality candidates in Thompson's group $F$ | Geometric group theory | Verified family exclusion |
| [`20001904`](results/20001904/) | [PDF](results/20001904/ARGUS_RESULT_20001904_TECHNICAL_REPORT.pdf) | Six-point positive-weight Farkas obstruction to degree-four Hermite curvature repairs on manifolds without conjugate points | Riemannian geometry | Verified Farkas obstruction |
| [`2248`](results/2248/) | [PDF](results/2248/ARGUS_RESULT_2248_TECHNICAL_REPORT.pdf) | Baier–Zhao dispersion scale barriers for quadratic-prime representations $n=ap^2+b$ (Erdős #676) | Analytic number theory | Verified analytic barrier |
| [`2305027`](results/2305027/) | [PDF](results/2305027/ARGUS_RESULT_2305027_TECHNICAL_REPORT.pdf) | Signed Cauchy–Green flux identity and $\ge N/400{,}000$ linear residual lower bound on planar corona corrections | Complex & harmonic analysis | Verified analytic obstruction |
| [`2662`](results/2662/) | [PDF](results/2662/ARGUS_RESULT_2662_TECHNICAL_REPORT.pdf) | Reidemeister-II collapse of two-change local plat families for unknotting and Conway mutation (Kirby 1.3) | Knot theory | Verified topological exclusion |
| [`2669`](results/2669/) | [PDF](results/2669/ARGUS_RESULT_2669_TECHNICAL_REPORT.pdf) | Handle-slide unlink orbit reduction on staged-framing two-component link presentations (Generalized Property R) | Low-dimensional topology | Verified topological reduction |
| [`2775`](results/2775/) | [PDF](results/2775/ARGUS_RESULT_2775_TECHNICAL_REPORT.pdf) | Complete solution classification $u\alpha(v)=vu$ of the $(A_{12},1,A_{12})$ projection fiber for braid and right-angled Artin groups | Braid groups & RAAGs | Verified fiber classification |
| [`2862`](results/2862/) | [PDF](results/2862/ARGUS_RESULT_2862_TECHNICAL_REPORT.pdf) | Co-normalizer orthogonal join reduction and rational Chern–Simons volume on spherical bar cycles (Kirby 3.64) | Low-dimensional topology & $K$-theory | Verified rationality reduction |
| [`8`](results/8/) | [PDF](results/8/ARGUS_RESULT_8_TECHNICAL_REPORT.pdf) | Reduction of the minimal-$101$ root-$4$ odd perfect number branch across $6{,}756{,}355$ prefixes to $\Phi_{31}(269)=\sigma(269^{30})$ | Elementary & computational number theory | Verified branch reduction |
| [`8200002`](results/8200002/) | [PDF](results/8200002/ARGUS_RESULT_8200002_TECHNICAL_REPORT.pdf) | A $39$-dimensional Arb Krawczyk interval-Newton certificate on the third Fourier fibre for $6$-dimensional MUBs | Quantum information & algebraic geometry | Verified interval certificate |

---

## Reproducing the Certificates & Verification Checks

Python 3.10+ is recommended:

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py

# Representative standalone certificate verifiers:
python results/20001036/verify_optimality.py
python results/11000263/verify_burau.py
python results/3059/test_permanent_amplification.py
python results/3102/test_discharge_cover.py
python results/7200051/check_robust_clipping_gap.py
python results/3167/verify_marked_closure.py
python results/20001675/knot_jet_fibers.py
python results/1275/check_finite_shift_certificate.py
python results/9400114/verify_short_arc.py
python results/2338/affine_orthogonal_runge_verify.py
```

---

## Rights and Attribution Notice

> **Copyright © 2026 Argus AI Team. All rights reserved.**
>
> Public disclosure does not waive copyright or transfer authorship. Accurate linking and academic citation are welcome; see [LICENSE](LICENSE) and [CITATION.cff](CITATION.cff) for details.
