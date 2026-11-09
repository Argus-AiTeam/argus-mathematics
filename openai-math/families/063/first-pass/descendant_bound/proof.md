# Point descendants from the marked component

## Statement and scope

The following is a geometric proof, not a computation of virtual classes.
The accompanying exact computation checks specified algebraic parts only.
Independent mathematical review of this proof is still required.

**Theorem A (arbitrary embedding version).** Let \(X\) be a smooth connected
complex projective variety such that
\[
             -K_X\cdot C\geq 2
\tag{1}
\]
for every irreducible rational curve \(C\subset X\). Let \(H\) be any very
ample line bundle. Suppose a numerical degree \(\beta\) has a nonconstant
free representative \(f:\mathbb P^1\to X\). Put
\[
       d=-K_X\cdot\beta,\qquad b=H\cdot\beta,\qquad h=d-2 .
\]
Sum invariants over actual classes with this numerical degree, as in the
manuscript. Then
\[
       \left\langle\tau_{d-2}(\mathrm{pt})\right\rangle_\beta
                        \geq b^{-(d-1)} .
\tag{2}
\]
There is no convexity, semisimplicity, or virtual-effectivity hypothesis.
In particular, choosing \(H=-aK_X\) proves precisely
`prop:descendant-bound`, for every permitted multiplier \(a\).
The Fano hypothesis is not needed beyond (1) and the given free map.

The integer \(d\) is at least two: the nonzero differential
\(\mathcal O(2)\to f^*T_X\), together with global generation of \(f^*T_X\),
forces a summand of degree at least two and all other summands to have
nonnegative degree. The integer \(b\) is positive; the construction below
also covers \(b=1\).

More precisely, if the right side of (1) is an integer \(\delta\geq2\),
a boundary stratum with \(u\) branches attached to the marked component
has image dimension at most
\[
                         h-(\delta-1)u .
\tag{3}
\]
This strengthening is a consequence of the same proof, not an additional
hypothesis for the manuscript's proposition.

### Foundations and retrieved prior results

The proof uses the usual characteristic-zero deformation theory of
genus-zero stable maps, their virtual fundamental class and refined
evaluation pullback, cohomology and base change, and rational Chow
localization and proper pushforward for Deligne--Mumford stacks.
These are foundational inputs, not assertions checked by `verify.py`.
The use of localization below requires the virtual class to agree with
the ordinary class on the unobstructed open locus only.
Exact source locations, hypotheses, and the distinction between integral
representable pushforward and rational proper pushforward are in
`literature/foundations.md`. The complete primary texts of Behrend,
Behrend--Fantechi, and Kresch used for these inputs are cached there.

The scoped primary-source retrieval found:

* Mustata--Mustata, *Intermediate moduli spaces of stable maps*,
  arXiv:math/0409569v4, Definition 1.2 and Proposition 1.3, constructs
  the one-mark intermediate contractions for projective-space maps.
  The pointed endpoint is \(k=1\), not the graph-space endpoint \(k=0\).
  Basepoints at the marking are excluded. The proof of Lemma 3.3
  identifies the cotangent class and the fiber weights used below.
* Mustata--Mustata, *The Chow ring of
  \(\overline M_{0,m}(\mathbb P^N,b)\)*, arXiv:math/0507464v5,
  Proposition 1.7, gives a proper fine Deligne--Mumford stack for the
  relevant weighted stable-map problem, smooth in genus zero, in
  characteristic zero (also in characteristic greater than \(b\)).
  It does not assert the virtual pushforward positivity for arbitrary
  \(X\).

The retrieved results support the ambient contraction; neither of these
propositions states (2). The construction below is supplied explicitly
so that no compatibility of an \(X\)-valued virtual class with an
intermediate-space virtual class is being inferred from these sources.
A narrowly scoped prior-art search located neither the numerical bound
(2) nor a counterexample. That is not a verified novelty claim.
The supplied project Wiki index had no relevant descendant/Mukai entry.
No previously retired route was present in the campaign's claim ledger.
Checking numerical consequences alone would not prove this theorem.

## 1. The very general point and the unobstructed open locus

For each projective degree, the morphism scheme
\(\operatorname{Mor}(\mathbb P^1,X)\) is of finite type. Its nonfree
locus is constructible, for example by upper semicontinuity of
\(h^1(f^*T_X(-1))\), and can be stratified into finitely many smooth,
reduced, irreducible locally closed strata. Over all degrees there are
countably many such strata.

No such stratum \(T\) evaluates dominantly onto \(X\).
Otherwise generic smoothness of
\(\mathbb P^1\times T\to X\) supplies a point with surjective
differential. Its image is contained in the evaluation image of
\(H^0(\mathbb P^1,f^*T_X)\): motion of the source point is also
obtained from global infinitesimal automorphisms of \(\mathbb P^1\).
Writing \(f^*T_X=\bigoplus\mathcal O(a_i)\), surjective evaluation
at even one point implies every \(a_i\geq0\). This contradicts
nonfreeness.

Choose \(x\) outside the countably many proper closed evaluation-image
closures. Also choose it in the nonempty open evaluation image of the
given free-map component. The latter image is open because
\(H^1(f^*T_X(-p))=0\), so evaluation is smooth there.
Such an \(x\) exists over \(\mathbb C\). Every nonconstant rational map
through this \(x\), including a special or multiply covered one, is free.

Let
\[
 F=\operatorname{ev}^{-1}(x)\subset\overline{\mathcal M}_{0,1}(X,\beta),
 \qquad U=\{[f]\in F:\text{the source is irreducible}\}.
\]
The numerical-degree convention is legitimate: fixed \(H\)-degree
stable maps form a proper finite-type stack, and actual classes and
numerical degrees are locally constant. Thus only finitely many actual
classes occur.
The stack \(U\) is nonempty and smooth, pure of dimension \(h\).
Since \(x\hookrightarrow X\) is a regular embedding of codimension \(n\),
the refined class
\[
 [F]^{\rm vir}:=x^![\overline{\mathcal M}_{0,1}(X,\beta)]^{\rm vir}
                                      \in A_h(F)_{\mathbb Q}
\]
is defined even if the rest of the fiber is obstructed or
larger-dimensional. It satisfies
\[
                    [F]^{\rm vir}|_U=[U]\quad\text{in }A_h(U)_{\mathbb Q}.
\tag{4}
\]
This follows from the vanishing of both \(H^1(f^*T_X)\) and
\(H^1(f^*T_X(-p))\). No assertion about unobstructedness on \(F-U\)
has been made.

## 2. A contraction in families, including non-flat base changes

Embed \(X\) by \(H\) and work first on the smooth ambient stack
\[
                   B=\overline{\mathcal M}_{0,1}(\mathbb P^N,b).
\]
Write \(\pi:\mathcal C\to B\), \(s\), and \(\mathcal L\) for its
universal curve, marking, and map line bundle.
Convexity is used here for \(\mathbb P^N\), not for \(X\).
Normalization on a tree and global generation of \(T_{\mathbb P^N}\)
give \(H^1(C,f^*T_{\mathbb P^N})=0\). Hence deformations of the
domain, including its independent node smoothings, lift to maps.
The universal curve is regular and its nodal charts are \(uv=t\),
with \(t\) an independent smoothing parameter.

At a node orient the dual tree away from the component containing \(s\).
For \(1\leq e<b\), define \(\Delta_e\) on \(\mathcal C\) as the sum
of the unmarked-side divisors over all boundary branches whose
unmarked subtree has projective degree \(e\).
This can equivalently be defined by taking the codimension-one closures
of those unmarked sides and adding their prime divisors. Regularity
makes the resulting Weil divisor Cartier. On a node-smoothing chart its
local branches are the unmarked-side Cartier divisors. Permuting
equal-degree branches preserves their sum, so this definition descends
from the charts, including charts where several such branches meet.

There is no unmarked subtree of degree zero: a finite contracted tree
without markings and with only one external attachment has an unstable
leaf. There is also no unmarked subtree of degree \(b\). Its complement
would be a contracted tree with one marking and one external
attachment; if it had \(v>0\) vertices its total number of special
points would be \(2(v-1)+2=2v<3v\), violating stability.

On the regular ambient universal curve form
\[
       \mathcal L^+
          =\mathcal L\left(\sum_{e=1}^{b-1}e\Delta_e\right)
\tag{5}
\]
with its canonical homomorphism \(\mathcal L\to\mathcal L^+\).
It is this line bundle and homomorphism that are pulled back to an
arbitrary test family. There is no need to assert that a pulled-back
boundary divisor is still Cartier or that the pulled-back homomorphism
is injective. This handles test families lying entirely in the
boundary, and nonreduced or non-flat test families as well.

On a geometric fiber let \(m_v\) be the original projective degree of
a vertex, and let \(E_v\) be the total degree below a nonroot vertex.
Twisting by its side divisor subtracts \(E_v\) from that vertex and
adds \(E_v\) to its parent. Thus the new degree at a nonroot vertex is
\[
                    m_v-E_v+\sum_{w\text{ child of }v}E_w=0.
\tag{6}
\]
The new root degree is \(m_0+\sum_wE_w=b\).
This computation includes chains, branching, and contracted vertices.

The line bundle \(\mathcal O_{\mathcal C}(s)\) is fiberwise generated:
on the root it is \(\mathcal O(1)\), and a section extends uniquely as
a constant on each attached tree. It has fiberwise \(h^0=2,h^1=0\).
Cohomology and base change therefore supplies a rank-two bundle and
a morphism
\[
       c:\mathcal C\longrightarrow
       P=\mathbb P_B\bigl(\pi_*\mathcal O_{\mathcal C}(s)\bigr).
\]
On each fiber this is the degree-one map on the root and contracts
every other component. It is an isomorphism on a neighborhood of the
section: near the section both families are smooth curves, its
relative differential is invertible, and its fiber has just one
point there. Equivalently, the usual relative degree-one contraction
is unchanged on the locus away from the contracted trees.
Let \(s'=c(s)\); then \(c^*\mathcal O_P(s')=\mathcal O_{\mathcal C}(s)\).

The line bundle \(\mathcal L^+(-bs)\) has multidegree zero on every
fiber tree. Such a line bundle is trivial on a tree of projective
lines; its \(h^0=1,h^1=0\). Base change and the fiberwise nonvanishing
evaluation give
\[
          \mathcal L^+(-bs)=\pi^*M
\]
for a line bundle \(M\) on \(B\).
Consequently \(\mathcal L^+\) is the pullback of
\(\overline{\mathcal L}=\mathcal O_P(bs')\otimes\pi_P^*M\).
Both bundles of sections have rank \(b+1\); the pullback map between
them is an isomorphism on every fiber and hence on the base.
The original \(N+1\) map sections, followed by (5), therefore descend
to \(N+1\) sections of \(\overline{\mathcal L}\) on \(P\).

On the root, these are the original sections multiplied by a common
factor with a zero of exact order \(E_w\) at each attachment.
The order is exact because the original sections have no common zero.
They have no common zero at \(s'\).
All steps were constructed on \(B\) and commute with base change.
In particular, they apply to \(F\), without an obstruction or
regularity assumption on stable-map spaces for \(X\).

## 3. The quotient, the cotangent sign, and stabilizers

Choose coordinates with \(x=[1:0:\cdots:0]\).
Locally trivialize the contracted pointed projective-line bundle,
put its section at infinity, and write its sections as polynomials.
Normalize the leading coefficient vector to \((1,0,\ldots,0)\).
There is a unique translation of the affine coordinate eliminating
the coefficient of \(z^{b-1}\) in the first polynomial: that
coefficient changes by \(bt\). Division by \(b\) is legitimate in
characteristic zero. After this normalization the only coordinate
freedom is scaling.

The remaining coefficients have weights
\[
             1^N,\quad 2^{N+1},\quad\ldots,\quad b^{N+1}.
\tag{7}
\]
For \(b=1\) the list consists just of \(N\) weight-one coordinates.
The tuple is nonzero. A zero tuple would be
\((z^b,0,\ldots,0)\): the root map would be constant and all degree
would be at one attachment. A constant root with the marking must
instead have at least two distinct attachments. Each attachment
has positive degree by the stability argument in Section 2.
A nonconstant root plainly cannot give this tuple either.

Normalized coefficient charts therefore glue to a morphism
\[
       \Phi:F\longrightarrow
       W=[(\mathbb A^M-\{0\})/\mathbb G_m]
\tag{8}
\]
for the positive weights (7). This is a separated proper
Deligne--Mumford weighted projective stack; \(\Phi\) is proper since
\(F\) is proper and \(W\) is separated. No representability assertion
about \(\Phi\) at the boundary is needed.

Here is the line-bundle sign, including its descent convention.
Precomposition by \(z\mapsto\lambda z\), followed by leading-term
normalization, multiplies a coefficient of \(z^{b-j}\) by
\(\lambda^{-j}\). The induced pullback of a cotangent at infinity,
written \(d(1/z)\), is multiplication by \(\lambda^{-1}\).
Replacing the group parameter by \(t=\lambda^{-1}\) gives positive
coefficient weights \(j\) and cotangent weight \(+1\).
The character \(t\mapsto t\) defines \(\mathcal O_W(1)\), as can
also be seen because a weight-\(j\) coordinate is a section of
\(\mathcal O_W(j)\). Since \(c\) is an isomorphism near the mark,
\[
             \mathbb L_F=\Phi^*\mathcal O_W(1),
             \qquad \psi=\Phi^*\xi,\quad \xi=c_1(\mathcal O_W(1)).
\tag{9}
\]
This is an identification of line bundles in families, not just of
their degrees.

On the basepoint-free locus a normalized tuple recovers the pointed
map, with no tails forgotten. Conversely, every tail produces a
common zero of positive order, so the inverse image of the
basepoint-free locus is exactly \(U\). The condition that it factor through
the closed embedding \(X\) is closed in that locus; numerical degree
is locally constant. Thus (8) identifies \(U\) with its locally
closed image **as stacks**. In detail, an automorphism of a pointed
smooth source is affine in \(z\); preservation of the centered first
polynomial forces its translation part to be zero. Its scaling
preserves the coefficients precisely when it preserves the map.
The two stabilizer groups are consequently identical, including for
multiple covers. The generic stack degree on each component of \(U\)
is one. A coarse-space degree assertion alone would not suffice.

## 4. A dimension estimate that does not involve the tail spaces

Fix a boundary combinatorial type in \(F\). Let \(u\geq1\) be the
number of trees attached directly to the root, \(d_0\) its
anticanonical degree, and \(d_1,\ldots,d_u\) the anticanonical
degrees of these trees. Its image under (8) remembers only the root
map, the \(u+1\) special points on it, and the projective degrees
of the trees. The maps, moduli, and automorphisms inside those
trees do not enter the coefficient tuple.

If \(d_0>0\), the root map through \(x\) is free. Its parametrized
map space has dimension \(n+d_0\), and its evaluation with a varying
marked point is smooth onto \(X\). Adding the \(u+1\) distinct
points, imposing evaluation \(x\), and quotienting by the
three-dimensional source automorphism group gives
\[
                   n+d_0+(u+1)-n-3=d_0+u-2 .
\tag{10}
\]
This bounds the image dimension even if not all choices admit the
prescribed attached maps.
If \(d_0=0\), the root map is the constant \(x\), stability gives
\(u\geq2\), and its data have dimension
\(\dim M_{0,u+1}=u-2\), again (10).
Ordering attachments or forgetting that order changes no dimension.

Each attached tree contains a nonconstant component. Under the
stronger rational-degree hypothesis \(-K_X\cdot C\geq\delta\),
including covering multiplicities gives
\[
 d-d_0=\sum_i d_i\geq\delta u,\qquad
 d_0+u-2\leq h-(\delta-1)u<h .
\tag{11}
\]
There are finitely many types: their total projective degree is \(b\),
so the number of positive-degree vertices is bounded, and stability
bounds the number of degree-zero vertices. Hence
\[
                         \dim\Phi(F-U)<h .
\tag{12}
\]
No dimension, smoothness, or effectivity statement about the tail
map spaces is being used. For \(h=0\), (12) says the boundary is
empty, which also follows directly from (11).

## 5. Virtual Chow localization

Let \(Z_\alpha\) be the closures in \(F\) of the finitely many
irreducible components \(U_\alpha\) of \(U\). All have dimension \(h\).
By (4) and the localization exact sequence
\[
             A_h(F-U)_{\mathbb Q}\longrightarrow A_h(F)_{\mathbb Q}
                    \longrightarrow A_h(U)_{\mathbb Q}\longrightarrow0,
\]
there is a class \(\eta\) on \(F-U\) such that
\[
                [F]^{\rm vir}-\sum_\alpha[Z_\alpha]=i_*\eta .
\]
Every \(h\)-cycle representing \(\eta\) has image dimension less
than \(h\), by (12), so its proper pushforward is zero.
Using the generic stack degree in Section 3 gives
\[
         \Phi_*[F]^{\rm vir}
                     =\sum_\alpha[\overline{\Phi(U_\alpha)}] .
\tag{13}
\]
This is a nonempty effective \(h\)-cycle. The argument does not
assume effectivity of \([F]^{\rm vir}\), and it never compares
virtual classes for \(X\) and for the intermediate projective-space
moduli problem.

For clarity, the rational proper pushforward here need not be taken
from an integral representable-only theory. If \(S_c,T_c\) are the
coarse spaces of separated Deligne--Mumford stacks \(S,T\), rational
coarse-moduli comparison identifies their Chow groups with those of
the stacks. For a proper \(f:S\to T\), transport the ordinary proper
pushforward \(f_{c*}\) through these comparisons. At an integral
generic cycle the comparison sends \([A]\) to
\([A_c]/|I_A|\), so the coefficient for an equal-dimensional image
is
\[
                  [k(A_c):k(f(A)_c)]\,|I_{f(A)}|/|I_A|.
\]
It is zero when image dimension drops. This proves the cycle rule
used in (13). The projection formula needed here reduces to its
coarse-space version: on \(W\), \(\mathcal O(m)\) descends to an
ample line bundle on its coarse space when \(m\) is a common multiple
of all the weights, and \(c_1(\mathcal O(1))=c_1(\mathcal O(m))/m\)
in rational operational Chow groups.

## 6. The weighted degree, with the generic gerbe factor

**Lemma.** If the positive weights of a weighted projective stack
are at most \(b\), every nonempty integral closed \(h\)-substack
\(Z\) has
\[
                     \int_Z c_1(\mathcal O(1))^h\geq b^{-(h+1)} .
\tag{14}
\]

Take the invariant affine cone of \(Z\), and a monomial initial
ideal of its weight-homogeneous defining ideal. Groebner
degeneration is flat and preserves the weighted grading. Removing
the origin and taking the \(\mathbb G_m\) quotient gives a flat
family in the fixed proper weighted projective stack. Its degree
is constant. The top-dimensional cycle of the monomial fiber is a
nonempty positive integral sum of coordinate weighted projective
substacks; embedded lower-dimensional components do not affect it.
One can see the required flatness degree by degree: use an integral
cost vector realizing the leading terms of a finite Groebner basis
and homogenize in a new parameter. The standard monomials form a
free basis over the parameter ring in each weighted degree. The
construction commutes with the grading action, and a monomial
prime is generated by a subset of the coordinate variables.

For one such component \(P(w_0,\ldots,w_h)\), consider the morphism
\[
 \mathbb P^h\longrightarrow P(w_0,\ldots,w_h),\qquad
 [x_0:\cdots:x_h]\longmapsto[x_0^{w_0}:\cdots:x_h^{w_h}] .
\tag{15}
\]
It is defined by the line bundle \(\mathcal O_{\mathbb P^h}(1)\)
and these sections of its powers; thus it pulls back \(\mathcal O(1)\)
to \(\mathcal O(1)\). It is representable (the source has trivial
stabilizers), proper, and quasi-finite, hence finite.
If \(g=\gcd(w_0,\ldots,w_h)\), its coarse torus degree is
\(\prod_jw_j/g\), while the target's generic stabilizer has order
\(g\). Its **stack degree is therefore \(\prod_jw_j\)**.

For an explicit lattice check of the coarse degree, the quotient
cocharacter lattices are
\(\mathbb Z^{h+1}/\mathbb Z(1,\ldots,1)\) and
\(\mathbb Z^{h+1}/\mathbb Z(w_0/g,\ldots,w_h/g)\).
The diagonal power map has cokernel presented by the matrix
\([\,\operatorname{diag}(w_j)\mid(w_j/g)_j\,]\).
Its maximal minors have gcd \(\prod_jw_j/g\): the diagonal minor
is \(\prod_jw_j\), and replacing any diagonal column by the last
column gives absolute determinant \(\prod_jw_j/g\).
This also handles \(h=0\), where (15) is
\(\operatorname{Spec}\mathbb C\to B\mu_{w_0}\), of degree \(w_0\).
The projection formula now gives
\[
           \int_{P(w_0,\ldots,w_h)}c_1(\mathcal O(1))^h
                            =\frac1{\prod_jw_j}\geq b^{-(h+1)} .
\]
The positive sum in the degeneration proves (14).

## 7. Conclusion and what has not been proved

The definition of the point descendant, (9), (13), and the
projection formula yield
\[
 \left\langle\tau_{d-2}(\mathrm{pt})\right\rangle_\beta
     =\int_{[F]^{\rm vir}}\psi^h
     =\int_{\Phi_*[F]^{\rm vir}}\xi^h
     \geq b^{-(h+1)}=b^{-(d-1)} .
\]
This proves Theorem A and hence the proposition with its actual
quantifiers. It supplies the lower-bound input used in `spectral.tex`;
it does not verify the recurrence, density argument, spectral argument,
alternating-trace argument, equality case, or the Mukai conjecture.

As a calibration, take \(X=\mathbb P^N\), \(H=\mathcal O(1)\), and
ordinary degree \(b\). Here \(h=(N+1)b-2=\dim W\), and basepoint-free
tuples are a nonempty dense open of \(W\). Their stack identification
with \(U\) makes (13) equal to \([W]\). Consequently the argument gives
\[
       \left\langle\tau_{(N+1)b-2}(\mathrm{pt})\right\rangle_b^{\mathbb P^N}
                          =\frac{1}{(b!)^{N+1}} .
\]
The verifier checks this weight product, not an independently
implemented Gromov--Witten calculation. This calibration alone would
not meet the mission's mathematical acceptance criterion.

Relative to the previously retrieved construction, the additional
mathematics here is the complete evaluation-fiber/virtual-Chow argument,
including the strict boundary-image bound, preservation of stack
stabilizers on \(U\), and the generic-gerbe factor in the weighted
degree. The arbitrary-embedding, non-Fano formulation and (3) give
a structural extension. Whether that extension is new or of
publishable significance remains an independent literature/review
question; neither is asserted on the strength of the bounded search.

Run `python3 research/descendant_bound/verify.py` from the campaign root
to replay `exact_certificate.json`. The nine exact check groups include
the retained typed Jacobian Smith certificate, its unimodular relation,
invalid-output rejection, a formal strictly positive boundary-gap
polynomial, and bounded chart/tree/weight/stabilizer tests. The finite
tests are supporting checks; the arguments above, rather than an
extrapolation from those tests, establish the quantified geometry.
