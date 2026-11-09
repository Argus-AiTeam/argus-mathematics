# Simultaneous compact arithmetic boundary gluing

## Statement (C_ABG)

Let \(k_0=\mathbb F_q\), let \(\ell\ne\operatorname{char} k_0\), let
\(L/\mathbb Q_\ell\) be finite, and let \(n\geq2\). Let \(X_0/k_0\)
be a smooth projective geometrically connected curve and let
\(\Delta_0\) be a nonempty finite reduced divisor. Put
\(U_0=X_0-\Delta_0\). Suppose
\[
 \rho:\pi_1^{\mathrm{et}}(U_0)\longrightarrow\mathrm{PGL}_n(L)
\]
is continuous, has Zariski-dense geometric image, kills wild inertia
at every puncture, and has unipotent tame boundary. No regularity or
nonzero condition on its nilpotent boundary logarithms is imposed.

There are a pointed characteristic-zero lift \((C_1,\Delta_1)/D\), where
\(D=\operatorname{Frac}W(k_0)\), a geometrically connected finite cover
\(h:C_2\to C_1\), one integer \(e>1\) prime to \(\ell\), and a
compact open subgroup \(J\subset\mathrm{PGL}_n(L)\), with the following
properties. No coefficient extension is needed.

1. The degree of \(h\) is \(e\). Above each closed point \(x\) of
   \(\Delta_1\) there is exactly one point \(y\), with ramification
   index \(e\) and residue field \(k(y)=k(x)\).
2. There is a compact-valued lift \(\sigma_1\) of the entire arithmetic
   torsor tower of \(\rho\) on
   \((C_1-\Delta_1)_{\bar D}\). Put \(\sigma_2=h^*\sigma_1\).
   Both geometric images are dense. In coordinate-neutralized boundary
   frames their logarithms are \(N_i,eN_i\), and their prescribed
   semilinear boundary transports are the same.
3. Identify the corresponding points of \(\Delta_1\) and \(h^{-1}\Delta_1\).
   The resulting projective nodal curve has a simultaneous projective
   smoothing over \(D[[s]]\). On its smooth geometric generic curve
   \(C/\Omega\), with
   \(\Omega=\overline{\bar D((s))}\), there is a continuous,
   Zariski-dense, unramified parameter
   \[
                 \tau:\pi_1^{\mathrm{et}}(C)\longrightarrow J.
   \]
4. The parameter is equipped with the prescribed semilinear arithmetic
   action: extend the \(q\)-Witt action to \(\bar D\), and then to
   \(\Omega\), fixing the chosen compatible roots of \(s\). A tower of
   finite right \(J/J_r\)-torsors on balanced twisted models realizes
   \(\tau\); its restrictions to the two punctured special components
   recover \(\sigma_1,\sigma_2\), with their arithmetic actions.
   All the comparisons commute with transition maps and evaluation in
   every algebraic representation. Thus they apply to the entire tensor
   local system, not just boundary conjugacy classes.

The divisor need not be split over \(k_0\): Frobenius may permute its
geometric points. For an empty divisor one can first mark any closed
point at which \(\rho\) is unramified, with logarithm zero, and apply
the statement. Forgetting this auxiliary marking recovers the original
parameter. This is a theorem about parameters and specialization data,
not a theorem producing Weil structures on geometric eigensheaves.

## 1. A canonical primary-space grading (L_ABG_GRADING)

Here is the algebraic strengthening used in the proof. Let \(F\) have
characteristic zero, let \(r\in F^\times\) have infinite order, and let
\(A\in\mathrm{PGL}_n(F)\). There is a cocharacter \(c_{A,r}\) over
\(F\) such that, **simultaneously for every**
\(N\in\mathfrak{pgl}_n(F)\) with \(\operatorname{Ad}(A)N=rN\),
\[
 c_{A,r}(z)A=Ac_{A,r}(z),\qquad
 \operatorname{Ad}(c_{A,r}(z))N=zN.                 \tag{1}
\]
It is invariant under changing a matrix lift of \(A\), is natural under
conjugation, and its matrix lift has weights in \(\{0,\ldots,n-1\}\).
In particular it centralizes the whole projective centralizer of \(A\).

**Proof.** Lift \(A\) to \(a\in\mathrm{GL}(V)(F)\), and use the unique
traceless lift of \(N\). The projective relation becomes \(aN=rNa\):
the possible scalar error has trace zero and therefore vanishes.
Over a finite Galois splitting field write \(V=\bigoplus_\lambda V_\lambda\)
for the generalized eigenspaces of \(a\). For all positive integers \(m\),
\[
       (a-r\lambda)^m N=r^m N(a-\lambda)^m.          \tag{2}
\]
The identity follows at \(m=1\) from \(aN=rNa\), and its multiplication
by \(a-r\lambda\) proves the induction step. Thus
\(N(V_\lambda)\subset V_{r\lambda}\), interpreting a missing
eigenspace as zero.

Draw an arrow \(\lambda\to r\lambda\) when both eigenvalues occur.
Each vertex has at most one predecessor and one successor. There is
no cycle, since \(\lambda\ne0\) and \(r\) has infinite order.
The finite graph is a disjoint union of paths. Let \(d(\lambda)\)
be the distance from the initial vertex of its path. Every existing
arrow raises \(d\) by exactly one, and \(0\leq d(\lambda)\leq n-1\).
Let \(c(z)\) act by \(z^{d(\lambda)}\) on \(V_\lambda\).
This is a cocharacter, commutes with the full generalized action of
\(a\), and satisfies (1) by (2). This proof does not diagonalize \(a\).

Galois permutations preserve the arrows and their initial vertices.
Consequently each weight space
\(\bigoplus_{d(\lambda)=j}V_\lambda\) descends to \(F\), so \(c\)
is defined over \(F\), not merely the splitting field. Replacing
\(a\) by a nonzero scalar multiple scales every vertex by that scalar
and leaves all heights and subspaces unchanged. Conjugation also
preserves the construction. If an element centralizes \(A\) only
projectively, its matrix lift conjugates \(a\) to a scalar multiple
of \(a\); the preceding two invariances still apply. This proves the
last assertion and independence of the lift. The same \(c\) works
for every \(N\) in (1). In fact (2) also proves such an \(N\) is
nilpotent; nilpotence need not be an additional local assumption. QED.

Equivalently, one can group the primary spaces of the irreducible
factors of the characteristic polynomial over \(F\). Multiplication
of their roots by \(r\) gives the same paths. Chinese remainder
projectors \(E_j\) onto the height-\(j\) spaces give
\[
                         c(z)=\sum_j z^j E_j.       \tag{3}
\]
This formula makes the construction effective without choosing
individual eigenvectors. Repeated eigenvalues, unequal primary
multiplicities, nonsplit eigenvalues, and zero \(N\) cause no exception.

## 2. One compact group, one degree, and arithmetic orbits

Let \(H_0=\rho(\pi_1(U_0))\), a compact group. The same argument applies
to any compact group recording a lifted arithmetic torsor tower.
Choose a closed faithful linear representation of \(\mathrm{PGL}_n\)
over \(L\) and an \(H_0\)-stable lattice \(\Lambda\). Such a lattice
exists: a compact set of matrices is bounded, so the module spanned
by the orbit of any lattice is contained in a fixed larger lattice
and is finitely generated. The inverse image
\[
             J=\mathrm{GL}(\Lambda)\cap\mathrm{PGL}_n(L)
\]
in this representation is open and compact, and contains \(H_0\).
Compactness uses the closed embedding, not merely faithfulness as
an abstract group homomorphism.

For split punctures, let \(A_i\in H_0\) be the arithmetic value in
the \(i\)-th boundary frame. Equation
\(\operatorname{Ad}(A_i)N_i=qN_i\) and (1) give \(c_i\).
For finitely many \(c_i\), continuity at 1 gives one integer \(M\)
such that all \(c_i(z)\) belong to \(J\) when
\(z\in1+\ell^M\mathbb Z_\ell\). Increase \(M\) so
\(e=\ell^M-1>1\); then
\[
 z=-1/e,\quad z-1=\ell^M/(1-\ell^M),\quad
 P_i=c_i(-1/e)\in J.                               \tag{4}
\]
The integer \(e\) is prime to \(\ell\). No condition prime to
\(\operatorname{char} k_0\) is needed: the auxiliary cover is constructed
in characteristic zero. It could also be imposed by taking
\(e=\operatorname{char}(k_0)\ell^M-1\).

For completeness, here is the nonsplit arithmetic case. Index
geometric punctures by a finite set \(I\) with permutation \(\pi\).
In compatible frames let \(B_i\in H_0\) be transport from \(i\) to
\(\pi i\). The convention used here is
\[
        \operatorname{Ad}(B_i)N_i=qN_{\pi i}.        \tag{5}
\]
For an orbit of length \(d\), the return value
\(A_i=B_{\pi^{d-1}i}\cdots B_{\pi i}B_i\)
scales \(N_i\) by \(q^d\), and
\(A_{\pi i}=B_iA_iB_i^{-1}\). Apply the canonical construction with
\(r=q^d\). Naturality, or simply propagation around the orbit, gives
\[
             c_{\pi i}=B_i c_i B_i^{-1},\qquad
             P_{\pi i}B_i=B_iP_i.                  \tag{6}
\]
The return condition holds because \(c_i\) commutes with \(A_i\).
There are finitely many cocharacters, so the same \(J,M,e\) work.
When \(N_i=0\) one may instead use the trivial cocharacter on that
entire orbit; (5) ensures all its logarithms vanish.

From (1) and (4), for every scalar \(a\),
\[
       P_i\exp(-eaN_i)P_i^{-1}=\exp(aN_i).          \tag{7}
\]
The minus sign is the branch orientation, and \(e\) is the
ramification factor. Equation (6), not commutation with every
individual \(B_i\), is the requisite arithmetic condition at
permuted punctures.

An effective form of the compactness argument is also available.
In the faithful representation write \(c_i(z)=\sum_w z^w E_{i,w}\).
Choose \(k\geq0\) with \(\ell^kE_{i,w}\Lambda\subset\Lambda\) for all
the finitely many weight projectors. If \(M\geq k+1\), then
\(z^w-1\in\ell^M\mathbb Z_\ell\), even for negative integral \(w\).
Thus \(c_i(z)-1\) and \(c_i(z)^{-1}-1\) preserve \(\Lambda\), proving
membership in \(J\) by an explicit denominator bound.

## 3. Lifting the arithmetic tower (L_ABG_LIFT)

Lift the smooth pointed curve, including its finite etale marked
divisor, over \(W(k_0)\). Curve deformations are unobstructed:
the obstruction group for the marked smooth curve is
\(H^2(T_{X_0}(-\Delta_0))=0\). An ample line bundle lifts, since
its obstruction is in \(H^2(\mathcal O_{X_0})=0\), and algebraization
gives a projective lift. This argument works with closed points,
not just rational points. It gives \(C_1/D\) above.

Take cofinal open normal congruence subgroups \(H_{0,r}\) and put
\(\Gamma_r=H_0/H_{0,r}\). The corresponding arithmetic finite right
\(\Gamma_r\)-torsors are defined over \(U_0\). At every puncture their
inertia images have \(\ell\)-power order. Choose one \(\ell\)-power
root order \(b_r\), divisible by all these orders, with
\(b_r\mid b_{r+1}\). The tame-cover/root-stack equivalence extends
each torsor to the proper root stack along all components of
\(\Delta_0\). Here \(b_r\) is prime to the residue characteristic;
the order of \(\Gamma_r\) need not be.
Locally this is tame Abhyankar extension: adjoining the indicated
root kills inertia and the normalization is etale over the root
chart. The unique extensions descend from geometric points to
the original finite field. Thus no equivalence between *all*
geometric generic and special tame covers is being assumed.

Proper henselian invariance lifts these torsors over \(W(k_0)\).
Its full faithfulness lifts their right actions, transition maps,
and every relation. Base change to the strictly henselian
\(W(\bar k_0)\) and then to \(\bar D\) supplies the specified
semilinear action, because the whole construction was over
\(W(k_0)\). Coordinate-neutralized root gerbes give compatible
boundary frames. The finite nonempty frame sets have surjective
transition maps, so compatible frames exist independently at all
finitely many punctures. Their transports are the \(B_i\) of (5).

Only \(\ell\)-power root orders were used. Therefore the full
characteristic-zero boundary homomorphism is
\(\exp(t_\ell N_i)\): every other prime factor, including the
original residue-characteristic factor, acts trivially.
The component argument of Section 6 shows that the geometric image
is exactly the original geometric compact image at every quotient
and hence in \(H_0\). In this smooth case removing the marked gerbes
from a connected component of a finite etale cover does not
disconnect it: the component is a smooth geometrically irreducible
curve as a stack. Thus \(\sigma_1\) has the claimed density and
arithmetic tower. No regularity was used.

## 4. One auxiliary cover for all punctures (L_ABG_COVER)

Choose local parameters \(t_i\) at the closed points of \(\Delta_1\).
They may be chosen over the respective residue fields, with their
usual descent compatibility. Let \(g=g(C_1)\) and
\(\delta=\deg(\Delta_1)\). Choose an effective pole divisor \(E\)
disjoint from \(\Delta_1\) with
\[
                         \deg E>2g-2+2\delta.
\]
Serre duality implies \(H^1(\mathcal O(E-2\Delta_1))=0\).
The jet-evaluation exact sequence consequently gives a rational
function \(t\), with poles bounded by \(E\), satisfying
\[
                         t\equiv t_i\pmod{\mathfrak m_i^2}
\]
at every marking. In particular every marked valuation of \(t\)
is exactly one and the tangent unit is exactly 1. This is a single
function over \(D\); no independent covers have to be reconciled.

Normalize \(C_1\) in \(D(C_1)[w]/(w^e-t)\). At any geometric
marked point the polynomial is Eisenstein, so it remains
irreducible over \(\bar D(C_1)\). The resulting \(C_2\) is smooth,
projective, geometrically connected, and has degree \(e\).
The completed local extension at a closed marking is
\[
                     k(x)[[t]]\subset k(x)[[w]],\quad t=w^e.
\]
This proves uniqueness, ramification index \(e\), and equality
of residue fields above each marking.

In the \(w\)-coordinate the pulled-back boundary is
\(\exp(e t_\ell N_i)\). The residual-gerbe map is
\(\zeta\mapsto\zeta^e\). The neutral objects agree because
\(h^*(1/t)=(1/w)^e\), with no constant unit. Since the map is
defined over \(D\), the pulled-back boundary frames have exactly
the original transports \(B_i\), including at permuted points.
Replacing \(t_i\) by \(t\) adds no twist: the unit \(t/t_i\) has
residue 1, whose formal roots with constant term 1 are unique
and compatible in characteristic zero.

Other branch points of \(h\) cause no ramification of \(h^*\sigma_1\):
the local system already extends across their images in \(U_1\).
To check density on \(C_2\), remove these extra branch values.
The remaining map is finite etale of degree \(e\), so its
fundamental-group image has finite index. Removing finitely many
points from the smooth target surjects on its original fundamental
group. Thus the image of \(\sigma_2\) has finite index in that of
\(\sigma_1\). A finite-index subgroup of a dense subgroup of the
connected group \(\mathrm{PGL}_n\) remains Zariski dense.

## 5. Simultaneous arithmetic gluing (L_ABG_GLUE)

Form \(C_0=C_1\cup C_2\) by identifying the corresponding closed
marked points with their identical residue fields. This is a
projective nodal curve. Its geometric dual graph has two vertices
and \(|I|\) edges. The local-to-global deformation map to the
product of the local node deformation functors is smooth.
This follows either from the curve deformation result recorded
in primary_sources.txt, or from the local-to-global Ext sequence:
the obstruction terms \(H^2(T)\) and \(H^1(\mathcal E xt^1)\)
vanish, the latter sheaf having finite support. Lifting an ample
line bundle and algebraizing gives a projective smoothing over
\(D[[s]]\).

Choose **each** node's smoothing direction in the prescribed
tangent coordinates before sending all local smoothing parameters
to \(s\). Then its completed equation is \(a_i b_i=s\), with
\((a_i/t)(x_i)=(b_i/w)(y_i)=1\). Independent tangent
normalizations at several nodes are not inferred from one later
rescaling of \(s\). At nonsplit nodes this choice is over the
respective finite residue field and descends over \(D\).

For \(b\mid m\), use compatible roots \(s_b^b=s\). The balanced
twisted models over \(\bar D[[s_b]]\) have charts
\[
 [\operatorname{Spec}(\bar D[[s_b]][u_i,v_i]/(u_iv_i-s_b))/\mu_b],
 \quad a_i=u_i^b,\quad b_i=v_i^b,\quad
 \zeta(u_i,v_i)=(\zeta u_i,\zeta^{-1}v_i).
                                                               \tag{8}
\]
They are proper flat tame DM curves, with finite diagonal,
projective coarse space, and geometrically reduced fibers.
Their normalizations on the special fiber are the two
componentwise root stacks. The power maps between models are
compatible. The construction is defined over \(D\); extend
the Witt action fixing every \(s_b\). It preserves the models.
The tangent units of residue 1 identify (8)'s neutralizations
with those of Section 4, equivariantly and compatibly.

Now choose cofinal open normal \(J_r\subset J\), and let \(Q_r=J/J_r\).
Extend the structure group of each component torsor from \(H_0\)
to \(Q_r\), factoring through a suitable \(\Gamma_j\).
Choose divisible \(\ell\)-power orders \(b_r\) killing every
stage-\(r\) boundary image on both components. These orders
are for torsors; no Borel-level or dominant-cocharacter assertion
is being added here.

In the common node generator \(\zeta\), the first action is
\(u_{i,r}(\zeta)\); the second is \(u_{i,r}(\zeta)^{-e}\).
The exponent is negative because the positive coordinate
generator on the second branch is \(\zeta^{-1}\), and its
absolute multiplier is \(e\) by the cover. Reducing (7) gives
\[
             P_{i,r}u_{i,r}(\zeta)^{-e}P_{i,r}^{-1}
                       =u_{i,r}(\zeta).             \tag{9}
\]
Use left multiplication by \(P_{i,r}\) to identify the second
right-torsor fiber with the first. It is right \(Q_r\)-equivariant,
and (9) makes it inertia-equivariant. Equation (6) makes **every**
arithmetic transport square commute. The square at a split
point is \(P_{i,r}A_{i,r}=A_{i,r}P_{i,r}\).

These are actual fiber isomorphisms, not merely equalities of
conjugacy classes. They glue the normalization torsors to a
finite etale right \(Q_r\)-torsor on the whole twisted special
curve. One can check this locally before taking the quotient:
finite etale branch covers are constant near the two origins;
identifying their fibers glues a constant cover across \(uv=0\),
with the same \(\mu_{b_r}\)-action. It is therefore etale at the
node. Different nodes are disjoint, so their identifications
are independent. Extra cycles in the dual graph record choices
of transport; they impose no additional relation.

All identifications are reductions of the fixed elements \(P_i\).
Hence the gluing preserves every transition map and relation in
the tower. Proper henselian invariance lifts the glued torsors
to the entire models (8). Full faithfulness lifts the right
actions, the semilinear isomorphisms, and the transition maps,
after pullback to common divisible indices. It also preserves
their compositions and inverses. Restricting to the common
smooth geometric generic curve and taking the inverse limit
gives a continuous parameter with values in
\(\varprojlim Q_r=J\), equipped with the required arithmetic
action. This proves compactness without assuming the glued
finite torsors are connected.

## 6. Density and tensor compatibility (L_ABG_DENSITY)

We supply the component fact used both here and in Section 3.
Let \(\mathcal Y/S\) be a proper flat tame DM curve over a complete
strictly henselian DVR, with finite diagonal, projective coarse
space, and geometrically reduced fibers. Let
\(\mathcal T\to\mathcal Y\) be a finite etale torsor. Along a
section of the smooth scheme locus trivialize its finite
fiber over \(S\). Its partitions into connected components
on the geometric special and generic fibers coincide.

Indeed proper henselian invariance lifts each special-fiber
open-and-closed summand of \(\mathcal T\) to a summand
\(\mathcal Z\). The coarse space \(Z\) of \(\mathcal Z\) is
proper and flat over \(S\), and formation of its fibers
commutes with base change. These assertions can be checked
in the inherited root/node quotient charts: averaging over
the finite group of invertible order makes invariants an
exact direct summand, preserving flatness and base change.
Finite etale pullback causes no new non-tame stabilizers.
The coarse space is projective (its map to the given
projective coarse curve is finite).

The special fiber \(Z_s\) is nonempty, connected, reduced,
and proper, so \(H^0(Z_s,\mathcal O)=k(s)\).
Let \(R\) be the base DVR with uniformizer \(\varpi\).
Proper coherence makes \(M=H^0(Z,\mathcal O)\) a finite
\(R\)-module. Flatness gives
\[
                 M/\varpi M\ \lhook\joinrel\longrightarrow\
                              H^0(Z_s,\mathcal O)=k(s).
\]
The image contains 1, so Nakayama gives \(M=R\cdot1\);
flatness and a nonempty fiber make \(R\to M\) injective.
Flat base change for \(H^0\) now gives
\(H^0(Z_{\bar\eta},\mathcal O)=\bar K\).
In particular the geometric generic fiber is connected.
Every lifted summand has exactly one such component, proving
the partition assertion. This argument does not assume
connectedness of the entire torsor.

Apply this to each lifted nodal torsor, choosing a section through
the first component's punctured smooth locus and compatible
frames of the tower. The orbit of the frame under the first
component monodromy is contained in its component in the whole
special torsor. The component fact identifies that component's
section fiber with a geometric generic component's section
fiber. If \(H_1\) and \(H_\tau\) are the two monodromy images,
\[
                  \operatorname{im}(H_1\to Q_r)
                      \subset\operatorname{im}(H_\tau\to Q_r)
                       \quad\text{for every }r.     \tag{10}
\]
Both images are compact and hence closed in \(J\). Cofinality
of \(J_r\) implies \(H_1\subset H_\tau\). Since \(H_1\) is
dense in \(\mathrm{PGL}_n\), so is \(H_\tau\).

For an algebraic representation of \(\mathrm{PGL}_n\), choose
a \(J\)-stable lattice (after the representation's coefficient
extension if necessary). Every finite lattice reduction factors
through some \(Q_r\). The associated sheaf on the smooth scheme
locus of the model extends that reduction and restricts on the
special components to the specified reductions of
\(\sigma_1,\sigma_2\), with their arithmetic actions.
Tensor products and all morphisms compare through this same
tower; denominators in a morphism can be cleared first.
No eigenobject or automatic Frobenius descent is used. QED.

## 7. Comparison and certification limits

The prior staged Frobenius result, parameters.tex,
`lem:compact-conjugator` and `prop:nodal-parameter`, treats a
single rational puncture and a regular nilpotent logarithm.
The staged several-point result supplies geometric multi-node
constructions with arbitrary nilpotent types, explicitly
without Frobenius. The theorem above proves their missing
**parameter-level** simultaneous arithmetic compatibility.
It additionally treats nonsplit arithmetic orbits and constructs
the local cocharacter over the original coefficient field.

The attempt to reuse diagonalizability of \(A\) outside the
regular case is invalid: \(A=\operatorname{diag}(U,qU)\),
\(U=\left(\begin{smallmatrix}1&1\\0&1\end{smallmatrix}\right)\),
and \(N=\left(\begin{smallmatrix}0&0\\I_2&0\end{smallmatrix}\right)\)
give \(AN=qNA\) with nonsemisimple \(A\). This is an obstruction
to that *extension route*, not a refutation of the manuscript's
regular-case assertion. No false literal manuscript assertion
has been established in this targeted investigation.

`verify.py` checks exact algebraic identities, CRT primary
projectors, nonsplit rational primary factors, all nilpotent
partitions through dimension six, a common compact subgroup
for several different boundary identifications, a nontrivial
two-point Frobenius orbit, both signs, and the polynomial
jet construction. It also independently replays the archived
Jacobian primary decomposition. It does **not** mechanically
prove the geometric or universal quantified theorem; the proof
is the argument above, subject to independent mathematical review.
There is no Lean source or compiler certificate.

The primary-source review recorded in primary_sources.txt
supports the geometric hypotheses used here. It found no
explicit combined arithmetic theorem in those three cited
papers; this is not an exhaustive originality search. The
spectral-grading calculation is not claimed to be novel by
itself. Novelty, publishable significance, and independent
acceptance of the combined theorem remain for the Host's
Reviewer. Accordingly this artifact does not declare the
campaign complete or mark any proof-graph node reviewer-proved.
