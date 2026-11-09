<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../assets/brand/argus-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="../assets/brand/argus-logo-light.svg">
    <img src="../assets/brand/argus-logo-dark.svg" width="420" alt="Argus">
  </picture>
</p>

<h1 align="center">Argus Mathematics — Open-Problem Result Packages</h1>

<p align="center">
  <strong>Autonomous Mathematical Theorems, Exact Counterexamples, and Machine-Verified Certificates</strong><br>
  <a href="README.zh-CN.md">中文说明</a> ·
  <a href="./">All 84 Result Packages (<code>open-problems/</code>)</a> ·
  <a href="results.json">Structured Index (<code>results.json</code>)</a> ·
  <a href="https://github.com/Argus-AiTeam/argus-counterexample-runtime">Standalone Runtime Repo</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Published_Result_Packages-84-174A7E?style=flat-square" alt="84 Result Packages">
  <img src="https://img.shields.io/badge/Standalone_AMS_LaTeX_Papers-84_PDFs-2E7D32?style=flat-square" alt="84 AMS Papers">
  <img src="https://img.shields.io/badge/Checksummed_Artifacts-730-6A1B9A?style=flat-square" alt="728 Artifacts">
  <img src="https://img.shields.io/badge/Verification-Jacobian_%7C_Lean_4_%7C_PARI%2FGP-C62828?style=flat-square" alt="Verification">
</p>

---

## Overview

This repository archives the completed, independently verified mathematical outputs of the **Argus** autonomous research program. Rather than publishing unverified model transcripts, every package in [`open-problems/<ID>/`](./) is organized around **explicit mathematical statements, exact rerunnable certificates, and explicit scope boundaries**, accompanied by a standalone compiled AMS LaTeX paper (`ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf` and `.tex`).

As of **November 5, 2026**, the archive contains **84 standalone open-problem result packages** (**748 SHA-256 checksummed artifacts**) plus a report on Argus's work on OpenAI's `openai/math` collection ([`../openai-math/README.md`](../openai-math/README.md)):

| Category | Count | Description |
|---|---:|---|
| **I. Flagship Counterexamples & Publishable Theorems on Open Conjectures** | **22** | Direct counterexamples and unconditional theorems advancing open problems in combinatorics, algebra, geometry, and number theory |
| **II. Millennium-Frontier & Structural Obstruction Theorems** | **12** | Unconditional theorems, spectral/geometric obstructions, and density bounds on concrete frontiers of Millennium-class problems |
| **III. Independently Verified Counterexamples & Literature Resolutions (Batch 001 & Audit)** | **31** | Exact counterexamples, Lean 4 formal refutations, and source-audited resolutions across 757 historical problem records |
| **IV. Symbolic, Algebraic & Polyhedral Boundary Certificates** | **19** | Computer-assisted exclusion certificates, Farkas dual proofs, and arithmetic reductions |
| **Total Archived Result Packages** | **84** | Every package includes `ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf`, `.tex`, `README.md`, and `verification-summary.json` |

---

## Compute Cost (token-metered)

| | Packages | Tokens | Cost |
|---|---:|---:|---:|
| Dedicated campaigns | 53 | 10.37B | **$13,211.56** (median $105.00 per package) |
| Shared audit and screening pools | 31 | 1.77B | **$1,202.86** |
| **Total** | **84** | **12.14B** | **$14,414.42** |

Costs are provider token-meter dollar equivalents (`total_nano_aiu / 1e11`) taken from every usage event in the campaign ledgers and their session databases, deduplicated. 963 calls carry no token detail and are not priced, so the totals are lower bounds. Per-package figures are in [`usage-audit.json`](usage-audit.json) and [`docs/usage-and-cost-audit.md`](docs/usage-and-cost-audit.md).

<details>
<summary><strong>Cost per dedicated campaign (53 packages)</strong></summary>

| ID | Result package | Runs | Tokens | Cost (token-metered) |
|---|---|---:|---:|---:|
| [`20001036`](20001036/) | A 5,454-vertex multi-label counterexample to Seymour-Sullivan Conjecture 6.1 and prototype optimality | 9 | 693.6M | $1,783.00 |
| [`3395`](3395/) | Centered Nuclear Duality, Addition-Aware Pinning, and Relative-Mass Obstructions in Monotone Boolean Circuit Lower Bounds | 2 | 515.9M | $1,469.29 |
| [`1465`](1465/) | Fu 2026 Theorem 2.8: regularity-premise local-finiteness gap | 1 | 1,730.8M | $1,295.35 |
| [`20000816`](20000816/) | Distinct Hilbert-scheme components sharing a complete unlabelled Grobner fan (AIM Problem 15 / 1.35) | 17 | 292.4M | $1,064.44 |
| [`2248`](2248/) | Baier-Zhao dispersion scale barriers for quadratic-prime representations n = a p^2 + b (Erdos #676) | 1 | 601.6M | $674.48 |
| [`20000582`](20000582/) | Moving-window Engel Hilbert cocycles with Omega(sqrt(k)) homogeneous gauge distortion | 1 | 557.8M | $606.57 |
| [`8200002`](8200002/) | A 39-dimensional Arb Krawczyk interval certificate for the third Fourier fibre in dimension six | 1 | 711.9M | $603.19 |
| [`20001578`](20001578/) | Exact quotient-multiplicity exclusion of 18-element equality candidates in Thompson's group F | 1 | 443.5M | $489.84 |
| [`1138`](1138/) | Universal Isotropy and Genus-Proportional Integral Hodge Defects on Dyadic Enriques Products | 1 | 142.0M | $431.99 |
| [`1380`](1380/) | Exact rational sign-cell exclusion on the balanced (2,2,2,2) Heilbronn configuration space | 1 | 270.7M | $325.93 |
| [`9400114`](9400114/) | Target-Free Prime-Power Reduction, Short-Arc Cubic Obstructions, and Inverse-Frobenius Classifications for Agrawal's Conjecture | 9 | 182.1M | $295.98 |
| [`20000715`](20000715/) | Differential equations and linear-ODE obstructions for eta-products (AIM Problem 1.2) | 14 | 92.9M | $288.56 |
| [`2305027`](2305027/) | A signed Cauchy-Green flux identity and linear residual lower bound on planar corona corrections | 4 | 141.9M | $266.22 |
| [`1518`](1518/) | An Unconditional Sixth-Energy Saving for Riemann Zeta Zeros and a Local Prime-Window Exceptional-Pair Bound | 5 | 354.6M | $242.43 |
| [`2338`](2338/) | Diophantine Obstructions, Affine Orthogonal Runge Theorems, and Degree-512 Extraspecial Covers for Multiplicity Five in Pascal's Triangle | 6 | 287.3M | $238.35 |
| [`9400078`](9400078/) | Unconditional Exceptional-Parameter Density Bounds for Ramified GL_4 Automorphic Representations | 6 | 77.5M | $232.25 |
| [`20000786`](20000786/) | Hasse-Witt matrix vanishing and cubic scalar cancellation on the k=3 quartic reduction branch | 1 | 254.1M | $213.57 |
| [`1187`](1187/) | Global Nonexistence of Twisted Bridges in F_2-Magnus Quotients and Six-Conjugate Primitive Exclusion for Andrews-Curtis Candidates | 5 | 197.3M | $200.89 |
| [`1900020`](1900020/) | Diagonal quadratic energy contraction on section returns of the cubic Jacobi-Perron algorithm | 1 | 96.9M | $180.14 |
| [`3256`](3256/) | Weighted Dijoin Packing in One-Edge Deletions of Chordal Digraphs and Six-Terminal Single-Defect Digraphs | 4 | 323.0M | $165.54 |
| [`1285`](1285/) | An Unconditional Exponential Worst-Case Lower Bound for Adaptive Signed-Chain Elliptic Curve Factorization Programs | 3 | 123.0M | $155.40 |
| [`2669`](2669/) | Handle-slide unlink orbit reduction on staged-framing two-component link presentations (Property R) | 1 | 94.7M | $152.13 |
| [`20002392`](20002392/) | Velocity-Only Exclusion of Backward Self-Similar Navier-Stokes Profiles in a Half-Space | 5 | 51.0M | $150.15 |
| [`40`](40/) | Conformal Transfer and Curvature-Response Closure for Axisymmetric Euler Flows in Periodic Variable-Radius Pipes | 1 | 44.7M | $131.45 |
| [`3167`](3167/) | Sheehan's Conjecture for Four-Regular Simple Graphs of Treewidth at Most Five | 7 | 275.5M | $124.34 |
| [`1994`](1994/) | Bottom-row quadratic reduction and scalar-span obstruction on rank-four parabolic Erdos-Ulam configurations | 1 | 137.0M | $121.95 |
| [`8`](8/) | Reduction of the minimal-101 root-4 odd perfect number branch to the single factor Phi_31(269) | 1 | 163.4M | $105.00 |
| [`20000278`](20000278/) | An irrational non-Q-Gorenstein F-jumping number in characteristic 13 (AIM Problem 1.3) | 2 | 29.5M | $96.33 |
| [`20001274`](20001274/) | Congruent plane projections do not determine a convex body up to translation or reflection | 3 | 25.6M | $84.24 |
| [`20001516`](20001516/) | A CAT(0) free-by-cyclic group that is not ordinary RFRS (AIM Problem 5.3) | 1 | 27.2M | $80.40 |
| [`6800022`](6800022/) | Complete Global Embeddedness Obstruction for the Reciprocal-Reflection Kato-Muroya Genus-One Four-Catenoidal-End Locus | 2 | 151.5M | $78.20 |
| [`2884`](2884/) | K3 Problem 4.8: arbitrary-X stabilization counterexample and fixed-E(2) PL/smooth seven-arrow construction | 1 | 219.3M | $76.02 |
| [`20001602`](20001602/) | Commensurated subgroups of branch groups: missing just-infinite hypothesis and Hanoi group counterexample | 3 | 22.4M | $70.08 |
| [`20001849`](20001849/) | Flying wings refute uniqueness of the collapsed product steady Ricci soliton (AIMPL Problem 6.7) | 3 | 19.0M | $63.41 |
| [`1413`](1413/) | Girth-five 77-matching prefix certificate in the search for a degree-57 Moore graph | 1 | 140.4M | $61.23 |
| [`2800203`](2800203/) | Threshold discrepancy barriers for depth-three scalar planted-clique AMP schedules | 1 | 99.3M | $59.06 |
| [`3059`](3059/) | The Alon-Jaeger-Tarsi Conjecture in Dimensions Eight and Nine over F_5 | 3 | 111.6M | $54.38 |
| [`20001904`](20001904/) | A six-point positive-weight obstruction to degree-four Hermite curvature repairs on manifolds without conjugate points | 1 | 84.1M | $53.52 |
| [`1417`](1417/) | A Uniform Square-Root Edge-Deficit Bound for Strongly Critical Graphs Avoiding Four- and Eight-Cycles | 3 | 44.5M | $52.37 |
| [`2862`](2862/) | Co-normalizer orthogonal join reduction and rational Chern-Simons volume on one-angle spherical bar cycles | 1 | 20.2M | $51.83 |
| [`1243`](1243/) | Unconditional Global Squareclasses, Genus-161 Rational-Point Classification, and Map Rigidity on Bremner's Octic K3 Surface | 6 | 100.0M | $50.04 |
| [`2775`](2775/) | Complete solution classification of the (A_12, 1, A_12) projection fiber for braid and right-angled Artin groups | 1 | 108.4M | $43.55 |
| [`2307015`](2307015/) | A translated-cusp boundary set of positive harmonic measure | 1 | 94.6M | $38.23 |
| [`20001352`](20001352/) | Literal-scope counterexample for commutator width and involution factorization in Thompson's group F (AIMPL Problem 3.1) | 3 | 10.3M | $37.67 |
| [`1275`](1275/) | Essential-Spectrum Obstruction for Finite-Shift Dilation Restrictions in Hilbert-Polya Realizations | 1 | 9.5M | $33.09 |
| [`20001675`](20001675/) | Arbitrary-Depth Exponential HOMFLY-PT Fibers over Quiver Point-Counting Polynomials of Plabic Links and Knots | 4 | 60.0M | $30.81 |
| [`2457`](2457/) | Countermodel to the Arvidsson heat-trace bounded-kernel implication (Erdos Problem #1055) | 1 | 23.6M | $23.85 |
| [`2662`](2662/) | Reidemeister-II collapse of two-change local plat families for unknotting and Conway mutation (Kirby 1.3) | 1 | 41.4M | $20.78 |
| [`7200051`](7200051/) | Quantitative Distortion Bounds and Formal Equilateral Exclusion for Eleven Points in Five-Dimensional l_1 | 2 | 28.3M | $13.52 |
| [`3102`](3102/) | The Support-At-Most-Five Pebbling Number of the Lemke Square Is 64 | 3 | 26.1M | $11.66 |
| [`1921`](1921/) | Uniform degree bounds excluding bounded offset-signature colorings for Erdos Problem #87 | 1 | 7.8M | $8.90 |
| [`11000263`](11000263/) | Twist-compatible Burau quotient and universal finite-dimensionality for Bigelow's zipper algebra | 1 | 6.8M | $7.24 |
| [`2813`](2813/) | An explicit taut-foliation Euler-class obstruction on a hyperbolic mapping torus | 1 | 2.6M | $2.72 |

| Shared pool | Tokens | Cost |
|---|---:|---:|
| `argus-audit-shard-02-retry2` | 1,608.3M | $1,119.47 |
| `argus-audit-shard-01-run3` | 147.8M | $76.30 |
| `argus-open-audit` | 10.9M | $7.09 |
| `argus-counterexamples` | — | not metered (35 calls without token detail) |
| `argus-audit-shard-01-run2` | — | no usage records |

</details>

---

## Featured Flagship Breakthroughs

### 1. [`#20001036`](20001036/) — Refutation of Seymour–Sullivan Conjecture 6.1 on Rainbow Reachability ([Paper PDF](20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf))
* **Problem:** Conjecture 6.1 of Sullivan (*arXiv:math/0605646*, posed by Paul Seymour and Blair Sullivan as a common generalization of Seymour's Second Neighborhood Conjecture and the Caccetta–Häggkvist Conjecture) asks whether every simple digraph $G$ with edge sets $E_1,\ldots,E_k \subseteq E(G)$ either contains a rainbow directed cycle or has a vertex $v$ reaching at least $\sum_{i=1}^k d^+_{G_i}(v)$ vertices via rainbow directed paths.
* **Result:** After proving via exhaustive enumeration ($34{,}012{,}224$ patterns) and $1{,}854$ integer Farkas dual certificates that no counterexample arises from independent-set blow-ups of $n \le 4$ templates, Argus constructed a **$16$-vertex digon-free oriented prototype** with $k=6$ labels and blow-up multiplicities $m=(1096,8,23,69,244,755,1,1059,1,1,1131,1,1,1,1,1062)$, yielding an explicit **$5{,}454$-vertex, $11{,}792{,}572$-arc loopless, digon-free oriented simple digraph** with **no rainbow directed cycle** where **every vertex $v$ violates the reachability bound** ($\sum_{i=1}^6 d^+_{G_i}(v) - |R(v)| \ge 1$). Exact LP/SMT duality (`optimality-certificate.json`) proves that $5{,}454$ is the absolute minimum vertex count on this prototype (integrality gap $0$).

### 2. [`#11000263`](11000263/) — Bigelow's Zipper Algebra Question: $X_3 \neq 0$ Counterexample and All-$n \ge 4$ Universal Finite-Dimensionality Theorem ([Paper PDF](11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf))
* **Problem:** Stephen Bigelow's Question 6 on braid-group zipper algebras $Q_n$.
* **Result:** (1) Under an unreduced twist-compatible Burau specialization at $u=q^3$, $\rho(X_3)=(q-u)(q^2-u)E_2 \neq 0$ while $X_4=0$, refuting the $n=3$ vanishing claim and producing a finite-dimensional quotient surjecting onto the BMW algebra with nonzero kernel. (2) For **every $n \ge 4$**, the universal quotient algebra $Q_n$ is proved to be **finite-dimensional** over its ground field, with explicit double-factorial dimension bounds $(2n-1)!! + 1 \le \dim Q_n \le (2n-1)!! + (n!/3)^2$.

### 3. [`#3059`](3059/) — The Alon–Jaeger–Tarsi Conjecture in Dimensions $8$ and $9$ over $\mathbb{F}_5$ ([Paper PDF](3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf))
* **Problem:** The Alon–Jaeger–Tarsi conjecture asserts that for every finite field $\mathbb{F}_q$ ($q \ge 4$) and every $A \in \mathrm{GL}_n(\mathbb{F}_q)$, there exists $x \in (\mathbb{F}_q^\times)^n$ such that $Ax \in (\mathbb{F}_q^\times)^n$; prime fields $5 \le p \le 61$ and $p=79$ remain open.
* **Result:** We prove the Alon–Jaeger–Tarsi conjecture unconditionally in **dimensions $n=8$ and $n=9$ over $\mathbb{F}_5$**. Three-copy horizontal permanent amplification settles all matrices of permanent rank $\ge 6$ (and $\ge 5$ for $n=8$), while an exact Schur-complement and zero-profile classification at the minimal permanent rank $5$ proves that either $A$ or $A^{-1}$ contains a column with at most three nonzero entries, reducing $n=9$ to $n=8$.

### 4. [`#3102`](3102/) — Graham's Pebbling Conjecture: Support-Five Threshold $64$ on the Lemke Square $L \mathbin{\square} L$ ([Paper PDF](3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf))
* **Problem:** Ronald Graham's 1989 conjecture $\pi(G_1 \mathbin{\square} G_2) \le \pi(G_1)\pi(G_2)$ on the $64$-vertex Cartesian square $L \mathbin{\square} L$ of the $8$-vertex Lemke graph $L$ (previously verified only for support size $\le 4$).
* **Result:** We prove that every $64$-pebble configuration on $L \mathbin{\square} L$ supported on **at most five vertices** reaches every target vertex, establishing $\pi_{\le 5}(L \mathbin{\square} L) = 64$ via split-arm fiber retention and a multistage integer discharge cover across all $181$ rooted-pair orbits and $701$ support templates.

### 5. [`#1243`](1243/) — Unconditional Genus-$161$ Rational-Point Classification and Map Rigidity on Bremner's Magic-Square K3 Surface ([Paper PDF](1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf))
* **Result:** On the Category 3 second-iterate branch of Bremner's octic K3 surface for $3\times 3$ magic squares of squares, we prove **without GRH or $\amalg$-finiteness** that the degree-$18$ two-division field $K/\mathbb{Q}$ has odd class number, the $12$ Simon generators span the full norm-square kernel, and the sextic elliptic cover $E/k$ satisfies $\dim_{\mathbb{F}_2}\mathrm{Sel}_2(E/k)=3$, $\operatorname{rank} E(k)=1$, and $\amalg(E/k)[2^\infty] \cong (\mathbb{Z}/2\mathbb{Z})^2$. Via $p=23$ Chabauty–Coleman closure, the genus-$161$ cover $X$ has exactly $8$ rational points (all above the collision locus $x=-1$), geometric gonality $8$, $\mathrm{Aut}_{\mathbb{Q}}(X)\cong(\mathbb{Z}/2\mathbb{Z})^3$, and admits no nonconstant rational morphism to Bremner's genus-$57$ cover.

### 6. [`#1138`](1138/) — Universal Isotropy ($\dim_{\mathbb{F}_2} D_C \ge g$) and Maximal Arithmetic Vanishing-Cycle Integral Hodge Defects ($\operatorname{Hdg}^4/\operatorname{cl}(\mathrm{CH}^2) \simeq (\mathbb{Z}/2\mathbb{Z})^4$) on Enriques Products ([Paper PDF](1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) · [`universal_isotropy.md`](1138/universal_isotropy.md) · [`arithmetic_defect.md`](1138/arithmetic_defect.md))
* **Result:**
  1. **Universal Isotropy Theorem (Eliminating Benoist–Ottem's *Very General* Hypothesis):** Strengthening Benoist–Ottem (2020, *Comment. Math. Helv.*), which required a *very general* curve $C$, we construct an explicit Enriques surface $S_{\text{new}}$ over $\mathbb{Q}(\sqrt{2})$ with smooth projective dyadic model and finite-flat Picard torsion $G_{\pi,\pi}$ ($\pi^2=2$), and prove via Knudsen–Mumford determinants of cohomology, Raynaud semistable Picard specialization, and SGA~7~I Poincaré biextensions that for **every smooth projective connected complex curve $C$ of genus $g \ge 1$** (with no generality or arithmetic assumption on $C$), the correspondence pullback $A_C = \{Z^*\alpha : Z \in \mathrm{CH}_1(C\times S_{\text{new}})\} \subset H^1(C,\mathbb{F}_2)$ is totally isotropic for the cup product. Consequently, $\dim_{\mathbb{F}_2} A_C \le g$, and the degree-$4$ integral Hodge defect of $C \times S_{\text{new}}$ satisfies **$\dim_{\mathbb{F}_2} D_C = 2g - \dim_{\mathbb{F}_2} A_C \ge g$ for every curve $C$ of genus $g \ge 1$**.
  2. **Arithmetic Vanishing-Cycle Bound & Full-Rank $(\mathbb{Z}/2\mathbb{Z})^4$ Defect Family ([`arithmetic_defect.md`](1138/arithmetic_defect.md)):** We further establish the arithmetic vanishing-cycle orthogonality bound $A \subseteq W^\perp$ ($\dim_{\mathbb{F}_2} D_C \ge \dim_{\mathbb{F}_2} W$) and prove that on the diagonal Enriques quotient $S = T/\langle\iota\rangle \subset \mathbb{P}^5_{\mathbb{Q}}$ and the explicit infinite genus-$2$ family $C_t : y^2 = x^5 - x - 1 + 1083t$ ($t\in\mathbb{Z}$, containing infinitely many geometric isomorphism classes), the complex correspondence pullback vanishes identically ($A_{C_t}=\{0\}$), attaining the **maximal possible degree-$4$ integral Hodge defect $\operatorname{Hdg}^4(C_{t,\mathbb{C}}\times S_{\mathbb{C}},\mathbb{Z})/\operatorname{cl}(\mathrm{CH}^2) \simeq (\mathbb{Z}/2\mathbb{Z})^4$**.

### 7. [`#20001675`](20001675/) & [`#1187`](1187/) & [`#1285`](1285/) & [`#1518`](1518/) & [`#1417`](1417/) & [`#3167`](3167/) & [`#3256`](3256/) & [`#7200051`](7200051/) & [`#9400114`](9400114/)
* **[`#20001675`](20001675/) ([PDF](20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf)):** For every jet depth $r\ge 1$ and word length $m\ge 1$, explicit families of $2^m$ connected simple plabic single-component knots sharing the exact same $\mathbb{F}_q$ quiver point-counting polynomial $R(q)$, Alexander polynomial, and all HOMFLY-PT derivatives of order $<r$ at $a=1$, while producing **$2^m$ pairwise distinct two-variable HOMFLY-PT polynomials** ($\log_2|\text{fiber}|\ge (N-8)/(74r^2)$), together with an exact two-variable interlace polynomial characterization.
* **[`#1187`](1187/) ([PDF](1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf)):** Unconditional nonexistence of solutions to the $P_2$ and $P_0$ Andrews–Curtis twisted bridge equations in $121$- and $3,906$-dimensional truncated $\mathbb{F}_2$-Magnus algebras, and six-conjugate primitive exclusion **$w_{\mathrm{prim}}(H) \ge 7$**.
* **[`#1285`](1285/) ([PDF](1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf)):** Unconditional exponential worst-case bit-operation lower bound for uniform adaptive signed-chain Elliptic Curve Method (ECM) factorization programs on balanced squarefree $n$-bit semiprimes.
* **[`#1518`](1518/) ([PDF](1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf)):** Unconditional sixth additive energy power saving $\delta = 1/200$ for Riemann zeta zeros near $\sigma = 7/8$ and local Second Hardy–Littlewood exceptional-pair bound $V(N,H) \ll_\varepsilon N^{19/15 - 1/10000 + \varepsilon}$.
* **[`#1417`](1417/) ([PDF](1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf)):** Parameter-uniform square-root edge-deficit theorem $n \le \max\{8d, 4d^2-8d\} \le 4d^2$ ($d=2n-m$) for strongly $\delta \ge 3$-critical $C_4,C_8$-free graphs, implying $m \le 2n - \max\{7, \lceil 1+\sqrt{n+4}/2\rceil\}$ for minimal Erdős–Gyárfás counterexamples.
* **[`#3167`](3167/) ([PDF](3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf)):** Unconditional proof of Sheehan's conjecture for all finite simple $4$-regular Hamiltonian graphs of **treewidth $\operatorname{tw}(G) \le 5$** (certified across $152{,}441$ active pointed states, $88{,}107{,}797$ routing entries, and $25{,}209{,}843{,}635$ relative boundary orders with zero uncovered targets).
* **[`#3256`](3256/) ([PDF](3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf)):** Sharp terminal-reachability threshold theorem for capacitated Woodall dijoin packing: $\nu(D,w)=\tau(D,w)$ holds universally for all nonnegative integral capacities $w$ and all $q\ge 1$ whenever the condensation reachability defect satisfies $\operatorname{def}(D)\le 2$ (whereas $\operatorname{def}(D)\ge 3$ fails by Schrijver's 1980 example), plus one-edge deletions of chordal digraphs.
* **[`#7200051`](7200051/) ([PDF](7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf)):** Quantitative eleven-point distortion bounds $\frac{3089}{3084} < \Delta_5(11) \le \frac{115}{106}$ in $\ell_1^5$ and Lean 4.33.1 kernel verification of $e(\ell_1^5)=10$.
* **[`#9400114`](9400114/) ([PDF](9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf)):** Target-free prime-power radical reduction, short-arc cross-ratio cubic lower bound $p \ge \max\{r^2+2, 1+N(\lfloor(r-1)/4\rfloor)\} \sim r^3/768$, and complete inverse-Frobenius classification for Agrawal's conjecture.

---

## Complete Catalog of All 84 Result Packages

### I. Flagship Counterexamples & Publishable Theorems on Open Conjectures (22 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`20001036`](20001036/) | [PDF](20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf) | A 5,454-vertex digon-free multi-label counterexample to Seymour–Sullivan Conjecture 6.1 and LP/SMT prototype optimality | Directed graphs & combinatorial optimization | Verified counterexample & optimality theorem |
| [`11000263`](11000263/) | [PDF](11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf) | Twist-compatible Burau quotient ($X_3\neq 0, X_4=0$) and universal finite-dimensionality of Bigelow's zipper algebra for all $n\ge 4$ | Braid groups & representation theory | Verified counterexample & all-$n$ theorem |
| [`3059`](3059/) | [PDF](3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf) | The Alon–Jaeger–Tarsi Conjecture in dimensions $8$ and $9$ over $\mathbb{F}_5$ (`C3059N9`, `H8C3059`) | Combinatorial algebra & finite fields | Verified publishable theorem |
| [`3102`](3102/) | [PDF](3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf) | The support-at-most-five pebbling number of the Lemke square $L\mathbin{\square} L$ is $64$ | Graph theory & combinatorial optimization | Verified publishable theorem |
| [`3167`](3167/) | [PDF](3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf) | Sheehan's Conjecture for $4$-regular simple graphs of treewidth at most five ($\operatorname{tw}(G)\le 5$) | Structural graph theory | Verified publishable theorem |
| [`3256`](3256/) | [PDF](3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf) | Sharp reachability-defect threshold $\operatorname{def}(D)\le 2$ for capacitated Woodall dijoin packing $\nu(D,w)=\tau(D,w)$ across all $q\ge 1$ and one-fill chordal digraphs | Combinatorial optimization & digraphs | Verified publishable theorem |
| [`7200051`](7200051/) | [PDF](7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf) | Quantitative $11$-point distortion bounds $3089/3084 < \Delta_5(11) \le 115/106$ in $\ell_1^5$ and Lean 4.33.1 audit of $e(\ell_1^5)=10$ | Discrete & metric geometry | Verified improved bounds & Lean 4 audit |
| [`1417`](1417/) | [PDF](1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf) | Uniform square-root edge-deficit bound $n \le \max\{8d,4d^2-8d\} \le 4d^2$ for critical $C_4,C_8$-free graphs (Erdős–Gyárfás) | Extremal & structural graph theory | Verified improved bound |
| [`1518`](1518/) | [PDF](1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf) | Unconditional sixth-energy saving ($\delta=1/200$) for Riemann zeta zeros near $\sigma=7/8$ and local prime-window bound | Analytic number theory | Verified publishable theorem |
| [`1243`](1243/) | [PDF](1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf) | Unconditional global squareclasses, $\operatorname{rank} E(k)=1$, $\amalg[2^\infty]\cong(\mathbb{Z}/2\mathbb{Z})^2$, genus-$161$ rational points, and map rigidity on Bremner's K3 surface | Arithmetic geometry & Diophantine equations | Verified publishable theorem |
| [`1187`](1187/) | [PDF](1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf) | Global nonexistence of $P_2,P_0$ twisted bridges in $\mathbb{F}_2$-Magnus quotients, all-$\mathrm{Aut}(F_2)$ join exclusion, and $w_{\mathrm{prim}}(H)\ge 7$ | Combinatorial & geometric group theory | Verified publishable theorem |
| [`9400114`](9400114/) | [PDF](9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf) | Target-free prime-power reduction, short-arc cubic obstruction $p \gg r^3$, and inverse-Frobenius classification for Agrawal's conjecture | Computational & algebraic number theory | Verified publishable theorem |
| [`2338`](2338/) | [PDF](2338/ARGUS_RESULT_2338_TECHNICAL_REPORT.pdf) | Multiplicity five in Pascal's triangle ($K(a)\ge 8, \omega(a)\ge 7, 14$), eventual uniform bound $m(a)\le \omega(a)$, affine orthogonal Runge theorem, and degree-$512$ genus-$1537$ extraspecial $2_+^{1+8}$ cover (Erdős #849) | Diophantine equations & number theory | Verified publishable theorem |
| [`6800022`](6800022/) | [PDF](6800022/ARGUS_RESULT_6800022_TECHNICAL_REPORT.pdf) | Complete global embeddedness obstruction for the reciprocal-reflection Kato–Muroya genus-one four-catenoidal-end locus | Differential geometry & minimal surfaces | Verified publishable theorem |
| [`1285`](1285/) | [PDF](1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf) | Unconditional exponential worst-case lower bound for adaptive signed-chain ECM shell-bank factorization programs | Computational number theory & complexity | Verified publishable theorem |
| [`20001675`](20001675/) | [PDF](20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf) | Arbitrary-depth exponential HOMFLY-PT fibers ($\log_2|\text{fiber}|\ge(N-8)/(74r^2)$) over quiver point-counting polynomials of plabic knots | Cluster algebras & knot polynomials | Verified publishable theorem |
| [`20000816`](20000816/) | [PDF](20000816/ARGUS_RESULT_20000816_TECHNICAL_REPORT.pdf) | Distinct irreducible components of $\mathrm{Hilb}^{4803}(\mathbb{A}^{20}_{\mathbb{C}})$ sharing a complete unlabelled Gröbner fan | Algebraic geometry & commutative algebra | Verified counterexample (AIM Problem 1.35) |
| [`20000278`](20000278/) | [PDF](20000278/ARGUS_RESULT_20000278_TECHNICAL_REPORT.pdf) | Irrational non-$\mathbb{Q}$-Gorenstein $F$-jumping number $\lambda=(53609-\sqrt{17})/48$ in characteristic $13$ | Commutative algebra & singularity theory | Verified counterexample (AIM Problem 1.3) |
| [`2884`](2884/) | [PDF](2884/ARGUS_RESULT_2884_TECHNICAL_REPORT.pdf) | Arbitrary-$X$ stabilization counterexample and fixed-$E(2)$ PL/smooth seven-arrow construction for K3 Problem 4.8 | Smooth $4$-manifolds & knot surgery | Verified counterexample & PL/smooth theorem |
| [`1465`](1465/) | [PDF](1465/ARGUS_RESULT_1465_TECHNICAL_REPORT.pdf) | Fu 2026 Theorem 2.8 regularity-premise local-finiteness gap with Lean 4 formal core | Model theory & o-minimal structures | Verified proof-premise counterexample |
| [`20001849`](20001849/) | [PDF](20001849/ARGUS_RESULT_20001849_TECHNICAL_REPORT.pdf) | Flying wings ($n=3,\alpha=1/2$) refute uniqueness of the collapsed product steady Ricci soliton | Differential geometry & Ricci flow | Verified counterexample (AIMPL Problem 6.7) |
| [`20000715`](20000715/) | [PDF](20000715/ARGUS_RESULT_20000715_TECHNICAL_REPORT.pdf) | Explicit $3$rd-order nonlinear ODE and all-order homogeneous $\mathbb{C}(q)$-linear ODE obstruction for $\eta^{24}$ | Modular forms & differential algebra | Verified obstruction theorem (AIM Problem 1.2) |

---

### II. Millennium-Frontier & Structural Obstruction Theorems (12 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`1138`](1138/) | [PDF](1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) | Universal isotropy ($\dim_{\mathbb{F}_2} A_C \le g$) and genus-proportional integral Hodge defect ($\dim_{\mathbb{F}_2} D_C \ge g$) on $C \times S_{\text{new}}$ for every curve $C$ | Algebraic geometry & Hodge theory | Verified publishable theorem |
| [`20002392`](20002392/) | [PDF](20002392/ARGUS_RESULT_20002392_TECHNICAL_REPORT.pdf) | Velocity-only exclusion of backward self-similar Navier–Stokes profiles in $\mathbb{R}^3_+$ under $|U(y)|\le C/(1+|y|)$ | PDE & fluid mechanics | Verified publishable theorem |
| [`40`](40/) | [PDF](40/ARGUS_RESULT_40_TECHNICAL_REPORT.pdf) | Cartesian logarithmic inverse obstruction and conformal curvature-response closure for axisymmetric Euler flows in curved pipes ($0<|\kappa|\le 1/10$) | PDE & fluid dynamics | Verified publishable theorem |
| [`1275`](1275/) | [PDF](1275/ARGUS_RESULT_1275_TECHNICAL_REPORT.pdf) | Full-line essential spectrum $\sigma_{\mathrm{ess}}(\widetilde{D})=\mathbb{R}$ for finite-shift dilation restrictions $P(S)C_c^\infty(0,\infty)$ | Spectral theory & Hilbert–Pólya realizations | Verified publishable theorem |
| [`9400078`](9400078/) | [PDF](9400078/ARGUS_RESULT_9400078_TECHNICAL_REPORT.pdf) | Unconditional exceptional-parameter density bound $\ll_\varepsilon q^{3-4\tau+\varepsilon}$ ($0<\tau\le 1/8$) for ramified $\mathrm{GL}_4$ representations | Automorphic forms & Ramanujan conjecture | Verified publishable theorem |
| [`3395`](3395/) | [PDF](3395/ARGUS_RESULT_3395_TECHNICAL_REPORT.pdf) | Centered nuclear-error dual charge equivalence and $O(M_n+N^2)$-gate refutation of uncentered relative-mass shortcuts | Computational complexity & circuit lower bounds | Verified equivalence & barrier theorem |
| [`2813`](2813/) | [PDF](2813/ARGUS_RESULT_2813_TECHNICAL_REPORT.pdf) | Explicit taut-foliation Euler-class obstruction $(-2,-2,2)$ on a hyperbolic genus-$3$ origami mapping torus | Low-dimensional topology & foliations | Verified explicit obstruction (Kirby 3.15) |
| [`20001836`](20001836/) | [PDF](20001836/ARGUS_RESULT_20001836_TECHNICAL_REPORT.pdf) | Unbounded negative curvature operator $\lambda_{\min}=1-2/\varepsilon^2$ in a collapsing circle quotient of $S^4$ | Riemannian geometry | Verified compact construction |
| [`2800203`](2800203/) | [PDF](2800203/ARGUS_RESULT_2800203_TECHNICAL_REPORT.pdf) | Threshold discrepancy barriers $O(1/\log n+n^{-1/2})$ for depth-three scalar planted-clique AMP schedules | High-dimensional probability | Verified impossibility theorem |
| [`20000582`](20000582/) | [PDF](20000582/ARGUS_RESULT_20000582_TECHNICAL_REPORT.pdf) | Moving-window Engel Hilbert cocycles with $\Omega(\sqrt{k})$ homogeneous gauge distortion | Metric geometry & bi-Lipschitz embeddings | Verified construction theorem |
| [`2457`](2457/) | [PDF](2457/ARGUS_RESULT_2457_TECHNICAL_REPORT.pdf) | Countermodel $H_N=\mathrm{diag}(0_K,(3/10)I_{N-K})$ to the Arvidsson heat-trace bounded-kernel implication | Spectral theory & analytic number theory | Verified proof-premise countermodel (Erdős #1055) |
| [`2307015`](2307015/) | [PDF](2307015/ARGUS_RESULT_2307015_TECHNICAL_REPORT.pdf) | Translated-cusp Jordan boundary set of positive harmonic measure across 471 normal forms | Complex analysis & potential theory | Verified exact construction |

---

### III. Independently Verified Counterexamples & Literature Resolutions — Batch 001 & Audit Shards (31 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`20000443`](20000443/) | [PDF](20000443/ARGUS_RESULT_20000443_TECHNICAL_REPORT.pdf) | Smooth rationally connected degree-$5$ hypersurface in $\mathbb{P}^9_K$ over a $\mathrm{cd}(K)\le 1$ field with no $K$-point | Arithmetic & algebraic geometry | Verified counterexample (Jacobian resultant) |
| [`20001224`](20001224/) | [PDF](20001224/ARGUS_RESULT_20001224_TECHNICAL_REPORT.pdf) | Explicit four-point rational design counterexample to AIM Question 47 | Algebraic statistics & commutative algebra | Verified counterexample |
| [`20001159`](20001159/) | [PDF](20001159/ARGUS_RESULT_20001159_TECHNICAL_REPORT.pdf) | Connected balanced circulant counterexample $K_{3,3}$ to the $G_B(k,m)$ conjecture and order-$\le 32$ census | Algebraic graph theory | Verified counterexample |
| [`3110`](3110/) | [PDF](3110/ARGUS_RESULT_3110_TECHNICAL_REPORT.pdf) | Explicit $5$-regular two-stage counterexample $L_5$ to the graph-theoretic Beneš conjecture ($16<25$) | Combinatorics & interconnection networks | Verified counterexample |
| [`1442`](1442/) | [PDF](1442/ARGUS_RESULT_1442_TECHNICAL_REPORT.pdf) | An $18$-vertex cubic bipartite counterexample to Teschner's bondage-number conjecture ($b(G)=5>9/2$) | Graph theory & domination | Verified counterexample |
| [`3117`](3117/) | [PDF](3117/ARGUS_RESULT_3117_TECHNICAL_REPORT.pdf) | Counterexample $(C_3\mathbin{\square} K_2)^{3/5}$ with $\chi=6>5=\omega$ for graph fractional powers | Graph coloring & fractional graph theory | Verified counterexample |
| [`7000029`](7000029/) | [PDF](7000029/ARGUS_RESULT_7000029_TECHNICAL_REPORT.pdf) | Smooth $C^\infty$ counterexamples to the Loewner and Carathéodory umbilic-index conjectures (index $3/2>1$) | Differential geometry & foliations | Verified Lean 4 formal artifact |
| [`1900`](1900/) | [PDF](1900/ARGUS_RESULT_1900_TECHNICAL_REPORT.pdf) | Refutation of both branches of Erdős Problem #43 on disjoint-difference Sidon sets | Additive combinatorics | Verified Lean 4.27 formal artifact |
| [`2141`](2141/) | [PDF](2141/ARGUS_RESULT_2141_TECHNICAL_REPORT.pdf) | Congruence sieve survivor set without logarithmic density ($\liminf\le 177/200<49/50\le\limsup$, Erdős #486) | Analytic & combinatorial number theory | Verified Lean 4 formal artifact |
| [`2215`](2215/) | [PDF](2215/ARGUS_RESULT_2215_TECHNICAL_REPORT.pdf) | Refutation of the linear-saving conjecture for triangle-free diameter-$4$ completion ($h_4(G)\ge(1-\eta)n$, Erdős #619) | Extremal graph theory | Verified Lean 4 formal artifact |
| [`20001068`](20001068/) | [PDF](20001068/ARGUS_RESULT_20001068_TECHNICAL_REPORT.pdf) | A $26$-vertex, $74$-arc counterexample to the literal weak-inequality form of AIM Conjecture 6.23 | Weighted digraphs | Verified counterexample |
| [`20000282`](20000282/) | [PDF](20000282/ARGUS_RESULT_20000282_TECHNICAL_REPORT.pdf) | Failure of upper semicontinuity of Hilbert–Kunz multiplicity on $k[a,b,c,d]/(ab,acd)$ | Commutative algebra | Verified counterexample (AIM Problem 1.5) |
| [`20001352`](20001352/) | [PDF](20001352/ARGUS_RESULT_20001352_TECHNICAL_REPORT.pdf) | Literal-scope counterexample for commutator width and involution factorization in Thompson's group $F$ | Geometric group theory | Verified domain correction (AIMPL 3.1) |
| [`20001602`](20001602/) | [PDF](20001602/ARGUS_RESULT_20001602_TECHNICAL_REPORT.pdf) | Missing just-infinite hypothesis and Hanoi branch-group counterexample $(G,G'')$ for commensurated subgroups | Group theory & branch groups | Verified literal-scope counterexample |
| [`20001760`](20001760/) | [PDF](20001760/ARGUS_RESULT_20001760_TECHNICAL_REPORT.pdf) | Rank-one lattice $L=\mathbb{Z}$ refutes the dimension-unrestricted all-shell $12$-design claim | Lattices & spherical designs | Verified literal-scope counterexample |
| [`4600048`](4600048/) | [PDF](4600048/ARGUS_RESULT_4600048_TECHNICAL_REPORT.pdf) | Irrational fixed point $x=1/(\beta-1)$ for a quartic Salem $\beta$-transformation | Dynamical systems & algebraic number theory | Verified catalogue correction |
| [`20001382`](20001382/) | [PDF](20001382/ARGUS_RESULT_20001382_TECHNICAL_REPORT.pdf) | Nonclosed-subgroup topological obstruction to the literal inverse arboreal Galois problem | Arithmetic dynamics & profinite groups | Verified scope correction |
| [`20001274`](20001274/) | [PDF](20001274/ARGUS_RESULT_20001274_TECHNICAL_REPORT.pdf) | Congruent plane projections do not determine a convex body up to translation or reflection ($\varepsilon=1/1000$ two-cap) | Convex & discrete geometry | Verified exact reconstruction |
| [`20001516`](20001516/) | [PDF](20001516/ARGUS_RESULT_20001516_TECHNICAL_REPORT.pdf) | A $\mathrm{CAT}(0)$ free-by-cyclic group $F_2\rtimes_\phi\mathbb{Z}$ that is not ordinary RFRS | Geometric group theory & topology | Verified reconstruction (AIM Problem 5.3) |
| [`20001862`](20001862/) | [PDF](20001862/ARGUS_RESULT_20001862_TECHNICAL_REPORT.pdf) | Explicit $8$-vertex half-turn symmetric obstruction to the standard pseudo-triangulation road map | Computational geometry & rigidity | Verified exact reconstruction |
| [`3206`](3206/) | [PDF](3206/ARGUS_RESULT_3206_TECHNICAL_REPORT.pdf) | A Cayley graph on $\mathbb{Z}_{15}$ whose core is $C_5$ | Algebraic graph theory | Verified exact reconstruction |
| [`1100501`](1100501/) | [PDF](1100501/ARGUS_RESULT_1100501_TECHNICAL_REPORT.pdf) | Identical complete axis sets do not imply ambient commensurability in Kleinian groups | Kleinian groups & hyperbolic geometry | Verified reconstruction |
| [`20000916`](20000916/) | [PDF](20000916/ARGUS_RESULT_20000916_TECHNICAL_REPORT.pdf) | The $\ell_1^d$ linear lower bound $(d+1)/2$ obstructing the arbitrary-norm Steinitz $O(\sqrt{d})$ claim | Convex geometry & vector balancing | Verified literature reconstruction |
| [`20000320`](20000320/) | [PDF](20000320/ARGUS_RESULT_20000320_TECHNICAL_REPORT.pdf) | Weak $\mathbb{Q}$-Gorensteinness does not force pluricanonical base change over $\mathrm{Spec}(k[t]/(t^2))$ | Algebraic geometry | Verified primary-source reconstruction |
| [`1350`](1350/) | [PDF](1350/ARGUS_RESULT_1350_TECHNICAL_REPORT.pdf) | GCH does not imply an $\aleph_2$-Suslin tree in relative consistency | Set theory | Verified published countermodel |
| [`1200029`](1200029/) | [PDF](1200029/ARGUS_RESULT_1200029_TECHNICAL_REPORT.pdf) | Dead ends can have positive ball density ($\ge 1/64$) in an infinite Cayley graph | Geometric group theory | Verified published counterexample |
| [`1100101`](1100101/) | [PDF](1100101/ARGUS_RESULT_1100101_TECHNICAL_REPORT.pdf) | A finite $K(G,1)$ without Baumslag–Solitar subgroups can be non-hyperbolic | Geometric group theory | Verified published counterexample |
| [`20000255`](20000255/) | [PDF](20000255/ARGUS_RESULT_20000255_TECHNICAL_REPORT.pdf) | Terminal three-fold singularities in positive characteristic need not be Cohen–Macaulay | Birational & algebraic geometry | Verified primary-source refutation (Totaro 2019) |
| [`20000256`](20000256/) | [PDF](20000256/ARGUS_RESULT_20000256_TECHNICAL_REPORT.pdf) | A characteristic-two $\mathbb{Q}$-factorial $3$-fold plt pair with a non-normal plt centre | Birational geometry | Verified primary-source refutation (Cascini–Tanaka) |
| [`20000332`](20000332/) | [PDF](20000332/ARGUS_RESULT_20000332_TECHNICAL_REPORT.pdf) | Non-stabilization of Chow semistable pluricanonical limits | Algebraic geometry & moduli | Verified primary-source refutation (Wang–Xu 2014) |
| [`20000472`](20000472/) | [PDF](20000472/ARGUS_RESULT_20000472_TECHNICAL_REPORT.pdf) | A bounded Fock-space Toeplitz operator with unbounded heat transform at $t=1/4$ | Operator theory & harmonic analysis | Verified primary-source refutation (Looi 2022) |

---

### IV. Symbolic, Algebraic & Polyhedral Boundary Certificates (19 Packages)

| ID | Paper | Title & Mathematical Result | Field | Status |
|---|---|---|---|---|
| [`20000496`](20000496/) | [PDF](20000496/ARGUS_RESULT_20000496_TECHNICAL_REPORT.pdf) | Smooth centrally symmetric convex domains in high dimensions with interior hot spots | Spectral geometry & PDE | Verified primary-source refutation (de Dios Pont 2024) |
| [`20000731`](20000731/) | [PDF](20000731/ARGUS_RESULT_20000731_TECHNICAL_REPORT.pdf) | Counterexamples to Nahm Conjecture 4.1 on $q$-hypergeometric modular functions | Modular forms & algebraic $K$-theory | Verified primary-source refutation (Vlasenko–Zwegers) |
| [`20000778`](20000778/) | [PDF](20000778/ARGUS_RESULT_20000778_TECHNICAL_REPORT.pdf) | A universal phantom subcategory on the blow-up of $\mathbb{P}^2_{\mathbb{C}}$ at $10$ general points | Algebraic geometry & derived categories | Verified primary-source refutation (Krah 2024) |
| [`1380`](1380/) | [PDF](1380/ARGUS_RESULT_1380_TECHNICAL_REPORT.pdf) | Exact $175$-leaf rational sign-cell exclusion on the balanced $(2,2,2,2)$ eight-point Heilbronn configuration space | Discrete geometry | Verified symbolic cell-exclusion certificate |
| [`1413`](1413/) | [PDF](1413/ARGUS_RESULT_1413_TECHNICAL_REPORT.pdf) | Girth-five $77$-matching prefix certificate ($3{,}192$ vertices, $7{,}448$ edges) in the search for a degree-$57$ Moore graph | Algebraic graph theory | Verified prefix certificate |
| [`1900020`](1900020/) | [PDF](1900020/ARGUS_RESULT_1900020_TECHNICAL_REPORT.pdf) | Diagonal quadratic energy contraction on section returns of the $D=229$ cubic Jacobi–Perron orbit | Number theory & dynamical systems | Verified method obstruction |
| [`1921`](1921/) | [PDF](1921/ARGUS_RESULT_1921_TECHNICAL_REPORT.pdf) | Uniform maximum-degree bounds excluding bounded offset-signature colorings for Erdős Problem #87 | Ramsey theory | Verified grammar exclusion |
| [`1994`](1994/) | [PDF](1994/ARGUS_RESULT_1994_TECHNICAL_REPORT.pdf) | Bottom-row quadratic reduction and scalar-span obstruction on rank-$4$ parabolic $\lambda=27$ Erdős–Ulam configurations | Discrete & arithmetic geometry | Verified algebraic reduction |
| [`20000786`](20000786/) | [PDF](20000786/ARGUS_RESULT_20000786_TECHNICAL_REPORT.pdf) | Hasse–Witt matrix vanishing and cubic scalar cancellation on the $k=3$ quartic reduction branch | Arithmetic geometry | Verified arithmetic lemma |
| [`20001578`](20001578/) | [PDF](20001578/ARGUS_RESULT_20001578_TECHNICAL_REPORT.pdf) | Exact right-quotient multiplicity exclusion ($8<15$) of $18$-element equality candidates in Thompson's group $F$ | Geometric group theory | Verified family exclusion |
| [`20001904`](20001904/) | [PDF](20001904/ARGUS_RESULT_20001904_TECHNICAL_REPORT.pdf) | Six-point positive-weight Farkas obstruction to degree-four Hermite curvature repairs on manifolds without conjugate points | Riemannian geometry | Verified Farkas obstruction |
| [`2248`](2248/) | [PDF](2248/ARGUS_RESULT_2248_TECHNICAL_REPORT.pdf) | Baier–Zhao dispersion scale barriers for quadratic-prime representations $n=ap^2+b$ (Erdős #676) | Analytic number theory | Verified analytic barrier |
| [`2305027`](2305027/) | [PDF](2305027/ARGUS_RESULT_2305027_TECHNICAL_REPORT.pdf) | Signed Cauchy–Green flux identity and $\ge N/400{,}000$ linear residual lower bound on planar corona corrections | Complex & harmonic analysis | Verified analytic obstruction |
| [`2662`](2662/) | [PDF](2662/ARGUS_RESULT_2662_TECHNICAL_REPORT.pdf) | Reidemeister-II collapse of two-change local plat families for unknotting and Conway mutation (Kirby 1.3) | Knot theory | Verified topological exclusion |
| [`2669`](2669/) | [PDF](2669/ARGUS_RESULT_2669_TECHNICAL_REPORT.pdf) | Handle-slide unlink orbit reduction on staged-framing two-component link presentations (Generalized Property R) | Low-dimensional topology | Verified topological reduction |
| [`2775`](2775/) | [PDF](2775/ARGUS_RESULT_2775_TECHNICAL_REPORT.pdf) | Complete solution classification $u\alpha(v)=vu$ of the $(A_{12},1,A_{12})$ projection fiber for braid and right-angled Artin groups | Braid groups & RAAGs | Verified fiber classification |
| [`2862`](2862/) | [PDF](2862/ARGUS_RESULT_2862_TECHNICAL_REPORT.pdf) | Co-normalizer orthogonal join reduction and rational Chern–Simons volume on spherical bar cycles (Kirby 3.64) | Low-dimensional topology & $K$-theory | Verified rationality reduction |
| [`8`](8/) | [PDF](8/ARGUS_RESULT_8_TECHNICAL_REPORT.pdf) | Reduction of the minimal-$101$ root-$4$ odd perfect number branch across $6{,}756{,}355$ prefixes to $\Phi_{31}(269)=\sigma(269^{30})$ | Elementary & computational number theory | Verified branch reduction |
| [`8200002`](8200002/) | [PDF](8200002/ARGUS_RESULT_8200002_TECHNICAL_REPORT.pdf) | A $39$-dimensional Arb Krawczyk interval-Newton certificate on the third Fourier fibre for $6$-dimensional MUBs | Quantum information & algebraic geometry | Verified interval certificate |

---

## Reproducing the Certificates & Verification Checks

Python 3.10+ is recommended:

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py

# Representative standalone certificate verifiers:
python open-problems/20001036/verify_optimality.py
python open-problems/11000263/verify_burau.py
python open-problems/3059/test_permanent_amplification.py
python open-problems/3102/test_discharge_cover.py
python open-problems/7200051/check_robust_clipping_gap.py
python open-problems/3167/verify_marked_closure.py
python open-problems/20001675/knot_jet_fibers.py
python open-problems/1275/check_finite_shift_certificate.py
python open-problems/9400114/verify_short_arc.py
python open-problems/2338/affine_orthogonal_runge_verify.py
```

---

## Rights and Attribution Notice

> **Copyright © 2026 Argus AI Team. All rights reserved.**
>
> Public disclosure does not waive copyright or transfer authorship. Accurate linking and academic citation are welcome; see [LICENSE](../LICENSE) and [CITATION.cff](../CITATION.cff) for details.
