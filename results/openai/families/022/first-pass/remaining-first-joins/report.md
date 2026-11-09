# A quantitative completion of the remaining first-join estimate

## Result and scope

**Theorem (`C_RFJ_QUANT`).** For the retained centres, good masks, preliminary
cell tests, and admissible finite histories in [the staged manuscript][joins],
both remaining counts in Proposition `join:remaining-first-joins` satisfy

\[
 Q_{\rm broad}+Q_{\rm narrow}\ll_{k_0} W^{201/200}.                 \tag{1}
\]

Here the broad distance constant is fixed. The implicit constant is independent
of the block, its position in the tail, the matching history, and \(N_0\).
In particular, the stated broad \(O(1)\) and narrow
\(O(W)+O_{k_0}(W^{1+c})\) bounds hold, with \(c=1/200\).
The improvement is that the oriented mixed roundoff is \(O(W^2)\), not merely
\(O(W)\): the smaller-band centre count retains a factor of total mass.
This strengthening concerns **remaining** comparisons, not the simultaneous
birth comparisons excluded by the proposition.

This is an analytic proof with exact local symbolic certificates, not a new
Lean proof or a finite-exhaustion argument. Independent Reviewer acceptance of
this theorem is still required. No manuscript refutation, proof of the main
conjecture, or verified publication novelty is asserted.

The previously reviewed `C_BC` v2 is reused unchanged. Its independent support is
`judgement-C_BC-4e16cb0094e9` by `reviewer:dd87d9144737`, bound to
`research/backward-charge/certificates/C_BC-a0a4835af61d31ec.json`.
Nothing here rewrites or recompiles that source. In particular we use its
actual-prefix expansion, reciprocal later-omission factors, column capacities,
preservation of either outer currency, and unique first-sharing epoch.

### Source map

| Issue | Staged source |
|---|---|
| Exact target and three terminal types | [joins.tex][joins], `join:remaining-first-joins`, `join:backward-decomposition` |
| Low fields and their period | [tables.tex][tables], `eq:core-loss`, `tab:intermediate-fields` |
| Remaining fields, main terms, roundoffs | [joins.tex][joins], `join:endpoint-count`, `join:linked-main`, `eq:no-link-roundoff`, `eq:linked-roundoff` |
| Mask hypotheses | [prescriptions.tex][prescriptions], `pre:good-masks` |
| Centre scales and exterior separation | [centres.tex][centres], `cen:assignment-cost`, `eq:centre-lower`, `eq:exterior-gain` |
| Arithmetic averaging and tensor interface | [preliminaries.tex][preliminaries], `ar:cycle`, `ar:pivot`, `ar:tensor` |
| Parameter order | [centres.tex][centres], `cen:hierarchy` |

The argument below reconstructs the needed one-sided field, centre, and tensor
interfaces. It does not import their counting conclusions as unexamined
assumptions.

## 1. Quantified data and the two reduction interfaces

Write \(b_i=B_i^*\), with \(B_i\le b_i<2B_i\). A centre object is a triple
\((L_i,r_i,b_i)\); at a fixed integer shell there is at most one object for
\((L_i,r_i)\). Its original assigned family has

\[
 k_i=L_ir_i,\qquad
 \delta_i=\sum_{v\ {\rm assigned}}\phi(v)/L_i,\qquad m_i=k_i\delta_i,
 \qquad \sum_i m_i\le W\le1.                                    \tag{2}
\]

These are **original assigned masses**, not the surviving adaptive weights.
The retention rule and the assignment cost give

\[
 \delta_i\ge e^{-8b_i/25},\qquad
 k_i\ge e^{-b_i-1},\qquad
 m_i\ge e^{-1}e^{-33b_i/25},\qquad
 \delta_i^{-1}\le e^{16B_i/25}.                                 \tag{3}
\]

For completeness, put \(z=\log k=-b+a+c\) in the source assignment formula,
and \(F(c)=10c_++(-c)_+\). Its cost is \(b+10a+F(c)<b_i+1\),
where \(b>0,a\ge0\). Both \(-z\) and \(10z\) are at most this cost.
This proves the scale bound used in (3). The density bound in (3) is exactly
the stipulated retention cutoff; no lower bound for updated table masses
has been substituted for it. The identity
\(\pi_L(d)=\phi(L/d)/L\) gives the assigned-mask probability \(\delta_i\).

Distinct retained bands are separated by a factor at most \(\theta\), which
can be made as small as required by the fixed colour separation.
The exterior alternative used below follows directly from cost minimization.
Use any source \((D_i,r_{0i})\) producing object \(i\) as a candidate for a row
\(v\) of object \(j\). Since \(D_i\mid L_i\) and \(F\) is subadditive, its cost
is at most

\[
 b_i+1+10\log\frac{v}{(v,L_i)}
       +10\log\frac{r_j}{r_{\min}}+\log^+\frac{r_i}{r_j}.          \tag{4}
\]

If both source alternatives failed, this would be at most
\(b_i+1+.85b_j<b_j\), for \(B_i/B_j\le\theta\), sufficiently small fixed
\(\theta\), and sufficiently large minimum shell. This contradicts the
minimum cost of \(v\). Thus every assigned row of the larger-band object
satisfies

\[
 \frac{v}{(v,L_i)}\frac{r_j}{r_{\min}}>e^{3b_j/200}
 \quad\hbox{or}\quad \log(r_i/r_j)>.7b_j.                        \tag{5}
\]

### First-sharing classification, including charged images

At a first join of height \(Y\), two old endpoints were in different components
at height \(Y/2\), so their log-ratio is \(>\beta Y/2\).
Two newborn endpoints not covered by the direct comparisons have
\(\log UT>\beta Y\). In the remaining case there is one old and one newborn
endpoint. If \(\log UT\le\beta Y/2\), they are adjacent at activation.

A high-type newborn has a dense bin at \(Y/2\). Its prime exponents agree
there with every neighbour: a discrepancy would cost at least
\(\exp(Y/2)>\beta Y\). Since one type was retained, any old high-type
neighbour would therefore have last dense height at least \(Y/2\), and start
at least \(Y\), a contradiction. Thus this nondistant case is medium type.

A medium newborn \(j\) has start at most \(2D_0B_j\), taking \(D_0\ge A_0\).
A larger retained band cannot be old if the colour separation exceeds
\(2D_0/A_0\). The same band cannot be old either: if the new start exceeds
\(A_0B_j\), its dense bin at half that start also occurs on the neighbour,
forcing that neighbour to start no earlier; otherwise the baseline start
already prevents an earlier start. Consequently
\(B_i/B_j\le\theta\).

For every bin at least \(\ell B_j\), exponent discrepancies cost more than
\(O(\beta D_0B_j)\), once the minimum band is large. Thus the exponents agree
through this range. A dense bin in it would be dense on the old centre,
contradicting \(Y_d(i)\le D_0B_i\), provided \(D_0\theta<\ell/2\).
There are no such dense bins. The new start is therefore \(Y=A_0B_j\).
Primes below \(\ell B_j\) have reciprocal sum \(O(\ell B_j)+O(1)\);
the later sparse bins on both centres have sum \(O(\kappa A_0B_j)\).
The choices in Section 6 give

\[
 \Sigma:=\sum_{\substack{p\mid L_iL_j\\\log\log p<Y}}\frac1p
       \le s_{\rm low}B_j.                                    \tag{6}
\]

Accordingly classify **each counted or charged pair** as distant if
\(\log UT>\beta Y/2\), and otherwise as mixed. A transported old endpoint
stays in its old child, while a newborn endpoint is static and unchanged.
`C_BC` preserves its first-sharing epoch. Hence this classification applies
to the image pair itself. An image of a mixed origin is not presumed still
to be nondistant; if it is distant it goes into the distant estimate.

### One-sided intermediate fields

Fix the actual history and the static anchors. At a full adaptive prime \(p\),
write the preweight as \(w\), the linked raw masses as \(m_\xi\), their
success indicators as \(I_\xi\), and \(u=w-\sum m_\xi\). The actual multiplier is

\[
 1-\sum_\xi(m_\xi/w)I_\xi-u/(pw).
\]

On a pre-\(p\) orbit the coefficients and positive-prefix condition transport
invariantly, and each indicator has mean \(1/p\). Thus this multiplier has
mean \(R_p=1-1/p\). Extend it by \(R_p\) on unavailable or zero-prefix orbits.
All earlier fields are invariant on this orbit. Later omissions are at
different primes and preserve it, so reverse averaging proves the product
mean for any selected subset. An adaptive omission leaves just the residual
scalar \(R_p\), when a positive power remains. A retained birth factor is
one forbidden residue, or its prescribed scalar, of the same mean.
Removing the other birth filters and all intervening discard fractions
enlarges the actual weight after anchor averaging.

The historical post-\(p\) core retains every unprocessed prime power.
Consequently the numerator period of fields through \(p\) has prime support
at most \(p\), divides the current denominator, and is at most
\(L_i/\mathrm{core}_p\le\exp(C_{\rm per}p)\).
Here the core estimate is uniform in \(N_0\): the spanning-tree log-cost is
at most \(\exp(h_*Y/10)\), and the losses at passed primes are bounded by
\(\sum_{l\le p}(4\log l+CX)\), with \(X=e^{2h_HY}\).
Splitting at \(e^{O(X)}\) bounds this by \(O(p)+e^{O(X)}=O(p)\).
The prime-log bound needed here follows, for example, by applying
\(\prod_{n<l\le2n}l\mid {2n\choose n}<4^n\) and summing dyadically.
The stipulated structural core symmetry, not a bound for the number of
matching labels or cells, is what controls this period.

Thus the necessary parts of `tab:intermediate-fields` follow from the
actual operation rules. Large rational model heights specify colours,
not the prime moduli of the retained hard exclusions.

## 2. Elementary uniform estimates

For \(p^\nu\parallel L\), the unrestricted deficit probabilities are

\[
 \Pr(a=j)=R_pp^{-j}\ (0\le j<\nu),\qquad \Pr(a=\nu)=p^{-\nu}.
\]

They sum to one and \(\Pr(a\ge1)=1/p\). Also

\[
 \frac{R_{\rm done}(L/d)}d=\pi_{\rm done}(d).                    \tag{7}
\]

The processed and outer coordinates have disjoint prime supports.
Dropping a mapped side's assignment restriction therefore leaves its
processed probability law unrestricted even at a fixed outer mask.

We only need an elementary prime-harmonic upper bound, not an asymptotic
prime number theorem. For \(x\ge e\), put \(s=1+1/\log x\). Finite Euler
products and \(\zeta(s)\le1+1/(s-1)\) give

\[
 \sum_{p\le x}\frac1p
 \le e\sum_{p\le x}p^{-s}
 \le e\log\zeta(s)
 \le e\log(1+\log x).
\]

The middle inequality follows by taking logarithms of
\(\prod_{p\le x}(1-p^{-s})^{-1}\le\sum_{n\ge1}n^{-s}\);
unique factorization and an integral comparison suffice.
In particular

\[
 \Sigma\le3(Y+1),\qquad
 \prod_{l\le p}R_l^{-1}\le e^{12Y_p+6}
       \quad(Y_p\le\log\log p<2Y_p),                            \tag{8}
\]

using \(-\log(1-1/l)\le2/l\).
For any fixed \(D,\delta>0\),
\(\tau(n)^D\le C_{D,\delta}n^\delta\): at sufficiently large primes use
\((a+1)^D\le2^{Da}\le p^{\delta a}\), and take the finite supremum at
each remaining prime. Its constant need not be small.

On grids of denominators \(v,w\), put \(g=(v,w)\),
\(s=w/g,t=v/g\). At determinant \(n=sz-tz'\) there are \(g\) pairs per unit
first-point length. For nonnegative residue weights of periods
\(D_1\mid v,D_2\mid w\), their cycle average has period dividing
\(P=D_1D_2\). Indeed a Bezout increment for determinant one, multiplied
by \(P\) in both coordinates, preserves both residues. Averaging over a
full determinant cycle enumerates all \(vw\) residue pairs, so its mean is
the independent residue mean \(\mu\). A nonnegative \(P\)-periodic
sequence has mass \(P\mu\) per period; the two end pieces of any interval
cost at most \(2P\mu\). Thus

\[
 \sum_{n\in J}A(n)=|J|\mu+O(P\mu).                              \tag{9}
\]

On a progression modulo \(Q\) coprime to \(P\), the same proof gives main
term \(|J|\mu/Q\) and the same error. This proves the cycle interface
needed here, including its nonnegative mean-weighted error.

## 3. Remaining fields and unlinked main terms

Use the source notation
\(G=(L,M),U=L/G,T=M/G,\Theta=Gr_{\min}\),
\(K=[L,M]r_{\max}\), \(H=B_i+B_j+\log(2UT)\),
and \(P_0=\rho H\). For fixed processed masks \(d,e\), put
\(f_0=(Td,Ue)\). The width-weighted cycle has size
\(\Theta f_0/(de)\), and a distance \(Sr_{\max}\) gives a determinant
interval of length \(O(SK/f_0)\). Since \(\Theta K=k_Lk_M\), the bare
main term is \(O(Sk_Lk_M/(de))\).

Fields through \(P_0\) have product period at most
\(\exp(C_{\rm per}P_0)\), ordinary separate means, and prime support
below \(P_0\). Choose \(\rho\) so this period is at most \(e^{\epsilon H}\).
At a high common full static prime the relative cycle density is at most

\[
 1+\frac2p\,\mathbf1_{\{n=n_p\pmod p\}}.                        \tag{10}
\]

In fact coincident forbidden residues give ratio \(R_p/R_p^2=1/R_p\le
1+2/p\); distinct residues give \((1-2/p)/R_p^2\le1\).
One nonconstant field gives no excess. High mismatches may be dropped
at the uniform restoration cost already proved in `C_BC`.

Expand (10). For a squarefree product \(Q\), (9) gives the extra main
factor \(1/Q\); the low period is coprime to \(Q\).
The main extra product is at most
\(\prod_p(1+2/p^2)\le e^2\), whereas the roundoff product is at most
\(e^{2\Sigma}\). This proves the remaining-field estimate, with an
absolute harmonic coefficient. It also covers all-static newborn pairs.

There is no combination here of unread high static fields with adaptive low
fields: if a side is adaptive below \(P_0\), its adaptive range covers the
larger primes below the join, which the backward continuation already read.
At a bad-omission stop the lower adaptive fields are dropped; the fields
still needing static counting are genuinely static. For a linked stop,
mapped weights will be bounded by one and the other side is static.

The continuing term now supplies (7) on both sides. Let

\[
 A_i(a)=\sum_{\substack{d:\ da\ {\rm assigned,\ good}}}
                   \pi_{{\rm done},i}(d).
\]

Then \(0\le A_i\le1\) and \(\mathbb E A_i\le\delta_i\).
Independent outer laws give \(\delta_i\delta_j\). With one common law,
\(\mathbb E(A_iA_j)\le\min(\delta_i,\delta_j)\).
For narrow counts \(S\ll e^{-E_g\max(B_i,B_j)}\), so (3) and \(E_g\ge2\)
give \(S/\max(\delta_i,\delta_j)\ll1\). Consequently the continuing main
term is \(O(m_im_j)\) in either currency. The common probability has
not been squared.

At a first bad omission \(p\), discard lower adaptive cuts. Sparse bins
from the adaptive start to bin \(Y_p\) have reciprocal sum at most
\(2\kappa Y_p\) per side. Restoring both ordinary products costs at most
\(e^{8\kappa Y_p}\). Designate one omitted adaptive side \(i\) and drop its
assignment restriction. Its unrestricted processed law gives \(1/p\),
uniformly at the fixed outer mask, while the other assignment is retained.

If \(p\mid UT\), then
\(\sum_{p\mid UT,p>P_0}\log p/p\le\log(UT)/P_0\le1/\rho\).
If \(p\mid e\), the partner's good mask instead gives
\(\sum(\log p)^{3/10}/p\le1\), since \(p>P_0>d_0B_j\).
In both cases \(\log\log p\ge A_0B_i\). For \(\kappa\le1/320\),

\[
 \sum\frac{e^{8\kappa Y_p}}p
 \ll_\rho e^{-A_0B_i/4}.                                      \tag{11}
\]

This follows by factoring \((\log p)^{8\kappa-1}\), respectively
\((\log p)^{8\kappa-3/10}\), from the corresponding controlled sum.
Both exponents are strictly below \(-1/4\) in the second, limiting case.
The inverse assignment density costs at most \(e^{16B_i/25}\).
Thus \(A_0\ge8\) more than pays for it, with margin
\(A_0/4-16/25>0\). The bad-stop main term is again \(O(m_im_j)\).
Keeping the partner assignment gives the same conclusion for the
independent and common outer laws.

The roundoff at fixed masks is bounded by

\[
 C\Theta\frac{f_0}{de}e^{\epsilon H+2\Sigma}
                (1+\omega(d)+\omega(e)).                      \tag{12}
\]

Density gains have been dropped here; there is no \(e^{8\kappa Y_p}\)
restoration cost in this roundoff. There is one continuing branch, and
every bad stopping prime divides one of these two masks.

## 4. Linked main terms and image cutoffs

Apply the unchanged `C_BC` mechanism to each separately stopped joint loss.
It supplies \(1/b_i^+\) on every mapped side, keeps the entire outer
coefficient, and bounds the sum of origin links by the actual successful
plus capacities. Origin masks are already matrix row labels, not another
sum after capacity. Each image pair has exactly its own first-sharing epoch.

Let \(d',e'\) be below-\(p\) image deficits on mapped sides, and use the
original processed mask on a static side. The two counted denominators are
\(L'/(pd'),M'/(pe')\). A static forbidden residue at \(p\) is one such
restricted grid, with its smaller residue tests translated by units.
The product of cycle size and determinant-interval length is

\[
 \frac{k_{L'}k_{M'}}{p^2d'e'}.                                 \tag{13}
\]

There is no missing factor of \(p\) in this expression.

The smaller smoothing cutoff for an image is valid uniformly. The metric
\(\log(AB/(A,B)^2)\) is the sum of absolute prime-valuation differences.
The two earlier-component paths change it by at most
\(2e^{h_*Y_p/10}\). A mapped band's height is at most \(Y_p/A_0\).
Thus \(H'\le H+2Y_p/A_0+2e^{h_*Y_p/10}\le H+p\), for all the sufficiently
large starting bins stipulated by the last \(k_0\) choice. Since \(p>\rho H\),
we may use

\[
 q=\frac{\rho}{4(1+\rho)},\qquad qH'<p,\qquad d_0<q/2.           \tag{14}
\]

Also \(qC_{\rm per}<\rho C_{\rm per}\le\epsilon\), so the image period
loss is at most \(e^{\epsilon H'}\). The image rows are assigned good
rows, so high mismatch restoration at this cutoff is again uniformly
bounded. No old cutoff is presumed automatically valid for a changed centre.

On a mapped side the geometric \(1/(pd'b_i^+)\), with its carried upper
ordinary factors, becomes
\(\pi_{\rm done}(d'pb_i^+)\) after restoring factors through \(p\).
By (8), restoration costs at most \(e^{12Y_p+6}\) per mapped side.
Dropping that side's assignment gives processed probability at most \(1/p\)
for deficit exactly one at \(p\), still at a fixed outer mask.
On a static side the assignment stays, and its success residue contributes
at most \(2A_j(a)/p\), allowing the missing ordinary \(R_p\).
Thus one mapped side and one static side give at most \(2\delta_j/p^2\)
after the outer average; two mapped sides give at most \(1/p^2\).
This argument works identically with a common outer mask.

The lost mapped assignment densities cost at most
\(\exp((32/(25A_0))Y_p)\). Therefore every image pair is charged at most
its mass product times a constant times

\[
 \sum_p\frac{\exp((24+32/(25A_0))Y_p)}{p^2}
 \le \sum_{n\ge2}\frac{(\log n)^{25}}{n^2}<\infty,              \tag{15}
\]

because \(A_0\ge8\) and \(Y_p\le\log\log p\).
An entirely elementary upper bound is \(2^{26}25!\):
use \(t^{25}\le25!e^t\) at \(t=\frac12\log n\), and
\(\sum_{n\ge2}n^{-3/2}\le2\).
Hence this stopping-prime sum is uniform, not a numerical finite bound.
Together with capacity and epoch uniqueness this proves that **all main
terms total \(O(W^2)\)**.

The linked roundoff before mask and stopping-prime sums is

\[
 C\Theta'\frac{(T'd',U'e')}{pd'e'}
       \prod_{\rm mapped}(b_i^+)^{-1}
       e^{\epsilon H'+2\Sigma'}.                              \tag{16}
\]

The main-term restoration \(e^{24Y_p}\) does not occur in (16).

## 5. Exact prime-exponent roundoff calculations

These are uniform in the centre exponents, not just in squarefree centres.
They are the local universal algebra checked by `verify.py`.

At a prime let the centre exponents be \(m+h,m\), \(h\ge0\), and write
the processed deficit exponents as \(a,b\). Put \(x=1/p\).
The local term in \(f_0/(de)\) is
\(p^{\min(a,h+b)-a-b}\). Include
\(2^{\mathbf1_{a>0}+\mathbf1_{b>0}}\), which pays
\(1+\omega(d)+\omega(e)\) globally.
Extending both exponents to infinity gives exactly

\[
 F_h(x)=
 \frac{(2h+1)+6x+(1-2h)x^2}{(1-x)^2}
 =F_0(x)+2h\frac{1+x}{1-x},\quad
 F_0(x)=1+\frac{8x}{(1-x)^2}.                                 \tag{17}
\]

Indeed at common exponents the total weight on \(\max(a,b)=k\ge1\)
is \(8k\); the extra free allowance \(h\) adds
\(2h(1+x)/(1-x)\). Finite centre exponents only reduce the sum.
For \(0\le x\le1/2\),

\[
 \begin{split}
 (1+32x-F_0)(1-x)^2&=8x(1-2x)(3-2x)\ge0,\\
 ((2h+1)F_0-F_h)(1-x)^2&=4hx(3+x)\ge0,\\
 (h+1)^2-(2h+1)&=h^2\ge0 .
 \end{split}
\]

Multiplication over the processed primes proves

\[
 \sum_{d,e}2^{\omega(d)+\omega(e)}\frac{(Td,Ue)}{de}
 \le \tau(UT)^2 e^{32\Sigma}.                                 \tag{18}
\]

Each later-omission sum in (16) costs at most
\(\prod_p(1-1/p)^{-1}\le e^{2\Sigma}\), even if we allow higher
deficits than the actual squarefree later omissions.
Two mapped sides cost at most \(e^{4\Sigma}\).
The stopping-prime sum \(\sum1/p\) is at most \(\Sigma\le e^\Sigma\).
The static expansion costs \(e^{2\Sigma}\).
Thus (12) and (16), after all their respective sums, are bounded by

\[
 C\Theta\,\tau(UT)^2\exp(\epsilon H+64\Sigma).                  \tag{19}
\]

The deliberately loose coefficient 64 is absolute. For example the
unconditional linked accounting above uses only \(32+4+1+2=39\).
The probability laws of the outer masks contribute one, with either
currency; no inverse density has been hidden in this step.

For the mixed relative estimate keep the newborn's processed mask \(c_j\)
fixed, and put \(W'=M/c_j\), \(E_{\rm ext}=W'/(W',L)\).
At one prime let \(n,m\) be the exponents in \(L,M\), \(c\) the exponent
in \(c_j\), and \(w=m-c\). The old-mask ratio is
\(p^{-\max(w-n+a,0)}\). If \(t=n-w\ge0\), its weighted sum is at most
\(1+2t+2x/(1-x)\le(t+1)^2(1+4x)\).
Here \(t\le\max(n-m,0)+c\), and
\(t+1\le(\max(n-m,0)+1)(c+1)\).
If \(t<0\), the sum is at most
\(p^{-(w-n)}(1+2x/(1-x))\le p^{-(w-n)}(1+4x)\).
These inequalities follow from nonnegative polynomial factorizations
recorded in the script. Therefore

\[
 \sum_d2^{\omega(d)}\frac{(W',L/d)}{W'}
 \le E_{\rm ext}^{-1}\tau(U)^2\tau(c_j)^2 e^{4\Sigma}.           \tag{20}
\]

The fixed partner omega allowance costs at most \(\tau(c_j)\).
Dividing the newborn row's roundoff by its original first-mass expression
\(r_jW'R_{\rm done}(W')\), with its outer coefficient left outside, gives

\[
 C e^{\epsilon H+64\Sigma}
   \frac{r_{\min}}{r_j}E_{\rm ext}^{-1}
   \tau(U)^2\tau(c_j)^3.                                      \tag{21}
\]

The inverse ordinary density costs at most \(e^{2\Sigma}\).
Including that cost, the static expansion, a later old-side mask sum,
and the stopping-prime sum still uses less than 64.

For a mixed linked term the newborn is static and its assigned row is
unchanged. Dividing both counted denominators by the common full \(p\)
divides their gcd by \(p\). Consequently the exterior ratio is unchanged,
and relative to the **original** newborn first mass there is an extra
\(1/p\). It sums as just described. This explains why (21), without an
extra restoration \(e^{CY_p}\), applies also to the linked roundoffs.

The processed segment of the newborn has reciprocal sum at most
\(s_{\rm low}B_j\), by (6). The second good-mask condition therefore gives
\(\tau(c_j)\le e^{s'B_j}\). Finally \(v\mid W'\) for every true row
represented by this projection, so
\(E_{\rm ext}\ge v/(v,L)\). Formula (5) applies to that very row,
not to a newly assigned or fictitious denominator.

## 6. One feasible parameter family, with strict margins

Let \(\eta=3/200\), take any fixed \(D\ge64\), and choose

\[
 \begin{gathered}
 \beta\ge64(3D+3),\qquad A_0\ge8,\\
 0<\epsilon,\delta\le\epsilon_*=
       \frac{\eta}{128(\beta A_0+2)},\qquad
 s'=\frac{\eta}{128D},\\
 0<s_{\rm low}\le s'/100,\qquad
 0<\kappa\le\min(1/320,s_{\rm low}/(100A_0)),\qquad
 0<\theta\le\eta/128.                                         \tag{22}
 \end{gathered}
\]

Enlarge \(A_0\) for the already specified geometric/core conditions.
Take \(\ell\) small relative to \(s_{\rm low}\) and \(\sigma\), then \(D_0\)
large after \(\kappa,A_0\), and make \(\theta\) smaller, if necessary, for
\(D_0\theta<\ell/2\) and the source colour requirements.
To preserve the earlier mask purge, choose an integer \(M\) with \(Ms'\ge4\)
and further decrease
\(s_{\rm low}\le Ms'/(4C_M)\). Then
\(Ms'-C_Ms_{\rm low}\ge3>2\). No later constant feeds back into the
absolute harmonic coefficient \(D\).

The rational-model and localization constants can now be chosen as in the
source; require also \(E_g\ge2\).
If they require smaller tiny powers, decrease \(\epsilon,\delta\);
all bounds use their upper values. After \(C_{\rm per}\) is fixed take
\(0<\rho\le\min(1,\epsilon/(4C_{\rm per}))\), then \(q\) as in (14),
and finally \(d_0<q/2\).
Choose \(k_0\) last for the finitely many large-band/onset requirements.
The choices of \(w\) and \(N_0\) have not been used.

Here are the margins used in the proof. They are strict, not a search for
one finite numerical assignment.

* With \(u_d=3/4\), the tensor exponent \(s_d=3/8\) has gap \(1/8\).
* With \(u_w=201/400\), \(s_w=399/800\) has gap \(1/800\).
  The available power exceeds it because
  \(\epsilon+\delta<1/800\).
* The width-shell saving beyond a reserved \(b_j/20\) is
  \[
  \frac38\frac{13}{20}
  -\left(\frac4{25}+\frac{33}{25}\frac1{400}\right)\frac{101}{100}
  -\frac1{100}-\frac1{20}
  =\frac{18817}{1000000}>0.
  \]
* The bad-omission density margin is \(A_0/4-16/25>0\), and
  \(3/10-8\kappa>1/4\).
* The linked restoration exponent satisfies
  \(24+32/(25A_0)<25\).
* The total oriented mixed exponent cost is bounded by
  \[
  \epsilon(2+\beta A_0/2)+\delta\beta A_0/2
       +Ds_{\rm low}+Ds'+4\theta
  \le \eta\,\frac{601}{12800}<\eta/2.                          \tag{23}
  \]

The exact script substitutes \(D=64+d,A_0=8+a\) and
\(\beta=64(3D+3)+b\), for arbitrary \(d,a,b\ge0\).
For eight parameter inequalities it clears positive denominators and
checks **all** polynomial coefficients are nonnegative and the constant is
positive. This is an exact certificate for the whole unbounded family,
not a numerical finite-bound check. Decreasing the small parameters
preserves these margins.

## 7. Universal summation

We include the tensor justification so that no unrelated unverified
arithmetic theorem is needed. Fix \(1/2<u<1\). For probability vectors
\(\alpha,\beta\), the off-diagonal kernel \(q^{|a-b|}\) has convolution
norm \(O(q)\) on \(\ell^2\). The diagonal sum is at most
\((\sum\alpha_a^{2u}\sum\beta_b^{2u})^{1/2}\).
If the whole sum is at least one, both vectors have dominant atoms of
mass \(1-O(q)\), since
\(\sum\alpha^{2u}\le(\max\alpha)^{2u-1}\); their dominant indices must
coincide, or the diagonal sum is \(o(1)\).
Let \(d\) be their total off-atom mass. The central term is at most
\(1-c_ud\), the double-off part is \(O(d^{2u})\), and Holder gives
the single-off part \(O(qd^u)\). Absorb \(d^{2u}\), since \(2u>1\).
Maximizing \(-c d+Cqd^u\) gives the uniform bound
\(1+O_u(q^{1/(1-u)})\).
When the total is below one the same upper bound is automatic.
For the finitely many larger \(q<1\), the elementary convolution norm
\(1+2q/(1-q)\) suffices.

Apply this with \(q=p^{-s}\) on each prime exponent coordinate.
Slice the two mass vectors at one coordinate, apply the remaining-coordinate
bound to each slice with its slice total, and then the one-coordinate bound
to those totals. The resulting product converges for \(s/(1-u)>1\),
by comparison with \(\sum n^{-s/(1-u)}\). Thus, for finite nonnegative
integer-indexed mass sequences,

\[
 \sum_{L,M}\frac{(x_Ly_M)^u}{(LM/(L,M)^2)^s}
 \le C_{u,s}\left(\sum x_L\sum y_M\right)^u.                   \tag{24}
\]

At fixed shells there is no repeated \((L,r)\).
At exact dyadic widths use (24), then the summable convolution kernel
\(2^{-\lambda|k-l|}\), for any fixed \(\lambda>0\).
Its quadratic form is bounded by its \(\ell^1\) norm times the two
\(\ell^2\) norms, and
\(\sum M_r^{2u}\le(\sum M_r)^{2u}\).
Consequently each fixed pair of shells costs at most \(C W^{2u}\).

### Distant roundoffs

Converting (19) with the centre identity costs, at mass exponent \(u\),

\[
 \Theta\le C(m_im_j)^u(UT)^{-1/2}
       (r_{\min}/r_{\max})^{1/2}
       \exp\left[
       \left(\frac4{25}+\frac{33}{25}(u-\tfrac12)\right)(b_i+b_j)
       \right].                                               \tag{25}
\]

At \(u=3/4\), the coefficient is \(49/100\);
\(b_i+b_j<4Y/A_0\). Use (8), the divisor tiny power, and
\(\log UT>\beta Y/2\). Spending \( (UT)^{1/16}\) pays the
\(3DY\) harmonic cost and leaves more than \(e^{-Y}\) after the
period and shell-conversion costs, by (22).
Also \(\epsilon+\delta<1/16\). Hence (19) is at most

\[
 C_{k_0}(m_im_j)^{3/4}(UT)^{-3/8}
       (r_{\min}/r_{\max})^{1/2}e^{-Y}.                        \tag{26}
\]

There are \(O((Y+1)^2)\) eligible shell pairs.
Apply (24) and width convolution, then sum
\(\sum_{Y\ {\rm dyadic}}(Y+1)^2e^{-Y}<\infty\).
The distant total is \(O_{k_0}(W^{3/2})\).

### Width-separated mixed roundoffs

Here \(\log(r_i/r_j)>13b_j/20\) and \(b_i/b_j\le1/100\).
Use \(u=201/400\). In (25) reserve width power \(1/8\) for convolution;
the remaining \(3/8\) supplies \(e^{-39b_j/160}\).
The mass conversion costs at most
\((4/25+(33/25)/400)(101/100)b_j\).
The harmonic and band-period cost is less than \(b_j/100\);
the small \(UT\) powers fit \(s=399/800>1-u\).
The exact margin in Section 6 leaves \(e^{-b_j/20}\).

At a fixed newborn shell \(t\), there are \(O(t+1)\) smaller old shells.
Applying (24) and width convolution gives
\[
 C_{k_0}W^{201/200}\sum_{t\ge1}(t+1)e^{-t/20}<\infty .
\]
This proves the claimed width-separated bound.

### Oriented mixed roundoffs: preserving the mass factor

Otherwise \(\log(r_i/r_j)\le .65b_j<.7b_j\), so (5) gives, row by row,
\[
 (r_{\min}/r_j)E_{\rm ext}^{-1}<e^{-\eta b_j}\le e^{-\eta B_j}.
\]
In (21), use \(\tau(c_j)^3\le e^{3s'B_j}\le e^{Ds'B_j}\),
\(\tau(U)^2\le C_\delta U^\delta\), (6), and
\(H\le(2+\beta A_0/2)B_j+\log2\).
The relative bound per old centre is therefore at most
\[
 C_{k_0}\exp\left[
 -\bigl(\eta-\epsilon(2+\beta A_0/2)-\delta\beta A_0/2
               -Ds_{\rm low}-Ds'\bigr)B_j\right].              \tag{27}
\]

Here is the strengthening over the source proof. Every possible old
centre has \(b_i<2\theta B_j\), and (3) implies
\(m_i\ge e^{-1}e^{-(66/25)\theta B_j}
       \ge e^{-1}e^{-4\theta B_j}\).
Since these **original assignments are disjoint** and their total is
at most \(W\),

\[
 \#\{i:B_i\le\theta B_j\}\le e\,W e^{4\theta B_j}.              \tag{28}
\]

It is unnecessary to replace the factor \(W\) in this count by one.
Combining (27), (28), and (23), the relative error for a fixed newborn
row is at most \(C_{k_0}W e^{-\eta B_j/2}\).
Its retained outer-law first mass sums to at most \(m_j\), by (7)
and the first-currency identity. This is true for the common-law and
independent-law versions: the old assignment has already been dropped,
and (20) is uniform in the fixed newborn outer mask.

Each mixed newborn is considered at its single start \(A_0B_j\).
Capacity has already removed origin multiplicity, and the linked stopping
primes were summed before (27). Therefore all these errors total
\[
 C_{k_0}W\sum_jm_j e^{-\eta B_j/2}\le C_{k_0}W^2.              \tag{29}
\]
No count of old matching histories, cells, or slots is present.

Finally the main terms are \(O(W^2)\), the distant errors are
\(O_{k_0}(W^{3/2})\), and the two mixed errors are as above.
Since \(0<W\le1\), their sum is bounded by (1). If there are no retained
centres the counts vanish. This completes the analytic proof.

## 8. Certificate boundary, prior work, and review

Run, without modifying artifacts:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/remaining-first-joins/verify.py
```

The script checks eleven exact symbolic identities, eight strict
positive-coefficient parameter certificates, the stated rational margins,
and 8,184 bounded prime-exponent/deficit-law regression cases. It also checks
49,686 projected-grid gcd identities against actual integer denominators
and 2,932 determinant-cycle/residue cases, including nontrivial coprime
cofactors and common prime powers, to test the coincidence orientation.
The finite cases are adversarial tests of the translation into local
exponents, **not** the proof for arbitrary exponents.
The universal local bounds follow from (17)--(20), and the universal
analytic summations from (8), (11), (15), and (24)--(29).
The script explicitly lists analytic obligations it does not execute.
There is no claim of a kernel check for this new analytic theorem.

Before custom certificate code, the current Jacobian operation contract
was inspected and one bounded operation was executed:
`combinatorics.generating_function.coefficients.compute`.
`jacobian-payload.json` is the exact request for
\((1+6x+x^2)/(1-x)^2\) through order 13.
`jacobian-output.json` preserves the adapter's typed answer, protocol
`2025-11-25`, server `0.14.0`, coefficients \(1,8,16,\ldots,96\),
and zero residual coefficients.
`jacobian-run-status.json` records exit 0 and no timeout.
This is exact finite corroboration only; no failure or `UNKNOWN` has been
treated as mathematical support.

The already identified BHV background is recorded separately as
`C_BHV_BACKGROUND`, not as a premise of this theorem:
[arXiv:2406.19198v1](https://arxiv.org/html/2406.19198v1),
Theorem 14, equations (52), (76), (78), proves the rational-shift benchmark
with \((A+aB,q)=1\). Its non-strict inequality yields the strict weak
inequality by applying it to \(\psi/2\).
Theorem 18 instead quantifies \(\forall f\,\exists\gamma\), where the chosen
Liouville shift depends on \(f\), and requires one of its additional
divergence lower bounds. It is not \(\forall\gamma\) for a prescribed
irrational shift. The targeted source passages and equations are
`Thmtheorem14.txt`, `Thmtheorem18.txt`, and `BHV-equations.txt`.
No new literature survey or assertion of verified novelty is made.
The canonical citations require the independent reader's attribution;
the Engineer has not self-certified their literature status.

Compared with the strongest prior result in this campaign, the new content
is the full uniform quantitative estimate, its simultaneous strict
parameter margins, and (28)--(29), not another verification of transport.
The sparse input, partition existence, direct birth comparisons, and
closure to the main conjecture remain outside this result.
No false literal manuscript assertion was established, so no artificial
`F_...` refutation claim has been registered.

[joins]: ../openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections/joins.tex
[centres]: ../openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections/centres.tex
[tables]: ../openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections/tables.tex
[prescriptions]: ../openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections/prescriptions.tex
[preliminaries]: ../openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections/preliminaries.tex
