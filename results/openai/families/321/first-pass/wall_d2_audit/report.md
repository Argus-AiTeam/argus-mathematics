# The universal Fox-boundary torsion obstruction: independent verification of the finite D(2) construction

## 1. Result, scope, and mathematical dependencies

This report independently verifies the algebraic core of OpenAI,
*A Counterexample to Wall's D(2) Problem*, October 6, 2026. Its central
formal result is universal: for every finite presentation, every complex
character of its actual presented quotient, and every torsion element,
injectivity of the relator-derived Fox boundary forces the character
to kill that element. This is the manuscript's torsion corollary in
presentation form, not a new torsion theorem. The staged source is
`research/openai_manuscript/A-Counterexample-to-Walls-D2-Problem-October-6-2026/build/`.

The verification contribution is an explicit word-level realization of
the cyclic-tower argument. A normal-closure identity determines one fixed
finite source; rational voltages construct its lifts; actual word-integral
matrices, specialization, and coefficient extraction transport the twisted
boundary; and strict vertex growth contradicts a fixed word-length bound.
Lean 4.31.0 certifies this construction and its final universally quantified
implication with no proof holes. Neither a covering-space interface nor the
desired transfer and growth properties are assumed. Section 14 states
this theorem and explains the implementation; Section 15 compares its
verification contribution with the strongest inspected primary sources.

The manuscript supplies the mathematical conclusion and its twisted
cyclic-cover argument; Howie and Louder-Wilton supply the prior tower
method. Our contribution is their source-faithful, independently checked
algebraic realization, not new priority for those results. Its significance
is assessed at the precise dependency used both by the manuscript and by
BBMN's explicitly conditional Corollary B, rather than by a search miss
or the mere existence of a compiling file.

The universal certificate and its statement fidelity were independently
accepted in `roles/reviewer/progress.json#torsion_fox_review_round_2`.
The fixed-construction integral certificate and the prose topology also
have their earlier independent reviews. **The CW-topological conclusion
below remains a reviewed prose theorem supported by certified algebra,
not a kernel theorem about CW complexes.** The higher-rank extension in
Section 3 is likewise prose, not part of the universal Lean certificate.
No counterexample to the staged mathematical conclusions is asserted.
The new contribution assessment in Section 15 still requires its own
Host Reviewer decision; correctness approval does not imply publication
approval.

The only imported topology is the usual foundational package: covering-space
classification and lifting; van Kampen; cellular homology, its relative exact
sequence and degree-one Hurewicz identification; cellular and simplicial
approximation; homotopy invariance; and degree-two Hurewicz for simply connected
CW complexes. These are stated as foundational assumptions in the ledger.
Hatcher's *Algebraic Topology* provides the corresponding sources, particularly
Proposition 1.33, Theorems 2C.1, 2.35, 4.8, 4.32, and Section 3.H.
Their hypotheses are checked at the applications below. We do not assume the
manuscript's obstruction, any unresolved relation-gap assertion, or the desired
conclusion. Elementary finite-dimensional linear algebra and abelian-group
algebra are used throughout.

The primary-source comparison is in [citations.md](citations.md). Howie's
constant-coefficient lemma is not being silently upgraded to a local-system
lemma. Mannan's normal-finiteness hypothesis is not being replaced by finite
generation of the kernel as an abstract group. Two historical sources,
Wall's 1979 problem list and Cohen's original stabilization note, were not
obtained; neither is a premise of this proof. The contribution claim below
is relative to the identified primary predecessors, not a claim to the
first formalization anywhere in the literature.

### The verification theorem

Let \(B\) be the presentation complex with generators
\(x_1,a_1,x_2,a_2,s\) and relators
\[
\begin{split}
r_1&=x_1a_1x_1^{-1}a_1^{-4},&
r_2&=x_2a_2x_2^{-1}a_2^{-3},\\
r_3&=x_1a_2^{-13},&
r_4&=sx_2s^{-1}a_1^{-5}.
\end{split}
\]
Write \(P=\pi_1(B)\), \(t_1=x_1^2\), \(t_2=x_2^3\),
\(K=\langle\!\langle t_1,t_2\rangle\!\rangle_P\), and \(G=P/K\).
There is a finite connected complex \(X\) obtained from \(B\) by two
two-cells and two three-cells such that
\[
\pi_1(X)=G,\quad
H_i(\widetilde X;\mathbb Z)=0\ (i>2),\quad
H^3(X;M)=0\quad\text{for every left }\mathbb ZG\text{-module }M.
\]
The group \(G\) is infinite, but \(X\) is not homotopy equivalent to any finite
CW complex of dimension at most two.

The following sections prove this assertion without assuming a finite
presentation for \(K\), an asphericity assertion about \(B\), flatness of a
coefficient module, or a triangulation that changes during the tower.

## 2. Ordinary chains and the cyclic-cover specialization

### 2.1 Conventions and subcomplexes

For a right representation \(V\) of \(\pi_1(T)\) over a field \(k\), use left
deck-action cellular chains and
\[
C_*(T;V)=V\otimes_{\mathbb Z\pi_1(T)}C_*(\widetilde T;\mathbb Z).
\]
Equivalently, choose a fiber over the interior of every oriented cell.
The cellular chain group is the **direct sum**, not the product, of those
fibers. Every chain has finite support. Its boundary is the sum of incidence
maps with their parallel transports. This description also applies to an
infinite complex and does not require identifying fundamental groups of
subcomplexes.

If \(A\subseteq T\) is a subcomplex, the inclusion is therefore injective on
cellular chains with the restricted system. If \(\dim T\leq2\), there are no
three-boundaries in either complex, so
\[
H_2(A;V|_A)=\ker(d_2|_{C_2(A;V)})
 \ \lhook\joinrel\longrightarrow\ \ker d_2=H_2(T;V).
\tag{2.1}
\]
In particular, no injectivity of \(\pi_1(A)\longrightarrow\pi_1(T)\) is needed.

On a connected complex, identify all vertex fibers with a base fiber using
paths in a spanning tree. The remaining edge relations identify \(v\) with
its transport around each loop. Consequently
\[
H_0(T;V)=V/\langle v\cdot g-v:v\in V,\ g\in\pi_1(T)\rangle.
\tag{2.2}
\]
If \(d=\dim_k V<\infty\), its dimension is at most \(d\), and equals \(d\)
only if every monodromy map is the identity. In rank one a nonidentity
monodromy scalar makes this quotient zero.

### 2.2 The deck action is not the character

Let \(p:\widehat A\to A\) be a connected infinite cyclic cover of a finite
connected CW complex. For a deck generator \(\tau\), define its action on the
pulled-back bundle by
\[
(\widehat x,v)\longmapsto(\tau\widehat x,v),\qquad v\in V_{p(\widehat x)}.
\tag{2.3}
\]
This is well defined because \(p\tau=p\). Parallel transport along a path and
its translate is transport along the very same downstairs path, so the action
commutes with cellular boundaries. Set \(R=k[z,z^{-1}]\), with \(z\) acting
as (2.3).

Choose one lift of each cell and a fiber basis there; give all its translates
the transported-by-(2.3) basis. Distinct translates are distinct cells, so
finite support identifies the degree-\(j\) chains with
\(R^{d c_j(A)}\). A cellular boundary has finite support and is \(R\)-linear.
Thus its entries really are Laurent polynomials, not formal Laurent series.

The projection on chains sends a translated cell with coefficient \(v\) to
the original cell with coefficient \(v\). Its kernel on each cell orbit is
exactly \((z-1)R^d\), and it respects the boundary because projected incidence
paths and transports are the downstairs ones. Hence, degree by degree and
compatibly with the differentials,
\[
C_*(\widehat A;p^*V)\otimes_R R/(z-1)
       \ \cong\ C_*(A;V).
\tag{2.4}
\]
No assertion of exactness of tensoring homology is used.

For example, for a circle with character value \(\lambda\), the boundary on
its infinite cyclic cover in these bases is \(\lambda z-1\), and at \(z=1\)
it is \(\lambda-1\), not zero. Thus specialization does not discard the
monodromy. Choosing the other deck generator replaces \(z\) by \(z^{-1}\)
and gives the same specialization.

### 2.3 Proof of the cyclic-cover lemma

Assume now \(\dim A\leq2\) and \(H_2(A;V)=0\). Let \(D(z)\) be the upstairs
second boundary and let \(m=d c_2(A)\) be its number of columns. Equation
(2.4) identifies \(D(1)\) with the downstairs second boundary. It is
injective because there are no three-cells.

If \(m=0\), the conclusion is immediate. Otherwise \(D(1)\) has a nonzero
\(m\)-row minor. The determinant of the corresponding minor of \(D(z)\)
is a Laurent polynomial whose value at 1 is nonzero. It is therefore
nonzero in the integral domain \(R\). The matrix has full column rank
over \(k(z)\). Since \(R^m\) embeds in \(k(z)^m\), it has zero kernel over
\(R\) as well. There are again no three-cells upstairs, so
\[
H_2(\widehat A;p^*V)=0.
\tag{2.5}
\]
This proves the manuscript's Lemma `lem:cyclic-cover`, and also its
finite-rank version over any field. It is a universal proof, not an
extrapolation from a collection of covers.

## 3. A maximal cyclic tower and the obstruction

### 3.1 A dimension-preserving simplicial model

We need a finite simplicial model of the target of dimension at most two.
Here is a concrete justification rather than an appeal to triangulability of
an arbitrary CW structure.

The finite one-skeleton is a graph; subdivide loops and parallel edges to
obtain an abstract simplicial graph. Homotope each two-cell attaching map
to a finite edge loop, using cellular/simplicial approximation on a circle.
A constant loop can instead be attached constantly, giving a two-sphere
wedged at its vertex. For a nonconstant loop, take a polygonal domain circle
with at least three distinct vertices, one edge for each traversal, with
further subdivision if needed.

Replace the attachment by the mapping cylinder of that edge-loop map,
capped on its domain circle by a disk. This is the original attachment
with a collar, after the harmless homotopy of its attaching map. Every
mapping-cylinder rectangle has four distinct vertices: its two domain-circle
vertices are separate from the graph, and its two graph vertices are distinct
endpoints of an edge. Cone each rectangle boundary to its own new interior
vertex, and cone each cap boundary to another new vertex. Adjacent rectangles
share the prescribed vertical edges; repeated traversals share only their
prescribed graph faces and have different interior vertices. Their triangles
therefore form an honest finite simplicial complex. Distinct two-cells use
different added vertices. A constantly attached sphere can also be triangulated
with just its chosen attaching vertex in the graph.

This gives a finite simplicial complex of dimension at most two with the
required homotopy type. Transfer the local system and the map to it. Standard
simplicial approximation applies because the domain \(F\) is a finite
simplicial complex. Subdivide \(F\) once sufficiently far so the map is
simplicial, and **fix that triangulation henceforth**. Homotopy equivalences
preserve local-coefficient homology: their lifts give equivariant chain
homotopy inverses, and tensoring preserves the chain homotopies.

### 3.2 Maximality, including the strict counting step

Let \(F\) be finite, connected, and satisfy \(b_1(F;\mathbb Q)=0\).
Start with the simplicial image \(A_0\) of \(F\). Consider every image
obtainable by a finite sequence of these operations: lift the current map
through a connected infinite cyclic cover, then corestrict to its image.
Include the empty sequence.

Every such image \(A\) is a finite connected subcomplex. Every one of its
nonempty simplices is the image of a simplex of the fixed \(F\), so its
number \(s(A)\) of nonempty simplices is at most \(s(F)\). The nonempty set
of attainable integer counts thus has a maximum, attained by some such
image \(A\). This is a finite maximal-image cyclic tower; no limiting
space or convergence assertion is involved.

Suppose \(b_1(A;\mathbb Q)>0\). Its finitely generated abelianization admits
an epimorphism to \(\mathbb Z\), giving
\(\phi:\pi_1(A)\twoheadrightarrow\mathbb Z\). The composite from
\(\pi_1(F)\) is zero, since it factors through the finite group
\(H_1(F;\mathbb Z)\). Covering-space lifting applies: \(F\) is connected and
locally path connected, and its fundamental-group image lies in
\(\ker\phi\). Therefore the current map lifts to the connected cover
\(p:\widehat A\to A\) for \(\ker\phi\).

The lift is simplicial on the **same** \(F\). On each domain simplex the
original image is a simplex; its chosen lift lies in one lift of that
simplex. Collapsed edges stay collapsed under lifting. No further subdivision
has been introduced. Let \(A'\) be the lifted image.

The restriction \(p|_{A'}\) is onto \(A\) and sends each simplex
isomorphically to a simplex of the same dimension. Thus \(s(A')\geq s(A)\).
If equality held, there would be one and only one simplex above each
simplex of \(A\). Uniqueness forces the inverse assignment to respect
faces, so it is a simplicial inverse to \(p|_{A'}\). Composing it with
\(A'\hookrightarrow\widehat A\) gives a section of \(p\). On fundamental
groups that would make \(p_*\) onto, contradicting
\(\operatorname{im}p_*=\ker\phi\ne\pi_1(A)\).
Consequently \(s(A')>s(A)\), contradicting maximality. We have proved
\[
b_1(A;\mathbb Q)=0
\quad\hbox{at a maximal image.}
\tag{3.1}
\]
Equivalently, a sequence that keeps taking nontrivial cyclic covers has at
most \(s(F)-s(A_0)\) such strict increases. This proves termination rather
than assuming a literature theorem with unchecked map hypotheses.

### 3.3 Finite-rank tower theorem

**Theorem.** Let \(k\) be any field, \(Y\) a finite connected CW complex of
dimension at most two, and \(V\) a local system of finite-dimensional
\(k\)-vector spaces. If \(H_2(Y;V)=0\), then for every map \(F\to Y\) from
a finite connected simplicial complex with \(b_1(F;\mathbb Q)=0\), the
pulled-back local system has trivial monodromy.

**Proof.** Rank zero is vacuous. Let the rank be \(d>0\). Use Section 3.1
and take a maximal image \(A\) as in Section 3.2. Along the finite tower,
the vanishing of \(H_2\) persists by (2.1) and (2.5). The system pulled
back to \(F\) is unchanged, since each step is a lift followed by a
corestriction.

By (3.1) and the ordinary rational Euler formula,
\(\chi(A)=1+b_2(A;\mathbb Q)\geq1\). On the other hand, every cell contributes
\(d\) dimensions to the local cellular chains. The alternating-sum formula
and vanishing of twisted \(H_2\) give
\[
d\ \leq\ d\chi(A)
  =\dim_k H_0(A;V_A)-\dim_k H_1(A;V_A)
  \leq \dim_k H_0(A;V_A)\leq d.
\tag{3.2}
\]
All inequalities are equalities. By (2.2), full-dimensional coinvariants
mean that every operator \(v\mapsto v\cdot g-v\) is zero. Thus \(V_A\),
and hence its pullback to \(F\), has trivial monodromy. This proves the
theorem. The use of rational Betti numbers only detects maps to
\(\mathbb Z\); it does not restrict the characteristic of \(k\). QED.

Taking \(k=\mathbb C\), \(d=1\) proves the manuscript's `thm:tower`.
Its intermediate Euler inference is also correct directly: nontrivial
rank-one monodromy gives \(H_0=0\), hence
\(\chi=-\dim H_1\leq0\); since
\(\chi=1-b_1(-;\mathbb Q)+b_2(-;\mathbb Q)\), one gets \(b_1\geq1\).

### 3.4 Torsion

If \(g\in\pi_1(Y)\) has order \(n>1\), a representative loop extends over
\(M_n=S^1\cup_{\deg n}D^2\) because its \(n\)-fold iterate is
nullhomotopic. The ordinary cellular boundary of \(M_n\) is multiplication
by \(n\), so \(H_1(M_n;\mathbb Z)=\mathbb Z/n\) and \(b_1(M_n;\mathbb Q)=0\).
Section 3.1 supplies a finite simplicial homotopy model. If the character
detected \(g\), this map would contradict the tower theorem. An element of
order one is already in every character's kernel. This proves
`cor:torsion`, including every finite order, not just order two.

## 4. The perfect kernel: noncommutative proof and word witnesses

All commutators below mean \([u,v]=uvu^{-1}v^{-1}\).
The presentation gives, by iterating conjugation,
\[
x_1^2a_1x_1^{-2}=a_1^{16},\qquad
x_2^3a_2x_2^{-3}=a_2^{27}.
\]
The other two relators give \(x_1^2=a_2^{26}\) and
\(sx_2^3s^{-1}=a_1^{15}\). Thus
\[
t_1=a_2^{26}=[t_2,a_2],\qquad
st_2s^{-1}=a_1^{15}=[t_1,a_1].
\tag{4.1}
\]
These are group identities, not abelianized substitutions.

The exact certificate contains six proofs of the relevant equalities as
products of conjugates of the original relators in the **free group** on
the five specified generators. The verifier expands each product and freely
reduces it to the target word. For example, putting
\(r=xax^{-1}a^{-q}\), one has
\[
x a^e x^{-1}a^{-qe}
 =\prod_{j=0}^{e-1}a^{qj}r a^{-qj}\quad(e\geq1),
\]
and
\[
x^m a x^{-m}a^{-q^m}
 =x\bigl(x^{m-1}a x^{-(m-1)}a^{-q^{m-1}}\bigr)x^{-1}
   \bigl(xa^{q^{m-1}}x^{-1}a^{-q^m}\bigr).
\]
These yield the first two witnesses. For \(r=uv^{-1}\), the identity
\(u^e v^{-e}=\prod_{j=e-1}^{0}u^j r u^{-j}\), with descending product
order, yields the power-equality witnesses. Multiplying one such equality
by the inverse of another yields (4.1). All cancellations are checked
literally; no word problem oracle is assumed.

Now let \(U=K/[K,K]\), write \(u_j\) for the image of \(t_j\), and use
the genuine left \(P\)-action by conjugation. Each element of \(K\) acts
trivially on \(U\), so this action factors through \(G\). For \(t\in K\)
and \(a\in P\), the image of \([t,a]=t(at^{-1}a^{-1})\) in \(U\) is
\([t]-a[t]\). Therefore (4.1) gives
\[
u_1=(1-a_2)u_2,\qquad su_2=(1-a_1)u_1.
\tag{4.2}
\]

Since \(t_1=a_2^{26}\), conjugation by \(a_2\) fixes \(u_1\), and
\(a_2^{26}\in K\) acts trivially on every element of \(U\).
Multiplying the first relation of (4.2) on the left by
\(1+a_2+\cdots+a_2^{25}\) gives
\[
26u_1=(1-a_2^{26})u_2=0.
\]
Likewise \(st_2s^{-1}=a_1^{15}\) shows that \(a_1\) fixes \(su_2\),
and \(a_1^{15}\) acts trivially on \(U\). Thus the second relation gives
\[
15su_2=(1-a_1^{15})u_1=0.
\]
The action of \(s\) is invertible, so \(15u_2=0\). Equation (4.2) now gives
\(15u_1=0\). The integer identity \(7\cdot15-4\cdot26=1\) implies \(u_1=0\),
and then \(su_2=0\) implies \(u_2=0\).

Only powers of **one** group action were multiplied in each norm sum.
Neither \(a_1\), \(a_2\), nor \(s\) was commuted past a different group
action. Finally, normal generation means every element of \(K\) is a finite
product of \(P\)-conjugates of \(t_j^{\pm1}\); hence \(u_1,u_2\) generate
\(U\) as a \(\mathbb ZG\)-module. Their vanishing proves \(K=[K,K]\).
This proves `lem:perfect`.

## 5. The character and exact Fox boundary

Work first in \(E=\mathbb Q[\zeta]/(\zeta^2+\zeta+1)\), represented exactly
by pairs \((a,b)=a+b\zeta\). The polynomial is irreducible over
\(\mathbb Q\) and its complex roots are the primitive cube roots, so either
embedding \(E\hookrightarrow\mathbb C\) is valid. Multiplication and norm are
\[
(a,b)(c,d)=(ac-bd,ad+bc-bd),\qquad
N(a,b)=a^2-ab+b^2.
\tag{5.1}
\]

Set
\[
(\rho(x_1),\rho(a_1),\rho(x_2),\rho(a_2),\rho(s))
       =(-1,\zeta,\zeta^2,-1,1).
\]
Evaluating the four actual relator words gives 1 in every case:
\(\zeta=\zeta^4\), \(-1=(-1)^3\),
\(-1=(-1)^{13}\), and \(\zeta^2=\zeta^5\).
Also \(\rho(t_1)=(-1)^2=1\) and \(\rho(t_2)=(\zeta^2)^3=1\).
Thus the character really descends to \(G\).

### 5.1 Reconstructing, rather than copying, the matrix

For each oriented occurrence of a positive generator \(g\) after prefix
\(w\), add \(\rho(w)\) to its coordinate. For a negative occurrence
\(g^{-1}\), add \(-\rho(wg^{-1})\), then continue with the updated prefix.
These are exactly the lifted cellular edge contributions. They also derive
the Fox product rule and inverse rule. In particular, summing the boundary
of each such edge telescopes to the endpoint difference, proving
\[
\sum_g \rho\left(\frac{\partial w}{\partial g}\right)(\rho(g)-1)
       =\rho(w)-1
\tag{5.2}
\]
for every word, before any relator is imposed.

Applied letter by letter to \(r_1,\ldots,r_4\), this gives the following
rows in the edge order \(x_1,a_1,x_2,a_2,s\):
\[
D=\begin{pmatrix}
1-\zeta&-2&0&0&0\\
0&0&2&\zeta^2-1&0\\
1&0&0&-1&0\\
0&-(1+\zeta)&1&0&1-\zeta^2
\end{pmatrix}.
\tag{5.3}
\]
For \(xax^{-1}a^{-n}\), the two nonzero coordinates are
\(1-\rho(a)^n\) and
\(\rho(x)-\sum_{j=0}^{n-1}\rho(a)^j\).
The sums needed here are
\(1+\zeta+\zeta^2+\zeta^3=1\),
\(1-1+1=1\),
\(\sum_{j=0}^{12}(-1)^j=1\), and
\(\sum_{j=0}^{4}\zeta^j=1+\zeta\).
Thus every displayed entry, including each inverse-letter sign, agrees.

The first boundary is the row with entries
\[
(-2,\zeta-1,\zeta^2-1,-2,0).
\]
Regard the rows of (5.3) as images of the four two-cell basis vectors.
Equation (5.2) proves, and the script checks exactly, that their dot
products with these first-boundary entries are zero. Equivalently, if
column vectors are used for chains, \(d_2=D^{\mathsf T}\) and
\(d_1d_2=0\). This fixes the row/column and left/right convention explicitly.

### 5.2 The minor and homology

In the columns \(x_1,a_1,x_2,s\), expand first along the last column.
The remaining three-by-three determinant is
\[
\det\begin{pmatrix}1-\zeta&-2&0\\0&0&2\\1&0&0\end{pmatrix}=-4.
\]
The minor is therefore
\[
-4(1-\zeta^2)=-8-4\zeta,\qquad N(-8-4\zeta)=48.
\tag{5.4}
\]
It is nonzero in \(E\) and in either complex embedding. Thus the
second boundary \(E^4\to E^5\) is injective. Since \(B\) has no
three-cells, \(H_2(B;E_\rho)=0\), and the same holds over \(\mathbb C\).
In fact \(d_1\) has rank one, so this twisted complex is acyclic.

The five maximal minors, in lexicographic column order, are
\[
0,\quad -8-4\zeta,\quad 6+6\zeta,\quad -6,\quad 8+4\zeta.
\]
As a second exact arithmetic check, replacing every \(a+b\zeta\) by its
two-by-two multiplication matrix
\(\left(\begin{smallmatrix}a&-b\\ b&a-b\end{smallmatrix}\right)\)
gives an eight-by-eight rational matrix for the chosen minor.
An independent rational elimination algorithm gives determinant 48.

## 6. Finite plus construction with an arbitrary-module splitting

This section proves `prop:plus` for every finite connected \(B\) of
dimension at most two, with any perfect \(K\) normally generated by
\(t_1,\ldots,t_r\). In particular it applies to Section 4.

Attach \(r\) two-cells along the chosen loops, giving \(B'\).
Van Kampen gives \(\pi_1(B')=G=P/K\). The full preimage \(\overline B\)
in \(\widetilde {B'}\) is connected because \(P\to G\) is onto; by
covering classification it is the cover of \(B\) with fundamental group
\(K\). Degree-one Hurewicz therefore gives
\(H_1(\overline B;\mathbb Z)=K_{\mathrm{ab}}=0\).

Put \(R=\mathbb ZG\) and use left cellular chain modules. Relative to
\(\overline B\), the only cells of \(\widetilde {B'}\) are the new
two-cells, one free \(G\)-orbit for each attachment. Thus the relative
chain complex is \(R^r\) in degree two and zero elsewhere. The exact
sequence of the pair gives an \(R\)-linear surjection
\[
H_2(\widetilde {B'};\mathbb Z)\longrightarrow R^r
   \longrightarrow H_1(\overline B;\mathbb Z)=0.
\tag{6.1}
\]
Choose a preimage \(\alpha_j\) of each standard basis vector. This is
only a finite list of choices; finite generation of the entire \(H_2\)
module is not assumed. Concretely, the boundary of each new two-cell is a
finite cellular one-cycle in \(\overline B\). Since its first homology
vanishes, subtract a finite two-chain of \(\overline B\) with that boundary.
The resulting two-cycle is the required lift of the relative basis vector.
This also gives a direct chain-level proof of (6.1).

The cover \(\widetilde {B'}\) is simply connected. The degree-two
Hurewicz theorem applies and represents each \(\alpha_j\) by a map
\(S^2\to\widetilde {B'}\). Project to \(B'\), and attach \(r\) three-cells
along these maps. The resulting finite \(X\) has fundamental group \(G\),
since three-cell attachment does not change it.

Let \(q\) project
\[
C_2(\widetilde X)=C_2(\overline B)\oplus R^r
\]
onto the second summand, identified with \(C_3(\widetilde X)=R^r\).
The chosen lifts and orientations of the three-cells have boundary
cycles representing the selected \(\alpha_j\). Because \(B'\) is
two-dimensional, these classes are actual cellular two-cycles, not
classes ambiguous modulo three-boundaries. Equation (6.1) says exactly
\[
q d_3=1.
\tag{6.2}
\]

Here is an explicit splitting, including its noncommutative order.
Write \(d_3(u)=(A u,u)\) for an \(R\)-linear map \(A\), and
write \(d_2(v,w)=d_Bv+bw\). The chain identity is
\(d_BA+b=0\). The degree-two change of coordinates
\[
(v,w)\longmapsto(v-Aw,w)
\tag{6.3}
\]
is an \(R\)-linear isomorphism with inverse \((v,w)\mapsto(v+Aw,w)\).
In these coordinates \(d_3(u)=(0,u)\) and \(d_2(v,w)=d_Bv\).
In all other degrees use the identity. Therefore
\[
C_*(\widetilde X)\ \cong\
C_*(\overline B)\ \oplus\
\bigl(0\to R^r\xrightarrow{1}R^r\to0\bigr),
\tag{6.4}
\]
where the last summand is in degrees three and two. The isomorphism fixes
the included \(C_*(\overline B)\). There is no commutative-ring assumption.

More explicitly, a chain retraction has degree-two component
\(r_2(v,w)=v-Aw\), identity in degrees one and zero, and zero in degree
three. If \(i\) is the inclusion, the homotopy
\(h_2(v,w)=w\), all other \(h_j=0\), satisfies \(1-ir=dh+hd\).
These displayed equations prove the splitting for every coefficient module;
they are not finite tests or stored truth values.

Equation (6.2) makes \(d_3\) injective, so \(H_i(\widetilde X;\mathbb Z)=0\)
for \(i>2\). For **any** left \(R\)-module \(M\), a cochain
\(\varphi:C_3(\widetilde X)\to M\) extends to \(\varphi q\), with
\((\varphi q)d_3=\varphi\); hence \(H^3(X;M)=0\).

For **any** right \(R\)-module \(N\), tensor (6.4), or tensor the displayed
retraction and chain homotopy. The identity two-term summand remains
contractible. Thus inclusion induces
\[
H_*(N\otimes_R C_*(\overline B))
       \cong H_*(N\otimes_R C_*(\widetilde X)).
\tag{6.5}
\]
The left side is \(H_*(B;N)\) with the action pulled back from \(G\):
indeed \(C_*(\overline B)=\mathbb ZG\otimes_{\mathbb ZP}
C_*(\widetilde B)\) as left modules, since the quotient identifies exactly
the \(K\)-translates of lifted cells. Tensor associativity gives the
claimed coefficient identification. The right side is \(H_*(X;N)\).
No exactness assumption about \(N\otimes_R-\), and in particular no
flatness or finite generation of \(N\), has entered the argument.

The case \(r=0\) is included: all new summands are zero and \(X=B\).
For our two generators the cell counts are
\((c_0,c_1,c_2,c_3)=(1,5,6,2)\), so \(\chi(X)=0=\chi(B)\).

## 7. Assembly of the manuscript's main theorem

Apply Section 6 using the perfect \(K\) from Section 4.
Apply (6.5) with \(N=\mathbb C_\rho\). Section 5 gives
\[
H_2(X;\mathbb C_\rho)=H_2(B;\mathbb C_\rho)=0.
\]
This proves `lem:twisted-vanishing`, not merely the analogous statement
for \(B\).

In \(G\), \(x_1^2=1\). Its character value is \(-1\ne1\), so \(x_1\)
is nonidentity and has order **exactly** two. Sending \(s\) to \(1\in\mathbb Z\)
and each other generator to zero respects the exponent sums of the four
relators and of \(t_1,t_2\). It is onto, proving \(G\) infinite.

If \(X\) were homotopy equivalent to a finite CW complex \(Y\) of dimension
at most two, \(Y\) would be connected. Transfer the character across the
induced fundamental-group isomorphism. Homotopy invariance gives
\(H_2(Y;\mathbb C_\rho)=0\), but the transferred character still takes value
\(-1\) on an element of order two. Section 3.4 forbids this. Equivalently,
the corresponding loop extends to \(\mathbb RP^2\to Y\); its pullback has
monodromy \(-1\) while \(b_1(\mathbb RP^2;\mathbb Q)=0\), contrary to
Section 3.3. This proves the verification theorem.

For completeness, the introduction's distinction between "all modules" and
"all finitely generated modules" causes no problem here. The constructed
splitting proves the stronger assertion directly. More generally, for a
finite CW complex a three-cocycle has finitely many values on the finitely
many three-cell basis vectors. They generate a finitely generated submodule
\(M_0\) of its coefficient module \(M\). The cochain is already an
\(M_0\)-valued cocycle, since the inclusion \(M_0\hookrightarrow M\) is
injective. If \(H^3(X;M_0)=0\), an \(M_0\)-valued primitive is also an
\(M\)-valued primitive. Thus vanishing for all finitely generated modules
implies vanishing for all modules in this finite situation, without a
Noetherian hypothesis.

## 8. Adversarial checks and indispensable hypotheses

The following are boundary diagnoses, not refutations of the stated claims.

* **Finite covers cannot replace infinite cyclic covers.** For
  \(\mathbb RP^2\) with trivial complex coefficients, \(H_2=0\), whereas
  its two-sheeted cover \(S^2\) has \(H_2=\mathbb C\). Upstairs
  \(d_2=1+t\) over \(\mathbb C[t]/(t^2-1)\) and
  \((1+t)(1-t)=0\). At \(t=1\), \(d_2=2\) is injective.
  The Laurent-domain argument is exactly what rules this out for the
  covers actually used.
* **Ordinary finite support matters.** For the presentation complex
  \(\langle x,a\mid xax^{-1}a^{-2}\rangle\), take the cover induced by
  \(x\mapsto1,\ a\mapsto0\) and trivial coefficients. Its second
  boundary is \((0,z-2)^{\mathsf T}\), and specialization is
  \((0,-1)^{\mathsf T}\). Over Laurent polynomials both are injective.
  In a product of coefficient fibers, however, the two-chain with
  coefficient \(2^{-n}\) on the \(n\)-th translated two-cell is nonzero
  and satisfies \(c_{n-1}-2c_n=0\). It is not an ordinary chain.
  No such completion is used in Sections 2 or 3.
* **Dimension two matters.** The inclusion \(S^2\subset D^3\) kills its
  second homology. Thus the subcomplex injection cannot be applied to
  \(X\) itself, which has three-cells. The proof applies it only to a
  putative two-dimensional \(Y\) and its towers.
* **The particular character matters.** The exact computation also checks
  all 18 characters with \(\rho(a_1)=\zeta^j\), \(j=0,1,2\),
  \(\rho(a_2)=\epsilon=\pm1\), \(\rho(s)=1,-1,2\),
  \(\rho(x_1)=\epsilon\), \(\rho(x_2)=\zeta^{2j}\).
  Every relator and chain identity holds. The boundary ranks, independent
  of these three choices of \(\rho(s)\), are \(3,4,4,3,4,3\) for
  \((j,\epsilon)=(0,-1),(0,1),(1,-1),(1,1),(2,-1),(2,1)\).
  Thus nearby characters need not give the requisite vanishing.
  This is a finite experiment, not evidence for the universal topology.

The zero-column case in the Laurent-rank proof, the order-one torsion case,
constant attaching loops, collapsed simplicial edges, and \(r=0\) in the
plus construction have all been addressed explicitly above.

## 9. Executable evidence and what it does not prove

Run, from the campaign root:

```bash
python3 research/wall_d2_audit/verify.py research/wall_d2_audit/exact_certificate.json
python3 research/wall_d2_audit/verify.py --self-test
```

The script uses only the Python standard library and exact rational
arithmetic. It starts from the fixed signed relator words, not from a
claimed successful matrix. It reconstructs the character evaluations,
Fox matrix, first-boundary composition, all maximal minors, a rational
block determinant, six free-group identities, coprime-annihilator
arithmetic, exponent sums, and the 18-case character experiment. The
certificate contains mathematical values and words, not Boolean
assertions of universal topology. Equality checks include JSON types
and shapes, so a Boolean cannot silently substitute for an integer.

Both commands passed. The self-test rejected 13 deliberately corrupted
witnesses, including a relator exponent, Fox sign, minor, relator-conjugate
sign, Bezout coefficient, missing/extra fields, truncated matrix, and
Boolean-for-integer substitution. It also checked 48 nonzero field
inverses. The primary numerical conclusion is the exact minor
\(-8-4\zeta\) with norm 48. A separate on-disk corruption of a Fox sign
was passed to the required verifier CLI; it returned exit status 1 and
identified the altered matrix entry. Its temporary fixture was removed.

Jacobian was used only through the specified isolated Argus adapter.
The discovered compatible operation was
`matrix.symbolic.determinant.compute`; its exact typed contract was inspected
before custom computation. One bounded run evaluated the polynomial lift
of the same four-by-four minor. It returned \(4z^2-4\), which reduces to
\(-8-4\zeta\) at \(z=\zeta\). Its method was `SYMPY_BAREISS`, server version
`0.14.0`, protocol `2025-11-25`, transport `mcp-stdio`, process exit status
0, and no timeout or stderr. The exact contract, request, typed output,
and adapter status are retained respectively in
`jacobian_contract.json`, `jacobian_payload.json`, `jacobian_result.json`,
and `jacobian_status.json`. The request echoed by the adapter was checked
against the saved payload. No unrelated number-field operation was forced
onto the claim, and no UNKNOWN or timeout was treated as mathematical evidence.

The executable certificate does **not** check the topology, construct explicit
three-cell attaching sphere maps, prove the abstract module argument, or
establish novelty. Those first three mathematical issues are handled by the
proofs above, including the Hurewicz existence construction; the last is not
an output of this script. The separate integral and universal Lean
certificates are described in Sections 11 and 14; their scope must not be
attributed to the Python replay.

## 10. Manuscript-to-proof correspondence and review boundary

| Manuscript result | Independent argument | Exact or formal evidence |
|---|---|---|
| `lem:cyclic-cover` | Section 2, including finite support and canonical specialization | Not replaced by a finite test |
| `thm:tower` | Section 3.1-3.3, maximal image and strict count | Not replaced by a finite test |
| `cor:torsion` | Section 3.4, all Moore complexes; Section 14, actual presentation quotients | `C-TORSION-FOX-CERT` v4 proves the universal algebraic implication |
| `prop:plus` | Section 6, explicit retraction for arbitrary modules | No stored universal assertions |
| `lem:perfect` | Section 4, noncommuting actions kept in order | Six free-group relator products and Bezout identity |
| `lem:twisted-vanishing` | Sections 5-7, applying homology preservation to \(X\) | Word-level Fox matrix and minor |
| `thm:main` | Section 7, torsion contradiction | Character, normal-generator values, map to \(\mathbb Z\) |

`research/PROOF_GRAPH.json` decomposes the claims and their indispensable
inferences. The ledger distinguishes compiler evidence, mathematical
judgments, and source attributions. Earlier independent mathematical and
citation reviews are reused; the current canonical citation-status query
reports no blocking attributions. Historical submission-time citation
restrictions in [citations.md](citations.md) are not current blockers.
The finite-only route remains retired because finite computations cannot
prove the universal assertions.

**Certification boundary:** the accepted correctness and fidelity reviews
cover the results they explicitly name, not the new scholarly assessment.
The integral algebra is kernel-checked, the universal torsion implication
is now kernel-checked, and their cellular interpretation and topological
assembly are reviewed prose. There is no Lean theorem here asserting the
existence or homotopy type of the entire CW counterexample. Section 15
submits originality of the verification construction and publication-level
significance separately; neither follows from a structural check.

## 11. Integrated integral verification theorem

The Host mathematical reviews, including
`roles/reviewer/progress.json#integral_plus_review`, support the construction
and its explicit integral refinement. The required source attributions
are confirmed. The unchanged native certificate for
`C-INTEGRAL-PLUS-CERT`, version 2, records Lean 4.31.0 compiler exit 0,
axiom-audit exit 0, and no proof holes. These facts do not constitute a
publication-level verdict. The later `integral_contribution_review`
resolved the two component-artifact bindings discussed in Section 13,
without upgrading the integral-only publication assessment.

### 11.1 Statement in the original cellular coordinates

**Integral verification theorem.** Retain exactly \(B,P,G,t_1,t_2\) and the
four relator words \(r_1,\ldots,r_4\) of Section 1. Put \(R=\mathbb Z[G]\).
Use free left \(R\)-modules, with coefficients multiplying the boundary rows
on the left. Let
\[
d_B:R^4\longrightarrow R^5,\qquad
d_B(e_j)=\operatorname{Fox}(r_j),\qquad
b_i=\operatorname{Fox}(t_i)\in R^5.
\]
Here Fox coefficients are evaluated in the six-relator group \(G\), not at
a character or a finite quotient. There are specified finite chains
\(F_1,F_2\in R^4\), given below, for which
\[
d_BF_1=b_1,\qquad d_BF_2=b_2.                         \tag{11.1}
\]
Define the left-linear maps
\[
\begin{split}
F(w_1,w_2)&=w_1F_1+w_2F_2,\\
D_2(v,w)&=d_Bv+w_1b_1+w_2b_2,\\
D_3(w)&=(-F(w),w),\qquad q(v,w)=w,\\
i(v)&=(v,0),\qquad r_2(v,w)=v+F(w).
\end{split}                                                     \tag{11.2}
\]
They satisfy
\[
\begin{gathered}
D_2D_3=0,\quad qD_3=1,\quad r_2i=1,\quad r_2D_3=0,\\
d_Br_2=D_2,\qquad z-i(r_2z)=D_3(qz).
\end{gathered}                                                   \tag{11.3}
\]
Thus the top-degree complex is explicitly the direct sum of the old
complex and \(0\to R^2\xrightarrow{1}R^2\to0\) in degrees three and two.
With identity maps in the unchanged lower degrees, zero retraction in
degree three, and \(h_2=q\), \(h_j=0\) otherwise, these are precisely
\(ri=1\) and \(1-ir=dh+hd\).

For every left \(R\)-module \(M\), every linear map
\(\varphi:R^2\to M\) extends across \(D_3\) as \(\varphi q\).
For every right \(R\)-module \(N\), tensoring the displayed homotopy
preserves the contraction. Neither assertion requires finite generation,
flatness, torsion-freeness, a field, or commutativity of \(R\).
The cochain extension is part of the formal algebra; the interpretation
as cellular (co)homology and the tensor-homotopy argument are the reviewed
prose consequences described in Section 11.3.

### 11.2 Source-derived chains and proof

The chains are fixed by the relator factorizations of Section 4, not by
choosing a preimage under an unspecified surjection. If a retained witness
is the free-word identity
\[
\omega=\prod_\ell h_\ell r_{j_\ell}^{\epsilon_\ell}h_\ell^{-1},
\qquad \epsilon_\ell\in\{1,-1\},
\]
its old-cell chain is
\(\sum_\ell\epsilon_\ell\overline h_\ell e_{j_\ell}\in R^4\).
The Fox product and inverse rules give its boundary as
\(\operatorname{Fox}(\omega)\), because all \(r_j\) are trivial in \(G\).
Use the four retained factorizations with targets
\[
\begin{array}{c|c}
\text{chain}&\text{target word}\\ \hline
U_1&[t_1,a_1]a_1^{-15}\\
U_2&[t_2,a_2]a_2^{-26}\\
P_1&t_1a_2^{-26}\\
P_2&st_2s^{-1}a_1^{-15}.
\end{array}
\]
The two remaining witnesses give
\(E_1=P_1-U_2\) and \(E_2=P_2-U_1\).
These definitions refer to the actual finite products, not just their
equality classes; their literal lists and differentiation are retained in
`../integral_plus_certificate/exact_certificate.json` and `Main.lean`
in that directory.

Write \(N_m(a)=1+a+\cdots+a^{m-1}\), and distinguish the edge basis
vectors \(e_{a_1},e_{a_2}\in R^5\) from the old two-cell basis above.
The quotient relations give \(a_1^{15}=a_2^{26}=1\). Differentiating the
four target words and the two difference witnesses gives
\[
\begin{aligned}
d_BU_1&=(1-a_1)b_1-N_{15}(a_1)e_{a_1},&
d_BU_2&=(1-a_2)b_2-N_{26}(a_2)e_{a_2},\\
d_BP_1&=b_1-N_{26}(a_2)e_{a_2},&
d_BP_2&=s b_2-N_{15}(a_1)e_{a_1},\\
d_BE_1&=b_1-(1-a_2)b_2,&
d_BE_2&=s b_2-(1-a_1)b_1 .
\end{aligned}                                                    \tag{11.4}
\]
The required chains, with every noncommutative factor in its indicated
order, are
\[
\begin{aligned}
F_{26}&=26P_1-N_{26}(a_2)U_2,\\
F_{15,2}&=s^{-1}\bigl(15P_2-N_{15}(a_1)U_1\bigr),\\
F_{15,1}&=15E_1+(1-a_2)F_{15,2},\\
F_1&=7F_{15,1}-4F_{26},\\
F_2&=s^{-1}\bigl(E_2+(1-a_1)F_1\bigr).
\end{aligned}                                                    \tag{11.5}
\]
If \(a^m=1\), then
\(N_m(a)(1-a)=0\) and \(N_m(a)^2=mN_m(a)\).
Consequently (11.4) gives
\[
d_BF_{26}=26b_1,\qquad d_BF_{15,2}=15b_2,\qquad
d_BF_{15,1}=15b_1.
\]
The identity \(7\cdot15-4\cdot26=1\) proves the first equality in
(11.1); the last line of (11.4) proves the second. Only integer scalars
and powers of the same group element were commuted. In particular,
neither \(s^{-1}\) nor \(1-a_2\) has been moved through an unrelated
coefficient. No denominator was introduced.

Substitution of (11.1) into (11.2) proves (11.3). Equivalently, the
invertible change of coordinates
\[
T(v,w)=(v+F(w),w),\qquad T^{-1}(v,w)=(v-F(w),w)
\]
sends \(D_3(w)\) to \((0,w)\) and changes \(D_2\) to \(d_B\) on
the first summand. This identifies the previously unspecified map \(A\)
in Section 6 as the concrete map \(-F\).

The kernel-checked declarations in
`research/integral_plus_certificate/Main.lean` track these steps as follows.
The names describe the instantiated presentation, not an abstract
assumption that a suitable filling already exists.

| Algebraic assertion | Named Lean declarations |
|---|---|
| Literal relator witnesses and their chains | `word_U1`, `word_U2`, `word_P1`, `word_P2`, `word_E1`, `word_E2`, `dB_witness`, `chain_E1`, `chain_E2` |
| Quotient orders and the six boundary equations | `A_order`, `B_order`, `dB_U1`, `dB_U2`, `dB_P1`, `dB_P2`, `dB_E1`, `dB_E2` |
| The five chains (11.5) and the instantiated filling | `dB_F26`, `dB_F15_2`, `dB_F15_1`, `dB_F1`, `dB_F2`, `fill_boundary` |
| Split boundary, retraction, and contraction | `D2_D3`, `q_D3`, `retract_include`, `retract_D3`, `boundary_retract`, `homotopy_degree_two`, `homotopy_degree_three` |
| Direct-sum coordinates and arbitrary-left-module extension | `splitCoordinates`, `split_D3`, `split_boundary`, `cochain_extension` |
| Collected instantiated identities | `instantiated_integral_plus` |

### 11.3 Topological consequence and exact certification boundary

Attach the two original two-cells to obtain \(B'\), with
\(\pi_1(B')=G\). Under the standard cellular identification, the two
vectors
\[
(-F_1,(1,0)),\qquad (-F_2,(0,1))
\]
are actual integral two-cycles in \(\widetilde{B'}\).
This universal cover is simply connected. Degree-two Hurewicz therefore
represents the cycles by sphere maps, and their projections can be used
to attach the two three-cells. The cells may be oriented and lifted
so that their boundary is exactly (11.2). This chooses specific
homology classes for a finite-plus realization; it does not supply
combinatorial attaching sphere maps or identify arbitrary pre-existing
choices of those maps.

The resulting \(X\) has cell counts \((1,5,6,2)\), fundamental group
\(G\), and the same conclusions as the verification theorem of Section 1.
In particular \(qD_3=1\) gives both higher universal-cover homology
vanishing and \(H^3(X;M)=0\) for every left \(R\)-module \(M\).
The tensor contraction preserves the twisted homology used in Sections
5-7, so the already reviewed torsion/tower argument still rules out a
finite two-dimensional homotopy model. This is the manuscript's
conclusion, now with specified integral boundary chains, not a new
counterexample or a stronger topological obstruction.

There are three different levels of evidence here. The native Lean
certificate proves the presented-group and integral group-ring
identities and the displayed linear maps. The independent
`integral_plus_review` supports their source interpretation and the
prose realization argument, and records the accepted exact replay.
The covering-space, cellular-homology, and Hurewicz identifications
remain the externally sourced foundations in `C-FOUNDATIONS`, also
used by `C-PLUS-ATTACH` and `C-INTEGRAL-REALIZATION`. They have not
become Lean theorems about CW complexes merely because the algebra
compiles. The source proves degreewise equations rather than packaging
the entire topological argument as a Mathlib chain-complex theorem.

The existing exact replay checks universal integral ideal-membership
identities, not a bounded list of representations; the independently
accepted replay and thirty corruption rejections are reused here.
No new compilation, replay, Jacobian calculation, source edit, fidelity
edit, or certificate copy is needed for this integration. The sole
parent compiler certificate remains
`research/integral_plus_certificate/certificates/C-INTEGRAL-PLUS-CERT-c09c9366c2325e62.json`.

## 12. Contribution relative to the primary predecessors

This section assesses the **fixed-construction integral certificate**.
Its inconclusive publication verdict is retained; the distinct universal
verification contribution is assessed in Section 15.

### 12.1 What the sources already provide

The closest comparison is not merely with an existential theorem.
Mannan's published Section 2 already explains an explicit cellular
construction once commutator expressions for the chosen normal
generators are supplied. It uses those commutator words as the new
two-cell attaching words, so their Fox boundaries vanish over the
quotient group ring. Lemma 2.2 writes the boundary as
\(\partial_2\oplus0\). On the next page, the three-boundary is the
inclusion of the new summand; Lemma 2.4 explicitly gives a chain
homotopy equivalence. This is a genuine constructive predecessor,
not just an abstract homology-vanishing statement. It does not assert
a uniform algorithm for discovering commutator expressions in an
arbitrarily presented perfect group.

| Primary source and locator | Prior mathematical content | Precise difference in this certificate |
|---|---|---|
| OpenAI, October 6, 2026, `sections/03-plus.tex`, `prop:plus`, equations `eq:relative-surjection` and `eq:split-boundary` | Chooses lifts of relative two-cell basis classes, realizes them by Hurewicz, and proves splitting and all-module preservation. | Equations (11.4)-(11.5) specify the lifts in the original six-relator cellular basis rather than leaving the old-cell correction \(A\) unspecified. The cohomological and coefficient quantifiers are unchanged. |
| The same manuscript, `sections/04-construction.tex`, `lem:perfect` and `eq:module-relations` | Uses the same norm annihilators 15 and 26 and coprimality to prove perfectness. | The same mechanism is lifted to explicit old-cell filling chains and checked in the full noncommutative integral group ring. Coprimality and the perfect-kernel argument are not new methods. |
| Mannan, DOI `10.2140/agt.2009.9.1399`, Section 2, Lemma 2.2 and its following construction, Lemmas 2.3-2.4, pp. 1401-1402 | A finite presentation and a perfect finitely normally generated kernel give a finite construction with zero added two-boundary, split three-boundary, all-module homology preservation, and a chain homotopy equivalence. | This certificate retains the manuscript's literal words \(x_1^2,x_2^3\), whose Fox rows need not vanish, and computes the compensating \(F_1,F_2\). The shear \(T\) then recovers the familiar split form. There is no new general finite-plus or nonflat-coefficient theorem. |
| Bridson-Tweedale, `arxiv:math/0607671v2`, Proposition 3.3 and Section 4, pp. 4, 6 | Coprime annihilators reduce relation-module generators. Section 4 traces a module splitting to three-cell attachments, explicitly noting that the attaching maps can be described by following the algebra. Its nonrealizability conclusion remains conditional on its relation-gap hypothesis. | The present fixed-word chain certificate is for the manuscript's different presentation. It neither supplies those authors' missing gap hypothesis nor makes algebra-to-attaching-map constructions new. |
| Bartholdi-Bridson-Mikhailov-Nicholson, `arxiv:2610.23637v1`, Theorem A and conditional Corollary B | Theorem A supplies finite relation gaps independently; Corollary B explicitly relies on the OpenAI torsion obstruction for its D(2)/deficiency conclusion. | Neither the retained G5/G6 application nor the integral certificate alone supplies first finite-gap existence or a kernel proof of that torsion obstruction. The new universal certificate, not this integral computation, supplies the latter algebraic proof in Section 14. The G5/G6 publication route remains retired. |

The Mannan comparison was made against the retained published text
`literature/mannan2009.txt`, not a search summary.
The precise additional passage for the cellular splitting is preserved
in `../literature/integral-verification-predecessors/mannan-cellular-splitting-excerpt.txt`.
The existing Mannan finite-plus, Bridson-Tweedale, and BBMN canonical
attributions remain unchanged. The more specific Mannan cellular-splitting
proposition was separately attributed in `integral_contribution_review`,
rather than silently extending the scope of earlier confirmations.
The staged manuscript and the retained versioned predecessor passages
are the comparison evidence; absence of a matching formula in a search
is not evidence of priority.

### 12.2 The supported increment and the unresolved publication question

Compared with the strongest accepted earlier report, Section 6 already
proved the arbitrary-module splitting, and `integral_plus_review`
already accepted the explicit chains and their formal interpretation.
This integration advances no mathematical proposition beyond that
accepted integral theorem. It brings the actual formulas and their
scope into the main report and supplies the sharper predecessor
comparison needed to judge their value.

The substantive increment of the **integral construction over the
original manuscript**, not of this editorial integration over its
accepted certificate, is the following: the old-cell correction for
each original attaching word is furnished as a finite integral witness,
and the resulting maps are checked in the presented group ring before
any coefficient specialization. The single algebraic identity therefore
controls all coefficient specializations through the explicit homotopy.
This replaces a choice of lifts by inspectable data and separates the
universal algebra from the remaining topological assumptions. It is an
exact verification theorem with independently reviewed source fidelity,
not a finite experiment and not a fully formalized proof of Wall's
topological counterexample.

**Integral-only assessment: publication-level added value remains
unestablished.**
The evidence supports that narrowly described verification contribution;
it does not establish a new finite-plus mechanism, a stronger D(2)
theorem, explicit sphere maps, a new relation-gap result, or a formally
proved tower obstruction within the integral source. Mannan already supplies the general split
construction, and the manuscript already supplies the norm argument
and the all-module conclusion. No comparative result here shows a
new reusable construction, a strengthened theorem, or why the remaining
formalized algebra alone meets the field's publication threshold.
An independent Reviewer may assess an original formal-verification
contribution on its merits, but must give an affirmative significance
and originality argument against these actual predecessors; compiler
success and nonappearance of the literal formulas are insufficient.

`C-INTEGRAL-CONTRIBUTION` records that precise unresolved publication
assertion separately from the supported mathematical claims. An
inconclusive assessment is not a refutation of those claims, nor a
proof that no publishable contribution could exist. If the Host cannot
support this added value, the remaining deficit is substantive, not
another need to rewrite the theorem, recompile it, or expand the
comparison prose. Any next mathematical route belongs to Planner;
this submission does not revive a retired route or declare campaign
completion.

## 13. Integral component evidence provenance

The Host's completed `integral_contribution_review` corrected the two
component-judgment artifact bindings to the already reviewed proof,
preserving their historical provenance. Those corrections are not
reopened here. The mathematical mapping remains:

| Component and existing Reviewer evidence record | Already reviewed derivation | Named formal content inside the parent source |
|---|---|---|
| `C-INTEGRAL-FILL` v1; `judgement-C-INTEGRAL-FILL-676d6c1d6e22` | `research/integral_plus_certificate/proof.md`, the integral Bezout filling; equations (11.4)-(11.5) above | `dB_F26`, `dB_F15_2`, `dB_F15_1`, `dB_F1`, `dB_F2`, `fill_boundary` |
| `C-INTEGRAL-RETRACT` v1; `judgement-C-INTEGRAL-RETRACT-1fd714876826` | The same reviewed `proof.md`, the explicit retraction and contraction; equations (11.2)-(11.3) above | `D2_D3`, `q_D3`, `retract_include`, `retract_D3`, `boundary_retract`, `homotopy_degree_two`, `homotopy_degree_three`, `splitCoordinates`, `split_D3`, `split_boundary` |

These are supported component judgments citing
`research/integral_plus_certificate/proof.md`, not separate component
compiler certificates. The parent mechanical record remains bound to
`C-INTEGRAL-PLUS-CERT` v2. Correcting an artifact reference neither
adds a theorem nor establishes publication significance. The accepted
source, fidelity note, certificate, executable witnesses, and reproduction
instructions have not changed in the present contribution assessment.

## 14. Universal verification by finite word images

### 14.1 Exact theorem and its interpretation

**Universal verification theorem (the manuscript's torsion corollary,
in presentation form).** For arbitrary \(n,m\geq0\), let
\[
 F_n=F(x_1,\ldots,x_n),\qquad
 r=(r_1,\ldots,r_m),\qquad
 G=F_n/\langle\!\langle r_1,\ldots,r_m\rangle\!\rangle,
\]
and let \(\pi:F_n\to G\) be the actual quotient map. For any character
\(\rho:G\to\mathbb C^\times\), put \(\kappa=\rho\pi\) and define
\[
 d(x_i)=e_i,\qquad d(uv)=d(u)+\kappa(u)d(v),\qquad
 D_\rho(c)=\sum_{j=1}^m c_jd(r_j).
\]
Then
\[
 D_\rho\text{ injective},\quad g\in G,\quad q>0,\quad g^q=1
 \quad\Longrightarrow\quad \rho(g)=1.                 \tag{14.1}
\]
Here \(q\) is any positive killing exponent, not necessarily the order.
The character need not have finite image. Repeated and identity relators
and the zero-generator and zero-relator cases are included. There is
no asphericity or residual-finiteness assumption.

The certified declaration is
`FoxTower.universal_torsion_statement :
TorsionFox.UniversalTorsionStatement`. Its boundary columns are constructed
from the given words, and its group is `PresentedGroup (Set.range r)`.
The final theorem obtains a representative of \(g\) and its
normal-closure witness; neither is an extra final hypothesis.

For the finite presentation complex, the positive-prefix and
negative-inverse-prefix rules identify \(D_\rho\) with the second
cellular boundary under the conventions of Section 2. Thus
\(H_2(Y_r;\mathbb C_\rho)=\ker D_\rho\). Conversely, collapse a maximal
tree in any finite connected two-complex to obtain this presentation
form, transporting the character and local homology. These are the
reviewed cellular identifications in
`../torsion_fox_certificate/proof.md`, Section 1. They are not Lean
declarations about CW complexes. With these identifications, (14.1)
is exactly the manuscript's `cor:torsion`, not a restricted
fixed-presentation test or a stronger topological conclusion.

### 14.2 The source-derived construction

Suppose, for contradiction, that \(\rho(g)\ne1\). Choose \(w\in F_n\)
representing \(g\). Normal-closure membership yields a finite identity
\[
 w^q=\prod_{\ell=1}^{k}
        u_\ell r_{j_\ell}^{\epsilon_\ell}u_\ell^{-1},
 \qquad \epsilon_\ell\in\{1,-1\}.                    \tag{14.2}
\]
The formal proof establishes this membership description rather than
postulating a certificate. No algorithm for finding such identities
uniformly in arbitrary presentations is claimed.

For a right action of \(F_n\) on a vertex set and a chosen root, follow
the fixed paths \(w\), all the stems \(u_\ell\), and each positive
relator \(r_{j_\ell}\) at its stem endpoint. Use positively oriented
generator edges, including the correct edge for every inverse traversal.
The image vertices, edges, and faces form finite sets \(S,E,T\).
A face retains its original relator index and its starting vertex;
repeated occurrences of the same pair are one image face. The bound
\[
 |S|\le B,\qquad
 B=1+2\left(|w|+\sum_\ell(|u_\ell|+|r_{j_\ell}|)\right)             \tag{14.3}
\]
depends on the fixed words, not the action or the number of lifts.
It is a termination bound for this proof, not a complexity bound for
deciding torsion or the word problem.

The actual word-integral constraint and gradient maps are
\[
 C_\kappa:\mathbb C^E\to\mathbb C^T,\quad
 (C_\kappa c)_{(s,j)}=I_\kappa(c,r_j,s),\qquad
 (\delta_\kappa b)(s,i)=\kappa(x_i)b(s\cdot x_i)-b(s).
\]
The integrals are generator-derived and obey the product and inverse
rules. Cochains are extended by zero off the actual source edges.
When the source loop and selected relators close,
nontrivial \(\kappa(w)\) makes \(\delta_\kappa\) injective, while
\(C_\kappa\delta_\kappa=0\). If \(C_\kappa\) is surjective, rank-nullity
therefore gives
\[
 |T|+|S|\le |E|.                                      \tag{14.4}
\]
With rational untwisted coefficients the constant vertex function lies
in the gradient kernel. Consequently the rational constraint kernel
strictly contains the gradient image. Choose a rational generator
voltage \(a\) which vanishes around the selected relators and is not
a vertex gradient.

The new action is constructed, on vertices with rational heights, by
\[
 (s,h)\cdot u=(s\cdot u,h+\nu_a(u,s)).
\]
The voltage product rule proves the action law. Every signed conjugate
in (14.2) fixes the lifted root. Since \(w\) closes downstairs,
the height change of \(w^q\) is \(q\nu_a(w,s)\); \(q>0\) in
\(\mathbb Q\) forces \(\nu_a(w,s)=0\). Thus the torsion loop itself
lifts closed. Equal old and new vertex counts would give a unique
height at each old vertex, whose differences along actual source
edges express \(a\) as a gradient. Therefore the vertex count strictly
increases.

### 14.3 The reusable transfer interface

The difficult formal interface is preserving the actual constraint map,
not just proving a theorem about an arbitrary matrix supplied as input.
The certified `source_constraints_lift_surjective` applies to any right
free-group action, root, finite source words and relator-indexed factors,
any character \(\kappa:F_n\to\mathbb C^\times\), and any rational
generator voltage. Surjectivity of the old source constraint map implies
surjectivity of the lifted one. Loop closure and unit relator values
are needed elsewhere in the tower argument, not as additional inputs
to this transfer declaration.

Here is its mechanism. Set \(R=\mathbb C[\mathbb Q]\), the domain of
finite sums of rational-exponent monomials. The weights
\(\kappa(u)t^{\nu_a(u,s)}\) define the actual matrix \(C_t\) over \(R\).
Augmentation \(\varepsilon(t^h)=1\) recovers \(C_\kappa\), retaining
the character, and the constant embedding is denoted by \(\iota\).
A left inverse to \(C_\kappa^{\mathsf T}\), lifted by \(\iota\),
gives a square product with \(C_t^{\mathsf T}\) whose determinant
specializes to one. The determinant and adjugate argument over the
domain \(R\) proves \(C_t^{\mathsf T}\) injective.

Let \(C'\) be the actual lifted constraint matrix. For a lifted face
\(f\) with projection \(p_Ff\) and starting height \(h_f\), put
\[
 J_{f_0,f}=\mathbf1_{f_0=p_Ff}t^{h_f}.
\]
Define the edge placement matrix \(U\) similarly, with rows indexed
by lifted edges and columns by old edges. Following the actual words
proves
\[
 C_t^{\mathsf T}J=U^{\mathsf T}(\iota C')^{\mathsf T}.              \tag{14.5}
\]
For \(x\in\mathbb C^{T'}\) in the kernel of \((C')^{\mathsf T}\),
(14.5) gives \(J\iota(x)=0\). Projection and starting height uniquely
determine a lifted face. Extracting the coefficient of \(t^{h_f}\)
in coordinate \(p_Ff\) therefore gives \(x_f=0\). This proves the
needed surjectivity of \(C'\).

Crucially, this does **not** assert injectivity of \(J\) on arbitrary
\(R\)-coefficient vectors: different height columns in one coordinate
can have \(R\)-linear dependencies. The assertion used is coefficient
separation for embedded complex vectors. Likewise, the finite-support
domain is not replaced by a product of coefficient fibers. These
distinctions are part of the proved interface, not informal assurances.

Finally the one-vertex word integral is proved to evaluate a linear
functional on the original \(d(u)\). A left inverse of the actual
\(D_\rho\) supplies initial surjectivity, with a locality argument
justifying restriction to the actual source edges. All successive
lifted states can now be constructed. Their vertex counts increase
strictly but satisfy (14.3), a contradiction. This proves (14.1).

The rational-voltage representation implements the classical cyclic
idea without a common-denominator normalization or a formal
covering-space library. Only finitely many voltage values occur at
each step, so their subgroup in \(\mathbb Q\) is cyclic; the proof
does not need to choose its generator. Neither rational heights nor
specialization is claimed as a new mathematical technique.

### 14.4 Evidence and reproduction boundary

| Obligation | Accepted formal declaration or construction |
|---|---|
| Actual quotient and relator derivative | `TorsionFox.GroupOf`, `fox`, `boundary_basis`, `torsion_has_certificate` |
| Fixed finite source and uniform bound | `sourcePaths`, `edgeSet`, `faceSet`, `vertexSet_bound` |
| Existence of a usable voltage and actual torsion lifting | `source_voltage_exists`, `RightAction.torsion_lifts` |
| Source-derived transfer, including coefficient separation | `specialization_injective`, `lifted_constraint_column`, `projectFace_height_injective`, `source_constraints_lift_surjective` |
| Strict growth, initialization, and contradiction | `voltage_strict_growth`, `initial_constraints_surjective`, `finite_source_tower_contradiction` |
| Unconditional universal conclusion | `FoxTower.universal_torsion_statement` |

These are parts of one source, not six independently certified files.
The native certificate
`../torsion_fox_certificate/certificates/C-TORSION-FOX-CERT-84bd8af494165de0.json`
is bound to `C-TORSION-FOX-CERT` version 4, with compiler exit 0,
axiom-audit exit 0, and `proof_holes=[]`. The actual source, statement
reading, and cellular interpretation were examined in
`torsion_fox_review_round_2`, which also records an independent fresh
Lean 4.31.0 compilation. That completed review is reused, not requested
again to support the contribution argument.

From the campaign root, the unchanged native reproduction command is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify --project-root . \
  --claim C-TORSION-FOX-CERT research/torsion_fox_certificate/Main.lean \
  --statement-fidelity research/torsion_fox_certificate/statement-fidelity.md
```

The separate fidelity document specifies the objects, quantifiers,
definitions, and residual prose topology. This report does not replace
that document or extend its compiler binding. The accepted integral
certificate, the exact witnesses and mutation checks, and the earlier
bounded Jacobian calculations are also unchanged. Those computations
are not evidence for originality or for a universal theorem beyond
their stated scope.

## 15. Original verification contribution and field-level significance

### 15.1 Comparison with the strongest inspected primary sources

The question is not whether the torsion theorem was already known: it
is the theorem of the manuscript being verified. The question is what
this independent verification supplies that the existing arguments and
earlier fixed-construction certificates did not.

| Primary source and exact locator | Content already supplied | Contribution claimed here, with its limit |
|---|---|---|
| Staged OpenAI manuscript, `02-tower.tex`, `lem:cyclic-cover`, `thm:tower`, `cor:torsion` | The twisted Laurent specialization, fixed-domain increasing-image argument, and full rank-one torsion conclusion. | A complete kernel-checked presentation-theoretic realization, including construction of the source and lifts, actual word-matrix transfer and coefficient extraction. No new torsion conclusion or credit for the manuscript's rank argument. |
| Howie, DOI `10.1515/crll.1981.324.165`, Lemmas 3.1-3.2, pp. 170-171 | Maximal tower lifting for the specified combinatorial maps; preservation of top-dimensional relative homology with constant abelian-group coefficients. | The word-graph implementation proves its own twisted transfer instead of importing the constant-coefficient lemma under changed hypotheses. The tower method is Howie's predecessor, not our invention. |
| Louder-Wilton, DOI `10.4153/CMB-2016-078-3`, Definition 3.1 p. 609 and Lemma 3.2 p. 610 | The cyclic-tower formulation and maximal lift for a cellular map of compact complexes. | Actual finite word images, voltage actions, and bounded growth replace an assumed maximal-tower interface inside the formal proof. The source does not supply the needed twisted transfer statement. |
| Howie-Schneebeli, DOI `10.1007/BF01166075`, definitions and Theorems 1-3, pp. 71-73 | Augmentation-detection classes for projective group-ring modules and their relation to local indicability, with the stated coefficient hypotheses. | This is an important predecessor for specialization logic, not a theorem about arbitrary twisted characters. We prove the actual specialized matrices and lifted-word identity; we do not claim augmentation detection itself as new. |
| BBMN, `arxiv:2610.23637v1`, Theorem A; qualification before Corollary B; Corollary B and its proof | Independent exact relation gaps in Theorem A. The D(2)/deficiency application in Corollary B explicitly takes OpenAI Corollary 2.3 as a premise. | The certificate independently establishes that premise's universal algebraic content. It does not re-prove Theorem A, formalize all of Corollary B, or claim a new relation-gap/deficiency mechanism. |

The Howie and Louder-Wilton passages are retained in
`literature/howie-excerpt.txt` and `literature/louder-wilton-excerpt.txt`.
The augmentation comparison uses
`../literature/finite-rank-predecessors/reviewer-howie-schneebeli1983-excerpt.txt`.
The exact BBMN qualification and proof passage are retained in
`../literature/relation-gap-predecessors/bartholdi-bridson-mikhailov-nicholson2026-review-excerpt.txt`.
These propositions are already independently attributed in
`C-KNOWN-TOWERS`, `C-FR-PRIMARY-COMPARISON`, and
`C-RG-BBMN-COMPARISON`; they are not newly assumed without source review.
Mannan's stronger-than-existential finite-plus construction remains
credited in Section 12 and is not a predecessor for the universal
torsion proof.

### 15.2 The precise original verification claim

The added verification object is the **complete composition**
\[
 \text{actual quotient relation}
 \longrightarrow \text{fixed word source}
 \longrightarrow \text{constructed rational lifts}
 \longrightarrow \text{actual twisted-matrix transfer}
 \longrightarrow \text{strict bounded growth}.                    \tag{15.1}
\]
Each arrow is a proved map or implication in the certified source.
In particular, the transfer declaration in Section 14.3 is reusable
for arbitrary word actions and voltages, not tied to the five-generator
counterexample. The proof does not obtain its universality by assuming
a tower, an injective placement map over the deck ring, or a growth law.

This is a representation-level proof development beyond the cited
prose arguments: the topology of image subcomplexes and covers is
replaced within the formal core by word actions, explicit source images,
and identities between their actual matrices. The delicate interface
is (14.5) together with complex-coefficient extraction, not a new
determinant identity. These mechanisms and the actual quotient
initialization are concrete inspectable outputs, not the observation
that the final theorem compiles. This is the scoped originality
assertion in `C-UNIVERSAL-VERIFICATION-ORIGINALITY`.

The comparison supports an original **verification implementation of
a credited theorem**, not mathematical priority for (14.1), the tower
method, voltage graphs, or specialization. It makes no global
first-formalization claim. A bounded additional search for formal Fox,
local-indicability, and cyclic-tower developments yielded no inspected
source changing this comparison; an inaccessible repository lead was
not counted either way. That nonfinding is not a premise of (15.1)
or evidence of priority.

Relative to the strongest prior campaign evidence, the distinction is
also substantive. The integral certificate settles a particular
construction, and the earlier universal Fox-calculus component stopped
at a relation coefficient \(c\) with \(D_\rho c=0\). Injectivity then
gives \(c=0\), not the required contradiction: an actual sixth-root
example in the accepted component has such cancellation. The completed
word-source construction proves the missing universal implication
without that shortcut. The example refutes an attempted Engineer
inference, not a claim in the manuscript. No retired integral-only,
induced-rank-two, or G5/G6 publication argument is being revived.

The present report integration adds no theorem beyond the already
accepted version-4 certificate. It identifies and argues for the value
of that newly completed theorem; it does not relabel editorial work
as further mathematical progress.

### 15.3 Why the universal dependency matters outside the fixed example

BBMN explicitly distinguish their unconditional Theorem A from
Corollary B, which relies on OpenAI Corollary 2.3. This is positive
primary-source evidence of an external use of the precise theorem
verified here, not a prediction that somebody might use the code.
The dependency can be matched without treating BBMN's entire paper
as an independently checked consequence of Lean.

For their coprime integers \(p,q\geq2\), write
\[
 H_{p,q}=\langle x,t\mid x^{pq},[x^p,tx^qt^{-1}]\rangle .
\]
The character \(x\mapsto\zeta,\ t\mapsto1\), where \(\zeta\) is a
primitive \(pq\)-th root, satisfies both relators and detects the
finite-order element \(x\). For **any** finite presentation of the
same group, transport this character and element through the group
isomorphism. The contrapositive of (14.1) says that its actual Fox
boundary is not injective. This is exactly the universal obstruction
which a computation for the displayed two-relator presentation alone
could not supply.

In the displayed presentation the source computes the only nonzero
boundary entries as
\[
 \partial_1=(\zeta-1,\ 0),\qquad
 (\partial_2)_{t,\,[x^p,tx^qt^{-1}]}
       =(\zeta^p-1)(1-\zeta^q)\ne0.
\]
The other entries of \(\partial_2\) are zero. Thus \(H_0=H_1=0\).
BBMN transfer this low-degree homology to every finite connected
two-complex \(Z\) with fundamental group \(H_{p,q}\). With the
reviewed cellular interpretation of (14.1), one then has
\[
 \chi(Z)=\dim_{\mathbb C}H_2(Z;\mathbb C_\rho)\geq1.
\]
Their finite D(2) construction has Euler characteristic zero. The
universal torsion premise is therefore load-bearing for the
nonrealizability conclusion and the deficiency bound, across their
whole parameter family and all alternative finite presentations.

This paragraph identifies the precise dependency being verified; it
does not claim these formulas, the Euler argument, or the family as
new. The present certificate independently discharges the algebraic
torsion premise, **not** the additional CW identification, low-degree
homology comparison, or BBMN construction inside Lean. There is no
new kernel certificate for BBMN's full Corollary B.

### 15.4 Contribution assessment and remaining boundary

**Engineer assessment: the universal package supports a substantive
original verification contribution suitable for a verification paper.**
The affirmative case has two separate grounds. First, the source
implements and verifies the nontrivial word/lift/boundary interfaces
in (15.1) with the theorem's full quantifiers, rather than leaving the
main geometric implication as an assumed interface. Second, the
primary BBMN passage identifies this same implication as an explicit
conditional input to further D(2) and deficiency conclusions. The
result supplies independent kernel evidence exactly at that
mathematically consequential dependency.

This is a different significance argument from certifying another
finite matrix or writing out a general splitting already supplied
by Mannan. It changes what has been independently checked about the
universal obstruction, not the theorem's truth conditions or the
authors' mathematical priority. The bounded originality claim and
the scholarly significance judgment are recorded separately as
`C-UNIVERSAL-VERIFICATION-ORIGINALITY` and
`C-UNIVERSAL-VERIFICATION-SIGNIFICANCE`, with their conjunction in
`C-UNIVERSAL-VERIFICATION-CONTRIBUTION`.

These are Engineer judgments, not compiler outputs or inherited
Reviewer approvals. The Host Reviewer must decide whether the
identified source-faithful formal construction and its demonstrated
dependency-level value meet the publication threshold, reusing the
completed correctness and fidelity review. No full CW-topology
formalization, higher-rank kernel theorem, global priority claim,
novel relation-gap result, or campaign-completion claim is made.
If the contribution is not accepted, the unresolved question is
the significance of this specific universal verification architecture;
another unchanged replay or comparison-only rewrite would not answer it.
