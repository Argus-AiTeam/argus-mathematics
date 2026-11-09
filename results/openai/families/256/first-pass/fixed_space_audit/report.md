# Universal verification of the simultaneous fixed-space theorem

## Result and precise scope

The October manuscript's `thm:fixed-space` is valid with its stated
hypotheses. The proof below verifies the universal intersection argument,
including unequal positive sizes, signed repeated occurrences, arbitrary
fixed unitary matrices, empty target lists, and the zero-variable case.
No false manuscript assertion was identified in this audit. In particular,
the rank-deficient example below is NOT a counterexample to the manuscript.

The algebraic coefficient and shorter-product vanishing have a genuine
Lean 4.31.0 proof in `Main.lean`. The topology is proved in prose using the
explicit classical prerequisites in `literature.md`; it is not formalized
in Lean. `verify.py` replays exact adversarial computations and checks the
current native Lean certificate. Neither those computations nor a compiler
run alone proves the topological assertions.

This settles the fixed-space input, not the spectral-phase, planar, or
coefficient-injectivity arguments in the full arbitrary-group manuscript.
Independent Reviewer approval is still required. Novelty and publishable
significance are not asserted on the strength of the bounded prior-art search.

The source being checked is
`research/openai_manuscript/Nonsingular-systems-of-equations-over-arbitrary-groups-October-5-2026/build/sections/fixed-space.tex`,
especially `eq:fixed-top-coefficient`. All orientations used below may be
chosen independently; the nonvanishing conclusion does not depend on them.

## 1. Statement

Let \(r\geq0\), \(n\geq1\), and \(k_i>0\). For each \(j\), let
\(\mathcal B_j\) be a finite ordered list of pairs \((i,s)\) with
\(1\leq i\leq r\) and \(s=\pm1\), allowing repetitions. Put
\[
 d_j=\sum_{(i,s)\in\mathcal B_j}k_i,\qquad
 b_{ij}=\sum_{\substack{(i',s)\in\mathcal B_j\\i'=i}}s.
\]
Assume the integer matrix \(B=(b_{ij})\) has row rank \(r\) over
\(\mathbb Q\). For arbitrary \(P_j\in U(d_j)\), there exists
\(X\in D=\prod_i U(k_i)\) such that
\[
 \sum_j\dim_{\mathbb C}\ker\bigl(
   \operatorname{diag}_{(i,s)\in\mathcal B_j}(X_i^s)P_j-I\bigr)
 \ \geq\ \sum_i k_i .
\]
We interpret \(U(0)\) and an empty product as points.

## 2. Nested columns and feasible allocations

For \(r=0\) the assertion is immediate. Otherwise relabel rows and variables
so that \(k_1\geq\cdots\geq k_r\). Full row rank implies that the first
\(t\) rows have rank \(t\), for every \(t\).

Suppose \(j_1,\ldots,j_{t-1}\) have already been chosen with a nonsingular
initial \((t-1)\)-row minor. Their restrictions to the first \(t\) rows
remain independent: a relation there restricts to a relation on the first
\(t-1\) rows. Since all columns of the \(t\)-row matrix span a
\(t\)-dimensional space, an additional, necessarily distinct, column
\(j_t\) extends them to a basis. Consequently
\[
 \Delta_t=\det B[1,\ldots,t\mid j_1,\ldots,j_t]\ne0
 \quad(1\leq t\leq r).
\]
This proves nested selection, rather than assuming that a single
nonsingular full minor has nonsingular leading minors in its original order.

Assign \(l_{j_t}=k_t\) and \(l_j=0\) otherwise. The selected column \(j_t\)
has a nonzero entry among its first \(t\) rows. Such an entry requires
an actual occurrence of an \(i\leq t\), so
\(d_{j_t}\geq k_i\geq k_t=l_{j_t}\). Cancellation of other occurrences
does not invalidate this implication. Also
\[
 N:=\sum_j l_j=\sum_i k_i,\qquad
 S:=\sum_j l_j^2=\sum_i k_i^2=\dim_{\mathbb R}D.
\]

## 3. Compatible primitive classes: a complete induction

Work over \(\mathbb Q\). We use the multiplicative cohomological Serre
spectral sequence with its edge maps, and rational Kunneth; precise
source statements are given in `literature.md`.

The last-column map is a smooth bundle
\(U(d-1)\to U(d)\to S^{2d-1}\). For \(d\geq2\) the base is simply
connected. Assume inductively that the fiber cohomology is exterior
on generators of degrees \(1,3,\ldots,2d-3\).
The spectral sequence has columns only at \(p=0,2d-1\).
Its only possible differential is \(d_{2d-1}\); on any fiber generator
its target has negative fiber degree. It therefore vanishes on generators,
and hence on all their products by the derivation rule.
The spectral sequence collapses.

The edge maps imply that restriction to the fiber is an isomorphism
in every degree below \(2d-1\), and the pullback of a sphere generator
in degree \(2d-1\) is nonzero. Lift the earlier generators in their
degrees, and use that sphere pullback for \(e_{d,d}\).
The associated graded algebra is exterior on these classes.
Their exterior monomials lift its basis; their squares vanish because
the classes are odd and the coefficient field has characteristic zero.
This proves
\[
 H^*(U(d);\mathbb Q)=\Lambda(e_{1,d},\ldots,e_{d,d}),
 \qquad |e_{a,d}|=2a-1,
\]
with restriction to \(U(k)\) equal to \(e_{a,k}\) for \(a\leq k\),
and zero otherwise.

Here is the point that must not be replaced by an unsupported assertion
that arbitrary exterior generators are primitive. Let
\[
 \delta_a=\mu^*e_{a,d}-e_{a,d}\otimes1-1\otimes e_{a,d}.
\]
Its restrictions to the two factors at the identity vanish. Every
Kunneth summand therefore has both degrees positive, and each degree
is at most \(2d-2\). Restriction to
\(U(d-1)\times U(d-1)\) is injective on these summands by the edge
isomorphisms just proved. For \(a<d\), the restriction of \(\delta_a\)
is zero by induction. For \(a=d\), all three terms restrict to zero:
the multiplication of two fiber elements remains in the fiber, and
the last-column sphere pullback restricts to zero on that fiber.
Thus \(\delta_a=0\). The \(d=1\) case has no positive-positive split
of degree one and is immediate.

Other coordinate-block inclusions are conjugate to the standard one;
conjugation is homotopic to the identity since \(U(d)\) is connected.
Pulling primitivity back along \(X\mapsto(X,X^{-1})\) gives
\(\operatorname{inv}^*e_{a,d}=-e_{a,d}\).
Right translation by any \(P_j\) is homotopic to the identity.
Writing a block diagonal map as the product of its individual block
embeddings now gives, with repetitions counted separately,
\[
 F_j^*e_{a,d_j}
   =\sum_{i:k_i\geq a}b_{ij}e_{a,k_i}^{(i)}.                 \tag{1}
\]
No assumption on eigenvalues, genericity, or embeddability of the
matrices \(P_j\) has been introduced.

## 4. The incidence class and its nonzero leading coefficient

For \(0\leq l\leq d\) define
\[
 R(d,l)=\{(W,E):E\in\operatorname{Gr}_l(\mathbb C^d),
                   \ W\in U(d),\ W|_E=I\},\qquad p(W,E)=W.
\]
Over a Grassmannian chart, an orthonormal frame identifies the fiber
with \(U(d-l)\). Transition maps act by conjugation on this fiber;
they preserve its orientation because these conjugations are isotopic
to the identity. The complex Grassmannian is oriented. Thus \(R(d,l)\)
is a closed oriented smooth manifold of dimension
\[
 2l(d-l)+(d-l)^2=d^2-l^2 .
\]
It is compact, for instance as the closed incidence subset of the
product of two compact spaces. Let
\(\alpha(d,l)=\operatorname{PD}(p_*[R(d,l)])\).
Its image is exactly the fixed-space-multiplicity locus.
No assertion that this image is smooth is needed.

An exterior monomial with \(u\) distinct generators has degree at least
\(1+3+\cdots+(2u-1)=u^2\). A monomial of degree \(l^2\) therefore has
length at most \(l\); the only possible length-\(l\) monomial is
\(e_{1,d}\cdots e_{l,d}\). Write its coefficient as \(c_{d,l}\).

To prove \(c_{d,l}\ne0\), use
\[
 f:U(l)\longrightarrow U(d),\qquad f(X)=X\oplus(-I_{d-l}).
\]
There is exactly one intersection pair of \(f\) with \(p\):
\(X=I_l,\ W_0=I_l\oplus(-I_{d-l}),\ E_0=\mathbb C^l\oplus0\).
Indeed, the second block has no fixed vectors, and an \(l\)-dimensional
fixed space in the first block requires that block to be the identity.

Right-trivialize the tangent space at \(W_0\). Variations of \(f\)
give all upper-left skew-Hermitian blocks; variations of the incidence
fiber give all lower-right blocks. If \(Z:\mathbb C^l\to\mathbb C^{d-l}\)
and
\[
 T=\begin{pmatrix}0&-Z^*\\Z&0\end{pmatrix},
\]
variation by conjugation gives
\[
 [T,W_0]W_0^{-1}=2T.                                       \tag{2}
\]
These are all off-diagonal skew-Hermitian blocks. The difference
differential for the two maps is therefore an isomorphism.
In these block coordinates its determinant has absolute value
\(2^{2l(d-l)}\), not zero. Thus the unique intersection has local
intersection number \(+1\) or \(-1\).

For clarity, the local-intersection fact used here follows directly
from duality and excision. In the product of the two source manifolds,
pull back the diagonal's local orientation class by \(f\times p\).
Its evaluation equals
\(\langle f^*\operatorname{PD}(p_*[R]),[U(l)]\rangle\), up to the
cross-product orientation convention, by cap/cross-product naturality.
Near a transverse isolated pair, diagonal normal coordinates give
the map \((x,z)\mapsto f(x)-p(z)\) in target coordinates.
An invertible derivative gives local degree \(+1\) or \(-1\).
Excision and compactness remove the complement of the isolated pair,
so no genericity assumption or unproved global perturbation step
enters this particular calculation.

The map \(f\) is homotopic to a coordinate inclusion. Pulling back
any monomial with an index above \(l\) gives zero. A shorter monomial
with all indices at most \(l\) cannot have degree \(l^2\), because
it omits at least one positive degree from their total \(l^2\).
Hence
\[
 \pm1=c_{d,l}
   \left\langle e_{1,l}\cdots e_{l,l},[U(l)]\right\rangle .
\]
The second factor is nonzero by the exterior basis and Poincare duality,
so \(c_{d,l}\ne0\). We have proved
\[
 \alpha(d,l)=c_{d,l}e_{1,d}\cdots e_{l,d}
                 +\text{terms of exterior length less than }l.       \tag{3}
\]
For \(l=0\), \(p\) is the identity and \(\alpha(d,0)=c_{d,0}=1\).
For \(l=d\), the complementary blocks are absent and the same
calculation is the transverse intersection of the identity map
with the identity point. The case \(d=l=0\) is a point.

## 5. Vanishing, determinant factorization, and the exact sign

The source exterior algebra has precisely \(N=\sum_i k_i\) generators.
Their degrees sum to \(S=\sum_i k_i^2\). Every proper subset has
degree strictly below \(S\). Under (1), a product of \(u\) generators
maps to a homogeneous exterior-length-\(u\) element or to zero.
Selecting any shorter summand in (3) therefore gives a term of total
length below \(\sum_j l_j=N\), and cannot contribute in top degree.
This is the manuscript's shorter-term argument with both gradings
distinguished. `shorter_products_vanish` proves the length statement
for arbitrary finite ordered products, not just for the test examples.

For each \(1\leq a\leq k_1\), put \(t_a=|\{i:k_i\geq a\}|\).
The active rows are \(1,\ldots,t_a\) and the active selected columns
in pivot order are \(j_1,\ldots,j_{t_a}\).
At level \(a\), (1) gives the ordered product
\[
 \prod_{t=1}^{t_a}
   \left(\sum_{i=1}^{t_a}b_{i,j_t}e_{a,k_i}^{(i)}\right)
 =\Delta_{t_a}\prod_{i=1}^{t_a}e_{a,k_i}^{(i)}.              \tag{4}
\]
The coefficient matrix whose ROWS are these factor vectors is the
TRANSPOSE of the displayed minor. Its determinant is still
\(\Delta_{t_a}\). Layer matrices may have different sizes.
Their block-diagonal determinant is their determinant product;
`filtered_coefficient` formalizes this statement as an actual
exterior coefficient, and `nested_minor_nonzero` specializes it to
the nested submatrices. Empty layers are permitted in both the
formal theorem and its determinant convention.

One can sharpen the manuscript's harmless unspecified sign.
Use the source top monomial in row-major order
\[
 T_D=\prod_{i=1}^r\prod_{a=1}^{k_i}e_{a,k_i}^{(i)}
\]
and multiply target factors in the original order \(j=1,\ldots,n\),
with generators within a target in increasing \(a\).
Then the coefficient is exactly
\[
 \boxed{\quad
 (-1)^{\sum_{s<t,\ j_s>j_t}k_s k_t}
 \left(\prod_j c_{d_j,l_j}\right)
 \prod_{a=1}^{k_1}\Delta_{t_a}.\quad}                        \tag{5}
\]
To see this, first reorder whole target blocks into pivot order.
The block-swap sign is the one displayed. Next transpose the
Ferrers-diagram order \((t,a)\) into \((a,t)\) to use (4).
All individual generators are odd. Restoring the resulting source
order from \((a,i)\) to \((i,a)\) uses the identical Ferrers-diagram
permutation, since \(l_{j_t}=k_t\). These two signs cancel.
Equation (5) in particular proves `eq:fixed-top-coefficient` up to
orientation sign, with no equal-size restriction.

Every factor in (5) is nonzero. The source top monomial has nonzero
evaluation on \([D]\). Thus
\[
 \left\langle\prod_j F_j^*\alpha(d_j,l_j),[D]\right\rangle\ne0.          \tag{6}
\]

## 6. Why nonzero pairing forces an actual intersection

Here is a version that avoids assuming the incidence image is embedded,
and avoids relying on the existence of a transverse perturbation.
Let \(Y\) be a closed oriented manifold, \(p:Q\to Y\) a continuous
map from a closed oriented manifold, and
\(\alpha=\operatorname{PD}(p_*[Q])\).
If a map \(f:M\to Y\) has image disjoint from \(p(Q)\), take an
open set \(U\supset p(Q)\) disjoint from \(f(M)\). In the application
both images are compact, so such \(U\) certainly exists.

Regard \(p_*[Q]\) as a homology class in \(U\).
Poincare duality with compact supports gives
\(\beta\in H_c^{\dim Y-\dim Q}(U;\mathbb Q)\) dual to this class.
Naturality under open inclusion sends \(\beta\), by extension by zero,
to \(\alpha\) in \(Y\). By the definition of compactly supported
cohomology, \(\beta\) is represented relative to \(U\setminus K\)
for some compact \(K\subset U\). Excision extends it to a class
relative to \(Y\setminus K\). Since \(f(M)\) avoids \(K\),
\(f^*\alpha=0\).
This proves the contrapositive: a nonzero pulled-back evaluation
forces an intersection. The external ingredients here are exactly
Hatcher's Theorems 3.30 and 3.35 and the cap-product naturality
spelled out in the source excerpts, not a theorem about smooth images.

Apply this to \(Y=\prod_j U(d_j)\), \(Q=\prod_jR(d_j,l_j)\),
\(p=\prod_jp_j\), and \(f=F=(F_1,\ldots,F_n)\).
The cross-product dual of \(p_*[Q]\) is
\(\prod_j\alpha(d_j,l_j)\) up to orientation sign.
The dimensions are complementary because
\(\dim D+\dim Q=\sum_jd_j^2\).
Equation (6) therefore gives a point \(X\) for which every \(F_j(X)\)
fixes an \(l_j\)-plane. Summing these dimensions proves the theorem.

## 7. Structural extension and an essential-hypothesis check

The same proof yields a layerwise intersection criterion, without
requiring the maps to come from signed block occurrences.
Let \(D=\prod_i U(k_i)\), let \(0\leq l_j\leq d_j\), and suppose the
multiset of positive \(l_j\)'s equals the multiset of \(k_i\)'s.
Suppose continuous maps \(G_j:D\to U(d_j)\) have LINEAR primitive
pullbacks
\[
 G_j^*e_{a,d_j}=\sum_{i:k_i\geq a}q^{(a)}_{ij}e_{a,k_i}^{(i)}
\]
for every target generator. At each level \(a\), assume the square
matrix with rows \(k_i\geq a\) and columns \(l_j\geq a\) is nonsingular.
Then there exists \(X\) such that every \(G_j(X)\) fixes an \(l_j\)-plane.
The coefficients may depend on \(a\). Equations (3)--(6) prove this
criterion with the independent layer determinants in place of
the nested minors. This is a structural extension of the audited
statement; its novelty relative to all literature is not established here.
The linear-pullback hypothesis is explicit: arbitrary decomposable
pullbacks are NOT covered by this argument.

Rank cannot simply be deleted from the manuscript's hypotheses.
For \(r=n=k_1=1\), take the two occurrences \(X,X^{-1}\) and
\[
 P=\begin{pmatrix}0&1\\-1&0\end{pmatrix},\qquad
 F(x)=\begin{pmatrix}0&x\\-x^{-1}&0\end{pmatrix}.
\]
For every \(x\in U(1)\), \(\det(F(x)-I)=2\), so no fixed vector exists.
Here \(B=(0)\), violating the original rank hypothesis. The exact
script labels this a negative control and never a manuscript refutation.

## 8. Evidence, limitations, and replay

`Main.lean` proves the universal algebra over all finite layer sizes,
including empty layers and an empty entire family. Its native
certificate records the actual compiler, exit status, proof-hole
audit, source, and fidelity document. The fidelity document explicitly
lists the objects not encoded in Lean.

The deterministic replays include eight signed-occurrence constructions,
four symbolic/rational coefficient constructions, all 21 tangent cases
\(0\leq l\leq d\leq5\), all nine shorter monomials of the required
degrees in those incidence examples, a rank-deficient negative control,
and one exact typed Jacobian determinant execution.
One shorter term has a NONZERO individual pullback and is killed only
after multiplication by the other factors. Thus testing only generator
truncation would not have checked the actual shorter-term mechanism.
The signed matrix \(\operatorname{diag}(2,-3)\) is included explicitly:
its determinant is \(-6\), so rational row rank is not being replaced
by an integral unimodularity hypothesis.
The general proofs are Sections 2--6 and the universal Lean declarations,
not extrapolations from these counts.

Run the exact replay with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/fixed_space_audit/verify.py
```

For an independent compiler replay, keep both source and fidelity
document unchanged during this command:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/fixed_space_audit/Main.lean --statement-fidelity research/fixed_space_audit/statement_fidelity.md --claim L_FS_FORMAL --project-root .
```

The proof graph leaves the other arbitrary-group bridges open and
does not impersonate an independent Reviewer. The separate literature
note distinguishes source retrieval, classical results, and the
still-unestablished novelty assessment.
