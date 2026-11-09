# The recurrent jet-decay and actualization bridge

## Result and scope

**Conditional verification theorem.** The inputs stated at the start of
Section 6 of the September 23, 2026 manuscript imply both `real:decay`
and `real:actualization`. In fact, for every fixed real number
`0 < c < b_u`,

\[
 \sup_{f^{-n}D}\lVert D_s^jG_{n,k}\rVert
       \le C_{c,j,k}e^{-ckn}\qquad
 (n\in\mathbb N,\ k\ge1,\ j\ge0).                 \tag{1}
\]

The same `c` works for all parameter degrees and derivative orders.
The constants, auxiliary scales, and interpolation orders need not.
Thus `c_0=b_u/4`, as requested in the manuscript, is valid. The
stronger conclusion is every strictly smaller rate than `b_u`, not
the endpoint rate `b_u`.

The finite-truncation construction has one common smooth limit, its
prescribed Taylor series, all finite unstable inputs, unstable-leaf
membership, the stated compatibility, and arbitrarily fast fixed-order
forward and backward approximation. The proof below supplies the
analytic sampling, interpolation, and manifold-valued limit arguments;
it is not a finite numerical check.

This theorem is **conditional on the upstream coherent formal data**.
It does not establish those data from entropy equality, certify
`real:stable-tangency`, or prove entropy rigidity. No false literal
manuscript assertion was identified in this scoped investigation, so
there is no `F_...` refutation claim. Independent review, citation
attribution, novelty, and publishable significance remain Host/Reviewer
decisions. An Engineer opinion is not independent certification.

The prior result being compared is the manuscript's `b_u/4` estimate.
Our mathematical improvement is the full open range `0<c<b_u`, together
with explicit separation of the spatial sampling input from temporal
recurrence and an expanded proof of cutoff independence. This is not a
claim that the underlying interpolation method is new.

## Source and the conditional inputs

All source paths below are relative to
`research/openai_manuscript/Entropy-equality-and-local-symmetry-in-negative-curvature-September-23-2026/build/`.
Write `S6` for `sections/06-realization.tex`. The document identifier
is the README's
`OAI:Entropy-equality-and-local-symmetry-in-negative-curvature-September-23-2026`,
not an unspecified version of a numbered theorem.

| Input or conclusion | Exact source locator | Treatment here |
|---|---|---|
| Uniform strong stable and reverse unstable contraction | S6:45-56, `real:hyperbolicity` | Geometric input |
| Entire-axis smooth, holonomic coefficients and measurable finite patch bounds | S6:15-29,60-74; `hull:coherence`, `hull:measurability`, `alg:axis-coherence` | Upstream input, not reproved |
| Equivariant formal exponential, identity first derivative, actual unstable input frame | S6:60-74,475-501, `real:pulled-jet` | Formal input |
| Local product measure classes and almost-everywhere agreement | S6:434-473, proof of `real:good-points` | Measure-theoretic input |
| Uniform fixed-order geometric calculus | S6:328-358, `real:iterate-bounds` | Explained below |
| Derivative-order-independent naive exponent | S6:360-386,503-539 | Proved below from finite-dimensional products |
| Desired degree-weighted decay | S6:541-630, `real:decay` | Proved, and sharpened to (1) |
| Smooth finite-truncation actualization | S6:634-780, `real:actualization` | Proved below |
| Backward-tail characterization of strong unstable plaques | S6:740-763 | Geometric input |

These are the five cited assumptions `A_GEOMETRY`, `A_COHERENCE`,
`A_FORMAL_EQUIVARIANCE`, `A_PRODUCT_MEASURE`, and
`A_UNSTABLE_CHARACTERIZATION` of ledger claim `C_RJD_BRIDGE`.
In particular, neither `real:good-points` nor `real:naive` is assumed
as an unexplained substitute for its proof.

For source attribution, the relevant literal passages, including the
important qualifications, are:

> Their full ambient jets are smooth and holonomic along both entire
> typical strong axes, and along the corresponding weak axes by flow
> transport. All finite collections of these jets and their plaque
> derivatives have measurable finite patch bounds. They are equivariant
> under \(f=\phi_T\). (S6:24-28)

> \(\|df^r|_{\Es}\|\le C e^{-b_s r}\), \(\|df^{-r}|_{\Eu}\|\le C e^{-b_u r}\).
> All subsequent refinements of the regular set are countable and retain
> conditional full measure on the entire axes in use. (S6:50-56)

> The horizontal affine exponential \(\mathcal E_a(V),\ V\in P_a\),
> including its height coordinate, is a formal map equivariant under
> \(f\). Its finite jets have the whole-axis coherence and measurability
> properties stated above. (S6:65-70)

> The product measure class in each box is the product of its transversal
> Lebesgue classes: this follows by stable disintegration and absolute
> continuity of weak unstable holonomy between stable transversals.
> (S6:439-442)

> For almost every weak unstable plaque, the required tensor jets have
> smooth coherent representatives on its full compact crossing plaque,
> agreeing with the global regular data almost everywhere. Their suprema
> there are finite and measurable by Lemma `hull:measurability`.
> (S6:444-448)

> Let \(Y(a):\mathbb R^{d_u}\to P^u_a\) be a smooth frame map on \(D^+\).
> (S6:478-480)

> The tensors include the usual factorial convention for Taylor
> coefficients. They are genuine smooth coefficient fields on the moving
> stable patch \(f^{-n}D^+\), although the displayed series is only formal.
> (S6:499-501)

> The entire backward tail has this estimate. The local
> unstable-manifold characterization then places the pair in one local
> unstable plaque at large negative time; invariance gives
> \(F(a,y)\in\mathcal W^u(a)\). (S6:758-763)

The first derivative of an affine exponential at its zero initial
vector is the identity by its defining geodesic equation. This is not
an additional claim that an arbitrary formal map has that derivative.
Completeness and the local unstable-manifold characterization are
standard geometric inputs for this lifted compact Anosov system,
not consequences of the compiler certificate.

### Literature scope

A targeted lookup found the classical Gagliardo--Nirenberg
interpolation literature; the primary Numdam entry for Nirenberg's
*On elliptic partial differential equations* (1959),
`https://www.numdam.org/item/ASNSP_1959_3_13_2_115_0/`, was opened.
No numbered proposition there is imported into this proof: the
particular interior estimate needed here is proved directly below.
No primary source for a verbatim named theorem covering this precise
smooth dense-net/dynamical bridge was established. This absence is not
evidence of novelty. Search suggestions about analytic continuation
are unnecessary: the proof uses only smooth finite-order Taylor
estimates, not analyticity or a convergent formal power series.
The supplied Wiki index contained no relevant entropy/jet-decay page.

## 1. Uniform geometric calculus

Use nested relatively compact stable patches and uniformly bounded
stable/geometric charts. By increasing a fixed iterate, the
coordinate derivative of its stable restriction has norm at most
some `theta<1`. Its derivatives of each fixed higher order have
uniform bounds from the smooth local stable-plaque geometry.

Induct on derivative order. In the chain rule for an additional
iterate, the highest derivative of the previous iterate occurs
linearly, multiplied by a first derivative of norm at most `theta`.
All other terms use lower derivatives already bounded by induction.
The recurrence `X_{m+1} <= theta X_m+C_j` gives a uniform bound.
The finitely many remaining iterate residues have uniform fixed-order
bounds as well. This proves all fixed-order bounds for the maps
`s -> f^i s` on uniform local stable plaques, uniformly in `i`.

For ambient iterates in either time direction, represent a centered
jet of fixed order `r` by its substitution matrix on polynomials of
degree at most `r`. One-step matrices are uniformly bounded on the
compact quotient. Products give `C_r exp(K_r n)` bounds. Here
`K_r` is allowed to depend on `r`.

If `D_0` has intrinsic distance `d>0` from the relative complement of
`D_1`, contraction of stable path lengths shows that every intrinsic
ball of a fixed radius less than `d/C` around a point of `f^{-n}D_0`
lies in `f^{-n}D_1`. Indeed its image under `f^n` stays within distance
`d` of `D_0`. This is the uniform interior room used subsequently.

## 2. Bounded jets in every fixed-radius stable disk

Fix a parameter jet order `k` and radius `rho>0`. Cover the compact
quotient by finitely many inner product boxes, with slightly larger
outer boxes whose stable crossing plaques have intrinsic diameter
less than `rho/2`. The complementary foliations are strong stable
and weak unstable, not two transverse strong foliations.

On almost every weak unstable crossing, all finitely many required
coefficient fields have smooth representatives on a compactly
contained whole crossing. Their suprema are finite measurable
functions of the crossing label. Some positive-measure family of
labels therefore has a common finite bound. In product coordinates,
almost every stable crossing meets that family in a positive
conditional-measure set. Almost-everywhere agreement with the regular
data removes only a null subset of those intersections. Take the
maximum of the finitely many box bounds.

For precision about whole leaves, collect the exceptional stable
crossings and the disagreement/nonregular sets into an ambient null
set in each box. Absolute continuity gives zero intrinsic measure
on the local stable plaques for almost every center. Impose this
condition at all integer iterates and use

\[
 W^s(a)=\bigcup_{r\ge0}f^{-r}W^s_{\rm loc}(f^r a).
\]

The resulting entire stable leaves meet every exceptional set in
intrinsic measure zero. A stable crossing in such a leaf cannot be
an exceptional crossing, since that would contribute an open leaf
piece of positive intrinsic measure.

Now consider any radius-`rho` disk, even one centered at a
nonregular point. Choose a nonexceptional point in its inner half.
An inner box containing it has its whole outer stable crossing
inside the disk, by the diameter bound. That crossing contains an
agreeing regular point with the prescribed jet bound. Countably many
`k` and integer translates can be imposed simultaneously. Lift the
same finitely many boxes to obtain the identical assertion upstairs.
This proves `real:good-points` from the recorded inputs.

Temporal recurrence by itself would not give these spatial samples.
The indispensable extra input here is whole **weak unstable**
coherence plus the local product measure class. No frequency estimate
for visits, and in particular no use of `real:returns`, is needed in
the decay argument.

## 3. Why the naive growth exponent does not depend on derivative order

Fix `k`. For `i=0,...,n-1`, the centered one-step inverse map from
the chart at `f^{i+1}s` to the chart at `f^i s` has a substitution
matrix on the fixed finite-dimensional space of polynomials of
degree at most `k`. Use matching intermediate geometric frames.
These matrices have norm at most `M_k>=1`.

Their order-`j` derivatives as functions of `s` involve uniformly
smooth one-step coefficients composed with `f^i` along a stable
plaque. Section 1 bounds those derivatives, for every fixed `j`,
uniformly in `i,n`. The terminal `k`-jet of the formal input map
over the fixed compact outer base patch is smooth with bounded
fixed-order stable derivatives. Composition with `f^n` preserves
that property.

Differentiating a product of `n` matrices `j` times affects at most
`j` factors, in at most `C_j(n+1)^j` ways. Each differentiated factor
has a fixed-order bound; the other factors contribute at most
`M_k^n`. Thus, also including the bounded terminal data,

\[
 \lVert D_s^jG_{n,k}\rVert
  \le C_{j,k}(n+1)^jM_k^n
  \le C'_{j,k}e^{A_kn},\qquad A_k=\log M_k+1.     \tag{2}
\]

The elementary bound `(n+1)^j <= C_j exp(n)` holds separately for
each fixed `j`; it does not assert a bound on `C_j` as `j` varies.
Only geometric coefficients are differentiated. There is no
differentiation of a merely measurable coordinate change.

An estimate with an arbitrary order-dependent exponent `A_{j,k}`
would not suffice for the later argument: sending the Taylor or
interpolation order to a large fixed value would then also change
the exponential cost being overcome. Equation (2) is stronger and
is justified by this fixed-dimensional product structure.

## 4. Densification and high-order interpolation

### 4.1 Spatial samples

For fixed `k`, finite-jet equivariance and the fixed-order ambient
iterate bounds give a finite `D_k>=0` such that jets initially
bounded through parameter degree `k` have bounds
`C_k exp(D_k r)` after `r` forward steps. The finite chain rule
uses only finitely many output jets of `f^r` and inverse linear
input maps. It does not involve any stable interpolation order.

Choose any fixed `0<epsilon<=1` and let `r=floor(epsilon n)`.
For a target point `s` in an inner moving patch, Section 2 supplies
a bounded-jet regular point within distance `rho` of `f^{-r}s`.
Its forward image `s'` satisfies

\[
 d_s(s,s')\le C\rho e^{-b_sr}
              \le C_\epsilon e^{-b_s\epsilon n}.
\]

For large `n`, this image lies in the slightly larger moving patch
where coefficients are being estimated. At it, the input
`df^{-n}Y(f^n s')` has norm at most `C_Y exp(-b_u n)`, since it
is an actual unstable input. Homogeneity of parameter degree `k`
in `real:pulled-jet` gives

\[
 |G_{n,k}(s')|\le
 C_{k,\epsilon}\exp[-(b_uk-D_k\epsilon)n].         \tag{3}
\]

Consequently the sample points are a uniform
`O(exp(-b_s epsilon n))` net. It is harmless to use the weaker
mesh `O(exp(-b_s epsilon n/4))`, as in the manuscript. This weaker
mesh is the one used in the formal rate certificate.

### 4.2 Perturbed unisolvent stencils

Fix any positive integer `p` and the stable dimension `d`.
Choose a tensor-product grid of `p` distinct nodes in each
coordinate of a small cube contained in the unit ball. Evaluation
is invertible on polynomials of separate degree less than `p`,
by the one-dimensional root bound, one coordinate at a time.
The total-degree-`<p` Taylor polynomial is in that space.

At a target point `x`, scale this grid by
`t_n=exp(-b_s epsilon n/8)`. Replace each grid point by a nearby
sample point. The relative perturbation is
`O(exp(-b_s epsilon n/8))`, tending to zero. The finite evaluation
matrix therefore remains invertible, with a uniformly bounded
inverse: its entries depend continuously on the normalized nodes,
its unperturbed determinant is nonzero, and inversion is continuous
there. The required starting time can depend on `p,k,epsilon`;
there is no bound uniform in `p`.

Expand `G_{n,k}` at `x` to total order `p-1`. The Taylor remainder
at every perturbed node is at most
`C_p t_n^p ||G_{n,k}||_{C^p}`. The bounded inverse evaluation
matrix recovers the Taylor polynomial's constant coefficient
from those values. Using (2) and (3) yields

\[
 \lVert G_{n,k}\rVert_{C^0}
 \le C_{p,k,\epsilon}\left[
   e^{-(b_uk-D_k\epsilon)n}
   +e^{(A_k-b_s\epsilon p/8)n}\right].             \tag{4}
\]

The moving patches have the uniform room established in Section 1.
All finitely many smaller `n` can be included by increasing the
constant: each corresponding compact coefficient field is smooth.
This proves the analytic sampling hypothesis of `uniform_jet_decay`
for **every** fixed `p`, rather than merely testing several orders.

### 4.3 Interior derivative interpolation

On nested coordinate balls, Taylor expansion to order `q-1` on a
fixed unisolvent grid of radius `t` recovers each order-`j` derivative
with the bound

\[
 |D^j u(x)|\le C_{j,q}
   (t^{-j}\lVert u\rVert_{C^0}
                   +t^{q-j}\lVert u\rVert_{C^q}),
       \qquad 0<t\le t_0,\quad 0<j<q.
\]

Take `t=(U/V)^{1/q}` when at most `t_0`, where `U=||u||_C0`
and `V=||u||_Cq`; otherwise take `t=t_0`. If `U=0` all
derivatives vanish; if `V=0` the assertion is immediate. The
second case has `V<U/t_0^q`, which bounds both terms by a
constant times `U`. Thus

\[
 \lVert D^j u\rVert_{C^0}\le C_{j,q}
       (U^{1-j/q}V^{j/q}+U).                     \tag{5}
\]

If `U<=C exp(-beta n)` and `V<=C_q exp(A_k n)`, (5) gives
the rate `beta(1-j/q)-A_k j/q`, plus the value-rate term.
Order zero satisfies the same upper-bound format directly.
Nested patches can be used so that `U` is taken on an
intermediate patch and the derivative on the inner patch.
Uniform tensor frames only change prefactors.

### 4.4 All orders and a single degree-proportional rate

Fix `0<eta<1`, put `B=b_u k`, and select

\[
 \epsilon=\min\{1,\eta B/[4(D_k+1)]\}>0.
\]

Then `D_k epsilon <= eta B/4`. Choose a positive integer `p` with

\[
 b_s\epsilon p/8\ge A_k+(1-\eta/2)B .
\]

Equation (4) gives the value rate `beta=(1-eta/2)B`.
For a prescribed `j`, select an integer `q>j` with

\[
 j(A_k+\beta)\le (\eta B/2)q .
\]

Such integers exist because the denominators are strictly positive.
Equation (5) now has derivative decay rate at least `(1-eta)B`.
Taking `eta=1-c/b_u` proves (1).

This order of choices is important: first `k` and a target fractional
loss, then `epsilon`, then `p`, then `q`. Neither `B_p` nor `D_p`
enters the sample estimate; samples used jets only through `k`.
The exponent `A_k` stays fixed when `p,q` increase. This resolves
the apparent dependence on arbitrarily high bounded-jet samples.

## 5. Smooth actualization by fixed finite cutoffs

Fix any one `0<c<b_u`, a compact parameter set, and nested compact
base patches. Constants below can depend on a fixed cutoff `R`.
Write `s=f^{-n}a` and

\[
 V_{n,R}(s,y)=\sum_{k=1}^R G_{n,k}(s)[y^{\otimes k}],
 \qquad F_{n,R}(a,y)=f^n\exp_s V_{n,R}(s,y).
\]

By (1), every fixed-order `(s,y)` derivative of `V_{n,R}` is
`O(exp(-cn))`; a derivative in `y` changes finite polynomial
constants, not the exponential weight of its coefficient.

### 5.1 Consecutive cutoffs and the continuous limit

The centered one-step map
`Psi_{f^{-1}s}(z)=log_s(f(exp_{f^{-1}s}z))` is uniformly smooth
and fixes zero. Exact formal equivariance says that the
parameter-degree-`<=R` part of `Psi(V_{n+1,R})` is `V_{n,R}`.
Taylor expand `Psi` in its spatial variable through order `R`.
Its remainder is `O(|V_{n+1,R}|^{R+1})`, hence
`O(exp(-c(R+1)n))`. In the finite polynomial part, every
discarded parameter monomial has original total degree at least
`R+1`. The product of its coefficient weights is
`exp(-c(k_1+...+k_m)n)`, so has the same bound.
No assertion of convergence of the formal series is used.

If `Lip(f^n)<=C exp(A n)`, with `A` independent of `R`, then

\[
 d(F_{n+1,R},F_{n,R})
       \le C_R e^{-\alpha_R n},\qquad
       \alpha_R=c(R+1)-A.                       \tag{6}
\]

For every sufficiently large fixed `R`, this is summable uniformly
on the compact domain. Completeness of the target gives a uniform
continuous limit. For two fixed cutoffs `R'>R`, their backward
difference is the finite sum of degrees `R+1,...,R'`. Its forward
distance is `O(exp(-alpha_R n))`. Thus all sufficiently large
fixed cutoffs have the **same** continuous limit `F`. This
comparison never takes `R` to infinity inside a formal series.

### 5.2 Smoothness and arbitrary forward rates

For each fixed `q`, the base substitution `s=f^{-n}a`, geometric
exponential, and outer map `f^n` have fixed-order exponential
derivative costs. The chain rule and the bounds on `V_{n,R}` give

\[
 \lVert F_{n,R}\rVert_{C^q}\le C_{R,q}e^{B_q n}, \tag{7}
\]

where `B_q>=0` is independent of `R`. The number of chain-rule
factors is controlled by `q`; derivatives of the finite polynomial
`V_{n,R}` have constants depending on `R` but no growing
exponential rate depending on it. This is precisely where a
cutoff-dependent exponential cost would break the proof.

The continuous limit allows finitely many fixed output charts on
smaller compact parameter/base neighborhoods. For large `n`,
both consecutive approximants lie in each applicable common chart.
Apply (5) to their coordinate difference, using (6) on a slightly
larger domain and (7) at order `q>j`. The rate is

\[
 (1-j/q)\alpha_R-(j/q)B_q.                      \tag{8}
\]

For `j>0` one can fix `q=2j`. Then (8) equals
`[c(R+1)-A-B_{2j}]/2`, and exceeds any requested `L>0`
when a sufficiently large **fixed** `R` is selected.
For `j=0`, use (6) directly. Summing the resulting geometric
tails proves smooth convergence at every fixed order and

\[
 \lVert F-F_{n,R}\rVert_{C^j}\le C_{R,j,L}e^{-Ln}.
                                                               \tag{9}
\]

Each order may use a different fixed cutoff, but the limit is
already the common continuous limit, so these are derivatives of
one map, not separate order-dependent realizations.

For every parameter Taylor order `m` and `R>=m`, the order-`m`
jet of `F_{n,R}` at zero equals the prescribed formal jet of
`mathcal F`, by formal equivariance. Use (9) in `C^m`, choosing
an additional sufficiently large fixed `R`, to identify the Taylor
series of `F`. In particular `F(a,0)=a` and `D_yF(a,0)=Y(a)`.

### 5.3 Backward estimates and actual unstable leaves

Let `Lip(f^{-n})<=C exp(K_1 n)`. In (9), first choose a
forward rate `M>K_1+c`. Then `f^{-n}F` lies within
`O(exp(-(M-K_1)n))` of `exp_s V_{n,R}`. Since
`V_{n,R}=O(exp(-cn))`, both points lie in a fixed uniform
based-logarithm ball for every sufficiently large `n`.

On this small neighborhood, the fixed-order derivatives of

\[
 \Lambda_n(a,x)=\log_{f^{-n}a}(f^{-n}x)
\]

have at most exponential growth, including derivatives of their
base. For a `C^j` difference estimate, integrate `D_x Lambda_n`
along the segment between the two nearby outputs in a common
output chart. The segment remains in the logarithm domain by the
same Lipschitz estimate. Differentiation uses derivatives of
`Lambda_n` through order `j+1` and finitely many derivatives
of `F,F_{n,R}`. By (7), their total exponential cost is
`C_{R,j} exp(H_j n)` with `H_j` independent of `R`.
Consequently (9), now with a larger rate than `L+H_j`, gives

\[
 \left\|\log_{f^{-n}a}(f^{-n}F(a,y))
       -V_{n,R}(f^{-n}a,y)\right\|_{C^j(a,y)}
       \le C_{R,j,L}e^{-Ln}.                    \tag{10}
\]

There is no circular assumption that the backward logarithm is
defined: the `C^0` argument precedes its differentiated use.

For one sufficiently large fixed cutoff, (10) gives
`d(f^{-n}F(a,y),f^{-n}a)<=C exp(-cn)` for **all** large
integers `n`, not just a recurrent subsequence. Thus the whole
further backward tail is in a uniformly small local neighborhood.
The recorded unstable-manifold characterization puts both points
in a local strong unstable plaque at sufficiently negative time.
Invariance gives `F(a,y) in W^u(a)`.

### 5.4 Intrinsic compatibility and all finite parameters

A geometric displacement-chart change fixes zero and is uniformly
smooth. Taylor expansion through a sufficiently large fixed order
has a remainder with exactly the degree-weight bound in (6).
After forward transport that remainder vanishes. Therefore the
limit is independent of displacement charts.

On an overlapping base patch, a frame change is a smooth invertible
linear substitution in the same initial vector. The finite
parameter truncations transform by that substitution; the limits
agree. Shifting the backward sequence by one step and using the
same formal one-step comparison proves equivariance under `f`.
These statements concern the constructed truncation limit, not
uniqueness among all smooth maps with the same Taylor series.

The construction and comparisons work on every enlarged compact
parameter set and every compactly contained base patch. Agreement
on intersections glues the limits for all finite `y`. No uniform
bound as `|y|` or `R` tends to infinity is used or needed. This
establishes all assertions of `real:actualization`.

## 6. What the machine evidence does and does not establish

`Main.lean` proves an all-natural-order theorem
`RecurrentJetDecay.uniform_jet_decay`. Its two analytic hypotheses
are exactly (4) and the exponential consequence of (5). Sections
1-4 justify those hypotheses from the stated geometric and formal
inputs. The compiler theorem includes quantified constants and
all natural times, not only exponent arithmetic at sampled orders.
It also proves arbitrary finite-list degree-weight multiplication
and the existence of fixed cutoffs achieving any requested rate.
See `statement_fidelity.md` for the exact separation of obligations.

The sole bounded Jacobian operation was
`polynomial.interpolation.hermite.compute` on rational nodes
`-1,1/8,1`, with values `1,73/64,3`. It returns
`x^2+x+1`. None of the sample nodes is the target zero.
This is an exact replay of a perturbed interpolation stencil, not
evidence that finitely many stencil orders prove Section 4.
The operation id, contract, input, server/protocol versions, and
typed answer are retained separately in the `jacobian_*.json`
files. A failed or unknown adapter answer would not support the
theorem.

`verify.py` replays that answer with rational arithmetic and checks
the source-bound official Lean certificate, its zero-hole compiler
answer, and the mathematical scope of `exact_certificate.json`.
With `--compile`, it additionally obtains a fresh official
compiler answer for `C_RJD_FORMAL` and runs both official
campaign-local structural checks. The analytic proofs above
remain human mathematics requiring independent review; a script
checking their presence is not presented as a proof checker.

## 7. Consequence for the main proof graph

The graph now records the main theorem's path through entropy
forms, normal forms, hull coherence/measurability, symmetries,
the algebraic dichotomy, exclusion of the infinite alternative,
smooth splitting in the finite alternative, and classical
rigidity. The present theorem addresses only the quantitative
bridge used in the infinite alternative. In particular:

* `real:stable-tangency` still uses formal parallelism, finite normal
  extensions, and good backward returns, beyond actualization.
* `real:infinite-excluded` also needs the complete proper stable ray
  and the ideal-boundary contradiction.
* The earlier whole-axis hull and algebra constructions and the
  separate Section 7 smoothness argument are not established by
  this certificate.

Those nodes remain open and no Reviewer confirmation is assigned.
A conditional verification of the quantitative bridge must not be
reported as a proof of Katok's conjecture, an independently reviewed
campaign completion, or verified novelty.
