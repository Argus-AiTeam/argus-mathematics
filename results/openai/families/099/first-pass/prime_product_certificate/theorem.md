# A coprime-period recursive obstruction

This is a parameter-uniform proof, not an inference from the finite checks in
`verify.py`. It verifies Proposition `prop:family` of the staged matching-bounds
manuscript, conditional on its specified prime pool, and gives a stronger
version. The separate Lean statement has the narrower scope stated in
`statement_fidelity.md`; it is not a formalization of this entire proof.

## Theorem

Let \(b\ge2\), \(1\le t<b\), \(c,L,h\ge1\) be integers. Let
\(n_1,\ldots,n_b\ge2\) be pairwise coprime integers, each at most \(R\).
Assume the product of **every** \(t\) distinct periods is at least \(L\).
Put
\[
 C=c+b-1,\qquad \mu=\min(c,b-t).
\]
Choose any positive integers \(g_s\), one for each positive level. There are
finite abelian state groups with distinguished elements of the indicated
orders, word maps, and cheap-step lists, with the following simultaneous
properties at every finite depth. Their common word length is
\[
 N_0=1,\qquad N_s=L(C+g_s)N_{s-1},
\]
and their alphabet size is at most \(A_s\), where
\[
 A_0=R,\qquad A_s=1+CA_{s-1}.
\]
Define
\[
 a_0=1,\quad
 a_s=\frac{2\mu g_s a_{s-1}}
 {(2g_s+\mu a_{s-1})(C+g_s)},\qquad
 B_0=2,\quad
 B_s=\frac{R^{2(h-1)}}L+
       \frac{2C}{h(C+g_s)}B_{s-1}.
 \tag{1}
\]
Every listed step \((e,r)\) obeys
\(\operatorname{ID}(W(z),W(z+e))\le N_s r\) at every state.
Every nonzero distinguished shift obeys
\(\operatorname{ID}(W(z),W(z+uv))\ge N_s a_s\) at every state.
Every map \(H\) from the state group to **real sequence-space**
\(\ell_1\) obeying the averaged listed budgets satisfies
\(V_H(uv)\le B_s\). No slice-wise budget, word-map injectivity, or
payload-boundary-respecting alignment is assumed.

Here ID permits insertions and deletions only. It equals the total length
minus twice the largest increasing equal-symbol matching. Each \(V_H\) is a
uniform average over the **entire** state group.

## 1. Construction and cheap steps

At level zero, the group for period \(n_j\) is \(\mathbb Z/n_j\), its
distinguished element is \(1\), and its word is the single state symbol.
List all nonzero steps with budget \(2\). The three claims hold; in fact
the initial separation is \(2\), so using \(a_0=1\) is conservative.

For a distinguished component, put it first in an enumeration of the pool.
At level \(s\) take the product of the preceding-level groups. The new
distinguished element acts in the first factor only. In row \(i\), for
\(0\le i<L\), place \(c\) separately tagged copies of
\(W_1(z_1+i v_1)\), then one separately tagged copy of each
\(W_j(z_j+i v_j)\), \(2\le j\le b\). Each tag is fixed across all rows
and disjoint from all other slot alphabets. If \(m=N_{s-1}\), this
payload has length \(Cm\). Append \(g_s m\) copies of a new symbol.
All lower-level markers are inside their slot tags and are not this new
symbol. This proves the claimed length and alphabet bound.

The simultaneous step \(\tau=(v_1,\ldots,v_b)\) has budget \(2/L\):
deleting the first complete row and inserting the last complete row
realizes the shift. A step in component \(j\), with preceding budget \(r\),
is lifted with budget
\[
 \omega_j r,\qquad \omega_j=c_j/(C+g_s),\quad
 c_1=c,\quad c_j=1\ (j>1).
 \tag{2}
\]
Edit each affected slot separately at its translated state. There are
\(Lc_j\) such slots, so the cost is at most
\(Lc_jmr=N_s\omega_jr\). These arguments are pointwise.

## 2. Arbitrary matchings of marked payloads

Suppose there are \(T\) payloads of length \(p\) on each side, separated
and followed by markers of length \(q>0\). The marker symbol occurs in no
payload. Suppose **every** source-target payload pair has one-sided
matching deficit at least \(d\ge0\). Necessarily \(d\le p\).

Fix any increasing equal-symbol matching. Write \(E\) for its unmatched
count on either side, and let \(s\) count source payloads whose matches
reach two or more target payloads.

Each of the other \(T-s\) source payloads loses at least \(d\) positions.
This includes a source payload with no matches. Thus
\[
 E\ge d(T-s). \tag{3}
\]
For a split source payload, select two of its matches in different target
payloads, and select any complete target marker between them. Every
position of this marker is unmatched. Indeed, a partner of such a target
position would have to lie strictly between the two source partners,
inside a payload containing no marker symbol. Different source payloads
have strictly ordered, disjoint target matched spans. Consequently their
selected markers are distinct, and
\[
 E\ge sq. \tag{4}
\]
This proves the assertion even for a nonoptimal matching and even when
several source payloads use the same target payload. Multiply (3) by
\(q\), (4) by \(d\), and add:
\[
 (d+q)E\ge Tdq,\qquad
 \operatorname{ID}(X,Y)\ge\frac{2Tdq}{d+q}. \tag{5}
\]
This is the manuscript's marked-payload lemma with its unrounded bound.

## 3. Row comparison and separation

Compare row \(i\) at \(z\) with row \(i'\) at \(z+uv\);
write \(\delta=i'-i\). The relative component shifts are
\(\delta+u\) in component 1 and \(\delta\) in every other component.
If \(n_1\nmid\delta+u\), all \(c\) distinguished slots are separated.
Otherwise \(0<|\delta|<L\) and \(n_1\nmid\delta\), since
\(0<u<n_1\). At most \(t-1\) other periods divide \(\delta\):
if \(t\) did, their product would divide the nonzero integer \(\delta\)
by pairwise coprimality, but would be at least \(L>|\delta|\).
Thus at least \(b-t\) other slots are separated. In either case there
are at least \(\mu\) separated slots.

Disjoint slot tags imply that any payload matching restricts to a
matching of the corresponding complete lower-level slot words. Its
one-sided deficit is therefore at least
\[
 d=m\mu a_{s-1}/2.
 \tag{6}
\]
This uses the induction hypothesis at arbitrary translated states and
every nonzero multiple of each distinguished element, not merely at
the zero state. There is no assumption about the matching outside this
pair of payloads. Inductively \(0<a_s\le1\): writing
\(x=\mu a_{s-1}\le C\), the denominator of \(a_s\) minus its numerator
is \(g_s(2C-x)+2g_s^2+xC\ge0\). Thus \(d\le Cm\).

Apply (5) with \(T=L\), \(p=Cm\), \(q=g_s m\), and divide by
\(N_s=L(C+g_s)m\). The result is exactly \(a_s\) in (1). This proves
the pointwise separation for all increasing matchings, at every depth.

## 4. A Fourier-free averaged displacement inequality

We prove the stronger analytic estimate
\[
 V_H(uv_1)\le
 \tfrac12 R^{2(h-1)}V_H(\tau)
 +\frac2h\sum_{j=1}^b\mathbb E_{a\in\mathbb Z/n_j}V_H(av_j).
 \tag{7}
\]
It holds for pairwise coprime periods, not only primes, and arbitrary
finite abelian factors.

First consider a real Boolean function \(F\) on
\(T=\prod_j\mathbb Z/n_j\). Use the finite real Hilbert space with
\(\|F\|_2^2=\mathbb E_x F(x)^2\). Let \(P_j\) average coordinate \(j\).
Direct summation shows that the \(P_j\) are commuting self-adjoint
idempotents. Thus
\[
 F=\sum_{S\subseteq[b]}F_S,\qquad
 F_S=\prod_{j\in S}(I-P_j)\prod_{j\notin S}P_jF
 \tag{8}
\]
is an orthogonal decomposition: for two different subsets, some
coordinate contributes the orthogonal factors \(P_j\) and \(I-P_j\).
Every coordinate translation commutes with these projections, so
orthogonality also holds after any displacement.

For \(f=F_S\), a coordinate outside \(S\) has zero displacement; in a
coordinate \(j\in S\), expansion of the square and \(P_j f=0\) give
\[
 \mathbb E_a\|f(\,\cdot+ae_j)-f\|_2^2=2\|f\|_2^2.
 \tag{9}
\]
Also \(\|f(\,\cdot+ue_1)-f\|_2^2\le4\|f\|_2^2\).
If \(|S|\ge h\), the component term in (7) alone pays this cost.

If \(0<r=|S|<h\), set \(q=\prod_{j\in S}n_j\) and let \(U\) shift
all coordinates by one. On this subspace \(U^q=I\) and
\[
 \frac1q\sum_{a=0}^{q-1}U^a f=0. \tag{10}
\]
For completeness, the Chinese-remainder map
\(\mathbb Z/q\to\prod_{j\in S}\mathbb Z/n_j\) is injective because
a difference divisible by every pairwise coprime period is divisible by
their product; the two finite sets have cardinality \(q\), so it is a
bijection. Averaging the orbit is therefore the product of the
coordinate averages, which kills \(f\).

Expansion of the square in (10), using that \(U\) is an isometry, gives
\[
 \frac1q\sum_a\|U^af-f\|_2^2=2\|f\|_2^2.
 \tag{11}
\]
For each residue \(a\), choose a signed representative with absolute
value \(d_a\le q/2\). Telescoping along that many unit steps and
Cauchy--Schwarz give
\[
 \|U^af-f\|_2^2\le d_a^2\|Uf-f\|_2^2
 \le(q^2/4)\|Uf-f\|_2^2.
 \tag{12}
\]
Negative steps have the same norm as positive steps. Equations
(11)-(12) imply
\[
 \|f(\,\cdot+ue_1)-f\|_2^2
 \le(q^2/2)\|Uf-f\|_2^2
 \le\tfrac12R^{2(h-1)}\|Uf-f\|_2^2.
 \tag{13}
\]
The empty subset is constant and costs zero. Summing (9) or (13)
over the orthogonal decomposition proves (7) for Boolean functions,
because squared difference equals absolute difference for Boolean values.
The low-support case is empty when \(h=1\).

The only vector inequalities just used are elementary finite identities.
For \(d>0\) vectors,
\[
 d\sum_i\|w_i\|_2^2-\left\|\sum_iw_i\right\|_2^2
   =\sum_{i<j}\|w_i-w_j\|_2^2\ge0.
\]
This proves the telescoping estimate in (12); the zero-step case is zero.
Likewise
\(2\|x\|_2^2+2\|y\|_2^2-\|x-y\|_2^2=\|x+y\|_2^2\ge0\)
proves the bound \(4\|f\|_2^2\) for any isometric displacement.

Here is the complete passage to real sequence-space \(\ell_1\).
For a finite set \(X\) and \(H:X\to\ell_1\), sort the distinct values of
each real coordinate. Consecutive gaps express its absolute differences
as nonnegative sums of cut differences. Group by the finitely many
nonempty proper subsets \(A\subset X\), obtaining coefficients \(c_A\).
These coefficients are finite: summing the identities over unordered
pairs yields
\[
 \sum_A c_A |A||X\setminus A|
 =\sum_{\{x,y\}}\|H(x)-H(y)\|_1<\infty.
 \tag{14}
\]
All interchanges are of nonnegative series; each indexed cut separates
at least one pair. This proves
\(\|H(x)-H(y)\|_1=\sum_Ac_A|1_A(x)-1_A(y)|\).
For general factor groups, restrict each cut to a coset of
\(\prod_j\langle v_j\rangle\), apply the Boolean result there, average
over the equal-size cosets, then sum the nonnegative cut weights.
This proves (7) with no finite-dimensional-target restriction.

## 5. All averaged budgets at once

Fix a component \(j\) and let \(Y_j\) be the product of the other state
groups. For an arbitrary budget-feasible \(H\), define
\[
 T_j(x)=\frac{1}{\omega_j|Y_j|}
          \bigoplus_{y\in Y_j}H(x,y).
 \tag{15}
\]
This finite direct sum is again real sequence-space \(\ell_1\).
Direct expansion of its norm gives, for **every** component step \(e\),
\[
 V_{T_j}(e)=\frac{V_H(\widetilde e)}{\omega_j}. \tag{16}
\]
Consequently the same map \(T_j\) satisfies all preceding-level budgets
simultaneously. The induction hypothesis gives
\(V_H(av_j)\le\omega_jB_{s-1}\) for all residues \(a\), including
zero. Apply (7), the simultaneous budget \(2/L\), and
\(\sum_j\omega_j=C/(C+g_s)\). The result is precisely the recurrence
for \(B_s\) in (1). This completes the simultaneous induction.

## 6. Exact specialization to the manuscript

For any positive integer \(k\) with the specified prime pool, set
\(b=100k\), \(P=b^2\), \(R=2P\), \(t=b/2\), \(L=P^t\),
\(c=b\), \(C=2b-1\), \(g_s=C\), and \(h=b/10\). Distinct primes
are pairwise coprime, and every \(t\)-period product is at least \(P^t\).
Thus the words and cheap-step lists just defined are the manuscript's
words and lists, up to names of tags and the chosen pool enumeration.
In particular \(N_s=(2(2b-1)L)^s\).

Here \(\mu=b/2\), and the separation recurrence becomes
\[
 a_s=\frac{\mu a_{s-1}}{2C+\mu a_{s-1}},\qquad
 a_0=1,\qquad
 a_s\ge9^{-s}>24^{-s}\quad(s>0). \tag{17}
\]
Indeed \(a_{s-1}\le1\) and \(1+2C/\mu=9-4/b<9\).
Equivalently, if \(\kappa=8-4/b\), then
\(a_s^{-1}=\kappa^s+(\kappa^s-1)/(\kappa-1)\).
The improved analytic recurrence is
\[
 B_0=2,\qquad
 B_s=\frac{(2P)^{2h-2}}{L}+\frac{B_{s-1}}h. \tag{18}
\]
It is termwise no larger than the manuscript's \(Q_s\). Equations
(17)-(18), together with the unchanged cheap-step construction, imply
all three assertions of `prop:family`, for every finite depth and every
admissible specified pool.

This result does not certify the binary code, the external upper-bound
theorem, or existence of enough primes for every sufficiently large
\(k\). None is needed for the live, conditional-on-the-pool proposition.
The finite experiments are additional adversarial checks, not proofs
of these unbounded statements. Novelty and publishable significance,
including the stronger constants and Fourier-free reduction, require
independent Reviewer assessment; no such approval is asserted here.

## 7. Scope of the literature comparison

A targeted lookup returned Jiao--Luo--Zanin--Zhou,
[arXiv:2609.15768v1, Theorem 1.3](https://arxiv.org/html/2609.15768v1).
The primary statement concerns a random-sign convolution inequality on
\((\mathbb Z/m)^n\), with \(1<p<\infty\) and local operators
\((T_j+T_j^{-1})/2\). These are not the full-coordinate averaging
projections used in (8), and that statement is not the coprime-period,
single-coordinate displacement inequality (7). It is related background,
not an assumption in this proof or an established exact predecessor.
The same secondary search supplied arXiv:1504.06622 as an edit-distance
reference; opening its primary record instead found an unrelated
stationary-point homotopy paper, so that suggested reference was rejected.
This limited comparison does not establish novelty or exhaust prior work.
