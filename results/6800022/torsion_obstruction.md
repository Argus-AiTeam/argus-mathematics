# Global obstruction on the reciprocal four-torsion period curve

## Theorem

No regular degree-four solution of equation (17) in `reduction.md`, with
four nonzero catenoidal weights, is globally embedded. The conclusion
includes asymmetric coefficients, every finite torus modulus, and repeated
logarithmic growths.

Together with the independently reviewed local and period reduction in
`reduction.md`, this excludes every potentially globally embedded member of
the normalized nonzero-spin Kato--Muroya locus with
\(I(z)=1/\overline z\), a common unoriented end-normal axis, and
\(N_1+N_2+2N_3=4,\ N_1+N_2>0\).

This is a scoped obstruction, not the general Hoffman--Meeks end-count
conjecture and not an embedded counterexample. Independent review of this
extension and a novelty/significance determination are still required.

The improvement over the previous result is the decision of the retained
stratum, not another numerical search: the two quadratic periods define a
compact real curve; every possible embeddedness chamber has an excluded
CCCC anchor. A removable-end degeneration and an equal-growth endpoint
cannot support an otherwise isolated embedded member.

## 1. Data, periods, and a controlled extension of the parameter space

Fix an arbitrary \(\rho>1\), and set
\[
 r=\rho^2,\quad s=-\rho,\quad L=\log r,\quad
 E=\mathbb C^\times/r^{\mathbb Z}.
\]
All kernels below are the signed source kernels (2) of `reduction.md`.
Put
\[
\begin{split}
 a&=h_1(1,1)>0,&
 b&=\sqrt\rho\,h_1(1,-\rho)>0,&
 c&=a-1/L<0,\\
 j&=h(1,-1)>0,&
 H&=-\sqrt\rho\,h(1,\rho)>0.                              \tag{18}
\end{split}
\]
The first three signs are exactly those already proved in the reviewed
off-real certificate, Section 4.2. The last two also have short independent
checks. With \(\ell=\log\rho\),
\[
 j=\frac12+\sum_{n\ge1}(-1)^n\operatorname{sech}(n\ell)
   =\frac{\pi}{2\ell}\sum_{m\in\mathbb Z}
       \operatorname{sech}\frac{(2m+1)\pi^2}{2\ell}>0,
 \quad
 H=\sum_{n\ge0}(-1)^n\operatorname{csch}((n+\tfrac12)\ell)>0.
                                                               \tag{19}
\]
The first equality uses the two absolutely convergent kernel tails and
Poisson summation for \(\operatorname{sech}\); the second positivity is
the strictly decreasing alternating series. These arguments work for
every \(\ell>0\).

For real vectors \(A=(A_1,A_2)\ne0\) and \(B=(B_1,B_2)\ne0\), define
\[
\begin{split}
 U_A(z)&=A_1h(z,1)+\sqrt\rho A_2h(z,-\rho),\\
 V_B(z)&=-B_1h(z,-1)-\sqrt\rho B_2h(z,\rho),\\
 \Phi&=(U_A^2-V_B^2,\ i(U_A^2+V_B^2),\ 2U_AV_B)\,dz .
\end{split}                                                     \tag{20}
\]
Up to congruence and a nonzero common scale, this is the datum in (8)
at \(\phi=\pi\), with \(A=(1,t/\sqrt\rho)\) and
\(B=C(1,u/\sqrt\rho)\). Thus no asymmetric coefficient was discarded.
The third coordinate in (20) is the common normal-axis coordinate.
For ordering we take height to be its negative, an ambient reflection.
With this convention the logarithmic height coefficients are exactly
\(2\lambda_i\) in (29), with a positive common factor.

For
\[
 M=\begin{pmatrix}a&b\\b&-a\end{pmatrix},\qquad
 N=\begin{pmatrix}c&b\\b&-c\end{pmatrix},
\]
the complete remaining periods are exactly
\[
 q_M(A)=q_M(B),\qquad q_N(A)=-q_N(B),\qquad
                         q_T(v)=v^TTv.                        \tag{21}
\]
This follows from (17), dividing its radial equation by \(L>0\).
Its circular imaginary part is already zero at these four punctures;
no extra cycle was omitted.

For a continuation argument only, allow a coefficient to pass through
zero and allow a catenoidal weight to become zero. These are not new
admissible witnesses for the mission. Below we prove exactly what happens:
a single zero coefficient removes one end at a regular point; a zero
weight with a nonzero pole coefficient is an ordinary planar end. Away
from coefficient zeros, the four ends and degree four are retained.

## 2. Two CCCC anchors give the strict constant inequalities

We use two already reviewed facts about the authenticated CCCC family:

1. Its full real equatorial period is
   \[
   P(D,\alpha)=C_D(\alpha^2-D)+2E_D\alpha,\quad C_D,E_D>0,\quad D>1.
   \]
   Its positive root satisfies \(1<\alpha_0(D)<\sqrt D\), and its
   negative root is \(-D/\alpha_0(D)\).
2. Both roots represent the same surface up to the exact half-period
   reparameterization, scale, and end relabeling; every such member has
   an actual meridian/end intersection.

These are `CCCC-PERIOD-LOCUS` and `CCCC-EXHAUSTED`, proved in
`../romon-wohlgemuth-cccc/obstruction.md`, not a new attribution to
Kato--Muroya. The two anchor identifications below also use the reviewed
off-real normal-form argument: a perpendicular reflection exchanging the
two opposite-normal pairs gives the CCCC data. To make clear that this is
an identification of full data rather than punctures alone, we give the
quotient and zero fibers explicitly.

Let
\[
 \delta=\arctan(j/H)\in(0,\pi/2),\quad
 v=\frac{\sqrt{j^2+H^2}+j}{H}
   =\tan(\pi/4+\delta/2)>1,\quad D=v^2.
\]
The elliptic function
\[
 F(z)=h(z,-\rho)/h(z,1)
\]
has degree two, with values
\[
 F(1)=0,\quad F(-\rho)=\infty,\quad
 F(-1)=-H/(\sqrt\rho j),\quad
 F(\rho)=j/(\sqrt\rho H).
\]
It is the quotient by \(z\mapsto1/z\). The real coordinate
\[
 x=D\,\frac{F+1/(\sqrt\rho v)}{F-v/\sqrt\rho}
                                                               \tag{22}
\]
therefore has branch values
\[
 x(1)=-1,\quad x(-\rho)=D,\quad
 x(-1)=1,\quad x(\rho)=-D .
\]
The quotient curve is \(w^2=(x^2-1)(x^2-D^2)\).
Translation by \(-1\) sends \(x\) to \(-x\); translation by \(\rho\)
sends \(x\) to \(D/x\).

For \(A=(\cos\theta,\sin\theta)\), its zero fiber is
\[
 x=\beta(\theta)
   =v\,\frac{v-\tan\theta}{1+v\tan\theta}.                       \tag{23}
\]
The spinor identity \(V_B(z)=U_B(-z)\) determines the other zero
fiber. In particular:

* If \(B=A\) and
  \(\theta=\theta_N=\tfrac12\arctan(-c/b)\in(0,\pi/4)\), (21)
  holds. The antiholomorphic involution \(z\mapsto-\overline z\)
  exchanges \(U\) and \(V\), so it is a reflection perpendicular to
  the end axis. The zero fibers are \(x=\beta,-\beta\).
* If \(B=(A_2,-A_1)\) and
  \(\theta=\theta_M=\pi/4+\tfrac12\arctan(b/a)\in(\pi/4,\pi/2)\),
  (21) holds. The identities
  \(U_A(\rho z)=-V_B(z)/\sqrt\rho\) and
  \(V_B(\rho z)=U_A(z)/\sqrt\rho\), combined with the original
  vertical reflection, give the perpendicular reflection
  \(z\mapsto\rho/\overline z\). Use
  \[
  p=\frac{v+1}{v-1},\quad D_*=p^2,\quad
  y=-p\,\frac{x-v}{x+v}.
  \]
  Then \((q_2,q_1,q_3,q_4)\) have branch values
  \((-1,D_*,1,-D_*)\), and the two zero fibers are
  \(y=\beta_*,-\beta_*\), where
  \[
  \beta_*(\theta)=p\,\frac{p\tan\theta-1}{p+\tan\theta}>0 .
                                                               \tag{24}
  \]

In the first case \(\beta>0\); the second inequality in (24)
uses \(\theta>\pi/4\) and \(p>1\).

Here is the remaining full-data check. A spinor square with zero fiber
\(\beta\) and poles at the first two branch points is necessarily
\[
 C\,\frac{(x-\beta)^2}{(x+1)(x-D)}\,\frac{dx}{w}.
 \]
The other spinor square has the opposite zero fiber and the other
two branch poles. The perpendicular reflection gives unit modulus for
their relative Gauss-map constant; an axial rotation makes that constant
one, while the real height residues make \(C\) real. Thus the
Weierstrass data are exactly the CCCC normal form with
\(\alpha=-\beta\), or with \(D_*,\alpha=-\beta_*\) in the second
coordinate. There is no zero-residue circularity in fixing that real
phase: at the first anchor the residue at \(q_2\) is a nonzero
multiple of
\(-\sin\theta(H\cos\theta+j\sin\theta)\), and at the second anchor
the residue at \(q_1\) is a nonzero multiple of
\(\cos\theta(j\sin\theta+H\cos\theta)\).

More explicitly, after the axial rotation the full normal form is
\[
 g=\frac{(x+\beta)(x+1)(x-D)}{(x-\beta)w},\quad
 \eta=C\,\frac{(x-\beta)^2}{(x+1)(x-D)}\,\frac{dx}{w},\quad
 g\eta=C\,\frac{x^2-\beta^2}{(x^2-1)(x^2-D^2)}\,dx .
 \]
The functional identity \(g(-\overline x,\overline w)
=1/\overline{g(x,w)}\) verifies the unit-modulus conclusion.
The same period quadratic holds even at a zero-weight
boundary; its roots above lie strictly away from all branch values, so
no such boundary is a period root at either anchor.

It follows that \(\beta>v\) and \(\beta_*>p\). From (23)--(24),
respectively, these inequalities are precisely
\[
 \theta_N<\delta/2,\qquad
 \theta_M>\pi/4+\delta/2 .
 \]
Consequently, with
\[
 \alpha_N=\arctan(-c/b),\qquad
 \alpha_M=\arctan(b/a),\qquad K=ac+b^2,
\]
we have the decisive strict inequalities
\[
 0<\alpha_N<\delta<\alpha_M<\pi/2,\qquad K>0.                  \tag{25}
\]
This obtains the signs from the reviewed exact CCCC period theorem,
not from sampled torus constants. All four sign variants of these
anchors are congruent CCCC members and hence are not embedded.

## 3. The whole real period curve and regularity

Identify \(A\) and \(B\) with complex numbers. If \(A^2=X+iY\),
(21) is equivalent to
\[
 B^2=\mathcal R(A^2),\qquad
 \mathcal R\binom XY=
 \begin{pmatrix}
 (a+c)/(a-c)&2b/(a-c)\\
 -2ac/[b(a-c)]&-(a+c)/(a-c)
 \end{pmatrix}\binom XY .                                    \tag{26}
\]
The matrix is an invertible real reflection: its square is the
identity and its determinant is \(-1\). Both off-diagonal entries
are positive. In particular, \(A=0\) iff \(B=0\), which is the
discarded zero datum.

Normalize \(|A|=1\). For either continuous square-root choice of
\(\mathcal R(A^2)\), write
\[
 A=e^{i\theta},\quad B=t_0e^{i\psi},\quad
 \alpha=\theta+\psi,\quad \gamma=\theta-\psi,\quad t_0>0.
 \]
Indeed
\[
 \operatorname{Im}\{(AB)^2\}
 =\mathcal R_{21}X^2+\mathcal R_{12}Y^2>0.
 \]
Changing \(B\) to \(-B\), which reflects the immersion's height
coordinate, lets us choose \(\alpha\in(0,\pi/2)\).

The angle \(\psi\) strictly decreases as \(\theta\) increases,
because an orientation-reversing invertible real linear map has
argument derivative
\(-1/|\mathcal R(e^{2i\theta})|^2\) here. As \(\theta\) traverses
an interval of length \(\pi\), \(\psi\) decreases by \(\pi\).
Thus \(\gamma\) traverses a circle once, with strictly positive
derivative. This parametrizes the entire projective period curve;
the other square-root choice is its height-reflected copy.

Eliminating the positive amplitude gives
\[
 f(\alpha):=(a\cos\alpha+b\sin\alpha)
             (c\cos\alpha+b\sin\alpha)=K\sin^2\gamma.           \tag{27}
\]
There is exactly one \(\alpha\) in
\([\alpha_N,\alpha_M]\) for each right-hand side. On this interval
the first factor is positive and nondecreasing, and the second is
nonnegative and strictly increasing. Moreover \(f(\alpha_N)=0\)
and \(f(\alpha_M)=K\). Outside this interval in \((0,\pi/2)\),
\(f<0\) or \(f>K\), respectively. Thus (27) describes the whole
curve without extra branches. It is symmetric under
\(\gamma\mapsto-\gamma\) and \(\gamma\mapsto\pi-\gamma\).

**No common spinor zero.** Equation (22), or directly the degree-two
function \(F\), gives
\[
 F(-z)=
 \frac{j}{\sqrt\rho H}\,
 \frac{F(z)+H/(\sqrt\rho j)}
      {F(z)-j/(\sqrt\rho H)} .
 \]
The homogeneous necessary condition for \(U_A\) and \(V_B\) to
vanish together is
\[
 H(A_1B_1-A_2B_2)+j(A_1B_2+A_2B_1)=0 .
 \]
The left side equals
\[
 |A||B|(H\cos\alpha+j\sin\alpha)>0,                            \tag{28}
\]
so no common zero occurs, including the limiting cases of the
homogeneous formula. In particular every four-pole member is regular
and has the separately required Gauss-map degree four.

Each individual coefficient has isolated simple zeros on the circle.
No two coefficients vanish together: if a component of \(A\) is
zero, \(A^2\) is real and (26) has nonzero imaginary part; if a
component of \(B\) is zero, the converse follows from
\(\mathcal R^2=1\). At a zero coefficient, the partner kernel in
the same orientation vanishes at that puncture. The absent pole is
therefore a regular removable point by (28), not a branch point.
Exactly three embedded ends remain, and the Gauss-map degree is three.
With nonzero pole coefficients, a zero height residue instead gives
an embedded planar end, not a removable point.

Every retained end has horizontal leading term a nonzero multiple of
the real and imaginary parts of \(1/\zeta\). It is an embedded
graph outside a disk. These expansions are uniform with all needed
derivatives on a parameter interval where that pole coefficient is
bounded away from zero. The height is a logarithm plus a constant
and \(O(R^{-1})\). Thus every member is a complete proper
finite-total-curvature immersion after precisely the removable
punctures just described are filled in.

## 4. Exact classification of all possible end orders

The logarithmic height growths in (20), divided by their common
positive factor two, are
\[
\begin{split}
 \lambda_1&=A_1(jB_1-HB_2),&
 \lambda_2&=-A_2(HB_1+jB_2),\\
 \lambda_3&=-B_1(jA_1-HA_2),&
 \lambda_4&= B_2(HA_1+jA_2).
\end{split}                                                     \tag{29}
\]
Their sum is zero. Ends 1,2 have one oriented normal; ends 3,4
have the other. All normal statements below concern oriented
normals, not the sign of a catenoidal weight.

After division by \(|A||B|>0\), put
\[
 X=j\cos\alpha-H\sin\alpha,\quad
 Y=j\cos\gamma,\quad Z=-H\sin\gamma.
\]
The four divided growths are
\[
 \tfrac12(X+Y-Z,\ X-Y+Z,\ -X-Y-Z,\ -X+Y+Z).                    \tag{30}
\]
For four distinct growths their oriented-normal order alternates
iff
\[
 \prod_{\substack{i=1,2\\k=3,4}}(\lambda_i-\lambda_k)<0
 \quad\Longleftrightarrow\quad
                         (X^2-Y^2)(X^2-Z^2)<0.               \tag{31}
\]
If this fails, global embedding is already impossible by the
ordered-end argument in `reduction.md`.

It remains to classify (31), exactly. On \(0\le\gamma\le\pi/2\),
\(\alpha\) increases from \(\alpha_N\) to \(\alpha_M\). Write
\(u=\tan\alpha\), \(\tau=j/H\). Substituting (27), the equations
\(X^2=Y^2\) and \(X^2=Z^2\) are, respectively, the following
quadratics, up to positive factors:
\[
\begin{split}
 Q_Y(u)&=ac+\{b(a+c)-2K/\tau\}u
                      +\{-ac+K/\tau^2\}u^2,\\
 Q_Z(u)&=ac-K\tau^2+\{b(a+c)+2K\tau\}u-acu^2.                \tag{32}
\end{split}
\]
Each has negative constant and positive leading coefficient; each
therefore has exactly one positive root. The decisive evaluations are
\[
 Q_Y(\tau)=-(a\tau-b)(c\tau-b)<0,\qquad
 Q_Z(\tau)=(a+b\tau)(c+b\tau)>0.                              \tag{33}
\]
They use precisely \(-c/b<\tau<b/a\), proved in (25). Hence
\[
 u_Z<\tau<u_Y .
 \]
There is one root of each in the actual \(\alpha\)-interval:
at \(\gamma=0\), \(0<X<j\); at \(\gamma=\pi/2\),
\(-H<X<0\). Thus \(X^2-Y^2\) goes from negative to positive,
while \(X^2-Z^2\) goes from positive to negative.

Consequently the alternating-growth set on the whole circle
consists of exactly four open intervals, each containing exactly
one of
\[
 \gamma=0,\quad\pi/2,\quad\pi,\quad3\pi/2.                    \tag{34}
\]
These are respectively the \(B=A\), \(B=-iA\), \(B=-A\),
and \(B=iA\) CCCC anchors of Section 2. No alternating chamber
has been discarded. At every boundary of these four intervals
exactly one pair of opposite-normal growths is equal, with all
other growths distinct. Indeed \(u_Z<\tau<u_Y\) rules out
simultaneous factors in (31), and the equal factor has \(X\ne0\).
Triple ties and two simultaneous opposite-normal ties are impossible.
A tie of only same-normal ends cannot give an alternating end order.

The strict signs in (32)--(33) are the exact certificate for the
interval count. The phase grid in `explore_torsion.py` is not used.

## 5. Compactness, primitivity, and one-ended degeneration

We record the geometric details needed for continuation rather than
assuming that a numerical component preserves embeddedness.

**Closedness at a regular limit.** A compact-parameter limit of these
immersions converges smoothly on every compact set away from the
punctures. If the approximating maps are embeddings, two local limit
sheets cannot cross transversely. If they meet tangentially, the
ordering of the approximating embedded sheets and the strong maximum
principle force the two limit sheets to coincide. Thus the proper
limit immersion covers an embedded image. This is the usual
maximum-principle closedness argument, also explicitly used in
Perez--Ros, *Some uniqueness and nonexistence theorems for embedded
minimal surfaces*, proof of Theorem 1, Assertion 1, pp. 10--11
of the preserved primary PDF.

The proper embedded image is two-sided, so its orientation makes the
cover holomorphic. For completeness, an orientation-reversing loop on
an embedded boundaryless surface in \(\mathbb R^3\) would give a closed
transverse curve with odd intersection number; a compact spanning disk
and properness force that mod-two intersection number to be zero.

In this family the cover has one sheet. Each end is embedded locally,
so a covering compactifies without ramification. The domain
compactification is a torus, hence the image compactification is a
torus too. An unramified holomorphic covering of tori has a
translation deck group. A translation preserving a subset of the
four two-torsion punctures belongs to \(E[2]\).

With four ends, a deck translation must preserve the two oriented
Gauss values. The only possible nontrivial translation is
\(z\mapsto-\rho z\), which exchanges 1 with 2 and 3 with 4.
For \(J_0(A_1,A_2)=(-A_2,A_1)\), however,
\[
 U_A(-\rho z)=U_{J_0A}(z)/\sqrt\rho .
 \]
Invariance of the one-form \(U_A^2dz\) under a deck map would
require \(U_{J_0A}^2=-U_A^2\), hence \(J_0A=\pm iA\).
That is impossible for a nonzero real vector \(A\). With three
ends, a subgroup of \(E[2]\) cannot preserve a three-point subset
nontrivially. Thus every regular limit under consideration is
primitive and is itself an embedding.

**Openness with distinct growths.** At an embedded member having
distinct end growths and nonzero pole coefficients, embeddedness is
open along (21). On a fixed compact core this is ordinary \(C^1\)
stability of an embedding. Outside a sufficiently large disk the
four graphical ends have strictly ordered logarithmic leading
terms; uniform expansions preserve that order for nearby
parameters. This also applies if a weight vanishes: the pole,
regularity, distinct growths, and four ends still persist.

**A zero coefficient cannot be approached by embedded members.**
Suppose otherwise. There is only one zero coefficient, by Section 3.
Fill its regular removable puncture. The limit has exactly three
embedded ends and is itself embedded by the preceding closedness
and primitivity argument. The same local argument extends across
the filled point: a transverse contact there gives nearby contacts
away from it, while an isolated tangential contact is forbidden by
the maximum principle.

The three remaining end normals must alternate. If an end of
normal type B disappeared, their order is A,B,A; if an A end
disappeared, their order is B,A,B. These three graph orders persist
for the remaining ends in any nearby embedded member: fix one
sufficiently large cylinder for the three nondegenerating ends,
preserve their strict height order there, and note that disjoint
graphs cannot exchange order farther out.

The sum of their growths is zero. They are not all zero, since
otherwise the height extends harmonically across every puncture of
the compact torus and is constant, making the nonflat immersion a
plane. Thus one of these three growths is strictly positive and
another strictly negative. The disappearing end's growth tends
to zero.

To insert the missing normal into A,B,A or B,A,B and obtain four
alternating normals, that new end must lie outside the three
remaining ends, not between them. But its growth, near zero,
lies strictly between a positive and a negative remaining growth.
It cannot be the top or bottom end. This contradiction excludes
every coefficient-zero endpoint of an embedded continuation,
including ties among the remaining three growths.

No assumption about the three-ended limit being a Costa surface is
used here.

## 6. Repeated growths do not leave isolated embedded members

We need a small maximum principle at infinity only for graphs with
the same logarithmic coefficient. Here is a proof in the precise
form needed.

Suppose two disjoint minimal end graphs are ordered and have the
same logarithmic coefficient and the same constant term. Their
positive height difference \(w\) tends to zero and solves
\[
 \operatorname{div}(\mathcal A(x)\nabla w)=0,\quad
 \mathcal A=I+O(R^{-2}),\quad \nabla\mathcal A=O(R^{-3}).
 \]
This follows by integrating the derivative of
\(p\mapsto p/\sqrt{1+|p|^2}\) between their gradients. The
derivative bounds follow from the meromorphic end expansions.
For sufficiently large \(R_0,C\),
\(F(R)=\log R-C/R^2\) is increasing and is a supersolution:
\(\operatorname{div}(\mathcal A\nabla F)\le0\).
If \(m=\min_{|x|=R_0}w>0\), comparison on \(R_0<R<T\) with
\[
 m\,\frac{F(T)-F(R)}{F(T)-F(R_0)}
 \]
and then \(T\to\infty\) gives \(w\ge m\), a contradiction.
Therefore distinct disjoint end graphs with equal growth have
strictly different height constants.

Now suppose a boundary point from Section 4 were embedded. Only
one opposite-normal pair has equal growth. Its height constants
give a strict order, and all four end normals must alternate.
Of the two possible orders of this adjacent tied pair, exactly
one is alternating; it is exactly the order on the adjacent
open interval (31). Move a small distance into that interval.
The tied growth difference then has the same sign as the
strict height-constant gap, so the two ends remain disjoint
uniformly outside a large disk. All other growth gaps are
already strict, and the compact core stays embedded.

Thus an embedded repeated-growth member would yield an embedded
member in an open alternating chamber. A same-normal tie with
no opposite-normal tie already violates alternating end order,
and higher ties were excluded algebraically in Section 4.
This covers all repeated-growth cases, rather than assuming
generic end data.

## 7. Exhaustion of the full torsion stratum

Suppose first that an embedded member has distinct growths.
It belongs to one of the four intervals in (31). Follow that
interval toward its CCCC anchor (34), allowing planar ends
with nonzero pole coefficients as in Section 1.

Until the first zero pole coefficient, embeddedness is both
open and closed by Section 5, so every point on this part of
the interval would be embedded. If a coefficient-zero point
is met before the anchor, the one-ended degeneration argument
in Section 5 is a contradiction. Otherwise the CCCC anchor
would be embedded, contradicting its reviewed exact end
intersection. Hence no distinct-growth member is embedded.

Section 6 reduces any possible repeated-growth embedded member
to the distinct-growth case. Therefore none exists. The argument
is for each arbitrary fixed \(\rho>1\); no compactness assertion
at \(\rho=1\) or \(\rho=\infty\) is needed. It includes every
finite allowed modulus.

Combined with the reviewed reduction, all eight distributions
and both signed branches are accounted for. Puncture collisions
were excluded there; the only additional finite boundaries used
here are explicitly identified as planar ends, single removable
ends, or repeated growths and have just been treated. The
separate degree-four condition is not inferred from period
closure: it is proved for the nonzero-coefficient period curve
by (28).

## Replay and evidence limits

From the campaign root:

```bash
PYTHONDONTWRITEBYTECODE=1 python research/kato-muroya-nonzero-reciprocal-fixed/verify_torsion.py
```

The exact replay checks the reflection parametrization, the
homogeneous common-zero criterion, the two quotient-coordinate
anchor changes, the degree/cover obstruction's coefficient
action, every growth difference, both tie quadratics and their
strict-sign root certificates, and the preserved typed Jacobian
factorization. It also executes the earlier reduction replay.
The topological and maximum-principle arguments are prose proofs,
not Lean/kernel certificates; independent mathematical review is
required.

The Jacobian factor request was inspected before execution. Its
dedicated payload and output are
`jacobian-payload-end-order-factor.json` and
`jacobian-output-end-order-factor.json`.
Server `0.14.0`, protocol `2025-11-25`, returned `FACTORIZED`
with `EXACT` reconstruction, 284 ms, exit 0, and no structured
error or timeout. This certifies only the polynomial identity
in (33), not the geometric continuation theorem. The factor payload
names the ratio \(\tau=j/H\) `r`; that variable is not the torus
multiplier \(r=\rho^2\).

## Literature and novelty boundary

The primary Kato--Muroya theorem is still only an immersion
theorem. The graph-at-infinity input is the already inspected
Hoffman--Karcher Proposition 2.1. The open/closed embedding
method and maximum principle at infinity are classical; the
preserved Perez--Ros primary source demonstrates the former
explicitly in its proof of Theorem 1. Their vertical-flux
deformation theorem is not applied here: (21), not Lopez--Ros
scaling, supplies the period-preserving deformation.

Targeted searches did not locate a primary theorem covering
this full asymmetric reciprocal locus. That is not proof of
novelty. The candidate new result is the exact full-locus
obstruction, including its period-circle and removable-end
analysis; `novelty_status=verified_new` and publishable
significance must not be asserted before independent source
and significance review.
