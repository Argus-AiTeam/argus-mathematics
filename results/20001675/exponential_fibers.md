# Exponential joint-invariant fibers of forest-quiver HOMFLY

**Theorem.** For every integer \(m\geq1\), there is a family of connected
trees of maximum degree at most five, all on \(N=33m+4\) vertices, with
identical entire independence and matching polynomials and at least
\(\lceil 2^{m/2}\rceil\) distinct full two-variable HOMFLY polynomials.
Every member has the reviewed connected simple non-reduced plabic
realization. Consequently, a joint normalized-point-count/Alexander
fiber contains at least this many distinct full HOMFLY polynomials, and
\[
 \log_2 |\text{fiber}|\ \geq\frac{N-4}{66},
 \qquad N=33m+4.
 \tag{E1}
\]
This is an ordinary all-\(m\) proof with exact algebraic replay, not a
Lean formalization or an extrapolation from word enumeration.
Independent mathematical and publication review of this strengthening
is still required; historical originality is not asserted.

## Reviewed inputs and conventions

Use \(C_T(x,y)\), \(I_T(x)=C_T(x,1)\), and \(M_T(x)=C_T(x,0)\) in the
reviewed forest conventions of `rooted_obstruction.md` and
`joint_refinement.md`. The exact inputs and independently checked source
attributions are unchanged. In particular, (24)--(28) of the latter
give rooted trees \(S_0,S_1\) of order 33, root degree two, and maximum
degree five. Write
\[
 K=y-1+xy^2,\quad C_i=C_{S_i},\quad D_i=C_{S_i-z},\quad
 E_i=\frac{yC_i-D_i}{K},\quad s_i=\frac{C_i}{E_i}.
 \tag{E2}
\]
The \(E_i\) are polynomials with constant coefficient 1. The reviewed
whole and deleted differences are both
\[
 \Delta=C_0-C_1=D_0-D_1
 =-x^6y(y-1)(1+x)K C_A C_B.
 \tag{E3}
\]
All four endpoint states, whole and root-deleted at \(y=0,1\), agree.

The chain \(U_{m,\epsilon}\) is exactly the reviewed one: start with
\(v_0v_1\cdots v_{m+1}\) and identify \(z\) of \(S_{\epsilon_i}\) with
\(v_i\), \(1\leq i\leq m\). It has order \(33m+2\), maximum degree five,
and root \(v_0\) of degree one. No switch, source, or old certificate
has been changed.

The source baseline is the already independently inspected Schwartz
`arxiv:2410.00399v2`, Definition 3.1, Lemma 4.1, Theorems 3.11 and 4.6,
and Corollary 4.12; Galashin--Lam `arxiv:2208.01175v1`, Proposition
5.8; and the reviewed tree realization `CPLABIC`. The identification
with the two-variable interlace polynomial is `CINTERLACE`. The
general rooted transfer is already explained by Traldi
`arxiv:0808.1888v4`, Definition 18 and Theorems 13 and 20, as recorded
in `CJOINTCOMPARE`. These are known inputs, not new results of this note.
The previously rejected old matching-visible publication route stays
retired. The distinct unread dissertation and final-journal bodies
remain a priority blocker; no access denial or search miss is evidence
that they contain no overlapping theorem.

## The switch gap has order seven

All series calculations below take place in the integral domain
\(\mathcal A=\mathbb Q(y)[[x]]\), with \(y\) indeterminate. For nonzero
series, \(\nu\) denotes \(x\)-adic order; \(\nu(0)=+\infty\).
Every displayed \(C,E\) has constant coefficient 1, so its inverse is
defined in \(\mathcal A\). Also \(K\) is a unit there. Polynomial
identities involving \(K\) may alternatively be cleared of denominators;
we never evaluate a rational expression at a pole.

From (E2)--(E3),
\[
 E_0-E_1=\frac{(y-1)\Delta}{K},
\]
and hence the exact cross numerator is
\[
 \begin{aligned}
 C_0E_1-C_1E_0
 &=\frac{\Delta}{K}\bigl(KE_1-(y-1)C_1\bigr)\\
 &=\frac{\Delta}{K}(C_1-D_1)\\
 &=-x^6y(y-1)(1+x)C_A C_B(C_1-D_1).
 \end{aligned}
 \tag{E4}
\]
For a forest with \(n\) vertices and \(c\) components,
\([x]C=(n-c)+cy\). Indeed, in the reviewed rank-nullity coordinates
\(C_F=H_F(x(1-y),xy)\), the terms of \(x\)-degree one come precisely
from single vertices and single edges. For a subset of at least three
vertices, its \(x\)-degree is
\(|A|-\operatorname{rank}(A)/2\geq\lceil |A|/2\rceil\geq2\);
a nonadjacent two-vertex subset also has degree two.
Thus, since deleting the degree-two root of \(S_1\) leaves two
components,
\[
 [x]C_1=32+y,\quad [x]D_1=30+2y,\quad
 C_1-D_1=x(2-y)+O(x^2).
 \tag{E5}
\]
Both \(C_A,C_B\) and \(E_0,E_1\) have constant coefficient 1. Therefore
\[
 s_0-s_1=x^7 L+O(x^8),\qquad
 L=y(y-1)(y-2)\ne0,\qquad \nu(s_0-s_1)=7.
 \tag{E6}
\]
The extra factor \(C_1-D_1\), rather than the order-six whole-polynomial
defect alone, is essential here. Specializations \(y=0,1,2\) are not
used to establish injectivity.

## Attachment and first-disagreement decoding

For any rooted tree, let \(C,D,E\) be its whole, root-deleted, and
root-excluded-product states, so \(yC=D+KE\).
If its rooted children have states \(C_j,E_j\), the reviewed rooted
recurrence gives
\[
 E=\prod_j(C_j-xyE_j),\qquad D=\prod_j C_j.
\]
Attaching a new child with states \(C_T,E_T\) to a rooted piece with
states \(C_i,E_i,D_i\) consequently gives
\[
 C'=C_iC_T-xK E_iE_T,\quad
 E'=E_i(C_T-xyE_T),\quad D'=D_iC_T.
 \tag{E7}
\]
These are polynomial identities, including at both endpoints.
For \(t=E_T/C_T\), the new ratio is
\[
 f_i(t)=\frac{1-xy t}{s_i-xKt}.
 \tag{E8}
\]
The constant term of \(s_i\) is 1, so these maps take series of constant
term 1 to series of constant term 1, with unit denominators.

Two exact identities supply the decoding, rather than a generic
nonisomorphism assertion:
\[
 f_i(t)-f_i(u)
 =\frac{x(K-ys_i)(t-u)}
        {(s_i-xKt)(s_i-xKu)},
 \tag{E9}
\]
and
\[
 f_0(t)-f_1(u)
 =\frac{-(s_0-s_1)(1-xy t)+x(K-ys_0)(t-u)}
        {(s_0-xKt)(s_1-xKu)}.
 \tag{E10}
\]
Since \(K(0)-ys_i(0)=-1\), (E9) increases the valuation of every
nonzero tail difference by exactly one and multiplies its leading
coefficient by \(-1\).

Fix any terminal series of constant term 1. Induction on word length
shows that all equal-length word images differ, if at all, by an
element of \(x^7\mathcal A\). The length-zero images are equal.
For equal first bits, (E9) preserves this assertion. For unequal first
bits, the first term in the numerator of (E10) has order seven with
nonzero leading coefficient \(-L\), whereas its tail term has order
at least eight. They cannot cancel. Interchanging 0 and 1 reverses
the sign. If two words have \(\ell\) common initial bits, apply (E9)
\(\ell\) times: the resulting difference has order \(7+\ell\).
This proves equal-length word injectivity for every length, without
enumerating words or assuming their tails are equal.

For the actual chain, the rightmost endpoint supplies
\(t_*=(1+xy)^{-1}\). The leftmost endpoint is one further application
of the same form (E8), with \(s_*=1+xy\). Thus
\[
 t_\epsilon:=\frac{E_{U_{m,\epsilon}}}{C_{U_{m,\epsilon}}}
 =f_*\circ f_{\epsilon_1}\circ\cdots\circ f_{\epsilon_m}(t_*).
 \tag{E11}
\]
If \(j\) is the first differing site of \(\epsilon,\eta\), (E9)--(E10)
give the sharper exact statement
\[
 t_\epsilon-t_\eta
 =(-1)^{j-1}(\eta_j-\epsilon_j)L\,x^{j+7}
     +O(x^{j+8}).
 \tag{E12}
\]
In particular all \(2^m\) ratios are distinct. The pair
\((C_U,C_{U-v_0})\) determines \(E_U=(yC_U-C_{U-v_0})/K\) and
therefore its ratio. All \(2^m\) rooted-state pairs are distinct.

Their whole and deleted independence and matching polynomials are,
nevertheless, independent of the word. The reviewed seed equality
implies equality of \(E_0,E_1\) at \(y=0,1\): at 0, \(K=-1\); at 1,
\(K=x\), and cancellation of the nonzero polynomial \(x\) is valid.
Now (E7), starting from the common right endpoint, propagates the
three endpoint states along the chain. This is endpoint equality of
polynomials, not just equality at a numerical value of \(x\).

## Two equal-size markers extract a scalar exponential fiber

At \(v_0\), append either a two-edge path on two new vertices (marker
\(\mathrm p\)) or two new leaves (marker \(\mathrm l\)). Write
\(C=C_U\), \(D=C_{U-v_0}\). The leaf recurrence
\(C_F=C_{F-b}+xC_{F-a-b}\), with singleton \(1+xy\), gives
\[
 A_\epsilon:=C_{U^\mathrm p}=(1+x)C+xD,\qquad
 B_\epsilon:=C_{U^\mathrm l}=C+x(2+xy)D.
 \tag{E13}
\]
For the first formula, deleting the terminal new leaf leaves \(U\)
with one new leaf; deleting its two-edge tail leaves \(U\).
For the second, deleting one new leaf again leaves the one-leaf
extension, and deleting that leaf and \(v_0\) leaves
\((U-v_0)\sqcup P_1\).

The joint transformation has matrix and determinant
\[
 \begin{pmatrix}1+x&x\\1&x(2+xy)\end{pmatrix},
 \qquad
 \det=x(1+2x+xy+x^2y)\ne0.
 \tag{E14}
\]
It is injective over \(\mathbb Q(x,y)\), hence on the rooted polynomial
pairs. Consequently the \(2^m\) pairs \((A_\epsilon,B_\epsilon)\) are
distinct. If \(a_m,b_m\) are the numbers of distinct scalar values in
the two marker families, respectively, then
\[
 a_m b_m\geq2^m,\qquad
 \max(a_m,b_m)\geq\lceil 2^{m/2}\rceil.
 \tag{E15}
\]
Choose one marker type attaining the larger cardinality, for this
fixed \(m\), and take its family. The marker is the same for every
word in that family. No equality between the endpoint polynomials
of the *two different marker types* is claimed or needed.

Both markers add exactly two vertices and preserve tree connectivity.
They change the degree of \(v_0\) from one to two or three, leaving
all other old degrees unchanged. Their new vertices have degree at
most two. Thus their order is \(33m+4\) and their maximum degree is
at most five. Substituting \(y=0,1\) in (E13) proves equality of the
entire matching and independence polynomials within each marker family.

## Faithful link translation and realizations

At this common order \(N\), the reviewed formula
\[
 P_T(a,z)=a^{-N}z^N C_T(z^{-2},1-a^{-2})
 \tag{E16}
\]
is injective on \(\mathbb Z[x,y]\). Distinct powers of \(x\) become
distinct powers of \(z^{-2}\); the substitution \(y=1-a^{-2}\) is an
injective change of one polynomial variable. The common Laurent
monomial is nonzero. Thus (E15) counts distinct full HOMFLY
polynomials, not merely distinct graphs or rooted labels.

The same fixed order and common \(I\) give common normalized quiver
point counts
\(R_T(q)=(q-1)^N I_T(q/(q-1)^2)\). These are rational functions in
general; no claim about an unnormalized variety-count polynomial is
being substituted. Common entire \(M\), at fixed order, gives common
Alexander polynomials by the reviewed Schwartz Corollary 4.12.

Apply the reviewed polygon-cell construction `CPLABIC` to each marked
tree. Here \(N\geq37\), so its \(n\geq2\) hypothesis holds. It gives
a connected ordinary-simple and plabic-simple disk graph, \(N\)
interior faces, \(6N-2\) black degree-one boundary vertices, and mutable
quiver an orientation of the input tree. Its specified opposite-color
interior leaf, with neighbor degree at least four, certifies
non-reducedness. Connectedness is precisely the hypothesis needed for
the reviewed link identification. No non-alternating assertion or
mutation-equivalence assertion is made. This proves the theorem.

## Exact replay and contribution boundary

Run the new, campaign-local certificate without modifying the reviewed
inputs:

```sh
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python research/exponential_fibers.py --check research/exponential_fibers.json
```

The replay reads the accepted seed polynomials, obtains each \(E_i\)
by exact polynomial division, verifies the complete cross numerator
(E4) and its exact order and leading coefficient, and verifies
(E7), (E9), (E10), and both marker identities in symbolic variables.
It checks the dedicated Jacobian factorization against (E14), including
its typed status and exact product reconstruction. New small graph
samples compare the chain transfer and markers with the existing
rooted recurrence, direct Laurent skein recurrence, point-count
numerator recurrence, and disk-map construction. First-disagreement
samples test the signs and site indexing through site three. These
are bounded implementation checks; (E9)--(E12), not the samples,
establish the all-word, all-\(m\) conclusion.

The Jacobian operation is `polynomial.multivariate.factor.compute`,
server 0.14.0, protocol 2025-11-25, with the dedicated files
`jacobian/exponential-{discovery,contract,input,output,status}.json`.
It returned `FACTORIZED`, `product_reconstruction=EXACT`, adapter
exit zero, and no timeout or structured error. It factors the marker
determinant; it does not prove decoding, plabic realizability, or priority.

The strongest accepted prior quantitative result was at least \(m+1\)
full polynomials on \(33m+2\) vertices, separated by Hamming weight.
That lower bound supplied no positive exponential rate. The new
rooted-state decoding preserves ordered-word information, and the
two-vertex marker argument proves rate at least \(1/66\) along
\(N=33m+4\). This is an asymptotic strengthening, not a claim that the
displayed bound is larger for every small \(m\). Both entire endpoint
polynomials, connectedness, and the degree-five bound are preserved.

**Publication assessment (Engineer, not independent acceptance).**
The new mathematical step is the noncancelling first-disagreement
proof for this compatible switch and the resulting exponential
*scalar-invariant* fiber. The previously inspected Traldi transfer,
Zhu/Wagner--Wang endpoint replacement, forest-interlace identification,
and Schwartz translations do not themselves state this ordered
decoding or this fiber-rate conclusion. They remain its acknowledged
inputs; the determinant and rooted transfer are not claimed as new.
The improvement is a substantive quantitative candidate rather than
another matching-visible reconstruction. This comparison does not
establish that an earlier work contains no equivalent argument or
theorem. In particular the closest dissertation and final-journal
bodies remain unread, so `novelty_status=verified_new` and independent
publication-level significance cannot yet be claimed. Normal
Host-invoked Reviewer replay and a separate publication assessment
are required. The old technical publication rejection, accepted
mathematics, and primary-source access blocker are all preserved.
