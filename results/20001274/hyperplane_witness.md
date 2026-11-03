# An explicit two-cap hyperplane-projection counterexample in R^3

This is a support-function specialization of the two extreme-level-cap
mechanism in Ning Zhang, *On bodies with congruent sections or projections*,
[arXiv:1711.10445v1](https://arxiv.org/abs/1711.10445v1), Section 3, pp. 5-8.
Problem 1.2, p. 1, is the source-aligned question; Theorem 1.4, p. 2, states
the projection result. The retrieved primary PDF and its text are
`zhang-1711.10445v1.pdf` and `zhang-1711.10445v1.txt`.

The construction below is not a verbatim copy of the paper's radial
perturbation. It uses the same spectral-cap symmetry directly on support
functions, with explicit parameters, a quantitative convexity bound, and
exclusions of *every* translation. The displayed source theorem alone only
says \(K\ne L,-L\). Neither that display nor the reviewed source-audit row is
being substituted for the translation argument below. No novelty is claimed.

## 1. Exact definitions

For a unit vector \(u=(u_1,u_2,u_3)\), put
\[
 A=\operatorname{diag}(3,2,1),\qquad q(u)=u^TAu,\qquad
 c_+=5/2,\quad c_-=3/2,\quad \varepsilon=1/1000.
\]
Write \(s_+=\max(s,0)\), and define
\[
 \begin{aligned}
 P_+(u)&=\begin{cases}(q(u)-c_+)_+^3&u_1>0,\\0&u_1\le0,\end{cases}\\
 P_-(u)&=\begin{cases}(q(u)-c_+)_+^3&u_1<0,\\0&u_1\ge0,\end{cases}\\
 N(u)&=\begin{cases}(c_--q(u))_+^3&u_3>0,\\0&u_3\le0.\end{cases}
 \end{aligned}
\]
The prescribed support functions are
\[
 h_K(u)=\sqrt{q(u)}+\varepsilon(P_+(u)+N(u)),\qquad
 h_L(u)=\sqrt{q(u)}+\varepsilon(P_-(u)+N(u)).
 \tag{1}
\]
The bodies themselves, without any implicit choice of parameter, are
\[
 K=\bigcap_{u\in S^2}\{x:x\cdot u\le h_K(u)\},\qquad
 L=\bigcap_{u\in S^2}\{x:x\cdot u\le h_L(u)\}.                 \tag{2}
\]
The unperturbed function is the support function of the ellipsoid with
semiaxes \(\sqrt3,\sqrt2,1\). Equations (1)-(2), not the source paper's
parameters, define the pair used in every assertion below.

## 2. Convex bodies and realization of the support functions

### Smoothness and elementary bounds

On \(S^2\),
\[
 1\le q\le3,\qquad q=2+u_1^2-u_3^2.                         \tag{3}
\]
Consequently the high cap \(q>5/2\) avoids \(u_1=0\), and the low cap
\(q<3/2\) avoids \(u_3=0\). In fact the relevant coordinate has squared
absolute value greater than \(1/2\). Thus the hemisphere gates introduce
no discontinuity: their other factors vanish on a neighborhood of the gate.
At a cap boundary the value and first two derivatives of \(s_+^3\) vanish.
All three perturbations and both functions in (1) are \(C^2(S^2)\).

The high and low caps are disjoint. At any point each support function has
at most one nonzero perturbation, including its derivatives. Each active
cubic has argument in \([0,1/2]\). In particular
\[
 1\le h_K,h_L\le2+1/8000<3.                                 \tag{4}
\]

### A uniform positive curvature bound

For orthonormal vectors \(u,v\), let
\(w_{ij}=u_iv_j-u_jv_i\). The following identity holds for arbitrary
\(u,v\), not just orthonormal ones:
\[
 \begin{split}
 &(u^TAu)(v^TAv)-(u^TAv)^2
       -\bigl(\|u\|^2\|v\|^2-(u\cdot v)^2\bigr)\\
 &\hspace{20mm}=5w_{12}^2+2w_{13}^2+w_{23}^2\\
 &\hspace{20mm}=(2w_{12})^2+w_{12}^2+w_{13}^2+w_{13}^2+w_{23}^2.
 \end{split}                                               \tag{5}
\]
For orthonormal \(u,v\), the parenthesized Euclidean determinant is 1.
Differentiating the homogeneous function \(\sqrt{x^TAx}\), its tangent
Hessian, equivalently \(\nabla_S^2\sqrt q+\sqrt q\,I\), is therefore
\[
 \frac{q(u)\,v^TAv-(u^TAv)^2}{q(u)^{3/2}}\ \ge\ \frac18.
 \tag{6}
\]
Here \(q\ge1\) and \(\sqrt q\le2\), so \(q^{3/2}\le8\).

Along the unit-speed great circle with initial position \(u\) and tangent
\(v\),
\[
 |q'|=|2u^TAv|\le6,\qquad |q''|=|2(v^TAv-q(u))|\le4.
 \tag{7}
\]
For either active cubic \(g=(q-c_+)^3\) or \(g=(c_--q)^3\),
with nonnegative argument \(s\le1/2\), the chain rule gives
\[
 |g''|\le 6s\,|q'|^2+3s^2|q''|
          \le3\cdot36+(3/4)\cdot4=111,\qquad 0\le g\le1/8.
 \tag{8}
\]
At inactive points and boundaries the same bound holds by \(C^2\)
matching. Since the cap supports are disjoint, there is no factor of two.
For either \(h=h_K,h_L\), (6)-(8) give, for every unit tangent \(v\),
\[
 (\nabla_S^2h+hI)(v,v)
 \ge \frac18-\frac1{1000}\left(111+\frac18\right)
 =\frac{111}{8000}>0.                                      \tag{9}
\]
This is an explicit nonzero-parameter convexity certificate; no limiting
argument or unspecified smallness is used.

### Why (1) really is the support of (2)

For either \(h\), extend it homogeneously by
\(F(x)=\|x\|h(x/\|x\|)\) for \(x\ne0\), and \(F(0)=0\).
Homogeneity makes the radial Hessian and the radial-tangent cross terms
zero. On tangent directions its Hessian is the form in (9), scaled by
\(1/\|x\|\). Thus the restriction of \(F\) to a line not passing through
zero is convex. On a line through zero the two slopes are
\(-h(-u)\) and \(h(u)\); (4) makes the former at most the latter.
Hence \(F\) is convex on every line, and therefore convex.

For a unit \(u\), put \(x_u=\nabla F(u)\). Euler's identity gives
\(u\cdot x_u=F(u)=h(u)\). The supporting inequality for a differentiable
convex function gives \(F(v)\ge x_u\cdot v\) for every unit \(v\), so
\(x_u\) belongs to the intersection (2). The prescribed value \(h(u)\) is
therefore attained as the support in direction \(u\). This proves that
the actual support functions of \(K,L\) are exactly (1).

The intersections (2) are closed and convex. By (4) they contain the
closed unit ball. If \(x\) is in either intersection and \(x\ne0\), use
\(u=x/\|x\|\) in (2) to obtain \(\|x\|<3\).
They are compact and have nonempty interiors.

## 3. Every plane: a universal congruence

Fix an arbitrary two-dimensional linear subspace \(H\).
Let \(M\) and \(m\) be the maximum and minimum of \(q\) on its unit circle.
They are the eigenvalues of the symmetric restriction of \(A\) to \(H\).
Indeed, in any orthonormal basis its matrix has the form
\(\left(\begin{smallmatrix}d&e\\e&f\end{smallmatrix}\right)\), with real
eigenvalues \((d+f\pm\sqrt{(d-f)^2+4e^2})/2\). Distinct eigenvectors
are orthogonal by symmetry; a repeated eigenvalue forces \(e=0,d=f\),
so the restriction is scalar. This also justifies the extremal
description and all eigenvector choices used below.
The following three cases exhaust every plane, including equality cases.

**Case I: \(M\le5/2\).** Both high perturbations vanish identically on the
circle. The two restricted support functions coincide, including their
common low perturbation. Set \(T_H=I_H\).

**Case II: \(M>5/2\) and \(m\ge3/2\).** The low perturbation vanishes
identically. Since \(q(-u)=q(u)\) and \(P_+(-u)=P_-(u)\),
\(h_K(-u)=h_L(u)\) throughout the circle. Set \(T_H=-I_H\).

**Case III: \(M>5/2\) and \(m<3/2\).** In this case \(M>m\).
Choose orthonormal eigenvectors \(p,r\in H\), with eigenvalues \(M,m\),
oriented so that \(p_1>0\) and \(r_3>0\). These choices are possible:
if \(p_1=0\), (3) would give \(M\le2\); if \(r_3=0\), it would give
\(m\ge2\). Define the reflection
\[
 T_H(ap+br)=-ap+br.                                        \tag{10}
\]
It is an origin-fixing orthogonal involution, and preserves \(q\).

It remains to justify the hemisphere signs, not just the level values.
Here is that step in detail. For \(u=ap+br\) on the high cap,
\[
 (M-5/2)a^2-(5/2-m)b^2>0.                                 \tag{11}
\]
Thus \(a\ne0\) and
\(|b/a|<\sqrt{(M-5/2)/(5/2-m)}\).
For every \(t\) in this connected open interval,
\[
 \frac{q(p+tr)}{\|p+tr\|^2}>5/2.
\]
The first coordinate of \(p+tr\) cannot vanish: a vector with first
coordinate zero has Rayleigh quotient at most 2. The coordinate is
positive at \(t=0\), and hence positive throughout the interval.
Since \(u=a(p+(b/a)r)\), this proves
\[
       \operatorname{sgn}(u_1)=\operatorname{sgn}(a)
       \quad\hbox{on the high cap}.                        \tag{12}
\]

For \(u\) on the low cap, the analogous inequality is
\[
 (3/2-m)b^2-(M-3/2)a^2>0.                                 \tag{13}
\]
Now \(b\ne0\), and on the interval
\(|t|<\sqrt{(3/2-m)/(M-3/2)}\), the vector \(r+tp\) has Rayleigh
quotient less than \(3/2\). Its third coordinate cannot vanish, because
such a vector has quotient at least 2. It is positive at zero, so
\[
       \operatorname{sgn}(u_3)=\operatorname{sgn}(b)
       \quad\hbox{on the low cap}.                         \tag{14}
\]
The reflection (10) reverses \(a\) and retains \(b\). Equations
(12)-(14) consequently show
\[
 P_+(T_Hu)=P_-(u),\qquad N(T_Hu)=N(u).
\]
Outside the corresponding caps these identities also hold, because
\(q\) is preserved and the perturbations are zero. In particular this
covers \(q=5/2\), \(q=3/2\), and the whole intervening band. Therefore
\[
                 h_K(T_Hu)=h_L(u)\quad(u\in S^2\cap H).
 \tag{15}
\]

For completeness, if the two restricted eigenvalues coincide then either
Case I or Case II applies, and no eigenvector choice from Case III is used.
Planes containing a coordinate axis, tangent to a cap, or missing a cap
require no additional genericity hypothesis.

Orthogonal projection onto \(H\) preserves support values in directions
belonging to \(H\): for \(u\in H\),
\(\sup_{x\in K}u\cdot P_Hx=\sup_{x\in K}u\cdot x\).
All three choices of \(T_H\) are self-adjoint involutions. Thus (15) in
each case says
\[
 h_{T_H(K|H)}(u)=h_K(T_Hu)=h_L(u)=h_{L|H}(u).
\]
Compact convex sets with the same support function are equal. To see the
needed separation directly, if \(y\) is outside such a set, choose a
closest point \(x\) in it. Minimality along every segment from \(x\) gives
\((y-x)\cdot(z-x)\le0\) for all points \(z\) of the set. The direction
\(y-x\) then strictly separates \(y\), proving that the set is the
intersection of its supporting halfspaces. It follows that
\[
                         T_H(K|H)=L|H
\]
for **every** \(H\in G(3,2)\). These are ordinary Euclidean congruences
within the plane; no translations are even needed.

## 4. Exclusion of arbitrary translations and reflected translations

Consider the three unit directions
\[
 d_1=e_2,\qquad d_2=(e_1+e_2)/\sqrt2,\qquad
 d_3=(e_2+e_3)/\sqrt2.
\]
Their \(q\)-values are respectively \(2,5/2,3/2\).
All perturbations vanish at these directions and their negatives. Hence
\[
 h_K(d_j)=h_L(d_j)=h_L(-d_j)\quad(j=1,2,3).                 \tag{16}
\]

If \(K=L+t\), the support translation identity and (16) imply
\(t\cdot d_j=0\) for all three directions. After removing their positive
normalization factors, the coefficient matrix is
\[
 \begin{pmatrix}0&1&0\\1&1&0\\0&1&1\end{pmatrix},
 \qquad\det=-1.
\]
Thus \(t=0\). But
\[
                  h_K(e_1)-h_L(e_1)=1/8000>0,              \tag{17}
\]
which is a contradiction. This excludes **every** translate of \(L\).

If \(K=-L+t\), use \(h_{-L+t}(u)=h_L(-u)+t\cdot u\).
Exactly the same three equations again give \(t=0\), whereas
\[
                  h_K(e_3)-h_L(-e_3)=1/8000>0.             \tag{18}
\]
This excludes **every** translate of \(-L\).

The pair is globally related by reflection in the plane \(u_1=0\).
That is not an excluded operation in the question: the forbidden global
relations are translation and central reflection followed by translation,
not arbitrary orthogonal congruence.

## 5. A distinct route and its exact obstruction

The alternative ansatz with a common even support function and only
linear odd parts,
\[
 \widetilde h_K(u)=b(u)+a\cdot u,\qquad
 \widetilde h_L(u)=b(u)+c\cdot u,
\]
cannot work. Their difference is \((a-c)\cdot u\), so their bodies are
exactly translates by \(a-c\). The obstruction holds for every admissible
even \(b\) in this family, not just for a sampled parameter set.
Route `R-20001274-affine-odd` is therefore excluded. It says nothing about
all polynomial supports or all possible constructions. The successful
candidate above uses genuinely nonlinear, localized odd parts instead.

## 6. Exact replay and its scope

From the campaign directory run:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python research/verify_witness.py
```

This uses only the Python standard library. It independently recomputes
the multivariate polynomial identities, rational curvature margin,
boundary values, translation-exclusion equations, and symbolic reflection
identities. It checks the saved Jacobian payload and typed output against
the same curvature polynomial. No floating point or plane sampling is used.

The original bounded Jacobian operation can also be independently rerun:

```bash
timeout 60 /home/argustest/zimo/references/jacobian/.venv/bin/jacobian \
  run polynomial.sos.decomposition.check \
  --file research/jacobian-sos-payload.json
```

Its exact inspected input/output contract, payload, typed result, and
execution metadata are the corresponding `jacobian-sos-*.json` files.
The operation proves the SOS identity (5), not the entire geometric
theorem. The universal sign/connected-interval argument and the passage
from support functions to bodies are the mathematical proof in Sections
2-4, and must be read in independent review. This is an exact analytic
construction with reproducible algebraic evidence, **not** a Lean/kernel
formalization. Engineer replay does not constitute independent Reviewer
acceptance.
