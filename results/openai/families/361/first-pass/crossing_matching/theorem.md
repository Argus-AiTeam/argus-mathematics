# Exact crossing matching for whole-ball harmonic restriction

## Result and scope

This is a proof of a parameter-uniform verification theorem, not a
counterexample to the manuscript. It verifies the complete transfer/matching/
growth implication **assuming the angular program and radial realization
specified below**. It does not prove that the manuscript constructs that
angular program, prove its Ricci-curvature calculation, or settle its main
dimension-comparison theorem. No false literal manuscript assertion was found
in the three sections audited here; no `refutes` verdict is asserted.

The manuscript proves its implication with slowness exponent `3/4`, control
exponent `3/4`, and column-box exponent `1/8`. The theorem below treats the
open region

\[
 {\cal D}=\{(\rho,q,\beta):\tfrac12<\rho<1,\quad
                  \tfrac12<q<1,\quad 0<\beta<q-\tfrac12\}.
 \tag{1}
\]

The finite-order extension below also allows nonlinearly split odd-order
crossings, which the manuscript's simple-crossing hypothesis excludes.
All thresholds are uniform on compact subsets of the stated regions. In particular,
the future dependence of the invariant graph, arbitrary earlier controls,
matrix inversion order, crossing-cut rounding, and simultaneous controls
are included, rather than replaced by finite spectral arithmetic.

The associated claims are `C_CM_UNIFORM`, `L_CM_TRANSFER`,
`L_CM_GRAPHS`, `L_CM_SIGN`, `L_CM_MATCHING`, and `L_CM_GROWTH`.
`C_CM_FORMAL_CORE` is the strictly narrower kernel-checked implication
described in `statement_fidelity.md`.

## Explicit hypotheses

Fix a probability area measure \(\mu\) on \(S^2\), a positive number
\(0<a<1\), and a finite integer \(p\). All angular data below are fixed
before the start \(J\). The constants are allowed to depend on these data,
including \(p\). They are not asserted uniform as the degree \(k\) grows.

**H1 (smooth fixed-area angular family).** A smooth finite-dimensional family
\(h(w)\) of sphere metrics has area form \(4\pi\mu\). The reference
\(w(s)\), \(s\geq0\), is smooth and periodic, with compact image in the
parameter domain, and is constant on a neighborhood of phase zero.
Its extension to negative phases is smooth, equals its initial value near
zero, and is round for \(s\leq-2\). The reference and all sufficiently small
perturbations below range in one compact smooth uniformly elliptic family.
Write \(L(s)=-\Delta_{h(w(s))}\), on the common space \(L^2(\mu)\).

**H2 (protected continued frame).** The first \(p\) eigenpositions admit a
smooth real orthonormal continued eigenframe \(e_i(s)\), with eigenvalues
\(\lambda_i(s)\in[0,\Lambda]\). There are a label period \(P>0\) and a
frame period dividing \(2P\). The gap above the cluster is at least \(g>0\).
Every equality between two different labels is an isolated positive
double eigenvalue, with nonzero derivative of
\(\lambda_h-\lambda_i\). Crossing phases \(s_\nu>0\) have a positive
minimum separation and finitely many repeated types. Each pair either
never crosses, with a uniform eigenvalue gap, or has periodically repeated
simple crossings. The first crossing is separated from phase zero.
All fixed-order angular and phase norms of the reference frame are bounded.

**H3 (one signed control per double).** For each crossing choose a fixed
smooth parameter direction \(\psi_\nu\) with
\[
 c_\nu=\langle e_h(s_\nu),\dot L_\nu(s_\nu)e_i(s_\nu)\rangle\ne0,
 \qquad
 \dot L_\nu(s)=\left.\partial_\epsilon\right|_0
           (-\Delta_{h(w(s)+\epsilon\psi_\nu)}).
 \tag{2}
\]
There are finitely many repeated direction and bump types. Smooth bumps
\(0\leq\chi_\nu\leq1\) have disjoint fixed phase supports, equal one on
fixed neighborhoods of their crossings. Shrink these supports, if needed,
so the coefficient in (13) has a fixed nonzero sign on them. Their
plateau half-widths have a positive minimum. The initial constant interval
is disjoint from all supports.

For \((\rho,q,\beta)\in{\cal D}\) define
\[
 \eta(t)=t^{-\rho},\quad
 s_J(t)=\frac{t^{1-\rho}-J^{1-\rho}}{1-\rho},\quad
 s_J(t_\nu)=s_\nu,\quad \varepsilon(t)=\eta(t)^q,
\]
\[
 w_z(t)=w(s_J(t))+
        \sum_\nu z_\nu\varepsilon(t_\nu)\chi_\nu(s_J(t))\psi_\nu,
 \qquad z\in[-1,1]^{\mathbb N}.
 \tag{3}
\]
Use the negative-phase extension in (3), and the round value for \(t\leq0\).
There is no accumulation of supports on compact time intervals.

**H4 (radial and core hypotheses).** For every sufficiently late \(J\)
there is a smooth positive warping function \(f_J(r)\), independent of
\(z\), with \(f_J(r)=r\) near zero. The controlled polar metric
\[
 g_z=dr^2+f_J(r)^2h(w_z(\log r))
 \tag{4}
\]
is smooth at zero. Put \(b_J(t)=e^{-t}f_J(e^t)\).
For one fixed \(0<c<1\), uniformly for \(t\geq cJ\) and for the exponents
under consideration,
\[
 a\leq b_J(t)\leq1,\qquad
 |b_J(t)-a|\leq C t^{1-2\rho},\qquad
 |b_{J,t}|+|b_{J,tt}|\leq C\eta(t)^2 .
 \tag{5}
\]
The constants are independent of \(J,z\). Fixed-ball coefficients depend
continuously, in smooth norms, on the finitely many controls meeting that
ball. Formula (3) has this property automatically.

**H5 (uniformity convention).** For a compact set \(K\subset{\cal D}\),
the same angular data and constants in H1--H4 work for the exponents in
\(K\). No compactness or uniform geometry is required of an unbounded
collection of angular programs with increasing \(p\). The reference
negative-phase interpolation is included in the compact smooth family.

**H6 (frequency hypothesis, only for the growth conclusion).** Let
\[
 d(x)=\frac{-1+\sqrt{1+4x}}2,\quad
 \Theta_i(s)=d(a^{-2}\lambda_i(s)),\quad
 m_i=P^{-1}\int_0^P\Theta_i(s)\,ds .
 \tag{6}
\]
For a prescribed \(k>0\), assume every \(m_i<k\).

## Theorem

Under H1--H5, every compact \(K\subset{\cal D}\) admits \(J_0\) such that,
for every \((\rho,q,\beta)\in K\) and integer \(J\geq J_0\), a **single**
control sequence \(z\) gives the following conclusions for the actual
whole-ball harmonic restriction maps \(T_j\), \(j\geq J\).

There are invariant graph maps \(V_j:\mathbb R^p\to E_j^\perp\),
\(\|V_j\|=O(\eta(j)^q)\), and a basis of low columns
\[
 v_i(j)=\mathbf e_i+\sum_{h\ne i}u_{hi}(j)\mathbf e_h,\qquad
 |u_{hi}(j)|\leq C\eta(j)^{q-1/2}<\eta(j)^\beta ,
 \tag{7}
\]
such that, with \(M_j=T_{LL}+T_{LQ}V_{j+1}\) and \(A_j=M_j^{-1}\),
\[
 A_jv_i(j)=\sigma_i(j)v_i(j+1),\qquad
 \sigma_i(j)=e^{d(b_J(j)^{-2}\lambda_i(s_J(j)))}+O(\eta(j)^q)>0 .
 \tag{8}
\]
The graphs and \(A_j\), before controls are selected, are continuous in
the full product topology and satisfy estimates uniform in every control.

The lifted traces define \(p\) independent smooth entire harmonic
functions \(U_i\). For all real \(t\geq J\),
\[
 \log\|U_i(e^t,\cdot)\|_2
 =m_i(t-J)+O\bigl(1+t^\rho+t^{2-2\rho}
                        +t^{1-\rho q}+t^{1-\rho}\bigr).
 \tag{9}
\]
The constants in these estimates can be chosen uniformly on \(K\).
Consequently their exact spherical logarithmic growth exponents are
\(m_i\). Under H6, every \(U_i\) has pointwise growth at most \(k\),
at every point and not just on a mesh of radii.

### Proof 1: actual restriction maps and uniform freezing

All balls in the smooth polar metric are ordinary smooth bounded
coordinate balls; \(d_g(0,(r,\omega))=r\). Smooth Dirichlet solvability
follows by subtracting a smooth boundary extension, applying the coercive
variational theorem, and boundary elliptic regularity. The analytic facts
used here are recorded as `A_CM_ELLIPTIC`; the primary source and precise
regularity hypotheses are in the literature note below.

The fixed area form gives
\[
 u_{rr}+2(f'/f)u_r+f^{-2}\Delta_{h(w_z)}u=0,\qquad
 (f^2\bar u_r)'=0 .
\]
The constant of integration is zero by smoothness in the Euclidean core.
Thus whole-ball restriction preserves the \(\mu\)-mean. The weak maximum
principle follows directly by testing the divergence-form equation with
the positive part of \(u-\max_{\partial B}u\); the Dirichlet energy of that
positive part is zero. It gives positivity and preservation of constants.
At each inner point positivity applied to \((v-c)^2\), with
\(c=(Tv)\) at that point, gives \((Tv)^2\leq T(v^2)\).
Integrating yields \(\|Tv\|_2\leq\|v\|_2\), for every two radii.

Smooth boundary approximations and this contraction define \(T\) on
\(L^2(\mu)\). The normalized divergence equation on a fixed-width
logarithmic cylinder centered at \(t_0\) is
\[
 \partial_t(e^{t-t_0}b^2 u_t)
       +e^{t-t_0}\Delta_{h(w_z(t))}u=0 .
 \tag{10}
\]
In a finite angular atlas its coefficients are uniformly elliptic and
uniformly \(C^1\). Interior \(H^2\) estimates, followed by Sobolev embedding
in dimension three, bound the interior sup norm by the cylinder \(L^2\)
norm and give compactness of interior traces. For a fixed smooth metric,
higher regularity also proves smoothness. Thus the \(L^2\) extension is
the trace of one harmonic function on every strictly smaller ball.
All the late-cylinder constants are independent of earlier controls.

Let \(P_j^0=e^{-d(b(j)^{-2}L(s_J(j)))}\). To prove
\(\|T_j-P_j^0\|=o(1)\) uniformly, suppose otherwise and choose
\(j_n\to\infty\), \(J_n\leq j_n\), arbitrary controls and unit boundary
vectors \(v_n\), with a fixed positive norm discrepancy. Subsequence
compactness gives \(v_n\rightharpoonup v\) and smooth convergence of the
reference link at \(j_n\). Shift the outer time to \(x=0\).
The good-coefficient interval extends to at least
\(-(1-c)j_n-1\); on every fixed subinterval of \(x\leq0\), the actual
coefficients converge to those of
\[
 U_{xx}+U_x-a^{-2}L_\infty U=0 .
 \tag{11}
\]
All sectional \(L^2\) norms are at most one. The local estimates above
give strong compactness of the trace at \(x=-1\).

For completeness the limiting boundary value is not assumed to be a
strong limit. For smooth \(\phi\), set \(y_n(x)=\langle u_n(x),\phi\rangle\).
On \([-1,0)\), \(y_n''+\gamma_n y_n'\) is uniformly bounded, where
\(\gamma=1+2b_t/b\). The \(y_n\) are bounded. The mean-value theorem on
\([-1,-1/2]\), followed by integrating the equation for \(y_n'\), bounds
\(y_n'\) up to zero. Hence the limit has weak trace \(v\). In the
eigenbasis of \(L_\infty\), the two roots of (11) are
\(d(a^{-2}\lambda)\) and \(-1-d(a^{-2}\lambda)\).
Boundedness toward \(x=-\infty\) eliminates the latter, including the
root \(-1\) for constants. The limit therefore equals
\(e^{xd(a^{-2}L_\infty)}v\). The frozen solutions with boundary \(v_n\)
have the same unique limit. Their traces and the actual traces at \(-1\)
converge strongly to the same vector, contradicting the discrepancy.

For the sharper estimate put
\(\ell_j=4\log(1/\eta(j))\), and freeze the actual controlled link and
radial coefficient at \(j\). On the cylinder \([j-\ell_j,j+1]\), the
frozen bounded-backward solution with boundary \(e_i(s_J(j+1))\) has
uniformly bounded pointwise derivatives: commute powers of its elliptic
Laplacian through the contracting spectral semigroup and use compact-family
elliptic estimates. Formula (3) gives \(H_t=O(\eta)\),
\(H_{tt}=O(\eta^2)\), since \(\eta'=O(\eta^2)\); its constants are uniform
on \(K\). The residual in the actual equation is
\(O((1+\ell_j)\eta(j))\).

The difference from the actual whole-ball solution vanishes at the
right endpoint, and is uniformly bounded at the left endpoint by the
maximum principle, independently of everything inside that endpoint.
For large \(J\), \(\gamma\geq3/4\). The scalar barrier
\[
 B(t)=C(1+\ell_j)\eta(j)(j+1-t)
                 +C e^{-(t-j+\ell_j)/2}
\]
dominates the difference at both endpoints, and
\((\partial_t^2+\gamma\partial_t)B\) dominates the negative absolute
residual. Comparison, or the positive-part energy argument, gives
\[
 \|(T_j-P_j^*)e_i(s_J(j+1))\|_2
 \leq C\{\eta(j)\log(1/\eta(j))+\eta(j)^2\}
 =o(\varepsilon(j)).
 \tag{12}
\]
The slab lies above \(cJ\) uniformly for \(j\geq J\) after one late
choice of \(J\). The last equality uses \(q<1\), uniformly on \(K\).

### Proof 2: graph tails, inverses, and the crossing coefficient

Let \(E_j\) be the reference cluster with frame map \(\iota_j\), and use
its orthogonal complement to block \(T_j\). Smooth movement of the frame
is \(O(\eta)=o(\varepsilon)\). The protected spectral projection for
the actual frozen link differs from the reference projection by
\(O(\varepsilon)\). Thus (12) gives
\[
 T_{QL}=O(\varepsilon_j),\qquad
 T_{LL}=\operatorname{diag}(e^{-d_i(j)})+O(\varepsilon_j).
\]
The operator-norm freezing gives \(T_{LQ}=o(1)\) and
\(\|T_{QQ}\|\leq\kappa\tau_j\), for a fixed \(\kappa<1\), where
\(\tau_j=\min_i e^{-d_i(j)}\geq\tau_*>0\).
The gap gives a uniform relative contraction; absorbing absolute
freezing errors into it is legitimate precisely because \(p\) is fixed.

For a fixed small operator ball define
\[
 {\cal F}_j(V)=(T_{QL}+T_{QQ}V)(T_{LL}+T_{LQ}V)^{-1}.
\]
Neumann inversion gives the low inverse bound
\(\tau_j^{-1}(1+o(1))\). The inverse-difference identity in its correct
order shows that \({\cal F}_j\) is a contraction with some
\(\kappa_0<1\), uniformly over all controls, and
\(\|{\cal F}_j(0)\|\leq C\varepsilon_j\).
Terminal-zero inward iterates therefore converge, independently of the
terminal choice, to the unique small graph family, with
\[
 \|V_j\|\leq C\sum_{m\geq0}\kappa_0^m\varepsilon_{j+m}
 \leq C'\varepsilon_j.
\]
In particular \(T_{LQ}V_{j+1}=o(\varepsilon_j)\). Its exact identity is
\[
 T_j(\iota_{j+1}c+V_{j+1}c)
       =\iota_jM_jc+V_jM_jc,\qquad M_j=T_{LL}+T_{LQ}V_{j+1}.
\]
Outward transfer is \(A_j=M_j^{-1}\), not any reversed product.

For fixed \(j\), smooth fixed-ball coefficient convergence gives strong
continuity of \(T_j\). One way to see this without an infinite-dimensional
operator-norm claim is to subtract the variational problems for a fixed
smooth boundary value. Uniform coercivity bounds the zero-boundary
solution difference in \(H^1\) by the coefficient difference; interior
regularity gives convergence at the inner sphere. Density and contraction
extend this to fixed \(L^2\) data. Strong continuity is operator-norm
continuity when restricted to finitely many convergent input columns.
Each finite graph iterate is therefore continuous in the controls on its
finitely many balls. The uniform tail \(C\kappa_0^{N-j}\) proves product
continuity of the limiting graph and \(A_j\). This handles both earlier
histories and arbitrarily remote future controls.

Here are details of the spectral foundations and differentiations used
above. The coercive form for \(1+L\), followed by chartwise elliptic
regularity and compact Sobolev embedding, makes \((1+L)^{-1}\) a compact,
positive, injective self-adjoint operator on \(L^2(\mu)\).
Its spectral basis can also be obtained directly: maximize its Rayleigh
quotient on the weakly compact unit ball, use compactness to attain the
maximum, and vary the maximizer to obtain an eigenvector. Repeat in
orthogonal complements. Compactness forces the successive eigenvalues
to tend to zero; an omitted orthogonal complement with nonzero
restriction would have a positive Rayleigh maximum, a contradiction.
Injectivity excludes a residual kernel. This gives the eigenbasis and
spectral contraction used in Proof 1. Elliptic regularity gives the
common operator domain \(H^2\); parameter derivatives of the Laplacians are
bounded \(H^2\to L^2\). The resolvent identity and a Neumann series on a
contour around the protected cluster give a smooth finite-rank Riesz
projection. Cauchy functional calculus on that contour gives the
divided-difference derivative in the reference eigenbasis. The part of
the compressed frozen contraction passing through the complementary
perturbed projection is \(O(\epsilon^2)\), since both projection factors
are \(O(\epsilon)\). Hence it has zero first derivative.

Write \(Q_b(x)=e^{d(b^{-2}x)}\), \(P_b=Q_b^{-1}\). Differentiating the
inverse of the frozen low compression gives
\[
 -Q_b(x)Q_b(y)P_b[x,y]=Q_b[x,y].
\]
Consequently, on the plateau of event \(\nu\),
\[
 (A_j)_{hi}
 =z_\nu\varepsilon(t_\nu)m_{hi}(s_J(j),b(j))+o(\varepsilon_j),
 \qquad
 m_{hi}(s,b)=Q_b[\lambda_h(s),\lambda_i(s)]
              \langle e_h(s),\dot L_\nu(s)e_i(s)\rangle.
 \tag{13}
\]
At equality this is
\[
 m_{hi}=e^{d(b^{-2}\lambda)}\,b^{-2}d'(b^{-2}\lambda)c_\nu .
\]
There is exactly one factor \(b^{-2}\). The reversed entry has the same
coefficient at equality by self-adjointness in the fixed area space.
Continuity and (2) give a fixed sign and a positive lower bound near the
crossing, uniformly for \(b\) close to \(a\).
All replacements cost \(O(\varepsilon^2)+o(\varepsilon)+O(\eta)\).
Thus (13) is uniform with every other control free, not just for a
truncated control family.

### Proof 3: signed mismatches and one simultaneous infinite match

Write \(A_j=\operatorname{diag}(\alpha_i(j))+{\cal E}_j\).
For column coordinates in the boxes
\(|u_{hi}(j)|\leq\eta(j)^\beta\), the normalized distinguished image
coordinate is positive, and exact line invariance is equivalent to
\[
 u_{hi}(j+1)=r_{hi}(j)u_{hi}(j)+F_{hi}(j),\quad
 r_{hi}=\alpha_h/\alpha_i,
\]
\[
 F_{hi}=
 \frac{{\cal E}_{hi}+\sum_{\ell\ne i}{\cal E}_{h\ell}u_{\ell i}
 -r_{hi}u_{hi}({\cal E}_{ii}
                       +\sum_{\ell\ne i}{\cal E}_{i\ell}u_{\ell i})}
 {\alpha_i+{\cal E}_{ii}+\sum_{\ell\ne i}{\cal E}_{i\ell}u_{\ell i}}.
 \tag{14}
\]
Thus \(|F_{hi}|\leq C\varepsilon_j\). At \(z_\nu=\pm1\), (13) and
\(\beta>0\) imply that on the plateau the force has the sign of
\(z_\nu m_{hi}\), and magnitude at least \(c\varepsilon(t_\nu)\).
Every error is uniform over all column coordinates as well as controls.

The sign of \(\log r_{hi}\) is the sign of \(\lambda_h-\lambda_i\);
the radial factor is common to both. Cut at \(N_\nu=\lceil t_\nu\rceil\).
At a positive-to-negative sign change prescribe \(u(N_\nu)=0\) and
propagate in the two stable directions. At a negative-to-positive sign
change there are two incoming stable values. If \(a<N<b\) are the
adjacent zero cuts, these values and their mismatch are
\[
 u^-_N=\sum_{n=a}^{N-1}F(n)\prod_{\ell=n+1}^{N-1}r(\ell),\qquad
 u^+_N=-\sum_{n=N}^{b-1}F(n)\prod_{\ell=N}^{n}r(\ell)^{-1},
\]
\[
 D_\nu=u_N^--u_N^+
 =\sum_{n=a}^{N-1}W^-_{n,N}F(n)
                +\sum_{n=N}^{b-1}W^+_{N,n}F(n).
 \tag{15}
\]
Both weight families are positive. The single step beginning before a
nonintegral crossing remains on its pre-crossing side, even if it ends
after the crossing. An integral crossing can contribute one neutral
step. Reversing the ordered pair reverses the stable directions, so an
unordered double requires exactly one mismatch equation, not two controls.
At the initial endpoint use zero at \(J\) on a forward-stable initial
interval, or propagate backward from the first zero cut. Noncrossing
pairs use the analogous forward sum or convergent backward sum from
infinity.

We supply the uniform weight argument, rather than assuming an adiabatic
theorem. On a phase sign interval \([s_a,s_b]\), simple zeros and
compactness give
\[
 |\log r(s,b)|\geq c\min(s-s_a,s_b-s,1),
\]
and an upper bound by \(C\) times the distance near either zero.
The phase lengths have positive lower and finite upper bounds. On a
bounded phase interval, elapsed time is \(O(t^\rho)=o(t)\), so all
speeds and amplitudes there are comparable to \(\eta_*,\varepsilon_*\),
with ratios tending to one uniformly on \(K\).

For a stable segment of \(m\) steps, the two phase endpoint strips of
width \(d\) contain at most \(C(d/\eta_*+1)\) mesh points. Taking
\(d=c'\eta_*m\), with \(c'\) small, leaves a fixed positive fraction
outside both strips, apart from a bounded rounding error. Hence
\[
 \sum|\log r|\geq c\eta_*m^2-C,\quad
 W(m)\leq C e^{-c\eta_*m^2},\quad
 \sum_m W(m)\leq C\eta_*^{-1/2}.
 \tag{16}
\]
These statements also apply to truncated initial sign intervals by
viewing them inside the full periodic reference interval. They prove
the trial bound \(C\varepsilon_*\eta_*^{-1/2}
=C\eta_*^{q-1/2}\).
For noncrossing pairs there is a uniform geometric ratio \(\theta<1\).
The backward bound follows from decreasing \(\varepsilon_j\).
The forward bound uses
\(\varepsilon_\ell/\varepsilon_j=(j/\ell)^{\rho q}
\leq(1+j-\ell)^{\rho q}\), so convolution against \(\theta^{j-1-\ell}\)
is \(O(\varepsilon_j)\). This is smaller than the crossing bound.

Near an incoming cut, the window
\(|j-t_\nu|\leq c\eta(t_\nu)^{-1/2}\) contains
\(c'\eta(t_\nu)^{-1/2}\) indices inside the plateau. Their incoming
weights are bounded below by \(e^{-C c^2}\), by the upper linear gap
bound. At \(z_\nu=\pm1\), their forces all have the selected sign, giving
a signed contribution at least \(c''\eta(t_\nu)^{q-1/2}\).
All other plateau terms have the same sign. Outside the plateau, every
incoming weight includes a fixed phase-length stable segment and is
\(O(e^{-c/\eta(t_\nu)})\). There are \(O(\eta(t_\nu)^{-1})\) such
indices on the two adjacent intervals. Their unsigned contribution is
at most
\[
 C\eta(t_\nu)^{q-1}e^{-c/\eta(t_\nu)}
       =o(\eta(t_\nu)^{q-1/2}).
\]
Initial separation puts the central window after \(J\) even at the
first crossing. Orient each control according to its selected coefficient.
We obtain, with all other variables free,
\[
 D_\nu|_{z_\nu=1}\geq c\eta_\nu^{q-1/2}>0,\qquad
 D_\nu|_{z_\nu=-1}\leq-c\eta_\nu^{q-1/2}<0 .
 \tag{17}
\]

Take the full product of all column boxes and all control intervals.
Map each column coordinate to its stable trial value; at a two-valued
cut use the forward value. Map each control to
\(\max(-1,\min(1,z_\nu-D_\nu))\).
The estimates place every trial column strictly inside its box because
\(\beta<q-1/2\). Each output coordinate is continuous: finite
propagations are finite expressions in continuous forces and matrices;
the only infinite propagations are uniformly geometrically summable
noncrossing tails.

For each finite set of output coordinates freeze all other inputs at
their box centers. Finite-dimensional Brouwer (`A_CM_BROUWER`) gives a
solution of those coordinate fixed-point equations. The full product is
compact, and each coordinate equation is closed, so the finite
intersection property gives one simultaneous fixed point.
`CrossingMatching.product_fixedPoint_of_finite` kernel-checks precisely
this infinite implication, for arbitrary compact Hausdorff factors.
At a fixed point (17) excludes both control endpoints, and the clamped
equation forces every \(D_\nu=0\), as also proved by
`CrossingMatching.clamp_fixed_forces_zero`.
Thus the forward and backward values agree at every incoming cut.
They agree at zero cuts by construction, and all recurrences hold,
including steps straddling a crossing. Equation (14) now gives (8);
`CrossingMatching.normalized_line_iff` verifies this equivalence for
arbitrary finite matrices. The columns form a basis, since their matrix
is \(I+O(p\eta^\beta)\). This proves exact matching for one common metric.

### Proof 4: compatible entire functions and every-radius growth

Put \(w_i(j)=\iota_jv_i(j)+V_jv_i(j)\).
Substituting \(c=v_i(j+1)\) in the graph identity and using (8) gives
\[
 T_jw_i(j+1)=\sigma_i(j)^{-1}w_i(j).
\]
With \(c_i(J)=1\), \(c_i(j+1)=\sigma_i(j)c_i(j)\), the traces
\(g_i(j)=c_i(j)w_i(j)\) satisfy \(T_jg_i(j+1)=g_i(j)\).
Restriction from the next ball makes every trace smooth. Dirichlet
uniqueness makes the harmonic extensions agree on nested balls, and their
union is an entire smooth harmonic function \(U_i\). Independence follows
by low projection at \(e^J\).

Orthogonality of graph and low components bounds \(\|w_i(j)\|_2\)
above and away from zero. Since \(\alpha_i\) is in a fixed positive
compact interval, (8) implies
\[
 \log\|g_i(n)\|_2=\sum_{j=J}^{n-1}d_i(j)
                  +O(1+\sum_{j=J}^{n-1}\eta(j)^q).
\]
Let \(Q_i\) be the bounded periodic primitive of \(\Theta_i-m_i\).
As \(s_J'=\eta\), integration by parts gives
\[
 \int_J^T(\Theta_i(s_J(t))-m_i)\,dt
 =[t^\rho Q_i(s_J(t))]_J^T
                  -\rho\int_J^T t^{\rho-1}Q_i(s_J(t))\,dt
 =O(T^\rho).
\]
The mesh/integral discrepancy is \(O(\sum_{j\leq T}\eta(j))
=O(T^{1-\rho})\). The radial frequency discrepancy in (5) sums to
\(O(T^{2-2\rho})\); the matrix error sums to
\(O(T^{1-\rho q})\). These establish (9) first at integer times.
All constants are uniform on compact \(K\).

For \(t\in[j,j+1]\), all-radius contraction in the two directions of
restriction gives
\[
 \|g_i(j)\|_2\leq\|U_i(e^t,\cdot)\|_2\leq\|g_i(j+1)\|_2 .
\]
This proves (9) for every real time, since the four error powers are
positive and strictly less than one. If H6 holds, choose
\(\max_i m_i<\gamma<k\); the sublinear errors give a spherical bound
\(C_i e^{\gamma t}\).
The uniform interior \(H^2\)-to-sup estimate from (10), on a cylinder
of width four, gives
\[
 \sup_\omega|U_i(e^t,\omega)|
 \leq C\left(\int_{t-2}^{t+2}
           \|U_i(e^\tau,\cdot)\|_2^2\,d\tau\right)^{1/2}
 \leq C_i' e^{\gamma t}.
\]
The compact core is absorbed into the constant, and \(d_g(0,x)=r=e^t\)
gives \(|U_i(x)|\leq C_i''(1+d_g(0,x))^k\). This proves the theorem.

## Extension: finitely degenerate odd-order crossings

The following is the stronger structural result `C_CM_ODD`. Fix an odd
integer \(D\geq1\). Replace the simple-zero part of H2 by:

**H2-odd.** At event \(\nu\), the two continued eigenvalues satisfy
\[
 \lambda_h(s)-\lambda_i(s)
   =(s-s_\nu)^{d_\nu}a_\nu(s),\qquad
 a_\nu(s_\nu)\ne0,\qquad
 d_\nu\in\{1,3,\ldots,D\}.
 \tag{18}
\]
The factors are smooth, and the isolated positive doubles, smooth continued
frame, protected outer gap, separation, and finitely repeated types are as
before. No nonzero *first* phase derivative is required.

Then the entire theorem, including actual whole-ball transfer, one common
infinite control sequence, and pointwise growth, holds on compact subsets of
\[
 {\cal D}_D=\{(\rho,q,\beta):
       \tfrac12<\rho<1,\quad \tfrac{D}{D+1}<q<1,\quad
       0<\beta<q-\tfrac{D}{D+1}\}.
 \tag{19}
\]
Replace (7) by \(C\eta(j)^{q-D/(D+1)}\); the error (9) is unchanged.
At event \(\nu\), the endpoint mismatch has signed magnitude at least
\(c\eta_\nu^{q-d_\nu/(d_\nu+1)}\).
In particular cubic stalls are covered, for example by
\((\rho,q,\beta)=(3/4,7/8,1/32)\).

**Proof.** Proofs 1 and 2 do not use a nonzero phase derivative of the
crossing gap: they use only smoothness, the outer cluster gap, and the
nonzero independent control derivative (2). The scalar normalizations
and cut recurrences in Proof 3 also do not require a simple zero.
An odd-order zero changes the sign, so it has exactly the same incoming
and zero-cut alternatives.

For the only estimate that changes, write \(\kappa_D=D/(D+1)\).
The positive divided difference of \(d(b^{-2}\cdot)\) is uniformly bounded
above and below on the finite spectral range. Thus (18) gives an order
\(d_\nu\) zero for the logarithmic ratio, uniformly in the common
radial factor. On an interval between crossings of orders at most \(D\),
\[
 |\log r(s,b)|\geq
 c\min\{(s-s_a)^D,(s_b-s)^D,1\}.
\]
The same endpoint-strip counting as in (16), now raising the retained
phase distances to power \(D\), gives for a segment of \(m\) steps
\[
 \sum|\log r|\geq c\eta_*^D m^{D+1}-C,\qquad
 W(m)\leq C e^{-c\eta_*^D m^{D+1}},\qquad
 \sum_m W(m)\leq C\eta_*^{-\kappa_D}.
 \tag{20}
\]
The last bound follows by the substitution
\(u=\eta_*^{\kappa_D}m\) in the integral comparison; the integral of
\(e^{-c u^{D+1}}\) is finite. Bounded phase lengths absorb the case
where an endpoint distance exceeds one. Initial truncated intervals
and a possible neutral integer step are handled exactly as before.
This proves the asserted trial scale and puts it strictly inside the
boxes in (19).

At an event of actual order \(d=d_\nu\), use instead the local window
\[
 |j-t_\nu|\leq\theta\eta_\nu^{-d/(d+1)}.
\]
Its phase width is \(O(\eta_\nu^{1/(d+1)})\), hence lies inside the
plateau. The upper local gap bound gives a cumulative logarithmic loss
at most
\(C\eta_\nu^d\sum_{m\leq\theta\eta_\nu^{-d/(d+1)}}(m+1)^d
\leq C'\theta^{d+1}+o(1)\).
Its weights therefore have a positive uniform lower bound, and its
signed force contribution is at least \(c\eta_\nu^{q-d/(d+1)}\).
Outside the plateau (20), applied over a fixed phase distance, still
gives \(e^{-c/\eta_\nu}\), because
\(\eta_\nu^D(\eta_\nu^{-1})^{D+1}=\eta_\nu^{-1}\).
The outside contribution \(C\eta_\nu^{q-1}e^{-c/\eta_\nu}\) is
negligible compared with the central contribution. All endpoint signs
survive uniformly. The same product fixed point and Proof 4 now apply
without any other alteration. This proves the extension.

**Realizability of the additional angular hypotheses.** These hypotheses
need not be postulated for an unrelated spectral family. Given the
simple-crossing angular program H1--H3, take disjoint arbitrarily short
phase intervals around its finitely many crossing types in a label
period. Inside each interval choose a smooth strictly increasing phase
homeomorphism \(\phi\), equal to the identity near the interval endpoints,
fixing its crossing \(s_\nu\), and satisfying
\(\phi(s)-s_\nu=c_\nu'(s-s_\nu)^{d_\nu}\) near that crossing, with
\(c_\nu'>0\) and prescribed odd \(d_\nu\).
To construct it, choose a smooth derivative that equals a positive
multiple of \((s-s_\nu)^{d_\nu-1}\) near the center, equals one near
the endpoints, and is positive elsewhere. Adjust its integrals on each
half-interval to the half-interval lengths using nonnegative bumps away
from the center, then integrate. This can be done by first choosing the
central profile with a deficit on each half; the added bumps exactly
fill the deficits. Extend by the identity outside the intervals and
by \(\phi(s+P)=\phi(s)+P\).

The paths \(w\circ\phi\), frames \(e_i\circ\phi\), and eigenvalues
\(\lambda_i\circ\phi\) are smooth and satisfy H2-odd, with no new
crossings and the same outer gap. The image of the angular path has
not changed. The nonzero control directions at the crossings remain
the original ones. If the original means have strict margin
\(\Delta=\min_i(k-m_i)>0\) and
\(M=\max_i\|\Theta_i\|_\infty>0\), the change of any mean is at most
\(2M/P\) times the total length of the modified intervals. Taking that
length below \(P\Delta/(2M)\) preserves all strict mean bounds.
If \(M=0\) there is no positive crossing to modify. The initial constant
phase interval is untouched. Thus the finite-order extension applies
to smooth stalls of the same angular program, subject to the same
separate radial-realization hypotheses; it is not merely an identity
for an unrelated two-by-two matrix.

## What is exact, proved, or still assumed

`verify.py` independently replays the typed Jacobian rational-function
solution and verifies polynomial identities for inverse order and the
projective force, including off-diagonal entries that need not be symmetric.
It checks exact rational crossing-cut recurrences, including neutral
integer steps, backward minus signs, and independent reversed ordering.
It also verifies the open exponent inequalities by exact rational interval
arithmetic on advertised simple- and cubic-crossing parameter boxes.
The crossing-cut tests are finite experiments; the interval checks are
exact bounds on those boxes. Neither substitutes for the analytic proof
or proves any assertion outside its stated scope.

The infinite proofs are the argument above and the three declarations in
`Main.lean`. Only the latter declarations are kernel-checked.
The compiler certificate is source- and fidelity-bound by the official
Argus verifier. `verify.py` checks that binding; it does not pretend to
recompile Lean or mechanically verify the PDE argument.

The manuscript's `n:lem-inward-transfer`, `n:prop-exact-graphs`,
`n:prop-outward-crossing`, `n:eq-matching-mismatch`,
`n:lem-matching-weights`, and `n:eq-exact-lines` correspond respectively
to Proofs 1, 2, 2, (15), (16)--(17), and (8).
`growth.tex` corresponds to Proof 4. No graph node is independently
confirmed by this Engineer report. H1--H4 must still be established by
the separate angular and geometric branches before this theorem can be
used to certify the manuscript's main theorem.

### Literature and novelty boundary

The campaign ledger initially contained no mathematical result. The
strongest prior result being extended here is the staged manuscript's
single exponent choice, recovered by \((\rho,q,\beta)=(3/4,3/4,1/8)\).
The improvement is the full open exponent region, compact-parameter
uniformity, the explicit every-radius error in (9), and the odd finite-order
crossing extension (18)--(20), including a smooth phase-stall construction
that preserves strict frequency margins.

The primary analytic source read was John K. Hunter's *Notes on Partial
Differential Equations*, Chapters 3--4, author-hosted files dated 2014-06-18:
Theorem 3.49(3), specifically \(H^2(\Omega)\) compactly embedded in
\(C^{0,\alpha}(\overline\Omega)\) for \(0<\alpha<1/2\) on a bounded smooth
three-dimensional domain;
Theorem 4.20 (coercive bounded bilinear forms on Hilbert space),
Theorems 4.27--4.28 (uniformly elliptic divergence-form interior
regularity, \(a^{ij}\in C^{m+1}\), weak \(H^1\) solution, \(H^m\) forcing,
on relatively compact subdomains), and Theorem 4.31 (the corresponding
zero-boundary result on a \(C^{m+2}\) bounded domain).
The normalized coefficients in (10), and the smooth finite-ball metrics
after multiplying by their volume densities, meet those hypotheses.
For the sup estimate in dimension three it suffices to take the interior
\(H^2\) estimate and Sobolev embedding; no unverified appeal to a
measurable-coefficient Schauder estimate is being made.

The primary topological source read was Lars Hesselholt's *The Brouwer
Fixed Point Theorem*, Theorem 1 and the closed-rectangle corollary on
page 1 of his author-hosted Fall 2008 notes. The primary PDFs and their
unmodified text extractions are in `literature/`. They have no DOI or
versioned arXiv identifier; the ledger records explicit prose sources,
not invented canonical identifiers. Independent reading of these
assumptions remains for the Host-invoked Reviewer.

Attempts to obtain the cited Gilbarg--Trudinger publisher page returned
HTTP 406 and a MIT-hosted copy returned HTTP 403. The proof therefore uses
the obtained Hunter statements instead of pretending those pages were
read. A targeted search for an existing exact countably simultaneous
crossing-matching theorem returned no verified primary-source match.
That search is not a proof of novelty. Novelty and publishable
significance remain unconfirmed until independent review; this report
does not authorize stopping the larger exploratory campaign.

## Replaying the evidence

From the campaign directory, run:

```bash
python3 research/crossing_matching/verify.py
```

This requires only Python's standard library. It checks the stored exact
certificate, typed Jacobian result, and fresh official Lean archive.
The independent formal replay command is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/crossing_matching/Main.lean --statement-fidelity research/crossing_matching/statement_fidelity.md --claim C_CM_FORMAL_CORE --project-root .
```

These are different checks: the Python replay checks the real recorded
compiler result and its source/reading binding, while the latter command
actually invokes Lean. Neither replaces independent review of Proofs 1--4,
the odd-order extension, or the statement-fidelity document.
