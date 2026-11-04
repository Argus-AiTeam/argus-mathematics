# Zero detection and the sixth-energy bottleneck

An Engineer proof of the unconditional saving in
`O1518_S6_ZERO_SAVING_V1` is supplied below; independent acceptance
is still open.
The preceding independent Reviewer accepted the generic-data obstruction
and the complete conditional prime-window transfer. This continuation
does not repeat either proof or its finite certificate. It tests a
different input: a large-value zero detector at each individual zero.

## Primary-source scope

The bounded independent source investigation found no verified
unconditional sixth-energy estimate. It inspected three primary sources:

- Maynard-Pratt, arXiv:2206.11729v1, Appendix C, pages 49-50, reproduces
  the mollified Mellin zero detector and its Type-I/Type-II alternative.
- Guth-Maynard, arXiv:2405.20552v1, Lemma 11.4 and Proposition 11.1,
  proves a discrete cubic ratio-moment bound for fourth energy. It does
  not state a sixth-energy theorem.
- Gafni-Tao, arXiv:2505.24017v1, page 13 and Section 3, gives the
  previously read higher-energy limitation and fourth-energy
  transcription. This source is reused, not looked up again here.

The campaign also already carries Guth-Maynard
`../exceptional-pair-large-deviations-v1/literature/guth-maynard-v2.pdf`
and its text. The v2 text is dated 7 April 2026. The relevant locators
actually read in this continuation are Lemmas 11.3-11.5, Proposition 11.1
and its proof, and Section 13.1. Version numbers are kept separate;
an equation's page number from v1 is not silently applied to v2.
The original Heath-Brown 1979 fourth-zero-energy article was not obtained;
its failed publisher URL was not retried.

A separate bounded originality lookup found no matching explicit
unconditional sixth-energy statement. It also identified two later
source-qualified comparisons. Tao-Trudgian-Yang,
arXiv:2501.16779v1, Table 2 and the energy row preceding Theorem 63,
retain exactly the reviewed \(d,e_4\) on \([0.874,0.876]\).
Every clause of its Theorem 64 stops at or below \(5/6\).
Bin Chen, arXiv:2507.08296v1, Theorem 1.4 gives weaker full-zero
density bounds at modulus one; its Proposition 10.1 is a
large-value-set fourth-energy theorem with
\(T^{3/4}/2\le L\le2T\), not a bound for the full zero multiset.
At \(7/8\), the additional density exponents are \(11/48\),
\(4/15\), \(7/24\), and \(3/13\), all greater than \(3/14\).
No extrapolation of an energy clause outside its sigma range is used.
These primary-source readings support applicability of the reviewed
comparison, not exhaustive literature completeness or a verified-new
verdict.

Guth-Maynard's energy input labelled [HB] is *A large values estimate
for Dirichlet polynomials*. It is not the distinct article labelled
[HB3], *Zero density estimates for the Riemann zeta-function and
Dirichlet L-functions*. This distinction matters when attributing a
sixth-energy estimate that neither cited proposition states.

The scalar detector alternatives, the permitted polynomial lengths,
and the treatment of multiplicities must all be preserved before any
estimate on a large-value set can become a bound for the complete
zeta-zero sextuple count.

## 1. The source-qualified short cutoff

The version-stamped Bourgain PDF now in `bourgain-v2.pdf` gives
\[
 \zeta(1/2+it)\ll_\epsilon (1+|t|)^{13/84+\epsilon}
                                                               \tag{1}
\]
in Theorem 5, equation (0.5), arXiv:1408.5794v2. The registry abstract
still displayed \(53/342\); the PDF statement, not that metadata,
is the proposition used. This is a known unconditional input.

Fix
\[
 s_L=7/8-1/1000,\quad s_U=7/8+1/1000,\quad
 X=2T^{1/1000},\quad Y=T^{5/12},\quad
 M(s)=\sum_{m\le X}\mu(m)m^{-s},\quad
 a(n)=\sum_{\substack{m\mid n\\m\le X}}\mu(m).
\]
For a zero \(\rho=\beta+i\gamma\), with \(\gamma\in[T,2T]\) and
\(\beta\ge s_L\), Mellin inversion and a contour shift give
\[
 \sum_{n\ge1}a(n)n^{-\rho}e^{-n/Y}
 =Y^{1-\rho}\Gamma(1-\rho)M(1)
  +\frac{1}{2\pi i}\int_{\Re w=1/2-\beta}
          Y^w\Gamma(w)M(\rho+w)\zeta(\rho+w)\,dw.         \tag{2}
\]
The possible pole at \(w=0\) is cancelled by \(\zeta(\rho)=0\),
also for a multiple zero. The only crossed zeta pole is \(w=1-\rho\);
the next gamma pole is at \(-1\), to the left of the new contour.
The residue displayed in (2) is exponentially small for
\(\gamma\in[T,2T]\). On the new line
\[
 |M(1/2+iv)|\le\sum_{m\le X}m^{-1/2}\ll X^{1/2}.
\]
Stirling's bound for the gamma factor and (1) consequently give,
uniformly for \(s_L\le\beta<1\),
\[
 \left|\frac{1}{2\pi i}\int_{(1/2-\beta)}\cdots\,dw\right|
 \ll_\epsilon
 T^{13/84+1/2000-(5/12)(\beta-1/2)+\epsilon}
 \le T^{-1/1750+\epsilon}.                              \tag{3}
\]
For \(|\Im w|>T/2\), gamma decay controls the integral even though
the critical-line height is no longer comparable to \(T\).
The real part \(1/2-\beta\) stays in a compact interval disjoint
from the gamma poles, so its constants are uniform.

Now \(a(1)=1\), \(a(n)=0\) for \(1<n\le X\), and
\(|a(n)|\le d(n)\). Truncating the exponentially weighted series
at \(Y(\log T)^2\) has error \(O(T^{-100})\), after increasing \(T\).
Taking a fixed source epsilon below \(1/3500\), (2)-(3) imply
\[
 \left|\sum_{X<n\le Y(\log T)^2}
                  a(n)n^{-\rho}e^{-n/Y}\right|\ge1/2.    \tag{4}
\]
Thus every zero in this height range is Type I for this **changed**
detector; no Type-II population is discarded or bounded by a
cardinality estimate. One of \(O(\log T)\) dyadic polynomials in (4)
has modulus \(\gg1/\log T\). Their lengths have exponents between
\(1/1000+o(1)\) and \(5/12+o(1)\).

The usual Fourier removal of the real part, as in Guth-Maynard
Section 13.1, applies to each such dyadic polynomial separately.
More explicitly, insert a smooth cutoff times
\(e^{(\sigma-\beta)u}\) on \(u\in[\log L,\log(2L)]\), and use
Fourier inversion on its \(u\) variable. Its Fourier tails decrease
faster than any power, uniformly for \(\sigma\in[s_L,s_U]\) and
\(\beta\in[\sigma,1]\). A detected zero supplies a point
\(t_\rho=\gamma+O(T^a)\), for any fixed arbitrarily small \(a>0\),
where a polynomial with coefficients of size \(T^a\) and dyadic
length \(L\) has modulus \(\gg L^\sigma T^{-a}\).
The arbitrary \(a\) here is a loss parameter, not an additional
constant saving or a shift of an entire zero set asserted to
preserve exact energies.

## 2. The fifth insertion and a sixth discrete ratio moment

Let \(W\) be a 1-separated set in an interval of length \(T\), and put
\[
 D=|W|,\quad R(v)=\sum_{t\in W}v^{it},\quad
 {\cal M}_j(L)=\sum_{m,n\sim L}|R(m/n)|^j.
\]
Let \(E_j(W)\) use the tolerance-one ordered additive-energy convention.
The notation \(E_4\) and \(E_6\) below refers to energies, not
cardinalities of sets of distinct sums.

Suppose \(P(t)=\sum_{n\sim L}b_nn^{it}\), \(|b_n|\le1\), and
\(|P(t)|\ge L^\sigma\) on \(W\). The same band-limited smoothing
idea as Guth-Maynard Lemma 11.3 gives an exact majorant without
any polynomial-length restriction. Choose a smooth compactly
supported Fourier multiplier equal to one on \([0,\log2]\),
with inverse transform \(h\), and apply Fourier inversion to
\(L^{-it}P(t)\). Cauchy-Schwarz gives
\[
 |P(t)|^2\le\int_{\mathbb R}K(s)|P(t-s)|^2\,ds,\qquad
 K(s)=\|h\|_1|h(s)|.
\]
The nonnegative kernel is rapidly decreasing and its integral
is bounded independently of \(L\). For
\(K_b(s)=\sup_{|v|\le b}K(s+v)\), the same is true for every
fixed \(b\). The integrals below are over the whole real line;
no tail or frequency block is omitted.

In a sextuple relation the sixth entry is within
one of \(t_1+t_2+t_3-t_4-t_5\); for each five entries there are
only \(O(1)\) such sixth entries. Insert \(|P(t_6)|^2/L^{2\sigma}\),
use the common majorant with \(K_1\), and expand. The two
ratio factors are \(R(m/n)^3\)
and \(R(n/m)^2\), so the bounded coefficients give
\[
                       E_6(W)\precsim L^{-2\sigma}{\cal M}_5(L).
                                                               \tag{5}
\]
The integral of \(K_1\) is an absolute constant; (5) in fact
needs no smoothing epsilon. It is an individual-zero detector
insertion, not an
assumption that triple sums are zero ordinates.

Guth-Maynard Lemma 11.6 states
\[
 {\cal M}_4(L)\precsim
           D^4L+E_4(W)L^2+E_4(W)^{3/4}DT^{1/2}L.        \tag{6}
\]
Here and throughout, \(\precsim\) permits an arbitrary \(T^\epsilon\).
No restriction \(L\ge T^{3/4}\) belongs to that lemma; the restriction
belongs to the separate Proposition 11.1 and is not extended here.

The weighted argument in that lemma also yields
\[
 {\cal M}_6(L)\precsim
           D^6L+E_6(W)L^2+E_6(W)^{3/4}D^{3/2}T^{1/2}L. \tag{7}
\]
For completeness, group the \(D^3\) ordered triples according to
\(u=\lfloor t_1+t_2+t_3\rfloor\), with multiplicity \(r_u\), and
let \(U_B=\{u:B\le r_u<2B\}\), for dyadic \(B\).
Since \(W\) is separated, \(r_u\ll D^2\); there are only
\(O(\log(2D))\) nonempty multiplicity bins. Cauchy-Schwarz over bins,
expansion over two triple sums, and smoothing their two fractional
parts reduce the moment to
\[
 T^\epsilon\sup_B
 B^2\sum_{u,v\in U_B}\sup_{|s|\le2}
                  \left|\sum_{n\sim L}n^{i(u-v+s)}\right|^2.
\]
The set \(U_B\) consists of distinct integers in an interval of
length \(3T+O(1)\). Heath-Brown's difference-set theorem,
as stated in Guth-Maynard Theorem 1.6, applies after using
the exact \(K_2\) majorant just proved to replace each inner
supremum by an integral over the real line. For each fixed
integration variable the coefficient sequence \(n^{is}\) is
common to every pair in \(U_B^2\) and has modulus one. The
theorem is uniform over such coefficient choices, and \(K_2\)
has bounded integral. This gives the bound
\[
 T^\epsilon\sup_B B^2
       \{|U_B|^2L+|U_B|L^2+|U_B|^{5/4}T^{1/2}L\}.
\]
No representation weight has been replaced by a cardinality.
Indeed
\[
 B|U_B|\le D^3,\qquad
 B^2|U_B|\le\sum_ur_u^2\le E_6(W),
\]
and
\[
 B^2|U_B|^{5/4}
     =(B^2|U_B|)^{3/4}(B|U_B|)^{1/2}
     \le E_6(W)^{3/4}D^{3/2}.
\]
These three inequalities prove (7).

Cauchy-Schwarz on the finite ratio sums gives
\({\cal M}_5\le({\cal M}_4{\cal M}_6)^{1/2}\). Using
(5)-(7) and absorbing each positive power of \(E_6\) yields
\[
\begin{split}
 E_6(W)\precsim\;&
 F^{1/2}D^3L^{1/2-2\sigma}
 +FL^{2-4\sigma}\\
 &+F^{4/5}D^{6/5}T^{2/5}L^{4/5-16\sigma/5},\\
 F={}&D^4L+E_4(W)L^2+E_4(W)^{3/4}DT^{1/2}L.             \tag{8}
\end{split}
\]
For example the last term comes from solving
\(E_6\precsim A E_6^{3/8}\), giving \(E_6\precsim A^{8/5}\);
using the wrong feedback power would invalidate (8).

This improves on the generic convolution estimate only because
the large-value lower bound in (5) is supplied at every selected
zero and the difference-set theorem controls its arithmetic ratio
moments. Without that additional lower bound, (5) is not available
to the generic Sidon/digital family from the preceding round.

## 3. Every detector length and every zero multiplicity

For an original polynomial with \(L=T^{\lambda+o(1)}\),
\(1/1000\le\lambda\le5/12\), choose the smallest integer \(k\)
with \(k\lambda\ge1/2\). Then \(2\le k\le500\).
If \(\lambda\ge1/4\), take \(k=2\), so \(k\lambda\le5/6\).
If \(\lambda<1/4\), minimality gives
\(k\lambda<1/2+\lambda<3/4\). Thus every length is moved to
\[
                            1/2\le k\lambda\le5/6.      \tag{9}
\]
Small logarithmic endpoint changes add only \(o(1)\).
The coefficients of \(P^k\) have size at most \(T^\epsilon\):
the number of factors is bounded, and fixed-order divisor
functions have that bound. Split its support
\([L^k,(2L)^k]\) into \(O(k)\) dyadic ranges, assigning each
detected point to a range with a large value. After normalization
the large-value exponent is \(\sigma-O(\epsilon)\).
There are only \(T^{o(1)}\) polynomial and range classes.

The shifted ordinates from Section 1 need not be separated.
In a unit interval, at most \(O(T^a\log T)\) original zero
indices can be assigned there: the shifts are \(O(T^a)\),
and Riemann-von Mangoldt bounds the original zero count in
each unit interval by \(O(\log T)\), counting multiplicity.
Color these indices into \(O(T^a\log T)\) 1-separated classes.
This does not omit multiple zeros or identify their indices.

For any multiset \(A\) and any \(b\ge1\), its triple-sum
occupancy profile in half-unit intervals and Cauchy-Schwarz give
\[
                         E_6^{(b)}(A)\ll bE_6^{(1)}(A), \tag{10}
\]
where the superscript is the tolerance; the same statement holds
for \(E_4\). For a shifted subset this bounds its fourth energy
by \(T^{O(a)}E_4(Z(\sigma,2T))\). Conversely every original
sextuple relation becomes a shifted relation with tolerance
at most \(1+6T^a\).

To combine different polynomial, color and height classes without
discarding mixed sextuples, use the nonnegative Fejer weight whose
Fourier transform is the tent supported on \([-2,2]\).
Its \(L^6\) integral is comparable, up to absolute constants
and (10), with the tolerance-one sixth energy. Minkowski
therefore gives
\[
                E_6\left(\bigsqcup_{j=1}^K A_j\right)
                       \ll K^5\sum_{j=1}^K E_6(A_j).    \tag{11}
\]
This applies to indexed multisets and to the shifted classes.
The factors from (10)-(11), coloring and normalization are
\(T^{O(a)+o(1)}\); choose \(a\) arbitrarily small before
applying the final bound. Dyadic positive-height intervals,
their conjugate negative-height intervals and the finite
bounded-height zero set are all included. The total number of
height classes is \(O(\log T)\).

## 4. A strict saving on the whole real-part neighborhood

Use the reviewed source-qualified functions
\[
 d(\sigma)=
 \begin{cases}
 3(1-\sigma)/(2\sigma),&s_L\le\sigma\le7/8,\\
 3(1-\sigma)/(10\sigma-7),&7/8\le\sigma\le s_U,
 \end{cases}
 \qquad e(\sigma)=12(1-\sigma)/(4\sigma-1).
\]
For each class, \(D\ll T^{d(\sigma)+\epsilon}\) and
\(E_4(W)\ll T^{e(\sigma)+O(\epsilon)}\).
For \(L=T^{\lambda+o(1)}\), (8) has exponent at most the
maximum of
\[
\begin{split}
 q_1&=a/2+3d+(1/2-2\sigma)\lambda,\\
 q_2&=a+(2-4\sigma)\lambda,\\
 q_3&=4a/5+6d/5+2/5+(4/5-16\sigma/5)\lambda,
\end{split}
\quad
 a=\max\{4d+\lambda,\ e+2\lambda,\ 3e/4+d+1/2+\lambda\}.
                                                               \tag{12}
\]
There are exactly nine affine expressions after expanding this
maximum. Comparing each with \(2d+e\) proves a uniform fixed
saving over all \(\lambda\in[1/2,5/6]\).

Here is an interval proof, not a sampled optimization.
Both \(d,e\) decrease on the full sigma interval. Every
coefficient of \(\lambda\) in the nine **gaps**
\(2d+e-q_j\) is positive on that interval, except the
gap arising from \(a=e+2\lambda,\ q_2\).
For the eight positive-coefficient gaps take
\(\lambda=1/2\), the appropriate endpoint bounds for \(d,e\),
and \(\sigma=s_L\) in the positive sigma terms. Their
explicit lower bounds, in the order of the three \(a\)
branches and three \(q\) branches, are
\[
\begin{array}{c|ccc}
 a=4d+\lambda&
 21851297/68390500&7005836/17097625&23394344/85488125\\
 a=e+2\lambda&
 3502918/17097625&31/3300&371589/4303750\\
 a=3e/4+d+1/2+\lambda&
 2924293/17097625&371589/3443000&7062/195625 .
\end{array}
\]
The middle gap is handled with its correlated density formula:
\[
 2d-4(1-\sigma)\lambda
 =2(1-\sigma)\{A(\sigma)-2\lambda\}
 \ge2(1-s_U)\{A(s_U)-5/3\}
 =31/3300.                                                \tag{13}
\]
The two density formulas agree at \(7/8\), and \(A\) decreases;
the brace in (13) is strictly positive. All nine gaps are
at least \(31/3300>1/200\).

Constants originally given for fixed sigma are made uniform
by a finite monotonicity grid on this compact interval.
Choose its mesh to cost less than an arbitrary final epsilon,
not to consume the fixed saving in (13); the finitely many
source constants then have a maximum. The same treatment
absorbs the \(o(1)\) in (9) and all loss parameters in (8),
(10)-(11).

Equations (2)-(13) therefore give the proposed unconditional
technical theorem
\[
 E_6(\sigma,T)\ll_\epsilon
 T^{2d(\sigma)+e(\sigma)-1/200+\epsilon}
             \quad(|\sigma-7/8|\le1/1000).                \tag{14}
\]
This is an Engineer proof, not independent certification.
The new steps requiring review are the all-zero short detector,
the weighted sixth ratio moment and the shifted-multiset cover.
The preceding generic construction is neither contradicted
nor being used as evidence for (14).

## 5. Instantiating the accepted ordinary-prime transfer

Take the unchanged reviewed spatial parameters, real-part grid,
cutoff, centering, endpoint control and all-integer-length
transfer from `sixth-energy.md` Sections 3-4. Replace only the
previous unproved sixth-energy antecedent by (14). Its radius
is the same \(1/1000\).

With \(\delta=1/200\) the new pair budget is
\[
 f_6(\theta,\sigma)=\theta+6\sigma-5+
           (1-\theta)\{2d(\sigma)+e(\sigma)-\delta\}.
\]
The real-part derivatives are exactly those in the previously
accepted cover: positive left of \(7/8\), negative right of it,
on \(|\theta-5/12|\le1/1000000\). Thus the new-neighborhood
maximum is at sigma \(7/8\). There
\[
 2d+e-\delta=1433/1400,\qquad
 \max_{|\theta-5/12|\le1/1000000} f_6
       =19/15-7/2400+33/1400000000
       <19/15-1/10000.                                  \tag{15}
\]
Outside the neighborhood no input changes: the previously
reviewed low-real-part cover, fourth-moment rectangle,
source-range bridge, compact high-real-part removals and
near-one zero-free treatment keep their strict buffers.
They are reused rather than rerun or reinterpreted.
Any additional applicable rows from the two newer sources
can also be retained by taking minima; they cannot weaken
this cover and do not lower its central \(19/15\) comparison.

The pointwise comparison still uses the full applicable
reviewed envelope, not \(31/24\). In the new neighborhood the
fourth budget is below the second. Correlation in the
generic-sixth loss gives
\[
 f_6-f_4
 \le 2(1-s_L)\max\{0,(1-\theta_-)A(s_L)-1\}
                   -(1-\theta_+)/200< -1/500,
\]
where \(\theta_\pm=5/12\pm1/1000000\).
Thus (14) improves the relevant fourth-energy minimum
pointwise there; elsewhere the full prior envelope is retained.

Combining (14)-(15) with the exact centered ordinary-prime
transfer yields the Engineer's local unconditional statement
\[
 V(N,H)\ll_\epsilon N^{19/15-1/10000+\epsilon},
 \qquad |\log_N H-5/12|\le1/1000000,                      \tag{16}
\]
uniformly for dyadic \(N,H\).
The ordinary-prime event, the factor \(H^2/d_{\rm grid}\),
every integer length, truncation, all frequency blocks,
prime-power corrections and endpoints are unchanged.
This is not a global bound for \(E(X)\) or an exact witness.

The strongest prior relevant result was the independently
reviewed local exponent \(19/15\). Equation (16) would lower
that exponent by \(1/10000\) unconditionally, unlike the
preceding conditional calculation. Independent correctness,
source attribution, originality and publishable significance
are not claimed by this Engineer note; normal Host Reviewer
certification is required before acceptance.

The general-form Jacobian parameter request was refused at
`normalization_admission` with `INVALID_REQUEST`: its normalized
simplex-basis count exceeded the advertised bound. Its exact payload,
structured error and exit status 2 are preserved, with no mathematical
conclusion. The equivalent fixed-cutoff standard-form request has three
nonnegative variables and two equality rows; its right-hand sides are
the detector margin \(1/1750\) and residual energy gap \(29/6600\).
The analytic statements above do not depend on either optimization
tool's verdict. `check_zero_detector.py` checks their arithmetic
directly and independently replays an admitted primal/dual certificate.
