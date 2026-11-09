# A sixth-energy saving for zeta zeros and a local ordinary-prime window bound

## Abstract

We establish an unconditional fixed-power improvement for the ordered sixth
additive energy of zeta zeros on a fixed neighborhood of real part \(7/8\).
A short mollified zero detector supplies a large value at every zero in that
neighborhood. Inserting one such large value into the sextuple relation and
retaining the weights of triple-sum multiplicity classes gives a fifth-ratio
inequality and a self-referential sixth-ratio bound. Their combination saves
\(1/200\) over the density/fourth-energy exponent. The centered ordinary-prime
transfer then gives an exceptional-pair exponent \(19/15-1/10000\) for lengths
whose exponent lies within \(1/1000000\) of \(5/12\).

This is a local unconditional theorem. It neither constructs a counterexample
to the Second Hardy-Littlewood Conjecture nor resolves that conjecture
globally.

## 1. Definitions and statements

Let \(\pi(u)\) count the positive primes at most the real number \(u\), and put
\[
 V(N,H)=\#\{(n,h)\in\mathbb Z^2:
       N\le n<2N,\ H\le h<2H,\
       \pi(n+h)>\pi(n)+\pi(h)\}.
                                                               \tag{1.1}
\]
Here \(N,H\) are positive dyadic integers. In particular, (1.1) counts
every integer length in \([H,2H)\), not just the dyadic length \(H\).

For \(T\ge2\), let \(Z(\sigma,T)\) be the indexed multiset of nontrivial
zeros \(\rho=\beta+i\gamma\) of \(\zeta\) with
\(\beta\ge\sigma\) and \(|\gamma|\le T\), counting multiplicity. Define
\[
 E_{2k}(\sigma,T)=
 \#\{(\rho_1,\ldots,\rho_{2k})\in Z(\sigma,T)^{2k}:
   |\gamma_1+\cdots+\gamma_k-\gamma_{k+1}-\cdots-\gamma_{2k}|
                                                        \le1\}.
                                                               \tag{1.2}
\]
All tuples are ordered; repeated indices and negative ordinates are included.
The notation \(E_{2k}^{(b)}(A)\) replaces the tolerance one by \(b\) for
an indexed multiset \(A\) of real ordinates.

Set
\[
 s_L=\frac78-\frac1{1000},\qquad
 s_U=\frac78+\frac1{1000},
\]
\[
 d(\sigma)=
 \begin{cases}
  3(1-\sigma)/(2\sigma),&s_L\le\sigma\le7/8,\\
  3(1-\sigma)/(10\sigma-7),&7/8\le\sigma\le s_U,
 \end{cases}
 \qquad e_4(\sigma)=\frac{12(1-\sigma)}{4\sigma-1}.        \tag{1.3}
\]

**Theorem 1 (sixth zero energy).** For every \(\epsilon>0\),
\[
 E_6(\sigma,T)\ll_\epsilon
 T^{\,2d(\sigma)+e_4(\sigma)-1/200+\epsilon}
       \quad(s_L\le\sigma\le s_U),                       \tag{1.4}
\]
uniformly in \(\sigma\) and \(T\ge2\).

**Theorem 2 (ordinary-prime windows).** For every \(\epsilon>0\),
\[
 V(N,H)\ll_\epsilon N^{\,19/15-1/10000+\epsilon}
 \quad\text{if}\quad
 \left|\frac{\log H}{\log N}-\frac5{12}\right|
                                              \le\frac1{1000000}, \tag{1.5}
\]
uniformly for all sufficiently large dyadic \(N,H\).

At \(\sigma=7/8\), the density/fourth-energy bound
\(E_6\ll |Z|^2E_4\) has exponent \(36/35\); (1.4) replaces it by
\(1433/1400\). The relevant previously reviewed local prime-window
comparison has exponent \(19/15\), not the weaker density-only \(31/24\).
Theorem 2 improves that local comparison by \(1/10000\).

## 2. Known inputs and their ranges

The following inputs are unconditional and are not new results of this work.

From [B2, Theorem 5, equation (0.5)],
\[
 |\zeta(1/2+it)|\ll_\epsilon
                    (1+|t|)^{13/84+\epsilon}.           \tag{2.1}
\]
The exponent here is the statement in the version-2 PDF, rather than
the older exponent appearing in registry metadata.

The density rows and the classical fourth-zero-energy estimate in
[GT1, Table 1 and Section 3] give, on \([s_L,s_U]\),
\[
 |Z(\sigma,T)|\ll_{\sigma,\epsilon}T^{d(\sigma)+\epsilon},
 \qquad
 E_4(\sigma,T)\ll_{\sigma,\epsilon}T^{e_4(\sigma)+\epsilon}.
                                                               \tag{2.2}
\]
Section 3 supplies the fourth-energy row on \(3/4<\sigma<1\);
we do not extend a narrower table entry by changing its stated range.
Uniformity on the compact interval is obtained by a finite monotonicity
grid, with arbitrarily small exponent loss.

For a 1-separated set \(U\) in an interval of length \(T\), the
Heath-Brown difference-set estimate as stated in [GM2, Theorem 1.6]
bounds the second moment of a common Dirichlet polynomial over \(U-U\):
\[
 \sum_{u,v\in U}|Q(u-v)|^2
 \precsim |U|^2L+|U|L^2+|U|^{5/4}T^{1/2}L,
 \quad Q(t)=\sum_{n\sim L}c_n n^{it},\quad |c_n|\le1.    \tag{2.3}
\]
Throughout, \(\precsim\) allows an arbitrary \(T^\epsilon\) loss.
The estimate is uniform in the common coefficient sequence, including
\(c_n=n^{is}\). We use (2.3) and [GM2, Lemma 11.6], not the distinct
large-value Proposition 11.1 with its \(T^{3/4}\)-scale length hypothesis.

The detector below uses the mollified Mellin method described in
[MP1, Appendix C]. The real-part removal uses Fourier inversion as in
[GM2, Section 13.1]. The quantitative PNT, relative-window explicit formula,
and low/high-real-part zero treatments are the same unconditional inputs
used in [GT1, Lemmas 2.1-2.4] and the accompanying centered prime-marker
derivation.

## 3. A short detector at every zero

For a zero \(\rho=\beta+i\gamma\) with \(\gamma\in[T,2T]\) and
\(\beta\ge s_L\), take
\[
 X=2T^{1/1000},\quad Y=T^{5/12},\quad
 M(s)=\sum_{m\le X}\mu(m)m^{-s},\quad
 a(n)=\sum_{\substack{m\mid n\\m\le X}}\mu(m).
\]
Mellin inversion followed by a shift to \(\Re w=1/2-\beta\) gives
\[
 \sum_{n\ge1}a(n)n^{-\rho}e^{-n/Y}
 =Y^{1-\rho}\Gamma(1-\rho)M(1)
  +\frac1{2\pi i}\int_{(1/2-\beta)}
       Y^w\Gamma(w)M(\rho+w)\zeta(\rho+w)\,dw.           \tag{3.1}
\]
The zero at \(\rho\) cancels the gamma pole at \(w=0\), also for a
multiple zero. The crossed zeta pole is at \(w=1-\rho\); the next
gamma pole, at \(-1\), is to the left of the new contour.
The residue in (3.1) is exponentially small.

On the new line, \(|M(1/2+iv)|\ll X^{1/2}\). Equation (2.1) and
Stirling's estimate therefore bound the integral in (3.1) by
\[
 T^{13/84+1/2000-(5/12)(\beta-1/2)+\epsilon}
                      \le T^{-1/1750+\epsilon}.         \tag{3.2}
\]
The real parts of the gamma arguments remain in a compact interval
away from its poles. When \(|\Im w|>T/2\), gamma decay controls the
integral without assuming that the critical-line height is comparable
to \(T\).

We have \(a(1)=1\), \(a(n)=0\) for \(1<n\le X\), and
\(|a(n)|\le d(n)\). Truncating at \(Y(\log T)^2\) has error
\(O(T^{-100})\). Fixing the source epsilon below \(1/3500\) in
(3.2), one obtains
\[
 \left|\sum_{X<n\le Y(\log T)^2}
              a(n)n^{-\rho}e^{-n/Y}\right|\ge\frac12.    \tag{3.3}
\]
Thus every zero under consideration is detected by a dyadic polynomial
of length \(L=T^{\lambda+o(1)}\) with
\(1/1000\le\lambda\le5/12\). There is no remaining Type-II population.

For \(\beta\ge\sigma\), Fourier inversion of a smooth cutoff times
\(e^{(\sigma-\beta)u}\), on \(u\in[\log L,\log(2L)]\), removes the
varying real part. For any fixed arbitrarily small \(a>0\), it supplies
a shifted point \(t_\rho=\gamma+O(T^a)\) at which a common polynomial
in its assigned dyadic class has coefficients of size \(T^{O(a)}\)
and modulus at least \(L^\sigma T^{-O(a)}\).
The Fourier tails have arbitrarily rapid decay, uniformly in the
indicated real-part ranges. The shifts will be accounted for explicitly;
they are not claimed to preserve energies exactly.

## 4. The fifth insertion and weighted sixth ratio moment

Let \(W\) be a 1-separated set in an interval of length \(T\), and set
\[
 D=|W|,\quad R(v)=\sum_{t\in W}v^{it},\quad
 {\cal M}_j(L)=\sum_{m,n\sim L}|R(m/n)|^j.
\]
Assume \(P(t)=\sum_{n\sim L}b_nn^{it}\), \(|b_n|\le1\), and
\(|P(t)|\ge L^\sigma\) on \(W\).

Choose a smooth compactly supported Fourier multiplier equal to one
on \([0,\log2]\), with inverse transform \(h\). Fourier inversion of
\(L^{-it}P(t)\) and Cauchy-Schwarz give
\[
 |P(t)|^2\le\int_{\mathbb R}K(s)|P(t-s)|^2\,ds,\qquad
 K(s)=\|h\|_1|h(s)|.
                                                               \tag{4.1}
\]
The kernel is nonnegative and rapidly decreasing. For each fixed \(b\),
\(K_b(s)=\sup_{|v|\le b}K(s+v)\) also has bounded integral,
independently of \(L\). All these integrals are over the whole line.

For each five entries of a tolerance-one sextuple there are \(O(1)\)
possible sixth entries in \(W\). Insert \(|P(t_6)|^2/L^{2\sigma}\)
and apply (4.1) with \(K_1\) at
\(t_1+t_2+t_3-t_4-t_5\). Expansion over the five free indices gives
\(R(m/n)^3R(n/m)^2\). Taking absolute values only after this expansion
yields
\[
                     E_6(W)\precsim L^{-2\sigma}{\cal M}_5(L).
                                                               \tag{4.2}
\]
This inserts a large value at an individual zero; it does not assume
that a triple sum of ordinates is itself a zero.

Lemma 11.6 of [GM2] gives
\[
 {\cal M}_4(L)\precsim
        D^4L+E_4(W)L^2+E_4(W)^{3/4}DT^{1/2}L=:F.       \tag{4.3}
\]
The weighted extension needed here is
\[
 {\cal M}_6(L)\precsim
        D^6L+E_6(W)L^2+E_6(W)^{3/4}D^{3/2}T^{1/2}L.   \tag{4.4}
\]
To prove it, group ordered triples by
\(u=\lfloor t_1+t_2+t_3\rfloor\), with representation count \(r_u\),
and let \(U_B=\{u:B\le r_u<2B\}\) for dyadic \(B\).
Separation gives \(r_u\ll D^2\), so there are \(O(\log(2D))\) bins.
Cauchy-Schwarz over these bins, expansion, and the two fractional
parts bound the sixth ratio moment by
\[
 T^\epsilon\sup_B B^2\sum_{u,v\in U_B}\sup_{|s|\le2}
             \left|\sum_{n\sim L}n^{i(u-v+s)}\right|^2.  \tag{4.5}
\]
The distinct integers \(U_B\) lie in an interval of length \(3T+O(1)\).
Apply (4.1) with \(K_2\), and then (2.3) for each common shift.
The coefficient sequence has modulus one and is common to all pairs.
Equation (4.5) is consequently at most
\[
 T^\epsilon\sup_B B^2
   \{|U_B|^2L+|U_B|L^2+|U_B|^{5/4}T^{1/2}L\}.
\]
The representation weights remain present:
\[
 B|U_B|\le D^3,\qquad B^2|U_B|\le\sum_ur_u^2\le E_6(W),
\]
\[
 B^2|U_B|^{5/4}
 =(B^2|U_B|)^{3/4}(B|U_B|)^{1/2}
                       \le E_6(W)^{3/4}D^{3/2}.
\]
These inequalities prove (4.4).

Finally, \({\cal M}_5\le({\cal M}_4{\cal M}_6)^{1/2}\). Substituting
(4.3)-(4.4) into (4.2) and absorbing the positive feedback powers gives
\[
 \begin{split}
 E_6(W)\precsim{}&
 F^{1/2}D^3L^{1/2-2\sigma}+FL^{2-4\sigma}\\
 &+F^{4/5}D^{6/5}T^{2/5}L^{4/5-16\sigma/5}.
 \end{split}                                                   \tag{4.6}
\]
The last absorption is \(E_6\precsim A E_6^{3/8}\), hence contributes
\(A^{8/5}\). It is not an independent cardinality estimate substituted
for a sixth energy.

## 5. Lengths, multiplicities, and the uniform saving

For an original detector length \(T^{\lambda+o(1)}\), choose the
smallest integer \(k\) with \(k\lambda\ge1/2\).
If \(\lambda\ge1/4\), then \(k=2\) and \(k\lambda\le5/6\).
If \(\lambda<1/4\), minimality gives
\(k\lambda<1/2+\lambda<3/4\). Thus \(2\le k\le500\) and
\[
                          1/2\le k\lambda\le5/6.        \tag{5.1}
\]
Powering the polynomial and splitting its support into \(O(k)\)
dyadic ranges costs only \(T^{o(1)}\) coefficient normalization,
by fixed-order divisor bounds. Every detected point is assigned
to a range retaining a large value.

The shifts in Section 3 put at most \(O(T^a\log T)\) original zero
indices in a unit interval, by the Riemann-von Mangoldt local count.
Coloring them into that many 1-separated classes retains all
multiplicities. The elementary occupancy estimate
\[
                  E_{2k}^{(b)}(A)\ll bE_{2k}^{(1)}(A)
                    \quad(b\ge1,\ k=2,3)                \tag{5.2}
\]
follows by partitioning \(k\)-fold sums into half-unit intervals and
using Cauchy-Schwarz on translated occupancy profiles.
It bounds each shifted fourth energy by \(T^{O(a)}\) times the
original fourth energy, and each original sextuple relation by a
shifted relation of tolerance at most \(1+6T^a\).

A nonnegative Fejer weight with tent Fourier transform supported
on \([-2,2]\) makes its \(L^6\) integral comparable to tolerance-one
sixth energy, using (5.2). Minkowski then gives, for indexed unions,
\[
 E_6\left(\bigsqcup_{j=1}^K A_j\right)
                          \ll K^5\sum_{j=1}^K E_6(A_j). \tag{5.3}
\]
This retains mixed sextuples between different classes.
Polynomial ranges, colors, positive and conjugate negative height
classes, and the bounded-height multiset are all included.
Their total losses are \(T^{O(a)+o(1)}\), with \(a\) arbitrarily small.

For \(L=T^{\lambda+o(1)}\) in (5.1), use (2.2) in (4.6). Put
\[
 A=\max\{4d+\lambda,\ e_4+2\lambda,\
                         3e_4/4+d+1/2+\lambda\}.
\]
The three exponents in (4.6) are
\[
 q_1=A/2+3d+(1/2-2\sigma)\lambda,\quad
 q_2=A+(2-4\sigma)\lambda,
\]
\[
 q_3=4A/5+6d/5+2/5+(4/5-16\sigma/5)\lambda.             \tag{5.4}
\]
Expanding the three branches of \(A\) gives nine affine gaps
\(2d+e_4-q_j\). Eight have positive \(\lambda\)-coefficient on
\([s_L,s_U]\). Evaluate those at \(\lambda=1/2\), using the
appropriate endpoint bounds for the decreasing functions \(d,e_4\).
The remaining gap is treated with its correlated density formula.
The resulting rigorous lower bounds are

| Branch of \(A\) | Gap for \(q_1\) | Gap for \(q_2\) | Gap for \(q_3\) |
|---|---|---|---|
| \(4d+\lambda\) | \(21851297/68390500\) | \(7005836/17097625\) | \(23394344/85488125\) |
| \(e_4+2\lambda\) | \(3502918/17097625\) | \(31/3300\) | \(371589/4303750\) |
| \(3e_4/4+d+1/2+\lambda\) | \(2924293/17097625\) | \(371589/3443000\) | \(7062/195625\) |

In particular, writing \(d=(1-\sigma)A_{\rm den}(\sigma)\),
the middle entry is
\[
 2d-4(1-\sigma)\lambda
 =2(1-\sigma)(A_{\rm den}(\sigma)-2\lambda)
 \ge2(1-s_U)(A_{\rm den}(s_U)-5/3)=31/3300.             \tag{5.5}
\]
The two density formulas agree at \(7/8\), and \(A_{\rm den}\)
decreases. All nine gaps exceed \(1/200\).

Choose the arbitrary normalization, shift, and source losses below
the residual gap and the prescribed final epsilon. A finite
monotonicity grid on the compact sigma interval makes the implied
constants uniform, costing arbitrarily little in the exponent.
Equations (3.1)-(5.5) prove Theorem 1.

## 6. The exact ordinary-prime transfer

Write \(\ell=\log N\), \(\theta=\log_N H\), and retain
\[
 \delta_0=\frac{H}{N\ell^3},\quad
 d_{\rm grid}=\left\lfloor\frac{H}{\ell^7}\right\rfloor,\quad
 \delta_1=e^{-\sqrt\ell},\quad \alpha=\delta_0/\delta_1.
\]
The quantitative PNT for \(\pi(h)\), with \(\theta\) in the
specified neighborhood of \(5/12\), shows that a violating interval
has a fixed positive ordinary-prime surplus over
\(\int_n^{n+h}dt/\log t\).
Partition it into relative \(\delta_0\)-windows and one shorter
remainder. The remainder costs \(O(\delta_0N+1)=o(h/\ell)\);
one full window has positive surplus. Rounding its start upward
to \(b=d_{\rm grid}m\) costs \(O(d_{\rm grid}+1)\), below the
surplus threshold. The long-window PNT therefore produces a marker
\[
 \int\kappa_b\,d\pi\ge c\delta_0N/\ell,\quad c=1/100,
 \quad
 \kappa_b={\bf1}_{(b,b(1+\delta_0)]}
                     -\alpha{\bf1}_{(b,b(1+\delta_1)]}. \tag{6.1}
\]
Use the first successful relative window to make the assignment
definite. For a fixed marker and window index, at most
\(d_{\rm grid}+1\) integers \(n\) are possible. There are \(H\)
integer lengths and \(O(\ell^3)\) indices. Consequently, with \(R\)
the number of markers,
\[
                              V(N,H)\ll H^2R.           \tag{6.2}
\]

The constant-density integral of \(\kappa_b\) vanishes, while
\[
 0\le\int\kappa_b(t)\frac{dt}{\log t}
                   \ll\delta_0\delta_1N/\ell^2.
\]
Thus centering preserves the original positive event with a smaller
fixed threshold. It is not an assertion of prime-diagonal cancellation.
The exact ordinary-prime identity is
\[
 d\pi-\frac{dt}{\log t}
 =\frac{d\psi-dt}{\log t}-d\nu_{\rm pp},\qquad
 d\nu_{\rm pp}=\sum_{p^k,\ k\ge2}\frac1k\delta_{p^k}.    \tag{6.3}
\]
Replacing \(1/\log t\) by \(1/\log b\) separately in the two
windows costs \(O(\delta_0(\delta_0+\delta_1)N/\ell)\).
The short prime-power correction is \(O(\ell)\); the scaled long
one is \(O(\delta_0\sqrt N\,\ell+\alpha\ell)\).
The scaled long-window PNT error is also negligible. Hence
\[
 \int\kappa_b(d\pi-dt/\log t)
  =\frac{\psi(b(1+\delta_0))-\psi(b)-b\delta_0}{\log b}
                                      +o(\delta_0N/\ell). \tag{6.4}
\]
All deterministic errors are removed before Markov's inequality.
An \(o(1)\) error is not counted as an exponent saving.

Choose the explicit-formula cutoff \(T=J\ell^2/\delta_0
=N^{1-\theta+o(1)}\), with fixed \(J\) sufficiently large.
The zero coefficients are
\[
 c_\rho=\frac{(1+\delta_0)^\rho-1}{\rho}
       =\int_0^{\delta_0}(1+v)^{\rho-1}\,dv,\qquad
 |c_\rho|\le\delta_0.                                   \tag{6.5}
\]
Truncation costs \(O(N\ell^2/T)\), and half-open jump endpoints
cost \(O(\ell)\), both below a prescribed fraction of the threshold.
For a real-part slice \(I\subset[\sigma_-,\sigma_+]\), expansion
against a smooth spatial majorant gives
\[
 \frac1N\int_N^{2N}
 \left|\sum_{\substack{\beta\in I\\|\gamma|\le T}}c_\rho b^\rho
       \right|^6\,db
             \ll\delta_0^6N^{6\sigma_+}E_6(\sigma_-,T).  \tag{6.6}
\]
Repeated integration by parts gives a decaying kernel in the signed
sum of the six ordinates. Schur's test on the triple-sum occupancy
profile bounds that kernel by the tolerance-one sixth energy.
All frequencies and cross-block terms are present.

Endpoint motion over a grid cell is \(O((d_{\rm grid}+1)\ell)
=o(\delta_0N)\). Disjoint cells therefore lift the marker count
to real exceptional measure. Combining this lift with (6.2) retains
the factor \(H^2/d_{\rm grid}=H\ell^{7+o(1)}\). If an energy
exponent is \(e_6(\sigma)\), the resulting pair budget is
\[
              f_6(\theta,\sigma)
               =\theta+6\sigma-5+(1-\theta)e_6(\sigma).  \tag{6.7}
\]
The second and fourth moments give the corresponding budgets
\[
 f_2=\theta+2\sigma-1+(1-\theta)d(\sigma),\qquad
 f_4=\theta+4\sigma-3+(1-\theta)e_4(\sigma).              \tag{6.8}
\]

## 7. Complete local cover and comparison

Inside \([s_L,s_U]\), substitute Theorem 1 into (6.7), with
\(\delta=1/200\). Its sigma derivatives are
\[
 \begin{cases}
 6-(1-\theta)\{3/\sigma^2+36/(4\sigma-1)^2\},&\sigma<7/8,\\
 6-(1-\theta)\{18/(10\sigma-7)^2+36/(4\sigma-1)^2\},&\sigma>7/8.
 \end{cases}
\]
They are positive on the left rectangle and negative on the right
rectangle when \(|\theta-5/12|\le1/1000000\). The maximum is
therefore at \(\sigma=7/8\). At that point,
\[
 e_6=\frac{1433}{1400},\qquad
 \max_\theta f_6
 =\frac{19}{15}-\frac7{2400}+\frac{33}{1400000000}
 =\frac{1769250033}{1400000000}
                         <\frac{37997}{30000}
                         =\frac{19}{15}-\frac1{10000}.  \tag{7.1}
\]

For completeness, the unchanged outside-neighborhood cover is as follows.
For \(0\le\sigma\le1/2\), the second moment and the local zero count
have budget at most one. Between \(1/2\) and \(s_0=3831/4791\),
the source-qualified density subcover uses these exponents
\(d=(1-\sigma)A_{\rm den}(\sigma)\):

| Sigma interval | \(A_{\rm den}(\sigma)\) |
|---|---|
| \([1/2,7/10]\) | \(3/(2-\sigma)\) |
| \([7/10,13/17]\) | \(15/(3+5\sigma)\) |
| \([13/17,25/32]\) | \(6/(5\sigma-1)\) |
| \([25/32,11/14]\) | \(2\) |
| \([11/14,s_0]\) | \(9/(7\sigma-1)\) |

Each second-moment budget has its maximum at the relevant sigma
endpoint and at \(\theta_+=5/12+1/1000000\); those budgets are
strictly below the target in (7.1).
On \([s_0,s_L]\), the fourth-energy budget is convex in sigma and
affine in theta. Its four rectangle corners are also strictly below
the target.

On \([s_U,279/314]\), the legitimate density row
\(A_{\rm den}=3/(10\sigma-7)\) gives uniform pointwise removal:
\[
 1-(1-\theta_-)A_{\rm den}(s_U)>0,\qquad
 \theta_-=\frac5{12}-\frac1{1000000}.
\]
On \([279/314,155/174]\), zero-count monotonicity from
\(\sigma_0=111/125\), where \(d(\sigma_0)=42/235\), gives the
previously established power margin \(923/204450\) on the larger
closed length band containing ours.
The following high-real-part density rows are used only on their
recorded source-qualified intervals:

| Sigma interval | \(A_{\rm den}(\sigma)\) |
|---|---|
| \([155/174,49/54]\) | \(24/(30\sigma-11)\) |
| \((49/54,15/16]\) | \(2/(7\sigma-5)\) |
| \((15/16,23/24]\) | \(4/(30\sigma-25)\) |

They have \(A_{\rm den}\le29/19\), hence retain a fixed removal
margin. Above \(23/24\), use the same compact \(A_{\rm den}\le3/2\)
treatment and the moving near-one zero-free argument of
[GT1, Lemma 2.1]. The latter is \(o(1)\) relative to the marker
threshold; no fixed source epsilon is divided by \(1-\sigma\).

These are the complete outside-neighborhood transfers in the
accompanying proof, not out-of-range extensions of published tables.
Their strict buffers are unchanged when the sixth-energy saving
is replaced by \(1/200\). Finite sigma-grid and source-epsilon
losses are chosen below the buffers and the final epsilon.
Equations (6.1)-(7.1) prove Theorem 2.

The comparison is with the full inspected density/fourth-energy
envelope. Inside the new neighborhood the fourth budget is below
the second. Moreover,
\[
 f_6-f_4
 \le 2(1-s_L)\max\{0,(1-\theta_-)A_{\rm den}(s_L)-1\}
                       -(1-\theta_+)/200<-1/500.        \tag{7.2}
\]
Outside it, all applicable previous inputs remain available by
taking minima. Thus the improvement is pointwise on the new
neighborhood and yields the stated local pair exponent.

## 8. Scope and source comparison

The new ingredient is the all-zero short detector together with the
weighted fifth/sixth ratio closure. The general inequality
\(E_6\ll D^2E_4\) alone does not supply (1.4). The accompanying
Sidon/digital model explains the sharpness of that generic deduction;
it is not a model of actual zeta zeros or evidence against Theorem 1.

The source comparison is qualified by the literature actually inspected.
[TTY1, Table 2, Theorem 53, and the energy row preceding Theorem 63]
does not improve (1.3) on this neighborhood. Its Theorem 64 concerns
fourth energy, and every clause ends at or below \(5/6\).
[C1, Theorem 1.4] gives weaker full-zero density exponents at modulus
one here; Proposition 10.1 is a character-labelled large-value-set
fourth-energy theorem with an explicit polynomial-length hypothesis,
not an as-stated sixth-energy or full-zero fourth-energy improvement.
Neither is extrapolated outside its hypotheses.

This supports the scoped comparison made here, not exhaustive literature
optimality. The earlier independent scholarly review accepted a
verified-new publishable local theorem against these inspected primary
sources; the mathematical assertions of this manuscript have the same
constants and scope. Final publication-level certification is a separate
independent verdict, not a consequence of the arithmetic replay.

No global estimate for the total number of exceptional pairs follows from
the local length band alone. No explicit pair with positive prime-count
excess is produced, and the global Second Hardy-Littlewood Conjecture
remains unresolved.

## References and accompanying derivations

- [B2] J. Bourgain, [arXiv:1408.5794v2](https://arxiv.org/pdf/1408.5794v2),
  Theorem 5, equation (0.5): the \(13/84\) critical-line exponent.
- [GM2] L. Guth and J. Maynard,
  [arXiv:2405.20552v2](https://arxiv.org/pdf/2405.20552v2),
  Theorem 1.6, Lemma 11.6, and Section 13.1: the difference-set
  estimate, fourth ratio moment, and real-part removal. Theorem 1.6
  is the source-qualified statement of the Heath-Brown input used here.
- [GT1] A. Gafni and T. Tao,
  [arXiv:2505.24017v1](https://arxiv.org/pdf/2505.24017v1),
  Table 1, Lemmas 2.1-2.4, Section 3, and the remark on page 13:
  density, ordinary short-window moments, fourth zero energy,
  and the higher-energy comparison. The original 1979
  Heath-Brown fourth-zero-energy article was not obtained; its
  proposition is used through this explicitly identified source.
- [MP1] J. Maynard and K. Pratt,
  [arXiv:2206.11729v1](https://arxiv.org/pdf/2206.11729v1),
  Appendix C, pages 49-50: the mollified Mellin zero detector.
- [TTY1] T. Tao, T. Trudgian, and A. Yang,
  [arXiv:2501.16779v1](https://arxiv.org/html/2501.16779v1),
  Table 2, Theorem 53, the energy row before Theorem 63, and
  Theorem 64: the source-qualified later comparison.
- [C1] B. Chen,
  [arXiv:2507.08296v1](https://arxiv.org/html/2507.08296v1),
  Theorem 1.4, equation (1.4), and Proposition 10.1:
  density and the separately hypothesized large-value fourth energy.

The accompanying [zero-detector derivation](../sixth-order-prime-window-improvement-v1/zero-detector.md)
contains the same new analytic proof and parameter calculations.
The [sixth-moment transfer](../sixth-order-prime-window-improvement-v1/sixth-energy.md),
Sections 3-4, is used only for the unchanged transfer and outside-band
cover; its earlier unproved \(1/35\) antecedent is replaced here by
the proved \(1/200\) in Theorem 1.
The [centered marker derivation](../centered-prime-marker-dispersion-v1/centered-marker.md),
Sections 1 and 7, fixes the centering and source-range bridge, and
the [spatial assignment](../sub-square-root-surplus-duality-v1/surplus-duality.md),
Section 4, fixes the ordinary-prime event and integer-length multiplicity.
Their historical progress labels do not change the assertions of this paper.
