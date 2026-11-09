# Independent cap-growth verification

**Engineer conclusion.** Proposition `prop:one-direction` has a complete
independent proof below. No false load-bearing assertion was found in the
four targeted sections. The exact certificate supports the algebra, not the
analytic arguments by itself. Independent Reviewer confirmation remains
required.

The verification sharpens two interfaces quantitatively: the coercivity
constant can be taken to be `1/256` uniformly for real `3 <= n <= 9`,
and the final contradiction admits the explicit finite-horizon bound in
Section 8. An elementary simplex normalization below removes the need to
assume John's theorem in the live proof. This does not claim a new Bernstein
classification or a verification of the full rigidity manuscript.

## Scope and known inputs

The live target is `prop:one-direction` in the September 24, 2026 rigidity
manuscript, not the full Bernstein theorem and not the dimension-ten existence
theorem. The ambient epigraph is that of a smooth strictly convex function on
an open convex domain; its graph is Euclidean complete and satisfies the
classical affine maximal equation. Models and their admissible coordinates
are exactly those in `geometry.tex`, Definition `def:model`.

The dependency chain under investigation is:
compact sections and affine limits; maximal-direction centering; cap
stationarity; the support-coordinate integral identities; nonvanishing mass;
a uniformly normalized cell bound; and a contradiction on one finite
logarithmic box for one sufficiently late smooth approximant.
No regularity of the limiting convex body may be assumed.

The original normalization uses John's ellipsoid theorem. The primary source
opened in scope was Keith Ball, *Ellipsoids of maximal volume in convex
bodies*, arXiv:math/9201217v1, Section 0, Theorem [J] and the ensuing
nonsymmetric outer-radius deduction:
<https://arxiv.org/html/math/9201217v1>. The archived short excerpt is
`evidence/ball_john_excerpt.txt`. Its contact identities imply the outer
radius is the dimension, not its square root, without a symmetry hypothesis.
An independent reader must confirm that citation before it can count as
independently checked literature evidence.

The manuscript also cites Trudinger--Wang (Invent. Math. 140 (2000),
399--422, DOI 10.1007/s002220000059), Section 6, for local area maximization.
For this target that appeal can be replaced by differentiating
`(det H)^(1/(n+2))` along a positive-definite segment and using compactly
supported stationarity. Likewise the support-coordinate formulas are to be
derived directly, not accepted from the affine Plateau literature.
The author's primary-source PDF endpoint was reachable in scope; its PDF
body was not used as a checked proposition.

The October 5, 2026 manuscript was read separately. Its main theorem depends
on `prop:reduction`, `lem:local`, `lem:autonomous`, `lem:box`, and
`prop:global`. Those dependencies remain explicitly outside this mission's verified closure. In particular, its smooth existence claim must
not be confused with the known singular Trudinger--Wang example.

No relevant affine-Bernstein page was found in the supplied inherited Wiki
index. No false manuscript assertion has been established at this scope
checkpoint. Checking only coefficient signs, inspecting an incomplete Lean
comparator, or doing finite numerical searches would not settle this target.

## Certification boundary

The intended deliverable distinguishes the analytic proof from exact symbolic
identities and from the smaller theorem actually compiled by Lean. Engineer
verification is not independent Reviewer acceptance. The Host, not this
Engineer, invokes the Reviewer.

## 1. Precise verification theorem

Let \(3\le n\le9\), let \(\Omega\subset\mathbb R^n\) be nonempty,
open and convex, and let \(u\in C^\infty(\Omega)\) have positive-definite
Hessian. Suppose its graph is complete for the induced Euclidean metric and
\[
 U^{ij}w_{ij}=0,\qquad
 U=(\det D^2u)(D^2u)^{-1},\qquad
 w=(\det D^2u)^{-(n+1)/(n+2)}.
\]
Put \(D=\{(x,z):x\in\Omega,\ z\ge u(x)\}\). Let \(\mathcal F(D)\)
be the full-dimensional local limits of invertible affine images of \(D\),
including the images themselves. Local convergence means locally uniform
convergence of distance functions.

A \(k\)-model is a member \(C\) of this family in coordinates
\((s,y)\in\mathbb R^k\times\mathbb R^{n+1-k}\) such that
\[
 \{(s,0):s_i\ge0\}\subset C\subset\{s_i\ge0\},
 \qquad C\cap\{\textstyle\sum_i s_i\le T\}\text{ is compact for every }T\ge0.
\]
**Theorem.** The largest such \(k\) is one.

All limits in this proof are limits of convex sets. Every curvature,
inverse Hessian, area density, and integration by parts is evaluated on one
of the smooth approximating boundaries, never on a nonsmooth limit.

## 2. Geometric closure, centering, and normalization

### Compact sections and elementary convergence facts

At a finite boundary point \(b\in\partial\Omega\), \(u(x)\to+\infty\).
Otherwise a sequence approaching \(b\) with bounded-above values, together
with convexity, bounds \(u(a+t(b-a))\) above for \(0\le t<1\). A tangent
plane at \(a\) bounds it below. A bounded convex function on an interval
has finite total variation: its derivative changes sign at most once.
The lifted segment therefore has length at most
\(|b-a|+\operatorname{Var}(u(a+t(b-a)))<\infty\).
Its tail is Cauchy in the complete graph metric but its base tends outside
\(\Omega\), a contradiction. This also proves that \(D\) is closed and
that its boundary is precisely the graph.

For \(g_a=u-u(a)-Du(a)\cdot(x-a)\), choose a ball of radius \(r\)
about \(a\) where \(D^2u\ge cI\). On every ray, convexity and
\(g_a(a)=0\) give
\[
 g_a(x)\ge (cr/2)|x-a|\quad (|x-a|\ge r).
\]
Thus its sublevels are bounded; the boundary blow-up makes them closed
inside \(\Omega\). The epigraph caps cut out by
\(z-u(a)-Du(a)\cdot(x-a)\le T\) are consequently compact.
These coordinates supply a \(1\)-model.

Closed convex sets meeting a fixed bounded set have locally convergent
subsequences: their distance functions are locally bounded and
1-Lipschitz, so a diagonal subsequence converges uniformly on bounded
sets. The limit is a distance function. Indeed, nearest points to any
fixed point stay bounded, and their subsequential limits realize the
limiting distance to its zero set. That zero set is closed, convex and
nonempty. A compact subset of a full-dimensional limit's interior
eventually lies in the approximating interiors: enclose a small
neighborhood of each point in a simplex inside the limit, approximate
its vertices, and use a finite cover.

These observations also give the usual two sequential characterizations
of local convergence. They are preserved by any fixed invertible affine
map. The distance-function topology is metrized by
\(\sum_{q\ge1}2^{-q}\min(1,\sup_{|X|\le q}|d_C-d_E|)\);
choosing one affine image within \(1/j\) of the \(j\)-th limit proves
that \(\mathcal F(D)\) is closed under further full-dimensional limits.

We will repeatedly use the following cap fact. If \(C_j\to C\) and
\(C\cap\{\ell\le b\}\) is bounded and contains \(q\) with \(\ell(q)<b\),
then the corresponding approximating caps are uniformly bounded and
converge in Hausdorff distance. If \(p_j\) in them escaped to infinity,
the segments from approximations \(q_j\to q\) to \(p_j\) would yield a
ray in the limit cap. This contradicts boundedness. The forward
Hausdorff inclusion now follows from local convergence. For the reverse
inclusion, approximate \((1-\eta)x+\eta q\), which is strictly below
the top, then let \(\eta\downarrow0\).

### Origin-preserving normalization without a literature assumption

Let \(K\subset\mathbb R^d\), \(d\ge1\), be compact, convex,
full-dimensional, and contain zero. Choose a simplex
\((v_0,\ldots,v_d)\) of maximum absolute determinant in \(K\).
The maximum exists by compactness and is nonzero. Put
\(P=(v_1-v_0,\ldots,v_d-v_0)\) and \(t=P^{-1}(y-v_0)\).
The transformed body contains the standard simplex. Replacing its
\(i\)-th vertex by \(y\in K\) multiplies the determinant by the
\(i\)-th barycentric coordinate. Maximality therefore bounds the absolute
value of every barycentric coordinate by one; in particular
\(|t_i|\le1\).

Set \(b=(1,\ldots,1)/(d+1)\) and
\(r=1/((d+1)\sqrt d)\). The standard simplex contains
\(\overline B_r(b)\), and \(|t-b|\le2\sqrt d\) on the transformed body.
Taking the **linear** map \(A=r^{-1}P^{-1}\), without translating the
distinguished origin, gives
\[
 \overline B_1(c)\subset AK\subset\overline B_{R_d}(c),
 \qquad R_d=2d(d+1),\qquad |c|\le R_d.
\]
The last bound uses \(0\in AK\). Hence \(AK\subset B_{2R_d}\).
The constants are coarser than John's, but no later argument requires
the sharper value.

If additionally \(-K\subset C_*K\), then
\(B_{1/C_*}(-c/C_*)\subset AK\). Its convex combination with
\(B_1(c)\), with weights \(C_*/(C_*+1)\) and \(1/(C_*+1)\),
is \(B_{2/(C_*+1)}(0)\). This proves the centered normalization
needed below, including when the origin was initially on the boundary.

### Why maximal direction number gives uniform centering

Every model admits addition of nonnegative \(s\)-directions. For
\(X\in C\) and \(v_i\ge0\), take the limit of
\((1-\eta)X+\eta(v/\eta,0)\) as \(\eta\downarrow0\).
Its fibers therefore satisfy
\[
 K_s\subset K_t\ (s\le t),\qquad K_{\lambda s}\subset\lambda K_s\
 (\lambda\ge1).
\]
Positive fibers are compact and contain zero. They are full-dimensional:
contract an interior ball toward the origin and then increase its
\(s\)-coordinates to the desired positive value.

Take the maximum direction number \(k\), which exists in
\(\{1,\ldots,n+1\}\), and suppose \(m=n+1-k>0\).
If no uniform \(C_*\) centered all positive fibers of all \(k\)-models,
choose failures \(-F_j\not\subset jF_j\), move their base points to
\(\mathbf1\) by positive diagonal changes, and use the elementary
normalization above on their transverse coordinates. There is then one
outer radius \(R\) with
\[
 B_1(c_j)\subset F_j\subset B_R,\qquad |c_j|\le R.
\]
For \(0\le s_i\le T\), \(T\ge1\), their fibers lie in \(TF_j\).
Thus their caps are uniformly bounded. A local subsequential limit
contains the orthant and a product
\([1,2]^k\times B_1(c)\), so is a full-dimensional \(k\)-model.
Its fiber \(F\) at \(\mathbf1\) is the Hausdorff limit of \(F_j\):
an approximating \((s^{(j)},y_j)\to(\mathbf1,y)\) can be contracted by
\(\min(1,1/s^{(j)}_1,\ldots,1/s^{(j)}_k)\to1\), then increased in \(s\),
to lie in the exact fiber. If \(0\) were interior to \(F\), interior
convergence and the common outer bound would contradict the failed
centering. Thus \(0\in\partial F\).

There is a supporting hyperplane for \(F\) at zero: take exterior
points tending to zero, project them to the compact convex \(F\),
and pass to a limit of the resulting unit separating normals.
The projection inequality gives a nonzero supporting normal at zero.
Make its supporting coordinate \(y_1\ge0\). Contracting
any point of the model until \(s_i\le1\), then increasing \(s\) to
\(\mathbf1\), propagates this support inequality to the entire model.
A further transverse linear change makes an interior point of \(F\)
equal to \((y_1,y')=(1,0)\). Put \(d=m-1\).
The slice
\[
 F_\epsilon=\{y':(\mathbf1,\epsilon,y')\in C\}
\]
contains \(B_{\epsilon r}(0)\) for some \(r>0\): contract an interior
ball at \((1,0)\) by \(\epsilon\), then increase \(s\).
For \(d>0\), normalize this slice by linear maps \(A_\epsilon\) to
contain a translated unit ball and have a fixed outer radius \(R'\).
For \(d=0\) omit this normalization.

In \(C_\epsilon=\{(s,r,z):(s,\epsilon r,A_\epsilon^{-1}z)\in C\}\),
all \(s_i,r\) are nonnegative. A point with \(s_i,r\le T\), \(T\ge1\),
can be increased in \(s\) and contracted to
\((\mathbf1,q,z/T)\), \(0\le q\le1\).
Also \((\mathbf1,2,0)\in C_\epsilon\) for \(\epsilon<1/2\).
Interpolating with weight \(1/(2-q)\ge1/2\) on the first point
puts it in the normalized slice at \(r=1\). Hence
\(|z|\le2TR'\). All fixed caps are uniformly bounded.

In a subsequential limit as \(\epsilon\downarrow0\), every fixed
\((s,r,0)\) with \(s_i>0,r\ge0\) is present, since it is present
before the limit whenever \(\epsilon r\le\min(1,s_1,\ldots,s_k)\).
Closedness adds the faces. The limit also contains the normalized
transverse ball at \((\mathbf1,1)\); the orthant recession property
then supplies an interior product. If \(d=0\), the orthant itself
has full dimension. Cap bounds and closure of \(\mathcal F(D)\)
therefore give a \((k+1)\)-model, a contradiction.

Consequently one uniform \(C_*\) exists. Normalize any chosen positive
fiber to
\[
 B_{r_0}\subset K_{\mathbf1}\subset B_{R_0},
 \qquad r_0=2/(C_*+1),\quad R_0=2R_m .
\]
For every fixed \(0<a<1<b\),
\(B_{ar_0}\subset K_s\subset B_{bR_0}\) on \([a,b]^k\).
A positive linear cap \(\ell(s)=\sum a_i s_i\le B\) lies in
\([0,T]^k\times B_{TR_0}\), with
\(T=\max(1,B/\min a_i)\). There is a fixed interior ball about
\((\mathbf1,0)\), using \(s_i\in[1/2,3/2]\) and the lower fiber bound.

The cap convergence and interior convergence proved above transfer
these bounds, with fixed slightly weaker constants, to every sufficiently
late smooth approximant of **each normalized model**. The constants do
not depend on the chosen fiber. The index may depend on that fiber.
For finitely many normalizations the maximum of their thresholds suffices.

## 3. Affine area, its cap identity, and its support

Write \(\delta=1/(n+2)\). For an inward conormal \(\nu\),
\(H_{ij}=\nu X_{ij}>0\), and \(\nu\xi=1\), the density is
\[
 dA=(\det H)^\delta|\det(X_1,\ldots,X_n,\xi)|^{n\delta}\,dx .
\]
Rescaling \(\nu\) cancels between the two factors. Parameter changes
have exponent \(2\delta+n\delta=1\); under an ambient affine linear
map \(L\) the density multiplies by \(|\det L|^{n\delta}\).
On the original graph use \(\nu=(-Du,1)\), obtaining
\(dA=(\det D^2u)^\delta dx\).

The cofactor of a Hessian is divergence free: differentiate its
alternating determinant expansion; symmetry of third derivatives
cancels terms in pairs. Since
\((\det D^2u)^\delta(D^2u)^{-1}=wU\), two integrations by parts
show that the graph's first variation against compactly supported
\(\eta\) is \(\delta\int\eta U^{ij}w_{ij}=0\).
Tangential variations are reparametrizations; a local graph
representation and a partition of unity cover all compactly
supported parametrized variations. Affine covariance transfers
stationarity to every affine image.

For later bounds, the affine area of a smooth positively curved convex
boundary inside \(B_R\) is at most \(C(n,R)\). Its Gauss map is injective:
two points with the same supporting normal would create a boundary
segment, contradicting positive curvature. Thus \(\int K\,dS\le|S^n|\).
On the \(2(n+1)\) sets where a signed normal component is at least
\((n+1)^{-1/2}\), projection to the corresponding coordinate hyperplane
is injective and has Jacobian at least that number. This bounds
Euclidean area by \(C(n)R^n\). Holder applied to \(dA=K^\delta dS\)
gives the claimed affine-area bound. These arguments also apply to
arbitrary measurable parts of the boundary lying in the ball.

Let \(o\) be interior, \(\ell\) affine, and let the restrictions of
\(\psi(\ell),\psi'(\ell),\psi''(\ell)\) have compact surface support.
On the original graph put
\[
 q=\ell(x,u),\quad Z=\nu(o-X)=o_{n+1}-u+(x-o')\cdot Du,\quad H=D^2u .
\]
Direct differentiation gives
\(DZ=H(x-o')\),
\(\operatorname{tr}(H^{-1}D^2Z)=n+(x-o')\cdot D\log\det H\),
and \(D^2q=\ell_zH\).
Test graph stationarity with \(Z\psi(q)\).
Integrating the \(D\log\det H\) term against
\((\det H)^\delta dx\) changes it to
\(-\delta^{-1}[n\psi+(x-o')\cdot Dq\,\psi']\).
The resulting coefficients are
\(n-n/\delta=-n(n+1)\) and \(2-1/\delta=-n\).
Also \(Z\ell_z-(x-o')\cdot Dq=\ell(o)-q\). Therefore
\[
 \int\left[
 Z|d\ell|_{H^{-1}}^2\psi''+
 n(\ell(o)-\ell(X))\psi'-n(n+1)\psi
 \right]dA=0.                                      \tag{3.1}
\]
This proves the cap identity, with its sign and normalization, on
every affine image. If \(B_{r_0}(o)\subset E\), each inward supporting
conormal satisfies \(Z\ge r_0|\nu|\): test its supporting inequality
on \(o-r_0\nu^\sharp/|\nu|\). In particular the first integrand in
(3.1) is nonnegative whenever \(\psi''\ge0\).

It is sufficient for \(\psi\) to vanish above a finite height \(b\)
when the cap \(\ell\le b\) is compact. It need not have compact
support as a function of one real variable. Its restriction and its
first two derivatives then do have compact surface support. This
distinction is essential in Section 6.

## 4. Smooth tube identities and a uniform spectral gap

Consider a smooth stationary approximant \(E\) on a positive \(s\)-box
whose compact fibers contain zero in their interiors. Fibers above
a compact subbox are uniformly bounded: otherwise segments from a
fixed \((s_0,0)\) to points escaping in \(y\) produce an infinite ray
in \(K_{s_0}\). The projection of its boundary to \(s\) has full rank.
A conormal with zero \(y\)-component would support the projection
at an interior point, although that projection contains the box.

The fiber boundaries are therefore smooth and positively curved.
For \(m>1\) their Gauss maps are diffeomorphisms: each direction has
a unique support point, and the differential is invertible by
positive curvature. Compactness and the implicit function theorem
give smooth dependence on \(s\). The support function \(h(s,e)>0\)
thus gives
\[
 X=(s,he+\nabla_Sh),\quad
 B=-D_s^2h,\quad R=\nabla_S^2h+hI,\quad \nu=(D_sh,-e).
\]
The sign is inward, since \(e\cdot y\le h(s,e)\).
Differentiating \(e\cdot Y=h\), \(e\cdot Y_s=h_s\) and
\(d_eY=R\) gives the second form \(\operatorname{diag}(B,R)\);
the mixed block is zero. Both blocks are positive definite.
Taking \(\xi=(0,-e)\) gives tangential determinant \(\det R\), so
\[
 I_0=(\det B)^\delta(\det R)^{1-\delta},\qquad
 dA=I_0\,ds\,d\omega,\qquad
 d\mu=h^{-n/2}\sqrt{\det B\det R}\,ds\,d\omega.       \tag{4.1}
\]
Here \(H/h\) is the positive metric defining \(\mu\), since the
fiber-inward vector \((0,-Y)\) has conormal value \(h\).
For \(m=1\), the two endpoint sheets are \(S^0\), with counting
measure, \(\det R=1\), and every angular derivative or trace zero.
All formulas and integrations below retain this convention.

Under \(s'=As,\ y'=Ly\), put
\(t=|L^{-\mathsf T}e|\), \(e'=L^{-\mathsf T}e/t\).
Then \(h'(As,e')=h/t\) and the new second form pulls back to \(H/t\).
Thus \(H/h\) and \(\mu\) are invariant. In particular
\[
 d\sigma=(1+\sum_i |D_s\log s_i|^2)\,d\mu,\qquad
 |\alpha|^2=h\alpha^{\mathsf T}B^{-1}\alpha          \tag{4.2}
\]
is invariant under linear transverse changes and positive diagonal
base changes.

Set
\[
 a=(\det B/\det R)^\delta,\quad f=\log(a/h),\quad
 c=(n+2)/2,\quad p=D_s\log h,\ d=D_sf,\ 
 p_e=\nabla_S\log h,\ d_e=\nabla_Sf .
\]
The angular metric is \(hR^{-1}\). The flat cofactor of \(B\) is
divergence free. The tensor \(R\) is Codazzi: commuting the ambient
derivatives of \(Y\) gives
\(\nabla_aR_{bc}=\nabla_bR_{ac}\).
The alternating cofactor expansion of any symmetric Codazzi tensor
is divergence free as well, because each differentiated term
contracts a symmetric pair against alternating indices.

Variation of \(h\) by an arbitrary compactly supported smooth
\(\eta(s,e)\) is a compactly supported surface variation; positivity
persists for sufficiently small parameter. Using the two cofactor
identities in its first variation gives
\[
 -(\operatorname{cof}B):D_s^2(a^{-(n+1)})
 +(n+1)(\operatorname{cof}R):(\nabla_S^2a+aI)=0.      \tag{4.3}
\]
For \(m=1\) the second term is absent. Divide by \((n+1)I_0\),
put \(\log a=\log h+f\), and use
\[
 T_s\log h=-k-|p|^2,\quad
 T_e\log h=n-k-h\operatorname{tr}R^{-1}-|p_e|^2,
\]
where \(T_s=hB^{-1}:D_s^2\), \(T_e=hR^{-1}:\nabla_S^2\).
The result is
\[
 n-2k+T_sf-|p|^2-(n+1)|p+d|^2
       +T_ef+2\langle p_e,d_e\rangle+|d_e|^2=0.     \tag{4.4}
\]
The matrix densities are
\(\mu_0hB^{-1}=(\operatorname{cof}B)h^{-n}e^{-cf}\)
and \(\mu_0hR^{-1}=(\operatorname{cof}R)h^2e^{cf}\).
Consequently, for a compactly supported \(v=v(s)\),
\[
 \begin{split}
 \int v^2T_sg\,d\mu
 &=\int[v^2\langle np+cd,D_sg\rangle
                   -2v\langle D_sv,D_sg\rangle]\,d\mu,\\
 \int v^2T_eg\,d\mu
 &=-\int v^2\langle2p_e+cd_e,\nabla_Sg\rangle\,d\mu .
 \end{split}                                      \tag{4.5}
\]
There are no angular boundary terms, including on \(S^0\).

Taking \(g=\log h\) in the first identity and integrating (4.4)
using \(g=f\) gives respectively
\[
 \begin{split}
 \int v^2[k+(n+1)|p|^2+c\langle p,d\rangle]\,d\mu
     &=2\int v\langle D_sv,p\rangle\,d\mu,\\
 \int v^2[\tfrac n2(|d|^2+|d_e|^2)
    +(n+2)(|p|^2+\langle p,d\rangle)-(n-2k)]\,d\mu
     &=-2\int v\langle D_sv,d\rangle\,d\mu .
 \end{split}                                      \tag{4.6}
\]
Subtracting twice the first identity from the second cancels
the mixed product exactly. Add \(2\lambda/n\) times that difference
back to the first, with \(\lambda=15/16\). The left integrand is
\[
 F=k-15/8+(n-7/8)|p|^2+(n+2)\langle p,d\rangle/2
                  +(15/16)(|d|^2+|d_e|^2),         \tag{4.7}
\]
and the right side is
\(\int v\langle D_sv,(2-15/(2n))p-(15/(4n))d\rangle\,d\mu\).

The paired coefficient matrix has determinant
\[
 \frac7{128}+\frac{(n-2)(9-n)}{16}\ge\frac7{128}.
\]
Subtracting \(\kappa I\), \(\kappa=1/256\), leaves positive first
diagonal entry and determinant at least \(1265/65536\) for
every **real** \(3\le n\le9\). The completed-square identity
\[
 a(ap^2+2cpd+bd^2)=(ap+cd)^2+(ab-c^2)d^2
\]
therefore proves, in arbitrary orthonormal frames,
\[
 F\ge\kappa(1+|p|^2+|d|^2+|d_e|^2)\quad(k\ge2).    \tag{4.8}
\]
These universal inequalities, not only their rational coefficients,
are compiled in `Main.lean`.

The squared coefficients on the right of (4.7) sum to at most 6
on this dimension interval. Young's inequality absorbs half of
(4.8), proving
\[
 \int v^2(1+|p|^2+|d|^2+|d_e|^2)\,d\mu
       \le C_E\int|D_sv|^2\,d\mu,\qquad C_E=6/\kappa^2.       \tag{4.9}
\]
For \(\alpha_i=\log s_i\), \(T_s\alpha_i=-|D_s\alpha_i|^2\).
Equation (4.5) gives
\[
 \int v^2|D_s\alpha_i|^2\,d\mu
 =-\int v^2\langle np+cd,D_s\alpha_i\rangle\,d\mu
       +2\int v\langle D_sv,D_s\alpha_i\rangle\,d\mu .
\]
Young with coefficient \(1/2\), followed by (4.9), bounds this by
\([2(n^2+c^2)C_E+8]\int|D_sv|^2d\mu\).
Summing and using \(k\le n\) proves
\[
 \int v^2d\sigma\le C_n\int|D_sv|^2d\mu,\quad
 C_n=C_E+n[2(n^2+c^2)C_E+8].
\]
Finally \(v(s)=\widetilde v(\log s)\) satisfies
\(|D_sv|^2\le|\nabla\widetilde v|^2\sum_i|D_s\alpha_i|^2\)
by Cauchy--Schwarz in the positive inner product. Thus
\[
 \int\widetilde v(\log s)^2d\sigma
       \le C_n\int|\nabla\widetilde v(\log s)|^2d\sigma .      \tag{4.10}
\]
Every test is compactly supported on the smooth tube. Completeness
of its invariant metric has not been used.

## 5. Nonvanishing mass and removal of the all-direction case

First consider any full-dimensional convex limit \(C\) with a compact
cap \(\ell\le b\), where \(\ell\) is nonzero and linear, containing an interior ball \(B_r(o)\)
strictly below its top. Its smooth approximants \(D_j\) have uniformly
bounded caps and, after shrinking the ball once, contain the same ball.
Let \(e_j\) be the unit image of the original upward vertical.
It is a recession direction and the boundary is graphical along it.
Uniform cap boundedness and the ray \(o+te_j\) imply
\(\ell(e_j)\ge c>0\): a nonpositive value makes the entire ray
stay in the cap, and a positive value tending to zero produces
arbitrarily long initial segments there.

Put \(V_j=e_j/\ell(e_j)\) and use coordinates
\(X=\zeta+\tau V_j\), \(\zeta\in\ker\ell\).
Both coordinate maps are uniformly bounded, and their absolute
determinants equal \(1/|\ell|\).
The boundary is the graph of a smooth strictly convex \(g_j\).
The bases \(E_j=\{g_j<b\}\) are uniformly bounded, and their closed
sublevels at levels at most \(b\) are compact inside their domains.
This follows from the compact ambient caps and the closed graphical
boundary. With \(\zeta_j=o-\ell(o)V_j\), the common ball gives
\(g_j\le b-\epsilon_0\) on \(B_r(\zeta_j)\), for a fixed
\(\epsilon_0>0\).

Choose \(\alpha>0\) uniformly small so that
\[
 q_j=b-2\epsilon_0/3+\alpha|\zeta-\zeta_j|^2
       \in[b-2\epsilon_0/3,b-\epsilon_0/3]\quad\hbox{on }E_j.
\]
Choose a smooth convex regularization \(\chi\) of the positive part,
equal to zero below \(-\eta\), equal to its argument above \(\eta\),
and with \(0\le\chi'\le1\), where \(0<\eta<\epsilon_0/6\).
Then \(\widetilde g_j=g_j+\chi(q_j-g_j)\) equals \(q_j\)
on the indicated ball and equals \(g_j\) near the cap top.
The perturbation has compact support in
\(\{g_j\le b-\epsilon_0/6\}\).
Its Hessian is
\((1-\chi')D^2g_j+\chi'D^2q_j
 +\chi''D(q_j-g_j)\otimes D(q_j-g_j)>0\).

For completeness, \(F(H)=(\det H)^\delta\) is concave on positive
matrices. Its second derivative in direction \(K\) is
\[
 \delta F(H)\{\delta(\operatorname{tr}H^{-1}K)^2
                 -\operatorname{tr}[(H^{-1/2}KH^{-1/2})^2]\}\le0,
\]
using \((\operatorname{tr}L)^2\le n\operatorname{tr}(L^2)\)
for symmetric \(L\), and \(n\delta<1\).
Concavity along the segment and compactly supported stationarity
therefore give
\(\int_{E_j}F(D^2g_j)\ge\int_{E_j}F(D^2\widetilde g_j)\).
The latter is at least
\(|B_r|(2\alpha)^{n\delta}>0\). Affine covariance with the fixed
coordinate determinant proves a positive affine-area lower bound
on the approximant cap. This argument needs no regularity of \(C\).

Now let \(C\) be a maximal \(k\)-model. Choose a compact cap
\(\ell_0=\sum_i s_i<b\) containing an interior ball. Its smooth
approximants have affine area at least \(c>0\) there. For each
fixed \(\epsilon>0\), eventually every \(s_i\ge-\epsilon\) on
the cap. On the part where \(s_i\le\epsilon\), stretch that one
coordinate by \(1/\epsilon\). This part lies in a fixed ball,
independent of \(\epsilon\), since the other coordinates already
have a common cap bound. Area covariance and the ball estimate give
\[
 A_j(\ell_0<b,\ s_i\le\epsilon)\le C\epsilon^{n\delta}.       \tag{5.1}
\]
Choose \(\epsilon\) so that the sum of these \(k\) bounds is
less than \(c/2\), then choose \(j\) sufficiently large.
Area at least \(c/2\) remains in a fixed bounded region with all
\(s_i>\epsilon\).

If \(k=n+1\), the model is exactly the nonnegative orthant.
The remaining region is compactly inside its interior and
eventually inside \(\operatorname{int}D_j\), so cannot contain
boundary area. This contradiction proves \(k\le n\), hence \(m\ge1\).

For \(2\le k\le n\), centering supplies support coordinates on any
fixed positive box \(Q\), with uniform upper and lower bounds on \(h\).
Choose \(Q\) to contain the remaining area just found.
The angular Jacobian satisfies
\(\int_{Q\times S^{m-1}}\det R\le C\): it is the Euclidean surface
area of a uniformly bounded convex fiber, bounded by the projection
argument of Section 3 in dimension \(m\). For \(m=1\) it counts
two endpoints. The exact factorization
\[
 I_0=\mu_0^{2\delta}h^{n\delta}(\det R)^{1-2\delta}
\]
and Holder with exponents \(1/(2\delta)\) and \(1/(1-2\delta)\)
give \(c/2\le C\mu_j(Q)^{2\delta}\).
Since \(\sigma_j\ge\mu_j\), there are fixed \(L_0,c_0>0\) with
\[
 \sigma_j(Q_{L_0})\ge c_0,\qquad
 Q_L=\{s:|\log s|_\infty\le L\},                         \tag{5.2}
\]
for every sufficiently late approximant.

## 6. The normalized inverse-Hessian and cell estimate

This section proves a useful standalone statement in **every**
dimension \(n\ge2\), not only the coercive range. Let each \(E\) be
a closed full-dimensional convex body in \(\mathbb R^{n+1}\) whose
boundary is smooth, positively curved, and stationary for affine
area under compactly supported variations. Suppose this family has, on
\([1/4,4]^k\), positive fibers and uniform bounds
\(c_1\le h\le C_1\), a fixed ball \(B_{r_0}(\mathbf1,0)\) inside
the bodies, and compact caps with one uniform outer radius for the
finitely many positive linear forms below, at one fixed top
\(b_0>2(k+1)\). For \(1\le k\le n\), these hypotheses
give a uniform bound for \(\sigma([1/2,2]^k)\).
For \(k=1\), the zero-order principal minor used below is simply 1.

Put \(Q=[1/2,2]^k\), \(a_r=\mathbf1+e_r\), and
\(\ell_r=a_r\cdot s\). Their values on \(Q\) belong to
\(J=[(k+1)/2,2(k+1)]\).
Choose \(b_0>2(k+1)\) and a nonnegative smooth \(\rho\),
supported below \(b_0\), with \(\rho\ge1\) on \(J\). Define
\[
 \psi(t)=\int_t^{b_0}(r-t)\rho(r)\,dr .
\]
Then \(\psi''=\rho\ge0\), \(\psi=0\) above \(b_0\).
Although it is affine far below, the uniform compact cap makes
its surface test admissible in (3.1). On that cap the values of
\(\ell_r,\psi,\psi'\) are uniformly bounded, and the cap area
is uniformly bounded by Section 3.

The first term of (3.1) is nonnegative on the whole cap.
On the tube use exactly the inward conormal
\(\nu=(D_sh,-e)\), for which \(|\nu|\ge1\) and
\[
 Z\ge r_0,\qquad
 |d\ell_r|_{H^{-1}}^2=a_r^{\mathsf T}B^{-1}a_r .
\]
The other terms of (3.1) have bounded absolute integrals.
Dropping the complement of the tube and using \(\rho\ge1\)
therefore bounds
\(\int_{Q\times S^{m-1}}I_0 a_r^{\mathsf T}B^{-1}a_r\le C\).
The exact identity
\[
 \sum_r a_ra_r^{\mathsf T}=I+(k+2)\mathbf1\mathbf1^{\mathsf T}
\]
implies
\(\sum_r a_r^{\mathsf T}B^{-1}a_r
=\operatorname{tr}B^{-1}+(k+2)\mathbf1^{\mathsf T}B^{-1}\mathbf1
\ge\operatorname{tr}B^{-1}\). Hence
\[
 \int I_0\,t_B\le C,\qquad t_B=\operatorname{tr}B^{-1}.       \tag{6.1}
\]
There is **no pointwise lower bound on eigenvalues of \(B\)** here.
The cap identity controls the required integral instead.

For fixed \(e\), \(q=-h(\cdot,e)\) is strictly convex.
Its bounded values on the larger box bound each gradient component
on \(Q\), by one-dimensional convex difference quotients at distance
at least \(1/4\). For a principal coordinate set \(I\), hold unused
coordinates fixed. The partial gradient of \(q\) is injective,
since its Hessian \(B_{II}>0\). It is a local diffeomorphism and its
image is contained in a fixed bounded cube. Change of variables
therefore bounds \(\int\det B_{II}\) in the selected variables.
Integrate in the remaining variables and in \(e\).
The full minor and the sum of the order-\((k-1)\) principal minors give
\[
 \int \det B\,(1+t_B)\le C.                              \tag{6.2}
\]
This uses only bounded gradients, not bounded Hessians.
The fiber surface-area bound also gives
\(\int\det R\le C\). Cauchy--Schwarz now controls
\(\int\sqrt{\det B\det R}\).

For the weighted term put
\(\theta=(n+2)/(2(n+1))\in(0,1)\).
For **all** positive \(D,R,t\),
\[
 \sqrt{DR}\,t
   =(D^\delta R^{1-\delta}t)^\theta(Dt)^{1-\theta}.          \tag{6.3}
\]
Both determinant exponents on the right are \(1/2\), and the
exponent of \(t\) is 1. This universal identity, including its
positivity hypotheses, is proved in Lean. Taking
\(D=\det B,\ R=\det R,\ t=t_B\), Holder and (6.1)--(6.2) give
\[
 \int\sqrt{\det B\det R}\,t_B
 \le(\int I_0t_B)^\theta(\int\det B\,t_B)^{1-\theta}\le C .
\]
Since \(h\ge c_1,\ h\le C_1,\ s_i^{-2}\le4\) on \(Q\),
(4.1)--(4.2) imply
\[
 \sigma(Q)\le c_1^{-n/2}
       \int\sqrt{\det B\det R}\,(1+4C_1t_B)\le C.          \tag{6.4}
\]
This proves the standalone local cell theorem.

For a maximal model, Section 2 supplies precisely these uniform
hypotheses after normalizing any fiber at \(s=e^a\).
Apply the same linear map to its approximants. Invariance of
\(\sigma\) gives a constant \(C_{\rm cell}\), independent of
\(a\in\mathbb R^k\), bounding the cell
\(\tfrac12e^{a_i}\le s_i\le2e^{a_i}\) for all sufficiently late
\(j\). Only that index depends on \(a\).

## 7. Polynomial bounds and finite shell iteration

For fixed integer \(L\ge1\), cells centered at the integer lattice
points of \([-L,L]^k\) cover the logarithmic box, since
\(1/2<\log2\). There are \((2L+1)^k\le3^k(L+1)^k\)
such cells. Their **finite** set of thresholds has a maximum.
Thus, with \(C_{\rm box}=3^kC_{\rm cell}\),
\[
 \sigma_j(Q_L)\le C_{\rm box}(L+1)^k                       \tag{7.1}
\]
for all sufficiently late \(j\), with the threshold allowed to
depend on this fixed \(L\).

Choose smooth cutoffs equal to 1 on \([-l,l]^k\), supported in
\((-l-1,l+1)^k\), with squared gradient at most \(4k\).
For example smooth a one-dimensional ramp of slope 2 with
transition strictly inside a unit interval and take products.
Their gradients lie in the intervening shell.
Equation (4.10) gives
\[
 \sigma_j(Q_l)\le4kC_n[\sigma_j(Q_{l+1})-\sigma_j(Q_l)] .
\]
Boundary cubes have zero mass because a fixed approximant has
a smooth density. Put \(q=1+(4kC_n)^{-1}>1\) and choose an
integer \(l_0\ge\max(1,L_0)\).
For a **fixed** \(j\) on which all the finite required estimates
hold, induction yields
\[
 \sigma_j(Q_{l_0+N})\ge c_0q^N.                           \tag{7.2}
\]
`recurrence_lower` and `finite_box_contradiction` in Lean encode
exactly this finite induction, not an infinite family of estimates
on an approximant that has not been chosen.

## 8. An explicit finite horizon and the order of quantifiers

Let \(\epsilon=q-1>0\). Choose an integer \(N\) with
\[
 N\ge2(k+1),\qquad N\ge l_0+1,\qquad
 N>\frac{C_{\rm box}}{c_0}
       \frac{2^{2k+1}(k+1)!}{\epsilon^{k+1}}.              \tag{8.1}
\]
Such a finite integer exists by the Archimedean property.
The binomial theorem and \(N-j\ge N/2\), \(0\le j\le k\),
give
\[
 q^N\ge {N\choose k+1}\epsilon^{k+1}
 \ge\frac{(N/2)^{k+1}\epsilon^{k+1}}{(k+1)!}
 >\frac{C_{\rm box}}{c_0}(2N)^k
 \ge\frac{C_{\rm box}}{c_0}(l_0+N+1)^k.                  \tag{8.2}
\]
Set \(L=l_0+N\) **now**. There are finitely many cells through
\(Q_L\) and finitely many shell inequalities from \(l_0\) to \(L-1\).
Choose a single \(j\) above the maximum of:
the initial positive-mass threshold, every cell threshold just
listed, and the threshold for tube coordinates on a slightly larger
box \(Q_{L+2}\).
Equations (7.1) and (7.2) for this same \(j\) contradict (8.2).

The quantifiers are thus:
\[
 \exists c_0>0,\ C_{\rm box}>0,\ q>1,\ l_0\in\mathbb N\
 \exists N<\infty\
 \exists J(N)\
 \forall j\ge J(N)\quad\text{contradiction}.
\]
There is no assertion of a single threshold valid on every box,
no passage of inverse Hessians to a convex limit, and no
interchange of an infinite-box limit with \(j\to\infty\).
This excludes every maximal \(k\ge2\). A \(1\)-model exists,
so the theorem is proved.

## 9. Exact evidence, limitations, and comparison

`verify.py --write` generates `exact_certificate.json`;
`verify.py --check` replays and compares it. The script certifies
16 symbolic identities, the shifted coercivity determinants in all
seven dimensions, eight cap-testing frames and their exact inverses,
21 exact paraboloid cap-integral calibrations, and 140 strictly
positive anisotropic determinant cases. The finite-horizon examples
use synthetic rational constants and the binomial lower bound;
they are not measured constants of any hypothetical graph.
The calibrations and anisotropic cases are checks, not proofs of
the analytic statements. The universal interpolation, coercivity,
frame identity, and finite induction have the separate Lean proof.

Jacobian 0.14.0, protocol 2025-11-25, was discovered and its exact
`matrix.inverse.compute` contract inspected before the custom
certificate was written. One bounded run inverted the three-direction
frame Gram matrix \(I+5\mathbf1\mathbf1^{\mathsf T}\), returning
\(I-(5/16)\mathbf1\mathbf1^{\mathsf T}\), with adapter exit code 0.
Its payload, typed response, contract, and exit status are separate
JSON files in `evidence/`. `verify.py` independently multiplies both
matrix orders exactly. This is a linear-algebra calibration, not an
analytic solver verdict.

Lean 4.31.0 actually compiled the source with exit code 0,
`proof_holes=[]`, and a successful axiom audit. The immutable
certificate recorded on `C_FORMAL_CORE` is
`evidence/lean/certificates/C_FORMAL_CORE-a4a3a774706de53b.json`.
Its source and statement-fidelity document are pinned by the
compiler-generated digests. The compilation has not been relabeled
as a formal proof of `C_ONE_DIRECTION`.

Compared with the strongest prior result relevant here, the staged
manuscript already claims the same no-multiple-direction conclusion.
This work supplies an independently reconstructed dependency-closed
analytic proof, an alternative elementary normalization, universal
formalized interfaces, a dimension-uniform numerical coercivity
constant, and a constructive finite horizon. It does not strengthen
the Bernstein conclusion, assert novelty of the dimension-ten
construction, or claim that a finite computation proves a global
analytic theorem.

The live proof uses only elementary finite-dimensional convexity,
compactness, smooth calculus, change of variables, and Holder/Young
inequalities as derived or applied above; it does not depend on the
John literature checkpoint or the cited interior PDE estimates.
The independent Reviewer must check the analytic proof and statement
fidelity, replay the exact script, and confirm any literature claim
retained for the separate scope checkpoint. No `F_<LABEL>` has been
created, because no literal false manuscript assertion was established.
All full-rigidity rescaling and dimension-ten construction nodes remain
outside the live proof's closure.
