# Universal isotropy for an explicit dyadic Enriques surface

Final research submission for the integral-torsion alternative in
[the Campaign 1138 objective](../../../OBJECTIVE.md).

## Statement and scope

Let \(S=S_{\rm new}\) be the explicit surface defined by equations
(9)--(11) of `../dyadic_theorem.md`. Its independently reviewed smooth
projective model over
\[
 R_0=\mathbf Z[\pi]_{(\pi)},\qquad \pi^2=2,
\]
has
\[
 G=\operatorname{Pic}^{\tau}_{\mathcal S/R_0}
   =\operatorname{Spec}R_0[s]/(s^2-\pi s),\qquad
 \Delta(s)=s\otimes1+1\otimes s-\pi s\otimes s.
 \tag{1}
\]
The generic nonidentity point is the canonical line bundle and the
geometric special fiber is \(\alpha_2\). The surface, its equations,
and its accepted certificates are not changed here.

**Theorem (universal isotropy).** For every smooth projective
connected complex curve \(C\) of genus \(g\geq1\), put
\[
 A_C=\{Z^*\alpha:Z\in\operatorname{CH}_1(C\times S)\}
       \subset H^1(C,\mathbf F_2),
 \tag{2}
\]
where \(\alpha\) is the class of the canonical double cover of \(S\).
Then \(A_C\) is totally isotropic for cup product, and
\[
 \dim_{\mathbf F_2}A_C\leq g,\qquad
 \dim_{\mathbf F_2}D_C=2g-\dim_{\mathbf F_2}A_C\geq g.
 \tag{3}
\]
Here the degree-four integral Hodge defect is
\[
 D_C=
 \operatorname{Hdg}^4(C\times S,\mathbf Z)/
 \operatorname{cl}\bigl(\operatorname{CH}^2(C\times S)\bigr),
\]
where integral Hodge classes include torsion: their images in complex
cohomology have type \((2,2)\).
No good-reduction, arithmetic-definition, or embedding-in-\(S\)
hypothesis is imposed on \(C\). This is an integral torsion statement,
not a counterexample to the smooth rational Hodge conjecture.

## Known inputs and boundaries

The retained inputs are the model (1), the determinant construction in
`../dyadic_theorem.md`, Section 2, and the defect identification of
Benoist--Ottem, Proposition 1.1 and its proof, arXiv:1802.01845v3,
pp. 3--4, published DOI 10.4171/CMH/479.

The following precise inputs were located by `isotropy-primary-sources`
and subsequently checked by the independent Reviewer. The retained
[primary-source readings](../../literature/universal-isotropy-review/primary-excerpts.txt)
give the passages, hypotheses and comparison statements actually inspected.

* Raynaud, *Specialisation du foncteur de Picard* (1970),
  DOI 10.1007/BF02684651, Theorems
  8.1.4 and 8.2.1, pp. 65--67: for a proper regular semistable curve over
  a DVR, the multidegree-zero relative Picard scheme is separated and
  is the identity component of the Jacobian's Neron model.
  Reduced special fibers have geometric multiplicity gcd one.
* SGA 7 I (1972), ISBN 9783540059875, Expose VIII,
  Theorem 7.1(b), pp. 299--300, and
  Expose IX, (1.4.4), pp. 324--325: the Poincare biextension extends
  over identity components. Expose VIII, (2.2.2)--(2.2.5), pp. 237--238,
  and (2.4.1), p. 253, construct the fppf torsion pairing for every
  positive integer \(n\), compatibly with base change. These statements
  include \(n=2\) in residue characteristic two.
* SGA 7 I, Expose VIII, Corollary 3.5 and Remark 3.6, pp. 262--263:
  biextensions of smooth connected semiabelian groups by
  \(\mathbf G_m\) descend through their torus quotients.
  Expose IX, Sections 12.1 and 12.3, describes the special abelian
  quotient as the product of the Jacobians of the normalized components.
* Pries--Ulmer, *Every BT1 group scheme appears in a Jacobian*,
  arXiv:2101.07946v1, Introduction and Sections 2.1--2.4, pp. 1--3:
  over an algebraically closed field of characteristic \(p\),
  \(B[p]\) for an abelian variety is a BT1, satisfying
  \(\ker F=\operatorname{im}V\) and
  \(\operatorname{im}F=\ker V\). These identities include \(p=2\).
* The semistable reduction theorem, including genus one, and regular
  resolution of nodal models: Stacks Project
  [Tag 0CDN](https://stacks.math.columbia.edu/tag/0CDN),
  Theorem 55.18.1, and
  [Tag 0CDE](https://stacks.math.columbia.edu/tag/0CDE),
  Lemma 55.14.3. After any finite extension, the nodal model can again
  be resolved without losing semistability.

The previous theorem proves \(A_E=0\) for the single curve
\(E:y^2+y=x^3\). The statement for every \(C\) is a different
quantitative conclusion, not another example. Benoist--Ottem's Theorem
0.1 gives failure for a very general curve for each fixed Enriques
surface; its Section 3 also gives other Enriques surfaces and elliptic
curves for which the correspondence image is the entire \(H^1\).
Thus the special integral model in (1) cannot be dropped.

Three shortcuts are unavailable. The Neron mapping property cannot be
applied to \(G\), whose special fiber is not smooth. The two-torsion of
a semistable Neron identity component need not be finite flat. Finally,
a curve with transcendental coefficients cannot simply be declared to
descend to a number field. The proof must address all three issues.

## 1. Integral Cartier duality and the good-reduction case

Work over any mixed-characteristic \((0,2)\) DVR \(R\) containing
\(\pi\) with \(\pi^2=2\). All statements in this section survive every
finite extension of \(R\), without a bound on its ramification.

The self-duality of \(G\) in (1) is the explicit Cartier pairing
\[
 \chi:G\times G\longrightarrow\mu_2,\qquad
 \chi(s,t)=1-st.
 \tag{4}
\]
Indeed, over any \(R\)-algebra, a pointed character has the form
\(1-st\); comparing the coefficient of \(s_1s_2\) in its
multiplicativity identity gives \(t^2=\pi t\).
Conversely that equation makes it multiplicative, and
\[
 (1-st)^2=1-2st+s^2t^2=1
\]
shows it is a unit. Multiplication of characters is
\(t+t'-\pi tt'\), giving exactly the Hopf algebra (1).
Thus (4) identifies \(G\) with \(G^D\) integrally.
At the two generic nonidentity points it takes the value
\(1-\pi^2=-1\).

Every bilinear pairing \(G\times G\to\mu_2\) is either trivial or
\(\chi\). In fact it corresponds to a map \(G\to G^D\).
The generic fiber is the constant group of order two, so it has just
the zero homomorphism and the isomorphism furnished by (4).
Flatness of \(G\) and separatedness of \(G^D\) give uniqueness from
the generic fiber. This argument concerns group schemes, not their
geometric points.

Let \(f_1,f_2:G\to\mathcal B[2]\), where \(\mathcal B/R\) is an
abelian scheme with a polarization. Write \(e\) for the corresponding
Weil pairing; it need not be perfect on the whole target for the
argument below. Suppose the generic pairing of the two nonidentity
images is \(-1\). Then
\[
 e(f_1(s),f_2(t))=\chi(s,t).
 \tag{5}
\]
Each self-pullback \(e(f_i(s),f_i(t))\) is trivial: it is trivial on
the split order-two generic fiber by alternation, and \(G\times G\)
is flat. The reversed cross-pairing is the inverse of (5).
Consequently, for \(H=G\times G\) and
\(h(s_1,s_2)=f_1(s_1)+f_2(s_2)\), the pulled-back pairing is
\[
 \beta((s_1,s_2),(t_1,t_2))
     =\chi(s_1,t_2)\chi(s_2,t_1)^{-1}.
 \tag{6}
\]
It is perfect: its map \(H\to H^D\) is the interchange of the two
Cartier-dual factors, with a sign on one factor. The sign is immaterial
on a group killed by two.

For any finite flat group \(M\), any bilinear form
\(b:M\to M^D\), and any \(h:H\to M\) such that
\(h^D b h=\beta^\flat\) is an isomorphism, the formula
\[
 r=(\beta^\flat)^{-1}h^D b:M\longrightarrow H
 \quad\hbox{satisfies}\quad rh=1_H.
 \tag{7}
\]
Thus \(H\) is a direct summand. Applying this with
\(M=\mathcal B[2]\), and then taking the geometric special fiber,
would split
\[
 H_{\bar k}=\alpha_2\times\alpha_2
 \quad\hbox{off}\quad \mathcal B_{\bar k}[2].
 \tag{8}
\]

This is impossible. A direct summand of a BT1 is a BT1, since
Frobenius and Verschiebung respect the product decomposition and
the identities \(\ker F=\operatorname{im}V\),
\(\ker V=\operatorname{im}F\) hold factor by factor. On
\(\alpha_2^2\), both \(F\) and \(V\) are zero; hence these identities
would identify the nonzero group \(\alpha_2^2\) with zero.
Equivalently, if \(i:H_{\bar k}\to M\) and \(r:M\to H_{\bar k}\)
were a retraction, then \(F_Mi=0\) would make \(i\) factor through
\(\ker F_M=\operatorname{im}V_M\), whereas
\(rV_M=V_Hr^{(2)}=0\), contradicting \(ri=1\).
This uses group-scheme \(F,V\), not an assertion about alternating
Dieudonne forms in characteristic two.

We have proved the good-reduction pairing obstruction. The next two
sections remove the good-reduction hypothesis on the curve.

## 2. Arbitrary correspondences on a regular semistable model

**Lemma.** Let \(\mathcal C/R\) be a proper regular semistable curve
with smooth geometrically connected generic fiber \(C/K\), and let
\(\mathcal S/R\) be the retained smooth projective model of \(S\).
Every integral one-cycle \(Z\) on \(C\times S_K\) induces a
homomorphism
\[
 \Phi_Z:G\longrightarrow
   \operatorname{Pic}^0_{\mathcal C/R}=\mathcal J^0,
 \tag{9}
\]
where \(\mathcal J\) is the Neron model of \(\operatorname{Jac}(C)\).
It is killed by two and induces the usual correspondence on the
generic Picard torsion. Here \(\operatorname{Pic}^0\) means zero
degree on **every** geometric component of the special fiber.

**Proof.** First take one integral component and its schematic closure
\(\overline Z\) in
\(\mathcal X=\mathcal C\times_R\mathcal S\).
The projection \(p:\mathcal X\to\mathcal C\) is smooth and proper.
Since \(\mathcal C\) is regular, \(\mathcal X\) is regular, so
\(\mathcal O_{\overline Z}\) is perfect. The closure is \(R\)-flat.
For a line bundle \(\mathcal L\) representing the \(G\)-class fppf
locally on its parameter scheme, form
\[
 \det Rp_*(\mathcal O_{\overline Z}\otimes\mathcal L)
       \otimes(\det Rp_*\mathcal O_{\overline Z})^{-1}.
 \tag{10}
\]
The retained perfect-pushforward and determinant results apply to
this projection, even though \(\mathcal C/R\) is not smooth.
They commute with arbitrary derived base change. The \(R\)-flatness
of the closure makes its derived pullback from \(R\) its ordinary
pullback.

For a component dominating \(C\), the rank of the pushed-forward
perfect complex is its generic projection degree \(d\); for a
vertical component it is zero. This rank is constant on
\(\mathcal C_G\): the rank of a perfect complex is locally constant,
and its flat-over-\(R\) ambient scheme has schematically dense
generic fiber, where the asserted rank holds on both \(G_K\)-points.
Changing a representative of the Picard class by a parameter line
bundle \(N\) therefore changes (10) by the pullback of \(N^d\).
Consequently (10) descends to a morphism
\(G\to\operatorname{Pic}_{\mathcal C/R}\).

On the generic fiber a dominating integral component is finite flat
over the smooth curve, and (10) is its norm. A vertical component
contributes the difference of Euler characteristics of the restricted
torsion line bundle and of the structure sheaf. That difference is
zero. Thus the generic morphism is the usual homomorphism on Picard
torsion, of degree zero.

The value at the identity of \(G\) is the trivial Picard class.
The geometric special fiber of \(G\) is \(\alpha_2\), with just that
one underlying point. Therefore the entire special-fiber image
lies in the open identity component of the Picard scheme.
The generic image also lies in its identity component. A morphism
whose underlying image lies in an open subspace factors through it,
including on nonreduced test schemes. This proves that (10) lands
in \(\operatorname{Pic}^0_{\mathcal C/R}\); in particular it proves
multidegree zero, not just total degree zero.

Raynaud's theorem now identifies this subfunctor with the separated
smooth group scheme \(\mathcal J^0\). The identity and group-law
equalities hold generically and extend by schematic density on
the flat schemes \(G\) and \(G\times G\). This proves (9), as well
as uniqueness and \(2\Phi_Z=0\). Sums and negative integral
coefficients are handled by tensor products and inverses in (10).
No smoothness of the cycle, finite-flatness of its closure over
\(\mathcal C\), or rational coefficients have been used.

After any further finite extension \(R'/R\), resolve the nodal base
change to a regular semistable curve and repeat the construction.
There is a canonical morphism from the base-changed Neron model
to the new Neron model: the Neron mapping property applies here
to its **smooth** source, not to \(G\). It sends identity components
to identity components. Its composite with the base-changed (9)
and the map constructed on the resolution have the same generic
fiber; flat generic density and separatedness identify them.
This proves the required finite-extension compatibility without
claiming that Neron models themselves commute with ramified base
change. \(\square\)

## 3. Semistable pairing obstruction, including graph cycles

**Lemma.** Let \(J/K\) be a polarized abelian variety with semistable
reduction over \(R\), and \(\mathcal J^0\) its Neron identity
component. For any two homomorphisms
\[
 f_1,f_2:G\longrightarrow\mathcal J^0,\qquad 2f_i=0,
 \tag{11}
\]
the generic Weil pairing of their nonidentity images is \(1\).

**Proof.** The polarization extends to a map between Neron models,
since its source is smooth, and preserves identity components.
Pull back the extended Poincare biextension along this polarization
to obtain a biextension \(W\) of
\(\mathcal J^0\times\mathcal J^0\) by \(\mathbf G_m\).
The all-\(n\) fppf construction in SGA 7 supplies
\[
 e_{2,W}:\mathcal J^0[2]\times\mathcal J^0[2]\longrightarrow\mu_2.
 \tag{12}
\]
It restricts to the usual generic Weil pairing and commutes with
specialization. There is no assertion that \(\mathcal J^0[2]\)
is finite flat.

Suppose the pairing in the conclusion were \(-1\). Restricting
(12) to the finite flat schemes \(G\times G\) gives (5) exactly.
The same generic-density argument as in Section 1 shows that its
pullback by \(h=f_1+f_2:H=G^2\to\mathcal J^0[2]\) is the perfect
form (6).

Pass to an algebraic closure \(k\) of the residue field and write
the semistable special fiber as
\[
 0\longrightarrow T\longrightarrow\mathcal J^0_k
       \xrightarrow{q}B\longrightarrow0,
 \tag{13}
\]
with \(T\) a torus and \(B\) an abelian variety. SGA 7 VIII,
Corollary 3.5 and Remark 3.6, applied successively in the two
variables, give a biextension \(\overline W\) of \(B\times B\)
whose pullback is \(W_k\). Functoriality and base-change
compatibility of the torsion pairing give
\[
 e_{2,W_k}(x,y)=e_{2,\overline W}(q(x),q(y))
 \quad (x,y\in\mathcal J^0_k[2])
 \tag{14}
\]
as fppf pairings of group schemes. This equality is not merely
an equality on geometric points.

Let \(\bar h=q h_k:H_k=\alpha_2^2\to B[2]\), and let
\(b_{\overline W}:B[2]\to B[2]^D\) be the bilinear form
defined by the descended pairing. Equation (14) implies
\[
 \bar h^D b_{\overline W}\bar h=\beta_k^\flat.
 \tag{15}
\]
Now \(B[2]\) is finite flat and \(\beta_k^\flat\) is an
isomorphism. Formula (7) gives a retraction of \(\bar h\).
Thus \(\alpha_2^2\) would be a direct summand of the BT1 \(B[2]\),
contradicting Section 1. This proves the lemma. \(\square\)

Only the existence of the descended biextension is needed in (15).
It need not be identified with the canonical principal Poincare
biextension on \(B\), and \(b_{\overline W}\) need not be perfect.
For a semistable Jacobian, \(B\) is the product of the Jacobians
of the normalized special components, while the torus records
cycles in the dual graph. Thus the argument explicitly allows
non-compact-type reduction and arbitrary toric rank.

## 4. Arithmetic curves and coefficient-two compatibility

Let \(C\), \(Z_1\) and \(Z_2\) be defined over a common number field
containing \(\mathbf Q(\pi)\). At a place above two, pass to a
finite extension giving \(C\) a regular semistable model. Such an
extension exists in every genus under consideration. The smooth
model of \(S\), its subgroup \(G\), and the pairing (4) survive it.
Section 2 produces two maps (11) into the same Neron identity
component. Section 3 gives
\[
 e_2\bigl(Z_1^*K_S,Z_2^*K_S\bigr)=1.
 \tag{16}
\]
The scalar is already in \(\{1,-1\}\) before the extension, so
an extension cannot turn \(-1\) into \(1\).

Here is the integral cohomological interpretation, including the
coefficient two. Over an algebraically closed characteristic-zero
field, the Kummer isomorphism identifies
\[
 H^1(C,\mu_2)=\operatorname{Pic}(C)[2]
             =\operatorname{Jac}(C)[2].
 \tag{17}
\]
On \(S\), the same isomorphism identifies \(\alpha\) with \(K_S\).
Pullback and the finite-flat norm commute with the Kummer
connecting map. Thus the action of an integral correspondence
in (17) is precisely the determinant/norm action used above;
vertical components contribute zero, and multiplicities remain
integral.

For the canonical principal polarization of a complex Jacobian,
\[
 e_2(\beta,\gamma)
     =(-1)^{\langle\beta\smile\gamma,[C]\rangle},
 \qquad \beta,\gamma\in H^1(C,\mathbf F_2).
 \tag{18}
\]
One can check the normalization integrally: identify the Jacobian
analytically with its period vector space modulo the integral
homology lattice. Its polarization has Riemann form the integral
intersection form. Two half-lattice points \(u/2,v/2\) have Weil
pairing \(\exp(\pi i\,E(u,v))=(-1)^{E(u,v)}\). Under Kummer and
Poincare duality this is exactly cup product modulo two.
The possible sign convention for the integral intersection form
does not change (18). In particular there is no extra factor two
which would erase this pairing.

Equations (16)--(18) prove the paired cup-product assertion for
arithmetic curves and **every pair** of their integral
correspondences, not only graphs of maps to \(S\).

## 5. Transcendental curves: spread the pair, not a fixed curve

Let now \(C/\mathbf C\) and \(Z_1,Z_2\) be arbitrary as in (2).
Fix the algebraic closure \(\bar K\) of \(\mathbf Q(\pi)\) inside
\(\mathbf C\). Spread the curve and the finitely many components
of both cycles over a finitely generated integral \(\bar K\)-algebra.
After restricting to a nonempty smooth open base \(U/\bar K\),
there are a smooth projective geometrically connected family
\(\mathscr C/U\), flat families of the cycle components on
\(\mathscr C\times S\), and a morphism
\(u:\operatorname{Spec}\mathbf C\to U\) recovering all the original
data. The map induced by the coefficient algebra is injective,
so its generic image remains in every such nonempty open.
We may take \(U\) integral and connected.

Use the actual line bundle \(K_S\), not a universal Picard
representative, in the determinant ratios (10) for these families,
and take their integral tensor combinations. The ambient product
is regular because \(U\) and \(\mathscr C/U\) are smooth in
characteristic zero. The same proper smooth projection therefore
makes these ratios line bundles on \(\mathscr C\), compatibly
with all fibers. On the generic curve they have degree zero and
are killed by two. Relative degree is locally constant, and the
relative Jacobian \(\mathscr J/U\) is separated, so these assertions
hold over \(U\). We obtain sections
\[
 P_1,P_2\in\mathscr J[2](U).
 \tag{19}
\]
In particular (19) is compatible with the original complex
correspondences and with the fundamental cycles of the flat
specializations. The norm calculation and its additivity on
generic curve components verify this compatibility, including
any vertical components.

Their relative Weil pairing is a morphism
\[
 e_2(P_1,P_2):U\longrightarrow\mu_2=\{1,-1\}.
 \tag{20}
\]
It is constant because \(U\) is connected and has characteristic
zero. The nonempty finite-type \(\bar K\)-scheme \(U\) has a
\(\bar K\)-point \(u_0\). Its curve and the two specialized cycles
are defined over one finite extension of \(K\), since their
equations have only finitely many algebraic coefficients.
Section 4 makes (20) equal to \(1\) at \(u_0\); it is therefore
\(1\) at \(u\) as well. Equation (18) proves
\[
 \langle Z_1^*\alpha\smile Z_2^*\alpha,[C]\rangle=0
 \quad\hbox{for all }Z_1,Z_2.
 \tag{21}
\]

This is specialization of a paired scalar in a relative Jacobian.
It does not descend the given transcendental curve to a number
field, keep its complex isomorphism class under specialization,
or identify the separate cohomology groups of different fibers.
Spreading both correspondences together is essential.

## 6. The quantitative integral Hodge obstruction

The correspondence map in (2) is additive, so its image is an
\(\mathbf F_2\)-subspace. Equation (21) says
\(A_C\subset A_C^\perp\). Poincare duality makes
\(H^1(C,\mathbf F_2)\) a nondegenerate alternating space of dimension
\(2g\). Alternation also in characteristic two follows by lifting
to \(H^1(C,\mathbf Z)\), whose cup square is zero.
Consequently
\[
 \dim A_C\leq\dim A_C^\perp=2g-\dim A_C,
 \quad\hbox{and hence}\quad \dim A_C\leq g.
 \tag{22}
\]

For clarity, the degree-four integral Kunneth decomposition has
only
\[
 H^0(C,\mathbf Z)\otimes H^4(S,\mathbf Z),\qquad
 H^1(C,\mathbf Z)\otimes H^3(S,\mathbf Z),\qquad
 H^2(C,\mathbf Z)\otimes H^2(S,\mathbf Z).
 \tag{23}
\]
The curve has torsion-free integral cohomology, so there are no
extra Tor summands. For an Enriques surface,
\(H^3(S,\mathbf Z)=\mathbf Z/2\); the outer summands are algebraic,
including the canonical torsion divisor. The middle summand is
\(H^1(C,\mathbf F_2)\), its algebraic part is exactly \(A_C\),
and all its classes are integral Hodge classes. This is precisely
the retained Benoist--Ottem identification. Thus
\[
 D_C\simeq H^1(C,\mathbf F_2)/A_C,\qquad
 \dim D_C=2g-\dim A_C\geq g>0.
 \tag{24}
\]
This proves the stated theorem. No sharpness of (22) or (24) is
asserted, and the obstruction disappears on tensoring with
\(\mathbf Q\).

## 7. Exact replay, comparison, and submission

The algebra in Section 1 can be replayed by

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/enriques-dyadic-defect/universal-isotropy/verify_isotropy.py
```

The script works in the explicit free integral basis for
\[
 \mathbf Z[\pi,s_1,\ldots,s_n]/
       (\pi^2-2,\ s_i^2-\pi s_i),
 \tag{25}
\]
not just over the fraction field. It checks the Hopf identities,
Cartier character formula, hyperbolic pairing, its unit determinant,
and their characteristic-two reductions. The coefficientwise
finite-field Jacobian operation is restricted to the displayed
\(\alpha_2\) character identity; its dedicated JSON files retain
the inspected contract, exact payload and typed output. It does
not certify semistable geometry or publication novelty.
The retained certificate records 33 exact checks, also replayed
independently in the accepted theorem review. In the bases
\((1,s_1,s_2,s_1s_2)\) and \((1,t_1,t_2,t_1t_2)\), the
coefficient matrix of (6) is
\[
 \begin{pmatrix}
 1&0&0&0\\0&0&-1&0\\0&-1&0&0\\0&0&0&1
 \end{pmatrix},
 \qquad \det=-1.
\]
It remains invertible modulo two. In particular the special
Cartier pairing is not trivial merely because all geometric
points of its source are the identity.

The inspected Jacobian operation was
`modular.polynomial_identity.compute`, server 0.14.0, protocol
2025-11-25. Its adapter exited zero, with no error or timeout;
the typed result was `identical: true`, with empty coefficient
residual. Its exact claim is
\[
 1+(s+s')t-(1+st)(1+s't)=ss't^2
 \quad\text{in }\mathbf F_2[s,s',t].
\]
The right side vanishes in the \(\alpha_2\) coordinate algebra.
The script separately checks both the polynomial's binding to
the payload and its reduction, so a pointwise finite-field test
has not been substituted for the nonreduced scheme identity.
The universal proofs of extension, biextension descent, the BT1
contradiction and spreading are the arguments above, not a finite
enumeration disguised as a theorem. No Lean formalization is
claimed.

The improvement over the strongest retained campaign result is a
change of quantifier and a structural restriction. The old theorem
computes \(A_E=0\) and \(\dim D_E=2\) for one CM elliptic curve.
That exact value remains stronger than the new lower bound on
that particular curve. The new statement instead controls
**every** correspondence image for **every** positive-genus curve
on this one explicit surface, including bad reduction and
transcendental parameters. It bounds the defect in proportion to
the genus and restricts all pairs, not merely one selected class.

The inspected published baselines include Benoist--Ottem's
very-general-curve theorem for a fixed surface, Theorem 0.1 of
arXiv:1802.01845v3. Its Section 3 full-image examples for other
Enriques surfaces show why (1) is substantive. Shen,
[arXiv:1901.07091v1](https://arxiv.org/abs/1901.07091v1),
Corollary 3.3 and its proof, p. 8, gives \(A_C=0\) and defect
dimension \(2g\) for very general plane curves. That value is
stronger than (24) on that restricted family; the present
improvement is uniformity over every curve, not a better generic
numerical value.

Colliot-Thelene,
[arXiv:1802.04372v2](https://arxiv.org/abs/1802.04372v2),
Corollary 2.2, gives failure for every elliptic curve of
transcendental \(j\) under its hypotheses on the surface. This
does not cover algebraic \(j\) or the all-genus paired restriction.
Huryn--Newman, arXiv:2609.04360v1, Corollary 3.3, pp. 12--13,
uses multiplicative elliptic reduction and residue characteristic
different from two. Schreieder, arXiv:2011.15047v4, Theorem 1.3,
p. 2, varies an Enriques surface very generally **with respect
to a fixed variety** and concerns exterior products modulo
algebraic equivalence; its quantifiers must not be interchanged.
These comparisons reuse the retained independent source readings;
no new novelty search is claimed.

**Submission provenance.** The accepted surface construction is
`../dyadic_theorem.md`, Sections 4--5, with its unchanged
`../algebra-certificate.json` and
`../special-smoothness-certificate.txt`, replayable by
`../verify_dyadic.py` (reviewed mission `1f1b8631a17f`).
The present theorem and `algebra-certificate.json` were independently
reviewed in mission `7a9841a4564b`. The retained verdict at
`../../../roles/reviewer/progress.json#universal_isotropy_review`
supports the unconditional every-curve theorem and classifies it
as a `new_theorem` with `verified_new` originality and `publishable`
significance. The final endorsement in reviewed mission
`60530174baa0` also accepted this theorem at project level, with
verified correctness and statement fidelity. These are retained
independent assessments, not an Engineer-issued certification or
a claim that Manager completion has occurred.

The intervening citation-delivery hold was resolved by the
independently accepted repair in mission `f3f51f25cb09`; see
`../../../roles/reviewer/progress.json#citation_attribution_review`.
All 53 affected bindings were independently supported, with no
citation-delivery blockers and no change to source hypotheses or
historical claims. The accepted delivery check reports 64 confirmed
bindings and 27 unchanged explicit uncited inputs. Those 27 inputs
remain explicit and are not newly discharged by the repair.
Its bounded `literature_review` classification describes only
the source-attribution work, not the mathematical result submitted
here.

This resubmission binds the accepted construction, theorem review,
final endorsement and citation repair for the normal Host-invoked
final independent certification and subsequent Manager completion.
The submitted project result is the universal-isotropy theorem
with (3), not the citation repair. Completion remains pending that
pathway and its actual research gate. No proof, exact certificate,
citation verdict or mathematical quantifier is replaced by this
submission.

The old fixed-surface image \(A_B\), its defect \(D_0\), the
unresolved fixed cup and effective descent are unchanged.
