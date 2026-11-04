# A dyadic finite-flat obstruction for Enriques products

An explicit surface over \(\mathbf Q(\sqrt2)\), its smooth dyadic quotient,
the correspondence-extension argument, and the resulting integral Hodge
obstruction are given below. The polynomial certificates have been replayed;
the geometric proof and publication qualification are submitted for independent
review, not certified by the author. This is a new surface, not the previously
fixed Kummer-Enriques surface. No conclusion concerns a counterexample to the
smooth rational Hodge conjecture.

## 1. Scope and known inputs

Write
\[
G_{a,b}=\operatorname{Spec}R[s]/(s^2-as),\qquad
\Delta(s)=s\otimes1+1\otimes s-bs\otimes s,\quad ab=2.
\]
The Cartier dual is \(G_{b,a}\). The intended base is a dyadic DVR with
\(\pi^2=2\), and the intended Picard torsion is \(G_{\pi,\pi}\).

The source reader `dyadic-primary-sources` inspected these primary sources:

* Christian Liedtke, *Arithmetic Moduli and Lifting of Enriques Surfaces*,
  arXiv:1007.0787v2, Sections 3.3 and 4, especially Lemma 3.6,
  Propositions 3.7 and 4.4, and Theorems 4.7 and 4.9.
  The last theorem gives a projective algebraizable lift with prescribed
  \(G_{\pi,\pi}\) for a supersingular Enriques surface carrying an **ample**
  Cossec-Verra polarization. It does not supply numerical quadrics.
* Bombieri-Mumford, *Enriques' Classification of Surfaces in Char. p, III*,
  Invent. Math. 35 (1976), 197--232, Section 3, pp. 222--223.
  Three generic invariant quadrics give a free torsor with smooth Enriques
  quotient. A numerical triple and its smoothness cannot be inferred merely
  by choosing coefficients. The canonical alpha-two cover is not smooth.
* Benoist-Ottem, *Failure of the integral Hodge conjecture for threefolds of
  Kodaira dimension zero*, Comment. Math. Helv. 95 (2020), 27--35,
  DOI **10.4171/CMH/479**, Proposition 1.1 and Remark 1.2. For a complex
  Enriques surface and curve,
  the degree-four integral Hodge defect is
  \(H^1(C,\mathbf F_2)/\{Z^*\alpha\}\).

The extension proof also uses:

* Knudsen-Mumford, *The projectivity of the moduli space of stable curves.
  I: Preliminaries on "det" and "Div"*, Math. Scand. 39 (1976), 19--55,
  DOI 10.7146/math.scand.a-11642, Definition 1 on pp. 23--24 and
  Theorem 1 on p. 25. Determinants of bounded locally free complexes are
  functorial for quasi-isomorphisms and commute with base change.
  Apply this locally to perfect complexes and glue by its canonical
  isomorphisms. The original scanned pages were read; the PDF and short
  excerpts are in `sources/`.
* Stacks Project, [Tag 0B91](https://stacks.math.columbia.edu/tag/0B91),
  Lemma 36.30.4(1): for a **proper flat morphism of finite presentation**
  and a **perfect complex**, derived pushforward is perfect and commutes
  with arbitrary base change. The flat map below is the smooth ambient
  projection, not the correspondence closure.
* Stacks Project, [Tag 07S7](https://stacks.math.columbia.edu/tag/07S7),
  Lemma 66.14.2: a **free** action of a **finite locally free** group on a
  **projective** scheme has a scheme as fppf quotient, and its quotient
  map is an fppf torsor. Freeness is proved below, not inferred from
  invariance of the equations.

The bounded source search found no verified occurrence of the proposed
good-supersingular, coefficient-prime obstruction. This is not a novelty
verdict. The accepted odd-place theorem and the marked I16 results remain
unchanged. In particular, ordinary finite-etale specialization with
coefficients prime to the residue characteristic is not available here.

There is a mixed-characteristic sign issue in the printed invariant
formula of Liedtke Lemma 3.6. For the action
\[
x_i\longmapsto x_i,\qquad
y_i\longmapsto sx_i+(1-bs)y_i,
\]
direct substitution gives the invariants
\[
x_ix_j,\qquad y_i^2-a x_i y_i,\qquad
x_i y_j+x_j y_i-b y_i y_j.
\tag{1}
\]
The last sign is minus. The printed plus sign agrees only in characteristic
two. This local algebra observation is not being promoted to a new
publication result.

## 2. Correspondence extension

**Proposition (proof submitted for independent review).** Let \(R\) be a
mixed-characteristic DVR, \(\mathcal S/R\) a smooth projective surface and
\(\mathcal C/R\) a smooth projective geometrically connected curve. Let
\(G\subset\operatorname{Pic}_{\mathcal S/R}\) be a finite flat subgroup,
with generic fiber consisting of torsion line bundles. Every integral
one-cycle \(Z\) on \(C_K\times S_K\) induces a homomorphism
\[
\Phi_Z:G\longrightarrow\operatorname{Pic}^0_{\mathcal C/R}
\tag{2}
\]
whose generic fiber is the usual pullback-and-norm correspondence on
line bundles. The construction is compatible with every finite extension
of DVRs. No finite-flatness assumption on the closure of \(Z\) over
\(\mathcal C\) is imposed.

Here are the details that must not be replaced by an appeal to the Neron
mapping property: \(G\) need not be smooth.

Take an integral component of \(Z\), and let \(\overline Z\) be its
scheme-theoretic closure in
\(\mathcal X=\mathcal C\times_R\mathcal S\). The ambient scheme is regular,
so \(\mathcal O_{\overline Z}\) is perfect. The closure is \(R\)-flat.
Let \(p:\mathcal X\to\mathcal C\). A line bundle \(\mathcal L\) representing
a family of Picard classes gives, after base change to its parameter
scheme, the relative Picard class of
\[
\det Rp_*(\mathcal O_{\overline Z}\otimes\mathcal L)
\otimes[\det Rp_*\mathcal O_{\overline Z}]^{-1}.
\tag{3}
\]
The map \(p\) is smooth and proper. Pushforward preserves perfect
complexes and commutes with arbitrary derived base change here; determinant
lines commute with pullback. Changing a representative by a line bundle
from the parameter scheme changes (3) only by a line from that scheme:
the rank of the pushed-forward perfect complex is the degree of the
components dominating \(C\), independent of the Picard parameter.
The relative Picard functor supplies representatives fppf locally, so this
argument does not assume the existence of a global Poincare bundle.
Thus (3) descends to a morphism
\(G\to\operatorname{Pic}_{\mathcal C/R}\).

On the generic fiber a component dominating \(C_K\) is finite flat over
that smooth curve, and (3) is its norm. A component over a point of \(C_K\)
contributes the difference of the Euler characteristics of a line bundle
on its support and of the structure sheaf. This difference is zero for a
torsion line bundle. Consequently the generic morphism is the usual group
homomorphism into \(\operatorname{Pic}^0\).

The relative Picard scheme of a smooth proper geometrically connected
curve is separated. Both \(G\) and \(G\times_R G\) are flat over \(R\);
their generic fibers are schematically dense. The identity and group-law
equalities therefore extend from the generic fiber. The degree is zero
everywhere, so the image lies in \(\operatorname{Pic}^0\). The same
density argument gives uniqueness of the extension.

After finite DVR extension, the ambient product is still smooth. Derived
base change in (3) agrees with ordinary base change of
\(\mathcal O_{\overline Z}\), since this sheaf is \(R\)-flat.
Alternatively, uniqueness compares the two extensions directly.
Additivity deals with arbitrary integral coefficients.

This proves extension rather than assuming it. In particular, substituting
the Neron mapping property for (3) would leave a gap, since the finite flat
source is not smooth.

## 3. The direction of the finite-flat obstruction

Let \(R'\) be any finite DVR extension of the dyadic base and normalize
\(v(2)=1\). Consider
\[
\mathcal E:\quad Y^2Z+YZ^2=X^3.
\]
Its discriminant is \(-27\), so this is a smooth elliptic scheme at two.
Its special fiber has no nonidentity geometric two-torsion point.

Every nonzero geometric generic two-torsion point has affine coordinates
\[
y=-1/2,\qquad x^3=-1/4,\qquad
t=-x/y=2x,\qquad t^3=-2.
\tag{4}
\]
Hence \(v(t)=1/3\).

A homomorphism \(G_{\pi,\pi}\to\mathcal E[2]\) sends the identity to the
identity. The whole target is contained in the affine chart \(Y\ne0\):
this holds on the special fiber and hence on the finite scheme over the
local DVR. In that chart \(t=-X/Y\) is regular. Its pullback has the form
\[
t\longmapsto c s,\qquad c\in R',
\]
because the augmentation ideal of \(R'[s]/(s^2-\pi s)\) is \(R's\).
If the generic map is nonzero, its value at \(s=\pi\) gives
\[
1/3=v(t)=v(c)+1/2\ \geq\ 1/2,
\]
a contradiction. If the generic map is zero, flatness of the source and
separatedness of the target make the whole map zero.
Thus
\[
\operatorname{Hom}_{R'}(G_{\pi,\pi},\mathcal E[2])=0
\quad\hbox{for every finite }R'/R.
\tag{5}
\]

In general, a pointed nonzero map between order-two models with nonzero
coordinate values \(a_{\rm source}\) and \(a_{\rm target}\) requires
\(a_{\rm target}/a_{\rm source}\in R'\). The inequality is
\(v(a_{\rm target})\geq v(a_{\rm source})\), not the reverse.
Equation (5) is a valuation argument over all finite extensions, not a
bounded finite-point calculation.

There is an integral coordinate certificate for this calculation. In the
chart \(Y=1\), put \(t=-X/Y\), \(v=Z/Y\). The curve equation and the fixed
equations for the inverse map give
\[
I=(v^2+v+t^3,\ tv+2t,\ v^2+2v)
  =(v-t^3,\ t^4+2t).
\tag{6}
\]
This equality holds over \(\mathbf Z\), not merely over \(\mathbf Q\).
Writing the first three generators as \(f_1,f_2,f_3\) and the last two
as \(g_1,g_2\), explicit identities are
\[
g_1=f_3-f_1,\quad g_2=f_2-tg_1,\quad
f_1=(v+t^3+1)g_1+t^2g_2,\quad
f_2=tg_1+g_2,\quad f_3=(v+t^3+2)g_1+t^2g_2.
\]
Moreover \((1+t^3)^2=1\) modulo \(g_2\), so the inverse-map denominator
is a unit. Consequently
\[
\mathcal E[2]=\operatorname{Spec}R[t]/(t^4+2t).
\tag{7}
\]
Pulling its equation back by \(t=cs\), \(s^2=\pi s\), gives
\[
t^4+2t=2c(\pi c^3+1)s.
\]
For \(c\ne0\), cancellation in the DVR would require
\(\pi c^3=-1\), impossible because \(\pi\) is a nonunit.

**Sharp Hom criterion.** More generally, for \(ab=2\), any finite DVR
extension \(R'/R\), and \(F'=\operatorname{Frac}R'\), evaluation at \(s=a\)
identifies
\[
\operatorname{Hom}_{R'}(G_{a,b},\mathcal E[2])
\quad\hbox{with}\quad
\{O\}\ \cup\
\{P\in E[2](F')\setminus\{O\}:t(P)/a\in R'\}.
\tag{8}
\]
Necessity follows from the augmentation ideal as above. Conversely,
\(c=t(P)/a\in R'\) defines the pointed morphism \(t\mapsto cs\) in (7).
Its generic fiber is a homomorphism from a group of order two. The group-law
identity extends by flatness of \(G_{a,b}\times G_{a,b}\) and separatedness
of \(\mathcal E[2]\). This proves sufficiency. After an extension containing
all two-torsion points, a nonzero homomorphism exists exactly when
\(v(a)\leq1/3\).

Only the **absence** of homomorphisms is used for cycles. A homomorphism
allowed by (8) need not be realized by an algebraic correspondence.

## 4. The explicit smooth projective model

Put \(K=\mathbf Q(\pi)\), \(\pi^2=2\), and
\(R=\mathbf Z[\pi]_{(\pi)}\). Its residue field is \(\mathbf F_2\).
The following numerical quadrics have coefficients in \(\mathbf Z\):
\[
\begin{split}
Q_1&=x_1^2+x_2^2+x_2x_3+x_3^2,\\
Q_2&=x_1x_2+x_1x_3+x_2^2+x_2x_3,\\
Q_3&=x_1x_3+x_3^2.
\end{split}
\tag{9}
\]
In \(\mathbf P^5_R\), let \(\mathcal T\) be the complete intersection
\[
F_i=y_i^2-\pi x_i y_i+
       (x_jy_k+x_ky_j-\pi y_jy_k)+Q_i(x_1,x_2,x_3),
\qquad (i,j,k)=(1,2,3),(2,3,1),(3,1,2).
\tag{10}
\]
Here and below the equation is \(F_i=0\). The action in (1), with
\(a=b=\pi\), preserves these three equations. On the generic fiber its
nonidentity element is the explicit involution
\[
\tau(x_i)=x_i,\qquad \tau(y_i)=\pi x_i-y_i.
\tag{11}
\]
Define \(S_{\rm new}=\mathcal T_K/\langle\tau\rangle\). We next prove that
this quotient has the claimed smooth projective model over \(R\).

### 4.1 Flatness and a free action

Modulo \(\pi\), the equations in (10), considered as polynomials in the
\(y_i\) over \(\mathbf F_2[x_1,x_2,x_3]\), have pairwise coprime leading
monomials \(y_1^2,y_2^2,y_3^2\) for an order that first compares total
\(y\)-degree. They are a regular sequence; their affine homogeneous ring
is free over \(\mathbf F_2[x_1,x_2,x_3]\) on the eight square-free
\(y\)-monomials. Lifting a regular sequence over a DVR proves that
\(\mathcal T\) is flat and is a relative complete intersection.

The plane \(x_1=x_2=x_3=0\) misses the special fiber: its equations would
be \(y_1^2=y_2^2=y_3^2=0\), which has empty projective spectrum.
The intersection of this plane with \(\mathcal T\) is proper over the
local DVR. A nonempty proper closed subset cannot lie only over its
generic point. Thus the plane misses all of \(\mathcal T\).

Similarly, the opens
\[
U_i=D_+(x_i)\cap D_+(x_i-\pi y_i)
\tag{12}
\]
cover \(\mathcal T\): their complement is proper and has empty special
fiber. They are stable under the action, since
\[
x_i-\pi y_i\longmapsto(1-\pi s)(x_i-\pi y_i),\qquad
(1-\pi s)^2=1.
\]
On \(U_i\), \(r=y_i/x_i\) transforms as
\[
r\longmapsto r+s(1-\pi r),
\]
where \(1-\pi r\) is a unit. Its stabilizer is therefore the identity
as a group functor, including on nonreduced test schemes. This proves
freeness, not just absence of fixed geometric points.

Tag 07S7 now gives a scheme quotient
\(\mathcal S=\mathcal T/G_{\pi,\pi}\) and a finite locally free torsor
\(\rho:\mathcal T\to\mathcal S\) of degree two. Flatness of
\(\mathcal S/R\) descends along this faithfully flat map.

Projection using the \(x_i\) gives a finite morphism
\(\mathcal T\to\mathbf P^2_R\). Indeed, its preimage over each standard
affine chart of \(\mathbf P^2\) is affine (with three \(y\)-coordinates),
and the morphism is proper, hence finite. The projection is invariant.
Over an affine chart its invariant algebra is a submodule of a finite
module over a Noetherian ring, so its affine quotient is finite.
Consequently \(\mathcal S\to\mathbf P^2_R\) is finite. In particular
\(\mathcal S\) is projective, not just a formal scheme or a proper
algebraic space.

### 4.2 Explicit quotient equations

The quotient of \(U_i\) has the following affine presentation. Put
\[
x=x_j/x_i,\quad y=x_k/x_i,\quad r=y_i/x_i,\quad
z=(x_i y_j+x_j y_i-\pi y_i y_j)/x_i^2,\quad
w=(x_i y_k+x_k y_i-\pi y_i y_k)/x_i^2,
\]
\[
h=r^2-\pi r,\qquad D=1+2h.
\]
Write \(q_\ell=Q_\ell(x_1/x_i,x_2/x_i,x_3/x_i)\), with \(x_i/x_i=1\).
The quotient chart is
\[
\operatorname{Spec}
R[x,y,z,w,h,D^{-1}]/(A_i,B_i,C_i),
\tag{13}
\]
where
\[
\begin{split}
A_i&=(h+q_i)D+xw+yz-\pi zw+\pi xyh,\\
B_i&=z^2-\pi xz-x^2h+(w+q_j)D,\\
C_i&=w^2-\pi yw-y^2h+(z+q_k)D.
\end{split}
\tag{14}
\]
These are numerical number-field equations once (9) is substituted,
not unspecified generic coefficients. Their overlap maps are given by
the displayed homogeneous-coordinate ratios.

For completeness, this presentation can be checked without assuming
that invariants commute with reduction. Over (13) adjoin
\[
r^2-\pi r=h.
\tag{15}
\]
Then \(d=1-\pi r\) satisfies \(d^2=D\), and the inverse coordinate formulas
are \(y_j/x_i=(z-xr)/d\), \(y_k/x_i=(w-yr)/d\).
Multiplying the substituted equations (10) by \(D\) gives exactly (14).
The group acts by \(r\mapsto r+s d\). For two roots \(r,r'\) of (15),
\(s=(r'-r)/d\) satisfies \(s^2-\pi s=0\). Thus (15) is a torsor.
An invariant element in its free basis \(1,r\) has zero \(r\)-coefficient,
since \(d\) is a unit. Its invariant algebra is exactly (13).
These identities are among the exact symbolic checks in `verify_dyadic.py`.

### 4.3 Geometric smoothness

In the special fiber, (13)--(14) eliminate \(h\) as
\[
h=xw+yz+q_i.
\]
The two remaining equations are
\[
P_i=z^2+x^2h+w+q_j=0,\qquad
Q_i'=w^2+y^2h+z+q_k=0.
\tag{16}
\]
For each \(i=1,2,3\), `special-smoothness-certificate.txt` gives eight
explicit polynomials \(g_{i,m}\) and eight coefficients \(c_{i,m}\) in
\(\mathbf F_2[x,y,z,w]\) such that
\[
g_{i,1}=P_i,\quad g_{i,2}=Q_i',\quad
\{g_{i,3},\ldots,g_{i,8}\}
 =\{\text{all six two-by-two minors of }J(P_i,Q_i')\},
\]
\[
\sum_{m=1}^8 c_{i,m}g_{i,m}=1.
\tag{17}
\]
Singular constructs these identities, and SymPy independently multiplies
them out over \(\mathbf F_2\), checking their binding to the actual global
quadrics (9). In particular (17) excludes singularities over the entire
algebraic closure. It is not a finite rational-point search.

The three charts cover the quotient special fiber, so \(\mathcal S_0\)
is geometrically smooth. The nonsmooth locus of the flat finitely
presented morphism \(\mathcal S/R\) is closed. Since \(\mathcal S\) is
proper and that locus misses the closed fiber, it is empty. Hence
\(\mathcal S/R\) is smooth and projective.

### 4.4 Enriques fibers and the exact Picard group scheme

Adjunction for the complete intersection gives
\(\omega_{\mathcal T/R}\simeq\mathcal O_{\mathcal T}\).
Its Koszul resolution has terms
\[
0\longrightarrow\mathcal O(-6)\longrightarrow
\mathcal O(-4)^3\longrightarrow\mathcal O(-2)^3
\longrightarrow\mathcal O\longrightarrow\mathcal O_{\mathcal T}
\longrightarrow0.
\]
Projective-space cohomology shows, after every base change,
\(H^0(\mathcal T,\mathcal O)=R\), \(H^1(\mathcal T,\mathcal O)=0\), and
\(H^2(\mathcal T,\mathcal O)=R\). In particular all geometric fibers
are connected and have no nonconstant global functions.

On the generic fiber the torsor is etale. Since \(\mathcal S_K\) is
smooth, \(\mathcal T_K\) is a smooth connected K3 complete intersection.
Its free involution gives an Enriques surface: etale pullback trivializes
the canonical bundle, its norm makes the canonical bundle two-torsion,
\(H^1(\mathcal S_{\bar K},\mathcal O)=0\), and
\(\chi(\mathcal O_{\mathcal S_{\bar K}})=
\chi(\mathcal O_{\mathcal T_{\bar K}})/2=1\). Thus \(p_g=0\) and the
canonical bundle is not trivial.

The smooth projective special fiber is also Enriques. To see the
specialization step explicitly, choose a relative ample divisor \(H\).
Constancy of intersection numbers gives \(K_{\mathcal S_0}\cdot H_0=0\)
and \(K_{\mathcal S_0}^2=0\). The Hodge index theorem then implies
numerical triviality of \(K_{\mathcal S_0}\). Smooth proper base change
with coefficients of characteristic three gives \(b_2=10\), as on the
generic Enriques fiber. A smooth projective surface with numerically
trivial canonical divisor and \(b_2=10\) is an Enriques surface (the
definition used in Liedtke, Section 1). In particular this is a family
to which his Proposition 4.4 applies.

We finally identify the **relative** Picard torsion, not only its two
fibers. The torsor \(\rho\) defines its character morphism
\[
G_{\pi,\pi}^{D}\longrightarrow\operatorname{Pic}^{\tau}_{\mathcal S/R}.
\tag{18}
\]
This is a monomorphism of fppf sheaves. Indeed, if an associated character
line is trivial in the relative Picard functor, then fppf locally on the
parameter base its trivialization pulls back to an invertible function
on \(\mathcal T\). Universal \(H^0(\mathcal O_{\mathcal T})=R\) makes that
function a base unit. Its equivariance therefore forces the character
to be trivial. This argument works on arbitrary, possibly nonreduced,
base changes.

For clarity, Cartier duality here is also explicit. A character of
\(G_{a,b}\) has the form \(1-su\). Its multiplicativity is precisely
\(u^2=bu\), and the multiplication of characters gives
\(\Delta(u)=u\otimes1+1\otimes u-au\otimes u\).
Also \((1-su)^2=1\). Thus \(G_{a,b}^{D}=G_{b,a}\).
For \(a=b=\pi\) this identifies the source of (18) with
\(G_{\pi,\pi}\).

By Liedtke Proposition 4.4 the target of (18) is finite locally free
of rank two. A monomorphism between these finite locally free schemes
of the same rank is an isomorphism. Consequently
\[
\operatorname{Pic}^{\tau}_{\mathcal S/R}\simeq G_{\pi,\pi}.
\tag{19}
\]
In particular the special fiber is supersingular Enriques, with Picard
torsion \(\alpha_2\). Smoothness was asserted for the quotient, not for
its characteristic-two canonical cover.

On the generic quotient chart (13) the canonical K3 cover has the
particularly explicit Kummer presentation
\[
d^2=1+2h,\qquad d=1-\pi r.
\tag{20}
\]
The deck involution changes \(d\) to \(-d\). Its nontrivial character
in (18) is \(u=\pi\), hence is the canonical line bundle on the
Enriques generic fiber.

## 5. All complex correspondences and the three missing classes

**Theorem.** For the explicit number-field surface \(S_{\rm new}\) in
(9)--(11) and \(E:Y^2+Y=X^3\), under any complex embedding,
\[
A=\{Z^*\alpha:Z\in\mathrm{CH}_1(E_{\mathbf C}
                 \times S_{{\rm new},\mathbf C})\}=0,
\qquad
\operatorname{Hdg}^4(E\times S_{\rm new},\mathbf Z)/
\operatorname{cl}\mathrm{CH}^2(E\times S_{\rm new})
 \simeq(\mathbf Z/2)^2.
\tag{21}
\]

First take a cycle defined over a finite extension \(L/K\). At any place
above \((\pi)\), base change the constructed smooth projective models to
the local DVR of \(L\), or its completion. Formation of the relative
Picard functor commutes with this base change, so (19) is preserved.
Section 2 extends the cycle action to a homomorphism
\[
G_{\pi,\pi}\longrightarrow\operatorname{Pic}^0_{\mathcal E/R'}
 =\mathcal E.
\]
It is killed by two, hence factors through \(\mathcal E[2]\), and (5)
makes it zero. Thus its generic action on the canonical line bundle
is zero. Over an algebraic closure, the Kummer isomorphism
\(H^1(-,\mu_2)\simeq\operatorname{Pic}(-)[2]\) identifies this action with
the canonical-cover pullback. No assertion that a possible **constant
arithmetic twist** is trivial before passing to the algebraic closure
is needed.

Now let a cycle have arbitrary complex coefficients. The Hilbert schemes
of the product are defined over \(\bar K\). A connected component
containing its Hilbert point contains a \(\bar K\)-point; the universal
flat family keeps the integral cycle class constant. Fundamental cycles
retain their multiplicities. Thus the original cycle is algebraically
equivalent to one over \(\bar K\), whose finitely many components are
defined over some finite extension \(L/K\). Integral cohomology, including
torsion, is invariant under algebraic equivalence. This is descent of
the cycle **class**, not the false assertion that every complex cycle
itself descends to a number field. Applying the preceding paragraph
proves \(A=0\) for all complex cycles. This is the same general
class-descent argument already established in `../enriques-arithmetic-defect/
arithmetic_defect.md`, Section 4; no odd-place specialization result is
being reused at the coefficient prime.

For completeness the cohomological identification in (21) is exact.
For a complex Enriques surface,
\[
H^2(S,\mathbf Z)=\mathbf Z^{10}\oplus\mathbf Z/2,\quad
H^3(S,\mathbf Z)=\mathbf Z/2,\quad H^4(S,\mathbf Z)=\mathbf Z.
\]
Since the cohomology of \(E\) is torsion-free, the integral Kunneth
decomposition in degree four has precisely the three summands
\[
H^0(E)\otimes H^4(S),\quad
H^1(E)\otimes H^3(S),\quad
H^2(E)\otimes H^2(S).
\]
The outer two are algebraic, including the canonical-divisor torsion
in the last one. The middle summand is identified with \(H^1(E,\mathbf
F_2)\), and the middle component of a correspondence is \(Z^*\alpha\).
This is the Benoist-Ottem calculation cited in Section 1. Thus (21)
follows with no remaining unidentified Kunneth summands.

Here are the three classes without a numerical-period convention.
Choose \(\kappa^3=2\) and a primitive cube root of unity \(\zeta\).
The nonzero two-torsion points of \(E\) are
\[
P_j=(-\kappa\zeta^j/2,-1/2),\qquad j=0,1,2.
\]
Their Kummer classes
\[
\beta_j=[x+\kappa\zeta^j/2]\in H^1(E,\mathbf F_2)
\tag{22}
\]
are unramified, since the displayed function has divisor \(2P_j-2O\).
They are exactly the three nonzero classes. Let \(\eta\) be the unique
nonzero element of \(H^3(S_{\rm new},\mathbf Z)\), and let
\(\widetilde\beta_j\in H^1(E,\mathbf Z)\) be any integral lift of
\(\beta_j\). Then
\[
\gamma_j=\widetilde\beta_j\boxtimes\eta
       \in H^4(E\times S_{\rm new},\mathbf Z),\qquad j=0,1,2,
\tag{23}
\]
is independent of the lift. The \(\gamma_j\) are the three nonzero
mixed torsion classes, and (21) proves that none is algebraic. Torsion
classes are integral Hodge classes and have zero complex periods;
no numerical period computation is being substituted for nonalgebraicity.

The argument also yields the same zero-image conclusion for any
number-field Enriques model with \(\operatorname{Pic}^{\tau}=G_{a,b}\)
and \(v(a)>1/3\) at this elliptic curve's dyadic place. The explicit
realization (9) is what makes (21) an unconditional example rather
than just that conditional criterion.

## 6. Exact replay, comparison, and remaining review

Run from the campaign root:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/enriques-dyadic-defect/verify_dyadic.py
```

The script checks the invariant equations and signs, the quotient and
torsor coordinate identities, the integral two-torsion algebra, the
actual three chart ideals, and their Bezout identities. The identities
in (17) are stored with explicit coefficients for an independent
polynomial replay. `find_smooth_model.py` records the bounded discovery
experiment: the third tested coefficient tuple was \((57,30,36)\).
That search result alone is not the smoothness proof.

One bounded Jacobian operation was inspected and executed through the
Argus sidecar:
`polynomial.ideal.groebner_basis.compute`, server 0.14.0, protocol
2025-11-25, ten-second computation budget. The exact payload and typed
output are `jacobian-elliptic-payload.json` and
`jacobian-elliptic-output.json`. The adapter exited zero; its outcome was
`COMPUTED`, runtime 535 ms, with no error or timeout, and basis
\((v-t^3,t^4+2t)\). Its domain is **QQ**. The integral equality (6) is
instead justified by the displayed integer-coefficient identities; the
characteristic-two smoothness proof is the separate certificate (17).
No nearby QQ operation was misrepresented as finite-field certification.

The mathematical improvement over the strongest relevant prior campaign
result is specific. The earlier theorem uses geometric vanishing cycles
of a semistable curve at an odd place. The fixed CM elliptic curve here
has potentially good reduction everywhere (and good reduction at two);
after semistable extension its vanishing-cycle space is zero. That
mechanism therefore gives no obstruction for this curve. Here it is
the **non-etale relative Picard torsion of the surface at the coefficient
prime**, the extension theorem, and the strict \(1/2>1/3\) inequality
that exclude every correspondence. The explicit quotient supplies the
arithmetic realization missing from the previously hypothetical route.
No statement about the old fixed surface, its unresolved cup, \(A_B\),
\(D_0\), or descent of \(z_p\) has changed.

This comparison establishes a different mathematical mechanism and an
explicit example, not publication priority by itself. The primary-source
reader found the known very-general and odd-place examples and the known
Enriques lifting construction; the bounded search did not verify an
identical dyadic theorem. **Novelty and substantive publication significance
remain unverified pending independent review.** The Host Reviewer must
read the extension argument, global geometry and Picard identification
as well as replay the exact algebra. A successful algebra program does
not independently verify those geometric proofs.

The official source-citation archiver writes to `research/literature/`,
outside this mission's writable paths. It has not been run with a
different root or a fabricated independent identity. Primary passages
and their exact locators are available here for the normal Reviewer.
The initially mistyped Benoist-Ottem DOI ending in 480 was disproved by
publisher lookup and retired in the ledger; only the verified DOI ending
in 479 is used. No old citation verdict was transferred.
