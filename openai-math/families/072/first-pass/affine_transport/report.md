# The critical affine law is the Cauchy quadratic law

## Result and scope

Write \(\mathbb H=\{x+iy:y>0\}\) and
\[
 \mathcal K=\{F:\mathbb H\longrightarrow\mathbb C:
       F\text{ holomorphic and injective},\ F(i)=0,\ F'(i)=1\}.
\]
Equip this space with locally uniform convergence. Put \(Q_F=1/F'\) and
\[
 T_{x+iy}F(w)=
 \frac{F(x+yw)-F(x+iy)}{yF'(x+iy)}.
\]

**Classification theorem (`C_AT_ENDPOINT`).** Let \(P\) be a Borel
probability on \(\mathcal K\). Suppose, for some \(\beta\ge1\), every
\(x\in\mathbb R\), \(y>0\), and nonnegative Borel \(\Phi\) satisfy
\[
 \mathbb E_P[|Q_F(x+iy)|^2\Phi(T_{x+iy}F)]
       =y^{-\beta}\mathbb E_P\Phi(F).                 \tag{1}
\]
Then \(\beta=1\), and \(P\) is uniquely the pushforward of
\[
 \frac{dt}{\pi(1+t^2)},\qquad t\in\mathbb R,
\]
under
\[
 F_t(z)=\frac{(z-t)^2-(i-t)^2}{2(i-t)}.              \tag{2}
\]
Conversely this probability satisfies (1), including all its Borel
tests. Thus the theorem is nonvacuous and includes existence, not just
an exclusion of excessive parameters.

The proof below also verifies the **complete shared signed-Jacobian
inference** in the two staged manuscripts. No false manuscript assertion
has been established. In particular, nonunimodularity alone is not a
refutation: the actual expected density is \(dx\,dy/y\), and the actual
enlarged-box ratios tend to one in the stated order of limits.

This is a mathematical proof with an exact symbolic certificate and a
separately delimited Lean core. The symbolic replay does not formalize
the whole analytic proof. Independent Reviewer replay, assessment of
significance/novelty, and citation attribution are still pending.

## Sources, prior result, and hypotheses

The manuscript source locators used here are:

| Short name | Staged manuscript and load-bearing locators |
|---|---|
| B | `Brennans-conjecture-and-sharp-inverse-square-integral-means-September-24-2026/build/sections/`: `02-weighted-law.tex`, Lemma `lem:weighted-law`; `03-escape.tex`, Proposition `prop:proper-superlevels`; `04-critical-pairing.tex`, Lemmas `lem:critical-count`, `lem:good-pairs` and Proposition `prop:critical-pairing`; `05-transport.tex`, Lemma `lem:root-exception` and Proposition `prop:transfer-bound`. |
| I | `A-strict-inverse-first-power-bound-for-univalent-functions-September-24-2026/build/sections/`: `02-weighted-law.tex`, Proposition `prop:law`; `03-escape.tex`, Proposition `prop:compact-levels`; `04-strict-pairing.tex`, Lemmas `lem:good`, `lem:count` and Proposition `prop:pair`; `05-strict-transport.tex`, Proposition `prop:strict-transport`; `06-equality-barrier.tex`, Lemma `lem:no-zero-J`. |

Both source trees are below `research/openai_manuscript/`. Their
normalization, operator composition order, inverse-coordinate Jacobian,
fixed root target, target weights, and exhaustion limits are checked
explicitly below, rather than inferred from a general mass-transport slogan.

The classical inputs are the Koebe quarter and distortion theorems,
normal-family compactness, Riesz representation on a compact metric
space, Tonelli/monotone convergence and local real change of variables,
and the planar Jordan/turning/index principles. They are recorded as
`A_KOEBE`, `A_MEASURE`, and `A_PLANE` in the ledger. The staged sources
cite Duren, *Univalent Functions* (1983), Chapter 2; Folland, *Real
Analysis*, second edition (1999), Theorems 7.2, 2.37, 2.47; Munkres,
*Topology* (2014), Theorem 63.4; Hopf (1935), Section 2; and Lee (2013),
Theorem 16.11. The original textbook passages have not been independently
obtained/attributed here; these are explicitly **uncited foundational
dependencies**, not purportedly checked quotations. Sard's special
case and the Borel enumeration are proved below and are not additional
unexamined external hypotheses.

**Strongest relevant prior result.** Binder, Ivrii, Prause, and Smirnov,
*Brennan's Conjecture and the Universal Integral Means Spectrum*,
[arXiv:2610.23853v1](https://arxiv.org/html/2610.23853v1), Section 1.4,
already state the strict quadratic bound for the bounded spectrum on
\((-2,2)\setminus\{0\}\), with the unrestricted negative-parameter
consequence immediately afterward. The primary source was opened.
An inconsistent search-generated summary calling \(p=-1\) open was
discarded; it is not evidence. Consequently the spectrum-only route
is retired. The improvement here is the classification of **all**
critical inverse-square affine probability laws, not another claim
of novelty for the strict spectrum inequality.

A separate bounded lookup checked five promising primary sources in
stationary conformal maps, restriction measures, variance/spectrum
theory, representation-theoretic univalent measures, and extreme-point
representations. It found no matching classification. Full access was
unavailable for Malliavin's 2005 chapter beyond its preview and for
Hallenbeck's 1974 paper beyond its abstract. A search-generated claim
that the latter contained this classification was unsupported and was
not adopted. This is a retrieval limitation, **not** verified novelty.
No relevant inherited Wiki page was found.

The bounded lookup's primary-source locators were Beliaev--Smirnov,
*Random conformal snowflakes*, Theorems 2.3-2.4
([arXiv:math/0701463v1](https://arxiv.org/abs/math/0701463v1));
Lawler--Schramm--Werner, *Conformal restriction: the chordal case*,
Proposition 3.3, Theorem 6.1 and Corollary 8.6
([arXiv:math/0209343v2](https://arxiv.org/html/math/0209343v2));
Ivrii, *On Makarov's Principle in Conformal Mapping*, Sections 1.2-1.3,
Theorems 1.1-1.2
([author manuscript](https://www.math.tau.ac.il/~ivrii/mak-principle.pdf));
Malliavin's 2005 unitarizing-measures chapter, accessible Sections 1-2
([DOI](https://doi.org/10.1007/3-540-30434-7_11)); and Hallenbeck's
1974 convex-hull paper, accessible abstract
([DOI](https://doi.org/10.1090/S0002-9947-1974-0338338-8)).
The first three concern different stationary/restriction/variance
statements, not the classification proved here; the last two remain
access-limited. None is used as a proof input to the classification.

## 1. The all-affine law really follows from the dyadic operator

We first check the hypothesis supplied by the manuscripts, rather than
assuming a stationary law for free. More generally let the inverse
derivative weight be \(|Q|^p\), \(p>0\). Source composition is
\[
 z\cdot w=x+yw,\qquad z^\#=(-x+i)/y.
\]
Direct differentiation gives
\[
 Q_{T_zF}(w)=Q_F(z\cdot w)/Q_F(z),\quad
 T_w(T_zF)=T_{z\cdot w}F,\quad A_zA_w=A_{z\cdot w},
\]
where \(A_z\Phi(F)=|Q_F(z)|^p\Phi(T_zF)\). In particular there is no
reversal of the displayed operator product.

The classical compact-family estimates give compact metrizability of
\(\mathcal K\), jointly continuous interior derivative evaluations, and
\(|Q_F(x+iy)|\le C/y\) for \(|x|\le2,0<y\le1\). Positivity gives
\[
 L^n=v\sum_{j=0}^{2^n-1}A_{-1+(2j+1)v+iv},\quad
 v=2^{-n},\quad \|L^n\|=\|L^n1\|_\infty.
\]
The affine map gives the lower norm bound one; distortion gives the
upper bound \(C_p2^{pn}\). Thus the root limit is \(2^\beta\) with
\(0\le\beta\le p\).

For \(\tau>\rho=2^\beta\), set \(R_\tau=\sum\tau^{-n}L^n\),
\(g_\tau=R_\tau1\), and \(M_\tau=\max g_\tau\). Since
\[
 Lg_\tau\le\tau(1-M_\tau^{-1})g_\tau,\qquad
 \rho\le\tau(1-M_\tau^{-1}),
\]
we have \(M_\tau\ge\tau/(\tau-\rho)\). A weak limit of
\(\delta_{F_\tau}R_\tau/M_\tau\), at maximizers \(F_\tau\), is a
probability \(\mu\) with \(\mu L=\rho\mu\). This only uses a countable
dense collection of continuous tests and Riesz representation.

Right composition by \(A_{2+i}\) shifts the dyadic grid one cell.
The exact two-endpoint cancellation gives
\[
 \|\mu A_{2+i}-\mu\|
 \le C_p\rho^{-n}v^{1-p}
 =C_p2^{n(p-1-\beta)}.
\]
It tends to zero if \(\beta>\max(0,p-1)\). Averaging \(\mu A_{x+i}\)
over \(0\le x\le2\) gives a finite positive \(\bar\mu\) invariant
under every horizontal right translation. Expanding \(\mu L\)
before making the substitutions \(-1/2+x/2\), \(1/2+x/2\) gives
\[
 \rho\bar\mu=\bar\mu A_{i/2}.
\]
The two intervals are adjacent and total one full horizontal period.
Consequently \(H(v)=v^\beta\bar\mu A_{iv}\) has \(H(2v)=H(v)\).
The commutation
\(A_{iv}A_{t+i}=A_{vt+i}A_{iv}\) preserves horizontal invariance.
Integrating \(H(v)\,dv/v\) over \(1\le v\le2\), then normalizing,
therefore gives
\[
 \mathbb E[|Q_F(x+iy)|^p\Phi(T_{x+iy}F)]
       =y^{-\beta}\mathbb E\Phi(F).                 \tag{3}
\]
The change of interval \([y,2y]\) is valid because it is one complete
logarithmic period. Equality of finite weighted pushforward measures
extends the continuous-test identity to every nonnegative Borel test.

For B the required threshold is exactly \(p=2,\beta>1\).
For I it is \(p=1,\beta\ge1/4>0\). Both meet the strict cancellation
threshold. **At \(p=2,\beta=1\) this cancellation bound does not
vanish.** We do not extend the manuscript construction to that boundary.
The endpoint law in the classification theorem is constructed directly
in Section 6 below.

## 2. Compact positive superlevels: the actual escape proof

Assume now (3) for \(p>0,\beta\ge0\), independently of how the law
was obtained. Set
\[
 s=p+2>2,\quad k=\frac{\beta+p+1}{p+2}>\frac12,\quad
 S_0=\{|(z-i)/(z+i)|\ge1/2\}.
\]
There is a common \(c>0\), for example \(c=1/16\), with
\(|F|\ge c\) on \(S_0\). For \(z\ne i\),
\[
 (T_zF)(z^\#)=-F(z)Q_F(z)/y.
\]
Applying (3) to \(|H(z^\#)|^{-s}\) therefore gives
\[
 \mathbb E[|F'(z)|^2|F(z)|^{-s}]
 =y^{-\beta-s}\mathbb E|F(z^\#)|^{-s}.             \tag{4}
\]
The **affine** inverse has determinant \(y^{-3}\), not \(y^{-4}\)
or the Jacobian of a complex reciprocal. It is an involution preserving
\(S_0\). If its new height is \(Y=1/y\), then
\(dx\,dy=Y^{-3}\,du\,dY\). Injectivity and conformal change of variables
bound the integral of the left side of (4) by
\[
 \int_{|\omega|\ge c}|\omega|^{-s}\,dA(\omega)
 =\frac{2\pi c^{-p}}p.
\]
Tonelli and the involution now give
\[
 \mathbb E I(F)\le\frac{2\pi c^{-p}}p,\qquad
 I(F)=\int_{S_0}y^{\beta+p-1}|F(z)|^{-s}\,dA(z).    \tag{5}
\]
Thus \(I(F)<\infty\) on one Borel full-probability set.

Fix a map in this set. For \(R(z)=|x|+y\), the disks \(B(z,y/2)\)
escape every bounded \(R\)-region when their centers do, eventually
lie in \(S_0\), and have comparable heights. Submean for \(|1/F|^s\)
gives
\[
 y^{sk}|F(z)|^{-s}\le
 C\int_{S_0\cap\{R(w)\ge R(z)/3\}}
       (\operatorname{Im}w)^{\beta+p-1}|F(w)|^{-s}\,dA(w)
 \longrightarrow0.                                \tag{6}
\]
Here \(sk=\beta+p+1\); the right side is a tail of one integrable
function. Hence \(y^k/|F(z)|\to0\) uniformly as \(R(z)\to\infty\).
Preimages of compact target sets restricted to \(y\ge\epsilon>0\)
are compact, and their full preimages have bounded height.

For a compact target set \(K\), choose smooth compactly supported
\(\psi\ge1_K\), \(\psi\ge0\). Strip compactness just proved makes
\(h(y)=\int_{\mathbb R}\psi(F(x+iy))\,dx\) smooth and supported in
a compact region above any fixed positive height. Twice integrating
by parts and then changing variables through \(F\) gives
\[
 h(\epsilon)=
 \int_{y>\epsilon}(y-\epsilon)|F'|^2(\Delta\psi)\circ F\,dA,
 \qquad
 |h(\epsilon)|\le
 H_{F,\operatorname{supp}\psi}\|\Delta\psi\|_1.
\]
Thus the horizontal preimage length of \(K\) is bounded independently
of \(\epsilon>0\). No sign assumption on \(\Delta\psi\) was made.

For completeness, this length bound controls all omitted targets
simultaneously. At a witness in a cell \([jh,(j+1)h)\), \(h\le y\le2h\),
with \(|\xi|\le R\), \(\xi\notin F(\mathbb H)\), and
\(|F(z)-\xi|\le y^k/\delta\), Koebe's quarter theorem gives
\(y|F'(z)|\le4|F(z)-\xi|\). Compact-family bounds for \(T_zF\) on
\([-1,1]+i[1/2,1]\) then give
\[
 |F(x'+ih)-\xi|\le C_\delta h^k
 \quad\text{for every }x'\text{ in the same cell}.   \tag{7}
\]
Every marked cell segment maps into one fixed compact target disk.
The length bound permits at most \(C/h\) marked cells. Disks of radius
\(C_\delta h^k\) about their midpoint images cover all witnessed
targets and have total area \(O(h^{2k-1})\). This is summable over
dyadic \(h\) because \(k>1/2\). The limsup is null. A countable union
over integer \(R\) and reciprocal-integer \(\delta\) shows
\(\sup_x y^k/|F(x+iy)-\xi|\to0\) for almost every omitted target.
These covers are measurable for a fixed \(F\); no measurable choice
of witnesses in \(F\) is required.

For an interior target a closed disk contained in \(F(\mathbb H)\)
has compact inverse image. Below its minimum height the target
distance is bounded below, giving the same limit for every such
target. Together with (6), this proves compactness in \(\mathbb H\)
of every closed positive superlevel of
\[
 V_\xi^F(z)=y^k/|F(z)-\xi|,
\]
including the possible pole. This discharges the compactness input
for both manuscripts and, importantly, also for the endpoint law
with \(p=2,\beta=1,k=1\).

## 3. Generic targets and measurable strict pairing

Put \(q=iyQ'/Q=-iyF''/F'=a+ib\) and
\[
 G_F(z)=F(z)-iyF'(z)/k,\quad
 J_F=\det DG_F/|F'|^2.
\]
Its real derivative columns are \(F'(k+q)/k\) and
\(iF'(k-1+q)/k\); hence
\[
 k^2J=k(k-1)+(2k-1)a+|q|^2.                       \tag{8}
\]
Away from a pole, \(\ell=\log V_\xi^F\) has
\(\Delta\ell=-k/y^2<0\), and its critical points are exactly
\(G_F(z)=\xi\). At these points
\[
 V_\xi^F=ky^{k-1}|Q_F|,\qquad
 \operatorname{Hess}\ell=\frac{k}{y^2}
 \begin{pmatrix}-(k+a)&b\\b&k-1+a\end{pmatrix},
 \quad \det\operatorname{Hess}\ell=-k^4J/y^4.       \tag{9}
\]
Thus positive \(J\) means a saddle, negative \(J\) a finite maximum.
The possible pole is not in this fiber.

For a fixed \(F\), singular values of \(G_F\) have area zero: on a
compact source box, a side-\(h\) square meeting the singular set maps,
by Taylor expansion at such a point, into an \(O(h^2)\)-thickened
segment of length \(O(h)\). There are \(O(h^{-2})\) squares, for
total covering area \(O(h)\). Exhaust the source by boxes.

On two distinct nonsingular inverse branches \(z_j(\xi)\), the
target differential of the critical log value is
\[
 d_\xi[\log V_\xi^F(z_j(\xi))](v)
       =\operatorname{Re}\frac{v}{F(z_j(\xi))-\xi}.
\]
The branch derivative in the source vanishes by criticality.
The two real linear forms are different by injectivity of \(F\);
therefore their difference has nonzero differential. Its zero set
is locally a smooth curve. Countably many inverse charts exclude
all ties on an area-null set. Thus for almost every map and target
we have compact positive superlevels, regularity, and distinct
critical values. Call such pairs good.

Goodness is Borel. Compactness is equivalent to: for every \(n\)
some compact box \(C_m=\{|x|\le m,1/m\le y\le m\}\) contains
\(\{V>1/n\}\). Failure of a containment is detected by rational
points in the open complement of \(C_m\). Bad regularity is the
projection of \(G_F(z)=\xi,J_F(z)=0,z\in C_m\). Bad ties are
projections of two roots in \(C_m\), separated by at least \(1/n\),
with equal continuous critical values from (9). All these compact
projections are closed; countable unions/intersections suffice.

For a good pair there are finitely many critical points above
every positive height. They are isolated, closed in the source,
and in a compact superlevel; they cannot accumulate at the pole,
which is not on the fiber. At a positive regular level \(\lambda\),
the boundary of \(\{V>\lambda\}\) is a compact smooth one-manifold,
thus a finite union of smooth simple closed curves. The bounded
Jordan interior of each curve lies in \(\mathbb H\).
Throughout its interior \(V>\lambda\): a lower value, or equality,
would force an interior minimum of the strictly superharmonic
\(\ell\). A small neighborhood of the possible pole can be removed
when taking the minimum since \(\ell\to+\infty\) there. Consequently
the curves cannot be nested and their interiors are exactly the
superlevel components.

The inward gradient winds once on each boundary. Applying the
closed angle form to the complement of small disks about zeros and
the pole gives
\[
 \#\text{components}
 =\#\text{finite maxima}-\#\text{saddles}+\#\text{poles}.
\]
The pole contributes \(+1\), not \(-1\). There is at most one pole,
and if present it belongs to a component. Thus maxima outnumber
saddles above every regular level. Finiteness above half a given
height extends the inequality to every positive height.

Order the saddles and the finite maxima separately by decreasing
critical value. Every point has finitely many predecessors, so
these are lists with natural-number ranks and no missing earlier
ranks. The count pairs each saddle with the maximum of the same
rank. The partner has strictly larger value because ties were
excluded. In B, lexicographic tie-breaking already gives a
non-strict pairing; using I's generic tie exclusion is a valid
strict upgrade, not a hypothesis added without proof.

For measurability, each nonsingular solution has a continuous local
branch in the parameters \((F,\xi)\): freeze the invertible real
derivative and use a uniformly contracting fixed-point map on a
small closed source ball. Second countability supplies countably
many branches. Activate a branch only if no earlier defined branch
has the same value. Signs, values, active predecessors, and finite
ranks are Borel. Equal-rank selection is therefore Borel.

If \(t=x_0+iy_0\), \(\eta=(\xi-F(t))/(y_0F'(t))\), then
\[
 G_{T_tF}(w)=\frac{G_F(t\cdot w)-F(t)}{y_0F'(t)},\quad
 J_{T_tF}(w)=J_F(t\cdot w),\quad
 V_\eta^{T_tF}(w)=y_0^{1-k}|F'(t)|V_\xi^F(t\cdot w).
\]
Goodness and all ranks correspond. The pairing \(R_F\) is thus
affine equivariant and injective on each target fiber.

## 4. Root exceptions, box exhaustion, and strict equality

Let \(\omega_F=y^{\beta-1}|Q_F|^p\), \(J_\pm=\max(\pm J,0)\).
Local diffeomorphism charts on the two nonzero-sign loci,
disjointified into Borel pieces, give for every nonnegative Borel \(h\)
\[
 \int h\omega_FJ_\pm\,dA
 =\int_{\mathbb C}\sum_{\substack{G_F(z)=\xi\\\pm J_F(z)>0}}
       h(z)y^{\beta-1}|Q_F(z)|^{p+2}\,dA(\xi).      \tag{10}
\]
There is no global properness assumption here. On a critical fiber,
\[
 y^{\beta-1}|Q|^{p+2}=(V_\xi^F/k)^{p+2},           \tag{11}
\]
since \((p+2)(k-1)=\beta-1\).

The root target is always \(G_F(i)=-i/k\); area-genericity alone
would not justify using it. In (10) restrict to a compact positive
area box and to bad targets. Its target integral is zero almost
surely. Apply (3) to the equivariant nonnegative test
\(J_+(i)1_{\{(F,-i/k)\text{ bad}\}}\) and use Tonelli. The source
density is \(y^{\beta-1}y^{-\beta}=1/y\); the box
\(\{|x|\le1,1\le y\le2\}\) has mass \(2\log2>0\).
Therefore
\[
 \mathbb E[J_+(i)1_{\{(F,-i/k)\text{ bad}\}}]=0.    \tag{12}
\]
This is a weighted assertion, not a claim that the fixed target
is good almost surely without a Jacobian factor.

On the good saddle domain \(\mathcal D\), put
\[
 c_F(z)=\left(V_{G_F(z)}^F(R_F(z))/V_{G_F(z)}^F(z)\right)^{p+2}>1,
\]
and set it to zero elsewhere. Restrict to \(\mathcal D_N\) where
\(1/N\le y'/y\le N\), \(|x'-x|\le Ny\). These Borel domains increase
to \(\mathcal D\), and their indicators and \(c\) are equivariant.
For \(B=\{|x|\le R,1\le y\le Y\}\), every selected partner lies in
\(B'=\{|x|\le R+NY,1/N\le y\le NY\}\). Multiplication by \(c\)
makes the source target-weight in (11) exactly its partner's
weight. Fiberwise injectivity, not a purported measure-preserving
property of \(R_F\), consequently gives
\[
 \int_B\omega_FJ_+c\,1_{\mathcal D_N}\,dA
       \le \int_{B'}\omega_FJ_-\,dA.
\]
Taking expectations using the actual Borel law (3) yields
\[
 2R\log Y\, A_N
 \le 2(R+NY)\log(N^2Y)\,d,\quad
 A_N=\mathbb E[J_+(i)c(i)1_{\mathcal D_N}],\
 d=\mathbb E J_-(i).                               \tag{13}
\]
The root jet is bounded on \(\mathcal K\), so \(d<\infty\).
At **fixed \(N\)**, take \(R=Y^2\) and \(Y\to\infty\). The exact ratio
\[
 (1+N/Y)(1+2\log N/\log Y)\longrightarrow1
\]
gives \(A_N\le d\). Only then let integer \(N\to\infty\). Monotone
convergence gives \(A=\mathbb E[J_+(i)c(i)1_{\mathcal D}]\le d\).
By (12), \(b=\mathbb E J_+(i)=\mathbb E[J_+(i)1_{\mathcal D}]\),
so \(b\le A\le d\). In particular
\[
 \mathbb E J(i)\le0.                               \tag{14}
\]
If equality holds, \(b=d\), and the integrable nonnegative excess
\(J_+(i)(c(i)-1)1_{\mathcal D}\) has zero expectation. It is strictly
positive wherever \(J_+(i)>0\) on \(\mathcal D\); (12) removes the
remaining positive mass. Thus \(b=d=0\) and \(J(i)=0\) almost surely.
There is no uniform lower bound on \(c-1\), nor is one needed.

Apply (3) to \(|J_F(i)|\). Its expectation is zero, the weight is
strictly positive, and \(J_{T_zF}(i)=J_F(z)\). For every fixed \(z\),
\(J_F(z)=0\) almost surely. Intersect these events over a countable
dense source set, then use continuity. We obtain
\(J_F\equiv0\) almost surely. This proves `C_AT_COMPARE`, including
all exceptional-target and exhaustion issues.

## 5. Moments and complete zero-Jacobian rigidity

Differentiate \(\mathbb E|Q_F(x+iy)|^p=y^{-\beta}\). The compact
family has uniform interior upper/lower bounds for \(Q\) and its
needed derivatives, so differentiation under the expectation is
justified even for nonintegral \(p\). Holomorphicity gives
\[
 \partial_y|Q|^p=p|Q|^p a/y,\quad
 \partial_x|Q|^p=p|Q|^p b/y,\quad
 \Delta|Q|^p=p^2|Q|^p|Q'/Q|^2.
\]
At \(i\), \(Q(i)=1\), and consequently
\[
 \mathbb E a=-\beta/p,\quad \mathbb E b=0,\quad
 \mathbb E|q|^2=\beta(\beta+1)/p^2.
\]
Combining with (8) and the actual value of \(k\) gives
\[
 k^2\mathbb E J(i)=
 \frac{(\beta+p+1)(4\beta-p^2)}{p^2(p+2)^2}.         \tag{15}
\]
For \(p=2,\beta\ge1\), (14)-(15) force \(\beta=1,k=1\)
and, by strictness, \(J\equiv0\) almost surely.
For I, \(p=1,\beta\ge1/4\) forces \(\beta=1/4,k=3/4\)
and the same zero-Jacobian conclusion.

Here is the required deterministic classification, rather than
just the special equality barrier. Suppose \(k>0\), \(F\in\mathcal K\),
and \(J_F\equiv0\). Completing the square in (8) gives
\[
 |q+k-1/2|^2=1/4.                                 \tag{16}
\]
If \(k\ne1\), the circle in (16) avoids zero: its distance from zero
is \(\delta=||k-1/2|-1/2|>0\). Thus the holomorphic
\(h=F''/F'\) has no zeros and \(|h(x+iy)|\ge\delta/y\).
The harmonic function \(u=\log|h|\) satisfies
\(u\ge\log\delta-\log y\). For \(0<\epsilon<1/2\), compare it on
\([-1,1]\times[\epsilon,1]\) with the harmonic function
\[
 b_\epsilon(x,y)=\log\delta+
 \log(1/\epsilon)\cos(\pi x/2)
 \frac{\sinh(\pi(1-y)/2)}{\sinh(\pi/2)}.
\]
On the sides and top the added term vanishes. On the bottom its
factor is between zero and one. Hence \(u\ge b_\epsilon\) on the
boundary and inside. At \(i/2\) the positive coefficient of
\(\log(1/\epsilon)\) is fixed, contradicting finite \(u(i/2)\).
This proves that \(k=1\) is necessary. It verifies I's harmonic
barrier in particular, so its remaining equality case is impossible.

At \(k=1\), equation (8) becomes
\[
 y\operatorname{Im}h+y^2|h|^2=0.
\]
If \(h\equiv0\), normalization gives \(F(z)=z-i\).
Otherwise, on any open component where \(h\ne0\),
\(\operatorname{Im}(1/h)=y\). Thus \(1/h-z\) is a real-valued
holomorphic function, a real constant \(-t\).
The identity \((z-t)h(z)=1\) extends to all of the connected
half-plane by the identity theorem. In particular \(h\) has no
zeros and \(h=1/(z-t)\), \(t\in\mathbb R\). Integrating
\(F''/F'=1/(z-t)\), then imposing the two normalizations, gives
exactly (2).

Conversely the affine map and all maps (2) have \(J\equiv0\) at
\(k=1\). The quadratics are admissible: the denominator is nonzero
for real \(t\), and
\[
 F_t(z)-F_t(w)=\frac{(z-w)(z+w-2t)}{2(i-t)}.
\]
For \(z,w\in\mathbb H\), the second factor cannot vanish since its
imaginary part is positive. Thus \(F_t\) is injective, with
\(F_t(i)=0,F'_t(i)=1\). This proves `C_AT_RIGIDITY`.

The B and I law hypotheses have now all been discharged by
Section 1, their compactness/pairing/transport hypotheses by
Sections 2-4, and their contrary expected-Jacobian signs by
(15). In B, \(\beta>1\) is impossible. In I, even equality at
\(\beta=1/4\) is impossible. This is the shared inference asked
for, not just its determinant calculation.

## 6. Existence and uniqueness of the critical law

It remains to identify the probability, not merely its deterministic
support. At \(\beta=1\), Sections 4-5 concentrate \(P\) on the affine
map \(F_\infty(z)=z-i\) and the maps \(F_t\), \(t\in\mathbb R\).
This locus is Borel. For example, on its nonaffine part the inverse
parameter is the continuous expression \(t=i-1/F''(i)\), taking real
values. Moreover \(F_t\to F_\infty\) as \(|t|\to\infty\).

The affine map is fixed by all \(T_z\), has \(|Q|=1\), and no
nonaffine map can rebase to an affine map. Apply (1) to the affine
singleton with \(y=2\). Its mass \(m\) satisfies \(m=m/2\), so \(m=0\).
We may therefore write \(P\) as a probability \(\mu\) on real vertices.
Direct calculation gives
\[
 T_{x+iy}F_t=F_{(t-x)/y},\qquad
 |Q_{F_t}(x+iy)|^2=\frac{1+t^2}{(t-x)^2+y^2}.       \tag{17}
\]
For a nonnegative Borel test \(\psi\), use the horizontal
law with the vertex test \(\Phi(s)=(1+s^2)\psi(s)\). If
\(d\lambda(t)=(1+t^2)\,d\mu(t)\), equation (17) becomes
\[
 \int\psi(t-x)\,d\lambda(t)=\int\psi(t)\,d\lambda(t).
\]
Thus \(\lambda\) is a locally finite translation-invariant Borel
measure on \(\mathbb R\).

For clarity, no Haar-measure classification is being hidden here.
All atoms of \(\lambda\) have the same mass, which must be zero by
local finiteness. The function
\(l\mapsto\lambda([0,l))\), \(l>0\), is finite, additive and
monotone, and so equals \(cl\), first for rational and then real
lengths. Translation gives every interval, and uniqueness of locally
finite Borel measures gives \(\lambda=c\,dt\). Since \(\mu\) is a
probability and \(\int_{\mathbb R}dt/(1+t^2)=\pi\), \(c=1/\pi\).
This proves uniqueness.

For existence, let \(t\) have precisely this Cauchy density. Every
map (2) is admissible, as proved above. In (17) substitute \(t=x+yu\):
\[
 \frac{1+t^2}{(t-x)^2+y^2}\,
 \frac{dt}{\pi(1+t^2)}
 =\frac1y\frac{du}{\pi(1+u^2)}.                   \tag{18}
\]
This is an equality of positive measures, hence gives (1) for
every nonnegative Borel test, with no integrability restriction.
The map \(t\mapsto F_t\) is continuous, so its pushforward is Borel.
The Cauchy probability has mass one. At the normalized point
\[
 a(i)=-1/(1+t^2),\quad |q(i)|^2=1/(1+t^2),
 \quad \mathbb E a=-1/2,\quad \mathbb E|q|^2=1/2,
 \quad J\equiv0.
\]
These agree with every endpoint moment and with the transport
equality condition. In disk coordinates \(F_0/(2i)\) becomes the
Koebe function \(z/(1-z)^2\); all the other \(F_t\) are affine
rebasings of this representative. The Cauchy vertex is uniform
boundary-parameter phase under \(t\mapsto(t-i)/(t+i)\).
This is an **affine-rebasing** Koebe orbit, not an assertion that the
normalized disk maps are rotations of Koebe: in fact their formula is
\[
 f_t(\zeta)=\frac{\zeta(1+t\zeta/(i-t))}{(1-\zeta)^2}.
\]

Combining uniqueness at \(\beta=1\), the nonexistence of \(\beta>1\),
and (18) proves the stated classification theorem.

## Certification and remaining review boundary

Run from the campaign root:

```text
$WORKSPACE/argus-live-update/.venv/bin/python research/affine_transport/verify.py
```

`verify.py` independently recomputes the saved typed Jacobian result
and replays 38 exact checks: orientation and Hessian, affine inverse
and weight exponents, general moments, the enlarged-box limit,
quadratic normalization and injectivity factorization, the full
rebasing identity, and the all-parameter Cauchy pushforward density.
It compares the result with `exact_certificate.json`, raising an
error rather than silently accepting a mismatch. There is no random
sampling, numerical quadrature, or bounded no-witness inference.

`jacobian_request.json` and `jacobian_result.json` preserve the exact
payload and typed result for operation
`matrix.symbolic.determinant.compute`, Jacobian server 0.14.0,
protocol 2025-11-25, adapter exit status zero. Its determinant was
independently recomputed, not treated as an oracle proof of transport.

`Main.lean` and `statement_fidelity.md` encode the nonuniform strict-gain
equality argument for integrable functions, finite-cutoff exhaustion,
box-factor control, both moment endpoint reductions, and quadratic
injectivity. They do not purport to encode the entire analytic
classification. The official compiler record must be read for the
actual result; the existence of the source file alone is not evidence.
The current official run in `lean_verification.json` has compiler
exit code zero, axiom-audit exit code zero, and `proof_holes=[]`,
recorded mechanically against `C_AT_FORMAL`. An earlier failed run
needed the complex-valued definition marked noncomputable; it is
superseded by this fresh successful compiler record.

The new contribution proposed for independent review is the unique
critical-law classification, with the complete shared transport
verification as its main proof mechanism. A broader spectrum
reconstruction is already known and is not the novelty claim.
The Reviewer must assess the analytic proof, replay the certificate,
and decide significance and novelty. No Reviewer verdict, campaign
acceptance, `verified_new` status, or `refutes` judgement is being
manufactured by the Engineer. `citation_check status` still reports
`C_AT_PRIOR/A_BIPS` as unchecked. Its independently readable source
excerpt is `literature/bips_theorem.txt`; the fixed official citation
archive location `research/literature/` is outside this mission's
allowlisted writable paths, so the Engineer has not written there
or bypassed the citation gate. This remains explicit handoff work,
not a completed independent attribution.
