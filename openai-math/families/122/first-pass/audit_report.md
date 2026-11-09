# Positive-moment multiscale transport

## Scope and source facts

The target is Proposition `prop:multiscale` in the staged October 5, 2026
*Uniform quasipolynomial-time trace reconstruction*, together with its
conversion in `contour.tex`. The definitions are those in `setup.tex`,
equations `eq:moment-matrix`, `eq:feature`, and `eq:signal`. In particular,
the comparison functional is a truncated Boolean positive moment
functional, not necessarily a distribution. The discrepancy vanishes on
every polynomial supported strictly before the first wrong bit `d`.
All degrees below are Boolean-reduced degrees.

The manuscript already asserts the loss `7.98`, order increase at most
four, height bound `H_f^4(1+1/(beta S'))^3`, and the stated factorization
of each new gap parameter. Verifying Gram chaining alone would not
verify that proposition. A floating-point Gram matrix not realized by
the stipulated polynomial functional would not refute it. Neither would
a finite search without a witness.

The external comparator is Burudgunte--Valiant--Wang,
*Quasipolynomial Trace Reconstruction*, arXiv:2607.04073v1, Section 1.
The primary HTML source was obtained and read at
<https://arxiv.org/html/2607.04073v1>. Its displayed introduction theorem
gives `exp(p^(-7/3) (log_2 n)^c)` samples. The relevant limitation is stated
explicitly there:

> However it is unclear whether there is an adaptation of our approach
> that additionally has quasipolynomial running time.

This comparator is background, not a lemma used in the proof below.
No external trace-reconstruction or optimization theorem is assumed.
The local wiki search found no prior page settling this multiscale
positive-moment proposition. This is a scope result, not a novelty claim.

## 1. The strengthened universal theorem

Let `n,k,D` be positive integers, `d in [n]`, and `x` a Boolean string.
Let `Ecal` be a normalized real Boolean moment functional through degree
`2D`, fixing a prefix which agrees with `x` before `d` and disagrees at
`d`. Assume `Ecal[P conjugate(P)] >= 0` for every polynomial of degree
at most `D`. Write `Delta[P]=Ecal[P]-P(x)`. For positive `a_h`, real
`theta_h`, and `z_h=exp(-a_h+i theta_h)`, put

\[
 f_j=\sum_{i_1<\cdots<i_k=j}X_{i_1}\cdots X_{i_k}
             \prod_{h<k}z_h^{i_{h+1}-i_h},\qquad
 H=\prod_{h<k}(1+1/a_h),
\]
\[
 {\cal S}_f(s,\omega)=\sum_j\Delta[f_j]e^{(-s+i\omega)(j-d)}.
\]

**Theorem A.** The complete conclusion of the manuscript's
`prop:multiscale` holds with loss **7.84** instead of **7.98**, under
the weaker degree hypothesis **`2k <= D`**. One choice of constants is

\[
 K=2^{16},\quad \beta=2^{-48},\quad \eta_0=2^{-96},\quad
 C_0=2^{48},\quad C_1=2^{15}.
 \tag{1}
\]

Explicitly, suppose

\[
0<S\le4,\quad 0<S'\le\min(1,\eta_0 S),\quad 2k\le D,\quad
\beta S\le s\le S,\quad |\omega|\le2.002s,
\]
\[
|{\cal S}_f(s,\omega)|\ge e^{-E},\qquad
E\ge C_0\{1+k\log(2k)+\log H+\log(1/S')\}.
\tag{2}
\]

There is an order-`k'` feature, `1 <= k' <= 4k`, for which

\[
 |{\cal S}_{f'}(s',\omega')|\ge e^{-7.84E},\qquad
 \beta S'\le s'\le S',\qquad |\omega'|\le2.002s',
 \qquad H_{f'}\le H^4(1+1/(\beta S'))^3.                 \tag{3}
\]

Moreover, for some `1 <= m <= 4`, each new inner parameter is a
nonempty product of at most one entry from each of `m` copies of the old
parameter list or its conjugate, and at most one of at most `m-1`
added parameters. Every added parameter `exp(-a+i theta)` has
`a >= beta S'` and `abs(theta) <= C_1 S`.

The theorem quantifies over all finite `n`, all admissible arrays and old
parameters, and every allowed scale. There is no distribution-realizability
or nonsingularity hypothesis. If `k>n`, the signal hypothesis is impossible.
The original proposition follows since `4k<=D` implies `2k<=D` and
`e^(-7.84E) >= e^(-7.98E)`.

## 2. Moment facts and explicit logarithmic accounting

For completeness, write the unfixed bits as `(1+Y_i)/2`, with
`Y_i^2=1`. For any sign monomial of degree at most `2D`, partition its
support into two sets of size at most `D`. The corresponding `2 by 2`
principal moment submatrix has diagonal entries one. Positivity gives
an absolute moment bound of one. Expanding bit monomials as averages of
sign monomials therefore gives

\[
 |\Delta[P]|\le2\sum_A|c_A|
 \quad\text{for }P=\sum_Ac_A X_A,\quad\deg P\le2D.       \tag{4}
\]

The form `<P,R>=Ecal[P conjugate(R)]` on degree-at-most-`D`
polynomials is positive semidefinite Hermitian. Its null space is
orthogonal to everything by Cauchy--Schwarz; the quotient is a finite
dimensional complex Hilbert space. This uses exactly truncated positivity.
In particular, no inequality for an unobserved, higher-degree polynomial
will be used.

Set

\[
 T=1+k\log(2k)+\log H+\log(1/S'),\quad
 \sigma=K\sqrt E/S',\quad b=\beta S',\quad
 U=8H(1+\sigma),\quad V=2H^4(1+1/b)^4.
\]

Here `T>=1` and `E>=2^48 T`. The elementary inequality
`log E <= 2 sqrt(E)` gives

\[
 \log E\le2^{-23}E,\qquad
 512T+2\log E<10^{-6}E.                               \tag{5}
\]

These are uniform in `E`, including arbitrarily large `E`.
The following specific prefactors all have logarithm at most the left
side of (5):

\[
 2U,\quad 2UJ^2\ (1\le J\le10/b),\quad
 N\ ((N\le(4k)^{4k})),\quad V,\quad
 6H(1+1/b),\quad 2^{23}.                              \tag{6}
\]

For example `log(2U)<=22T+(log E)/2`,
`log J<=52+log(1/S')`, `log N<=8k log(2k)`, and
`log V<=201T`. We used `log 2<1`, `S'<=1`, and
`1+1/b<=2^49/S'`. Thus (5), not an unspecified absorption of
constants, pays for every prefactor below. In particular, `E>=10000`.

## 3. Windowing and the logarithmic signal

Put `W(l)=exp(-l^2/(2 sigma^2))` and

\[
 A(t)=\sum_j f_j W(j-d)e^{it(j-d)},\quad B(t)=A(t)(x),
 \quad P(z)=\sum_{j\ge d}\Delta[f_j]W(j-d)z^{j-d}.
\]

Coefficient sums, (4), and
`sum_{l in Z} W(l) <= 1+sqrt(2 pi) sigma <= 1+3 sigma`
give `abs(B(t)), abs(Ecal[A(t)]), abs(P(e^{it})) <= U`.
The Gaussian-sum estimate follows by bounding each decreasing tail by
its integral. Prefix cancellation is why `P` has only nonnegative powers.

Let `Z` be a real centered Gaussian of variance `sigma^-2`. The exact
Gaussian moment generating function gives

\[
 {\cal S}_f(s,\omega)
       ={\bf E}\,P(e^{-s+Z+i\omega}).
\]

Take `delta_w=10^-4`. Exponential tilting shows that the contribution
with `abs(Z)>delta_w s` has magnitude at most

\[
 2H(1+1/s)
 \left\{2e^{-\delta_w^2s^2\sigma^2/8}
                 +e^{-\delta_w s^2\sigma^2/2}\right\}. \tag{7}
\]

Indeed, for `0<=l<=delta_w s sigma^2/2` the tilted normal has mean
`l/sigma^2`; the two Gaussian tail estimates are each bounded by
`exp(-delta_w^2 s^2 sigma^2/8)`. For larger `l`, bound the tilted
probability by one and sum `e^(-sl)`. The geometric factor is at most
`1+1/s`. These estimates also prove (7) for a finite polynomial of any
degree, without an `n`-dependent prefactor.

By (1)--(2),

\[
 s^2\sigma^2/E\ge\beta^2K^2/\eta_0^2=2^{128}.
\]

Both decay coefficients in (7) exceed `100E`, whereas its prefactor
is at most `6H(1+1/b)`. Equations (5)--(6) make (7) less than `e^(-2E)`.
Consequently, continuity on the compact interval `abs(Z)<=delta_w s`
gives some `s_1` with

\[
 |s_1/s-1|\le10^{-4},\qquad
 |P(e^{-s_1+i\omega})|\ge\tfrac12e^{-E}.                \tag{8}
\]

Define `Lambda(t)=log(U/abs(P(e^{it})))`, with the usual infinite
value at a zero. This is nonnegative. It has the bound

\[
 \int_{\mathbb R}\Lambda(t)
 \frac{s_1\,dt}{\pi(s_1^2+(t-\omega)^2)}
 \le E+\log(2U)\le1.0001E.                            \tag{9}
\]

Here is the analytic justification, including the sign. Closing the
contour of `e^{i xi z}/(pi(1+z^2))` in the decaying half plane gives
Fourier transform `e^{-abs(xi)}`. Thus the periodized Cauchy density
is circle Poisson measure at `e^{-s_1+i omega}`. Factor `P`.
An exterior root gives a harmonic logarithm. For an interior root `a`,

\[
 |1-\bar a z|^2-|z-a|^2
                  =(1-|a|^2)(1-|z|^2)\ge0
\]

shows that the interior log magnitude is at most its boundary Poisson
average. Boundary roots follow by radial approximation; their logarithmic
singularities are integrable. Sum the factors and use (8). This proves
(9); it is an inequality in the needed direction, not an equality
requiring `P` to be zero-free. The verifier checks the displayed root
identity as a polynomial in four arbitrary real coordinates.

## 4. Cauchy matching with enough quantitative mass

Write `w(v)=1/(pi(1+v^2))`. For every `r>0` there is a positive measure
on pairs `v-v'=r` whose two marginals have sum at most `w(v)dv`
and whose mass is `M(r)/2`, where

\[
 M(r)=1-\frac4\pi\arctan(e^{-\pi/r}).                  \tag{10}
\]

Here is a direct construction. Split the real line into chains
`v+jr`, `-r/2<=v<r/2`. On the edge from `j` to `j-1`, `j>=1`,
put the alternating tail
`e_j=sum_{h>=0}(-1)^h w(v+(j+h)r)`. The summands decrease, so this
is nonnegative and `e_j+e_{j+1}=w(v+jr)`. Do the same from the
negative tail. Only the vertex at `v` can be left uncovered.
Its remainder is

\[
 R(v)=\sum_{j\in\mathbb Z}(-1)^j w(v+jr)
 =\frac2r\sum_{h\ge0}\tau^{2h+1}
                       \cos((2h+1)\pi v/r),\quad\tau=e^{-\pi/r}.
\]

The Fourier series follows from the Cauchy transform above and is
absolutely convergent. For `a=pi v/r`, the last sum equals

\[
 \frac{\tau(1-\tau^2)\cos a}
             {1-2\tau^2\cos(2a)+\tau^4}\ge0 .
\]

Thus the central capacity is not overused. Integrating the remainder
over the central cell gives `(4/pi) atan(tau)`, proving (10).
Orient edges from larger to smaller endpoint. At `r=0`, use half the
Cauchy measure on the diagonal. Reversing orientation treats negative
differences. This proves an actual matching measure, not just a
lower bound on overlap of two densities.

Our exact numerical bounds are

\[
 \frac{\arctan(2-2.003)+\arctan(2+2.003)}{\pi}>0.421,
 \qquad M(2)>0.739.                                  \tag{11}
\]

They are certified without floating point. The alternating arctangent
series and `pi=16 atan(1/5)-4 atan(1/239)` enclose `pi` between
`3.14159` and `3.14160`. The positive degree-20 exponential partial
sum proves `exp(-pi/2)<2079/10000`. Substituting these rational
bounds in the arctangent expressions proves (11). The remainders have
their alternating-series signs: integrate the finite geometric-series
identity for `1/(1+x^2)` to obtain them. Machin's identity follows from
the tangent addition formula with both angles in their specified
quadrants.

We have `abs(omega)/s_1<=2.002/0.9999<2.003`. The Cauchy mass of
`[-2s_1,2s_1]` is minimized at the extreme allowed center; (9)--(11)
therefore give a frequency

\[
 |\lambda|\le2s_1,\qquad\Lambda(\lambda)\le2.376E,       \tag{12}
\]

since `1.0001/0.421<2.376`.

For every `abs(y)<=2s_1`, apply the matching construction at
`r=abs(y)/s_1`, then put `t=omega+s_1 v`. Discard pairs with either
endpoint outside `[-4096s_1,4096s_1]`. Their mass is at most the
Cauchy tail, which is at most

\[
 \frac{2}{\pi(4096-2.003)}.
\]

Thus twice the retained pair mass is greater than
`0.739-4/(pi(4096-2.003))>0.738`. Its integral of
`Lambda(t)+Lambda(t')` is at most `1.0001E` by marginal domination.
There are consequently pairs satisfying

\[
 t-t'=y,\quad |t|,|t'|\le4096s_1,\quad
 \Lambda(t)+\Lambda(t')\le2.711E,                      \tag{13}
\]

because `2(1.0001)/0.738<2.711`. The same argument applies on the
diagonal for `y=0`. There is no measurability-of-selection issue:
only finitely many of these pairs will be selected.

## 5. The positive-moment step and the degree improvement

Call a product of one to four `A(t)` or `conjugate(A(t))` balanced if
every individual frequency has magnitude at most `C_3 S`, where
`C_3=8192`, and its signed frequency sum has magnitude at most `b`.
All frequencies in (12)--(13) satisfy this individual bound.

**Balanced-product claim.** Some such product `G` has

\[
 |\Delta[G]|\ge e^{-7.81E}.                            \tag{14}
\]

Suppose not, and set `epsilon=e^(-7.81E)`. Each `abs(A(t))^2` is a
balanced product. Cauchy--Schwarz against the constant polynomial gives

\[
 |\mathcal E[A(t)]|^2\le\mathcal E[|A(t)|^2]
                \le |B(t)|^2+\epsilon,\qquad
 |\Delta[A(t)]|\le2|B(t)|+\sqrt\epsilon.               \tag{15}
\]

The signals at (12) and (13) obey, respectively,
`abs(Delta[A(lambda)])>=exp(-2.376E)` and

\[
 |\Delta[A(t)]\Delta[A(t')]| \ge e^{-2.711E}.
\]

Each individual paired signal is also at least `e^(-2.711E)`,
because `Lambda>=0` and `U>=1`. Since
`sqrt(epsilon)=e^(-3.905E)`, (15) makes every relevant evaluation at
least one third of its signal. Using `E>=10000` to pay factors three
and nine gives

\[
 |B(\lambda)|\ge e^{-2.377E},\qquad
 |B(t)\overline{B(t')}|\ge e^{-2.712E}.                \tag{16}
\]

Choose a monotone chain from `0` to `lambda`, with steps at most `b`
and `1<=J<=10/b`. For `lambda=0`, use `J=1` and the same two
endpoints. At each interior chain label `y_i`, use (13) and form

\[
 V_0=1,\quad
 V_i=\frac{A(t)\overline{A(t')}}{B(t)\overline{B(t')}}
       \ (0<i<J),\quad V_J=A(\lambda)/B(\lambda).
\]

They have evaluation one at `x` and degree at most `2k`. Thus they
are legitimate vectors in the Hilbert quotient as soon as `2k<=D`.
Their norm squares and neighboring inner products are normalized
balanced products of at most four factors. Their moments use degree
at most `4k<=2D`, and every normalization denominator has magnitude
at least `e^(-5.424E)`. Hence

\[
 |\|V_i\|^2-1|,\quad
 |\langle V_i,V_{i-1}\rangle-1|
      \le \xi:=e^{-(7.81-5.424)E}=e^{-2.386E}.         \tag{17}
\]

Here is the needed stability argument, without an assumption about Gram
matrix realizability beyond the already constructed vectors. If
`h_i=V_i-V_{i-1}`, (17) gives
`norm(h_i)<=2 sqrt(xi)` and
`abs(<h_i,V_{i-1}>)<=2xi`.
The triangle inequality gives
`norm(V_{i-1}-V_0)<=2(i-1)sqrt(xi)`. Cauchy--Schwarz then gives
`abs(<h_i,V_0>)<=(4i-2)xi`. Summing yields

\[
 |\langle V_J,V_0\rangle-1|\le2J^2\xi.
\]

Consequently

\[
 |\Delta[A(\lambda)]|
 \le2UJ^2e^{-2.386E}
 \le e^{-(2.386-10^{-6})E}<e^{-2.376E},
\]

contradicting (12). This proves (14).

This also locates the improved degree requirement exactly: vector degree
is `2k`, whereas the product degree is `4k`. The functional is supplied
through degree `2D`, not merely `D`. There is no step requiring `D>=4k`.

## 6. The signed contour, including absolute convergence

Fix a balanced product with `m` factors, `1<=m<=4`. Expand its old
tuples and partition all assignments into their weak order types,
including ties. Relabel the copies within one such interleaving so
their endpoints satisfy `j_1<=...<=j_m`. Absorb conjugation into the
signed real frequencies `t_r` and conjugate the corresponding old
inner lists. The endpoint weight is

\[
 \prod_{r=1}^m W(j_r-d)e^{it_r(j_r-d)},\quad
 |t_r|\le8192S,\quad |\sum_rt_r|\le b.                 \tag{18}
\]

The Gaussian identity

\[
 W(l)=\frac{\sigma}{i\sqrt{2\pi}}
       \int_{-i\infty}^{i\infty}e^{\sigma^2v^2/2+vl}\,dv
\]

follows by writing `v=iu`; differentiating the Fourier Gaussian
integral in `l` and integrating by parts gives its ODE and its value
one at `l=0`.

For real `u_r`, put

\[
 \Omega=\sum_r(u_r+t_r),\quad
 \rho=500/1001,\quad
 v_r=b+iu_r\ (r<m),\quad v_m=-mb-\rho|\Omega|+iu_m.
 \tag{19}
\]

Shift the first `m-1` contours to `Re(v_r)=b`. For fixed other
coordinates, deform the last contour to the piecewise-linear graph
in (19). Along its horizontal closing segments at imaginary heights
`+/-T`, the real part of the Gaussian exponent is
`-c T^2+O(T)` for `c>0`, since `rho<1`. The position-dependent
exponential adds only `O(T)` for each fixed tuple. Thus the closing
integrals vanish. The integrands are entire, so there are no residues.
This proves the iterated deformation, including the corner at
`Omega=0`.

The resulting measure, after removing position-dependent factors, is

\[
 d\nu(u)=\left(\frac{\sigma}{\sqrt{2\pi}}\right)^m
       e^{\frac{\sigma^2}{2}\sum_rv_r^2}
       (1+i\rho\,\operatorname{sgn}\Omega)\,du.        \tag{20}
\]

In particular the sign is **plus**: division of
`dv_m=(-rho sgn(Omega)+i)du_m` by `i du_m` produces this factor.
Its absolute value is `sqrt(1+rho^2)<2`.

Set

\[
 \delta=1-4\rho^2>0,\quad c_1=\delta/2>1/1024,\quad
 C_4=3+(4+\rho)^2(1+8\rho^2/\delta).
\]

For `q=sum u_r^2`, the four-factor Cauchy inequality gives
`abs(Omega)<=2 sqrt(q)+b`. Hence

\[
 \sum_r(\Re v_r)^2
 \le3b^2+\{2\rho\sqrt q+(4+\rho)b\}^2
 \le(1-c_1)q+C_4b^2.                                 \tag{21}
\]

The last step is the exact nonnegative-square identity

\[
 (1-c_1)x^2+(C_4-3)b^2-\{2\rho x+(4+\rho)b\}^2
 =\frac\delta2
       \left(x-\frac{4\rho(4+\rho)}{\delta}b\right)^2.
\]

This is the delicate universal component formalized in `Main.lean`.
The strict four-factor coercivity is also certified there, for arbitrary
four real coordinates, not by testing a rational vector. Jacobian's
inertia computation independently confirms the fixed rational metric
`I-rho^2 11^T` is positive definite.

Let `alpha=C_4 K^2 beta^2/2<10^-6`. Equations (20)--(21) bound the
absolute density by

\[
 2\left(\frac{\sigma}{\sqrt{2\pi}}\right)^m
         e^{\alpha E}e^{-c_1\sigma^2q/2}.              \tag{22}
\]

For a fixed tuple, the remaining position factor is at most
`exp(C_n(1+sum abs(u_r)))` for a finite `C_n`. This is integrable
against (22), proving joint absolute convergence before interchanging
the finite tuple sums and the integrals.

Gaussian rescaling gives

\[
 \|\nu\|_{\rm abs}\le2c_1^{-m/2}e^{\alpha E}
       \le2^{21}e^{\alpha E}\le e^{0.001E}.            \tag{23}
\]

On the complement of `Ubox={max abs(u_r)<=S'/16}`, we have
`q>S'^2/256`. Split the Gaussian exponent in (22) into two equal
parts; rescaling the remaining half gives

\[
 \int_{Ubox^c}|d\nu|
 \le2^{23}\exp\{(\alpha-c_1K^2/1024)E\}
 \le e^{-20E}.                                      \tag{24}
\]

Indeed `c_1K^2/1024>30`, and (5)--(6) pay the fixed factor.
All estimates are uniform over interleavings, endpoint coincidences,
and individual frequencies satisfying (18).

## 7. Exact parameters and height for every interleaving

Put `c_r=v_r+i t_r`. The exact identity

\[
 \sum_rc_r(j_r-d)
  =\left(\sum_rc_r\right)(j_m-d)
    -\sum_{r<m}\left(\sum_{\ell\le r}c_\ell\right)(j_{r+1}-j_r)
 \tag{25}
\]

shows that the outer parameter is `-s'+i Omega`, with
`s'=b+rho abs(Omega)`. The added endpoint parameter on the link
from `j_r` to `j_{r+1}` is

\[
 \exp\left(-rb-i\sum_{\ell\le r}(u_\ell+t_\ell)\right).
 \tag{26}
\]

All its dampings are at least `b`. On `Ubox`,

\[
 |\Omega|\le(\beta+1/4)S',\quad
 \beta S'\le s'\le\{\beta+\rho(\beta+1/4)\}S'<S',
 \quad |\Omega|\le2.002s'.
\]

The angle in (26) has magnitude at most
`3(8192S+S'/16)<32768S`. These are actual real angles, not bounds
obtained by reducing angles modulo `2 pi`.

For the interleaving's distinct positions `i_1<...<i_v`, draw all
old inner edges and all consecutive endpoint links (26). Remove
zero-length endpoint loops. This multigraph is connected: each old
tuple is a path to its endpoint, and the links join those endpoints.
For each new gap, multiply the parameters on exactly the edges that
cross it. Splitting each old edge length into its crossed gaps proves
equality of weights. Connectivity ensures the product is nonempty.
The inner intervals of any one old tuple have disjoint interiors;
so do consecutive endpoint links. Therefore each new parameter uses
at most one entry per old/conjugate list and at most one added
parameter. This proves the full factor-count assertion, not just
positive total damping.

Ties cause no further coefficients: `X_i^r=X_i` for positive integer
`r`. Assigning arbitrary strictly increasing values to the distinct
positions of a fixed weak order type gives exactly one assignment
to its labeled old tuples. Thus the resulting sum is exactly a
feature of order `v`, `1<=v<=mk<=4k`, whose endpoint is `j_m`.
It is not a feature with an unaccounted positional restriction.

To bound its height, we need a distinct crossing edge for each new
gap. Here is a proof valid for every connected ordered multigraph.
Retain a spanning tree and form the square matrix with rows its
`v-1` edges, columns its `v-1` gaps, and entry one for crossing.
If `g` is in its kernel, set `y_1=0`,
`y_{a+1}=y_a+g_a`. The kernel equation says `y` has equal values
at both ends of each tree edge. Connectivity forces every `y` to
be zero, so the matrix is nonsingular. A nonzero determinant term
assigns distinct crossing edges to all gaps.

Give each edge occurrence damping `a_e>0`. Each merged-gap damping
is at least its assigned edge damping. Since `1+1/a` decreases,

\[
 H_{\rm new}
 \le\prod_{e\ {\rm assigned}}(1+1/a_e)
 \le\prod_{e\ {\rm present}}(1+1/a_e)
 \le H^m(1+1/b)^{m-1}
 \le H^4(1+1/b)^3.                                  \tag{27}
\]

This proof does not charge an old edge once for every gap it crosses.
For `v=1` both the height and the assignment are empty products, and
the argument still applies.

## 8. Completing the full universal signal estimate

There are at most `N<=(mk)^(mk)<=(4k)^(4k)` weak order types:
map each labeled old position to its rank among distinct positions.
Equations (19)--(27) give the exact identity

\[
 \Delta[G]=\sum_{\mathcal I}\int_{\mathbb R^m}
       {\cal S}_{f^{\mathcal I,u}}(s',\Omega)\,
                                      d\nu_{\mathcal I}(u). \tag{28}
\]

This identity is meaningful throughout `R^m`, not just on `Ubox`.
The coefficient sum of each new endpoint polynomial is bounded by
(27). For endpoints before `d`, its discrepancy is zero. Since
`s'>=b` everywhere, (4) and the geometric sum give the crucial
`n`-independent bound

\[
 |{\cal S}_{f^{\mathcal I,u}}(s',\Omega)|
 \le2H^4(1+1/b)^3\sum_{l\ge0}e^{-bl}\le V.           \tag{29}
\]

Thus no negative centered distance creates an uncontrolled contour
tail.

If every retained signal were smaller than `e^(-7.84E)`, then
(23)--(24), (28)--(29), and `log N,log V<=0.001E` would imply

\[
 |\Delta[G]|
 \le e^{-(7.84-0.001-0.001)E}
      +e^{-(20-0.001-0.001)E}
 =e^{-7.838E}+e^{-19.998E}<e^{-7.81E}.                \tag{30}
\]

The last strict inequality already holds for `E>=100`: both
differences from `7.81`, multiplied by 100, exceed one, and
`e^x>=1+x>2` then makes each relative term less than one half.
This contradicts (14). A retained interleaving and real vector
`u` therefore give (3), and Sections 6--7 give every other required
output condition. This proves Theorem A.

## 9. A structural loss criterion

The same argument gives a useful parameterized theorem, not a finite
experimental extrapolation. For `c>2` and `R>0`, define

\[
 F(R,c)=\frac{\arctan(R-c)+\arctan(R+c)}{\pi},\quad
 M(R)=1-\frac4\pi\arctan(e^{-\pi/R}).
\]

Both are positive.

**Theorem B.** For every fixed `c>2`, `R>0`, and

\[
 L>\frac1{F(R,c)}
       +2\max\left\{\frac1{F(R,c)},\frac2{M(R)}\right\},\tag{31}
\]

there are constants `beta,eta_0,C_0,C_1`, depending only on these
three fixed parameters, such that the complete multiscale theorem
holds with input and output sector constant `c`, loss `L`, and
degree requirement `D>=2k`. Order, height, and parameter-factor
conclusions are unchanged.

To prove it, first choose the relative window perturbation sufficiently
small that `F(R,c/(1-delta_w))` is as close to `F(R,c)` as needed.
Take the logarithmic prefactor loss small and the frequency truncation
large. The single deficit exponent can then be any `a>1/F(R,c)`,
and the pair deficit exponent any `p>2/M(R)`. Normalization costs
can be made arbitrarily small. Norm and neighboring-inner-product
denominators are at least `exp(-(2 max(a,p)+o(1))E)`.
Gram chaining therefore requires a balanced loss strictly larger
than `a+2 max(a,p)`; its polynomial chain length is paid by the same
`log(1/S')` term. This inequality also ensures that the square root
of the hypothetical balanced error is negligible compared with
both single and paired signals in the evaluation lower bound.
Choose the balanced loss strictly between `a+2 max(a,p)` and `L`.
Use slope `rho=1/c` in the contour. The condition
`c>2` is precisely `4rho^2<1`, so choose `K` first for the tail,
then `beta` sufficiently small for an arbitrarily small mass
exponent, then `eta_0` for the window and finally `C_0`. The
remaining gap to `L` pays the number of interleavings and uniform
signal bound. Every geometric and factor-count assertion in
Sections 6--8 is unaffected. This proves (31) with its stated
quantifiers.

In particular, for `c=2.002`, `R=2`, (11) gives

\[
 \frac1{F(2,2.002)}
 +2\max\left\{\frac1{F(2,2.002)},\frac2{M(2)}\right\}
 <\frac{1000}{421}+\frac{4000}{739}
 =\frac{2423000}{311119}<7.79.
\]

Thus Theorem B also permits loss `7.80` with constants chosen for
that loss; it does not assert that the explicit constants (1),
with our explicit intermediate budgets, certify `7.80`.
Theorem A supplies a separate entirely explicit `7.84` instance.

## 10. Exact and formal evidence; remaining review

Run the standalone arithmetic/algebra certificate with

```
$WORKSPACE/argus-live-update/.venv/bin/python research/verify.py
```

It uses only the standard library. The recorded replay passed:
the rational Cauchy margins, all explicit exponential budgets, ten
polynomial/sign identities, exact independent LDL replay of Jacobian's
metric, and all **24,496** specified weak interleavings. The finite
inventory is `1<=m<=4, 1<=k<=2`, together with `k=3,m<=2`.
It includes ties, empty old lists, and repeated endpoint links.
These are adversarial stress checks, not the proof for arbitrary `k`.

The script also constructs genuine nonrepresentable Boolean moment
arrays. For `N` sign bits, set every nonempty sign moment equal to
`-1/t`. On degree-at-most-`D` rows the moment matrix is
`(t+1)I/t - 11^T/t`, with `r=sum_{j<=D} binomial(N,j)` rows.
For `(N,D,t)=(4,2,11)` its eigenvalues are `1/11,12/11`;
for `(8,4,199)` they are `37/199,200/199`. Both are positive definite,
but their unique full Boolean signed measures give the all-plus atom
negative masses `-1/44` and `-7/6368`, respectively. Fixing an
additional first bit opposite to `x` supplies the exact wrong-prefix
context. These are valid non-distribution inputs to the theorem,
including a case satisfying the manuscript's original degree bound.
They are not counterexamples.

The inspected Jacobian operation was `matrix.inertia.compute`, through
the prescribed Argus adapter, server `0.14.0`, protocol `2025-11-25`.
Its full successful typed request/output and the earlier rejected
mirrored-coordinate request/error are retained in
`exact_certificate.json`. The rejection is an input-contract event,
not a mathematical conclusion. The accepted upper-triangular payload
has inertia `(4,0,0)`, independently replayed using rational LDL.

The official Lean 4.31.0 compiler and axiom audit both exited zero,
with `proof_holes=[]`. The immutable successful record is
`research/certificates/C_MULTI_ALG-dc4e48662ebfa9b9.json`.
The source and its fidelity document have not been edited since that
run. The first run failed only because real definitions were not
marked noncomputable; its inconclusive record is preserved by the
ledger. Lean establishes the universal contour algebra and endpoint
identities specified in `statement_fidelity.md`; it does **not**
establish the entire analytic theorem. Sections 2--9 are the universal
mathematical proof submitted for independent review.

The strongest directly relevant prior statement is the staged
manuscript's own `7.98` proposition with `D>=4k`. The improvement is
the explicit loss `7.84`, the halved degree threshold, and the
general criterion (31). This is not a new decoder implementation
or a certification of either other family manuscript. The external
BVW comparison is background only and is recorded separately from
all proof dependencies. Its primary passage has been read by the
Engineer; independent attribution of that background citation
remains for the Reviewer, not self-attribution.

Research target: **publishable**. Mathematical objective: **exploratory**.
The candidate result class is **improved_bound**. Independent review,
statement-fidelity approval, and novelty/significance assessment are
**pending**; `verified_new` and Reviewer acceptance are not asserted.
No false literal manuscript assertion was found in the audited step,
so no unsupported `F_...` refutation claim has been invented.
