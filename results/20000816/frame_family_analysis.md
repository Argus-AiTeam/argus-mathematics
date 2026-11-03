# Frame families and component selection at length 4803

**Mathematical Engineer analysis, not an independent review.** All assertions
about the Borisov–Keum surface, its conjugate, its projective Hilbert scheme,
and identification of its truncated deformation functor are inputs to this
note. The common arithmetic retraction is also an input, not proved here.
This note does not certify a counterexample.

## Conclusions

1. Jelisiejew's two open immersions do not say that either BB projection is
   smooth. They do not identify a unique component through the frame.
2. There is a useful distinction between the two BB steps. For the present
   square-zero \(y\)-frame, the **fixed-bigraded-point fiber of the
   \(G_y\)-BB step inside the total-homogeneous Hilbert scheme is an affine
   space**, described explicitly below. This does not settle the subsequent
   total-degree-positive BB fiber.
3. In fact, the actual frame with \(n=10,a=4\) is **singular**, conditional
   only on the supplied nonempty projective input. An explicit positive
   tangent of bidegree \((2,-1)\) has no lift from
   \(k[\epsilon]/(\epsilon^2)\) to \(k[\epsilon]/(\epsilon^3)\). There is also
   an explicit flat nodal two-parameter subfamily in its total-positive BB
   fiber. These are not assertions of multiple ambient components.
4. Neither uniqueness of the component through this frame nor generic
   reducedness follows from the cited results or the calculations here.
   A singular point can still lie on a unique generically reduced component.
5. A geometric minimal prime of an explicit border-basis chart through the
   frame selects a genuine full point-Hilbert component. Conjugating that
   prime selects another genuine component, and the two are distinct **if
   the main Engineer's common arithmetic retraction has the stated
   compatibility**. This route needs neither uniqueness nor generic
   reducedness. Section 7 gives the exact algebraic recipe and distinguishes
   it from a computed prime certificate.

## 1. The finite algebra and its dimensions

Work first over a field \(k\) of characteristic zero containing the
coefficients of \(I\). Put

\[
 S=k[x_1,\ldots,x_{10}],\quad R=S/I,\quad
 K_0=I+\mathfrak m_x^5,\quad B=S/K_0,
\]
\[
 M=B^{10}/B(x_1,\ldots,x_{10}),\qquad
 A=T/J=B\oplus M.
\]

The symbol \(e_i\in M\) denotes the class of \(y_i\). In this description
\(M^2=0\), and \(B\) acts on \(M\) in the indicated way. Give \(e_i\)
\(x\)-degree zero and \(y\)-degree one.

The map \(B_{d-1}\longrightarrow B_d^{10}\), \(b\mapsto(x_i b)_i\),
is injective for \(1\leq d\leq4\). Indeed, a kernel element would be a
socle element of \(R\) in degree below the truncation, excluded by
\(\operatorname{depth}R>0\). Thus

\[
\begin{array}{c|rrrrr}
d&0&1&2&3&4\\ \hline
\dim B_d&1&10&55&136&253\\
\dim M_d&10&99&540&1305&2394
\end{array}
\]

and

\[
 \dim A=455+4348=4803.
\]

Equivalently, the total-graded Hilbert function of \(A\) is
\((1,20,154,676,1558,2394)\). Its highest nonzero total degree is five.
The term \(R_5\), which is relevant to perturbing the truncation
generators even though \(B_5=0\), has dimension \(406\).

## 2. What the source actually supplies

Source: Joachim Jelisiejew, *Pathologies on the Hilbert scheme of points*,
arXiv:1812.08531v2, the supplied local `pathologies_v2.txt` and PDF.
Page numbers below are the printed paper pages.

* **Proposition 3.10, page 10:** the depth and dimension hypotheses imply
  TNT. In particular all negative total tangents are translations.
* **Corollaries 3.15–3.16, page 13:** the bidegree \((1,-1)\) tangents,
  and all positive-\(x\)-degree total-zero tangents, are precisely the
  100-dimensional shear-group directions. This does **not** concern
  \((2,-1)\).
* **Corollary 3.17, page 13:** the projective thickening
  \(V(Q,\mathfrak m_y^2)\subset V(Q)\subset\mathbf P^{19}\) is abstractly
  rigid. Its proof computes degree-zero deformation theory of its
  homogeneous coordinate ring. It does not assert rigidity of the
  finite truncation or vanishing of positive-degree affine-cone
  deformations.
* **Definition 4.2 and Lemma 4.3, pages 17–18:** the frame hypotheses apply
  here.
* **Proposition 4.5, page 19:** an open neighborhood of \([J]\) in the
  full point Hilbert scheme is isomorphic to
  \(\mathbb A^{20}\times U_{xy}\), where \(U_{xy}\) is an open neighborhood
  in the total-degree BB attracting scheme.
* **Proposition 4.7, page 19, with Diagram (4.1):** an open neighborhood
  in the total-homogeneous fixed locus is isomorphic to
  \(G\times U_y\), with \(G\simeq\mathbb A^{100}\) and \(U_y\) in the
  \(G_y\)-attracting scheme.
* **Propositions 4.8–4.9, page 19:** the bigraded flag construction
  recovers the \(x\)-only truncation uniquely, and keeping \(Q\) and the
  \(y\)-ideal fixed supplies a section. This is a retraction statement,
  not a smoothness statement.
* **Propositions 1.4 and 4.10, pages 4 and 20:** composing these
  constructions gives the three local retractions.

The classical affine-bundle theorem for BB decompositions quoted in
the introduction assumes the *ambient scheme is smooth*. Applying that
theorem here to prove smoothness would be circular. The table on page 6
explicitly leaves the \((\alpha,-1)\) entries for \(\alpha\geq2\)
uncomputed; the obstruction below occurs in precisely one of these
entries.

The open immersion from TNT does have a useful component consequence:
every component through \([J]\) is elementary, since a whole neighborhood
parameterizes translates of schemes supported at the origin. At length
4803 none of these is the smoothable component.

## 3. An actual affine BB fiber and a large explicit flat family

Fix \(K_0\) and \(Q\). The fiber over their bigraded frame of the
\(G_y\)-BB projection **within the total-homogeneous Hilbert scheme** is

\[
 V=\operatorname{Hom}_S(K_0,M)_{-1}.
 \tag{3.1}
\]

Here the subscript is the change in \(x\)-degree; the corresponding
Hilbert tangent has bidegree \((-1,1)\).

For \(\psi\in V\), use representatives of \(\psi(f)\) linear in the
\(y\)'s and form

\[
 J_\psi=(\,\mathfrak m_y^2,\ Q,\ f-\psi(f):f\in K_0\,).
 \tag{3.2}
\]

It suffices to use any finite homogeneous generating set of \(K_0\).
Changing representatives does not change this ideal.

### Flatness, including arbitrary parameter bases

Take the split square-zero algebra \(S\ltimes M\), where the \(S\)-action
on \(M\) factors through \(B\). The graph

\[
 L_\psi=\{(f,-\psi(f)):f\in K_0\}
\]

is an ideal: this uses \(S\)-linearity of \(\psi\) and \(K_0M=0\).
Its quotient has an exact sequence

\[
 0\longrightarrow M\longrightarrow
 (S\ltimes M)/L_\psi\longrightarrow B\longrightarrow0.
\]

The same construction over the polynomial coordinate ring \(k[V]\)
gives a sequence with the constant free modules \(M\otimes k[V]\) and
\(B\otimes k[V]\). It splits as a sequence of \(k[V]\)-modules, since
the latter module is free. Hence (3.2) is a finite flat family of rank
4803. It is exactly the displayed quotient algebra.

Conversely, a total-homogeneous deformation with this fixed
\(G_y\)-initial ideal cannot change \(\mathfrak m_y^2\): a higher
\(y\)-degree tail would exceed total degree two. Its \(Q\)-lift differs
only by an element of \(\mathfrak m_y^2\), so \(Q\) is unchanged.
Each \(x\)-only generator can change only by a term linear in \(y\),
modulo that ideal. Flatness identifies the \(y\)-layer with \(M\), and
compatibility of the lifts with all \(S\)-syzygies says exactly that
their tails form an \(S\)-linear map \(K_0\to M\).
This proves (3.1) on arbitrary parameter algebras, not merely on
tangent spaces. The family is therefore universal, and in particular
dominant, for **this fiber**.

### A concrete linear subfamily of dimension 971964

There is a canonical subspace

\[
 \operatorname{Hom}_k(R_5,M_4)\ \subseteq\ V.
\]

For \(L:R_5\to M_4\), set \(\psi(I)=0\), use \(L\) on degree-five
truncation generators modulo \(I_5\), and set it zero in higher
degrees. This is \(S\)-linear because \(\mathfrak m_xM_4=0\).
Thus the explicit family

\[
 (I,\mathfrak m_y^2,Q,\ f-L(\bar f):f\in S_5)
 \tag{3.3}
\]

is finite flat of rank 4803 over an affine space of dimension

\[
 406\cdot2394=971964.
\]

This family can be written using a basis of \(R_5\) instead of all of
\(S_5\). Its dimension is not an asserted component dimension.

For completeness, near the original bigraded frame the bigraded data
themselves are just \(K_0\) and a nondegenerate bilinear relation line
\([q]\in\mathbf P(S_1\otimes k^{10})\); \(\mathfrak m_y^2\) is fixed.
The maximal-rank conditions on \(b\mapsto q b\) are open, and the
prescribed bigraded Hilbert function then leaves no additional
generators. If the truncated homogeneous Hilbert neighborhood is the
smooth rigid orbit supplied by the main Engineer, this bigraded
neighborhood is smooth. The associated spaces in (3.1) have constant
rank along that orbit and the nondegenerate \(q\)-orbit, so they form a
vector bundle there. The shear open immersion then gives smoothness
of the *total-homogeneous fixed locus* at \(J\).

Even this stronger intermediate statement does not make the
total-degree-positive BB scheme smooth or irreducible.

## 4. An explicit positive tangent which is obstructed at second order

This construction uses only \(n\geq4\), \(a=4\), and a nonempty
\(\operatorname{Proj}(S/I)\). It therefore applies to the supplied
frame without using any special cubic equations.

Work over \(\mathbb C\). Choose a geometric point of
\(\operatorname{Proj}(S/I)\), and make a linear change in \(x\), with
the dual change in \(y\), so that it is \([1:0:\cdots:0]\). This
preserves \(Q\) and the frame construction. This coordinate change
is only used to prove singularity; it is not used in the arithmetic
component-selection recipe.

For \(r=2,3,4\), define \(B\)-linear forms on \(M\) by

\[
 \ell_r(e_i)=x_1\delta_{ir}-x_r\delta_{i1}.
 \tag{4.1}
\]

They descend from \(B^{10}\) to \(M\), since

\[
 \ell_r\!\left(\sum_i x_i e_i\right)=x_1x_r-x_rx_1=0.
\]

Define symmetric \(B\)-bilinear maps \(M\times M\to M\):

\[
 \mu_1(v,w)=\ell_2(v)\ell_2(w)e_3,
\]
\[
 \mu_2(v,w)=
 \bigl(\ell_3(v)\ell_4(w)+\ell_4(v)\ell_3(w)\bigr)e_3
       +\ell_4(v)\ell_4(w)e_4,
 \qquad \mu=\mu_1+\mu_2.
 \tag{4.2}
\]

Over \(D=\mathbb C[\epsilon]/(\epsilon^2)\), retain the usual
products involving \(B\) and define

\[
 v*w=\epsilon\,\mu(v,w)\quad(v,w\in M).
 \tag{4.3}
\]

This is associative. Mixed products use \(B\)-bilinearity; every
associator with three inputs from \(M\) has a factor \(\epsilon^2\).
The underlying module is the free module \((B\oplus M)\otimes D\).
The elements \(x_i,e_i\) generate it as an algebra. Consequently
(4.3) is an actual embedded first-order flat deformation, represented
by

\[
 (K_0,Q,\ y_i y_j-\epsilon\,\mu(e_i,e_j)).
 \tag{4.4}
\]

For instance, reductions of terms with three \(y\)'s have a factor
\(\epsilon^2\); the relations span the free quotient just described.
The new tails have bidegree \((2,1)\), replacing generators of
bidegree \((0,2)\). This is a tangent of bidegree \((2,-1)\), of
positive total degree one. Its associated total-graded algebra is
unchanged, so it belongs to the total-positive BB fiber over \(J\).

### No embedded flat lift modulo \(\epsilon^3\)

Suppose such a lift existed. Lift the three indicated relations from
(4.4), allowing arbitrary second-order corrections:

\[
\begin{aligned}
 y_2^2&=\epsilon x_1^2y_3+\epsilon^2\nu_{22},\\
 y_2y_4&=\epsilon^2\nu_{24},\\
 y_3y_4&=\epsilon x_1^2y_3+\epsilon^2\nu_{34}.
\end{aligned}
\]

No restriction is placed on the polynomials \(\nu_{ij}\), and all
other defining generators are also allowed to deform at second order.
Associativity, or simply the identity
\((y_2^2)y_4-y_2(y_2y_4)=0\), gives

\[
 \epsilon^2\bigl(x_1^4y_3+\nu_{22}y_4-y_2\nu_{24}\bigr)=0.
\]

Flatness over \(\mathbb C[\epsilon]/(\epsilon^3)\) implies that its
coefficient is zero in the special fiber \(A\). But there is an
algebra homomorphism

\[
 A\longrightarrow \mathbb C[s,z]/(s^5,z^2)
\]

given by \(x_1\mapsto s,\ y_3\mapsto z\), and all other variables
mapping to zero. The ideal \(I\) maps to zero because
\([1:0:\cdots:0]\) lies on its projective zero set. The other frame
relations also map to zero. Under this homomorphism the alleged zero
maps to

\[
 s^4z\neq0.
\]

This is a contradiction. In particular, the point Hilbert scheme is
not smooth at this frame. The argument excludes arbitrary
second-order corrections, not just corrections preserving the
bigrading or the chosen displayed family.

For a smaller example of the failed smoothness implication, take
\(I=0,n=4,a=4\). Its projective input is the rigid smooth Hilbert point
representing all of \(\mathbf P^3\); the same argument makes its
length-315 frame in \(\mathbb A^8\) singular.

## 5. A flat nodal slice, and the limit of what it proves

Each \(\mu_i\) separately is an associative multiplication on \(M\).
For \(\mu_1\), this follows from \(\ell_2(e_3)=0\).
For \(\mu_2\), use the two-dimensional associative algebra with
basis \(b,c\) and products

\[
 b^2=0,\qquad bc=b,\qquad c^2=c.
\]

Writing \(F(v)=(\ell_3(v),\ell_4(v))\) and
\(E(b)=e_3,E(c)=e_4\), one has \(F\circ E=x_1\,\mathrm{id}\) and
\(\mu_2=E\circ(\text{product})\circ(F,F)\). This proves the
associativity identity directly.

On the fixed module \(B\oplus M\) now set

\[
 v*w=u\mu_1(v,w)+v_0\mu_2(v,w).
 \tag{5.1}
\]

The associators have a factor \(uv_0\). Conversely, the associator
on \((e_2,e_2,e_4)\) is

\[
 uv_0\,x_1^4e_3.
\]

The same projection as in Section 4 shows that this vector has a
nonzero coefficient over the ground field. Thus the parameter scheme
of associative products of exactly the form (5.1) is precisely

\[
 \operatorname{Spec}\mathbb C[u,v_0]/(uv_0).
 \tag{5.2}
\]

Over (5.2) the algebra is finite free of rank 4803, and its presentation
is (4.4) with \(\epsilon\mu\) replaced by \(u\mu_1+v_0\mu_2\).
Multiplication strictly raises total degree relative to the original
square-zero products, so the family is in the total-positive BB
fiber. In a quotient-basis chart it is a closed algebra-structure
slice: all multiplication matrices have the displayed linear
dependence on \(u,v_0\); the products \(y_2^2\) and \(y_3y_4\)
recover the two parameters by a linear functional taking
\(x_1^2e_3\) to 1.

**This does not prove that the ambient BB fiber has two irreducible
components.** An irreducible singular variety may contain such a
nodal slice. Nor does the obstructed tangent prove generic
nonreducedness.

In general, BB fibers over a smooth fixed point really can be
reducible: let \(\mathbb G_m\) contract
\(\operatorname{Spec}k[u,v]/(uv)\) to its origin by giving both
coordinates positive contracting weight. The fixed locus is the
smooth point \(\operatorname{Spec}k\), and the attracting fiber is
the entire reducible node. The identical construction with
\(k[u]/(u^2)\) gives a nonreduced fiber. With \(k[u,v,w]/(uv-w^2)\)
it gives an irreducible reduced but singular fiber. A smooth
retraction target therefore decides none of these issues.

## 6. What remains unknown about this particular frame

The established families do not give a family dominant over an
irreducible component of the *full* point Hilbert scheme:

* (3.2) dominates a particular intermediate BB fiber, not the final
  total-positive BB neighborhood.
* (3.3) is an especially explicit subfamily of that intermediate
  fiber.
* (5.2) is a nonlinear slice in the final BB fiber, not a
  component decomposition.

There is no basis here for the assertions “the rigid projective
input has a unique point-Hilbert component above it,” “the frame is
smooth,” or “the component is generically reduced.” The second of
these assertions is actually false by Section 4. Determining the
first or third would require additional information about the
positive-degree deformation equations.

The original component-conjugation strategy does **not** require the
first or third assertion. It can instead select a geometric minimal
prime.

## 7. An explicit border-basis recipe for selecting full components

### 7.1 A common chart, defined over the rationals

Retain the original arithmetic coordinates here. Fix a monomial
order, for example graded lexicographic order with
\(x_1>\cdots>x_{10}>y_1>\cdots>y_{10}\).

Construct a set \(\mathcal O\) by greedily retaining independent
residue monomials, starting with the smallest monomials in this
order. Only the following finite list need be considered:

\[
 \{x^\alpha:|\alpha|\leq4\}\ \cup\
 \{x^\alpha y_j:|\alpha|\leq4,\ 1\leq j\leq10\}.
 \tag{7.1}
\]

Dependence is decided by exact linear algebra over
\(K=\mathbb Q(\sqrt{-7})\), using:

* \(I_d\subset S_d\), obtained from the 84 cubic generators by
  multiplication, for \(d=3,4\);
* \(I_d\otimes\langle y_j\rangle+Q S_{d-1}\) in bidegree \((d,1)\);
* zero relations \(x^5\) and \(y_i y_j\) outside the list.

This describes finite matrices and does not require a large
Groebner-basis calculation. No such matrix reduction is executed in
this note. The result has 4803 elements. The usual greedy argument
for a monomial order shows that it is divisor-closed: a dependence
of a monomial on smaller monomials yields a dependence for each
multiple, because a monomial order is multiplicative.

Conjugation preserves all zero and nonzero determinants of these
matrices. Hence **the same monomial set \(\mathcal O\)** is a quotient
basis for \(J\) and \(\overline J\). This chart construction requires
no compatibility assertion about the retraction.

Write \(z_1,\ldots,z_{20}\) for the \(x,y\) variables and let

\[
 \partial\mathcal O
 =\left(\bigcup_i z_i\mathcal O\right)\setminus\mathcal O.
\]

For every \(b\in\partial\mathcal O,\ m\in\mathcal O\), introduce
an indeterminate \(c_{b,m}\) and a border relation

\[
 g_b=b-\sum_{m\in\mathcal O}c_{b,m}m.
\]

Define the 4803-by-4803 matrices \(Z_i\), indexed by \(\mathcal O\),
as follows. Their column at \(m\) is the appropriate standard unit
vector if \(z_i m\in\mathcal O\), and is
\((c_{z_i m,m'})_{m'\in\mathcal O}\) otherwise. Let

\[
 E=\bigl(\text{entries of }[Z_i,Z_j]:1\leq i<j\leq20\bigr)
       \subset\mathbb Q[c],
 \qquad \mathcal R=\mathbb Q[c]/E.
 \tag{7.2}
\]

This is an explicit finite polynomial presentation, albeit a very
large one. \(\operatorname{Spec}\mathcal R\) is the standard
border-basis open chart in \(\operatorname{Hilb}^{4803}(\mathbb A^{20})\).

To see flatness without an unstated border-basis theorem, commuting
matrices define a \(\mathbb Q[c]/E[z]\)-module with basis
\(\mathcal O\). It is cyclic with generator \(e_1\), since
divisor-closedness gives \(m(Z)e_1=e_m\) for every \(m\in\mathcal O\).
The border relations then present exactly this free module.
Conversely, multiplication in any quotient with basis \(\mathcal O\)
gives these matrices and their commutator equations. Thus the
universal quotient on the chart is finite free of rank 4803.

The frame supplies exact coordinate values
\(c_{b,m}=c^J_{b,m}\in K\) by normal-form linear algebra, and its
conjugate supplies their coefficientwise conjugates.

### 7.2 Select a geometric minimal prime, not an arbitrary prime

Use \(\overline{\mathbb Q}[c]\), rather than merely \(K[c]\).
A prime over \(K\) need not remain irreducible over \(\mathbb C\).
Let

\[
 \mathfrak m_J=(c_{b,m}-c^J_{b,m})
       \subset\overline{\mathbb Q}[c].
\]

The eligible primes are the finite nonempty set

\[
 \mathcal P_J=
 \{\mathfrak p\in\operatorname{Min}(E\overline{\mathbb Q}[c]):
                       \mathfrak p\subseteq\mathfrak m_J\}.
 \tag{7.3}
\]

Here is one completely specified selection rule, if a choice-free
recipe is desired. Fix effective encodings of algebraic numbers,
a term order on the \(c\)'s, and an order on finite encoded lists.
Represent each prime by its unique reduced Groebner basis in that
order and choose the least list among (7.3). Denote the chosen
geometric minimal prime by \(\mathfrak p\). This is a finite
algebraic specification; **it is not a claim that this primary
decomposition or Groebner basis has been computed**.

Set

\[
 C=\overline{\operatorname{Spec}
       (\mathbb C[c]/\mathfrak p\mathbb C[c])}
       ^{\ \operatorname{Hilb}^{4803}(\mathbb A^{20}_{\mathbb C})},
 \qquad
 C^\sigma=\overline{\operatorname{Spec}
       (\mathbb C[c]/\sigma(\mathfrak p)\mathbb C[c])}.
 \tag{7.4}
\]

The minimality condition, and not just primality, makes these
**full irreducible components**. Taking their closures in the
Hilbert scheme does not enlarge them into some different component:
irreducible components of an open chart are the intersections
with precisely the global components meeting that chart.

### 7.3 The resulting genuine dominant family

Put

\[
 D_{\mathfrak p}=\operatorname{Spec}
       (\overline{\mathbb Q}[c]/\mathfrak p).
\]

The border relations \(g_b\) over \(D_{\mathfrak p}\) define a
finite free family of rank 4803. Its classifying map is the inclusion
of the reduced component of the border-basis chart, so it is
dominant onto \(C\) after extending scalars to \(\mathbb C\).
Equivalently, over

\[
 F_{\mathfrak p}
 =\operatorname{Frac}(\overline{\mathbb Q}[c]/\mathfrak p)
\]

the explicit relations \(g_b\) define its generic length-4803 ideal.
Conjugate all coefficients for the second family.

The family remains usable if the ambient component is generically
nonreduced: its reduced structure has the same underlying
irreducible component and generic points of interest. To avoid
all component intersections, for each other minimal prime
\(\mathfrak p'\) choose
\(h_{\mathfrak p'}\in\mathfrak p'\setminus\mathfrak p\), and invert
their finite product. Its image in the domain
\(\overline{\mathbb Q}[c]/\mathfrak p\) is nonzero. This gives a
nonempty dense open avoiding every other component.

### 7.4 Where distinctness uses the main Engineer's result

Assume the main Engineer supplies one common rationally defined
open neighborhood and retraction, containing \(J,\overline J\),
with their images the two given smooth points on distinct
projective Hilbert components. Then the component selected by
(7.3) and its conjugate are distinct.

Indeed, if they were the same component, its nonempty intersection
with that common open would be irreducible and would contain both
frames. Its image under the common retraction would have
irreducible closure containing both smooth projective points.
Any irreducible closed subset through a smooth point belongs to
that point's unique irreducible component. It cannot contain the
second point on a different component.

This paragraph only uses the common-retraction lemma. It does
not construct or certify its rational definition, domains, cutoff
compatibility, or surface identification.

### 7.5 What this does and does not count as

Equations (7.1)–(7.4) provide an exact algebraic **recipe** selecting
actual components and a dominant family over each selected
geometric prime. They remove the unsupported irreducible-fiber
assumption from the component-selection argument.

They are not yet a concrete computed component certificate.
If “actual component data” means displayed generators of a
particular geometric prime, a checked proof of its minimality,
and executable normal forms for its generic ideal, those data
remain to be produced. Merely supplying the 84 cubic equations
and the isolated frame does not supply them. This note neither
performs nor recommends claiming completion of that computation.
If a theorem-level exact component definition by minimal-prime
selection is acceptable, (7.3) supplies one, conditionally on the
input and the common-retraction lemma; no smoothness of the frame
or irreducibility of a BB fiber is needed.

## 8. Small exact identity check

The companion script
`research/certificates/generic_collision/frame_family/verify_identities.py`
uses integer sparse-polynomial arithmetic only. It checks the
length calculations, that (4.1) annihilates the relation \(x\),
that the two multiplications in (4.2) separately satisfy
associativity, and that their sum has the asserted nonzero
second-order associator. Four \(x\)-variables suffice because
all other input indices have zero \(\ell_r\)-values.

Run from this campaign directory:

```sh
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/certificates/generic_collision/frame_family/verify_identities.py
```

The script verifies the universal polynomial identities, not the
surface hypotheses, a prime decomposition of (7.2), or the common
arithmetic retraction. The flatness and obstruction arguments
are the algebraic proofs in Sections 3–5. The displayed invocation
completed successfully with all assertions passing.
