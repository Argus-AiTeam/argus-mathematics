# Complete Usage & Billed Cost Audit (All 84 Result Packages)

This document records the complete, ground-truth compute and billing audit reconstructed from all **150 `usage.jsonl` and `events.jsonl` ledgers** across the Argus Mathematics program (August–November 2026). Machine-readable data is archived in [`open-problems/usage-audit.json`](../usage-audit.json) and embedded per result in [`open-problems/results.json`](../results.json).

## Program-Wide Summary (`$0.04` / Copilot Premium Request)

| Metric | Value |
|---|---:|
| **Total Published Result Packages** | **84** (`53` dedicated campaigns + `31` shared batch-audit packages) |
| **Total `usage.jsonl` Ledgers Audited** | **150** |
| **Total Model Calls** | **8,877** |
| **Total Billed Premium Requests** | **8,821.0** |
| **Total Tokens Processed** | **7,613,247,348** (**7.613B tokens**) |
| **Dedicated 53 Campaigns Total Billed Cost** | **`$320.20`** (avg **`$6.04`** / campaign) |
| **Nov 2026 20-Theorem Run Billed Cost** | **`$71.68`** (avg **`$3.58`** / theorem) |
| **Shared Audit Shards Total Billed Cost (31 Packages)** | **`$32.64`** (avg **`$1.05`** / package) |
| **Grand Total Program Billed Cost (All 84 Results)** | **`$352.84`** (avg **`$4.20`** / result package) |

---

## Part I. All 53 Dedicated Problem Campaigns (Sorted by Billed Cost)

| ID | Result Title | Field | Models | Runs | Calls | Prem. Req. | Tokens | Nov 2026 Run | Total Billed Cost (`$0.04`/req) |
|---|---|---|---|---:|---:|---:|---:|---:|---:|
| [`11000263`](../11000263/) | Twist-compatible Burau quotient and universal finite-dimensionality for Bigelow's zipper algebra | braid groups and algebra | `gpt-5.6-sol` | 1 | 6 | 6.0 | 6.48M | — | **`$0.24`** |
| [`2813`](../2813/) | An explicit taut-foliation Euler-class obstruction on a hyperbolic mapping torus | low-dimensional topology, foliations, and dynamical systems | `gpt-5.6-sol` | 1 | 10 | 10.0 | 1.77M | — | **`$0.40`** |
| [`1275`](../1275/) | Essential-Spectrum Obstruction for Finite-Shift Dilation Restrictions in Hilbert-Polya Realizations | spectral theory and analytic number theory | `gpt-6-astra` | 1 | 16 | 16.0 | 7.93M | $0.64 | **`$0.64`** |
| [`2457`](../2457/) | Countermodel to the Arvidsson heat-trace bounded-kernel implication (Erdos Problem #1055) | spectral theory and analytic number theory | `gpt-5.6-sol` | 1 | 20 | 23.0 | 0.00M | — | **`$0.92`** |
| [`2662`](../2662/) | Reidemeister-II collapse of two-change local plat families for unknotting and Conway mutation (Kirby 1.3) | knot theory | `gpt-5.6-sol, gpt-6-astra` | 1 | 23 | 23.0 | 9.62M | — | **`$0.92`** |
| [`2775`](../2775/) | Complete solution classification of the (A_12, 1, A_12) projection fiber for braid and right-angled Artin groups | geometric group theory and braid groups | `gpt-5.6-sol, gpt-6-astra` | 1 | 25 | 25.0 | 44.79M | — | **`$1.00`** |
| [`2307015`](../2307015/) | A translated-cusp boundary set of positive harmonic measure | complex analysis, potential theory, and harmonic measure | `gpt-5.6-sol` | 1 | 26 | 26.0 | 22.34M | — | **`$1.04`** |
| [`1921`](../1921/) | Uniform degree bounds excluding bounded offset-signature colorings for Erdos Problem #87 | Ramsey theory | `gpt-5.6-sol` | 1 | 27 | 27.0 | 0.67M | — | **`$1.08`** |
| [`40`](../40/) | Conformal Transfer and Curvature-Response Closure for Axisymmetric Euler Flows in Periodic Variable-Radius Pipes | partial differential equations and fluid dynamics | `gpt-6-astra` | 1 | 34 | 34.0 | 40.98M | $1.36 | **`$1.36`** |
| [`3102`](../3102/) | The Support-At-Most-Five Pebbling Number of the Lemke Square Is 64 | graph theory and combinatorial optimization | `gpt-6.1-sol` | 2 | 36 | 36.0 | 22.80M | $1.44 | **`$1.44`** |
| [`7200051`](../7200051/) | Quantitative Distortion Bounds and Formal Equilateral Exclusion for Eleven Points in Five-Dimensional l_1 | discrete and metric geometry | `gpt-6.1-sol` | 1 | 44 | 44.0 | 24.19M | $1.76 | **`$1.76`** |
| [`2800203`](../2800203/) | Threshold discrepancy barriers for depth-three scalar planted-clique AMP schedules | high-dimensional probability and statistical inference | `gpt-5.6-sol, gpt-6-astra` | 1 | 49 | 49.0 | 79.04M | — | **`$1.96`** |
| [`1994`](../1994/) | Bottom-row quadratic reduction and scalar-span obstruction on rank-four parabolic Erdos-Ulam configurations | discrete and arithmetic geometry | `gpt-5.6-sol, gpt-6-astra` | 1 | 49 | 50.0 | 12.14M | — | **`$2.00`** |
| [`3167`](../3167/) | Sheehan's Conjecture for Four-Regular Simple Graphs of Bounded Treewidth | structural graph theory | `gpt-6.1-sol` | 5 | 54 | 54.0 | 42.76M | $2.16 | **`$2.16`** |
| [`20001352`](../20001352/) | Literal-scope counterexample for commutator width and involution factorization in Thompson's group F (AIMPL Problem 3.1) | geometric group theory | `gpt-5.6-sol, gpt-6-astra` | 3 | 60 | 57.0 | 4.31M | — | **`$2.28`** |
| [`2884`](../2884/) | K3 Problem 4.8: arbitrary-X stabilization counterexample and fixed-E(2) PL/smooth seven-arrow construction | smooth 4-manifolds and knot surgery | `gpt-5.6-sol` | 1 | 60 | 60.0 | 100.90M | — | **`$2.40`** |
| [`20000278`](../20000278/) | An irrational non-Q-Gorenstein F-jumping number in characteristic 13 (AIM Problem 1.3) | commutative algebra and positive-characteristic singularity theory | `gpt-6-astra` | 2 | 62 | 61.0 | 22.53M | — | **`$2.44`** |
| [`20001602`](../20001602/) | Commensurated subgroups of branch groups: missing just-infinite hypothesis and Hanoi group counterexample | group theory and branch groups | `gpt-6-astra` | 3 | 62 | 62.0 | 14.58M | — | **`$2.48`** |
| [`20001849`](../20001849/) | Flying wings refute uniqueness of the collapsed product steady Ricci soliton (AIMPL Problem 6.7) | differential geometry and Ricci flow | `gpt-5.6-sol, gpt-6-astra` | 3 | 65 | 63.0 | 11.20M | — | **`$2.52`** |
| [`20001516`](../20001516/) | A CAT(0) free-by-cyclic group that is not ordinary RFRS (AIM Problem 5.3) | geometric group theory and low-dimensional topology | `gpt-6-astra` | 1 | 67 | 66.0 | 14.84M | — | **`$2.64`** |
| [`2669`](../2669/) | Handle-slide unlink orbit reduction on staged-framing two-component link presentations (Property R) | low-dimensional topology | `gpt-5.6-sol, gpt-6-astra` | 1 | 69 | 66.0 | 24.52M | — | **`$2.64`** |
| [`1900020`](../1900020/) | Diagonal quadratic energy contraction on section returns of the cubic Jacobi-Perron algorithm | number theory and dynamical systems | `gpt-5.6-sol, gpt-6-astra` | 1 | 71 | 71.0 | 85.89M | — | **`$2.84`** |
| [`3256`](../3256/) | Weighted Dijoin Packing in One-Edge Deletions of Chordal Digraphs | combinatorial optimization and directed graphs | `gpt-6.1-sol` | 1 | 72 | 72.0 | 52.53M | $2.88 | **`$2.88`** |
| [`1417`](../1417/) | A Uniform Square-Root Edge-Deficit Bound for Strongly Critical Graphs Avoiding Four- and Eight-Cycles | extremal and structural graph theory | `gpt-6-astra, gpt-6.1-sol` | 2 | 76 | 73.0 | 30.62M | $1.36 | **`$2.92`** |
| [`2862`](../2862/) | Co-normalizer orthogonal join reduction and rational Chern-Simons volume on one-angle spherical bar cycles | low-dimensional topology and algebraic K-theory | `gpt-5.6-sol, gpt-6-astra` | 1 | 73 | 73.0 | 12.43M | — | **`$2.92`** |
| [`1413`](../1413/) | Girth-five 77-matching prefix certificate in the search for a degree-57 Moore graph | algebraic graph theory | `gpt-5.6-sol` | 1 | 82 | 81.0 | 100.77M | — | **`$3.24`** |
| [`20001904`](../20001904/) | A six-point positive-weight obstruction to degree-four Hermite curvature repairs on manifolds without conjugate points | Riemannian geometry | `gpt-5.6-sol, gpt-6-astra` | 1 | 82 | 82.0 | 75.04M | — | **`$3.28`** |
| [`6800022`](../6800022/) | Complete Global Embeddedness Obstruction for the Reciprocal-Reflection Kato-Muroya Genus-One Four-Catenoidal-End Locus | differential geometry and minimal surfaces | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 2 | 88 | 88.0 | 102.65M | $1.16 | **`$3.52`** |
| [`20000786`](../20000786/) | Hasse-Witt matrix vanishing and cubic scalar cancellation on the k=3 quartic reduction branch | arithmetic geometry | `gpt-5.6-sol, gpt-6-astra` | 1 | 89 | 89.0 | 111.66M | — | **`$3.56`** |
| [`20001675`](../20001675/) | Arbitrary-Depth Exponential HOMFLY-PT Fibers over Quiver Point-Counting Polynomials of Plabic Links and Knots | algebraic combinatorics, cluster algebras, and knot polynomials | `gpt-6.1-sol` | 3 | 93 | 93.0 | 69.23M | $3.72 | **`$3.72`** |
| [`8`](../8/) | Reduction of the minimal-101 root-4 odd perfect number branch to the single factor Phi_31(269) | elementary and computational number theory | `gpt-5.6-sol, gpt-6-astra` | 1 | 96 | 96.0 | 15.01M | — | **`$3.84`** |
| [`1138`](../1138/) | Bielliptic Half-Fiber and Dyadic Picard-Torsion Obstructions on Enriques Surfaces | algebraic geometry and Hodge theory | `gpt-6-astra` | 1 | 97 | 97.0 | 97.44M | $3.88 | **`$3.88`** |
| [`20001274`](../20001274/) | Congruent plane projections do not determine a convex body up to translation or reflection | convex and discrete geometry | `gpt-6-astra` | 3 | 103 | 102.0 | 14.76M | — | **`$4.08`** |
| [`3059`](../3059/) | The Alon-Jaeger-Tarsi Conjecture in Dimensions Eight and Nine over F_5 | combinatorial algebra and finite fields | `gpt-6.1-sol` | 2 | 111 | 111.0 | 106.72M | $4.44 | **`$4.44`** |
| [`3395`](../3395/) | Centered Nuclear Duality and Relative-Mass Obstructions in Monotone Boolean Circuit Lower Bounds | computational complexity and circuit lower bounds | `gpt-6-astra` | 2 | 122 | 119.0 | 129.04M | $4.76 | **`$4.76`** |
| [`9400078`](../9400078/) | Unconditional Exceptional-Parameter Density Bounds for Ramified GL_4 Automorphic Representations | automorphic forms and analytic number theory | `gpt-6-astra` | 6 | 144 | 143.0 | 56.57M | $5.72 | **`$5.72`** |
| [`1380`](../1380/) | Exact rational sign-cell exclusion on the balanced (2,2,2,2) Heilbronn configuration space | discrete geometry | `gpt-5.6-sol, gpt-6-astra` | 1 | 145 | 144.0 | 121.94M | — | **`$5.76`** |
| [`20002392`](../20002392/) | Velocity-Only Exclusion of Backward Self-Similar Navier-Stokes Profiles in a Half-Space | partial differential equations and fluid mechanics | `gpt-6-astra` | 5 | 150 | 145.0 | 39.00M | $5.80 | **`$5.80`** |
| [`20000582`](../20000582/) | Moving-window Engel Hilbert cocycles with Omega(sqrt(k)) homogeneous gauge distortion | metric geometry and bi-Lipschitz embeddings | `gpt-5.6-sol, gpt-6-astra` | 1 | 152 | 152.0 | 437.17M | — | **`$6.08`** |
| [`1285`](../1285/) | An Unconditional Exponential Worst-Case Lower Bound for Adaptive Signed-Chain Elliptic Curve Factorization Programs | computational number theory and arithmetic complexity | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 3 | 157 | 155.0 | 93.52M | $1.24 | **`$6.20`** |
| [`2305027`](../2305027/) | A signed Cauchy-Green flux identity and linear residual lower bound on planar corona corrections | complex and harmonic analysis | `gpt-5.6-sol, gpt-6-astra` | 3 | 161 | 165.0 | 84.57M | — | **`$6.60`** |
| [`20001578`](../20001578/) | Exact quotient-multiplicity exclusion of 18-element equality candidates in Thompson's group F | geometric group theory | `gpt-5.6-sol, gpt-6-astra` | 1 | 182 | 182.0 | 272.80M | — | **`$7.28`** |
| [`2338`](../2338/) | Diophantine Obstructions, Degree-120 S-Unit Descent, and Affine Orthogonal Runge Theorems for Multiplicity Five in Pascal's Triangle | Diophantine equations and algebraic number theory | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 2 | 188 | 188.0 | 194.53M | $5.76 | **`$7.52`** |
| [`1243`](../1243/) | Unconditional Global Squareclasses, Genus-161 Rational-Point Classification, and Map Rigidity on Bremner's Octic K3 Surface | arithmetic geometry and Diophantine equations | `gpt-5.6-sol, gpt-6.1-sol` | 5 | 204 | 192.0 | 71.54M | $6.92 | **`$7.68`** |
| [`8200002`](../8200002/) | A 39-dimensional Arb Krawczyk interval certificate for the third Fourier fibre in dimension six | quantum information and algebraic geometry | `gpt-5.6-sol, gpt-6-astra` | 1 | 239 | 239.0 | 417.23M | — | **`$9.56`** |
| [`1187`](../1187/) | Global Nonexistence of Twisted Bridges in F_2-Magnus Quotients and Six-Conjugate Primitive Exclusion for Andrews-Curtis Candidates | combinatorial and geometric group theory | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 5 | 249 | 246.0 | 113.91M | $7.72 | **`$9.84`** |
| [`1518`](../1518/) | An Unconditional Sixth-Energy Saving for Riemann Zeta Zeros and a Local Prime-Window Exceptional-Pair Bound | analytic number theory | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 5 | 269 | 266.0 | 104.23M | $5.04 | **`$10.64`** |
| [`9400114`](../9400114/) | Target-Free Prime-Power Reduction, Short-Arc Cubic Obstructions, and Inverse-Frobenius Classifications for Agrawal's Conjecture | computational and algebraic number theory | `gpt-6-astra, gpt-6.1-sol, mai-code-1.1-flash` | 9 | 303 | 298.0 | 202.21M | $3.92 | **`$11.92`** |
| [`2248`](../2248/) | Baier-Zhao dispersion scale barriers for quadratic-prime representations n = a p^2 + b (Erdos #676) | analytic number theory | `gpt-5.6-sol, gpt-6-astra` | 1 | 309 | 311.0 | 500.20M | — | **`$12.44`** |
| [`20000715`](../20000715/) | Differential equations and linear-ODE obstructions for eta-products (AIM Problem 1.2) | modular forms and differential algebra | `gpt-5.6-luna, gpt-5.6-sol, gpt-6-astra` | 14 | 426 | 426.0 | 33.14M | — | **`$17.04`** |
| [`1465`](../1465/) | Fu 2026 Theorem 2.8: regularity-premise local-finiteness gap | model theory, o-minimal structures, and real analytic geometry | `gpt-5.6-sol, gpt-6-astra` | 1 | 777 | 778.0 | 1431.73M | — | **`$31.12`** |
| [`20001036`](../20001036/) | A 5,454-vertex multi-label counterexample to Seymour-Sullivan Conjecture 6.1 and prototype optimality | directed graphs, rainbow paths, and combinatorial optimization | `gpt-5.6-sol, gpt-6-astra` | 9 | 891 | 883.0 | 606.40M | — | **`$35.32`** |
| [`20000816`](../20000816/) | Distinct Hilbert-scheme components sharing a complete unlabelled Grobner fan (AIM Problem 15 / 1.35) | algebraic geometry and computational commutative algebra | `gpt-5.6-sol, gpt-6-astra` | 17 | 995 | 987.0 | 77.31M | — | **`$39.48`** |
| **Subtotal (53 Campaigns)** | — | — | — | — | **8,060** | **8,005.0** | **6,370.17M** | **`$71.68`** | **`$320.20`** |

---

## Part II. Shared Batch-Audit & Counterexample-Screening Pools (31 Published Result Packages)

The remaining **31 published result packages** (Batch 001 counterexamples, Lean 4 formal refutations, and source-audited resolutions across the 757-problem catalog) were produced by the shared audit-shard and screening pools below, at an amortized cost of **`$1.05` per published package**:

| Pool ID | Run Dirs | Calls | Prem. Req. | Tokens | Models | Total Billed Cost (`$0.04`/req) |
|---|---:|---:|---:|---:|---|---:|
| `audit-shard-02-retry2` | 1 | 632 | 635.0 | 1083.24M | `gpt-5.6-sol, gpt-6-astra` | **`$25.40`** |
| `audit-shard-01-run3` | 1 | 127 | 123.0 | 131.88M | `gpt-5.6-sol` | **`$4.92`** |
| `batch-001-counterexample-screening` | 1 | 35 | 35.0 | 21.48M | `gpt-5.5, gpt-5.6-sol` | **`$1.40`** |
| `open-conjectures-audit` | 1 | 21 | 21.0 | 6.48M | `gpt-5.6-sol` | **`$0.84`** |
| `argus-latest` | 1 | 1 | 1.0 | 0.00M | `gpt-5.6-sol` | **`$0.04`** |
| `counterexample-batch-1` | 1 | 1 | 1.0 | 0.00M | `gpt-5.6-sol` | **`$0.04`** |
| **Subtotal (31 Packages)** | **6** | **817** | **816.0** | **1,243.07M** | — | **`$32.64`** (`$1.05` / package) |

**31 Result Packages Produced by the Shared Audit & Screening Pools:**
[`1100101`](../1100101/), [`1100501`](../1100501/), [`1200029`](../1200029/), [`1350`](../1350/), [`1442`](../1442/), [`1900`](../1900/), [`20000255`](../20000255/), [`20000256`](../20000256/), [`20000282`](../20000282/), [`20000320`](../20000320/), [`20000332`](../20000332/), [`20000443`](../20000443/), [`20000472`](../20000472/), [`20000496`](../20000496/), [`20000731`](../20000731/), [`20000778`](../20000778/), [`20000916`](../20000916/), [`20001068`](../20001068/), [`20001159`](../20001159/), [`20001224`](../20001224/), [`20001382`](../20001382/), [`20001760`](../20001760/), [`20001836`](../20001836/), [`20001862`](../20001862/), [`2141`](../2141/), [`2215`](../2215/), [`3110`](../3110/), [`3117`](../3117/), [`3206`](../3206/), [`4600048`](../4600048/), [`7000029`](../7000029/)
