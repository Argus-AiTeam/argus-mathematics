# A logarithmic obstruction to the proposed Cartesian weighted inverse bound

## Result and scope

Estimate (19) in `reduction.md` is false with its stated quantifiers.
This is not another failure to prove the estimate: the family below has a
uniformly bounded input norm and an output norm diverging linearly in an
integer parameter. It uses the actual global zero-flux inverse, not an
arbitrary harmonic addition. All origin jets of the stream vanish, so
the quadratic curvature mode remains separate and is identically zero
in this example.

The comparison with the preceding result is precise. The earlier
boundary-jet obstruction ruled out an unchanged *local* cubic
tangential remainder. The present obstruction survives that local
correction and rules out the proposed *global* \(X_1\)-to-\(X_1\)
effective-source estimate. An explicit conformal map at the end
removes the responsible anisotropic principal part, but its uniform
weighted inverse and nonlinear stability estimates are not proved here.

These are author-proved analytical statements with exact algebraic
replay, awaiting independent review. No new Euler singular solution,
publishable acceptance, or verified originality is claimed.

## 1. Norm, geometry, and the assertion being tested

Use the quarter-plane \(Q=\{X>0,Y>0\}\), \(\rho=(X^2+Y^2)^{1/2}\),
and \(\beta=1/16\). The source is odd in \(X\) when extended to the
upper half-plane. The norm is exactly Chen--Hou (6.76):

\[
 \|f\|_{X_1}=\|f\varphi_1\|_\infty+\|f\varphi_{g,1}\|_\infty
                  +[f\psi_1]_{C^{1/2}_{g_1}},                  \tag{N}
\]
\[
 \begin{split}
 \varphi_1&=|X|^{-1/2}
       (\rho^{-12/5}+\tfrac35\rho^{-1/2})+\tfrac3{10}\rho^{-1/6},\\
 \varphi_{g,1}&=\varphi_1+\rho^\beta,\qquad
 \psi_1=\rho^{-2}+\tfrac12\rho^{-1}+\tfrac15\rho^{-1/6}.
 \end{split}
 \tag{W}
\]

In (C.1), \(g_1(h)\) is
\[
 \frac{41/40}{
   \sqrt{|h_1|+(3/25)|h_2|}
           +(1/4)\sqrt{|h_2|+(1/100)|h_1|}} .
\]
Thus \([g]_{C^{1/2}_{g_1}}\leq3[g]_{C^{1/2}}\); indeed the denominator
is at least \(\sqrt{3/25}\,|h|^{1/2}\) and
\(41/(8\sqrt3)<3\).

Fix
\[
 a(z)=1+\kappa(1-\cos z),\quad 0<|\kappa|\leq1/4,\quad
 z\in\mathbb R/(2\pi\mathbb Z).
 \tag{G}
\]
The original flattened coordinates are
\[
 X=z/\ell,\quad Y=(a(z)-r)/\ell,\quad R=a(\ell X)-\ell Y.
 \tag{F}
\]
For a physical Stokes stream \(\mathcal P\), let
\[
 \widehat h=\mathcal P/\sqrt r,\qquad
 h(X,Y)=\ell^{-2}\widehat h(R,\ell X).
\]
Here the amplitude rescaling \(C_\omega\) is one. The exact physical
equation, equivalent to (1) and (7) of `reduction.md`, is
\[
 \left(-\partial_{zz}-\partial_{rr}+\frac3{4r^2}\right)
               \widehat h=r^{3/2}\widetilde\omega,\qquad
 \omega(X,Y)=\widetilde\omega(R,\ell X).
 \tag{E}
\]

The tested assertion is that constants \(\delta_a,C_a>0\), independent
of \(\ell,S\), give
\[
 |h_{XY}(0)|+\frac{\|-\Delta H-\omega\|_{X_1}}{\ell(1+S)}
                   \leq C_a\|\omega\|_{X_1},                   \tag{T}
\]
for every smooth odd source supported in \(\rho\leq S\) with
\(\ell(1+S)<\delta_a\), where \(H\) is the cutoff stream with the
two origin-jet corrections (16)--(17) of `reduction.md`.
The outer cutoff is one on a neighborhood of the source support.
This is the actual assertion in the ledger, not a stronger surrogate.

## 2. A specified smooth family

Here is a fixed cutoff, to make its constants independent of every
sequence parameter. Set
\[
 e(t)=\begin{cases}\exp(-1/t),&t>0,\\0,&t\leq0,\end{cases}
 \quad
 \eta(t)=\frac{e(4-t)}{e(4-t)+e(t-1)},\quad
 \chi(w)=\eta(|w|^2).
 \tag{C}
\]
The denominator never vanishes. The function \(\chi\) is smooth,
equals one on \(|w|\leq1\), vanishes on \(|w|\geq2\), and takes
values in \([0,1]\). Fix the finite, explicit cutoff constant
\[
 K=1+\max_{1\leq j\leq3}\|D^j\chi\|_\infty,                    \tag{K}
\]
with Euclidean operator norms for the derivative tensors.
It is a constant of this single displayed function, not an
\(\ell\)-dependent regularity assumption.

**Theorem.** For every \(\delta>0\), set
\[
 d=\min(1/32,\delta/8),\quad L=d/16,\quad
 z_*=d,\quad r_*=a(d)-d,\quad
 \ell_n=L2^{-n},\quad S_n=2d/\ell_n=32\,2^n,\quad n\geq1.
 \tag{P}
\]
There are smooth odd sources \(\omega_n\), arising from smooth,
finite-energy, zero-flux axisymmetric velocity data in (G), for which
\[
 \ell_n(1+S_n)<\delta,\qquad
 \|\omega_n\|_{X_1}\leq4000K,\qquad
 h_n=0\text{ on a neighborhood of }(0,0),                      \tag{B1}
\]
and the corrected residual in (T) satisfies
\[
 \|-\Delta H_n-\omega_n\|_{X_1}
 \geq 2|\kappa\sin d|(\sqrt2d)^{1/16}\,n\log2
 \geq \tfrac12|\kappa|d^{17/16}n.                              \tag{B2}
\]
The sources may be multiplied by any fixed positive scalar, so they
may lie in an arbitrarily small \(X_1\) ball without changing the
ratio in (T). Nonzero smooth swirl with the required reflection
symmetry may be included.
The vorticity is sign-changing; (T) imposes no positivity condition.
This theorem does not claim failure on a smaller sign-restricted class.

Consequently no pair \(\delta_a,C_a\) can satisfy (T). More
quantitatively, the norm ratio is at least
\[
 \frac{\|-\Delta H_n-\omega_n\|_{X_1}}
      {\ell_n(1+S_n)\|\omega_n\|_{X_1}}
       \ \geq\ \frac{|\kappa|d^{1/16}}{24000K}\,n.              \tag{B3}
\]

### Construction

At the positive axial center write \(s=z-d\), \(v=r-r_*\),
\(q=s^2+v^2\), and, for \(0<\ell\leq L/2\), put
\[
 G_\ell(s,v)=sv\log\frac{L}{\sqrt{q+\ell^2}},\qquad
 F_\ell(s,v)=\chi((s,v)/L)G_\ell(s,v).
 \tag{L}
\]
Define the physical conjugated stream by odd reflection:
\[
 \widehat h_\ell(r,z)=\ell^\beta
       \bigl(F_\ell(z-d,r-r_*)-F_\ell(-z-d,r-r_*)\bigr).
 \tag{S}
\]
It is extended periodically in \(z\). The two supports are disjoint
and away from the periodic seam. Define \(\mathcal P_\ell=\sqrt r\,
\widehat h_\ell\), recover \(u^r=-\mathcal P_z/r\),
\(u^z=\mathcal P_r/r\), and define the vorticity by (E).
No independent, potentially inconsistent vorticity is prescribed.

For \(|(s,v)|\leq2L=d/8\), the physical support satisfies
\[
 7d/8\leq z\leq9d/8,\qquad
 27d/32\leq a(z)-r\leq37d/32,\qquad r>3/4.                    \tag{S1}
\]
Indeed \(|a(z)-a(d)|\leq |s|/4\). The last inequality follows
from \(1-\cos d\leq d^2/2\) and \(d\leq1/16\).
In particular the support is strictly inside the domain and away
from the axis. The first two inequalities imply
\[
 d\leq\sqrt{z^2+(a(z)-r)^2}\leq2d.
 \tag{S2}
\]
They also hold with \(|z|\) at the reflected center. Thus after
rescaling
\[
 d/\ell\leq\rho\leq2d/\ell,\qquad |X|\geq(7/16)\rho.            \tag{S3}
\]
All fields vanish near the wall, the axis, and \(z=0\).
The stream is smooth, wall tangent, and has zero axial flux.
It therefore obeys, in particular, \(u^r=a'(z)u^z\) on the wall.

Choose in (17) of `reduction.md`
\[
 \chi_R(X,Y)=\chi\!\left(\frac{\ell(X,Y)}{2d}\right),\qquad
 \chi_0(X,Y)=\chi(X,Y).                                       \tag{S4}
\]
The first is one on the support of \(h\) and the source.
The origin strain \(h_{XY}(0)\) and both correction coefficients
are zero. Hence the exact corrected stream is \(H=h\).
Even with another admissible outer cutoff the central lower
bound below is unchanged: that cutoff is one near the center,
which belongs to the interior of the source support.

## 3. Uniform control of the input, with no hidden regularity bound

The elementary identity driving the example is
\[
 Q_\ell:=-\Delta_{s,v}G_\ell
       =\frac{2sv(2q+3\ell^2)}{(q+\ell^2)^2}.                  \tag{I1}
\]
It implies
\[
 |Q_\ell|\leq2,\qquad |\nabla Q_\ell|\leq10/\ell.               \tag{I2}
\]
For the first bound, use \(2|sv|\leq q\) and the exact
nonnegative remainder
\[
 2(q+\ell^2)^2-q(2q+3\ell^2)=\ell^2(q+2\ell^2).
\]
For the second, write \(Q=4sv/(q+\ell^2)+
2\ell^2sv/(q+\ell^2)^2\) and differentiate. For each coordinate
the four absolute terms are bounded by
\(2/\ell,2/\ell,1/\ell,2/\ell\), respectively, using
\(\sqrt q/(q+\ell^2)\leq1/(2\ell)\). The Euclidean bound is
\(7\sqrt2/\ell<10/\ell\).

On \(|w|\leq2L\), the following bounds are uniform in \(\ell\):
\[
 |G_\ell|\leq3L^2,\quad |\nabla G_\ell|\leq4L,\quad
 |D^2G_\ell|\leq8\quad\text{on }L\leq|w|\leq2L.                \tag{I3}
\]
For example, the positive logarithm is bounded by
\(\log(L/|w|)\), and \(t^j\log(1/t)\) is bounded on \(0<t\leq1\),
for \(j=1,2\). Where the logarithm is negative its absolute value
is less than one, since \(\ell\leq L/2\) and
\(\sqrt{|w|^2+\ell^2}/L\leq\sqrt{17/4}<e\).
Differentiating \(sv\log(L/\sqrt{q+\ell^2})\) proves the stated
gradient and annular Hessian bounds. No bound on the central
Hessian is asserted; it is deliberately logarithmically large.

The product rule, (K), (I2), and (I3) now give
\[
 \begin{split}
 |-\Delta F_\ell|&\leq16K,&
 |\nabla(-\Delta F_\ell)|&\leq50K/\ell,\\
 |F_\ell|&\leq3L^2,&|\nabla F_\ell|&\leq7KL.
 \end{split}                                                  \tag{I4}
\]
For transparency, the Laplacian cutoff contributions are at most
\(8K+6K\), in addition to the bound 2 for \(Q\).
In its differentiated version the cutoff contributions are
\((2+24+14)K/L\), in addition to \(10/\ell\). Since \(\ell\leq L\)
these give the displayed constants.

On the support, \(r^{-3/2}\leq2\),
\(|\partial_r r^{-3/2}|\leq4\), \(3/(4r^2)\leq4/3\), and
\(|\partial_r(3/(4r^2))|\leq4\). Formula (E) and (I4) therefore give
\[
 |\widetilde\omega_\ell|\leq40K\ell^\beta,\qquad
 |\nabla_{r,z}\widetilde\omega_\ell|\leq256K\ell^{\beta-1}.
 \tag{I5}
\]
The rescaling (F) has derivative norm at most \(2\ell\), so
\[
 \|\omega_\ell\|_\infty\leq40K\ell^\beta,\qquad
 \|\nabla_{X,Y}\omega_\ell\|_\infty\leq512K\ell^\beta.           \tag{I6}
\]
These are bounds for the whole zero-extended source, not just
its values near the central ray.

Put \(m=d/\ell\geq32\). On (S3), direct estimates of (W) give
\[
 \varphi_1\leq3\rho^{-1/6},\quad
 \varphi_{g,1}\leq4\rho^\beta,\quad
 \psi_1\leq2m^{-1/6},\quad |\nabla\psi_1|\leq3m^{-7/6}.
 \tag{I7}
\]
For the angular weight use
\(\sqrt{16/7}<8/5\) and
\((8/5)^2+3/10<3\). Consequently
\[
 \|\omega\varphi_1\|_\infty\leq120K,\qquad
 \|\omega\varphi_{g,1}\|_\infty\leq160K.                        \tag{I8}
\]
For \(g=\omega\psi_1\), extended by zero, set
\(T_\ell=\ell^\beta(\ell/d)^{1/6}\leq1\).
Equations (I6)--(I7) yield
\[
 \|g\|_\infty\leq80KT_\ell,\qquad
 \|\nabla g\|_\infty\leq1144KT_\ell.                           \tag{I9}
\]
The extension is smooth since the support is separated from both
axes. Splitting pairs at distance one gives
\([g]_{C^{1/2}}\leq\max(2\|g\|_\infty,\|\nabla g\|_\infty)\).
The anisotropic seminorm is therefore at most \(3432K\).
Adding the two bounds in (I8) proves
\(\|\omega_\ell\|_{X_1}\leq3712K<4000K\).
This proves the asserted uniform norm bound, including the
weighted Holder term.

## 4. The diverging output is an exact point evaluation

At the positive physical center, the cutoff is identically one,
and
\[
 G_\ell=\nabla G_\ell=(G_\ell)_{ss}=(G_\ell)_{vv}=Q_\ell=0,
 \qquad (G_\ell)_{sv}=\log(L/\ell).                            \tag{D1}
\]
Thus the actual vorticity is zero at that point. The flat
rescaled Laplacian applied to \(h=\ell^{-2}\widehat h\) is
\[
 \Delta_{X,Y}h=
   \widehat h_{zz}+2a'(z)\widehat h_{zr}
       +(1+a'(z)^2)\widehat h_{rr}+a''(z)\widehat h_r.
 \tag{D2}
\]
At \((X_*,Y_*)=(d/\ell,d/\ell)\), it follows exactly that
\[
 (-\Delta H-\omega)(X_*,Y_*)
          =-2\kappa\sin d\,\ell^\beta\log(L/\ell).              \tag{D3}
\]
Since \(\varphi_{g,1}\geq\rho^\beta\), the \(\ell^\beta\)
factor cancels the growing weight. Substituting
\(\ell_n=L2^{-n}\) gives the first lower bound in (B2).
The elementary inequalities \(\sin d\geq d/2\),
\(\log2\geq1/2\), and \((\sqrt2d)^\beta\geq d^\beta\)
give the second. Also
\(\ell_n(1+S_n)=\ell_n+2d<3d<\delta\).
Combining with the input bound proves (B3).

This is a proof for every integer \(n\), not numerical evidence
from large but finite test values. The physical inputs may have
small high-order length scales; the tested norm and the mission
impose smoothness, not a uniform bound on those higher derivatives.

## 5. The global inverse and Euler admissibility are not omitted

The constructed stream vanishes outside the two displayed physical
balls. Nevertheless it is precisely the global zero-flux inverse
of the source defined by (E). To prove uniqueness, let
\(\widehat h_1-\widehat h_2=w\) be the difference of two regular
solutions with the same source, zero flux, and the same periodicity.
It satisfies
\[
 (-\Delta_{r,z}+3/(4r^2))w=0,\quad w|_{r=a(z)}=0,\quad
                         w=O(r^{3/2})\text{ at the axis}.
\]
Multiply by \(w\) and integrate over \(r>\epsilon\) in one period.
The wall term vanishes, periodic terms cancel, and the axis
boundary term tends to zero by regularity. Hence
\[
 \int\left(|\nabla w|^2+\frac{3}{4r^2}|w|^2\right)\,dr\,dz=0,
\]
so \(w=0\). There is no freely chosen harmonic field to be
estimated or removed from the counterexample.

The constructed physical velocity is smooth at the axis because
it is identically zero near it, is smooth and tangent at the wall,
has the required reflection symmetry, and has zero axial flux.
It has finite energy; in fact (I3)--(I4) give meridional velocity
bounded by a constant times \(\ell^\beta\) on a fixed compact set.
For swirl choose a nonzero, even, smooth
\(\Gamma_\ell=\ell^\beta\epsilon_\theta(\chi_++\chi_-)\),
where \(\chi_\pm\) are the two supported cutoffs from (S), and
put \(u^\theta=\Gamma_\ell/r\). This is smooth and has finite
energy, and \(\widetilde\theta=\Gamma_\ell^2\) is even.
These are admissible Euler initial data, not an asserted explicit
time-dependent solution or a blowup construction.

The exterior stream is exactly zero in this family, all origin
jets vanish, and the two supports remain in an arbitrarily small
physical neighborhood of the wall point. The increasing rescaled
support radius is essential and is allowed by the stated
\(\ell(1+S)<\delta\) hypothesis. Thus exterior estimates, smaller
cutoff errors, or more corrections depending only on origin jets
cannot rescue (T). A bound allowing a logarithmic loss or using a
different principal operator is a different assertion.

## 6. A concrete change of mathematical approach

The bad term in (D2) is not intrinsic to the physical elliptic
operator: it is produced by nonconformal flattening. For the
nonempty subfamily \(0<|\kappa|\leq1/10\), there is an explicit
global conformal parametrization of the periodic meridional domain.
Let
\[
 F(w)=w-i\kappa(1-\cos w),\qquad w=\xi+i\eta,\quad0\leq\eta\leq2.
 \tag{M1}
\]
Write \(F=Z+i(1-R)\). Then
\[
 Z=\xi+\kappa\sin\xi\sinh\eta,\quad
 R=1-\eta+\kappa-\kappa\cos\xi\cosh\eta.                        \tag{M2}
\]
On \(\eta=0\), \(Z=\xi\), \(R=a(\xi)\), exactly. Define
\[
 A=1+\kappa\cos\xi\sinh\eta,\quad B=\kappa\sin\xi\cosh\eta,\quad
 J=A^2+B^2=|F'(w)|^2.                                        \tag{M3}
\]
Since \(\cosh2<4\),
\[
 |F'-1|<2/5,\quad
 |F(w_1)-F(w_2)|\geq(3/5)|w_1-w_2|,\quad
             9/25<J<49/25.                                  \tag{M4}
\]
The distance inequality follows by integration along a segment
in the convex strip, before taking the periodic quotient.
The restriction \(|\kappa|\leq1/10\) supplies this explicit global
strip margin; it is not an exclusion statement for other curvatures.

This really parametrizes the entire desired domain, not only a
fixed compact wall patch. For fixed \(\eta\), \(Z_\xi=A>3/5\);
thus \(\xi\mapsto Z\) is bijective on the line and respects the
period. At fixed physical \(Z\), implicit differentiation gives
\[
 \frac{dR}{d\eta}\Big|_Z=-J/A<0.
\]
At \(\eta=0\), \(R=a(Z)>0\); at \(\eta=2\),
\(R\leq-1+(1/10)(1+\cosh2)<-1/2\).
Every \(0<r<a(z)\) is therefore represented once.
Equivalently the parameter domain is \(0<\eta<H(\xi)\),
where \(H\) is the unique smooth even periodic root of
\(R(\xi,H(\xi))=0\). The axis and zero-flux boundary conditions
are transported, not discarded.

Use the new rescaled coordinates \((\mathsf X,\mathsf Y)
=(\xi/\ell,\eta/\ell)\) and \(h=\ell^{-2}C_\omega
\widehat h\circ F\). The same physical inverse (E) becomes
\[
 -\Delta_{\mathsf X,\mathsf Y}h+
       \frac{3\ell^2J}{4R^2}h=JR^{3/2}\omega.                 \tag{M5}
\]
There is **no** anisotropic second-derivative perturbation.
The new source multiplier and potential are scalar. In
particular, the physical harmonic mixed Hessian in (D1) has
zero conformal Laplacian at its center, rather than producing
(D3).

For clarity, this change is also compatible with the exact Euler
transport structure. Put \(\Phi=\sqrt R\,h\) and use the same
time and amplitude rescalings as in `reduction.md`. The coordinate
velocity and source are
\[
 U=-\frac{\Phi_{\mathsf Y}}{RJ},\quad
 V=\frac{\Phi_{\mathsf X}}{RJ},\quad
 \partial_{\mathsf X}(RJU)+\partial_{\mathsf Y}(RJV)=0,
 \tag{M6}
\]
\[
 \begin{split}
 \theta_\tau+(c_l(\mathsf X,\mathsf Y)+(U,V))\cdot\nabla\theta
       &=(c_l+2c_\omega)\theta,\\
 \omega_\tau+(c_l(\mathsf X,\mathsf Y)+(U,V))\cdot\nabla\omega
       &=c_\omega\omega+
            \frac{A\theta_{\mathsf X}+B\theta_{\mathsf Y}}{JR^4}.
 \end{split}                                                  \tag{M7}
\]
Here \(A,B,J,R\) are evaluated at
\((\ell\mathsf X,\ell\mathsf Y)\).
The derivative matrix of \((Z,R)\) is
\(\begin{pmatrix}A&B\\B&-A\end{pmatrix}\), whose square is \(JI\);
the chain rule and the physical Hamiltonian stream velocity give
(M5)--(M7). On the wall \(V=0\), and (M6) gives
\(u^r=a'(z)u^z\), not \(u^r=0\).
The reflection symmetry is preserved. At \(\kappa=0\) the map,
inverse, and transport equations specialize to the cylinder.

For a smooth source in \(X_1\), let \(a_0=h_{\mathsf X\mathsf Y}(0)\).
The scalar equation (M5) has no cubic stream jet. Its quadratic
source jet is removed by
\[
 {\cal H}=\chi_Rh-\tfrac18\ell^2a_0\mathsf X\mathsf Y^3\chi_0.
 \tag{M8}
\]
The velocity still has low-order terms which must be kept separate:
\[
 \begin{split}
 U&=-{\cal H}_{\mathsf Y}
           +2\kappa\ell a_0\mathsf X\mathsf Y+O(\rho^3),\\
 V&={\cal H}_{\mathsf X}
           +(\tfrac12-2\kappa)\ell a_0\mathsf Y^2+O(\rho^3).
 \end{split}                                                  \tag{M9}
\]
Indeed \(R=1-\ell\mathsf Y+O(\rho^2)\),
\(J=1+2\kappa\ell\mathsf Y+O(\rho^2)\), and
\(h=a_0\mathsf X\mathsf Y+O(\rho^4)\). Substituting these into
(M6) proves (M9). The correction in (M8) is cubic in its
velocity derivatives and cannot cancel the quadratic mode.
It specializes exactly to the cylinder correction.

These exact identities provide a materially different remaining
route. They do **not** establish uniform weighted inverse bounds,
control the axis singularity or exterior contribution for arbitrary
sources, or prove that curvature velocity modes fit the nonlinear
stability inequalities. Those estimates must now be proved for
(M5)--(M7), rather than trying again to prove the false (T).

For specificity, the new unproved inverse target uses
\(\chi_R(\mathsf X,\mathsf Y)=\chi((\mathsf X,\mathsf Y)/R_c)\),
\(R_c=(64\ell)^{-1}\), \(\chi_0=\chi\), and sources with
\(\ell(1+S)<\delta\leq1/256\). The desired estimate is
\[
 |a_0|+\frac{\|-\Delta{\cal H}-\omega\|_{X_1}}{\ell(1+S)}
       \leq C\|\omega\|_{X_1},                                \tag{M10}
\]
with \(C,\delta\) independent of \(\ell,S\) for the stated
conformal geometry range. Bounds for the velocity remainders,
the separately retained modes (M9), and all actual stability
functionals are additional obligations. Formula (M10) is
explicitly a conjectured next step, not a theorem proved by
the coordinate identities.

## 7. Sources, replay, and remaining acceptance conditions

The only external mathematical specification used for the obstruction
is the already independently checked Chen--Hou norm:
[arXiv:2210.07191v4](https://arxiv.org/html/2210.07191v4),
(6.76), (C.1), (C.3), (C.4). The logarithmic family, norm bounds,
global inverse identification, and explicit conformal map are
proved above. Their novelty has not been independently established.

The prior Reviewer also correctly identified that the abbreviated
stability assumption omitted the second inequality in (A.11).
Any future application must have both the strict positive margin
and a uniform finite bound \(M\) on the sum of coupling, quadratic,
and residual terms, as well as (A.9)--(A.10), the transport
conditions, and the separate nonlinear-mode estimates.
Correcting that citation does not supply these estimates.

Run the new, bounded certificate from the campaign root:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/curved_wall/inverse_obstruction.py
```

It verifies the exact logarithmic derivatives, zero central physical
source, nonzero flattened error, rational norm-bound arithmetic,
dyadic growth identities, and the conformal operator and velocity
identities. The bounded Jacobian operation was inspected and
executed through the authorized adapter; its dedicated payload
and output are `research/jacobian/harmonic-payload.json` and
`research/jacobian/harmonic-result.json`. It certifies the harmonic
polynomial seed \(sv\), not the norm theorem. The analytic
estimates and global uniqueness are the prose proof, not
mislabelled symbolic output.

The campaign's publishable quantitative Euler reduction remains
open. The new independent-review question is whether (B1)--(B3)
indeed refute the proposed estimate under its actual quantifiers;
the subsequent analytic route is (M5)--(M7).
