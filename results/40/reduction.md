# Curved-wall Euler: exact equations and a boundary-jet obstruction

**Status.** The coordinate identities, the obstruction to an *unmodified*
cylinder velocity decomposition, and the local jet correction below were
supported by the Host-invoked independent Reviewer. They are not a uniform
weighted reduction, a singularity theorem, or a verified-new publishable
result. The follow-up `inverse_obstruction.md` now gives an explicit
logarithmic counterexample to the proposed Cartesian estimate (19), even
after the local correction, and an exact conformal alternative. Those
new results await independent review.

The strongest prior result used here is Chen--Hou, arXiv:2210.07191v4,
Theorem 5: smooth finite-energy nearly self-similar blowup in a periodic
straight cylinder. This note identifies an additional curvature-dependent
mode absent from that cylinder decomposition. It does **not** extend their
blowup theorem to a noncylindrical domain.

## 1. Physical equations, flux, and boundary condition

Let \(z\in\mathbb R/(2\pi\mathbb Z)\), \(0\leq r<a(z)\), where \(a\) is
smooth, positive, even, and \(a(0)=1\). Consider smooth axisymmetric Euler
velocity with swirl, regular at the axis, tangent to the wall:

\[
 u^r(a(z),z)=a'(z)u^z(a(z),z).
\]

Write \(\Gamma=ru^\theta\), \(\widetilde\theta=\Gamma^2\),
\(\widetilde\omega=\omega^\theta/r\), and use the Stokes stream function
\(\mathcal P\):

\[
 u^r=-r^{-1}\mathcal P_z,\quad u^z=r^{-1}\mathcal P_r,\qquad
 -(\partial_{rr}-r^{-1}\partial_r+\partial_{zz})\mathcal P
       =r^2\widetilde\omega.                                      \tag{1}
\]

The axis value of \(\mathcal P\) is fixed at zero. Incompressibility and
wall tangency make the axial flux constant in \(z\). Its value is
\(2\pi[\mathcal P(a(z),z)-\mathcal P(0,z)]\). Zero flux therefore gives
\(\mathcal P=0\) on the wall as well as the axis. This normalization
excludes an unspecified axial harmonic through-flow.

The exact transport equations are

\[
 D_t\widetilde\theta=0,\qquad
 D_t\widetilde\omega=r^{-4}\partial_z\widetilde\theta,\qquad
 D_t=\partial_t+u^r\partial_r+u^z\partial_z.                       \tag{2}
\]

These are Chen--Hou (6.2), (6.6), (6.7), with the stream convention
\(\mathcal P=r\widetilde\phi\). The identities are local in the meridional
plane and do not assume a cylindrical wall.

## 2. Exact flattening and dynamic rescaling

Let \(\ell>0\), \(C_\omega>0\), with
\(\ell'/\ell=-c_l\), \(C_\omega'/C_\omega=c_\omega\), and
\(dt/d\tau=C_\omega\). Set

\[
 X=z/\ell,\quad Y=(a(z)-r)/\ell,\quad
 R=a(\ell X)-\ell Y,\quad b=a'(\ell X),\quad d=\ell a''(\ell X),
\]
\[
 \theta=C_\omega^2\ell^{-1}\widetilde\theta,\quad
 \omega=C_\omega\widetilde\omega,\quad
 \Phi=C_\omega\ell^{-2}\mathcal P .
\]

The rescaled meridional domain is
\[
 D_\ell=\{ |X|<\pi/\ell,\quad 0<Y<a(\ell X)/\ell\},
\]
with periodic identification of the vertical ends. Define
\[
 U=(C_\omega/\ell)u^z=-\Phi_Y/R,\qquad
 V=(C_\omega/\ell)(bu^z-u^r)=\Phi_X/R.                            \tag{3}
\]
Consequently \(V=0\) on \(Y=0\), not \(u^r=0\). The equations are
\[
 \theta_\tau+(c_l(X,Y)+(U,V))\cdot\nabla\theta
       =(c_l+2c_\omega)\theta,
\]
\[
 \omega_\tau+(c_l(X,Y)+(U,V))\cdot\nabla\omega
       =c_\omega\omega+R^{-4}(\theta_X+b\theta_Y),                 \tag{4}
\]
\[
 -\{\Phi_{XX}+2b\Phi_{XY}+(1+b^2)\Phi_{YY}
                     +(d+\ell/R)\Phi_Y\}=R^2\omega.              \tag{5}
\]
Here \(c_l(X,Y)\) means the scalar \(c_l\) times the vector \((X,Y)\).
In particular,
\[
 \partial_X(RU)+\partial_Y(RV)=0,\qquad
 U_X+V_Y=\ell R^{-1}(V-bU).                                     \tag{6}
\]

For completeness, at fixed physical coordinates,
\(X_\tau=c_lX\), \(Y_\tau=c_lY\). At fixed time,
\(\partial_r=-\ell^{-1}\partial_Y\) and
\(\partial_z=\ell^{-1}(\partial_X+b\partial_Y)\). Applying these
operators twice proves (5), including the derivative \(d\Phi_Y\).
In (4), the source coefficient is
\(C_\omega^2/(\ell(C_\omega^2/\ell))=1\). These calculations prove
(3)--(6), rather than postulating a self-similar profile.

If \(\omega,\Phi,U\) are odd in \(X\) and \(\theta,R,V\) are even,
every term has the appropriate parity. This class is preserved by the
equations. Axis regularity remains a condition on the physical fields
at \(R=0\); no estimate below treats the factors \(R^{-1}\) as bounded
there.

The principal metric is
\[
 G_b=\begin{pmatrix}1&b\\ b&1+b^2\end{pmatrix},\qquad
 \det G_b=1,\quad
 \det(\mu I-G_b)=\mu^2-(2+b^2)\mu+1.
\]
Its quadratic form is \((\xi+b\eta)^2+\eta^2\); for \(|b|\leq B\)
its eigenvalues lie between \(1/(2+B^2)\) and \(2+B^2\).
This is uniform ellipticity, not smallness of the elliptic inverse.

## 3. Conjugation and what concentration actually controls

Put \(h=\Phi/\sqrt R\). Direct conjugation in physical coordinates,
\[
 (\partial_{rr}-r^{-1}\partial_r+\partial_{zz})(\sqrt r\,h)
   =\sqrt r\,(\partial_{rr}h+\partial_{zz}h-3h/(4r^2)),
\]
gives
\[
 -\{h_{XX}+2bh_{XY}+(1+b^2)h_{YY}+dh_Y\}
       +\frac{3\ell^2}{4R^2}h=R^{3/2}\omega,                    \tag{7}
\]
\[
 U=-R^{-1/2}h_Y+\frac{\ell}{2R^{3/2}}h,\qquad
 V=R^{-1/2}h_X+\frac{\ell b}{2R^{3/2}}h.                         \tag{8}
\]
For \(a\equiv1\), \(b=d=0\), and (7) is exactly the conjugated
cylinder equation Chen--Hou (6.16).

Let \(K=\|a''\|_\infty\). On \(\rho=(X^2+Y^2)^{1/2}\leq S\),
\[
 |b|\leq K\ell S,\quad |d|\leq K\ell,\quad
 |R-1|\leq\ell S+\tfrac12K(\ell S)^2.                            \tag{9}
\]
For example, \(\ell S\leq1/4\) and \(K(\ell S)^2\leq1/2\)
ensure \(R\geq1/2\). The difference between the differential part
of (7) and the Laplacian is then bounded pointwise by
\[
 2K\ell S|h_{XY}|+K^2(\ell S)^2|h_{YY}|+K\ell|h_Y|.
\]
This is a coefficient estimate, not the requested weighted inverse estimate.

There is no uniform coefficient convergence on the entire expanding
domain. For
\[
 a(z)=1+\kappa(1-\cos z),\quad 0<|\kappa|\leq1/4,                 \tag{10}
\]
the wall is positive, smooth, even, and genuinely noncylindrical.
At \(X=\pi/(2\ell)\), \(b=\kappa\), for every \(\ell\).
Even in a fixed small physical patch \(z=\delta>0\),
\(b(\delta/\ell)=\kappa\sin\delta\) is independent of \(\ell\).
Thus shrinking \(\ell\) alone does not give a time-integrable
coefficient bound on an expanding support.

This distinction also matters when citing Chen--Hou. Their (6.113)
and support estimate following (6.115) control
\(\ell(1+S)\) uniformly by a small number; they do not assert that
this quantity is time integrable. Their strict stability margin can
absorb uniformly small errors, so integrability is not a necessary
replacement hypothesis.

## 4. Boundary-jet obstruction to the unchanged cylinder decomposition

**Proposition.** Let (3), (5) hold smoothly near the origin with the
above reflection symmetry, \(\Phi(X,0)=0\), and
\(\kappa=a''(0)\). Write \(s=U_X(0,0)\). Then
\[
             U_{XY}(0,0)=\omega_X(0,0)-3\ell\kappa s.             \tag{11}
\]
There are smooth finite-energy, zero-flux axisymmetric data with nonzero
swirl in each domain (10) for which \(\omega\) belongs to Chen--Hou's
\(X_1\) space, \(\omega_X(0)=0\), and \(s\ne0\).
For these data there is no smooth decomposition
\[
 U=-H_Y+U_R,\quad H(X,0)=0,\quad -\Delta H=F\in X_1,\quad
                         U_R=O(\rho^3).                        \tag{12}
\]
In particular, (12) cannot hold with \(F=\omega+f_{\rm err}\) and
\(\omega,f_{\rm err}\in X_1\). This only rules out that
*unchanged decomposition*, not a curved-wall blowup theorem.

**Proof of the identity.** At the origin, \(R=1\), \(R_Y=-\ell\),
\(b=0\), \(b_X=d=\ell\kappa\), and
\(\Phi=\Phi_X=\Phi_Y=0\). The wall trace gives
\(\Phi_{XXX}(0)=0\). Differentiate (5) in \(X\):
\[
 \omega_X(0)=-\Phi_{XYY}(0)-\ell(3\kappa+1)\Phi_{XY}(0).
\]
Differentiate (3):
\[
 s=-\Phi_{XY}(0),\qquad
 U_{XY}(0)=-\Phi_{XYY}(0)-\ell\Phi_{XY}(0).
\]
Eliminating the stream derivatives proves (11).

**Why \(X_1\) detects the obstruction.** Chen--Hou (6.76), (C.1),
(C.3), (C.4) define
\[
 \|f\|_{X_1}=\|f\varphi_1\|_\infty+\|f\varphi_{g,1}\|_\infty
                   +[f\psi_1]_{C^{1/2}_{g_1}},
\]
\[
 \varphi_1=|X|^{-1/2}(\rho^{-12/5}+\tfrac35\rho^{-1/2})
                    +\tfrac3{10}\rho^{-1/6},\quad
 \varphi_{g,1}=\varphi_1+\rho^{1/16},
\]
\[
 \psi_1=\rho^{-2}+\tfrac12\rho^{-1}+\tfrac15\rho^{-1/6}.
\]
The anisotropic seminorm is equivalent, by fixed positive constants,
to the usual \(1/2\)-Holder seminorm; the coefficients of its
directional denominator are all positive.
A smooth \(F\in X_1\) has \(F_X(0)=0\), as is already seen on
the ray \(Y=0\). Since \(H(X,0)=0\),
\[
             (-H_Y)_{XY}(0)=(-\Delta H)_X(0)=F_X(0)=0.
\]
The mixed derivative of a smooth \(O(\rho^3)\) remainder is zero.
This contradicts (11) when \(\omega_X(0)=0\) and \(\kappa s\ne0\).

The conflict is not removed by making \(\ell\) very small.
For a nonzero quadratic term \(cXY\), on \(X=Y=t\),
\[
 |cXY|\varphi_1\ \geq\
                  |c|\,2^{-6/5}t^{-9/10}\longrightarrow\infty.  \tag{13}
\]
A linear strain normalization does not change a mixed second derivative.
In particular, multiplying this new tangential quadratic term by a
background vorticity with nonzero \(\bar\omega_X(0)\) produces a
quadratic forcing outside \(X_1\), unless it is explicitly projected
into an additional low-order mode.

Chen--Hou explicitly use \(u_R=O(\rho^3)\), \(v_R=O(\rho^2)\) in
(6.46), Remark 6.10, and (6.54). Their cylinder rank-one stream
correction in Proposition 6.9 is quartic, proportional to
\(-XY^3/6\). It does not supply the cubic curvature correction
identified below. This observation does not assert that their
finite-rank *framework* cannot accommodate another mode.

### Actual admissible data, not a free harmonic addition

Fix \(0<\ell\leq1/16\), \(0<|\kappa|\leq1/4\), \(A\ne0\), and
use (10). In the flattened chart set, near the origin,
\[
 h=A XY-\tfrac32\ell\kappa AXY^2
                 +\tfrac18\ell^2(12\kappa^2+1)AXY^3.            \tag{14}
\]
Multiply by a smooth radial cutoff equal to one for \(\rho\leq1\)
and zero for \(\rho\geq2\). Define
\(\Phi=\sqrt R\,h\), set \(C_\omega=1\), and recover the physical
stream \(\mathcal P=\ell^2\Phi\) and velocity by (1).
The support is away from the axis and periodic seam; extend by zero.
The field is smooth, divergence free, wall tangent, and has zero flux.

Define \(\omega\) by (7), not independently of the velocity.
Differentiation gives
\[
 \omega_X(0)=\omega_{XY}(0)=0,\quad
 U_X(0)=-A,\quad U_{XY}(0)=3\ell\kappa A.                         \tag{15}
\]
Oddness in \(X\) and these vanishings give
\(\omega=X\,O(\rho^2)\). Compact support then implies both
weighted supremum norms in \(X_1\) are finite. The most singular
Holder factor \(\omega\rho^{-2}\) is Lipschitz at the origin:
its degree-three Taylor terms divided by \(\rho^2\) are
degree-one functions with bounded first derivatives off the
origin, and the Taylor remainder has the same bound. The other
terms in \(\omega\psi_1\) are less singular. Thus \(\omega\in X_1\).
The construction is linear in \(A\). Taking \(A\) arbitrarily small
places these vorticities in arbitrarily small \(X_1\) balls, without
removing the nonzero mixed-jet obstruction.

Nonzero smooth swirl can be added by choosing
\(\Gamma=\epsilon\chi_\theta\), with \(\epsilon>0\) and a smooth
even cutoff supported away from the axis and constant near the
origin. Then \(u^\theta=\Gamma/r\), extended by zero near the
axis, is smooth; \(\widetilde\theta=\Gamma^2\) is even and constant
near the origin. All three velocity components have finite energy.
This is an admissible initial field, not a claimed explicit
time-dependent Euler solution or singular solution.

There is no arbitrary external flow in this construction.
With zero flux, the difference between two regular physical
streams for the same \(\widetilde\omega\) satisfies
\(-\operatorname{div}(r^{-1}\nabla\mathcal P)=0\), with zero wall
and axis values and periodicity. Multiplication by the difference
and integration gives \(\int r^{-1}|\nabla\mathcal P|^2=0\).
The axis boundary term vanishes by regularity
\(\mathcal P=O(r^2)\). Thus the prescribed stream is the unique
zero-flux inverse of its vorticity. This completes the proposition.

## 5. A local finite-rank repair, and the subsequently refuted estimate

The failure of (12) suggests a different decomposition, not abandoning
the noncylindrical objective. Suppose \(\omega\in X_1\) is smooth,
and set \(A=h_{XY}(0)\). Its first two source jets vanish.
Equation (7) gives
\[
 h_{XYY}(0)=-3\ell\kappa A,\qquad
 c_1=(-\Delta h)_X(0)=3\ell\kappa A,
\]
\[
 c_2=(-\Delta h)_{XY}(0)
             =-\ell^2(9\kappa^2+\tfrac34)A.                     \tag{16}
\]
To see the last equality, put \(B=h_{XYY}(0)/2\).
The \(XY\) coefficient of
\(2bh_{XY}+b^2h_{YY}+dh_Y-3\ell^2h/(4R^2)\)
is \(6\ell\kappa B-3\ell^2A/4\).
The factor \(R^{3/2}\omega\) has no jet of degree at most two.
Evenness of \(a\) removes an \(a'''(0)\) term.

Choose cutoffs \(\chi_R,\chi_0\) equal to one near the origin,
even in \(X\), with \(\chi_R\) supported inside a wall chart
containing the vorticity support. Then define
\[
 H=\chi_Rh+\tfrac12c_1XY^2\chi_0+\tfrac16c_2XY^3\chi_0.          \tag{17}
\]
At \(\kappa=0\) the cubic corrector vanishes and the quartic
corrector is \(-\ell^2AXY^3\chi_0/8\), precisely the
\((3/4)\ell^2A(-XY^3/6)\) correction in Chen--Hou Proposition 6.9.
The exact residual \(f_{\rm err}=-\Delta H-\omega\), with
vorticity extended by zero outside its support, has no jets
of degree at most two and is smooth, odd in \(X\), and compactly
supported. The same argument as for (14) proves
\(f_{\rm err}\in X_1\), but gives **no uniform small bound**.
Near the origin, the tangential velocity is now
\[
               U=-H_Y+3\ell\kappa AXY+O(\rho^3).                \tag{18}
\]
The new explicitly separated quadratic mode is rank one in the
nonlocal strain \(A\). The normal velocity still has an allowed
quadratic remainder. Equations (16)--(18) are a local repair,
not the required stability theorem.

The originally proposed target, with constants independent of \(\ell,S\)
in a nonempty support bootstrap range, was
\[
 |A|+\|f_{\rm err}\|_{X_1}/(\ell(1+S))
           \ \leq\ C_a\|\omega\|_{X_1},                         \tag{19}
\]
together with the corresponding velocity, weighted Holder,
profile, and low-mode bounds. Formula (19) is now **refuted under
these quantifiers** by the theorem in `inverse_obstruction.md`.
That family has uniformly bounded source norm, zero exterior
stream, zero origin jets, and residual norm growing as
\(\log(1/\ell)\) on expanding supports. It uses the actual global
zero-flux inverse. The formula is retained to identify exactly
what failed; it is not an assumption used to conclude blowup.
The new route uses the explicit conformal coordinates (M1)--(M7)
in that proof, where the principal part is the scalar Laplacian.

The required link to stability is specific. Chen--Hou (6.109)
bound their effective-source error in \(X_1\), and Section 6.5
bounds the increments in their weighted energy and nonlinear
modes by a constant times \(\ell S+\nu^{-\gamma}\).
Lemma A.2 requires the pointwise strict margin
\[
 a_{ii}E_*-\sum_{j\ne i}
   (|a_{ij}|E_*+|a_{ij,2}|E_*^2+|a_{ij,3}|)>\varepsilon_0>0
                                                               \tag{20}
\]
for every spatial argument, time, and component, not a generic
unweighted energy inequality. Lemma A.2 also requires a uniform
finite upper bound \(M\) on the sum on the left of the second
inequality in (A.11); the positive margin alone is insufficient.
Their (6.112) chooses the error
below a fixed fraction of this margin and the additional
nonlinear-mode margin. A curved-wall proof must bound (18)'s
new mode and all residual increments in precisely these
inequalities. No such bound or closure is supplied here.

## 6. Evidence, literature boundary, and replay

Run from the campaign directory:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/curved_wall/certificate.py
```

The certificate uses exact SymPy rational identities, not floating-point
samples. Testing the six polynomial jets in the coordinate calculation
determines every coefficient of a linear differential operator of
order at most two, so that part is an operator identity rather than a
finite-instance experiment. Boundary calculations use arbitrary
symbolic jet coefficients; the admissible construction additionally
uses the exact cosine wall, not its global Taylor approximation.
The cutoff existence, regularity, uniqueness, and weighted-norm
arguments are the prose proofs above, not claims about what SymPy
checked.

The prerequisite Jacobian discovery, inspected typed contract,
payload, and output are in `research/jacobian/`. The operation was
`matrix.symbolic.characteristic_polynomial.compute`, server 0.14.0,
protocol 2025-11-25, through the authorized Argus adapter.
The adapter returned exit status 0 with a complete typed output
and no reported error or timeout. It certifies the principal
metric polynomial only. The local certificate independently
compares that polynomial with the displayed formula.

Primary sources:

- Chen--Hou, [arXiv:2210.07191v4](https://arxiv.org/html/2210.07191v4):
  Theorems 2, 5; (6.2)--(6.16); Proposition 6.9; (6.46),
  Remark 6.10, (6.54), (6.76), (6.109)--(6.115);
  Lemma A.2, (A.11); weights (C.1), (C.3), (C.4).
- Chae--Tsai, [arXiv:1402.4560v3](https://arxiv.org/html/1402.4560v3):
  Theorems 1 and 2, including the exact representations, domain
  growth, decay, and boundary hypotheses (2.1)--(2.9),
  (3.1)--(3.3), (3.8)--(3.11).

The latter rigidity statements do not prove an exclusion for
nearly self-similar dynamics without their additional hypotheses.
An independent source reader supported the cylinder and generalized
ansatz citations, but rejected as unsupported the stronger wording
that exact-ansatz hypotheses "cannot be imposed" on nearly
self-similar dynamics. That wording is not used as a theorem here.

A targeted literature search returned Chen--Hou I/II and institutional
copies, but no independently verified noncylindrical extension.
An automated search summary asserted such an extension; the primary
Theorems 2 and 5 instead specify the cylinder. The summary is not
evidence. This limited search neither establishes originality of the
jet observation nor proves absence of other work.

**Open objective:** a uniform quantitative curved-wall reduction with an
actual Euler consequence. Neither the unchanged decomposition (12) nor
the corrected Cartesian \(X_1\) transfer estimate (19) is an available
route. The current analytic question is the uniform scalar inverse
estimate for the explicit conformal system in `inverse_obstruction.md`,
including its exterior and expanding-domain terms, followed by both
inequalities in (A.11) and the separate nonlinear-mode estimates.
