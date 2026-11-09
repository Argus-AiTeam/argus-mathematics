# Arbitrarily deep endpoint jets do not recover forest-quiver HOMFLY

**Theorem.** For every integer \(r\geq1\) and every \(m\geq1\), set
\[
 k=\min\{j\geq0:2^j\geq r\},\qquad
 d_k=2^k,\qquad n_k=\frac{230\cdot8^k+1}{7},\qquad N=n_km+4.
 \tag{J1}
\]
There is an explicitly defined family of connected trees on \(N\) vertices,
of maximum degree at most seven, having at least
\(\lceil2^{m/2}\rceil\) distinct full two-variable HOMFLY polynomials.
All its members have the same entire normalized quiver point count,
Alexander polynomial, first \(r\) normalized top-\(a\) layers, and
derivatives through order \(r-1\) at \(a=1\). The derivative assertion
holds for both the normalized and full HOMFLY polynomials. Every member
has the reviewed connected simple non-reduced plabic realization.
The same conclusion for depth zero follows by using \(k=0\).

In particular, for every fixed finite depth, the enriched data have
exponentially large full-HOMFLY fibers:
\[
 \log_2|\text{fiber}|\geq\frac{m}{2}
       =\frac{N-4}{2n_k},\qquad n_k\leq263r^3.
 \tag{J2}
\]
This is an all-depth, all-\(m\) proof with exact symbolic replay, not a
finite experiment or a formal-kernel certificate. Independent review
of this new theorem is requested; historical originality and independent
publication-level significance remain uncertified.

## Inputs already reviewed

Use the unchanged forest refinement \(C_T(x,y)\) and put
\[
 K=y-1+xy^2,\quad
 D=C_{T-z},\quad E=(yC_T-D)/K,\quad F=(D-E)/y.
 \tag{J3}
\]
These are polynomial rooted states. Coalescence at a marked vertex and
attachment by one edge have the reviewed formulas
\[
 C_{H\cdot T}=EC_H+FC_{H-h},
 \quad
 (C',D',E')=(CC_T-xKEE_T,\ DC_T,\ E(C_T-xyE_T)).
 \tag{J4}
\]
The product-switch lemma is (26) in `joint_refinement.md`, accepted as
`CJOINTSEED`. Its original rooted trees \(S_{0,0},S_{0,1}\) have order
33, root degree two, maximum degree five, and equal whole and deleted
differences
\[
 \Delta_0=C_{0,0}-C_{0,1}=D_{0,0}-D_{0,1}
 =-x^6y(y-1)(1+x)K C_A C_B\ne0.                              \tag{J5}
\]
Their actual edges and complete polynomials are the unchanged
`joint_certificate.json`. We reuse that reviewed certificate, rather
than regenerate or re-review its atoms.

The general first-disagreement calculation and two marker identities
are the independently accepted (E7)--(E15) of `exponential_fibers.md`.
The stronger fixed-path scalar theorem in `scalar_fibers.md` is also
independently accepted: `reviewer:copilot-scalar-review` supports its
four claims in `MATH_STATE.json`, and the sealed scalar handoff confirms
rate \(1/33\). Neither that result nor its certificates are revised.

The cited inputs remain the already independently inspected
Schwartz `arxiv:2410.00399v2`, Definition 3.1, Lemma 4.1, Theorems 3.11
and 4.6, and Corollary 4.12; Galashin--Lam `arxiv:2208.01175v1`,
Proposition 5.8; and the universal tree realization `CPLABIC`.
`CINTERLACE` supplies the rank-nullity interpretation, and the known
rooted transfer is compared with Traldi `arxiv:0808.1888v4`,
Theorems 13 and 20, in the accepted comparison. These are acknowledged
inputs, not new results. No new source-access attempt was made. The
previously unread closest dissertation and final-journal bodies still
block historical-priority certification; inaccessible text is not
evidence of originality. The old matching-visible route remains retired.

## Actual connected switches at every depth

Suppose \(S_{k,0},S_{k,1}\), rooted at \(z\), have been constructed.
Take disjoint copies and add an edge between their roots, obtaining
\(Q_k\) with marked endpoints \(p\) (the zero copy) and \(q\) (the one
copy). This is a tree on \(2n_k\) vertices. Both marked degrees are three.

Using four fresh copies of \(Q_k\), form two rooted child trees for a
new vertex \(z'\). In \(S_{k+1,0}\), coalesce the \(p,p\) marks for the
first child and the \(q,q\) marks for the second. In \(S_{k+1,1}\),
coalesce the \(q,p\) marks for the first child and the \(p,q\) marks
for the second. In each case join \(z'\) by one edge to each coalesced
mark. This is exactly the product switch with \(A=B=Q_k\); it does not
identify any other vertices or reuse copies.

Every child is a tree, and their only connection is through \(z'\), so
each result is a connected ordinary-simple tree. The new root has
degree two. Each coalesced mark has degree \(3+3+1=7\); all other
vertices retain their previous degree. Thus the maximum degree is at
most seven at every depth. The sizes satisfy
\[
 n_0=33,\qquad n_{k+1}=1+2(2n_k+2n_k-1)=8n_k-1.              \tag{J6}
\]
Solving this recurrence gives (J1). The functions `switch` and `family`
in `jet_fibers.py` implement these identifications with explicit edges.

Write \(C_i=C_{k,i}\), \(D_i=D_{k,i}\), \(E_i=E_{k,i}\), and suppose
\(C_0-C_1=D_0-D_1=\Delta_k\). The joining-edge formula and actual
root deletions give
\[
 C_{Q_k}=C_0C_1-xKE_0E_1,\qquad
 C_{Q_k-p}=D_0C_1,\quad C_{Q_k-q}=C_0D_1.
\]
Consequently the marked deletion difference is exactly
\[
 \delta_{Q_k}=D_0C_1-C_0D_1
             =\Delta_k(C_1-D_1).                            \tag{J7}
\]
Applying the reviewed product-switch lemma now proves both full
polynomial differences, not just a specialization:
\[
 C_{k+1,0}-C_{k+1,1}=D_{k+1,0}-D_{k+1,1}=\Delta_{k+1},
 \qquad
 \Delta_{k+1}=\frac{C_{Q_k}^{\,2}\delta_{Q_k}^{\,2}}{K}.
 \tag{J8}
\]
Every marked deletion difference is divisible by \(K\). More
explicitly, \(B_k=\Delta_k/K\) is a polynomial, and (J8) is the
denominator-free recurrence
\[
 \Delta_{k+1}
 =K C_{Q_k}^{\,2}B_k^{\,2}(C_1-D_1)^2.                     \tag{J9}
\]
Thus no evaluation at a zero of \(K\) or rational limiting convention
enters the construction.

## Nonzero defects and exact doubled vanishing

For a forest with \(n\) vertices and \(c\) components,
\([x]C=(n-c)+cy\). In the reviewed rank-nullity coordinates, only
single vertices and single edges have \(x\)-degree one; a selected set
of at least three vertices has degree at least two. Deleting a
degree-two root leaves two components, hence at every depth
\[
 [x]C_1=n_k-1+y,\quad [x]D_1=n_k-3+2y,\quad
 C_1-D_1=x(2-y)+O(x^2).                                    \tag{J10}
\]
In particular \(C_1-D_1\) is nonzero and remains nonzero as a
polynomial in \(x\) at both \(y=0\) and \(y=1\). Also
\(C_{Q_k}(0,y)=1\), including after either endpoint specialization.

Equation (J5) has exact order one at each endpoint: \(K(x,0)=-1\),
\(K(x,1)=x\), and the endpoint polynomials of \(C_A,C_B\) have
constant coefficient one. Since \(K\) has neither \(y\) nor \(y-1\)
as a factor, (J7)--(J9) and (J10) imply inductively that
\(\Delta_k\ne0\) and its exact orders at \(y=0,1\) are \(d_k=2^k\).
This argument uses the whole polynomial, not just its first
\(x\)-coefficient.

For decoding, work in \(\mathbb Q(y)[[x]]\). Here \(K\) and all the
states with constant coefficient one are units. Let
\(\alpha_k=\nu_x(\Delta_k)\) and \(H_k=[x^{\alpha_k}]\Delta_k\).
(J5), (J8), and (J10) yield
\[
 \alpha_0=6,\quad \alpha_{k+1}=2\alpha_k+2,\quad
 H_0=-y(y-1)^2,\quad
 H_{k+1}=\frac{H_k^2(2-y)^2}{y-1}.                          \tag{J11}
\]
Therefore
\[
 \alpha_k=8d_k-2,\qquad
 H_k=(-1)^{d_k}y^{d_k}(y-1)^{d_k+1}(y-2)^{2d_k-2}\ne0.
 \tag{J12}
\]
The apparent endpoint orders of \(H_k\) need not equal those of the
whole \(\Delta_k\); (J12) is used only for \(x\)-adic decoding.

## All-word decoding and scalar exponential separation

Put \(s_i=C_i/E_i\). From (J3) and equal whole/deleted differences,
\[
 E_0-E_1=(y-1)\Delta_k/K,\quad
 C_0E_1-C_1E_0=(\Delta_k/K)(C_1-D_1).
 \tag{J13}
\]
The \(E_i\) have constant coefficient one. Equations (J10)--(J13)
give the exact first ratio defect
\[
 s_0-s_1=L_kx^{b_k}+O(x^{b_k+1}),\quad b_k=8d_k-1,\quad
 L_k=(-1)^{d_k+1}y^{d_k}(y-1)^{d_k}(y-2)^{2d_k-1}\ne0.
 \tag{J14}
\]

Start with the path \(v_0v_1\cdots v_{m+1}\) and identify a fresh
copy of the root of \(S_{k,\epsilon_i}\) with \(v_i\), for
\(1\leq i\leq m\). Call the rooted result \(U_{k,m,\epsilon}\), rooted
at \(v_0\). It is connected, has \(n_km+2\) vertices, root degree one,
and maximum degree at most seven.

For a tail ratio \(t=E_T/C_T\), edge attachment (J4) induces
\[
 f_i(t)=\frac{1-xy t}{s_i-xKt}.
 \tag{J15}
\]
The already reviewed difference identities (E9)--(E10) apply
unchanged. In the same-bit identity the factor \(x(K-ys_i)\) has
order one and leading coefficient \(-1\). In the different-bit
identity the seed term has order \(b_k\) and leading coefficient
\(-L_k\), whereas a tail difference of order at least \(b_k\)
contributes only at order at least \(b_k+1\).

Induction on equal word length starts with the identical terminal
ratio \(t_*=(1+xy)^{-1}\). It shows that any two tails differ by an
element of \(x^{b_k}\mathbb Q(y)[[x]]\). At the first unequal bit
the two orders just displayed cannot cancel; every preceding equal
bit increases the order by one and reverses the leading sign. The
left endpoint supplies one further map, with \(s_*=1+xy\).
Thus words first differing at site \(j\) satisfy
\[
 \frac{E_{U_\epsilon}}{C_{U_\epsilon}}
 -\frac{E_{U_\eta}}{C_{U_\eta}}
 =(-1)^{j-1}(\eta_j-\epsilon_j)L_kx^{b_k+j}
       +O(x^{b_k+j+1}).                                    \tag{J16}
\]
All \(2^m\) ratios, and therefore all whole/deleted rooted pairs,
are distinct. This is an induction for every length, not an
enumeration claim.

At \(v_0\) append either a two-edge path on two new vertices or two
new leaves. The reviewed marker identities are
\[
 A_\epsilon=(1+x)C_{U_\epsilon}+xD_{U_\epsilon},\qquad
 B_\epsilon=C_{U_\epsilon}+x(2+xy)D_{U_\epsilon}.              \tag{J17}
\]
Their transformation determinant
\(x(1+2x+xy+x^2y)\) is nonzero. Hence the \(2^m\) pairs
\((A_\epsilon,B_\epsilon)\) are distinct. If \(a,b\) count the
distinct scalar values in the two marker families, then
\(ab\geq2^m\), so one family has at least \(\lceil2^{m/2}\rceil\)
values. Choose the path marker when \(a\geq b\), and the leaf marker
otherwise, and use it for every word. This is a deterministic finite
definition: exact polynomial evaluation and comparison determine
the chosen marker for any fixed \(k,m\). No equality between different
marker types is required. Both add two vertices and preserve the
degree bound, giving the claimed order \(N\).

## Preservation of the entire endpoint jets

Let \(J_d=y^d(y-1)^d\mathbb Z[x,y]\), with \(d=d_k\). By the exact
vanishing result, \(C_0-C_1,D_0-D_1\in J_d\). The factors \(K\)
and \(y(y-1)\) are coprime in the polynomial UFD, so
\(B_k=\Delta_k/K\in J_d\). Equation (J13) gives
\(E_0-E_1=(y-1)B_k\in J_d\); also \(F_0-F_1=xyB_k\in J_d\).
All seed states are therefore congruent modulo \(J_d\).

The attachment formulas (J4) are polynomial in those states.
Starting from the same terminal endpoint and propagating along the
path shows that every word has the same entire triple \((C,D,E)\)
modulo \(J_d\). Applying either fixed marker in (J17) preserves this
congruence. Thus, within the chosen family, every pairwise full
refinement difference is divisible by \(y^d(y-1)^d\).

At common order \(N\), the reviewed faithful translation is
\[
 P_T(a,z)=a^{-N}z^N C_T(z^{-2},1-a^{-2}),\qquad
 \widehat P_T=a^Nz^{-N}P_T.
 \tag{J18}
\]
With \(t=a^{-2}\), the normalized difference is divisible by
\((-t)^d(1-t)^d\). The first \(d\) normalized top-\(a\) layers
mean precisely the coefficients of \(t^j\), \(0\leq j<d\), in
\(\widehat P_T=C_T(z^{-2},1-t)\); they agree. At \(a=1\),
\(1-a^{-2}=(a-1)(a+1)/a^2\) has a simple zero and \(a^{-2}\)
is a unit. Consequently all derivatives of order below \(d\)
agree there. Multiplication by the common factor \(a^{-N}z^N\)
preserves this zero order, proving the full-polynomial assertion too.

The entire \(I_T(x)=C_T(x,1)\) and \(M_T(x)=C_T(x,0)\) agree, so
the whole normalized point count and Alexander polynomial agree:
\[
 R_T(q)=(q-1)^N I_T\!\left(\frac{q}{(q-1)^2}\right),\qquad
 P_T(1,z)=z^N M_T(z^{-2}).                                  \tag{J19}
\]
The first expression is a rational function in general, as in the
reviewed convention. It is not substituted for an unnormalized
variety-count polynomial. At fixed \(N\), (J18) is injective on
\(\mathbb Z[x,y]\), so the scalar values counted above are genuinely
distinct full HOMFLY polynomials.

The reviewed polygon-cell realization applies to every marked tree,
since \(N\geq37\). It gives a connected ordinary-simple and
plabic-simple disk graph with \(N\) interior faces, \(6N-2\) black
degree-one boundary vertices, and mutable quiver an orientation of
the input tree. Its specified opposite-color interior leaf, whose
neighbor has degree at least four, certifies non-reducedness.
This invokes the reviewed connected forest-quiver link theorem.
No disconnected link product, common-factor padding, non-alternating
claim, or refutation of the separate mutation-equivalence conjecture
is used.

Finally \(2^k<2r\) (including \(r=1\)), whence
\(n_k<(1840r^3+1)/7\leq263r^3\). Together with the scalar count,
this proves (J1)--(J2) and the theorem.

## Exact certificate and contribution boundary

Run:

```sh
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python research/jet_fibers.py --check research/jet_fibers.json
```

The new certificate checks the joining-edge states, marked deletion
identity, both product-switch differences, and denominator-free
recurrence in unrestricted symbolic variables. These are full
identities, with zero residuals. It checks the closed size and leading
recurrences, and the dedicated Jacobian result for \(Ky^2(y-1)^2\).
The adapter discovered and inspected
`polynomial.multivariate.factor.compute` before this custom code.
Server 0.14.0, protocol 2025-11-25 returned `FACTORIZED` and `EXACT`
reconstruction, adapter exit zero, no timeout or structured error.
This bounded operation proves only the stated factorization.

New actual switches at depths one and two check connectivity, simplicity,
root degree, size, and maximum degree. At depth one the independent
parent-count graph recurrence checks the complete coefficients through
\(x^{18}\), including the new order-14 whole/deleted defect, order-15
ratio defect, and first-disagreement indexing through site three.
Separate Taylor-ring graph calculations retain **every** \(x\)-degree
in the first two jets at both endpoints; their constant jets are
also compared with the reviewed independent rooted independence and
matching implementation. New marked graph samples check the leaf
skein identity in the retained \(z\)-layers, the entire independence
leaf identity and its normalized point-count translation, and actual
plabic realization. The JSON distinguishes these bounded samples
from the universal symbolic identities. Neither samples nor truncation
prove the all-depth or all-word statements; the inductions above do.

The strongest prior accepted theorem gives all \(2^m\) scalar values at
rate \(1/33\) when only the two entire endpoint polynomials are prescribed.
The present theorem does **not** improve that rate: its guaranteed
rate is \(1/(2n_k)\). Its new mathematical scope is simultaneous
invisibility to arbitrarily deep prescribed jets at both endpoints,
with actual connected bounded-degree switches and a cubic-in-depth
size bound. Rooted transfer, interlace identification, marker
determinants, and link substitutions remain known inputs. Independent
mathematical review of this delta and lawful primary-source priority
assessment are still required before any publishable-completion claim.
