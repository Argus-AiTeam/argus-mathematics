# A marked arithmetic family with exact Enriques torsion defect

The explicit exponent is **N = 1**. The proof below identifies the actual
marked half-fiber, proves the uniform local statement for every integer
parameter, and determines its entire complex correspondence image. The
exact symbolic verifier has passed. Independent Host review and
publication qualification are distinct: the family theorem and its
certificate have received independent mathematical support. The
contribution comparison in Section 7 does not establish a substantive
original structural theorem, and requests a different mathematical
target. Neither `verified_new` nor `publishable` is asserted.

These are integral torsion counterexamples on smooth projective
threefolds, not counterexamples to the smooth rational Hodge conjecture.
The previously fixed `A_B`, `D_0`, and descent of `z_p` remain unresolved.

## 1. Statement and inputs

Put \(K=\mathbf Q(\sqrt2,\sqrt3)\), and, for every \(m\in\mathbf Z\), set
\[
 a_m=3+2\sqrt2+11m,\qquad
 \lambda_m=a_m^2+a_m^{-2}-1,\qquad
 r=-3+2\sqrt3,\quad r'=-6-r.
 \tag{1}
\]
Thus \(rr'=-3\). For the moment write \(a,\lambda\) for \(a_m,\lambda_m\).
Define
\[
 A_a:\ Y_A^2=x(x-a)(x-a^{-1}),\qquad
 B:\ Y_B^2=y(y-r)(y-r'),\qquad
 T_a=\operatorname{Km}(A_a\times B).
 \tag{2}
\]
The two marked points on \(A_a,B\) are \((0,0)\). The involution induced
by \((P,Q)\mapsto(P+(0,0),-Q+(0,0))\) is
\[
 \tau(x,y,w)=(x^{-1},-3/y,3w/(x^2y^2))
 \quad\text{on}\quad
 w^2=x(x-a)(x-a^{-1})y(y-r)(y-r').
 \tag{3}
\]
The smooth Kummer resolution is understood throughout. Set \(S_a=T_a/\tau\).

**Theorem.** For every integer \(m\), the construction in Section 2 gives
an actual smooth connected half-fiber \(i_m:C_m\hookrightarrow S_{a_m}\).
The following statements hold.

1. The marked complex curve \((C_m,K_{S_{a_m}}|_{C_m})\) is isomorphic to
   \[
   E_{\lambda_m}:\quad
   Y^2=X\bigl(X^2+2(1+\lambda_m)X+(1-\lambda_m)^2\bigr),
   \qquad \eta_m=(0,0)\in E_{\lambda_m}[2].
   \tag{4}
   \]
   This is an identification of the actual curve and its restricted
   canonical cover, not only an equality of unmarked \(j\)-invariants.
2. The surface and its canonical cover have good reduction at both
   places of \(K\) above eleven. With \(v(11)=1\),
   \[
   v(\lambda_m)=1,\qquad v(j(C_m))=-1.
   \tag{5}
   \]
   The actual curve has semistable multiplicative reduction after a
   finite extension. An explicit isomorphism in Section 3 reduces this
   assertion to a regular nodal model of (4).
3. If \(\alpha_m\) is the K3-cover class and
   \[
   \mathcal A_m=\{Z^*\alpha_m:
      Z\in\mathrm{CH}_1((C_m\times S_{a_m})_{\mathbf C})\},
   \]
   then
   \[
   \mathcal A_m=\langle\eta_m\rangle,\qquad
   \operatorname{Hdg}^4(C_m\times S_{a_m},\mathbf Z)/
       \operatorname{cl}\mathrm{CH}^2(C_m\times S_{a_m})
       \simeq\mathbf Z/2.
   \tag{6}
   \]
   This includes all complex correspondences, with no restriction on
   their fields of definition.
4. The two missing mixed torsion classes are specified by the points
   \[
   \beta_m=\bigl(-(1+\sqrt{\lambda_m})^2,0\bigr),\qquad
   \beta_m+\eta_m=\bigl(-(1-\sqrt{\lambda_m})^2,0\bigr)
   \tag{7}
   \]
   through the cohomological construction in Section 5. There are
   infinitely many geometric curve classes, and also infinitely many
   geometric product classes. Among \(|m|\leq M\) there are at least
   \(\lceil(2M+1)/24\rceil\) of each.

**Reviewed inputs.** We reuse the all-complex-correspondence arithmetic
transfer theorem of `../enriques-arithmetic-defect/arithmetic_defect.md`,
Sections 1--4, including invariance of the specialization subspace after
arbitrary ramified base change. We also reuse the Benoist--Ottem
identification of the defect with \(H^1(C,\mathbf F_2)/\mathcal A\)
[BO, Proposition 1.1 and Remark 1.2]. These are not new mechanisms.
The earlier fixed I16 construction supplies the starting formula, but
the proof below does not assume that its full Neron--Severi calculation
continues to hold at every parameter. In particular, we do not claim a
constant full Neron--Severi group or a uniform index-two statement for
the K3 pencils at all Picard-jumping parameters.

## 2. Actual fibers on the Kummer-Enriques surfaces

We first work over an algebraically closed field of characteristic zero
with
\[
 a(a^2-1)(a^4-a^2+1)\ne0.
 \tag{8}
\]
Equivalently \(a\ne0\) and \(\lambda\notin\{0,1\}\). Section 4 proves
(8) for every parameter (1).

The fixed-point calculation for (3) is uniform. A fixed point on the
singular Kummer quotient would require
\((P+(0,0),-Q+(0,0))=(P,Q)\) or \((-P,-Q)\). These require one of the
two marked nonzero points to be zero. On the sixteen Kummer nodes,
translation by the pair of markings has no fixed point, so the
exceptional curves are exchanged in pairs. Thus \(\tau\) is free on
the resolution. It negates the two-form, and its quotient is Enriques
with canonical cover \(T_a\).

Order the branch rows and columns as
\[
 (0,a,\infty,a^{-1}),\qquad(0,r,\infty,r').
 \tag{9}
\]
Use \(R_i,C_j,E_{ij},H_x,H_y\) as in the reviewed double Kummer
configuration. Their relations
\[
 2R_i=H_x-\sum_jE_{ij},\quad
 2C_j=H_y-\sum_iE_{ij},\quad
 H_xH_y=2,\quad E_{ij}^2=-2
 \tag{10}
\]
hold throughout this family. Let
\[
 M=\{(i,i),(i+1,i):i\in\mathbf Z/4\},\qquad
 F=\sum_iR_i+\sum_jC_j+\sum_{(i,j)\notin M}E_{ij}
   =2H_x+2H_y-\sum_{(i,j)\in M}E_{ij}.
 \tag{11}
\]
Its sixteen components form a cycle, so \(F\) is a reduced I16 divisor,
\(F^2=0\), and \(F\) is nef.

Put
\[
 h=a+a^{-1},\quad n=6a+(r-r')/a,\qquad
 Q=r'x^2y+3x^2-3ax+axy^2-y^2+r'y+nxy.
 \tag{12}
\]
The polynomial \(Q\), bihomogenized to bidegree \((2,2)\), passes
through precisely the eight nodes in \(M\). Both local partial
derivatives are nonzero at each of these nodes under (8). This follows
by substitution in the four charts, not by a generic-parameter
assertion: `verify_family.py` gives the exact derivative norms, whose
only possible parameter zeros lie outside (8).

The section \(w\) of the pulled-back \(\mathcal O(2,2)\) has as divisor
the sum of the 24 basic curves. Removing the eight common exceptional
components of \(w,Q\) leaves \(F\) and the residual divisor \(D\) of
\(Q\). They are disjoint. On a branch line, all zeros of \(Q\) are the
specified grid nodes. At a selected node, resolution coordinates have
the form
\[
 u=z,\quad v=zq^2,\quad w_{\rm loc}=zq.
 \]
The residual equation is \(A+Bq^2+O(z)=0\), with \(AB\ne0\), so it
avoids the branch endpoints on that exceptional curve. At an
unselected node \(Q\ne0\). Therefore \(w/Q\) defines an actual
base-point-free pencil on \(T_a\), not a pencil on its Jacobian.

To establish smoothness, let \(Q_0\subset\mathbf P^1\times\mathbf P^1\)
be \(Q=0\). Its quadratic presentation in \(y\) has coefficients
\[
 ax-1,\qquad r'(x^2+1)+nx,\qquad 3x(x-a).
 \]
They have no common zero: at \(x=a^{-1}\) the last is nonzero, and the
chart at infinity gives the same conclusion. With
\[
 W=2(ax-1)y+r'(x^2+1)+nx,\qquad
 f(t)=(r't+n)^2-12a(t-h),
 \tag{13}
\]
its double-cover model is \(W^2=x^2f(x+x^{-1})\). The exact identities
\[
 \operatorname{disc}(f)=144,\qquad
 \operatorname{disc}_x\bigl(x^2f(x+x^{-1})\bigr)
       =2^{16}3^6\lambda(\lambda-1)
 \tag{14}
\]
show that \(Q_0\) is smooth of genus one. The local calculation above
shows that \(D\to Q_0\) is an etale double cover, including over the
eight grid nodes. Thus \(D\) is smooth; its connectedness is proved
directly by the marked function fields in Section 3.

The identity
\[
 x^2y^2Q(x^{-1},-3/y)=-3Q(x,y)
 \tag{15}
\]
gives the pencil action \(s\mapsto-s\), where \(s=w/Q\).
Once connectedness of \(D\) is known, the pencil has connected fibers:
in its Stein factorization the reduced connected fiber \(D\) forces
the finite map of bases to have degree one. Its generic fiber has
genus one by adjunction. The point \(s=\infty\) is fixed by the base
involution, and is a branch point of \(s\mapsto s^2\). Since the
surface quotient is etale, the corresponding quotient fiber is
exactly \(2C\), where \(C=D/\tau\). This proves the claimed half-fiber
property, rather than only the existence of an elliptic curve in \(S_a\).

## 3. Identification of the actual marked curve

Define the invariant functions on the actual fiber \(D\)
\[
 t=x+x^{-1},\quad u=y-3/y,\quad d=x-x^{-1},\quad
 K_0=(t-2a)u-2r't-2n,\quad Z=dw/(xy).
 \]
They satisfy
\[
 (t^2-4)(u^2+12)=K_0^2,\qquad
 Z^2=(t^2-4)(t-h)(u+6).
 \tag{16}
\]
The inverse functions are
\[
 x=(t+d)/2,\quad y=(u+K_0/d)/2,\quad w=xyZ/d,
 \qquad d^2=t^2-4.
 \tag{17}
\]
Thus (16) is the function field of the quotient by the original
\(\tau\); (17) retains its original canonical cover.

Here is an explicit simplification that selects the correct
two-isogeny kernel. On the curve \(R\) given by the first equation of
(16), set
\[
 V=2a(t-h)u+(t-2a)(r't+n),\quad
 g(t)=(t-2a)(r't+n)-12a(t-h).
 \]
Then
\[
 V^2=(t^2-4)f(t),\qquad
 Z^2=\frac{t^2-4}{2a}(V-g).
 \tag{18}
\]
This quartic has discriminant
\(2^{24}3^6\lambda^2(\lambda-1)^2\).
Let
\[
 e_\pm=\frac{-r'n+6a\pm6}{r'^2},\qquad
 k=\frac{e_+-2}{e_+-e_-},\qquad
 z=k\,\frac{t-e_-}{t-2}.
 \tag{19}
\]
We have \(e_+-e_-=12/r'^2\), and the ordered branch points
\((e_-,e_+,-2,2)\) map to \((0,1,\lambda,\infty)\).
All required constants in (19) are nonzero under (8).

Choose constants \(c,\ell\) in a finite extension such that
\[
 c^2=-\frac{r'}{4ak},\qquad
 \ell^2=\frac{k(k-1)(k-\lambda)}{r'^2},
 \qquad
 p=c(t^2-4),\quad q=\frac1{4acz}.
 \tag{20}
\]
The decisive square identity is
\[
 \frac{Z^2}{z}=(p+qV)^2.
 \tag{21}
\]
It follows directly from
\[
\begin{split}
 g-4(r+3)(t-h)&=r'(t+2)(t-e_-),\\
 g+4(r+3)(t-h)&=r'(t-2)(t-e_+),\\
 V^2-g^2&=-192(t-h)^2.
\end{split}
\]
In particular (21) is a statement about the actual \(Z\) in (16),
not a freely chosen two-torsion kernel on an isogenous curve.

Put \(\zeta=Z/(p+qV)\) and
\(v=\ell V/((t-2)^2\zeta)\). Equations (18)--(21) give
\[
 C:\quad v^2=(\zeta^2-1)(\zeta^2-\lambda),\qquad z=\zeta^2.
 \tag{22}
\]
Conversely \(t=(2z-ke_-)/(z-k)\), and the same formulas recover
\(V,u,Z\). They are inverse function-field maps. All these maps extend
between the smooth projective curves.

This also proves connectedness without assuming the Neron--Severi
lattice of a special member. On the smooth Legendre model
\((\ell V/(t-2)^2)^2=z(z-1)(z-\lambda)\), the function \(z\) is not
a square: its half-divisor is the difference of distinct two-torsion
points. Consequently adjoining \(\zeta\) gives the connected curve
(22). Furthermore
\[
 t^2-4=\frac{4k(2-e_-)(z-\lambda)}{(z-k)^2}.
 \tag{23}
\]
Over the algebraic closure, (17) is therefore precisely
\[
 D=C\bigl(\sqrt{\zeta^2-\lambda}\bigr).
 \tag{24}
\]
On (22), write \(P_b=(b,0)\) for \(b=1,-1,\sqrt\lambda,-\sqrt\lambda\),
and take \(P_1\) as origin. The class of (24) is
\[
 [P_{\sqrt\lambda}+P_{-\sqrt\lambda}
       -\infty_+-\infty_-]=[P_{-1}-P_1]\ne0.
 \tag{25}
\]
Indeed the infinity fiber is linearly equivalent to \(2P_1\), and
the other three branch points are the three nonzero two-torsion
points. Thus \(D\) too is connected. It is the original smooth
fiber from Section 2, and its connected cover (24) is exactly
\(K_{S_a}|_C\).

Finally the formulas
\[
 X=(1-\lambda)\frac{\zeta+1}{\zeta-1},\qquad
 Y=\frac{2(1-\lambda)v}{(\zeta-1)^2}
 \tag{26}
\]
identify (22), with origin \(P_1\), with (4). They send \(P_{-1}\)
to \((0,0)\) and the other two branch points to (7). The actual
invariants are
\[
\begin{split}
 c_4&=16(\lambda^2+14\lambda+1),\\
 \Delta&=256\lambda(\lambda-1)^4,\\
 j(C)&=\frac{16(\lambda^2+14\lambda+1)^3}
                   {\lambda(\lambda-1)^4}.
\end{split}
\tag{27}
\]
At \(m=0\), \(\lambda=33\) and \(j(C)=912673/528\).
This resolves the two-kernel ambiguity left by the earlier unmarked
calculation; the other candidate \(-192100033/2371842\) is not the
quotient specified by (12) and (3).

## 4. A uniform local certificate with N = 1

At either place of \(K\) above eleven, the extension is unramified and
the residue field is \(\mathbf F_{11}(b)\), where \(b^2=2\).
The polynomial \(b^2-2\) is irreducible since \(2^5=-1\pmod {11}\).
The two choices of residue of \(\sqrt3\) do not affect the following
calculation.

Write \(a_0=3+2\sqrt2\). Its norm is one and
\(\operatorname{Nm}_{\mathbf Q(\sqrt2)/\mathbf Q}(a_0^2-1)=-32\).
Consequently \(a_m\) and \(a_m^2-1\) are units at eleven for all \(m\).
For the function \(\lambda(a)=a^2+a^{-2}-1\),
\[
 \lambda(a_0)=33,\qquad
 \lambda'(a_0)=-192+144\sqrt2.
 \]
The Taylor identity in the local ring, with unit denominator, gives
\[
 \lambda(a_0+11m)
   \equiv 33+11m(-192+144\sqrt2)\pmod {121}.
 \tag{28}
\]
The verifier checks (28) after clearing the unit denominator as a
polynomial identity in \(m\), modulo \(b^2-2\).
In particular
\[
 \lambda_m/11\equiv3+m(6+b)\pmod {11}.
 \tag{29}
\]
For an integer \(m\), this residue cannot vanish: its \(b\)-coefficient
would force \(m=0\) in \(\mathbf F_{11}\), after which its constant
coefficient would be \(3\). This proves \(v(\lambda_m)=1\) for **every**
integer \(m\), not just for finitely many tested parameters.
It also proves \(v(\lambda_m-1)=0\), and hence (8).
Equation (27) now gives \(v(c_4)=0\), \(v(\Delta)=1\), and \(v(j)=-1\).

The model (4) has special fiber
\[
 Y^2=X(X+1)^2,
 \tag{30}
\]
an irreducible rational curve with an ordinary node at \((-1,0)\).
For the equation \(F=Y^2-X(X^2+2(1+\lambda)X+(1-\lambda)^2)\),
we have \(F_\lambda(-1,0,0)=-4\). Since \(\lambda_m\) is a uniformizer
times a unit, the total model is regular at the node. It is regular
elsewhere as well, including at the point at infinity. Thus (4) is an
explicit proper regular semistable model. Its node splits over the
geometric residue field; in fact \(-1\) is already a square in
\(\mathbf F_{121}\).

The constants \(c,\ell\) in (20) require at most a degree-four extension
of \(K\). Over that extension the actual \(C_m\) is isomorphic to (4),
not just isogenous to it. On a ramified extension, resolving the nodal
base change inserts a chain of rational curves. Hence the actual
curve has the required semistable reduction, and the specialization
subspace of \(H^1(C_m,\mathbf F_2)\) has dimension one. No potentially
good-reduction criterion inferred from floating-point \(j\)-values is
being used.

For the surfaces, the displayed elliptic discriminants are
\[
 \Delta(A_{a_m})=16(a_m-a_m^{-1})^2,\qquad
 \Delta(B)=6912.
 \tag{31}
\]
They are units at eleven, by the unit calculation preceding (28).
The two nonzero marked points remain nonzero in the special fiber.
Blow up the finite etale two-torsion subgroup of the abelian scheme
and quotient by \((-1,-1)\). This gives a smooth proper relative
Kummer resolution in odd residue characteristic. Locally on a blowup
chart the remaining involution acts by \(z\mapsto-z\) on the normal
coordinate, so its quotient is smooth. The fixed-point calculation
for \(\tau\) from Section 2 works on each geometric fiber. Therefore
the relative quotient by \(\tau\) is smooth proper and the double
cover is finite etale. This proves good reduction of both \(S_m\)
and its actual canonical cover, not merely of an unrelated surface.

## 5. Every complex correspondence and the two missing classes

Let \(U\subset H^1(C_m,\mathbf F_2)\) be the specialization image for
a regular semistable model after the finite extension just described.
The special fiber is an I1 curve or its nodal base-change resolution,
so \(\dim U=1\).

For clarity, the reviewed arithmetic theorem supplies more than
inertia invariance. A complex cycle class descends, by an algebraic
equivalence on a Hilbert scheme, to a cycle over a finite extension
of the number field. Normalize each component dominating \(C_m\).
Properness of the surface model and extension of the double cover
make its pulled-back Kummer class unramified at every valuation over
the divisors of the regular curve model. The norm valuation formula
makes the transfer unramified there as well, so it extends as an
etale double cover of that model. Resolving any further ramified
base change does not change \(U\), because the inserted rational
trees have no first cohomology. Components not dominating the curve
contribute zero. Thus, for every complex cycle,
\[
 \mathcal A_m\subseteq U.
 \tag{32}
\]
This is the previously reviewed norm-extension argument, not a new
claim that finite-extension invariance alone survives even ramification.

The graph of the actual inclusion \(i_m:C_m\hookrightarrow S_m\)
has pullback \(\eta_m\ne0\). Combining this with (32) gives
\(\mathcal A_m=U=\langle\eta_m\rangle\). Benoist--Ottem's integral
Kunneth calculation now proves (6).

Here is an explicit integral cohomology specification of the missing
classes. Identify \(E_{\lambda_m}[2]\) with
\(\operatorname{Pic}^0(C_m)[2]=H^1(C_m,\mathbf F_2)\) using (26).
Let \(\epsilon_m\) be the unique nonzero element of
\(H^3(S_m,\mathbf Z)=\mathbf Z/2\). For either point \(b\) in (7),
take any integral lift \(\widetilde b\in H^1(C_m,\mathbf Z)\) of
its Kummer class and put
\[
 \gamma_b=\widetilde b\boxtimes\epsilon_m
       \in H^4(C_m\times S_m,\mathbf Z).
 \tag{33}
\]
This is independent of the lift, since \(2\epsilon_m=0\).
The two displayed points are precisely the two elements outside
\(\langle(0,0)\rangle\); (32) proves that both classes (33) are
nonalgebraic. They are nonzero order-two integral Hodge classes.
In contrast, the mixed class corresponding to \(\eta_m\) is algebraic,
using the graph and subtraction of the other algebraic Kunneth
components. The additional canonical-divisor torsion in
\(H^2(C_m,\mathbf Z)\otimes H^2(S_m,\mathbf Z)\) is also algebraic.
We do not incorrectly label every torsion class nonalgebraic.

All rational degree-four Hodge classes on these products are algebraic:
the only problematic Kunneth summand above is torsion.

### 5.1 A version-specific marked-point obstruction

The family also prevents an inaccurate use of [HN, Corollary 3.3].
We give the cohomological argument, since a disagreement between
reduction labels alone would not establish a counterexample.

**Proposition.** For every \(m\), and every lift
\(\theta\in H^2(S_m,\mu_2)\) of the nonzero Enriques Brauer class,
\[
 \operatorname{res}_{\mathbf C(C_m\times S_m)}
       (\eta_m\smile\theta)=0
       \quad\text{in }H^3(\mathbf C(C_m\times S_m),\mu_2^{\otimes2}).
 \tag{33a}
\]
Here the order-two coefficient twists are identified using \(-1\).

**Proof.** The coefficient-compatible comparison proved in the
reviewed `brauer_cup.md`, Proposition 3 and its proof, applies to
any smooth complex curve times an Enriques surface: the only uses
of the curve there are torsion-freeness of its integral cohomology
and surface support for the product's zero-cycles. The latter follows
by taking the product with a curve supporting \(\mathrm{CH}_0(S_m)\).
The already reviewed Colliot-Thelene--Voisin exact sequence and
vanishing theorem identify
\[
 H^3_{\rm nr}(C_m\times S_m,\mu_2^{\otimes2})
       \simeq Z^4(C_m\times S_m)[2].
 \]
Its value on the restriction of \(\eta_m\smile\theta\) is the class
of its integral Bockstein, namely
\(\widetilde\eta_m\boxtimes\epsilon_m\).
That integral class is algebraic by the actual graph in Section 5.
The comparison is injective, so the unramified class, and hence its
image in function-field cohomology, is zero. Changing the lift
\(\theta\) adds a divisor Chern class, which is already zero on the
function field. This proves (33a). No assumption that a nonzero
Brauer class automatically has nonzero cups is made.

At \(m=0\) this gives a particularly explicit example. Over \(\mathbf Q\)
take the fixed surface built from
\(A:y^2=x(x^2-6x+1)\), \(B:y^2=x(x^2+6x-3)\), and
\[
 E_0:\ Y^2=X(X^2+68X+1024),\qquad P=(0,0).
 \tag{33b}
\]
The surface has good reduction at eleven, \(E_0\) has multiplicative
reduction, and \(P\) reduces to the **smooth** point \((0,0)\) of
\(Y^2=X(X+1)^2\); the derivative in \(X\) there is \(-1\).
The actual marked isomorphism (26) makes its cover class algebraic.
The convention [HN, (2.4)(a)--(b)] identifies their \(\alpha_P\)
with this same class: it is the cover dual to \(E_0\to E_0/P\).
Thus (33a) is zero for exactly the class that the printed
Corollary 3.3 asserts to be nonzero under these hypotheses.

For an explicit field-symbol form, reuse the independently reviewed
nonzero Brauer representative on this fixed surface:
\(\beta=(t_S-2,u_S-2\sqrt{-3})\). Here \(t_S=x_A+x_A^{-1}\) and
\(u_S=x_B-3/x_B\) are the invariant surface functions, not the
external elliptic coordinates. Since \(X\) has divisor
\(2(P)-2(O)\) on (33b), the same conclusion is
\[
 \{X,t_S-2,u_S-2\sqrt{-3}\}=0
 \quad\text{in }H^3(\mathbf C(E_0\times S_0),\mu_2^{\otimes2}).
 \tag{33c}
\]
The fixed Brauer representative, its exceptional residues, and its
nontriviality are reused from the accepted proof, not reasserted
from an affine-only calculation.

The marked valuation explains the issue precisely. A Legendre
parameter preserving \(P=(0,0)\) is
\[
 \nu=\frac{(\sqrt\lambda+1)^2}{(\sqrt\lambda-1)^2},\qquad
 \nu-1=\frac{4\sqrt\lambda}{(\sqrt\lambda-1)^2}.
 \tag{33d}
\]
At eleven it satisfies \(v(\nu)=0\), \(v(\nu-1)=1/2\), with
\(v(11)=1\) retained on the extension. The proof of the printed
corollary infers \(v(\nu)\ne0\) from bad reduction after fixing this
marked Legendre presentation; (33d) shows why that inference does
not follow for a point reducing to the smooth locus.

The versioned PDF text and primary HTML both say "smooth point".
The arXiv submission history checked during this work lists only
v1, submitted 2026-09-03. This is a counterexample to **that printed
Corollary 3.3**, not a claim that the paper's main theorems or
Corollary 3.4 are false. It is not a decision of the original fixed
CM cup: (33c) has a different external elliptic curve and class.

## 6. Nonconstant moduli and exact replay

As a function of \(a\), (27) is
\[
 j(C_a)=
 \frac{16(a^8+12a^6-10a^4+12a^2+1)^3}
 {a^2(a^2-1)^8(a^4-a^2+1)}.
 \tag{34}
\]
The numerator has degree 24, and the denominator degree 22. The
source-bound Jacobian operation certifies
\[
 \operatorname{Res}_a
 \bigl(a^8+12a^6-10a^4+12a^2+1,\
       a(a^2-1)(a^4-a^2+1)\bigr)=256.
 \tag{35}
\]
Thus (34) has degree exactly 24. Any one finite \(j\)-value has at
most 24 parameters \(a_m\), which proves the infinitude and counting
assertion. The products are also distinguished by these \(j\)-values,
since their Albanese varieties are \(E_{\lambda_m}\).

Run the independently rerunnable exact calculation from the campaign
root:

```bash
python3 research/enriques-half-fiber-defect/verify_family.py
```

`family_certificate.json` records its forty-one rational-function
identities, all node/transversality checks, the universal congruence
(28), the explicit quotient and cover, and the moduli degree.
It does not purport to enumerate complex correspondences or prove
publication novelty. Those require the prose and independent review.
There is no unchecked Lean source.

The exact typed payload is `jacobian-resultant-payload.json`.
After inspecting its typed contract, the Argus sidecar ran
`polynomial.compute.resultant`; `jacobian-univariate-output.json`
records server `0.14.0`, protocol `2025-11-25`, the unchanged payload,
result `256`, and runtime `17 ms`. Adapter exit status was zero;
there was no timeout or structured error. The verifier binds the
request and the exact answer to (35).

An earlier request sent this univariate payload to the multivariate
resultant contract. The adapter correctly rejected it with
`INVALID_REQUEST` because that operation requires at least two
variables, notwithstanding the more permissive shared JSON schema.
Its exact output is retained in `jacobian-resultant-output.json`;
exit status was 2. That rejection is not mathematical evidence.
No dummy variable was added: the proper univariate contract was
inspected and used instead.

## 7. Marked-object comparison and contribution decision

The preceding accepted I16 result constructed the actual half-fiber
only on the fixed surface and left its \(j\)-invariant in a set of
two candidates. Both were enough to reject an isogeny to the fixed CM
curve. Sections 2--3 now give a parameterized actual construction,
an inverse marked function-field identification, the correct single
kernel, and the complete marked curve (4). Section 4 replaces a
single eleven-adic observation by the universal integer congruence
(29), already for \(N=1\). Sections 5--6 give the exact image and
two missing classes on every member of a nonisotrivial arithmetic
family. No claim about the old fixed CM product follows.

The strongest accepted campaign arithmetic family already has maximal
rank-four defect, and the accepted genus-two bielliptic family has
exact image \(L_s\) and defect \((\mathbf Z/2)^2\) for
\(s\in\mathbf Q\setminus\{1,0,-1,-2,-1/2\}\)
(`../enriques-bielliptic-defect/classification.md`, Theorem 3).
In particular, an exact, prescribed nonzero correspondence image with
actual generating cycles was already established. The present
rank-one defect is not a stronger bound for those objects, and a
different family or a different defect rank is not itself a
substantive structural improvement.

### 7.1 Known inputs and the exact remaining proposition

The following comparison is based on primary passages, not on absence
of a search hit.

* **Benoist--Ottem.** [BO, Proposition 1.1, Remark 1.2] supplies the
  integral defect interpretation. Remark 2.2 already supplies
  arithmetic examples using an odd good-reduction prime of an
  Enriques surface. Section 3 explicitly uses a smooth half-fiber
  to obtain a nonzero algebraic cover class, and uses automorphisms
  of a \(j=0\) half-fiber to obtain all three classes. Consequently
  neither half-fiber positivity nor arithmetic nonalgebraicity is
  new here. Once the actual marked family and its local conditions
  are established, the rank-one equality is a short consequence.
* **Huryn--Newman.** [HN, (1.1), (1.5)--(1.7), Proposition 3.2,
  Corollaries 3.3--3.4] treats these Lieberman-type surfaces and
  good-versus-multiplicative-reduction nonvanishing. Its discussion
  in (1.11) relates the obstruction to integral nonalgebraicity and
  correspondence images. These ideas are prior work. However, the
  **printed smooth-point hypothesis of Corollary 3.3 cannot be used
  as an input here**: Section 5.1 gives an explicit counterexample,
  keeps the coefficient convention, and identifies the incompatible
  marked Legendre valuation. This does not refute the different
  hypotheses of Corollary 3.4 or establish a new degeneration
  mechanism.

The precise geometric statement still available for comparison is
the following already supported proposition: for every \(a\) satisfying
(8), the displayed pencil on the original \(T_a\) has the actual smooth
connected fiber \(D\), its quotient \(C\) is a half-fiber on \(S_a\),
and (16)--(26) identify the actual cover \(D\to C\) with the marked
curve \((E_\lambda,(0,0))\). This is more information than \(j(C)\).
It resolves the old two-kernel ambiguity and makes the arithmetic
application possible.

It is **not** a classification of sectionless pencils, a uniform
divisibility-two assertion at Picard jumps, or a new relation between
the generic torsor class of a pencil and its half-fiber character.
These are limitations of the proposition's scope, not defects in its
accepted proof. Sectionlessness at \(a=3+2\sqrt2\) is the separately
accepted full-lattice result in `sectionless_pencils.md`, (S6), not
an additional theorem proved by the parameterized calculation here.
The full reference is the
[fixed sectionless-pencil proof](../enriques-bielliptic-defect/exceptional-zero/unramified-obstruction/sectionless-preimage/sectionless_pencils.md),
Section 2.

### 7.2 Comparison of pencils, not merely of surfaces

The relevant marked object consists of \(T_a,\tau\), the pencil
\(s=w/Q\), its designated smooth fiber \(D\), and the cover
\(D\to C=D/\tau\). An identification must intertwine the involutions,
preserve the pencil up to a base isomorphism, and carry the designated
fiber and its cover character to the designated ones. An abstract
surface isomorphism, or an isomorphism of unmarked elliptic curves,
does not provide this identification.

[HS, Sections 3.1--3.5] starts with a rational elliptic surface with
section and makes a quadratic base change. The displayed K3 pencil
has a section. Its Enriques involution combines the base involution
with translation by a section; on a smooth fixed fiber it is
translation by a nonzero two-torsion point. Proposition 3.1 gives
the converse under the hypothesis of a rational bisection that
splits into sections on the canonical K3 cover. In particular it is
not a classification of all pencils on an Enriques surface.

[MMV, Lemma 3.1] assumes the type \(\widetilde A_7\) configuration,
including an \(I_8\) half-fiber and the two specified rational
bisections, not an \(I_8\) half-fiber alone. In its proof the
bisections lift to four disjoint sections of the K3 pencil with
an \(I_{16}\) fiber. The lemma establishes a numerically trivial
involution with the specified divisorial fixed locus and smoothness
of the other half-fiber. The later equations in the proof of
Proposition 3.4, which additionally assumes infinite automorphism
group, are
\[
 J(f):y^2=x^3+2a_2(s,t)x^2+t^4x,\qquad
 \widetilde X:y^2=x^3+2a_2(s^2,t^2)x^2+t^8x.
 \tag{36}
\]
The K3 model has its zero section and section \((0,0)\). Its
Enriques involution combines \((s,t)\mapsto(-s,t)\) with translation
by \((0,0)\). Neither an \(I_8\) label nor (36) supplies the required
marked identification of our pencil.

There is a precise obstruction at the fixed member. The accepted
calculation gives
\[
 \gcd\{F\cdot L:L\in\operatorname{NS}(T_{a_0})\}=2,
 \qquad a_0=3+2\sqrt2.
 \tag{37}
\]
A section would have intersection one with \(F\), contradicting
(37). A pencil-preserving isomorphism to a sectioned pencil would
pull back its section and is therefore impossible. The same
argument excludes a birational equivalence of generic fibers:
it would give a rational point on our smooth generic genus-one
curve, which extends to a section by properness over the base curve.

This is a genuine distinction between the **specified pencils**.
It is inherited from the earlier fixed-member lattice calculation.
It neither distinguishes their underlying unmarked surfaces nor
excludes a different sectioned pencil on the same K3 surface.
No uniform assertion extending (37) to every parameter is used.

### 7.3 The abstract marked cover has a standard two-isogeny form

The marked curve and cover themselves do not give a new normal form.
Here is an exact comparison retaining the cover character, rather
than just the \(j\)-invariant.

For \(c^2\ne1\), put
\[
 \mathscr D_c:v^2=u(u^2+2cu+1),\qquad
 \mathscr C_c:V^2=U\bigl(U^2-4cU+4(c^2-1)\bigr).
 \tag{38}
\]
The quotient of \(\mathscr D_c\) by translation by \(P=(0,0)\) is
\[
 U=u+2c+u^{-1},\qquad V=v(1-u^{-2}).
 \tag{39}
\]
This is the same quotient formula already used in `classification.md`,
Proposition 1, (1), with coefficients \(2c,1\).
Indeed that translation is \((u,v)\mapsto(u^{-1},-v/u^2)\);
both functions in (39) are invariant and satisfy (38).
Moreover \(z=v/u\) satisfies \(z^2=U\), changes sign under the
translation, and recovers
\[
 u=(U-2c+V/z)/2,\qquad v=uz.
 \tag{40}
\]
Thus the actual quotient cover in (38) has function field
\(\mathbf C(\mathscr C_c)(\sqrt U)\). Since
\(\operatorname{div}(U)=2(0,0)-2O\), its character is exactly the
nonzero class \((0,0)\) on \(\mathscr C_c\), not the choice of a
different two-isogeny kernel.

For any \(\lambda\notin\{0,1\}\), choose \(b^2=\lambda\) and \(d^2=b\)
over \(\mathbf C\), and set
\[
 c=-\frac{1+\lambda}{2b},\qquad X=bU,\qquad Y=d^3V.
 \tag{41}
\]
Then
\[
 c^2-1=\frac{(\lambda-1)^2}{4\lambda},\quad
 -4cb=2(1+\lambda),\quad
 4(c^2-1)b^2=(1-\lambda)^2.
 \tag{42}
\]
Equations (38)--(42) give an isomorphism
\((\mathscr C_c,(0,0))\simeq(E_\lambda,(0,0))\).
The square classes of \(U\) and \(X\) agree under this isomorphism,
because their ratio is a nonzero complex constant. Consequently
the connected double cover is identified as well. This is an
isomorphism of abstract marked covers over \(\mathbf C\), not an
arithmetic identification over the original number field.

In (36), writing \(a_2(0,1)=c\), the smooth K3 ramification fiber
is \(\mathscr D_c\). Its actual Enriques half-fiber is its
translation quotient \(\mathscr C_c\), with the character just
computed. One must not replace that half-fiber by the K3 fiber
itself. This matches the fiber-level form in the cited construction;
it does not assert that a full surface with arbitrarily chosen
remaining coefficients satisfies all of Proposition 3.4's
hypotheses. In particular (41) is **not** an identification of
our whole pencil with (36); (37) obstructs such an identification
at \(a_0\).

For an independently rerunnable check of only the new algebra, run
the following from the campaign root. These are rational-function
identities, not a finite parameter experiment.

```bash
python3 - <<'PY'
import sympy as s
u, v, c, b = s.symbols('u v c b')
U = u + 2*c + 1/u
V = v*(1 - 1/u**2)
D = u*(u**2 + 2*c*u + 1)
cb = -(1 + b**2)/(2*b)
checks = [
    D*(1 - 1/u**2)**2 - U*(U**2 - 4*c*U + 4*(c**2 - 1)),
    U.subs(u, 1/u) - U,
    (-v/u**2)*(1 - u**2) - V,
    D/u**2 - U,
    (-v/u**2)/(1/u) + v/u,
    (U - 2*c + V/(v/u))/2 - u,
    -4*cb*b - 2*(1 + b**2),
    4*(cb**2 - 1)*b**2 - (1 - b**2)**2,
    cb**2 - 1 - (b**2 - 1)**2/(4*b**2),
]
for expression in checks:
    assert s.factor(s.together(expression)) == 0
print("PASS: 9 exact marked-cover comparison identities")
PY
```

### 7.4 Contribution decision

The supported increment over the earlier fixed example is the
parameterized identification of its actual half-fiber and character,
including the previously ambiguous kernel. The supported distinction
from the displayed primary pencils is (37), which was already known
for this fixed member. The abstract marked cover is the elementary
two-isogeny form (38)--(42). Together these facts do not provide a
new classification, rigidity statement, torsor obstruction, or
other substantive structural consequence beyond the accepted
family theorem.

Accordingly the present evidence does **not** establish a qualifying
original proposition. The publication candidacy of this route is
withdrawn and a materially different mathematical target is requested
through normal independent review. This is not a theorem that no
stronger result could ever be extracted from these pencils, and not
a claim that the entire construction is equivalent to one in [HS]
or [MMV]. It is a contribution decision about the propositions
actually proved here, not an inference from missing search results.

Sections 1--6, the accepted \(N=1\) theorem, actual marking,
correspondence image, missing classes, and original exact certificates
are retained. The printed-hypothesis correction in Section 5.1 is
not substituted for a new contribution. The fixed CM cup, \(A_B\),
\(D_0\), and descent of \(z_p\) remain unresolved. Neither the
campaign nor its publication gate is declared complete.

### Primary sources actually used or compared

[BO] O. Benoist and J. C. Ottem, *Failure of the integral Hodge
conjecture for threefolds of Kodaira dimension zero*,
[arXiv:1802.01845v3](https://arxiv.org/pdf/1802.01845v3),
Proposition 1.1 and Remark 1.2, pp. 3--4; Remark 2.2 and Section 3,
p. 6. The retained primary PDF/text and earlier independent source
readings are in `../enriques-arithmetic-defect/reviewer/`.

[HN] J. Huryn and W. C. Newman, *On the torsion in the Chow motive
of an Enriques surface*,
[arXiv:2609.04360v1](https://arxiv.org/html/2609.04360v1),
(1.1), (1.5)--(1.7), (1.11); Proposition 3.2 and Corollaries
3.3--3.4, printed pp. 11--13; the coefficient convention (2.4),
printed p. 7. The existing versioned PDF/text in
`../enriques-bielliptic-defect/exceptional-zero/unramified-obstruction/external-isogeny-descent/`
was read directly; it was not replaced by a search summary.

[Mukai] S. Mukai, *Kummer's quartics and numerically reflective
involutions of Enriques surfaces*, primary preprint
[RIMS1633](https://www.kurims.kyoto-u.ac.jp/preprint/file/RIMS1633.pdf),
abstract, introduction, Proposition 1 and Theorem 2, pp. 1--3.
The inspected preprint and extracted text are retained in this
directory. It is a comparison source, not a premise of the theorem.

[HS] K. Hulek and M. Schuett, *Enriques Surfaces and Jacobian
Elliptic K3 Surfaces*,
[arXiv:0912.0608v2](https://arxiv.org/pdf/0912.0608v2),
Section 2.3, p. 5; Sections 3.1--3.5 and Proposition 3.1,
pp. 8--12. The converse's splitting-bisection hypothesis matters.

[MMV] G. Martin, G. Mezzedimi and D. C. Veniani,
*Enriques surfaces of zero entropy*,
[arXiv:2406.18407v1](https://arxiv.org/pdf/2406.18407v1),
Section 3.1 and Lemma 3.1 with proof, pp. 8--9;
Proposition 3.4 with proof and (3.1), pp. 10--11.
The version-stamped PDF, not a later HTML rendering, was used.

The source-specific hypotheses and short operative excerpts for [HS]
and [MMV] are recorded in `reviewer_source_excerpts.txt`, credited
to the research reader. They are not represented as a new Host
Reviewer verdict or as completed native citation attribution.
