# Quantitative comparison for the actual priority-transfer circuits

## Result and scope

**Theorem 1 (explicit verification of `prop:comparison`).** Use exactly the
spaces, metrics, arrival frames, priority maps, and directed exchanges in
Sections 3--5 of the staged `strong-ulam-stability.tex`. If
\(0<h\leq 1/128\) and \(0<\eta\leq 1/4\), then
\[
 \|V_{qp}^{\{p,q\}}-V_{qp}^{\{p,q,r\}}\|
 \leq 40h+16N\eta+30Nh\eta.                         \tag{1}
\]
Thus the proposition holds with \(h_0=1/128\) and \(C=40\). All norms in
(1) are in the manuscript's Hilbert space, not in an incompatible
Euclidean metric. No estimate about a priority map or the next layer is
an assumption of this theorem.

Here is a slightly more general statement, useful for distinguishing the
two sources of error.

**Theorem 2 (nested finite configuration sets).** The same recipe works
for any finite nonempty sets \(\mathcal A\subseteq\mathcal B\) of
configurations, and any \(p,q\in\mathcal A\). Keep the source's actual
Jordan--Wigner metrics, or allow \(h\) to vary independently subject to
\(h\sqrt L\leq 1/2\), with \(N=L+1\). Suppose every arrival switchable set
for \(\mathcal B\) has Gram error at most \(\delta\), and every priority
set for \(\mathcal B\) has the sparse \(J\)-restriction bound at most
\(\zeta\), where \(0\leq\delta,\zeta\leq1/4\). Use the source's symmetric
orthonormalization, its block-Schur priority map, and its fixed reverse
leg, without replacing them by arbitrary near-identity maps. Then
\[
 \|V_{qp}^{\mathcal A}-V_{qp}^{\mathcal B}\|
 \leq40h+16N\delta+30Nh\zeta.                       \tag{2}
\]
The constants are independent even of \(|\mathcal B|\); sparsity of the
sets, not their number of defining configurations, is what is needed.
These sparsity hypotheses are available for each finite
\(|\mathcal B|\), as explained below. Theorem 1 is the literal
pair-to-triple specialization, not a surrogate abstract circuit theorem.

This is a proof and a quantitative extension of one analytic proposition.
It is **not** a certification of either manuscript's full amenability
converse. The exact script and the Lean file described below check
specified algebraic and scalar parts; the operator estimates and their
translation to the actual tensor spaces are the proof in this document.
Independent mathematical and significance/novelty review is still
required.

## 1. Prerequisites and the actual construction's hypotheses

The external prerequisite for the existence of the flags is the boundary
characterization of nonamenability, recorded as `A_BOUNDARY` on
`C_US_FLAGS`. Kalantar--Kennedy, arXiv:1405.4359v3, Proposition 3.2 and
Corollary 3.9, give a nontrivial compact Hausdorff minimal strongly
proximal space for every nonamenable discrete group. This external
theorem is not needed to prove (2) for supplied flags satisfying F1--F3.
It is needed to conclude that the manuscript can supply such flags.

For clarity, the construction from that prerequisite can be checked
without another literature theorem. On a nontrivial boundary there are
no isolated points: one isolated point would, by minimality and
compactness, make the space finite; its invariant uniform probability
would contradict strong proximality unless it were a singleton.
Fix a nonempty open \(U\), a point \(\zeta_0\), and \(0<\beta<1\).
Choose a continuous \(0\leq f\leq1\), supported in \(U\), equal to one
at a point of \(U\). Strong proximality and minimality applied to
\((m+\delta_{\zeta_0})/2\), for each Radon probability \(m\), give a
translate \(f\circ s^{-1}\) with integral \(>1-\beta/2\) and
\(s^{-1}\zeta_0\in U\). If the convex hull of these allowed translates
did not meet the open cone of functions everywhere \(>1-\beta\),
Hahn--Banach separation would give a nonzero positive functional:
positivity follows by adding arbitrary nonnegative functions to that
cone. Normalizing and applying Riesz representation would contradict
the preceding integral bound. A finite convex combination therefore
lies in the cone. Compactness gives a uniform margin, so rationalizing
the coefficients gives a finite list with the desired strict counting
bound. The finite intersection of the sets \(sU\) is a neighborhood
of \(\zeta_0\).

Now work backwards in the number of stages. In each already chosen
nonempty \(U_k\), take more than \(1/\beta\) disjoint nonempty open sets
\(U_{k,c}\). Apply the list construction to each, repeat lists to equal
length, and set
\[
 U_{k-1}=\bigcap_{c,y}s_k(c,y)U_{k,c},\qquad
 b_k(w;c,y)=\mathsf E
 \Longleftrightarrow (ws_k(c,y))^{-1}\xi\in U_{k,c}.
\]
The displayed intersection contains \(\zeta_0\). Its inverse-image
containments prove F1 at the next stage. The list bound proves F2 at
each departure. At an arrival, the disjoint \(U_{k,c}\) allow at most
one \(\mathsf E\) color, proving F3. Repetition of any alphabet
preserves these properties. Left translation also preserves them
because it preserves every labelled right step. In particular,
F1 applies simultaneously to every configuration used below.

The sparse linear algebra is available with separate errors
\(\delta,\zeta>0\). For completeness, if \(O\) is Haar orthogonal in
dimension \(m\), the Gaussian realization of a uniform sphere point
gives
\[
 {\mathbb P}(|u^*Ov|>t)
 \leq2(1-t^2)^{(m-1)/2}
 \leq2e^{-(m-1)t^2/2}\quad(0<t<1).
\]
Use \(1/4\)-nets of size at most \(9^s\) on every coordinate sphere
of dimension \(s\leq qm\). Approximating two maximizing unit vectors
shows that a bilinear bound \(\epsilon/2\) on the nets gives norm at
most \(\epsilon\). The number of subsets of size at most \(qm\) is
at most \(e^{mH(q)}\), where
\(H(q)=-q\log q-(1-q)\log(1-q)\). Consequently the exceptional
probability is at most
\[
 2\exp(2mH(q)+2qm\log9-m\epsilon^2/16)\quad(m\geq2).
\]
Choose \(q\) so small that
\(2H(q)+2q\log9<\epsilon^2/32\), then take \(m\) sufficiently large.
The union of the standard and \(O\)-column bases has Gram error at
most \(\epsilon\) on those sparse sets. Independently using such an
\(O\) in \(J=\left(\begin{smallmatrix}0&O\\O^*&0\end{smallmatrix}\right)\)
gives the sparse \(J\) bounds. Apply this twice with
\(\epsilon=\delta,\zeta\). For fixed finite
\(m_0=|\mathcal B|\), choose the flag parameter \(\beta\) so small
that \(m_0\beta|X|\) and \(m_0\beta|Y|\) are within the two allowed
sparsity thresholds. F3 and F2 respectively give exactly those
cardinality bounds. Alphabet repetition then meets every dimension
threshold. The zero-error cases in (2) are conditional limiting
statements; no existence of zero-error redundant sparse frames is
asserted.

Here are the important metric and support checks. Each
\(\gamma_d=f_d(X_d)Z_1\cdots Z_{d-1}J_d\) is a self-adjoint
involution. For \(d<e\), \(J_dZ_d=-Z_dJ_d\) is the sole
anticommuting factor, so \(\gamma_d\gamma_e=-\gamma_e\gamma_d\).
Thus
\[
 \left(\sum_{k<d\leq L}\gamma_d\right)^2=(L-k)I,\qquad
 \tfrac12I\leq G_k\leq\tfrac32I
\]
when \(h\sqrt L\leq1/2\). The compressed \(X_j\), \(j\leq k\),
carry identity. Every surviving term commutes with coordinate
projections in \(X_j\), \(j>k\), and in \(Y_d\), \(d\leq k\):
its factors on the latter are only diagonal \(Z_d\)'s.

It follows that each stated left endpoint is a reducing coordinate
sector. A right endpoint has fixed \(Y_{k-1}=y\) and an adjusted line
in the compressed \(X_k\). It too is reducing; different right
endpoints at a fixed arrival are orthogonal because the adjusted
columns are orthonormal. Their residual metric is the same \(B_y\)
for every column \(x\). Restricting the two level metrics gives,
literally,
\[
 A_{x,y}=B_y+h\Gamma_{x,y},\quad
 \Gamma_{x,y}=f_k(x)Z_1\cdots Z_{k-1}J_k|_{Y_{k-1}=y},
 \quad\|\Gamma_{x,y}\|=1.                          \tag{3}
\]
At the last stage both metrics are identity.

The priority projection is block diagonal in \(X_{k+1}=z\), with
\(Y_k\) selected by
\[
 R_{k,v,z}^{\mathcal C}
 =\{t:\text{some }c\in\mathcal C
                  \text{ has }c_{k+1}(v;z,t)=\mathsf F\}.
\]
It commutes with \(B_y\), since \(G_k\) has only diagonal parity
factors on \(Y_k\). In blocks of future \(X\)'s and earlier \(Y\)'s,
\(P\Gamma_{x,y}P\) is a signed \(J_k[R,R]\) tensor an identity.
Its norm is at most \(\zeta\), not a sum over blocks.
For nested configuration sets these projections are nested.
These facts establish the hypotheses of the actual priority formula.

## 2. Quantitative bounds for that formula

Temporarily consider the slightly wider regime \(h\leq1/8\) and
\(0\leq\zeta\leq1\); the restriction \(\zeta\leq1/4\) is only
needed for the later truncation budget.
Whiten the right metric:
\[
 H=B^{-1/2}AB^{-1/2}
  =\begin{pmatrix}a&b\\b^*&d\end{pmatrix},
 \qquad E=d-b^*a^{-1}b.
\]
Because \(P\) commutes with \(B\), this is the same orthogonal
decomposition \(R\oplus R^\perp\). We have
\[
 \|H-I\|\leq2h,\quad
 \|a-I\|\leq2h\zeta,\quad
 \|b\|\leq2h,\quad
 (1-2h)I\leq a,E\leq(1+2h)I.                     \tag{4}
\]
For the Schur lower bound, minimize
\(\langle(x,y),H(x,y)\rangle\) over \(x\), then use
\(H\geq(1-2h)I\); the minimum is still at least
\((1-2h)\|y\|^2\). Its upper bound follows from \(E\leq d\).
In addition,
\[
 \|E-I\|\leq2h+\frac{4h^2}{1-2h}\leq\tfrac83h.  \tag{5}
\]
All spectral intervals in (4) lie in \([3/4,5/4]\).
On this interval,
\[
 |t^{-1/2}-1|
 =\frac{|t-1|}{\sqrt t(1+\sqrt t)}\leq|t-1|,
 \qquad t^{-1/2}\leq4/3.
\]
Applying spectral calculus to individual positive operators, not an
unsupported operator-Lipschitz assertion about two matrices, gives
for the source's exact matrix
\[
 Q_R=\begin{pmatrix}
 a^{-1/2}&-a^{-1}bE^{-1/2}\\0&E^{-1/2}
 \end{pmatrix}
\]
the bounds
\[
 Q_R^*HQ_R=I,\quad
 \|Q_R-I\|\leq
 \max\{2h\zeta,\tfrac83h\}+\tfrac{32}{9}h<7h,\quad
 \|(Q_R-I)P\|\leq2h\zeta.                       \tag{6}
\]
The first identity is direct block multiplication:
the upper right block of \(HQ_R\) is zero and the lower right
block is \(E^{1/2}\). The first column proves \(Q_RR=R\).
Empty blocks cause no exception.

Put \(S_R=B^{-1/2}Q_RB^{1/2}\), exactly as in the source.
In the \(B\)-norm, conjugation by \(B^{1/2}\) is an isometry, so
(6) holds for \(S_R\) with the same constants.
Also
\(\|Q_R^{-1}\|^2=\|H\|\leq1+2h\), hence
\(\|Q_R^{-1}\|\leq9/8\).
For \(R_2\subseteq R_3\) define \(K=S_{R_3}^{-1}S_{R_2}\).
The isometry identities show \(K^*BK=B\). Taking the difference
of the two \(S\)'s in their common, whitened coordinates yields
\[
 \|K-I\|_B\leq (9/8)\,14h\leq16h,\qquad
 \|(K-I)P_2\|_B\leq(9/8)\,4h\zeta\leq5h\zeta.   \tag{7}
\]
The different block decompositions used to construct the two \(Q\)'s
do not matter: both inequalities in (6) concern operators on the
same whitened space, and \(R_2\subseteq R_3\).
This proves the nested-transfer estimate for the actual formula.

## 3. Arrival frames cost at most \(16N\delta\) in a comparison

If \(F^*F\) has spectrum in \([1-\delta,1+\delta]\), its polar
column isometry \(\widetilde F=F(F^*F)^{-1/2}\) satisfies
\[
 \|\widetilde F-F\|
 =\|(F^*F)^{1/2}-I\|
 \leq\frac{\delta}{1+\sqrt{1-\delta}}\leq\delta. \tag{8}
\]
For \(S_{\mathcal A}\subseteq S_{\mathcal B}\), restrictions of the
two adjusted frames therefore differ by at most \(2\delta\).
Replace the \(\mathcal A\)-circuit's arrival columns by the
\(\mathcal B\)-columns, but leave its active edges and priority maps
unchanged. Call this circuit \(\overline W_p\).

In the layer formula
\[
 I-LL^*-RR^*+LC_0R^*+RTL^*,                     \tag{9}
\]
the embeddings \(L,R\) and transfers \(C_0,T\) are isometries in
their indicated metrics. Only \(R\) changes. Since the residual
metric \(B_y\) is independent of \(x\), (8) tensors with this
metric with exactly the same bound. Orthogonal summation over
\((v,y)\) gives \(\|R-R'\|\leq2\delta\). Equation (9) changes
by at most \(4\|R-R'\|\leq8\delta\). No estimate of individual
columns is summed. Telescoping the \(N\) unitary layers gives
\[
 \|W_p^{\mathcal A}-\overline W_p\|\leq8N\delta,
 \quad
 \|W_q^{\mathcal A}-\overline W_q\|\leq8N\delta. \tag{10}
\]

## 4. Added common exchanges really cancel

An edge switchable for \(\mathcal B\) but not for \(\mathcal A\)
has a constant flag on \(\mathcal A\). If this flag is
\(\mathsf E\), neither \(p\) nor \(q\) uses it. If it is
\(\mathsf F\), both use the same exchange, with the same
\(\mathcal B\)-frame and the same two directed legs.

A later such common exchange commutes with every earlier surviving
exchange. Nonadjacent layers have disjoint levels. For adjacent
layers, any surviving edge is switchable for \(\mathcal A\);
there is therefore a configuration \(c\in\mathcal A\) which flags
it \(\mathsf E\). At its arrival, F1 says that *every* next
edge is \(\mathsf E\) in \(c\). A new common edge, which is
\(\mathsf F\) in every configuration of \(\mathcal A\), cannot
depart there. Thus the supports are disjoint even before using any
coordinate information. Changing arrival columns does not change
their group locations. This argument also explains why, for larger
\(\mathcal A\), the configuration \(c\) need not be \(p\) or \(q\).

Inside a layer all exchanges have orthogonal supports. Move common
exchanges to the earliest application positions, keeping their
relative order. There are finitely many layers; the within-layer
infinite families are orthogonal direct sums, not unregulated
infinite products. Consequently
\[
 W_p^{\mathcal B}=\widehat W_p C_{\rm com},
 \quad W_q^{\mathcal B}=\widehat W_q C_{\rm com},
 \quad V_{qp}^{\mathcal B}=\widehat W_q\widehat W_p^{-1}. \tag{11}
\]
The surviving circuits have exactly the edges of the
\(\mathcal A\)-circuits and the \(\mathcal B\)-arrival columns.
Only their forward priority legs differ from \(\overline W_p\).

## 5. The actual next departure is protected

On one active edge, multiply the new exchange by the inverse of
the old one:
\[
 \begin{pmatrix}0&C\\S_3^{-1}&0\end{pmatrix}
 \begin{pmatrix}0&S_2\\C^{-1}&0\end{pmatrix}
 =\begin{pmatrix}I&0\\0&S_3^{-1}S_2\end{pmatrix}. \tag{12}
\]
The independence of the *reverse* leg \(C=A^{-1/2}B^{1/2}\)
is essential. In particular this is an arrival-level, not a
departure-level, error. Orthogonal sums of (12) give
\[
 \widehat M_{p,k}=K_k\overline M_{p,k},\qquad
 K_k=I\text{ off }H_k,\qquad\|K_k-I\|\leq16h.    \tag{13}
\]

Let \(Q_{k+1}\) be the actual departure projection of
\(\overline M_{p,k+1}\) on \(H_k\). At location \(v\) it selects
the active coordinates \(X_{k+1}=z,Y_k=t\); all other tensor
factors are unrestricted. A current arrival projection selects
\(Y_{k-1}=y\) and a line in the compressed \(X_k\).
These projections commute in the actual \(G_k\)-metric, since
they concern different factors and all selected factors reduce
that metric. Every selected next departure has flag \(\mathsf F\)
in \(p\in\mathcal A\), so its \(t\) belongs to the *smaller*
priority set \(R^{\mathcal A}_{k,v,z}\). On each intersection,
(7) therefore applies. Off all current arrivals \(K_k=I\).
Orthogonal summation gives the genuine manuscript estimate
\[
 \|(K_k-I)Q_{k+1}\|\leq5h\zeta.                 \tag{14}
\]
The fact that the arrival columns were changed does not alter
this inclusion or this commutation. Set \(Q_{N+1}=0\).

## 6. Truncate, commute, and use orthogonal levels

Here is the required truncation argument, including the
infinite-dimensional issue. Write a unitary \(U\), relative to
\(QH\oplus(1-Q)H\), as
\(\left(\begin{smallmatrix}a&b\\c&d\end{smallmatrix}\right)\).
If \(\|(U-I)Q\|\leq e\), then
\((U^*-I)Q=-U^*(U-I)Q\), so the analogous row bound also
holds. It follows that
\(\|U-\operatorname{diag}(I,d)\|\leq2e\).
If \(\|U-I\|<1/2\), then \(\|d-I\|<1\), so \(d\) is
invertible by the Neumann series, not just injective.
Its polar factor \(v\) is unitary. Since
\(d^*d=I-b^*b\),
\[
 \|v-d\|\leq1-\sqrt{1-e^2}\leq e^2.
\]
Thus \(\widetilde U=I\oplus v\) fixes \(QH\), preserves its
orthogonal complement, and has distance at most \(3e\) from \(U\)
when \(e\leq1/2\).

Apply this to (13)--(14). For \(h\leq1/128\),
\(16h\leq1/8<1/2\), and \(5h\zeta\leq5/512<1/2\).
It produces unitaries supported on \(H_k\) with
\[
 \widetilde K_kQ_{k+1}=Q_{k+1},\quad
 \|K_k-\widetilde K_k\|\leq15h\zeta,\quad
 \|\widetilde K_k-I\|\leq16h+15h\zeta\leq20h.   \tag{15}
\]
A unitary fixing \(Q_{k+1}H_k\) pointwise also preserves its
orthogonal complement. The next layer is identity on that
complement and acts between \(Q_{k+1}H_k\) and a subspace of
\(H_{k+1}\); \(\widetilde K_k\) is identity on both these
active subspaces. Hence it commutes with the actual next
layer. Every further layer is on disjoint levels.

Replace \(K_k\) by \(\widetilde K_k\) in the interleaved product
from (13). A unitary telescoping bound costs at most
\(15Nh\zeta\). Moving each corrected error past the later
layers is now an exact algebraic identity:
\[
 \prod_{k=N,\ldots,1}
       (\widetilde K_k\overline M_{p,k})
 =(\widetilde K_N\cdots\widetilde K_1)
       (\overline M_{p,N}\cdots\overline M_{p,1}). \tag{16}
\]
The corrected errors act on different orthogonal levels.
Their product is block diagonal, so, including the untouched
level zero,
\[
 \|\widetilde K_N\cdots\widetilde K_1-I\|
 =\max_{1\leq k\leq N}\|\widetilde K_k-I\|
 \leq20h.                                      \tag{17}
\]
In particular there is no \(Nh\) estimate hidden here.
Equations (15)--(17) give, for each of \(p,q\),
\[
 \|\widehat W_p-\overline W_p\|
 \leq20h+15Nh\zeta.                             \tag{18}
\]
Finally telescope the two factors in a comparison, use
(10)--(11), and use that inversion preserves distances between
unitaries. Twice (10) plus twice (18) is precisely (2).
The pair/triple switchable and priority sets have sizes at
most \(3\beta|X|\), \(3\beta|Y|\), within the literal
\(4\beta\) sparse bounds. Set \(\delta=\zeta=\eta\) to obtain
(1), with all hypotheses of the actual construction accounted
for. This completes the proof.

## 7. Exact and formal evidence: what it does and does not show

`verify.py` checks the literal source equations, rational
constant inequalities, universal noncommutative block
identities, the F1 adjacent-support implication, and a
nontrivial rational nested-priority example. It also checks
the recorded compiler result when the Lean evidence is
present. These checks complement the uniform proof above;
they are not an exhaustive search over groups or Hilbert
spaces.

The exact example has a four-dimensional involution metric,
a protected coordinate, and a genuine two-dimensional priority
rotation. The script checks the prescribed Schur formula,
including positivity of its inverse square-root blocks, not
just the existence of some isometry. The next layer exchanges
the protected coordinate with a new level. The rotation
commutes with this exchange, but is not identity. Jacobian's
`matrix.rank.compute` is used only to compute the rank of the
explicit rational priority discrepancy; the displayed
three-by-three payload omits a fourth, exactly fixed coordinate.
Its typed output
does not purport to prove an analytic circuit theorem.

`lean/Main.lean` formalizes the noncommutative swap orientation,
the annihilating-support commutation criterion, the
all-length interleaved-product identity (16), and the
disjoint-error product identity underlying (17). Its
separate fidelity document specifies its exact quantifiers
and limitations. In particular it does not encode spectral
calculus, the norm maximum, or the full group construction.

There cannot be a finite-group realization of the manuscript's
small-\(\beta\) flags: sum F2 over all departures to obtain at
least \((1-\beta)|G||X||Y|\) edges marked \(\mathsf E\).
The change of variables \(v=ws_k(x,y)\) is a permutation
for each label pair; summing F3 counts the same edges and
gives at most \(\beta|G||X||Y|\). Thus
\(\beta\geq1/2\). This is why the finite tests are local
algebra tests, not purported global flag counterexamples.
The unusable finite-group route is retired in the ledger.

## 8. Literature scope and comparison with prior knowledge

The initial project ledger had no earlier mathematical result
beyond its campaign objective. The improvement here is an
explicit bound for the actual maps and a nested-configuration
extension with two separate error parameters, not a larger
no-witness search.

Primary sources opened for scope were:

* Burger--Ozawa--Thom, arXiv:1010.0565v1, Theorem 1.1,
  Theorem 1.2, Definition 2.1, and Theorem 3.2: amenable
  stability is uniform over all Hilbert spaces, and
  nonabelian free-subgroup cases are unstable. These do not
  establish the converse for all nonamenable groups.
* Alpeev, arXiv:2009.11738v3, Theorem B: restricted wreath
  products with a nontrivial countable abelian base and
  nonamenable countable acting group are not strongly Ulam
  stable. This is not a theorem about every such acting
  group by itself.
* Kalantar--Kennedy, arXiv:1405.4359v3, Proposition 3.2
  and Corollary 3.9: the boundary prerequisite used above.

The first automated literature summary misidentified the
numbering of the Burger--Ozawa--Thom theorems; it was not
used as evidence. The source at the verified v1 locator
has the relevant statements. No false citation assertion
in the staged manuscript is inferred from that search
summary.

A bounded search for an independent prior priority-circuit
comparison theorem located the target preprint but no
additional primary-source theorem covering (2). This is a
retrieval limitation, not a proof of novelty. Search-engine
statements that the manuscript has already proved its main
theorem are not independent certification. No upstream
placeholder comparator is used as a proof. Independent
Reviewer attribution of the recorded external prerequisites
and assessment of publishability/novelty remain outstanding.
