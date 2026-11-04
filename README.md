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
  <img src="https://img.shields.io/badge/Checksummed_Artifacts-728-6A1B9A?style=flat-square" alt="728 Artifacts">
  <img src="https://img.shields.io/badge/Verification-Jacobian_%7C_Lean_4_%7C_PARI%2FGP-C62828?style=flat-square" alt="Verification">
</p>

---

## Overview

This repository archives the completed, independently verified mathematical outputs of the **Argus** autonomous research program. Rather than publishing unverified model transcripts, every package in [`results/<ID>/`](results/) is organized around **explicit mathematical statements, exact rerunnable certificates, and explicit scope boundaries**, accompanied by a standalone compiled AMS LaTeX paper (`ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf` and `.tex`).

As of **November 4, 2026**, the archive contains **84 result packages** (**728 SHA-256 checksummed artifacts**):

| Category | Count | Description |
|---|---:|---|
| **I. Flagship Counterexamples & Publishable Theorems on Open Conjectures** | **22** | Direct counterexamples and unconditional theorems advancing open problems in combinatorics, algebra, geometry, and number theory |
| **II. Millennium-Frontier & Structural Obstruction Theorems** | **12** | Unconditional theorems, spectral/geometric obstructions, and density bounds on concrete frontiers of Millennium-class problems |
| **III. Independently Verified Counterexamples & Literature Resolutions (Batch 001 & Audit)** | **31** | Exact counterexamples, Lean 4 formal refutations, and source-audited resolutions across 757 historical problem records |
| **IV. Symbolic, Algebraic & Polyhedral Boundary Certificates** | **19** | Computer-assisted exclusion certificates, Farkas dual proofs, and arithmetic reductions |
| **Total Archived Result Packages** | **84** | Every package includes `ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf`, `.tex`, `README.md`, and `verification-summary.json` |

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

### 6. [`#1138`](results/1138/) — Dyadic Finite-Flat Picard-Torsion Obstruction to the Integral Hodge Conjecture on Enriques Products ([Paper PDF](results/1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf))
* **Result:** Using Knudsen–Mumford determinants of cohomology to extend correspondences across non-smooth finite-flat Picard-torsion group schemes $G_{\pi,\pi}$ ($\pi^2=2$) over mixed-characteristic $(0,2)$ discrete valuation rings (and correcting a mixed-characteristic sign in Liedtke's invariant formula), we construct an explicit Enriques surface $S_{\text{new}}$ over $\mathbb{Q}(\sqrt{2})$ with good dyadic reduction such that on the threefold $E \times S_{\text{new}}$ ($E \colon Y^2+Y=X^3$), every complex algebraic correspondence acts trivially on torsion, yielding a non-vanishing degree-$4$ integral Hodge defect $(\mathbb{Z}/2\mathbb{Z})^2$.

### 7. [`#1518`](results/1518/) & [`#1417`](results/1417/) & [`#3167`](results/3167/) & [`#3256`](results/3256/) & [`#7200051`](results/7200051/) & [`#9400114`](results/9400114/)
* **[`#1518`](results/1518/) ([PDF](results/1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf)):** Unconditional sixth additive energy power saving $\delta = 1/200$ for Riemann zeta zeros near $\sigma = 7/8$ and local Second Hardy–Littlewood exceptional-pair bound $V(N,H) \ll_\varepsilon N^{19/15 - 1/10000 + \varepsilon}$.
* **[`#1417`](results/1417/) ([PDF](results/1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf)):** Parameter-uniform square-root edge-deficit theorem $n \le \max\{8d, 4d^2-8d\} \le 4d^2$ ($d=2n-m$) for strongly $\delta \ge 3$-critical $C_4,C_8$-free graphs, implying $m \le 2n - \max\{7, \lceil 1+\sqrt{n+4}/2\rceil\}$ for minimal Erdős–Gyárfás counterexamples.
* **[`#3167`](results/3167/) ([PDF](results/3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf)):** Proof of Sheehan's conjecture for all finite simple $4$-regular Hamiltonian graphs of treewidth $\operatorname{tw}(G) \le 4$.
* **[`#3256`](results/3256/) ([PDF](results/3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf)):** Weighted Woodall dijoin packing theorem $\nu(D,w)=\tau(D,w)$ for all finite loopless digraphs whose underlying graph becomes chordal upon adding at most one edge.
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
| [`3167`](results/3167/) | [PDF](results/3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf) | Sheehan's Conjecture for $4$-regular simple graphs of treewidth at most four | Structural graph theory | Verified publishable theorem |
| [`3256`](results/3256/) | [PDF](results/3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf) | Weighted dijoin packing $\nu(D,w)=\tau(D,w)$ in one-edge deletions of chordal digraphs | Combinatorial optimization & digraphs | Verified publishable theorem |
| [`7200051`](results/7200051/) | [PDF](results/7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf) | Quantitative $11$-point distortion bounds $3089/3084 < \Delta_5(11) \le 115/106$ in $\ell_1^5$ and Lean 4.33.1 audit of $e(\ell_1^5)=10$ | Discrete & metric geometry | Verified improved bounds & Lean 4 audit |
| [`1417`](results/1417/) | [PDF](results/1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf) | Uniform square-root edge-deficit bound $n \le \max\{8d,4d^2-8d\} \le 4d^2$ for critical $C_4,C_8$-free graphs (Erdős–Gyárfás) | Extremal & structural graph theory | Verified improved bound |
| [`1518`](results/1518/) | [PDF](results/1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf) | Unconditional sixth-energy saving ($\delta=1/200$) for Riemann zeta zeros near $\sigma=7/8$ and local prime-window bound | Analytic number theory | Verified publishable theorem |
| [`1243`](results/1243/) | [PDF](results/1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf) | Unconditional global squareclasses, $\operatorname{rank} E(k)=1$, $\amalg[2^\infty]\cong(\mathbb{Z}/2\mathbb{Z})^2$, genus-$161$ rational points, and map rigidity on Bremner's K3 surface | Arithmetic geometry & Diophantine equations | Verified publishable theorem |
| [`1187`](results/1187/) | [PDF](results/1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf) | Global nonexistence of $P_2,P_0$ twisted bridges in $\mathbb{F}_2$-Magnus quotients, all-$\mathrm{Aut}(F_2)$ join exclusion, and $w_{\mathrm{prim}}(H)\ge 7$ | Combinatorial & geometric group theory | Verified publishable theorem |
| [`9400114`](results/9400114/) | [PDF](results/9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf) | Target-free prime-power reduction, short-arc cubic obstruction $p \gg r^3$, and inverse-Frobenius classification for Agrawal's conjecture | Computational & algebraic number theory | Verified publishable theorem |
| [`2338`](results/2338/) | [PDF](results/2338/ARGUS_RESULT_2338_TECHNICAL_REPORT.pdf) | Multiplicity five in Pascal's triangle ($K(a)\ge 8, \omega(a)\ge 7, 14$), degree-$120$ descent, and affine orthogonal Runge theorem (Erdős #849) | Diophantine equations & number theory | Verified publishable theorem |
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
| [`1138`](results/1138/) | [PDF](results/1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) | Bielliptic half-fiber and mixed-characteristic $(0,2)$ dyadic Picard-torsion obstructions ($\mathrm{Def}^4=(\mathbb{Z}/2\mathbb{Z})^2$) on Enriques products | Algebraic geometry & Hodge theory | Verified integral Hodge obstruction |
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
