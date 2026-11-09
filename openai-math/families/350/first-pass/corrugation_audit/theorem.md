# Repeatable corrugation: exact scope and mathematical verification

## Source and scope

The target is the staged September 23, 2026 version of
`Power-law-violations-of-Yaus-nodal-upper-bound`, specifically
`build/sections/envelopes.tex`, Lemma `lem:corrugation` and Proposition
`prop:envelope`. The definition of the test is
`build/sections/framework.tex`, equation `eq:hessian-test`.
These local sources, rather than a different revision or a literature
analogue, determine the statements under examination.

Write

\[
 p=\nabla_G h,\quad T(p)=p/\sqrt{1+|p|_G^2},\qquad
 J_h(e)=\nabla_G^2h(T(p),T(p))+\nabla_G^2h(e,e).
\]

A test has \(|e|_G=1\) and \(dh(e)=0\). At \(p=0\) every unit vector
is a test. A cube of coordinate side \(\nu S\), \(0<S\leq1\), is
prepared when its closure satisfies

\[
 |p|_G>0,\quad |\nabla_G^2h|_{\mathrm{op}}\leq C_p|p|_G/S,
 \quad
 \exists E\subset\ker dh,\ \dim E=2:
 J_h(e)\geq c_p|p|_G/S\quad(e\in E,\ |e|_G=1).
\]

All integrals in this local assertion use coordinate Lebesgue measure,
not Riemannian volume. Metric ellipticity and first coordinate derivatives
have common bounds. No higher derivative bound for an input function is
available. The parent slope may be any strictly positive number.

The exact requested conclusions include compact interior support of the
perturbation, both gradient comparisons, a positive test everywhere on
the parent, preparation on *closed* grid children of side \(\nu^3S\) at
scale \(\ell=\nu^2S\), and selected new gradient mass exceeding the
*entire* old parent mass. The pattern and positive mass gain must be
chosen before \(C_p,c_p,\nu\), and before all later approximation orders.
The order-\(j\) increment bound is \(C_j s\ell^{1-j}\), with
\(s=|\nabla_Gh(x_P)|_G\). Constants \(C_j\), but not the exponent of the
eventual envelope gain, may depend on \(j\).

## Dependency frontier

The local mechanism separates into radial-well identities, uniform
absorption at zero well/cutoff coefficients, stability of an inherited
favorable two-plane at all slope sizes, selection of closed children
with mass slack, and additive derivative accounting. The envelope
proposition additionally needs the seed of Lemma `lem:seed`.

The surface main theorem, the qualitative dimension-three/four main
theorems, and the power-law *nodal* main theorem are separate open
claims. Proving the envelope proposition does not prove any of them:
the wave, exactification, spectral-persistence, and limiting-metric
steps are outside this mission.

No external literature theorem is needed for the local mechanism:
the required finite-packing, compactness, linear-algebra, and stability
facts will be proved here. The manuscript's unrelated nodal-history
citations are not assumptions of this verification. No novelty claim
about the entire literature is made at scope.

## Result and status

**Theorem A (local verification and simultaneous energy amplification).**
The stated Lemma `lem:corrugation` is valid. In fact, for every fixed base
dimension \(n\geq4\), the same assertion holds with a two-dimensional
favorable parent plane. One can choose the pattern and a further constant
\(\rho>1\), before the preparation constants, so that its selected union
also satisfies

\[
 \inf_{\mathcal R_P}|\nabla_Gv|_G
 \ \geq\ \rho\sup_P|\nabla_Gh|_G.                       \tag{A1}
\]

With the same modification, the same children, and the same constants,
simultaneously for **every real \(r\geq1\)**,

\[
 \int_{\mathcal R_P}|\nabla_Gv|_G^r\,dx
 \geq (1+\zeta)\rho^{r-1}\int_P|\nabla_Gh|_G^r\,dx.    \tag{A2}
\]

For **every finite convex** \(\Phi:[0,\infty)\to[0,\infty)\) with
\(\Phi(0)=0\), without changing the construction,

\[
 \int_{\mathcal R_P}\Phi(|\nabla_Gv|_G)\,dx
 \geq (1+\zeta)\int_P\Phi(|\nabla_Gh|_G)\,dx.           \tag{A3}
\]

The two-plane, support, Hessian, derivative and metric hypotheses are
exactly those specified above. The dimension is fixed before the pattern.
This does not assert such a construction in base dimension three.

**Theorem B (order-independent iteration).**
The stated Proposition `prop:envelope` follows, with the same envelope
sequence for every finite derivative order. If Theorem A's selection is
used, this sequence also has

\[
 \int_V|\nabla_Gh_k|_G^r\,dx\geq c_r k^{\gamma_r},
 \qquad
 \gamma_r=\theta\{\log(1+\zeta)+(r-1)\log\rho\}>0
 \quad(r\geq1),                                      \tag{B1}
\]

where \(\theta>0\) is fixed independently of \(r\), derivative orders
and later approximation accuracies.

These are mathematical proofs with an exact, universal **algebraic**
replay, not a fully formalized analytic proof. `verify.py` checks the
displayed polynomial/rational certificates, the recorded Jacobian answer
and its exact input, and the stated source anchors. Compactness, smoothness,
finite packing, integration and the analytic interpretation of the
certificates are proved below and still require an independent reader.
No false manuscript assertion was found in this scoped argument. That
statement is not a finite-search proof of correctness.

The convex-energy and all-real-moment conclusions strengthen the staged
local lemma; they are not claimed there. A bounded literature lookup found
no exact matching primary theorem, but is not a proof of literature-wide
novelty. Publishability, originality and independent acceptance remain
for the host's Reviewer; no campaign-completion claim is made here.

## Proof of Theorem A

### 1. A fixed smooth pattern and finite packing

Set \(\vartheta(u)=e^{-1/u}\) for \(u>0\), and zero for \(u\leq0\).
The following explicit choice meets the manuscript's profile conditions:

\[
 F(v)=v\,\frac{\vartheta(1-v)}
                 {\vartheta(1-v)+\vartheta(v-1/2)},\qquad 0\leq v\leq1.
                                                               \tag{1}
\]

The denominator never vanishes on this interval. Thus \(F\) is smooth,
positive in its interior, equals \(v\) near zero, and is flat at one.
For a ball of radius \(R\leq1\), put

\[
 \psi(r)=-\int_r^R F(q/R)\,dq,\qquad
 f=F(r/R),\quad u=f/r.
\]

At the center set \(u=1/R\). Near it \(\psi\) is a constant plus
\(r^2/(2R)\). Extension by zero past \(r=R\) is smooth. For \(r>0\),
ordinary differentiation of \(r=|z'|\) gives

\[
 d\psi=f\sigma,\quad
 D^2\psi=f'\sigma\otimes\sigma+u(I-\sigma\otimes\sigma),
 \qquad \sigma=z'/r.                                  \tag{2}
\]

The formula extends at the center because \(f'=u=1/R\) there.
Two finite constants, independent of \(R\leq1\), give

\[
 f^2|f'|\leq M_F u,\qquad f^2\leq N_F u,\qquad
 M_F=\max_{0\leq v\leq1}vF(v)|F'(v)|,\quad
 N_F=\max_{0\leq v\leq1}vF(v).                         \tag{3}
\]

Indeed the corresponding quotients are \(vF(v)|F'(v)|\) and
\(RvF(v)\). Set all coefficients to zero outside the balls. They
are continuous, and \(u=0\) implies \(f=f'=\psi=0\): an interior
point of a ball has \(u>0\), and at its outer boundary flatness
gives the assertion. This includes all degeneracies used below.

Let \(m=n-1\). Choose \(a>0\), with \(a\leq1\), sufficiently small
that \(2C_0^2a^2M_F\leq1/4\), where \(C_0=2\) is justified in
Step 3. This choice precedes the packing. Its one-well mean is

\[
 W=m\int_0^1 v^{m-1}\sqrt{1+a^2F(v)^2}\,dv>1.
\]

The strict inequality follows from positivity on an interval, not
from numerical quadrature. Put \(\eta=(W-1)/8>0\).

Here is a finite packing proof. In a bounded open remainder \(O\)
inside the unit cube, sufficiently fine grid cubes whose closures
lie in \(O\) cover at least \(|O|/2\): every point of \(O\) has
positive distance from its complement, and the indicators of these
inner grid unions converge to one on \(O\). Only finitely many grid
cubes occur. In each, a ball of radius one quarter its side has
closure in its interior and captures at least the rational volume
fraction \(\kappa=(4m)^{-m}>0\), as is seen by a smaller inscribed
cube. Ball closures are disjoint, including across grid boundaries.
Removing them leaves another open remainder with volume at most
\((1-\kappa/2)|O|\). Finitely many repetitions make the total
uncovered volume as small as desired. Consequently a finite packing
with volume fraction \(\varpi\) satisfying
\(\varpi W>1+6\eta\) exists. Its balls lie strictly inside the
unit cube, so the resulting \(\psi\) extends periodically and
smoothly. All its derivative bounds are finite.

For the strengthening, retain annuli

\[
             dR_i<r<(1-d)R_i,\qquad 0<d<1/2,          \tag{4}
\]

rather than just deleting the outer collars. As \(d\downarrow0\),
their weighted integral tends to \(\varpi W\). Choose \(d\) once
so that the per-period integral \(C_{\rm ann}\) is greater than
\(\varpi W-\eta>1+5\eta\). The discarded center balls have
vanishing volume, so do not exhaust the mass slack. On the closures
of these annuli both

\[
       f\geq f_*>0,\qquad u\geq u_*>0                 \tag{5}
\]

hold, since the packing is finite and \(F\) is positive on
\([d,1-d]\).

Choose an inner parent cube of volume fraction \(q\) so close to one
that \(qC_{\rm ann}>C_{\rm ann}-\eta>1+4\eta\).
Choose a smooth \(0\leq\chi\leq1\), compactly supported in the unit
parent interior, equal to one on that inner cube and flat on its
zero set. Products of one-dimensional smooth plateau functions
constructed from \(\vartheta\) suffice. The entire pattern, the
annuli, the cutoff and their derivative bounds are now fixed.

### 2. Parent normalization uses only its prepared Hessian

Choose an affine coordinate system \(z=(z_1,z')\), centered at
the parent center, with \(G(x_P)=I\) and
\(\nabla_Gh(x_P)=s\,\partial_{z_1}\), \(s>0\).
Its linear matrix and inverse are uniformly bounded by ellipticity;
the set of such frames has compact closure.

The connection bound and \(S\leq1\) give
\(|D(dh)|\leq K|dh|/S\), with \(K=C(C_p+1)\).
Parametrize any segment from the center by its Euclidean length
\(r_1\). Its covector norm \(b(r_1)=|dh|\) is positive, and
\(|(\log b)'|\leq K/S\). Hence
\(s e^{-Kr_1/S}\leq b(r_1)\leq s e^{Kr_1/S}\).
Integrating the original covector derivative also gives
\(|dh(r_1)-dh(0)|\leq s(e^{Kr_1/S}-1)\).
Since \(r_1\leq C\nu S\), these elementary integrations give
on the whole closed parent

\[
 dh/s=dz_1+O(\nu),\quad G_z=I+O(\nu),\quad
 |\nabla_Gh|_G/s=1+O(\nu).                            \tag{6}
\]

The constants may depend on \(C_p\); choosing \(\nu\) after \(C_p\)
is allowed. This argument does not presuppose a uniform positive
lower bound for \(s\), or use any third derivative.

Rescale the parent cutoff and set

\[
 w=s\ell a\chi\psi(z'/\ell),\qquad
 v=h+w,\qquad \ell=\nu^2S.                           \tag{7}
\]

It is a smooth function with compact support in the parent
interior. Here and below \(f,f',u,\sigma\) are evaluated in the
rescaled transverse period. Since \(\ell/(\nu S)=\nu\),

\[
 dv/s=dz_1+a\chi f\,\sigma\cdot dz'+O(\nu).            \tag{8}
\]

Thus positive constants \(\alpha\leq1\leq\beta\) compare new and old
gradient norms, uniformly over every \(s>0\). There are also fixed
positive lower and upper bounds for \(|\nabla_Gv|_G/s\).

### 3. The new Hessian, including every zero-coefficient case

Put \(D=T(\nabla_Gv)\), and let

\[
 {\cal F}=\{e:dv(e)=0,\ \sigma\cdot e'=0\}.
\]

The two constraints are independent by (8), so
\(\dim{\cal F}=n-2\). For any metric unit \(e\in{\cal F}\),
\(e_1=O(\nu)\), whence \(|e'|^2\geq1/2\) for small \(\nu\).
Also \(|D|_G\leq1\) and

\[
       |\sigma\cdot D'|\leq 2a\chi f+C\nu.            \tag{9}
\]

To see uniformity in slope, the numerator in this component is
\(s(a\chi f+O(\nu))\), while its denominator is at least
\(\sqrt{1+s^2/4}\). Thus their slope ratio is at most two,
both as \(s\downarrow0\) and as \(s\to\infty\). Metric errors
are \(O(\nu)\) in the same bound.

The leading normalized contribution to
\(\nabla_G^2w(D,D)+\nabla_G^2w(e,e)\), with normalization
factor \(\ell/s\), is

\[
 a\chi\{f'(\sigma\cdot D')^2+
       u(|\Pi_\sigma D'|^2+|e'|^2)\}.
\]

By (3), (9), and the already fixed amplitude, it is at least
\(a\chi u/4-C\nu^2\chi|f'|\). The mixed cutoff contribution
on \(e,e\) vanishes exactly, since \(d\psi(e)=0\).
On \(D,D\) it is bounded in absolute value by

\[
 C\nu f|D_{\rm sc}\chi|(\chi f+\nu).
\]

The pure cutoff term is bounded by
\(C\nu^2|\psi||D_{\rm sc}^2\chi|\). Replacing the coordinate
Hessian by the covariant Hessian adds at most
\(C\ell(\chi f+\nu)\). These statements follow directly from
twice differentiating (7); the connection is only multiplied
by \(dw\).

For completeness, the needed zero-coefficient absorption is a
uniform theorem, not an informal relative-error assertion.
On a compact space let continuous \(X,b\geq0\) satisfy
\(b=0\) on \(X=0\). Put \(B=\sup b\) and
\(\omega_b(\tau)=\sup_{X\leq\tau}b\). Compactness implies
\(\omega_b(\tau)\to0\): otherwise a sequence with \(X\to0\)
and \(b\) separated from zero has a contradictory convergent
subsequence. For every \(\tau>0\),

\[
 \frac{\nu^2b}{X+\nu^2}
       \leq\omega_b(\tau)+\frac{B\nu^2}{\tau}.        \tag{10}
\]

Split into \(X\leq\tau\) and \(X>\tau\) to prove this.
Choose \(\tau\) first, then \(\nu\); hence the left side tends
uniformly to zero.

Apply (10) with \(X=\chi u\) and with
\[
 b=\chi|f'|,\quad f|D_{\rm sc}\chi|,\quad
 |\psi||D_{\rm sc}^2\chi|.
\]
If \(u=0\), the well-vanishing identities give their vanishing.
If \(\chi=0\), flatness of the cutoff gives their vanishing.
The compact parameter space is cutoff position, period position
and the compact family of affine frames, not the unbounded slope.
The choice of \(\sigma\) at centers causes no problem: (2) is
independent of it there and the scalar error coefficients are
continuous.

The other mixed term is at most \(C\nu X\).
Moreover \((\chi f)^2\leq N_FX\) and \(\ell\leq\nu^2\), so

\[
 \frac{\ell(\chi f+\nu)}{X+\nu^2}
 \leq C\frac{\nu^2\sqrt X}{X+\nu^2}+\nu
 \leq (C/2+1)\nu,                                   \tag{11}
\]

using \((\sqrt X-\nu)^2\geq0\). Combining the estimates yields

\[
 \frac{\ell}{s}
 \{\nabla_G^2w(D,D)+\nabla_G^2w(e,e)\}
 \geq c_aX-\epsilon(\nu)(X+\nu^2),\quad
 c_a=a/4,\quad\epsilon(\nu)\longrightarrow0.          \tag{12}
\]

Every constant and modulus is independent of \(s,S\), the parent
function's higher derivatives, and any later accuracy order.
In particular (12) is valid exactly at \(X=0\), not just on its
positive set.

### 4. A quantitative two-regime test selection

Write \(t_0=\nu^2\), \(M=2C_p\), \(b_0=c_p/2\), and
normalize the old Hessian by \(\ell/s\). By (6), its operator
norm is at most \(Mt_0\); its old good tests are at least
\(b_0t_0\). Choose

\[
 H=\frac{4M+b_0}{c_a},\qquad
 0\leq\epsilon(\nu)\leq\min(c_a/2,b_0/4).             \tag{13}
\]

If \(X\geq Ht_0\), any unit \(e\in{\cal F}\) has total test
at least \(b_0t_0/4\). The exact nonnegative decomposition is

\[
\begin{split}
 &c_aX-\epsilon(X+t_0)-2Mt_0-b_0t_0/4\\
 &=(c_a/2-\epsilon)X+(b_0/4-\epsilon)t_0
                 +(c_a/2)(X-Ht_0)\ \geq0.           \tag{14}
\end{split}
\]

This is the universal identity replayed by Jacobian after clearing
the defining relation \(c_aH=4M+b_0\).

If \(X\leq Ht_0\), (7) and (3) instead give
\[
 \eta_1:=|\nabla_Gv-\nabla_Gh|_G/|\nabla_Gh|_G
 \leq C(1+\sqrt H)\nu.
\]
For any vectors \(p,q\) in one inner-product space with
\(|q-p|\leq\eta_1|p|\), \(\eta_1\leq1/2\),

\[
 |T(q)-T(p)|\leq
 \frac{\eta_1|p|}{\sqrt{1+|p|^2/4}}\leq2\eta_1.     \tag{15}
\]

Indeed the segment stays outside the ball of radius \(|p|/2\);
the derivative norm of \(T\) there is at most
\((1+|p|^2/4)^{-1/2}\).
The unit directions of \(p,q\) differ by at most \(2\eta_1\).
The minimal orthogonal planar rotation \(R\) between them therefore
has \(\|R-I\|\leq2\eta_1\) and sends \(p^\perp\) to \(q^\perp\).

In \(q^\perp\), of dimension \(n-1\),
\[
       \dim(RE\cap{\cal F})\geq2+(n-2)-(n-1)=1.
\]
Choose a unit \(e\) in this intersection. Comparing the old test
on \(T(p),R^{-1}e\) with the old Hessian on \(T(q),e\)
costs at most \(8M\eta_1t_0\): each quadratic evaluation
changes by at most its operator norm times the vector difference
times the sum of the vector norms. Choose \(\nu\) still smaller
so that \(\eta_1\leq b_0/(16M)\). The old contribution is then
at least \(b_0t_0/2\); (12) contributes at least
\(-\epsilon t_0\). Consequently the total is again at least
\(b_0t_0/4\). Equivalently, the remaining scalar surplus is
\[
       (c_a-\epsilon)X+(b_0/4-\epsilon)t_0\geq0.     \tag{16}
\]

These rotations and intersections are pointwise. No continuity of the
parent favorable plane, or smooth choice of the new test, was assumed.

Thus a test with normalized margin \(c_p\nu^2/8\) exists
everywhere. In unnormalized units it is at least
\((c_p/16)|\nabla_Gh|_G/S\), by (6).
This proves the positive-test part of the local lemma, including
small, large and unbounded slopes. There was no limiting compactness
assumption on those slopes.

### 5. Repeat preparation and selected mass

In the inner parent where \(\chi=1\), take the open annuli (4)
in every period. Here \(u\geq u_*\). Formula (12) applies to
**all** unit vectors of \({\cal F}\). Taking \(\nu\) small
gives a fixed lower bound \(c_1s/\ell\) for their tests.
There is a fixed \(K\) with
\[
 |\nabla_G^2v|\leq(K+2C_p\nu^2)s/\ell.
\]
Let \(\alpha_s,\beta_s>0\) be the lower and upper bounds for
\(|\nabla_Gv|_G/s\) from (8). For example the loose bounds
\(\alpha_s=1/2\), \(\beta_s=4\) are available by making the
normalization error small, since the explicit profile has \(F\leq1\)
and \(a\leq1\). These bounds are chosen before \(C_p,c_p\).
It suffices to take
\[
 C_p^*\geq2K/\alpha_s,\qquad c_p^*\leq c_1/\beta_s
\]
and then \(\nu^2\leq\alpha_s/4\), as well as the earlier
smallness conditions. A two-plane inside \({\cal F}\) exists
because \(n-2\geq2\). These estimates give exactly the same
preparation constants \(C_p,c_p\) at scale \(\ell\).

Select every closed child cube contained in this open repeat
region. For \(\nu=1/N\), there are exactly \(N^2\) children
per parent side, because the ratio of side lengths is
\((\nu S)/(\nu\ell)=\nu^{-2}\). Thus this is a genuine
partition in the original coordinates, not in the affine frame.
Preparation holds on each selected closure.

Here are the discretization estimates. In affine coordinates, tile
by period cubes of side \(\ell\), including a dummy period in
\(z_1\). Those crossing the inner parent's boundary have total
relative volume \(O(\ell/(\nu S))=O(\nu)\). Constants are
uniform for the bounded affine frames. In each rescaled period
the finitely many spherical annulus boundaries have finite area;
their width-\(C\nu\) neighborhoods have volume \(O(\nu)\).
A point at distance greater than the diameter \(C\nu\ell\)
of a child from the repeat-region complement lies in a selected
closed child. The additional child-grid loss is therefore also
\(O(\nu)\) of the parent volume. This uses the fixed finite
packing, not a bound uniform over arbitrarily small new radii.

On the repeat region (6)--(8) give
\[
 |\nabla_Gv|_G/s=\sqrt{1+a^2f^2}+O(\nu).
\]
Both the normalized integrand and the frame Jacobian have common
bounds. The constant affine Jacobian cancels in the ratio to
parent coordinate volume. Hence
\[
 \frac{\int_{\mathcal R_P}|\nabla_Gv|_G\,dx}{s|P|}
       \geq qC_{\rm ann}-C\nu,\qquad
 \frac{\int_P|\nabla_Gh|_G\,dx}{s|P|}\leq1+C\nu.
\]
Choose the two errors at most \(\eta\). The mass ratio is
strictly greater than
\[
        \frac{1+3\eta}{1+\eta}
        >1+\zeta,\qquad \zeta=\eta/(1+\eta)>0.        \tag{17}
\]
This compares with the *entire old parent*, not just its selected
part.

To prove the stronger (A1), (5) gives
\(L=\sqrt{1+a^2f_*^2}>1\). Put \(\rho=(1+L)/2>1\).
For a common error \(d_\nu=C\nu\),
\[
 \inf_{\mathcal R_P}|\nabla_Gv|_G/s\geq L-d_\nu,
 \qquad \sup_P|\nabla_Gh|_G/s\leq1+d_\nu.
\]
If \(d_\nu\leq(L-1)/(2(L+3))\), then
\(L-d_\nu-\rho(1+d_\nu)\geq(L-1)/4>0\).
This additional choice of \(\nu\) is independent of all energy
functions or exponents.

Let \(A=\sup_P|\nabla_Gh|_G>0\). For every real \(r\geq1\),
\[
\begin{split}
 \int_{\mathcal R_P}|\nabla_Gv|_G^r
 &\geq(\rho A)^{r-1}\int_{\mathcal R_P}|\nabla_Gv|_G\\
 &\geq(1+\zeta)\rho^{r-1}A^{r-1}\int_P|\nabla_Gh|_G
 \geq(1+\zeta)\rho^{r-1}\int_P|\nabla_Gh|_G^r.
\end{split}
\]
There is no \(r\)-dependent error being absorbed here. For a finite
convex \(\Phi\) as in (A3), \(\Phi(t)/t\) is nondecreasing
on \(t>0\), because convexity with \(0\) gives
\(\Phi(u)\leq(u/v)\Phi(v)\) when \(0<u<v\).
Thus
\[
 \int_{\mathcal R_P}\Phi(|\nabla_Gv|_G)
 \geq \frac{\Phi(A)}{A}\int_{\mathcal R_P}|\nabla_Gv|_G
 \geq(1+\zeta)\int_P\Phi(|\nabla_Gh|_G).
\]
This also covers \(\Phi(A)=0\); no division by \(\Phi(A)\)
was used. These are simultaneous inequalities, not separate
constructions for finitely many energies.

### 6. All derivatives and the order of quantifiers

With \(j\) derivatives, of which \(q_1\) land on the cutoff,
the factor in (7) is
\[
 s\ell(\nu S)^{-q_1}\ell^{-(j-q_1)}
       =s\ell^{1-j}\nu^{q_1}\leq s\ell^{1-j}.
\]
All pattern derivatives and affine matrices are fixed coefficients.
The frozen \(s\) and the frozen affine frame are not differentiated.
Consequently \(\|D^jw\|_\infty\leq C_js\ell^{1-j}\)
for every integer \(j\geq0\), with no derivative of the parent
beyond its prepared Hessian bound.

The order of choices is: dimension and metric bounds; \(F,a\);
finite packing, annuli, parent cutoff, \(\eta,\zeta,\rho\);
preparation thresholds; any allowable \(C_p,c_p\); finally a
sufficiently small reciprocal \(\nu\). Every further restriction
above is a small-\(\nu\) condition independent of derivative,
moment and approximation orders. Increasing \(C_p\) or decreasing
\(c_p\) changes that final restriction but not the pattern or gains.
This proves Theorem A and every condition of the target local lemma.

## Proof of Theorem B

### 7. The seed does not hide a slope or critical-point assumption

On the round \(S^4\), with \(t=|y|^2\), tangent projection of
the ambient gradient of \(\widetilde h=-a_*t\) and restriction
of its ambient Hessian give
\[
 |\nabla\widetilde h|^2=4a_*^2t(1-t),\qquad
 \nabla^2\widetilde h=2a_*(t g_0-dy\cdot dy).
\]
The Hessian operator norm is at most \(2a_*\) and the gradient
squared at most \(a_*^2\). The kernel of
\(dy:T_xS^4\to\mathbb R^3\) has positive dimension. Any unit
vector in it is an admissible test, including at a critical point,
and for \(t\geq1/4\) gives
\[
 J_{\widetilde h}\geq a_*/2-2a_*^3\geq a_*/4
 \quad\text{if }a_*^2\leq1/8.
\]

At a point with \(t=1\), the gradient vanishes and the Hessian
eigenvalues are \(2a_*,2a_*,0,0\). In a small normal coordinate
ball above \(t=1/2\), add
\(\varepsilon|\xi|^2/2\) times a fixed plateau cutoff. This
makes the Hessian positive definite at its center. Choose the
ball first so that the original gradient is small and two positive
Hessian eigenvalues are retained, and then choose \(\varepsilon\)
small relative to the fixed cutoff's \(C^2\) norm. Throughout
its support the perturbed Hessian still has a uniformly positive
two-plane, bounded operator norm, and sufficiently small gradient.
The intersection of this plane with \(\ker dh_0\) has dimension
at least one and gives \(J_{h_0}>0\), because the possibly
negative gradient-Hessian term is bounded by
\(|\nabla^2h_0|\,|\nabla h_0|^2\).
Outside the support the previous kernel test is unchanged.

All strict margins survive a sufficiently small common \(C^1\)
perturbation of the metric: the connection difference is contracted
only with \(dh_0\). The kernel \(dy\) remains metric independent.
In the positive-definite region there is a point with \(dh_0\ne0\);
otherwise the function would be constant on an open region with
positive-definite Hessian. Choose \(U_0\Subset V\Subset\Omega\)
near such a point. Compactness gives uniform positive lower and
upper gradient bounds on \(U_0\). On sufficiently small initial
cubes, positive definiteness gives the prepared two-plane for
large \(C_p\) and small \(c_p\). This proves the precise seed
data used here, rather than assuming an external theorem.

### 8. Iteration and additive, not multiplicative, derivative costs

Fix the preparation constants and \(\nu\) once, uniformly for the
metric neighborhood, with a cube \(P_0\) of side \(\nu\)
compactly in \(U_0\). Put \(r_0=\nu^2\).
At generation \(i\), corrugate the selected parents at scale
\(S_i=r_0^{i-1}\), and select their children at scale \(r_0^i\).
There are finitely many parents with disjoint interiors at each
generation. The perturbations vanish on neighborhoods of parent
boundaries, so the finite sum \(h_i\) is smooth. Nothing outside
\(P_0\) changes.

For selected gradient mass,
\[
 I_i\geq(1+\zeta)I_{i-1},\qquad
 \int_V\sqrt{1+|\nabla_Gh_i|_G^2}\,dx
 \geq I_i\geq I_0(1+\zeta)^i,\qquad I_0>0.           \tag{18}
\]
Coordinate cube boundaries have measure zero, so using closed
children does not introduce double counting.

At every point of \(P_0\), after \(i\) generations the gradient
is at least \(s_{\min}\alpha^i\) and at most \(C\beta^i\).
A point not changed at a given generation satisfies these
inequalities as well, since \(\alpha\leq1\leq\beta\).
The all-order increment estimate and disjoint interiors give
\[
 \|D^j(h_i-h_{i-1})\|_\infty
 \leq C_j\beta^{i-1}r_0^{i(1-j)}.                   \tag{19}
\]
There is no parent-count factor in a supremum norm, and no
product of \(C_j\)'s across generations: these are additive
increments with separately frozen frames and slopes.

Let \(B=\log\beta\geq0\), \(A=|\log r_0|>0\), and
\(H_0=-\log\alpha\geq0\). Since \(m\leq e^m\) for \(m\geq1\),
summing (19), including \(j=0,1\), gives
\[
 \|h_m\|_{C^j}\leq C'_j
      e^{[B+(j-1)_+A+1]m}
 \leq C'_j e^{C_*(j+1)m},\qquad
 C_*=B+A+1+H_0.                                    \tag{20}
\]
For \(j=0\) the exponent surplus is \(A+H_0\); for \(j\geq1\)
it is \(Bj+2A+j+H_0(j+1)\geq0\).
Changing to the fixed finite atlas adds only lower derivatives
and fixed order-dependent coefficients. In particular it cannot
change \(C_*\).

At a point in \(P_0\), use the last generation whose closed
parent contains it, or use the seed if there is none. Its test
margin is at least
\[
 c\,s_{\min}\alpha^{i-1}/r_0^{i-1}
       \geq c\,s_{\min}\alpha^m.
\]
Every later perturbation has zero jets at that point, either
because the point is outside its support or on its support
boundary. The margin therefore persists. Outside \(P_0\) the
seed margin persists, including at its critical points. Thus
\[
       \max_eJ_{h_m}(e)\geq c e^{-C_*m}
       \quad\text{on }t\geq1/4.                     \tag{21}
\]

### 9. One frequency exponent for all orders

Fix \(\delta=10^{-6}\), choose one
\(0<\theta\leq\delta/C_*\), and take
\[
 m=\lfloor\theta\log k\rfloor,\quad
 \gamma=\theta\log(1+\zeta)>0,\quad h_k=h_m+c_k.
\]
For bounded prescribed \(c_k\), (20) yields every
\(C_j k^{\delta(j+1)}\) estimate and (21) the
\(ck^{-\delta}\) test margin. From
\(m\geq\theta\log k-1\), (18) gives
\[
 I_m\geq I_0(1+\zeta)^{-1}k^\gamma.
\]
The support and identity \(h_k=-a_*t+c_k\) below \(t=1/2\)
are unchanged. Every construction parameter and \(\gamma\)
was fixed before any derivative order or later residual accuracy.
A fixed smooth subsequent coordinate change involves only
derivatives of orders at most \(j\), with fixed coefficients;
it changes \(C_j\), not the exponent.

Finally apply (A2) on every parent at each generation:
\[
 I_m^{(r)}\geq
       \{(1+\zeta)\rho^{r-1}\}^{m} I_0^{(r)}.
\]
The same floor estimate gives (B1), with \(I_0^{(r)}>0\)
and a possibly \(r\)-dependent prefactor, but the original
\(\theta\). This proves both the exact target proposition and
the simultaneous-moment extension.

## Replay and remaining review boundary

From the campaign root run

```
$WORKSPACE/argus-live-update/.venv/bin/python research/corrugation_audit/verify.py
```

The verifier uses exact SymPy arithmetic, no random sampling, numerical
quadrature, asymptotic fitting, external service or new Jacobian call.
Its symbolic inequalities are universal in their nonnegative real
parameters. The saved Jacobian request concerns only (14), and its
`COMPUTED`, zero-remainder answer is independently replayed locally.
The complete argument also uses the elementary analytic proofs in
Steps 1--9; a successful replay is not represented as a Lean/compiler
verdict or as independent review.
