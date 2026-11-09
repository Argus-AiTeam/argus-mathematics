# The fixed bielliptic family and its Enriques correspondence image

This is a new mathematical mission, not a resubmission of the arithmetic
publication-qualification mission. The propositions below establish the image
away from four parameters, and bounds, not exact images, at those parameters.
The requested complete classification and publication qualification remain
open. This manuscript has not yet passed independent mathematical review.

Work over the complex numbers, retaining the displayed rational models for
arithmetic arguments. Put

\[
E:v^2=u^3+1,\quad p=(-1,0),\qquad
F:v^2=u^3-u,\quad q=(1,0),
\]
\[
B=E/\langle p\rangle:y^2=x^3+6x^2-3x,\qquad
A=F/\langle q\rangle:y^2=x^3-6x^2+x.
\]

The specified points \(a\in A[2]\), \(b\in B[2]\) are both \((0,0)\).
The surface to be checked is the quotient of
\(T=\operatorname{Km}(A\times B)\) by the involution induced by
\((P,Q)\mapsto(P+a,-Q+b)\).

For \(s\in\mathbf Q\setminus\{1\}\), let
\[
C_s:y^2=(x^2-s)^3+1,\qquad
f_s:C_s\longrightarrow E,\quad (x,y)\mapsto(x^2-s,y).
\]
The objective is to determine the image
\[
\mathcal A_s=\{Z^*\alpha:Z\in\operatorname{CH}_1(C_s\times S)\}
       \subset H^1(C_s,\mathbf F_2)
\]
for every such parameter and give actual cycle representatives and a universal
upper bound. The four specified values \(0,-1,-2,-1/2\) are not assumed to be
exceptional, nor is any rank assigned to them in advance.

## Inputs and boundaries

The accepted arithmetic transfer theorem in
`../enriques-arithmetic-defect/arithmetic_defect.md`, Sections 1--4, applies to
all complex correspondences when its cover-extension and semistable-reduction
hypotheses are verified. Its existing independent review and exact example
certificates are retained unchanged; the old example is not evidence for the
new surface or family.

The identification of the integral degree-four Hodge defect with
\(H^1(C,\mathbf F_2)/\mathcal A_C\) is the already reviewed result of
Benoist--Ottem, arXiv:1802.01845v3, Proposition 1.1 and Remark 1.2.
This concerns integral mixed 2-torsion, not a counterexample to the smooth
rational Hodge conjecture.

A degree-four isogeny from the two elliptic factors to a genus-two Jacobian
does not identify their direct sum with its cohomology modulo two. Any use of
the elliptic quotients below must retain their integral gluing.

The construction of the surface is classical: Keum, *Every algebraic Kummer
surface is the K3-cover of an Enriques surface*, Nagoya Math. J. 118 (1990),
99--110, DOI `10.1017/S0027763000003019`, Example (3.1), pp. 108--109.
The graph-kernel gluing description is also classical:
Howe--Leprevost--Poonen, arXiv:math/9809210v1, Section 3.2, Propositions 3--4.
A bounded primary-source reading obtained both statements; it found no
classification of this fixed correspondence image. That search is not a
certificate of novelty. The constructions and the particular gluing needed
here are checked directly below.

## 1. The surface and its two kinds of half-fibers

**Proposition 1.** The specified quotient is an Enriques surface. It and its
canonical K3 cover have good reduction at every prime greater than three.
It has smooth half-fibers isomorphic to \(E\) and to \(F\), on which the
canonical cover restricts to \(B\to E\) and \(A\to F\), respectively.
Under \(H^1(-,\mathbf F_2)=\operatorname{Pic}^0(-)[2]\), their cover classes
are \(p\) and \(q\).

**Proof.** For \(v^2=t^3+ct^2+dt\), quotienting by \((0,0)\) gives
\[
X=t+c+d/t,\qquad Y=v(1-d/t^2),\qquad
Y^2=X^3-2cX^2+(c^2-4d)X.
\tag{1}
\]
Apply this with \(t=u+1,c=-3,d=3\) for \(E\), and with
\(t=u-1,c=3,d=2\) for \(F\). These give exactly the specified \(B,A\).
The dual quotients are \(E,F\) after scaling \(X=4t,\ Y=8v\).
Their dual kernels are consequently the specified points \(b,a\).

Write \(\kappa(P,Q)=(-P,-Q)\). The involution \(\tau\) commutes with
\(\kappa\). A fixed point of its action on the singular Kummer quotient would
require \(\tau(P,Q)=(P,Q)\) or \(\tau(P,Q)=(-P,-Q)\). The first equality
requires \(a=0\), and the second requires \(b=0\), both impossible.
On the sixteen two-torsion points, it acts as translation by \((a,b)\),
without fixed points. Thus it exchanges, rather than fixes, the corresponding
exceptional curves on the Kummer resolution. Its action on the resolved
surface is free.

The Kummer resolution \(T\) is K3. The form \(dP\wedge dQ\) changes sign
under \(\tau\). Hence its smooth quotient has \(q=p_g=0\), nontrivial
canonical bundle of order two, and canonical cover \(T\): it is Enriques.
The discriminants of the displayed models of \(A,B\) are
\[
\Delta_A=512,\qquad \Delta_B=6912.
\]
Over any DVR of residue characteristic greater than three, these are units.
Blowing up the finite etale two-torsion subscheme and taking the Kummer
quotient constructs the smooth relative Kummer resolution. The same
fixed-point calculation holds on every geometric fiber; its free quotient
and canonical cover therefore extend smoothly and etale over that DVR.

Choose \(P_0\in A\) with \(2P_0=a\). It is not two-torsion. The image of
\(\{P_0\}\times B\) in \(T\) is a smooth copy of \(B\), disjoint from the
exceptional curves. On this copy the involution acts by \(Q\mapsto Q+b\):
\[
[P_0+a,-Q+b]=[-P_0,-Q+b]=[P_0,Q+b].
\]
Its image in \(S\) is \(B/\langle b\rangle=E\). In the fibration obtained
from the first projection, the base involution fixes the point
\(\{\pm P_0\}\); the base quotient is ramified there, so the resulting fiber
is twice this smooth elliptic curve. The restricted K3 cover is \(B\to E\).
The kernel of its pullback on \(\operatorname{Pic}^0\) is the original
kernel \(\langle p\rangle\) of the dual isogeny \(E\to B\). Its cover class
is therefore \(p\).

Likewise, choose \(Q_0\) with \(2Q_0=b\). On the copy of \(A\) represented
by \((P,Q_0)\), \(\tau\) acts by \(P\mapsto P+a\). The second projection
gives the half-fiber \(A/\langle a\rangle=F\), with restricted cover \(A\to F\)
and cover class \(q\). These constructions are over \(\overline{\mathbf Q}\),
which is sufficient for complex cycles. \(\square\)

## 2. Positive cycles, the complementary elliptic quotient, and gluing

Write \(L_s=f_s^*H^1(E,\mathbf F_2)\).

**Proposition 2.** For every rational \(s\ne1\), \(C_s\) is smooth of genus
two, \(L_s\) is a two-dimensional Lagrangian, and \(L_s\subseteq\mathcal A_s\).
Two explicit graphs span this subspace.

**Proof.** The sextic discriminant is
\[
\operatorname{disc}_x((x^2-s)^3+1)=6^6(s^3-1).
\tag{2}
\]
For rational \(s\), it vanishes only at \(s=1\). Its smooth projective
double cover of the \(x\)-line has six branch points, hence genus two.

The map \(f_s\) has degree two and is ramified at the two points with
\(x=0\). Its pullback on \(H^1(-,\mathbf F_2)\) is injective: if a
nontrivial etale double cover of \(E\) became trivial on \(C_s\), the map
\(f_s\) would factor through that cover; degree two would force \(C_s\)
to be isomorphic to an elliptic curve. Cup products of pulled-back classes
are multiplied by two, so this two-dimensional image is Lagrangian.

Let \(i_E:E\hookrightarrow S\) be the half-fiber above, and let
\(\rho(u,v)=(\zeta_3u,v)\). The classes \(p\) and \(\rho^*p\) are distinct
nonzero elements of \(E[2]\), so they form a basis. For \(j=0,1\), the graph
\[
Z_{s,j}=\Gamma_{\,i_E\circ\rho^j\circ f_s}\subset C_s\times S
\tag{3}
\]
is an actual integral one-cycle, and
\(Z_{s,j}^*\alpha=f_s^*(\rho^j)^*p\). These are the required basis.
The analogous automorphism \((u,v)\mapsto(-u,iv)\) of \(F\) takes
\(q=(1,0)\) to the independent point \((-1,0)\), so the \(F\) half-fiber
also realizes all of \(H^1(F,\mathbf F_2)\). \(\square\)

Set \(d=1-s^3\). The complementary elliptic quotient is
\[
Q_s:\ Y^2=X^3-3sX+1+s^3,\qquad
g_s(x,y)=\left(s^2+\frac{d}{x^2},\,\frac{d\,y}{x^3}\right).
\tag{4}
\]
This rational formula extends to a degree-two morphism of smooth projective
curves. Its involution is \((x,y)\mapsto(-x,-y)\); that of \(f_s\) is
\((x,y)\mapsto(-x,y)\). Its invariants are
\[
\Delta(Q_s)=-432(s^3-1)^2,\qquad
j(Q_s)=\frac{-6912s^3}{(s^3-1)^2}.
\tag{5}
\]

Here is the integral gluing, including its mod-two consequence. Let \(r\)
range over the three roots of \(r^3=-1\), and let
\[
W_{r,\pm}=(\pm\sqrt{s+r},0),\qquad
\delta_r=[W_{r,+}-W_{r,-}]\in J(C_s)[2].
\]
The two pullbacks satisfy
\[
f_s^*[(r,0)-O]=\delta_r
 =g_s^*[(sr-r^2,0)-O].
\tag{6}
\]
Indeed, both point fibers are \(W_{r,+}+W_{r,-}\), and both divisors over
the elliptic origin are hyperelliptic fibers of degree two, which are
linearly equivalent. The three nonzero \(\delta_r\)'s sum to zero.

The homomorphism
\[
\psi:E\times Q_s\longrightarrow J(C_s),\qquad
(u,v)\longmapsto f_s^*u+g_s^*v
\]
has degree four. Its dual is \((f_{s,*},g_{s,*})\); their composition is
\([2]\times[2]\). The cross terms vanish because the two quotient
involutions have opposite actions on the respective elliptic subvarieties.
Thus \((\deg\psi)^2=16\). Equation (6) identifies all four points of
its kernel:
\[
\ker\psi=\{(t,\phi_s(t)):t\in E[2]\},\quad
\phi_s(r,0)=(sr-r^2,0).
\tag{7}
\]
In particular,
\[
g_s^*H^1(Q_s,\mathbf F_2)
 =f_s^*H^1(E,\mathbf F_2)=L_s,
\tag{8}
\]
not a second complementary two-dimensional subspace.

## 3. Exact image for all but four rational parameters

**Theorem 3.** If
\[
s\in\mathbf Q\setminus\{1,0,-1,-2,-1/2\},
\]
then
\[
\mathcal A_s=L_s,\qquad
D_s\simeq(\mathbf Z/2)^2.
\tag{9}
\]
The upper bound applies to correspondences defined anywhere over \(\mathbf C\).

**Proof.** Write \(s=a/b\), with \(b>0\) and \(\gcd(a,b)=1\), and put
\[
N=a^2+ab+b^2.
\]
It is odd. If \(3\mid N\), then \(a=b\not\equiv0\pmod3\); writing
\(a=b+3k\) gives
\[
N=3(b^2+3bk+3k^2),
\]
so \(v_3(N)=1\). If \(N\) has no prime divisor greater than three, it
must therefore be \(1\) or \(3\). The identity
\[
4N=(2a+b)^2+3b^2
\]
then implies \(1\le b\le2\) and \(|a|\le2\).
Checking this *proved exhaustive range* gives precisely
\[
(a,b)=(-2,1),(-1,1),(0,1),(1,1),(-1,2).
\tag{10}
\]
Thus any parameter in the theorem has a prime \(\ell>3\) dividing \(N\).

This prime does not divide \(b\). Modulo \(\ell\), \(s\) is a primitive
cube root of unity: \(s^2+s+1=0\) but \(s\ne1\).
The special curve is
\[
y^2=x^2(x^4-3s x^2+3s^2).
\tag{11}
\]
The quartic has discriminant \(432s^6\), a unit at \(\ell\), and has no
zero root. Thus the special fiber is irreducible with exactly one
ordinary nonseparating node, at \(x=y=0\). Its normalization has genus one.
The hyperelliptic model is smooth at infinity. Locally at the node, the
nondegenerate quadratic part gives \(uv=\varepsilon\pi^n\), with
\(n=v_\ell(1-s^3)>0\) and \(\varepsilon\) a unit. Resolution inserts a
chain of rational curves; the accepted arithmetic transfer theorem covers
every thickness \(n\), not only \(n=1\).

In the six-branch-point description
\[
J(C_s)[2]\simeq
\{\text{even subsets of the six branch points}\}/
\{\text{subset}\sim\text{complement}\},
\tag{12}
\]
the vanishing vector is the pair of branch points colliding at zero.
This is \(\delta_r\), where \(r=-s\) in the residue field and \(r\ne-1\).
The other two roots of \(r^3=-1\) are exchanged by the absolute Galois
group of \(\mathbf Q\). Their vectors are distinct and span \(L_s\).
The pairing in (12) is the parity of the intersection of two subsets.
Consequently their span is Lagrangian and its annihilator is itself.

By Proposition 1 the cover extends etale at \(\ell\). The accepted transfer
theorem gives
\(\mathcal A_s\subseteq(\sum_\sigma\sigma\delta_r)^\perp=L_s\).
Its descent and norm arguments include every complex correspondence;
no rationality assumption on the individual cycles has been inserted.
Proposition 2 gives the opposite inclusion and explicit basis cycles.
The reviewed identification \(D_s=H_s/\mathcal A_s\) finishes the proof.
\(\square\)

This changes the mathematical content relative to the prior rank-four
arithmetic example: there is now a prescribed, nonzero algebraic image,
with actual cycles, and an exact rank-two nonalgebraic quotient throughout
the displayed rational parameter set. It is not a new proof of maximality
from irreducibility. Its publication-level originality has not been established.

## 4. What is proved at the four remaining fibers

Write \(\delta_0=\delta_{-1}\), the class of the pair with \(x^2=s-1\).
The following are bounds, not a completed classification:

| \(s\) | \(Q_s\) | \(j(Q_s)\) | Proved information |
|---|---|---|---|
| \(0\) | \(Y^2=X^3+1\) | \(0\) | \(L_s\subseteq\mathcal A_s\); its dimension is \(2\) or \(4\) |
| \(-1\) | \(Y^2=X^3+3X\) | \(1728\) | \(L_s\subseteq\mathcal A_s\subseteq H_s\) |
| \(-2\) | \(Y^2=X^3+6X-7\) | \(2048/3\) | \(L_s\subseteq\mathcal A_s\subseteq\delta_0^\perp\); dimension \(2\) or \(3\) |
| \(-1/2\) | \(Y^2=X^3+\tfrac32X+\tfrac78\) | \(2048/3\) | \(L_s\subseteq\mathcal A_s\subseteq\delta_0^\perp\); dimension \(2\) or \(3\) |

**Proposition 4 (additional universal exclusion at three).** The two last
upper bounds in the table hold for all complex correspondences. In particular,
both of these fibers have nonzero integral Hodge defect.

**Proof.** Work over the extension of \(\mathbf Q_3\) with uniformizer
\(\pi\) satisfying \(\pi^4=3\). The substitution
\[
u=-1+\pi^2 U,\quad v=\pi^3 V
\]
gives the good model
\[
E:\quad V^2=U^3-\pi^2U^2+U,\qquad \Delta=-16.
\tag{13}
\]
The point \(p\) remains the nonzero point \((0,0)\). For \(B\), scaling
\(x=\pi^2U,\ y=\pi^3V\) gives
\[
B:\quad V^2=U^3+2\pi^2U^2-U,\qquad \Delta=256.
\tag{14}
\]
The surface construction of Proposition 1 now applies over this DVR:
\(A\) already has good reduction at three, and \(2\) is invertible.
Thus \(S\) and its etale canonical cover have good reduction here.

For \(s=-2\), the substitution \(x=\pi X,\ y=\pi^3Y\) gives
\[
Y^2=X^6+2\pi^2X^4+4X^2+\pi^2.
\tag{15}
\]
For \(s=-1/2\), first set \(t=\sqrt2\,x,\ w=2\sqrt2\,y\), allowing a
further unramified quadratic extension. Then
\[
w^2=t^6+3t^4+3t^2+9.
\]
Putting \(t=\pi X,\ w=\pi^3Y\) gives
\[
Y^2=X^6+\pi^2X^4+X^2+\pi^2.
\tag{16}
\]
Both reductions are \(Y^2=X^2(X^4+1)\) in characteristic three.
The quartic is separable, the points at infinity are smooth, and the node
has thickness two. In each model the colliding pair is exactly the original
pair \(x^2=s-1\); the other four branch points reduce to distinct nonzero
points. The vanishing vector is therefore \(\delta_0\).
Apply the accepted arithmetic transfer theorem over this number-field
extension. It gives \(\mathcal A_s\subseteq\delta_0^\perp\), which has
dimension three. No additional vanishing line is obtained by conjugation:
the pair defining \(\delta_0\) is rationally invariant. \(\square\)

For an explicit nonalgebraic class in each of these two fibers, take
\(\eta=(1+\sqrt{-3})/2\) and
\[
\beta_s=[W_{-1,+}-W_{\eta,+}]\in H^1(C_s,\mathbf F_2).
\tag{17}
\]
Its branch subset meets that of \(\delta_0\) in one point, so
\(\langle\beta_s,\delta_0\rangle=1\). Hence \(\beta_s\notin\mathcal A_s\).
If \(\widetilde\beta_s\in H^1(C_s,\mathbf Z)\) is any lift and
\(\gamma\) is the nonzero element of \(H^3(S,\mathbf Z)=\mathbf Z/2\),
then \(\widetilde\beta_s\otimes\gamma\) is an integral Hodge class which
is not algebraic. It is independent of the chosen lift. This is an explicit
torsion obstruction, not an asserted exact rank of the whole defect.

For \(s=0\), multiplication of \(x\) by \(\zeta_3\) is an automorphism of
\(C_0\). It cyclically permutes the three nonzero elements of \(L_0\).
The symplectic pairing identifies \(H_0/L_0\) with \(L_0^\vee\), so its
action on this quotient is irreducible over \(\mathbf F_2\). The algebraic
image is preserved by this automorphism and contains \(L_0\). Thus it is
either \(L_0\) or all of \(H_0\), not a three-dimensional subspace.
This argument does not decide which possibility occurs.

At \(s=-1\), \(Q_s\) is geometrically isomorphic to \(F\); choosing
\(c^2=-3\), the scaling \(X=c\,u,\ Y=c^{3/2}v\) identifies their equations.
Hence the \(F\) half-fiber supplies graph cycles through \(g_s\).
Equation (8) shows that their classes still span the *same* \(L_s\).
They do not supply two more independent classes.

## 5. Remaining obstruction and rejected shortcut

The missing mathematics is a positive construction outside \(L_s\), or a
universal exclusion of such constructions, at each of the four named
parameters. At \(0\) the remaining alternatives for \(D_s\) have ranks
two and zero; at \(-1\) ranks two, one and zero remain; at \(-2,-1/2\)
ranks two and one remain. A single unconstructed class is not counted as
algebraic.

There is a specific limitation of the accepted odd-place vanishing-cycle
method here, not just an unsuccessful search for primes. For all four
parameters the sextic models have good reduction at primes greater than
three. At three, \(Q_0=E\) has the good model (13), and
\(Q_{-1}:Y^2=X^3+3X\) has the good model
\[
V^2=U^3+U,\qquad X=\pi^2U,\quad Y=\pi^3V.
\tag{18}
\]
The two elliptic curves in (7) consequently have good reduction over a
finite extension at three for \(s=0,-1\). Their graph of two-torsion extends
as a finite etale subgroup, and the quotient is an abelian scheme with
generic fiber \(J(C_s)\). Thus these two Jacobians have potentially good
reduction. In a semistable curve model their dual graphs have no cycles:
the torus of the identity component of the special Picard group has rank
equal to that first Betti number, whereas a good Jacobian has no such torus.
Their geometric vanishing spaces are therefore zero. For \(-2,-1/2\),
(15)--(16) give exactly the one vanishing line
\(\langle\delta_0\rangle\), unchanged by further ramified base change and
fixed by the global Galois action. Hence collecting **all** odd-place
vanishing spaces gives dimensions \(0,0,1,1\), respectively.
This method alone cannot turn any of the four current bounds into the
requested complete image classification. It says nothing about a different
obstruction, or about characteristic-two methods outside its hypotheses.

The route of obtaining the missing classes simply by adding the two elliptic
pullback images is disproved by (6)--(8). In particular it fails precisely
where \(Q_s\) becomes isomorphic to one of the known half-fibers. A degree-four
isogeny cannot be inverted on integral or mod-two cohomology.

A bounded numerical probe of invariant rational graphs of degrees
\((2,1)\) and \((1,2)\) on the Kummer base supplied no candidate at these four
parameters. It is neither an exact exclusion of those graphs nor any
exclusion of correspondences. No upper bound or rank in this manuscript
uses that numerical probe.

There is no complete-family or publishable-result claim. Independent review
is requested for the new propositions and exact arithmetic, not acceptance
of the unfinished mission.

## 6. Exact replay and its scope

Run

```bash
python3 research/enriques-bielliptic-defect/verify_family.py
```

The program checks the symbolic isogeny, quotient, discriminant, and local-model
identities; the proved-bounded Diophantine enumeration; the full finite
mod-two vector space and its pairings; and the captured typed resultant.
The output is exact arithmetic, not a certificate that arbitrary complex
cycles have been enumerated. The universal bounds are proved by the geometric
and arithmetic arguments above and require independent proof review.

The Jacobian operation was
`polynomial.multivariate.resultant.compute`, with its inspected contract,
exact payload, and full typed response in the adjoining dedicated JSON files.
It returned \(-46656s^3+46656\) for the resultant of the sextic and its
derivative, hence (2) after the degree-six discriminant sign. Server
`jacobian` version `0.14.0`, protocol `2025-11-25`, adapter exit status zero,
no timeout and no structured error are recorded separately. This operation
checks the discriminant, not algebraicity or completeness.
