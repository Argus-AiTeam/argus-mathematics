# The reciprocal stratum without fixed punctures

## Statement and dependency boundary

Let \(r>1\), \(L=\log r\), \(\rho=\sqrt r\), and
\(s=\sigma\rho\), where \(\sigma\in\{+1,-1\}\) is retained. Consider
the normalized nonzero-spin Kato--Muroya data on
\(E=\mathbb C^\times/r^{\mathbb Z}\), with four distinct catenoidal
punctures, nonzero end weights, no common spinor zero, and
\(\deg g=4\). Suppose reflection is
\(I[z]=[1/\bar z]\), all punctures are nonfixed
(\(N_1=N_2=0,N_3=2\)), and the limiting normals have one unoriented
axis.

**Theorem.** No such datum is globally embedded.

For \(\sigma=+1\), an auxiliary reflection and the turning number of
a compact planar oval give a direct obstruction. For \(\sigma=-1\),
an explicit biholomorphism transports the complete datum, not just
its punctures, to the independently excluded conjugation-reflection
locus. Alternatively, the same biholomorphism and the auxiliary
reflection transport it into the accepted all-fixed reciprocal locus.

The previously reviewed end-ordering lemma and the two reviewed
obstructions are dependencies, not new claims here:

- `../kato-muroya-nonzero-reciprocal-fixed/reduction.md`, Section 2:
  a reflection plane containing the end-normal axis fixes every end
  of a globally embedded member.
- `../kato-muroya-nonzero-offreal/obstruction.md`: the normalized
  nonzero-spin conjugation-reflection \((0,0,2)\) one-axis locus is
  globally nonembedded.
- The accepted fixed-puncture obstruction is authenticated by
  `/home/argustest/zimo/.argus-campaign-6800022-run2/projects/0f2d784a6dfc/handoffs/85c325059410/round-0002.json`.
  Its proof is unchanged and is not reopened here.

This is a prose proof with exact algebraic replay, not a Lean proof
or an embedded-surface construction. Independent review of the new
steps and of publishability is still required.

## 1. Homogeneous local data, including zero and infinity

A reflection-invariant unoriented normal axis is either contained in
the reflection plane or perpendicular to it. In the first case the
reviewed end-ordering lemma fixes each puncture, contrary to the
hypothesis. Thus choose the perpendicular axis and label its values
\[
 p_1=p_2=0,\qquad p_3=p_4=\infty .
\]
Reflection exchanges the two orientations, so there are exactly two
ends of each type. Use homogeneous coefficients, never an expression
obtained by substituting infinity for a finite \(p_j\):
\[
 \begin{split}
 P(z)&=\sum_{j=1}^4c_jh(z,q_j),&
 Q(z)&=\sum_{j=1}^4b_jh(z,q_j),\\
 g&=P/Q,&\eta&=-Q^2dz,\\
 c_1=c_2&=b_3=b_4=0,&b_1b_2c_3c_4&\ne0,\\
 h(z,q)&=\sum_{\ell\in\mathbb Z}\frac{s^\ell}{z-qr^\ell}.
 \end{split}                                                    \tag{1}
\]
Proposition 4.2 and Lemma 5.1 of Kato--Muroya 2012 apply to
these coefficients. Put \(H_{jk}=h(q_j,q_k)\). The horizontal local
residues vanish precisely when
\[
 H_{12}=H_{34}=0.
 \tag{2}
\]
Indeed \(R_{01}=-2b_1b_2H_{12}\) and
\(R_{23}=-2c_3c_4H_{34}\); the other horizontal residues then
vanish as well. The remaining residues
\[
 R_{1j}=-\sum_{k\ne j}(c_jb_k+b_jc_k)H_{jk}
 \quad\text{are real and nonzero}.                              \tag{3}
\]
The unique kernel zero is \(z/q\in s r^{\mathbb Z}\).
Consequently (2) gives \(q_2=sq_1\) and \(q_4=sq_3\) in \(E\).

Relabeling within the first half-period pair, changing representatives
by powers of \(r\), and rotating the coordinate (which commutes with
\(I\)) give the following full domain:
\[
 q=(a,sa,r/a,s/a),\qquad 1<a<\rho .                             \tag{4}
\]
Here \(I\) pairs \(1\leftrightarrow3\) and
\(2\leftrightarrow4\). This normalization does not use a radial
rescaling, which would change \(I\). Distinctness additionally
excludes \(a^2=\rho\) when \(s>0\). There is no such additional
collision when \(s<0\). The endpoints \(a=1,\rho\) are fixed-puncture
strata, not omitted members of the open hypothesis.

The reciprocal coefficient relation, with its one common sign
\(\epsilon\), is
\[
 c_3=\epsilon(s/a)\bar b_1,\qquad
 c_4=\epsilon(1/a)\bar b_2,\qquad \epsilon\in\{+1,-1\}.
 \tag{5}
\]
Here it can be derived directly, rather than importing a finite-\(p\)
formula. The actual reflection equations
\(g\circ I=1/\bar g\) and
\(I^*\eta=-\overline{g^2\eta}\) imply, for one
\(\delta\in\{+1,-1\}\),
\[
 Q(1/\bar z)=\delta\bar z\,\overline{P(z)},\qquad
 P(1/\bar z)=\delta\bar z\,\overline{Q(z)}.
 \]
The sign is constant by analytic continuation; the quotient equation
makes it the same for both spinors. At \(z=a\), the pole on the left
is at \(q_3/r=1/a\) and has coefficient \(c_3/s\). Comparing
principal parts gives \(c_3=-\delta(s/a)\bar b_1\).
At \(z=sa\), the same calculation at \(q_4/r=1/(sa)\)
gives \(c_4=-\delta(1/a)\bar b_2\). Set \(\epsilon=-\delta\).
This also checks the homogeneous extension of source (7.4)
without treating infinity as a finite variable.

All \(H_{jk}\) are real because \(q_j,r,s\) are real. In particular
\[
 R_{11}=-\frac{\epsilon}{a}
       \{s|b_1|^2H_{13}+b_1\bar b_2H_{14}\}.                   \tag{6}
\]
The value \(H_{14}\) is finite by distinctness and is nonzero:
its vanishing would require
\[
 \frac{a}{s/a}\in s r^{\mathbb Z},
 \qquad\text{hence}\qquad a^2\in r^{\mathbb Z},
 \tag{7}
\]
whereas \(1<a^2<r\). Thus the reality in (3) implies
\(b_2=t b_1\) with \(t\in\mathbb R^\times\).

An actual rotation about the normal axis acts on the spinors by
\(P\mapsto e^{i\gamma/2}P,\ Q\mapsto e^{-i\gamma/2}Q\).
Choose it so \(b_1\) is real. Equations (5)--(6) then make all
four nonzero coefficients real. No new period or coefficient
restriction was imposed.

## 2. The forced second reflection

The real coefficients imply
\[
 P(\bar z)=\overline{P(z)},\qquad
 Q(\bar z)=\overline{Q(z)}.
 \tag{8}
\]
Write the actual null one-form as
\[
 \Phi=\big(P^2-Q^2,\ -i(P^2+Q^2),\ -2PQ\big)\,dz,
 \qquad X=\operatorname{Re}\int\Phi .                           \tag{9}
\]
For \(J[z]=[\bar z]\), (8)--(9) give
\[
 d(X\circ J)=(dX_1,-dX_2,dX_3).
 \tag{10}
\]
Because the assumed surface has all real periods zero, \(X\) is
single-valued. Integrating (10) gives a genuine reflection in a
vertical plane, up to translation. Applying \(J\) twice shows that
the translation is normal to that plane; a change of origin removes
it. Thus every point fixed by \(J\) maps to that plane.

This conclusion follows from local residue reality and the original
period closure. It is not an assumption of an additional symmetry.

## 3. Positive sign: a compact planar oval with the wrong turn

If \(s>0\), all four punctures in (4) lie on the positive-real oval
of \(J\). Its other oval
\[
 C_-:\quad z=-e^t,\qquad t\in\mathbb R/L\mathbb Z
 \tag{11}
\]
is compact and unpunctured. If \(X\) were a global embedding, its
restriction to \(C_-\) would be a regular simple closed curve in
the plane of (10).

Both \(P,Q\) are real on \(C_-\). In the plane coordinates
\((X_1,X_3)\), (9) yields the exact tangent-square identity
\[
 \frac{d}{dt}(X_1+iX_3)
   =z(P-iQ)^2=f(t)^2,\quad
 f(t)=i e^{t/2}\big(P(-e^t)-iQ(-e^t)\big).
 \tag{12}
\]
Regularity makes \(f\) nonzero. The kernel identity
\[
 h(rz,q)=(s/r)h(z,q)
 \tag{13}
\]
gives \(f(t+L)=\sigma f(t)\). On the positive branch \(f\) is
therefore a continuous nonvanishing periodic function. Equation
(12) makes the tangent winding number even. A regular simple
closed planar curve has tangent winding number \(+1\) or \(-1\)
(the classical turning theorem). This is a contradiction.

For completeness, the turning fact can be obtained by elementary
polygonal approximation. A sufficiently fine inscribed polygon of
a regular embedded \(C^2\) closed curve is simple, and its edge
directions are uniformly close to the curve tangents on the
corresponding arcs. Local graph charts give this assertion on
neighboring arcs; compactness separates disjoint nonneighboring
arcs. Rounding the polygon's corners inside these charts gives a
nonvanishing tangent field homotopic to the original one.
Triangulating a simple polygon with \(n\) vertices gives total
interior angle \((n-2)\pi\), so its signed exterior angles sum
to \(2\pi\), or \(-2\pi\) after reversal of orientation.
The common tangent degree is consequently \(+1\) or \(-1\).
Thus no unproved spin-parity theorem is being imported into
(12).

There is no assumption about strict growth ordering, absence of
equal growths, or a numerical period root in this argument.
It excludes every regular period-closing positive-branch member.

The original reciprocal fixed ovals alone cannot prove this result:
they follow the circular generator, whose spin multiplier is always
\(-1\). The essential extra curve is the unpunctured oval of the
*forced auxiliary* reflection. The former original-oval route is
retired in the claim ledger for this reason.

## 4. Negative sign: exact change of the complete spinor datum

Let \(z=e^u\) and put
\[
 c=\frac{2\pi}{L},\quad
 v=-icu,\quad w=e^v,\quad
 L'=\frac{4\pi^2}{L},\quad r'=e^{L'},\quad s'=-e^{L'/2}.
 \tag{14}
\]
The map on additive universal covers sends the lattice generators
\[
 2\pi i\longmapsto L',\qquad
 L\longmapsto-2\pi i.
 \tag{15}
\]
It is a biholomorphism \(F:E\to E'\), not a covering of degree
larger than one. Moreover
\[
 F\circ I=\text{conjugation}\circ F,\qquad
 F\circ J=(w\mapsto1/\bar w)\circ F.
 \tag{16}
\]

The square-root functions \(e^{u/2}P(e^u)\) and
\(e^{u/2}Q(e^u)\) have multipliers
\[
 (-1,\sigma)\quad\text{along }(2\pi i,L).
 \tag{17}
\]
In the new order (circular, radial) they have multipliers
\((\sigma,-1)\). Hence, and only hence for this normalization,
the negative branch is again \((-1,-1)\), the signed nonzero
kernel class with \(s'<0\). The positive branch would give
\((+1,-1)\); no application of the reviewed normalized
conjugation theorem to that branch is made.

Choose \(\kappa^2=i/c\). On the universal covers define
\[
 \begin{split}
 Q'(e^v)&=\kappa e^{(u-v)/2}Q(e^u),\\
 P'(e^v)&=\kappa e^{(u-v)/2}P(e^u).
 \end{split}                                                    \tag{18}
\]
Equations (17)--(18) make \(P',Q'\) single-valued in \(w\) and
give the target multiplier \(s'/r'\) under \(w\mapsto r'w\).
Since \(dz/dw=(i/c)e^{u-v}\), their actual forms satisfy
\[
 F^*\eta'=\eta,\qquad g'\circ F=g,\qquad F^*\Phi'=\Phi .
 \tag{19}
\]
There is no associate-family phase left in (19): the chosen
\(\kappa^2\), rather than merely the Gauss-map divisor, fixes it.

For lifts \(u_j\), \(v_j=-icu_j\), the transformed coefficients are
\[
 q'_j=e^{v_j},\qquad
 b'_j=\kappa^{-1}e^{(v_j-u_j)/2}b_j,\qquad
 c'_j=\kappa^{-1}e^{(v_j-u_j)/2}c_j.
 \tag{20}
\]
In particular, zero coefficients remain zero and all required
nonzero coefficients remain nonzero. The exact kernel identity is
\[
 \kappa e^{(u-v)/2}h(e^u,e^{u_j})
   =\kappa^{-1}e^{(v_j-u_j)/2}
       h_{r',s'}(e^v,e^{v_j}).                                 \tag{21}
\]
To prove (21), its two sides have the same transition multipliers,
the same poles, and the same residues by \(dz/dw\).
Their difference is holomorphic on \(\mathbb C^\times\) and
satisfies \(A(r'w)=-r'^{-1/2}A(w)\). Its Laurent series would
require \(r'^n=-r'^{-1/2}\) for a nonzero coefficient, impossible
for an integer \(n\). Thus the difference vanishes. This proves
the entire homogeneous representation, not just its divisor.

With the lifts of (4), put \(\theta=c\log a\in(0,\pi)\) and
\(\rho'=\sqrt{r'}\). The four images are exactly
\[
 (q'_1,q'_2,q'_3,q'_4)
 =(e^{-i\theta},-\rho'e^{-i\theta},
   e^{i\theta},-\rho'e^{i\theta}).                              \tag{22}
\]
They form two nonreal conjugate pairs with no fixed puncture.
Their Gauss values are still \(0,0,\infty,\infty\), on one
unoriented axis. There is also no mismatch of the reflection lift.
For \(\kappa=e^{i\pi/4}/\sqrt c\), use the explicit lifts
\[
 \begin{split}
 u&=(\log a,L/2+\log a+i\pi,L-\log a,L/2-\log a+i\pi),\\
 v&=(-i\theta,L'/2-i\pi-i\theta,-2\pi i+i\theta,
                                      L'/2-i\pi+i\theta).
 \end{split}
\]
Substitution in (5), (20) gives simultaneously
\[
 c'_3=-\epsilon i\,\overline{b'_1},\qquad
 c'_4=-\epsilon i\,\overline{b'_2}.
\]
This is the single common sign required by the target reflection,
not two independently chosen signs. Thus the reviewed
conjugation-reflection obstruction applies.

There is also a second, independent identification of the target
scope: (8), (16), and (22) give a reciprocal reflection with all
four punctures fixed, two on each fixed oval, and with the normal
axis in its plane. That is a sublocus of the accepted fixed-puncture
theorem. This alternative uses the same transported forms (19),
not a different period normalization.

## 5. Both source cycles and all logarithmic terms

The transport is an identity of one-forms; period closure is not
replaced by one selected equation. With \(\alpha\) the circular
cycle and \(\beta\) the radial cycle, choose their target
representatives as the actual images of the source paths. Then
\[
 \int_\alpha\Phi=\int_{\beta'}\Phi',\qquad
 \int_\beta\Phi=-\int_{\alpha'}\Phi'.
 \tag{23}
\]
Small puncture loops map to small puncture loops with the same
orientation and residues. If canonical source cuts replace these
paths, they can add puncture loops; their real periods are zero
by (3). Thus (23) is an equivalence of the *full* real period
problem, in both directions.

For clarity, the complete source radial formulas are retained.
Let
\[
 (\Omega_0,\Omega_1,\Omega_2)=(-Q^2,-PQ,-P^2)\,dz,\quad
 R_\nu(\gamma)=\frac1{2\pi i}\int_\gamma\Omega_\nu,\quad
 R_{\nu j}=\operatorname{Res}_{q_j}\Omega_\nu .
 \]
Kato--Muroya 2012 Lemma 6.2, printed p. 950, is
\[
 R_\nu(\beta)=-\frac1{2\pi i}
 \left\{-D_\nu-LR_\nu(\alpha)+
                   \sum_j\log q_j\,R_{\nu j}\right\},
 \quad
 (D_0,D_1,D_2)=
 \sum_j\frac{(b_j^2,b_jc_j,c_j^2)}{q_j}.                        \tag{24}
\]
The \(\log q_j\) terms in (24) are present; none is declared zero
under reparameterization. The same identity holds for the primed
kernel and cycles. Equation (19) identifies each \(\Omega_\nu\)
and hence these complete cycle integrals.

One can also retain the symmetry-reduced source system (7.5)
explicitly. Let \(K_{jk}=h_1(q_j,q_k)\), including its defined
diagonal values, and choose the inner nonfixed representatives
\(O=\{1,4\}\). Reindexing the defining series by
\(\ell\mapsto-\ell\) gives \(K_{jk}=K_{kj}\). In this homogeneous
exceptional-axis case the system is
\[
 \begin{split}
 F_1&=\sum_{j,k}b_jb_kK_{jk}=0,\\
 F_2&=L\sum_{j,k}b_jc_kK_{jk}
       -\sum_j b_jc_j/q_j
       +\sum_{j\in O}(2\log|q_j|-L)R_{1j}=0 .
 \end{split}                                                    \tag{25}
\]
The diagonal term happens to vanish because every \(b_jc_j=0\).
The off-orbit and logarithmic terms combine to the last sum;
they have **not** been dropped. There is no need to evaluate
(25) to obtain the contradiction, because (19), (23), and the
reviewed target theorem preserve and decide its entire solution
set.

Locally this treatment of logarithms can be checked without any
elliptic-function identity. For a coordinate change
\(z-q=d\,t+e\,t^2+\cdots\), \(d\ne0\),
\[
 \left(\frac{A}{(z-q)^2}+\frac{R}{z-q}\right)dz
   =\left(\frac{A/d}{t^2}+\frac R t+O(1)\right)dt .
 \tag{26}
\]
Thus the coefficient of the logarithm in a primitive is exactly
the same \(R\). Branch changes only add \(2\pi iR\), already
accounted for by the local period conditions. The exact replay
checks (26) with a symbolic cubic coordinate change.

## 6. Admissibility and boundaries

Every step above is for an arbitrary fixed \(r>1\); no finite
modulus range or sampled period locus substitutes for a proof.

The map \(F\) is a conformal bijection. Equations (19)--(20)
preserve all four distinct punctures, their local residues and
nonzero weights, absence of common spinor zeros, Gauss-map degree
four, the induced metric, completeness, total curvature, and
properness or global embedding if present. In fact
\(X'\circ F=X+\text{constant}\). The inverse map gives the converse
transport. This is stronger than an abstract isomorphism of
elliptic curves.

The argument nowhere crosses a zero-weight, common-zero, colliding-end,
or zero-modulus boundary. Such degenerations are not admissible
members of the statement. A collision at \(a^2=\rho\) on the
positive branch is excluded by the original four-distinct-ends
condition, not reported as an embedded boundary. The endpoints
\(a=1,\rho\) are covered by the accepted fixed-puncture theorem
when they remain otherwise admissible. Equal nonzero growths are
allowed throughout: neither the turning argument nor exact
reparameterization requires strict growth inequalities.

`verify_exact.py` checks the homogeneous residue algebra, the
planar tangent square and speed, both signed spin transports, the
lattice and involution exchange, coefficient pullback, both-cycle
matrix, the complete logarithmic residue, the homogeneous form
of (25), and the nine-distribution count. Its finite symbolic
identities support the displayed formulas; the geometric turning
argument, analytic kernel uniqueness, and reviewed obstruction
dependencies are explicit prose arguments, not claims certified
by that program.

The external analytic input is the already independently
source-attributed Kato--Muroya homogeneous representation and
kernel/local/global identities. In the ledger it is reused
verbatim as `KM2012-NONZERO-SYMMETRIC-SYSTEM`, with the existing
confirmed citation evidence. The reciprocal coefficient relation
itself was derived above; no new use of Theorem 7.3 as a
global-embedding theorem, or unverified period-system assumption,
is concealed in that reuse.
