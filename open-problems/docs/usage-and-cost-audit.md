# Compute Cost of the 84 Result Packages

As of 2026-11-09. Machine-readable data: [`../usage-audit.json`](../usage-audit.json).

## Method

Provider token-meter dollar equivalents: total_nano_aiu / 1e11 (1 AI credit = $0.01) for every usage event, from the campaign usage.jsonl ledgers (model_usage records) united with each campaign's own session-store.db, deduplicated by (session_id, usage_event_id). Cache reads/writes are inside input tokens and reasoning inside output tokens. Calls whose records carry no token detail are not priced, so totals are lower bounds. These are metered amounts, not reconciled invoices.

## Summary

| | Packages | Tokens | Cost |
|---|---:|---:|---:|
| Dedicated campaigns | 53 | 10,370,949,034 | $13,211.56 |
| Shared audit and screening pools | 31 | 1,767,023,261 | $1,202.86 |
| **Total** | **84** | **12,137,972,295** | **$14,414.42** |

Calls without token detail (not priced): 963.

The 31 shared-pool packages came out of batch audit runs. Their cost cannot be attributed to individual packages, so it is given per pool.

## Dedicated campaigns

| ID | Result package | Runs | Tokens | Cost (token-metered) |
|---|---|---:|---:|---:|
| [`20001036`](../20001036/) | A 5,454-vertex multi-label counterexample to Seymour-Sullivan Conjecture 6.1 and prototype optimality | 9 | 693.6M | $1,783.00 |
| [`3395`](../3395/) | Centered Nuclear Duality, Addition-Aware Pinning, and Relative-Mass Obstructions in Monotone Boolean Circuit Lower Bounds | 2 | 515.9M | $1,469.29 |
| [`1465`](../1465/) | Fu 2026 Theorem 2.8: regularity-premise local-finiteness gap | 1 | 1,730.8M | $1,295.35 |
| [`20000816`](../20000816/) | Distinct Hilbert-scheme components sharing a complete unlabelled Grobner fan (AIM Problem 15 / 1.35) | 17 | 292.4M | $1,064.44 |
| [`2248`](../2248/) | Baier-Zhao dispersion scale barriers for quadratic-prime representations n = a p^2 + b (Erdos #676) | 1 | 601.6M | $674.48 |
| [`20000582`](../20000582/) | Moving-window Engel Hilbert cocycles with Omega(sqrt(k)) homogeneous gauge distortion | 1 | 557.8M | $606.57 |
| [`8200002`](../8200002/) | A 39-dimensional Arb Krawczyk interval certificate for the third Fourier fibre in dimension six | 1 | 711.9M | $603.19 |
| [`20001578`](../20001578/) | Exact quotient-multiplicity exclusion of 18-element equality candidates in Thompson's group F | 1 | 443.5M | $489.84 |
| [`1138`](../1138/) | Universal Isotropy and Genus-Proportional Integral Hodge Defects on Dyadic Enriques Products | 1 | 142.0M | $431.99 |
| [`1380`](../1380/) | Exact rational sign-cell exclusion on the balanced (../2,2,2,2) Heilbronn configuration space | 1 | 270.7M | $325.93 |
| [`9400114`](../9400114/) | Target-Free Prime-Power Reduction, Short-Arc Cubic Obstructions, and Inverse-Frobenius Classifications for Agrawal's Conjecture | 9 | 182.1M | $295.98 |
| [`20000715`](../20000715/) | Differential equations and linear-ODE obstructions for eta-products (AIM Problem 1.2) | 14 | 92.9M | $288.56 |
| [`2305027`](../2305027/) | A signed Cauchy-Green flux identity and linear residual lower bound on planar corona corrections | 4 | 141.9M | $266.22 |
| [`1518`](../1518/) | An Unconditional Sixth-Energy Saving for Riemann Zeta Zeros and a Local Prime-Window Exceptional-Pair Bound | 5 | 354.6M | $242.43 |
| [`2338`](../2338/) | Diophantine Obstructions, Affine Orthogonal Runge Theorems, and Degree-512 Extraspecial Covers for Multiplicity Five in Pascal's Triangle | 6 | 287.3M | $238.35 |
| [`9400078`](../9400078/) | Unconditional Exceptional-Parameter Density Bounds for Ramified GL_4 Automorphic Representations | 6 | 77.5M | $232.25 |
| [`20000786`](../20000786/) | Hasse-Witt matrix vanishing and cubic scalar cancellation on the k=3 quartic reduction branch | 1 | 254.1M | $213.57 |
| [`1187`](../1187/) | Global Nonexistence of Twisted Bridges in F_2-Magnus Quotients and Six-Conjugate Primitive Exclusion for Andrews-Curtis Candidates | 5 | 197.3M | $200.89 |
| [`1900020`](../1900020/) | Diagonal quadratic energy contraction on section returns of the cubic Jacobi-Perron algorithm | 1 | 96.9M | $180.14 |
| [`3256`](../3256/) | Weighted Dijoin Packing in One-Edge Deletions of Chordal Digraphs and Six-Terminal Single-Defect Digraphs | 4 | 323.0M | $165.54 |
| [`1285`](../1285/) | An Unconditional Exponential Worst-Case Lower Bound for Adaptive Signed-Chain Elliptic Curve Factorization Programs | 3 | 123.0M | $155.40 |
| [`2669`](../2669/) | Handle-slide unlink orbit reduction on staged-framing two-component link presentations (Property R) | 1 | 94.7M | $152.13 |
| [`20002392`](../20002392/) | Velocity-Only Exclusion of Backward Self-Similar Navier-Stokes Profiles in a Half-Space | 5 | 51.0M | $150.15 |
| [`40`](../40/) | Conformal Transfer and Curvature-Response Closure for Axisymmetric Euler Flows in Periodic Variable-Radius Pipes | 1 | 44.7M | $131.45 |
| [`3167`](../3167/) | Sheehan's Conjecture for Four-Regular Simple Graphs of Treewidth at Most Five | 7 | 275.5M | $124.34 |
| [`1994`](../1994/) | Bottom-row quadratic reduction and scalar-span obstruction on rank-four parabolic Erdos-Ulam configurations | 1 | 137.0M | $121.95 |
| [`8`](../8/) | Reduction of the minimal-101 root-4 odd perfect number branch to the single factor Phi_31(../269) | 1 | 163.4M | $105.00 |
| [`20000278`](../20000278/) | An irrational non-Q-Gorenstein F-jumping number in characteristic 13 (AIM Problem 1.3) | 2 | 29.5M | $96.33 |
| [`20001274`](../20001274/) | Congruent plane projections do not determine a convex body up to translation or reflection | 3 | 25.6M | $84.24 |
| [`20001516`](../20001516/) | A CAT(../0) free-by-cyclic group that is not ordinary RFRS (AIM Problem 5.3) | 1 | 27.2M | $80.40 |
| [`6800022`](../6800022/) | Complete Global Embeddedness Obstruction for the Reciprocal-Reflection Kato-Muroya Genus-One Four-Catenoidal-End Locus | 2 | 151.5M | $78.20 |
| [`2884`](../2884/) | K3 Problem 4.8: arbitrary-X stabilization counterexample and fixed-E(../2) PL/smooth seven-arrow construction | 1 | 219.3M | $76.02 |
| [`20001602`](../20001602/) | Commensurated subgroups of branch groups: missing just-infinite hypothesis and Hanoi group counterexample | 3 | 22.4M | $70.08 |
| [`20001849`](../20001849/) | Flying wings refute uniqueness of the collapsed product steady Ricci soliton (AIMPL Problem 6.7) | 3 | 19.0M | $63.41 |
| [`1413`](../1413/) | Girth-five 77-matching prefix certificate in the search for a degree-57 Moore graph | 1 | 140.4M | $61.23 |
| [`2800203`](../2800203/) | Threshold discrepancy barriers for depth-three scalar planted-clique AMP schedules | 1 | 99.3M | $59.06 |
| [`3059`](../3059/) | The Alon-Jaeger-Tarsi Conjecture in Dimensions Eight and Nine over F_5 | 3 | 111.6M | $54.38 |
| [`20001904`](../20001904/) | A six-point positive-weight obstruction to degree-four Hermite curvature repairs on manifolds without conjugate points | 1 | 84.1M | $53.52 |
| [`1417`](../1417/) | A Uniform Square-Root Edge-Deficit Bound for Strongly Critical Graphs Avoiding Four- and Eight-Cycles | 3 | 44.5M | $52.37 |
| [`2862`](../2862/) | Co-normalizer orthogonal join reduction and rational Chern-Simons volume on one-angle spherical bar cycles | 1 | 20.2M | $51.83 |
| [`1243`](../1243/) | Unconditional Global Squareclasses, Genus-161 Rational-Point Classification, and Map Rigidity on Bremner's Octic K3 Surface | 6 | 100.0M | $50.04 |
| [`2775`](../2775/) | Complete solution classification of the (A_12, 1, A_12) projection fiber for braid and right-angled Artin groups | 1 | 108.4M | $43.55 |
| [`2307015`](../2307015/) | A translated-cusp boundary set of positive harmonic measure | 1 | 94.6M | $38.23 |
| [`20001352`](../20001352/) | Literal-scope counterexample for commutator width and involution factorization in Thompson's group F (AIMPL Problem 3.1) | 3 | 10.3M | $37.67 |
| [`1275`](../1275/) | Essential-Spectrum Obstruction for Finite-Shift Dilation Restrictions in Hilbert-Polya Realizations | 1 | 9.5M | $33.09 |
| [`20001675`](../20001675/) | Arbitrary-Depth Exponential HOMFLY-PT Fibers over Quiver Point-Counting Polynomials of Plabic Links and Knots | 4 | 60.0M | $30.81 |
| [`2457`](../2457/) | Countermodel to the Arvidsson heat-trace bounded-kernel implication (Erdos Problem #1055) | 1 | 23.6M | $23.85 |
| [`2662`](../2662/) | Reidemeister-II collapse of two-change local plat families for unknotting and Conway mutation (Kirby 1.3) | 1 | 41.4M | $20.78 |
| [`7200051`](../7200051/) | Quantitative Distortion Bounds and Formal Equilateral Exclusion for Eleven Points in Five-Dimensional l_1 | 2 | 28.3M | $13.52 |
| [`3102`](../3102/) | The Support-At-Most-Five Pebbling Number of the Lemke Square Is 64 | 3 | 26.1M | $11.66 |
| [`1921`](../1921/) | Uniform degree bounds excluding bounded offset-signature colorings for Erdos Problem #87 | 1 | 7.8M | $8.90 |
| [`11000263`](../11000263/) | Twist-compatible Burau quotient and universal finite-dimensionality for Bigelow's zipper algebra | 1 | 6.8M | $7.24 |
| [`2813`](../2813/) | An explicit taut-foliation Euler-class obstruction on a hyperbolic mapping torus | 1 | 2.6M | $2.72 |

## Shared pools

| Shared pool | Tokens | Cost |
|---|---:|---:|
| `argus-audit-shard-02-retry2` | 1,608.3M | $1,119.47 |
| `argus-audit-shard-01-run3` | 147.8M | $76.30 |
| `argus-open-audit` | 10.9M | $7.09 |
| `argus-counterexamples` | — | not metered (35 calls without token detail) |
| `argus-audit-shard-01-run2` | — | no usage records |
