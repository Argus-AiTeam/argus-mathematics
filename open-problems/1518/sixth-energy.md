# Sixth zero energy and the ordinary-prime window

The unconditional improvement requested in this mission is **not proved**.
The target is

\[
 V(N,H)=\#\{(n,h)\in\mathbb Z^2:N\le n<2N,\ H\le h<2H,\
       \pi(n+h)>\pi(n)+\pi(h)\}
 \ll_\epsilon N^{19/15-\kappa+\epsilon},
\]

for explicit \(\kappa>0\) and \(0<w<1/420\), uniformly for dyadic \(N,H\)
with \(|\log_N H-5/12|\le w\). This is a local pair-count question, not a
global estimate for \(E(X)\), and not an exact counterexample.

## Source-qualified scope

Write \(D(\sigma,T)=|Z(\sigma,T)|\), where \(Z\) is a multiset of
nontrivial zeta zeros with \(\beta\ge\sigma\) and \(|\gamma|\le T\).
Every occurrence of a zero, including a repeated zero, is a separate
index in

\[
 E_{2k}(\sigma,T)=
 \#\{(\rho_1,\ldots,\rho_{2k})\in Z(\sigma,T)^{2k}:
   |\gamma_1+\cdots+\gamma_k-\gamma_{k+1}-\cdots-\gamma_{2k}|\le1\}.
\]

On \(|\sigma-7/8|\le1/1000\), the applicable reviewed envelope is

\[
 d(\sigma)=
 \begin{cases}
  3(1-\sigma)/(2\sigma),&\sigma\le7/8,\\
  3(1-\sigma)/(10\sigma-7),&\sigma\ge7/8,
 \end{cases}
 \qquad
 e_4(\sigma)=12(1-\sigma)/(4\sigma-1).
\]

The inputs are \(D\ll_{\sigma,\epsilon}T^{d(\sigma)+\epsilon}\) and
\(E_4\ll_{\sigma,\epsilon}T^{e_4(\sigma)+\epsilon}\).
These are the reviewed inputs, not an assertion that no later
improvement exists.

The document actually inspected is A. Gafni and T. Tao, *On the number of
exceptional intervals to the prime number theorem in short intervals*,
arXiv:2505.24017v1: Table 1 gives the two density rows; Section 3 gives the
classical fourth-energy row on \(3/4<\sigma<1\); Lemmas 2.2-2.4 give the
pointwise, second- and fourth-moment arguments. Its PDF and text already
reside in `../centered-prime-marker-dispersion-v1/`. The original
Heath-Brown 1979 fourth-energy proof was not obtained in the preceding
mission; this note does not invent its theorem number.

The remark after the proof using Lemma 2.4, on page 13, describes higher
ordered additive energies and says that the unconditional bounds then
available were consequences of density or fourth energy. Its reference
[5] is Bazzanella, *Two conditional results about primes in short
intervals* (2011), not an unconditional sixth-energy input. The displayed
higher-energy formula in the text extraction omits the intermediate
negative terms; the definition above includes all three for \(k=3\).

The independent review recorded in `roles/reviewer/progress.json`
supports the preceding mission's ordinary-prime marker transfer and
\(19/15\) local comparison. We reuse those mathematical results, not the
old, weaker \(31/24\) numerical benchmark. Automatic cancellation from
centering was already ruled out and is not being retried.

A focused external lookup in this round returned no verified subsequent
sixth-energy input. The search summary misnamed the Gafni-Tao paper,
misdated it, invented a locator and misstated an energy exponent; those
claims are rejected against the inspected primary text. This is a failed
lookup, not an exhaustive literature or originality certification.

At the critical point,
\[
 d(7/8)=3/14,\qquad e_4(7/8)=3/5,\qquad
 2d(7/8)+e_4(7/8)=36/35.
\]
The missing new assertion is a fixed positive saving in this last
exponent, uniformly on a fixed real-part neighborhood, using genuinely
zeta-specific information. Neither a finite model nor a conditional
prime-window implication establishes that assertion.

## 1. What the generic sixth moment actually gives

For any finite multiset of real ordinates, with the tolerance-one
definitions above,
\[
                         E_6\ll D^2E_4.                 \tag{1}
\]
To check the tolerance, partition the ordered pair sums into intervals
of length \(1/2\), and let \(r_j\) be their occupancies. For a fixed
translation \(s\), the condition \(|u-v+s|\le1\) permits only a bounded
number of differences between the two interval indices. Each resulting
sum \(\sum_jr_jr_{j+a}\) is at most \(\sum_jr_j^2\) by Cauchy-Schwarz,
and the latter counts only quadruples with difference at most \(1/2\),
hence is at most \(E_4\). Fixing the first and fourth sextuple entries
leaves precisely such a translated pair-sum problem. Summing over their
\(D^2\) ordered choices proves (1), with multiplicities intact.
For integer sums with exact equality the constant is one, by Young's
inequality for discrete convolution.

Let \(\theta=\log_N H\), \(\tau=1-\theta\). The limiting second-, fourth-
and generic sixth-moment pair budgets are
\[
\begin{split}
 f_2&=\theta+2\sigma-1+\tau d(\sigma),\\
 f_4&=\theta+4\sigma-3+\tau e_4(\sigma),\\
 f_6^{\rm gen}&=\theta+6\sigma-5+\tau(2d(\sigma)+e_4(\sigma)).
\end{split}
\]
In particular
\[
 f_6^{\rm gen}-f_4
   =2\{\tau d(\sigma)-(1-\sigma)\}
   =2(1-\sigma)\{\tau A(\sigma)-1\}.                     \tag{2}
\]
The pointwise zero-density argument removes a slice when
\(\tau A(\sigma)<1\), with fixed buffers away from the boundary.
On every surviving limiting slice, (2) is nonnegative. Thus the generic
sixth moment does not improve the full known second/fourth-moment
envelope where an exceptional-set estimate is needed. At
\((\theta,\sigma)=(5/12,7/8)\) the difference is exactly zero and both
fourth and sixth budgets are \(19/15\). With a genuine energy saving
\(\delta\), the sixth budget there would instead be
\[
                         19/15-7\delta/12.              \tag{3}
\]
Equation (3) alone is not the prime-window theorem.

## 2. An exact sharpness family for the available generic data

This is an unconditional elementary construction of ordinate sets,
**not** a construction of zeta zeros.

For an odd prime \(p\), put
\[
 r_i=i^2\bmod p\in\{0,\ldots,p-1\},\qquad
 B_p=\{2pi+r_i:0\le i<p\}.
\]
If \(b_i+b_j=b_k+b_l\), then
\[
 2p(i+j-k-l)=r_k+r_l-r_i-r_j.
\]
The right side has absolute value less than \(2p\), so the index sums
are equal. Reduction modulo \(p\) then gives equal sums and products
of \(i,j\) and \(k,l\); since \(2\) is invertible, the unordered pairs
are identical. Consequently
\[
                        E_4(B_p)=2p^2-p.
\]
The triple sums lie in fewer than \(6p^2\) integer positions.
Cauchy-Schwarz and (1) give
\[
                    p^4/6\le E_6(B_p)\le2p^4.
\]

Let \(L=p^4\), \(Q=8p^2\), \(I_L=\{0,\ldots,L-1\}\), and
\[
                     A_p=QI_L+B_p.
\]
In a quadruple or sextuple equality the difference between the sums of
the \(B_p\) digits has absolute value less than \(6p^2<Q\).
Thus equality splits into equality of the high digits and equality of
the low digits, without carries. In particular,
\[
 |A_p|=p^5,\quad E_4(A_p)=E_4(I_L)E_4(B_p),\quad
 E_6(A_p)=E_6(I_L)E_6(B_p).
\]
Here \(E_4(I_L)=(2L^3+L)/3\), and pigeonholing the \(L^3\)
triple sums in fewer than \(3L\) positions gives \(E_6(I_L)\ge L^5/3\).
Young's inequality gives \(E_6(I_L)\le L^5\). Therefore
\[
 \frac23p^{14}\le E_4(A_p)\le2p^{14},\qquad
                  p^{24}/18\le E_6(A_p)\le2p^{24}.       \tag{4}
\]

To preserve conjugation symmetry **and the density bounds at every
height**, not just at the largest height, set
\[
 T_p=p^{70/3},\quad K_p=\lfloor T_p/2\rfloor,\quad
 \Gamma_p=(K_p+2A_p)\ \cup\ (-K_p-2A_p).
\]
The sets on the right are disjoint. All ordinates have the same parity,
are separated by at least two, and lie between \(T_p/3\) and \(T_p\)
in absolute value. The last assertion follows from
\(\max A_p<8p^6\) and \(T_p>32p^6\) for \(p\ge3\).
The tolerance-one counts therefore equal the exact equality counts.
Translation and dilation preserve the counts within either component.
The elementary inequality \(|u+v|^4\le8(|u|^4+|v|^4)\), integrated over
the unit circle, bounds the fourth energy of their union by
\(16E_4(A_p)\). Together with (1) and (4), this gives
\[
 |\Gamma_p|=2p^5\asymp T_p^{3/14},\quad
 E_4(\Gamma_p)\asymp T_p^{3/5},\quad
 E_6(\Gamma_p)\asymp T_p^{36/35}.                         \tag{5}
\]
For example the constants above give
\(E_6(\Gamma_p)/( |\Gamma_p|^2E_4(\Gamma_p))\ge1/2304\).
Below height \(T_p/3\) the set is empty; above it the cardinality and
fourth energy are bounded by the right sides of (5), up to absolute
constants. Thus the corresponding upper bounds hold uniformly at
every height. Assigning real part \(7/8\) to these formal ordinates
also satisfies the two displayed metadata bounds for every threshold
in our real-part neighborhood: below \(7/8\) both exponents are
nondecreasing as the threshold decreases, and above it the set is
empty. This assignment says nothing about values of zeta.

For any proposed \(\delta>0\), choose \(\epsilon<\delta\) and let the
primes \(p\) tend to infinity in (5). The proposed saved exponent fails
for these sets. This disproves a deduction from density, fourth energy,
symmetry and unit-interval spacing alone. It does **not** disprove
the desired bound for actual zeta zeros, establish a global analytic
obstruction for primes, or meet the publication-level acceptance bar.

The dedicated Jacobian payload uses \(B_{11}\), not zeta zeros.
The inspected `additive.ordered_difference_profile.compute` contract
admits at most 128 distinct vectors with coordinates of magnitude less
than \(10^6\), and returns all nonzero ordered differences and their
source indices. It is used only to check this finite Sidon instance.
The general construction is proved above, not inferred from that run.
`check_sixth_energy.py` independently replays the complete ordered
difference output, the finite digit factorization, repeated-index counts,
and the actual \(\Gamma_3\) construction. Its height shift and the
inequalities \(T/3\le|\gamma|\le T\) are checked by integer cubes,
without a floating-point root.

## 3. Sixth moment with the exact ordinary-prime center retained

Use the previously reviewed parameters
\[
 \ell=\log N,\quad \delta_0=H/(N\ell^3),\quad
 d_{\rm grid}=\lfloor H/\ell^7\rfloor,\quad
 \delta_1=e^{-\sqrt\ell},\quad \alpha=\delta_0/\delta_1,
 \quad U=16(N/H)\ell^{12}.
\]
For \(b=d_{\rm grid}m\) in the reviewed range, write
\[
 \kappa_b(t)={\bf1}_{(b,b(1+\delta_0)]}(t)
       -\alpha{\bf1}_{(b,b(1+\delta_1)]}(t),\qquad
 B(b)=\int\kappa_b(t)\{d\pi(t)-dt/\log t\}.
                                                               \tag{6}
\]
This is the same centered ordinary-prime remainder as before.
No alteration of the marker event is made.

The exact identity of measures, with prime powers counted separately,
is
\[
 d\pi(t)-dt/\log t
   =\frac{d\psi(t)-dt}{\log t}-d\nu_{\rm pp}(t),\qquad
 d\nu_{\rm pp}(t)=\sum_{p^k,\ k\ge2}\frac1k\delta_{p^k}(dt).
                                                               \tag{7}
\]
Write \(R_j(b)=\psi(b(1+\delta_j))-\psi(b)-b\delta_j\).
Replacing \(1/\log t\) in (7) by \(1/\log b\), separately in the
two windows, costs at most
\[
 O\bigl(\delta_0(\delta_0+\delta_1)N/\ell\bigr).
                                                               \tag{8}
\]
Indeed its oscillation is \(O(\delta_j/\ell^2)\), while
the total variation of \(d\psi-dt\) on that window is at most
\(O((N\delta_j+1)\ell)\). The extra endpoint terms in this estimate
are smaller than (8) at these parameters.

Uniformly on the present length band the short window has length
less than \(\sqrt N\). For each \(k\ge2\), consecutive \(k\)-th
powers near \(N\) are separated by at least a fixed multiple of
\(\sqrt N\). There are \(O(\ell)\) possible exponents. The short
prime-power correction is therefore \(O(\ell)\); the long correction,
after multiplying by \(\alpha\), is at most
\[
             O(\delta_0\sqrt N\,\ell+\alpha\ell).
                                                               \tag{9}
\]
These are upper bounds over all integer powers, so they do not require
any assertion about the primality of their bases.

The reviewed long-window PNT, applied to \(\delta_1N\), gives
\(\alpha R_1(b)=o(\delta_0N)\), uniformly. This can also be read
directly from the quantitative PNT: its endpoint error is
\(N\exp(-c\ell^{3/5}(\log\ell)^{-1/5})\); multiplication by
\(\alpha\) introduces only the factor \(\exp(\sqrt\ell)\).
Equations (7)-(9) consequently give
\[
 B(b)=\frac{R_0(b)}{\log b}+{\cal E}(b),\qquad
                  \sup_b|{\cal E}(b)|=o(\delta_0N/\ell).
                                                               \tag{10}
\]
This error is removed from the fixed marker threshold **before**
Markov's inequality. Bounding its sixth moment by a merely \(o(1)\)
factor and calling that a power saving would be invalid.

Choose the explicit-formula cutoff
\(T=J\ell^2/\delta_0=N^{1-\theta+o(1)}\le U\), with the fixed
constant \(J\) chosen after the event threshold. The reviewed
relative-window explicit formula expresses \(R_0(b)\) as a zero sum
with coefficients
\[
 c_\rho=\frac{(1+\delta_0)^\rho-1}{\rho}
       =\int_0^{\delta_0}(1+v)^{\rho-1}\,dv,\qquad
                              |c_\rho|\le\delta_0,
                                                               \tag{11}
\]
plus \(O(N\ell^2/T)\) and harmless jump-endpoint errors
\(O(\ell)\). The overall sign convention of the zero sum is immaterial
here, since the moment and containment use absolute values.
The truncation error is smaller than a prescribed fixed fraction of
the threshold after choosing \(J\). The endpoints are the half-open
endpoints in (6)-(7); changing a convention only affects the stated
\(O(\ell)\) jump error.

For a fixed real-part slice
\(I\subset[\sigma_-,\sigma_+]\), let
\[
                 S_I(b)=\sum_{\rho:\,\beta\in I,\ |\gamma|\le T}
                                  c_\rho b^\rho.
\]
Integrate \(|S_I|^6\) against a smooth majorant after putting
\(b=Ne^u\). Expansion has exactly three unconjugated and three
conjugated entries. The real-part parameter in the smooth transform
lies in the compact interval \([0,6]\). Repeated integration by parts
and (11) bound the normalized moment by
\[
 \delta_0^6N^{6\sigma_+}
 \sum_{\rho_1,\ldots,\rho_6\in Z(\sigma_-,T)}
 (1+|\gamma_1+\gamma_2+\gamma_3-\gamma_4-\gamma_5-\gamma_6|)^{-10}.
\]
Define
\[
 F_3(v)=\#\{(\rho_1,\rho_2,\rho_3)\in Z(\sigma_-,T)^3:
                |\gamma_1+\gamma_2+\gamma_3-v|\le1/2\}.
\]
Averaging the decaying kernel over the two unit intervals and using
Schur's test bounds the sum by a constant times \(\int F_3^2\).
Expanding that integral gives tent weights
\((1-|\gamma_1+\gamma_2+\gamma_3-\gamma_4-\gamma_5-\gamma_6|)_+\);
it is at most \(E_6(\sigma_-,T)\). Thus
\[
 \frac1N\int_{N}^{2N}|S_I(b)|^6\,db
             \ll\delta_0^6N^{6\sigma_+}E_6(\sigma_-,T).   \tag{12}
\]
The same proof works on every fixed comparable spatial range required
by the marker transfer. Every negative ordinate, repeated zero, and
ordered sextuple is included. No separation into frequency blocks is
needed: (12) uses the entire cutoff, including all cross-block terms.
It does not drop the low-frequency block.

From (10)-(12), or the unchanged ordinary-prime containment in the
weighted short-window event, a marker requires a zero-slice sum of
size a fixed multiple of \(\delta_0N\). A finite real-part grid and
Markov's inequality give the real-measure exponent
\[
                          6\sigma_+-5+\tau e_6(\sigma_-).
\]
Moving \(b\) over a cell of length \(d_{\rm grid}\) changes the two
weighted endpoints by \(O((d_{\rm grid}+1)\ell)=o(\delta_0N)\).
The disjoint cells therefore give
\[
 R\,d_{\rm grid}\ll \text{real exceptional measure},\qquad
 V(N,H)\ll H^2R.
\]
Hence the pair budget is \(f_6=\theta+6\sigma-5+\tau e_6(\sigma)\),
up to a controllable fixed-grid and source-epsilon buffer.
The factor \(H^2/d_{\rm grid}=H\ell^{7+o(1)}\) is retained;
every integer length \(H\le h<2H\) is counted.

## 4. A complete local implication, with an unproved hypothesis

The following is **conditional**, not the requested unconditional
theorem. Suppose that the new assertion
\[
 E_6(\sigma,T)\ll_\epsilon
 T^{2d(\sigma)+e_4(\sigma)-1/35+\epsilon}
 \quad\text{uniformly for }|\sigma-7/8|\le1/1000          \tag{H6}
\]
holds. Then (12), the reviewed source envelope, and the unchanged
ordinary-prime transfer imply
\[
 V(N,H)\ll_\epsilon N^{19/15-1/10000+\epsilon}
       \quad\text{if }|\theta-5/12|\le1/1000000.         \tag{13}
\]
Here is complete slice coverage, rather than just (3).

Put \(\sigma_L=7/8-1/1000\), \(\sigma_U=7/8+1/1000\),
\(\theta_\pm=5/12\pm1/1000000\), and
\(\tau_{\max}=1-\theta_-\), \(\tau_{\min}=1-\theta_+\).
For \(f_6\) under (H6), its real-part derivative is
\[
 \begin{cases}
 6-\tau\{3/\sigma^2+36/(4\sigma-1)^2\},&\sigma<7/8,\\
 6-\tau\{18/(10\sigma-7)^2+36/(4\sigma-1)^2\},&\sigma>7/8.
 \end{cases}
\]
The first is positive throughout the rectangle, since it is positive
at \((\sigma_L,\tau_{\max})\). The second is negative throughout,
since it is negative at \((\sigma_U,\tau_{\min})\).
At \(\sigma=7/8\), direct simplification gives \(f_6=5/4\)
for every \(\theta\): the energy exponent under (H6) is exactly one.
Thus the entire new-energy neighborhood has budget at most \(5/4\).

For \(0\le\sigma\le1/2\), the second moment and
Riemann-von Mangoldt unit-interval count give budget at most one.
Between \(1/2\) and \(s_0=3831/4791\), reuse the full reviewed
low-real-part density cover. A sufficient explicit subcover is
\[
\begin{array}{c|c}
 [1/2,7/10]&3/(2-\sigma)\\
 [7/10,13/17]&15/(3+5\sigma)\\
 [13/17,25/32]&6/(5\sigma-1)\\
 [25/32,11/14]&2\\
 [11/14,s_0]&9/(7\sigma-1).
\end{array}
\]
These are the source-qualified rows already reviewed, not
out-of-range extensions of Table 1. Additional applicable rows in
the full envelope can only lower this bound. Each second-moment
budget is nondecreasing in \(\theta\); as a function of \(\sigma\)
it is convex, or increasing for the first row. Exact endpoint
evaluation at \(\theta_+\) bounds every one strictly below
\(19/15-1/10000\).

On \([s_0,\sigma_L]\), use the fourth-energy bound
\(12(1-\sigma)/(4\sigma-1)\). Its budget is convex in \(\sigma\)
and affine in \(\theta\). Its maximum is at one of the four rectangle
corners, and all four are strictly below \(19/15-1/10000\).

On \([\sigma_U,279/314]\) the legitimate
\(A(\sigma)=3/(10\sigma-7)\) row gives
\[
 1-\tau A(\sigma)\ge
       1-\tau_{\max}\frac3{10\sigma_U-7}>0.
\]
This is uniform pointwise removal, with
\(1-\sigma\ge35/314\). On \([279/314,155/174]\) reuse the
reviewed monotonicity bridge at \(111/125\); its fixed power margin
\(923/204450\) was proved on the larger closed theta band containing
ours. On \([155/174,23/24]\) the legitimate three high-real-part
rows, \(24/(30\sigma-11)\), \(2/(7\sigma-5)\), and
\(4/(30\sigma-25)\), have \(A\le29/19\) in their exact reviewed
intervals. Their previous fixed removal margin still applies.
Above \(23/24\), retain the reviewed compact \(A\le3/2\) treatment
and the moving near-one zero-free argument. Lemma 2.1 of the inspected
primary source bounds that final contribution by a factor tending to
zero relative to the event threshold. No fixed source epsilon is
divided by \(1-\sigma\).

This covers every real-part slice of the full cutoff. All displayed
inequalities outside the new neighborhood have strict fixed buffers.
Choose the finite grid widths and source epsilons below these buffers
and the requested final epsilon. The near-one cutoff and its estimates
are uniform on the compact theta band. Truncation, deterministic errors,
and length endpoints were controlled in Section 3. This proves the
conditional implication (13), with explicit
\(\kappa=1/10000\) and \(w=1/1000000<1/420\).

The pointwise comparison is with the reviewed density/fourth-energy
envelope, not just \(31/24\). On the new neighborhood,
\[
\begin{split}
 f_2-f_4
 &\ge2(1-\sigma_U)+\tau_{\max}
                 \{d(\sigma_U)-e_4(\sigma_L)\}>1/100,\\
 f_6-f_4
 &\le2\{\tau_{\max}d(\sigma_L)-(1-\sigma_U)\}
                                      -\tau_{\min}/35<-1/100.
\end{split}
\]
The exact checker verifies these interval bounds, all endpoint budgets,
and both derivative signs using rational arithmetic, not a sampled
grid. Outside the neighborhood the full existing envelope is retained.
Its \(19/15\) peak at the central slice is the comparison relevant
to (13). No global estimate for \(E(X)\) follows from this local result.

## 5. The zeta-specific step remains open

Zero detection supplies relations or large-value conditions at the
individual ordinates \(\gamma_j\). It does not assert that
\(\gamma_1+\gamma_2+\gamma_3\) is a zero ordinate or obeys the same
zero-detecting relation. Applying a zero-density theorem to the
triple-sum support would therefore add an unjustified hypothesis.
Combining the individual scalar conditions only through the known
supremum and fourth-moment inequalities leaves (1) and the nonnegative
loss (2). The explicit family in Section 2 shows why the generic
metadata cannot repair that loss.

No zeta-specific six-variable estimate overcoming this step was proved
in this round. In particular (H6) is unproved; the conditional constants
in (13) are not unconditional constants earned by the mission. The
strongest prior relevant result remains the independently reviewed
\(19/15\) local comparison. This round does not improve it
unconditionally and does not certify originality or publishable
significance. Independent Reviewer replay is still required for the
new construction, sixth-moment transfer, and conditional coverage;
the publication-level goal and exact witness remain open.

Only the generic-data-only deduction is retired, for the exact
sharpness reason in Section 2. The materially different route requiring
a genuinely zeta-specific correlation estimate is left open. No
negative result in this note rules out that route.
