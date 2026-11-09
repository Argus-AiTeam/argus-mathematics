# Quartic growth under smooth pruning

## Scope and source facts

This is an audit of `lem:frame-quartic`, equations `eq:src21` and
`eq:src22`, in the planar manuscript dated September 24, 2026. The target
remains publishable/exploratory. No counterexample, endpoint convergence
theorem, novelty verdict, or independent acceptance is asserted here.

Write `P` for
`research/openai_manuscript/Endpoint-convergence-for-the-planar-Schrodinger-equation-September-24-2026/build/sections/`
and `H` for
`research/openai_manuscript/Endpoint-pointwise-convergence-for-the-Schrodinger-equation-in-higher-dimensions-September-24-2026/build/sections/`.
These abbreviations below identify staged, unmodified primary sources.

The planar dependency chain is:

* `P/05-frame.tex:85-176`: initial cap bounds, including small curvature
  derivatives at scale `Delta_0`.
* `P/05-frame.tex:178-234,278-460`: the actual continuous tight frame,
  smooth deletion masks, contraction, persistence, and loss-sensitive
  mixed derivative estimates.
* `P/05-frame.tex:543-732`: Gaussian quartet potential, the error bound
  `eq:src21`, and growth bound `eq:src22`.
* `P/05-frame.tex:462-539,734ff`: flux and maximal recovery are additional,
  separate obligations for the bilinear frame theorem at lines 27-66.
* `P/06-flat.tex`, `P/08-dyadic.tex:10-28,699ff`: flat reductions and the
  frame theorem enter the dyadic distribution estimate with some fixed
  `p>2` and a density saving.
* `P/09-endpoint.tex:29-46,361ff,455-469`: short-time weak bounds, common
  time-tree square summation, and the local strong `L^1` maximal estimate.
  The convergence claim is `P/01-introduction.tex:23-35`.

The higher-dimensional manuscript has a different chain. Its endpoint
claim is `H/introduction.tex:25-55`, for each fixed `n>=3`, with Sobolev
exponent `n/(2(n+1))`. The source-linked reading gives:
`H/transverse.tex:15-45` (`t:transverse`), `H/sparse.tex:4-20,143-147`
(`s:sparse`), wall/flattening reductions
(`H/wall.tex:111-188`, `H/flattening.tex:151-178`), the distinct
`k=n-1>=2` transverse frame theorem
`H/frame.tex:16-66` (`f:frame`), the lossless weak estimate
`H/weak.tex:3-31,104-125` (`w:weak`), and
`H/endpoint.tex:65-96,172-224,294-333,398-499`.
The higher-dimensional proof does not invoke planar `lem:frame-quartic`.
An accepted result here therefore does not automatically verify its
transverse frame theorem or either manuscript's endpoint conclusion.

The retrieved classical scope results are Du--Guth--Li,
arXiv:1612.08946v2, Theorems 1.1-1.3, and Du--Zhang,
arXiv:1805.02775v3, Theorems 1.1-1.3. Their positive Sobolev statements
use strict inequalities, and their frequency-localized estimates have
an arbitrary positive epsilon loss. They do not state the endpoint or
the smooth-pruning quartic estimate. These are observations about the
retrieved theorem statements, not assumptions that their conclusions
are true and not inputs to the analytic argument below. Independent
source-statement review remains for the Host-invoked Reviewer.

For example, Theorem 1.1 of
<https://arxiv.org/html/1612.08946v2> states:
> For every \(f\in H^s(\mathbb R^2)\) with \(s>1/3\),
> \(\lim_{t\to0}e^{it\Delta}f(x)=f(x)\) almost everywhere.

Theorem 1.1 of <https://arxiv.org/html/1805.02775v3> states:
> Let \(n\geq3\). For every \(f\in H^s(\mathbb R^n)\) with
> \(s>n/(2(n+1))\), \(\lim_{t\to0}e^{it\Delta}f(x)=f(x)\)
> almost everywhere.

The respective Theorem 1.3 bounds explicitly include \(R^\epsilon\)
and \(R^{n/(2(n+1))+\epsilon}\) for each \(\epsilon>0\), for all
\(R\geq1\) and data with Fourier support in the unit annulus.
No conclusion of either external theorem is invoked in Theorem T.

The project Wiki index contained no matching Schrödinger/quartic audit
page. No relevant prior route was present in the campaign ledger.
The elementary quartet identity is not a resolution of the analytic
question.

## Actual hypotheses to be preserved

In the frame theorem, packets have the form
`s_l exp(i(x xi_l-t xi_l^2)) H_l((x-b_l-2 xi_l t)/h,t/h^2)`,
with fixed profile boxes, sufficiently many uniformly bounded
derivatives, bounded unit phase-space multiplicity, and `h>=1`.
After frequency-layer reduction and normalization the initial cap
size is `Delta_0~h^-1`, the retained amplitudes are at most `lambda`,
and `D` bounds the squared spacetime norm. The scales are
`Delta_j=K^j Delta_0`, with fixed sufficiently large dyadic `K`.

At stage `j`, `c_a=P_a g_(j-1)`, `b_a=rho_a c_a`,
`d_a=(1-rho_a)c_a`, `g_j=integral P_a b_a da/Delta_j`, and
`R_j=integral P_a d_a da/Delta_j`. Here `p` is a fixed real smooth
compactly supported function with `integral p^2=1`.
The masks are not arbitrary cutoffs: marked co-moving unit cells are
enlarged by `K+2`, convolved with the stipulated nonnegative bump,
and combined with the time partition in `Delta_j^2 t`.
In particular `0<=rho_a<=1`,
`L_a=(1-rho_a^2)|c_a|^2`, and
`sum_j l_j<=D`, where `l_j=integral L_a dz da/Delta_j`.
Explicitly, with \(\psi\geq0\), supported in \((-1,1)\) and of
integral one,
\[
 m_e=\psi*\mathbf1_{\{r:\operatorname{dist}(r,A_e)<K+2\}},\qquad
 1-\rho_a(x,t)=\sum_e\chi_e(\Delta_j^2t)
                         m_e(\Delta_j(x-2at)).
\]
The nonnegative time partition has bounded overlap and support lengths,
a fixed inner interval on which each cutoff is bounded below, and
the stipulated flatness at support endpoints.

The parent frame theorem also requires
\(h^{-1/2}\leq\delta\lesssim1\), separated frequency intervals of
length \(\delta\), and a terminal scale
\(\Delta_n\asymp_K c_0\delta\) small enough to preserve their gap.
This single-field quartic lemma does not use separation: those
conditions choose the initial and terminal packet scales and are
needed elsewhere in the bilinear frame theorem. Proving the lemma
for every finite scale progression does not remove any gap hypothesis
from that parent theorem. The positive spatial smoothing operators
\(W_j\), their polynomial envelope kernels, and the witness thresholds
belong to the separate flux/recurrence/maximal applications; none is
an additional input to the quartic potential estimate proved here.

The fields need not solve the free equation. The relevant operator is
`L=i partial_t+partial_x^2`, and all integrals are global spacetime
integrals. Neither spatial translations introduced by a multiplier
nor curvature differentiation may be justified by an assumed compact
temporal Fourier support.

## Result: a two-derivative defect-budget theorem

The result below is an analytic proof, with an exact algebraic and
summation certificate. It is not a computer proof of an analytic
operator inequality. Independent review, significance, and originality
assessment are pending. In particular, "no matching result retrieved"
would not establish novelty.

Fix a smooth compactly supported partition of unity
\(\sum_{b\in\mathbb Z}\chi(\xi/d-b)=1\), and let \(Q_{d,b}\) denote its
spatial multipliers. Fixed enlargements of these caps will always be
allowed; changing to an enlarged cutoff costs a fixed number of
neighboring caps. All norms in this note are on \(\mathbb R_x\times
\mathbb R_t\). The Fourier transform is normalized with Plancherel
measure, so fixed positive Fourier constants do not appear in the
quartic identities.

**Theorem T.** Let \(K\geq2\), \(d_j=K^j d_0>0\), \(0\leq j\leq n\),
and let
\[
 g_j=g_{j-1}-R_j,\qquad
 \mathcal L=i\partial_t+\partial_x^2.
\]
Initially take smooth rapidly decreasing fields, so all identities
below are ordinary integrals. Suppose \(\mathfrak A\geq1\),
\(\lambda>0\), \(D\geq0\), and \(l_j\geq0\) satisfy, for
\(q=0,1,2\), at every stage,
\[
 \sup_b\|Q_{d_j,b}\mathcal L^q g_j\|_\infty
       \leq\mathfrak A\lambda d_j^{2q},\qquad
 \sum_b\|Q_{d_j,b}\mathcal L^q g_j\|_2^2
       \leq\mathfrak A^2d_j^{4q}D,                 \tag{T1}
\]
and
\[
 \sum_b\|Q_{d_m,b}\mathcal L^qR_m\|_1
       \leq\mathfrak A\lambda^{-1}d_m^{2q}l_m.
                                                        \tag{T2}
\]
Constants for fixed cap enlargements can be included in \(\mathfrak A\).
Define \(G_d(u)=e^{-cu^2/d^2}\), for fixed \(c>0\). Then
\[
 \begin{split}
 |\operatorname{Err}_j|
 &\leq C_{c,\chi}\mathfrak A^4\lambda^2
 \left[
   (d_0/d_{j-1})^2D+
   \sum_{m<j}(d_m/d_{j-1})^2l_m
 \right],                                             \tag{T3}\\
 \sum_{j=1}^n\int (G_{d_j}-G_{d_{j-1}})(u)
       |\widehat{|g_{j-1}|^2}(u,\tau)|^2\,du\,d\tau
 &\leq C_{K,c,\chi}\mathfrak A^4\lambda^2
              \left(D+\sum_{m=1}^n l_m\right).          \tag{T4}
 \end{split}
\]
Here the error is the exact error in the Gaussian potential identity
below, not a numerically defined remainder. In (T3) its multiplier
constant is independent even of the ratio \(d_j/d_{j-1}\geq1\).
The constant in (T4) may depend on the fixed upper ratio \(K\).
There is no dependence on \(n\), spatial frequency span, or temporal
support size. No temporal Fourier support is assumed.

The proof applies as well to the finite-decay, bounded-time fields
constructed from the manuscript's finite packet arrays. Their stipulated
profile regularity can be chosen to give the integrability of the
finitely many derivatives and Fourier products used below. Alternatively,
common smooth convolution, spatial cap truncation, and passage in the
norms in (T1)-(T2) give the same conclusion. The actual fields are checked
explicitly in the mask application below; no equation
\(\mathcal Lg_j=0\) is imposed.

Compared with the manuscript's off-diagonal proof, this uses at most
**two**, rather than four, curvature derivatives on an input. The
improvement is confined to this quartic module: it does not lower the
regularity needed by the separate flux and maximal-recovery arguments.
The theorem also isolates a defect-budget hypothesis not tied to
positive masks or a fixed native time support.

### 1. The normalized Gaussian identity and the sign

Let \(q_{d,a}\) have spatial multiplier \(e^{-c(\xi-a)^2/d^2}\), and put
\[
 \mathcal P_d(f)=\frac{2\sqrt c}{\sqrt\pi}
       \int_\mathbb R\int_{\mathbb R^2}|q_{d,a}f|^4\,dz\,\frac{da}{d}.
                                                        \tag{1}
\]
On a quartet set
\[
 \xi_1=x,\quad \xi_2=x-u,\quad
 \xi_3=x-u-v,\quad \xi_4=x-v.
\]
Its common midpoint is \(M=x-(u+v)/2\), and
\[
 \sum_{\nu=1}^4(\xi_\nu-a)^2
       =4(a-M)^2+u^2+v^2.                              \tag{2}
\]
Thus the center integral in (1) is exactly
\(G_d(u)G_d(v)\). Also
\[
 \xi_1^2-\xi_2^2+\xi_3^2-\xi_4^2=2uv.                \tag{3}
\]
Both are polynomial identities, not estimates.

Write \(\Lambda_M(f_1,f_2,f_3,f_4)\) for the quartic integral on the
spatial and temporal alternating-sum planes, with multiplier \(M(u,v)\)
and conjugation on slots 2 and 4. In particular
\(\Lambda_1(f,f,f,f)=\int|f|^4\).
Set \(d=d_{j-1}\), \(B=d_j/d\), and
\[
 E_B(s,t)=F_B(s)F_B(t)-F_1(s)F_1(t),\qquad
 F_B(s)=1-e^{-cs^2/B^2}.                               \tag{4}
\]
Then
\[
 \mathcal P_{d_j}(g)-\mathcal P_d(g)
   =2I_j+\operatorname{Err}_j,\quad
 \operatorname{Err}_j=\Lambda_{E_B(u/d,v/d)}(g,g,g,g),   \tag{5}
\]
where \(I_j\) is the corresponding summand in (T4).
Indeed, expand \(G(u)G(v)\) about \(1\), and interchange slots
2 and 4 to equate the two single-difference terms.

With the spacetime transform using \(e^{-i(x\xi+t\tau)}\),
\(\mathcal L\) has symbol \(-(\tau+\xi^2)\).
The temporal alternating sum is zero. Consequently division by
\(2uv/d^2\) is exactly transfer of one signed
\(-\mathcal L/d^2\) to one of the four slots. Repeating the identity
twice produces at most two derivatives on a slot. It does not
differentiate a cutoff or require temporal localization.

### 2. A spatial kernel bound

If a function \(H\) is supported on a fixed rectangle, then
\[
 \|\check H\|_1
 \leq C\sum_{\alpha_1,\alpha_2\in\{0,2\}}
                 \|\partial_1^{\alpha_1}
                   \partial_2^{\alpha_2}H\|_1.         \tag{6}
\]
To see this, multiply its Fourier transform by
\((1+y_1^2)(1+y_2^2)\) and integrate by parts. The reciprocal
weight is integrable. An invertible diagonal rescaling leaves the
Fourier-kernel \(L^1\) norm unchanged. Thus a symbol with bounded
derivatives through order two in each rescaled variable, on a fixed
rectangle, has uniformly bounded kernel mass.

A Fourier character in \(u,v\) translates slots 1, 2, and 4 in \(x\)
(with slot 1 receiving the sum of the two translations).
These translations preserve every global \(L^1,L^2,L^\infty\) norm and
commute with \(\mathcal L\). They may be arbitrarily large.

For one cap-offset pattern, fixing one cap vertex fixes all four
indices up to those offsets. Holder followed by Cauchy--Schwarz in the
common cap vertex therefore gives
\[
 |\Lambda_H(f_1,f_2,f_3,f_4)|
 \leq C\|\check H\|_1
       \|(\|Q_bf_1\|_2)_b\|_{\ell^2}
       \|(\|Q_bf_2\|_2)_b\|_{\ell^2}
       \sup_b\|Q_bf_3\|_\infty
       \sup_b\|Q_bf_4\|_\infty,                        \tag{7}
\]
after permuting slots if necessary. A distinguished \(L^1\) slot
instead gives its cap-summed \(L^1\) norm times the other three cap
suprema. No free-cap count is present in (7).

### 3. A global rank-two quotient: all offsets, including the axes

There is a simpler global argument than a near-axis/off-diagonal
decomposition. Define the smooth function
\[
 r_B(s)=
 \begin{cases}(1-e^{-cs^2/B^2})/s^2,&s\ne0,\\ c/B^2,&s=0.
 \end{cases}
 \qquad
 r_B(s)=\frac c{B^2}\int_0^1e^{-c\theta s^2/B^2}\,d\theta.          \tag{8}
\]
The **twice**-divided error has the global rank-two tensor form
\[
 H_B(s,t):=\frac14[r_B(s)r_B(t)-r_1(s)r_1(t)],\qquad
                    E_B(s,t)=(2st)^2H_B(s,t).        \tag{9}
\]
The second identity holds on the axes as well. Thus two transfers
of the curvature identity are globally legitimate, with no singular
division and no temporal cap assumption.

For each fixed derivative order \(r\),
\[
 |r_B^{(r)}(s)|
       \leq C_{r,c}(B+|s|)^{-2-r}
       \leq C_{r,c}(1+|s|)^{-2-r},\qquad B\geq1.     \tag{10}
\]
Indeed, (8) proves smoothness and bounded derivatives on \(|s|\leq1\)
for \(r_1\). On \(|s|\geq1\), differentiate
\(r_1(s)=s^{-2}-s^{-2}e^{-cs^2}\); the Gaussian terms decay faster
than every fixed power, and the rational term has the asserted
derivatives. Finally use
\(r_B^{(r)}(s)=B^{-2-r}r_1^{(r)}(s/B)\).
All constants are independent of \(B\).

Take a smooth unit-scale partition
\(\sum_{p\in\mathbb Z}\eta(s-p)=1\).
On the rectangle localized by \(\eta(s-p)\eta(t-q)\), (6),
(9), and (10) give kernel mass at most
\[
             C w_p w_q,\qquad w_p=(1+|p|)^{-2}.       \tag{11}
\]
The fixed support width of \(\eta\) changes only \(C\).
Now fix the first cap vertex. There are only \(O(1)\) choices for
the second cap near the offset \(p\), \(O(1)\) choices for the fourth
near \(q\), and \(O(1)\) choices for the third by the alternating
sum constraint. Unlike a dyadic annulus, a unit-offset rectangle
does not have an increasing number of cap patterns.
This remains true with any of the four vertices distinguished.
By (7), sum over the common vertex with no additional free-cap count.
Then sum over \(p,q\).

The summation is absolutely and uniformly convergent. For every
finite \(N\geq0\),
\[
 \sum_{p=-N}^N w_p
  =1+2\sum_{k=1}^N\frac1{(k+1)^2}
  \leq1+2\sum_{k=1}^N\frac1{k(k+1)}
  =3-\frac2{N+1}\leq3.                              \tag{12}
\]
Hence the double sum of the weights is at most \(9\).
The scalar comparison follows also from the exact identity
\(1/[k(k+1)]-1/(k+1)^2=1/[k(k+1)^2]\), with positive denominator.
A looser bound of \(25\) for the double sum follows by grouping
positive and negative offsets into dyadic annuli and applying the
already formalized geometric bound with \(r=1/2\): each one-sided
annulus has at most \(2^z\) entries of weight at most \(2^{-2z}\).
Thus the formal all-depth core suffices for absolute summability
without formalizing any infinite lattice sum.

This improves the initially developed dyadic proof, whose bound was
\(C(z+3)2^{-z}\) on \(Z=2^z\): it removes the logarithmic rectangle
count and all anisotropic near-axis partitions. That earlier bound
is also a corollary: on \(|s|\lesssim1/Z\), \(|t|\asymp Z\),
the once-divided quotient is \(2stH_B\), with rescaled kernel cost
\(O(Z^{-2})\); there are \(O(Z)\) offsets. On
\(|s|\asymp U\), \(1/Z\lesssim U\lesssim Z\), the twice-divided
quotient has rescaled kernel cost
\(O(\min(U^2,1)/(U^2Z^2))\) and
\(O(Z\max(1,U))\) offsets. Summing \(U\) gives the former
\(C(z+3)2^{-z}\) bound. Thus the original dyadic claim is retained
as a true, nonsharp corollary.

The global tensor argument also improves on the manuscript's
four-derivative off-axis argument. Neither comparison asserts that a
one-derivative theorem is false. A single-division absolute cap-counting
route still fails to certify summability: on \(|u|\asymp d\),
\(|v|\asymp Zd\), its available quotient bound is \(O(1/Z)\)
against \(O(Z)\) offsets.

### 4. Distinguished derivative and the precise loss gain

In the first transferred derivative use
\(g_{j-1}=g_0-\sum_{m<j}R_m\) only in that slot.
Any second derivative transfer leaves this slot with curvature
order \(q=1\) or \(q=2\). At the current scale \(d=d_{j-1}\),
bounded cap overlap and (T1) at scale \(d_0\) give
\[
 \left(\sum_b\|Q_{d,b}(\mathcal L/d^2)^qg_0\|_2^2
                                                    \right)^{1/2}
       \leq C\mathfrak A(d_0/d)^{2q}\sqrt D.          \tag{13}
\]
For \(R_m\), resolve it at its own scale \(d_m\).
Each fine cap meets only \(O(1)\) current caps since \(d_m\leq d\);
the projection kernels have bounded \(L^1\) norm. Therefore (T2)
gives
\[
 \sum_b\|Q_{d,b}(\mathcal L/d^2)^qR_m\|_1
       \leq C\mathfrak A\lambda^{-1}
                          (d_m/d)^{2q}l_m.          \tag{14}
\]
This step counts current caps per earlier cap, not earlier caps
per current cap, and hence has no factor \(d/d_m\).

All other slots retain the actual \(g_{j-1}\), with its own cap
bounds in (T1). Use two \(L^2\) slots and two \(L^\infty\) slots
for (13), or one \(L^1\) slot and three \(L^\infty\) slots for (14).
Since \(q\geq1\) and \(d_m\leq d\),
\((d_m/d)^{2q}\leq(d_m/d)^2\).
Equations (7), (9)-(12), and (13)-(14) prove (T3).
The sum of the derivative orders is at most two; all sixteen
terms from two transfers have the same gain. No cap in the temporal
Fourier variable and no bound on a support length has entered.

### 5. Potential deletion and all-depth telescoping

The Gaussian composed with \(Q_{d,b}\) has kernel \(L^1\) norm
at most \(C_N(1+|a/d-b|)^{-N}\), for any fixed \(N\).
For nearby centers this is the bounded rescaled smooth multiplier
estimate; for distant centers it follows from Gaussian derivative
decay on the compact cap. Summing these bounds proves
\[
 \|q_{d_j,a}g_j\|_\infty+
 \|q_{d_j,a}g_{j-1}\|_\infty
             \leq C_K\mathfrak A\lambda,\qquad
 \int\|q_{d_j,a}R_j\|_1\,\frac{da}{d_j}
             \leq C\mathfrak A\lambda^{-1}l_j.       \tag{15}
\]
The previous state in the first estimate has \(O(K)\) fine caps
under a current Gaussian; \(K\) is fixed. The second estimate is
(T2) with \(q=0\) and the same integrated Gaussian/cap overlap.
Also the center integral of \(\|q_{d_j,a}g_j\|_2^2\) is a fixed
multiple of \(\|g_j\|_2^2\leq C\mathfrak A^2D\).
Consequently
\[
 |\mathcal P_{d_j}(g_j)-\mathcal P_{d_j}(g_{j-1})|
                   \leq C_K\mathfrak A^4\lambda^2l_j,\qquad
 \mathcal P_{d_n}(g_n)\leq C\mathfrak A^4\lambda^2D.  \tag{16}
\]
Here use
\(\big||z|^4-|w|^4\big|\leq
4(|z|+|w|)^3|z-w|\); its constant is immaterial.

Summing (5) with the actual changing states, rather than a fixed field,
gives the exact sign-sensitive identity
\[
 2\sum_j I_j
 =\mathcal P_{d_n}(g_n)-\mathcal P_{d_0}(g_0)
  +\sum_j[\mathcal P_{d_j}(g_{j-1})-\mathcal P_{d_j}(g_j)]
  -\sum_j\operatorname{Err}_j.                       \tag{17}
\]
The initial term is nonpositive. Each \(I_j\) is nonnegative.
With \(r=K^{-2}<1\),
\[
 \sum_{j=1}^n(d_0/d_{j-1})^2\leq\frac1{1-r},\quad
 \sum_{j=m+1}^n(d_m/d_{j-1})^2\leq\frac1{1-r}.       \tag{18}
\]
For every finite \(N\),
\((1-r)\sum_{k<N}r^k=1-r^N\), so these bounds hold at arbitrary
depth, not just at a list of tested depths.
Equations (T3), (16)-(18) prove (T4).
For \(K\geq2\), \(1/(1-K^{-2})\leq4/3\).
This completes the proof of Theorem T.

## Application to the actual masks

This section verifies the analytic inputs, instead of treating the
manuscript's mask lemma as a theorem imported without its hypotheses.
All constants here may depend on the fixed large \(K\), never on the
stage index.

First, the initial mixed cap estimates in `eq:frame-initial-sup` and
`eq:frame-initial-square` follow directly from the packet representation:
there are boundedly many transported spatial intercepts in each
length-\(h\) cell inside one frequency bin on \(|t|=O(h^2)\).
The retained amplitudes are at most \(\lambda\); summing the fixed
polynomial spatial tails gives the cap suprema.
Weighted Cauchy--Schwarz gives the cap square sum with single-packet
spacetime volume \(h^3\). A spatial derivative costs \(h^{-1}\) and
an affine time derivative costs \(h^{-2}\). These are estimates for
the initial profiles, including their time cutoff derivatives, not a
free-evolution assertion.

For completeness the two derivative identities used here are
\[
 D_a=\partial_t+2a\partial_x-ia^2,\quad
 \mathcal L=iD_a+(\partial_x-ia)^2,\quad
 D_a-D_b=2(a-b)(\partial_x-ib)-i(a-b)^2.               \tag{19}
\]
The signs agree with the carrier \(e^{i(xa-ta^2)}\).

### Uniform retained-state bounds

Use precisely the marked-cell construction quoted above. Its
co-moving spatial derivatives cost \(\Delta\), and its co-moving
time derivatives cost \(\Delta^2\), at \(\Delta=\Delta_j\).
Their constants are independent of \(j\) and, before enlargement
constants are used, of \(K\). At a same-time peak all active masks
are identically one in a co-moving neighborhood, so \(\rho_a=0\)
there and all its derivatives vanish. Thus
\(|b_a|\leq\lambda\).

Summing the preceding projected pieces gives
\[
 \|c_a\|_\infty\leq CK\lambda,\qquad
 \|\mathcal Lc_a\|_\infty
                    \leq CC_1\lambda\Delta^2/K.      \tag{20}
\]
There are \(O(K)\) preceding normalized centers and the preceding
curvature scale is \((\Delta/K)^2\).
Where a mask derivative is nonzero there can be no same-time peak
within co-moving distance \(K/2\): such a peak would mark every active
time index and make every active enlarged cell function one locally.
A cap reproducing kernel, split inside and outside that neighborhood,
then gives
\(|(\partial_x-ia)c_a|\leq C\Delta\lambda\) there.
Inside use \(|c_a|\leq\lambda\); outside use (20) and rapidly
decreasing kernel tails, choosing the decay order greater than two.
The product rule yields
\[
 \|\mathcal Lb_a\|_\infty
                 \leq C\lambda\Delta^2(1+C_1/K).
 \tag{21}
\]
Applying the outer projection has bounded kernel norm. Choose \(C_1\)
first, then \(K\) sufficiently large, to close the curvature induction.

The higher affine bounds needed here are only \(r=1,2\).
After expressing \(D_a^r\) on a preceding center using (19), the
top-order old term has normalized coefficient
\(CK^{1-2r}\) in supremum norm, and
\(CK^{1/2-2r}\) in the center-integrated \(L^2\) norm.
For the latter, Cauchy--Schwarz in the old-center window costs
\(\sqrt K\), and the new-center window for each fixed old center
has normalized measure \(O(1)\).
All other terms use a smaller affine derivative order, with powers
of \(|a-b|\lesssim\Delta\); spatial derivatives of projected old
pieces cost the old cap width. Derivatives falling on \(\rho_a\)
also use strictly lower field derivative order.
The top coefficients are less than one for fixed large \(K\).
Induction first in \(r\), then in stage number, gives
\[
 \|D_a^rP_ab_a\|_\infty\leq C_{r,K}\lambda\Delta^{2r},
 \qquad
 \int\|D_a^rP_ab_a\|_2^2\,\frac{da}{\Delta}
                           \leq C_{r,K}\Delta^{4r}D. \tag{22}
\]
The order-zero \(L^2\) input is frame contraction, not a triangle
inequality accumulating over stages. Spatial Bernstein applies
after the outer projection. Resolve \(g_j=\int P_ab_a\,da/\Delta\)
into lattice caps; the participating centers have normalized measure
\(O(1)\). Expanding \(\mathcal L^q\) using (19), (22), and spatial
Bernstein proves (T1) for \(q\leq2\). It also gives the incoming
mixed derivative suprema for \(c_a\) through those orders.

### Loss-sensitive source bounds, including mask activation

Fix a marked cell and one of its marking slabs. There is a peak
\(|c_a(x_0,t_0)|>\lambda\) in that cell during the open slab.
At any comparison time \(t\) in the same slab, use Duhamel for
\(\mathcal Lc_a\), with a smooth cap cutoff equal to one on the
spatial supports of both \(c_a\) and \(\mathcal Lc_a\).
The time difference is \(O(\Delta^{-2})\).
In co-moving coordinates the propagator kernel has \(L^1\) norm
\(O(1)\), \(L^2\) norm \(O(\sqrt\Delta)\), and arbitrarily decreasing
tails at scale \(\Delta^{-1}\). The source term from (20) is at
most \(CC_1\lambda/K\).
The main contribution outside co-moving distance \(K/2\) is
negligible, again by (20) and kernel tails.
For sufficiently large fixed \(K\), the local main contribution
has modulus at least \(c\lambda\). Cauchy--Schwarz gives
\[
 \int_{\text{that fully marked neighborhood}}|c_a(x,t)|^2\,dx
                                     \geq c\lambda^2/\Delta.       \tag{23}
\]
This holds at **every** comparison time in the slab, not just at
the peak time, and explicitly permits \(\mathcal Lc_a\ne0\).

Let \(u=1-\rho_a=\sum_e\chi_em_e\). Since \(0\leq u\leq1\),
\(1-\rho_a^2=2u-u^2\geq u\). In the inner times where a given
\(\chi_e\) is bounded below, its fully marked neighborhood has
\(m_e=1\). Integrating (23) over those inner times gives
a charge \(c\lambda^2\Delta^{-3}\) to \(\int L_a\).
Each activated enlarged cell/slab has volume \(O_K(\Delta^{-3})\).
The enlarged neighborhoods overlap \(O_K(1)\) times, including
across the bounded-overlap time partition.
It follows that the union of activated cells, counted slab by slab
and including every mask-derivative support, has volume at most
\[
                         C_K\lambda^{-2}\int L_a.   \tag{24}
\]
On that set the mixed derivatives of \(d_a=(1-\rho_a)c_a\)
are bounded by \(C_{K,r,s}\lambda\Delta^{s+2r}\), and off that
set they vanish. Thus, for the finite list needed,
\[
 \|(\partial_x-ia)^sD_a^r d_a\|_1
       \leq C_{K,r,s}\Delta^{s+2r}\lambda^{-1}\int L_a.             \tag{25}
\]
For \(\mathcal L^q d_a\), \(q\leq2\), the expansion in (19)
needs only \(r\leq2\), \(s\leq4\), \(s+2r\leq4\).
Because \(R_j=\int P_ad_a\,da/\Delta_j\), its outer projection
meets \(O(1)\) lattice caps per fixed synthesis center and has
bounded \(L^1\) kernel. Sum the cap norms and integrate (25)
in \(a\). This proves (T2), with precisely \(l_j\), not \(D\)
or an uncharged volume.

Finally the tight-frame analysis is an isometry and synthesis is
its adjoint contraction. Since
\(|d_a|^2\leq L_a\),
\[
 \|g_j\|_2^2\leq\|g_{j-1}\|_2^2-l_j,\qquad
                         \sum_jl_j\leq D.           \tag{26}
\]
All operations are spatial multipliers or multiplication by the
actual smooth masks. The original bounded time support is retained;
it was used for initial packet counts, never as temporal Fourier
support. For a finite array, the initial frequency-layer decay can
be chosen to give the finitely many spatial and temporal \(L^1\)
derivatives needed for Fourier inversion. Compact outer frequency
support and fixed-order polynomial kernel decay preserve these
properties at every finite stage. Thus the global identities used
in Theorem T are justified for these fields, not just for abstract
solutions.

Combining (T3) with (26) gives exactly the quoted manuscript assertion
\[
 |\operatorname{Err}_j|\lesssim_K\lambda^2
 \left[(\Delta_0/\Delta_{j-1})^2D+
       \sum_{m<j}(\Delta_m/\Delta_{j-1})^2l_m\right]
 \quad\text{(`eq:src21')}.
\]
Combining (T4) with (26) gives exactly
\[
 \sum_{j=1}^n\int_{\mathbb R^2}(G_j-G_{j-1})(u)
       |\widehat{|g_{j-1}|^2}(u,\tau)|^2\,du\,d\tau
             \lesssim_K\lambda^2D
 \quad\text{(`eq:src22')}.
\]
The constants absorb only the fixed cap/profile/mask constants and
the chosen \(K\). This is the asserted scale-uniform verification,
subject to independent reading of the analytic proof.

## What the executable and formal certificate do not say

The executable checks the quoted source anchors, the quartet and
Gaussian completion identities, the rank-two quotient factorization,
potential expansion and telescoping, the exact dyadic and geometric
recurrences, rational reciprocal-square comparisons and offset
majorants, and the preserved Jacobian typed result. The accompanying
Lean declarations quantify over arbitrary finite depths; they are
not a bounded numerical search.

Neither executable nor Lean formalizes Holder, the Fourier-kernel
estimate, Duhamel persistence, or the cap-norm inductions.
Those are proved above and require independent mathematical review.
The full endpoint convergence theorems, the other frame arguments,
and any publication/novelty judgement remain unverified here.
No false manuscript assertion has been established, so this route
creates no `F_` refutation claim.

The exact replay is
`python3 research/quartic-core/verify.py`.
It also verifies that the retained compiler record matches both the
Lean source and its statement-fidelity document. A fresh formal replay is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/quartic-core/lean/Main.lean --statement-fidelity research/quartic-core/lean/statement_fidelity.md --claim C_Q_SERIES_CORE --project-root .
```

The recorded Lean 4.31.0 run has `exit_code=0`, `proof_holes=[]`,
and no evidence-recording refusals. Only `C_Q_SERIES_CORE` earned
`closed_kernel`; the analytic theorem has not thereby earned a
kernel proof or an independent Reviewer judgement.

The initial general web query returned predominantly unrelated
Gaussian-potential physics papers and provides no novelty evidence.
Primary retrieval of Guth--Maldague--Wang, arXiv:2009.07953, Theorems
1.1-1.2, gives a polylogarithmic decoupling estimate for parabola
neighborhoods, not this smooth-defect theorem. Primary retrieval of
Li--Yung, arXiv:2609.33949v1, Theorems 1.1-1.2, gives rational
curve additive-energy/discrete-restriction estimates. These retrieved
statements are related background, not imported proof steps and not
an exhaustive originality check.

## Jacobian applicability

The authorized adapter reports Jacobian 0.14.0 over MCP stdio, protocol
2025-11-25. The initial analytic query returned unrelated finite
Fourier/topology/conic operations; the inspected conic contract requires
a smooth rational conic and cannot decide this analytic estimate.
The subsequent polynomial factorization contract can check only the
quartet's polynomial core. Its payload and typed output are preserved
separately. No Jacobian operation discovered here certifies an
infinite-dimensional norm estimate.
