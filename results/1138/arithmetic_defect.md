# Arithmetic vanishing cycles and maximal Enriques torsion defects

The theorem and family in Sections 1--6 passed independent correctness review;
see `roles/reviewer/progress.json`. The exact arithmetic certificate and the
reviewed mathematical statements are unchanged. There is no Lean formalization.
The publication assessment in Section 7 does **not** establish a substantive
original contribution: it separates the arithmetic argument from its formal
Galois consequences and compares the underlying primary-source mechanisms.
Novelty and publishable significance remain unverified. The host-invoked
independent publication review completed on 2026-11-03 at 19:59:03Z and
requested replanning. It preserved correctness and did not certify publication
qualification; this note is not a publication certificate.

The supplied mission names a genus-two curve and a diagonal Enriques quotient but
does not supply their equations in the objective, mission, or frontier. This
note makes the following concrete choices explicit rather than claiming to have
recovered missing coefficients:

\[
C:\ y^2=x^5-x-1,\qquad
T:\ \sum_{j=0}^5z_j^2=\sum_{j=0}^5jz_j^2
                    =\sum_{j=0}^5j^2z_j^2=0\ \subset\mathbf P^5_{\mathbf Q},
\]
\[
\iota(z_0,z_1,z_2,z_3,z_4,z_5)=(-z_0,-z_1,-z_2,z_3,z_4,z_5),
\qquad S=T/\langle\iota\rangle .
\]

The conclusion proved below is
\[
\operatorname{Hdg}^4(C_{\mathbf C}\times S_{\mathbf C},\mathbf Z)/
\operatorname{cl}(\mathrm{CH}^2(C_{\mathbf C}\times S_{\mathbf C}))
\simeq(\mathbf Z/2)^4.
\]
The same conclusion holds for every integer member
\(C_t:y^2=x^5-x-1+1083t\). These curves have infinitely many geometric
isomorphism classes.

## 1. The arithmetic bound

Let \(K\) be a number field, \(S/K\) an Enriques surface, and \(C/K\) a smooth
projective geometrically connected curve of genus \(g\). Fix a complex embedding
and a geometric place above a finite place \(v\) of odd residue characteristic.
Let \(\alpha\in H^1_{\mathrm{et}}(S_{\bar K},\mathbf F_2)\) be the canonical
K3-cover class. Put
\[
H=H^1_{\mathrm{et}}(C_{\bar K},\mathbf F_2),\quad
M=H^\vee,\quad
A=\{Z^*\alpha:Z\in\mathrm{CH}_1(C_{\mathbf C}\times S_{\mathbf C})\}.
\]
Comparison with singular cohomology is understood in the definition of \(A\).
In particular, \(A\) includes classes of **all complex algebraic cycles**, not
only cycles defined over \(K\).

Suppose \(C\) has semistable reduction at \(v\). Choose a regular semistable
model \(\mathcal C\) over the strict henselization \(R\) of the local DVR, and
write \(C_0\) for its geometric special fiber. Define
\[
U=\operatorname{im}\bigl(H^1_{\mathrm{et}}(C_0,\mathbf F_2)
                  \xrightarrow{\mathrm{sp}} H\bigr),\quad
V=U^\perp\subset M,\quad
W=\sum_{\sigma\in G_K}\sigma V.
\]
The specialization map here is restriction to the geometric generic fiber,
after identifying \(H^1(\mathcal C,\mathbf F_2)\) with
\(H^1(C_0,\mathbf F_2)\). Thus \(V\) is the geometric vanishing-cycle
space, not merely the image of a mod-2 monodromy operator.

**Theorem 1 (arithmetic vanishing-cycle bound).** Suppose that the geometric
cover class \(\alpha\) has a representative extending to a finite etale double
cover of a proper model of \(S\), after a finite extension at \(v\). Then
\[
A\subseteq W^\perp .
\tag{1}
\]
Writing \(D\) for the integral Hodge defect in degree four of \(C\times S\),
there is a surjection
\[
D\simeq H/A\twoheadrightarrow W^\vee,\qquad
\dim_{\mathbf F_2}D\geq\dim_{\mathbf F_2}W.
\tag{2}
\]
If \(H\) is an irreducible \(G_K\)-module and \(V\ne0\), then
\[
A=0,\qquad D\simeq(\mathbf Z/2)^{2g}.
\tag{3}
\]
The hypothesis on the cover holds in particular if \(S\) has good reduction at
\(v\). Hence it holds under the mission's good-reduction hypotheses on \(S\)
and its K3 cover.

The dual graph \(\Gamma\) of \(C_0\) satisfies
\(\dim V=b_1(\Gamma)\). A separating node alone need not give an obstruction:
the nonzero-vanishing-space hypothesis in (3) is essential.

The identification \(D=H/A\) is the known Benoist--Ottem calculation [BO,
Proposition 1.1 and Remark 1.2], recalled in Section 4. The assertions assessed
for originality are the arithmetic annihilation statement, its Galois
saturation, and its explicit arithmetic applications, not that known calculation.

## 2. A norm extension lemma

**Lemma 2.** Let \(R\) be an excellent DVR with \(2\) invertible, let
\(\mathcal C/R\) be a regular integral proper model of a smooth projective
curve \(C/F\), and let \(\mathcal Y/R\) be proper with a finite etale double
cover of class \(a_{\mathcal Y}\). If
\[
f:B\longrightarrow C,\qquad h:B\longrightarrow Y
\]
are morphisms from a smooth projective integral curve over \(F\), with \(f\)
nonconstant, then
\[
f_*h^*a_Y\in H^1(C,\mathbf F_2)
\]
extends to \(H^1(\mathcal C,\mathbf F_2)\).

**Proof.** The morphism \(f\) is finite and locally free. Write \(E=F(B)\)
and \(F_C=F(C)\). Identify \(\mu_2\) with the constant group \(\mathbf F_2\).
At the generic point, choose a Kummer representative \(a\in E^*\) of
\(h^*a_Y\). Transfer and the Kummer map commute with the norm [SGA4,
XVII, 6.3.18]. Therefore the generic square class of \(f_*h^*a_Y\) is
\[
b=N_{E/F_C}(a)\in F_C^*/F_C^{*2}.
\]

Let \(P\) be any prime divisor of \(\mathcal C\), horizontal or vertical.
Its local ring is a DVR. For every extension \(w\) of its normalized
valuation to \(E\), the map \(\operatorname{Spec}E\to\mathcal Y\) extends
to \(\operatorname{Spec}\mathcal O_w\to\mathcal Y\), by properness.
The pulled-back double cover is etale over this DVR. Its Kummer class
therefore has a unit representative, so \(w(a)\) is even. The valuation
formula for norms gives
\[
\operatorname{ord}_P(b)=
 \sum_{w\mid P}[\kappa(w):\kappa(P)]w(a)\in2\mathbf Z.
\tag{4}
\]
No parity assumption on ramification indices or residue degrees is used.

Consequently \(\operatorname{div}_{\mathcal C}(b)=2E_0\) for an integral
Weil divisor \(E_0\). Since \(\mathcal C\) is regular, \(E_0\) is Cartier.
Multiplication by \(b\) identifies
\(\mathcal O_{\mathcal C}(E_0)^{\otimes2}\) with \(\mathcal O_{\mathcal C}\).
The resulting quadratic algebra is locally \(R'[u]/(u^2-\varepsilon)\)
with \(\varepsilon\) a unit. It is finite etale because \(2\) is invertible.
Its generic class is \([b]\). Restriction from a normal integral scheme
to its function field is injective for etale double covers, so its
restriction to \(C\) is the required transfer class. This proves the lemma.

For a one-cycle on \(C\times Y\), normalize each component dominating \(C\)
and apply the lemma. Components mapping to a point of \(C\) have zero
contribution to \(H^1(C,\mathbf F_2)\): their restriction over the generic
point is zero, and this restriction is injective. Additivity handles
arbitrary integral coefficients. In particular, the lemma does not require
the correspondence to extend as a smooth family of curves.

## 3. Why ramified base change cannot remove this obstruction

**Lemma 3.** For a regular semistable curve over a strictly henselian DVR
with algebraically closed residue field of odd characteristic, the subspace
\(U\) of geometric generic-fiber cohomology defined above is unchanged by
finite extension of the DVR and regular semistable resolution of the base
change. These residue-field hypotheses hold for the strict henselizations
at the number-field places used here.

**Proof.** After a finite extension of ramification index \(e\), a node has
an etale-local equation \(xy=u t^e\), where \(u\) is a unit. Absorb \(u\)
in one coordinate. Resolving \(xy=t^e\) inserts a chain of \(e-1\)
projective lines between its two branches.

Here is the local calculation needed even when \(e\) is divisible by the
residue characteristic or by \(2\). For \(e>1\), blow up \((x,y,t)\).
The \(x\)- and \(y\)-charts are regular and have reduced nodal special
fiber; in the \(t\)-chart the remaining equation is
\(x_1y_1=t^{e-2}\). For \(e=2\), the exceptional curve is the smooth
conic \(xy=t^2\) in the exceptional projective plane, hence a projective
line over the algebraically closed residue field. For \(e>2\), the first
exceptional divisor consists of two lines, with any remaining singularity
at their meeting point. Induction inserts the intervening chain.
These are the blowup charts of [ST, 0CDC]; the global nodal resolution is
[ST, 0CDE]. In particular every fiber of the contraction of special
fibers
\[
q:C'_0\longrightarrow C_0
\]
is either a point or a connected tree of projective lines.

Such a tree has \(H^0_{\mathrm{et}}(-,\mathbf F_2)=\mathbf F_2\) and
\(H^1_{\mathrm{et}}(-,\mathbf F_2)=0\), by the normalization sequence.
Proper base change [ST, 095T] now gives
\[
q_*\mathbf F_2=\mathbf F_2,\qquad R^1q_*\mathbf F_2=0.
\]
The low-degree Leray sequence implies
\[
q^*:H^1(C_0,\mathbf F_2)\xrightarrow{\sim}H^1(C'_0,\mathbf F_2).
\tag{5}
\]

Restriction from a proper scheme over a henselian local ring to its closed
fiber is an equivalence on finite etale covers [ST, 0A48], and consequently
an isomorphism on \(H^1\) with finite constant coefficients [ST, 0A5G].
Combining this with (5), the pullback on the \(H^1\) of the two proper
models is an isomorphism. Its restriction to the geometric generic fiber
is the identity under the chosen identification of that fiber. The
images \(U\) are therefore equal. This proves the lemma.

For completeness, specialization on \(H^1(C_0,\mathbf F_2)\) is injective
here. An extending double cover which is geometrically trivial on the
generic fiber is a constant quadratic twist there. Over a strictly
henselian DVR with \(2\) invertible, every unit is a square; the only
possible nontrivial constant square class is a uniformizer. Its valuation
at the generic point of any reduced component of the special fiber is
one, contradicting etaleness of the extending cover. Thus the twist is
trivial, and normality makes the original cover trivial as well.

If the normalized components of \(C_0\) have genera \(g_i\), the
normalization sequence gives
\[
\dim H^1(C_0,\mathbf F_2)=2\sum_i g_i+b_1(\Gamma),\qquad
g=\sum_i g_i+b_1(\Gamma).
\]
The injectivity just proved yields \(\dim V=b_1(\Gamma)\).

**Good reduction of the surface.** If \(\mathcal S/R\) is smooth and proper,
smooth proper base change for order-two coefficients identifies the
geometric generic and special \(H^1\) [M, Theorem 20.4 and its following
scheme-valued good-reduction application]. The special-fiber cover
corresponding to \(\alpha\) lifts to \(\mathcal S\) by [ST, 0A48].
The cover and its identification with the geometric generic cover descend
to a finite extension of the original local field, since they are of
finite presentation. Only a representative of the geometric class is
needed. If a previously chosen arithmetic double cover differs by a
constant quadratic twist, a further finite extension kills that twist.
Lemma 3 allows all these extensions without changing \(U\).

**Excluded shortcut.** Merely observing that a cycle is defined over some
finite extension is insufficient. A Picard--Lefschetz transvection
\(I+N\), with \(N^2=0\), has \((I+N)^2=I\) over \(\mathbf F_2\).
Even ramification can therefore erase the mod-2 inertia action while the
vanishing cycle persists. Lemmas 2 and 3 use extension of an actual
etale cover, not invariance under the resulting inertia action.
This shortcut is recorded as retired route `R1138-inertia-only`.

## 4. All complex cycles, Galois saturation, and the defect

**Descent of cycle classes.** Let \(X/\bar K\) be smooth projective.
Every algebraic cycle on \(X_{\mathbf C}\) is algebraically equivalent
to a cycle over \(\bar K\) [CS, Remark 46]. Explicitly, its components
are points of Hilbert schemes defined over \(\bar K\). A connected
component containing such a point has a \(\bar K\)-point, and the
universal flat family keeps the integral cycle class constant.
Fundamental cycles of nonreduced fibers are taken with multiplicity.
Algebraic equivalence preserves integral singular cohomology, including
torsion. This is descent of the **class**, not the false assertion that
every complex subvariety itself is defined over \(\bar K\).

Apply this to \(X=C\times S\). Each descended cycle is defined over some
finite extension of \(K\), but there is no need for one common field of
definition for all cycles. At a place above \(v\), Lemma 2 extends its
correspondence double cover on a regular semistable model after that
extension. Lemma 3 places its geometric class in the **original** \(U\).
Thus \(A\subseteq U\) for every complex cycle.

Moreover \(A\) is \(G_K\)-stable. The canonical geometric K3-cover class
of an Enriques surface is Galois-invariant, and conjugation takes
cycles over \(\bar K\) to cycles over \(\bar K\), compatibly with
pullback, transfer, and comparison. Consequently
\[
A\subseteq\bigcap_{\sigma\in G_K}\sigma U
       =\left(\sum_{\sigma\in G_K}\sigma V\right)^\perp
       =W^\perp .
\]
This proves (1), with the original \(G_K\), not merely the subgroup of
a field of definition of one cycle.

For an Enriques surface over \(\mathbf C\),
\[
H^2(S,\mathbf Z)=\mathbf Z^{10}\oplus\mathbf Z/2,\quad
H^3(S,\mathbf Z)=\mathbf Z/2,\quad H^4(S,\mathbf Z)=\mathbf Z.
\]
Since the integral cohomology of \(C\) is torsion-free, the integral
Kunneth decomposition in degree four is
\[
H^4(C\times S,\mathbf Z)=
 [H^0(C)\otimes H^4(S)]
 \oplus[H^1(C)\otimes H^3(S)]
 \oplus[H^2(C)\otimes H^2(S)].
\tag{6}
\]
All these classes are integral Hodge classes. The first summand is
algebraic, using a point of \(S\). The last summand is algebraic,
using a point of \(C\) and divisor classes on \(S\), including the
torsion canonical divisor class. Cup product with \(\alpha\) and
pushforward along \(S\) identify the middle summand with \(H\), and
the middle component of an algebraic cycle with \(Z^*\alpha\).
This is precisely the computation in [BO, Proposition 1.1].
It follows that \(D=H/A\), with no unproved assertion about other
Kunneth summands.

Restriction of functionals gives \(H\twoheadrightarrow W^\vee\) with
kernel \(W^\perp\). Since \(A\subseteq W^\perp\), this descends to
the surjection (2). If \(H\) is irreducible, then \(M=H^\vee\) is
irreducible. A nonzero \(V\) therefore has \(G_K\)-span \(M\), forcing
\(A=0\) and proving (3).

In particular, maximal defect means that every nonzero **mixed**
torsion class is nonalgebraic. It does not mean that every torsion
class in \(H^4(C\times S,\mathbf Z)\) is nonalgebraic: (6) has the
additional algebraic canonical-divisor torsion class in its last
summand. After tensoring with \(\mathbf Q\), every degree-four Hodge
class here is algebraic. This is not a counterexample to the smooth
rational Hodge conjecture.

## 5. The explicit genus-two example

### 5.1 The surface and the cover at 19

For parameters \(a_j=j\), let \(v_j=(1,a_j,a_j^2)^T\). Every
three-column determinant of the matrix with columns \(v_j\) is
\[
\det(v_i,v_j,v_k)=(j-i)(k-i)(k-j)\ne0
\]
over both \(\mathbf Q\) and \(\mathbf F_{19}\).
The exact certificate checks all twenty determinants.

At a singular point of the intersection of the three quadrics, the
active Jacobian columns \(2z_jv_j\) would have rank at most two.
Thus at most two \(z_j\)'s could be nonzero. The defining equations,
and independence of any two columns, would then force every \(z_j^2\)
to be zero, impossible in projective space. Thus the intersection is
a smooth relative complete intersection over \(\mathbf Z_{19}\).
It is nonempty of relative dimension two by the projective dimension
theorem. The Koszul resolution gives geometric connectedness and
\(H^1(T,\mathcal O_T)=0\); adjunction gives
\(\omega_T=\mathcal O_T(2+2+2-6)=\mathcal O_T\).
Thus the fibers are K3 surfaces.

The projective fixed locus of \(\iota\) consists of the two coordinate
planes supported on \(0,1,2\) and on \(3,4,5\). The corresponding
three-column determinants are both \(2\). Neither fixed plane
intersects \(T\), in characteristic zero or at 19. The quotient of
the relative projective surface by this free order-two action is
projective, and \(T\to S\) is finite etale. Smoothness descends through
this etale covering.

The action on the residue generator of \(\omega_T\) is multiplication
by \(\det(\iota)=-1\), since each defining quadric is invariant.
Consequently the canonical bundle of the quotient is the nontrivial
order-two line bundle attached to the cover. Trace shows
\(H^1(S,\mathcal O_S)=0\). Thus the characteristic-zero quotient is
an Enriques surface and \(T\to S\) is its canonical K3 cover.
The construction over \(\mathbf Z_{19}\) proves good reduction of
the surface, the cover, **and the covering map**.

### 5.2 The semistable curve at 19

Set \(f=x^5-x-1\). Its exact discriminant is
\[
\operatorname{disc}(f)=2869=19\cdot151 .
\]
Over \(\mathbf F_{19}\),
\[
f=(x-13)^2q(x),\qquad q=x^3+7x^2+13x+10.
\tag{7}
\]
The certificate checks \(\gcd(q,q')=1\), \(\gcd(f,f')=x-13\), and
\[
q(13)=6=5^2\pmod {19}.
\]
Hence the unique singularity of the special affine curve is the
ordinary split node \((13,0)\), with distinct tangents
\(y=\pm5(x-13)\).

For the proper model, glue the finite double-cover charts
\[
y^2=x^5-x-1,\qquad z^2=u-u^5-u^6,\quad u=1/x,\ z=y/x^3 .
\]
Equivalently this is the degree-six binary branch equation over
\(\mathbf P^1_{\mathbf Z_{19}}\). At infinity \(u=z=0\), the
derivative with respect to \(u\) is \(-1\), so there is no
additional singularity. At the node,
\[
f(13)=371279=19\cdot19541,\qquad19541\equiv9\pmod {19}.
\]
The equation of the total space therefore has a nonzero linear
uniformizer term in the local maximal ideal modulo its square.
The total space is regular there. This is a regular semistable
model with a thickness-one node.

The normalization of its special fiber is \(w^2=q(x)\).
The cubic is squarefree, so this is a geometrically connected
genus-one curve. Its two points over \(x=13\) are distinct.
The special fiber is therefore irreducible with one nonseparating
node; its dual graph has one vertex and one loop. Lemma 3 gives
\(\dim V=1\), in particular \(V\ne0\).

### 5.3 The Galois module, without a full Galois-group computation

The polynomial \(f\bmod3=x^5+2x+2\) is irreducible.
`verify_example.py` proves this by checking all three monic linear
polynomials and all nine monic quadratic polynomials over
\(\mathbf F_3\). A reducible polynomial of degree five has a
factor of degree one or two, so this is a complete irreducibility
test, not a heuristic search. Jacobian independently returns the
same irreducibility result. The reduction is squarefree.

An unramified Frobenius at 3 therefore acts on the five roots of
\(f\) as a 5-cycle. No assertion that the full Galois group is
\(S_5\) is needed.

Here is the precise module on which it acts. Let \(P_1,\ldots,P_5\)
be the finite Weierstrass points and let \(P_\infty\) be the
rational point at infinity. In \(J(C)[2]\), set
\(d_i=[P_i-P_\infty]\). The divisors of \(x-r_i\) and \(y\)
give \(2d_i=0\) and \(\sum_i d_i=0\).
There is no nonempty proper subset relation: by taking complements
it would have size one or two. A size-one relation would make
\(P_i-P_\infty\) principal. A size-two relation is equivalently
\(P_i-P_j\) principal, since \(2d_j=0\). Either would give a
degree-one map to \(\mathbf P^1\), impossible for a genus-two
curve. These generators thus give the equivariant identification
\[
H^1_{\mathrm{et}}(C_{\bar{\mathbf Q}},\mathbf F_2)
 \simeq J(C)[2]\simeq\mathbf F_2^5/\langle(1,1,1,1,1)\rangle .
\]
The first identification is the Kummer sequence over the
algebraically closed field. Since five is odd, the quotient is
equivariantly isomorphic to the even-coordinate-sum subspace.

In the basis \(e_i+e_5\), \(1\le i\le4\), the 5-cycle has matrix
\[
F=\begin{pmatrix}
1&1&1&1\\
1&0&0&0\\
0&1&0&0\\
0&0&1&0
\end{pmatrix}.
\]
Its characteristic polynomial is \(t^4+t^3+t^2+t+1\), irreducible
over \(\mathbf F_2\): it has no linear factor and its only possible
irreducible quadratic factor \(t^2+t+1\) does not divide it.
Alternatively the certificate checks that the orbit of each of the
fifteen nonzero vectors spans the full four-dimensional space.
Thus the action of this single Galois element is irreducible, and
so is the full \(G_{\mathbf Q}\)-action.

All hypotheses of Theorem 1 now hold. It gives \(A=0\) and
\(D\simeq(\mathbf Z/2)^4\), with the qualification about the other
algebraic torsion summand made in Section 4.

## 6. A uniform infinite arithmetic family

Let \(m=3\cdot19^2=1083\) and \(b_t=-1+mt\). For every integer \(t\),
put \(f_t=x^5-x+b_t\) and let \(C_t\) be the smooth projective curve
with affine equation \(y^2=f_t(x)\).

Modulo 3 and modulo \(19^2\), \(f_t\) equals \(f_0\). Consequently:

1. Reduction modulo 3 remains irreducible and squarefree. In
   particular \(f_t\) is squarefree in characteristic zero and
   the same 5-cycle proves irreducibility of its four-dimensional
   mod-2 cohomology.
2. The special fiber modulo 19 is exactly (7). Moreover
   \[
   f_t(13)/19=19541+57t\equiv9\pmod {19}.
   \]
   Hence the total-space regularity and the nonseparating node
   persist, for every \(t\), not just for tested parameters.
3. The surface and its cover are unchanged. Theorem 1 applies
   to every \(C_t\times S\), giving defect \((\mathbf Z/2)^4\).

One can also check uniformly that
\[
\operatorname{disc}(x^5-x+b)=3125b^4-256
 \equiv2869\pmod {19^2}
\]
when \(b\equiv-1\pmod {19^2}\). For the displayed formula, evaluate
\(x^5-x+b\) at the four roots \(r\) of \(5x^4-1\): its value is
\(b-\tfrac45r\). Taking the product and multiplying by \(5^5\)
gives \(3125b^4-256\). The discriminant sign for degree five is
positive. No numerical discriminant approximation is involved.

These are infinitely many geometric isomorphism classes.
For a fixed genus-two curve, an isomorphism descends through its
canonical hyperelliptic pencil to a projective transformation of the
six branch points. The distinguished branch point at infinity of
our presentation can map to only six choices. Fix one of them
and move that target branch point to infinity. The remaining
transformation is affine. The vanishing coefficient of \(x^4\)
fixes its translation by centering the five finite branch points.
If the centered target polynomial has a nonzero \(x^3\) or \(x^2\)
coefficient, no member of our family has that presentation.
Otherwise normalizing the coefficient of \(x\) to \(-1\) gives
at most four scalings; if that coefficient is zero it gives none.
Thus a fixed geometric isomorphism class contains at most
\(6\cdot4=24\) of the distinct parameters \(b_t\).
The integer parameters are infinite, proving the assertion.

## 7. Publication qualification: implications, not statement matching

### 7.1 What the existing results and their proofs supply

[BO, Proposition 1.1 and Remark 1.2] supplies \(D=H/A\).
Remark 2.2 supplies arithmetic failures for the Legendre curve
\(Y^2Z=X(X-Z)(X-pZ)\) at odd good-reduction primes of an Enriques
surface over \(\mathbf Q\). Its rational two-torsion does not give
the irreducible module used in Section 5. Conversely, replacing
this particular elliptic curve by a curve with irreducible
two-torsion is not by itself a new obstruction mechanism.

The closest comparisons concern proofs, rather than a search for the
displayed equations or the words "Galois-saturated."

**Diaz.** The relevant author is Humberto A. Diaz. In [Di, Theorem 3.2,
p. 4], passage from unramified cohomology to nonalgebraic torsion has
a Chow-triviality hypothesis. Section 4 then uses a selected genus-one
cover and multiplicative reduction (Assumption 4.1 and Lemma 4.2,
pp. 4--5), a good-reduction lifting argument (Lemma 4.3, pp. 6--7),
and a nonzero specialized residue (equations (6)--(7), pp. 7--8).
This is already a mixed-characteristic good-versus-bad-reduction
obstruction. It is not a theorem about the transfers of every
correspondence on an arbitrary semistable curve. In particular,
one cannot apply his Chow-triviality conversion theorem unchanged
to \(C\times S\), or replace nonalgebraic torsion by mere nonvanishing
of an unramified class without checking integral lifts.
The version used for this comparison is arXiv v1; agreement of every
locator with the published version is not asserted.

**Shen.** [Sh, Lemma 2.2(3), p. 5, and Proposition 2.5(1),
pp. 6--7] kills odd-dimensional vanishing cycles after arbitrarily
ramified base change and resolution. The even-ramification case is
part of the argument, not an omission repaired here. The proof of
Corollary 3.3, p. 8, contracts an extending class with the
Enriques-cover class to obtain an extending class on the first
factor. Theorem 3.4, pp. 8--9, then gives the vanishing-space
annihilation and maximal mixed nonalgebraicity. Thus both the
base-change-resistant mechanism and maximal mixed defect are
already present. Remark 1.3, p. 2, explains the extension of cycles
from a very general fiber. That extension along a complex pencil
cannot simply be assumed for a prescribed number-field fiber.

**Kok.** [Kok, Lemma 2.3, pp. 124--125] treats norm/trace compatibility
with Kummer classes; Proposition 2.19, pp. 129--130, treats
specialization under finite extension. The proof of Theorem 4.7(ii),
pp. 138--139, uses the ordinary-double-point residue of
Propositions 4.3--4.4 and an obstruction to lifting to higher
\(2\)-power coefficients. The lift obstruction matters: nonzero
residue alone must not be silently substituted for the nonalgebraicity
conclusion. Corollary 4.9 and Remark 4.13, pp. 139--140, yield the
Enriques application and identify Shen's mixed class.
Proposition 5.4 and its proof, pp. 143--144, construct refined
cospecialization by closing supports. The local/support mechanism
is therefore substantially closer to the present argument than the
phrase "geometric generic fiber" alone suggests.
These results do not license specialization of generic-fiber
nonalgebraicity to an arbitrary number-field point.

[CT] gives nonvanishing for elliptic curves with transcendental \(j\)
when the other factor is defined over a number field, not a
number-field elliptic factor. [To] already constructs arithmetic
threefold failures by finite-field specialization. Neither
number-field definability nor arithmetic specialization is an
originality claim available here.

### 7.2 The precise arithmetic bridge, and its limitations as a novelty claim

The additional argument needed on the prescribed arithmetic trait is
exactly Lemmas 2 and 3, not an appeal to the generic-fiber conclusions
of [Sh] or [Kok]. For every normalized correspondence and every
divisorial valuation of the regular curve model, properness makes
the pulled-back cover unramified. The standard norm formula then gives
\[
 \operatorname{ord}_P N(a)
   =\sum_{w\mid P}[\kappa(w):\kappa(P)]w(a)\equiv0\pmod2.
\]
The resulting quadratic cover extends over the regular model.
After a ramified extension, the exceptional rational chains do not
change its \(H^1\) specialization image. Hilbert-scheme descent of
integral cycle classes therefore gives \(A\subset U\) for all complex
cycles. These are the already reviewed arguments, using the
already recorded norm/Kummer, proper-cover, nodal-resolution, and
descent inputs.

This identifies the missing implication precisely. It is an
unramified-transfer argument on an arithmetic trait, rather than
a new conclusion obtained by specialization of nonalgebraicity.
Its correctness rests on the proof in Sections 2--4, not on a claim
that a cited author printed this exact arithmetic lemma. No
unverified alternate mixed-characteristic cycle-class formalism
is needed for that proof.

Allowing the surface model to be proper and possibly singular is
outside the smooth-model setup in the closest comparisons. However,
in Lemma 2 the surface enters only through properness and the
extending etale cover. The same even-valuation norm calculation
already handles this generality; no additional cohomological
obstruction is proved for it. A broader hypothesis alone is not
evidence of a substantive new mechanism.

### 7.3 Why the quantitative and maximal-rank conclusions are formal

Here is the exact implication that a comparison of printed statements
can miss. Let \(G\) act on a finite-dimensional vector space \(H\), let
\(A\subset H\) be a \(G\)-stable subspace, and let \(U\subset H\)
be a subspace with \(A\subset U\).
Then
\[
 U_{\mathrm{core}}:=\bigcap_{\sigma\in G}\sigma U
\]
is the largest \(G\)-stable subspace contained in \(U\).
Indeed, it is stable, and every stable \(B\subset U\) satisfies
\(B=\sigma B\subset\sigma U\) for every \(\sigma\).
With \(V=U^\perp\subset H^\vee\) and \(W=\sum_\sigma\sigma V\),
finite-dimensional duality gives
\[
 A\subset U_{\mathrm{core}}=W^\perp,\qquad
 H/A\twoheadrightarrow H/U_{\mathrm{core}}\simeq W^\vee.
\]
This proves the entire quantitative saturation step without an
additional geometric input.

There is an even shorter implication in the irreducible case.
If \(H\) is irreducible, its stable subspace \(A\) is either \(0\)
or \(H\). Thus **any** proof that \(A\ne H\), together with
Galois stability, forces \(A=0\). A nonzero local vanishing
direction and \(A\subset U\) give precisely \(A\ne H\).
Equivalently, on this irreducible module, nonzero defect already
implies full defect.

This does not claim that [BO]'s particular Legendre theorem applies
to the curves in Section 6. The necessary local argument for those
curves is the arithmetic bridge just described. It shows instead
that, once that local argument is available, moving from one
nonalgebraic direction to all four is not a further Hodge-theoretic
advance. The same observation applies to a single irreducible
Galois element as to the full group.

### 7.4 Consequence for the exact family and the publication goal

For the already verified family, the node at 19 supplies \(V\ne0\),
the Frobenius at 3 supplies irreducibility, and the surface cover
extends at 19. The preceding implication therefore yields the full
rank-four defect for every integer \(t\). The congruences and the
bound of 24 parameters per geometric isomorphism class then give
the infinite family. All of these conclusions remain exact and
proved; none is withdrawn or replaced by a finite experiment.

The previous review established correctness and described a
quantitative exploratory advance over the inspected statements.
The stronger comparison here closes that baseline under the formal
implications above. It isolates the only candidate additional
mathematics as the short arithmetic norm-extension argument and
its application, not the Galois saturation, rank four, or the choice
of coefficients. The inspected papers do not contain a printed
theorem literally subsuming every hypothesis of Theorem 1.
Nevertheless, their mechanisms together with the standard
unramified-transfer argument leave no demonstrated substantive
original contribution under this mission's bar. This is the
Engineer's significance assessment, not an independent verdict
that the exact statement has previously been published.

**Publication qualification is unmet.** Neither `verified_new`
nor `publishable` is supported by this comparison. The independent
publication Reviewer has now checked the source mechanisms and
invariant-subspace implication, preserved the accepted correctness
and exact-certificate judgments, and requested a substantive
replacement mission. Its source readings are in
`reviewer/publication-source-readings.json`; the verdict is in
`roles/reviewer/progress.json`. This is not a finding that the exact
theorem is already published or cannot be publishable.
The proposed route from the reviewed
good-reduction theorem and family directly to campaign completion
is retired for this reason; the mathematical claims themselves
remain supported. The campaign remains open, and this bounded
qualification task does not broaden its target or open a replacement
mathematical route. Planner must issue the replacement mission rather
than send this unchanged qualification claim through review again.

## 8. Sources and exact replay

- **[BO]** O. Benoist and J. C. Ottem, *Failure of the integral Hodge
  conjecture for threefolds of Kodaira dimension zero*,
  [arXiv:1802.01845v3](https://arxiv.org/pdf/1802.01845v3),
  Proposition 1.1, Remark 1.2, Proposition 2.1, Remark 2.2.
  Published DOI: [10.4171/CMH/479](https://doi.org/10.4171/CMH/479).
- **[Sh]** M. Shen, *Vanishing cycles under base change and the integral
  Hodge conjecture*, [arXiv:1901.07091v1](https://arxiv.org/pdf/1901.07091v1),
  Remark 1.3, Lemma 2.2(3), Proposition 2.5(1), Corollary 3.3,
  Theorem 3.4.
- **[Di]** H. A. Diaz, *On the integral Hodge conjecture for varieties
  with trivial Chow group*,
  [arXiv:2204.13818v1](https://arxiv.org/pdf/2204.13818v1),
  Theorem 3.2, Assumption 4.1, Lemmas 4.2--4.3, and the conclusion
  of Section 4, equations (6)--(7), pp. 4--8.
  Published DOI:
  [10.1017/S0305004123000233](https://doi.org/10.1017/S0305004123000233).
  The comparison uses the arXiv version, not an unchecked assumption
  that the published theorem numbering agrees.
- **[CT]** J.-L. Colliot-Thelene, *Cohomologie non ramifiee dans le produit
  avec une courbe elliptique*,
  [arXiv:1802.04372v2](https://arxiv.org/pdf/1802.04372v2),
  Proposition 2.1(c),(d), Corollary 2.2.
- **[Kok]** K. Kok, *On the failure of the integral Tate conjecture for
  products with projective hypersurfaces*, Algebra & Number Theory
  20 (2026), 119-146,
  [DOI:10.2140/ant.2026.20.119](https://doi.org/10.2140/ant.2026.20.119),
  Lemma 2.3, Proposition 2.19, Propositions 4.3--4.4,
  Theorem 4.7(ii), Corollary 4.9, Remark 4.13, Proposition 5.4.
- **[To]** B. Totaro, *On the integral Hodge and Tate conjectures over a
  number field*, [author's primary text](https://www.math.ucla.edu/~totaro/papers/public_html/integral.pdf),
  Theorem 2.1 and its proof, p. 3. The downloaded text is in `literature/`.
- **[CS]** F. Charles and C. Schnell, *Notes on absolute Hodge classes*,
  [arXiv:1101.3647v1](https://arxiv.org/pdf/1101.3647v1),
  Remark 46, p. 27. The cycle-level algebraic-equivalence assertion,
  rather than only de Rham descent in Theorem 45, is used.
- **[SGA4]** SGA 4, Tome 3, Expose XVII, Example 6.3.18,
  diagram (6.3.18.2), printed p. 198,
  [original scan](https://library.slmath.org/books/sga/sga/4-3/4-3t_449.html).
  The norm/Kummer compatibility is stated for finite locally free
  morphisms, not only for etale maps.
- **[M]** J. S. Milne, *Lectures on Etale Cohomology*, version 2.21,
  March 22, 2013,
  [author's PDF](https://www.jmilne.org/math/CourseNotes/LEC.pdf),
  Theorem 20.4 and the following good-reduction application for
  schemes over a mixed-characteristic DVR. Downloaded in `literature/`.
- **[ST]** The Stacks Project, tags
  [0A48](https://stacks.math.columbia.edu/tag/0A48) (proper henselian
  equivalence of finite etale covers),
  [0A5G](https://stacks.math.columbia.edu/tag/0A5G) (the \(H^1\) consequence),
  [095T](https://stacks.math.columbia.edu/tag/095T) (proper base change),
  [0CDC](https://stacks.math.columbia.edu/tag/0CDC) (the node blowup charts),
  [0CDE](https://stacks.math.columbia.edu/tag/0CDE) (regular nodal resolution).
  The chain/cohomology/base-change argument in Lemma 3 is supplied here;
  it is not misattributed verbatim to one Stacks lemma.

From the campaign root, rerun the independent exact arithmetic program:

```bash
python3 research/enriques-arithmetic-defect/verify_example.py
```

It uses only the Python standard library. The saved output is
`exact_certificate.json`. The twenty determinant identities, the
degree-five discriminant, the node data, the complete mod-3 irreducibility
test, and all fifteen nonzero vector-orbit ranks are recomputed exactly.
The congruence-family checks verify the universal modulus and linear
smoothing expression; no finite list of parameters stands in for that proof.

The final Jacobian calculation can separately be replayed through the
required isolated adapter:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run \
  --operation polynomial.galois.factor_mod_p.compute \
  --payload-file research/enriques-arithmetic-defect/jacobian/f-mod-3.payload.json
```

`jacobian/f-mod-3.output.json` preserves the exact typed output, server
version 0.14.0, protocol 2025-11-25, operation ID and payload.
`jacobian/f-mod-3.status.json` records exit status 0 and no timeout.
Coefficient arrays are ascending and use canonical field residues.
The initial negative-residue request was rejected and remains archived
with its structured `coefficients_not_canonical` error and exit status 2.
The intermediate reversed coefficient vector computes the reciprocal
polynomial; that successful output is also preserved but is not used as
the certificate for the intended input. The final request and the
standalone verifier agree on the exact polynomial.

This finite certificate verifies arithmetic and linear algebra, not the
entire cohomological argument. The independent review recorded in
`roles/reviewer/progress.json` already supports Lemmas 2 and 3, descent
of all complex cycles, the quotient construction, and the uniform
family proof. Those judgments and the accepted Jacobian result are
reused, not replayed for an unchanged statement. The independent
publication review of Section 7 is also complete: qualification was
not certified, and the next required action is technical replanning.
