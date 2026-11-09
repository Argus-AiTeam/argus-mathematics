# Quadratic-cost endpoint-jet obstruction on degree-five trees

**Theorem (CPOLARFIBER).** For every pair of integers \(r,m\geq1\), put
\[
 q_r=2^{\lfloor\log_2 r\rfloor},\qquad
 n(r)=\frac{98q_r(3r-2q_r)+1}{3},\qquad N=n(r)m+4.
 \tag{P1}
\]
There is an explicitly defined family of connected ordinary-simple trees
on \(N\) vertices, of maximum degree at most five, with at least
\(\lceil2^{m/2}\rceil\) distinct full two-variable HOMFLY polynomials.
All members have identical entire normalized quiver point counts and
Alexander polynomials, identical first \(r\) normalized top-\(a\) layers,
and identical derivatives through order \(r-1\) at \(a=1\), for both
normalized and full HOMFLY. Every tree has the unchanged reviewed connected
simple non-reduced plabic realization. Moreover,
\[
 n(1)=33,\qquad n(r)\leq37r^2,\qquad
 \log_2|\text{fiber}|\geq\frac{N-4}{2n(r)}
                         \geq\frac{N-4}{74r^2}.
 \tag{P2}
\]

This is an all-\(r\), all-\(m\) theorem proved below in ordinary mathematics,
with an exact rerunnable algebraic certificate and bounded graph checks.
It is not a finite-search conclusion or a Lean-kernel certificate.
Independent review of this new delta is required; historical originality
and publication-level significance remain unverified.

## Unchanged independently accepted inputs

Use the forest refinement \(C_T(x,y)\), with
\[
 I_T(x)=C_T(x,1),\quad M_T(x)=C_T(x,0),\quad K=y-1+xy^2.
 \tag{P3}
\]
For a rooted tree \((T,z)\), put \(C=C_T,\ D=C_{T-z}\) and
\[
 E=(yC-D)/K,\qquad F=(D-E)/y.
 \tag{P4}
\]
These are polynomial states and satisfy
\[
 C=(1+xy)E+F,\quad D=E+yF,\quad
 KF=(1+xy)D-C,\quad yC=D+KE.
 \tag{P5}
\]
The reviewed transfer laws are
\[
 \begin{split}
 C_{A\cdot B}&=E_A C_B+F_A D_B,\quad
 D_{A\cdot B}=D_A D_B,\quad E_{A\cdot B}=E_A E_B,\\
 (C',D',E')&=(CC_T-xKEE_T,\ DC_T,\ E(C_T-xyE_T)).
 \end{split}
 \tag{P6}
\]
The dot coalesces only the two roots; the second line attaches a child by
one edge. These are known rooted-transfer identities, not a novelty claim.

`CJOINTSEED` supplies the unchanged 33-vertex rooted trees \(S_{1,0},S_{1,1}\)
of root degree two and maximum degree five, with
\[
 C_{1,0}-C_{1,1}=D_{1,0}-D_{1,1}
 =\Delta_1=-x^6y(y-1)(1+x)K C_A C_B.
 \tag{P7}
\]
Their actual edges and full polynomials are `joint_certificate.json`.
Both \(C_A,C_B\) have constant \(x\)-coefficient one, including at both
endpoints. We read the reviewed input; we do not regenerate its atoms.

The first-disagreement maps and equal-size marker determinant are the
accepted (E7)--(E15) in `exponential_fibers.md`. The degree-25 fixed-path
scalar theorem in `scalar_fibers.md` is independently accepted at rate
\(1/33\). The cubic-cost degree-seven all-depth theorem in `jet_fibers.md`
is independently accepted by `reviewer:copilot-jet-review`.
All their statements, certificates, and supporting judgements are unchanged.

The imported source propositions are the already independently inspected
Schwartz `arxiv:2410.00399v2`, Definition 3.1, Lemma 4.1, Theorems 3.11
and 4.6, Corollary 4.12; Galashin--Lam `arxiv:2208.01175v1`, Proposition
5.8; and the all-tree realization `CPLABIC`. `CINTERLACE` gives the
rank-nullity interpretation. The known rooted-transfer comparison with
Traldi `arxiv:0808.1888v4`, Theorems 13 and 20, is also preserved.
The new claim routes reference these accepted claims rather than mint
duplicate assumptions or repeat completed citation reviews. No new external
proposition is used. The unread closest dissertation and final-journal
bodies still block historical-priority certification; no denied source
was retried, and no source absence or originality is inferred.

## Direct polarization, without a doubled marked tree (CPOLARSEED)

Let \(A_0,A_1\) and \(B_0,B_1\) be rooted tree pairs such that
\[
 C_{A_0}-C_{A_1}=D_{A_0}-D_{A_1}=\Delta_A,\qquad
 C_{B_0}-C_{B_1}=D_{B_0}-D_{B_1}=\Delta_B.
 \tag{P8}
\]
Write \(W_A=C_{A_1}-D_{A_1}\) and \(W_B=C_{B_1}-D_{B_1}\).
Using fresh disjoint copies, attach two coalesced children to a new root:
\[
 R_0:\ (A_0\cdot B_0,\ A_1\cdot B_1),\qquad
 R_1:\ (A_0\cdot B_1,\ A_1\cdot B_0).
 \tag{P9}
\]
**Polarization lemma.** The whole and new-root-deleted differences are
equal and given by the complete polynomial identity
\[
 \Delta_R=C_{R_0}-C_{R_1}=D_{R_0}-D_{R_1}
          =\frac{\Delta_A\Delta_B W_AW_B}{K}.
 \tag{P10}
\]
In particular this is not the old product switch with a common
whole polynomial, and it does not first construct \(Q\).

**Proof.** From (P4)--(P8),
\[
 E_{A_0}-E_{A_1}=(y-1)\Delta_A/K,\quad
 F_{A_0}-F_{A_1}=xy\Delta_A/K.
\]
Consequently
\[
 E_{A_0}F_{A_1}-F_{A_0}E_{A_1}=-\Delta_AW_A/K,\qquad
 C_{B_0}D_{B_1}-D_{B_0}C_{B_1}=-\Delta_BW_B.
 \tag{P11}
\]
Put \(T_{ij}=A_i\cdot B_j\) and \(c_{ij}=C_{T_{ij}}\).
The determinant of
\(c_{ij}=E_{A_i}C_{B_j}+F_{A_i}D_{B_j}\) is the product of the
two determinants in (P11). Deleting the new root in (P9) therefore gives
\[
 c_{00}c_{11}-c_{01}c_{10}=\Delta_A\Delta_BW_AW_B/K.
 \tag{P12}
\]
The root-excluded child state is
\[
 o_{ij}=c_{ij}-xyE_{A_i}E_{B_j}
       =\frac{D_{A_i}D_{B_j}+(y-1)E_{A_i}E_{B_j}}{y}.
 \tag{P13}
\]
Here
\[
 D_{A_0}E_{A_1}-E_{A_0}D_{A_1}=y\Delta_AW_A/K
\]
and the corresponding identity holds for \(B\). Taking the determinant
in (P13) gives
\[
 E_{R_0}-E_{R_1}
 =o_{00}o_{11}-o_{01}o_{10}
 =\frac{(y-1)\Delta_A\Delta_BW_AW_B}{K^2}
 =\frac{y-1}{K}\Delta_R.
 \tag{P14}
\]
Subtract \(yC_R=D_R+KE_R\) for the two trees. Equations (P12)--(P14)
give \(y(C_{R_0}-C_{R_1})=y\Delta_R\), proving (P10).

All calculations can first be made in the rational function field and
then read as identities of the actual polynomial states. More explicitly,
\(K\mid\Delta_A,\Delta_B\): \(K\mid(y-1)\Delta\) by the \(E\)-difference,
and \(\gcd(K,y-1)=1\) in the polynomial UFD. Writing \(B_A=\Delta_A/K\)
and \(B_B=\Delta_B/K\) removes all denominators:
\[
 \Delta_R=K B_A B_B W_AW_B,\qquad B_R=B_A B_B W_AW_B.
 \tag{P15}
\]
No specialization at a pole is used.

## Actual balanced switches, exact depth, and degree

For \(r>1\), set \(a=\lfloor r/2\rfloor\) and \(b=\lceil r/2\rceil\).
Define \(S_{r,0},S_{r,1}\) by (P9) with
\(A_i=S_{a,i}\) and \(B_i=S_{b,i}\), using fresh copies for each
child and a fresh root. Both are connected ordinary-simple trees:
coalescing two tree roots creates a tree, and the only connection
between the two children is through the new root.

The new root has degree two. Each coalesced child root has degree
\(2+2+1=5\), including its edge to the new root. Other vertices
retain their previous degrees. Thus induction gives maximum degree
at most five at every exact depth. The order satisfies
\[
 n(1)=33,\qquad n(r)=1+2(n(a)+n(b)-1)=2n(a)+2n(b)-1.
 \tag{P16}
\]

For a forest with \(n\) vertices and \(c\) components,
\([x]C=n-c+cy\). In the reviewed rank-nullity coordinates, degree-one
terms come only from single vertices and single edges; a selected
set of size at least three has \(x\)-degree at least two.
Deleting a degree-two root leaves two components, so at every depth
\[
 C_{r,1}-D_{r,1}=x(2-y)+O(x^2).
 \tag{P17}
\]
In particular this difference is a nonzero polynomial and remains
nonzero at both \(y=0\) and \(y=1\).

Equation (P7) has exact vanishing order one at each endpoint.
The polynomials \(K(x,0)=-1\) and \(K(x,1)=x\) are nonzero; thus
\(K\) has neither \(y\) nor \(y-1\) as a factor. Equations (P15)
and (P17) show inductively that \(\Delta_r\ne0\), \(K\mid\Delta_r\),
and its exact orders at \(y=0\) and \(y=1\) are \(a+b=r\).
This proves exact depth, not just a lower bound or dyadic overshoot.

Let \(\alpha_r=\nu_x(\Delta_r)\) and
\(H_r=[x^{\alpha_r}]\Delta_r\), working in \(\mathbb Q(y)[[x]]\).
Since \(K\) has \(x\)-constant term \(y-1\), (P7), (P10), and (P17) give
\[
 \alpha_1=6,\quad \alpha_r=\alpha_a+\alpha_b+2,\quad
 H_1=-y(y-1)^2,\quad H_r=H_aH_b(2-y)^2/(y-1).
\]
Therefore, for every integer \(r\geq1\),
\[
 \alpha_r=8r-2,\qquad
 H_r=(-1)^r y^r(y-1)^{r+1}(y-2)^{2r-2}\ne0.
 \tag{P18}
\]
The endpoint orders of this one \(x\)-coefficient need not be those
of the entire defect; exact endpoint orders were proved by (P15).

## Solving the size recurrence without overshoot

Put \(f_q(s)=(98q(3s-2q)+1)/3\). Then \(f_1(1)=33\) and
\[
 f_{q/2}(q)=f_q(q),\qquad
 2f_{q/2}(a)+2f_{q/2}(b)-1=f_q(a+b).
 \tag{P19}
\]
For \(q=q_r\) and \(r>1\), both children lie in \([q/2,q]\).
The endpoint identity in (P19) permits use of \(q/2\) even if a
child equals \(q\). Strong induction in (P16) proves (P1).
For example, \(n(2)=131,\ n(3)=327,\ n(4)=523,\ n(5)=915\).

The exact identity
\[
 37r^2-n(r)=\frac{r^2}{4}-\frac13
                   +\frac{49}{12}(3r-4q_r)^2
 \tag{P20}
\]
is nonnegative for \(r\geq2\); for \(r=1\) the difference is four.
This proves the uniform bound in (P2).

## All-word decoding and scalar extraction (CPOLARDECODE)

Put \(s_{r,i}=C_{r,i}/E_{r,i}\). Their \(E\)'s have constant
\(x\)-coefficient one. Equal whole/deleted defects give the exact cross
numerator
\[
 C_{r,0}E_{r,1}-C_{r,1}E_{r,0}
       =(\Delta_r/K)(C_{r,1}-D_{r,1}).
 \tag{P21}
\]
Equations (P17)--(P18) imply
\[
 s_{r,0}-s_{r,1}=L_r x^{b_r}+O(x^{b_r+1}),\quad b_r=8r-1,\quad
 L_r=(-1)^{r+1}y^r(y-1)^r(y-2)^{2r-1}\ne0.
 \tag{P22}
\]

Start with the path \(v_0v_1\cdots v_{m+1}\). At each internal site
\(v_i\), coalesce a fresh root of \(S_{r,\epsilon_i}\), for
\(\epsilon\in\{0,1\}^m\), obtaining \(U_{r,m,\epsilon}\), rooted at
\(v_0\). Its order is \(n(r)m+2\), its root has degree one, and
its maximum degree is at most five. A site root has degree four,
not a degree exceeding five.

For a tail ratio \(t=E_T/C_T\), (P6) induces the reviewed map
\[
 f_i(t)=\frac{1-xy t}{s_{r,i}-xKt}.
 \tag{P23}
\]
The accepted exact difference identities (E9)--(E10) apply with
these new seed states. All denominators are units in
\(\mathbb Q(y)[[x]]\). An equal-bit map raises any nonzero difference
order by exactly one and reverses its leading sign, since
\(K(0)-ys_{r,i}(0)=-1\). At an unequal bit the seed term has order
\(b_r\) with leading coefficient \(-L_r\); a tail difference of
order at least \(b_r\) contributes only from order \(b_r+1\).

Induction on equal word length, starting from the identical terminal
ratio \((1+xy)^{-1}\), first shows that all tail differences lie in
\(x^{b_r}\mathbb Q(y)[[x]]\). The two terms at the first unequal bit
cannot cancel. Every preceding equal bit raises the order by one;
the left endpoint adds one final equal map. Thus words first
differing at site \(j\) satisfy
\[
 \frac{E_{U_\epsilon}}{C_{U_\epsilon}}
 -\frac{E_{U_\eta}}{C_{U_\eta}}
 =(-1)^{j-1}(\eta_j-\epsilon_j)L_r x^{b_r+j}
                      +O(x^{b_r+j+1}).
 \tag{P24}
\]
This proves all \(2^m\) ratios and whole/deleted pairs are distinct
for every length, without assuming identical tails or extrapolating
from word enumeration.

At \(v_0\), append either a two-edge path on two new vertices or two
new leaves. Their unchanged reviewed scalar polynomials are
\[
 A_\epsilon=(1+x)C_{U_\epsilon}+xD_{U_\epsilon},\qquad
 B_\epsilon=C_{U_\epsilon}+x(2+xy)D_{U_\epsilon}.
 \tag{P25}
\]
Their transformation determinant is
\(x(1+2x+xy+x^2y)\ne0\). The joint scalar pairs therefore have
\(2^m\) values. If the two individual image cardinalities are
\(a_{r,m},b_{r,m}\), then \(a_{r,m}b_{r,m}\geq2^m\).
One fixed marker family has at least \(\lceil2^{m/2}\rceil\) values.
Choose path if \(a_{r,m}\geq b_{r,m}\), otherwise leaves, and use
that same marker for every word. Exact finite polynomial comparison
defines this choice for each \(r,m\); injectivity of either individual
marker at higher depths is not assumed. Both markers add two vertices,
give order \(N\), and preserve connectivity and degree at most five.

## Entire endpoint data, jets, and faithful links (CPOLARDATA)

Let \(J_r=y^r(y-1)^r\mathbb Z[x,y]\).
The exact endpoint orders imply \(\Delta_r\in J_r\).
Since \(K\) has no endpoint factor, \(B_r=\Delta_r/K\in J_r\) as well.
The differences in all four seed states are
\[
 \Delta C=\Delta D=\Delta_r,\qquad
 \Delta E=(y-1)B_r,\qquad \Delta F=xyB_r,
 \tag{P26}
\]
so they belong to \(J_r\). Polynomial attachment (P6), from the common
terminal endpoint along each word, preserves their congruence. Either
fixed marker (P25) does too. Every pairwise full refinement difference
within the chosen family is therefore divisible by \(y^r(y-1)^r\).

At common order \(N\), the reviewed forest-quiver translation is
\[
 P_T(a,z)=a^{-N}z^N C_T(z^{-2},1-a^{-2}),\qquad
 \widehat P_T=a^N z^{-N}P_T.
 \tag{P27}
\]
This is injective: different \(x\)-powers give different
\(z^{-2}\)-powers, and \(y=1-a^{-2}\) is an injective change of
one polynomial variable. The common Laurent monomial is nonzero.
Thus the scalar values in (P25) are distinct full HOMFLY polynomials.

With \(t=a^{-2}\), the normalized differences are divisible by
\((-1)^r t^r(1-t)^r\). The first \(r\) normalized top-\(a\) layers
are precisely coefficients of \(t^j\), \(0\leq j<r\), in
\(\widehat P=C_T(z^{-2},1-t)\); all agree.
At \(a=1\), \(1-a^{-2}=(a-1)(a+1)/a^2\) has a simple zero
and \(a^{-2}\) is a unit. All derivatives of order below \(r\)
agree there. Multiplication by the common \(a^{-N}z^N\) preserves
this vanishing order, proving the assertion for full HOMFLY too.

The entire endpoint polynomials agree, hence so do
\[
 R_T(q)=(q-1)^N I_T\!\left(\frac{q}{(q-1)^2}\right),\qquad
 P_T(1,z)=z^N M_T(z^{-2}).
 \tag{P28}
\]
The first is the reviewed normalized rational function, not a
substitution for an unnormalized variety-count polynomial.

For every \(N\geq37\), `CPLABIC` realizes the input tree by a
connected ordinary-simple and plabic-simple disk graph with \(N\)
interior faces, \(6N-2\) black degree-one boundary vertices, and
mutable quiver an orientation of that tree. The specified
opposite-color interior leaf has neighbor degree at least four
and certifies non-reducedness. Connectedness supplies the hypothesis
of the reviewed forest-quiver link identification. The degree-five
bound is on the trees, not a new bound on the disk graphs.
No non-alternating or mutation-equivalence assertion is made.
Equations (P16)--(P28) prove the theorem and (P2).

## Exact replay and the mathematical improvement

```sh
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python research/polarized_jet_fibers.py --check research/polarized_jet_fibers.json
```

The certificate checks the unrestricted direct-polarization determinants,
both whole/deleted differences, polynomial denominator removal, the
dyadic-boundary and balanced-size identities, the quadratic bound identity,
and endpoint and Laurent translation identities with exact arithmetic.
New actual graphs check non-dyadic depths, degree five, the independent
parent-count recurrence against direct transfer, the new defect and ratio
orders, first-disagreement signs, and scalar extraction. Full-\(x\) Taylor
calculations check all requested endpoint jets and the first nonzero seed
jet in new bounded samples. New marked samples check the entire independent
independence/matching data, leaf skein/count translations, and the unchanged
plabic realization. Every truncation and sample is explicitly labelled;
the uniform inductions above, not those samples, prove all quantifiers.

The Engineer's durable certificate run exited zero in 3.8 seconds and
persisted a certificate of 99,369 bytes, with successful JSON readback.
All 53 exact residuals are zero: 38 unrestricted or typed identity checks
and 15 explicitly bounded leading-coefficient instances. Actual depth-two
and depth-three switches agree with the independent graph recurrence
through \(x^{18}\) and \(x^{26}\), respectively. Full-\(x\) graph Taylor
calculations find the first nonzero whole/deleted jet at exactly orders
two and three at each endpoint. Actual structural samples at depths
two, three, five, and six have root degree two and maximum degree five.
The submitted run is an Engineer check; the command above remains the
normal independent Reviewer's replay, not an already obtained verdict.

Jacobian discovery and inspection preceded custom certificate code.
The full cleared coalescence-matrix payload was rejected before computation
with `INVALID_REQUEST`, `matrix.budget_exceeded`, adapter exit two,
and no timeout. That is a typed admission failure, not support or
refutation of (P10). It is preserved in dedicated
`jacobian/polarized-jet-{input,output,status}.json`.
Under the same inspected determinant contract, the bounded rooted-pair
minor \(\det\bigl(\begin{smallmatrix}c+h&d+h\\c&d\end{smallmatrix}\bigr)
=-h(c-d)\) returned an exact `SYMPY_BAREISS` result,
server 0.14.0, protocol 2025-11-25, adapter exit zero, no timeout,
and no structured error. Its dedicated minor input, output, and status
are retained too. This operation verifies only the factor in (P11);
the full unrestricted identities are separately checked by the certificate.

The strongest accepted arbitrary-depth theorem used degree seven,
dyadic depth \(2^k\geq r\), and \(n_k=(230\cdot8^k+1)/7\leq263r^3\).
Direct polarization removes its doubled marked tree and adds exact depths,
giving degree five, order (P1), and quadratic cost \(n(r)\leq37r^2\),
without depth overshoot. For example, depth three uses 327 vertices per
switch, instead of the accepted dyadic construction's 2103.
This is the quantitative improvement being submitted for independent review.

The accepted depth-one fixed-path theorem still has all \(2^m\) scalar
values on \(33m+4\) vertices and rate \(1/33\); it is stronger than
the uniform two-marker guarantee at \(r=1\) and remains available unchanged.
We do not claim to improve that scalar rate. Known transfer and interlace
identities, marker extraction, and link translations remain acknowledged
inputs. The new bounded mathematical theorem is not certified historical
originality or publication-level acceptance, and does not complete the
publishable campaign while those independent gates remain open.
