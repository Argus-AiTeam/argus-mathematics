# A support-only, two-layer denominator theorem

## Result and scope

The two odd-prime inequalities `eq:odd-lower-pair-range` and
`eq:odd-two-layer-bound` follow from the rational moment recurrences and
the stated row supports. Below is a universal proof, not an extrapolation
from the numerical tests. In fact neither the Chebyshev design nor Taylor
contact is needed for this arithmetic theorem: arbitrary locally integral
polynomial rows with the same support restrictions work.

No false manuscript assertion was found in the audited digit, central, or
local-elimination arguments. In particular this report is **not** a
refutation of the manuscript and says nothing unconditional about the
rationality of Catalan's constant. The analytic identification of the
rational-entry formula with the original integrals, the prime-two bound,
nonvanishing, and the real-place estimate remain separate open audit nodes.
Independent Reviewer approval and any publication/novelty assessment are
pending; they are not supplied by this Engineer report.

The primary source is the staged version
`Catalans-constant-is-irrational-September-24-2026/build/sections/`:
`foundations.tex`, equations `eq:moment-values`,
`eq:boundary-recurrences`, `eq:rational-starts`, `eq:diagonal-reduction`,
`eq:negative-boundary`, `eq:rational-z`, and `eq:rational-raw-entry`;
and `odd-primes.tex`, Lemmas `lem:odd-digit-reductions`,
`lem:odd-central-layer`, and `lem:odd-local-elimination`. These local
primary sources were available and read. No outside theorem is invoked
without proof in the arithmetic argument below.

## Universal theorem

Let p be an odd prime, H,L,A,b,n integers with

\[
 0\le b\le A<L\le H,\qquad 1\le n\le L-b,\qquad p^2>4H,
 \qquad p\le H.
\]

Put q=L-b-n, and let O be the subring of p-integral rational numbers.
Use exactly the rational arrays M0,Z0 defined by the cited rational
starts and recurrences, with M0(-1,j)=kplus(j+1).
For any gamma in O and any n pairs of polynomials P_r,D_r in O[t] with

\[
 \operatorname{supp}P_r\subseteq[A,H-1],\qquad
 \operatorname{supp}D_r\subseteq[A+1,H-1],
\]

define an n by (L-b) matrix T, with column indices b<=j<L, by

\[
 T_{rj}=\sum_i P_{ri}\{M0(i,j)+4\gamma c_{(i-j)/2}\}
           -\frac32\sum_iD_{ri}Z0(i,j).
\tag{1}
\]

Here c_l=binom(2l,l)/4^l for nonnegative integers l, and c_l=0 otherwise.
Let Delta be any full minor of T, or det(TB) for any
(L-b) by n matrix B over O. Then:

* If p<=H/2, put
  d0=(min(p,L-p,A)-max(b,H-2p))_+. One has
  v_p(Delta)>=-2n+(d0-q)_+.
* If p>H/2 and p>b, put K=L-p, J=H-p, and
  \[
  R=K_++(K-A)_++(J-\max(b,K))_+,\qquad
  S=(\min(A,K)-b)_++(\min(b,J)-\max(0,K))_+ .
  \]
  Then v_p(Delta)>=-min(2n,n+R,2R+S).

The convention is v_p(0)=infinity. Thus the statements include singular
matrices. They require no rank or independence assumption on the rows.

This generalizes the fixed manuscript ratios and the prescribed integer
filter to arbitrary admissible supports, locally integral rows, and locally
integral filters. Substituting an arbitrary gamma here constructs an
algebraic family; it does not identify a different gamma with actual G.

## 1. Exact recurrence solutions and carry calculation

Write H_z=c_(z/2) for even z>=0 and
H_z=1/(z c_((z-1)/2)) for odd z>=1. Direct division of the boundary
recurrences by H_z, using H_(z+2)/H_z=(z+1)/(z+2), gives

\[
\begin{split}
 kminus(u)&=H_u\sum_{1\le z\le u,\ z\ {\rm even}}
                     2/(z^2H_z^2) &&(u\ {\rm even}),\\
 kminus(u)&=H_u\sum_{1\le z\le u,\ z\ {\rm odd}}2/z
                                                   &&(u\ {\rm odd}),\\
 kplus(u+1)&=H_u\sum_{1\le z\le u,\ z\equiv u\ (2)}
                     2/(z^2H_z).
\end{split}\tag{2}
\]

For completeness the initial terms are kminus(0)=0, kminus(1)=2,
kplus(1)=0, kplus(2)=2. The increments after division are respectively
2/(z^2H_z^2), 2/z, and 2/(z^2H_z); these establish (2) by induction.
Also m_(z-1)=2H_z for odd z and is zero for positive even z; m_(-1)=0.

Let epsilon=(-1)^((p-1)/2) and
E(t)=(1-t^2)^((p-1)/2) in F_p[t], extended by E_d=0 outside [0,p-1].
The product expression for its even coefficients gives

\[
 E_{2k}=c_k\pmod p,\qquad
 E_{p-1-d}=\epsilon E_d.                                      \tag{3}
\]

Indeed (-1)^k binom((p-1)/2,k) reduces to the product
prod_(j=1)^k (2j-1)/(2j)=c_k. Reversing the binomial polynomial proves
the second identity.

For z=Pp+r<H, 0<=r<p, all reduced-index factors H_P are units:
P<H/p<p/4. The identity (1+x)^p=1+x^p in F_p[x] proves the
two-digit binomial coefficient rule by multiplying
(1+x^p)^P(1+x)^r and comparing coefficients. Applying it to the
central binomial coefficients gives the following exhaustive cases.

* For even z and even r, P is even and H_z=E_r H_P modulo p.
  Powers of 4 reduce correctly since 4^p=4 in F_p.
* For even z and odd r, P is odd and v_p(H_z)=1. The factorial-floor
  difference for binom(z,z/2) at p is 1 and at p^2 is 0.
  Consequently, for positive even z, v_p(z H_z) is 1 exactly when
  r=0 or r is odd, and otherwise is 0.
* For odd z, 1/H_z is in O. If r is odd, z and
  c_((z-1)/2) are units, so pH_z=0 modulo p. If r is even, P is odd.
  The two-digit rule at z=Pp gives pH_(Pp)=epsilon H_P modulo p.
  Advancing by even r with H_(z+2)/H_z=(z+1)/(z+2), whose denominators
  are units through r=p-1, gives pH_z=epsilon E_r H_P modulo p.

There are no higher carries: z<H<p^2/4, and all high digits in this
calculation are less than p/4. These facts also prove every integrality
assertion just used. Together with (3), the cases yield

\[
 p m_{z-1}=E_{p-1-r}m_{P-1}\pmod p.                           \tag{4}
\]

At z=0 both sides are zero by definition. Thus (4) includes that
boundary without assigning an analytic meaning to a negative moment.

## 2. Starting arrays: the complete blocks matter

We prove, rather than assume, the starting reductions

\[
 p^2kminus(Pp+r)=E_{p-1-r}kminus(P),\qquad
 p^2kplus(Pp+r+1)=E_r kplus(P+1)\pmod p.                     \tag{5}
\]

For odd u=Pp+r, the first expression in (5) is
(pH_u) sum_(odd z<=u) 2p/z. All summands are integral and only
z=mp survives. If r is odd the prefactor vanishes; otherwise P is
odd and the preceding carry formula gives
epsilon E_r H_P sum_(odd m<=P)2/m, as required by (3).

For even u, p^2kminus(u)=H_u sum_(even z<=u)2W_z^2 with
W_z=p/(zH_z) integral. If r is odd, H_u vanishes modulo p.
If r is even, P is even. The nonzero W_z form exactly the complete
blocks z=mp-2j, m=2,4,...,P and j=0,...,(p-1)/2.
An even z with odd low digit lies just below the next even multiple
of p; a positive even multiple itself is the j=0 endpoint.
No incomplete block occurs when the upper limit has even low digit.
Starting at mp and descending, W_(z-2)/W_z=(z-1)/(z-2) gives

\[
 W_{mp-2j}=c_j/(mH_m)\pmod p.
\]

The coefficient of x^s in (1+x)^s(1+x)^s, s=(p-1)/2, proves

\[
 \sum_{j=0}^s c_j^2
 =\sum_{j=0}^s\binom{s}{j}^2
 =\binom{p-1}{s}=(-1)^s=\epsilon\pmod p.
\]

Multiplying the resulting block sum by E_r H_P proves (5) for even u.
When P=0 the block set and the reduced sum are both empty.

For kplus, when u is even use
H_u sum_(even z<=u) 2p^2/(z^2H_z). Every nonmultiple of p vanishes:
v_p(H_z)<=1. At z=mp, H_(mp)=H_m modulo p and m is even.
When r is odd, H_u itself supplies the additional p; otherwise the
remaining sum is E_r kplus(P+1). For odd u instead use
(pH_u) sum_(odd z<=u)2p/(z^2H_z).
The summands are integral, all nonmultiples vanish, and the multiples
have residue 2/(m^2 epsilon H_m). The two epsilon factors cancel.
This proves (5), including local integrality, in every parity case.

## 3. Digit reductions with the negative boundary

Let ell=j mod p, d=(j-i-1) mod p,
i'=(i+1+d-ell)/p-1, and j'=floor(j/p).
Since i'=floor((i-ell)/p), i'>=-1.

For i>=j write i-j=Pp+r. Diagonal reduction is
kminus(i-j)-sum_(k=1)^j m_(i-j+k-1)/k.
After multiplication by p^2 every term with p not dividing k vanishes
by (4). For k=mp its residue is E_(p-1-r)m_(P+m-1)/m.
Using (5) gives E_d M0(j'+P,j'), the required reduced entry.

For i<j write j-i-1=Pp+r. The reduction is
kplus(Pp+r+1)-sum_(k=Pp+r+2)^j m_(k-Pp-r-2)/k.
At k=mp the moment index plus one is
(m-P-1)p+(p-1-r); hence (4) gives E_r m_(m-P-2)/m.
The possible first multiple m=P+1 contributes m_(-1)=0.
The remaining sum starts at P+2, exactly the reduced diagonal formula
with i'=j'-P-1. If i'=-1 then j'=P, the sum is empty, and the
remaining starting value is kplus(j'+1)=M0(-1,j').

All reduced arrays here are integral: their indices are bounded by
H/p<p/4 (with the stated +1 boundary for kplus), so the explicit
formulas have no denominator factor p. We have therefore proved the
M0 congruence and integrality in `eq:digit-layers`, without assuming it.

For harmonic sums, removing nonmultiples of p gives
p B_i^(1)=B_floor(i/p)^(1) and p^2 B_i^(2)=B_floor(i/p)^(2)
modulo p; i<p^2 makes all reduced denominators units.
The diagonal Z0 formula follows immediately. Off the diagonal,
different low digits make i-j a unit and the scaled residue zero;
equal low digits give i-j=p(I-J) with nonzero |I-J|<p.
Substituting the first harmonic congruence gives precisely Z0(I,J).
This proves the second digit reduction and its integrality.

## 4. Leading residues and the lower-range bound

For each 0<=ell<p form vectors
P'_u=[t^((u+1)p+ell)]tP E for u>=-1 and
D'_u=[t^(up+ell)]D for u>=0. The just-proved reductions imply

\[
 p^2F_{kp+\ell}\bmod p
 =\sum_{u\ge-1}P'_uM0(u,k)-\frac32\sum_{u\ge0}D'_uZ0(u,k). \tag{6}
\]

The gamma term is integral, since every c_l has only a power of two
in its denominator. Thus every raw entry is in p^(-2)O.

If ell>=H-2p, degrees force P'_u=D'_u=0 for u>1.
The rational starts give M0(u,0)=(0,0,2) and
M0(u,1)=(2,0,-2) for u=(-1,0,1).
Likewise Z0(u,0)=(0,1), Z0(u,1)=(1,-1) for u=(0,1).
Consequently, setting V_ell=2P'_1-3D'_1/2 and
U_ell=2P'_-1-3D'_0/2, (6) becomes

\[
 p^2F_\ell=V_\ell,\qquad
 p^2F_{p+\ell}=U_\ell-V_\ell\pmod p.                       \tag{7}
\]

The support assumptions give U_ell=0 for ell<=A, including equality.
For max(b,H-2p)<=ell<min(p,L-p,A), both columns exist and their
sum belongs to p^(-1)O^n. Replacing the high column by this sum is
an invertible integral shear. The d0 pairs are disjoint.
Deleting q columns from an (n+q)-column pool leaves at least
(d0-q)_+ of the improved columns. Every selected determinant therefore
has denominator loss at most 2n-(d0-q)_+. This proves the first bound.
Here d0<=n+q, so (d0-q)_+<=n and the stated loss exponent is
nonnegative. The local subring contains p, and p^D det in that
subring is equivalent, by numerator and denominator divisibility,
to v_p(det)>=-D. These verify the corresponding arithmetic
hypotheses of the formal determinant-integrality lemmas.
The optional pair ell=A is deliberately not counted; omitting it
cannot invalidate the conservative manuscript inequality.

## 5. Central residues proved directly

Now p>H/2, p>b, J=H-p, K=L-p, so 0<=J<p and K<=J.
A central column has max(b,J)<=j<min(p,L).
For every 0<=i<H, both |i-j|<p and 1<=j-ell<p for ell<min(i,j).
The diagonal starting value is therefore integral. The remaining
sum can in both diagonal cases be written as

\[
 -\sum_{0\le\ell<\min(i,j)}
               m_{i-\ell-1}/(j-\ell).
\]

After multiplication by p, (4) is nonzero only for
p<=i-ell<2p, giving 2E_(2p+ell-1-i).
Such ell satisfy ell<J<=j; hence collecting coefficients introduces
no truncated or extra nonzero terms. It follows that
pM0(P,j)=-sum_(ell<J)2P'_1/(j-ell).

For Z0, j<p and B_j has no pole. A pole in B_i occurs exactly for
i=p+ell with 0<=ell<J. Then i-j is a unit (j>=J>ell), and
pZ0(p+ell,j)=1/(ell-j). All other Z0 entries are integral.
Combining the two contributions proves, including integrality,

\[
 pF_j=-\sum_{0\le\ell<J}V_\ell/(j-\ell)\pmod p.             \tag{8}
\]

This is the central-layer formula, derived from the exact recurrences
and harmonic formulas rather than used as a hypothesis.

## 6. Integral elimination without losing the second coefficients

First dispose of a boundary possible in the generalized parameters but not
in the fixed manuscript ratios: if L<=J, then L<=J<p, K<0, and
R=J-b>=L-b>=n. The asserted minimum is consequently 2n, already
proved by raw-entry integrality in Section 4. There are no central
columns and no need to choose representatives of nonexistent raw
columns. In the rest of this section assume J<L.

The noncentral columns are the high F_(p+ell), 0<=ell<K, and
the low F_ell, b<=ell<J. Pair the B=(min(A,K)-b)_+ indices
b<=ell<min(A,K), retaining each low column and replacing its high
column by the sum. All remaining noncentral columns are retained as
possible p^(-2) columns. Their number is

\[
 R_0=K_++(J-b)_+-B=R.                                    \tag{9}
\]

Splitting K into K<=0, 0<K<=b, b<K<=A, and K>A gives respectively
(J-b)_+, K+(J-b)_+, J, and K+J-A on both sides.
The integer identity is also kernel-checked by `retained_count`.

The retained low columns represent V_ell for b<=ell<J.
The unpaired high columns represent -V_ell for 0<=ell<min(b,K),
because these ell are <b<=A. The only possibly unrepresented indices are

\[
 {\cal E}=[\max(0,K),\min(b,J)),\qquad
 e=|{\cal E}|=(\min(b,J)-\max(0,K))_+ .
\]

For each represented ell choose a retained Y_ell with
p^2Y_ell=sign_ell V_ell mod p, sign_ell=+1 or -1. In every
central column make the integral shear

\[
 C_j=F_j+p\sum_{\ell<J,\ \ell\notin{\cal E}}
             \frac{\operatorname{sign}_\ell}{j-\ell}Y_\ell .
\tag{10}
\]

All displayed coefficients lie in O, and the inverse changes the
signs of the additions while leaving the retained columns unchanged.
Equations (8) and (10) imply

\[
 pC_j=-\sum_{\ell\in{\cal E}}V_\ell/(j-\ell)\pmod p.
\tag{11}
\]

Crucially no information about the next coefficient of Y_ell is used.
The exact identity
p(p^(-2)y0+p^(-1)y1+y2)=p^(-1)y0+y1+py2
shows why: y1 becomes integral, rather than being assumed zero.
`scaled_shear`, `central_residue`, and `secondary_terms` formalize
these exact cancellations.

The coefficient vectors (1/(j-ell))_(ell in E) of (11) lie in F_p^e.
Choose a column basis of their finite matrix by elementary Gaussian
elimination: each pivot adds an independent vector and consumes a
different row, so there are d<=e pivots. For each nonpivot subtract
its linear combination of the pivot columns. Lift the finitely many
coefficients to integers in O. Permutations and these column subtractions
have integral inverses. The nonpivot pC_j residues are zero and
C_j was already in p^(-1)O^n, so those columns are now integral.
At most d central columns still have denominator p.

The final pool thus has R possible p^2-denominator columns, at most
B+d<=B+e=S other p-denominator columns, and integral remaining
columns. A selected full minor with r,s columns of the first two
types has loss 2r+s, where r+s<=n, r<=R, s<=S. Therefore

\[
 2r+s\le2n,\qquad2r+s\le n+R,\qquad2r+s\le2R+S.
\]

`loss_cap` proves these inequalities for all natural parameters.
`weighted_det` and `bounded_denominator` prove that the corresponding
column-weight bound gives p^D det in the local subring, with no
nonsingularity hypothesis.

Finally every operation used belongs to GL_(L-b)(O). Expanding the
determinants of T=(TQ)Q^(-1) by multilinearity expresses each original
full minor as an O-linear combination of full minors of TQ.
The same expansion for TB transfers the bound to every integral
filter B. This is the Cauchy--Binet identity, and in this application
it is just the finite determinant expansion; there is no analytic
or rank hypothesis. The universal theorem is proved.

## Specialization, endpoints, and evidence

For the manuscript, n=48N,b=7N,A=19N,L=59N,H=65N,q=4N.
The Chebyshev recurrences give integral coefficients. If d=|r-4N|,
then d<=44N-1. Thus the least possible P degree is
63N-1-(44N-1)=19N and the least D degree is at least 19N+1;
both maximum degrees are 63N-1+2N=65N-1. These verify all the
support hypotheses separately. In the upper range p>H/2>b.
For every N>=1, H>=65>16 makes this range also satisfy p^2>4H.
The prescribed filter has integer binomial coefficients.
Taking gamma=G when G is rational and p-integral proves both
requested arithmetic inequalities for every admissible prime.

The proof includes i'=-1, zero reduced starts, carry boundaries,
the conservative and optional paired endpoints, K<=0, J<=b,
empty central sets, and all secondary denominator terms.
If L<=p in the fixed manuscript parameters, J<=H-L=6N<b:
there are no noncentral columns, R=0, S=J. This last simplification
uses the fixed ratios; it was not silently imposed on the general theorem.

`verify.py` independently constructs the rational arrays from their
recurrences, not from the disputed reductions. The bounded replay at
N=1,2 tested 439400 (i,j,p,N) digit cases, 218010 scalar central cases,
and 20111 full rational secondary-term shears. It also checked the
optional ell=A pairs, the negative reduced index, K<=0 and J<=b.
Those finite checks found no witness; they are supporting tests, not
the proof of the theorem.

Jacobian 0.14.0, protocol 2025-11-25, successfully executed
`combinatorics.recurrence.p_recursive.evaluate` for the first 33 terms
of (2k+1)a_k-2k a_(k-1)=0, a_0=2.
The exact payload, inspected contract, and typed output are stored
separately. The replay verifies every output against the closed form.
That operation exactly matches this atomic recurrence calculation,
but its typed contract has no universal quantifier, modular reduction,
or column-elimination conclusion. No finite Jacobian answer is being
represented as a proof of (4), (5), (8), or the universal theorem.

`Main.lean` and its separate statement-fidelity document certify the
decisive algebraic identities and determinant-integrality transfer.
The prescribed `lean_evidence verify --claim C_ODD_CORE` run succeeded
with Lean 4.31.0, exit_code=0 and proof_holes=[]; its source-bound archive
is `certificates/C_ODD_CORE-bae38c384ecd4b48.json`.
Its exact scope is narrower than the prose arithmetic theorem, as
stated in `statement_fidelity.md`. The ledger has mechanical evidence
only for that algebraic core, not for the full prose arithmetic proof.

From the campaign root, the standalone exact replay is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/odd-prime-bound/verify.py
```

To recompile the core through the authorized evidence path:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/odd-prime-bound/Main.lean --statement-fidelity research/odd-prime-bound/statement_fidelity.md --claim C_ODD_CORE --project-root .
```

The replay checks the archived compiler result against the current source,
fidelity document, and claim version; it does not pretend that reading a
certificate launches another compiler run.

Compared with the initial campaign ledger (which had no arithmetic
evidence), this supplies a complete support-only arithmetic proof
and an independently replayable exact test suite. Compared with the
manuscript statement, it removes the special row design and fixed
parameter ratios from the local arithmetic conclusion; it does not
claim a new irrationality proof or a verified novelty determination.
