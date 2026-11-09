# Staggered-fidelity audit

## Scope and current mathematical status

The target is the ordered limit in `lem:overlap-asymptotic`, not the complete
GFF theorem. Throughout, sites are
`b_j=(j-(L-1)/2)d/2`, `L` is even, `n=L/2`, and `B=Ld/2`.
The Hilbert space has its ordinary orthonormal spin basis. The derivative
parameter is the auxiliary twist `diag(exp(it),exp(-it))`.

The source is the staged September 23, 2026 manuscript, specifically
`build/sections/02-finite-rows.tex`, `03-thermodynamic-kernels.tex`, and
`05-normalization.tex`. No previous mathematical result or certificate was
present in the campaign ledger. Searching the inherited Wiki index for this
problem found no relevant result.

The finite identity, its second-order jets, the continuum symbol, and the
finite-to-continuum remainder are separate obligations. Small exact systems
are falsification probes only. Neither an unverified external determinant
formula nor agreement of continuum symbols establishes the ordered limit.
No false manuscript assertion has been established at this scope checkpoint.

The only non-elementary external algebraic input is the
twisted Slavnov scalar-product identity, with its precise on-shell and
normalization hypotheses. Its primary-source attribution must be checked
independently before review acceptance. Root-density, inverse, and remainder
estimates must be proved, not taken as consequences of the lemma being audited.

The Engineer read the actual Proposition 3.1 and (3.8)-(3.9) in
[KMST, arXiv:hep-th/0406190v1](https://arxiv.org/html/hep-th/0406190v1).
The passage and convention translation are in
`certificate_sources/KMST2005-excerpt.md`. No completeness theorem is used.
A targeted literature search returned no primary proposition for this precise
array limit; its generated discussion confused the array length with a twist,
so it is not evidence that the result is new. Novelty remains a separate
Reviewer question. The strongest preceding local result was only the
unreviewed manuscript assertion; the improvement here is an explicit
oriented-jet calculation, an exact finite monodromy check, and a quantitative
ordered-limit proof rather than finite numerical agreement.

## Verification theorem and its scope

**Theorem.** Fix `pi/2 < lambda < pi`. Use the displayed standard monodromy,
the ordinary Hilbert norm, consecutive real roots, the real site array above,
and half filling. For its normalized physical vector and the twist derivative
specified above,

\[
 \lim_{d\downarrow0}\limsup_{\substack{B\to\infty\\B=Ld/2,\ L\ {\rm even}}}
 \left|{I_L\over B}-{1\over2\lambda(\pi-\lambda)}\right|=0.       \tag{T}
\]

In particular (T) verifies the live objective for `2pi/3<lambda<pi`.
The proof uses only negativity of `K`, not the stronger threshold `2pi/3`.
This modest extension is not a claim that the full GFF construction extends,
or that the extension's novelty or publishability has already been certified.
Constants below may depend on the fixed `lambda`; no endpoint uniformity is
asserted.

The proof is analytical, with exact symbolic and formal verification of its
algebraic components. **Neither the script nor Lean mechanically proves (T).**
Independent review of the analytic estimates and the cited determinant
theorem is required.

### 1. Finite Hilbert overlap

Write `k=-K>0`, `h=int k=2lambda/pi-1<1`, and let `P` and `Q` be the
manuscript's parity matrices. Locally
`R_ph=Z_a L Z_j`. Commuting the auxiliary parities through the ordered product
for even `L` gives `M_ph=P M P Q`. Taking adjoints of quantum blocks of a
physical local matrix exchanges its two auxiliary spin indices. Different
sites commute after the auxiliary indices have been fixed; thus this relation
persists for the monodromy without reversing the site parameters.
Consequently `B(x)^*=-C(conj(x))`. For real root lists,

\[
 \|\mathcal P|Y\rangle\|^2=(-1)^n S(Y,Y),\qquad
 {\left|\langle\Omega_Y,\Omega_U\rangle\right|^2}
 ={S(Y,U)S(U,Y)\over S(Y,Y)S(U,U)}.                           \tag{1}
\]

The on-shell condition follows from the counting equations, rather than an
assumption about eigenvector completeness. Logarithmic differentiation of
the displayed vacuum and scattering ratios gives `q_Y'/q_Y=2pi i xi_Y'`.
Their limits at positive infinity, with `L` even, fix the constant as
`q_Y(u)=(-1)^n exp(2pi i xi_Y(u))`. The consecutive levels
`j-(n+1)/2+t/pi` therefore give `q_Y(y_j)=-exp(2it)`.
The exact script checks both elementary logarithmic derivatives over a
rational parametrization of sine and cosine.

For regular on-shell lists, the KMST formula with anisotropy `i lambda`,
site parameters `b_j+i lambda/2`, and `kappa=exp(-2it_Y)` gives

\[
 S(Y,U)=e^{-int_Y}\prod_{y\in Y}l(y)\,
 {\det(\partial_{y_j}\tau_{t_Y}(U_k;Y))\over
       \det(1/\sinh(U_k-y_j))}.                             \tag{2}
\]

The local normalization multiplies both sides of the external formula by
the same `s_lambda^(2Ln)`. Differentiating before imposing the Bethe equations
extracts `-2pi i a(u)F_Y(u)` from each derivative column. The hyperbolic
Cauchy determinant then gives the pair product

\[
 |\langle\Omega_A,\Omega_C\rangle|^2
 ={ \prod_{j,k}[A_j-C_k+i\lambda][C_j-A_k+i\lambda]\over
    \prod_{j,k}[A_j-A_k+i\lambda][C_j-C_k+i\lambda]}
 {\det M_{AC}\det M_{CA}\over\det G_A\det G_C}.                \tag{3}
\]

All one-set factors cancel, separately in both orientations. Distinct real
roots have nonzero shifted differences and nonzero vacuum factors.
Nonsingular `G` permits the coincident-column limits in (2). The norm
determinant, followed by (1), proves the vector is nonzero. These observations
check precisely the hypotheses needed in the continuation of (2).

Let `C(t)=Y(t)`, `A=Y(0)`, `x_j=Y_j(0)`, `v_j=Y_j'(0)`, and `w_j=Y_j''(0)`.
The local logarithm of (3) is defined near zero for each finite chain. Its
quadratic coefficient is `-I_L`; no uniform neighborhood in `t` is needed.

### 2. Both oriented jets, including the diagonal

For an orientation with on-shell list `Y(t)`, columns `U(t)`, and on-shell
twist `t_Y`, set

\[
 Q(t,u)=e^{-2it_Y}q_{Y(t)}(u),\quad
 h_j=U_j-Y_j,\quad
 L_j=\int_0^1\rho_{Y(t)}(Y_j+\theta h_j)\,d\theta,\quad
 z_j=2\pi i h_j L_j .
\]

Since `Q(t,Y_j)=-1` and `partial_u log Q=2pi i rho_Y`,
`Q(t,U_j)=-exp(z_j)`. Direct substitution into the source column gives,
for `u=U_j-Y_i`,

\[
 M_{ij}=K(u)+(1-e^{z_j})H(u),\qquad
 H(u)={\coth u-\coth(u+i\lambda)\over-2\pi i}.                 \tag{4}
\]

This identity fixes both signs. The removable diagonal is

\[
 M_{jj}=K(h_j)+L_j\mathcal E(z_j)V(h_j),\quad
 \mathcal E(z)={e^z-1\over z},\quad
 V(h)=h(\coth h-\coth(h+i\lambda)).                           \tag{5}
\]

Here

\[
 V(0)=1,\quad V'(0)=i\cot\lambda,\quad
 V''(0)=2(1/3-\csc^2\lambda).
\]

Writing `a=h_j'(0)`, `b=h_j''(0)`, `rho=rho(x_j)`, and
`l_1=L_j'(0)`, `l_2=L_j''(0)`, one has

\[
 z'=2\pi i\rho a,\qquad z''=2\pi i(\rho b+2al_1),
\]
\[
 M'_{jj}=l_1+\rho(z'/2+V'a),
\]
\[
 M''_{jj}=K''(0)a^2+l_2+2l_1(z'/2+V'a)
 +\rho\{z''/2+(z')^2/3+V''a^2+V'b+z'V'a\}.                \tag{6}
\]

For `AC`, the on-shell list is fixed:

\[
 (a,b)=(v_j,w_j),\quad
 l_1=\rho'v_j/2,\quad
 l_2=\rho''v_j^2/3+\rho'w_j/2.                              \tag{7}
\]

For `CA`, the on-shell list moves and the columns are fixed:

\[
 (a,b)=(-v_j,-w_j),\quad
 l_1=\dot\rho+\rho'v_j/2,\quad
 l_2=\ddot\rho+\dot\rho'v_j+\rho''v_j^2/3+\rho'w_j/2.         \tag{8}
\]

Dots are time derivatives at fixed spatial position. In particular (8)
must not be replaced by (7) before taking the bulk limit. Off the diagonal,
ordinary differentiation of (4), with `beta=1-exp(z_j)`, gives

\[
 M'=K'u'+\beta'H,\quad
 M''=K''(u')^2+K'u''+\beta''H+2\beta'H'u',
 \quad \beta'=-z',\ \beta''=-z''-(z')^2.                    \tag{9}
\]

The exact script checks (6)-(8) in a formal Taylor ring. No division by a
velocity or a displacement occurs.

For the pair product put `f(u)=log sinh(u+i lambda)`. Its second derivative
at zero twist is **exactly**

\[
 2\sum_{i,j}v_i v_j f''(x_i-x_j).                           \tag{10}
\]

Indeed, for each pair the acceleration multiplier is
`-w_j+w_i-(w_i-w_j)=0`, while
`v_j^2+v_i^2-(v_i-v_j)^2=2v_i v_j`. This cancellation is finite,
not an assumption of constant bulk accelerations.

### 3. Real roots and uniform inverse control

The counting Jacobian has diagonal
`sum_a s(x_i-b_a)+sum_{j!=i}k(x_i-x_j)` and off-diagonal `-k(x_i-x_j)`.
It is a positive diagonal form plus a positive weighted graph Laplacian.
Thus it is positive definite at every real list. At `lambda=pi/2`
the independent counting equations have unique real solutions. Continue
in `lambda` on a compact interval below `pi`. Collisions are impossible
because the prescribed counting levels differ. If the last `j` roots escape
to infinity, summing their equations cancels their mutual odd primitives;
the excess per root over the assigned levels is `j(1-lambda/pi)>0`.
This rules out escape. The negative end is identical. Strict convexity gives
uniqueness. This proves existence and the local real analytic twist branch.

For completeness the positive dressed density used below is not an
additional unproved input. Integrating the two displayed bare kernels around
a rectangle of height `i pi` gives

\[
 \widehat s(p)={\sinh((\pi-\lambda)p/2)\over\sinh(\pi p/2)},
 \qquad
 \widehat K(p)={\sinh((\pi-2\lambda)p/2)\over\sinh(\pi p/2)}.
\]

There are two poles in a period, at `i theta/2` and `i(pi-theta/2)` for
the kernel with angle `theta`; the formula covers both `theta=lambda`
and `theta=2lambda`, including the negative sign of the latter kernel.
Zero frequency follows by continuity. The hyperbolic addition identity gives

\[
 1+\widehat K
 ={2\sinh((\pi-\lambda)p/2)\cosh(\lambda p/2)\over\sinh(\pi p/2)},
 \qquad {\widehat s\over1+\widehat K}={1\over2\cosh(\lambda p/2)}.
\]

The inverse transform, obtained by the same residue calculation for `sech`,
is `r(u)=1/(2lambda cosh(pi*u/lambda))>0`, of mass `1/2` and with exponential
tails. These factorization identities are also checked in the exact script.
The masses are `int s=1-lambda/pi` and `int K=1-2lambda/pi`.

At half filling the counting density `rho=xi'` has mass `n`, is strictly
positive, and the roots are its midpoint quantiles. The signed measure

\[
 e=\sum_j\delta_{x_j}-\rho(u)\,du
\]

has a primitive `F` satisfying `|F|<=1/2` and `F(+-infinity)=0`.
If `R_0=K*(I+K*)^{-1}` and `p=sum_a r(u-b_a)`, convolution inversion yields

\[
 \rho-p=-R_0'*F,\qquad
 \int_{-\infty}^u(\rho-p)=-R_0*F .                         \tag{11}
\]

The Neumann series is absolutely convergent with a sufficiently small
exponential weight since `int k=h<1`. It gives bounded discrepancies in
(11) and their required fixed derivatives. Also `rho` is the sum of
positive translates of `s` and `k`; their logarithmic derivatives of every
fixed order are bounded. Hence `|rho^(r)|<=C_r rho`.

For small `d` and `B>=2`, (11) gives `rho<=C/d` globally; inside the bare
array one already has `rho>=sum_a s(u-b_a)>=c/d`. Write the roots from
the right as `x_1>x_2>...` and `T(u)=int_u^infinity rho`. Then
`T(x_j)=j-1/2`. For either positive kernel `q=s,k`,
`q(u)<=C bar(q)(u)` on the line, and
`q(u)>=c bar(q)(u)` for `u>=0`. At a root beyond the last bare site,
the outward roots and its own half kernel contribute at most
`h(j-1/2)` to `T`. The inward centers therefore contribute at least
`(1-h)(j-1/2)`. Consequently

\[
 c(j-1/2)\le\rho(x_j)\le C(j-1/2).                         \tag{12}
\]

 Only (12) and the edge extraction below use decreasing edge labels; all
 other matrix and spacing formulas use the original increasing ordering.

Comparing inward tails at neighboring exterior roots also gives, for fixed
`j`, a finite upper gap bound and a lower bound `c/(j+1)`. To apply (12) in
an ordered-limit extraction, note the direct inequality
`T(b_max)>=sum_a bar(s)(b_max-b_a)>=c/d`. Thus every fixed right-edge
index eventually lies beyond the bare sites as `d->0`, `B` sufficiently
large. No fixed-`d` terminal-mesh limit is being assumed.

These bounds and `|rho'|<=C rho` imply

\[
 cd\le\ell_j=1/\rho(x_j)\le C,\quad x_{j+1}-x_j\ge cd,\quad
 \sup_u\sum_j\ell_j e^{-\alpha|u-x_j|}\le C_\alpha.          \tag{13}
\]

For example, on a counting cell whose gap is at most one, the logarithmic
density bound compares its endpoint reciprocal densities to its length;
unit intervals contain at most two partial cells. Larger gaps have
separated endpoints, each of weight at most `C`. This proves the local
mass assertion in (13). A bounded Lipschitz quadrature test in a region
with density at least `M` then has error at most
`C/M (sup|phi|+Lip(phi))`, by integration over the counting cells.

Here is a proof of the inverse bound rather than an appeal to finite
diagonal dominance. Put `A=G diag(ell)=I-k ell`.
Truncate the kernel at a fixed large distance, then use the cell quadrature
where `rho` is sufficiently large. Those rows have absolute `k ell` row
sum at most a fixed `q<1`. By (12), (13), and logarithmic density
comparability, every remaining row belongs to a fixed number of indices
at either end, independently of small `d` and sufficiently large `B`.

If `A` had no uniform lower bound, choose `||W||_infinity=1` with
`A W->0`. A maximal coordinate must survive in those edge indices.
Translate that terminal root to zero and extract every fixed index, using
the gap bounds. In the limit `ell_j` is positive and comparable to `1/j`.
There is no finite accumulation: it would contradict (13) and divergence
of `sum 1/j`. Exponential localization and (13) allow passage to the
infinite equation. With `u_j=ell_j W_j`, it reads

\[
 (\rho_j-k(0))u_j=\sum_{i\ne j}k(x_j-x_i)u_i.               \tag{14}
\]

The coefficient on the left is positive, bounded below by the interaction
with any other retained index. Finite row dominance and Fatou's lemma
give `sum_{i!=j}k(x_j-x_i)<=rho_j-k(0)`. Thus (14) is an averaging
equation with positive weights and total at most one. But `u` is nonzero,
`u_j->0`, and therefore attains a nonzero absolute maximum; some other
index has strictly smaller modulus. Its positive weight makes (14)
impossible. This proves `||A^{-1}||_infinity<=C` in the required ordered
convention. Finally (13) gives

\[
 \sup_i\sum_j k(x_i-x_j)\ell_j
       |e^{a(x_i-x_j)}-1|\le C|a|.
\]

Perturbing the inverse for sufficiently small `a` proves bounded inverse
row norms for both exponential weights, and hence for
`exp(a|x_i-x_j|)` by adding the two bounds.

### 4. Arbitrary fixed-order bulk accuracy

Let a retained point have distance `R` from both ends of the bare array.
All estimates here permit an additional `C_d exp(-a R)` error, with `C_d`
finite for each fixed `d`; this is why the order of limits matters.
In the counting coordinate `z=xi(u)`, roots have exact unit midpoint
spacing. Bounds `rho>=c/d` and `|rho^(r)|<=C_r rho` imply, by differentiating
the inverse coordinate,

\[
 |u^{(r)}(z)|\le C_r d^r,\quad
 \int |\partial_z^r F(u(z))|\,dz\le C_r d^{r-1}              \tag{15}
\]

for a smooth exponentially localized test, after a cutoff in the dense
region. The constants for each fixed order are uniform in small `d`.
Repeated integration by parts against the bounded periodic Bernoulli
primitives of the unit counting comb proves quadrature error
`O_r(d^(r-1))`; cutoff errors are `C_d exp(-aR)`. The unweighted number
of roots per unit interval is `O(1/d)` by the minimum gap, so convolution
tails outside the cutoff have the same exponential bound, not a factor `B`.

Apply (15) to each fixed derivative of `K`. In the density equation the
discrete-root sum differs from convolution against `rho` by an arbitrary
fixed power of `d`. The uniform site array has the same quadrature
accuracy. Since
`int s=1-lambda/pi` and `1+int K=2(1-lambda/pi)`,
the constant solution is `1/d`. Invert `I+K*` with its exponentially
weighted Neumann series. For every fixed `m` and required spatial derivative,

\[
 \rho=d^{-1}+O_m(d^m)+C_d e^{-aR},\qquad
 \rho^{(r)}=O_m(d^m)+C_d e^{-aR}\quad(r\ge1).               \tag{16}
\]

There is a useful independent simplification for the velocity. Exactly,
`G 1=sigma`, where `sigma=sum_a s(x_i-b_a)`. Thus, for
`c_*=1/(2(pi-lambda))`,

\[
 G(c_*d\,1)-1/\pi=c_*d\,\sigma-1/\pi .
\]

The right side is arbitrarily small in the interior by *site* quadrature,
and bounded globally. The weighted inverse just proved yields

\[
 v_j=c_*d+O_m(d^m)+C_d e^{-aR}.                             \tag{17}
\]

Globally `|v_j|<=C ell_j`. Twice differentiating the finite counting
equations gives

\[
 Gw=-H,\qquad
 H_i=\sigma'(x_i)v_i^2-\sum_jK'(x_i-x_j)(v_i-v_j)^2.         \tag{18}
\]

Equations (13) and the kernel bounds give `|H_i|<=C` and therefore
`|w_i|<=C ell_i`. In the interior, (17) cancels the velocity differences;
site quadrature cancels `sigma'`. The weighted inverse gives
`w_i=O_m(d^m)+C_d exp(-aR)`. Similarly

\[
 \dot\rho=\sum_jK'(\,\cdot-x_j)v_j,\qquad
 \ddot\rho=\sum_j\{K'(\,\cdot-x_j)w_j-K''(\,\cdot-x_j)v_j^2\}
\]

are arbitrarily small in the interior, including their required spatial
derivatives: use (15)-(17) and `int K'=int K''=0`. They are `O(1)` globally.
Thus (7) and (8) become opposite constant translations only *after*
their correct finite jets have been taken.

### 5. Quantitative finite-trace localization

Fix `D=diag(ell_j)` at zero twist, not a moving density weight.
For any of the four determinant matrices `M(t)` in (3), set `N(t)=M(t)D`.
At zero `N(0)=A`; elementary finite matrix differentiation gives

\[
 (\log\det M)''=\operatorname{Tr}
 \{A^{-1}N''-A^{-1}N'A^{-1}N'\}.                            \tag{19}
\]

There is no derivative of `D`. Equations (5)-(9), (13), and (18) imply
weighted absolute row bounds

\[
 \|N'\|\le C/d,\qquad \|N''\|\le C/d^2.                     \tag{20}
\]

For clarity, off the diagonal
`|H(u)|<=C(1+|u|^-1)exp(-a|u|)` and
`|H'(u)|<=C(1+|u|^-2)exp(-a|u|)`.
Use the minimum gap for the two poles and (13) for the residual row sum.
On the diagonal (5) gives `ell_j |M_jj^(r)|<=C`, `r=1,2`:
`z',z''=O(1)`, `L',L''=O(1)`, and `ell_j rho_j=1`.
For `G_C` both Taylor bounds are `C`; `G_A` is constant. These estimates
bound each trace diagonal in (19) by `C/d^2`.

The count of all discarded roots, including exterior ones, is at most

\[
 \#\{j:|x_j|\ge B/2-R\}\le C(R+1)/d.                       \tag{21}
\]

Indeed their half-integer counting tails are, by (11), bounded by the
tails of `sum r(u-b_a)` plus a constant. Sites to the right of `B/2-R`
number `O(R/d+1)`; the remaining exponentially decaying tails sum to
`O(1/d)`. This proves (21). Deleting their diagonals from (19), divided
by `B`, costs at most `C(R+1)/(d^3 B)`.

Compare with `T_n=I+(dK(d(i-j)))`. The common row algebra can be taken
with weights `exp(a d|i-j|)` since `|x_i-x_j|>=cd|i-j|`.
For small `d`,
`||T_n-I||<=q<1` follows by quadrature from
`int exp(a|u|) k(u)<1`, so `T_n^{-1}` has a bounded weighted row norm.
The exact resolvent identity is

\[
 A^{-1}-T_n^{-1}=A^{-1}(T_n-A)T_n^{-1}.                    \tag{22}
\]

Take a fixed number of nested physical strips of width proportional to
`R`. Their intervening index counts are at least `cR/d-O(1)`.
Every matrix-product path crossing one such strip acquires
`C_d exp(-aR)` from the common weighted norm. The number of factors in
(19) and (22) is fixed. Absolute row norms are submultiplicative, so
no intermediate sum contributes `n` or `B`.

Here is a conservative power count for interior errors, to make this
localization quantitative. Choose (16)-(18) with accuracy `d^m`, taking
as many extra fixed derivatives in (15) as necessary. Counting differences
give
`x_j-x_i=d(j-i)+O(d^(m+2)|j-i|)` and `ell_j=d+O(d^(m+2))`.
The only poles through the second Taylor order are `H,H'`, and their
first spatial derivatives in a difference comparison cost at most
`d^-3`. Polynomial index separations are absorbed by the weighted
exponential sums. Therefore the interior errors of each normalized
Taylor matrix, and of `A-T_n`, are at most `C_m d^(m-3)`.
This deliberately also bounds the much smaller smooth-kernel errors.
In (19), changing one inverse costs at most its error times
`||N'||^2<=C/d^2`; changing a Taylor factor has no worse cost.
Equations (20)-(22) thus give retained-diagonal error
`C_m d^(m-5)+C_d exp(-aR)`. A trace per physical length costs the
additional factor `n/B=1/d`, giving `C_m d^(m-6)`.

The same weighted-path argument replaces `T_n^{-1}` by its full-lattice
inverse: an omitted path must cross the matrix boundary, at index distance
at least `cR/d` from a retained row. The uniform full-lattice Taylor
matrices have the same bounds (20). This justifies a lattice convolution
trace, not an infinite-volume trace-class assertion.

For the pair sum (10), `f''=-csch^2(u+i lambda)` is smooth and exponentially
localized on the real axis. The bounds `|v_i|<=C ell_i` and (13) localize
its rows; (16)-(17) give its interior Riemann sum. Its errors are smaller
than the conservative bound above. Since
`int_R f''=coth(+infinity+i lambda)-coth(-infinity+i lambda)=2`,
its logarithmic quadratic coefficient per length tends to `2 c_*^2`.

### 6. The sampled Fourier symbol: positive and negative frequencies

Put `z=c_*t` in the uniform bulk model. For `AC` the root-column difference
is `d(k+z)`, and its normalized kernel is `d` times

\[
 { (1-E)\coth y-\coth(y-i\lambda)+E\coth(y+i\lambda)\over-2\pi i},
 \qquad y=d(k+z),\quad E=e^{2\pi i z}.                     \tag{23}
\]

For `CA` replace `z` by `-z`. The Gaudin denominators correspond to zero.
Coalescence in (23) is interpreted by (5), not by assigning a value to a
singular summand.

For real nonzero `p`, residue summation, closing below when `p>0` and
above when `p<0`, gives

\[
 \widehat{\coth(\,\cdot+i\lambda)}(p)
 ={ -2\pi i e^{-\lambda p}\over1-e^{-\pi p}},\qquad
 \widehat{\coth(\,\cdot-i\lambda)}(p)
 ={ -2\pi i e^{-(\pi-\lambda)p}\over1-e^{-\pi p}},             \tag{24}
\]
\[
 \widehat{\operatorname{pv}\coth}(p)
 =-\pi i\,{1+e^{-\pi p}\over1-e^{-\pi p}}.
\]

These are transforms of bounded-tail functions in the distributional
sense; their restrictions away from zero are the displayed ordinary
functions. In particular (24) holds also at **negative** `p`; replacing
`p` by `|p|` in just one factor would give the wrong orientation.

With the offset Fourier exponent, the sampled simple pole is

\[
 \sum_{k\in\mathbb Z}{e^{-ipd(k+z)}\over k+z}
 =\pi(\cot\pi z-i\,\operatorname{sgn}p),
 \qquad 0<|p|<\pi/d.                                      \tag{25}
\]

One derivation is to differentiate its distributional Fourier series in
`q=pd`: it is constant between multiples of `2pi`, with jump `-2pi i`
at zero. Its symmetric value there is the partial-fraction expansion
`pi cot(pi z)`. This proves both signs in (25).

Subtract the pole `1/y` from `coth y`. The remainder has integrable
derivative analytic in every closed strip narrower than the nearest
nonzero pole. The other coth terms have the same property in a strip
`a<min(lambda,pi-lambda)`. Contour shifting bounds their nonzero-frequency
transforms, after removing constants, by `C exp(-a|p|)/|p|`.
Poisson summation of the regular remainder therefore has only exponentially
small nonzero aliases, also through two `z` derivatives. Constants may
contribute at zero frequency only, which is not used in the trace integral.

More explicitly, on the fundamental band all nonzero aliases have absolute
frequency at least `pi/d`; their two offset derivatives introduce at most a
fixed multiple of `1+m^2`. Summing the resulting geometric series, and
allowing conservative derivative costs, bounds their trace contribution by

\[
 C d^{-3}{e^{-a\pi/d}\over(1-e^{-2a\pi/d})^3}.               \tag{26}
\]

The geometric identity `sum_{m>=1} m^2 q^m=q(1+q)/(1-q)^3` and the
pole correction below are checked exactly in `verify.py`.

To see why neither sign is lost, write `a_0=exp(-lambda p)`,
`b_0=exp(-(pi-lambda)p)`. Dividing the continuous transform of (23) by
`-2pi i` gives

\[
 C(E)={ (1-E)(1+a_0b_0)/2-b_0+Ea_0\over1-a_0b_0}.
\]

For either sign `s=sgn p`, the sampled pole minus its continuous transform
is

\[
 {(1-E)(\cot\pi z-is)\over-2i}-{(1-E)s\over2}
 ={1+E\over2}.                                           \tag{27}
\]

The sign-dependent terms cancel. Thus the corrected symbol is

\[
 C(E)+{1+E\over2}
 ={(1-b_0)(1+Ea_0)\over1-a_0b_0}.
\]

Its ratio to the zero-twist value is

\[
 R_z(p)={1+e^{2\pi iz}e^{-\lambda p}\over1+e^{-\lambda p}}.   \tag{28}
\]

For `p<0` it tends to `E` at the far band end, not to one.
This is a linear logarithmic phase, canceled by the opposite orientation.
The offset-exponent phases `exp(+-ipdz)` likewise cancel exactly.
The zero-twist sampled Gaudin symbol is bounded below by `1-q>0`;
(26) and the relative symbol near zero therefore control the quadratic
logarithmic coefficients without a uniform finite-system `t` neighborhood.

The coefficient of `t^2` in the two logarithms of (28) is

\[
 -4\pi^2c_*^2{e^{-\lambda p}\over(1+e^{-\lambda p})^2}.
\]

It is even in `p`. The convolution trace per length has measure
`dp/(2pi)`: the lattice diagonal has measure `d dp/(2pi)` and `n/B=1/d`.
With the substitution `x=exp(-lambda p)`, the integral is

\[
 \int_{\mathbb R}{e^{-\lambda p}\over(1+e^{-\lambda p})^2}
                  {dp\over2\pi}={1\over2\pi\lambda}.        \tag{29}
\]

The band truncation is exponentially small. Therefore the determinant
contribution per length is `-2pi c_*^2/lambda`. Adding the pair contribution
gives

\[
 2c_*^2-{2\pi c_*^2\over\lambda}
 =-{1\over2\lambda(\pi-\lambda)}.                          \tag{30}
\]

### 7. The ordered remainder and conclusion

Take the fixed number of nested strips in Section 5 with widths proportional
to `sqrt(B)`. Combining (19)-(30), for any fixed sufficiently high accuracy
order `m>=8`, yields

\[
 \left|{I_L\over B}-{1\over2\lambda(\pi-\lambda)}\right|
 \le C_m d^{m-6}
   +{C(\sqrt B+1)\over d^3B}
   +C_d e^{-a\sqrt B}
   +{C d^{-3}e^{-a\pi/d}\over(1-e^{-2a\pi/d})^3}.            \tag{31}
\]

Here `a>0` and `C,C_m` are independent of small `d` and sufficiently large
`B`; `C_d` is finite for each fixed `d`. Reducing `a` absorbs the fixed
strip-width proportions and any polynomial in `sqrt(B)` from cutoffs.
All derivatives were taken at finite `L`. First let `B->infinity` at fixed
`d`, which removes the second and third terms. Then let `d->0`, which
removes the first and fourth. This proves (T) with precisely the requested
limsup convention. It does not exchange the two limits or assert a limit
at each fixed `d`.

## Exact evidence and remaining independent obligations

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/verify.py

The script uses no floating-point tolerance. Besides the general algebraic
jets and symbol identities, it checks the displayed two-site monodromy and
physical gauge, verifies `B^*=-C` under the exact local conjugation rule,
and compares both oriented determinants with the actual Hilbert overlap
for an entire exact one-root family. This family has
`cos(lambda)=-3/5`, `sin(lambda)=4/5`, `d=2log(2)`, and zero-twist root zero;
its exact twist velocity is `37/32` and its fidelity is `481/1024`.
It satisfies the live parameter interval. This is a finite identity
check, explicitly not evidence that an asymptotic limit follows from
small systems.

Jacobian 0.14.0, protocol 2025-11-25, was first discovered and its exact
`matrix.symbolic.multiply.compute` contract inspected. One bounded
8-by-8 symbolic product then computed the two-site monodromy over
`QQ(a0,l0,a1,l1)`. The exact payload, typed output, stderr, and adapter
exit receipt are separate files in `research/jacobian/`; `verify.py`
independently replays every output entry. An initial local parser expected
a nonexistent `status` field; the typed result was retained and the parser
was corrected to the actual contract, without repeating the operation.
There was no mathematical failure, adapter timeout, or UNKNOWN result.

`research/lean/Main.lean` checks only the algebraic core named in its
statement-fidelity document. It cannot certify the Fourier transforms,
inverse extraction, localization, or (31). The first compiler attempt
exposed an uncleared inverse in one proof and the verifier's requirement for
unqualified declaration names in the fidelity document; these are local
formalization issues, not manuscript counterexamples.
The final real Lean 4.31.0 compiler run succeeded with exit code zero and
`proof_holes=[]`. Its archived certificate is
`research/lean/certificates/C_ALG_KERNEL-5aa3c8fd29bf311b.json`.
The exact script also checks that the current Lean source and
statement-fidelity document still match that compiler record. This freshness
check reuses the verifier's required hashes; it does not substitute a
scripted verdict for a compiler run.

Before acceptance the Host-invoked independent Reviewer must scrutinize the
proof of (13)-(18), the fixed-power bookkeeping and localization in
(19)-(22), and the two-sign alias argument (24)-(27); replay the exact
script and fresh Lean evidence; and attribute `C_SCALAR/A_KMST` and
`C_NEGATIVE_FIDELITY/A_KMST_NEGATIVE` from the primary passage. These are
dependencies on the same cited proposition, not two different external
theorems. No false literal manuscript assertion has been established,
so there is no legitimate `F_*` refutation claim to record. The whole GFF
theorem remains outside the verified scope, and no independent certification
or `verified_new` novelty verdict is being asserted by the Engineer.

The proposed extended theorem is recorded as `C_NEGATIVE_FIDELITY`.
`new_theorem` in the exact certificate identifies that proposed result
class, not an accepted publication decision. The campaign cannot be declared
complete on a finite check or on this unreviewed classification.
