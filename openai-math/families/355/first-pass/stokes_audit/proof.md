# A nonvanishing translator jump for radial weights between one and two

## Result and scope

For every real \(m\in[1,2]\), consider, on the indicated branches,
\[
 h'=l,\qquad l'=(1+l^2)(1-ml/y).                         \tag{1}
\]
There are unique upper and lower exterior sectorial slopes with
\(ml/y\to1\), on sectors containing respectively
\(\arg(y^2)=2\pi/3\) and \(-2\pi/3\) and a common neighborhood of
the positive ray. Their common formal expansion has an all-order
Gevrey remainder. On the positive ray,
\[
 l_{m,+}-l_{m,-}
   =c_m y^{4-m}e^{-y^2/(2m)}(1+O(y^{-2})),\qquad c_m\ne0. \tag{2}
\]
The estimates can be taken uniformly in \(m\in[1,2]\).
The multipliers are continuous, purely imaginary, and nonzero throughout
this interval; in particular their imaginary signs agree and
\(\min_{[1,2]}|c_m|>0\). No numerical value or choice of that sign is asserted.

For
\[
 L_m=y^m e^h\sqrt{1+l^2},\qquad
 P_m=y^m e^h l/\sqrt{1+l^2},                            \tag{3}
\]
the net boundary comparison of an outward exterior piece and a
stationary inner piece is
\[
 P_m(Y,h_+,l_+)-P_m(Y,h_-,l_-)-\int_0^1P_m\,\partial_t h\,dt
 =\int_0^1Y^m e^h(1+l^2)^{-3/2}\partial_t l\,dt.         \tag{4}
\]
If \(l(t)=l_-+t(l_+-l_-)\) and, uniformly in \(t\),
\(h(t)=Y^2/(2m)-\log Y+o(1)\), the right side tends to
\(m^3c_m\ne0\). Finite exterior bypasses obeying the precise matching
hypotheses below give the same limit.

The case \(m=1\) verifies the scalar conclusion of `jump:stokes` and
the limiting, signed boundary calculation in `jump:primitive` through
`jump:net-comparison`. The interval of weights, its uniform
nonvanishing, and the weighted transfer are a structural extension.
They do **not** prove the existence, estimates, or compatibility of the
manuscript's normalized surface families. Applying (4) to those families
still requires the PDE interfaces explicitly listed in Section 8.
Nor is this a proof of tangent-flow uniqueness.

The analytic argument below is a proof, not a finite experiment.
`verify.py` checks exact algebra and finite recurrence instances.
`lean/Main.lean` separately proves the stated universal recurrence
lower bound and polynomial identities. Neither checker formalizes
the complex-analysis argument.

## 1. Prior results and what is not being imported

The staged manuscript, dated September 24, 2026, already asserts the
\(m=1\) lateral nonvanishing and transfer, and supplies a positivity
argument. Thus their verification alone must not be advertised as an
original discovery. Here that mechanism is extended to every
\(m\in[1,2]\) and its parameter dependence is established.

Clutterbuck--Schnuerer--Schulze, *Stability of translating solutions to
mean curvature flow*, arXiv:math/0509372v1, Section 2, equation (2.1),
give (1) with \(m=n-1\). Lemmas 2.1--2.2 concern real exterior and
entire translators and their real quadratic--logarithmic asymptotics.
The source was opened at
<https://arxiv.org/html/math/0509372v1>; the relevant statements are
transcribed in `CSS2007_excerpt.txt`. They are provenance, not premises
of the proof below. In particular a real-translator theorem is not a
complex-sector selection or nonvanishing theorem.

Two targeted literature searches found no primary source proving the
specific weighted complex nonvanishing theorem above. Search-generated
summaries had mismatched citations and are not mathematical evidence.
This limited negative search is **not** a verification of novelty.
No external summability theorem, Stokes nonvanishing theorem, or
resurgence/large-order correspondence is assumed.

All analytic tools used below are elementary: uniformly convergent
holomorphic iterations, Cauchy's formula and contour deformation,
integrating factors, and the positive-series argument proved in
Section 5. There are no imported geometric hypotheses in (1)--(4).

## 2. Exact reduction and positive recurrence

Put \(\tau=y^2/(2m)\), \(x=(2\tau)^{-1}=m/y^2\), and \(q=1-ml/y\).
Direct substitution, without dropping any term, gives
\[
 q_\tau+q=2q^2-q^3+\frac{1-(m+1)q}{2\tau}.              \tag{5}
\]
For \(D=x\partial_x\), its formal equivalent is
\[
 \begin{split}
 q(1-q)^2&=x(1-(m+1)q+2Dq),\\
 q&=x+x\frac{2Dq-(m-1)q-q^2}{(1-q)^2}
   =x+x\sum_{k\ge1}(2D-mk+1)q^k.                     \tag{6}
 \end{split}
\]
All operations are valid in the formal power-series ring because
\(q(0)=0\), so \(1-q\) is a unit. Consequently there is a unique
formal solution \(q=\sum_{n\ge1}b_n(m)x^n\), with \(b_1=1\), and
\[
 b_{n+1}
 =\sum_{k=1}^n(2n-mk+1)
   \sum_{\substack{i_1+\cdots+i_k=n\\i_j\ge1}}
      \prod_{j=1}^k b_{i_j}.                          \tag{7}
\]
This recursively constructs polynomials in \(m\); it does not presume
convergence.

For \(1\le m\le2\), \(1\le k\le n\), the weights satisfy
\[
 1\le2n-mk+1\le2n-k+1\le2n.
 \]
Every \(b_n\) is positive. The \(k=1\) summand yields
\(b_{n+1}\ge(2n-1)b_n\). Since
\((n+1)(2n-1)\ge2n^2\) for \(n\ge1\), induction gives
\[
 \frac{2^{n-1}(n-1)!}{n}\le b_n
          \le3^{n-1}(n-1)!\quad(n\ge1).              \tag{8}
\]
For the upper induction, a positive composition has
\(\prod_j(i_j-1)!\le(n-k)!\), and there are
\(\binom{n-1}{k-1}\) such compositions. Substitution in (7) gives
\[
 b_{n+1}
 \le2\,3^{n-1}n!\sum_{j=0}^{n-1}\frac{3^{-j}}{j!}
 <3^n n!.
 \]
Indeed the infinite sum is at most
\(1+1/3+\frac12\sum_{j\ge2}3^{-j}=17/12<3/2\).
This proves (8) with constants independent of \(m\).
For \(m=1\), the sharper lower bound
\(b_n\ge2^{n-1}(n-1)!\) follows in the same way.

The restriction on \(m\) is mathematical, not cosmetic: at \(m=3\),
\(b_2=0\) and \(b_3=-1\). Positivity is therefore not a route to
nonvanishing in every dimension. This observation does not say that
the Stokes constant vanishes there.

## 3. Sectorial selection by a convergent integral iteration

For definiteness set
\(\alpha=\pi/12\), \(\theta=3\pi/4\), \(v=e^{i\theta}\), and
\[
 \Omega_+(R)=\{a e^{-i\alpha}+b v:a>R,\ b>0\}.
 \]
For \(\tau\) in this cone, \(\tau+tv\) stays in the cone and
\[
 |\tau+tv|\ge c(|\tau|+t),\quad c=\cos(5\pi/12)>1/4,
 \quad|\tau|\ge R/2,\quad-\Re v=\kappa=1/\sqrt2>7/10. \tag{9}
\]
The last radial bound follows by minimizing
\(|a e^{-i\alpha}+bv|\) over \(b\ge0\).
This translated cone contains every sufficiently distant point of
each closed smaller sector inside \((-\alpha,\theta)\).

Let \(G_m(q,z)=2q^2-q^3+(1-(m+1)q)/(2z)\). On holomorphic
functions with norm \(\|q\|=\sup_{\Omega_+}|\tau q(\tau)|\), set
\[
 T_mq(\tau)=-v\int_0^\infty e^{tv}G_m(q(\tau+tv),\tau+tv)\,dt. \tag{10}
\]
Here is an explicit uniform contraction, rather than a formal
existence assertion. Take \(R=4096\), \(\rho=R/2=2048\), and
the closed ball \(\|q\|\le8\). The absolute bound for \(G_m\) is
\[
 |G_m(q,z)|\le
 \left(\tfrac12+\frac{M}{\rho}\right)|z|^{-1},\qquad
 M=2\cdot8^2+\tfrac32\cdot8+8^3/\rho=561/4.
 \]
On the segment between two values in this ball,
\[
 |\partial_qG_m|\le D|z|^{-1},\qquad
 D=4\cdot8+3\cdot8^2/\rho+3/2=1075/32.
 \]
By (9),
\[
 \|T_mq\|\le\frac{40}{7}(\tfrac12+M/\rho)<8,\qquad
 \|T_mq-T_mp\|\le\frac{40D}{7\rho}\|q-p\|<\tfrac18\|q-p\|. \tag{11}
\]
The rational inequalities in (11) are replayed by `verify.py`.
Starting at zero, the iterates converge geometrically in this
complete weighted space, uniformly on compact sets. Their limit
is holomorphic, and differentiation of (10), followed by integration
by parts, gives \(q'=G_m(q,\tau)-q\), namely (5).
Reflection constructs \(q_-\). This construction also works for
complex \(m\) in a sufficiently small neighborhood of \([1,2]\);
uniform iteration makes the solutions holomorphic in that parameter.

If two small solutions are defined on an upper sector containing
a left-going interior ray, their difference satisfies
\[
 \delta'=\left[-1+2(q_1+q_2)
 -(q_1^2+q_1q_2+q_2^2)-\frac{m+1}{2\tau}\right]\delta. \tag{12}
\]
For \(q_i=O(1/\tau)\), a nonzero solution of (12) grows
exponentially, up to powers, on that ray. It cannot be \(O(1/\tau)\).
This proves uniqueness. Selection by the apparently weaker
\(q\to0\) gives the same answer: on closed smaller subsectors,
Cauchy's estimate gives \(q'=o(1/\tau)\), and (5) then gives
\(q=O(1/\tau)\). The corresponding sector must include a
left-going interior ray, not only the positive real ray.

## 4. All-order analytic remainders

Write \(a_j=b_j/2^j\), \(P_N(\tau)=\sum_{1\le j<N}a_j\tau^{-j}\),
and
\[
 D_N=P_N'+P_N-2P_N^2+P_N^3
             -\frac{1-(m+1)P_N}{2\tau}.              \tag{13}
\]
It is a polynomial in \(\zeta=1/\tau\) vanishing to order \(N\).
This is the coefficient identity (7), not an asymptotic inference.
For \(L\) sufficiently large, on \(|\zeta|=(LN)^{-1}\), (8)
and a geometric-ratio estimate give
\(|P_N|+|\zeta^2\partial_\zeta P_N|\le C/N\), uniformly in \(m,N\).
The maximum-modulus principle for \(D_N/\zeta^N\) gives
\[
 |D_N(\tau)|\le(C/N)(LN)^N|\tau|^{-N}
       \le C A_0^N N!|\tau|^{-N},\quad|\tau|\ge LN.    \tag{14}
\]
For example \(N^N\le e^N N!\) follows by integrating \(\log t\)
under \(\sum_{j=1}^N\log j\); a fixed exponential constant suffices.

The actual error \(e_N=q_+-P_N\) solves the exact linear equation
\[
 e_N'+(1-B_N)e_N=-D_N,\quad
 B_N=2(q_++P_N)-(q_+^2+q_+P_N+P_N^2)
                         -(m+1)/(2\tau).             \tag{15}
\]
On the rays in (10), when \(|\tau|\ge L'N\) and \(L'\) is fixed
large enough, \(B_N=O(1/|\tau+tv|)\).
The integrating kernel is bounded by
\(e^{-\kappa t}(1+t/|\tau|)^C\). Moreover
\[
 \left|\frac{\tau}{\tau+tv}\right|^N
 \le\exp\!\left(\frac{Nt}{c|\tau|}\right).             \tag{16}
\]
The logarithmic derivative of the modulus proves (16) even when
the path initially moves closer to the origin.
Increase \(L'\), and if necessary the exterior cutoff, so these
two losses are absorbed by \(e^{-\kappa t/2}\).
Variation from infinity is legitimate: \(e_N=O(1/|\tau|)\)
there, and its integrating factor decays exponentially on this
left-going ray. Equations (14)--(16) prove
\[
 |q_\pm-P_N|\le C A^N N!|\tau|^{-N},
                         \quad|\tau|\ge L'N.          \tag{17}
\]
This estimate holds uniformly on each closed smaller sector and
uniformly in \(m\).

One can take (17) for all \(N\ge1\) at a fixed sufficiently large
exterior cutoff, after increasing \(A,C\). For completeness,
when \(|\tau|<L'N\), bound \(q\) and each term of \(P_N\) directly
using (8). Dividing by \(A^N N!|\tau|^{-N}\), the \(j\)-th term
is at most a constant times
\((\max(3/2,L')/A)^N N^{N-j}j!/N!\).
The last ratio is at most \(e^N\). Choose
\(A>4e\max(3/2,L')\); summing fewer than \(N\) terms is bounded.
The bounded \(q\) term has the same estimate.
Thus no restriction of the form "check finitely many coefficients"
has replaced an all-order remainder argument.

## 5. Why the lateral solutions cannot coincide

Suppose \(q_+=q_-\) on their overlap. They glue to a holomorphic
exterior solution on a sector containing
\(-\omega\le\arg\tau\le\omega\), with
\(\pi/2<\omega<3\pi/4\). It has (17) uniformly on this closed
sector. Let \(\Gamma_R\) enter from infinity on angle \(-\omega\),
follow the right circular arc counterclockwise, then leave on
angle \(+\omega\). For \(|\arg u|<\omega-\pi/2\), define
\[
 H(u)=\frac1{2\pi i}\int_{\Gamma_R}e^{\tau u}q(\tau)\,d\tau. \tag{18}
\]
The ray integrals converge locally uniformly, so \(H\) is holomorphic
near every positive real \(u\). Cauchy's theorem in the annular
sector makes it independent of sufficiently large \(R\).

Use \(R=KN\), with \(K>L'\). The integral of \(\tau^{-j}\) is
\(u^{j-1}/(j-1)!\), by closing to the left; no singularity of
\(q\) inside the omitted disk is being assumed away in this step.
For positive \(u\), (17) bounds the integrated error by
\[
 C A^N N!(KN)^{1-N}e^{KNu}
 \le CKN(A/K)^N e^{KNu}.                              \tag{19}
\]
The rays contribute at most \(CR^{1-N}\), by integrating
\(\rho^{-N}\), and the arc contributes that same power times
\(e^{Ru}\), which proves the first inequality for \(N\ge2\).
Choose \(K>A\), then a fixed \(u>0\) small enough.
The right side tends to zero. Therefore \(H\) agrees near the
positive origin with the convergent Borel series
\[
 Q_m(u)=\sum_{n\ge1}\frac{b_n}{2^n(n-1)!}u^{n-1}.      \tag{20}
\]
By (8), its coefficients are positive and its finite radius
\(R_m\) belongs to \([2/3,1]\).

Here is the positive-series singularity argument in full.
If a power series \(\sum c_n u^n\), \(c_n\ge0\), of finite
positive radius \(R_m\) were holomorphic through \(R_m\), choose
\(r<R_m\) close enough that its Taylor series at \(r\) converges
at some \(b>R_m\). Such a disk exists: the union of the original
disk and a neighborhood of \(R_m\) contains a disk about sufficiently
nearby \(r\) of radius greater than \(R_m-r\).
Every Taylor coefficient at \(r\) is nonnegative. Expanding it
by termwise differentiation inside the original disk and exchanging
nonnegative double sums shows
\[
 \sum_{j\ge0}\sum_{n\ge j}c_n\binom nj r^{n-j}(b-r)^j
 =\sum_{n\ge0}c_n b^n<\infty.
 \]
This contradicts the radius \(R_m\).
But (18) analytically continues (20) through every positive point,
including \(R_m\). The supposition of equal lateral solutions is
therefore impossible.

Finally the exact slope difference is
\[
 (l_+-l_-)'=
 \left[l_++l_--m/y-\frac m y(l_+^2+l_+l_-+l_-^2)\right](l_+-l_-).
                                                               \tag{21}
\]
From the already proved expansion,
\(l=y/m-y^{-1}-m(3-m)y^{-3}+O(y^{-5})\), the bracket is
\(-y/m+(4-m)/y+O(y^{-3})\). Its final remainder is integrable.
An integrating factor proves (2), and its constant is nonzero
because a nonzero solution of (21) cannot vanish at a point.

The construction and the remainder estimates are uniform in \(m\).
At a common fixed large \(Y\), formula (21) expresses \(c_m\)
as a nonzero difference at \(Y\), times a nonzero explicit factor
and the exponential of a uniformly convergent integral of
the \(O(y^{-3})\) remainder. Thus \(c_m\) is continuous.
Reflection gives \(l_-=\overline{l_+}\) on the positive ray;
the normalizing factor in (2) is positive real there. Hence
\(c_m\in i\mathbb R\setminus\{0\}\). Connectedness and compactness
give the common imaginary sign and a strictly positive uniform
lower bound. No numerical analytic continuation is used.

There are also canonical heights with the required zero additive
constant. On either sector set
\[
 h_m(y)=\frac{y^2}{2m}-\log y
   -\int_y^\infty\left(l_m(s)-s/m+1/s\right)\,ds.      \tag{26}
\]
The integrand is \(O(s^{-3})\). The integral converges along
exterior radial paths, and its values agree on intersecting
subsectors: the connecting large circular integral is \(O(R^{-2})\)
and tends to zero. Thus (26) is holomorphic, has derivative \(l_m\),
and differs from \(y^2/(2m)-\log y\) by \(O(y^{-2})\).
It is the unique antiderivative with this normalization.
Consequently the height normalization used in (4) and (22) is
available for the canonical scalar solutions, not an assumption
of existence of a translating cap.

## 6. Finite bypass stability

Let \(\gamma_Y\) lie in one of the constructed sectors, connect
the positive point \(Y\) to \(y_e\), have length at most \(CY\),
and satisfy \(cY\le|y|\le CY\) and
\(\Re y_e^2\le-\eta Y^2\), for fixed positive constants.
Suppose a finite solution of (1) satisfies uniformly on this path
\[
 ml/y=1+O(Y^{-\sigma}),\qquad
 h=y^2/(2m)-\log y+O(Y^{-\sigma}),\quad\sigma>0.        \tag{22}
\]
Its slope discrepancy from the canonical solution is polynomially
bounded at the exit. In their exact difference equation the
coefficient is \(-y/m+O(Y^{1-\sigma})+O(Y^{-1})\).
Integration back to \(Y\) gives
\[
 |\delta l(Y)|\le P(Y)
 \exp\left(-Y^2/(2m)+\Re y_e^2/(2m)+o(Y^2)\right)
 \le Y^{4-m}e^{-Y^2/(2m)}O(e^{-\eta'Y^2}).             \tag{23}
\]
All constants can be uniform in \(m\); polynomial factors have
been absorbed by decreasing \(\eta'>0\).
This proves the finite-bypass assertion at the relative exponential
scale, rather than merely at polynomial accuracy.
By (22), \(|P_m(y_e)|\le P(Y)e^{-\eta Y^2/(2m)}
=O(e^{-\eta''Y^2})\). These conclusions use matching along
the bypass, not only at its terminal point.

## 7. Exact boundary transfer and orientation

Choose \(\log y\) by continuation from the positive ray and
\(\sqrt{1+l^2}\sim y/m\) there. For large exterior \(y\),
these factors never vanish. Direct differentiation of (3) along
(1) gives
\[
 P_m'=L_m,\qquad
 dP_m-P_m\,dh=y^m e^h(1+l^2)^{-3/2}dl
                                          \quad(y\text{ fixed}). \tag{24}
\]
For example, after dividing the first identity by
\(y^m e^h(1+l^2)^{-3/2}\), its residual is exactly
\[
 (ml/y+l^2)(1+l^2)
 +(1+l^2)(1-ml/y)-(1+l^2)^2=0.                        \tag{25}
\]
The second identity follows from
\(\partial_l(l/\sqrt{1+l^2})=(1+l^2)^{-3/2}\).
It holds for an arbitrary differentiable interpolation \((h,l)\).
Integrating it proves (4), without estimating two large terms
separately.

Uniformly along the linear slope interpolation,
\[
 Y^m e^h(1+l^2)^{-3/2}
 =m^3Y^{m-4}e^{Y^2/(2m)}(1+o(1)).
 \]
Multiplication by (2), or by its finite-bypass version (23),
proves that (4) tends to \(m^3c_m\).

For the manuscript's \(m=1\), an outward end has decreasing
\(r\), so its positive-area radial integral is from the exit
back to the incoming section. Its exterior contribution is
\(P(Y)-P(y_e)\), and the stationary inner first variation is
\(-\int P\,dh\). These are exactly the signs in (4).
The affine relation \(r^2=2(1-z^2/Z_0^2)\) interchanges the
upper and lower bypass labels. This interchange is the same
on every end, and persists under the fixed small phase
deformations by continuation. Reversing a surface normal or
rotating its axis does not reverse a positive area integral.
Thus the physical coefficient is
\(\epsilon_{\rm lab}8\pi c_1\) on every end, not a freely
chosen end-dependent sign. If the plus array means the upper
axial bypass, then \(\epsilon_{\rm lab}=-1\) relative to
upper-minus-lower \(y^2\) labels.

## 8. Finite scale, remaining hypotheses, and precise coverage

At finite scale put \(\varepsilon=Z_*^{-2}\) and, for \(m=1\),
\[
 L_\varepsilon=ye^{h-\varepsilon(h^2+y^2)}\sqrt{1+l^2},
 \qquad
 P_\varepsilon=ye^{h-\varepsilon(h^2+y^2)}
                                      l/\sqrt{1+l^2}.
 \]
The exact radial equation is
\[
 l'=(1+l^2)(1+2\varepsilon(yl-h)-l/y).
 \]
Its identity is \(P_\varepsilon'=(1-2\varepsilon h)L_\varepsilon\),
**not** \(P_\varepsilon'=L_\varepsilon\).
Also \(\partial_hP_\varepsilon=(1-2\varepsilon h)P_\varepsilon\).
The script verifies these exact correction terms. The staged
manuscript explicitly retains them, so they are not refutations.

One must take \(B\to\infty\) with \(Y\) fixed before using (24).
On a fixed section, convergence of the graphs and their first
homotopy derivatives makes the finite-scale first variation
converge to (4). Only afterwards may \(Y\to\infty\).
This does not justify a simultaneous limit with \(Y\asymp B\).

To turn this verified scalar theorem into `jump:action-jump` for
the manuscript's normalized surfaces, the following assertions remain
inputs, not results of this audit:

1. The normalized surface families, fixed observations, and exact
   finite-scale stationary homotopies exist with the stated
   uniqueness and endpoint compatibility (`jump:compatibility`).
2. At fixed \(Y\), the graphs and homotopy derivatives converge
   radially with the common normalization and satisfy (22), uniformly
   over the required interpolations (`jump:endpoints` and
   `jump:interpolation-height`).
3. Synchronization, moving-exit, correction, and far nonadverse
   momentum errors have the stated exponential bounds at the
   physical scale (`jump:nonadverse-sync`, `jump:endpoint-bound`).
4. The preliminary \(Z_*\) is held fixed during the inner homotopy;
   the geometric first-variation formula has no compact observation
   term at fixed parameters.

Subject to precisely these inputs, (2)--(4), (23), and the branch
calculation prove the Stokes-to-action step, including its nonzero
coefficient, common sign, and order of limits. The present proof
does not assume or establish the array action upper bound,
the phase separation theorem, the exclusion of opening arcs,
or convergence of the actual mean curvature flow.

No false literal manuscript assertion has been established in this
bounded audit, so no `F_` refutation claim is warranted. An absent
independent verification of the PDE inputs is not a counterexample
to them.
