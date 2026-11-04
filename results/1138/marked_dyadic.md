# A marked half-fiber obstruction to the proposed dyadic model

This note concerns the **previously fixed** Lieberman Enriques surface
\[
 S=\operatorname{Km}(A\times B)/\langle\tau\rangle,\qquad
 \tau(P,Q)=(P+a,-Q+b),
\]
where
\[
 A:y^2=x^3-6x^2+x,\quad B:y^2=x^3+6x^2-3x,\qquad a=b=(0,0).
\]
It does not replace this surface by the new dyadic example.

The local elliptic calculation validates the suggested numerical window
\(1/6<v(\gamma)\leq1/4\). However, the actual marked surface rules out
**every** positive \(v(\gamma)\) in a smooth projective model with canonical
Picard subgroup \(G_{\gamma,2/\gamma}\). The obstruction is an already
constructed half-fiber with a nontrivial component class at two.

The new proof below is submitted for independent review. It excludes a
model hypothesis, not either possible value of \(\mathcal A(B,S)\).
The uniform cyclic \(2\)-power classification, \(D_0\), originality and
publication significance remain unresolved.

## 1. Inputs and comparison with prior results

The following retained, independently reviewed campaign results are inputs:

1. `../../classification.md`, Propositions 1--2, constructs this surface
   and its \(E:y^2=x^3+1\) and \(F:y^2=x^3-x\) half-fibers. Their graph
   cycles and CM automorphisms realize all of \(E[2]\) and \(F[2]\).
2. `../../../enriques-half-fiber-defect/family_theorem.md`, Sections 2--3,
   constructs an actual marked half-fiber on this same surface. At
   \(a_0=3+2\sqrt2\), so that \(a_0+a_0^{-1}=6\), it is
   \[
   C:\quad Y^2=X(X^2+68X+1024),\qquad \eta=(0,0).
   \tag{1}
   \]
   Its canonical-cover class is \(\mathcal O_C(\eta-O)\).
   This is the \(\lambda=33\) member, not an unmarked isogenous curve.
3. `../../../enriques-dyadic-defect/dyadic_theorem.md`, Section 2,
   gives the reviewed determinant construction for correspondences.
   Section 4 below checks the extra hypotheses needed with a **regular
   semistable**, rather than smooth, external curve. The previous
   proposition is not silently applied beyond its statement.

The input paths above are relative to this note's directory. The precise
campaign-root paths are also recorded in the ledger assumptions.

A bounded primary-source lookup obtained Matsumoto,
*Supersingular reduction of Kummer surfaces in residue characteristic 2*,
arXiv:2302.09535v1, Theorem 1.2: an abelian surface with good supersingular
reduction over a characteristic-zero Henselian DVR of perfect residue
characteristic two has a Kummer surface with potential good reduction.
Here good reduction allows a smooth proper **algebraic space**. This does
not construct a projective model of the marked Enriques quotient or
identify its Picard torsion. This contextual theorem is not a step in the
obstruction proof below.

Previously the valuation window and the existence of the required marked
model were both open. Sections 2--3 settle the local calculation; Sections
4--6 show that the geometric hypothesis is impossible. The accepted
degree-three reduction in `../marked_cover.md` still gives
\[
 D_0\simeq(B[2]/\mathcal A(B,S))^2.
\]
Nothing below selects its value. The older odd-place vanishing-cycle
route, integral-lattice-only inference, and excluded elliptic constructions
remain retired for their recorded reasons.

## 2. Exact good elliptic models and their marked valuations

Work after a finite dyadic extension containing the displayed constants,
and normalize \(v(2)=1\). On a good model with identity \([0:1:0]\), use
\(t=-X/Y\). All special fibers in this section are supersingular.

### The curve \(E\)

For \(\ell^3=2\), the substitution
\[
 x=\ell^2X,\qquad y=2Y+1
\]
gives \(Y^2+Y=X^3\), of discriminant \(-27\).
At every nonzero two-torsion point, \(t^3=-2\), so \(v(t)=1/3\).

### The curve \(F\)

Choose
\[
 3r^4-6r^2-1=0,\quad s^2=3r,\quad
 h=(3r^2-1)/(2s),\quad u^2=2.
\]
Then \(h^2=r^3-r\), and
\[
 (x^3-x)-[s(x-r)+h]^2=(x-r)^3.                  \tag{2}
\]
The change
\[
 x=u^2X+r,\qquad y=u^3Y+u^2sX+h
\]
gives
\[
 Y^2+(2s/u)XY+(2h/u^3)Y=X^3.                    \tag{3}
\]
All roots \(r\) are units, and
\((r^2-1)^2=4/3\). Therefore \(v(r-1)=v(r+1)=1/2\):
their valuations sum to one, and their difference is two.
It follows that \(v(s)=0\), \(v(h)=1/2\).
The coefficients in (3) have valuations \(1/2\) and zero.
Its discriminant is \(64/u^{12}=1\), so (3) is a good model.

For \(e=0,1,-1\), the formal coordinate of the point \((e,0)\) is
\[
 t_e=\frac{u(e-r)}{s(e-r)+h}.
\]
Equation (2) gives
\([s(e-r)+h]^2=-(e-r)^3\). Consequently
\[
 v(t_0)=1/2,\qquad v(t_1)=v(t_{-1})=1/4.         \tag{4}
\]
These are exact algebraic valuations, not a numerical approximation.

### The marked curve \(B\)

Choose \(w^3=4\). The flex \((1,2)\) has tangent \(y=3x-1\).
The substitution
\[
 x=w^2X+1,\qquad y=w^3Y+3w^2X+2
\]
gives
\[
 \mathcal B:\quad Y^2+(6/w)XY+Y=X^3,\qquad
 \Delta=216/w^3-27=27.                         \tag{5}
\]
Here \(v(6/w)=1/3\). In particular this is a good supersingular model.
For a nonzero two-torsion point with old coordinate \(e\),
\[
 t_e=\frac{w(e-1)}{3e-1},\qquad
 (3e-1)^2=-(e-1)^3.                            \tag{6}
\]
At \(b=(0,0)\), \(t_b=w\), of valuation \(2/3\).
At \(e=-3\pm2\sqrt3\), one has \(v(e-1)=1\), whence
\[
 v(t_b)=2/3,\qquad v(t_{-3+2\sqrt3})
                     =v(t_{-3-2\sqrt3})=1/6.  \tag{7}
\]

## 3. What the local Hom test does and does not imply

For any of the good models
\[
 Y^2+cXY+dY=X^3,\qquad d\in R^\times,
\]
the whole finite scheme of two-torsion is in the chart \(Y\ne0\):
its special fiber is supported at the identity. Put \(t=-X/Y\),
\(z=Z/Y\). The curve and inverse-fixed equations generate
\[
 (t^3+z-ctz+dz^2,\ t(2-ct+dz),\ z(2-ct+dz))
     =(z-t^3,\ dt^4-ct^2+2t).                 \tag{8}
\]
The exact identities are checked by `verify_marked_dyadic.py`.
The inverse-chart denominator has square one modulo the latter ideal.
Thus this is an integral scheme calculation, not elimination only over
the fraction field.

For
\[
 G_{\gamma,2/\gamma}
   =\operatorname{Spec}R[q]/(q^2-\gamma q),
\]
a pointed map pulls \(t\) back to \(kq\), with \(k\in R\).
Evaluation at \(q=\gamma\) identifies its possible nonzero generic
images with
\[
 \{P:t(P)/\gamma\in R\}.                       \tag{9}
\]
Conversely this divisibility defines the morphism using (8).
Its generic group-law identity extends by flatness of the source
product and separatedness of the elliptic scheme. This proves (9),
including sufficiency. It persists under every finite DVR extension.

The known positive \(E\) and \(F\) correspondences and the reviewed
smooth-curve extension theorem force
\[
 v(\gamma)\leq \min(1/3,1/4)=1/4.              \tag{10}
\]
Within that range, the two outside \(B[2]\) points are excluded by (9)
exactly when \(v(\gamma)>1/6\); \(b\) is allowed.
Thus \(1/6<v(\gamma)\leq1/4\) is the correct **local** window.
Allowing a homomorphism does not realize a cycle, and these inequalities
do not construct a model of \(S\).

## 4. A connected-Picard graph-specialization lemma

**Lemma.** Let \(R\) be a mixed-characteristic DVR, \(\mathcal S/R\)
smooth projective, and \(\mathcal C/R\) a regular projective semistable
curve with geometrically connected fibers, an \(R\)-section, and smooth
generic fiber. Let
\(G\subset\operatorname{Pic}_{\mathcal S/R}\) be finite flat with
connected geometric special fiber. If \(g\in G(R)\) and \(i:C\to S\)
is a generic-fiber morphism, the pullback class \(i^*g_K\) has an
extension to \(\mathcal C\) of degree zero
on every special-fiber component.

**Proof.** The product \(\mathcal X=\mathcal C\times_R\mathcal S\)
is regular: its projection to the regular scheme \(\mathcal C\) is
smooth. The closure \(\overline\Gamma_i\) is therefore perfect as a coherent
sheaf on \(\mathcal X\). The projection
\(p:\mathcal X\to\mathcal C\) is smooth and proper.

Exactly the reviewed determinant construction gives a relative Picard
class
\[
 \mathcal L\longmapsto
 \det Rp_*(\mathcal O_{\overline\Gamma_i}\otimes\mathcal L)
       \otimes(\det Rp_*\mathcal O_{\overline\Gamma_i})^{-1}.
 \tag{11}
\]
Here \(\mathcal L\) represents the universal \(G\)-class fppf locally.
Pushforward of the perfect complex and its determinant commute with
derived base change. Changing a representative by a line bundle from
the parameter changes (11) only by a line from that parameter: the
rank is one, since the generic graph projects isomorphically to \(C\).
Thus (11) descends as a relative Picard class and specializes
functorially. Its generic value is \(i^*\mathcal L_K\).

Both \(g\) and the identity have the same reduction, since a finite
connected group scheme over the residue field has just its identity
as a geometric point. At the identity (11) is trivial. Consequently
the specialization of (11) at \(g\) is the trivial Picard class on
\(\mathcal C_k\), and its degree on each component is zero.
The section rigidifies the Picard functor, so the resulting Picard
class has an actual line-bundle representative on \(\mathcal C\).
In the application below the elliptic origin supplies the section.

This argument does **not** use separatedness of the full relative
Picard functor of the semistable curve, assert a group-law extension
there by density, or invoke the Neron mapping property on \(G\).
Only the determinant class and its specialization are needed.
After a finite DVR extension, resolve the semistable curve's nodes;
the new curve is again regular and \(\mathcal S\) remains smooth,
so the argument applies anew. \(\square\)

## 5. The actual half-fiber has a persistent nonidentity component

In (1), put \(X=16x\), \(Y=64y+32x\). The resulting model is
\[
 W:\quad y^2+xy=x(x+2)^2.                      \tag{12}
\]
It has \(c_4=97\), \(\Delta=528=16\cdot33\), and
\(j=912673/528\). The point \(\eta\) is still \((0,0)\).
The special cubic has a split node at \((0,0)\), with tangents
\(y=0\) and \(y+x=0\); its origin is a smooth point at infinity.

Here is an explicit regular resolution, avoiding an inference from
the \(j\)-valuation alone. Blow up the closed point \((2,x,y)\).
The \(2\)-chart, with \(x=2x_1,y=2y_1\), is
\[
 y_1^2+x_1y_1=2x_1(x_1+1)^2.                 \tag{13}
\]
Its only remaining singular point is \(2=x_1=y_1=0\).
On the \(x\)-chart write \(y=xz,\ 2=xw\); the equations are
\[
 xw=2,\qquad z^2+z=x(1+w)^2.                  \tag{14}
\]
The second equation has unit derivative in \(z\) at two.
This chart is etale over the regular surface \(xw=2\).
The \(2\)- and \(x\)-charts cover the exceptional locus: the initial
tangent cone is \(Y(Y+X)=0\), with no projective point where
both the \(2\)- and \(x\)-coordinates vanish.

Blow up the remaining point in (13). Its \(2\)-chart is
\[
 x_1=2u,\quad y_1=2v,\qquad
 v^2+uv=u(2u+1)^2.                            \tag{15}
\]
Modulo two, put \(f=v^2+uv+u\). The exact identity
\[
 f+(u+v+1)\,\partial f/\partial u=1
 \quad\text{over }\mathbf F_2
 \tag{16}
\]
proves this chart smooth. The other required chart, with
\(y_1=x_1z,\ 2=x_1w\), is
\[
 x_1w=2,\qquad z^2+z=w(x_1+1)^2,              \tag{17}
\]
and again the derivative in \(z\) is a unit.
The second tangent cone \(Y^2+XY-XZ=0\) is a smooth conic
covered by these charts. No further chart is omitted.

The special fiber is a reduced cycle of four rational curves:
the normalized original cubic \(\Gamma_0\), the two lines from the
first blow-up \(\Gamma_1,\Gamma_3\), and the conic from the second
\(\Gamma_2\). Equations (14) and (17) show the four transverse
adjacencies. Every component has multiplicity one, and hence
self-intersection \(-2\).
The origin meets \(\Gamma_0\).
The section \(\eta\) passes through both blow-up centers and in (15)
is \(u=v=0\), a smooth point of \(\Gamma_2\), away from the adjacent
components. Thus its component is \(2\) in the four-cycle.

This conclusion survives **every** finite dyadic extension.
If its absolute ramification index is \(e\), each node of this
semistable model becomes locally \(UV=\pi^e\), after absorbing a
unit. Its resolution inserts \(e-1\) components between the old
neighbors. Explicitly, blowing up \((U,\pi)\) leaves
\(U_1V=\pi^{e-1}\) on one chart and a regular chart on the other;
induction gives the chain. Equivalently its regular charts have
\[
 U=\pi^i a,\quad V=\pi^{e-i-1}b,\quad ab=\pi,
 \qquad 0\leq i<e.
 \tag{18}
\]
The whole fiber is therefore a cycle of length \(N=4e\).
The sections remain on the old components: \(O\) has index zero
and \(\eta\) index \(2e\).

In particular, \(\mathcal O_C(\eta-O)\) has **no** extension of
degree zero on every component. Indeed, any extension differs from
the section-divisor extension by a vertical divisor
\(\sum n_j\Gamma_j\); regularity and a generic trivialization prove
this directly. Its component degrees would be
\[
 d_j=\delta_{j,2e}-\delta_{j,0}
                -2n_j+n_{j-1}+n_{j+1},\quad j\in\mathbf Z/N.
 \tag{19}
\]
But the exact cyclic telescoping identity is
\[
 \sum_{j=0}^{N-1}j\,d_j
       =2e+N(n_0-n_{N-1})\not=0.              \tag{20}
\]
The last inequality follows from \(N=4e\) and \(e>0\);
it is not a bounded check of ramification indices.
Thus the generic marked class has a nonzero component class after
every finite extension.

## 6. Exclusion of the proposed surface model

**Theorem.** No smooth projective model of this fixed \(S\) over
any finite dyadic DVR extension has a finite flat relative Picard
subgroup \(G\) with generic fiber \(\{O,K_S\}\) and connected special
fiber. In particular it cannot have canonical Picard subgroup
\(G_{\gamma,2/\gamma}\) with \(v(\gamma)>0\).

**Proof.** Suppose such a model exists. Enlarge the field so that the
reviewed marked half-fiber inclusion \(i:C\hookrightarrow S\) is
defined. This does not change connectedness of the geometric special
fiber of \(G\).
The generic point \(K_S\) extends to a section of \(G\), since \(G\)
is finite and proper. Apply the lemma to its section and the graph
of \(i\), using the regular model of \(C\) constructed above and its
resolved base change. It gives a multidegree-zero extension of
\[
 i^*K_S=\mathcal O_C(\eta-O).
 \tag{21}
\]
Equation (20) forbids exactly this extension. This is a contradiction.

If \(v(\gamma)>0\), the special algebra of
\(G_{\gamma,2/\gamma}\) is \(k[q]/q^2\), so it is connected.
The conclusion includes the entire proposed window. \(\square\)

The theorem does not rule out a smooth model with **etale** special
canonical Picard subgroup, or decide whether any such model exists.
For an etale order-two subgroup the coordinate \(\gamma\) is a unit;
(9) then allows all three \(B[2]\) points and supplies no desired
upper bound. Thus this same local-Hom route cannot decide the base
image even if an etale model is constructed.

The obstruction uses a positive curve on the actual surface, not a
failure to find equations and not bad reduction of its Kummer cover.
The new dyadic surface and its accepted counterexample are unaffected.
There is no counterexample here to the smooth rational Hodge conjecture.

## 7. Exact replay and its boundary

Run from the campaign root:

```
python3 research/enriques-bielliptic-defect/exceptional-zero/dyadic-marked/verify_marked_dyadic.py
```

The verifier checks the good-model coordinate identities, the full
integral two-torsion ideal identities, the marked half-fiber change of
variables, all four blow-up charts, the special-fiber smoothness identity,
and the universal cyclic obstruction algebra. It uses exact arithmetic,
not numerical roots or a finite search over extensions.

The inspected Jacobian operation
`number_theory.elliptic_curve.short_weierstrass.discriminant.compute`
returns discriminant one for the scaled short \(F\)-equation
\(y^2=x^3-x/4\). The dedicated payload and typed output retain the
server, protocol and adapter status. That short equation is **not**
itself asserted to be integral at two; (3) supplies the integral model.
The operation does not certify the surface argument.

Independent review must still assess the determinant specialization
lemma for a graph, the use of the retained actual half-fiber, and the geometric
interpretation of the exact charts. The author has not assigned an
independent verdict or claimed publication qualification.
