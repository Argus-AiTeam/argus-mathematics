# An everywhere-quadratic limit under vanishing twists

## Exact scope

The target is Proposition `prop:limit` in the staged September 24, 2026
manuscript, not the construction, ampleness, or obstruction propositions.
Here `S = P^1 x P^1`, `P = O(1,1)`, and `f_m` raises each pair of
homogeneous coordinates to the power `m`. For an arbitrary holomorphic
bundle `G` of rank `r >= 1`, the hypothesis is that `f_m^*G tensor P`
has a smooth strictly Griffiths-positive Hermitian metric for infinitely
many **distinct positive integers** `m`. The asserted conclusion is a
finite, nonnegative, nonzero psh function on `F = G^dual`, whose
restriction to **every** fiber is a positive semidefinite Hermitian
quadratic. No determinant lower bound, continuity of the limiting
coefficients, or convergence of restrictions to a divisor is asserted.

The proof below will distinguish analytic reasoning from exact algebraic
replay. A Python replay cannot certify compactness, removable
singularities, or every-point analytic quantifiers.

## Source-grounded exclusions

The manuscript itself rejects taking the raw pointwise limit: the
normalized trace of `(1 + |y|^2)|v|^2` through `y^m = x` is
`(1 + |x|^(2/m))|v|^2`. Its raw limit has coefficient `1` at `0`
and `2` away from `0`, so is not upper semicontinuous. Its intrinsic
psh representative instead has coefficient `2` also at `0`.
This is a failed proof route, not a counterexample to `prop:limit`.

Its Remark `rmk:canonical-limit` also explicitly excludes deducing
convergence of restrictions to the graph divisor from distributional
convergence on the base. Graph identities must be evaluated on the
single recovered, everywhere-defined psh function.

Rank-deficient limits are allowed. A method requiring a positive
determinant of the limit would prove a different statement and cannot
be used here without an additional argument.

## Analytic foundations

The primary source is J.-P. Demailly, *Complex Analytic and Differential
Geometry*, **June 21, 2012** edition. The downloaded PDF's title page
confirms that edition. `sources.md` records the passages read, and the
PDF and its text extraction are retained beside this proof.

| Ledger assumption | Precisely what is used |
|---|---|
| `A_SUBHARM_COMPACT` | Chapter I, Proposition 4.21: locally `L^1`-bounded subharmonic functions are relatively compact in `L^1_loc`. |
| `A_REMOVABLE` | Chapter I, Theorem 5.24: extension of a locally upper-bounded psh function across a closed pluripolar set. |
| `A_RADIAL` | Chapter I, (4.11) and Theorem 4.18(a): spherical means increase with radius, hence convolution by any fixed nonnegative radial kernel increases with its scale. |
| `A_PSH_DECREASE` | Chapter I, Theorem 5.4: decreasing limits of psh functions are psh. Here a uniform lower bound excludes the identically minus-infinity alternative. |
| `A_SUBMEAN` | Chapter I, Theorem 4.12(c) and (5.3): ball submean inequalities for psh functions. Upper semicontinuity then recovers each finite value from shrinking ball means. |

We also use elementary Lebesgue integration: Fubini, dominated
convergence, and the fact that equal locally integrable distributions
are equal almost everywhere. These are measure-theoretic foundations,
not outputs of the exact verifier. The elementary extraction of an
almost-everywhere subsequence from `L^1` convergence is explained below.
No weak compactness theorem for Hilbert spaces, determinant lower
bound, singular curvature current, or restriction theorem for a
divisor is used.

The local smoothing mechanism is already known: Raufi,
`arxiv:1211.2948v3`, Definition 2 and Proposition 1.1(i), explicitly
describe negative singular Hermitian metrics and decreasing local
regularization. That is the **preprint's** numbering, not an allegation
about the numbering of the journal version cited in the manuscript.
We do not claim novelty for this regularization. The additional
statements proved here are strong coefficient convergence in every
finite `L^p` and preservation of the normalized maximum, as well as a
dimension- and sublinear-twist-uniform formulation. This is a
mathematical strengthening of the manuscript's distributional,
nonzero-limit assertion, not a verified priority claim.

## Theorem A: compactness under vanishing twisting laws

Let `X` be a compact complex manifold, of complex dimension `n >= 1`,
let `F` be a holomorphic bundle of rank `r >= 1`, and let `K` be a
holomorphic line bundle. Fix smooth positive Hermitian background
metrics on `F` and `K`. Let `epsilon_j` be any real sequence tending
to zero. Suppose that for each nonvanishing holomorphic frame `t`
of `K` on `U`, there is a continuous function `q_{j,t}` on `F|_U`
such that:

1. It is jointly psh on the total space and is a positive definite
   Hermitian quadratic on every fiber.
2. Its bundle-coordinate changes are the usual ones for a quadratic,
   and for a line-frame change `t' = g t` it satisfies
   `q_{j,t'} = |g|^(2 epsilon_j) q_{j,t}`.

The scalars multiplying each whole family can be chosen so that

`N_j(x,v) := q_{j,t}(x,v) |t(x)|_0^(-2 epsilon_j)`

has maximum one on the background unit sphere bundle. Then a
subsequence has the following properties:

* The matrices of `q_{j,t}` converge strongly in `L^p_loc` for every
  finite `1 <= p < infinity`, in every fixed holomorphic chart.
* Their limit has a unique representative `q` on the total space
  which is finite, nonnegative, psh, and a Hermitian positive
  semidefinite quadratic on **every** fiber.
* Everywhere, `q(x,v) <= |v|_0^2`, and
  `max_{x in X, |v|_0=1} q(x,v) = 1`.

The uniqueness is for the measurable limit of the chosen subsequence.
There is no assertion that different subsequences yield the same
limit, or that `q` is continuous or positive definite.

### A1. Normalization and strong coefficient extraction

The frame law makes `N_j` a globally defined continuous positive
quadratic. Compactness of the unit sphere bundle makes its positive
maximum finite and attained. Dividing by that maximum gives

`0 <= q_{j,t}(x,v) <= |t(x)|_0^(2 epsilon_j) |v|_0^2`.       (1)

On each relatively compact chart, the scalar factor on the right
converges uniformly to one: if `b = log |t|_0^2` and `|b| <= M`,
then `|exp(epsilon_j b)-1| <= |epsilon_j| M exp(|epsilon_j| M)`.
Thus the local coefficient matrices `H_j` are uniformly bounded.

Use the following finite collection of constant fiber vectors:

`e_k`, `e_k+e_l`, and `e_k+i e_l`, for `1 <= k < l <= r`.

There are exactly `r^2` such vectors. Each scalar function
`q_{j,t}(x,c)` is nonnegative, subharmonic in the base, and locally
uniformly bounded. Proposition 4.21 applies. Extracting successively
for this finite collection and diagonally for a countable relatively
compact chart exhaustion gives simultaneous `L^1_loc` convergence.
Polarization gives coefficient convergence to a measurable Hermitian
matrix `H`:

`H_kk = q(e_k)`,

`2 Re H_kl = q(e_k+e_l)-q(e_k)-q(e_l)`,

`2 Im H_kl = q(e_k)+q(e_l)-q(e_k+i e_l)`.                 (2)

The sign in the last formula is for the convention `v^* H v`.
The diagonal and the two real components of every off-diagonal entry
therefore converge in `L^1_loc`. A further subsequence converges
almost everywhere simultaneously on the chart exhaustion. For
completeness, on each compact set choose `L^1` errors smaller than
`2^(-2j)`; the sets where the error exceeds `2^(-j)` have summable
measure by Markov's inequality. Outside their limsup the errors tend
to zero. A countable diagonal selection deals with all entries and
compact sets.

Consequently `0 <= H(x) <= B_0(x)` almost everywhere, where `B_0`
is the matrix of the background squared norm. The upper bound follows
by taking the almost-everywhere limit in (1). The uniform local
coefficient bound also upgrades convergence to every finite `L^p`,
because for uniformly bounded scalar entries

`|H_j-H|^p <= (2C)^(p-1) |H_j-H|`.

No positive determinant is asserted.

### A2. The twist disappears, including on overlaps

If fiber coordinates change by `v = R(x)w` and `t' = g t`,
then

`H'_j = |g|^(2 epsilon_j) R^* H_j R`.                    (3)

On every compact subset of an overlap, `R`, `R^*`, and
`log |g|^2` are bounded. The exponential estimate from A1 implies
that the scalar in (3) converges uniformly to one. Multiplying
strongly convergent coefficients by the fixed smooth matrices
preserves local `L^p` convergence. A biholomorphic change of base
coordinates also preserves local convergence, by the bounded
Jacobian and its inverse on smaller compact subsets. Hence

`H' = R^* H R` almost everywhere.                         (4)

This is the untwisted transition law. We have not assigned values
to a base-null set, much less restricted (4) to a divisor.

### A3. The canonical representative is quadratic at every point

Work in one coordinate and bundle chart. Let `rho >= 0` be smooth,
radial on `R^(2n)`, supported in the unit ball, and of integral one.
For small positive `delta` and interior base points put

`H_delta = H * rho_delta`, `q_delta(x,v) = v^*H_delta(x)v`,

where `rho_delta(y) = delta^(-2n) rho(y/delta)`.
All convolution arguments take place on smaller relatively compact
subcharts and are then exhausted; no convolution across a chart
boundary is involved.

Likewise the base convolution of `q_{j,t}` is jointly psh: it is
a positive average of pullbacks by the holomorphic translations
`(x,v) -> (x-y,v)`. For fixed `delta`, all derivatives of its
coefficients converge locally uniformly to those of `H_delta`.
Indeed, their differences are bounded by the local `L^1` coefficient
error times a fixed supremum of a derivative of the kernel.
The Levi matrices therefore converge, proving that `q_delta` is
smooth and jointly psh. It is nonnegative and locally bounded by
`C|v|^2`.

The monotonicity needed here does **not** require a monotone radial
profile for `rho`. If `rho(y) = phi(|y|)` and `M_u(x,s)` is the
spherical mean in real dimension `2n`, polar coordinates give

`(u*rho_delta)(x) =
 |S^(2n-1)| integral_0^1 M_u(x,delta s) phi(s) s^(2n-1) ds`. (5)

Spherical means of a subharmonic function increase with radius, and
the weight is nonnegative and independent of `delta`. Apply (5)
first to `u(x)=q_{j,t}(x,v)` for every fixed `v`, then pass to the
coefficient limit at two fixed scales. This gives

`H_delta1(x) <= H_delta2(x)` for `0 < delta1 < delta2`.     (6)

Thus `q_delta` decreases as `delta` decreases. Theorem 5.4 gives
a psh limit `q_U`. It is finite and nonnegative by the local bound.
For each fixed `x`, every value in the finite polarization set (2)
has a finite limit. Hence all entries of `H_delta(x)` converge to
one Hermitian matrix `Hhat_U(x)`. Taking the limit in the finite
quadratic polynomial proves, simultaneously for **all** `v`,

`q_U(x,v) = v^* Hhat_U(x) v`.                            (7)

This is the all-fiber step; it is not an inference from almost-
everywhere matrix values. Nonnegativity makes `Hhat_U(x)` positive
semidefinite for every `x`, even if it is singular or zero.

The bounded pointwise coefficient convergence and dominated
convergence show `H_delta -> Hhat_U` in local `L^1`. On the other
hand, for a smooth compactly supported test function `psi`,

`<H*rho_delta,psi> = <H,rho_delta(-.)*psi> -> <H,psi>`.

The last convergence follows from uniform convergence of the
convolved test functions and the bounded local coefficients.
Therefore `Hhat_U = H` almost everywhere. This proves recovery of
the original measurable form without assuming pointwise
approximate-identity convergence on a specified exceptional set.

Moreover `H <= B_0` almost everywhere, so
`q_delta(x,v) <= v^*(B_0*rho_delta)(x)v`. Smoothness of `B_0`
and `delta -> 0` give

`q_U(x,v) <= |v|_0^2` at **every** point.                 (8)

### A4. Intrinsic gluing and uniqueness

By (4), the two local candidates, after the holomorphic coordinate
change on `F`, agree off a base-null set for every fiber vector.
On bounded fiber sets they agree almost everywhere in the total
space by Fubini. Both are finite psh functions. For any such
function `u`, submean and upper semicontinuity give

`u(p) <= average_{B(p,s)} u <= sup_{B(p,s)} u`,

and hence `u(p) = lim_{s -> 0} average_{B(p,s)} u`.
Functions equal almost everywhere have identical ball averages,
so these local candidates agree at every total-space point.
They glue to `q`. The same argument proves independence of the
chosen radial kernel and uniqueness for the given measurable form.
In particular (7) holds also above any prescribed divisor.

### A5. The normalized maximum cannot decrease

Let `(x_j,v_j)` attain `N_j=1` on the unit sphere bundle. Pass
to a convergent subsequence `(x_j,v_j) -> (x_*,v_*)`, with
`|v_*|_0=1`. In one fixed chart near `x_*`, let `c_j -> c`
be the fiber coordinates. Uniform operator bounds give

`|c^*H_j(x_j)c-c_j^*H_j(x_j)c_j|
 <= C |c-c_j| (|c|+|c_j|) -> 0`.

The second quadratic equals `|t(x_j)|_0^(2 epsilon_j) -> 1`.
Thus `u_j(x_j) -> 1` for the nonnegative subharmonic functions
`u_j(x)=q_{j,t}(x,c)`. We already know that `u_j` converges
in local `L^1` to `u(x)=q(x,c)` and that both are bounded on
a slightly smaller chart.

Fix a small ball radius `s` around `x_*`. The symmetric difference
of `B(x_j,s)` and `B(x_*,s)` has volume tending to zero. Consequently

`|integral_{B(x_j,s)}u_j - integral_{B(x_*,s)}u|
 <= ||u_j-u||_{L^1(K)}
    + C Vol(B(x_j,s) symmetric_difference B(x_*,s)) -> 0`,

for one fixed compact neighborhood `K`. Passing to the limit in
the submean inequality at the moving points yields

`1 <= average_{B(x_*,s)} u`.

Letting `s` decrease to zero yields `1 <= q(x_*,c)`. Equation
(8) supplies the opposite bound because `c` represents `v_*`.
Therefore `q(x_*,v_*)=1`, proving the stated maximum and
noncollapse. This completes Theorem A.

## Theorem B: product power maps and sublinear twists

Let `d >= 1`, `X=(P^1)^d`, `L=O(1,...,1)`, and `F=G^dual`
for any positive-rank holomorphic bundle `G`. Let `m_j` be
distinct positive integers tending to infinity and `a_j` integers
such that `a_j/m_j -> 0`. If

`f_{m_j}^*G tensor L^(a_j)`

admits a smooth Griffiths-**semipositive** Hermitian metric for
every `j`, then the conclusion of Theorem A holds for `F`.

### B1. The curvature sign

The dual metric on `f_m^*F tensor L^(-a)` is Griffiths-
seminegative. Here is the local calculation rather than a sign
convention inferred from terminology. Along a holomorphic disk
choose a normal frame for this smooth dual metric `h`, so
`h=I` and `dh=0` at its center. In the manuscript's convention
its curvature coefficient is `C=-h_{z bar z}`. For the
holomorphic section defined by any disk in the total space,

`partial_z partial_barz (s^*h s)
 = |s'|^2 - s^* C s >= 0`.

Thus the squared norm is psh on the total space. Duality reverses
the curvature sign, as also follows by differentiating
`h h^(-1)=I` at a normal point. Strict positivity of the original
metric is unnecessary for this implication. In the `v^*h v` convention
the dual matrix is the transpose of the inverse; the transpose does
not change the reversed Hermitian sign.

### B2. Root independence and frame transitions

The power map has degree `m^d`, and the usual homogeneous-coordinate
isomorphism identifies `f_m^*L^(-1)` with `L^(-m)`.
Let `t` be a nonvanishing holomorphic frame of `L^(-1)` on
a target open set `U`. On a small source neighborhood, write

`f_m^*t = eta s^m`

with `s` a frame of `L^(-1)` and `eta` a nowhere-zero
holomorphic function. A local logarithm gives
`r_t=exp(log(eta)/m)s`. Then `r_t^a` is a local section
of `L^(-a)`, including when `a` is negative. Changing a
logarithm multiplies it by an `m`-th root of unity raised to
the integer `a`, so its squared norm is unchanged. Set

`q_{m,t}(x,v) =
 m^(-d) sum_{y in f_m^(-1)(x)} ||v tensor r_t(y)^a||_y^2`, (9)

counting local multiplicities. This is a positive definite
Hermitian quadratic. If `t'=g t`, its root changes by a
factor whose modulus is `|g(x)|^(1/m)`. Consequently

`q_{m,t'}=|g|^(2a/m) q_{m,t}`.                           (10)

Root choices do not create a cocycle error: every ambiguity has
unit modulus before taking squared norms.

### B3. Ramification, including crossings and infinity

Off the branch locus, (9) is a positive sum of holomorphic
pullbacks of the source norm, hence jointly psh. For fixed
`m`, it is continuous also on the branch locus. Indeed, the
multiset of the roots of `y^m=x` is continuous, counting
multiplicity. At `x=0` all `m` roots coalesce to `0`; at
infinity the coordinates `1/y` and `1/x` give the same
calculation. In `d` factors the multisets are Cartesian products.
At a corner with `k` ramified factors, each unramified preimage
is counted `m^k` times. The total multiplicity is always `m^d`.

More explicitly, take disjoint source neighborhoods of the finite
fiber. In each, the local root section used in (9) and the metric
are continuous. Each colliding summand tends to the value at its
limiting preimage. Its number of copies is the local multiplicity.
Summing finitely many such limits proves continuity jointly in
the target base and `v`. This argument uses no bound uniform in
`m`, and works equally at crossings of branch components.

In a total-space chart the inverse image of the branch locus is
contained in coordinate hyperplanes and is pluripolar; locally
`log|z_1...z_k|` witnesses this. The continuous trace is locally
bounded above. Theorem 5.24 therefore extends its off-branch psh
function. The extension's values are the upper limits of the
off-branch values, which are the continuous values just proved.
Thus (9) is jointly psh on all of `F|_U`.

Apply Theorem A with `K=L^(-1)` and `epsilon_j=a_j/m_j`.
The input Hermitian norms may be rescaled by positive constants
without changing curvature. This proves Theorem B.

## Resolution of the exact manuscript proposition

Take `d=2` and `a_j=1` in Theorem B. An infinite subset of
the positive integers contains an unbounded sequence of distinct
integers, so `epsilon_j=1/m_j -> 0`. A strictly positive
metric is in particular semipositive. All hypotheses of
Theorems A and B have now been derived from, not added to,
the hypotheses of `prop:limit`. Their conclusion is exactly
the finite nonnegative nonzero psh Hermitian quadratic on
**every** dual fiber. It applies at branch points, graph
intersections, and all points of the graph divisor without
claiming convergence of restrictions there.

In addition, this proof gives local strong coefficient convergence
for every finite `L^p` and maximum one after normalization.
The manuscript only claims distributional convergence and
nonvanishing. Construction, ampleness, and obstruction are
separate graph obligations and are not certified by this proof.

No false assertion of the staged limit section was identified.
The pointwise-limit and determinant pitfalls are explicitly
avoided by that section, so they are not registered as invented
`F_...` refutations.

## Exact replay and its limits

The replay requires Python 3 and SymPy. Run
`python3 research/limit_certificate/verify.py` from the campaign
root, or run the script by absolute path from another directory.
The default mode compares recomputed results with
`exact_certificate.json` and does not overwrite the certificate.

The replay checks universal polynomial identities for the two-index
complex polarization convention, congruence and its orientation,
the normal-frame inverse-metric sign, and the squared-norm Hessian.
It also checks rank-deficient boundary families, exact ramification
multiplicity bookkeeping, and an exact branch-limit diagnostic.
Each finite sweep is explicitly labelled finite; none is a proof
of a quantified analytic assertion.

The Jacobian adapter was discovered and its exact typed
`matrix.subsystem.psd_order.decide` contract inspected before the
single bounded call. `jacobian_payload.json` is the exact input;
`jacobian_output.json` retains the protocol, server version,
operation id, echoed input, and typed output. It verifies only
the rational comparison

`[[1,1],[1,1]] <= [[17/16,1],[1,17/16]]`.

The difference is `I/16` although the lower matrix has rank one.
This is a relevant degeneracy diagnostic, not support for
compactness or a substitute for Theorem A. The adapter returned
exit code zero, with no error or timeout.

The exact script does **not** certify the cited analytic results,
their applicability, compactness of the base, existence of input
metrics, subsequence extraction, the all-point limiting argument,
or novelty. Those belong to the proof and independent Reviewer.
There is no Lean formalization or claim of kernel certification.
Independent replay, citation attribution, significance, and
novelty assessment remain for the host's normal Reviewer path.
