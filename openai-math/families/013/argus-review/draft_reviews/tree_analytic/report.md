# Tree comparison: analytic proof, explicit constant, and cycle criterion

## Assessment

**Supported as a human-checked finite mathematical proof in the stated scope.**
The old draft's density, affine, fourth-moment, majorant, and projection
arguments give both the manuscript comparison and the stated bound
`16^r (epsilon + q^(-1/4))`. The proof uses a cycle in the first diagram's
component--quartet multigraph, not the numerical component bound after the
cycle has been found. Thus the stated cycle-criterion extension is also
supported. No false manuscript assertion or counterexample follows.

This is a reproduction of the supplied manuscript's local analytic argument,
with an explicit, deliberately loose constant and an explicit extraction of
a criterion already used in that argument. It is not a new proof of
Ostmann's conjecture, a machine verification of the analysis, or a novelty
claim. Native independent-Reviewer acceptance remains pending.

## Source, versions, and attribution

The draft is the read-only old workspace's
`research/tree_comparison/report.md`, principally "An explicit-constant
verification theorem" and sections 1--6. The source is OpenAI,
*The additive indecomposability of the primes*, September 24, 2026,
revision `4eaee87548250b2682affda7d05d947c05554bae`, as fixed by the
supplied `9100013/MANUSCRIPTS.json`. The relevant file is
`build/sections/06-tree.tex`, abbreviated **06** below.

The source-scope assessment compared all eleven manifest-listed TeX files
with their supplied hashes. In particular 06 matches
`290c22fc61a7787fdf8d7074e5df48c0c98a65531f7399caa0a0fe7d626b9d00`.
The staged manuscript entry is a symlink to the manifest's source directory,
not an independent preserved manuscript copy. The supplied snapshot manifest
lists nine family013 artifacts; the old report and other eight listed files
match it. The additional twelve inventoried files are supporting old-workspace
artifacts, not twelve extra snapshot-listed drafts. See the coverage index
and the two companion assessments for the comparisons; no manifest was rebuilt.

Historical `C_TREE@1` states an unspecified depth constant `C_l`. Matching
old-ledger judgments by `engineer:copilot` and `reviewer:a32ebef5489a`
support that claim version and its density/affine/fourth/majorant/cycle
subclaims. Those are genuine reviewed records, not merely scheduling receipts.
However, neither a distinct `16^r` claim nor a distinct cycle-extension claim
was versioned there. The stronger report statement is assessed directly here;
it is not silently assigned a separate historical reviewer approval.
The historical graph's `reviewer_confirmed=false` flags remain unchanged.

`C_TREE_ALGEBRA@1` was informal. Version 2 added the formal source without
changing the natural statement. Its compiler certificate and historical reviewer
judgment bind version 2. The old majorant route still names version 1's hash;
the index records that stale reference rather than rewriting the old ledger.

## Exact theorem and hypotheses

Let `q` be an **odd prime**, `U = F_q^*`, with uniform probability measure
on `F_q` or `U` as indicated. Let `g:F_q -> C` satisfy

```
g(0)=0,       E_Fq |g|^2 <= 1,
epsilon = max_(chi in U-hat, a in F_q) |E_x g(x) chi(x) e_q(a*x)|.
```

All multiplicative characters, including the principal character, are zero
at zero. No pointwise bound on `g` is assumed. The parameter for `conj(g)`
is the same, and `epsilon<=1`.

A diagram is exactly the ordered full binary tree of 06:32--68:
depth `l`, `r=2^l` unit leaves, unit frequencies at **every** node, unit
`D'`, unit internal constants and root current entries. Current entries
propagate as `(p_n, X_(n,+/-))`. With

```
H_(n,+/-) = X_(n,+/-) C_(n,+/-) M_(n,+/-),
p_n = (s_(n,+) H_(n,-) - s_(n,-) H_(n,+))/(s_n u_n),
y_n = s_n/(D' H_(n,+) H_(n,-)),
y_(n,+/-) = s_(n,+/-)/(D' p_n u_n H_(n,+/-)),
```

the constants obey the stated consistency
`C_(n,+,+) C_(n,+,-)=u_n C_(n,+)`, and its minus analogue.
Every zero reconstructed `p_n` kills the **whole** diagram before division.
Bottom siblings use opposite conjugations; different pairs can choose
differently. Depth zero uses the separate `y=c/M` convention.

For independent uniform leaves the conclusion is `E|W|^2<=3^r`.
For two diagrams of the same depth, pair partitions into the same number
`b` of nonempty blocks and use uniform measure on equality of paired block
products. Parameters and conjugations can differ between diagrams.
For `l>=2`, either of the following is sufficient:

1. The manuscript condition `b<=3r/4`.
2. The first diagram's component--bottom-quartet multigraph has a cycle,
   including a two-parallel-edge cycle.

Then

```
|E W_1 conj(W_2)| <= 16^r (epsilon + q^(-1/4)).
```

For a family of functions with fixed `l`, `q -> infinity` and
`epsilon_q -> 0`, this implies the manuscript's `o_l(1)` conclusion
(06:70--88). The quantitative inequality itself does not require an
asymptotic hypothesis at an individual prime. No assertion for varying
unbounded depth, characteristic two, arbitrary nonuniform leaf laws,
zero parameters, or arbitrary pairings of individual leaves is made.

## 1. Density and bottom-pair data

On valid points, cancellation gives `y=d-e` and
`d/e=(s_+/s_-)(H_-/H_+)`. Expose the root product, then descendant
products. The root argument is uniform on `U`; conditionally at a split,
the left product is uniform on `U`, the right product is determined, and
the current entries are fixed. The child ratio is a fixed unit times an
inverse square. A specified valid split has at most two preimages.

At a horizontal level of `k` nodes, the arguments determine all earlier
arguments by differences. The root costs `1/(q-1)` and its `k-1` splits
cost at most `2/(q-1)` each. Hence the valid **subprobability** law is
dominated by `2^(k-1)` times independent uniform law on `U^k`.
One never conditions on validity and renormalizes it. This proves

```
E|W|^2 <= 2^(r-1) (q/(q-1))^r ||g||_2^(2r) <= 3^r.
```

The depth-zero convention obeys the bound directly. This checks
`C_TREE_DENSITY@1` and the single-diagram part of `C_TREE@1`
against 06:90--125, including unbounded or sparse `g`.

Put `L=q/(q-1)<=3/2`. For `sigma=+/-1`, `f=g` or `conj(g)`,

```
h(d,t)=f(sigma*d*t/(t-1)) conj(f(sigma*d/(t-1))),
R(d)=E_(t in U)|h(d,t)|^2,
```

with invalid arguments zero. The valid parametrization is a bijection to
distinct ordered unit pairs, so `E_U R<=L^2`. Conjugation and reversing
the ordered pair make this same `R` valid for every pair type.
For nonzero `d`, let `P_chi(d)` be the Mellin coefficient of `h`.
Its extension at zero must be its autocorrelation value, **not** `h(0,t)`:

```
P_chi(d)=L E_x (f*conj(chi))(x) conj((f*conj(chi))(x-sigma*d)).
w_chi(a)=hat(P_chi)(a)=L |hat(f*conj(chi))(sigma*a)|^2 >= 0.
J_chi=sum_a w_chi(a)=L ||g||_2^2 <= L.
r_chi=sum_a w_chi(a)^2.
max_(chi,a) w_chi(a)<=L epsilon^2,
max_chi r_chi<=L^2 epsilon^2,
sum_chi r_chi<=2L,
E_U |P_chi|^2<=L r_chi.
```

For the total `r` bound, the nonzero-`d` Parseval contribution is at most
`L`; the `q-1` equal autocorrelation values at `d=0` contribute at most
another `L`. This verifies the normalizations at 06:209--284.
The square pullback loses at most a factor two by character orthogonality
and Cauchy--Schwarz; square-coset probability is dominated by twice uniform
unit probability. These are integrated estimates, not pointwise estimates.

## 2. Uniform affine Mellin bound

The claimed estimate is, for every `eta,a`,

```
sum_chi |hat(P_chi*chi*eta)(a)|^2
  <= L (epsilon^4 + sqrt(3) q^(-1/2)).
```

The twist zeros the origin even when principal. Parseval in `lambda`
turns its left side into
`E_lambda |E_d h(d,lambda*d) eta(d)e_q(-a*d)|^2`.
The substitutions in 06:302--331 give

```
t=sigma/lambda, v=1/z, 1/x=v-t*v^2,
G(v)=(f*eta)(1/v)e_q(-a*sigma/v), G(0)=0,
TF(t)=q^(-1) sum_(v in U) conj(G(v)) F(v-v^2*t).
```

The omitted values are exactly zeros, not an unestimated exceptional set.
The coefficient is `conj(eta(lambda))*TG(t)`;
`||G||_2<=1` and `|EG|<=epsilon`.

For `U_v F(t)=F(v-v^2*t)`, the coordinate map in `U_v^* U_w` is
`t -> (w/v)^2*t + w-w^2/v`. At fixed slope, `z=w/v` has at most two
choices. For `z!=1`, translation `v(z-z^2)` fixes `v` uniquely.
The identity has only `w=v` representations: the other possible
slope-one value `z=-1` has translation `-2v!=0` because `q` is odd.
Thus, for the affine coefficient array of `T^*T`,

```
sum_(A,B)|c(A,B)|^2 <= q^(-2) + 2 q^(-4)(sum_v |G(v)|^2)^2
                    <= 3 q^(-2).
```

On the mean-zero additive Fourier basis, its squared Hilbert--Schmidt
norm is at most `q sum|c|^2`; this is additive Parseval in `B`.
The operator norm of `T^*T` is therefore at most `sqrt(3)q^(-1/2)`.
Both the constants and mean-zero subspace are invariant. The squared
constant contribution to `TG` is `|EG|^4`, not `|EG|^2`.
Restricting the remaining average to `U` costs `L`. This proves the
displayed estimate and supports `C_TREE_AFFINE@1` (06:286--381).
No external affine-group mixing theorem or boundedness of `G` was used.

## 3. Fourth moment and the principal correction

For nonnegative weights of mass `J`, multiplicative orthogonality gives

```
(q-1)^(-1) sum_(alpha,a) |sum_b w(b)alpha(a-b)|^4
    <= 2q (sum_b w(b)^2)^2 + J^4.
```

Matching unordered pairs account for the first term. Otherwise the
difference of the two monic quadratics is nonzero of degree at most one,
so there is at most one collision argument. Repeated entries and zero
products do not add cases: the former are included, the latter are killed
by the zero extension of characters. This is the decisive counting
argument, not the finite enumeration.

The principal contribution is at least
`J^4 - 3J^4/(q-1)`, by summing
`(J-w(a))^4 >= J^4-4J^3 w(a)`.
It must be subtracted **before** the nonprincipal Gauss formula is used.
The elementary Gauss identity then gives

```
sum_(alpha!=1,a) |hat(P_chi*alpha)(a)|^4
    <= 2r_chi^2 + 3J_chi^4/q^2,
sum_(chi,alpha!=1,a) |hat(P_chi*alpha)(a)|^4
    <= 16(epsilon^2+q^(-1)).
```

Indeed the two summed coefficients are bounded by `4L^3` and `3L^3`,
respectively, both below 16. For a principal twist the exact correction
is `hat(P_chi*1_U)(a)=w_chi(a)-J_chi/q`; its Fourier squared norm is
at most `r_chi`.

In the two-bad convolution with twists
`alpha=nu*conj(psi)`, `beta=conj(nu)*conj(chi)`, separate four cases.
Both nonprincipal cost at most `16(epsilon^2+q^(-1))` by Cauchy--Schwarz
and the two bijections of character indices. Exactly one principal fixes
one index; the other squared Fourier factor is at most `L^2/q`, and the
remaining sum costs at most `2L`. Each such case costs `2L^3/q`.
Both principal fix both indices, and cost at most
`2L^4(epsilon^4+q^(-2))`. Their sum is bounded by

```
40(epsilon^2+q^(-1)) <= 64 delta,
delta=epsilon^2+q^(-1/2).
```

This supports `C_TREE_FOURTH@1` and its use for all principal exceptions
(06:549--635). The coefficient 16 and the budget 40 are mathematical
bounds using `L<=3/2`, `epsilon<=1`, and `q>=3`; a compiler's polynomial
identity or a small-prime test alone would not prove them.

## 4. Parameter-free quartet majorants

For nonnegative functions put
`(F star G)(y)=(q-1)^(-1) sum_(d,e in U;d-e=y) F(d)G(e)`.
Its `U`-mean is at most the product of means after discarding `d=e`.

When both moving leaves are in one pair, the moving-square coefficient
costs two and the two held square-coset laws cost four. The old majorant
`8(S_rho star R)` sums both inverse-index conventions. It has

```
sup_rho E B_same,rho <= 32L^5 epsilon^2 <= 243 epsilon^2,
sum_rho E B_same,rho <= 32L^4 <= 162.
```

There are at most four character terms in `S_rho`, and summing it over
`rho` counts each `chi` twice. Moving the right pair just reverses the
convolution. An untouched quartet is bounded by
`B_0=8(R star R)`, with mean at most `8L^4<=81/2`.

For cross-pair motion, orient each moving leaf as free. The exact
identities are

```
t_L/d = fixed_unit * H_held,L^2,
t_R/e = fixed_unit * H_held,R^2,
p_*^2 = (s_+s_-/(s_n D' u_n^2)) y/(d*e).
```

A residual held current entry gives `t_L=lambda_L*d` or
`t_R=lambda_R*e` (friendly). A reconstructed held current entry gives
`t_L=lambda_L/e` or `t_R=lambda_R/d` (bad).
The multipliers in the two lambdas can depend on fixed ancestors and
`y`, but **not** on either held variable. Thus the lambdas are independent
square-coset variables. Negating the moving coordinate changes `p_*`
by a sign, not these ratios, so no square-root branch of a diagram is
being discarded.

Square pullback, both nonnegative coset dominations, and the change to
`1/q` normalization cost at most `2*4*L^2<=18`.
For each fixed `nu`, Mellin expansion in the two independent lambdas
followed by additive Parseval gives the following twists:

| Left/right type | alpha | beta |
|---|---|---|
| friendly/friendly | `nu*chi` | `conj(nu)*psi` |
| friendly/bad | `nu*chi*conj(psi)` | `conj(nu)` |
| bad/friendly | `nu` | `conj(nu)*psi*conj(chi)` |
| bad/bad | `nu*conj(psi)` | `conj(nu)*conj(chi)` |

If either side is friendly, the affine bound sums the appropriate index
uniformly; the remaining Parseval sum is at most 3. This costs at most
`8 delta`. The two-bad row costs at most `64 delta`.
There are at most four `nu` terms for a fixed `rho`, and changing the
`y` average to `F_q` costs `L`. Consequently

```
sup_rho E B_cross,rho <= 18*4*L*64 delta <= 6912 delta <8192 delta,
sum_rho E B_cross,rho <= 36L^4 <= 729/4 <256.
```

The second bound uses Mellin Parseval in `d/e`, not the first bound
summed over `q-1` characters. These are distinct necessary estimates.
The functions so defined no longer contain any ancestor-dependent
coset multipliers. Adding 32 same-pair and 64 cross-pair types includes
all orientations, conjugations and friendly/bad choices, even though
some are redundant. For `K=2^20` this proves

```
sup_rho E B_rho <= K delta,   sum_rho E B_rho <= K,   E B_0<=K,
32*256+64*8192=532480<K,      96*256<K.
```

This supports `C_TREE_MAJORANTS@1` (06:383--547, 629--635).
Every domination integrates a nonnegative function; there is no passage
from an averaged estimate to a pointwise bound on `g` or `P_chi`.

## 5. Projection, parallel edges, and the explicit constant

Each component product fiber has `(q-1)^(r-b)` elements. Sampling common
independent uniform component totals, and then independent fibers in the
two diagrams, gives the stated paired law and uniform independent leaf
marginals. Hence conditional Cauchy--Schwarz gives

```
|E W_1 conj(W_2)| <= 3^(r/2) ||P W_1||_2,
```

where `P` averages reciprocal leaf scalings around a cycle in the first
diagram. This group average is an orthogonal projection. It preserves
component totals, so conditional expectation of `PW_1` equals that of
`W_1`; it need not preserve the second diagram's quartets.

There are `r` edges and `b+r/4` vertices in the first bipartite
multigraph. Under `b<=3r/4` it cannot be a forest. Parallel edges count
and are allowed. Once a cycle exists, nothing in the remaining proof
uses the numerical bound on `b`.

Put `k=r/4`. Condition on all quartet products. Ancestor data and validity
are fixed, and quartet interiors are independent uniform fibers. The two
held coordinates and one moving coordinate in a cycle quartet are
independent uniform units. Mellin Parseval leaves exactly the relation
`product_j rho_j^(delta_j)=1`, `delta_j=+/-1`.
One character is uniquely determined by the others. The majorants and
the valid horizontal subprobability density therefore give

```
||PW_1||_2^2
 <= 2^(k-1) (sup_rho b_rho)(sum_rho b_rho)^(t-1)b_0^(k-t)
 <= 2^k K^k delta,
```

where `t` is the number of cycle quartets. For two parallel edges,
`t=1`; the sole character is principal and the same small supremum
bound applies. There is no missing longer-cycle hypothesis.

Finally,

```
3^(r/2) sqrt(2^k K^k delta)
 <= 3^(r/2) 2^(21r/8) (epsilon+q^(-1/4))
 <= 16^r (epsilon+q^(-1/4)).
```

The last numerical step follows from `3^4*2^21<=16^8`; it holds
independently of any finite test. This supports `C_TREE_CYCLE@1`, the
paired part of `C_TREE@1`, the report's explicit constant, and its cycle
extension (06:127--207,637--673).

## Evidence, assumptions, and limits

The companion `formal_algebra/report.md` identifies all eleven exact Lean
declarations, their nonzero hypotheses, and their foundational axioms.
Its unchanged current copy obtained a fresh official Lean 4.31.0 run,
compiler/audit exits 0, and `proof_holes=[]`, under
`C_REVIEW_ALG_013`. That result supports rational substitution, square
fibers, affine coordinates, collision uniqueness, group cancellation,
and one integer budget. It does **not** certify any integral, operator
norm, majorant, graph, or analytic theorem above.

The unchanged isolated checker reproduced its stored certificate:
9 symbolic identities, 14 scalar inequalities, 6 field-fiber cases,
20 diagram cases/4,244 tuple occurrences, 324 function cases,
19,008 sign-lift checks, and 259 matched partition cases. Bounds and
families were not enlarged. Some diagram cases have no valid tuples;
the paired depth-three case instead has 128 nonzero weights in each
diagram and a positive projection norm. These diagnostics are useful
for implementation conventions, not a proof of the displayed estimates.
The checker reads historical Lean/Jacobian receipts, so its successful
receipt assertions are not themselves a fresh compiler or adapter run.

A separate bounded current adapter run uses
`arithmetic_dynamics.finite_field.functional_graph.compute` on
`{"prime":5,"coefficients":["0","0","1"]}`. Discovery, inspected input/output
contract, exact payload, raw typed result, and adapter status are adjacent
JSON files. Server 0.14.0/protocol 2025-11-25 returned the complete graph

```
0->0, 1->1, 2->4, 3->4, 4->1
```

with adapter exit 0, no timeout and no structured error. Thus the unit
square fibers in this already-tested field have size two. It neither
proves nor refutes a quantified estimate. The old extension-presentation
request's `INVALID_REQUEST` remains a separate historical non-conclusion;
its failure was not treated as an unavailable service or mathematical result.

The elementary tools used in the analytic proof are finite Fourier/Mellin
orthogonality and Parseval, Cauchy--Schwarz, polynomial root counting,
finite-dimensional operator norms, and group averaging. They are justified
by finite expansions in the old proof and the calculations above. For
completeness, `U` is cyclic: a finite abelian subgroup of a field has an
element of its exponent (take maximal prime-power order parts and multiply
these coprime-order elements), and the polynomial of that degree cannot have
more roots than its degree. Its exponent must therefore be its size.
Characters are then the explicit roots-of-unity characters of a cyclic
group, so their completeness and the two-root dual-square statement follow
from geometric sums. No unproved affine-mixing, Gauss-sum, or fourth-moment
theorem is imported. The Gowers/Babai--Nikolov--Pyber/Gill citations at
06:334--338 are motivational comparisons, not premises whose attribution
this review certifies. No novelty search or priority claim is made.

**Concrete unresolved boundary:** the local theorem does not prove that the
manuscript's integer construction yields the required independent unit
residues, common spectator primes with uniformly small epsilon, controlled
errors, history norms, or transfers. Those are the arithmetic idealization
and rate obligations listed claim by claim in `arithmetic_scope/report.md`,
including the separate regular-factor norm needed at final closure.
There is no identified missing analytic step in the literal local proof
after the above checks, but this is a human judgment, not a kernel verdict.
Neither it nor the historical reviewer records decide acceptance of the
entire family review.
