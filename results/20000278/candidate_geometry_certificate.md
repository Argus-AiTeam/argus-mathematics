# Geometric certificate for the fixed characteristic-13 candidate

## 1. Statement and scope

Let
\[
 k=\mathbb F_{13}(u,v,w,z),\qquad
 E:\ y^2=x(x-1)(x-u),\qquad X=E\times E,
\]
where the four parameters are algebraically independent. Keep the actual
divisors and cover in the frozen candidate:
\[
 \Theta=f_1+f_2,\quad M=3\Theta,\quad
 L=6f_1+3f_2+6\delta,\quad
 f:W=\operatorname{Spec}_X(\mathcal O_X\oplus\mathcal O_X(-M))\longrightarrow X,
\]
with multiplication given by
\[
 b=x_1^3x_2^3+vx_1^3+wx_2^3+z\in H^0(X,2M).
\]
Put \(A_0=f^*L\), \(A=3A_0\),
\[
 S=\bigoplus_{n\geq0}H^0(W,nA),\quad
 \mathfrak n=S_+,\quad C=\operatorname{Spec}S,\quad
 R=S_{\mathfrak n},\quad \mathfrak m=\mathfrak nR.
\]
Line bundles are also written additively.

The following are proved below:

1. The specified branch divisor is nonempty and geometrically smooth,
   including above infinity. The specified \(W\) is a smooth, geometrically
   integral projective surface, and \(K_W\sim f^*M\).
2. \(S\) is a normal, finitely generated, standard graded \(k\)-domain, and
   \(A\) is very ample. Both \(S\) and \(R\) are F-finite;
   \(\dim R=3\) and \(\mu(\mathfrak m)=1116\).
3. The blowup of the affine cone is
   \(Y=\operatorname{Tot}\mathcal O_W(-A)\). It is smooth, its exceptional
   divisor \(W_0\) is the zero section, and
   \(\mathfrak n\mathcal O_Y=\mathcal O_Y(-W_0)\) is relatively ample.
   The local vertex ring is not Q-Gorenstein.
4. The pseudo-effective threshold is
   \[
      \inf\{t:tA-K_W\text{ is pseudo-effective}\}
         =\theta=\frac{7+\sqrt{17}}{48}.
   \]
5. For every prescribed \(s=h/q>\theta\), with \(q>0\) and \(13\nmid q\),
   the prescribed \(\ell\) and \(m_s=q\ell\) make
   \(m_s(sA-K_W)\) very ample. There is a smooth member over the **original
   field \(k\)**, and its cone boundary has prime-to-13 index and exceptional
   coefficient exactly \(s+1\).

No assertion here concerns a test ideal, an endpoint bound, or a jumping
number. In particular these geometric assertions alone do not certify the
proposed negative witness.

## 2. Precise standard inputs

These are the external geometric inputs used below. The intervening
candidate-specific arguments, the multiplication argument, the
double-cover separation argument, and the cone-boundary calculation are
given explicitly rather than taken from Ajit.

**[AV]** J. S. Milne, *Abelian Varieties*, author-hosted corrected version
dated January 2, 2022, of Chapter V of *Arithmetic Geometry* (1986):
<https://www.jmilne.org/math/xnotes/AVs.pdf>.
The numbering is unchanged from the published chapter.

- Theorem **4.2(a)**, p. 6: cohomology of locally free finite-rank sheaves
  in the indicated proper flat setting commutes with flat base change.
  In particular this applies to extension of the ground field.
  Part **(b)** says that the Euler characteristic in such a family
  is locally constant.
- Corollary **6.4**, pp. 8–9: the theorem-of-the-cube line bundle on the
  triple product is trivial. Its pullback along three homomorphisms gives
  the cubic identity used in Section 4 below.
- Corollary **6.6**, p. 9:
  \([n]^*\mathcal B\simeq\mathcal B^{\otimes n^2}\) for a symmetric line
  bundle \(\mathcal B\).
- Remark **7.3**, p. 12: the third power of an ample line bundle on an
  abelian variety is very ample. The original reference given there is
  Mumford, *Abelian Varieties* (1970), **Section 17, p. 163**.
  The concluding paragraph (a) of the proof of Theorem **7.1**, p. 11,
  also explicitly records descent of very ampleness of the complete
  linear system from the algebraic closure.
- Theorem **8.2**, p. 13: on a \(g\)-dimensional abelian variety, \([n]\)
  is finite of degree \(n^{2g}\), and is étale when \(n\) is prime to the
  characteristic.
- Theorem **13.3(b)**, p. 25:
  \(\chi(\mathcal O(D))=D^g/g!\). Its original reference is Mumford,
  **Section 16, p. 150**.

This article works over an arbitrary ground field; its conventions are
explicit on p. 2. We do not use a characteristic-zero matrix-cone theorem.

**[S]** Stacks Project:

- Lemma, Tag **0AVB**, <https://stacks.math.columbia.edu/tag/0AVB>:
  a finite reflexive module over a Noetherian normal domain is the
  intersection of its height-one localizations inside its generic
  fibre. Applied locally to a line bundle, this detects regularity
  of rational sections in codimension one.
- Lemma **30.16.1(1), (3), (4)**, Tag **0B5T**, in
  <https://stacks.math.columbia.edu/tag/0B5S>:
  finite generation of a proper ample section ring, finite-dimensional
  coherent cohomology, and Serre vanishing.
- Lemma **30.17.2**, Tag **0B5V**, in
  <https://stacks.math.columbia.edu/tag/01XO>:
  an invertible sheaf on a proper scheme is ample if and only if its
  pullback under a finite surjective morphism is ample.
- Lemma **28.18.2**, Tag **01PW**,
  <https://stacks.math.columbia.edu/tag/01PW>:
  localization of the graded module of sections at a section computes
  sections on its nonvanishing open, for a quasi-compact,
  quasi-separated scheme.
- Lemmas **31.33.2–4**, Tags **0804**, **0805**, **02OS**, in
  <https://stacks.math.columbia.edu/tag/01OF>:
  affine blowup charts \(B[I/a]\), compatibility with flat base change,
  and the exceptional invertible ideal. The paragraph following
  Definition 31.33.1 identifies the relative very ample twist.
- Situation **33.47.2**, Tag **0G47**, and Lemma **33.47.3**, Tag
  **0FD6**, in <https://stacks.math.columbia.edu/tag/0FD4>:
  if a finite-dimensional generating space of sections defines an
  immersion of a smooth \(k\)-scheme, the smooth members contain a
  nonempty open of its affine parameter space. The definition of
  “general” explicitly applies to points over every extension field;
  there is no perfectness hypothesis on \(k\).

The [AV] PDF and its text extraction are retained as
`evidence/literature/geometry/milne-AVs.{pdf,txt}`. The four displayed
Stacks section pages are retained in the same directory, with names
beginning `stacks-0B5S`, `stacks-01XO`, `stacks-01OF`, and `stacks-0FD4`.
The individual lemma pages `stacks-0AVB-reflexive.html` and
`stacks-01PW-section-localization.html` are retained there as well.

## 3. The actual branch section and double cover

### 3.1. Projective coordinates and the branch values

The projective equation
\[
 Y^2Z=X(X-Z)(X-uZ)
\]
is a smooth plane cubic: \(u\ne0,1\), and \(2\ne0\) in \(k\).
Its point \(O=[0:1:0]\) has \(x\) of pole order two and \(y\) of pole
order three. In particular \(1,x^3\) are sections of
\(\mathcal O_E(6O)\) with no common zero. They define a finite separable
map
\[
       g:E\longrightarrow\mathbb P^1,\qquad g=[x^3:1].
\]
It has degree six. The degree-two map \(x\) is ramified precisely over
\(0,1,u,\infty\); the map \(a\mapsto a^3\) is ramified only over
\(0,\infty\). Since 2 and 3 are prime to 13, the branch values of their
composite are exactly
\[
                \mathcal T=\{0,1,u^3,\infty\}.
\]
This description includes the point \(O\): its ramification index for
\(g\) is six, not an unexamined affine-chart limit.

Write the coordinates of the two copies of \(\mathbb P^1\) as
\([T_1:S_1]\), \([T_2:S_2]\). The section \(b\) is the pullback of
\[
 F=T_1T_2+vT_1S_2+wS_1T_2+zS_1S_2.
\]
Because \(z-vw\ne0\), its zero locus \(G\) is the graph of an
automorphism of \(\mathbb P^1\):
\[
            a\longmapsto-\frac{va+z}{a+w}.
\]
In particular both projections \(G\to\mathbb P^1\) are isomorphisms.

Here is the complete check that \(G\) avoids
\(\mathcal T\times\mathcal T\).

- For finite \(a,b\in\{0,1,u^3\}\), its equation is
  \(ab+va+wb+z=0\). This is false because the coefficient of the
  algebraically independent parameter \(z\) is one.
- At \((\infty,b)\), \(b\) finite in that set, the equation is
  \(b+v=0\), also false.
- At \((a,\infty)\), it is \(a+w=0\), also false.
- At \((\infty,\infty)\), \(F=1\).

All these are nonzero elements of \(k\), so the exclusions remain true
over \(\bar k\).

### 3.2. Smoothness, nonemptiness, and integrality of \(W\)

Let \(B=(g\times g)^{-1}G\). At a geometric point of \(B\), at least
one of the two maps \(g\) is unramified. In local coordinates on the
two projective lines the equation of \(G\) has both partial
derivatives nonzero, since both graph projections are isomorphisms.
Consequently its pulled-back differential is nonzero on at least one
factor of the smooth surface \(X_{\bar k}\). This proves that
\(B_{\bar k}\) is smooth. The calculation is intrinsic in local
coordinates on \(\mathbb P^1\), and thus also proves smoothness above
infinity.

The map \(g\times g\) is finite surjective, so \(B\) is nonempty. Its
line bundle is
\[
        \mathcal O_X(B)=\mathcal O_X(2M)
          =\mathcal O_E(6O)\boxtimes\mathcal O_E(6O),
\]
which is ample. In particular \(B\) is a nonempty reduced divisor.

Locally trivialize \(M\), and let \(\beta\) be the resulting local
equation of \(B\). The cover is the hypersurface
\(\xi^2=\beta\). Away from \(B\) it is étale. At a point above \(B\),
the differential of \(\xi^2-\beta\) is \(-d\beta\ne0\).
Therefore \(W\) is smooth over \(k\).

To prove geometric integrality, view \(b\) as a rational function
after using the given divisor \(2M\) to trivialize its line bundle.
Its divisor is \(B-2M\). At the generic point of any geometric
component of \(B\), its valuation is odd: the coefficient contributed
by \(B\) is one and that contributed by \(2M\) is even.
Thus \(b\) is not a square in \(\bar k(X)\). The generic cover is a
quadratic field extension. On every affine trivializing open the
cover algebra is free over the coordinate domain and embeds into
that generic field. It is therefore a domain. This proves that
\(W_{\bar k}\), and hence \(W\), is integral.
No connectedness or irreducibility theorem for the branch divisor
is needed for this argument.

The construction is finite flat of degree two, with the specified
splitting
\[
             f_*\mathcal O_W=\mathcal O_X\oplus\mathcal O_X(-M).
                                                        \tag{3.1}
\]
It is projective since \(X\) is projective and \(f\) is finite.

For completeness the canonical formula follows directly from
adjunction. Inside \(V=\operatorname{Tot}\mathcal O_X(M)\), \(W\) is
the zero divisor of a section of the pullback of \(2M\). The relative
cotangent sequence of this line bundle gives
\(\omega_V=p^*(\omega_X\otimes\mathcal O_X(-M))\).
Taking determinants in the conormal sequence of the smooth
hypersurface gives
\[
           \omega_W=f^*(\omega_X\otimes\mathcal O_X(M)).
\]
The invariant differentials on the two elliptic factors trivialize
\(\omega_X\). Thus
\[
                         K_W\sim f^*M.                    \tag{3.2}
\]
We may and do choose the canonical divisor representative
\(K_W=f^*M\) when exact divisors are used below.

## 4. The matrix cone on the required span, without an endomorphism assumption

All assertions about positivity may be checked over \(\bar k\).
For a divisor in the specified span define
\[
 Q(\alpha f_1+\beta f_2+\gamma\delta)
       =\begin{pmatrix}\alpha+\gamma&\gamma\\
                         \gamma&\beta+\gamma\end{pmatrix}.
                                                        \tag{4.1}
\]
These are numerical real matrices; their entries are **not** reduced
modulo 13. We prove exactly the restriction of the matrix-cone
description that is needed, without identifying the full
Néron–Severi group. The intersections
\(f_1^2=f_2^2=\delta^2=0\) and
\(f_1f_2=f_1\delta=f_2\delta=1\) give an intersection matrix
of determinant two, so these three classes are numerically independent.

### 4.1. A line-bundle identity and positive definiteness

For integers \(a,b\), let
\(\rho_{a,b}(P,Q)=[a]P-[b]Q\).
In \(\operatorname{Pic}(X)\) one has
\[
 \rho_{a,b}^*\mathcal O_E(O)
   \sim (a^2-ab)f_1+(b^2-ab)f_2+ab\delta.                 \tag{4.2}
\]
Here is a derivation that also rules out a hidden \(\operatorname{Pic}^0\)
error in this formula. Let \(q(a,b)\) denote the left side as a Picard
class. Pulling back the cube identity [AV, Corollary 6.4] says that
\[
 q(x+y+z)-q(x+y)-q(x+z)-q(y+z)+q(x)+q(y)+q(z)=0.
\]
Since \(q(0)=0\), the cross term \(q(x+y)-q(x)-q(y)\) is bilinear.
Symmetry of \(\mathcal O_E(O)\), together with [AV, Corollary 6.6],
gives \(q(nx)=n^2q(x)\). Finally
\(q(1,0)=f_1\), \(q(0,1)=f_2\), and \(q(1,1)=\delta\).
These facts give (4.2) as an actual line-bundle equivalence.

Suppose now that \(D\) is an integral divisor in the span and
\[
                 Q(D)=\begin{pmatrix}a&c\\c&b\end{pmatrix}
\]
is positive definite. Then \(a>0\) and
\(\Delta=ab-c^2>0\) are integers. The morphism
\[
       \psi(P,Q)=(P+[c]Q,[a]Q)
\]
is finite surjective, even if \(13\mid a\): it is a group
automorphism followed by the finite surjective map
\(\operatorname{id}\times[a]\).
Applying (4.2) to its two coordinates and their difference gives
\[
 Q(\psi^*D)=
 \begin{pmatrix}1&0\\-c&a\end{pmatrix}
 Q(D)
 \begin{pmatrix}1&-c\\0&a\end{pmatrix}
       =\begin{pmatrix}a&0\\0&a\Delta\end{pmatrix},
\]
and, as line bundles,
\[
                     \psi^*D\sim a f_1+a\Delta f_2.
                                                        \tag{4.3}
\]
This is ample: both elliptic factors have positive degree.
Indeed \(\mathcal O_E(3O)=\mathcal O_E(1)\) for the displayed plane
cubic, so a positive multiple of \(O\) is ample directly from the
definition. Ampleness descends along \(\psi\) by [S, 0B5V].
Thus every integral positive-definite class in (4.1) is ample.
The same holds for rational classes after clearing denominators.

### 4.2. Necessity and the closed cone

Every effective divisor on an abelian variety is nef. To see this
directly, fix an integral curve and translate the divisor so that it
does not contain that curve. Its intersection with the curve is
then nonnegative. Translation preserves the intersection number:
the translated line bundles belong to the connected family obtained
by pulling back along the addition morphism, and degree on the
fixed curve is constant in that family by [AV, Theorem 4.2(b)].
Limits of effective classes
are consequently nef as well.

For any integers \(r,t\), not both zero, the map
\[
       E\longrightarrow X,\qquad P\longmapsto([r]P,[-t]P)
\]
is finite onto a curve. Restricting \(D\) to this map gives degree
\[
       \alpha r^2+\beta t^2+\gamma(r+t)^2
          =(r,t)\,Q(D)\,(r,t)^{\mathsf T}.                 \tag{4.4}
\]
The degree formula \(\deg[n]=n^2\) holds also for inseparable
multiplication maps by [AV, Theorem 8.2]. Nefness forces (4.4) to
be nonnegative for every such pair. Density of rational vectors
therefore forces \(Q(D)\) to be positive semidefinite.

Conversely any positive-semidefinite real matrix in this
three-dimensional span is a limit of rational positive-definite
matrices. By Section 4.1 the latter are ample rational divisor
classes. A positive integral multiple of each has a nonzero
section, so these classes are effective rational classes. Their
limit is pseudo-effective and nef. We have proved
\[
 \overline{\operatorname{Eff}}(X)\cap
          \operatorname{span}_{\mathbb R}(f_1,f_2,\delta)
 =\operatorname{Nef}(X)\cap
          \operatorname{span}_{\mathbb R}(f_1,f_2,\delta)
 =\{D:Q(D)\succeq0\}.                                    \tag{4.5}
\]
Positive-definite classes are ample, including real classes by
openness and rational approximation in the ample cone.
Nothing in the proof uses \(\operatorname{End}_{\bar k}(E)=\mathbb Z\).

The same argument computes the pseudo-effective threshold if
effectivity is required over \(k\), rather than over \(\bar k\):
the approximating rational ample classes are defined over \(k\);
their sufficiently high multiples have \(k\)-sections. Thus there
is no change of ground field hidden in the threshold.

## 5. Cohomology, the exact third Veronese, and the section ring

### 5.1. The vanishing required here

Every line bundle represented by an integral combination of
\(f_1,f_2,\delta\) is symmetric. For an ample such bundle
\(\mathcal B\), one has
\[
                        H^i(X,\mathcal B)=0\quad(i>0).
                                                        \tag{5.1}
\]
A short proof suffices instead of assuming general abelian
vanishing. For arbitrarily large \(N=2^j\), the map \([N]\) is
finite étale of degree \(N^4\), prime to 13. Its unit map followed
by the trace is multiplication by this invertible degree.
Consequently \(\mathcal O_X\) is a direct summand of
\([N]_*\mathcal O_X\). Tensoring with \(\mathcal B\) and taking
cohomology makes \(H^i(X,\mathcal B)\) a direct summand of
\[
 H^i(X,[N]^*\mathcal B)
       =H^i(X,\mathcal B^{\otimes N^2}).
\]
This last group is zero for large \(N\) by Serre vanishing
[S, 0B5T(4)]. This proves (5.1), over \(k\) as well as over \(\bar k\).

Both \(M\) and \(L-M=3f_1+6\delta\) are ample and globally
generated. For \(M\) use the two degree-three plane embeddings.
For \(L-M\), the automorphism
\((P,Q)\mapsto(P,P-Q)\) identifies its line bundle with
\(\mathcal O_E(3O)\boxtimes\mathcal O_E(6O)\).
Thus \(L=M+(L-M)\), and then \(A_0=f^*L\), are ample and
globally generated.

For every integer \(n\geq1\), the divisors \(nL\) and
\[
                    nL-M=(n-1)L+(L-M)
\]
are ample and symmetric. The finite pushforward (3.1) and the
projection formula therefore give
\[
 H^i(W,nA_0)
    =H^i(X,nL)\oplus H^i(X,nL-M)=0\quad(i>0).             \tag{5.2}
\]

### 5.2. An explicit multiplication proof

Write \(S^{(0)}_n=H^0(W,nA_0)\). Because \(k\) is infinite and
\(A_0\) is globally generated on a surface, choose three sections
\(s_0,s_1,s_2\) with no common zero. More explicitly, choose \(s_0\)
nonzero, choose \(s_1\) avoiding the finitely many components of its
zero divisor, and choose \(s_2\) nonvanishing at the finitely many
closed points in their intersection. Each avoidance excludes only
a proper \(k\)-linear subspace of the section space; this works
also at non-rational or inseparable closed points.

The Koszul complex of these sections is exact because locally one
section is a unit. Twisting it by \((n+1)A_0\) gives
\[
 0\longrightarrow (n-2)A_0
 \longrightarrow ((n-1)A_0)^{\oplus3}
 \longrightarrow (nA_0)^{\oplus3}
 \longrightarrow (n+1)A_0\longrightarrow0.
\]
For \(n\geq3\), the two groups
\(H^2(W,(n-2)A_0)\) and \(H^1(W,(n-1)A_0)\) vanish by (5.2).
Splitting the complex into two short exact sequences proves
surjectivity of its last multiplication map on global sections.
In particular,
\[
                 S^{(0)}_n S^{(0)}_1=S^{(0)}_{n+1}
                         \qquad(n\geq3).                 \tag{5.3}
\]
Here products of spaces mean the spans of products of sections.
Iterating gives
\[
 S^{(0)}_{3j}=S^{(0)}_3(S^{(0)}_1)^{3j-3}
                   =(S^{(0)}_3)^j\qquad(j\geq1):
\]
for the second equality group the \(3j-3\) degree-one factors into
triples, each of which lies in \(S^{(0)}_3\); the reverse inclusion
is automatic. Hence the **specified** third Veronese
\[
                          S=(S^{(0)})^{(3)}
\]
is generated by \(S_1\). No unspecified replacement polarization
is being used.

The full-section-ring qualification also proves that \(A\) is
very ample. For a nonzero section \(a\in H^0(W,A)\), \(W_a\) is
affine: a sufficiently high power of \(A\) is very ample, and
\(W_a=W_{a^d}\) is its hyperplane-complement affine chart. By
[S, 01PW],
\[
                         \Gamma(W_a,\mathcal O_W)=S_{(a)}.
                                                        \tag{5.4}
\]
The sections of \(A\) cover \(W\), and the degree-one elements
cover \(\operatorname{Proj}S\), since \(S\) is standard graded.
Thus (5.4) identifies \(W\) with \(\operatorname{Proj}S\) and
identifies \(A\) with \(\mathcal O_{\operatorname{Proj}S}(1)\).
The surjection \(\operatorname{Sym}_k(S_1)\to S\) now gives the
closed immersion defined by the complete system \(|A|\).

### 5.3. Normality, dimension, F-finiteness, and the generator number

Finite-dimensionality of \(S_1\) and Section 5.2 prove finite
generation of \(S\). Its degree-zero field is \(k\), since \(W\)
is proper and geometrically integral.

Here is a direct normality argument. Fix the actual Cartier
divisor \(A\) and embed the section ring into \(k(W)[T]\) by
writing its degree-\(n\) elements as \(f_nT^n\), with
\(\operatorname{div}(f_n)+nA\geq0\). For each prime divisor \(D\)
on the normal variety \(W\), let \(a_D\) be the coefficient of
\(A\), and extend its valuation to the Gauss valuation
\[
 v_D'\!\left(\sum f_nT^n\right)
                  =\min_n\{\operatorname{ord}_D(f_n)+na_D\}.
\]
Regularity of a rational section of a line bundle on a normal
variety is detected in codimension one [S, 0AVB]. Consequently
\[
 S=k(W)[T]\ \cap\!
            \bigcap_{D\subset W\ {\rm prime\ divisor}}\mathcal O_{v_D'}
             \quad\text{inside }k(W)(T).
                                                        \tag{5.5}
\]
The polynomial ring and all valuation rings in this intersection
are integrally closed. Thus \(S\) is a normal domain.

For \(0\ne a\in S_1\), its localization is
\[
                         S[a^{-1}]=S_{(a)}[a,a^{-1}],
                                                        \tag{5.6}
\]
with \(a\) a Laurent indeterminate over the degree-zero ring.
Equations (5.4)–(5.6) give
\(\operatorname{trdeg}_k\operatorname{Frac}S=2+1=3\).
The vertex has height three: a curve and a closed point on the
projective surface give a chain of homogeneous primes
\((0)\subsetneq P_{\rm curve}\subsetneq P_{\rm point}
\subsetneq\mathfrak n\).
Therefore \(\dim R=3\).

The monomials \(u^iv^jw^az^b\), \(0\leq i,j,a,b<13\), form a
basis of \(k\) over \(k^{13}\). In particular
\([k:k^{13}]=13^4\). A polynomial ring over \(k\) is finite over
its Frobenius image: use this basis together with monomials of
exponents less than 13 in its polynomial variables. Quotients
and localizations preserve this finite-generation statement.
Thus \(S\) and \(R\) are F-finite. The ring \(R\) is a normal
local domain essentially of finite type over \(k\).

Finally the intersection numbers
\[
 L^2=144,\qquad L\cdot M=63,\qquad M^2=18
\]
follow from \(f_1^2=f_2^2=\delta^2=0\) and the three distinct
pairwise intersections being one. Applying (5.1), (3.1), and
[AV, Theorem 13.3(b)] gives the exact, already prescribed count
\[
 \begin{split}
 \dim_k S_1
 &=h^0(X,3L)+h^0(X,3L-M)\\
 &=\frac{(3L)^2}{2}+\frac{(3L-M)^2}{2}
   =648+468=1116.
 \end{split}                                               \tag{5.7}
\]
Standard grading gives
\(\mathfrak n/\mathfrak n^2=S_1\).
Localization at \(\mathfrak n\) does not change this vector
space, since elements outside \(\mathfrak n\) act through their
nonzero constant terms. Nakayama's lemma therefore gives
\[
                            \mu(\mathfrak m)=1116.
\]

## 6. The actual blowup and the local non-Q-Gorenstein obstruction

### 6.1. Blowup charts and canonical divisors

Use degree-one generators \(a_i\) of \(S\). By [S, 0804], the
chart of \(\operatorname{Bl}_{\mathfrak n}C\) corresponding to
\(a=a_i\) has coordinate ring \(S[\mathfrak n/a]\).
Because the grading is standard, the ratios \(a_j/a\) generate
\(S_{(a)}\), and
\[
                      S[\mathfrak n/a]=S_{(a)}[a].
                                                        \tag{6.1}
\]
Here \(a\) is an ordinary polynomial fibre coordinate; its
algebraic independence follows from the grading. On overlaps
the fibre coordinates transform by \(a_i/a_j\). These are
exactly the transition functions for
\[
             \pi:Y=\operatorname{Tot}\mathcal O_W(-A)
                       \longrightarrow C.
                                                        \tag{6.2}
\]
The vertex ideal on each chart is \((a)\), so its inverse image
is the zero section \(W_0\), and
\[
 \mathfrak n\mathcal O_Y=\mathcal O_Y(-W_0)=p^*\mathcal O_W(A).
                                                        \tag{6.3}
\]
The latter is the relative very ample twist of the blowup
[S, 01OF]. The surface \(W\) is smooth, so \(Y\) is smooth,
and (6.1) identifies \(C\setminus\{\mathfrak n\}\) with
\(Y\setminus W_0\), a smooth \(\mathbb G_m\)-bundle over \(W\).

For clarity, the blowup of \(\operatorname{Spec}R\) is the
**base change** \(Y\times_C\operatorname{Spec}R\), by
[S, 0805]. It is regular and has the same entire exceptional
surface \(W\). It should not literally be identified with all
of the global total space \(Y\).

The normal bundle of the zero section and the relative
cotangent sequence give
\[
 \mathcal O_Y(W_0)|_{W_0}=\mathcal O_W(-A),\qquad
 \omega_Y=p^*(\omega_W\otimes\mathcal O_W(A)).
                                                        \tag{6.4}
\]
One can choose compatible canonical **divisors**, not just
classes, as follows. In the rational-coordinate convention of
(5.5), the function \(T\) on \(Y\) satisfies
\[
                    \operatorname{div}_Y(T)=W_0+p^*A.
                                                        \tag{6.5}
\]
Choose a rational two-form \(\omega\) on \(W\) representing
\(K_W\). The rational three-form
\[
                         p^*\omega\wedge dT/T
\]
has divisor \(p^*K_W-W_0\): in a local trivialization of the
line bundle its extra horizontal differential term wedges to
zero. Define \(K_C\) by restriction to the punctured cone and
closure. We obtain compatible representatives
\[
                           K_Y=p^*K_W-W_0.
                                                        \tag{6.6}
\]
All differentials here are relative to \(k\); smoothness makes
this construction valid over the imperfect field as well.

### 6.2. Non-Q-Gorensteinness is at the local vertex

Suppose, to the contrary, that \(R\) were Q-Gorenstein.
Then for some integer \(r>0\), \(rK_C\) is Cartier on an open
neighborhood \(V\) of the vertex. On \(\pi^{-1}V\) the two
Cartier divisors below agree away from the sole exceptional
prime, so for an integer \(b\),
\[
                         \pi^*(rK_C)=rK_Y+bW_0.
                                                        \tag{6.7}
\]
The pullback on the left restricts to a trivial line bundle
on \(W_0\): the morphism \(W_0\to V\) factors through the
\(k\)-rational vertex. Restricting (6.7), using (6.4), gives
\[
                        rK_W+(r-b)A\sim0.
                                                        \tag{6.8}
\]
In particular \(K_W\) would be numerically a rational
multiple of \(A\).

But \(K_W=f^*M\) and \(A=3f^*L\). Pushing forward numerical
divisor classes under the finite flat degree-two map \(f\)
would make \(M\) numerically proportional to \(L\).
This is impossible because
\[
 M\cdot f_1=M\cdot f_2=3,\qquad
 L\cdot f_1=9,\quad L\cdot f_2=12.
\]
Thus \(R\) is not Q-Gorenstein. This argument is local at the
vertex; it does not infer the local conclusion merely from
non-Cartierness somewhere on the affine cone.

## 7. The threshold of this fixed polarization

A finite flat surjective map preserves the pseudo-effective
test for pullback classes. Pullback sends effective divisors
to effective divisors, while pushforward does the same and
satisfies \(f_*f^*D=2D\). By continuity on numerical classes,
\[
 f^*D\text{ is pseudo-effective}
       \quad\Longleftrightarrow\quad
 D\text{ is pseudo-effective}.                            \tag{7.1}
\]
Therefore the required threshold is that for \(3tL-M\) on
\(X\). Its matrix is
\[
 Q(3tL-M)=3\left(
       t\begin{pmatrix}12&6\\6&9\end{pmatrix}-I\right).
\]
By (4.5), it is pseudo-effective precisely when this matrix
is positive semidefinite. The positive definite matrix
\(Q(L)\) has characteristic polynomial \(x^2-21x+72\);
the first \(t\) for which both eigenvalues of \(tQ(L)-I\)
are nonnegative is its smaller eigenvalue's reciprocal.
Equivalently it is the larger root of
\[
                          72t^2-21t+1=0.
\]
Thus, with the prescribed exact arithmetic,
\[
 \inf\{t:tA-K_W\text{ is pseudo-effective}\}
           =\frac{7+\sqrt{17}}{48}=\theta.                \tag{7.2}
\]
For \(t>\theta\) the matrix is positive definite, so the
class is ample, and its finite pullback is ample. Also
\(K_W=f^*M\) is ample, so truncating the infimum to
\(t\geq0\) makes no difference.

## 8. The prescribed auxiliary systems and boundaries

Fix \(s=h/q>\theta\), where \(h\) is integral,
\(q>0\), and \(13\nmid q\); reduction of the fraction is
not required. Define
\[
 \begin{split}
 C_s&=3h(2f_1+f_2+2\delta)-q\Theta,\\
 D_s&=3hL-qM=3C_s,\\
 P_s&=Q(C_s)
       =\begin{pmatrix}12h-q&6h\\6h&9h-q\end{pmatrix},\\
 T'_s&=\operatorname{tr}P_s=21h-2q.
 \end{split}
\]
Let \(\ell\) be the first integer greater than \(T'_s\)
which is prime to 13, and put \(m=m_s=q\ell\).

### 8.1. The specified integer really suffices

Since \(s>\theta\), \(P_s\) is positive definite. Its
determinant is a positive integer and its trace is a
positive integer. If \(\lambda_1\leq\lambda_2\) are its
eigenvalues, then
\[
 \lambda_1=\frac{\det P_s}{\lambda_2}
          \geq\frac1{\lambda_2}>\frac1{T'_s}.
\]
It follows that \(\ell P_s-I\) is positive definite.
Moreover \(\ell\leq T'_s+2\), since two successive integers
cannot both be divisible by 13. Its positive integral
diagonal entries imply \(T'_s\geq2\); in particular \(m>1\).

Set \(N=\ell D_s\). Both
\[
                 N=3(\ell C_s),\qquad
                 N-M=3(\ell C_s-\Theta)                 \tag{8.1}
\]
are triples of ample integral divisors by Section 4.
The abelian third-power theorem [AV, Remark 7.3] therefore
makes \(\mathcal O_X(N)\) and \(\mathcal O_X(N-M)\)
very ample. No asymptotic choice of \(\ell\) is used.

### 8.2. Why the pullback is very ample, including at ramification

For this double cover, the following elementary criterion
is sufficient: if \(\mathcal N\) is very ample on \(X\)
and \(\mathcal N(-M)\) is globally generated, then
\(f^*\mathcal N\) is very ample.

Here is an affine-chart proof. For a section
\(a\in H^0(X,\mathcal N)\), let \(U=X_a\).
Since \(\mathcal N\) is very ample, \(U\) is affine and
its coordinate ring is generated by the ratios of its
global sections to \(a\).
On \(U\), the sections \(b_j/a\), for a generating space
\(b_j\in H^0(X,\mathcal N(-M))\), generate
\(\mathcal O_X(-M)|_U\). Since \(U\) is affine, they also
generate its module of global sections. By (3.1) the
coordinate algebra of \(f^{-1}U\) is consequently generated
by the invariant ratios and the anti-invariant elements
represented by \(b_j/a\).
These are exactly ratios of global sections in
\[
 H^0(W,f^*\mathcal N)
    =H^0(X,\mathcal N)\oplus H^0(X,\mathcal N(-M))
\]
to the invariant section \(a\).
Thus the complete linear system gives a closed immersion
on each of these affine target charts. They cover its
image, and the morphism is proper, so it is a closed
immersion globally. The algebra argument includes the
nonreduced length-two fibres above the branch divisor; it
does not merely separate the two points of an étale fibre.

Apply this criterion to (8.1). With the representative
\(K_W=f^*M\), we have the actual line-bundle identity
\[
                 m(sA-K_W)=f^*(\ell D_s)=f^*N.
                                                        \tag{8.2}
\]
This line bundle is therefore very ample. Also \(mA\)
is very ample, since \(A\) already is.

### 8.3. A smooth member over the fixed imperfect field

Use the full \(k\)-space \(H^0(W,f^*N)\). Its morphism is
a closed immersion and \(W\) is smooth over \(k\).
The hypotheses of [S, Lemma 33.47.3, Tag 0FD6] are
therefore all satisfied. Its conclusion supplies a
nonempty \(k\)-open subset of the affine space of sections
whose members are smooth over their field of definition.

A nonempty open subset of affine space over an infinite
field has a \(k\)-point: its complement is avoided by a
nonzero polynomial, and a nonzero polynomial cannot
vanish on all of \(k^n\). Thus one may choose
\[
                         H_s\in|m(sA-K_W)|
                                                        \tag{8.3}
\]
smooth **over \(k\)**. No extension, perfection, or new
transcendental parameter is introduced. The section can
be chosen nonzero; its zero divisor is nonempty because
a nowhere-vanishing section would trivialize the ample
line bundle (8.2) on a positive-dimensional projective
variety.

Smoothness implies that the geometric components of
\(H_s\) are reduced, smooth, and disjoint. Irreducibility
of \(H_s\) is not needed: all components of
\(\Delta_s=H_s/m\) have coefficient \(1/m<1\), and their
support is SNC.

### 8.4. The cone divisor, its exact index bound, and its coefficient

Let \(U=C\setminus\{\mathfrak n\}\simeq Y\setminus W_0\).
Take the inverse image of \(H_s\) under \(p|_U:U\to W\),
and let \(Z_s\) be its closure as an effective Weil
divisor on \(C\). Define
\[
                        \Gamma_s=\frac1m Z_s.
\]
Its strict transform is exactly
\[
                        \Gamma_{s,Y}=\frac1m p^*H_s.
                                                        \tag{8.4}
\]
In particular it has no \(W_0\) component and restricts
on \(W_0\) to \(\Delta_s\).
Locally near an intersection of the two divisors, a
local equation for \(H_s\) on the smooth base and the
fibre coordinate are independent regular parameters.
Thus
\[
                     W_0\cup\operatorname{Supp}\Gamma_{s,Y}
\]
is SNC, with every strict-transform coefficient \(1/m<1\).

Here is an explicit rational-function calculation of
Q-Cartierness and of the coefficient; a cone class-group
criterion is unnecessary. Set
\[
                          d=ms=h\ell\in\mathbb Z.
\]
The linear equivalence \(H_s\sim dA-mK_W\) means that
there is \(g_s\in k(W)^*\) with
\[
                  \operatorname{div}_W(g_s)=mK_W+H_s-dA.
\]
Using the rational coordinate \(T\) of (6.5), form
\(\rho_s=g_sT^d\in k(C)^*\). Equations (6.5) and (6.6)
give the exact identity
\[
 \begin{split}
 \operatorname{div}_Y(\rho_s)
 &=p^*(mK_W+H_s-dA)+d(W_0+p^*A)\\
 &=mK_Y+p^*H_s+(m+d)W_0.
 \end{split}                                               \tag{8.5}
\]
Pushing forward, or just restricting to \(U\) and using
that its complement has codimension three, gives
\[
                 m(K_C+\Gamma_s)=\operatorname{div}_C(\rho_s).
                                                        \tag{8.6}
\]
Hence this multiple is actually principal on the whole
affine cone. In particular the Cartier index divides
\(m=q\ell\) and is prime to 13. Pulling back (8.6) and
dividing (8.5) by \(m\) proves
\[
       \boxed{\ \pi^*(K_C+\Gamma_s)
                 =K_Y+\Gamma_{s,Y}+(s+1)W_0.\ }          \tag{8.7}
\]

One wording in Ajit's Proposition 4.12 is not needed and
should not be carried over: a nonzero cone divisor's
support generally **contains the vertex**. What is true
and required is that its strict transform has no
exceptional component, as (8.4) proves.

## 9. What this certificate does and does not leave open

The candidate-specific geometric eligibility and the
prescribed auxiliary boundary construction are proved
above from the precise standard inputs in Section 2.
There is no remaining endomorphism-specialization
assumption, generic-branch choice, unspecified Veronese,
perfect-ground-field assumption in Bertini, or merely
global argument for the local non-Q-Gorenstein claim.
The auxiliary smooth sections have been proved to exist
over the fixed field, not enumerated as coordinate
polynomials; their individual coefficients are not
needed in this existence argument.

This is not a proof of the proposed full-big-test-ideal
jump. The separate test-ideal obligations are outside
this certificate, and no counterexample is accepted by
these geometric conclusions alone.
