# Verification of the sharp comparison-square Sobolev theorem

## Result and exact scope

The argument below verifies `thm:extrinsic-sobolev` in the staged
`build/sections/03-sobolev.tex`, using the actual comparison maps of
`02-maps.tex`. It does not certify Sections 4-9 or the finite-perimeter
isoperimetric and equality theorems.

**Theorem.** Let \(m\geq3\), \(b\in\{0,1\}\), and let \(M^n\) be complete,
simply connected and smooth with \(\operatorname{Sec}\leq-b^2\).
Let \(X:\Sigma^m\to M^n\) be a locally \(C^{1,1}\) immersion, with
\(n\geq m\). Put
\[
 q=\frac{2m}{m-2},\quad c=\frac4{m-2},\quad
 \alpha=\frac{m-2}{2},\quad Y_m=m|\mathbb S^m|^{2/m}.
\]
If \({\bf H}=-m^{-1}\operatorname{tr}II\), define
\[
 Q(v)=\int_\Sigma\{c|\nabla v|^2+
                    m(|{\bf H}|^2-b^2)v^2\}\,d\sigma.
\]
Then \(Q(v)\geq Y_m\|v\|_q^2\) for every Lipschitz \(v\) with compact
support in the intrinsic interior, and for the zero extension of every
\(v\in H^1_0(U)\), \(U\Subset\Sigma^\circ\) open. Here \(H^1_0\) is
exactly the closure of compactly supported Lipschitz tests. Neither
completeness, properness, connectedness, orientability, embeddedness,
nor regularity of \(\partial U\) is assumed.

For a hypersurface, \({\bf H}=hN\) when
\(mh=\operatorname{div}_\Sigma N\). Thus the theorem includes **exactly**
the manuscript's statement. The normal-vector formulation also proves
an arbitrary-codimension extension. This extension and the centering
potential in Section 3 are mathematical additions, not verified claims
of priority. Independent review and a novelty assessment remain necessary.

The imported results are Talenti's opening sharp-constant theorem
at \(p=2\), Brezis-Lieb Theorem 1, and the complete nonpositive-curvature
exponential-map/compact-ball theorems. Exact sources, hypotheses,
retrieval limitations and excerpts are in `research/literature/`.
No confined-profile or total-curvature assertion is an input.

## 1. Local weak calculus and zero extension

On each relatively compact \(C^{1,1}\) immersion chart the induced metric
is Lipschitz, uniformly positive definite, and comparable with the
Euclidean metric. Its area density is bounded above and below, and
\({\bf H}\) is essentially bounded. All constants here are local; no
bounded geometry at infinity is used.

For a compactly supported Lipschitz function in \(U\), extension by zero
is Lipschitz locally on \(\Sigma^\circ\), and its gradient is its
gradient on \(U\) and zero off \(U\). The extension preserves its
\(H^1\) norm. Taking the defining \(H^1\) limit gives
\[
 E_0v\in H^1(\Sigma^\circ),\qquad
 \nabla E_0v={\bf1}_U\nabla v,\qquad
 E_0v=0\text{ a.e. on }\Sigma^\circ\setminus U.                 \tag{1}
\]
These statements include \(\partial U\), even if it has positive area.
There is no assertion that a general \(H^1(U)\) function can be extended
this way. A bounded Lipschitz multiplier near \(\bar U\) preserves
\(H^1_0(U)\): multiply its approximants and use the product rule and
local metric comparability. The same approximation proves the weak
product and chain rules used below.

## 2. The actual radial comparison maps

Write \(r=d(p,x)\), \(\theta=\log_p(x)/r\), and
\(t=\operatorname{sn}_b(r/2)/\operatorname{cs}_b(r/2)\).
The global logarithm exists by Cartan-Hadamard. The source maps are
\[
 \Phi=\left(\frac{2at}{1+a^2t^2}\theta,
                  \frac{1-a^2t^2}{1+a^2t^2}\right),\qquad
 f=e^u=\frac{a(1-b^2t^2)}{1+a^2t^2}.                         \tag{2}
\]
Here \(t=r/2\) if \(b=0\), \(t=\tanh(r/2)\) if \(b=1\), and
\[
 t'=(1-b^2t^2)/2,\quad
 \operatorname{sn}_b r=\frac{2t}{1-b^2t^2},\quad
 \operatorname{cs}_b r=\frac{1+b^2t^2}{1-b^2t^2}.
\]
The denominators are positive for every finite \(r\). At the pole,
the coefficient of \(\log_p(x)\), the last coordinate and \(f\)
are smooth functions of \(r^2\). The pole values are
\[
 d\Phi_p(V)=(aV,0),\qquad
 u=\log a-\tfrac14(a^2+b^2)r^2+O(r^4).
\]
Smooth dependence of the inverse exponential map gives the joint
smoothness needed for centering.

For clarity, the one-sided geometric comparison is also justified.
The Jacobi field \(J\) with endpoint values \(0,V\), \(V\perp\dot\gamma\),
satisfies the index-form formula
\[
 \operatorname{Hess}r(V,V)
 =\int_0^r(|D_sJ|^2-\langle R(J,\dot\gamma)\dot\gamma,J\rangle)\,ds
 \geq\int_0^r(|D_sJ|^2+b^2|J|^2)\,ds.
\]
In a parallel frame, subtract
\(J_0(s)=\operatorname{sn}_b(s)V/\operatorname{sn}_b(r)\).
The cross term integrates to zero, since
\(J_0''=b^2J_0\) and \(J-J_0\) has zero endpoint values.
The remaining energy is nonnegative. Hence
\[
 {\cal A}:=\operatorname{Hess}r-
   \frac{\operatorname{cs}_b r}{\operatorname{sn}_b r}
          (g-dr\otimes dr)\ \geq0.                         \tag{3}
\]
Radial and mixed components vanish by \(|\nabla r|=1\).
For an angular Jacobi field,
\((|J|^2)'=2\operatorname{Hess}r(J,J)\).
Thus \(|J|^2/\operatorname{sn}_b(r)^2\) is nondecreasing from its
initial angular norm. Gauss's lemma yields
\[
 g\geq dr^2+\operatorname{sn}_b(r)^2g_{\mathbb S_p^{n-1}}.
\]
Pulling back the round stereographic metric in (2), and using
\[
 \frac{2(at)'}{1+a^2t^2}=f,\qquad
 \frac{2at}{1+a^2t^2}=f\operatorname{sn}_b r,
\]
proves \(|d\Phi(V)|\leq f|V|\).

Direct differentiation gives, for \(r>0\),
\[
 u'=-\frac{(a^2+b^2)t}{1+a^2t^2}<0,\quad
 u''=(u')^2+u'\frac{\operatorname{cs}_b r}{\operatorname{sn}_b r},
\quad
 u'\frac{\operatorname{cs}_b r}{\operatorname{sn}_b r}
       =-\tfrac12(b^2+f^2+(u')^2).
\]
Consequently
\[
 \operatorname{Hess}u
 =du\otimes du-\tfrac12(b^2+f^2+|\nabla_g u|^2)g+u'{\cal A}
 \leq du\otimes du-\tfrac12(b^2+f^2+|\nabla_g u|^2)g.          \tag{4}
\]
The sign \(u'\leq0\) is essential. The pole expansion supplies (4)
and the differential bound at \(p\). These calculations use an
**upper**, not lower, sectional-curvature bound.

## 3. Balancing, with an independent minimization construction

Let \(\mu\) be a compactly supported nonatomic Borel probability measure,
with \(K=\operatorname{supp}\mu\subset B_R(o)\), \(R>0\).
Completeness makes \(\overline B_R(o)\) compact.

Uniform atomlessness holds:
\[
 \sup_{p\in\overline B_R(o)}\mu(B_\delta(p))\longrightarrow0
                       \quad(\delta\downarrow0).             \tag{5}
\]
Indeed, otherwise choose \(\delta_j\to0\) and centers of balls carrying
mass at least \(\varepsilon>0\); a convergent subsequence of centers
forces every neighborhood of its limit to have that mass, hence an atom.

Choose \(a_0>0\) with \(a_0t_b(2R)<1\). Uniformly for
\(p\in\overline B_R(o)\), the last coordinate of the mean of
\(\Phi_{p,a_0}\) is positive. By (5), choose \(\delta>0\) with
the supremum there less than \(1/4\). Choose finite \(a_1>a_0\)
with \(a_1t_b(\delta)\geq\sqrt3\). At this scale the last
coordinate is at most \(-1/2\) outside \(B_\delta(p)\) and at most
one inside, so its mean is at most
\(1/4-(3/4)/2=-1/8\).

Here is a direct alternative to the manuscript's Brouwer argument.
On the compact cylinder \(\overline B_R(o)\times[a_0,a_1]\), minimize
\[
 {\cal E}(p,a)=
 \int_K\log\left(
 \frac{\operatorname{cs}_b(d(p,x)/2)^2+
              a^2\operatorname{sn}_b(d(p,x)/2)^2}{a}\right)d\mu(x).
                                                                  \tag{6}
\]
The integrand is smooth, including at \(p=x\), with bounded
derivatives on this compact cylinder times \(K\). Differentiation
under the integral is justified. If \(\Phi^{\rm tan}\) and
\(\Phi^{\rm last}\) denote the two components, calculation gives
\[
 \nabla_p{\cal E}
   =-\frac{a^2+b^2}{2a}\int_K\Phi^{\rm tan}_{p,a}\,d\mu,\qquad
 a\partial_a{\cal E}=-\int_K\Phi^{\rm last}_{p,a}\,d\mu.        \tag{7}
\]
On the lower scale face the inward derivative is negative, and the
same is true on the upper scale face by reversing direction.
On the side face, set \(\rho=d(o,\cdot)\).
Convexity of distance along the geodesic from \(p\) to \(x\) gives
\[
 \langle\nabla\rho(p),\theta_p(x)\rangle
       \leq(\rho(x)-R)/d(p,x)<0.
\]
This remains valid if that geodesic passes through \(o\):
convexity supplies the one-sided supporting-line inequality at \(p\).
The first component of (2) is a positive multiple of \(\theta_p(x)\).
Equation (7) therefore says the outward radial derivative of
\({\cal E}\) is positive. Moving inward lowers \({\cal E}\).
At corners one may still move inward in the offending coordinate.
Thus no boundary point minimizes (6).

An interior minimizer has both derivatives in (7) zero, and hence
\[
                   \int_M\Phi_{p,a}\,d\mu=0.                 \tag{8}
\]
In particular \(p\in B_R(o)\) and \(0<a<\infty\). No uniqueness
or convexity of \({\cal E}\) is claimed. This verifies the exact
centering lemma without requiring a new fixed-point assumption.

## 4. The comparison square, including the normal convention

Put \(\beta=(\nabla_g u)^\perp\). The restriction identity is
\[
 \Delta_\Sigma u
     =\operatorname{tr}_{T\Sigma}\operatorname{Hess}_g u
                         -m\langle{\bf H},\beta\rangle.      \tag{9}
\]
In a \(C^{1,1}\) chart this follows by differentiating \(u\circ X\)
and the metric divergence expression almost everywhere. All first
derivatives in that divergence are Lipschitz, so the same identity
holds weakly. For a hypersurface it is precisely
\(\Delta_\Sigma u=\operatorname{tr}\operatorname{Hess}u-mhNu\);
reversing \(N\) reverses both \(h\) and \(Nu\).

Taking the trace of (4), separating the tangent and normal gradients,
and using (9) gives
\[
 2\Delta_\Sigma u\leq
 -(m-2)|\nabla_\Sigma u|^2-m(b^2+f^2)-m|\beta|^2
                                      -2m\langle{\bf H},\beta\rangle.
\]
Equivalently,
\[
 m(|{\bf H}|^2-b^2)\geq
 mf^2+m|{\bf H}+\beta|^2+(m-2)|\nabla_\Sigma u|^2
                                                    +2\Delta_\Sigma u.
\]
Multiply by \(v^2\) and integrate by parts for a compact interior
Lipschitz test. The divergence term is
\(-4\int v\langle\nabla v,\nabla u\rangle\).
The exact identities \(c\alpha=2\) and \(c\alpha^2=m-2\) yield
\[
 Q(v)\geq\int_\Sigma
 \{mf^2v^2+m|{\bf H}+\beta|^2v^2
                 +c|\nabla v-\alpha v\nabla u|^2\}
 \geq\int_\Sigma
 \{v^2|d(\Phi\circ X)|^2
                 +c|\nabla v-\alpha v\nabla u|^2\}.          \tag{10}
\]
All coefficients are bounded near \(\bar U\); approximation extends
(10) to \(H^1_0(U)\). In particular \(Q\geq0\) there. Summing a
quadratic-form bound over \(m\) orthonormal tangent directions gives
the factor \(m\), independently of ambient dimension.

## 5. Subthreshold attainment on arbitrary relatively compact open sets

Let \(U\Subset\Sigma^\circ\) be nonempty and open. Its area is finite.
For every \(\varepsilon>0\), one has
\[
 (Y_m-\varepsilon)\|v\|_q^2
       \leq c\|\nabla v\|_2^2+C_{\varepsilon,U}\|v\|_2^2,
                  \qquad v\in H^1_0(U).                    \tag{11}
\]
The normalization can be checked without trusting a gamma-function
OCR transcription. Talenti's extremal at \(p=2\) is
\(w(x)=(1+|x|^2)^{-(m-2)/2}\).
The stereographic volume factor gives
\(I=\int_{\mathbb R^m}w^q=2^{-m}|\mathbb S^m|\).
Direct radial differentiation gives
\(-\Delta w=m(m-2)w^{q-1}\), and integration by parts gives
\(\int|Dw|^2=m(m-2)I\); its boundary term tends to zero as
\(R^{2-m}\). Consequently its sharp quotient is
\[
 c\int|Dw|^2/I^{2/q}
       =4mI^{2/m}=m|\mathbb S^m|^{2/m}=Y_m.
\]
The radial differential equation and these exponent cancellations
are replayed by `verify.py`.

Here are the details needed at the stated regularity. Normalize the
metric at a chart center and make its eigenvalues lie in
\([1-\delta,1+\delta]\). Talenti's theorem implies, for a
chart-supported test,
\[
 c\int|\nabla v|^2\geq
 Y_m\left(\frac{1-\delta}{1+\delta}\right)^{m/2}\|v\|_q^2.
\]
The gradient density contributes at least
\((1-\delta)^{m/2}/(1+\delta)\), and the squared \(L^q\) norm
contributes at most \((1+\delta)^{m/q}\).
The exponents combine because \(1+m/q=m/2\).
Take a finite such chart cover of \(\bar U\) and chart-supported
Lipschitz cutoffs \(\chi_i\) with \(\sum_i\chi_i^2=1\) near \(\bar U\).
Then
\[
 \|v\|_q^2\leq\sum_i\|\chi_i v\|_q^2,\qquad
 \sum_i|\nabla(\chi_i v)|^2
     =|\nabla v|^2+v^2\sum_i|\nabla\chi_i|^2.
\]
Choose \(\delta\) to make the chart coefficient at least
\(Y_m-\varepsilon\), and sum. Initially this proves (11) for
compact Lipschitz tests. Taking \(\varepsilon=Y_m/2\) first
gives continuity of the \(L^q\) inclusion, so the defining
\(H^1_0\) approximation proves (11) for all its elements.

The inclusion \(H^1_0(U)\to L^2(U)\) is compact even when
\(\partial U\) is irregular. To see the only compactness input
explicitly, zero extend and multiply by the finitely many \(\chi_i\).
In a chart these are bounded Euclidean \(H^1\) functions supported
in a fixed compact set. For such functions
\(\|f(\cdot-y)-f\|_2\leq |y|\|Df\|_2\), by the fundamental theorem
along segments and smooth approximation. Convolution at scale
\(\delta\) therefore approximates this bounded family uniformly in
\(L^2\) with error \(O(\delta)\). At fixed scale the convolutions
and their first derivatives are uniformly bounded on a fixed compact
set by Cauchy-Schwarz, and finite meshes give total boundedness in
\(L^2\). A diagonal choice as \(\delta\downarrow0\) proves
precompactness. Reassemble using \(v=\sum_i\chi_i(\chi_i v)\).
No trace or extension theorem for \(\partial U\) is being invoked.

Write \(Y=\inf_{\|v\|_q=1}Q(v)\), and suppose \(Y<Y_m\).
By (10), \(Y\geq0\); nonzero compact interior tests show it is finite.
For a minimizing sequence,
\[
 \|v_j\|_2^2\leq\sigma(U)^{2/m},\qquad
 c\|\nabla v_j\|_2^2
                  \leq Q(v_j)+mb^2\sigma(U)^{2/m}.            \tag{12}
\]
Thus it has a weakly convergent subsequence in the Hilbert space
\(H^1_0(U)\); compactness just proved gives strong \(L^2\) and
almost-everywhere convergence to \(\psi\).
For completeness, weak subsequential compactness here can be obtained
by diagonal convergence of the bounded coefficients in a countable
orthonormal basis; the limiting square-summable coefficients define
the weak limit. The closed \(H^1_0\) subspace retains that limit.

Set \(t=\int|\psi|^q\in[0,1]\), \(z_j=v_j-\psi\), and \(p=2/q\).
Brezis-Lieb Theorem 1 applies to the \(L^q\)-bounded, a.e.-convergent
sequence on the induced measure space, and gives
\(\|z_j\|_q^q\to1-t\).
The quadratic form splits by weak convergence. The potential
\(V=m(|{\bf H}|^2-b^2)\) is bounded near \(\bar U\) and
\(V\geq-mb^2\). Equation (11) and strong \(L^2\) convergence imply
\[
 Y\geq Q(\psi)+Y_m(1-t)^p
       \geq Yt^p+Y_m(1-t)^p.                                \tag{13}
\]
The last step is homogeneity of the defining infimum, including
\(\psi=0\).

There is a particularly short way to settle **all** cases, including
\(Y=0\): for \(0\leq s\leq1\) and \(0<p<1\), \(s^p\geq s\).
Thus the right side of (13) is at least
\[
 Yt+Y_m(1-t)=Y+(Y_m-Y)(1-t).
\]
Since \(Y_m>Y\), necessarily \(t=1\).
Weak lower semicontinuity of the gradient norm and strong \(L^2\)
convergence of the bounded-potential term give \(Q(\psi)\leq Y\).
Its now unit critical norm gives the reverse inequality.
This proves subthreshold attainment, without any smoothness,
positivity, or boundary trace of \(\psi\).
The universal real-power implication, including \(Y=0\), is one of
the statements encoded in `research/lean/Main.lean`.

## 6. Balanced variations force the first-order identity

For now let \(\Sigma\) be connected and boundaryless, and choose
\(U\Subset\Sigma\) with a nonempty open complement of \(\bar U\).
If \(Y(U)<Y_m\), take the normalized minimizer from Section 5.
Push \(|E_0\psi|^q\,d\sigma\) to \(M\).
It is a compactly supported nonatomic probability measure: on the
compact intrinsic set \(\bar U\), a finite cover by local embedding
charts makes each immersion fiber finite. Each such fiber has zero
area measure. Properness and global injectivity are not needed.

Apply (8), and use a fixed orthonormal frame of \(T_pM\oplus\mathbb R\)
to write \(w_j=(\Phi\circ X)_j\), \(1\leq j\leq n+1\). Then
\[
 \int|\psi|^q w_j=0,\qquad \sum_jw_j^2=1.
\]
The \(w_j,u\) and their first derivatives are bounded near \(\bar U\).
Their products preserve \(H^1_0(U)\), as established in Section 1.

Let \(B_Q\) denote the polarized quadratic form. For any bounded
Lipschitz multiplier \(\zeta\), differentiation along
\(\psi(1+s\zeta)\) gives
\[
 B_Q(\psi,\psi\zeta)=Y\int|\psi|^q\zeta.                     \tag{14}
\]
For small \(|s|\), \(1+s\zeta\) is uniformly positive.
Both differentiated mass integrands are bounded by constants times
\(|\psi|^q\); dominated convergence justifies both derivatives for
arbitrary \(H^1\) minimizers, even sign-changing ones.

For a balanced \(w=w_j\), put \(B_w=\int|\psi|^qw^2\). The squared
critical norm is
\[
 \|\psi(1+sw)\|_q^2=1+(q-1)B_ws^2+o(s^2).
\]
The linear numerator term vanishes by (14). Minimality of the
quotient gives
\[
                    Q(\psi w)\geq(q-1)YB_w.                 \tag{15}
\]
The product rule, then (14) with \(\zeta=w^2\), gives exactly
\[
 Q(\psi w)=B_Q(\psi,\psi w^2)+c\int\psi^2|\nabla w|^2
           =YB_w+c\int\psi^2|\nabla w|^2.                    \tag{16}
\]
Subtract (16) from (15), sum the finitely many coordinates, use
\(\sum B_w=1\), and cancel the **positive** number \(c=q-2\).
The resulting inequality has the crucial direction
\[
               E:=\int\psi^2|d(\Phi\circ X)|^2\geq Y.        \tag{17}
\]
The opposite inequality with a defect comes from (10):
\[
 Y=Q(\psi)\geq E+cD,\qquad
 D:=\int|\nabla\psi-\alpha\psi\nabla u|^2\geq0.
\]
Equations (17) and (10) force \(D=0\), since \(c>0\).
Therefore
\[
                  \nabla\psi=\alpha\psi\nabla u
                              \quad\text{a.e. on }U.        \tag{18}
\]
No division by \(\psi\), no Euler-Lagrange regularity theorem,
and no maximum principle has been used.

## 7. The zero-extension contradiction is a global weak statement

Choose a compactly supported Lipschitz \(\chi\) equal to one near
\(\bar U\), and set \(F=\chi e^{-\alpha u}E_0\psi\).
The multiplier is bounded with bounded weak first derivatives, so
\(F\in H^1(\Sigma)\). On \(U\), its gradient vanishes by (18).
Off \(U\), both \(E_0\psi\) and its gradient vanish a.e. by (1).
Thus
\[
                         \nabla F=0\quad\text{a.e. on }\Sigma.       \tag{19}
\]
This conclusion includes an irregular positive-measure boundary;
it is not a piecewise-smooth assertion ignoring a jump distribution.

To justify constancy without an unstated regularity hypothesis,
use a coordinate ball. Uniformly invertible metric coefficients turn
(19) into zero distributional Euclidean partial derivatives.
Mollification on smaller concentric balls has zero classical
derivative, hence is constant there. Its \(L^2\) limit is constant
almost everywhere. Two overlapping balls have the same constant
because their intersection is open and has positive measure.
Connectedness propagates the constant to all of \(\Sigma\).
Since \(F\) vanishes on the nonempty open set
\(\Sigma\setminus\bar U\), the constant is zero. But on \(U\),
\(F=e^{-\alpha u}\psi\), and this weight is strictly positive.
This contradicts \(\|\psi\|_q=1\). It proves \(Y(U)\geq Y_m\)
for every such \(U\).

## 8. Full support, boundary, disconnectedness and sharpness

A proper compact support in a connected boundaryless \(\Sigma\)
has a relatively compact open neighborhood \(U\) whose closure
misses a smaller coordinate ball outside that support. Section 7
therefore proves the required inequality for it. If the support is
the entire component, that component is compact.
In a chart at one point choose a Lipschitz cutoff \(\eta_\delta\)
which is zero on a radius-\(\delta\) ball, one outside the
radius-\(2\delta\) ball, and has derivative at most \(C/\delta\).
For Lipschitz \(v\), local metric comparability gives
\[
 \|\nabla((1-\eta_\delta)v)\|_2^2
 \leq2\int_{D_{2\delta}}|\nabla v|^2
                         +C\|v\|_\infty^2\delta^{m-2}\to0.
\]
Also \(\eta_\delta v\to v\) in \(L^2\) and \(L^q\).
The potential is bounded on this compact component, so the
proper-support inequalities pass to \(v\).
This is the point where \(m>2\), rather than just \(q>2\), is needed.

If \(\Sigma\) has boundary, work on \(\Sigma^\circ\).
If it is disconnected, a compact support meets only finitely many
components: the open components cover that compact set and admit a
finite subcover. With \(a_j=\int_{\Sigma_j}|v|^q\) and \(p=2/q<1\),
\[
 Q(v)\geq Y_m\sum_j a_j^p\geq Y_m(\sum_j a_j)^p.
\]
For the second inequality, normalize by \(A=\sum a_j>0\);
\((a_j/A)^p\geq a_j/A\), and sum. The zero test is immediate.
Finally, the defining \(H^1_0(U)\) approximants converge in \(L^q\)
by (11), and \(Q\) converges because its potential is bounded near
\(\bar U\). Equation (1) identifies the limit with the stipulated
zero extension. This also covers \(U\) containing an entire compact
component. All requested scope quantifiers are now accounted for.

For a radius-\(R\) geodesic sphere in the \((m+1)\)-dimensional model,
\[
 A=|\mathbb S^m|\operatorname{sn}_b(R)^m,\qquad
 h^2-b^2=\operatorname{sn}_b(R)^{-2}.
\]
For a constant \(v\), \(Q(v)=m(h^2-b^2)Av^2=Y_m A^{2/q}v^2\).
Thus the constant is sharp, with the normalization in the question.
In higher ambient dimension use a totally geodesic model
\((m+1)\)-subspace when available; local Euclidean concentrating tests
also show the universal constant cannot increase, including codimension
zero.

## 9. What is, and is not, certified by computation

`verify.py` replays universal rational identities in \(m-2,a,b^2,t\),
not a finite list of dimensions or test functions. It checks the
map's model factor, both radial Hessian identities, the pole jets,
the normal-completion sign, the integration-by-parts square,
the multiplier product identity, both quotient derivative coefficients,
the centering-potential derivatives, concentration and distortion
exponents, the Talenti extremal's radial equation, and model-sphere
normalization.
It also replays the archived exact Jacobian SOS payload and checks its
typed response. Jacobian's inspected contract handles only polynomial
coefficient identities; it cannot express the analytic goal, and is
not represented as having done so.

The separate Lean claim `L_MASS_CLOSURE` encodes the universal no-loss,
positive-coefficient cancellation and defect-saturation implications,
with explicit statement fidelity. Only an actual successful official
compiler record can certify that claim. It cannot certify the geometry
or functional analysis.

In particular, no Python identity or Lean theorem in this deliverable
establishes Jacobi-field comparison, differentiating a parameterized
measure integral, local \(H^1\) compactness, Brezis-Lieb splitting,
Sobolev multiplication or weak zero extension. Those have been
justified in the source-bound proof above or imported with the
precise cited hypotheses. Independent human review must check those
arguments and the source transcriptions. The full analytic result is
therefore a **proof submitted for independent review**, not a
fully kernel-formalized Sobolev theorem.

No false assertion of the staged Sections 2-3 was established here.
In particular, irregular \(\partial U\), immersion multiplicity,
the case \(Y=0\), compact components, or orientation reversal do
not yield counterexamples. No speculative `F_*` refutation claim is
registered. The downstream profile, singular-cutoff and equality
claims remain open; this verification must not be used to mark them
proved.
