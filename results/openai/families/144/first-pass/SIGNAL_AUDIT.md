# Scale-independent signal transmission

## Scope and source findings

This audit concerns the full quantified assertion of `lem:signal`, not the
main spectral theorem. The source prefix below is
`research/openai_manuscript/A-smooth-three-torus-diffeomorphism-with-simple-Lebesgue-spectrum-September-23-2026/build/sections/`.
The staged files are read-only.

The existing ledger contained only campaign goal `C9000144`, with no previous
mathematical result or retired route. A targeted search of the supplied Wiki
index found no relevant Banach-spectrum, jitter-law, or signal-transmission
page. No novelty conclusion follows from that limited search.

The source dependency chain is:

| Assertion | Source | Load-bearing dependencies |
|---|---|---|
| `thm:main` | `01-introduction.tex`; proof in `05-completion.tex` | `prop:stage`, flat initial vector, strong Koopman continuity, diagonal retention |
| `prop:stage` | `05-completion.tex` | preparation by neutral passages, `prop:prediction`, `lem:flat-vector`, whitening |
| `prop:prediction` | `04-blocks.tex` | `lem:refresh-transmit`, `lem:phase-tests`, centered block estimates |
| `lem:refresh-transmit` | `03-signals.tex` | `lem:neutral`, `lem:signal`, support drift bounds |
| `lem:signal` | `03-signals.tex`, lines 19-334 | positive joint law, prime sieve, finite-c estimate, `lem:law-approx`, `lem:fast-average`, `lem:passage` |
| `lem:neutral` | `02-passages.tex` | passage density formula and weighted Riemann sums |
| `lem:passage` | `02-passages.tex`, lines 54-304 | exact coordinate change, stationary phase, coefficient-mass rounding removal, density pushforward |
| `lem:law-approx` | `02-passages.tex`, lines 375-408 | truncated quantile map and a smooth cutoff |
| `lem:fast-average` | `02-passages.tex`, lines 306-359 | uniform continuity on cells of length P/N |

Important quantifiers read directly in the source:

* P and gamma_0 depend only on b, D_0, d.
* c may depend on B, the actual finite packet list, the old map, and every
  requested error; gamma need not shrink when these data change.
* The jitter and cutoffs are fixed after c, and N is selected last.
  Every sufficiently large integer N must work; a subsequence is insufficient.
* Negative m and nonunit residue classes are included.
* Rounding is removed from coefficient masses before fast sampling. It does
  not license replacing Ns by N(s-m Delta_N).

No false literal manuscript assertion has been established at this point.
In particular, treating the finite-c phases as residue characters would be an
invalid proposed route, not a quotation of what the manuscript does: the
source explicitly estimates those phases before applying its sieve.

## Capability boundary

Before any custom exact-computation code, the installed Jacobian catalogue
was queried for finite character sums, divisibility, and symbolic identities.
The relevant inspected operation is
`finite_abelian_group.spectral_pair.decide`, server 0.14.0, protocol
2025-11-25. It decides a bounded finite spectral pair by exact cyclotomic
reduction. It can check one finite instance of character orthogonality; it
cannot settle a parameter-general prime sieve, finite-c perturbations, a
smooth law realization, or a stationary-phase limit. Its typed input/output
will be retained in `exact_certificate.json`, separately from the analytic
proof and without being described as a proof of the quantified lemma.

## Result and its exact scope

**Verification theorem (analytic proof, pending independent review).** The
full assertion of `lem:signal` is valid. In particular P and gamma_0 can be
chosen solely from b, D_0, d, for every positive scale B and every admissible
finite packet list. The necessary growth with the actual indices belongs
to c, not to gamma. The proof below also gives an explicit summed finite-c
error bound and proves the smooth realization and the restricted passage
needed for this assertion.

This is not a proof of `thm:main`, `prop:prediction`, neutral refresh, or the
general residue version of `lem:passage`. It does not claim a new solution
of Banach's problem or verified novelty. Relative to the previously empty
mathematical ledger, the improvement is a parameter-general proof of this
local bottleneck, not merely a larger finite search.

The finite-character/sieve core is separately formalized in Lean 4.31.0:
`Main.lean`, claim `C144_SIEVE_KERNEL`. The successful real compiler run has
exit code 0 and no proof holes; its archived certificate is
`certificates/C144_SIEVE_KERNEL-de0932f30af7e89b.json`.
The reading of that formal statement is `research/STATEMENT_FIDELITY.md`;
the official verifier also maintains its canonical copy
`statement_fidelity.md`. Compilation does not check the analytic proof below
or the correctness of that reading. Neither file was edited during a run.

## 1. Adversarial findings before the positive argument

The exact script checks both Fourier signs, negative frequencies, nonunit
classes, all possible relevant small harmonics, and exact rational
parameter-budget arithmetic. It checks 996 signed character frequencies,
24,320 prime-cover cases, and 192 normalized-band cases. No admissible
counterexample was found in that finite search. That is a finite
experiment, not the proof of the theorem.

There are two genuine obstructions to tempting *alternative proofs*:

1. With P=6, m=1, ell=2, t=5/4, the normalized Ramanujan transform of
   the finite-c phase is
   \[
   \frac{1+2\zeta_{12}^2-\zeta_{12}^3}{6}\ne0.
   \]
   At t=1 it is zero. Nonvanishing follows exactly by reduction modulo
   \(\Phi_{12}(X)=X^4-X^2+1\). This can be relevant to a smooth d
   supported near +/-5/2, with x=1, b=1, D_0=2, D=13/4, L=4.
   It refutes exact cancellation at an arbitrary finite c, not
   `lem:signal`, which allows c to be increased. The source explicitly
   handles this issue in `eq:signal-finite-c`.
2. The condition \(|\Delta_N|\le1/N\) does not imply
   \(e(Nm\Delta_N)\to1\). For \(Nm\Delta_N=1/2\) it is exactly -1.
   Thus moving a rounding shift inside a fast phase is invalid. The
   source instead removes rounding in coefficient masses, before sampling.

The exact-character-at-finite-c route is retired in the claim ledger with
this obstruction, rather than misrecorded as a flawed manuscript assertion.
No literal false assertion of the staged manuscript was identified in this
mission, so there is no justified `F_...` refutation claim to file.

## 2. A scale-independent positive law

Use \(e(t)=\exp(2\pi i t)\) and the positive Fourier convention
\(\widehat f(v)=\int f(R)e(vR)\,dR\). Fix
\[
 \alpha=b/4,\qquad a_0=(2\alpha)^{-1},
 \qquad
 s_\alpha(R)=\alpha\left(\frac{\sin(\pi\alpha R)}
                                  {\pi\alpha R}\right)^2,
 \quad
 q_0(R)=\frac1{2a_0}\int_{-a_0}^{a_0}s_\alpha(R-t)\,dt .
\]
The inverse Fourier transform of
\(\alpha^{-1}{\bf1}_{[-\alpha/2,\alpha/2]}*
 {\bf1}_{[-\alpha/2,\alpha/2]}\) is \(s_\alpha\):
this follows by multiplying the two elementary interval integrals.
Fourier inversion therefore gives
\(\widehat{s_\alpha}(v)=(1-|v|/\alpha)_+\).
It also gives mass one. Averaging translations preserves mass and
restricts the Fourier support of q_0 to \([-\alpha,\alpha]\).

Here is an explicit global lower bound, avoiding an unspecified compact
minimum. The interval of averaging has exactly one sine-squared period.
For every R, with the removable zero interpreted by continuity,
\[
 q_0(R)\ \ge\
 \frac{1}{2\pi^2\alpha(|R|+a_0)^2}
 \ \ge\ \frac{c_0}{1+R^2},\qquad
 c_0=\frac1{2\pi^2\alpha(1+a_0^2)}.                 \tag{2.1}
\]
The first inequality uses \(|R-t|\le |R|+a_0\) inside the integral;
the second is Cauchy--Schwarz. Also \(q_0\le\alpha\), and for
\(|R|\ge R_0=\max(1,2a_0)\),
\(q_0(R)\le4/(\pi^2\alpha R^2)\). Thus
\[
 q_0(R)\le C_0/(1+R^2),\qquad
 C_0=\max\{\alpha(1+R_0^2),8/(\pi^2\alpha)\}.        \tag{2.2}
\]
In particular q_0 is a strictly positive smooth probability density.

Choose D greater than b and the absolute support radius of d, and choose
an integer \(L>\max(2,D/b)\). Put
\[
 P=\prod_{\substack{p\le L\\p\ {\rm prime}}}p,\quad
 U=|(\mathbb Z/P\mathbb Z)^\times|,\quad
 C_P(h)=\sum_{k\in(\mathbb Z/P\mathbb Z)^\times}e(-kh/P).
\]
P >= 2. These choices do not use B or any packet. Define
\[
 g(R)=\int d(v)e(-vR)\,dv,\quad
 A=\|d\|_\infty,\quad A_1=\|d'\|_\infty,\quad
 G_0=\|d\|_1+\frac{\|d''\|_1}{4\pi^2}.
\]
Two integrations by parts give
\((1+R^2)|g(R)|\le G_0\). Repeated integrations give the Schwartz
property. The Hermitian symmetry of d makes g real, and Fourier inversion
gives \(\int g=d(0)=0\). The unit set is invariant under negation, so C_P
is real and \(|C_P(h)|\le U\).

The following explicit positive choice suffices:
\[
 \boxed{\quad
 \gamma_0=\min\left\{1,\,
       \frac{c_0}{2U(1+G_0)},\,
       \frac1{4(1+A)}\right\}>0 .
 \quad}                                                     \tag{2.3}
\]
It is valid even when d=0. For every \(0<\gamma\le\gamma_0\), set
\[
 Q_h(R)=P^{-1}[q_0(R)+\gamma C_P(h)g(R)].
\]
By (2.1)--(2.3),
\[
 \frac{q_0(R)}{2P}\le Q_h(R)\le\frac{3q_0(R)}{2P},
 \qquad \int Q_h=1/P.                                  \tag{2.4}
\]
Thus these functions define a probability law. Finite character
orthogonality, for every real v and every integer k, gives
\[
 \sum_h\int Q_h(R)e(vR+kh/P)\,dR
 =\widehat q_0(v){\bf1}_{P\mid k}
       +\gamma d(v){\bf1}_{\gcd(|k|,P)=1}.                \tag{2.5}
\]
Indeed, expanding C_P leaves the sum of
\(P^{-1}\sum_h e((k-a)h/P)\) over units a. This is precisely the
positive-character/negative-character pairing in `joint_transform`.
It includes negative k and nonunits, not just reduced positive indices.

## 3. All harmonics and the uniform finite-c bound

Fix the actual B and finite list only now. Under the law above, set
\[
 J_*=(R/B+h/P)/c,\qquad
 \rho(y)=cB\sum_{h=0}^{P-1}Q_h(B(cy-h/P)).
\]
For every B>0 and c>0 this is a strictly positive smooth probability
density. It has two-sided quadratic tails; the constants may depend on
B,c. For example, writing a=Bc and
\(C=1+2(1+B^2)/a^2\), (2.2)--(2.4) give
\[
 \rho(y)\le\frac{3cBC_0C}{2(1+y^2)},\qquad
 \rho(y)\ge
 \frac{cBc_0}{2P\max(1,a^2)(1+y^2)}.                    \tag{3.1}
\]
For the upper bound use
\(1+y^2\le C[1+(ay-Bh/P)^2]\); the h=0 summand gives
the lower bound. No uniformity of (3.1) over future B,c is needed.

Choose once from b,d,L a number
\[
 1/2<\tau<1,\quad D/(\tau b)<L,\qquad
 K=\left\lfloor D/(\tau b)\right\rfloor<L,\qquad
 C_1=P^{-1}\sum_h|C_P(h)|.
\]
For a signed input index m let x=m/B. For s=mct, the positive Fourier
moments of the periodized density of sJ_* are exactly
\[
 M_\ell(t)=\frac1P\sum_h e(\ell mt h/P)
       [\widehat q_0(\ell xt)+\gamma C_P(h)d(\ell xt)] .
                                                               \tag{3.2}
\]
This formula does not assume that \(\ell mt\) is an integer.
For every \(t\ge\tau\), the baseline vanishes for all \(\ell\ge1\),
because \(|\ell xt|\ge\tau b>\alpha\). For every \(\ell>K\)
the perturbation also vanishes, because \(|\ell xt|>D\).
Thus there are at most K positive harmonics even at finite c.

At t=1, (2.5) gives
\[
 M_1(1)=\gamma d(x){\bf1}_{\gcd(|m|,P)=1},\qquad
 M_\ell(1)=0\quad(\ell\ge2).                            \tag{3.3}
\]
For the second assertion, if d(ell*x) is nonzero then
\(2\le\ell\le D/b<L\). Any prime divisor p of ell lies below L,
divides P, and divides ell*m, for either sign of m. If m was already
a nonunit, the first harmonic in (3.3) is zero as well.
The general divisibility statement, including signed m, is
`higher_mode_zero`; it is not inferred from the finite searches.

For \(1\le\ell\le K\), use the global Lipschitz bound for d and
\(|e(v)-e(w)|\le2\pi|v-w|\). Since \(0\le h/P<1\), (3.2) yields
\[
 |M_\ell(t)-M_\ell(1)|
 \le\gamma C_1\ell(D_0A_1+2\pi|m|A)|t-1|.              \tag{3.4}
\]
This proves the manuscript's finite-c estimate with the phases left
noncharacter throughout the estimate.

For s in a fixed compact set away from zero define
\[
 {\cal P}_s\rho(y)=
       \sum_{n\in\mathbb Z}|s|^{-1}\rho((y+n)/s).
\]
The tails (3.1) imply uniformly summable tails of this series and joint
continuity in s,y. Its Fourier moments are exactly (3.2), also when s<0:
the absolute Jacobian in the definition removes the orientation issue.
Fourier uniqueness now identifies it with its finite Fourier polynomial.
For example, convolving the difference with the Fejer kernels gives zero
and converges uniformly to that continuous difference. Because its
moments have positive exponent, the reconstruction uses \(e(-\ell y)\).
Consequently, for \(t\ge\tau\),
\[
 \sup_y\left|{\cal P}_{mct}\rho(y)
       -[1+2\gamma{\bf1}_{\gcd(|m|,P)=1}
                       \operatorname{Re}(d(x)e(-y))]\right|
 \le \gamma C_1K(K+1)(D_0A_1+2\pi|m|A)|t-1|.           \tag{3.5}
\]

Put \(F=\|\phi\|_\infty\), \(H=F+1\), and
\(M=\max|m|\), taking M=0 for the empty list. Choosing
\(c\ge H/(1-\tau)\) makes
\[
 t_N(u)=1+(\phi(u)+\Delta_N)/c\ge\tau,\qquad
 |t_N(u)-1|\le H/c
\]
uniformly for all N>=1 and \(|\Delta_N|\le1/N\).
The same bounds hold after rounding has been removed.

For packet i=(r,m), let \(a_i=\|A_i\|_2^2\) and
\(T=\sum_i a_i\). Its stationary weight is
\[
 w_i(s)=\frac{|A_i(u,a)|^2}{|m\phi'(u)|},
             \qquad s=m(c+\phi(u)),
 \qquad \int_{\mathbb R}w_i=a_i.                       \tag{3.6}
\]
It is independent of a, nonnegative, smooth, compactly supported, and
zero near s=0. Summing (3.5) against these weights bounds the entire
finite-c density error by
\[
 \boxed{\quad
 E_c\le
 \frac{T\gamma C_1K(K+1)(D_0A_1+2\pi MA)H}{c}.
 \quad}                                                     \tag{3.7}
\]
All dependence on the actual maximum index is explicit in (3.7).
It requires c to grow, not gamma to shrink.

## 4. An actual bounded smooth cutoff law and its error

This paragraph proves the needed law realization rather than leaving
`lem:law-approx` as an assumption. For the strictly positive smooth
density rho above let
\(\mathcal F(y)=\int_{-\infty}^y\rho(v)\,dv\). It is a smooth
diffeomorphism from R to (0,1).

Given any positive missing-mass budget mu and good-arc complement budget
kappa, choose
\[
 0<\delta<\min(1/8,\mu/4,\kappa/2).
\]
Take a smooth real cutoff xi supported inside
\((\delta/2,1-\delta/2)\), equal to 1 on
\([\delta,1-\delta]\), and set
\[
 J(a)=\xi(a)\mathcal F^{-1}(a)
\]
on the circle, extending by zero near the identified endpoints.
This is a bounded smooth real circle function. On
\(I'=(\delta,1-\delta)\), it has
\(J'=1/\rho(\mathcal F^{-1}(a))>0\).
Choose a smooth \(0\le\psi\le1\), compactly supported in I',
equal to 1 on \([2\delta,1-2\delta]\). Its pushforward is exactly
\[
 \widetilde\rho(y)=\rho(y)\psi(\mathcal F(y))^2,\qquad
 0\le\widetilde\rho\le\rho,\qquad
 \|\rho-\widetilde\rho\|_1
   =1-\int\psi^2\le4\delta<\mu.                         \tag{4.1}
\]
It is smooth and compactly supported. The law is not renormalized.
Both its lost mass and \(|\mathbb T\setminus I'|=2\delta\) have
the required bounds.

Since \(|A_i|\) is independent of a, the physical cutoff error obeys
\[
 \|(1-\psi)A_i e(m\theta)\|_2^2
 =a_i\int(1-\psi)^2
 \le a_i\int(1-\psi^2)<a_i\mu.                         \tag{4.2}
\]
Thus the same choice of mu can enforce each prescribed positive
physical L2 transport tolerance. The possibly enormous bound on J
affects only the subsequent lower bound on N.

Here is the quantitative averaging fact used for law replacement.
If G(s,y) is continuous, supported in a slow interval of length ell,
and periodic of period p>0 in y, let
\(\omega_G(h)=\sup_{|s-s'|\le h,y}|G(s,y)-G(s',y)|\),
where G is zero-extended in s. Partition the real line into cells
of length p/N with endpoints chosen so that \(Ns+\beta\) traverses
one full period on each cell. Replacing the slow variable by a cell
endpoint in both integrals proves, uniformly in real beta,
\[
 \left|\int G(s,Ns+\beta)\,ds
       -\frac1p\int\!\int_0^pG(s,y)\,dy\,ds\right|
 \le2(\ell+2p/N)\omega_G(p/N).                         \tag{4.3}
\]
Only cells meeting the support contribute. Uniform continuity makes
the bound tend to zero for all sufficiently large integers N.
This also proves the general `lem:fast-average`.
For its law-comparison conclusion, the integral of a periodized absolute
density difference over one period is at most the original L1 difference
by the change of variables on the disjoint translated intervals. Dividing
by p gives exactly its factor \(1/p\).

For the present law comparison set
\[
 W(s)=\sum_iw_i(s),\qquad
 G(s,y)=W(s)|{\cal P}_s\widetilde\rho(y)
                          -{\cal P}_s\rho(y)|.
\]
Both periodizations are jointly continuous on the fixed compact s
supports, by compact support or (3.1). W vanishes near zero, so G
extends continuously there by zero. Pushforward and periodization
contract the L1 norm, hence
\[
 \int G(s,y)\,dy\,ds\le T\mu.
\]
With p=1, (4.3) gives the actual diagonal estimate
\[
 E_{\rm law}(N)\le
       T\mu+2(\ell+2/N)\omega_G(1/N).                   \tag{4.4}
\]
It is an averaged bound for the fixed family, not a purported pointwise
bound from total variation. All constants in (4.4) are fixed before N.

## 5. Restricted smooth passage, including rounding

The following proof establishes the P=1, spare-independent-weight
specialization of the passage that `lem:signal` needs. The unreviewed
general residue version of `lem:passage` is not being silently assumed.

First choose an integer c with \(c>F+1\) and \(c>2MF+2\), as well as
the requirements in section 3. For distinct old m,n, their full ranges
are contained in intervals centered at mc,nc of radii \(|m|F,|n|F\).
The separation is at least \(c-2MF>2\), and the ranges avoid zero.

Choose \(\Delta_N\) by rounding \(N\int(c+\phi)\) to an integer:
\[
 |\Delta_N|\le1/N,\qquad
 H_N'=N(c+\phi+\Delta_N),\qquad
 H_N(u+1)-H_N(u)\in\mathbb Z .
\]
Define
\[
 \sigma_N(a)=1/N+J(a)/N^2,\qquad
 C_N(\theta,u,a)=(u,a,\theta-H_N(u)).
\]
This is a global smooth torus diffeomorphism of Jacobian 1, with inverse
\((\theta',u',a')\mapsto(a'+H_N(\theta'),\theta',u')\).
Conjugating the twist of speed sigma_N by C_N gives exactly
\[
 T_N(\theta,u,a)=
  (\theta+H_N(u+\sigma_N(a))-H_N(u),u+\sigma_N(a),a).
                                                               \tag{5.1}
\]
It preserves volume. For every fixed derivative order k,
\[
 H_N(u+\sigma_N(a))-H_N(u)
 =N\int_0^{\sigma_N(a)}(c+\phi(u+t)+\Delta_N)\,dt
 =c+\phi(u)+O_{C^k}(1/N).                              \tag{5.2}
\]
The constants depend only on the already fixed c, J, derivatives of phi
and the fixed physical chart. The inverse formula uses the same integral
over the backward interval and has the same convergence. Since c is an
integer, (5.2) is convergence to the old S on the torus. Thus both maps
eventually lie in every prescribed smooth neighborhood, for all large N.
The new good arc is I', since \(\sigma_N'=J'/N^2>0\) there.

In the new coordinates the exact old packet Fourier coefficients are
\[
 C_{i,j}(a)=\int A_i(u,a)e(mH_N(u)-ju)\,du.
\]
Choose real \(0\le\chi_i\le1\), supported in arbitrarily small
disjoint s-neighborhoods of
\(E_i=m(c+\phi(\operatorname{proj}_u\operatorname{supp}A_i))\),
and equal to 1 on a smaller neighborhood. These cutoffs may depend only
on s because different old m are distinct and their full ranges have
already been separated. The retained finite outputs are
\[
 G_{i,j}(\theta',u',a')
 =e(j\theta')e(ma')\psi(u')\chi_i(j/N)C_{i,j}(u').
                                                               \tag{5.3}
\]
Their angular indices are nonzero and the ranges of different old
indices are disjoint.

For clarity, the analytic coefficient estimate needed here can be proved
directly. On a compact subarc containing the amplitude support, the
stationary equation is
\[
 m(c+\phi(u)+\Delta_N)=s,\qquad s=j/N.
\]
There is at most one solution, and its second phase derivative is
\(m\phi'(u)\), bounded away from zero on a slightly enlarged compact
subarc. At a critical point u_* the leading term is
\[
 L_{i,j}(a)=
 \frac{A_i(u_*,a)}{\sqrt{N|m\phi'(u_*)|}}
 e(mH_N(u_*)-ju_*+\operatorname{sgn}(m)/8).
\]
It is zero if there is no critical point in the branch or the amplitude
there vanishes.

Here are details giving a uniform remainder, rather than an appeal to an
unchecked stationary-phase citation. When u_* lies in the enlarged compact
subarc, the one-dimensional Morse coordinate
\[
 y=\operatorname{sgn}(u-u_*)
   \sqrt{2\operatorname{sgn}(m)(f_s(u)-f_s(u_*))}
\]
reduces the divided phase to
\(f_s(u_*)+\operatorname{sgn}(m)y^2/2\).
It is smooth and invertible across u_*, because
\(\operatorname{sgn}(m)f_s''=|m|\phi'>0\).
After extension by zero, the transformed amplitudes b are smooth,
compactly supported, and have uniformly bounded L1 norms of their
derivatives through order four. Uniformity is over the fixed compact
critical-point, a, and rounding parameters; these are finite-data bounds,
not bounds uniform over future passages.

For such b, Fourier inversion and a damped Gaussian integral give
\[
 \int b(y)e(N\varepsilon y^2/2)\,dy
 =N^{-1/2}e(\varepsilon/8)
       \int\widehat b(v)e(-\varepsilon v^2/(2N))\,dv,
       \qquad \varepsilon\in\{-1,1\}.
\]
To justify the identity insert a positive Gaussian damping factor,
evaluate by completing the square, and pass to the limit. The transformed
Gaussian factors are bounded by \(N^{-1/2}\), and \(\widehat b\) is
integrable, so dominated convergence applies. In particular its error
from \(N^{-1/2}e(\varepsilon/8)b(0)\) is at most
\[
 \pi N^{-3/2}\int v^2|\widehat b(v)|\,dv
 \le \pi N^{-3/2}
    \left(\tfrac23\|b\|_1+\tfrac2{(2\pi)^4}\|b^{(4)}\|_1\right).
                                                               \tag{5.4}
\]
The final inequality splits at |v|=1 and integrates by parts four
times. If the potential critical point is outside the enlarged subarc,
two integrations by parts give an \(O(N^{-2})\) nonstationary error,
uniformly on the fixed compact s range. Outside a sufficiently large
\(|j|\le RN\) range, repeated integration by parts instead gives
\(|C_{i,j}|\le C_q|j|^{-q}\), uniformly in N and a: the first phase
derivative is comparable to |j| and all higher ones are O(N)=O(|j|).
These statements cover the whole index array, including ends of supports.

There are O(N) indices in the compact range. Taking q=2 outside it,
(5.4) therefore proves
\[
 \sum_j\int|C_{i,j}-L_{i,j}|^2\,da=O(N^{-2}),\qquad
 \sum_j\int\left||C_{i,j}|^2
      -N^{-1}w_i(j/N-m\Delta_N)\right|\,da=O(N^{-1}).     \tag{5.5}
\]
The second bound is Cauchy--Schwarz, using Parseval for the exact array
and a bounded Riemann sum for the leading array. Every constant depends
only on this fixed packet, c, phi and finitely many amplitude/phase
derivatives. The cutoffs equal 1 on the leading support for all sufficiently
large N, so (5.5) remains valid after retention and multiplication by psi.
Parseval also gives
\[
 \left\|\sum_jG_{i,j}\circ C_N-\psi A_i e(m\theta)\right\|_2
       =O(N^{-1}).                                      \tag{5.6}
\]

**Rounding is removed now, before pushing any mass to temporal frequency.**
The smooth compactly supported w_i has a bounded derivative. If its
support is contained in an interval of length ell_i, then
\[
 \frac1N\sum_j|w_i(j/N-m\Delta_N)-w_i(j/N)|
 \le\frac{|m|}{N}\|w_i'\|_\infty
           [\ell_i+2(|m|+1)/N].                         \tag{5.7}
\]
Indeed every nonzero summand lies in the union of an interval and its
translate, and the difference is at most
\(|m\Delta_N|\|w_i'\|_\infty\). Multiplication by psi squared
does not enlarge this bound. Pushforward contracts total variation.
Thus (5.5)--(5.7) replace the exact retained squared coefficients by
\(N^{-1}w_i(j/N)\psi(a)^2\,da\) at O(1/N) total mass error.
No occurrence of the lattice j/N or the fast phase is translated.

Define the fixed smooth compactly supported kernel
\[
 K_i(s,y)=w_i(s)|s|^{-1}\widetilde\rho(y/s),
\]
zero-extended near s=0. Under the real temporal-frequency map
\[
 t=j\sigma_N(a)=j/N+(j/N)J(a)/N
\]
the density of this replacement measure is **exactly**
\(K_i(j/N,Nt-j)\): the Jacobian N cancels the coefficient mass 1/N.
Choose \(Y\ge1\) containing its y support, and let
\(L_i=\|\partial_sK_i\|_\infty\). At each t at most 2Y+2 integer
indices contribute, with \(|j/N-t|\le Y/N\). On a fixed interval
of length \(L_t\) containing both t supports,
\[
 \left\|\sum_jK_i(j/N,Nt-j)-\sum_jK_i(t,Nt-j)\right\|_1
 \le L_t(2Y+2)L_iY/N.                                  \tag{5.8}
\]
For example \(L_t=2(R_i+Y+1)\) works if \(|s|\le R_i\)
on the kernel support. This proves that the true unfolded density differs
by at most \(C_i/N\), for all sufficiently large N, from
\[
 \sum_jK_i(t,Nt-j)=w_i(t){\cal P}_t\widetilde\rho(Nt).
                                                               \tag{5.9}
\]
Here C_i is the sum of the fixed coefficient-mass, rounding, and explicit
sampling constants just given. Folding modulo one contracts L1. This is
the full analytic transfer needed for the signal theorem, including its
all-sufficiently-large-N quantifier.

## 6. Density conclusion, supports, and the order of every choice

Since mc is an integer, folding w_i gives exactly the old packet density:
\[
 p_i(z)=\sum_{n\in\mathbb Z}w_i(z+n).
\]
Also \(e(-N(z+n))=e(-Nz)\) for every integer N. Combining
(3.5)--(3.7), (4.4), and (5.9), including every packet in the finite
sum, gives
\[
 \boxed{\quad
 \begin{split}
 &\sum_i\left\|p_i^+
  -p_i(z)[1+2\gamma{\bf1}_{\gcd(|m_i|,P)=1}
                 \operatorname{Re}(d(m_i/B)e(-Nz))]\right\|_1\\
 &\quad\le
 \frac{T\gamma C_1K(K+1)(D_0A_1+2\pi MA)H}{c}
 +T\mu+2(\ell+2/N)\omega_G(1/N)
 +\frac{\sum_iC_i}{N}.
 \end{split}
 \quad}                                                     \tag{6.1}
\]
Each \(C_i\), the interval length ell, and the continuous-family modulus
in (6.1) are fixed after c, J, psi and the cutoffs, before N.
Their dependence on B, the finite packet list, and its derivatives is
allowed. None enters the definition of P or gamma_0.

For support control choose a positive enlargement eta_0 after c, and
choose chi_i supported within eta_0/2 of E_i. When
\(N>2M/\eta_0\), every retained index has, for some old support point u,
\[
 j/N=m(c+\phi(u)+\Delta_N)+\eta,\qquad |\eta|<\eta_0.
\]
Because \(|A_i|\) is independent of a, its support is a product in a,
so u can indeed be completed to a point of the old coefficient support.
With \(B^+=NcB\), direct subtraction gives the source's safe bounds
\[
 |j/B^+-m/B|\le D_0H/c+\eta_0/(cB),                    \tag{6.2}
\]
\[
 \operatorname{dist}_{\mathbb T}(j\sigma_N(u'),m\phi(u))
 \le M/N+\eta_0+
       [M(c+H)+\eta_0]\|J\|_\infty/N.                  \tag{6.3}
\]
The sign of m is harmless in these absolute-value estimates.

A single valid selection schedule is now explicit:

1. From b,D_0,d alone choose alpha, D, L, P, gamma_0, tau, K,
   C_1. Fix any permitted positive gamma, before B or the packet list.
2. For the actual finite data compute M,T,F,H,A,A_1. Choose an integer c
   satisfying the range-separation requirements, \(c\ge H/(1-\tau)\),
   \(D_0H/c<\delta_x/4\), and the first term of (6.1) less than
   epsilon/4. Zero masses and an empty list impose no extra restriction.
3. Choose eta_0 small enough for disjoint cutoffs, avoidance of zero,
   \(\eta_0/(cB)<\delta_x/4\), and \(\eta_0<\delta_z/4\).
   Choose mu with \(T\mu<\epsilon/4\) and
   \(\sqrt{a_i\mu}\) less than half of each prescribed positive L2
   transport bound. Realize rho by the bounded J and psi of section 4,
   with the requested good-arc complement. All choices remain independent
   of N.
4. Choose N beyond every resulting finite lower bound: make the last
   two terms of (6.1) total less than epsilon/2; enforce (5.6) for the
   other half of every L2 transport bound; enforce (6.3) below delta_z;
   and enforce the requested forward/inverse physical smooth neighborhood
   by (5.2). Any prescribed additional lower bound on N can be included.

This schedule works for **every** integer N above one threshold, not just
for a selected sequence. Formula (6.2) is already below delta_x.
For clarity, after J is fixed a sufficient extra temporal condition is
\[
 N>4\{M+[M(c+H)+\eta_0]\|J\|_\infty\}/\delta_z,
\]
besides \(N>2M/\eta_0\). All little-error and O(1/N) estimates concern
fixed smooth data, so increasing N preserves the conclusions.

Finally (5.3) is \(e(ma')\) times a function of u', proving independence
of the new spare-coordinate modulus. Distinct old indices have disjoint
retained j ranges by the c choice and the cutoffs. For conjugate pairs
take real psi and \(\chi_{-m}(s)=\chi_m(-s)\); the exact coefficient
identity \(C_{-m,-j}=\overline{C_{m,j}}\) preserves conjugation.
These observations prove all remaining assertions of `lem:signal`,
including physical L2 approximation by (4.2) and (5.6).

## 7. Dependency and certification boundary

The analytic proof has independently established the positive law, the
uniform finite-c estimate (3.7), the general quantile realization,
fast averaging, and the restricted smooth passage (5.1)--(5.9).
It does not rely on the truth of the manuscript's general `lem:passage`
or its full residue formula. It uses ordinary Fourier inversion,
change of variables, Parseval, and Gaussian integration, with the needed
specialized estimates derived above. No specialized external literature
theorem is being imported on an unchecked citation.

The source dependency route through the general passage is retained in
the ledger. The independent verification route replaces that obligation
by `C144_SIGNAL_TRANSFER`, the restricted statement proved here.
The general passage still remains open on the neutral-refresh route.
Thus closing the local signal lemma would not close the campaign.

`verify.py` is standalone standard-library Python. Its default mode
recomputes the exact finite results and compares them with
`exact_certificate.json`; it does not claim to verify an infinite
analytic theorem by sampling. The parameter-budget examples assume the
explicit norm budgets printed in the certificate; they are not described
as constructed smooth jitter laws. The actual law and smooth map are
constructed in sections 4--5 for arbitrary admissible data.

`Main.lean` proves the finite-character identities and sieve for all
parameters in its statement, not only the script's examples. The
successful compiler certificate and its statement-fidelity document must
be read separately from the analytic proof. Independent Reviewer replay
and judgement of the full analytic theorem remain required; Engineer
support is not independent certification. Novelty and publishable
significance of any campaign-level result remain unestablished.
