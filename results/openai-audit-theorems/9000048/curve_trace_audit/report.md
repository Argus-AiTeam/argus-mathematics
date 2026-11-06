# Joint existence of the curve and residue inputs

## Result, fidelity, and boundary

**Theorem (prose proof, submitted for independent review).** The joint
input-existence assertions of `prop:curve-data` and `prop:residue-data` in
the staged September-23-2026 manuscript hold over \(\mathbb C\), with the
manuscript's normal-first adjunction and unnormalized field trace.
There is a nonempty Zariski-open subset of a 21-dimensional affine
fourth-contact family on which **all** the following data coexist:

* a smooth connected curve \(C\), \(g(C)=21\), a reduced six-point
  divisor \(Z\), a degree-four pencil \(H\), and
  \(L=H+Z\), \(\deg L=10\), with the specified \(L^4=K_C\);
* all section dimensions, multiplication identifications, and evaluation
  surjectivity assertions of `prop:curve-data`, including evaluation of
  \(L^n\) at \(Z\) for every \(n\geq3\);
* \(r=\xi u\) with simple common divisor \(Z\), spanning derivative rows
  \(r'(q_j)\), and a reduced zero fiber of \(u_1\) disjoint from \(Z\);
* nonzero \(c_j\) and **one global pair**
  \(P\in H^0(C,L^2(Z))^{\oplus2}\), whose restrictions in compatible
  fourth-root coordinates give holomorphic
  \[
  R_j=(c_j/z_j)r,\qquad p_j=P-(c_j/z_j)r',
  \]
  and satisfy
  \[
  p_j(0)\wedge R_j(0)=1,\qquad
  W_j=R_j(0)\wedge R_j'(0),\qquad
  \sum_{j=1}^6(W_j-1)=-90.
  \]

No counterexample to either proposition is obtained. In particular, the
negative frame-square sign in the trace comparison is **necessary and
correct**; changing it would break the normalization.

The strongest prior result is `J_all_orders` v3: a conditional all-order
jet theorem. Its completed independent Reviewer receipt is
`/home/argustest/zimo/.argus-campaign-9000048/projects/46e84e6fea35/handoffs/bf979be90014/round-0001.json`
(`review.status=done`). This report does not redo that proof or replay its
checker. The mathematical improvement is removal of its geometric
input-existence condition: the global section and all six local
normalizations are now obtained together. Combining the two proofs gives
actual input data for the reviewed finite-jet and formal-limit conclusions.
It gives **no** analytic realization, convergence, algebraization,
Lipman-Zariski counterexample, verified novelty, or publishable-significance
verdict. The earlier Reviewer receipt is not independent approval of this
new theorem.

`verify.py` checks exact algebraic identities, an explicit algebraic
six-vector witness, all possible degree-four ramification partitions,
cohomology arithmetic, and rejecting certificate controls. The geometric
existence, duality, and global section arguments below are prose, not a
kernel formalization. The certificate is not being presented as an
explicit polynomial equation for a selected member \(C\).

## 1. External inputs and elementary replacements

Only the following substantial external propositions are needed.

| Proposition | Primary source and hypotheses | Use |
|---|---|---|
| Serre duality, with cup-product trace | Serre, *Un theoreme de dualite* (1955), DOI `10.1007/BF02564268`, section 3, no.13, Theorem 4, p.22, and no.15, p.23; section 4, no.16, Theorem 5, p.24. Compact smooth complex curves and holomorphic line bundles meet the hypotheses. | Section dimensions and the principal-part obstruction criterion. |
| Projective cohomology comparison | Serre, *Geometrie algebrique et geometrie analytique* (1956), DOI `10.5802/aif.59`, section 3, no.12, Theorem 1, p.19. The varieties are projective over \(\mathbb C\); all sheaves in these calculations are algebraic coherent sheaves. | Transfer of algebraic section/cohomology calculations to the analytic formulation of the jet inputs. |

The Serre duality PDF and excerpt are reused from `research/jet_audit/`;
the earlier Reviewer already inspected this primary statement. The GAGA
PDF, extracted text, and short statement excerpt are in
`research/literature/serre_gaga_*`. The sentence immediately following
GAGA Theorem 1 explicitly includes \(q=0\), resolving the OCR ambiguity
in its inequality. The existing Cartan B source and its completed reading
are retained for the downstream jet theorem; no new use of Cartan B is
needed for the input construction. Native independent citation attribution
and independent review of this new application remain for the Reviewer.

Here are the elementary ingredients, so that no additional unexamined
theorem is hidden in the proof.

On \(\mathbb P^1\), the two-chart Laurent calculation gives
\[
h^0(\mathcal O(n))=\max(n+1,0),\quad
h^1(\mathcal O(n))=\max(-n-1,0).
\]
The four-chart complex on \(\mathbb P^1\times\mathbb P^1\) is the tensor
product of these complexes. Over a field its cohomology gives
\[
h^1(\mathcal O(a,b))=h^1(a)h^0(b)+h^0(a)h^1(b),\quad
h^2(\mathcal O(a,b))=h^1(a)h^1(b).
\tag{1.1}
\]
The same calculation gives \(h^0(\mathcal O(a,b))=h^0(a)h^0(b)\).
Affine-chart coherent acyclicity here is the elementary localization
Cech calculation for the displayed line bundles.

On a smooth projective curve, a line bundle has a rational section and
thus is \(\mathcal O(D)\) for a divisor. Adding or subtracting one point
in the divisor exact sequence changes Euler characteristic by one.
Consequently
\(\chi(B)=\deg B+1-g\), where \(g=h^1(\mathcal O_C)\).
A negative-degree line bundle has no section. Combining these facts
with the cited duality proves the Riemann-Roch calculations used below.
In particular, on an elliptic curve a positive-degree line bundle has
exactly its degree many sections; a nontrivial degree-zero bundle has
none. On a connected compact curve holomorphic functions are constant.

The global residue theorem follows by excising disks and applying
Stokes. For a principal part \(a\) of a line bundle \(B\), its connecting
class pairs with \(s\in H^0(KB^{-1})\) as
\(\sum_q\operatorname{Res}_q(as)\): use cutoff representatives for the
connecting class and the cup-product description in Serre no.15, then
Stokes on each disk. Thus realizability is the vanishing of all these
residue sums. This fixes the normalization without importing a separate
finite-duality theorem.

We replace the cited Bertini application by a first-jet incidence proof
in section 3. We also prove the needed rank-four splitting directly in
section 5. Neither general Bertini, Grothendieck's general splitting
theorem, nor Hartshorne's finite-duality theorem is an unproved dependency
of this proof. No failed mathematical route is being silently reused:
there was no earlier input-existence proof in the supplied project state.

## 2. Elliptic torsion, the quadratic form, and admissible six vectors

The elliptic starting locus is nonempty, even with algebraic data.
Take the smooth projective cubic
\[
E:\quad y^2=x^3-x,\qquad O=[0:1:0],\qquad
P=(i,1-i),\quad T=(0,0).
\]
The cubic discriminant is 64. Its affine partial derivatives have no
common zero, and the derivative in the projective normal direction at
\(O\) is nonzero. The differential \(dx/(2y)\) extends without a zero
or pole at the branch points and at \(O\); it trivializes \(K_E\).
Hence \(g(E)=1\) by duality. The tangent at \(P\) has slope
\(-(1+i)\) and intersection divisor \(2P+T\). Also
\((x)=2T-2O\). It follows that
\[
2(P-O)=-(T-O)=T-O,\qquad 4(P-O)=0.
\]
The degree-zero class \(T-O\) is not trivial: otherwise there would be
a nonconstant function with only one simple pole, whereas
\(h^0(\mathcal O_E(O))=1\). Thus \(D_0=\mathcal O_E(P-O)\) has
**exact** order four. The checker verifies the curve equation,
smoothness tests, tangent identity, and doubling calculation.

For completeness, the usual identification \(E=\operatorname{Pic}^0(E)\)
in the following argument follows from the same dimension calculation.
Every degree-one line bundle has a unique effective divisor \(p\);
this makes \(p\mapsto\mathcal O(p-O)\) surjective and injective.
The addition law is the one induced by tensor product. For a degree-two
bundle of divisor sum \(a\), the two points in a fiber sum to \(a\);
its involution is \(p\mapsto a-p\). A degree-two bundle is basepoint
free because its section dimension is two and that after subtracting
any point is one.

Set \(F=\mathcal O_E(2O)\), \(S=F+D_0\). The associated product map
embeds \(E\) in \(\Sigma=\mathbb P^1\times\mathbb P^1\): a pair of
distinct points cannot be interchanged by both involutions, and a
point cannot be fixed by both, since their centers differ by nonzero
\(D_0\). Thus the map is injective and immersive; properness makes it
an embedding. Its projection degrees are two, so its image \(\Gamma\)
has bidegree \((2,2)\). Write \(F=(1,0)\), \(S=(0,1)\) on \(\Sigma\).

Put \(\Delta=2D_0\), \(\Phi=F|_\Gamma+\Delta\), \(M=3\Phi\).
In the group generated by \(F|_\Gamma,D_0\), with coefficients of
\(D_0\) taken modulo four,
\[
\Gamma|_\Gamma=4F+\Delta,\quad M=3F+\Delta,\quad 2M=6F,
\]
\[
4M=(2\Gamma+4F)|_\Gamma,\quad
2M-(\Gamma+F)|_\Gamma=\Phi,\quad
(\Gamma+2F)|_\Gamma-2M=\Delta.
\tag{2.1}
\]
Fix these identifications compatibly, including \(2\Phi=2F|_\Gamma\).
The certificate checks these equalities in \(\mathbb Z\oplus\mathbb Z/4\).

Since \(K_\Sigma+\Gamma=0\), a nonzero trivializing logarithmic form
\(\Omega\) has nowhere-zero normal-first residue \(\omega\) on
\(\Gamma\). For a basis \(u=(u_1,u_2)\) of the \(F\)-pencil put
\(\eta_\Gamma=u_1du_2-u_2du_1\).
The four branch points of the degree-two \(F\)-map are its fixed
points. The \(\Phi\)-involution is the \(F\)-involution followed by
translation by the nonzero two-torsion point \(\Delta\). It pairs
these four points without fixed points. They therefore form two
distinct reduced \(\Phi\)-fibers. Equivalently, for the explicit
cubic they are \(O,T,(1,0),(-1,0)\), paired by translation by \(T\).

The ramification section \(-\eta_\Gamma/\omega\) consequently is the
pullback of a binary quadratic with two distinct zeros under the
\(\Phi\)-map. The proportionality scalar is fixed by that equality.
Pullback is injective, so this gives a unique, nondegenerate quadratic
form \(Q\) on \(H^0(\Gamma,\Phi)^*\). Its isotropic evaluation
directions are exactly the \(F\)-ramification points.

Here is an exact alternative to the manuscript's small-parameter
cubic argument. In coordinates \(Q(x,y)=xy\), let
\[
t^2=125/313,\quad
d_1=(1,-43/4),\quad
d_2=(t,(133-313t)/8),\quad
d_3=(-t,(133+313t)/8).
\tag{2.2}
\]
Use each row twice. Their sum is \(w=(2,45)\). Direct reduction
modulo \(t^2-125/313\) gives
\[
Q(w)=90,\qquad Q(d_i)+d_i\cdot w=1,\qquad
2\sum_i Q(d_i)-6=-90.
\tag{2.3}
\]
All three norms and all three pairwise determinants are nonzero.
These are exact number-field checks, not numerical approximations.
For example the determinants are
\((133-227t)/8,(133+227t)/8,133t/4\).
The polynomial \(t^2-125/313\) is irreducible over \(\mathbb Q\),
so the recorded nonzero remainders really are nonzero.

To avoid any prescribed finite projective set, apply the isometry
\((x,y)\mapsto(\nu x,\nu^{-1}y)\). Each of the three ratios \(x/y\)
is nonzero and finite; a forbidden nonisotropic ratio excludes at
most two values of \(\nu\in\mathbb C^*\). Isotropic directions are
already avoided. Thus the permitted set of \(\nu\)'s is nonempty
Zariski open. Apply this to the branch values of the \(\Phi\)-map.

Each selected direction then has two distinct inverse images on
\(\Gamma\). These six points are distinct, and form
\(Z\in|3\Phi|=|M|\). Let \(\beta\) be a section with this divisor.
They are unramified for \(F\), by nonisotropy. A degree-two \(F\)-fiber
contains at most two of them, so their \(F\)-values are not all equal.
This proves admissibility of the marked directions and the torsion
construction **together**, rather than assuming an arbitrary six-tuple
of points can be used.

## 3. A nonempty smooth fourth-contact family

Let \(\gamma\) define \(\Gamma\). Restriction from
\(\mathcal O_\Sigma(8,4)=\mathcal O_\Sigma(2\Gamma+4F)\) to \(\Gamma\)
is onto: its kernel is \(\mathcal O_\Sigma(6,2)\), with \(H^1=0\)
by (1.1). Consequently the affine family
\[
\mathcal A=\{\kappa:\kappa|_\Gamma=\beta^4\}
           =\kappa_0+\gamma H^0(\Sigma,\mathcal O(6,2))
\tag{3.1}
\]
has dimension 21.

For any point \(p\notin\Gamma\), the moving system surjects onto the
three-dimensional first-jet space at \(p\). Indeed, in a ruling chart,
the sections corresponding to \(1,x,y\) prescribe value and both
first derivatives; this argument works at every point by changing
the ruling coordinates. Multiplication by the unit \(\gamma\) is
an automorphism of that jet space, of determinant \(\gamma(p)^3\).
Thus the conditions that \(\kappa(p)=d\kappa(p)=0\) impose three
independent affine equations on \(\mathcal A\).
The incidence of singular points off \(\Gamma\) has dimension
at most \(2+21-3=20\). Its projected closure cannot fill
\(\mathcal A\). This proves existence of a nonempty open set smooth
off \(\Gamma\), without an appeal to general Bertini.

No member meets \(\Gamma\setminus Z\). Near \(q\in Z\), write
\[
\gamma=y\mathfrak g,\quad
\kappa=k(y,z)\mathfrak g^2\mathfrak f^4,\quad
\beta=b(z)\mathfrak m,\quad k(0,z)=b(z)^4,
\]
where \(b'(0)\ne0\) and
\(\mathfrak m^4=(\mathfrak g^2\mathfrak f^4)|_\Gamma\).
Changing the moving section varies \(k_y(q)\) nontrivially, because
\(\mathcal O(6,2)\) is globally generated. Thus \(k_y(q)=0\)
is one proper affine hyperplane, not all of \(\mathcal A\).
The complement of these six hyperplanes meets the previous open
set: a finite union of proper closed subsets cannot fill the
irreducible affine space. No independence of the six value
functionals is assumed.

Choose any \(\kappa\) in this nonempty intersection and set \(C=(\kappa)\).
The implicit equation has the expansion
\[
y|_C=-\frac{b(z)^4}{K(z)}+O(z^8),\quad K(z)=k_y(0,z),\quad K(0)\ne0.
\tag{3.2}
\]
Indeed \(k=b^4+Ky+y^2L_2(y,z)\); first \(y\in(z^4)\), and substitution
gives the order-eight remainder. In particular the fourth-order
coefficient is \(-b'(0)^4/K(0)\ne0\). Hence contact is **exactly**
four, not merely at least four, and \((\gamma|_C)=4Z\).

The divisor sequence and
\(H^0(\mathcal O(-8,-4))=H^1(\mathcal O(-8,-4))=0\) give
\(H^0(\mathcal O_C)=\mathbb C\). A smooth projective curve with this
property is connected; its irreducible components cannot meet
smoothly, so it is irreducible. The same sequence gives
\(h^1(\mathcal O_C)=h^2(\mathcal O(-8,-4))=7\cdot3=21\).
Set \(H=F|_C\), \(L=H+Z\), and \(\theta=2L\).
Then \(\deg H=4\), \(\deg L=10\), and adjunction gives
\(K_C=(6,2)|_C=(\Gamma+4F)|_C=4L\).
We use precisely
\[
\xi^4\longmapsto\gamma|_C,\qquad
s|_C\longmapsto\operatorname{Res}_C(s\gamma\Omega/\kappa).
\tag{3.3}
\]
The normal differential is first throughout.

The first ruling restricts to a finite degree-four map \(f:C\to\mathbb P^1\).
Contact identifies its derivative at each marked point with that on
\(\Gamma\); hence it is unramified there. In characteristic zero its
critical values are finite, so choose a regular fiber away from \(f(Z)\).
A determinant-one basis change makes it \((u_1)_0\). It preserves
\(\eta_\Gamma,\eta_C\), hence every quadratic normalization already fixed.

## 4. All section dimensions and interpolation

For \(0\leq j\leq3\) put \(A_j=(6-j,2)\). Its restriction kernels
to \(C\) and to \(\Gamma\) are
\[
(-2-j,-2),\qquad (4-j,0),
\]
respectively. The first has \(H^0=H^1=0\); the second has \(H^1=0\).
Thus \(H^0(A_j)=H^0(C,K_C-jH)\), and restriction to
\(H^0(\Gamma,N_j)\) is onto, with \(N_j=(8-j)F+\Delta\).

For \(1\leq\ell\leq4\), (3.2) gives equality of embedded ideals
\[
(y-y|_C,z^\ell)=(y,z^\ell).
\]
The marked length-\(\ell\) schemes, the ambient bundle restrictions,
and their ambient evaluations are identical. Therefore the two
complete systems have equal evaluation ranks on these schemes.
Using \(Z=3F+\Delta\), the elliptic calculations are:

| \(j\) | \(\ell\) | \(h^0(N_j)\) | \(N_j-\ell Z\) | \(h^0(N_j-\ell Z)\) | rank |
|---|---|---|---|---|---|
| 0 | 1 | 16 | \(5F\) | 10 | 6 |
| 1 | 2 | 14 | \(\Phi\) | 2 | 12 |
| 2 | 2 | 12 | \(\Delta\) | 0 | 12 |
| 3 | 2 | 10 | \(-F+\Delta\) | 0 | 10 |

The nontriviality of \(\Delta\), not just its degree zero, is essential.
Also the fourth surface space has dimension 12, but its elliptic
restriction has dimension 10. Confusing these would give the wrong
dimension for the trace quotient.

The ruling restriction sequence has kernel \((j-8,-4)\) with
\(H^0=H^1=0\), so \(h^0(jH)=j+1\) for \(0\leq j\leq3\).
Euler characteristic and duality applied to a divisor sequence give
\[
h^0(B+D)-h^0(B)=\deg D-\operatorname{rank}
\bigl(H^0(K_C-B)\longrightarrow H^0(D,(K_C-B)|_D)\bigr).
\tag{4.1}
\]
The four rows yield respectively
\[
h^0(\mathcal O(Z))=1,\quad h^0(H+2Z)=2,\quad
h^0(2H+2Z)=3,\quad h^0(3H+2Z)=6.
\]
The inclusions \(H^0(H)\subset H^0(H+Z)\subset H^0(H+2Z)\)
give \(h^0(L)=2\). Equal dimensions in the natural multiplication
inclusions give exactly
\[
H^0(L)=\xi H^0(H),\quad
H^0(H+2Z)=\xi^2H^0(H),\quad
H^0(\theta)=\xi^2H^0(2H).
\tag{4.2}
\]
In particular every section of \(\theta\) vanishes twice at \(Z\).
The pencil has no base points, so \(r=\xi u\) has exactly the simple
common zeros \(Z\). In compatible frames \(r'(q_j)=u(q_j)\).
Their projective directions are \(f(q_j)\), not all equal, so they
span \(\mathbb C^2\).

For any \(n\geq3\), the dual of the cokernel of evaluation of \(L^n\)
on \(Z\) is
\[
H^0(L^{4-n}(Z))/H^0(L^{4-n}).
\]
For \(n=3\) use the equal two-dimensional spaces in (4.2); for \(n=4\)
use \(h^0(\mathcal O(Z))=1\). For **every** \(n\geq5\), the target
bundle has degree \(10(4-n)+6\leq-4\), so both spaces are zero.
This is the universal interpolation assertion, not a finite test.
The auxiliary dimensions \(h^0(3L)=12\), \(h^0(4L)=21\) follow as well.

## 5. Perfect trace, including every ramification type

Put \(\Lambda=\theta+H\) and \(E=f_*\Lambda\). A finite map between
smooth curves is flat: its local modules over the target discrete
valuation ring are torsion-free, hence free. Thus \(E\) has rank four.
Since \(\Lambda^2=K_C+2H\), the expression
\[
B(T_1,T_2)=\operatorname{Tr}_{C/\mathbb P^1}(T_1T_2/\eta_C)
\tag{5.1}
\]
is well defined. It is the field trace, not its average.

Near any point of ramification index \(e\), holomorphic parameters
can be chosen with \(x=w^e\). If a local frame satisfies
\(\tau^2=a(w)\,dw\,\mathfrak f^2\), \(a\) a unit, then (5.1) is
\[
(b,c)\longmapsto\operatorname{Tr}\frac{a(w)bc}{e w^{e-1}}.
\]
For \(a=1\), in the basis \(1,w,\ldots,w^{e-1}\), root-of-unity
summing gives
\[
\operatorname{Tr}\frac{w^{i+j}}{e w^{e-1}}
=\begin{cases}1&i+j=e-1,\\0&\text{otherwise}.\end{cases}
\tag{5.2}
\]
The exponent after division lies between \(-(e-1)\) and \(e-1\);
zero is the only possible multiple of \(e\). This proves that the
meromorphic-looking expression extends holomorphically and perfectly.
The \(1/e\) in (5.2) is the derivative \(dx/dw\), **not** a
normalization of the trace by the total degree four.

Multiplication by \(a\) is an automorphism. At the special fiber its
determinant is \(a(0)^e\), so the Gram determinant is
\((-1)^{e(e-1)/2}a(0)^e\ne0\).
Take the orthogonal sum over all points above the target.
The possible index partitions are
\[
1+1+1+1,\quad2+1+1,\quad2+2,\quad3+1,\quad4.
\]
The checker verifies the trace identity over \(\mathbb Q(x)\) using
the multiplication matrix \(w^e=x\), the symbolic unit determinant,
and all these partitions. Ramification **away from** marked points,
including on the same fiber as a marked point, is fully included.

We can derive the splitting without a general splitting theorem.
Multiplication by \(\xi^2\) gives
\(\mathcal P=\mathcal O_{\mathbb P^1}(3)\to E\).
It is a subbundle: every length-four fiber has an unmarked point,
since at most two points of \(Z\) have a fixed \(F\)-value and they
are unramified. At an unmarked point \(\xi^2\) is a unit, so its
image in the fiber algebra is nonzero. The fiber vector defining
\(\mathcal P\) therefore never vanishes.

This line is isotropic because
\(\operatorname{Hom}(\mathcal O(6),\mathcal O)=0\). Let
\(K=\mathcal P^\perp/\mathcal P\). It is a rank-two bundle with a
perfect symmetric form. All global sections of \(E\), or of \(E(-1)\),
lie in \(\mathcal P^\perp\), or \(\mathcal P^\perp(-1)\), since the
respective quotient line bundles are \(\mathcal O(-3)\) and
\(\mathcal O(-4)\). Equations (4.2) and \(H^1(\mathcal O(3))=
H^1(\mathcal O(2))=0\) give
\[
h^0(K)=6-4=2,\qquad h^0(K(-1))=3-3=0.
\]
At every \(x\), evaluation \(H^0(K)\to K_x\) is injective by the
second equality and hence an isomorphism by dimension. Thus
\(K=\mathcal O^{\oplus2}\). The extensions split because
\[
H^1(\mathcal O(3))=0,\qquad
H^1(\mathcal O(6)\oplus\mathcal O(3)^{\oplus2})=0.
\]
This proves \(E=\mathcal O(3)\oplus\mathcal O^{\oplus2}\oplus\mathcal O(-3)\).
The form on global sections has precisely radical
\(\xi^2H^0(3H)\). Its quotient
\[
W=H^0(\Lambda)/\xi^2H^0(3H)
\]
is two-dimensional and identifies isometrically with every \(K_x\).

If \(q\in Z\), write
\(\tau^2=s\,dz\,\mathfrak f^2\), \(\eta_C=\mathcal E\,dz\,\mathfrak f^2\).
The unramified local factor at \(q\) has form coefficient \(s/\mathcal E\).
Coefficient evaluation has metric dual of square \(\mathcal E/s\).
It kills \(\mathcal P\), since \(\xi^2(q)=0\), so its metric dual
belongs to \(\mathcal P^\perp\). Passing to its quotient preserves
that square. The other Artin-local factors are orthogonal; no
unramifiedness assumption on them is used. Therefore
\[
\ell_q^2=\mathcal E(q)/s(q).
\tag{5.3}
\]

## 6. One global residue-dual comparison, not six scalar choices

Let \(N_\Sigma=\Gamma+F\) and \(D=2Z\). Fourth-order contact identifies
\(D\) on both curves with the same embedded length-twelve scheme.
Adjunction identifies \(N_\Sigma|_C=K_C-3H\), whereas \(\omega\)
trivializes \(K_\Gamma\). The principal-part spaces of \(3H(D)\)
on \(C\) and of \(-N_\Gamma(D)\) on \(\Gamma\) both identify
canonically by residues with
\[
H^0(D,N_\Sigma|_D)^*.
\tag{6.1}
\]
Locally this is the perfect pairing
\((a_{-2},a_{-1})\) against \((s_0,s_1)\) given by
\(a_{-2}s_1+a_{-1}s_0\). Thus (6.1) compares **both**
double-pole coefficients before global realizability is considered.

The restriction kernels for the adjoint ambient system are
\((-5,-2)\) for \(C\) and \((1,0)\) for \(\Gamma\); both have
\(H^1=0\). Hence its complete adjoint jet images in \(H^0(D,N_\Sigma|_D)\)
coincide. On \(\Gamma\), \(h^0(N_\Gamma)=10\), and
\(\deg(N_\Gamma-2Z)=-2\), so that common image has dimension 10.
Its annihilator has dimension two.

By the principal-part criterion in section 1, this same annihilator is
the image of \(H^0(C,\Lambda)\) by \(T\mapsto\operatorname{pp}(T/\xi^2)\),
with kernel \(\xi^2H^0(3H)\), and the image of
\(H^0(\Gamma,\Phi)\) by
\(\widetilde T\mapsto\operatorname{pp}(\widetilde T/\beta^2)\).
The latter map is injective because \(h^0(-N_\Gamma)=0\).
This constructs a **single global** isomorphism
\[
\iota:W\longrightarrow H^0(\Gamma,\Phi).
\tag{6.2}
\]

To compute its scalar, choose the coordinates of section 3 with
\(\Omega=e(y,z)(dy/y)\wedge dz\), \(e(0,z)=1\).
Then \(\omega=dz\), \(e|_C=1+O(z^4)\), and
\(k_y|_C=K(z)+O(z^4)\). Normal-first adjunction sends
\(\mathfrak g\mathfrak f^4\) to \(e|_C\,dz/k_y|_C\), with
**positive** sign: \(dy\wedge dz=dk\wedge dz/k_y\).
Let \(a=\xi/z\), \(\tau=\mathfrak f^3a^2\).
The fourth-power identification gives \(a^4=(y|_C/z^4)\mathfrak g\).
Consequently
\[
\tau^2=s\,dz\,\mathfrak f^2,\qquad
s(0)=-b_1^4/K_0^2,\quad b_1=b'(0),\ K_0=K(0).
\tag{6.3}
\]
The negative sign is from solving the equation of \(C\), not from
reversing the adjunction convention.

Write \(T=\pi\tau\), and \(\widetilde T=\widetilde\pi\,
\mathfrak m^2/(\mathfrak g\mathfrak f)\).
Against a common ambient test section \(A\mathfrak g\mathfrak f\),
the two residue expressions are
\[
\operatorname{Res}\frac{A|_C\pi e|_C}{k_y|_Cz^2}\,dz,\qquad
\operatorname{Res}\frac{A(0,z)\widetilde\pi}{b(z)^2}\,dz.
\]
Their equality on all local test jets is precisely
\[
\operatorname{pp}\frac{\pi}{K(z)z^2}
=\operatorname{pp}\frac{\widetilde\pi}{b(z)^2}.
\]
Writing \(b=b_1z+b_2z^2+\cdots\), \(K=K_0+K_1z+\cdots\), this means
\[
\widetilde\pi_0=\frac{b_1^2}{K_0}\pi_0,\qquad
\widetilde\pi_1=\frac{b_1^2}{K_0}\pi_1+
\left(\frac{2b_1b_2}{K_0}-\frac{b_1^2K_1}{K_0^2}\right)\pi_0.
\tag{6.4}
\]
The checker derives these coefficients by solving the two symbolic
residue equations, not by inserting independently chosen local scalars.
Their triangular determinant is \(b_1^4/K_0^2\ne0\).

For coefficient evaluations, (6.4) gives
\(\iota^*\widetilde\ell=\alpha\ell\), \(\alpha=b_1^2/K_0\).
Contact gives \(\mathcal E_C(0)=\mathcal E_\Gamma(0)\), so (5.3)-(6.3)
give
\[
(\iota^*\widetilde\ell)^2
=\alpha^2\mathcal E_C(0)/s(0)=-\mathcal E_\Gamma(0).
\tag{6.5}
\]
The compatible bundle identities imply
\((\mathfrak m^2/(\mathfrak g\mathfrak f))^2=\mathfrak f^2\);
the right side is exactly \(Q(\widetilde\ell)\). The marked evaluations
use three distinct projective directions. Two binary quadratic forms
agreeing on these directions agree everywhere, since a nonzero binary
quadratic has at most two distinct projective zeros. Thus \(\iota^*\)
is an isometry, with its sign and scalar fixed.

## 7. A single global \(P\) forces all six local normalizations

Choose centered disks and frames \(\ell^{\rm fr}\) with
\((\ell^{\rm fr})^4\mapsto dz\). Taking a fourth root of a unit on a
small disk makes this possible. Set
\[
a=\xi/z,\qquad \mathfrak f=\ell^{\rm fr}/a,\qquad
\tau=(\ell^{\rm fr})^2\mathfrak f.
\]
Then \(r=zu\), and \(\tau^2=dz\,\mathfrak f^2\).
Coefficient evaluation \(l_j\) on \(W\) has
\[
l_j^2=(u_1u_2'-u_2u_1')(q_j).
\tag{7.1}
\]
Transport the previously fixed six vectors by \(\iota^*\):
\(v_j^*=\iota^*w_j\), \(V=\sum v_j^*\).
The global comparison of evaluation directions gives unique
nonzero \(c_j\) with \(c_jl_j=v_j^*\). Thus
\[
V^2=90,\qquad (v_j^*)^2+v_j^*\cdot V=1.
\tag{7.2}
\]

Prescribe the simple principal part \(c_ju(q_j)/z_j\) for a
\(\theta\)-valued row. Every such prescription is globally realizable:
the dual obstruction space is \(H^0(K_C-\theta)=H^0(\theta)\),
and by (4.2) every test section vanishes twice at \(Z\).
Its residue against any simple pole is therefore zero. Applying
this to both entries yields **one global**
\(P\in H^0(\theta+Z)^{\oplus2}\).
It is not a family of independently adjustable regular parts.

Because \(r=zu\), \(R=(c/z)r=cu\) is holomorphic and nonzero at the
center, and \(m r'=(c/z)u+cu'\) has the prescribed principal part;
therefore \(p=P-mr'\) is holomorphic. Equation (7.1) gives
\(W_j=R_j(0)\wedge R_j'(0)=(v_j^*)^2\).
The simple pole in \(u\wedge P\) cancels, so
\[
J=u\wedge P\in H^0(\Lambda).
\]

The global pairing is the decisive constraint on its regular values.
For any \(T\in H^0(\Lambda)\), the differential
\[
\nu=P_1T/u_1
\]
is canonical because \(2\theta=K_C\).
Its only possible poles are at \(Z\) and at the reduced unramified
zero fiber of \(u_1\), chosen disjoint from \(Z\).
At \(q_j\), compatibility of the fourth-root frame gives
\(\operatorname{Res}\nu=c_jl_j(T)\), with no scalar factor.
At a simple zero of \(u_1\),
\[
J=-u_2P_1,\qquad \eta_C=-u_2\,du_1,
\]
so \(\operatorname{Res}\nu=(JT/\eta_C)(q)\).
The two minus signs cancel. The sum over that fiber equals the value
of the **unnormalized** trace, which is a global holomorphic function
on \(\mathbb P^1\) by section 5 and hence constant. The residue theorem
therefore proves
\[
\langle[J],[T]\rangle=-\sum_jc_jl_j(T)=-V([T]).
\tag{7.3}
\]
This derives the pairing before asserting any determinant normalization.

Locally \(P=p+(c/z)u+cu'\), so identically
\[
cJ=R\wedge p+R\wedge R'.
\]
On the other hand (7.3) and (7.2) give
\[
c_jl_j(J)=-v_j^*\cdot V=(v_j^*)^2-1=W_j-1.
\]
Subtracting proves \(R_j(0)\wedge p_j(0)=-1\), equivalently
\(p_j(0)\wedge R_j(0)=1\), at **every** point, for the same global \(P\).
Summing (7.2) gives
\(\sum_j(W_j-1)=-V^2=-90=-9\deg L\).
Also
\[
P=R(0)/z+p(0)+2R'(0)+O(z).
\tag{7.4}
\]
The factor two is checked independently. If a holomorphic
\(\theta\)-valued pair is added to \(P\), (4.2) shows its wedge with
\(u\) belongs to \(\xi^2H^0(3H)\); thus \([J]\) is unchanged.

Finally these statements do not depend on the choice of compatible
coordinates. If \(\zeta=\psi(z)\), the new \(L\)-frame is \(g(z)\ell^{\rm fr}\),
and \(g^4=\psi'\), write \(g_0=g(0)\), \(g_1=g'(0)\). Then
\[
l_{\rm new}=g_0^{-7}l,\quad c_{\rm new}=g_0^7c,\quad
R_{\rm new}(0)=g_0^2R(0),\quad
p_{\rm new}(0)=g_0^{-2}p(0)+6g_1g_0^{-3}R(0).
\tag{7.5}
\]
The coefficient of \(\zeta^{-1}\) in \(P_{\rm new}=g^{-2}P\) is
\(g_0^2R(0)\), exactly the new prescription. Differentiating \(R_{\rm new}\)
with respect to \(\zeta\) gives \(W_{\rm new}=W\); the extra term in
(7.5) is parallel to \(R\), so \(p\wedge R\) is unchanged.
The checker derives the coefficient 6 using symbolic coordinate jets;
the first jet of \(g\) and second jet of \(\psi\) determine these formulas.

This completes the simultaneous-existence proof. The nonempty open
choice of \(\kappa\) was made before constructing the trace quotient
and \(P\); all subsequent arguments work for every member of that
open set. No further genericity condition or unproved compatibility
requirement has been imposed.

## 8. Exact certificate and bounded Jacobian use

Run from the campaign root:

```bash
python3 research/curve_trace_audit/verify.py --negative-controls
```

Only exact integer, rational, quadratic-number-field, polynomial, and
rational-function arithmetic is used. There is no floating-point
threshold. The program derives the certificate fields, checks its
entire shape and values, and rejects mutations of the norm, trace
normalization, omitted ramification type, adjunction sign, derivative
coefficient, global pairing sign, determinant, and coordinate scaling.
The negative controls reuse the freshly derived identities rather than
repeating their unchanged computation. A wrong certificate exits nonzero.
The checker neither writes nor repairs the supplied certificate during
verification. `--emit-certificate` is an explicit generation mode, not
an assertion of independent acceptance.

Existing Jacobian discovery already listed exact formal-series division.
Its current typed contract was inspected before the custom computation.
The bounded operation was
`formal_series.rational.divide.compute`, server `0.14.0`, protocol
`2025-11-25`, using the separate `jacobian_payload.json`.
It divides the first four coefficients of \((2+3z+5z^2)^2\) by
\(3+7z+11z^2\), a specialization of the multiplier \((b/z)^2/K\)
in (6.4). The typed answer is
\[
4/3+(8/9)z+(73/27)z^2+(35/81)z^3\pmod{z^4}.
\]
The adapter exited zero, with complete exact output and zero residual;
there was no timeout or structured error. Contract, exact payload,
server/protocol metadata, and typed output are preserved in the
three `jacobian_*.json` files. The checker independently convolves
the returned quotient with the exact denominator and binds the output
to the preserved payload. This bounded specialization is corroboration,
not the proof of the symbolic formula or of geometric existence.

New independent approval is still required through the normal Host
Reviewer path. The whole-manuscript analytic/algebraic claims and the
manager-owned significance/novelty conditions remain unresolved.
