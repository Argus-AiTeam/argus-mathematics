<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../assets/brand/argus-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="../assets/brand/argus-logo-light.svg">
    <img src="../assets/brand/argus-logo-dark.svg" width="420" alt="Argus">
  </picture>
</p>

<h1 align="center">Argus Mathematics — 开放问题成果包</h1>

<p align="center">
  <strong>Argus 自治数学研究工程：原创数学定理、精确反例与机器可复核证书总库</strong><br>
  <a href="README.md">English</a> ·
  <a href="./">全部 84 个成果包目录 (<code>open-problems/</code>)</a> ·
  <a href="results.json">结构化索引 (<code>results.json</code>)</a> ·
  <a href="../runtime/">Argus 运行时与 <code>math</code> Vertical</a> ·
  <a href="https://github.com/Argus-AiTeam/argus-counterexample-runtime">独立引擎源码仓库</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/正式归档成果包-84-174A7E?style=flat-square" alt="84 个成果包">
  <img src="https://img.shields.io/badge/独立_AMS_LaTeX_论文-84_篇_PDF-2E7D32?style=flat-square" alt="84 篇论文">
  <img src="https://img.shields.io/badge/SHA--256_校验产物-730-6A1B9A?style=flat-square" alt="728 个产物">
  <img src="https://img.shields.io/badge/验证体系-Jacobian_%7C_Lean_4_%7C_PARI%2FGP-C62828?style=flat-square" alt="验证体系">
</p>

---

## 仓库总览

本仓库集中归档 **Argus** 自治数学研究项目已形成完整证据链的数学定理、显式反例与形式化/符号复算证书。本仓库不堆砌未验证的模型对话，[`open-problems/<ID>/`](./) 下的每一个成果包均围绕**严格的数学命题、可独立重跑的精确证书（Farkas 对偶、SMT/ILP、$\mathbb{F}_2$-Magnus 代数、PARI/GP 数域下降、Lean 4 内核）以及明确的适用边界**构建，并配有独立编译的 AMS LaTeX 学术论文（`ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf` 与 `.tex` 源码）。

截至 **2026 年 11 月 5 日**，仓库共收录 **84 个独立开放问题正式成果包**（**748 个带 SHA-256 校验值的公开产物**），以及一份关于 Argus 在 OpenAI `openai/math` 论文集上工作的报告（[`../openai-math/README.zh-CN.md`](../openai-math/README.zh-CN.md)）：

| 类别 | 数量 | 说明 |
|---|---:|---|
| **一、公开猜想的旗舰反例与可发表新定理** | **22** | 组合图论、有限域代数、代数几何、群论与数论中公开猜想的直接反例及无条件正面定理 |
| **二、千禧年难题前沿子模型与结构阻碍定理** | **12** | 整系数霍奇猜想普适迷向性定理、Navier–Stokes 自相似排除、Euler 弯管共形闭合、Hilbert–Pólya 本质谱阻碍、$\mathrm{GL}_4$ 非温和密度界与电路复杂性对偶 |
| **三、独立核验反例与文献勘误（Batch 001 与全量审计）** | **31** | 对 757 道历史公开问题逐项审计产出的显式反例、Lean 4 形式化反驳与定义域修正 |
| **四、符号计算、代数归约与多面体边界证书** | **19** | 计算机辅助家族排除证书、Farkas 不可行性对偶证明与高精度区间牛顿认证 |
| **合计正式归档成果包** | **84** | 每个成果包均含 `ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf`、`.tex`、`README.md` 与 `verification-summary.json` |

---

## 算力花销（按 token 计量）

| | 成果包数 | Tokens | 花销 |
|---|---:|---:|---:|
| 专项 campaign | 53 | 10.37B | **$13,211.56**（每个包的中位数为 $105.00） |
| 共享审计与筛选池 | 31 | 1.77B | **$1,202.86** |
| **合计** | **84** | **12.14B** | **$14,414.42** |

花销按供应商的 token 计量折算成美元（`total_nano_aiu / 1e11`），数据取自各 campaign 用量文件和会话数据库里的每一条调用记录，已去重。另有 963 次调用没有 token 明细，未计入，所以上面的总额是下限。各成果包的明细见 [`usage-audit.json`](usage-audit.json) 和 [`docs/usage-and-cost-audit.md`](docs/usage-and-cost-audit.md)。

<details>
<summary><strong>各专项 campaign 花销（53 个成果包）</strong></summary>

| ID | 成果包 | 运行次数 | Tokens | 花销（按 token 计量） |
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

| 共享审计池 | Tokens | 花销 |
|---|---:|---:|
| `argus-audit-shard-02-retry2` | 1,608.3M | $1,119.47 |
| `argus-audit-shard-01-run3` | 147.8M | $76.30 |
| `argus-open-audit` | 10.9M | $7.09 |
| `argus-counterexamples` | — | 未计量（35 次调用无 token 明细） |
| `argus-audit-shard-01-run2` | — | 无用量记录 |

</details>

---

## 核心代表作（Featured Flagship Breakthroughs）

### 1. [`#20001036`](20001036/) — 推翻 Paul Seymour 与 Blair Sullivan 的彩虹可达性猜想（Conjecture 6.1）及 5,454 顶点零间隙最优性证明（[论文 PDF](20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf)）
* **问题背景**：Sullivan 综述（*arXiv:math/0605646* 第 6 页 **Conjecture 6.1 (Seymour, Sullivan)**）提出了同时蕴含「Seymour 第二邻域猜想」与「Caccetta–Häggkvist 猜想」的彩色母猜想：设简单有向图 $G=(V,E)$ 带边子集 $E_1,\ldots,E_k\subseteq E(G)$，是否必有彩虹有向圈，或存在顶点 $v$ 使彩虹有向路可达顶点数 $|R(v)| \ge \sum_{i=1}^k d^+_{G_i}(v)$？该猜想自 2006 年提出以来 20 年未决。
* **Argus 成果**：先用 C++ 穷举 $n\le 4, k\le 3$ 的全部 $34{,}012{,}224$ 种构型并用 $1{,}854$ 个整数 Farkas 对偶证书证明 $n\le 4$ 独立集吹胀绝无反例；随后在 $k=6$ 色、$16$ 顶点无双向边（digon-free）原型上求得整数吹胀向量 $m=(1096,8,23,69,244,755,1,1059,1,1,1131,1,1,1,1,1062)$，构造出 **5,454 个顶点、11,792,572 条有向弧的严格定向简单图（无自环、无重边、无双向边）**，图中**不存在任何彩虹有向圈**，且**每一个顶点 $v$ 均严格违反可达性下界**（$\sum_{i=1}^6 d^+_{G_i}(v) - |R(v)| \ge 1$；取 $2m$ 即 $10{,}908$ 顶点时连包含 0 步平凡路也严格违反）。同时通过整数对偶乘子与 SMT（`optimality-certificate.json`）证明了 5,454 是该 16 点原型上的理论绝对最小值（整性间隙为 $0$）。

### 2. [`#11000263`](11000263/) — Bigelow 拉链代数问题：$X_3 \neq 0$ 反例与对一切 $n \ge 4$ 普适商有限维定理（[论文 PDF](11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf)）
* **成果**：(1) 在 $u=q^3$ 的非约化 twist 相容 Burau 表示下算出 $\rho(X_3)=(q-u)(q^2-u)E_2 \neq 0$ 且 $X_4=0$，否定 $n=3$ 消没猜想并给出满射到 BMW 代数且核非零的有限维商；(2) 无条件证明**对一切 $n \ge 4$**，Bigelow 拉链代数的普适商 $Q_n$ 均是**有限维代数**，维数满足 $(2n-1)!! + 1 \le \dim Q_n \le (2n-1)!! + (n!/3)^2$。

### 3. [`#3059`](3059/) — 完整证明 $\mathbb{F}_5$ 上 $8$ 维与 $9$ 维的 Alon–Jaeger–Tarsi 无零坐标猜想（[论文 PDF](3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf)）
* **成果**：针对素数域 $5\le p\le 61$ 上长期开放的 Alon–Jaeger–Tarsi 猜想，无条件证明了 **$\forall A \in \mathrm{GL}_n(\mathbb{F}_5)$（$n \in \{8,9\}$），必存在无零分量向量 $x \in (\mathbb{F}_5^\times)^n$ 使得 $Ax \in (\mathbb{F}_5^\times)^n$**。证明结合了三拷贝水平永久式秩放大定理（解决 $\operatorname{perrank}\ge 6$）与极小永久式秩 $5$ 下的 Schur 补零剖面分类（证明 $A$ 或 $A^{-1}$ 必有一列至多含 3 个非零元，从而归约到 8 维）。

### 4. [`#3102`](3102/) — Ronald Graham 笛卡尔积 Pebbling 猜想：证明 Lemke 平方图 $L \mathbin{\square} L$ 支撑集 $\le 5$ 的精确阈值为 $64$（[论文 PDF](3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf)）
* **成果**：将 2024 年文献仅证到支撑集 $\le 4$ 的结果推进一阶——通过分叉臂纤维保持引理与多阶段整数放电覆盖，完整验证全部 $181$ 个有根顶点对轨道、$701$ 个支撑模板与 $723$ 个远距重堆整数分配，严格证明 64 顶点 Lemke 平方图 $L \mathbin{\square} L$ 上**任意支撑集大小 $\le 5$ 的 64-pebble 配置均可到达任意目标根顶点**（$\pi_{\le 5}(L\mathbin{\square} L)=64$）。

### 5. [`#1243`](1243/) — 3×3 平方数幻方：Bremner 八次 K3 曲面亏格 161 覆盖的有理点无条件完全分类与映射刚性定理（[论文 PDF](1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf)）
* **成果**：在不依赖 GRH 与 $\amalg$ 有限性的前提下，证明 18 次二等分域 $K/\mathbb{Q}$ 类数为奇数、12 个 Simon 生成元张成完整的范数平方类核，并结合 Cassels–Tate 配对证明 6 次椭圆覆盖满足 $\dim_{\mathbb{F}_2}\mathrm{Sel}_2(E/k)=3$、$\operatorname{rank} E(k)=1$ 及 $\amalg(E/k)[2^\infty]\cong(\mathbb{Z}/2\mathbb{Z})^2$。结合 $p=23$ Chabauty–Coleman 闭合，证明亏格 161 三平方覆盖曲线 $X(\mathbb{Q})$ 仅有 $x=-1$ 上方的 8 个碰撞有理点，几何 gonality 为 8，$\mathrm{Aut}_{\mathbb{Q}}(X)\cong(\mathbb{Z}/2\mathbb{Z})^3$，且不存在到 Bremner 亏格 57 曲线的非常数有理态射。

### 6. [`#1138`](1138/) — 整系数霍奇猜想：二进 Enriques 乘积普适全迷向定理（$\dim_{\mathbb{F}_2} D_C \ge g$）与算术消失圈最大缺陷定理（$\operatorname{Hdg}^4/\operatorname{cl}(\mathrm{CH}^2) \simeq (\mathbb{Z}/2\mathbb{Z})^4$）（[论文 PDF](1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) · [`universal_isotropy.md`](1138/universal_isotropy.md) · [`arithmetic_defect.md`](1138/arithmetic_defect.md)）
* **成果**：
  1. **普适全迷向定理（彻底去掉 Benoist–Ottem 2020 的 very general 假设）**：Benoist–Ottem (2020, *Comment. Math. Helv.*) 的主定理仅能对“非常一般（very general）”曲线证明整系数霍奇猜想在 $C\times S$ 上失效。我们在 $\mathbb{Q}(\sqrt{2})$ 上显式构造出具有二进光滑射影模型与有限平坦 Picard 挠群 $G_{\pi,\pi}$（$\pi^2=2$）的 Enriques 曲面 $S_{\text{new}}$，结合 Knudsen–Mumford 完美复形上同调行列式、Raynaud 半稳定曲线 Picard 专门化与 SGA~7~I Poincaré 双扩张，无条件证明：对**任意亏格 $g\ge 1$ 的光滑射影连通复曲线 $C$（无需任何“非常一般”或数域定义假设）**，代数对应拉回子空间 $A_C = \{Z^*\alpha : Z \in \mathrm{CH}_1(C\times S_{\text{new}})\} \subset H^1(C,\mathbb{F}_2)$ 关于杯积**恒为全迷向子空间（totally isotropic）**，从而
     $$\dim_{\mathbb{F}_2} A_C \le g \implies \dim_{\mathbb{F}_2} D_C = 2g - \dim_{\mathbb{F}_2} A_C \ge g,$$
     即整系数霍奇猜想在 $C \times S_{\text{new}}$ 上对**每一条**正亏格光滑复曲线 $C$ 均不成立，且缺陷维数至少随亏格 $g$ 线性增长！
  2. **算术消失圈界与满维最大缺陷 $(\mathbb{Z}/2\mathbb{Z})^4$ 无穷曲线族（[`arithmetic_defect.md`](1138/arithmetic_defect.md)）**：进一步证明算术消失圈正交界 $A \subseteq W^\perp$（$\dim_{\mathbb{F}_2} D_C \ge \dim_{\mathbb{F}_2} W$），并在对角 Enriques 商曲面 $S = T/\langle\iota\rangle \subset \mathbb{P}^5_{\mathbb{Q}}$ 与显式亏格 2 曲线无穷族 $C_t: y^2 = x^5 - x - 1 + 1083t$（$t\in\mathbb{Z}$，含无穷多个几何不同构类）上证明全体复代数闭链拉回 $A_{C_t}=\{0\}$ 彻底归零，使四次整系数霍奇缺陷群达到**理论绝对上限 $(\mathbb{Z}/2\mathbb{Z})^{2g} = (\mathbb{Z}/2\mathbb{Z})^4$**！

### 7. 其它新近完成的可发表级定理精选（[`#20001675`](20001675/)、[`#1187`](1187/)、[`#1285`](1285/)、[`#1518`](1518/)、[`#1417`](1417/)、[`#3167`](3167/)、[`#3256`](3256/)、[`#7200051`](7200051/)、[`#9400114`](9400114/)）
* **[`#20001675`](20001675/) ([PDF](20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf))**：针对 Galashin–Lam 丛代数 Plabic 图问题，对任意射流深度 $r\ge 1$ 与字长 $m\ge 1$ 构造出 $2^m$ 个连通简单 plabic 单分支纽结（knots），它们共享完全相同的 $\mathbb{F}_q$ 箭图点计数多项式 $R(q)$、相同的 Alexander 多项式及 $a=1$ 处 $<r$ 阶全部导数，却产生 **$2^m$ 个两两不同的双变量 HOMFLY-PT 多项式**（$\log_2|\text{fiber}|\ge (N-8)/(74r^2)$），并通过两变量交错多项式（interlace polynomial）完整刻画其森林不变量。
* **[`#1187`](1187/) ([PDF](1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf))**：Andrews–Curtis 猜想：在 121 维与 3,906 维截断 $\mathbb{F}_2$-Magnus 代数中证明标准候选表示 $P_2, P_0$ 的扭曲桥方程对任意字长无解，并证明秩 2 候选子群的原元共轭宽度满足 **$w_{\mathrm{prim}}(H)\ge 7$**。
* **[`#1285`](1285/) ([PDF](1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf))**：无条件证明任何自适应带符号链椭圆曲线分解（ECM）壳库程序在平衡无平方因子 $n$ 比特半素数 $N_n=p_nq_n$ 上的最坏情况指数级比特操作下界。
* **[`#1518`](1518/) ([PDF](1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf))**：用短磨光零点检测器证明黎曼 $\zeta(s)$ 零点在 $|\sigma-7/8|\le 10^{-3}$ 邻域的**六阶加性能量无条件幂次节省 $\delta=1/200$**，并导出第二 Hardy–Littlewood 猜想在 $\log_N H \approx 5/12$ 处的异常对上界 $V(N,H)\ll_\varepsilon N^{19/15 - 1/10000 + \varepsilon}$。
* **[`#1417`](1417/) ([PDF](1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf))**：强最小度 3 临界无 $C_4,C_8$ 图的参数统一平方根边亏损定理 $n \le \max\{8d, 4d^2-8d\} \le 4d^2$（将 Erdős–Gyárfás 极小反例边数上界压至 $m \le 2n - \max\{7, \lceil 1+\sqrt{n+4}/2\rceil\}$）。
* **[`#3167`](3167/) ([PDF](3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf))**：无条件证明所有**树宽 $\operatorname{tw}(G)\le 5$** 的有限简单 4-正则哈密顿图必有至少两个不同的无向哈密顿圈（遍历 6 顶点边界袋的全部 $152{,}441$ 个带标状态、$88{,}107{,}797$ 个正路由条目与 $25{,}209{,}843{,}635$ 个相对边界序，未覆盖目标数为 $0$）。
* **[`#3256`](3256/) ([PDF](3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf))**：完整解决 Schrijver (1980) 以来悬置 46 年的加权 Dijoin 打包可达性缺陷阈值问题——无条件证明对任意非负整数容量 $w$ 与任意 $q\ge 1$，当强连通缩合图的不可达源汇对数满足 **$\operatorname{def}(D)\le 2$** 时恒有 $\nu(D,w)=\tau(D,w)$（而 $\operatorname{def}(D)\ge 3$ 被 Schrijver 反例证伪，故阈值 $d=2$ 绝对紧），并推广至全体单边缺失弦图。
* **[`#7200051`](7200051/) ([PDF](7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf))**：证明 $\ell_1^5$ 空间 11 点最小失真比满足 $\frac{3089}{3084} < \Delta_5(11) \le \frac{115}{106}$，并完成 $e(\ell_1^5)=10$ 的 Lean 4.33.1 内核形式化核验。
* **[`#9400114`](9400114/) ([PDF](9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf))**：Agrawal 素性猜想的无目标素数幂根基约化、短弧有理交比显式三次方下界 $p \ge \max\{r^2+2, 1+N(\lfloor(r-1)/4\rfloor)\} \sim r^3/768$ 及逆 Frobenius 分圆范数完整分类。

---

## 全部 84 个成果包完整分类目录

### 一、公开猜想的旗舰反例与可发表新定理（22 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`20001036`](20001036/) | [PDF](20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf) | Seymour–Sullivan 猜想 6.1（彩虹可达性）的 5,454 顶点严格定向图反例与 16 点原型零间隙最优性证明 | 有向图与组合优化 | 已独立验证反例与最优性定理 |
| [`11000263`](11000263/) | [PDF](11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf) | Bigelow 拉链代数的 twist Burau 商（$X_3\neq 0, X_4=0$）与全 $n\ge 4$ 普适商有限维定理 | 辫群与代数表示论 | 已独立验证反例与全 $n$ 定理 |
| [`3059`](3059/) | [PDF](3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf) | 证明 $\mathbb{F}_5$ 上 8 维与 9 维 Alon–Jaeger–Tarsi 无零坐标猜想（`C3059N9`, `H8C3059`） | 组合代数与有限域 | 已独立验证可发表定理 |
| [`3102`](3102/) | [PDF](3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf) | 证明 Lemke 平方图 $L\mathbin{\square} L$ 在支撑集 $\le 5$ 下的精确 Pebbling 数为 64 | 图论与组合优化 | 已独立验证可发表定理 |
| [`3167`](3167/) | [PDF](3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf) | 证明树宽 $\mathrm{tw}\le 5$ 的有限简单 4-正则哈密顿图必有至少两个哈密顿圈（Sheehan 猜想） | 结构图论 | 已独立验证可发表定理 |
| [`3256`](3256/) | [PDF](3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf) | 加权 Woodall Dijoin 打包的源汇不可达缺陷紧阈值定理（$\operatorname{def}(D)\le 2$ 对任意整容量 $q\ge 1$ 成立，$d\ge 3$ 失效）与单边缺失弦图定理 | 组合优化与有向图 | 已独立验证可发表定理 |
| [`7200051`](7200051/) | [PDF](7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf) | $\ell_1^5$ 空间 11 点失真比上下界 $3089/3084 < \Delta_5(11) \le 115/106$ 与 $e(\ell_1^5)=10$ 的 Lean 4.33.1 核验 | 离散与度量几何 | 已独立验证上下界与 Lean 4 核验 |
| [`1417`](1417/) | [PDF](1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf) | 强最小度 3 临界无 $C_4,C_8$ 图的平方根边亏损定理 $n\le\max\{8d,4d^2-8d\}\le 4d^2$（Erdős–Gyárfás） | 极值与结构图论 | 已独立验证改进上界定理 |
| [`1518`](1518/) | [PDF](1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf) | 黎曼 $\zeta$ 零点在 $\sigma\approx 7/8$ 处的六阶加性能量无条件节省（$\delta=1/200$）与素数窗口异常对上界 | 解析数论 | 已独立验证可发表定理 |
| [`1243`](1243/) | [PDF](1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf) | 3×3 平方数幻方 Bremner K3 曲面 18 次域平方类完备性、$\operatorname{rank} E(k)=1$、亏格 161 有理点完全分类与刚性 | 算术几何与丢番图方程 | 已独立验证可发表定理 |
| [`1187`](1187/) | [PDF](1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf) | Andrews–Curtis 候选表示在 4/5 阶 $\mathbb{F}_2$-Magnus 商群中的扭曲桥不存在定理、全 $\mathrm{Aut}(F_2)$ 排除与 $w_{\mathrm{prim}}(H)\ge 7$ | 组合与几何群论 | 已独立验证可发表定理 |
| [`9400114`](9400114/) | [PDF](9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf) | Agrawal 猜想的无目标素数幂根基约化、短弧交比显式三次方下界 $p\gg r^3$ 与逆 Frobenius 分类 | 计算与代数数论 | 已独立验证可发表定理 |
| [`2338`](2338/) | [PDF](2338/ARGUS_RESULT_2338_TECHNICAL_REPORT.pdf) | 杨辉三角重数 5 素因子下界（$K(a)\ge 8, \omega(a)\ge 7, 14$）、一致渐近上界 $m(a)\le\omega(a)$、仿射正交群 Runge 定理与 512 次（亏格 1537）超特殊 2-群 $2_+^{1+8}$ 覆盖阻碍（Erdős #849） | 丢番图方程与代数数论 | 已独立验证可发表定理 |
| [`6800022`](6800022/) | [PDF](6800022/ARGUS_RESULT_6800022_TECHNICAL_REPORT.pdf) | 互反反射对称 Kato–Muroya 亏格 1 四悬链端极小曲面轨迹全部 9 种穿孔分布的全局嵌入不存在定理 | 微分几何与极小曲面 | 已独立验证可发表定理 |
| [`1285`](1285/) | [PDF](1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf) | 一致自适应符号链 ECM 壳库整数分解程序在 $n$ 比特无平方因子半素数上的最坏情况无条件指数下界 | 计算数论与算术复杂性 | 已独立验证可发表定理 |
| [`20001675`](20001675/) | [PDF](20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf) | 任意喷流深度 $r\ge 1$ 下简单非约化 Plabic 纽结的指数级 HOMFLY-PT 纤维定理（$\log_2|\text{fiber}|\ge(N-8)/(74r^2)$） | 丛代数与纽结多项式 | 已独立验证可发表定理 |
| [`20000816`](20000816/) | [PDF](20000816/ARGUS_RESULT_20000816_TECHNICAL_REPORT.pdf) | $\mathrm{Hilb}^{4803}(\mathbb{A}^{20}_{\mathbb{C}})$ 不同不可约分支在稠密开集上共享完整无标签 Gröbner 扇 | 代数几何与计算交换代数 | 已独立验证反例（AIM Problem 1.35） |
| [`20000278`](20000278/) | [PDF](20000278/ARGUS_RESULT_20000278_TECHNICAL_REPORT.pdf) | 特征 13 非 $\mathbb{Q}$-Gorenstein 局部整环的无理 $F$-跳跃数 $\lambda=(53609-\sqrt{17})/48$ | 交换代数与正特征奇点 | 已独立验证反例（AIM Problem 1.3） |
| [`2884`](2884/) | [PDF](2884/ARGUS_RESULT_2884_TECHNICAL_REPORT.pdf) | K3 Problem 4.8 任意 $X$ 稳定化反例与固定 $E(2)_{6_3}\to E(2)_{19nh_{78}}$ 七步 PL/光滑构造 | 光滑四维流形与纽结手术 | 已独立验证反例与构造定理 |
| [`1465`](1465/) | [PDF](1465/ARGUS_RESULT_1465_TECHNICAL_REPORT.pdf) | Fu 2026 定理 2.8 正则性局部有限前提漏洞及 Lean 4 逻辑核心验证 | 模型论与 o-极小结构 | 已独立验证前提反例 |
| [`20001849`](20001849/) | [PDF](20001849/ARGUS_RESULT_20001849_TECHNICAL_REPORT.pdf) | Flying wings ($n=3,\alpha=1/2$) 反驳全尺度空间塌缩下三维稳态 Ricci 孤立子唯一性 | 微分几何与 Ricci 流 | 已独立验证反例（AIMPL 6.7） |
| [`20000715`](20000715/) | [PDF](20000715/ARGUS_RESULT_20000715_TECHNICAL_REPORT.pdf) | $\eta^{24}$ 的显式三阶非线性微分方程与全阶齐次 $\mathbb{C}(q)$-线性 ODE 阻碍定理 | 模形式与微分代数 | 已独立验证阻碍定理（AIM 1.2） |

---

### 二、千禧年难题前沿子模型与结构阻碍定理（12 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`1138`](1138/) | [PDF](1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) | 二进 Enriques 乘积 $C\times S_{\text{new}}$ 对一切正亏格复曲线 $C$ 的普适全迷向定理（$\dim_{\mathbb{F}_2} A_C\le g$）与亏格成正比整系数霍奇缺陷（$\dim_{\mathbb{F}_2} D_C\ge g$） | 代数几何与霍奇理论 | 已独立验证可发表定理 |
| [`20002392`](20002392/) | [PDF](20002392/ARGUS_RESULT_20002392_TECHNICAL_REPORT.pdf) | 半空间 $\mathbb{R}^3_+$ 无滑移边界下仅假设速度衰减 $|U(y)|\le C/(1+|y|)$ 的后向自相似 Navier–Stokes 对齐剖面完整排除定理 | 偏微分方程与流体力学 | 已独立验证可发表定理 |
| [`40`](40/) | [PDF](40/ARGUS_RESULT_40_TECHNICAL_REPORT.pdf) | 变半径周期余弦管壁（$0<|\kappa|\le 1/10$）轴对称 Euler 流笛卡尔逆对数发散反例与共形曲率响应闭合定理 | 偏微分方程与流体力学 | 已独立验证可发表定理 |
| [`1275`](1275/) | [PDF](1275/ARGUS_RESULT_1275_TECHNICAL_REPORT.pdf) | Hilbert–Pólya 有限移位膨胀算子限制 $D|_{P(S)C_c^\infty(0,\infty)}$ 的全实轴本质谱阻碍定理 $\sigma_{\mathrm{ess}}(\widetilde{D})=\mathbb{R}$ | 谱理论与解析数论 | 已独立验证可发表定理 |
| [`9400078`](9400078/) | [PDF](9400078/ARGUS_RESULT_9400078_TECHNICAL_REPORT.pdf) | $\mathrm{GL}_4$ 分歧型尖点自守表示违背温和性的无条件密度上界 $\ll_\varepsilon q^{3-4\tau+\varepsilon}$（$0<\tau\le 1/8$） | 自守形式与广义 Ramanujan 猜想 | 已独立验证可发表定理 |
| [`3395`](3395/) | [PDF](3395/ARGUS_RESULT_3395_TECHNICAL_REPORT.pdf) | 单调布尔电路下界中的中心化核误差荷对偶等价性、非中心化相对质量捷径的 $O(M_n+N^2)$ 门反例与局部矩阵粘合阻碍 | 计算复杂性理论与电路下界 | 已独立验证等价性与障碍定理 |
| [`2813`](2813/) | [PDF](2813/ARGUS_RESULT_2813_TECHNICAL_REPORT.pdf) | 双曲映射环面上的显式紧叶状结构 Euler 类 $(-2,-2,2)$ 障碍 | 低维拓扑与叶状结构 | 已独立验证显式障碍（Kirby 3.15） |
| [`20001836`](20001836/) | [PDF](20001836/ARGUS_RESULT_20001836_TECHNICAL_REPORT.pdf) | 坍缩圆周商 $S^4$ 中无统一下界的负曲率算子 $\lambda_{\min}=1-2/\varepsilon^2$ | 黎曼几何 | 已独立验证紧致构造 |
| [`2800203`](2800203/) | [PDF](2800203/ARGUS_RESULT_2800203_TECHNICAL_REPORT.pdf) | 深度 3 标量植入团 AMP 调度的阈值差障碍 $O(1/\log n+n^{-1/2})$ | 高维概率与统计推断 | 已独立验证不可能定理 |
| [`20000582`](20000582/) | [PDF](20000582/ARGUS_RESULT_20000582_TECHNICAL_REPORT.pdf) | 具有 $\Omega(\sqrt{k})$ 齐次规范扭曲的移动窗口 Engel Hilbert 上闭链 | 度量几何与双 Lipschitz 嵌入 | 已独立验证构造定理 |
| [`2457`](2457/) | [PDF](2457/ARGUS_RESULT_2457_TECHNICAL_REPORT.pdf) | Arvidsson 热迹有界核蕴含命题的对角反模型 $H_N=\mathrm{diag}(0_K,(3/10)I_{N-K})$ | 谱理论与解析数论 | 已独立验证前提反模型（Erdős #1055） |
| [`2307015`](2307015/) | [PDF](2307015/ARGUS_RESULT_2307015_TECHNICAL_REPORT.pdf) | 具有正调和测度的平移尖点 Jordan 边界集（覆盖 471 个规范形式） | 复分析与势论 | 已独立验证精确构造 |

---

### 三、独立核验反例与文献勘误 — Batch 001 与全量审计（31 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`20000443`](20000443/) | [PDF](20000443/ARGUS_RESULT_20000443_TECHNICAL_REPORT.pdf) | $\mathrm{cd}(K)\le 1$ 域上无 $K$-有理点的 $\mathbb{P}^9_K$ 光滑五次有理连通超曲面 | 算术与代数几何 | 已独立验证反例（Jacobian 结式证书） |
| [`20001224`](20001224/) | [PDF](20001224/ARGUS_RESULT_20001224_TECHNICAL_REPORT.pdf) | AIM 问题 47（代数统计设计理想）的四点有理显式反例 | 代数统计与计算交换代数 | 已独立验证显式反例 |
| [`20001159`](20001159/) | [PDF](20001159/ARGUS_RESULT_20001159_TECHNICAL_REPORT.pdf) | 平衡循环图 $G_B(k,m)$ 猜想的连通反例 $K_{3,3}$ 及 32 阶内 196,573 个循环图全量核验 | 代数图论与完美图 | 已独立验证反例 |
| [`3110`](3110/) | [PDF](3110/ARGUS_RESULT_3110_TECHNICAL_REPORT.pdf) | Beneš 猜想图论形式的 5-正则二阶段显式反例 $L_5$（最小割证书 $16<25$） | 组合数学与互连网络 | 已独立验证反例 |
| [`1442`](1442/) | [PDF](1442/ARGUS_RESULT_1442_TECHNICAL_REPORT.pdf) | Teschner 束缚数猜想的 18 顶点三次二部图反例（$b(G)=5>9/2$） | 图论与控制集 | 已独立验证反例 |
| [`3117`](3117/) | [PDF](3117/ARGUS_RESULT_3117_TECHNICAL_REPORT.pdf) | 图分数幂着色猜想反例 $(C_3\mathbin{\square} K_2)^{3/5}$（$\chi=6>5=\omega$） | 图着色与分数图论 | 已独立验证反例 |
| [`7000029`](7000029/) | [PDF](7000029/ARGUS_RESULT_7000029_TECHNICAL_REPORT.pdf) | $C^\infty$ 光滑曲面 Loewner 与 Carathéodory 脐点指标猜想反例（指标 $3/2>1$） | 微分几何与叶状结构 | 已独立验证 Lean 4 形式化成果 |
| [`1900`](1900/) | [PDF](1900/ARGUS_RESULT_1900_TECHNICAL_REPORT.pdf) | Erdős 问题 #43（不相交差集 Sidon 集）两分支的同时反驳 | 加性组合 | 已独立验证 Lean 4.27 形式化成果 |
| [`2141`](2141/) | [PDF](2141/ARGUS_RESULT_2141_TECHNICAL_REPORT.pdf) | 一般同余筛剩余集不存在对数密度的反例（$\liminf\le 177/200<49/50\le\limsup$，Erdős #486） | 解析与组合数论 | 已独立验证 Lean 4 形式化成果 |
| [`2215`](2215/) | [PDF](2215/ARGUS_RESULT_2215_TECHNICAL_REPORT.pdf) | 无三角形图直径 4 补边线性节省猜想的反驳（$h_4(G)\ge(1-\eta)n$，Erdős #619） | 极值图论 | 已独立验证 Lean 4 形式化成果 |
| [`20001068`](20001068/) | [PDF](20001068/ARGUS_RESULT_20001068_TECHNICAL_REPORT.pdf) | AIM Conjecture 6.23 字面弱不等式版本的 26 顶点、74 弧有向图反例 | 加权有向图 | 已独立验证反例 |
| [`20000282`](20000282/) | [PDF](20000282/ARGUS_RESULT_20000282_TECHNICAL_REPORT.pdf) | 约化非等维环 $k[a,b,c,d]/(ab,acd)$ 上 Hilbert–Kunz 重数上半连续性反例 | 交换代数 | 已独立验证反例（AIM 1.5） |
| [`20001352`](20001352/) | [PDF](20001352/ARGUS_RESULT_20001352_TECHNICAL_REPORT.pdf) | Thompson 群 $F$ 的换位子宽度与对合分解字面范围反例 | 几何群论 | 已独立验证范围修正（AIMPL 3.1） |
| [`20001602`](20001602/) | [PDF](20001602/ARGUS_RESULT_20001602_TECHNICAL_REPORT.pdf) | 分支群可公度子群定理缺失 just-infinite 假设及 Hanoi 群 $(G,G'')$ 反例 | 群论与分支群 | 已独立验证字面范围反例 |
| [`20001760`](20001760/) | [PDF](20001760/ARGUS_RESULT_20001760_TECHNICAL_REPORT.pdf) | 秩一格 $L=\mathbb{Z}$ 反驳不限维数的“所有壳层不可能均为 12-design”字面命题 | 格与球面设计 | 已独立验证字面范围反例 |
| [`4600048`](4600048/) | [PDF](4600048/ARGUS_RESULT_4600048_TECHNICAL_REPORT.pdf) | 四次 Salem $\beta$-变换的无理不动点 $x=1/(\beta-1)$ | 动力系统与代数数论 | 已独立验证目录表述修正 |
| [`20001382`](20001382/) | [PDF](20001382/ARGUS_RESULT_20001382_TECHNICAL_REPORT.pdf) | 逆树状 Galois 问题字面表述中的非闭子群拓扑障碍 | 算术动力系统 | 已独立验证范围修正 |
| [`20001274`](20001274/) | [PDF](20001274/ARGUS_RESULT_20001274_TECHNICAL_REPORT.pdf) | 全体平面投影合同不决定凸体（$\varepsilon=1/1000$ 双球冠显式有理复算） | 凸几何与离散几何 | 已独立验证精确复算 |
| [`20001516`](20001516/) | [PDF](20001516/ARGUS_RESULT_20001516_TECHNICAL_REPORT.pdf) | $\mathrm{CAT}(0)$ 自由-by-循环群 $F_2\rtimes_\phi\mathbb{Z}$ 不满足普通 RFRS | 几何群论与低维拓扑 | 已独立验证文献重建（AIM 5.3） |
| [`20001862`](20001862/) | [PDF](20001862/ARGUS_RESULT_20001862_TECHNICAL_REPORT.pdf) | 标准伪三角剖分路线的 8 顶点半周旋转对称障碍 | 计算几何与刚性理论 | 已独立验证显式重建 |
| [`3206`](3206/) | [PDF](3206/ARGUS_RESULT_3206_TECHNICAL_REPORT.pdf) | 图核为 $C_5$ 的 $\mathbb{Z}_{15}$ Cayley 图 | 代数图论 | 已独立验证文献重建 |
| [`1100501`](1100501/) | [PDF](1100501/ARGUS_RESULT_1100501_TECHNICAL_REPORT.pdf) | 完整轴集相同不蕴含环境群可公度 | Kleinian 群与双曲几何 | 已独立验证文献重建 |
| [`20000916`](20000916/) | [PDF](20000916/ARGUS_RESULT_20000916_TECHNICAL_REPORT.pdf) | 任意范数 Steinitz $O(\sqrt{d})$ 表述的 $\ell_1^d$ 线性下界 $(d+1)/2$ 障碍 | 凸几何与向量平衡 | 已独立验证文献重建 |
| [`20000320`](20000320/) | [PDF](20000320/ARGUS_RESULT_20000320_TECHNICAL_REPORT.pdf) | 弱 $\mathbb{Q}$-Gorenstein 条件在 $\mathrm{Spec}(k[t]/(t^2))$ 上不能保证多重典范层基变换 | 代数几何 | 已独立验证来源重建 |
| [`1350`](1350/) | [PDF](1350/ARGUS_RESULT_1350_TECHNICAL_REPORT.pdf) | 相对一致性下 GCH 不蕴含存在 $\aleph_2$-Suslin 树 | 集合论 | 已独立验证相对一致性反模型 |
| [`1200029`](1200029/) | [PDF](1200029/ARGUS_RESULT_1200029_TECHNICAL_REPORT.pdf) | 无限 Cayley 图的死端在闭球约定下可具有正渐近密度（$\ge 1/64$） | 几何群论 | 已独立验证文献反例 |
| [`1100101`](1100101/) | [PDF](1100101/ARGUS_RESULT_1100101_TECHNICAL_REPORT.pdf) | 无 Baumslag–Solitar 子群的有限四维 $K(G,1)$ 群可以非双曲 | 几何群论 | 已独立验证文献反例 |
| [`20000255`](20000255/) | [PDF](20000255/ARGUS_RESULT_20000255_TECHNICAL_REPORT.pdf) | 正特征终端三维奇点不必是 Cohen–Macaulay | 双有理与代数几何 | 原始文献反驳核验（Totaro 2019） |
| [`20000256`](20000256/) | [PDF](20000256/ARGUS_RESULT_20000256_TECHNICAL_REPORT.pdf) | 特征 2 三维 $\mathbb{Q}$-factorial plt 对的非正规素除子中心 | 正特征双有理几何 | 原始文献反驳核验（Cascini–Tanaka） |
| [`20000332`](20000332/) | [PDF](20000332/ARGUS_RESULT_20000332_TECHNICAL_REPORT.pdf) | Chow 半稳定多典范极限的不稳定性 | 代数几何与模空间 | 原始文献反驳核验（Wang–Xu 2014） |
| [`20000472`](20000472/) | [PDF](20000472/ARGUS_RESULT_20000472_TECHNICAL_REPORT.pdf) | Fock 空间有界 Toeplitz 算子在 $t=1/4$ 处热变换无界 | 算子理论与调和分析 | 原始文献反驳核验（Looi 2022） |

---

### 四、符号计算、代数归约与多面体边界证书（19 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`20000496`](20000496/) | [PDF](20000496/ARGUS_RESULT_20000496_TECHNICAL_REPORT.pdf) | 高维光滑中心对称凸域的内部热斑 | 谱几何与偏微分方程 | 原始文献反驳核验（de Dios Pont 2024） |
| [`20000731`](20000731/) | [PDF](20000731/ARGUS_RESULT_20000731_TECHNICAL_REPORT.pdf) | Nahm 猜想 4.1 的 $q$-超几何模函数反例 | 模形式与代数 $K$-理论 | 原始文献反驳核验（Vlasenko–Zwegers） |
| [`20000778`](20000778/) | [PDF](20000778/ARGUS_RESULT_20000778_TECHNICAL_REPORT.pdf) | $\mathbb{P}^2_{\mathbb{C}}$ 吹起 10 个一般点上的普适幻影范畴 | 代数几何与导出范畴 | 原始文献反驳核验（Krah 2024） |
| [`1380`](1380/) | [PDF](1380/ARGUS_RESULT_1380_TECHNICAL_REPORT.pdf) | 八点 Heilbronn 三角形问题平衡 $(2,2,2,2)$ 构型空间的 175 叶精确有理符号胞腔排除 | 离散几何 | 已独立验证有理胞腔排除证书 |
| [`1413`](1413/) | [PDF](1413/ARGUS_RESULT_1413_TECHNICAL_REPORT.pdf) | 57 度 Moore 图搜索中的 3,192 顶点、7,448 边围长 5 匹配前缀证书 | 代数图论 | 已独立验证前缀证书 |
| [`1900020`](1900020/) | [PDF](1900020/ARGUS_RESULT_1900020_TECHNICAL_REPORT.pdf) | $D=229$ 三次 Jacobi–Perron 轨道截面返回对正定对角二次型的严格收缩障碍 | 数论与动力系统 | 已独立验证单调能量障碍 |
| [`1921`](1921/) | [PDF](1921/ARGUS_RESULT_1921_TECHNICAL_REPORT.pdf) | Erdős 问题 #87 中有界偏移签名着色文法的一致最大度上界排除 | Ramsey 理论 | 已独立验证构造文法排除 |
| [`1994`](1994/) | [PDF](1994/ARGUS_RESULT_1994_TECHNICAL_REPORT.pdf) | Erdős–Ulam 平面有理距离问题秩 4 抛物 $\lambda=27$ 分支的二次归约与标量张成障碍 | 离散与算术几何 | 已独立验证代数归约 |
| [`20000786`](20000786/) | [PDF](20000786/ARGUS_RESULT_20000786_TECHNICAL_REPORT.pdf) | 四次曲线族 $k=3$ 分支上的 Hasse–Witt 矩阵消没与三次标量相消引理 | 算术几何 | 已独立验证算术引理 |
| [`20001578`](20001578/) | [PDF](20001578/ARGUS_RESULT_20001578_TECHNICAL_REPORT.pdf) | Thompson 群 $F$ 中 18 元等式候选的右商重数上界（$8<15$）精确排除 | 几何群论 | 已独立验证家族排除 |
| [`20001904`](20001904/) | [PDF](20001904/ARGUS_RESULT_20001904_TECHNICAL_REPORT.pdf) | 无共轭点流形四次 Hermite 曲率修补的六点正有理权重 Farkas 障碍 | 黎曼几何 | 已独立验证 Farkas 障碍 |
| [`2248`](2248/) | [PDF](2248/ARGUS_RESULT_2248_TECHNICAL_REPORT.pdf) | 二次素数表示 $n=ap^2+b$（Erdős #676）的 Baier–Zhao 色散尺度屏障 | 解析数论 | 已独立验证解析尺度障碍 |
| [`2305027`](2305027/) | [PDF](2305027/ARGUS_RESULT_2305027_TECHNICAL_REPORT.pdf) | 平面域 Corona 问题导数耦合修正族的有符号 Cauchy–Green 通量恒等式与 $\ge N/400{,}000$ 下界 | 复分析与调和分析 | 已独立验证解析残差下界 |
| [`2662`](2662/) | [PDF](2662/ARGUS_RESULT_2662_TECHNICAL_REPORT.pdf) | Kirby 问题 1.3 双变交叉局部 plat 突变族的 Reidemeister-II 坍缩排除 | 纽结理论 | 已独立验证局部突变族排除 |
| [`2669`](2669/) | [PDF](2669/ARGUS_RESULT_2669_TECHNICAL_REPORT.pdf) | 广义 Property R 猜想分阶段标架二分量链环的 handle-slide 平凡链环轨道归约 | 低维拓扑 | 已独立验证拓扑轨道归约 |
| [`2775`](2775/) | [PDF](2775/ARGUS_RESULT_2775_TECHNICAL_REPORT.pdf) | 辫群到直角 Artin 群投影中 $(A_{12},1,A_{12})$ 纤维的完整解分类 $u\alpha(v)=vu$ | 辫群与几何群论 | 已独立验证完整纤维分类 |
| [`2862`](2862/) | [PDF](2862/ARGUS_RESULT_2862_TECHNICAL_REPORT.pdf) | 单角球面 bar 闭链的共正规化子正交联接归约与 Chern–Simons 体积有理性（Kirby 3.64） | 低维拓扑与代数 $K$-理论 | 已独立验证有理性归约 |
| [`8`](8/) | [PDF](8/ARGUS_RESULT_8_TECHNICAL_REPORT.pdf) | 奇完全数 minimal-101 root-4 分支经 $6{,}756{,}355$ 个前缀归约到单一因子 $\Phi_{31}(269)=\sigma(269^{30})$ | 初等与计算数论 | 已独立验证因子链归约 |
| [`8200002`](8200002/) | [PDF](8200002/ARGUS_RESULT_8200002_TECHNICAL_REPORT.pdf) | 六维互无偏基系统第三 Fourier 纤维的 39 维 Arb Krawczyk 区间牛顿认证 | 量子信息与代数几何 | 已独立验证区间包含证书 |

---

## 一键重放与独立验证（Reproducibility）

建议使用 Python 3.10 或更高版本：

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py

# 核心代表作独立复算脚本示例：
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

## 版权与署名声明

> **版权所有 © 2026 Argus AI Team，保留全部权利。**
>
> 公开展示不等于放弃版权或转移作者身份。欢迎准确链接与学术规范引用；详细条款见 [LICENSE](../LICENSE) 与 [CITATION.cff](../CITATION.cff)。
