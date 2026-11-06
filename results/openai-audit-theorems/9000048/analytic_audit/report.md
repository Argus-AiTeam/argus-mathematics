# From the reviewed finite jets to the analytic surface germ

## Result and boundary

**Theorem (prose proof, submitted for independent review).** The conclusions
of the reviewed `CT_joint_inputs` and `J_all_orders` results imply
`prop:analytic-counterexample` of the staged September-23-2026 manuscript.
There is a normal complex surface germ \((X,x)\), with \(x\) genuinely
singular and the complement smooth, for which
\[
\mathcal T_X=\mathcal Hom_{\mathcal O_X}
                 (\Omega^1_{X,\mathrm{an}},\mathcal O_X)
             \simeq\mathcal O_X^2.
\]
It admits a proper resolution whose entire exceptional set is one smooth
genus-21 curve \(C\), with \(C^2=-10\). The dualizing sheaf is trivial,
the discrepancy of \(C\) is \(-5\), and
\[
                         33\leq p_g(X,x)\leq39.
\tag{0.1}
\]
The upper bound is an elementary additional consequence of the same
filtration; it is not asserted to be optimal or new. The corresponding
graded lifting threshold is sharp: the relevant \(H^1\) vanishes for
every \(n\geq9\), whereas its value at \(n=8\) has dimension one.

The strongest prior result was the combination of simultaneous
curve/residue input existence and compatible jets of every finite order,
with a stable **formal** limit. The two completed independent Reviewer
receipts are

* `handoffs/70d65f383197/round-0001.json`: `CT_joint_inputs`;
* `handoffs/bf979be90014/round-0001.json`: `J_all_orders`.

These are under
`/home/argustest/zimo/.argus-campaign-9000048/projects/46e84e6fea35/`.
Both have `review.status=done`; their proofs and checkers are reused,
not rebuilt or replayed. Their acceptance does not approve this report.
The new mathematical implication is from these inputs to **actual
holomorphic fields on one Hausdorff neighborhood** and the **full**
analytic derivation sheaf at a singular normal point.

There is no claim here of algebraization, an explicit affine equation,
kernel formalization, independently established novelty, publishable
significance, or completion of the campaign. Those remain separate.
No obstruction to this analytic implication was found. Inaccessibility
of one cited source and a printing error in another are not refutations
of the proposition.

The proof uses only a finite jet. It does not assert convergence of the
entire formal construction, that a resolution containing \(C\) is Stein,
flatness of the contraction, termwise base change, or invariance of the
initial meromorphic volume under every overlap.

## 1. Inputs and the propositions actually used

The upstream results supply a smooth connected projective complex curve
\(C\), a line bundle \(L\), and a fixed isomorphism
\[
g(C)=21,\qquad \deg L=10,\qquad L^4\simeq K_C.
\tag{1.1}
\]
They also give \(h^0(L)=2\), \(h^0(L^2)=3\), and the following finite
analytic data. On the split normal bundle \(N=L^{-1}\), only the six
disk-to-outside identifications are changed. Each change is a finite
composition of actual local flows of
\[
D=t^k\bigl(b(z)t\partial_t+h(z)\partial_z\bigr),\qquad k\geq1.
\tag{1.2}
\]
The coefficients are holomorphic on the punctured-disk overlaps.
The changes fix \(C\) and its conormal, and local fields
\[
v_i^{[8]}=t(A_iE_t+B_i\partial_z),\quad
E_t=t\partial_t,\quad
A_i=\sum_{k=0}^7 A_{ki}t^k,\quad B_i=\sum_{k=0}^7 B_{ki}t^k
\tag{1.3}
\]
match through coefficient degree eight in the logarithmic basis.
Their determinant satisfies
\[
A_1B_2-A_2B_1=t^2(1+O(t)).
\tag{1.4}
\]
The coefficient one holds along **all** of \(C\), including the common
zeros of the initial row. These are precisely the conclusions of the
reviewed jet result at \(N=7\), not extra analytic assumptions.

The substantial external inputs of the present proof are as follows.
The locators name propositions, not merely papers.

| Input | Read source and application |
|---|---|
| Curve duality | Serre, DOI `10.1007/BF02564268`, section 3 no.13, Theorem 4, p.22, and section 4 no.16, Theorem 5, p.24. The completed upstream source reading is reused for compact smooth \(C\) and its line bundles. |
| Negative-definite contraction | Grauert 1962, DOI `10.1007/BF01441136`, section 4.8(e), pp.366--367; section 2.1, p.337; section 2.4, Definition 3, pp.339--340. The hypotheses are a smooth complex surface and a compact nowhere-discrete analytic subset with negative-definite intersection matrix. |
| Compact nilpotence and coherence | Grauert 1960, DOI `10.1007/BF02684746`, section 1.6, Satz 4 and its proof, p.15; section 2.1, Definition 3 and (a)--(c), p.16. These apply also to nonreduced complex spaces. |
| Proper direct-image coherence | Grauert 1960, introduction (I), p.7, and section 6.5, Hauptsatz I, p.59: proper holomorphic map of complex spaces, coherent sheaf on the source. |
| Analytic formal functions | Grauert 1960, section 6.5, the ideals preceding Hauptsatz II and Hauptsatz IIa, p.59, with the correction below. Properness and coherence are required, not flatness. |
| Correction | Grauert 1963, DOI `10.1007/BF02684291`, items 1--2, pp.35--36. Its changed estimates and the withdrawn closedness assertion are distinguished below. |
| Stein vanishing for spaces | Grauert 1960, section 2.3, Satz 3, p.17: positive coherent cohomology vanishes on a holomorphically complete complex space, including a singular one. |
| Depth of a normal local ring | Stacks Project, [Tag 031S](https://stacks.math.columbia.edu/tag/031S), Lemma 10.157.4, read 2026-11-05: a Noetherian normal ring is \(R_1\) and \(S_2\). |
| Dualizing-sheaf criterion | Flenner--Zaidenberg, `arxiv:math/0109221v1`, section 2.4, Definition 2.18 and following paragraph, p.19: a normal surface singularity is Cohen--Macaulay, and is Gorenstein with trivial dualizing module exactly when its puncture has a nowhere-zero holomorphic two-form. No good \(\mathbb C^*\)-action is required by this paragraph. |

Original Grauert PDFs, relevant page images/text, and the complete correction
are archived in `research/literature/`. See
`research/literature/grauert_analytic_sources.md` for the precise readings.
Hauptsatz I on p.59 prints the wrong source/target letter for the sheaf;
the introduction on p.7 has the unambiguous source formulation.
The 1963 correction repairs the indicated polyradius estimates and
inductions. Its item 2 withdraws the asserted closedness of the failure
locus of the **fiberwise** base-change map in section 7, Satz 2. That
claim is not used. Neither corrected proper coherence nor the
inverse-limit formal-functions theorem requires flatness.

The cited Demailly book could not be retrieved. No unexamined Demailly
statement is an assumption of this proof: section 5 below uses Grauert's
compact nilpotence theorem, and section 8 replaces the general analytic
Hartogs argument by a direct descent and finite-colength argument.
This changes the proof, not the proposition. Source attributions for the
new applications remain for the normal independent Reviewer; the Engineer
does not impersonate that reader.

We use the usual analytic local algebra of complex spaces. In particular,
their local rings are quotients of convergent power-series rings and are
Noetherian. To recall the algebra behind this assertion, Weierstrass
preparation and division reduce a nonzero ideal in
\(\mathbb C\{z_1,\ldots,z_e\}\), after a linear coordinate change, modulo
a distinguished polynomial in \(z_e\). The quotient is finite over
\(\mathbb C\{z_1,\ldots,z_{e-1}\}\); induction makes the ideal finitely
generated. This is the Cartan--Ruckert basis input explicitly used in
Grauert's p.15 proof. Finite locally free sheaves and the kernels,
images and quotients below are coherent by the read p.16 statements.

## 2. Finite flow germs are genuine, uniformly defined maps

Choose a compact annular band strictly inside each punctured-disk
overlap, and a slightly wider band. On the latter, all the finitely
many \(b,h\) and their needed derivatives are bounded. For sufficiently
small \(|t|\), (1.2) has
\[
                 D(t)=O(t^2),\qquad D(z)=O(t)
\tag{2.1}
\]
uniformly on the bands. The elementary holomorphic ODE existence
argument therefore supplies the flow for times from \(-1\) to \(1\)
on one transverse neighborhood of the smaller compact band.

Here is why vanishing, rather than a formal exponential, gives the
uniform time interval. If the coefficient bounds are \(B\), take
\(|t(0)|<\epsilon\) and work in \(|t|<2\epsilon\). The normal
displacement on a unit time interval is bounded by
\(4B\epsilon^2\), and the base displacement by \(2B\epsilon\),
after increasing \(B\) for the finitely many fields. Choose these
bounds smaller than \(\epsilon/2\) and the annular buffer,
respectively. Local Picard existence and uniqueness, followed by
continuation inside this buffered domain, give the time-one map,
holomorphic in the initial point, and its inverse time-minus-one
map. The same estimates work for complex time near this interval.
No trajectory reaches a chart boundary. Finite successive shrinkings
give every specified finite composition and its inverse.

Write the resulting inside-to-outside maps as \(\Phi_j\), \(1\leq j\leq6\).
In the split identification they satisfy
\[
                     T=t+O(t^2),\qquad Z=z+O(t).
\tag{2.2}
\]
They are injective on the retained domains: uniqueness of the inverse
flow, also for the finite compositions, rules out two preimages.

## 3. Separation and the quotient sections

Take mutually disjoint coordinate disks \(D_j\), with annular radii
\[
                   0<a_j<a'_j<b'_j<b_j
\tag{3.1}
\]
strictly inside the disks. Choose the bands in section 2 wider than
the closed annuli \([a_j,b_j]\). In \(N\) retain small open tubular
pieces \(V_j\) over \(|z_j|<b'_j\), and \(V_0\) over
\[
                C\setminus\bigcup_j\{|z_j|\leq a'_j\}.
\]
Their transverse thicknesses can be chosen so that the maps are
defined across the closed bands, their images remain inside the
corresponding disjoint \(D_j\), and
\[
 |z_j(\Phi_j(p))-z_j(p)|<(a'_j-a_j)/2
\tag{3.2}
\]
there. The maps equal the identity on the zero section, so these
choices are possible uniformly.

Identify \(p\) with \(\Phi_j(p)\) precisely on the open set
\[
 A_j=\{p\in V_j:a_j<|z_j(p)|<b_j,\ \Phi_j(p)\in V_0\}.
\tag{3.3}
\]
Each map is a biholomorphism onto an open subset. Different images
in \(V_0\) are disjoint because they lie over disjoint disks.
Consequently each equivalence class has at most two members. No
points in one piece become identified, and there are no new
triple-overlap or longer-chain conditions.

The graph of \(\Phi_j|_{A_j}\) is closed relative to \(V_j\times V_0\).
Indeed, suppose \(p_\nu\to p\in V_j\) and \(\Phi_j(p_\nu)\to q\in V_0\).
The limiting source radius is at least \(a_j\) and less than
\(b'_j<b_j\). The map is defined across this closed band, so
\(q=\Phi_j(p)\). A limiting radius equal to \(a_j\) would give
\[
 |z_j(q)|\leq a_j+(a'_j-a_j)/2<a'_j,
\]
contradicting \(q\in V_0\). Thus \(p\in A_j\). Both limiting points
are inside the retained open pieces, so a transverse boundary
cannot invalidate this argument.

The entire relation on the finite disjoint union is the union of
these graphs, their inverses and the diagonals, hence is closed.
The quotient map is open: the saturation of an open set is open
under these open identifications. For two unrelated representatives,
closedness gives product neighborhoods containing no related pair;
their open quotient images are disjoint. The quotient is Hausdorff.
Its restriction to each \(V_i\) is injective and open. These charts
give a smooth complex surface \(Y\); a finite open quotient of
second-countable pieces remains second countable. The zero sections
give the original compact curve, with unchanged complex structure.

Equation (2.2), composed with the original split changes, preserves
the conormal bundle. Thus, for \(I=\mathcal O_Y(-C)\),
\[
                 I/I^2\simeq L,\qquad C^2=-\deg L=-10.
\tag{3.4}
\]
Let \(F=\mathcal T_Y(-\log C)\). In divisor coordinates it is freely
generated by \(E_t,\partial_z\). The row indices \(0,\ldots,7\) in
(1.3) specify its coefficients in degrees \(1,\ldots,8\).
Compatibility of the actual finite maps therefore gives sections
\[
       \bar v_i\in H^0(Y,IF/I^9F)\subset H^0(Y,F/I^9F).
\tag{3.5}
\]
This is not only compatibility of abstract formal power series.
Their polynomial representatives have
\[
 \det_{\log}(v_1^{[8]},v_2^{[8]})=t^4(1+O(t)),\qquad
 \det_{\mathrm{ordinary}}(v_1^{[8]},v_2^{[8]})=t^5(1+O(t)).
\tag{3.6}
\]
The second equality has the extra factor \(t\) from \(E_t=t\partial_t\).

## 4. Infinitesimal vanishing, and its exact threshold

Restriction of a logarithmic field to its tangential component gives
\[
        0\longrightarrow\mathcal O_C\longrightarrow F|_C
             \longrightarrow\mathcal T_C\longrightarrow0.
\tag{4.1}
\]
The first map is the Euler class. To see its independence of coordinates,
write \(T=t\,u(t,z)\), \(Z=\psi(z)+O(t)\). In the new logarithmic basis
the pushforwards of \(E_t,\partial_z\) have matrix
\[
\begin{pmatrix}
tT_t/T&T_z/T\\
tZ_t&Z_z
\end{pmatrix}.
\tag{4.2}
\]
Along \(C\), its first column is \((1,0)^t\), and the lower-right
entry is \(\psi'\). This proves (4.1); no splitting is asserted.

Using \(K_C=L^4\), twist to obtain
\[
0\longrightarrow L^n\longrightarrow F|_C\otimes L^n
       \longrightarrow L^{n-4}\longrightarrow0.
\tag{4.3}
\]
The two outer first cohomology groups are dual to
\(H^0(L^{4-n})\) and \(H^0(L^{8-n})\).
For \(n=9+k\), \(k\geq0\), these bundles have degrees
\(-50-10k\) and \(-10-10k\), respectively. A nonzero section would
have an effective divisor of that negative degree, which is impossible.
Thus
\[
                 H^1(C,F|_C\otimes L^n)=0\quad(n\geq9).
\tag{4.4}
\]
At \(n=8\), \(H^1(L^8)=0\), \(H^2(L^8)=0\), and
\(H^1(L^4)\simeq H^0(\mathcal O_C)^*\simeq\mathbb C\).
The same exact sequence gives
\[
                  h^1(C,F|_C\otimes L^8)=1.
\tag{4.5}
\]
The threshold nine is therefore not replaceable by eight in this
graded vanishing assertion.

Because \(C\) is Cartier and \(F\) is locally free,
\[
              I^nF/I^{n+1}F\simeq F|_C\otimes L^n.
\tag{4.6}
\]
Set \(E=I^9F\). For every integer \(r\geq1\), \(E/I^rE\) has
the finite filtration (4.6) with \(9\leq n<9+r\).
Cohomology exact sequences, beginning with (4.4), give
\[
                         H^1(Y,E/I^rE)=0.
\tag{4.7}
\]
The graded sheaves are pushed forward from the closed compact curve,
so their cohomology on \(Y\) is their cohomology on \(C\). In particular
this is not an assertion that \(H^1(Y,E)\) already vanishes.

## 5. Proper contraction and uniform cofinality

The intersection matrix is the negative-definite one-by-one matrix
\([-10]\). Grauert's criterion applies to the **already Hausdorff
smooth surface** and contracts precisely \(C\). Its definition of
exceptionality and the normal holomorphic reduction give, after
restricting to a representative,
\[
\begin{gathered}
\pi:Y\longrightarrow X\ \text{proper},\quad X\ \text{normal},\\
\pi^{-1}(x)=C\ \text{set-theoretically},\quad
Y\setminus C\simeq X\setminus\{x\},\quad
\pi_*\mathcal O_Y=\mathcal O_X.
\end{gathered}
\tag{5.1}
\]
The connected curve maps to one point in the discrete contracted set.
The complement is smooth. Choose a small Stein representative of
the target and take its **full inverse image** as the new \(Y\).
This preserves properness. A positive-dimensional compact curve in
\(Y\) is no reason to call \(Y\) Stein; no such claim is made.

Let \(J=\mathfrak m_x\mathcal O_Y\). It is coherent and has zero set
exactly \(C\). Since \(C\) is reduced, \(J\subseteq I\).
Consider the possibly nonreduced complex subspace
\[
                         Z=(C,\mathcal O_Y/J).
\]
Its reduction is \(C\); its nilradical is \(I/J\).
Grauert's section 1.6, Satz 4 applies on its compact underlying space.
It supplies a single integer \(a\geq1\) such that
\((I/J)^a=0\). Equivalently, on a neighborhood of all of \(C\),
\[
                    I^a\subseteq J\subseteq I,\qquad
                    I^{ar}\subseteq J^r\subseteq I^r
                    \quad(r\geq1).
\tag{5.2}
\]
One can also read the proof at p.15 locally: the analytic
Nullstellensatz gives a power of each reduced generator in \(J\);
coherence extends the inclusion to a neighborhood, and a finite cover
of \(C\) makes the exponent uniform. This supplies both the local
and compact-uniform assertions, without assuming the scheme fiber
is reduced or the map flat.

All such shrinkings may be made on \(X\). If \(U\) is an open
neighborhood of the entire compact fiber, properness makes
\(\pi(Y\setminus U)\) closed and disjoint from \(x\). A sufficiently
small Stein neighborhood \(X'\) of \(x\) avoids it, and
\(\pi^{-1}(X')\subset U\).

## 6. Formal functions detect a zero obstruction, then actual lifts

Proper direct-image coherence makes \(R^1\pi_*E\) coherent.
The corrected analytic formal-functions theorem gives
\[
 \widehat{(R^1\pi_*E)_x}
       \simeq\varprojlim_r H^1(Y,E/J^rE).
\tag{6.1}
\]
This is the completed-stalk theorem, not the fiberwise base-change
map whose failure locus appears in the correction. The quotient
sheaves are supported on \(C\); restricting \(Y\) to any neighborhood
of that support does not change their cohomology. Thus their
cohomology agrees with the stalks of the corresponding higher direct
images in Grauert's statement. No flatness is being inserted.

The right side of (6.1) is zero for a concrete reason. For every \(r\),
\[
 J^{ar}E\subseteq I^{ar}E\subseteq J^rE
\]
gives a factorization of the transition map
\[
 H^1(Y,E/J^{ar}E)\ \longrightarrow\
 \underbrace{H^1(Y,E/I^{ar}E)}_{0}\
 \longrightarrow H^1(Y,E/J^rE).
\tag{6.2}
\]
An element of the inverse limit has its \(r\)-component equal to the
image of its \(ar\)-component, hence equal to zero. This proves
pro-zero, not termwise zero, and does not require a separate
Mittag--Leffler assumption.

Put \(M=(R^1\pi_*E)_x\), a finite module over the analytic local ring
at \(x\). If its completion is zero, every \(m\in M\), viewed as the
compatible sequence of its residue classes, has zero image in
\(M/\mathfrak m_xM\). Thus \(M=\mathfrak m_xM\), and Nakayama gives
\(M=0\). This only uses finiteness; it does not pretend that arbitrary
nonfinite modules are detected by completion.
Off \(x\), \(\pi\) is an isomorphism, so its higher direct image is
zero there as well. After the allowed shrinking,
\[
                             R^1\pi_*E=0.
\tag{6.3}
\]

The direct image \(\pi_*E\) is coherent too. Cartan B in the read
**complex-space** formulation applies on the Stein target \(X\).
The low-degree Leray exact sequence consequently gives
\[
                             H^1(Y,E)=0.
\tag{6.4}
\]
In
\[
                0\longrightarrow E\longrightarrow F
                   \longrightarrow F/I^9F\longrightarrow0
\]
the connecting obstruction therefore vanishes for every section.
In particular (3.5) lifts both sections on the same \(Y\):
\[
                             v_1,v_2\in H^0(Y,F).
\tag{6.5}
\]
This is actual analytic lifting of the prescribed finite quotient,
not inference of convergence from an infinite compatible jet.

## 7. Lift errors, a common unit neighborhood, and the volume

Locally \(v_i-v_i^{[8]}\in I^9F\), while \(v_i^{[8]}\in IF\).
Hence
\[
v_1\wedge v_2-v_1^{[8]}\wedge v_2^{[8]}
                          \in I^{10}\det F.
\tag{7.1}
\]
For arbitrary coefficient functions \(a,b,c,d,p,q,r,s\), this is
the universal identity
\[
\begin{split}
&\det\begin{pmatrix}ta+t^9p&tc+t^9r\\tb+t^9q&td+t^9s\end{pmatrix}
                 -t^2(ad-bc)\\
&\hspace{12mm}=t^{10}(as+pd-br-cq)+t^{18}(ps-qr).
\end{split}
\tag{7.2}
\]
The logarithmic determinant is still \(t^4\) times a unit with
restriction one to \(C\); its relative error has order at least six.
Its ordinary determinant has the additional factor \(t\):
\[
             v_1\wedge v_2=t^5u(t,z)\partial_t\wedge\partial_z,
             \qquad u(0,z)=1.
\tag{7.3}
\]
No division by the initial row is involved, so the common zeros of
that row cause no exception.

Each local \(u\) is nonzero on a neighborhood of its part of \(C\).
A finite cover of compact \(C\) gives one neighborhood on which the
wedge has no zero outside \(C\), and the properness argument in
section 5 makes it the inverse image of a smaller Stein target.
Since \(F=\mathcal T_Y\) away from \(C\), the two fields are a frame
of \(\mathcal T_{Y\setminus C}\) there.

The original expression \(t^{-5}dt\wedge dz\) need not glue under
every positive-order change. For example the allowed local flow
\(T=t/(1-t), Z=z\) multiplies that expression by \((1-t)^3\).
This example is an illustration of the unjustified shortcut, not a
counterexample to the reviewed transition choices. The two-form
used here is instead the dual of the **actual global wedge**:
\[
                         t^{-5}u(t,z)^{-1}dt\wedge dz.
\tag{7.4}
\]
Its local expressions glue automatically because the actual fields
do. Thus volume transport introduces no extra unproved invariance
condition.

## 8. Singularity and the entire analytic derivation sheaf

If \(x\) were smooth, choose a nowhere-zero holomorphic two-form
\(\eta\) near it. Its pullback is holomorphic on \(Y\), nonzero off
\(C\), and has divisor \(bC\) for an integer \(b\geq0\). Therefore
\[
                            K_Y\cdot C=bC^2\leq0.
\]
The conormal sequence of \(C\) in \(Y\), on taking determinants,
is the adjunction identity \(K_C=(K_Y+C)|_C\). It gives instead
\[
                       K_Y\cdot C=2g-2-C^2=40+10=50.
\tag{8.1}
\]
This contradiction proves that \(x\) is singular. It is the only
singular point of the chosen representative.

The following argument proves both extension and generation, without
assuming the unavailable general Hartogs citation. For an open
\(U\subset X\) and \(f\in\mathcal O_X(U)\), apply \(v_i\) to
\(\pi^*f\). The resulting holomorphic function on \(\pi^{-1}U\)
descends uniquely by \(\pi_*\mathcal O_Y=\mathcal O_X\). This
defines a derivation \(w_i(f)\), compatible with restrictions,
addition, constants and products. To check explicitly that it is
an **analytic** derivation, embed a representative in a smooth
space with coordinates \(x_\alpha\). The functions
\(a_{i\alpha}=w_i(x_\alpha)\) are holomorphic, and for every defining
relation \(f\) the identity
\(\sum_\alpha a_{i\alpha}\partial_\alpha f=0\) follows on the
puncture and then on reduced \(X\). The usual analytic chain rule
identifies this tuple with a section of
\(\mathcal Hom(\Omega^1_{X,\mathrm{an}},\mathcal O_X)\).
Off \(x\) these sections are the descended frame.

Here is the algebraic extension lemma needed for its coefficients.

**Finite-colength lemma.** Let \((R,\mathfrak m)\) be a Noetherian
local domain of depth at least two. If \(R^r\hookrightarrow M\) is
an injection into a finite torsion-free module, with finite-length
cokernel, then it is an isomorphism.

**Proof.** Tensor with \(K=\operatorname{Frac}R\) to identify
\(M\subset K^r\) using the prescribed basis. Some power
\(\mathfrak m^N\) kills the cokernel. Choose a regular sequence
\(f,g\in\mathfrak m\). For any coordinate \(h\) of an element of
\(M\), both \(f^Nh\) and \(g^Nh\) lie in \(R\).
Multiplication by \(g\) is injective modulo \(f^NR\): if
\(gx\in f^NR\), reduction modulo \(f\) gives \(x=fx_1\);
cancelling the nonzerodivisor \(f\) and inducting gives
\(x\in f^NR\). Its power \(g^N\) is therefore injective on the
same quotient. Since
\[
                     g^N(f^Nh)=f^N(g^Nh)\in f^NR,
\]
we get \(f^Nh\in f^NR\), and cancellation gives \(h\in R\).
This holds in every coordinate, so \(M=R^r\). \(\square\)

Apply the lemma at \(x\). The analytic local ring
\(R=\mathcal O_{X,x}\) is a normal two-dimensional domain; the
read normality criterion gives depth at least two. The module
\(M=\mathcal T_{X,x}\) is finite and torsion free: in an analytic
embedding it is the kernel of the finite Jacobian relation matrix
inside \(R^e\). The map
\[
                     R^2\longrightarrow M,\quad
                     (h_1,h_2)\longmapsto h_1w_1+h_2w_2
\tag{8.2}
\]
is injective, since it is an isomorphism off \(x\) and functions
vanishing on that dense open set are zero.

Its coherent cokernel is supported only at \(x\) and has finite
length. More explicitly, form the subspace cut out by its
annihilator. Its underlying set is the point \(x\), so compact
nilpotence gives \(\mathfrak m_x^N\) in that annihilator for some
\(N\). The finite module is then a module over
\(R/\mathfrak m_x^N\), a finite-dimensional complex vector space.
This also makes clear why mere support without coherence would
not suffice.

The lemma makes (8.2) surjective. It indeed extends the **actual
frame coefficients**: choose a nonzero two-by-two minor of the
tuples \(w_i(x_\alpha)\). Cramer's rule expresses the coefficients
of any local derivation as fractions in \(K\), agreeing with its
unique holomorphic frame coefficients on the puncture. The
regular-sequence argument proves these same fractions belong to
\(R\). Equality extends coordinatewise across \(x\); uniqueness
follows from injectivity. Thus, on a representative,
\[
                              \mathcal T_X\simeq\mathcal O_X^2.
\tag{8.3}
\]
This proves full sheaf generation, not merely the existence of two
independent derivations on the smooth locus.

## 9. Canonical discrepancy and geometric genus

Let \(\omega^\circ\) be the nowhere-zero two-form dual to
\(w_1,w_2\) on the puncture. The normal-surface criterion in the
read Flenner--Zaidenberg paragraph gives
\(\omega_X\simeq\mathcal O_X\); choose \(K_X=0\) in this
trivialization. Normality in dimension two also gives
Cohen--Macaulayness, consistently with the depth computation above.
By (7.4) its pullback is meromorphic on \(Y\), with divisor exactly
\(-5C\), so
\[
                             K_Y=\pi^*K_X-5C.
\tag{9.1}
\]
In particular the discrepancy is negative five, not positive five.
Its intersection with \(C\) is \(50\), independently agreeing
with adjunction.

Put \(\mathcal O_{nC}=\mathcal O_Y/I^n\). On a compact curve,
Euler characteristic changes by one on adding a point to a divisor,
so \(\chi(L)=\deg L+1-g=-10\). The supplied \(h^0(L)=2\)
therefore gives \(h^1(L)=12\). The sequence
\[
0\longrightarrow L\longrightarrow\mathcal O_{2C}
               \longrightarrow\mathcal O_C\longrightarrow0
\]
has zero connecting homomorphism on \(H^0(\mathcal O_C)=\mathbb C\),
because constants lift. There is no \(H^2\) for a line bundle on
a curve. Hence
\[
                           h^1(\mathcal O_{2C})=12+21=33.
\tag{9.2}
\]
For every \(n\geq1\), the sequence with kernel \(L^n\) gives a
surjection
\[
                  H^1(\mathcal O_{(n+1)C})
                      \longrightarrow H^1(\mathcal O_{nC}).
\tag{9.3}
\]
Curve duality and the reviewed dimensions give
\[
\begin{array}{c|rrrrrr}
n&0&1&2&3&4&n\geq5\\ \hline
h^1(L^n)&21&12&3&2&1&0 .
\end{array}
\tag{9.4}
\]
Thus (9.3) is an isomorphism for \(n\geq5\), and the successive
kernel dimensions from \(2C\) through \(5C\) are bounded above by
\(3,2,1\). This proves
\[
                  33\leq h^1(\mathcal O_{5C})\leq39.
\tag{9.5}
\]
It does not assume the connecting maps for these later thickenings
are zero.

For completeness, cofinality in (5.2) identifies the **inverse
limits** of the \(I\)- and \(J\)-quotient cohomologies. There are maps
from the \(J^r\)-quotient to the \(I^r\)-quotient and from the
\(I^{ar}\)-quotient to the \(J^r\)-quotient. The two composites are
the corresponding transition maps. They therefore induce mutually
inverse maps on limits. This proves the needed comparison without
asserting equality at any fixed index.

Formal functions for \(\mathcal O_Y\) now identifies
\[
\widehat{(R^1\pi_*\mathcal O_Y)_x}
        \simeq\varprojlim_n H^1(\mathcal O_{nC})
        \simeq H^1(\mathcal O_{5C}).
\tag{9.6}
\]
The coherent higher direct image is supported at \(x\), hence its
stalk is finite length by the same annihilator argument as in
section 8. Such a stalk equals its completion. Its dimension is
\(p_g(X,x)\), proving (0.1). The dual graph has one vertex and no
edges, so \(b=0\), and
\[
                            p_g-g-b\geq33-21=12.
\]

## 10. What the executable certificate does and does not verify

Run, without a network connection:

```bash
python3 research/analytic_audit/verify.py --negative-controls
```

`exact_certificate.json` records the numerical inputs and exact
polynomial/order conclusions used above. The checker independently
derives the two-by-two determinants, coordinate-change formula,
inverse-flow example and volume multiplier, Cramer identities,
the universal lift-error formula, the linear-in-\(k\) negative-degree
bounds, the adjunction/discrepancy arithmetic and the genus bounds.
Its boundary checks retain the nonzero \(n=8\) obstruction and the
possibility of destroying a leading wedge with an insufficiently
accurate lift. Corruptions of signs, orders, filtration indices and
invariants must be rejected.

Before writing those checks, the installed Jacobian catalog was
queried and its exact `matrix.symbolic.determinant.compute` contract
inspected. One bounded operation computed
\[
\det\begin{pmatrix}a+p&c+r\\b+q&d+s\end{pmatrix}
=ad+as-bc-br-cq+dp+ps-qr
\]
over eight algebraically independent variables. The precise payload,
typed response, server/protocol versions and adapter status are in
`jacobian_payload.json`, `jacobian_output.json`,
`jacobian_contract.json` and `jacobian_run.json`. The local checker
binds that response to the payload and independently derives its
polynomial. Replaying the remote operation is optional for the
offline command; its exact adapter invocation is recorded in
`jacobian_run.json`.

These computations are universal algebraic identities and exact
order arithmetic, with explicit illustrative local models. They do
**not** constitute a kernel proof of the analytic existence theorem,
construct an explicit global equation, prove any cited literature
theorem, or replace the separation, compactness, coherence,
regular-sequence and cohomological arguments above. The ledger
therefore records Engineer judgements on a prose proof, with external
assumptions and independent review still visible.
