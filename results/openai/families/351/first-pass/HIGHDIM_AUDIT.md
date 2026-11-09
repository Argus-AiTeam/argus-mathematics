# High-dimensional bounded-scalar mechanism

The object under audit is the implication in Sections 2--6 of
`A-closed-Ricci-flow-with-bounded-scalar-curvature-and-finite-time-curvature-blowup-September-24-2026/build`.
The principal question is whether the reaction constant in Section 5 is
independent of both dimension parameter q and mode k, and whether the stated
construction inputs suffice for the complete scalar comparison.

## Scope and known input

The source of the singular flow is Stolarski, arXiv:1905.00087v1. A separate
primary-source reader located the following statements in that exact version.
They are external construction inputs, not results newly proved in this audit.

* Definition 3.3, printed page 15 (`BoxDefn.tex`, lines 115--131), gives
  `0 <= U`, `-1/gamma <= U_gamma <= 0`, and
  `0 <= U_gammagamma + U_gamma/gamma` on the inner U interval, and
  `0 <= Z <= 1-B^2` on the inner Z interval.
* The proof of Theorem 4.3, printed page 25 (`PointwiseEst.tex`, lines
  63--77 and 104--120), explicitly applies the inner lemmas with
  `Upsilon = 4 Upsilon_Z >= 4 Upsilon_U` and concludes membership in
  `I_(Barrier I)[4 Upsilon_Z,4 Upsilon_Z,tau_0,tau_1]`, hence membership
  with the smaller requested cutoffs.
* Appendix B (`AppendixOfConstants.tex`, lines 5--6 and 52--70) says:
  "This list is ordered such that the each constant depends only on the
  constants above it." Small tolerances precede the inner cutoffs; the
  Z-cutoff can depend on the U-cutoff and the starting time on both.
  Enlargements are sequential finite choices, not changes with all later
  parameters frozen.
* `B^2 lambda_k=-nu`, `alpha_k=nu/d`, and
  `sigma=alpha_k+1/2=k/d`. With `r=sqrt(delta) gamma`,
  `f=1+gamma U_gamma` and
  `f_r=gamma (U_gammagamma+U_gamma/gamma)/sqrt(delta)`.
  Thus the quoted source inequalities are precisely the inner inequalities
  used in the staged manuscript.

The citation-omission attack based solely on the shorter Definition 4.1 is
retired: its missing list is not the propagation theorem, and the proof of
Theorem 4.3 expressly invokes the stronger barriers. This closes that attack,
not the scalar-curvature question.

No staged manuscript assertion has yet been established false. In particular,
the source's apparent physical-scale sign typo reported by the reader is
not attributed to the staged manuscript, whose scale conversion is correct.

The remaining construction-source lookup is preserved in
`certificates/highdim-ricci-scalar/literature/stolarski-profiles/REPORT.md`
and its primary-source excerpts. Definition 3.1 supplies the two-derivative
weights; Definition 3.5 and Lemma 3.6 use the same initial expansion and
outer-sign endpoint. The lower homogeneous Z-mode index is `K=k-3`, so
its largest growth is `2k-4<2k-d`, since `d<4`. Existence is the input
of Lemma 3.12 and the proof of Theorem 1.1. The construction's degree
argument and parameter hierarchy are imported, not reproved here.

## Result and mathematical scope

**Conditional verification theorem.** For the flows satisfying the precise
construction input in Section 2, the parameter choices in Section 6 can
be made in their stated order. They imply a uniform global scalar bound,
and `(r^2+theta^2)|Rm|<=C` together with
`c theta<=phi(0,t)<=C theta`. Consequently the full curvature diverges
at the finite terminal time. The constant in the leading reaction
estimate is independent of q and k.

In fact, the reaction estimate can be sharpened to
\[
 c(x,t)\le {2(q-1)+C_{\rm sharp}\over r^2},
 \tag{V1}
\]
where `C_sharp` is numerical, independent of both q and k, for all
sufficiently large q. This is stronger than the staged manuscript's
`O(sqrt(q))` error, not a refutation of it.

**Continuous-exponent extension.** Suppose a smooth closed doubly warped
Ricci flow with p=2 has the two monotone hemispheres and polar expansions
described above. Require time-uniform bounded r and warping slopes and
`phi/r>=c_0>0` globally. There must be fixed `Y_2>=Y_1>1` such that,
at late times on both hemispheres, `0<=f=ru_r<=1` and `f_r>=0` for
`r<=Y_1 theta`, and `B^2<=z<=1` for `r<=Y_2 theta`, with
`A^2=1/(q+1)` and `B^2=(q-1)/(q+1)`. Require fixed positive
`epsilon_1` and finite `C_gap` with `phi/r>=A/B+epsilon_1` on
`r<=Y_1 theta` and `phi(Y_1 theta,t)<=C_gap theta`.
All these constants may depend on the fixed flow.
Assume also the uniform inner estimates
\[
 |z-1|\le4/q,\quad |ru_r|\le2,\quad
 r^2 e^{-2u}\le(q-1)(1+4/q)
 \quad(0<r\le\sqrt\delta),
 \tag{V2}
\]
on the full monotone interval up to `sqrt(delta)` on each hemisphere,
and `|Ric|<=C_[a1,a2] delta^(nu-1)` on every fixed positive parabolic
annulus `a1 sqrt(delta)<=r<=a2 sqrt(delta)`, at sufficiently late
times depending on that annulus. Let `theta=delta^sigma`, where
\[
 \sigma>1/2,\qquad \nu>\max\{1,\sigma\}.
 \tag{V3}
\]
For sufficiently large q, depending on these fixed exponents and the
universal constants but not on subsequent flow-dependent cap constants,
the scalar curvature is uniformly bounded. This conclusion is conditional
on the stated geometric hypotheses; it asserts no new existence theorem
for arbitrary continuous exponents.

The proof below supplies the cap estimates; they are not added as
unjustified assumptions. Its analytical external inputs are the classical
one-dimensional heat estimate and global/local Shi derivative estimates.
The exact script checks their algebraic applications, not those external
analytic theorems or the maximum principle. Independent Reviewer judgement
is pending. No claim of global bibliographic novelty, Lean certification,
or machine verification of an analytic PDE theorem is made.

### 1. Elementary geometry and the external analytic inputs

Write `p=2`, `m=p+q`, and orient each hemisphere outward from its pole.
The construction supplies `r_s>0` there and smooth odd/even polar
expansions. Put `v=r_s`, `z=v^2`, and `u=log(phi)`. At a regular orbit
the five sectional curvatures are
\[
 h=-\phi_{ss}/\phi,\quad h_q=-r_{ss}/r,\quad
 j=(1-\phi_s^2)/\phi^2,\quad
 \ell=(1-r_s^2)/r^2,\quad
 \mu=-\phi_s r_s/(\phi r).
\]
The Ricci eigenvalues are
`p h+q h_q`, `h+(p-1)j+q mu`, and `h_q+(q-1)ell+p mu`.
For the evolution identities we use Cao--Zhu, Corollaries 1.3.2--1.3.3,
printed pages 184--185: the covariant Ricci tensor evolves by
`D Ric=2 Rm(Ric)-2 Ric^2` and scalar curvature by
`D R=2|Ric|^2`. In its squared evolving norm, the two inverse-metric
derivatives contribute `+4 tr(Ric^3)`, cancelling the covariant
tensor equation's `-4 tr(Ric^3)`. Consequently
`D |Ric|^2=-2|nabla Ric|^2+4<Rm(Ric),Ric>`. This fixes the
sign and the factor of two used in the reaction quotient.
The curvature-norm identity is
\[
 |\mathrm{Rm}|^2=4\{ph^2+qh_q^2+
 p(p-1)j^2/2+q(q-1)\ell^2/2+pq\mu^2\}.
 \tag{1}
\]
These formulas use unit-sectional-curvature sphere metrics.

The warping flow equations and the commutator
`[partial_t|_x,partial_s]=(p h+q h_q)partial_s` give the slope equation
in Section 3. At an interior maximum `r_s>1` its zeroth-order term is
negative; at an interior minimum below `-1` it is positive. Polar endpoint
values are `1,-1`. The same argument for `phi_s`, whose polar values are
zero, bounds both slopes by their initial values and one. A maximum of r
decreases. The scalar equation `D R=2|Ric|^2` gives a time-uniform lower
bound for R. All arguments first take place on compact smooth time slabs.

For scalar compositions, including across the equator,
\[
 {\cal D}F=F_t|_r-zF_{rr}-{q-1+z\over r}F_r,\qquad
 {\cal D}\log(\phi/r)={q-1\over r^2}-{p-1\over\phi^2}.
 \tag{2}
\]
The sideways equations on a monotone hemisphere are
\[
 u_t=zu_{rr}+{q-1+z\over r}u_r-(p-1)e^{-2u},\quad
 v_t=zv_{rr}+{q-1-z\over r}v_r+
 {(q-1)v(1-v^2)\over r^2}-pv^3u_r^2.
 \tag{3}
\]
The supplied positive small-profile coefficient, small tolerance, and
`0<=f=ru_r<=1` yield a fixed strict inner gap
`phi/r>=A/B+epsilon_1` and `phi(Y_1 theta,t)<=C theta`.
The number `epsilon_1>0` can depend on all selected flow parameters.
Increasing first `Y_1` and then `Y_2` absorbs every profile constant
`C_(q,k)` and gives (V2), with numerical constant 4. No uniformity of
the cutoffs or starting time in q or k is asserted.

For the global lower ratio, the positive large-profile coefficient gives
`U>=0` at a fixed sufficiently large parabolic radius. The initial
profile estimate and outer sign meet at the same initial endpoint.
Comparison of the second equation in (2) with the equilibrium
`log(A/B)` propagates this sign over the exterior, including both
hemispheres. On the remaining compact gamma intervals the profiles,
and then the inner bounds, give `phi/r>=c_0>0`. Earlier time intervals
are compact and smooth. On each fixed positive gamma annulus, the
rescaled metric is a two-derivative `O(delta^nu)` perturbation of the
Ricci-flat cone, which gives the stated annular Ricci bound. Positivity
of z there excludes an equator in any such fixed annulus at late times.

The only linear parabolic estimate used below is the constant-coefficient
estimate
\[
 \|V_{yy}\|_s+\|V_\rho\|_s
 \le C_s\|V_\rho-V_{yy}\|_s,\qquad s=4.
 \tag{4}
\]
Krylov, arXiv:math/0610955v1, Theorem 5.5, printed pages 15--16,
states this for `W_s^(1,2)` functions with constant elliptic spatial
coefficient, after reversing time. Its hypothesis is not a bound for
derivatives of the variable coefficient. The exact v1 TeX and PDF are in
`certificates/highdim-ricci-scalar/literature/krylov/`.
One may apply the whole-time estimate after continuing a function
vanishing in the distant past by the homogeneous forward heat flow
beyond time zero. With s=4 this continuation is in the required
whole-time spaces; the one-dimensional heat tail has integrable fourth
power. Thus no vanishing terminal trace is required.

Shi's estimates, in the explicit statements of Cao--Zhu,
Asian J. Math. 10 (2006), Theorems 1.4.1--1.4.2, printed pages 190--193,
are also used. The global version bounds
`|nabla Rm|<=C M/sqrt(t)` for a complete flow with `|Rm|<=M`
and `0<t<=1/M`. The local version assumes `|Rm|<=M` on
`U x [0,theta_dim/M]` and an initial closed metric ball
`B_0(p,r)` contained in U, and yields
`|nabla Rm(p,t)|^2<=C M^2 (1/r^2+1/t+M)`.
There is no injectivity-radius hypothesis. The actual journal PDF and
text are preserved under `literature/cao-zhu/`. The cited mirror returned
HTTP 403; the journal's primary PDF was obtained successfully.

### 2. Radius and cap estimates, without a cap-model assumption

Here every constant may depend on the chosen flow and dimension.
First suppose `r^2|Rm|` is unbounded, and take increasing record points
with `r_i^2 Q_i=max_(M x [0,t_i]) r^2|Rm| -> infinity`.
Boundedness of r gives `Q_i->infinity` and `t_i->T`.
Since `|partial_t|_x r^2|<=C_m r^2|Rm|`, on
`[t_i-b/Q_i,t_i]` the variation of `r(x,t)^2` at every fixed manifold
point is at most `r_i^2/16`, for a fixed sufficiently small b.

Rescale by `Q_i`. On every fixed-radius ball in the metric at the
initial time `-b`, the Lipschitz bound for r and
`r_i sqrt(Q_i)->infinity` imply `r>=r_i/2` for all these times.
The record bound gives `|Rm|<=4` on this fixed spatial domain.
Integrating Ricci flow there compares its metrics by a factor E,
independent of i and the fixed ball radius. Take that radius larger
than `E+2`. A final curve of length at most one cannot exit the
initial ball, since its initial length to first exit is at least the
ball radius. Every point on the final unit ball therefore has an
initial ball of uniform positive radius lying in the controlled
domain. Choose b below the dimension-dependent local Shi time.
The local estimate applies with its actual initial-ball hypothesis
and bounds the final `|nabla Rm|` uniformly on the final unit ball.

Both rescaled warping factors `sqrt(Q_i) phi` and `sqrt(Q_i) r`
tend uniformly to infinity on a fixed short radial interval about the
record point, since `phi>=c_0 r` and their derivatives are bounded.
The distance to a pole tends to infinity by the Lipschitz estimate.
Their tangential sectional curvatures tend to zero. By (1), a radial
sectional curvature stays nonzero at the center. Parallel transport
of the radial unit vector and a sphere-tangent vector along the radial
geodesic and the derivative bound keep that same curvature of one sign
and uniformly away from zero on a fixed subinterval. Integrating
`F''=-h_a F` then contradicts bounded `F'`. Hence `r^2|Rm|<=C`.

Next the pole radius satisfies `c theta<=phi(0,t)<=C theta`.
For clarity, the lower bound is not obtained from a limiting cap.
The exact scalar formula is
\[
 r^2R={p(p-1)\over(\phi/r)^2}+q(q-1)(1-z)
 -pz\{(p+1)f^2+(2q-2)f+2rf_r\}-(pf+q)rz_r.
 \tag{5}
\]
If `L_0=phi(0,t)=o(theta)`, bounded slopes and `r_s>=B` imply
`phi(L_0,t)/L_0<=1+C/B`. For `r_*=(L_0 theta)^(1/2)`,
the positive lower ratio gives
`0<=integral_[L_0,r_*](1-f)dr/r<=C`.
Since `f_r>=0`, this implies `f(r_*,t)->1`, uniformly also for
`r_*<=r<=theta`. At `f=1`, the nondifferentiated terms in (5) equal
`p(p-1)/(phi/r)^2+q(q-1)-m(m-1)z`. The strict cone gap and `z>=B^2`
bound this above by `-kappa<0`. The `f_r` term is nonpositive.
The scalar lower bound therefore forces
`(pf+q)rz_r<=-kappa/2`, and hence
`rz_r<=-kappa/(2m)`, on this whole annulus at late times.
Its logarithmic width tends to infinity, contradicting
`B^2<=z<=1`. The upper pole-radius bound follows from `f>=0`
and the interface upper bound. Monotonicity also gives
`phi>=c theta` throughout the inner interval.

Put `w=1-v`. In the inner region (3) gives
\[
 [\partial_t-z\partial_{rr}-(q-1-z)r^{-1}\partial_r
 +(q-1)v(1+v)r^{-2}]w=pv^3u_r^2\le C\theta^{-2}.
 \tag{6}
\]
Here `u_r=phi_s/(phi v)` and the established pole lower bound
justify the right-hand inequality. The operator applied to `r/theta`
is
`sigma r/(delta theta)+{(q-1)[v(1+v)-1]+z}/(r theta)`.
For q large, `B(1+B)>1`, so this dominates a fixed positive multiple
of `theta^-2` on `r<=theta`. Initial and moving outer data are
dominated by one sufficiently large multiplier. On each compact time
slab polar smoothness gives `w=O(r^2)` uniformly. Excision at
`r=eta`, comparison, and then `eta->0` give
`0<=1-v<=C r/theta`, with one multiplier independent of the slab.

Finally suppose `theta^2|Rm|` is unbounded and take records with
`theta_i^2 Q_i->infinity`. Monotonicity of theta gives
`|Rm|(x,t)<=Q_i` for all `t<=t_i`; global Shi therefore applies
on a fixed backward rescaled interval and bounds the final gradient.
The already proved radius bound gives `r_i sqrt(Q_i)<=C`.
Every fixed short outward radial interval is in `r<=theta_i`,
because `theta_i sqrt(Q_i)->infinity`. There
`sqrt(Q_i)phi->infinity` and `v->1` uniformly. Moving a small
fixed outward distance keeps curvature bounded below, while making
the rescaled radius bounded below. All tangential curvatures then
tend to zero. By (1) and the gradient bound a radial curvature has
one sign on a fixed interval. For the phi factor integration
contradicts bounded derivative and diverging radius; for the r factor
it contradicts `v->1` and a radius bounded below. This includes
records on a pole by choosing any outward ray. Thus
\[
 (r^2+\theta^2)|\mathrm{Rm}|\le C.
 \tag{7}
\]
In particular `c<=C_*/theta^2`, including poles by continuity, and
`c<=D_1/r^2` globally at positive r, with fixed flow-dependent constants.

### 3. The moving cylinders really are uniform in q and k

First prove the perturbative interior lemma rather than assume a
coefficient-derivative bound. For `H_rho=a H_yy+b H_y+F`,
`|a-1|<=epsilon_0` and `|H|+|b|+|F|<=K`, multiply by a cutoff
between `P_R1` and `P_R2`. The exact expansion is the one in Section 5.
Apply (4), choose `epsilon_0 C_4<1/2`, and absorb the second derivative.
Interpolation in the spatial interval, with parameter a sufficiently
small multiple of `R2-R1`, gives
\[
 E(R_1)\le E(R_2)/16+C(K)(R_2-R_1)^{-2},
 \quad E(R)=\|H_{yy}\|_4+\|H_\rho\|_4.
\]
For `R_j=7/4-2^(-j)/4` the errors sum geometrically and the remainder
tends to zero, since `E(7/4)` is finite for each individual smooth H.
This yields `E(3/2)<=C(K)` and the interpolated first derivative norm.
For completeness, the last pointwise gradient estimate need not import
an additional Sobolev reference. Localize once more, apply the heat
representation, and use Holder's inequality with the gradient heat
kernel on a finite time interval. In one space dimension that kernel
is in `L^(4/3)` near time zero:
its time integral scales as `integral_0^1 t^(-4/3+1/2)dt<infinity`.
The localized forcing is in L4 by the estimates just established.
This gives `|H_y|<=C(K)` on P1, including its terminal time.

At `(r_c,t_c)` put `h_c=r_c/sqrt(q)` and
`R_c(t)^2=r_c^2+2(q-1)(t_c-t)`. On P2, q>=16,
`1<=R_c/r_c<=3` and `r=R_c+h_c y` satisfies
`r_c/2<=r<=7r_c/2`. If `r_c<=sqrt(delta_c)/8`,
then `r^2<=49 delta_c/256<delta(t)`. The backward time length
is at most `delta_c/(16q)`. Thus one flow-dependent late threshold
puts every such cylinder in (V2); no threshold uniform in k is needed.

For `H=q(v-1)`, the pulled-back coefficients are exactly
\[
 a=z,\quad b=h_c[(q-1)(1/r-1/R_c)-z/r],\quad
 F=q h_c^2[(q-1)v(1-z)/r^2-pv^3u_r^2].
\]
Here `q|v-1|<=4`, `|a-1|<=4/q`, and `q h_c^2=r_c^2`.
The drift cancellation is the exact identity
`h_c(q-1)(1/r-1/R_c)=-(q-1)h_c^2 y/(r R_c)`.
All coefficients and amplitudes are bounded by numerical constants,
not by a dimension-dependent parabolic estimate. The lemma gives
`|z_r|<=C/(r_c sqrt(q))` on P1.

Differentiate the u equation in (3). For `w=u_r` its drift is
`z_r+(q-1+z)/r` and its potential is
`z_r/r-(q-1+z)/r^2+2(p-1)e^(-2u)`.
On P1 rescale `W=r_c w`. The preceding derivative estimate, (V2),
and `h_c^2 (p-1)e^(-2u)<=C` bound the transformed drift, potential,
and W numerically. Apply a fixed smaller-cylinder form of the same
interior lemma and evaluate at its center. There is a numerical
`K>=1`, fixed before q and k, such that
\[
 |rz_r|\le K/\sqrt q,\qquad r^2|u_{rr}|\le K\sqrt q.
 \tag{8}
\]
The late time can depend on the selected flow. This is precisely
the distinction needed to avoid circular dimension selection.

### 4. A sharper reaction estimate

On invariant diagonal tensors use the norm coordinates
`(alpha,sqrt(p) beta,sqrt(q) chi)`. The curvature action is the
symmetric matrix
\[
 M=\begin{pmatrix}
 0&\sqrt p h&\sqrt q h_q\\
 \sqrt p h&(p-1)j&\sqrt{pq}\mu\\
 \sqrt q h_q&\sqrt{pq}\mu&(q-1)\ell
 \end{pmatrix}.
 \tag{9}
\]
The ordered mixed terms are `2p h alpha beta`,
`2q h_q alpha chi`, and `2pq mu beta chi`; no factor of two
is lost in the norm. Kato's inequality applied to the evolving
Ricci norm gives `D|Ric|<=c |Ric|` wherever that norm is nonzero,
where c is twice the Rayleigh quotient of (9).

Multiply (9) by `r^2`, and split off the p-sphere coordinate. The
remaining two-dimensional block has upper quadratic bound
`D_low=4+K/2`, by `|sqrt(q) h_q r^2|<=K/2` and
`|(q-1)ell r^2|<=4`. The separated diagonal is at most `q-1+4`.
Using (8), `z<=2`, and `|f|<=2`, its coupling vector obeys
\[
 |v_{\rm mix}|^2\le E q,\qquad
 E=(6K+16)^2+64.
\]
Indeed `|h r^2|<=2K sqrt(q)+8+K/sqrt(q)`,
`|sqrt(p)h r^2|<=(6K+16)sqrt(q)`, and
`|sqrt(pq)mu r^2|<=8 sqrt(q)`.

For a separated coordinate x and a two-vector y, Young's inequality
gives
`2x v_mix.y <=2E x^2+(q/2)|y|^2`. If `q>=K+10`,
then `D_low+q/2<=q-1+4+2E`. Hence
\[
 \lambda_{\max}(r^2M)\le q-1+4+2E,\qquad
 C_{\rm sharp}=8+4E.
 \tag{10}
\]
This proves (V1) for every admissible q, not a finite parameter sample.
The original `C sqrt(q)` estimate follows immediately with
`C=C_sharp` for q>=1. The improvement exploits the gap rather than
the characteristic polynomial. The latter was independently computed
once by Jacobian and replayed locally only as an algebraic cross-check.

### 5. Quantifier-complete scalar comparison

Here is the precise comparison implication. Fix numerical K and
`C_sharp` before q. Choose `a>2` and q large enough for (8)--(10),
`q>3`, and
\[
 {\mathfrak m}=(a-2)(q-1)-C_{\rm sharp}-2a^2-1>0.
 \tag{11}
\]
Next fix `L>0`, `sigma>1/2`, and the flow, with
\[
 0<e=a-L/\sigma<1,\quad \nu>1,\quad
 \nu-1-L+a/2\ge0.
 \tag{12}
\]
Constants `C_*` and `D_1` in (7) are now fixed. Only then choose
`b_0>0` with `b_0 C_*<mathfrak m`, and put
`xi=min(1/8,1/(2 sqrt(L)))`. Later time restrictions do not alter
any selected flow parameter.

Set `D_0=r^2+b_0 theta^2` and `H=delta^L D_0^(-a/2)`.
Direct differentiation gives
\[
 {{\cal D}H\over H}
 =-{L\over\delta}+{a\sigma b_0\theta^2\over\delta D_0}
   +{a(q-1)+2az\over D_0}
   -{a(a+2)zr^2\over D_0^2}
 \ge -{L\over\delta}+{a(q-1)-a^2z\over D_0}.
 \tag{13}
\]
The difference from the lower expression is exactly the sum of
`a sigma b_0 theta^2/(delta D_0)` and
`a(a+2)z b_0 theta^2/D_0^2`, both nonnegative.
Late enough, on `r<=xi sqrt(delta)`, `L D_0/delta<=1`
and `z<=2`. The two independent upper bounds for c give
`c D_0<=2(q-1)+C_sharp+b_0 C_*`, also if c is negative.
At a pole the cap bound alone gives this inequality, and H is
smooth because `r^2` is smooth. Thus
`D H/H-c >=(mathfrak m-b_0 C_*)/D_0>0`.

On the moving lateral boundary,
`|Ric|/H<=C delta^(nu-1-L+a/2)`, uniformly by (12).
One multiplier dominates these data for all future times and the
compact starting slice. A first contact has `|Ric|>0`, where its
norm is smooth. The strict differential inequality excludes it;
pole orbits are interior points, not extra boundaries. Consequently
\[
 |\mathrm{Ric}|\le C\delta^L(r^2+b_0\theta^2)^{-a/2}
 \le K_R r^{-e}\quad(r>0).
 \tag{14}
\]
The last step uses `delta^L=theta^(a-e)` and splits `r>=theta`
and `r<=theta`. The latter inequality has a singular right side
at the pole; it does not assert singularity of the actual tensor.

Let `ell_0=2-2e` in `(0,2)`. Equation (2) gives
\[
 {\cal D}(-r^{\ell_0})=\ell_0(q-1+\ell_0 z)r^{-2e},
 \quad {\cal D}(r^{-1})=(q-1-z)r^{-3}.
\]
For `C_2>=2K_R^2/[ell_0(q-1)]`,
`S_epsilon=C_1-C_2 r^ell_0+epsilon/r` satisfies
`D S_epsilon>=2|Ric|^2` at positive radii.
Choose a late fixed starting time and a single C1 larger than the
starting and lateral scalar suprema plus
`C_2 (xi sqrt(delta_0))^ell_0`. The lateral scalar data are bounded
because `nu>1`. For any fixed `epsilon>0` and compact slab ending
before T, scalar smoothness is uniform; choose a small excision
radius eta so that `epsilon/eta` dominates its scalar data for the
entire slab. The outer moving boundary is regular by `r_s>0`.
Comparison on the excised moving domain, then `eta->0`, and then
`epsilon->0` at each positive-radius point gives `R<=C_1`.
C1 is independent of epsilon and of the slab endpoint. Continuity
at each fixed time gives the same bound at the poles.

For the full exterior choose `b_1>2D_1+1` and
`Gamma^2>=max(2b_1,4(q-1))`, `Gamma>xi`.
The smooth geometric function `H_o=1-b_1 delta/r^2` has
`1/2<=H_o<=1` there and
\[
 {\cal D}H_o={b_1\over r^2}
 [1-(2(q-1)-4z)\delta/r^2]\ge {b_1\over2r^2}
 > D_1 H_o/r^2.
\]
This uses only `z>=0` on the exterior. Annular data at Gamma
and compact initial data fix one multiplier, and first contact
gives a bounded Ricci norm there. The equator is interior to the
full geometric exterior, even though r is not a coordinate there.
The intervening fixed gamma annulus is controlled directly.
Combine the scalar upper bound with the elementary scalar lower
bound and compactness of earlier smooth time intervals. This proves
the global two-sided scalar bound with all constants fixed before
t tends to T.

### 6. The original parameter order and the continuous extension

For the manuscript take `a=5/2`. When `q>=16`,
\[
 d={q+1-\sqrt{(q+1)(q-7)}\over2}\in(2,5/2).
\]
For example d is the smaller root of `d^2-(q+1)d+2(q+1)=0`;
the polynomial is positive at 2 and negative at 5/2.
The heat constants, K, and `C_sharp` were fixed numerically first.
Choose q large enough for (11), all preceding large-q conditions,
and, if using the manuscript's original weaker estimate, its
stated `C sqrt(q)` margin as well.
Next choose an even k sufficiently large for the construction and
at least 6. With `L=k-1`, `sigma=k/d`, and `nu=k-d/2`,
\[
 e=5/2-d+d/k\in(0,1),\qquad
 \nu-1-L+a/2=(a-d)/2>0.
\]
Also `nu>1` and `sigma>1/2`. All tolerances, cutoffs, and starting
time can now be chosen sequentially as in the construction; there
is no backwards dependence of q on a flow-dependent cap constant.
After the flow is fixed choose b0 and the later comparison times.
Thus (11)--(14) prove the scalar conclusion for the original
discrete-mode inputs. The pole-size upper bound makes
`j(0,t)=phi(0,t)^(-2)->infinity`, since `phi_s=0` at the pole.
Together with smooth existence for every earlier time and compact
uniqueness, T is the finite maximal smooth existence time.

For the extension fix any real `sigma>1/2` and
`nu>max(1,sigma)`. Set
\[
 \eta=\min\{1/2,(\nu-\sigma)/(2(\sigma-1/2))\},\quad
 a=2+\eta,\quad
 g=\nu-\sigma-\eta(\sigma-1/2)>0,
\]
\[
 w=\min\{\sigma/2,g/2\},\qquad
 L=\sigma(a-1)+w.
\]
Then `g>=(nu-sigma)/2>0`, `L>0`,
`e=1-w/sigma` lies in `[1/2,1)`, and
`nu-1-L+a/2=g-w>=g/2>0`.
Choose q next so that (11) and the uniform derivative thresholds
hold; all flow-dependent constants and b0 still come afterwards.
This proves (V3) implies the comparison hypotheses, and hence the
global scalar conclusion, under the explicitly stated geometric
inputs. This is a continuous-exponent structural extension carrying
the conclusion, not an isolated symbolic observation.

## Reproducibility and limits

Run
`$WORKSPACE/argus-live-update/.venv/bin/python research/certificates/highdim-ricci-scalar/verify.py`.
The certificate checks exact identities and universal positivity
reductions, not floating-point samples. Its saved Jacobian request,
typed contract, result, protocol/server version, and successful
adapter status are in the adjacent `jacobian/` directory. No timeout,
transport error, or unknown result is interpreted mathematically.

No staged false assertion was identified in this selected dependency
chain, so no artificial F-claim is introduced. This is an analytical
conditional verification with a stronger reaction estimate and a
continuous-exponent extension. It is not a Lean proof or an independently
accepted publishable result yet. The broader literature search located
the target manuscript and Stolarski, but did not settle priority of
the extension; search absence is not novelty certification.

Independent source attribution remains for the Host-invoked Reviewer.
The citation tool's `attribute` command archives into
`research/literature/`, which is outside this mission's authoritative
writable paths. No such out-of-scope archive was created. Primary
sources and excerpts available inside the owned certificate subtree
are ready for review; a permitted archival path is needed before
claiming the citation delivery gate has cleared.
