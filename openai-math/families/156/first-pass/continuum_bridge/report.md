# The continuum-to-finite bridge

## Result and scope

**Bridge theorem (`C9000156_BRIDGE`).** A cover of
\[
 X_4=\{uu^{\mathsf T}:u\in\mathbb R^4,\ \|u\|=1\}
\]
by at most ten sets of Frobenius diameter strictly less than \(\sqrt2\)
would produce a **nonempty** family
\(F\subseteq\binom{\{0,\ldots,9\}}4\) with the following properties:

1. Every triple is contained in an even number of members of \(F\).
2. With \(T(F)=\{t:|t|=3,\ t\subset s\text{ for some }s\in F\}\),
   the triangles \(T(F)\cap\binom{V\setminus s}3\) form a six-system
   for each \(s\in F\): exactly one member of each complementary pair,
   and exactly two triangles through every pair of labels.

The proof below supplies the continuum implication, including both
dimensions three and four, without assuming that any support complex
triangulates projective space. Combining it with the retained theorem
`C9000156_COMB`, version 5, rules out the cover and proves the staged
manuscript's main theorem.

**Evidence distinction.** This is an analytic/topological proof, not a Lean
formalization of the continuum. `verify.py` certifies the exact polynomial,
dimension, metric-basis, and incidence calculations specified below; it does
not check Sard's theorem, manifold degree, or this prose proof. The finite
obstruction has an existing zero-hole Lean 4.31.0 certificate and a completed
independent review. That certificate is reused, not recompiled or replayed:

- `research/ten_label_obstruction/certificates/C9000156_COMB-3e41b9605d2fdf73.json`;
- independent Reviewer `reviewer:gpt-6.1-sol:62918ef4ee29`, whose
  `handoffs/62918ef4ee29/round-0001.json` records `review.status = done`.

The improvement over that prior result is the proof of its previously
unverified continuum antecedent, not a stronger finite exclusion. No new
counterexample to a literal manuscript assertion was found in this scope.
This is an independently written verification of the staged construction,
not a claim that the manuscript's conclusion or the standard topology used
here is original to this audit. Independent review of this bridge remains
required.

## 1. Definitions and external inputs

Put \(N_k=k(k+1)/2\). An admissible map is a smooth map
\(f:\mathbb P(\mathbb R^k)\to\Delta^{m-1}\) with nonnegative coordinates
summing to one, whose positive supports
\(S(x)=\{i:f_i(x)>0\}\) satisfy
\[
 x\perp y\quad\Longrightarrow\quad S(x)\cap S(y)=\varnothing.
 \tag{1}
\]
Its support complex is the downward closure of these supports. Throughout
the proof, homology and cohomology are over \(\mathbb F_2\). A fundamental
class for a disconnected compact manifold means the sum of the classes
of its components; for the empty manifold it means zero.

The precise source statements, versions, hypotheses, downloaded primary
texts, and attribution excerpts are in `literature/sources.md`.
The external inputs are:

| Input | Read primary source | Use and hypothesis check |
|---|---|---|
| Odd sphere self-maps have odd degree | Hatcher, AT, Proposition 2B.6 | Continuous odd maps; no global smoothness required |
| Borsuk--Ulam | AT, Corollary 2B.7 and proof | Excludes odd maps to lower spheres |
| Excision, fundamental classes, component additivity | AT, Theorem 2.20, Theorem 3.26, Proposition 2.6 | Closed components; mod-two orientation; local calculation proved in Section 3 |
| Projective cohomology and cup naturality | AT, Theorem 3.19, Proposition 3.10 | Finite real projective spaces; mod-two coefficients |
| Naturality and normalization of \(w_1\) | Hatcher, VB, Theorem 3.1(a),(d) | Real line bundles over paracompact bases; finite normalization by restriction |
| Smooth partitions of unity | MIT 18.965, Fall 2004, Lecture 8, Section 9 | A finite open cover of a compact smooth manifold |
| Sard | Same course, Lectures 10--11, Theorem 12.3 | Smooth maps on the indicated open smooth loci only |
| Inverse/regular-fiber theorems | Same course, Lecture 4, Theorem 5.1 and Corollary 5.4 | Finite-dimensional smooth maps; empty fibers handled separately |
| Simplicial--singular comparison | AT, Theorem 2.27 and coefficient extension on p.153 | The finite support complex, not a purported triangulation of the domain |

The manuscript cites Lee's second edition for the three smooth-manifold
tools. Its exact theorem pages were not obtainable from the legitimate
public sample. They are **not** counted as verified citations here. The
proof uses the readable primary MIT statements instead; it does not leave
an assumption that Lee's inaccessible pages say what was needed.

## 2. The matrix extension, including its singular boundary

We prove `C9000156_EXTENSION`. Let \(V\) be a \(k\)-dimensional Euclidean
space and set
\[
 H(v)=\|v\|^2 f([v])\quad(v\ne0),\qquad H(0)=0,\qquad
 E_V(Q)=k\int_{S(V)}H(Q^{1/2}u)\,d\mu(u)\quad(Q\ge0).
 \tag{2}
\]
The measure is normalized rotation-invariant sphere measure.
\(H\) is nonnegative, smooth off zero, and homogeneous of degree two.
Since \(\|H(v)\|_1=\|v\|^2\), it is continuous at zero.

Here are useful elementary matrix details. The finite-dimensional spectral
theorem follows by maximizing the Rayleigh quotient on the unit sphere,
obtaining an eigenvector, and inducting on its invariant perpendicular
complement. The positive semidefinite square root is unique. If \(Q_j\to Q\)
in the positive semidefinite cone, their square roots are bounded; any
convergent subsequence has positive semidefinite limit \(R\) with \(R^2=Q\),
hence \(R=Q^{1/2}\). Subsequence compactness proves continuity, including at
singular \(Q\).

On the positive definite cone the square root is smooth: the differential
of \(R\mapsto R^2\) is \(X\mapsto RX+XR\), which in an orthonormal
eigenbasis multiplies \(X_{ij}\) by the strictly positive number
\(\rho_i+\rho_j\). It is invertible on symmetric matrices, so the inverse
function theorem gives the claimed smooth branch. This also supplies the
smooth inverse square roots used below.

Compactness of the sphere in (2) now proves continuity of \(E_V\).
Homogeneity and second moments give
\[
 E_V(tQ)=tE_V(Q),\qquad E_V(Q)_i\ge0,\qquad
 \sum_iE_V(Q)_i
 =k\int u^{\mathsf T}Qu\,d\mu(u)=\operatorname{tr}Q.
 \tag{3}
\]
Its exact support is
\[
 \{i:E_V(Q)_i>0\}
   =\bigcup_{x\in\mathbb P(\operatorname{ran}Q)}S(x).
 \tag{4}
\]
For the forward inclusion, every nonzero input to \(H\) in (2) lies in
the range. Conversely, every line in that range occurs as
\([Q^{1/2}u]\) for some unit \(u\). Positivity at such a point persists
on an open piece of the sphere, of positive sphere measure. Nonnegative
integration then makes the coordinate strictly positive. For \(Q=0\),
both sides are empty. In particular \(E_V(P_x)=f(x)\).

The ambient dimension factor in (2) is important. For a standard Gaussian
\(Z\) in \(V\), polar coordinates and
\(\mathbb E\|Z\|^2=k\) give the equivalent formula
\[
 E_V(Q)=\mathbb E\,H(Q^{1/2}Z).
 \tag{5}
\]
If \(Q\) is supported on \(W\), then \(Q^{1/2}Z\) depends only on
\(\pi_W Z\), a standard Gaussian in \(W\). Applying (5) in \(W\) proves
\[
 E_V(Q)=E_W(Q|_W).
 \tag{6}
\]
Thus there is no missing factor \(k/\dim W\). Equivalently, the weighted
projection of sphere measure used by the manuscript has mass \(\dim W/k\).

If \(W\) varies smoothly with constant rank, choose a local orthonormal
frame \(T:\mathbb R^r\to W\) and write \(Q|_W=C>0\). Formula (6) becomes
\[
 r\int_{S^{r-1}}H(TC^{1/2}u)\,d\mu(u).
 \tag{7}
\]
The arguments of \(H\) stay away from zero locally and uniformly on the
compact sphere. All parameter derivatives can therefore be taken under
the integral, proving the required bundle-local smoothness.

For symmetric \(A\), define
\[
 |A|=(A^2)^{1/2},\quad A_\pm=(|A|\pm A)/2,\quad
 \Phi(A)=E_V(A_+)-E_V(A_-).
 \tag{8}
\]
The ranges of \(A_+\) and \(A_-\) are orthogonal. By (1) and (4), the two
nonnegative output vectors have disjoint supports. There is **no
cancellation**. Hence \(\Phi\) is continuous and odd, and
\[
 \|\Phi(A)\|_1=\operatorname{tr}|A|,\quad
 \sum_i\Phi(A)_i=\operatorname{tr}A,\quad
 \{\pm\Phi(A)_i>0\}
 =\bigcup_{x\in\mathbb P(\operatorname{ran}A_\pm)}S(x).
 \tag{9}
\]
If the output has full support, \(A\) has no kernel: a kernel line has
some positive label, orthogonality makes that label absent from both
spectral ranges, and (9) would make its output zero. If all output
coordinates are negative, \(A_+=0\) by (3), and the absence of a kernel
makes \(A\) negative definite. The corresponding positive assertion
follows by oddness.

Near nonsingular \(A\), the projections
\[
 \Pi_\pm(A)=\tfrac12\bigl(1\pm A(A^2)^{-1/2}\bigr)
 \tag{10}
\]
are smooth of constant ranks. They admit smooth local orthonormal frames.
Formula (7), with the rank-zero term simply zero, proves smoothness of
\(\Phi\) there. Repeated eigenvalues within either sign subspace do not
cause an exception.

The trace-norm sphere
\(\Sigma(V)=\{A:\operatorname{tr}|A|=1\}\) is antipodally homeomorphic,
by radial normalization, to \(S^{N_k-1}\); the label norm sphere
\(\Sigma_m=\{y:\sum|y_i|=1\}\) is similarly \(S^{m-1}\). Give them the
transported smooth structures. At nonsingular matrices and full-support
label vectors these agree with the ordinary hypersurface structures:
the respective norm functions are smooth with nonzero radial derivative.
Thus (9) gives a continuous odd sphere map, smooth at every preimage of
a full-support value. No global smoothness at the singular norm loci
has been assumed.

## 3. Local counting and the label bound

**Local counting (`C9000156_LOCAL_DEGREE`).** Suppose \(M\) is a closed
smooth \(n\)-manifold, \(Y\) is Hausdorff and locally Euclidean of
dimension \(n\) at \(y\), and \(q:M\to Y\) is continuous and a local
diffeomorphism near every point of \(q^{-1}(y)\). Then
\[
 q_*[M]\ \text{in }H_n(Y,Y\setminus\{y\})
       = |q^{-1}(y)|\pmod2.
 \tag{11}
\]
The inverse function theorem isolates the fiber points. The closed
fiber is compact, hence finite. Choose disjoint coordinate neighborhoods
of its points. Excision gives the direct sum of the corresponding
local homology groups in
\(H_n(M,M\setminus q^{-1}(y))\). The total fundamental class restricts
to one in every summand, and a local diffeomorphism takes a local
generator to a local generator. Naturality proves (11). The empty
fiber gives the zero relative class. Compact manifolds have finitely many
components because their components are open; applying the connected
fundamental-class theorem componentwise proves the disconnected case.
This proves the required generalization rather than citing Hatcher's
sphere-only Proposition 2.30 as a theorem about arbitrary manifolds.

If \(Y\) is a connected closed manifold of dimension \(n\), (11) is its
mod-two degree formula. Smoothness is needed only near the selected fiber.

**Label bound (`C9000156_LABEL_BOUND`).** An odd map
\(S^{N_k-1}\to S^{m-1}\) requires \(m\ge N_k\). Indeed, if \(m<N_k\),
compose with the linear inclusion \(\mathbb R^m\to\mathbb R^{N_k-1}\).
Borsuk--Ulam would give equal values at some antipodal pair; oddness
would force the value to be zero, impossible for a sphere-valued map.
At equality, Hatcher's odd-degree proposition makes the mod-two degree
one. A nonzero-degree map to a sphere is surjective, since the punctured
target has zero top homology.

At equality every pair \(i,j\) of labels is an edge of the support complex.
Choose a full-support output having exactly these two coordinates
positive and use surjectivity. Its positive spectral range is nonzero
and uses only \(i,j\). If its dimension were at least two, restriction
to any two-dimensional subspace would be an admissible map using at
most two labels, violating \(N_2=3\). Its dimension is therefore one,
and (9) says the line has both positive labels.

## 4. Product-cover parity, with no base-class ambiguity

We prove `C9000156_PRODUCT_PARITY`. Let \(L\) be a closed smooth
\(d\)-manifold, possibly disconnected or empty, let \(h\ge2\) and
\(a=h+d\), and let
\[
 G:L\times S^{h-1}\longrightarrow S^{a-1},\qquad
 G(x,-z)=-G(x,z)
 \tag{12}
\]
be continuous. Suppose it is smooth with invertible derivative near its
fiber over \(g\). That fiber is finite by (11). Oddness gives the same
local regularity at \(-g\).

The quotient map is
\(\bar G:L\times\mathbb{RP}^{h-1}\to\mathbb{RP}^{a-1}\).
The pullback of the target sphere cover has an explicit isomorphism
from the source product cover:
\[
 (x,z)\longmapsto ((x,[z]),G(x,z)).
 \tag{13}
\]
It is a continuous equivariant bijection on each two-point fiber.
In local covering trivializations it is a homeomorphism. Consequently
the associated line bundles are isomorphic:
\[
 \bar G^*\gamma_{a-1}\cong \operatorname{pr}_2^*\gamma_{h-1},\qquad
 \bar G^*w=\operatorname{pr}_2^*u.
 \tag{14}
\]
Here \(w=w_1(\gamma_{a-1})\) and \(u=w_1(\gamma_{h-1})\) are the usual
degree-one generators. Naturality and normalization of \(w_1\) apply:
all finite-dimensional bases here are compact manifolds and hence
paracompact. The finite-projective normalization follows by restriction
of the canonical bundle on \(\mathbb{RP}^{\infty}\); the skeletal
inclusion induces an isomorphism on \(H^1\) for dimensions at least one.

Equation (13), not a claim about fiber restrictions of cohomology, proves
(14). A possible element of \(H^1(L)\) is thereby excluded even if that
group is nonzero. No Kunneth splitting or vanishing of \(H^1(L)\) is
needed.

If \(d>0\), then \(a-1\ge h\), so projective cohomology and cup
naturality give
\[
 \bar G^*(w^{a-1})=\operatorname{pr}_2^*(u^{a-1})=0,\qquad u^h=0.
 \tag{15}
\]
The source is a closed manifold of dimension \(d+h-1=a-1\), and
\(w^{a-1}\) is the target's nonzero top generator. The identity
\(\langle\bar G^*\alpha,[D]\rangle
=\langle\alpha,\bar G_*[D]\rangle\), obtained directly from the
chain/cochain definitions, shows that its total mod-two degree is zero.
This includes disconnected sources and the empty source.

There is an exact fiber bijection
\[
 \bar G^{-1}([g])
   =G^{-1}(\{g,-g\})/\{(x,z)\sim(x,-z)\}
   \ \longleftrightarrow\ G^{-1}(g).
 \tag{16}
\]
Every orbit has exactly one representative mapping to \(g\).
In particular one does **not** halve \(|G^{-1}(g)|\).
The quotient maps are local diffeomorphisms, so \([g]\) satisfies the
local counting hypotheses. Equations (11), (15), and (16) show that
\(|G^{-1}(g)|\) is even when \(d>0\).

When \(d=0\), \(L\) is finite. Each fiber map is an odd self-map of
\(S^{h-1}\). The same regular value \(g\) is locally regular for each,
so (11) and odd degree give
\[
 |G^{-1}(g)|=\sum_{x\in L}|G_x^{-1}(g)|\equiv |L|\pmod2.
 \tag{17}
\]
This proves the asserted parity theorem in both cases.

## 5. Equality supports, including initially empty level sets

We prove `C9000156_SUPPORT_EQUALITY` for every \(k\ge3\), with
\(m=N_k\). In particular this proves both applications required here.
Fix **any** facet \(I\) of the support complex. Maximality gives a witness
\(x_0\) with \(S(x_0)=I\). Write
\[
 s=|I|,\quad J=[m]\setminus I,\quad a=|J|,\quad h=N_{k-1}.
 \tag{18}
\]
Every line in \(x_0^\perp\) uses only \(J\). The label bound in dimension
\(k-1\ge2\) gives \(a\ge h\), hence \(s\le k\).

### 5.1 Compactness and the affine-chart trivialization

Let \(U_I=\{x:f_i(x)>0\ (i\in I)\}\). Every support on \(U_I\) is
exactly \(I\), by maximality, and \(U_I\) avoids
\(\mathbb P(x_0^\perp)\) by (1). Thus \(f_I\) is a smooth map
\[
 f_I:U_I\longrightarrow\mathring\Delta_I
 \tag{19}
\]
on one affine projective chart. Choose any regular value
\(r\in\mathring\Delta_I\); Sard supplies such values. Put
\(L=f_I^{-1}(r)\), allowing \(L=\varnothing\).
For \(r\) extended by zero on \(J\),
\[
 L=f^{-1}(\widetilde r).
 \tag{20}
\]
Positivity of all \(I\)-coordinates proves this equality in both
directions. Therefore \(L\) is closed in compact projective space, not
merely closed in the possibly noncompact open chart. If nonempty it is
a boundaryless embedded smooth manifold with
\[
 d=\dim L=(k-1)-(s-1)=k-s=a-h.
 \tag{21}
\]
The empty case carries the empty \(d\)-manifold convention and is not
discarded.

For clarity, the regular-fiber dimension assertion needs only the local
inverse theorem. In charts centered at a preimage, split the tangent
space as \(\ker Df_I\oplus C\) with \(Df_I|_C\) an isomorphism onto the
target. The map \((v,c)\mapsto(v,f_I(v+c))\) has invertible derivative.
Its inverse-function coordinates make the fiber the slice with second
coordinate \(r\); its tangent is \(\ker Df_I\) and its dimension is
the source dimension minus the target dimension. These charts have no
boundary.

There is a global smooth trivialization of \(x^\perp\) over this chart.
Choose coordinates with \(x_0=[e_0]\) and
\(x=[(1,t)]\), put \(D=1+\|t\|^2\), and project \(e_0^\perp\)
orthogonally onto \(x^\perp\). The projection sends
\[
 v\longmapsto (0,v)-\frac{t^{\mathsf T}v}{D}(1,t).
 \tag{22}
\]
Its Gram matrix is \(R=1-tt^{\mathsf T}/D\). It has eigenvalues one
on \(t^\perp\) and \(1/D\) in the \(t\)-direction (at \(t=0\) it is
the identity). Thus \(R>0\) and \(\det R=1/D>0\). Multiplying these
projection columns by \(R^{-1/2}\) gives a single smooth orthonormal
frame on the entire chart. There is no transition-function twist left
on \(L\). The exact polynomial identities behind (22) and its Gram
determinant are replayed in dimensions three and four by `verify.py`;
the eigenvalue argument proves the statement in every dimension.

For \(x\in U_I\), restriction of \(f\) to \(\mathbb P(x^\perp)\)
uses only \(J\), so the extension of Section 2 defines an odd map
\(G_x:\Sigma(x^\perp)\to\Sigma_a\). It varies continuously with \(x\)
by the local frame formula. Restrict its sphere bundle to \(L\):
\[
 M=\{(x,B):x\in L,\ B\in\operatorname{Sym}(x^\perp),\
                     \operatorname{tr}|B|=1\},\quad G(x,B)=G_x(B).
 \tag{23}
\]
The orthonormal frame induces a symmetric-operator bundle
trivialization. Fiberwise radial normalization then gives an
equivariant homeomorphism
\[
 M\cong L\times S^{h-1},\qquad B\mapsto-B
       \ \longleftrightarrow\ z\mapsto-z.
 \tag{24}
\]
Use its Euclidean sphere-bundle smooth structure. This agrees with
the trace-norm hypersurface structure at definite \(B\), where we will
differentiate. The manifold is closed and
\[
 \dim M=d+h-1=a-1.
 \tag{25}
\]

### 5.2 The full preimage splitting and its derivative

Let \(O_-\) be the open strictly negative orthant of \(\Sigma_a\).
If \(G_x(B)\in O_-\), the exact spectral-support statement proves
that \(B\) is negative definite on \(x^\perp\): a positive spectral
line would supply a positive label, and a kernel line would need a
label missing from the full output. Consequently \(G\) is smooth on
the open set \(G^{-1}(O_-)\). Apply Sard to this **smooth restriction**
to choose \(g\in O_-\) regular there. Its fiber is finite by
compactness and local regularity. This choice is valid even if \(M\)
or this open set is empty.

Fix \(0<\lambda<1\) and set
\[
 y_I=\lambda r,\qquad y_J=(1-\lambda)g.
 \tag{26}
\]
This is a full-support point of \(\Sigma_m\).
We claim the following bijection, not just an injection:
\[
 G^{-1}(g)\longleftrightarrow \Phi^{-1}(y),\qquad
 (x,B)\longmapsto A=\lambda P_x+(1-\lambda)B,
 \tag{27}
\]
with \(B\) extended by zero on \(x\).

To prove the reverse direction, let \(\Phi(A)=y\). Full output
support makes \(A\) nonsingular. Its positive spectral range is
nonzero and all lines in it use only \(I\). A positive subspace
of dimension at least two would meet the hyperplane \(x_0^\perp\)
in a nonzero line, whose support must instead lie in \(J\). Since
supports are nonempty, this is impossible. The positive subspace
is a line \(x\), and the positive output block is
\(\rho f(x)\), where \(\rho\) is its positive eigenvalue.
Every \(I\)-coordinate of this block is positive, so \(S(x)=I\).
Summing the block gives \(\rho=\lambda\) and then \(f_I(x)=r\).
The remaining operator is strictly negative on \(x^\perp\);
its trace norm is \(1-\lambda\). After normalization it is the
unique \(B\) of (27), and (6), (8) give \(G_x(B)=g\).
Conversely, any \((x,B)\in G^{-1}(g)\) has \(x\in L\) and \(B<0\);
(6) and homogeneity show that (27) has trace norm one and maps
exactly to (26). This proves both directions and uniqueness.

We next check the invertible local derivative; it is not an assumed
degree count. Near such an \(A\), operators of signature \((1,k-1)\)
on the trace-norm sphere have smooth coordinates
\[
 (\lambda',x',B'),\qquad
 A'=\lambda'P_{x'}+(1-\lambda')B',\quad B'<0,\quad
 \operatorname{tr}|B'|=1.
 \tag{28}
\]
The inverse coordinates are smooth by (10), with
\(\lambda'=\operatorname{tr}A'_+\), positive line
\(\operatorname{ran}\Pi_+(A')\), and the normalized negative
restriction. Near \(x\), \(x'\in U_I\), so its support stays exactly
\(I\). In the target orthant, use positive mass followed by the
two normalized blocks. Formulas (6)--(9) give the exact local map
\[
 (\lambda',x',B')\longmapsto
           (\lambda',f_I(x'),G_{x'}(B')).
 \tag{29}
\]
The first two differential blocks have rank
\(1+(s-1)=s\), because \(r\) is regular. Their kernel is precisely
the tangent space to the bundle over \(L\) with \(\lambda'\) fixed.
It has dimension \(a-1\). On that kernel the last block is
\(D(G|_M)\), an isomorphism by regularity of \(g\) and (25).
Thus (29) has zero kernel; its source and target both have
dimension \(m-1\), so it has invertible derivative.

We may now use (11) on \(\Phi\). Its mod-two sphere degree is one,
and (27) proves
\[
 |G^{-1}(g)|=|\Phi^{-1}(y)|\equiv1\pmod2.
 \tag{30}
\]
This also proves \(L\ne\varnothing\); initial emptiness was never
ruled out by an unsupported regular-value assertion.

### 5.3 Purity, odd coefficients, and the actual simplicial cycle

Transport \(G\) through (24) and the radial target identification.
All the hypotheses of Section 4 hold, including equal dimensions,
closedness, equivariance, and the just-selected locally regular
fiber. If \(s<k\), then \(d=a-h>0\); (15)--(16) say that (30)
must be even. This contradiction proves \(s=k\) for this arbitrary
facet, and hence for every facet.

Now \(a=h\) and \(L\) is finite. Each \(G_x\) is an odd sphere
self-map, and regularity for \(G\) is regularity for each component.
Equations (17) and (30) yield
\[
 |f^{-1}(\widetilde r)|=|L|\equiv1\pmod2.
 \tag{31}
\]
The proof started with an arbitrary regular \(r\) in (19), so (31)
holds for every such regular value, not just for a value already
known to be in the image.

Finally let \(n=k-1\) and consider
\(f_*[\mathbb{RP}^{k-1}]\in H_n(|K|)\). The domain is a closed
mod-two manifold, regardless of orientability. Simplicial--singular
comparison represents this class by a simplicial \(n\)-cycle \(z\).
There are no \((n+1)\)-simplices, so this representing top cycle is
unique. At an interior point \(\widetilde r\) of a facet \(I\),
local homology reads exactly the coefficient of \(I\) in \(z\).
For precision, delete the open \(I\)-simplex to obtain a subcomplex
\(K'\). The space \(|K|\setminus\{\widetilde r\}\) deformation
retracts onto \(|K'|\) by radial retraction within \(I\), fixed
on its boundary. The comparison for this pair identifies the map
to the one-dimensional local homology group with the simplicial
coefficient projection onto \(I\).

Near every point over \(\widetilde r\), the map has values in the
open \(I\)-simplex and derivative invertible by the regularity of
(19), now between equal dimensions. Equations (11) and (31) say
that the coefficient is one. This holds for every facet, so
\[
 z=\sum_{I\text{ facet}} I,\qquad \partial z=0.
 \tag{32}
\]
Each codimension-one face lies in at least one facet by purity,
and its coefficient in \(\partial z\) is its facet incidence
modulo two. Thus that incidence is positive and even.

For \(k=3\), (32) gives a pure two-dimensional support complex
on six labels with all fifteen edges and positive even edge
incidences. For \(k=4\), it gives a pure three-dimensional
complex on ten labels with positive even triangle incidences.
No three-manifold or projective-space triangulation assertion
was used. The four-dimensional specialization is
`C9000156_EQUALITY`.

## 6. The exact complementary six-systems

First consider **any** admissible map
\(\mathbb{RP}^2\to\Delta^5\). Section 5 with \(k=3\) gives purity,
all fifteen edges, and at least two triangles on every edge.
Two complementary triples cannot both be triangles: choose their
witness lines in \(\mathbb R^3\); a nonzero line perpendicular to
both exists and would have no available label. Thus there are
at most ten triangles. Counting triangle--edge incidences gives
\[
 3\,|\mathcal T|=\sum_{\text{15 pairs }e}\deg(e)\ge30.
 \tag{33}
\]
Consequently there are exactly ten triangles, one from each
complementary pair, and every pair has degree exactly two.
This uses only (32), not any of the manuscript's additional
six-system structural lemmas. This proves `C9000156_SIX_MAP`.

Now let \(f:\mathbb{RP}^3\to\Delta^9\) be admissible, let \(K\)
be its support complex, and let \(S\) be a four-element facet.
Choose a witness \(x\) with support exactly \(S\). Set
\(C=[10]\setminus S\). The restriction
\[
 f|_{\mathbb P(x^\perp)}:\mathbb{RP}^2\longrightarrow\Delta_C
 \tag{34}
\]
uses no labels of \(S\), by (1). The six-label lower bound
excludes unused labels, and (33) supplies a six-system
\(\mathcal T_0\) among its restricted triangles.

It remains essential to prove equality with **all global**
triangles on \(C\), rather than confuse restriction with equality.
Certainly \(\mathcal T_0\subseteq K\cap\binom C3\). If a global
triangle \(T\subset C\) were not in \(\mathcal T_0\), the
complementary rule would give \(C\setminus T\in\mathcal T_0\).
Choose global witness lines for \(S\), \(T\), and \(C\setminus T\).
These three lines span a subspace of dimension at most three in
\(\mathbb R^4\), so there is a nonzero line perpendicular to all
three. Its support must avoid their support union, which already
contains all ten labels. This contradicts the coordinate sum one.
Therefore
\[
 K\cap\binom C3=\mathcal T_0.
 \tag{35}
\]
This proves `C9000156_COMPLEMENT` with the exact, unrestricted
global-triangle interpretation needed by the finite certificate.

## 7. From arbitrary cover sets to the forbidden nonempty family

For unit \(u,v\), direct matrix multiplication gives
\[
 \|uu^{\mathsf T}-vv^{\mathsf T}\|_F^2
       =2-2(u^{\mathsf T}v)^2.
 \tag{36}
\]
The projector map identifies compact projective space with \(X_4\);
its image determines the line, so the map is injective and is a
homeomorphism onto its image. Equation (36) gives diameter
\(\sqrt2\), attained exactly on orthogonal lines.
The trace-one hyperplane has Euclidean dimension \(10-1=9\).
The nine traceless symmetric basis directions used by the staged
coordinate formula have Gram diagonal
\((2,6,12,2,2,2,2,2,2)\); dividing by their norm lengths verifies
the stated Euclidean isometry. Both algebraic assertions are
checked exactly by `verify.py`.

Suppose \(A_1,\ldots,A_{10}\) cover \(X_4\), with each nonempty
set of diameter \(d_i<\sqrt2\); pad by empty sets if necessary.
For nonempty \(A_i\), put
\(\epsilon_i=(\sqrt2-d_i)/4\) and
\[
 U_i=\{P\in X_4:\operatorname{dist}(P,A_i)<\epsilon_i\}.
 \tag{37}
\]
Distance to a nonempty arbitrary set is a continuous 1-Lipschitz
function; closedness or measurability of \(A_i\) is unnecessary.
Thus the \(U_i\) form a finite open cover. The triangle inequality
and the strict distance inequalities give
\[
 \operatorname{diam}(U_i)
 \le d_i+2\epsilon_i=(d_i+\sqrt2)/2<\sqrt2.
 \tag{38}
\]
Set \(U_i=\varnothing\) for the padded empty sets.
Pull back the cover to projective space and take a smooth
subordinate partition of unity \(f_i\), putting zero on an empty
cover member. Positivity of \(f_i\) implies membership in its
open set; (36)--(38) show that no orthogonal pair can share a
positive label. This proves `C9000156_REDUCTION`. Merely having
arbitrary color classes without orthogonal pairs would not
justify this smoothing step; the strict uniform gap does.

Apply Section 5 with \(k=4\). The finite complex \(K\) has facets
of cardinality four. It has at least one: every line has a
nonempty support, and every face of a finite complex extends
to a facet. Let \(F\) be all of these facets and relabel \(i\)
by \(i-1\). Then \(F\ne\varnothing\). Purity proves
\[
 T(F)=\{t\in K:|t|=3\}.
 \tag{39}
\]
For triples in \(K\), (32) gives positive even incidence; triples
not in \(K\) have incidence zero. Thus **every** triple satisfies
the finite parity hypothesis. Equations (35) and (39) give the
exact six-system on each facet complement. These are precisely,
and not stronger substitutes for, the hypotheses of
`C9000156_COMB` version 5.

That retained theorem implies \(F=\varnothing\), contradicting
nonemptiness. It follows that \(X_4\) has no such ten-set cover.
Together with (36) and the nine-dimensional isometry, this proves
`C9000156_MAIN`.

## 8. Exact replay and remaining certification boundary

Run `python3 research/continuum_bridge/verify.py` from the campaign
directory. It uses only Python's standard library. The replay checks
integer multivariate polynomial identities, not floating-point samples:
the projection columns are perpendicular to \((1,t)\), their Gram
numerator is \(D(D1-tt^{\mathsf T})\), and
\(\det(D1-tt^{\mathsf T})=D^{k-2}\) for \(k=3,4\). It also checks
the projector-distance identity before imposing unit norms, the
metric-basis Gram matrix, all seven \(1\le s\le k\) dimension
cases for \(k=3,4\), and the exact six-label incidence totals.
It also compares the retained finite source and fidelity text with the
archived certificate and checks the current-version mechanical and
independent-review bindings. Those are integrity checks on existing
evidence, not a new compiler run or finite-proof replay.

One bounded Jacobian operation independently returns the \(k=4\)
symbolic determinant. Its inspected contract, exact sparse-polynomial
input, and unmodified typed response are
`jacobian_contract.json`, `jacobian_input.json`, and
`jacobian_output.json`. The response identifies server 0.14.0,
protocol 2025-11-25, operation
`matrix.symbolic.determinant.compute`, and exact Bareiss output
\((1+x^2+y^2+z^2)^2\); runtime 26 ms. It reports no adapter error
or timeout. This certifies the specified algebraic calculation,
not the continuum theorem.

The external propositions are recorded as cited assumptions, never as
manuscript conclusions. Their primary passages are retained for the
Host-invoked independent Reviewer's attribution and proof review.
The Engineer has not impersonated that Reviewer or marked the new
continuum nodes independently proved. In particular a successful
algebra replay is not a substitute for review of (11)--(35).
