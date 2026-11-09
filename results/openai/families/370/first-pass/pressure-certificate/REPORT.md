# Energy-relative pressure from weighted Riesz source layers

## Result and scope

Theorem 1 below proves the complete analytic implication used by the
staged manuscript's Proposition `prop:pressure`. It also allows every
Riesz order \(0<\sigma<n\), dimension \(n\ge2\), and positive spatial
weights with bounded logarithmic derivatives on the cutoff annulus.
It does not assume a uniform energy bound, subcriticality, a differential
equation, radial solutions, or finite total interaction.

The Newton specialization is an independent verification of the
pressure mechanism in Sections 4--5, conditional on precisely the
potential representations and uniform source/tail estimates stated in
Section 2. Those inputs, the separate virial/localization arguments,
and the full nonexistence theorem are not declared independently
certified by this report. No false assertion in the pressure chain has
been established, and no counterexample is claimed.

This is a proof with a rerunnable exact-algebra certificate and a
kernel-checked geometric core. It is not a formalization of all the
analysis. Independent mathematical review is still required.

The prior baseline is radial existence, not an earlier verified
pressure estimate. Bidaut-Veron--Giacomini, arXiv:1001.0562v2, standing
assumptions (1.5) and Theorem 1.4(i), and Phan, arXiv:1108.1312v1,
solution class (2) and Proposition B, supply existence under the reverse
weak hyperbola inequality. Their relevant statements were opened;
`baseline-excerpts.txt` records the hypotheses. Neither result is used
in the proof below. In particular, Phan's nonradial Theorem 1.2 also
requires the unweighted subcritical inequality; that transfer is not
a route to the unrestricted weighted assertion.
The manuscript itself gives the exact parameter obstruction
\(n=5,\ p=q=4,\ A=B=3\): the weighted sum is \(16/5>3\),
whereas the unweighted sum is \(2<3\). This is a known failed
transfer route, not a flaw attributed to the manuscript and not
a counterexample solution of the PDE.

A narrow literature search for the specific interval/cap/layer-loss
pressure estimate returned the target manuscript and distinct standard
Liouville methods. No primary source stating the generalization below
was obtained. That is not a verified novelty claim. Compared with the
target, the mathematical extension is the Riesz order, dimension two,
and annular log-Lipschitz coefficients; the pressure proof retains the
target's interval mechanism and makes its constants explicit.

## Theorem 1: annular weighted Riesz pressure

Fix \(n\ge2\), \(0<\sigma<n\), \(c>0\), \(p,q>0\), and \(M\ge1\).
Write \(\tau=n-\sigma>0\) and
\[
 K(z)=c|z|^{-\tau}.
\]
Let \(f,g\ge0\) be locally integrable and continuous off zero, and set
\(f(0)=g(0)=0\). Suppose
\[
 u=K*g,\qquad v=K*f
\]
are finite, positive, and continuous off zero, and \(fu,gv\) are
locally integrable. Assume the following bounds, all with the same
constant \(M\):
\[
 \int_{B_4}(f+g+u+v)\le M,                                      \tag{1}
\]
\[
 \int_{|x-y|\ge l} K(x-y)(f(y)+g(y))\,dy
       \le M l^{-\tau}
 \quad(x\in B_2,\ 0<l\le1).                                   \tag{2}
\]
On a neighborhood of the closed annulus \(1\le|x|\le2\), suppose
\[
 f(x)=b_*(x)u(x)^q,\qquad g(x)=a_*(x)v(x)^p,                    \tag{3}
\]
where \(a_*,b_*>0\) are \(C^1\), and
\[
 |\nabla\log b_*|\le L_b,\qquad |\nabla\log a_*|\le L_a.
\]
Only their values and derivatives on the annulus are used; \(C^1\)
can equally be replaced by a logarithmic Lipschitz bound along the
retained line segments.

Use exactly the manuscript cutoff:
\[
 \begin{split}
 d(x)&=\min(1,(2-|x|)_+),&m&=n+3,\\
 k&=n(m+1),&N&=k+n+2,\\
 \eta(x)&=[(1-(|x|-1)_+^3)_+]^N,&
 w(x)&=-x\cdot\nabla\eta(x).
 \end{split}                                                   \tag{4}
\]
Set
\[
 \begin{split}
 d\pi(x,y)&=f(x)g(y)K(x-y)\,dx\,dy,\\
 E_f&=\int\eta fu,&E_g&=\int\eta gv,&E&=E_f+E_g,\\
 W_f&=\int wfu,&W_g&=\int wgv,\\
 D_e(x,y)&=\frac{((x-y)\cdot e)^2}{|x-y|^2},&
 D(x,y)&=D_{x/|x|}(x,y),&
 T&=\int w(x)D(x,y)\,d\pi .
 \end{split}
 \]
Values on null diagonals or at \(x=0\) are immaterial.
Then for every \(\varepsilon>0\),
\[
 \boxed{\quad
 \frac{W_f}{q+1}+\frac{W_g}{p+1}
       \le \tau T+\varepsilon E+C_\varepsilon .
 \quad}                                                        \tag{5}
\]
The constant is uniform over all data satisfying (1)--(3). It
depends only on \(n,\sigma,p,q,M,L_a,L_b\) and a once-fixed smooth cap
profile. The kernel normalization \(c\) is already incorporated in
(1)--(2). In particular no bounded value of \(E\) is an input.

Here is an explicit choice of constants and parameters.

Choose any fixed smooth \(0\le\psi\le1\), supported in \([0,1]\)
and equal to one near zero. Let \(S=|\mathbb S^{n-1}|\),
\(R=|\mathbb S^{n-2}|/S\), and
\[
 I_0=\int_0^1\psi(t)t^{n-2}\,dt>0,\quad
 I_2=\int_0^1\psi(t)t^n\,dt,\quad J=\|\psi'\|_\infty.
\]
Define
\[
 \begin{split}
 a_n&=\min(1,(3/4)^{(n-3)/2}),\\
 b_n&=\max(1,(3/4)^{(n-3)/2}),\\
 b'_n&=\max(1,(3/4)^{(n-5)/2}),\\
 z_0&=R a_n I_0,\qquad
 z_2=R((n-1)b_n I_0+|n-3|b'_n I_2/4),\\
 W_0&=6N3^{N-1},\\
 W_1&=3N(5\,3^{N-1}+6(N-1)3^{N-2}),\\
 A&=\max\left(\frac{W_0}{z_0},
       \frac{W_1+2W_0J}{z_0}+\frac{W_0z_2}{z_0^2}\right),\\
 B_0&=(5/4)^{N-n-1},\qquad G_n=n2^{n+1}/S,\\
 L&=\max(L_b/q,L_a/p),\qquad C_{\rm end}=2Le^{L/2},\\
 C_0&=12N\tau,\qquad
 C_1=3AB_0+6NC_{\rm end},\qquad C_2=2AG_nM.
 \end{split}                                                   \tag{6}
\]
For any \(0<\kappa<1\), \(0<\delta<1/4\), \(P\ge1\), the stronger
quantitative estimate is
\[
 \begin{split}
 \frac{W_f}{q+1}+\frac{W_g}{p+1}
 \le{}&\tau T+
  (C_0\kappa+C_1\kappa^{-n}\delta+
             C_2\kappa^{-n}\delta^{-n}/P)E\\
 &+AM^2\kappa^{-n}\delta^{-\tau}+2W_0MP.                       \tag{7}
 \end{split}
\]
For example take
\[
 \begin{split}
 \kappa&=\min(1/2,\varepsilon/(3(C_0+1))),\\
 \delta&=\min(1/8,\varepsilon\kappa^n/(3(C_1+1))),\\
 P&=\max(1,3C_2\kappa^{-n}\delta^{-n}/\varepsilon),\\
 C_\varepsilon&=AM^2\kappa^{-n}\delta^{-\tau}+2W_0MP.
 \end{split}                                                   \tag{8}
\]
Each of the three relative terms is at most \(\varepsilon/3\).
The coefficients depending on an earlier parameter never depend on
a later one.

## Proof

### 1. The finite interval comparison and its sign

Fix a unit vector \(e\) and two distinct parallel lines. Write
\(x=z+se,\ y=z'+s'e,\ \lambda=|z-z'|>0,\ h=s-s'\). The restricted
kernel is
\[
 {\cal K}(s,s')=c(\lambda^2+h^2)^{-\tau/2},\qquad
 {\cal D}(s,s')=h^2/(\lambda^2+h^2).
 \]
For a bounded interval \(I=(s_-,s_+)\), let
\(\overline{\cal K}_I(s')=({\cal K}(s_-,s')+
{\cal K}(s_+,s'))/2\), and define the second endpoint average
similarly. For bounded \(I,J\), let their midpoints be \(m_I,m_J\)
and \(d_0=m_I-m_J\).

Integration by parts in each variable gives
\[
 2A-B_I-B_J
 =\tau\int_{I\times J}
       \frac{h^2-d_0h}{\lambda^2+h^2}{\cal K}\,ds\,ds',          \tag{9}
\]
where \(A=\int_{I\times J}{\cal K}\), and \(B_I,B_J\) are the
integrated endpoint averages. For example
\([(s-m_I){\cal K}]_{s_-}^{s_+}
=|I|\overline{\cal K}_I\); this fixes both the sign and factor.

For lengths \(l_I,l_J>0\), the pushforward density of \(h\) is
\[
 \rho(h)=F(|h-d_0|),\qquad
 F(r)=\max(0,\min(l_I,l_J,(l_I+l_J)/2-r)).
 \]
Indeed, this density is \(|I\cap(J+h)|\). The intersection equals
the smaller interval when the center separation is at most
\(|l_I-l_J|/2\), decreases with slope \(-1\) until separation
\((l_I+l_J)/2\), and is zero thereafter. These three cases give
the displayed formula. In particular \(F\) is nonincreasing.

For every real \(d_0\) and \(h\ge0\),
\[
 d_0(F(|h-d_0|)-F(|h+d_0|))\ge0.                               \tag{10}
\]
For \(d_0\ge0\), use \(|h-d_0|\le h+d_0\); for \(d_0\le0\),
use \(|h+d_0|\le h-d_0\) and reverse both signs. The odd kernel
\(h{\cal K}(h)/(\lambda^2+h^2)\) is positive for \(h>0\).
Pairing its positive and negative arguments, with compactly
supported \(\rho\), proves
\[
 d_0\int_{I\times J}\frac{h}{\lambda^2+h^2}{\cal K}\ge0 .
 \]
No monotonicity of that odd kernel is asserted or needed.
Consequently \(2A-B_I-B_J\le\tau\int{\cal D}{\cal K}\).

For \(c_I,c_J\ge0\), put \(c_*=\min(c_I,c_J)\).
The exact algebraic remainder for, say, \(c_I\le c_J\) is
\[
 \begin{split}
 &c_IB_I+c_JB_J+c_I T_0+(c_J-c_I)A-(c_I+c_J)A\\
 &=c_I(T_0-2A+B_I+B_J)+(c_J-c_I)B_J\ge0,
 \end{split}
 \]
where \(T_0=\tau\int{\cal D}{\cal K}\). The other ordering is
symmetric. Thus
\[
 \int_{I\times J}(c_I+c_J){\cal K}
 \le\int_{I\times J}
 \{c_I\overline{\cal K}_I+c_J\overline{\cal K}_J+
       (\tau c_*{\cal D}+|c_I-c_J|){\cal K}\}.                 \tag{11}
\]
If a coefficient is positive its interval must be bounded. If at
most one coefficient is positive, the absolute-difference term
equals the left integrand pointwise, so (11) also holds for
unbounded zero-weight intervals. Endpoint terms with coefficient
zero are defined as zero without evaluating an endpoint.
This last case involves no subtraction of infinite integrals.

The sign (10), its nonnegative integral consequence, and the
finite weighted remainder implication are formalized in
`Main.lean`. The overlap identification, (9), and the extended
zero-weight case are analytic arguments here.

### 2. Cutoff and cap bounds

On \(1<r<2\), put \(s=r-1\); then \(d=1-s\) and
\(1-s^3=d(1+s+s^2)\). Direct differentiation gives
\[
 d^N\le\eta\le3^Nd^N,\quad
 w=3Nr s^2(1-s^3)^{N-1}\le W_0d^{N-1},\quad
 |\nabla w|\le W_1d^{N-2},\quad dw\le6N\eta.                  \tag{12}
\]
The derivative bound follows by differentiating \(rs^2\), whose
derivative is at most \(5\), and \(1-s^3\), whose derivative has
magnitude at most \(3\).

Let expectation in \(e\) be normalized sphere measure. Chordal
coordinates give, independently of \(\theta\),
\[
 Z(l)=\mathbb E_e\psi(|e-\theta|/l)
   =R l^{n-1}\int_0^1\psi(t)t^{n-2}
                   (1-l^2t^2/4)^{(n-3)/2}\,dt .
 \]
For \(0<l\le1\), formula (6) yields
\(Z(l)\ge z_0l^{n-1}\) and \(|Z'(l)|\le z_2l^{n-2}\).
The same calculation applies to \(n=2\): its negative exponent
is bounded since \(1-l^2t^2/4\ge3/4\).

Define, on the annulus,
\[
 h_e(x)=w(x)\psi(|e-\omega_x|/(\kappa d(x)))/Z(\kappa d(x)),
 \qquad \omega_x=x/|x|,
 \]
and extend by zero. Its exact mean is \(w(x)\).
On the differentiated profile's support,
\[
 |\nabla(|e-\omega_x|/(\kappa d))|\le2/(\kappa d).
 \]
Near \(e=\omega_x\) the profile is constant, so the norm has no
differentiability singularity. Formula (6), differentiation of
\(Z^{-1}\), and (12) imply
\[
 0\le h_e\le A\kappa^{-n}d^{N-n},\qquad
 |\nabla h_e|\le A\kappa^{-n}d^{N-n-1}.                       \tag{13}
\]
The extension is \(C^1\): \(w\) vanishes quadratically at \(r=1\)
and \(N-n>1\) at \(r=2\). Inside \(B_1\), \(h_e=0\).

Put \(l(z)=\delta d(z)^m\) when \(d(z)>0\).
Call a pair close if \(|x-y|\le l(z)\) for either endpoint \(z\).
The 1-Lipschitz function \(d\) lies between
\((1-\delta)d(z)\) and \((1+\delta)d(z)\) on that segment.
Integrating (13) therefore gives
\[
 |h_e(x)-h_e(y)|
 \le AB_0\kappa^{-n}\delta d(z)^{N-n-1+m}
 =AB_0\kappa^{-n}\delta d(z)^{N+2}.
 \]
Since \(d(z)^N\le\eta(z)\le\eta(x)+\eta(y)\), the close-pair
integral is at most \(AB_0\kappa^{-n}\delta E\).

On far pairs each contributing endpoint has separation greater
than its own \(l(z)\). By (2), (13), and (1), their integral is
at most
\[
 A\kappa^{-n}M\delta^{-\tau}
     \int_{B_2}(f+g)d^{N-n-m\tau}
 \le A\kappa^{-n}M^2\delta^{-\tau},                           \tag{14}
\]
because
\[
 N-n-m\tau=n+2+m\sigma>0 .
 \]
The marginal identities used here and below follow directly
from the assumed potentials and Tonelli:
\(\pi(dx,\mathbb R^n)=f(x)u(x)dx\) and
\(\pi(\mathbb R^n,dy)=g(y)v(y)dy\).
Thus, uniformly in \(e\),
\[
 \int|h_e(x)-h_e(y)|\,d\pi
 \le AB_0\kappa^{-n}\delta E+
                 A\kappa^{-n}M^2\delta^{-\tau}.              \tag{15}
\]

On the support of \(h_e(x)\),
\(|D_e-D|\le2|e-\omega_x|\le2\kappa d(x)\).
Averaging and using (12) yields
\[
 \mathbb E_e\int h_e(x)D_e\,d\pi\le T+12N\kappa E.             \tag{16}
\]
Its constant is independent of \(\delta,P\) and of \(\kappa\).

### 3. Measurable retained intervals and averaged layer loss

For \(0<t<f(x)\), let \(I\) be the component containing \(x\)
of \(\{f>t\}\) on \(x+\mathbb R e\). Set
\[
 \chi_f(e,x,t)=
 \begin{cases}
 \inf_I h_e,&I\text{ bounded and }|I|\le2\delta\inf_I d,\\
 0,&\text{otherwise}.
 \end{cases}                                                  \tag{17}
\]
Define \(\chi_g\) identically. These weights are constant on each
component and lie between zero and \(h_e\).

For completeness these objects are jointly measurable, not just
separately defined for almost every direction. With the convention
at zero, \(\{(x,t):0<t<f(x)\}\) is open. The forward exit distance
exceeds \(r\ge0\) precisely when the compact segment of length \(r\)
is contained in this open set; this is open in \((e,x,t)\).
The backward distance is treated the same way. Their sum is the
measurable extended component length. Infima in (17) are infima
over rational offsets strictly between the exits of continuous
functions \(h_e(x+se)\) and \(d(x+se)\). Finite endpoint positions
are measurable functions of the exit distances. All required
zero-weight products are defined to be zero. These observations
also make their later endpoint-potential products measurable.

Let
\[
 {\cal L}_f(e)=\int u(x)\int_0^{f(x)}(h_e(x)-\chi_f(e,x,t))\,dt\,dx
 \]
and similarly for \(g,v\). They are finite for each fixed data set:
\(h_e\) is bounded and supported in the compact annulus, and
\(fu,gv\) are locally integrable. This is not a uniform estimate.

Fix an annular \(x\), write \(d=d(x)\), \(l=\delta d^m\).
If \(|I|\le l\), then
\(\inf_I d\ge(1-\delta)d\) and
\(|I|\le\delta d\le2\delta\inf_I d\). Thus it is retained and
its weight loss is at most
\[
 AB_0\kappa^{-n}\delta d^{N+2}
 \le AB_0\kappa^{-n}\delta\eta(x).                            \tag{18}
\]

If \(|I|>l\), a forward or backward segment of length \(l/2\)
lies in its layer. Let \(F_t\) be the directions with the forward
property. Polar coordinates centered at \(x\) give
\[
 \int_{B_{l/2}(x)}f
 \ge tS(l/2)^n\mathbb P_e(F_t)/n.
 \]
The long event lies in \(F_t\cup(-F_t)\); antipodal invariance
and \(B_l(x)\subset B_4\) imply
\[
 \mathbb P_e\{|I|>l\}\le G_nM/(t l^n).                       \tag{19}
\]
The right side need not be less than one; only its upper-bound
property is used.

For levels \(t\ge P d^{-k}\), use the supremum of \(h_e(x)\)
times (19), not an unjustified independence assertion. The
expected long loss is at most
\[
 AG_nM\kappa^{-n}\delta^{-n}P^{-1}
     d^{N-n+k-mn}
 =AG_nM\kappa^{-n}\delta^{-n}P^{-1}d^N.                       \tag{20}
\]
Integrate (18),(20) over these levels, then against \(u(x)dx\).
The available range of levels has length at most \(f(x)\).
This bounds the high part by
\[
 (AB_0\kappa^{-n}\delta+
  AG_nM\kappa^{-n}\delta^{-n}/P)E_f .
 \]
For low levels use exact cap normalization instead of (13):
\[
 \int_0^{\min(f(x),Pd^{-k})}
      \mathbb E_e(h_e-\chi_f)\,dt
 \le Pd^{-k}w(x)
 \le W_0P d^{N-1-k}\le W_0P,                                \tag{21}
\]
since \(N-1-k=n+1>0\). Integration against \(u\) is bounded by
(1). Adding the \(g\) calculation proves
\[
 \mathbb E_e({\cal L}_f+{\cal L}_g)
 \le(AB_0\kappa^{-n}\delta+
      AG_nM\kappa^{-n}\delta^{-n}/P)E+W_0MP.                 \tag{22}
\]
The last coefficient has no dependence on \(\kappa,\delta,P\);
the relative coefficients have no dependence on \(P\).

### 4. Endpoints: their actual potentials, not idealized constants

If a component has positive weight, \(h_e\ge\chi_I>0\)
throughout it and, by continuity, at its endpoints. Both endpoints
therefore lie strictly inside the annulus. Maximality and continuity
of \(f\) give \(f(x_\pm)=t\). Hence
\[
 u(x_\pm)=(t/b_*(x_\pm))^{1/q}.
 \]
For \(x\in I\), \(|x_\pm-x|\le2\delta d(x)\), with the whole
segment contained in the annulus. If
\(\theta_x=(t/b_*(x))^{1/q}\le u(x)\), the logarithmic derivative
bound gives
\[
 |\log(u(x_\pm)/\theta_x)|
 \le2(L_b/q)\delta d(x)\le L/2.
 \]
The inequality \(|e^r-1|\le |r|e^{|r|}\) consequently gives,
with \(\overline u_I=(u(x_-)+u(x_+))/2\),
\[
 |\overline u_I-\theta_x|
       \le C_{\rm end}\delta d(x)\theta_x
       \le C_{\rm end}\delta d(x)u(x).                       \tag{23}
\]
The \(g,v,p,a_*\) assertion follows by the same calculation with
those named quantities. Zero-weight endpoints are never evaluated.
Only fixed coefficient bounds and exponents enter \(C_{\rm end}\);
there is no dependence on the solution or on \(\kappa,P\).

### 5. Integrating the interval inequality without infinite subtraction

Fix \(e,t,t'>0\). On distinct parallel lines apply (11) to every
pair of source components with \(c_I=\chi_I,c_J=\chi_J\).
Replace \(\min(\chi_I,\chi_J)\) by \(h_e(x)\) in its nonnegative
directional term. Each open line layer has countably many
components. Sum and integrate in the transverse variables and
levels, using only nonnegative integrands. For fixed \(e\) the
coincident-line set has codimension \(n-1\ge1\), hence is null.
The preceding joint measurability makes all resulting quantities
measurable in \(e\), so subsequent sphere averaging is legitimate.

Tonelli and the potential identities turn the left terms into
\[
 U_f=\int\int_0^{f(x)}\chi_f(e,x,t)u(x)\,dt\,dx,\qquad U_g
 \]
and the endpoint terms into
\[
 V_f=\int\int_0^{f(x)}\chi_f(e,x,t)\overline u_I\,dt\,dx,
 \qquad V_g .
 \]
For example, the partner-layer integration of the endpoint kernel
is \(\int g(y)K(x_\pm-y)dy=u(x_\pm)\). Omitting the line through
the endpoint deletes a Lebesgue-null subset of \(\mathbb R^n\);
even its possible singular kernel values do not change this
nonnegative integral.

Before any subtraction, put
\(H_f=\int h_e fu,\ H_g=\int h_e gv\).
Both are finite. We have \(U_f\le H_f,\ U_g\le H_g\);
(23) gives \(V_f\le(1+C_{\rm end}/4)H_f\), and similarly for \(g\).
The directional term is at most \(\tau H_f\). The integrated
mismatch is finite because
\(|\chi_f-\chi_g|\le h_e(x)+h_e(y)\) and the two marginals give
the bound \(H_f+H_g\). Thus every integrated term is finite,
including when \(\tau\le1\); no infinite endpoint defect has
been subtracted on an unbounded interval.

It is now legitimate to put \(S_e=U_f+U_g-V_f-V_g\).
The sharper elementary inequality
\[
 |\chi_f-\chi_g|
 \le |h_e(x)-h_e(y)|+(h_e(x)-\chi_f)+(h_e(y)-\chi_g)
 \]
then yields
\[
 S_e\le\tau\int h_e(x)D_e\,d\pi+
       \int|h_e(x)-h_e(y)|\,d\pi+{\cal L}_f+{\cal L}_g .       \tag{24}
\]
\(S_e\) itself is not asserted nonnegative.

### 6. Recovery, two losses, and the noncircular parameter choice

By (3), the exact weighted layer integral is
\[
 \int_0^{f(x)}(u(x)-(t/b_*(x))^{1/q})\,dt
       =f(x)u(x)/(q+1).                                     \tag{25}
\]
Indeed, substituting \(t=f(x)r\) leaves
\(f(x)u(x)\int_0^1(1-r^{1/q})dr=f(x)u(x)/(q+1)\).
There is no assumption \(q\ge1\).

For every level, including the zero-weight convention, (23) gives
\[
 \begin{split}
 &h_e(u-\theta_x)-\chi_f(u-\overline u_I)\\
 &=(h_e-\chi_f)(u-\theta_x)+\chi_f(\overline u_I-\theta_x)\\
 &\le(h_e-\chi_f)u+C_{\rm end}\delta d(x)h_e(x)u(x).
 \end{split}
 \]
Integrating, using (25) and its \(g\) counterpart, proves
\[
 \frac{H_f}{q+1}+\frac{H_g}{p+1}
 \le S_e+{\cal L}_f+{\cal L}_g+
       C_{\rm end}\delta\int d\,h_e(fu+gv).                  \tag{26}
\]
Combining (24),(26) incurs exactly two, not one, copies of the
total loss. Average in \(e\). Exact normalization gives the left
side of (7). Estimate (16), multiplied by \(\tau\), contributes
\(12N\tau\kappa E\). Estimate (15) contributes its one mismatch
coefficient and additive term. Two copies of (22) contribute
twice their coefficients and \(2W_0MP\). Finally the last term
of (26) is at most \(6NC_{\rm end}\delta E\) by (12).
Since \(\kappa^{-n}\ge1\), these are exactly bounded by (6)--(7).
Formula (8) proves (5). This completes the proof.

## Corollary: the literal manuscript pressure proposition

For an admissible Newton pair in the staged manuscript take
\[
 \sigma=2,\quad c=((n-2)|\mathbb S^{n-1}|)^{-1},\quad
 b_*(x)=|x|^B,\quad a_*(x)=|x|^A .
 \]
On the annulus \(L_b=|B|\), \(L_a=|A|\) suffice. The manuscript's
`eq:potentials` supplies the exact potentials and
`eq:uniform` supplies a single \(M\) after enlarging its constant
to at least one. Its local integrability statement supplies the
only energy-finiteness premise. Thus (5) is precisely
`eq:pressure`, with \(a=1/(q+1), b=1/(p+1)\), and a constant
depending only on the equation parameters and \(\varepsilon\).
It is not a closure lemma that assumes pressure: Steps 1--6
derive pressure directly.

## What the executable certificate does and does not establish

`verify.py` checks the universal symbolic derivative, midpoint,
cutoff-exponent, and weighted-remainder identities in exact
arithmetic. It independently checks the retained typed Jacobian
enclosure for \(4hd\) on the unit square, the polynomial behind
\((h+d)^2-(h-d)^2\); that bounded call is not a continuum proof.
Its finite rational boundary cases are explicitly labeled finite
experiments. General signs are supplied by the Lean theorem,
and the continuum estimates are supplied by the complete proof
above. It also checks that the successful real Lean run has no
proof holes and still matches both source and statement-fidelity
document.
The elementary parameter obstruction to the already-disallowed
unweighted transfer is checked separately and is not counted as
the new mathematical result.

The target's interval mechanism is prior art, not claimed here
as an invention. No checked result is described as refuting the
main PDE theorem or settling its remaining independent audit
obligations. Publishability, novelty, statement fidelity, the
analytic proof, and source attribution await the Host-invoked
independent Reviewer. Graph nodes remain unconfirmed until that
review.
