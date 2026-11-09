# Conditional verification of the auxiliary volume construction

## Statement, scope, and prior result

**Conditional theorem.** Retain exactly the prepared-fibration data of
`09-regular-preparation.tex`, Proposition `prop:regular-preparation`, and
the local-model data of `08-local-models.tex`, Theorem `thm:nodal-model`,
including its two annular periods and polynomial intrinsic chart bounds.
Let \(X\) be closed, connected, oriented, and smooth, and retain
\(b^+(X)=3\) from `prop:topology`. The fixed closed definite pair satisfies
\[
 \int_X A^2=\int_X C^2=1,\qquad \int_X AC=0.
\]
All disks, annuli, identifications, and regular prepared data are fixed
before the positive area parameter \(\epsilon\) is chosen. Then there is
\(\epsilon_0>0\) such that, for every \(0<\epsilon<\epsilon_0\), there is a
smooth closed real two-form \(D_\epsilon\) satisfying
\[
 AD_\epsilon=CD_\epsilon=0,\qquad D_\epsilon^2=A^2,
\]
with a positive wedge Gram matrix and positive area on the oriented
fibers, including the smooth parts of nodal fibers.

Products of forms below mean wedge products. Regular preparation and the
nodal-model theorem are **hypotheses**, not conclusions of this audit.
The numerical topology input is also retained explicitly. In particular,
the polynomial core estimates are taken from the stated nodal-model
hypothesis; neither of the two Section 10 lemmas being audited is assumed.
Classical de Rham Hodge theory, Euclidean Sobolev estimates, the
Weitzenbock formula, Banach contraction, and finite-coefficient local
elliptic regularity are the standard analytic inputs described below.
No positive spectral-gap bound is assumed.

This verifies the assertion `thm:auxiliary-solution` conditionally, not
`prop:auxiliary-class`, the endpoint argument, or Donaldson's conjecture.
There is no assertion that \([D_\epsilon]=[B]\), no assertion about
smooth dependence on \(\epsilon\), and no novelty claim for the standard
exact-form identities. The exact certificate checks finite identities,
not the analytic theorem.

The strongest earlier accepted result in this campaign is the conditional
restricted-jet theorem, accepted in
`handoffs/763f04b9f55c/round-0001.json` in the host project. That review is
reused, not reopened. The present improvement is a separate conditional
global construction after preparation: it accounts for both annular
periods, all three global moments, the whole harmonic cokernel,
degenerating-metric estimates, and spatial regularity. It does not
discharge the hypotheses of either conditional theorem.

## 1. Known inputs and routes that do not suffice

Donaldson, **arXiv:math/0607083v1**, Section 2, Proposition 1, proves
the local deformation framework for negative-tangent two-form
constraints with a suitable cohomological transverse condition.
Equation (3) there is precisely
\[
 0=\int_X da\,da=\|(da)^+\|_2^2-\|(da)^-\|_2^2.
\]
These are established prior art, not discoveries here. A fixed-metric
implicit-function theorem alone gives no uniform neighborhood for the
collapsing family. Likewise, existence of a Green operator alone gives
no polynomial bound on a one-form primitive. That shortcut is excluded;
the estimate below is for \(h=da\) itself.

Gross--Wilson, **arXiv:math/0008018v3**, concerns an integrable complex
elliptic K3 surface (24 type-\(I_1\) fibers in its stated generic case)
and a Kahler/complex Monge--Ampere correction. It supplies the
exponential-error-versus-polynomial-loss strategy, but is not a theorem
giving this almost-complex exact-two-form correction. We do not import
its global inverse or scalar complex equation.

Taylor's Hodge notes, revised August 2010, equations (2.1)--(2.2),
give the harmonic projection and Green decomposition. The smooth
de Rham Laplacian is elliptic, so its usual fixed-metric Sobolev
regularity applies. Commutation with the Hodge star is the de Rham
algebraic identity, not a quoted assertion in those notes.
Taylor's *Nonlinear Elliptic Equations*, Section 4, Theorem 4.3,
is an endpoint finite-coefficient regularity theorem for elliptic
systems, and applies to the first-order bootstrap in Section 7.
Exact locators, the reader's observations, and short source passages
are in `primary-sources/readings.md`.

The inherited Wiki index has no matching auxiliary-volume, Donaldson,
Gross--Wilson, or hypersymplectic entry. No claim of a complete
literature search or independently established novelty follows.

## 2. Invariant solution, annular exactness, and the three moments

Write \(\nu=A^2/2\). On a regular translation chart use base coordinates
\((s_1,s_2)\) and period-one fiber angles \((a,b)\). Invariance and
\(\int_{T^2}\Psi=1\) say that the vertical coefficient of \(\Psi\)
is \(da\,db\). Every invariant top form has the form
\(z(s)\,ds_1ds_2da\,db\). Consequently
\[
 \zeta=\Psi\,p^*(p_*\zeta).
\]
This identity does not require \(\Psi^2=0\) or a global section; a
translation of the local origin does not affect the top-degree identity.
Define
\[
 \beta_\epsilon=\frac{p_*(A^2)}{2\epsilon}
                  -\frac{\epsilon}{2}p_*(\Psi^2),\qquad
 D^{\rm sf}_\epsilon=\epsilon\Psi+p^*\beta_\epsilon.
\]
Both summands are closed. A basic two-form wedges to zero with either
fiber-Lagrangian member \(A,C\). Thus the prepared orthogonality gives
\(AD^{\rm sf}_\epsilon=CD^{\rm sf}_\epsilon=0\), and the top-form
identity gives
\[
 (D^{\rm sf}_\epsilon)^2
 =\epsilon^2\Psi^2+\Psi\,p^*(p_*(A^2)-\epsilon^2p_*(\Psi^2))=A^2.
\]
Its fiber restriction is \(\epsilon\Psi\). The pair's positive wedge
block and the positive third square prove definiteness, with the
positive fiber sign.

On a punctured nodal disk the hypotheses give
\(\Sigma=h\,ds\,dz\), \(z=a+\tau b\), \(\tau_2>0\), and
\(\Psi=da\,db\). In the orientation \(dx_1dx_2da\,db\),
\[
 (\Re\Sigma)^2=2|h|^2\tau_2\,dx_1dx_2da\,db,\qquad
 D^{\rm sf}_\epsilon
 =\epsilon\,da\,db+\frac{|h|^2\tau_2}{\epsilon}\,dx_1dx_2.
\]
In particular there is no fiber-sign reversal.

For each fixed annular torus bundle, the monodromy is a single shear.
In an angle convention it is \(T(a,b)=(a-b,b)\); changing the cycle
convention changes the shear sign, not the following conclusion.
The mapping-torus homology exact sequence gives
\[
 0\longrightarrow H_2(T^2;\mathbb R)
 \longrightarrow H_2(M;\mathbb R)
 \longrightarrow\ker(T_*-1:H_1(T^2;\mathbb R)\to H_1(T^2;\mathbb R))
 \longrightarrow0.
\]
The left space has dimension one. The right space has dimension one,
generated by the invariant \(a\)-cycle, and its lift is the sweep at
\(b=0\). Thus a fiber and that sweep test **all** real two-periods.
The local-model hypothesis supplies period \(\epsilon\) on the first
cycle and zero on the second for both forms. Therefore
\(\zeta_\epsilon=D^{\rm loc}_\epsilon-D^{\rm sf}_\epsilon\) is exact.
Equality of fiber area alone would not have sufficed.

Here is an estimate on a primitive, only on this fixed annulus.
Radially identify it with \(M\times[r_0,r_1]\), choose \(r_*\), and set
\[
 K\zeta(r)=\int_{r_*}^r\iota_{\partial_r}\zeta(u)\,du.
\]
For a closed form, radial homotopy gives
\(\zeta=\pi_M^*\zeta_*+dK\zeta\). The exact restriction \(\zeta_*\)
has primitive \(d_M^*G_M\zeta_*\) for a fixed smooth metric on the
compact mapping torus \(M\). Indeed, Hodge decomposition, exactness,
and \(dG_M\zeta_*=G_Md\zeta_*=0\) imply
\(d_Md_M^*G_M\zeta_*=\zeta_*\). Thus
\[
 \alpha_\epsilon=K\zeta_\epsilon+
                    \pi_M^*(d_M^*G_M(\zeta_\epsilon)_*)
 \quad\hbox{satisfies}\quad d\alpha_\epsilon=\zeta_\epsilon.
\]
Restriction, radial integration, and fixed-geometry elliptic estimates
bound each \(C^j\) norm of \(\alpha_\epsilon\) by finitely many
\(C^\ell\) norms of \(\zeta_\epsilon\). All constants and domains here
are independent of \(\epsilon\). A fixed cutoff \(\chi\), one near the
inner edge and zero near the outer edge, therefore glues
\(D^{\rm sf}_\epsilon+d(\chi\alpha_\epsilon)\) to the exact local form.
The result \(E_\epsilon\) is smooth and closed; its residual is
exponentially small in every fixed finite coordinate order and is
supported on fixed annuli. Polynomially large background coefficients
can be absorbed by decreasing the exponential rate. On those annuli
the vertical error is smaller than the positive fiber area
\(\epsilon\); on the cores positivity is the model positivity.

An exact global correction preserves all three relevant integrals.
Set
\[
 a_\epsilon=\int E_\epsilon A,\quad b_\epsilon=\int E_\epsilon C,
 \quad\widehat E_\epsilon=E_\epsilon-a_\epsilon A-b_\epsilon C,\quad
 q_\epsilon=\int\widehat E_\epsilon^2.
\]
The normalized intersection data give, exactly,
\[
 \int\widehat E_\epsilon A=\int\widehat E_\epsilon C=0,\qquad
 q_\epsilon=\int E_\epsilon^2-a_\epsilon^2-b_\epsilon^2.
\]
The annular estimates imply \(a_\epsilon,b_\epsilon=O(e^{-c/\epsilon})\)
and \(q_\epsilon=1+O(e^{-c/\epsilon})\), after reducing \(c>0\).
In particular \(q_\epsilon>0\). With the **positive** square root set
\[
 r_\epsilon=q_\epsilon^{-1/2},\qquad D^0_\epsilon=r_\epsilon\widehat E_\epsilon.
\]
Then
\[
 \int AD^0_\epsilon=\int CD^0_\epsilon=0,\qquad
 \int(D^0_\epsilon)^2=\int A^2=1.
\]
The frame change from \((A,C,E_\epsilon)\) to
\((A,C,D^0_\epsilon)\) has determinant \(r_\epsilon>0\).
It changes neither their three-plane nor its chosen component.
Since \(A,C\) vanish vertically, it also preserves the fiber sign.

## 3. Derivation of polynomial geometry

Let \(g_\epsilon\) be the metric with self-dual plane
\(P_\epsilon=\operatorname{span}(A,C,D^0_\epsilon)\) and volume
\(\nu=A^2/2\). Its total volume is \(1/2\).
There are three regions, all indispensable to the estimate.

**Model cores.** On a fixed smaller nodal disk the unnormalized frame is
\[
 (\Re\Sigma,\ x_0\Re\Sigma+y_0\Im\Sigma,\ D^{\rm loc}_\epsilon).
\]
Its plane is that of the model parallel triple and its volume is
exactly the model volume. Uniqueness of metric from plane and volume
makes \(g_\epsilon\) exactly the transported model metric there.
The chart counts, radii, margins, coefficient bounds, inverses, and
finite derivatives therefore follow from item (iii) of the stated
local-model hypothesis. The three forms are parallel on this region;
their intrinsic derivatives are consequently controlled. No derivative
bound for the holomorphic identification in an unrelated fixed atlas
is used.

**Fixed regular complement.** Here all prepared coefficients, fiber
integrals, and their derivatives are fixed smooth functions on finitely
many compact bundle charts. The coefficients of \(D^{\rm sf}_\epsilon\)
and any prescribed finite number of derivatives are sums of an
\(\epsilon\) term and an \(\epsilon^{-1}\) term. The pair's wedge block,
relative to \(\nu\), is fixed and uniformly positive; the third square
is \(2\nu\) and its mixed products vanish.

To pass from forms to the metric without assuming an estimate, take an
orthonormal self-dual frame \(\Theta_i\), of the orientation giving a
positive metric, with \(\Theta_i\Theta_j=2\delta_{ij}\nu\). It is obtained
using the inverse square root of the positive wedge Gram matrix.
The algebraic identity
\[
 g(v,w)\nu=\frac16\sum_{i,j,\ell}\varepsilon_{ij\ell}
       (\iota_v\Theta_i)(\iota_w\Theta_j)\Theta_\ell
\]
is checked on the standard self-dual frame in the exact verifier.
It gives polynomial coordinate bounds for \(g_\epsilon\) and its
finite derivatives. The density of \(\nu\) is fixed and positive in
these compact charts, so \(\det g_\epsilon\) has a fixed positive
lower bound there. The adjugate formula gives polynomial inverse
metric bounds, and differentiated inversion gives all finite
derivative bounds. Matrix square root and inverse are smooth with
bounded derivatives on the uniformly positive, bounded Gram matrices.

**Fixed gluing annuli.** The coordinate perturbation of the regular
forms is exponentially small, and all its finite derivatives have
that property. The same algebraic construction therefore preserves
uniform Gram positivity and polynomial metric and inverse bounds.
These annuli overlap the exact core and regular regions. Moment
normalization does not change the plane at all. Its exponentially
small constant coefficients add only polynomially controlled
intrinsic derivatives to the normalized frame.

Together these observations prove uniform upper and lower bounds on
the frame Gram matrix \(M_\epsilon=(\langle E_i,E_j\rangle)\), where
\((E_1,E_2,E_3)=(A,C,D^0_\epsilon)\), as well as polynomial intrinsic
bounds for the frame, \(M_\epsilon^{-1}\), curvature, and every fixed
finite curvature derivative.

For clarity, these local bounds also give the required quantitative
global functional estimates. The union of the polynomial-size model
covers and fixed regular/annular covers is already polynomial-size.
Their smaller domains cover with polynomial coordinate margins.
Bounds on both metric eigenvalues convert a further polynomial
coordinate shrinkage to an intrinsic interior radius bounded below
by a power of \(\epsilon\). Coordinate cutoffs have polynomial
covariant derivative bounds. Their sum is bounded below on the smaller
cover, so normalization gives a partition of unity with polynomial
derivatives. Even the crude overlap bound by the number of charts is
polynomial. This uses no unbounded transition-map estimate: derivatives
of each cutoff are estimated intrinsically in its own chart.

Euclidean Sobolev inequalities on these domains, dilation by their
polynomial radii, and the coordinate/covariant norm comparisons give
polynomial global Sobolev constants. Fix \(k=6\). In a derivative of a
product of total order at most \(k\), one factor has order at most
\(\lfloor k/2\rfloor=3\); the \(H^k\) norm controls that factor in
\(L^\infty\), since \(k-3>4/2\). The other factor is controlled in
\(L^2\). Hence for some finite \(q\)
\[
 \|h\widetilde h\|_{H^k}\le Q_\epsilon
          \|h\|_{H^k}\|\widetilde h\|_{H^k},
 \qquad Q_\epsilon\le C\epsilon^{-q}.
\]
The \(H^k\)-to-\(C^0\) embedding also has a polynomial constant.
The identical argument works at any one fixed sufficiently large order.

Before normalization the residual vanishes off the gluing annuli.
On the annuli conversion from coordinate to intrinsic derivatives
costs only powers. Normalization adds exponentially small constants
times globally polynomially controlled forms; the total volume is
fixed. Therefore, for the chosen finite \(k\),
\[
 {\cal R}_\epsilon=
 \left(-AD^0_\epsilon,-CD^0_\epsilon,
                    \frac{A^2-(D^0_\epsilon)^2}{2}\right),\qquad
 \delta_\epsilon:=\|{\cal R}_\epsilon\|_{H^k}
       \le C\epsilon^{-s}e^{-c/\epsilon}.
\]
This derives all parts of `lem:auxiliary-geometry`; it does not posit
a polynomial inverse or a spectral gap.

## 4. Exact two-forms and exhaustion of the harmonic cokernel

First consider any one smooth compact oriented four-manifold and metric.
The map
\[
 h\longmapsto h^+
\]
from exact two-forms has image exactly the self-dual forms orthogonal
to the harmonic self-dual forms. Necessity follows by integration by
parts against any closed self-dual form. For sufficiency, let \(\phi\)
be self-dual and orthogonal to that harmonic space. It is automatically
orthogonal to harmonic anti-self-dual forms. Thus its full harmonic
projection vanishes. The de Rham identity \(\Delta *=*\Delta\), obtained
from the formula for \(d^*\) and \(**=(-1)^{p(4-p)}\), implies that
\(G\phi\) is self-dual: both \(G\phi\) and \(*G\phi\) solve the same
equation on the harmonic complement.

For a self-dual two-form \(\psi\), \(d^*\psi=-*d\psi\) and therefore
\[
 \Delta\psi=(1+*)dd^*\psi=2(dd^*\psi)^+.
\]
It follows that
\[
 h=2dd^*G\phi
\]
is exact and \(h^+=\phi\). This is only a fixed-metric existence formula;
no family estimate for \(G\), \(d^*G\), or a primitive is being used.
The argument extends to Sobolev data by fixed-metric elliptic
regularity or smooth approximation.

For the metric of Section 3, each \(E_i\) is closed and self-dual, hence
harmonic. Pointwise independence makes them independent as global
forms. Since **\(b^+(X)=3\)**, they exhaust the harmonic self-dual
space as a vector space of global forms with constant coefficients.
This is the step that would fail with an additional harmonic direction.

For top forms \(f_i=t_i\nu\), put \(t=(t_1,t_2,t_3)\). Their three
wedge equations prescribe
\[
 \phi=\sum_j(M_\epsilon^{-1}t)_jE_j,\qquad
 \langle\phi,E_i\rangle_{L^2}=\int_X f_i.
\]
Consequently the three zero-mean conditions are exactly the entire
harmonic-cokernel condition. They are not merely necessary moments.
The construction above gives the desired exact \(h\) with
\(E_i h=f_i\).

## 5. Derivation of the inverse estimates without a spectral gap

For every exact smooth \(h\), Stokes gives
\[
 0=\int_X h^2=\|h^+\|_2^2-\|h^-\|_2^2,\qquad
 \|h\|_2^2=2\|h^+\|_2^2.
\]
This also holds for exact \(L^2\) forms: take a fixed-metric \(H^1\)
primitive, approximate it by smooth one-forms, and pass in \(L^1\) in
the square. An exact anti-self-dual form is therefore zero, proving
uniqueness of \(h\), not uniqueness of a primitive.

Let \(m_0>0\) be a common lower eigenvalue bound for \(M_\epsilon\).
Pointwise,
\[
 |\phi|^2=t^{\mathsf T}M_\epsilon^{-1}t\le m_0^{-1}|t|^2.
\]
Since \(\nu\) is the parallel unit volume form, multiplication or
division by \(\nu\) preserves the intrinsic Sobolev norms for top
forms and functions. Thus the \(L^2\) inverse bound is actually uniform:
\[
 \|h\|_2\le\sqrt{2/m_0}\,\|f\|_2.
\]

For higher derivatives, write \(\phi=h^+\). Closedness gives the exact
identities
\[
 dh=0,\qquad *h=2\phi-h,\qquad d^*h=-2*d\phi.
\]
The integrated Weitzenbock identity yields
\[
 \|\nabla h\|_2^2
 \le 4\|d\phi\|_2^2+
                C\|\operatorname{Rm}\|_\infty\|h\|_2^2.
\]
To specify the iteration, apply the tensor-valued Hodge Weitzenbock
identity to \(T=\nabla^j h\), viewed as a two-form with \(j\) additional
covariant indices. The curvature action on these indices is algebraic,
bounded by \(C_j|\operatorname{Rm}||T|\). Commuting its alternating
derivative and divergence past \(\nabla^j\) produces sums of
\[
 \nabla^\ell\operatorname{Rm}*\nabla^{j-1-\ell}h,
 \qquad 0\le\ell\le j-1.
\]
There are no derivatives of \(h\) above order \(j-1\) in these
commutators. The remaining leading divergence term is
\(-2*\nabla^j d\phi\), controlled by \(C_j\|\phi\|_{H^{j+1}}\).
After the integrated identity and the triangle inequality,
\[
 \|\nabla^{j+1}h\|_2
 \le C_j\|\phi\|_{H^{j+1}}+K_{j,\epsilon}\|h\|_{H^j},
\]
where \(K_{j,\epsilon}\) is bounded by a polynomial in finitely many
suprema of curvature derivatives (and their square roots, harmless
after increasing the power). Section 3 bounds all of them polynomially.
Induction from the exact \(L^2\) identity proves
\[
 \|h\|_{H^k}\le C_k\epsilon^{-p_k}\|\phi\|_{H^k}.
\]
Differentiating \(\phi=\sum_j(M_\epsilon^{-1}t)_jE_j\) uses only
the polynomial frame and inverse-Gram bounds, so
\[
 \|{\cal L}_\epsilon f\|_{H^k}
 \le P_\epsilon\|f\|_{H^k},\qquad P_\epsilon\le C_k\epsilon^{-p_k}.
\]
There is **no loss of derivatives**. Smooth approximation gives this
estimate on the corresponding Sobolev spaces. This derives
`lem:auxiliary-inverse`, including its existence, uniqueness,
cokernel, and polynomial estimate.

## 6. A uniform small-parameter contraction and the fiber sign

For the fixed \(k=6\), exact \(H^k\) forms form a closed Banach
subspace: equivalently they are distributionally closed with zero
harmonic projection for any one fixed smooth metric. The equivalence
and \(H^{k+1}\) primitives are fixed-metric Hodge facts; their constants
are not used in the contraction estimates.

For exact \(h\) set
\[
 {\cal T}_\epsilon(h)={\cal L}_\epsilon
 \left(-AD^0_\epsilon,-CD^0_\epsilon,
            \frac{A^2-(D^0_\epsilon)^2-h^2}{2}\right).
\]
The three free data have zero integral by Section 2. Moreover
\(\int h^2=0\) for **every** exact iterate, including Sobolev iterates.
Thus this map always lies in the domain of the inverse. This is why
no harmonic obstruction is generated at nonlinear order.

Use the derived bounds \(P_\epsilon\le C\epsilon^{-p}\),
\(Q_\epsilon\le C\epsilon^{-q}\), and
\(\delta_\epsilon\le C\epsilon^{-s}e^{-c/\epsilon}\). If
\(\delta_\epsilon>0\), define
\[
 R_\epsilon=2P_\epsilon\delta_\epsilon,\qquad
 \lambda_\epsilon=P_\epsilon Q_\epsilon R_\epsilon
                  =2P_\epsilon^2Q_\epsilon\delta_\epsilon.
\]
On the closed radius-\(R_\epsilon\) ball,
\[
 \|{\cal T}_\epsilon(h)\|_{H^k}
 \le R_\epsilon/2+\lambda_\epsilon R_\epsilon/2,\qquad
 \|{\cal T}_\epsilon(h)-{\cal T}_\epsilon(\widetilde h)\|_{H^k}
 \le\lambda_\epsilon\|h-\widetilde h\|_{H^k}.
\]
For every sufficiently small \(\epsilon>0\), \(\lambda_\epsilon<1/2\):
its upper bound is \(C\epsilon^{-(2p+q+s)}e^{-c/\epsilon}\).
For completeness, exponential domination follows by choosing an integer
\(n>2p+q+s\) and using
\[
 e^{c/\epsilon}\ge(c/\epsilon)^n/n!,
 \quad
 \epsilon^{-(2p+q+s)}e^{-c/\epsilon}
 \le n!c^{-n}\epsilon^{\,n-(2p+q+s)}\longrightarrow0.
\]
The ball maps into its radius-\(3R_\epsilon/4\) subball, and the map
is a strict contraction. Banach's theorem gives an exact \(h\) with
\(\|h\|_{H^k}\le2P_\epsilon\delta_\epsilon\). If the residual is
identically zero, take \(h=0\), without dividing by \(R_\epsilon\).
Expanding the fixed-point equation proves all three target equations
for \(D_\epsilon=D^0_\epsilon+h\).

Polynomial Sobolev embedding implies \(\|h\|_{C^0(g_\epsilon)}\to0\)
exponentially. This controls the correct intrinsic norm, including on
the collapsing cores. Uniform positivity and boundedness of the
approximate frame's Gram matrix imply that the segment
\((A,C,D^0_\epsilon+t h)\), \(0\le t\le1\), stays positive for small
\(\epsilon\). Hence it retains the initial component.

More explicitly, the structure \(J\) determined by the definite pair
is Hermitian for \(g_\epsilon\). Decompose \(D^0_\epsilon\) within the
self-dual plane into its component in \(\operatorname{span}(A,C)\)
and its orthogonal component \(d_\epsilon\omega_J\). The positive
Schur complement of the uniformly positive Gram matrix bounds
\(d_\epsilon\) below by a positive constant, with the sign chosen by
the oriented fibers. The pair component vanishes on every \(J\)-line,
whereas \(\omega_J(v,Jv)=|v|_{g_\epsilon}^2\). Thus a sufficiently
small intrinsic \(h\) preserves the positive fiber sign without any
fixed-coordinate lower bound near the node. At the endpoint the exact
orthogonality makes \(D_\epsilon\) a positive \(J\)-invariant form.
The fiber smooth loci and the local nodal branches are \(J\)-lines by
the retained hypotheses. A singular point itself is not assigned a
nonexistent smooth fiber tangent plane.

## 7. Spatial smoothness at the one chosen parameter

Now fix any \(\epsilon\) below the finite-order threshold. Choose a
Coulomb primitive \(a\in H^{k+1}\), with \(da=h\) and
\(d^*_{g_\epsilon}a=0\). Its norm may depend arbitrarily on this fixed
metric: no estimate for it enters Section 6.

Write the three equations for \(D^0_\epsilon+da\), dividing top forms
by the smooth positive \(\nu\), together with this gauge equation.
This is a smooth nonlinear first-order system of four equations for
four real components. At the solution, its principal symbol sends
\(b\) at \(\xi\ne0\) to the three wedge products of \(\xi b\) with
\(A,C,D_\epsilon\), and to
\(\langle\xi,b\rangle_{g_\epsilon}\).
If the three products vanish, \(\xi b\) belongs to the wedge-orthogonal
complement of the positive three-plane
\(\operatorname{span}(A,C,D_\epsilon)\). That complement is strictly
negative definite. But \((\xi b)^2=0\), so \(\xi b=0\).
Hence \(b=t\xi\); the gauge gives \(t|\xi|_{g_\epsilon}^2=0\).
The symbol is injective and square, hence elliptic. The standard-frame
determinant \(|\xi|^4\) is checked separately, but this invariant
argument verifies the actual solution symbol, not just a model one.

In dimension four, \(a\in H^7\) implies \(a\in C^{4,\alpha}\) for
any fixed \(0<\alpha<1\). Differentiate the local nonlinear system.
For \(u=\partial_j a\) the resulting first-order elliptic system has
coefficients \(F_{Da}(x,a,Da)\) and right-hand side consisting of
smooth background derivatives evaluated on \(a,Da\). These are
\(C^{3,\alpha}\); no second derivative of \(a\) remains on the
right-hand side. Coefficient and lower-order terms from the smooth
Coulomb gauge have the same or better regularity.

Apply Taylor's Theorem 4.3 locally with differential order \(m=1\),
coefficient index \(s=3+\alpha\), and unknown \(u=\partial_j a\).
Its initial requirement \(u\in C^{m-s+\eta}\) is satisfied, for example
with \(\eta=s>0\), since \(u\in C^{3,\alpha}\subset C^1\).
The endpoint conclusion is
\[
 u\in C_*^{m+s}=C^{4,\alpha},\qquad a\in C^{5,\alpha}.
\]
The equality of these Hölder--Zygmund and ordinary Hölder spaces uses
the nonintegral exponents. Repeating the differentiated argument raises
the order by one each time. Ellipticity persists at the same solution.
Local estimates, with successively smaller interior neighborhoods,
give smoothness everywhere. All bootstrap constants may depend on the
fixed \(\epsilon\); no intersection of infinitely many parameter
thresholds has been taken.

## 8. Node-free case, certificate, and remaining boundary

If there are no nodal fibers, \(X^\circ=X\), so
\(D^{\rm sf}_\epsilon\) is globally smooth and already solves the target
equations with positive fiber sign for every \(\epsilon>0\).
Its mixed moments are zero and its square integral is one:
\(a_\epsilon=b_\epsilon=0,\ q_\epsilon=r_\epsilon=1\).
Thus \(E_\epsilon=D^0_\epsilon=D_\epsilon=D^{\rm sf}_\epsilon\),
the residual is zero, and no contraction or limiting argument is
needed. This is not an implicit exclusion of the torus case.

Run the standalone finite replay with

```
$WORKSPACE/argus-live-update/.venv/bin/python research/auxiliary-volume-audit/verify.py
```

`exact_certificate.json` records its exact scope. The verifier checks
the invariant and local wedge identities, the metric reconstruction
identity with its frame orientation, both annular test directions,
moment normalization and frame determinant, Gram-adjugate and
self-dual identities, the gauge symbol determinant, and contraction
arithmetic. The Jacobian adapter's exact typed determinant payload and
result are preserved separately and independently replayed.
These are algebraic checks, **not** a machine proof of Hodge theory,
annular topology, the geometry bounds, Stokes, elliptic estimates,
Banach contraction, or smoothness. Those arguments are above and
require the normal independent Reviewer.

No new Lean file is introduced: the unresolved burden here is global
analysis, and kernel-checking the standard algebra again would not
certify it. No formal compiler result for another mission is promoted
to evidence for this analytic theorem. The upstream regular preparation,
local model, topology input, auxiliary-class chamber comparison, and
main deformation theorem remain outside the conclusion.
