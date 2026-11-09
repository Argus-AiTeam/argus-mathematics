# Stability of the normalized-height bridge

## Result and its exact scope

**Theorem.** The staged Proposition `prop:height-equation` is valid under
its stated hypotheses, including the hypotheses of both Section 04
lemmas. Its limit is the very same height, on the very same subsequence,
as in `lem:moving-compactness`. No graph parametrization, regularity of
source densities, bound on the normalized origin value, or rate for
measure convergence or mean correction is required.

There is a strengthening: throughout the energy-to-equation argument,
the cubic oscillation bound can be replaced by
\[
 |\mathcal R_{\mu_j}(\xi)|
       \le D\delta_j^2(\operatorname{Lip}\xi+1)                 \tag{Q}
\]
for a fixed finite \(D\), for the same compact, current-measure-mean-zero
tests. In particular the version with \(D\delta_j^2\operatorname{Lip}\xi\)
also suffices. This improves the oscillation exponent in the staged
bridge, not the manuscript's main theorem. No novelty or publishability
claim is made for this strengthening.

This is an analytic proof, not a finite experiment and not a complete
Lean formalization of the bridge. `Main.lean` proves the universal cutoff
and finite-variance algebra and the two rate-free limit principles.
`verify.py` independently replays the exact algebra, typed Jacobian
factorization, horizon arithmetic, and freshness of that real compiler
record. Neither of those checks substitutes for review of this proof.

### Source anchors

Paths below are relative to
`research/openai_manuscript/Riesz-transforms-and-uniform-rectifiability-in-higher-codimension-September-24-2026/build/sections/`.

| Assertion | Exact location | Role here |
|---|---|---|
| Mean-zero pairings and weak limits | `01-background.tex`, `lem:pairings` (line 86), `lem:weak-compactness` (line 156) | Cancellation, growth estimates, support control |
| Common reference-plane moments | `03-planar-limits.tex`, `lem:fixed-plane-moments` (line 115), `prop:flat-limit` (line 491) | Upstream source of the hypotheses, not presumed proved by this audit |
| Uniform normalized energy | `04-height-compactness.tex`, `lem:height-energy` (line 32), `eq:height-cutoff-identity` (line 129), `eq:height-exterior-bound` (line 225) | Proved below, including the remote factor of delta |
| Signed and squared moments | `04-height-compactness.tex`, `lem:moving-compactness` (line 287), `eq:height-cell-variance` (line 400), `eq:height-three-measures` (line 512) | Proved below |
| The exact target | `05-fractional-rigidity.tex`, `prop:height-equation` (line 110), `eq:height-source-moment` (line 123), `eq:height-source-oscillation` (line 132) | Full statement verified below |
| Diagonal and exterior limits | `05-fractional-rigidity.tex`, `eq:height-diagonal-estimate` (line 50), `eq:two-height-tail-errors` (line 220), `eq:fixed-normalization-convergence` (line 249) | All three passages justified below |
| Horizon schedule | `06-excess-propagation.tex`, `eq:sequential-horizon-schedule` (line 189), `eq:uniform-propagation-constants`, and the proof of `thm:excess-propagation` (line 319 onward) | Checked separately in Section 7 below |

### Complete hypothesis audit

Let \(1\le n<d\), \(0<\gamma<1\), and
\(\nu=q\mathcal H^n|_L\), where \(q>0\), \(L\) is a linear \(n\)-plane,
and plane Hausdorff measure is Euclidean Lebesgue measure.
The source hypotheses are the following.

1. The Radon measures \(\mu_j\) have global upper \(n\)-growth with the
same \(G\); \(0\) belongs to their supports; their support diameters
tend to infinity. The moving-compactness lemma also assumes one lower
bound \(cr^n\) **at every support point**, for every admissible radius.
The energy lemma only needs this lower bound at zero.
2. They converge against compact continuous tests to the specified
full constant-density plane measure \(\nu\). Constancy and positivity
are hypotheses at this point, supplied upstream by `prop:flat-limit`;
they are not inferred merely from support convergence.
3. Each \(u_j\) is affine, with gradient \(e_j\), \(|e_j|\le1\), and
bounded unnormalized origin value. Write \(w_j=u_j/\delta_j\), where
\(\delta_j>0\) tends to zero.
4. There are integers \(K_j\to\infty\), a fixed \(M\), and the bounds
\[
 \int_{B(0,2^k)}u_j^2\,d\mu_j
       \le M\delta_j^2 2^{k(n+2+2\gamma)}
       \quad(0\le k\le K_j),\qquad
 \delta_j^{-1}2^{-K_j}\longrightarrow0.                       \tag{1}
\]
5. Oscillation is small for **all** compact ambient Lipschitz tests
of zero \(\mu_j\)-mean in \(B(0,A_j)\), where \(A_j\to\infty\).
The source cubic bounds imply (Q) after omitting finitely many indices.
No relation between the rate of \(A_j\) and that of \(\delta_j\) is used.

The hard-truncation operator bound is used upstream to obtain the plane
limit, but is not an extra input to the proof below. The condition
\(\delta_j2^{\gamma K_j}\to0\) is likewise upstream reference-plane
control, not an additional hidden requirement for this proposition.
The restriction \(\gamma<1/2\) is needed by the displayed propagation
schedule, whereas this bridge itself only needs \(\gamma<1\).
No source graph or density is introduced. A zero affine gradient is
allowed. Finitely many initial indices affect constants, not limits.

The bound on \(u_j(0)\) is also recoverable if one uses only the
proposition's displayed restatement: weak convergence to \(\nu\) gives
\(\mu_j(B(0,1))\ge m_0>0\) eventually, and the affine Lipschitz bound and
the moment at \(k=0\) imply
\[
 |u_j(0)|\le 1+
       \left(\frac{\int_{B(0,1)}u_j^2\,d\mu_j}
                        {\mu_j(B(0,1))}\right)^{1/2}
       \le 1+\sqrt{M/m_0}\,\delta_j.                          \tag{2}
\]
This does not bound \(u_j(0)/\delta_j\).

## 1. Energy without circular use of energy

Upper growth, decomposing a ball into annuli with radii
\(h, h/2,\ldots\), gives
\[
 \int_{0<|x-y|\le h}|x-y|^{1-n}\,d\mu_j(y)
       \le C_nGh.                                           \tag{3}
\]
It also implies no atoms. Equation (3) proves absolute integrability of
the Lipschitz-cancelled local Riesz pairing and of local affine and
cutoff energies before any quantitative bound is asserted.
For exterior points, \(|\nabla K_n(z)|\le C_n|z|^{-n-1}\).
The base-point kernel difference therefore has an absolutely integrable
tail, of size \(O(T^{-1})\) for any fixed compact test.
All splitting operations below can first be done with finite inner and
outer cutoffs and then justified by these estimates.

Fix \(H\ge1\). Choose \(0\le\chi\le1\), equal to one on \(B(0,H)\),
supported in \(B(0,3H/2)\), and with Lipschitz constant at most \(2/H\).
Let \(R\ge4H\) be dyadic and \(D_R=B(0,R)\).
All following bounds concern sufficiently large \(j\), with this fixed
\(H,R\); their constants are independent of \(j\).
Suppress \(j\), and set
\[
 b=\frac{\int\chi^2u\,d\mu}{\int\chi^2\,d\mu},\quad
 U=u-b,\quad \phi=\chi^2U .
\]
The denominator is at least \(cH^n\), eventually at an admissible radius.
Moments at \(R\) and Cauchy--Schwarz give
\[
 |b|\le C_H\delta,\quad \int_{D_R}U^2\,d\mu\le C_H\delta^2,
 \quad \int|\phi|\,d\mu\le C_H\delta,\quad
 \int|\phi U|\,d\mu\le C_H\delta^2.                          \tag{4}
\]
These are second-moment estimates, not consequences of unknown energy.
The compact test \(\phi\) has zero measure mean and a uniformly bounded
Lipschitz constant: on its fixed support
\(|U|\le W+2H+C_H\), and the cutoff handles the boundary.
Under (Q),
\[
 |e\cdot\mathcal R_\mu(\phi)|\le C_H D\delta^2.               \tag{5}
\]
Under the original cubic bound the right side is \(C_H\delta^3\).

With \(k(x-y)=|x-y|^{-n-1}\), the **exact** cutoff identity is
\[
 (U_x-U_y)(\chi_x^2U_x-\chi_y^2U_y)
   =(\chi_xU_x-\chi_yU_y)^2-U_xU_y(\chi_x-\chi_y)^2.          \tag{6}
\]
The last integral's absolute value is bounded by
\[
 C_nGR\,\operatorname{Lip}(\chi)^2
                  \int_{D_R}U^2\,d\mu\le C_H\delta^2,       \tag{7}
\]
using (3), symmetry, and \(2|U_xU_y|\le U_x^2+U_y^2\).
The sign in (6) is crucial; neither \(U_xU_y\ge0\) nor a vanishing
normalized energy is assumed.

The normal scalar component of the Riesz pairing has interior part
one half the integral of the left side of (6), and exterior part
\[
 E_{\rm out}=\int\phi(x)\int_{D_R^c}
  \big[U(x)k(x-y)-U(y)\{k(x-y)-k(-y)\}\big]\,d\mu(y)d\mu(x). \tag{8}
\]
The base-point formula initially has one more term,
\(-U(0)k(-y)\). Its exterior kernel is separately integrable and its
test integral is zero, so it vanishes without an estimate on a
normalized origin value. The difference multiplying \(U(y)\) in (8)
must be kept together.

For \(|x|\le2H\), \(|y|\ge R\),
\[
 k(x-y)\le C_n|y|^{-n-1},\qquad
 |k(x-y)-k(-y)|\le C_nH|y|^{-n-2}.                          \tag{9}
\]
Write \(S=2^K\). On any controlled dyadic shell
\(t\le|y|<2t\), \(R\le t<S\), the moment at \(2t\) and upper growth give
\[
 \int_{t\le|y|<2t}|U(y)|\,d\mu(y)
       \le C_H\delta t^{n+1+\gamma}.
\]
Thus its contribution with weight \(|y|^{-n-2}\), summed over the
controlled shells, is at most \(C_H\delta\). Beyond \(S\), the
unnormalized affine bound \(|U(y)|\le |y|+W+C_H\) gives at most
\(C_H S^{-1}\). The half-open shells and the closed final exterior
include their boundary spheres. Inserting these bounds and (4) in (8),
\[
 |E_{\rm out}|\le C_H(\delta^2+\delta S^{-1}).               \tag{10}
\]
In particular the test contributes a factor \(\delta\) to the remote
term; replacing it by an \(O(1)\) bound would be incorrect.

Equations (5)--(10), with the interior factor \(1/2\), imply
\[
 \mathcal E_{\mu,D_R}(\chi U)
       \le C_H((1+D)\delta^2+\delta S^{-1}).
\]
On \(B(0,H)\) differences of \(\chi U\) are differences of \(u\).
After division by \(\delta^2\),
\[
 \mathcal E_{\mu,B(0,H)}(w)
       \le C_H(1+D+\delta^{-1}2^{-K}).                      \tag{11}
\]
The local \(L^2\) bound follows directly from (1).
The last term in (11) is bounded by hypothesis.
Each omitted initial term is a locally Lipschitz affine function divided
by its own positive \(\delta_j\); (3) gives its finite local energy.
This proves `lem:height-energy`, as well as its quadratic strengthening.

## 2. Moving measures: why the squared moments have no defect

Fix orthonormal coordinates \(\pi:\mathbb R^d\to\mathbb R^n\) on \(L\).
Use exactly the source's bounded regions
\[
 Q_H=(-(H+1),H+1)^n,\qquad
 \Omega_H=\pi^{-1}(Q_H)\cap
      B(0,(\sqrt n+1)(H+1)).
\]
They exhaust space. Their boundaries meet \(L\) only in the coordinate
faces, which are \(\nu\)-null. Weak convergence therefore passes to
finite restrictions on their common compact closures.

The lower bound **at all support centers** implies the qualitative
tube estimate
\[
 \sup_{x\in\operatorname{supp}\mu_j\cap B(0,R)}
                         \operatorname{dist}(x,L)\to0       \tag{12}
\]
for each fixed \(R\). Otherwise a bounded sequence of support points
away from \(L\) has a subsequential limit away from \(L\). A fixed small
ball around each point has mass bounded below, with admissible radius
eventually. A continuous cutoff supported away from \(L\), in a slightly
larger ball, contradicts weak convergence. No convergence rate follows
or is needed.

Partition the projection box into finitely many half-open dyadic cells
of side \(h=2(H+1)2^{-k}\); intersect their projection cylinders with
\(\Omega_H\) to obtain the disjoint cells \(C_D\).
Each cell and each intersection of cells has \(\nu\)-null boundary.
For every fixed level \(k\),
\[
 \mu_j(C_D)\to qh^n,\qquad
 \mu_j(C_D\cap C_{D'})\to\nu(C_D\cap C_{D'}).                \tag{13}
\]
In particular the finitely many cell masses are at least \(qh^n/2\)
eventually. By (12), actual source support points in each cell have
mutual distance at most \((\sqrt n+2)h\), eventually at that fixed
level. This is not a diameter assertion about the whole cylinder.

For the cell average \(m_{j,D}\), the integral variance identity gives
\[
 \begin{split}
 \int_{C_D}|w_j-m_{j,D}|^2\,d\mu_j
 &=\frac{1}{2\mu_j(C_D)}
           \iint_{C_D^2}|w_j(x)-w_j(y)|^2\,d\mu_j(x)d\mu_j(y)\\
 &\le C_nq^{-1}h\,\mathcal E_{\mu_j,C_D}(w_j).
 \end{split}                                               \tag{14}
\]
It follows directly by expanding the square and using Fubini; the
positive cell mass is indispensable for the division.
Summing (14) gives for the step function \(P_k^jw_j\)
\[
 \|w_j-P_k^jw_j\|_{L^2(\mu_j|_{\Omega_H})}^2\le C_Hh.        \tag{15}
\]
There is **no factor equal to the number of cells**.

At fixed \(H,k,D\), Cauchy--Schwarz, (13), and the local norm bound
bound each cell average. A single diagonal subsequence makes every
cell average converge, for all countably many \(H,k,D\), and for all
members of the finite family of heights at once.
The limits define plane step functions \(P_{H,k}\).
At two fixed levels, (13) passes the squared difference of the source
step functions to its plane counterpart. Equation (15) then makes
the plane step functions Cauchy in \(L^2(\nu|_{\Omega_H})\).
Let their limit be \(v_H\).

The reverse triangle inequality, (15), and convergence of the finite
step-function norms imply
\[
 \|w_j\|_{L^2(\mu_j|_{\Omega_H})}\to
                          \|v_H\|_{L^2(\nu|_{\Omega_H})}.    \tag{16}
\]
For any continuous \(\psi\) on the compact closure, the error in
replacing \(w_j\) by its step function when testing against \(\psi\)
is at most \(C_H\sqrt h\,\|\psi\|_\infty\).
At fixed \(k\), weak convergence on the continuity cells passes the
step-function integral to the limit. Taking \(j\to\infty\) first,
then \(k\to\infty\), proves the signed-moment limit for **every** such
\(\psi\); no uncountable diagonal extraction is involved.
The limits \(v_H\) agree on overlaps: test the two signed limits
against compact Lipschitz functions supported in the overlap and use
density in local plane \(L^2\). Thus they define one measurable \(v\).

To pass a continuous weight against squares, approximate \(v\) in
\(L^2(\nu|_{\Omega_H})\) by a fixed bounded ambient Lipschitz function
\(g\), using plane approximation followed by projection and a compact
ambient cutoff. Equations (16), the signed limit, and ordinary weak
convergence give
\[
 \lim_j\int_{\Omega_H}|w_j-g|^2\,d\mu_j
                        =\int_{\Omega_H}|v-g|^2\,d\nu.      \tag{17}
\]
Moreover,
\[
 \left|\int\psi(w_j^2-g^2)\,d\mu_j\right|
 \le\|\psi\|_\infty\|w_j-g\|_2(\|w_j\|_2+\|g\|_2).
\]
First take \(j\to\infty\) for fixed \(g\), pass the continuous term
\(\psi g^2\) by weak convergence, and then let \(g\to v\) in plane
\(L^2\). The other norm factors remain bounded after the first limit.
The result is the three finite-measure convergences
\[
 \mu_j|_{\Omega_H}\to\nu|_{\Omega_H},\quad
 w_j\mu_j|_{\Omega_H}\to v\nu|_{\Omega_H},\quad
 w_j^2\mu_j|_{\Omega_H}\to v^2\nu|_{\Omega_H}.               \tag{18}
\]
The middle measures have bounded total variation by Cauchy--Schwarz.
An arbitrary plane representative of \(v\) has never been evaluated on
a different source measure. This proves all of `lem:moving-compactness`,
not just its weak first-moment assertion.

### A genuine obstruction to a weaker, but unstated, variant

The support-centered lower bound in this lemma cannot simply be
discarded. For \(t_j\downarrow0\), let
\[
 \mu_j=\mathcal H^n|_{L_0}+t_j^2\mathcal H^n|_{L_1},
 \qquad
 w_j|_{L_0}=0,\quad w_j|_{L_1}=t_j^{-1},
\]
where \(L_0=\mathbb R^n\times\{0\}\) and
\(L_1=\mathbb R^n\times\{1\}\) in \(\mathbb R^{n+1}\).
For \(0<t_j\le1\) these measures have upper growth \(2\omega_n\),
converge weakly to plane volume on \(L_0\), and have uniformly bounded
local norms and energies: on \(B(0,R)\) the cross-sheet energy is
\[
 2\iint_{(L_0\cap B(0,R))\times(L_1\cap B(0,R))}
                         |x-y|^{-n-1}\,d\mathcal H^n(x)d\mathcal H^n(y),
\]
independent of \(j\) and finite since \(|x-y|\ge1\).
But their signed height measures tend to zero and their squared height
measures are exactly \(\mathcal H^n|_{L_1}\), a nonzero defect off
the limit plane. At a point of \(L_1\) and \(r<1/2\), the ball mass is
\(t_j^2\omega_n r^n\); no common positive lower bound exists.
This is a counterexample to a **weakened** compactness statement, not
to the manuscript. It explains exactly which already-stated hypothesis
prevents that failure. No `F_` manuscript claim is warranted by it.

## 3. Passing the singular diagonal to the same height

Fix one \(\Omega=\Omega_H\) large enough for the localization. On its
compact closure, products of the measures in (18) converge against
continuous product kernels. Indeed continuous kernels on that compact
product are uniformly approximable by finite sums \(a(x)b(y)\);
uniform total-variation bounds control the approximation error.
One can obtain these sums directly by continuous partitions of unity
on finite small-ball covers of each compact factor.

For \(k_h(x,y)=\max\{h,|x-y|\}^{-n-1}\), expand the energy as the two
products of a squared-height measure with an ordinary measure, minus
twice the product of the signed-height measures. Equation (18) passes
this capped energy to the limit. Its value for the source is at most
the uniformly bounded uncapped energy. Monotone convergence as
\(h\downarrow0\) gives finite local energy for \(v\).
The diagonal is null because positive-dimensional upper growth gives
no atoms.

For a fixed compact Lipschitz \(\phi\), Cauchy--Schwarz and (3) give
\[
 \begin{split}
 &\iint_{\Omega^2,\ |x-y|\le h}
 |w(x)-w(y)|\,|\phi(x)-\phi(y)|\,|x-y|^{-n-1}\,d\rho^2\\
 &\hspace{8mm}\le C_n\operatorname{Lip}(\phi)
       \mathcal E_{\rho,\Omega}(w)^{1/2}
                           (G\rho(\Omega)h)^{1/2}.          \tag{19}
 \end{split}
\]
It holds for the sources and the limit with one uniform constant.
For the capped bilinear form, expand linearly in the signed and
ordinary measures in (18); all coefficients involving \(\phi\) are
continuous. Its error from uncapping is bounded by (19).
Thus fixing \(h\), passing \(j\to\infty\), and finally taking
\(h\downarrow0\) proves the uncapped bilinear limit.
No Lipschitz bound on \(w_j=u_j/\delta_j\) uniform in \(j\) is used.

## 4. Inherited moments and the complete exterior estimate

Use the squared-measure convergence in (18) and nonnegative compact
cutoffs inside a larger dyadic ball. For every fixed \(t\ge1\), (1)
passes to
\[
 \int_{L\cap B(0,t)}v^2\,d\nu\le C t^{n+2+2\gamma}.        \tag{20}
\]
Changing the enclosing radius by a factor at most two avoids any
assertion about source mass on spheres. Every fixed radius eventually
lies below the actual horizon.
On a dyadic shell \(t\le|y|<2t\), Cauchy--Schwarz and (20) give
\(\int |v|\,d\nu\le C t^{n+1+\gamma}\). Consequently
\[
 \int_{|y|>T}|v(y)|\,|y|^{-n-2}\,d\nu(y)
       \le C_\gamma T^{\gamma-1}\quad(T\ge2).               \tag{21}
\]
This is a convergent geometric sum because \(\gamma<1\).
Together with local \(L^2\) and \(q>0\), it proves precisely
\(\int_L|v|(1+|x|)^{-n-2}\,d\mathcal H^n<\infty\).

For the sources, the same computation on controlled shells gives,
for \(2H<T\le2^{K_j}\),
\[
 \int_{T<|y|<2^{K_j}}|w_j(y)|\,|y|^{-n-2}\,d\mu_j(y)
       \le C_\gamma T^{\gamma-1}.                          \tag{22}
\]
If \(T\) is not dyadic, start with the dyadic shell at a radius
between \(T/2\) and \(T\). The source moment at each shell's outer
radius is still within the horizon. For the actual last exterior,
the affine bound, (2), and upper growth give
\[
 \int_{|y|\ge2^{K_j}}|w_j(y)|\,|y|^{-n-2}\,d\mu_j(y)
       \le C\delta_j^{-1}
                       (2^{-K_j}+2^{-2K_j})
       \le C\delta_j^{-1}2^{-K_j}.                         \tag{23}
\]
No moment beyond \(2^{K_j}\) has been substituted.

For any fixed compact Lipschitz test \(\psi\), including a nonzero-mean
test, the part of its normalized exterior pairing with \(|y|>T\)
is, by (9), at most
\[
 \begin{split}
 &\frac{C}{T}\int|\psi w_j|\,d\mu_j\\
 &\quad+CH\int|\psi|\,d\mu_j
                \int_{|y|>T}|w_j(y)|\,|y|^{-n-2}\,d\mu_j(y)\\
 &\hspace{8mm}\le C_\psi\left(
       T^{-1}+T^{\gamma-1}+\delta_j^{-1}2^{-K_j}\right).
 \end{split}                                               \tag{24}
\]
The local norm and mass bounds control both test integrals.
The limiting estimate is \(C_\psi(T^{-1}+T^{\gamma-1})\) by (21).
These are exactly the three asserted errors. The order of limits is
fixed \(T\), then \(j\to\infty\), then \(T\to\infty\), never
an unproved simultaneous choice of \(T_j\).

## 5. One normalization removes the apparent mean-correction problem

For a bounded continuity region \(A=\Omega_m\) containing a ball
\(B(0,R)\), \(R>2H\), define, exactly as in the manuscript,
\[
 \begin{split}
 B_{\rho,A}(w,\psi)
 &=\frac12\iint_{A^2}(w(x)-w(y))(\psi(x)-\psi(y))k(x-y)\,d\rho^2\\
 &\quad+\int_A\psi(x)\int_{A^c}
    [w(x)k(x-y)-w(y)\{k(x-y)-k(-y)\}]\,d\rho(y)d\rho(x).
 \end{split}                                               \tag{25}
\]
Equation (19) proves the interior's absolute convergence, and the
weighted tail with (9) proves the exterior's. In particular this
normalization is defined even for tests of nonzero measure mean.
Its dependence on \(A\) in that case is not denied.

For each fixed \(\psi\), its interior limit follows from Section 3.
For the bounded exterior restrict first to a larger continuity region
\(B=\Omega_l\). The nonzero test variable stays a positive distance
from \(A^c\), so the kernel has no singularity there.
Restrictions to \(A^c\cap B\) can be passed by continuous cutoffs:
if \(F_h\) is the closed \(h\)-collar of their two boundaries in one
fixed large ball, then
\[
 \limsup_j\int_{F_h}|w_j|\,d\mu_j
       \le C\{\limsup_j\mu_j(F_h)\}^{1/2}
       \le C\nu(F_h)^{1/2}\to0.                            \tag{26}
\]
Here the second moment is uniformly bounded on that fixed ball;
Portmanteau applies to its compact collar. The final limit uses
\(\nu(\partial A\cup\partial B)=0\). Ordinary collar mass also tends
to zero. After replacing the restrictions by continuous cutoffs,
(18) passes each product with its separated continuous kernel to the
limit. Finally remove the outer restriction using (24).
We have proved, for **every** such fixed test, regardless of its mean,
\[
 B_{\mu_j,A}(w_j,\psi)\longrightarrow B_{\nu,A}(v,\psi).
                                                                    \tag{27}
\]
All pairings in (27) use the same \(A\) and the subtraction point zero.

Choose fixed compact Lipschitz functions \(\phi,\eta\) with
\(\int\phi\,d\nu=0\) and \(\int\eta\,d\nu\ne0\). Choose \(A\) for
both tests, and set
\[
 c_j=\frac{\int\phi\,d\mu_j}{\int\eta\,d\mu_j},\qquad
 \xi_j=\phi-c_j\eta .
\]
Weak convergence implies that the denominator is nonzero eventually
and \(c_j\to0\). The \(\xi_j\) have a common compact support, uniformly
bounded Lipschitz constants, and zero mean against the **whole**
current measure. Their support is eventually in \(B(0,A_j)\).
Linearity under the one normalization and (27) imply
\[
 B_{\mu_j,A}(w_j,\xi_j)
   =B_{\mu_j,A}(w_j,\phi)-c_jB_{\mu_j,A}(w_j,\eta)
       \longrightarrow B_{\nu,A}(v,\phi).                 \tag{28}
\]
The bump pairing in (28) already has a finite limit; it is not bounded
by a multiple of \(w_j(0)\). There is no requirement that
\(c_j=o(\delta_j)\) or that \(c_jw_j(0)\to0\).

For a mean-zero current-measure test, the affine difference identity
and cancellation of the integrable term
\(-\delta_j^{-1}u_j(0)k(-y)\) give exactly
\[
 B_{\mu_j,A}(w_j,\xi_j)
       =\delta_j^{-1}e_j\cdot\mathcal R_{\mu_j}(\xi_j).      \tag{29}
\]
Consequently (Q) makes its absolute value at most
\(C_{\phi,\eta}D\delta_j\to0\). Under the original cubic hypothesis
it is at most \(C_{\phi,\eta}\delta_j^2\).
Equations (28)--(29) prove
\[
 B_{\nu,A}(v,\phi)=0\quad\text{whenever }\int\phi\,d\nu=0.    \tag{30}
\]
This proves the claimed quadratic strengthening and the original
mean-correction passage.

## 6. The intrinsic fractional equation and all integrability claims

For a compact intrinsic Lipschitz test \(g\) on \(L\), compose with the
orthogonal coordinate projection and multiply by a compact ambient
cutoff equal to one on its trace support. Its trace is exactly \(g\)
and its \(\nu\)-integral is \(q\int g\).
The two integrations in (25) produce the factor \(q^2>0\);
cancel it. For mean-zero tests the value is localization independent:
do the splitting first inside a finite outer ball. Changing \(A\)
adds a term equal to the zero test mean times a finite center
integral. Then send that outer radius to infinity using the
renormalized, not the uncancelled, tail.
Thus (30) becomes the intrinsic equation with \(A=B(0,R)\).

For real \(g\in C_c^\infty(\mathbb R^n)\) of integral zero,
supported in \(B(0,H)\), and \(R>2H\), define
\[
 L_\varepsilon g(x)
   =\frac12\int_{|h|\ge\varepsilon}
             \frac{2g(x)-g(x+h)-g(x-h)}{|h|^{n+1}}\,dh .
\]
Translation and reflection, at this fixed positive cap, identify it
with \(\int_{|x-y|\ge\varepsilon}(g(x)-g(y))k(x-y)\,dy\).
Symmetrizing the local integral, for \(\varepsilon<R-H\), yields
\[
 \begin{split}
 \int vL_\varepsilon g
 &=\frac12\iint_{B(0,R)^2,\ |x-y|\ge\varepsilon}
                 (v(x)-v(y))(g(x)-g(y))k(x-y)\,dx\,dy\\
 &\quad+\iint_{B(0,R)\times B(0,R)^c}
       g(x)[v(x)k(x-y)-v(y)\{k(x-y)-k(-y)\}]\,dx\,dy .
 \end{split}                                               \tag{31}
\]
For the term containing the far-away height, perform the compact
test integration first and use \(\int g=0\) to subtract \(k(-y)\).
The resulting product is absolutely integrable by (9) and (21).
This does not apply Fubini to \(|v(y)|k(x-y)|g(x)|\) without
cancellation; that uncancelled product need not be integrable.

The local side of (31) converges as \(\varepsilon\downarrow0\) by
(19). On bounded \(x\), Taylor's second-difference bound for \(g\)
gives a uniform bound on \(L_\varepsilon g\).
Outside a fixed large ball the cap is inactive for \(0<\varepsilon\le1\),
and mean-zero cancellation gives
\[
 |L_\varepsilon g(x)|\le C_g(1+|x|)^{-n-2}.
\]
Local \(L^1\) of \(v\) and the proved weighted tail therefore justify
dominated convergence on the left of (31).
Its limit is the absolutely convergent integral
\[
 \int_{\mathbb R^n}v(x)Lg(x)\,dx
       =B_{dx,B(0,R)}(v,g)=0,
\]
with exactly the operator and factor \(1/2\) in the source.
Apply this to real and imaginary parts for complex tests.
There has been no new subsequence after the extraction in Section 2.
Everything applies simultaneously to a finite family of heights.
This completes the proof of the proposition.

## 7. Horizon arithmetic and what has not been proved

For \(r=j+J_0\), the actual schedule is
\[
 \delta_j=2^{-r},\quad K_j=2r+3,\quad A_j=8\,2^{K_j}.
\]
It satisfies
\[
 \delta_j^{-1}2^{-K_j}=2^{-r-3}\to0,\qquad
 \delta_j2^{\gamma K_j}
       =2^{3\gamma}2^{-(1-2\gamma)r}\to0
       \quad(0<\gamma<1/2).
\]
At \(\gamma=1/4\), the fourth power of the latter is
\(8(1/4)^r\). No hidden exchange of the moment and oscillation
horizons is necessary.

The strongest prior result in the project was only the seed objective;
there was no certified bridge result in its ledger. Relative to the
staged proof, this work supplies a hypothesis-complete independent
proof and proves that a quadratic, rather than cubic, oscillation
bound suffices. The exact two-sheet example explains why replacing
the support-centered lower bound by a bound only at zero would be a
different and false compactness theorem.

No literal false assertion was found in the scoped manuscript bridge.
The preceding weakened-statement counterexample must not be recorded
as a refutation of an actual manuscript lemma. Nor does verification
of this bridge verify the flat-seed, reflectionless planar-density,
weighted-rigidity, packing, or David--Semmes endpoint arguments.
Those are separate open nodes in the project graph. In particular
the higher-codimension main theorem is not certified by this mission.

### Primary-source scope, not an imported proof shortcut

The complete proof above uses elementary integration, finite
partitions, compactness of bounded real sequences, and completeness
and approximation in \(L^2\). It does not import a specialized
fractional regularity, viscosity equivalence, or variable-space
compactness theorem.

Di Nezza--Palatucci--Valdinoci, **arXiv:1104.4345v3**, Section 7,
first theorem (displayed as Theorem 7.34 in the experimental HTML),
assumes a **bounded extension domain** \(\Omega\subset\mathbb R^n\),
\(s\in(0,1)\), \(p\in[1,\infty)\), \(q\in[1,p]\), a bounded family in
\(L^p(\Omega)\), and a uniform Gagliardo seminorm; it concludes
precompactness in \(L^q(\Omega)\). The source was read at
<https://arxiv.org/html/1104.4345v3#S7>. This is fixed-domain prior
art; its finite-cell proof explains the relevant mechanism, but its
statement alone does not provide (18) on moving measures.

Dipierro--Savin--Valdinoci, **arXiv:1610.04663v1**, Definition 1.1,
requires local continuity and
\(\int |u(y)|/(1+|y|^{n+2s+k})\,dy<\infty\); its cutoff equation
has a polynomial remainder of degree at most \(k-1\).
For \(s=1/2,k=1\) this is the same tail exponent and a remainder
modulo constants. Their Theorem 1.6 additionally assumes continuous
functions \(u_m,f_m\) on a fixed Euclidean ball, a viscosity equation,
\(L^1\) and locally uniform convergence there, locally uniform
convergence of \(f_m\), a uniform weighted bound, and the stated
weighted weak convergence against all bounded tests.
The definition and stability hypotheses were read at
<https://arxiv.org/html/1610.04663v1>.
Those identifications are not available merely from moving height
measures. The route importing that stability theorem without them is
retired in the ledger. The manuscript explicitly proves its own
measurable formulation and only says “compare” this paper; that
comparison is not a misapplication or a refuted claim.

An unverified search result suggesting that convergence rates or
graph parametrizations are generally necessary was not used as
evidence. The direct proof (12)--(18) settles the precise hypotheses
here. No primary-source lookup obtained in this scope establishes
novelty of the verified bridge or its quadratic strengthening.

## Reproduction

From the campaign root, run
`$WORKSPACE/argus-live-update/.venv/bin/python research/normalized_height_bridge/verify.py`.
It reads the manuscript and local exact artifacts without altering them.
For a fresh kernel run, use
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/normalized_height_bridge/Main.lean --statement-fidelity research/normalized_height_bridge/statement_fidelity.md --claim NHB_FORMAL --project-root .`.
That kernel run concerns only the declarations described in the
statement-fidelity document. Independent Reviewer acceptance of the
analytic proof and that interpretation is still required.
