# Finite-input smooth correction with polynomially degenerating normal geometry

## 1. Statement and scope

Fix a closed smooth surface, a finite background atlas and its norms, and an
integer `D >= 4`. Write `gamma(f) = df^T df` and let `B_f` be the normal
projection of `D^2 f`. No orientability assumption is made. All statements
about families below are pointwise in the parameter: parameter regularity
is neither assumed nor concluded.

**Theorem.** Fix real numbers `a,b,d >= 0` and `L > 0`. Put `R = 440`.
There is a positive integer `N`, depending on these exponents, the fixed
background data and `D`, but not on the constants in the following bounds.
Suppose, for sufficiently small `z > 0`, that `f_z : M -> R^D` is a smooth
immersion, `h_z` is a smooth metric, and

\[
\begin{split}
 c_0 g_{\rm bg}\le h_z\le C_0 g_{\rm bg},\qquad&
 \|f_z\|_{C^{j+2}}\le C_j z^{-a-bj}\quad(0\le j\le R),\\
 \|\gamma(f_z)-h_z\|_{C^R}\le C z^N,\qquad&
 \inf_p\max_{|Y|_{\rm bg}=1}|B_{f_z}(Y,Y)|\ge c z^d .
\end{split}                                                    \tag{1}
\]

All constants here are strictly positive and independent of `z`.
There are smooth immersions `fhat_z` with

\[
       \gamma(\widehat f_z)=h_z,\qquad
       \|\widehat f_z-f_z\|_{C^2}\le z^L                 \tag{2}
\]

for all sufficiently small `z`. The threshold can depend on all the
constants in (1). Neither the threshold nor `N` uses any bound for a
derivative of either true input above its displayed order.
The uncontrolled higher derivatives can affect finite waiting times.

For the staged Proposition `prop:exact-correction`, take `D=4`,
`a=2,b=1,d=0`, and `h_z=h_*`. The manuscript's jet hypotheses imply
the jet bounds in (1); its defect hypothesis gives the uniform metric
bounds. Taking, for example, `L=1` proves its conclusion. Thus this is a
verification of that proposition with additional degenerating-geometry,
varying-target, and quantitative-proximity conclusions. It does **not**
verify the manuscript's perturbed small-increment proposition, periodic
primitive realization, boundary propagation, or main global theorem.

This is an analytic proof with a machine-checked algebraic/scheduling core,
not a Lean formalization of the entire analytic theorem. Independent
mathematical review must assess the analytic proof and statement fidelity.
No literature-wide originality or publishability verdict is assumed.

## 2. Quantitative good phases without uncontrolled derivatives

Set

\[
 A_0=\max(a+b,2a),\qquad \ell=A_0+d+2,\qquad
 J=L+a+d+4,\qquad \rho=z^J .
                                                               \tag{3}
\]

Metric closeness implies that `df_z` is uniformly bounded and uniformly
injective. Differentiating
`Pi_N = I - df (df^T df)^{-1} df^T` therefore gives

\[
 |B_f|=O(z^{-a}),\quad |D B_f|=O(z^{-A_0}),\quad
 |D\Pi_N|=O(z^{-a}).                                  \tag{4}
\]

In the middle estimate the two contributions have orders
`D^3 f = O(z^{-a-b})` and `(D^2 f)^2=O(z^{-2a})`.
The defect bound also implies, for `0 <= j <= R`,

\[
                 \|h_z\|_{C^j}=O(z^{-2a-bj}).          \tag{5}
\]

Indeed apply the product rule to `df^T df`, use the uniform first
derivative bound for the end terms, and use the two displayed jet
bounds for every interior term. This loose exponent bounds them all.
In particular `Dh_z` has a polynomial bound; no higher target derivative
is needed to choose the phase data.

Here is a quantitative phase construction. At the center of a coordinate
cell choose an `h_z`-orthonormal coframe `(e_1,e_2)`. Use a common
rotation of the three covectors `e_1, e_1/2+e_2, -e_1/2+e_2`.
Their squares are independent and their positive combination with
coefficients `3/4,1/2,1/2` is the identity metric in that coframe.
A nonzero normal-valued quadratic form
has only finitely many projective zeros: one of its nonzero scalar
components is a nonzero homogeneous quadratic in two variables, with at
most two projective zeros. A rotation therefore makes all three kernel
directions good.

This choice has a **uniform relative**, not absolute, margin. Normalize
the second form by its norm. On the compact space of unit normal-valued
symmetric forms and of background-comparable positive metrics, the
maximum over rotations of the minimum of the three transverse lengths
is a positive continuous function. Its minimum is positive. Consequently
the selected unit kernel vectors satisfy

\[
                 |B_f(Y,Y)|\ge\kappa |B_f| .            \tag{6}
\]

This also gives a uniform angular neighborhood of good directions, since
the norm of a quadratic form controls its angular derivative.
All constants may depend on `c_0,C_0`, but their powers of `z` do not.

Use cells of diameter comparable to `z^ell` in the fixed atlas. On an
enlarged cell the change of `B_f` is `O(z^{d+2})`, by (4), small relative
to its lower bound. The change of the target tends to zero by (5) (or
directly `Dh_z=O(z^{-a})` from `df=O(1)`). Extend each center coframe
as coordinate-linear differentials. Their positive expansion remains
positive throughout the enlarged cell, with uniform positive coefficient
and basis-determinant margins.

Choose cutoffs on these cells and divide them by the square root of the
sum of their squares. Thus `sum psi_c^2=1`. Their order-`j` derivatives
are `O(z^{-ell*j})`; there are `O(z^{-2ell})` cells. A fixed lattice
coloring and the finite chart index give finitely many labels such that
supports with the same label are disjoint. Give one label to each
color/triple position. Successively larger **fixed** phase weights make
the normalized differential of a sum or difference arbitrarily close
to that of its larger-weight member. The uniform angular margin in (6)
therefore makes every required individual, doubled, and pairwise
sum/difference phase nonzero and good. Divide each coefficient form by
its phase weight squared. The number of weights is independent of `z`
and of the number of cells.

We have obtained phases and fiberwise linear coefficient forms with

\[
 A=\sum_\nu b_\nu(A)^2\,d\phi_\nu^2,\qquad
 b_\nu(A)=\psi_\nu\sqrt{q_\nu(A)}                       \tag{7}
\]

for `A` in a fixed-radius `C^0` neighborhood of `h_z`. Before the cutoff,
each square-root argument has a uniform positive lower bound.
Take nested neighborhoods `U_0` and `U_1` with a positive gap.

Every relevant differential and a complementary coordinate differential
give an invertible local coframe with fixed bounds. On overlaps this
means using the dual vector fields of two exact independent one-forms;
they commute and the usual coordinate calculation is valid without a
global injectivity assumption. All fixed-order derivatives of the phase,
coframe, cutoff, and coefficient data have polynomial `z^{-1}` bounds.
The exponents depend on the displayed exponents and the derivative
orders, not on implicit constants.

If `||G-f_z||C2 <= rho`, then

\[
 |B_G-B_f|\le C\rho(1+z^{-a})=O(z^{J-a})=o(z^d).
                                                               \tag{8}
\]

Thus all the relative good-direction and metric margins persist in
this ball. For a good phase with transverse coordinate `y`, let
`b_G=(B_G)_{yy}`. In `R^D` the orthogonal projector onto
`N_G intersect b_G^perp` has rank `D-3 >= 1`. At a cell center at
least one ambient coordinate vector has projected length at least
`sqrt((D-3)/D)`. Formulae (4), (6), and (8) make this choice persist
on the enlarged cell and throughout the ball. Normalize its projection
to obtain a local smooth unit normal `n_G` perpendicular to `b_G`.
For `D=4` this is the usual perpendicular-product normal. All its
denominators have polynomial reciprocal bounds.

This construction uses only low jets to choose the cells and constant
coframes. Higher derivatives of `f_z` or `h_z` are not hidden in the
phase-data constants. Normals subsequently evaluated at a *smoothed*
current map use that smoothed map's derivatives.

For the manuscript's profile `a=2,b=1,d=0`, (3) gives exactly the
mesh exponent `ell=6`. In (8) one may use `rho=z^4`, since then
`J-a=2>d=0`. Thus this argument also verifies the larger persistent
ball stated in `lem:polynomial-phase-data`, not only the smaller ball
chosen for the quantitative conclusion (2).

## 3. The unperturbed finite increment, proved directly

For sections set

\[
 |u|_{m,s}=\sum_{j=0}^m s^j\|u\|_{C^j},\qquad
 |j^2G|_{m,s}=\sum_{j=0}^m s^j\|G\|_{C^{j+2}} .
\]

The product rule makes these norms algebras with constants depending
only on the displayed order and fixed charts. Composing with an
inverse, a square root on a positive interval, or a normalized vector
has polynomial bounds in the input norms and reciprocal margins.
This follows by differentiating: an order-`m` derivative is a finite
sum of products of at most `m` input derivatives and derivatives of
the scalar inverse/square-root function. All its negative powers
are controlled by the prescribed margin.

We prove the increment assertion needed here: for admissible `G,A`,
with all their weighted `s`-norms bounded, every integer `q >= 1`
admits a finite smooth differential construction `U` satisfying

\[
 \begin{split}
 |U|_{m,\tau}&\le C_{m,q}\delta\tau,\\
 |\gamma(G+U)-\gamma(G)-\delta^2 A|_{m,\tau}
 &\le C_{m,q}\{\delta(\tau/s)^q+\delta^3/\tau\}.
 \end{split}                                                   \tag{9}
\]

Here `0<tau<=s<=1`, and `tau/s` and `delta/tau` must be small.
**The domain smallness conditions use only finitely many input
orders depending on `q`, not on the observation order `m`.**
Once these conditions hold, (9) holds for each `m`, with no new
smallness condition. We justify this point explicitly below.
Fix `Q=q+2` for every mode solve and fix `q` mean substitutions.
These choices, hence the actual displacement `U`, are independent
of `m`; only the finite input order and bound in its differentiated
estimate increase with `m`.

### 3.1 A finite linear-mode solver

Work in coordinates with phase `x`. Decompose a complex amplitude as
`Z=G_k g^{ki}u_i+v`, where `v` is normal and `g=gamma(G)`.
Differentiate `u_i=<G_i,Z>` to obtain, without suppressing a normal-frame
derivative,

\[
 (e^{-ix/\tau}D_G(e^{ix/\tau}Z))_{ij}
 =\partial_i u_j+\partial_j u_i-2\Gamma^k_{ij}u_k
 +{i\over\tau}(\delta_{ix}u_j+\delta_{jx}u_i)
 -2\langle B_{ij},v\rangle .                            \tag{10}
\]

For a prescribed normal amplitude `v_0 perpendicular b_G`, put

\[
 v=v_0+{b_G\over |b_G|^2}
       \{\partial_yu_y-\Gamma^k_{yy}u_k-h_{yy}/2\}.
                                                               \tag{11}
\]

This solves the `yy` equation exactly. The other two equations become

\[
               (i/\tau)u+\mathcal L u=k(h,v_0),         \tag{12}
\]

where `L` is first order and `k` is algebraic and linear. More explicitly
the right sides are

\[
 h_{xx}/2+\langle B_{xx},v_0\rangle-c_{xx}h_{yy}/2,\quad
 h_{xy}+2\langle B_{xy},v_0\rangle-c_{xy}h_{yy},
 \qquad c_{ij}={\langle B_{ij},b_G\rangle\over|b_G|^2}.
\]

The left differential terms are obtained by subtracting
`c_xx*(partial_y u_y-Gamma_yy^k u_k)` and
`2c_xy*(partial_y u_y-Gamma_yy^k u_k)` from the tangential
`xx/2` and `xy` expressions, respectively. Their coefficients are
smooth algebraic functions of the two-jet and the reciprocal margins.

Put `alpha=tau/i` and use the **finite** formula

\[
        u=\alpha\sum_{j=0}^{Q-1}(-\alpha\mathcal L)^j k .
                                                               \tag{13}
\]

The geometric-polynomial identity leaves residual
`-(-alpha L)^Q k` in (12). A first derivative costs `s^{-1}`;
thus the residual is bounded by
`C_m (tau/s)^Q (|h|_{m+e_Q,s}+|v_0|_{m+e_Q,s})`,
for a finite `e_Q`. Reconstruction using (11) gives the same
bound for the residual tensor, a bounded amplitude `Z`, and, for `h=0`,

\[
             Z-v_0=O_s((\tau/s)|v_0|) .                \tag{14}
\]

Here and below the notation on the right permits a specified finite
derivative loss on the amplitude; it never conceals a true-input
smallness hypothesis in a higher norm. To verify (14), `u` is
`O_s(tau*v_0)`, its derivative in (11) is `O_s(tau/s*v_0)`,
and its zero-order tangential and connection terms are bounded
by the same quantity because `s<=1`. Formula (13) is support preserving.
It works for each permitted phase combination as well.

### 3.2 Positive mean and finite substitutions

For a trial tensor `A in U_1`, set

\[
 v_{0,\nu}=\sqrt2\,\delta\tau b_\nu(A)n_\nu
\]

and apply (13) with `h=0`, to sufficiently high finite order. Let
`U_1(A)` be the sum of the real oscillations so obtained.
Its differentiated leading amplitude divided by `delta` is
`i sqrt2 b_nu(A)n_nu dphi_nu`; its amplitude error and difference
error have an extra factor `tau/s`. Slow differentiation of the
leading amplitude has this factor too. Therefore

\[
 D_GU_1=O_\tau(\delta\tau(\tau/s)^Q),\qquad
 \delta^{-2}Q_0(A)=A+T(A),                              \tag{15}
\]

where `Q_0` is the zero-phase part of `dU_1^T dU_1`, and

\[
 |T(A)|_{m,s}\le C_m(\tau/s),\qquad
 |T(A)-T(\bar A)|_{m,s}
 \le C_m(\tau/s)|A-\bar A|_{m+e,s}.                     \tag{16}
\]

Constants in (16) are polynomial on bounded weighted sets; `e` is
finite and can depend on `Q`. For clarity, the leading real single-mode
quadratic term is
`2 delta^2 b_nu(A)^2 sin^2(phi_nu/tau) dphi_nu^2`.
Its mean is `delta^2 b_nu(A)^2 dphi_nu^2`. Equation (7) gives
exactly `delta^2 A`. All other terms contain a small amplitude/slow
derivative error. In differences, the leading term `A-bar A`
cancels **exactly**, so the small factor persists. This proves (16)
by the product and chain rules, not by an inverse function theorem.
Crossed and doubled phases are nonconstant on their supports by
construction; accidental equal nonzero phases can simply be grouped.

Starting with the desired tensor `A_0=A_target in U_0`, define

\[
             A_{j+1}=A_{\rm target}-T(A_j).
                                                               \tag{17}
\]

For any requested finite number `q` of substitutions, these formulas
are well defined for sufficiently small `tau/s`, with a threshold
using **only finitely many** input derivatives. Here is a precise
finite-jet argument for that assertion. To bound `A_q` in order zero,
work backward through the finite loss `e`: it is enough to bound
`A_0` and all coefficient fields through order `q*e`, increasing this
finite order if required by (13). Their bounds and the positive gap
between `U_0,U_1` determine bounds for each intermediate finite jet.
In order zero, (16) then makes each `T(A_j)` smaller than that gap.
Induction over the finitely many substitutions proves both domain
membership and these finite-jet bounds. For an observation order `m`,
the same finite formulas, now differentiated `m` times, give a bound
using finitely many higher input norms. **They impose no further
domain restriction:** all square-root arguments have already been
bounded away from zero in order zero. This is why the threshold
does not depend on uncontrolled high derivatives.

Successive differences in (17) acquire a factor `tau/s` at each
substitution, by (16) applied in successively lowered finite orders.
Consequently, after finitely many substitutions,

\[
                    Q_0(A_q)
       =\delta^2 A_{\rm target}+O_s(\delta^2(\tau/s)^q).
                                                               \tag{18}
\]

This is not a Banach contraction in a space with derivative loss.

### 3.3 The remaining modes

Each nonzero quadratic coefficient of `dU_1^T dU_1-Q_0` is
`O_s(delta^2)`. Solve its negative using (11)-(13), now with `v_0=0`,
to accuracy `q`. Sum the real solutions as `U_2`. Then

\[
 U_2=O_\tau(\delta^2),\qquad
 D_GU_2+(dU_1^TdU_1-Q_0)=O_\tau(\delta^2(\tau/s)^q).
                                                               \tag{19}
\]

Thus `U=U_1+U_2=O_tau(delta*tau)` when `delta/tau<=1`.
The remaining quadratic terms have size at most
`C_m(delta^3/tau+delta^4/tau^2)<=2C_m delta^3/tau`.
There is no third-order Taylor remainder because `gamma` is quadratic.
Combining (15), (18), and (19) proves (9). The `C^2` change is
`O(delta/tau)`; reducing this ratio with the already finite low-order
constant keeps the segment in the admissible jet domain. Cutoff
flatness and the differential formulas give smooth extension by zero.

In particular, this proof discharges the unperturbed small-increment
dependency; it does not posit it as an external assumption.

## 4. Smoothing and the linear high-input tail

Smooth bundle sections in the fixed finite atlas, with localized
convolutions and fixed secondary cutoffs. For each integer `r>=1`
choose a compactly supported smooth kernel with integral one and
all moments of total degrees `1,...,r` zero. One explicit construction
uses dilates `1,...,r+1` of an initial kernel and coefficients

\[
             c_i=(-1)^{i-1}{r+1\choose i}\quad(1\le i\le r+1).
                                                               \tag{20}
\]

For `0<=j<=r`, apply `(X d/dX)^j` to `(1-X)^{r+1}` at `X=1`.
The zero has order `r+1`, so the result vanishes; expanding proves
`sum c_i=1` and `sum c_i i^j=0` for `1<=j<=r`.
This proves the assertion for **every** `r`, not just the finite
moment system in the computational example.

Integration by parts and Taylor's formula give, for the resulting `S_s`,

\[
 \begin{split}
 \|S_su\|_{C^{q+m}}&\le C s^{-m}\|u\|_{C^q},\\
 \|u-S_su\|_{C^{q+j}}&\le C s^{r-j}\|u\|_{C^{q+r}}\quad(0\le j\le r),\\
 \|S_su\|_{C^m}&\le C_m\|u\|_{C^m}.
 \end{split}                                                   \tag{21}
\]

To see these estimates on the manifold, extend localized components
by zero, convolve inside their larger chart, multiply by a cutoff
equal to one near their original support, and sum. At scale zero
the sum is exactly the original section. Derivatives of fixed frames
and cutoffs introduce only bounded lower-order terms; the same
Taylor estimate applies to them.

For this varying-target theorem retain the target as one additional
true-input component:

\[
 X_m(t)=\sum_{j=0}^m t^j
   \{\|G\|_{C^{j+2}}+\|H\|_{C^j}+\|h_z\|_{C^j}\}.
                                                               \tag{22}
\]

If `X_r(t)<=B` and `0<tau<=s<=t<=1`, smoothing bounds every
weighted `s`-norm of `j^2G_s,H_s,(h_z)_s` by `C_{m,r}B`.
For their respective differences, the corresponding weighted
`tau`-norm is bounded by

\[
      C_{m,r}\{B(s/t)^r+X_m(t)(\tau/t)^r\}.             \tag{23}
\]

For `j<=r` the contribution is
`CB t^{-r}s^{r-j}tau^j <= CB(s/t)^r`.
For `j>r`, smoothing boundedness in that very order gives
`C_m(tau/t)^j X_m(t) <= C_m(tau/t)^r X_m(t)`.
Thus (23) is **linear** in the uncontrolled high true-input norm.
It does not assert that high true-input norms are bounded by `B`.

## 5. An all-order step with one finite retained order

Fix `z`. Put

\[
 B=z^{-a-4},\quad \beta=6/5,\quad\lambda=11/10,\quad
 \tau=t^\beta,\quad s=t^\lambda,\quad
 \delta=t^k,\quad r=q=40(k+1),\quad k\ge10 .
                                                               \tag{24}
\]

Assume `||G-f_z||C2<=rho/2`, `H=delta^{-2}(h_z-gamma(G))`
belongs to a sufficiently small fixed `C^0` neighborhood of `h_z`,
and `X_r(t)<=B`. Let `delta'` be either `tau^k` or `tau^{k+1}`.
By (23), `G_s` is in the admissible ball. Apply (9), at `G_s`, to

\[
             A_s=H_s-(\delta'/\delta)^2(h_z)_s .
                                                               \tag{25}
\]

It lies in `U_0` for small `t`, using (23), the neighborhood gap,
and `delta'/delta -> 0`. All smoothed weighted input norms required
by (9) are bounded by a fixed multiple of `B`, whatever their order.
Thus, for each fixed `m,k`,

\[
 |U|_{m,\tau}\le C_m(z,k)\delta\tau,\qquad
 |E|_{m,\tau}\le C_m(z,k)\{\delta(\tau/s)^q+\delta^3/\tau\},
                                                               \tag{26}
\]

where `E=gamma(G_s+U)-gamma(G_s)-delta^2 A_s`.
The inverse domain threshold is polynomial in `z^{-1}` for each `k`;
each fixed output constant is polynomial for each `k,m`.
Their exponents are independent of implicit input constants.
Indeed every finite expression in Section 3 consists of differentiation,
addition, multiplication and the inverses/normalizations whose margins
were bounded in Section 2. Finite sums over `O(z^{-2ell})` phases only
add finite powers: the depth and number of nested sums depend on `k,m`,
not on the number of cells. Their term counts are therefore polynomial
in that number. No expression introduces a high true-input norm.
Section 3.2 proves that the
domain threshold requires only a finite list of these expressions.

Add `U` to the **unsmoothed** map, set `G'=G+U`, and let
`H'=delta'^{-2}(h_z-gamma(G'))`. For
`C(V,U)_{ij}=<V_i,U_j>+<V_j,U_i>`, exact expansion gives

\[
 \delta'^2(H'-h_z)
 =\delta^2(H-H_s)-E-C(G-G_s,U)
       +\delta'^2((h_z)_s-h_z).                        \tag{27}
\]

The last term is absent for the manuscript's choice of an unsmoothed
fixed target in (25). Smoothing the varying target here is essential:
otherwise its unbounded higher norms could enter the mode constants.
There is **no square of `G-G_s`** in (27). Its only product has a
smoothed-input increment as the second factor.

Weighted differentiation of (26) gives
`|dU|_{m,tau} <= C_m(z,k)delta`. Apply (23) to the other factors.
After division by the smaller choice `delta'^2=t^{2*beta*(k+1)}`,
the six non-target exponents are

\[
 {13k+8\over5},\ {3k-18\over5},\
 {18k+8\over5},\ {38k+28\over5},\
 {13k+8\over5},\ {33k+28\over5}.                       \tag{28}
\]

The extra target-tail exponents are `r/10` and `r/5`.
Every exponent is at least `1/5` for `k>=10`. This algebra is useful
**only after** (23), (26), and (27) have established linear high-input
dependence. We conclude

\[
 |H'-h_z|_{m,\tau}
        \le C_m(z,k)t^{1/5}(1+X_m(t)).                 \tag{29}
\]

Positive weighted orders of the inherited `G` and `h_z` gain at least
`tau/t=t^{1/5}`. Also `|j^2 U|_{m,tau}<=C_m delta/tau`.
Since (22) contains both `H'` and `h_z`, the resulting recurrence is

\[
 X_m(\tau;G',H',h_z)
 \le \|G\|_{C^2}+2\|h_z\|_{C^0}
          +C_m(z,k)t^{1/5}(1+X_m(t;G,H,h_z)).          \tag{30}
\]

For the manuscript's fixed target one can omit its additional component
in (22), recovering its baseline
`||G||C2+||h_*||C0` instead. Neither version puts an uncontrolled
true-input norm into the threshold or into `C_m(z,k)`.
The cap `z^{-a-4}` is convenient rather than essential: any fixed
polynomial cap with exponent greater than `a` works. In particular,
with `a=2` and fixed target, one may take the manuscript's `B=z^{-4}`.

## 6. Uniform finite initialization

By (1), (3), and `B=z^{-a-4}`, all maps in the `rho` ball satisfy,
for sufficiently small `z`,

\[
             \|G\|_{C^2}+2\|h_z\|_{C^0}<B/4 .        \tag{31}
\]

For each fixed `z,k`, impose a scale threshold which makes the step
valid, preserves the normalized-defect neighborhood, preserves
`X_{r(k)}<=B` by (30), and ensures

\[
                 \|U\|_{C^{\lfloor k/2\rfloor}}\le\rho t .
                                                               \tag{32}
\]

The last condition is available because its unabsorbed power of `t`
is `k+(6/5)(1-floor(k/2)) >= (2/5)k+6/5 > 1`.
It also keeps the segment inside the required `C^2` domain.
All these are finitely many inequalities at a fixed `k`, with
polynomial `z` constants and strictly positive `t` powers. Thus their
inverse threshold is polynomial in `z^{-1}`.

For `k=10` there is therefore a **fixed** real `mu>1` such that
`t_0=z^mu` satisfies every threshold for sufficiently small `z`.
Choose it larger if needed so that

\[
             \mu>b+2a+1,\qquad 20\mu-a>J .
                                                               \tag{33}
\]

No exponent in this choice depends on an implicit input constant:
an inequality `C z^{-A} t^e < z^F`, `e>0`, holds eventually
at `t=z^mu` whenever `mu*e>A+F`. This is the entire
constant-independence argument, including the geometric thresholds.
Choose an integer `N>20mu+1`, and put

\[
 \delta_0=t_0^{10},\qquad
 G_0=\sqrt{1-\delta_0^2}\,f_z,\qquad
 H_0=h_z+(1-\delta_0^{-2})(\gamma(f_z)-h_z).            \tag{34}
\]

The formula for `H_0` is exact. Its error relative to `h_z` tends to
zero in `C^R`, since `N-20mu>0`. The weighted jets of `G_0` are
bounded by
`C z^{-a} sum_{j=0}^R z^{(mu-b)j}`.
Those of the target are bounded by (5) and (33), and hence by a
constant plus a quantity tending to zero. Consequently `X_R(t_0)<B/2`.
Moreover `||G_0-f_z||C2=O(z^{20mu-a})<=rho/4`.
This proves initialization with exactly `R=440`.

## 7. Finite waiting, smooth convergence, and proximity

After each step replace `t` by `t^{6/5}`. Thus
`t_n=t_0^{(6/5)^n}` tends to zero. If `t_0` is small enough,
`t_{n+1}<=t_n/2`, so `sum t_n <=2t_0<1/4`.
Equations (32) and (34) keep all maps in the `rho/2` ball,
and therefore preserve (31) and every geometric margin.

Hold `k` fixed temporarily. For any one fixed observation order `m`,
(30) gives finite nonnegative numbers satisfying

\[
        x_{n+1}\le B/4+c_n(1+x_n),\qquad
        c_n=C_m(z,k)t_n^{1/5}\longrightarrow0.         \tag{35}
\]

Eventually `c_n<=1/4`, and `B>=1`. From then on
`x_{n+1}<=B/2+x_n/4`. After shifting the starting index,
induction gives the explicit bound

\[
              x_n\le {2B\over3}+4^{-n}x_0 .           \tag{36}
\]

There is a finite `n` for which
`4^{-n}<B/(3(x_0+1))`, implying `x_n<B`.
Once `x_n<=B`, (35) with `c_n<=1/4` keeps it below `B`.
The initial `x_0` can be arbitrarily large: it changes only this
finite hitting time. This is the universal finite-waiting implication
certified in `Main.lean`; no bounded simulation substitutes for it.

Apply this to `m=r(k+1)`. Wait in the current block until this norm
is at most `B`, the scale satisfies the next block's threshold, and

\[
       C_{r(k+1)}(z,k)t^{1/5}(1+B)\le B/2 .            \tag{37}
\]

These are finitely many eventually satisfied requirements. In particular
the norm condition persists while waiting for the scale requirements.
Then use the already proved smaller-amplitude alternative
`delta'=tau^{k+1}`. Equations (30), (31), and (37) put the new higher
norm below `3B/4`. Its new scale is below the next threshold.
Each block therefore has finite length and `k` increases without bound.
This is a dependent choice of finite block lengths, not an assumption
of a common upper bound for them.

For each fixed `m`, all sufficiently late blocks have
`floor(k/2)>=m`. Their increments are absolutely summable in `C^m`
by (32). In a fixed chart, uniform convergence of each derivative and
the fundamental theorem of calculus identify these limits as the
successive derivatives of the same map. Finite charts give a smooth
limit `fhat_z`. Its defect tends to zero in `C^0` because `H` stays
in a fixed neighborhood of `h_z` and `delta=t^k ->0`.
Continuity of `df^T df` under `C^1` convergence gives
`gamma(fhat_z)=h_z`; positivity makes it an immersion.
Finally

\[
 \|\widehat f_z-f_z\|_{C^2}
 \le\rho/4+\rho\sum_n t_n<\rho/2\le z^L
                                                               \tag{38}
\]

eventually, since `J>L`. This proves the theorem.

## 8. What the certificates do and do not establish

`verify.py` exactly replays the mode-system elimination, metric-transfer
identity (including the varying-target term), positive decomposition
identities, exponent margins, moment construction at the actual initial
retained order, and recorded Jacobian response. These are symbolic or
integer/rational equalities, not floating-point experiments.
The order-440 moment replay is finite; the proof following (20) is the
all-order argument. The Jacobian calculation is a bounded order-four
instance, not a substitute for that argument.

`Main.lean` proves the universal scalar waiting bound and finite hitting
time, its order-of-growth inequality, and the transfer algebra. Its
separate fidelity document specifies its exact limited coverage.
Analytic smoothing estimates, local differential construction bounds,
finite-jet domain induction, and interpretation as immersion theory
are proved above and require independent mathematical reading.

No false literal manuscript assertion has been established in this
scope. In particular, this verification does not convert an untested
perturbed operator assertion or an unaudited global step into a proved
claim. Reviewer acceptance and the novelty/significance determination
remain pending.
