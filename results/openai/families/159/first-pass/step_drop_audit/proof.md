# Coefficient-uniform recovery from common logarithmic derivatives

## Result and scope

The reduction from `prelim:common-derivative` through `prelim:lattice` to
the final graded factorization is valid under its stated hypotheses.
In particular, an unbounded adjoint shear does not require bounded
coefficient numerators. The explicit estimate in Theorem 1 below
strengthens the quantitative statement of the lattice lemma and supplies
one denominator for both kinds of rational lift.

This is a proof of the reduction, not a proof of the whole step-drop
lemma, the quantitative Szemeredi theorem, or the reciprocal-sum
conjecture. Producing the common fast subgroup by biased normalized
squares and lower-degree induction remains a separate input. No claim
of literature novelty or publishable significance is made before
independent review. The previous strongest relevant statement is the
manuscript's qualitative `exp(poly(p))` lattice bound; the improvement
here is the explicit bound, joint denominator, and separate exact
certification of the algebraic passage.

The primary source is OpenAI, *Quasipolynomial Bounds for Arithmetic
Progressions*, September 23, 2026, staged at
`research/openai_manuscript/Quasipolynomial-Bounds-for-Arithmetic-Progressions-September-23-2026/build/`.
In `foundations/02-symbols.tex`, the relevant locations are:

| Location | Proposition used or audited |
|---|---|
| lines 34-42, 47-80, 245-257 | Actual side lengths; denominator is not height; no orbit coefficient bound |
| lines 273-290 | Rational separation |
| lines 666-684 | Step-drop statement |
| lines 696-848 | Lattice-extraction statement and proof |
| lines 885-953 | Associated-graded square and right logarithmic derivative |
| lines 974-1022 | Common diagonal, common relative class, and derivative equation |
| lines 1025-1054 | Coefficient lattice and coordinate derivative system |
| lines 1056-1203 | Target algebra and grade-by-grade removals |

These are source-only assumptions in `C_SOURCE_SCOPE`, not assumptions
that the manuscript's conclusions are true. The staged README supplies
no DOI or arXiv identifier. The ledger therefore explicitly reports
these local primary-source citations as `uncited`; their independent
attribution is a Reviewer task, not a fictitious registry lookup. The
proof below invokes no specialized external equidistribution or inverse
theorem. The source's named antecedents are not used as black boxes.

## Theorem 1: explicit extraction with arbitrary real shears

Let \(n,m\geq1\), \(0\leq a\leq m\), \(l\) be a positive integer,
\(R\geq1\), and \(0<\delta\leq1\). Put \(N=n+m\) and
\[
 C=\delta^{-1}((N+2)R)^N,\qquad B=C\,l^{m+1}.                 \tag{1}
\]
Let \(T_i>0\), \(T_*=\min_iT_i\), and \(D_T=\operatorname{diag}(T_i)\).
Let \(L=\operatorname{diag}(w_j)\), where \(w_j=1\) for \(j\leq a\)
and \(w_j\geq T_*\) for \(j>a\). Let \(M\) be any real lower
unitriangular matrix whose first \(a\)-by-\(a\) block is the identity,
and let \(Y:\mathbb R^n\to\mathbb R^m\) be any real linear map.
Neither matrix has an entry bound.

Suppose
\[
 \Lambda=\{(D_T^{-1}h,L(Yh-Mr)):
                 h\in\mathbb Z^n,\ r\in l^{-1}\mathbb Z^m\}
                                                               \tag{2}
\]
has at least \(\delta\prod_iT_i\) vectors of Euclidean norm at most
\(R\) with distinct \(h\)'s. If \(T_*>B\), there are:

* a rational subspace \(K\subseteq\mathbb R^a\) with a basis of
  rational height at most \(B\);
* linear maps \(S,\mathcal R:K\to\mathbb R^m\), with
  \(S=M\mathcal R\), horizontal parts both the identity, and
  \(\lVert LS(k)\rVert\leq B\lVert k\rVert\);
* \(k_i\in K\), \(s_i,r_i\in\mathbb R^m\), satisfying
  \[
   Ye_i=s_i+Mr_i+S(k_i),\qquad \lVert Ls_i\rVert\leq B/T_i;
                                                               \tag{3}
  \]
* one positive integer \(D\leq B\) that clears the coordinates of
  \(\mathcal R\) on the displayed basis of \(K\) and all the \(r_i\).

The numerators of \(\mathcal R\) and \(r_i\) are not bounded.

### Proof

The defining linear map of (2) is invertible, so \(\Lambda\) is a
lattice. Let \(Z\) be the real span of all its vectors of norm at most
\(R\), \(d=\dim Z\), and \(\Lambda_Z=\Lambda\cap Z\).

First \(Z\) projects onto all \(h\)-coordinates. Otherwise a nonzero
linear equation on those coordinates determines some \(h_i\) from
the others. Since \(|h_j|\leq RT_j\), their number is at most
\[
 \prod_{j\ne i}(2RT_j+1)
 \leq (2R+1)^{n-1}\frac{\prod_jT_j}{T_*}
 <\delta\prod_jT_j .
\]
Here \(T_*>B\geq1\) and
\(\delta^{-1}(2R+1)^{n-1}\leq C\leq B\).
This contradicts the hypothesis.

Choose \(d\) independent short vectors spanning \(Z\). Rounding their
real coefficients shows that their integral span has covering radius
at most \(dR/2\); the superlattice \(\Lambda_Z\) has no larger covering
radius. Its Voronoi cell is therefore in a ball of radius \(dR/2\).
The translates of that cell centered at the given short vectors are
disjoint except on null sets and lie in a ball of radius
\((1+d/2)R\). In orthonormal coordinates on \(Z\), that ball is in a
cube of side \((d+2)R\). Consequently
\[
 \operatorname{covol}(\Lambda_Z)
 \leq \frac{\delta^{-1}((d+2)R)^d}{\prod_iT_i}
 \leq \frac C{\prod_iT_i}.                                  \tag{4}
\]
This establishes the constant in (1), rather than leaving an
unspecified dimension-dependent ball-volume factor.

Set \(V=Z\cap(\{0\}\times\mathbb R^m)\),
\(q=\dim V\), and \(\Lambda_V=\Lambda\cap V\).
Projection of a basis of \(\Lambda_Z\) to unscaled \(h\)-coordinates
is an integer matrix of rank \(n\). Its kernel has an integer basis
after clearing denominators, so \(\Lambda_V\) spans \(V\).
The projected lattice is a subgroup \(H\leq\mathbb Z^n\) of finite
index \(I\).

The orthogonal complement to \(V\) in \(Z\) is the graph of
\(A:\mathbb R^n\to V^\perp\subseteq\mathbb R^m\) in the scaled
coordinate \(x=D_T^{-1}h\). Put
\(E_A=\sqrt{\det(1+A^*A)}\).
Taking an exterior product of a vertical lattice basis and lifts of a
basis of \(D_T^{-1}H\) gives the exact formula
\[
 \operatorname{covol}(\Lambda_Z)
 =\operatorname{covol}(\Lambda_V)
       \frac I{\prod_iT_i}E_A .
\]
Indeed vertical components of the lifts do not change that exterior
product, and the graph contributes the Gram factor \(E_A\).
Thus
\[
 \operatorname{covol}(\Lambda_V) I E_A\leq C.                \tag{5}
\]
Every singular value of the graph map \(x\mapsto(x,Ax)\) is at
least one, so its operator norm is at most their product \(E_A\).

Write a basis of \(\Lambda_V\) as the columns of \(LMR_b\), with
\(R_b\in(l^{-1}\mathbb Z)^{m\times q}\). Choose rows
\(J=(j_1<\cdots<j_q)\) greedily: keep a row of \(R_b\) exactly
when it increases row rank. Every earlier nonpivot row is in the
span of earlier pivot rows. Hence the selected rows of \(MR_b\)
are obtained from the selected rows of \(R_b\) by a lower
unitriangular \(q\)-by-\(q\) row operation. In particular
\[
 \det(MR_b)_J=\det(R_b)_J .
                                                               \tag{6}
\]
This is an exact identity for arbitrary entries of \(M\), not an
estimate involving its operator norm. By the Gram determinant
expansion,
\[
 \operatorname{covol}(\Lambda_V)
 \geq |\det(LMR_b)_J|
 \geq l^{-q}\prod_{j\in J}w_j .                              \tag{7}
\]
If one pivot is nonhorizontal, the right side is at least
\(l^{-m}T_*>C\), contradicting (5). All pivots are horizontal.

It follows that horizontal projection is injective on \(V\).
Let \(H_b\) be the horizontal rows of \(R_b\); they are also the
horizontal rows of \(LMR_b\). Their column space is \(K\).
Every maximal minor of \(H_b\) is in \(l^{-q}\mathbb Z\) and
has magnitude at most \(\operatorname{covol}(\Lambda_V)\leq C\).
Choose a nonzero minor \(H_J\). The columns of
\[
                  H_bH_J^{-1}                              \tag{8}
\]
are a rational basis of \(K\). Cramer's rule writes their entries
as ratios of these maximal minors. Both the integer numerators
and their common denominator have magnitude at most \(Cl^q\leq B\).
This proves height control without requiring a short basis of
\(\Lambda_V\).

The unique graph lift \(K\to V\) has volume expansion
\[
 \frac{\operatorname{covol}(\Lambda_V)}
      {\operatorname{covol}(H_b\mathbb Z^q)}
 \leq Cl^q .
\]
Its horizontal part is the identity, so all singular values are at
least one. Its operator norm is therefore at most \(Cl^q\).
Write this lift as \(k\mapsto LS(k)\), and on the basis (8) define
\[
 \mathcal R(H_bH_J^{-1}u)=R_bH_J^{-1}u .
\]
Then \(S=M\mathcal R\). The table \(R_bH_J^{-1}\) has denominator
dividing
\[
                    d_0=|\det(lH_J)| .
\]
There is deliberately no assertion about its numerators.

Since \(I\mathbb Z^n\subseteq H\), lift \(Ie_i\) to
\(\Lambda_Z\), then divide by \(I\). It has the form
\[
 (e_i/T_i,L(Ye_i-Mr_i)),\qquad r_i\in(lI)^{-1}\mathbb Z^m .
\]
Its component orthogonal to \(V\) is
\((e_i/T_i,Ae_i/T_i)\), of norm at most \(E_A/T_i\).
The remaining component is \(LS(k_i)\) for a unique \(k_i\in K\).
Set \(Ls_i=Ae_i/T_i\). Equations (3) and their bounds follow from
(5) and (7).

Finally a *joint* denominator is
\[
                       D=lI d_0 .
\]
This is still at most \(B\), not merely \(B^2\): the minor bound
\(d_0\leq l^q\operatorname{covol}(\Lambda_V)\) and (5) give
\[
 D\leq l^{q+1}I\operatorname{covol}(\Lambda_V)
   \leq Cl^{q+1}\leq Cl^{m+1}=B .
\]
For \(q=0\), all bases and minors are empty, their determinant
and covolume are one, \(K=0\), and the same proof gives
\(D=lI\leq B\). This includes \(a=0\). The proof is complete.

## Theorem 2: from the derivative system to the target algebra

Fix \(s\geq2\). Let \(\mathfrak n=\bigoplus_{j=1}^s\mathfrak n_j\)
be a rational graded nilpotent Lie algebra, \(U\) a controlled
rational graded Lie subalgebra, and \(V_j\subseteq\mathfrak n_j\)
controlled rational spaces with
\[
 V_1=0,\qquad [U_i,V_j]\subseteq V_{i+j}.                     \tag{9}
\]
Zero layers beyond \(s\) are understood. The direct sum \(V\)
need not be an ideal of \(\mathfrak n\), or be contained in \(U\).
It is a module invariant under the adjoint action of \(U\).

Let \(B(t)\) be a symbol in \(U\): if \(P=\log B\), then \(P_j\)
is homogeneous of parameter degree \(j\). Work in
\[
 \mathscr M=\bigoplus_{j=1}^s
      \mathcal H_{j-1}(\mathbb R^n)\otimes(\mathfrak n_j/V_j).
\]
On this space \(\operatorname{Ad}_B\) is lower unitriangular by
Lie layer. Let \(L_T\) scale a monomial coefficient by \(T^\alpha\).

Suppose a controlled rational \(K\subseteq\mathfrak n_1\) and
linear maps \(S,\mathcal R:K\to\mathscr M\) satisfy
\[
 S=\operatorname{Ad}_B\mathcal R,\quad
 S(k)_1=\mathcal R(k)_1=k,\quad
 \lVert L_TS(k)\rVert\leq H\lVert k\rVert,                   \tag{10}
\]
and, for each \(i\),
\[
 Y_i(B)=s_i+\operatorname{Ad}_B r_i+S(k_i),\qquad
 \lVert L_Ts_i\rVert\leq H/T_i,                             \tag{11}
\]
where \(Y_i(B)=(\partial_iB)B^{-1}\).
The tables of \(\mathcal R\) on a controlled rational basis of
\(K\), and the \(r_i\), have a controlled common denominator.
They have no numerator bound; the \(k_i\) are arbitrary real vectors.
All the dimension data, logarithmic structural heights,
\(\log H\), and logarithmic denominator bounds are
\(\operatorname{poly}(p)\).

For \(T_*\geq\exp(\operatorname{poly}(p))\), with degree-dependent
polynomials, one can factor \(B=aPb\), with \(a\) slow, \(b\)
denominator-bounded rational, and the logarithmic coefficients of
the new middle symbol in
\[
 W_1=\{v\in K\cap U_1:[v,K]\subseteq V_2\},\qquad
 W_j=U_j\cap V_j\quad(2\leq j\leq s).                       \tag{12}
\]
All rational heights and logarithmic costs remain
\(\operatorname{poly}(p)\). In particular \(\eta(V_s)=0\)
implies \(\eta(W_s)=0\).

### Separation and quantitative bookkeeping

The only small-versus-rational argument needed is the following.
If \(Q\) is a controlled rational matrix, \(u+v\in\ker Q\),
\(\lVert u\rVert\leq H/\tau\), and \(v\) has common denominator
at most \(D\), then \(Qu=-Qv\).
After clearing the denominators of \(Q\), every nonzero coordinate
of \(Qv\) has magnitude at least the reciprocal of an explicit
controlled integer times \(D\). But
\(\lVert Qu\rVert\leq\lVert Q\rVert H/\tau\).
For sufficiently large controlled \(\tau\), both are zero.
This proof does not involve the numerator of \(v\).
Here \(\tau\) is always \(T^\alpha\) with \(|\alpha|>0\), or
\(T_iT^\alpha\); in either case it is at least \(T_*\).

Rational kernels, intersections, images, and sections used below are
obtained by maximal minors after clearing denominators jointly.
For a matrix with \(r\) rows and entries of height at most \(H_0\),
its integer minors are at most \(r!H_1^r\) after denominator
clearing. When \(r\) and \(\log H_0\) are polynomial in \(p\),
their logarithms are polynomial in \(p\). This proves the claimed
cost for every such section.

Fixed-step BCH and adjoint formulas use rational coefficients with
commutator length at most \(s\). Their number of terms is polynomial
in the dimensions at fixed \(s\). The norm
\(\max_\alpha T^\alpha\lVert c_\alpha\rVert\) is preserved up to
controlled factors under multiplication of slow arrays: the exact
identity \(T^{\alpha+\beta}=T^\alpha T^\beta\) is used, not a
comparison between different side lengths. Rational arrays are
closed under these formulas with denominator control only.

### Identities preserved during removal

If \(B=aB'b\), with \(a\) slow and \(b\) rational, both in \(U\),
the right derivative product rule gives
\[
 \begin{split}
 S'&=\operatorname{Ad}_{a^{-1}}S,&
 \mathcal R'&=\operatorname{Ad}_b\mathcal R,\\
 s'_i&=\operatorname{Ad}_{a^{-1}}(s_i-Y_i(a)),&
 r'_i&=\operatorname{Ad}_b r_i-Y_i(b).                       \tag{13}
 \end{split}
\]
Equations (10)-(11) remain true for \(B'\).
Only slow arrays enter the new \(S'\) and \(s'_i\);
only rational arrays enter the new \(\mathcal R'\) and \(r'_i\).
Thus no unbounded rational numerator is used to estimate a slow
quantity. Their horizontal identity parts are unchanged.

For \(k_s,k_r\in K\), the replacements
\[
 s_i\mapsto s_i-S(k_s),\quad
 r_i\mapsto r_i-\mathcal R(k_r),\quad
 k_i\mapsto k_i+k_s+k_r                                      \tag{14}
\]
also preserve (11). The slow bound persists when
\(\lVert k_s\rVert\) is controlled times \(T_i^{-1}\).
The denominator bound persists when \(k_r\) has controlled
denominator, with no bound on its size.

### Horizontal normalization

The coefficient of \(t_i\) in \((\log B)_1\) is
\(s_{i,1}+r_{i,1}+k_i\in U_1\).
Therefore \(s_{i,1}+r_{i,1}\in U_1+K\).
Separation modulo the rational space \(U_1+K\), at scale \(T_i\),
puts the two terms separately in that space.
Choose bounded rational decompositions into \(U_1\) and \(K\).
Absorb the \(K\)-parts using (14), and remove the \(U_1\)-parts by
left and right exponentials whose logarithms have only layer one.
Equation (13) gives
\[
 (\log B)_1\in U_1\cap K,\qquad s_{i,1}=r_{i,1}=0.           \tag{15}
\]
All statements about higher components below are modulo their \(V_j\).

### Induction on the layer

Write \(P_j=(\log B)_j\), updating it after each removal.
At the start of stage \(j=2,\ldots,s\), maintain
\[
 \begin{array}{ll}
 P_d\in U_d\cap V_d &(2\leq d<j),\\
 [P_d,K]\subseteq V_{d+1} &(1\leq d\leq j-2),\\
 S_d=\mathcal R_d=0 &(2\leq d<j),\\
 s_{i,d}=r_{i,d}=0 &(1\leq d<j).
 \end{array}                                                \tag{16}
\]

In layer \(j\), expansion of \(S=\operatorname{Ad}_B\mathcal R\)
gives
\[
              [P_{j-1},k]=S_j(k)-\mathcal R_j(k).            \tag{17}
\]
To see this without discarding any unbounded coefficient, first
discard inputs in \(V\) using (9). All lower components of
\(\mathcal R\) except its horizontal component are then zero.
Every nested bracket of length at least two in
\(\exp(\operatorname{ad}P)k\) has an innermost
\([P_d,k]\) with \(d\leq j-2\). It is in \(V\) by (16), and
the remaining brackets stay in \(V\) by (9).
The sole remaining term is the displayed single bracket.

Let \(E=U_1\cap K\) for \(j=2\), and
\(E=U_{j-1}\cap V_{j-1}\) otherwise. On a controlled rational
basis \((k_b)\) of \(K\), consider
\[
 Q_j:E\to\bigoplus_b\mathfrak n_j/V_j,\qquad
                  v\mapsto([v,k_b])_b .
\]
Each coefficient of \(P_{j-1}\) belongs to \(E\).
In (17) the first part of the right side is slow, the second is
rational. Modulo the controlled rational image \(Q_j(E)\),
separation puts both parts in that image individually.
A bounded rational section gives homogeneous polynomials
\(a_{j-1},b_{j-1}\) in \(E\) with
\[
 Q_j(a_{j-1})=S_j,\qquad Q_j(b_{j-1})=-\mathcal R_j.         \tag{18}
\]
The first is slow; the second has bounded denominator.

Remove their exponentials on the left and right.
The new layer-\((j-1)\) logarithm is
\(P_{j-1}-a_{j-1}-b_{j-1}\).
At layer \(j\), (13) changes \(S_j\) by
\(-[a_{j-1},k]\) and \(\mathcal R_j\) by
\([b_{j-1},k]\). Thus (18) gives, with exactly these signs,
\[
 [P_{j-1},K]\subseteq V_j,\qquad S_j=\mathcal R_j=0.         \tag{19}
\]
All lower conditions persist. At \(j=2\) the new horizontal
derivative terms are \(-\partial_i a_1\) and
\(-\partial_i b_1\), both in \(K\). Absorb them by (14).
Their size and denominator have the required respective controls.
Because \(S_2=\mathcal R_2=0\), this absorption does not undo
(19). For \(j>2\), the analogous new terms are already in
\(V_{j-1}\).

Now the finite right-logarithmic-derivative expansion gives
\[
          Y_i(B)_j=\partial_iP_j\pmod{V_j}.                 \tag{20}
\]
Indeed every other term is a nested bracket containing
\(\partial_iP_d\) in a lower layer. For \(d\geq2\) that
derivative is in \(V_d\); for \(d=1\) it is in \(K\), so its
innermost bracket is in \(V\) by (19) and the preceding bracket
conditions. All outer brackets preserve \(V\).
Also \((\operatorname{Ad}_B r_i)_j=r_{i,j}\), since every
lower component is zero modulo \(V\). Equations (11) and (19)
therefore reduce to
\[
                \partial_iP_j=s_{i,j}+r_{i,j}\pmod{V_j}.    \tag{21}
\]

For each monomial \(t^\beta\), \(|\beta|=j\), select an \(i\)
with \(\beta_i>0\). Divide its derivative coefficient by
\(\beta_i\). The slow part has size at most a controlled constant
times
\[
                 (T_iT^{\beta-e_i})^{-1}=T^{-\beta};
\]
the rational part retains a controlled common denominator, since
all \(\beta_i\) divide \(s!\).
The sum belongs to \(U_j+V_j\). Separation and a bounded rational
section of \(U_j\to(U_j+V_j)/V_j\) lift both parts into \(U_j\).
Remove their exponentials in layer \(j\).
This puts \(P_j\) in \(U_j\cap V_j\), without changing (19).
Equation (21) now says \(s_{i,j}+r_{i,j}=0\) modulo \(V_j\).
Separation at scale \(T_iT^\alpha\) makes the two terms vanish
separately. This proves all of (16) for the next stage.

At the end \(P_1\) belongs to \(W_1\) and each \(P_j\), \(j\geq2\),
belongs to \(W_j\). The spaces (12) form a graded Lie algebra:
\([W_1,W_1]\subseteq U_2\cap V_2\), and every other required
bracket is in both \(U\) and \(V\) by (9).
Their rational height is controlled by joint rational linear algebra.
There are only \(s\) stages, with a bounded number of outside factors
per stage; their products remain slow and rational respectively.
This proves the theorem.

## Theorem 3: the complete common-derivative reduction

In the setting of Theorem 2, suppose a set of distinct integer shifts
\(H_0\), with \(|h_i|\leq T_i\), has size at least
\(\delta\prod_iT_i\), and
\[
 Y_h(B)=s_h+\operatorname{Ad}_B r_h+Z_0\pmod V,             \tag{22}
\]
where \(Z_0\in\mathscr M\) is independent of \(h\),
\(\lVert L_Ts_h\rVert\leq R\), and all \(r_h\) are in one
controlled rational grid. Assume fixed \(s\) and polynomially growing
dimensions and logarithmic budgets as above.
Then the factorization of Theorem 2 holds for sufficiently large
\(T_*\geq\exp(\operatorname{poly}(p))\).

Choose \(h_0\in H_0\) and subtract its equation. The maps
\(h\mapsto Y_h(B)\) are real linear. The resulting lattice vectors
have scaled horizontal norm at most \(2\sqrt n\) and vertical
norm at most \(2R\), hence norm at most
\(R_0=2(\sqrt n+R)\). Their \(h-h_0\)'s remain distinct, including
the zero vector, so no density loss is necessary here.
In coordinates on \(\mathscr M\),
\(M=\operatorname{Ad}_B\) is lower unitriangular with identity
horizontal block. Every nonhorizontal scale is \(T^\alpha\)
with \(|\alpha|\geq1\), hence at least \(T_*\). Theorem 1 applies
with \(R_0\), yielding exactly (10)-(11).

If \(m=\dim\mathscr M>0\), its sufficient lattice cutoff is explicitly
\[
 \delta^{-1}((n+m+2)R_0)^{n+m}l^{m+1}.                     \tag{23}
\]
At fixed degree,
\[
 m=\sum_j\dim(\mathfrak n_j/V_j)
                   {n+j-2\choose j-1}
   \leq (\dim\mathfrak n){n+s-2\choose s-1}
\]
is polynomial in the growing dimensions.
The logarithm of (23) is
\[
 \log\delta^{-1}+(n+m)\log((n+m+2)R_0)+(m+1)\log l,
\]
which is polynomial in \(p\). Rational coordinate changes only
enlarge those budgets polynomially. The finitely many separation
cutoffs in Theorem 2 have the same form. When \(m=0\), the quotient
system is zero and \(K=0,\ a=b=1,\ P=B\) already work. Zero
parameters are likewise trivial.
This proves the claimed coefficient-uniform reduction.

## Why the manuscript supplies exactly (22)

For a subgroup of a relative/diagonal semidirect product with abelian
relative part, two elements in the subgroup having the same diagonal
differ by an element of its vertical kernel. This is simply
\(\pi(xy^{-1})=1\), with \(xy^{-1}\) still in the subgroup.
Thus, after the manuscript's diagonal factors have been made common,
the fast relative coordinate is common modulo \(V\). It is not
silently assumed to be independent of \(t\), only of the retained
shift \(h\).

Writing \(X=ABD\), the raw square-coordinate equation is
\[
 Y_h(X)-e_h-\operatorname{Ad}_X m_h
       =u_h+\operatorname{Ad}_A Z_h+\operatorname{Ad}_{AB}v_h .
\]
The right cocycle rule
\(Y_h(ABD)=Y_h(A)+\operatorname{Ad}_A Y_h(B)
                      +\operatorname{Ad}_{AB}Y_h(D)\)
therefore gives (22) with exactly
\[
 s_h=\operatorname{Ad}_{A^{-1}}(e_h+u_h-Y_h(A)),\qquad
 r_h=v_h+\operatorname{Ad}_D m_h-Y_h(D).                    \tag{24}
\]
The bounded \(e_h\), slow \(u_h,A\), and \(|h_i|\leq T_i\)
give the required shift-error bound. Integer \(h_i\), rational
\(D,v_h,m_h\), and fixed-step formulas give denominator control
for \(r_h\), not height control. Pigeonholing the already bounded
denominators supplies one grid, at a controlled density cost.

This argument does not assume the original filtration is graded.
To justify the square symbol, choose complements \(E_j\) and scale
them by \(z^j\). A bracket component from \(E_i,E_j\) to \(E_k\)
has coefficient multiplied by \(z^{k-i-j}\), with nonnegative
exponent. Thus the deformed bracket is polynomial and specializes
at \(z=0\) to the associated graded bracket. Adaptedness similarly
makes \(\delta_z\log g(t/z)\) polynomial in \(z\).

When shift and insertions are zero, the relative product is the
identity for every \(z\). Its first-order variations coming only
from the bracket or the subleading orbit coefficients therefore
cancel. The surviving first-order term can be calculated over
the dual numbers:
\[
 e^{-\epsilon e_h}X(t+\epsilon h)e^{-\epsilon m_h}X(t)^{-1}
   =\exp\{\epsilon(Y_h(X)-e_h-\operatorname{Ad}_X m_h)\},
 \qquad \epsilon^2=0 .
\]
Higher-layer normalizing coefficients occur only in terms divisible
by \(z^2\). Divisibility is formal, not a smallness estimate; their
arbitrarily large numerators cause no difficulty. This verifies the
algebraic passage to (24), conditional on the separate square and
induction input producing the retained fast subgroup.

## Exact evidence and its limits

`Main.lean`, checked with Lean 4.31.0, proves common-fiber uniqueness,
(24), (13), (14), and the sign in (18)-(19) for arbitrary group
representations and additive cocycles. Its complete scope is in
`statement_fidelity.md`. It does not formalize Theorems 1-3 in full.

`verify.py` uses exact rational polynomial and noncommutative word
arithmetic, not floating-point agreement. Its certificate checks:

1. The source-bound Jacobian symbolic determinant
   \[
    \det\begin{pmatrix}
      a&b\\w(c+(x+y\lambda)a)&w(d+(x+y\lambda)b)
    \end{pmatrix}=w(ad-bc).
   \]
   This is a rank-two pivot example with an intervening dependent
   row and arbitrary shear parameters. The all-rank assertion is
   proved in (6), not inferred from this example. The exact typed
   request, output, server/protocol versions and contract are retained
   under `jacobian/`.
2. The cocycle, adjoint, exponential derivative and removal formulas
   in the free truncated associative algebra through weight four.
   This is a universal symbolic identity in that algebra, not a
   finite numerical sample and not an all-step formal proof.
3. A direct product of arbitrarily many Heisenberg blocks, with an
   exact replay at the rank specified in the certificate. The model
   has sides \(T_i=T^{i+1}\), \(T\) larger than (1), and rational
   numerators larger than those side scales. Its lift has horizontal
   identity and arbitrarily large vertical numerators, while its
   image \(S\) has norm one. The construction, not a finite sweep,
   supplies the all-rank family.
4. A genuinely nonrational fast Heisenberg symbol. Put
   \([X,Y]=Z\), \(a(t)=\exp(T_1^{-1}t_1Y)\),
   \(P(t)=\exp(\alpha t_1X)\), and
   \(b(t)=\exp(A t_2Y)\), where \(\alpha\) is an arbitrary real
   and \(A\) an unrestricted integer. For \(B=aPb\),
   \[
    K=\mathbb RX,\quad S(X)=X-T_1^{-1}t_1Z,\quad
    \mathcal R(X)=X+A t_2Z .
   \]
   Thus \(S=\operatorname{Ad}_B\mathcal R\), while
   \(s_1=T_1^{-1}Y,\ r_2=AY,\ k_1=\alpha X\), and the other
   \(s_i,r_i,k_i\) are zero. All identities are checked
   polynomially in \(\alpha\). For (22), choose an integer \(q_h\)
   within \(1/2\) of \(h_1\alpha\), put
   \[
    s_h=h_1T_1^{-1}Y+S((h_1\alpha-q_h)X),\qquad
    r_h=h_2AY+\mathcal R(q_hX).
   \]
   Then \(Y_h(B)=s_h+\operatorname{Ad}_B r_h\) for every integer
   shift, the scaled slow error is at most \(1+\sqrt2/2<2\),
   and \(r_h\) has denominator one. This has a full-density
   common-derivative system, with \(Z_0=0\), arbitrary \(\alpha\),
   and no aspect-ratio restriction. Here \(W_1=K,W_2=0\).

Run `python3 research/step_drop_audit/verify.py` from the campaign
directory. It is an offline replay: it does not rerun Jacobian,
contact a registry, or claim to rerun Lean. A new Lean compiler run
uses the authorized `lean_evidence verify` command with
`--claim C_ALGEBRA_CORE`.

No false literal manuscript assertion was found in this reduction.
Consequently no `F_` refutation has been invented. The route that
tries to refute lattice extraction merely by enlarging an adjoint
shear is excluded by Theorem 1; this does not exclude other possible
defects in the manuscript. The main quantitative density theorem,
the analytic input to step drop, and independent novelty/significance
assessment remain open in the proof graph.
