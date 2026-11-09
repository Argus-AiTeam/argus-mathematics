# Exceptional-fiber-safe concentration in AE's signed-excess argument

## Result and scope

This is a mathematical verification of the **concentration part** of AE
`lt:config` and `pk:reverse`, conditional on the upstream witness/envelope/
barrier estimates that `pk:reverse` itself invokes. It also proves a weak
critical-endpoint refinement in dimensions at least three. Neither main
regularity theorem is proved or refuted here. Independent review, including
the significance and literature-novelty assessment, is pending.

The exact algebraic replay is `../../verify.py`. The Lean certificate concerns
only the finite weighted Holder algebra, not the geometric or infinite-sum
arguments below. No false literal manuscript assertion has been established.

**Primary-source scope.** AE means the staged September 23, 2026 manuscript.
Its `thm:main` asserts \(\mathcal H^m(\operatorname{Sing}V)=0\), with regularity
meaning local equality to one embedded minimal submanifold with constant
integer multiplicity. The October 5 manuscript asserts
\(\dim_{\mathcal H}\operatorname{Sing}V\le m-1\); its
`03-normal-inputs.tex`, `thm:signed-input`, imports AE `sx:signed` explicitly.
Thus invalidating an input here would expose a shared dependency, not by
itself refute either main conclusion.

For comparison, Brena--Decio--De Lellis, arXiv:2503.00651v1,
Theorem 1.9, gives a multi-strip **support-height** estimate under its stated
cylinder, mass, and small-tilt hypotheses. Its Lemma 2.3 is approximate
constancy of normalized cylindrical mass at definite scales; it is not the
full-mass higher-moment assertion audited here. Its Section 1.4 discusses
catenoidal failure of higher integrability of the **gradient** of a
Lipschitz approximation. That failure does not refute an estimate for
distance in **height** from a configuration. These source facts were checked
in the versioned primary text, not inferred from search summaries.

**Stronger prior art and the novelty boundary.** A separate bounded
primary-source lookup located Menne, *A Sobolev Poincare type inequality
for integral varifolds*, arXiv:0808.3660v2, Definition 3.1 and
Corollary 3.8(1). Under its cylinder mass-gap, vertical-annulus mass,
and ambient-mass assumptions, the stationary case with \(q=2\) gives
**strong** \(L^{2m/(m-2)}\) height control relative to an optimized
multivalued plane. Menne, *Weakly differentiable functions on varifolds*,
arXiv:1411.3287v1, Theorem 10.7(3), gives a strong critical estimate
after selection of finitely many medians under its stated mass,
density, first-variation, and interior hypotheses. These prior strong
unweighted estimates are stronger than the corresponding unweighted
weak-critical consequence (5.6).

Thus neither the critical exponent nor unweighted exceptional-set
control is claimed as new. What is separately established below is the
Gaussian, prescribed-fixed-well estimate with the barrier coefficient
\(k^{-1}\delta\), polynomial dilation, and uniform remote tails.
The lookup did not establish whether the complete formulation is already
an implication of prior results. Its literature novelty remains
**unverified**, and this work is not a terminal publishable campaign
result unless the independent Reviewer establishes the required
significance and novelty.

## 1. Notation and hypotheses that must not be dropped

Use the literal interior normal-cylinder setting of AE `local.tex`.
The varifold is stationary and integral, with weight \(\mu\), and its
restriction is separated from its artificial vertical boundary above each
compact base set. Multiplicity is included in every fiber count. All
enlargements used below remain inside the available lateral chart.

In the original inherited height frame,
\[
 M=\pi_\#\mu-Q\operatorname{vol}_S,\quad
 D=\pi_\#(e\mu),\quad
 \tau=|M|+D+\Lambda,\quad 0\le e\le m.
\]
Here \(Q\ge1\) is the selected reference integer, not a density upper bound.
The packing measure \(\nu\) is \(\tau\), **not** \(\pi_\#\mu\).
In curved charts, \(\Lambda\) and
\(\gamma=l+\sup|z_{\rm phys}|\) keep their physical meaning after every
interior rescaling. No recentering of the normal gauge is used.
The symbol \(z\) in the witness formulas below denotes the section's
scaled height \(\zeta\), never \(z_{\rm phys}\).

For the configuration statement assume
\(\tau(B_{cs}(x))\le ds^m\), \(0\le d\le d_0\), with \(c\) a sufficiently
large fixed enlargement. For the witness statement also retain the exact
upstream inputs printed in `ex:envelope`, `ex:barrier`, `pk:witnesses`,
and `pk:flux-lower`: fixed polynomial dilation, the clipped fixed-well
multiplier, the moment barrier, the witness tilt and flux lower bounds,
transition control, and the specified physical smallness and tails.
The argument below does not independently certify how those inputs are
obtained from contacts. This is precisely the boundary of this mission.

## 2. The local selection input does not require a higher moment

Here are the ingredients of the finite selection used below, separately
from the moment conclusion.

The area formula and AE's displayed projection-Jacobian calculation give
\[
 \pi_\#(J_\pi\mu)=N\operatorname{vol}_S,\qquad
 |\pi_\#\mu-N\operatorname{vol}_S|\le C(D+\Lambda).
\]
Consequently \(\int|N-Q|\le C\tau\), after the bounded coordinate-volume
change. In particular \(N=Q\) off a base set of volume \(Cds^m\).
Deficient-rank points have a Lebesgue-null projected image by the area
formula; their **mass** is not zeroed out.
The area formula used here is precisely Simon's March 7, 2018 notes,
Chapter 3, Section 2, (2.5), with all the section's rectifiability,
local-finiteness, Lipschitz, and target-dimension hypotheses. The actual
primary PDF and the consulted passage are retained in this directory.

To check the projection calculation, the nearest-point derivative is
\(J_z^{-1}P_h\), whence
\(J_\pi=\sqrt{\det P_{hh}}/\det J_z\). The eigenvalues \(b_i\) of
\(B\) lie in \([0,1]\), and
\(1-\sqrt{\prod(1-b_i)}\le\sum b_i=e\).
Also \(\det J_z=1-\langle H_S,z_{\rm phys}\rangle
+O(|z_{\rm phys}|^2)\); the tube bounds its inverse. Young's inequality
therefore gives \(|1-J_\pi|\le C(e+\lambda)\).
Push forward this signed difference after applying the weighted area
formula to obtain the displayed full-measure bound.

For a bounded height test \(|f|\le1\), multiply the horizontal
first-variation field by \(f\). Cauchy--Schwarz bounds the mixed block by
\(\sqrt d\). The scalar localized potential calculation of AE
`lt:potential` then gives, for the empirical counting function \(N_f\),
a weak-\(L^1\) oscillation about one smooth average of size
\[
 C\{d+s\operatorname{Lip}(f)\sqrt d\}.                 \tag{2.1}
\]
This use of the potential estimate is an explicit analytic dependency,
not a consequence of the finite algebra certificate. Its ingredients are
the weak-(1,1) estimate for the differentiated Newton kernel, the locally
integrable first derivative kernel, and a harmonic remainder controlled
modulo a constant by the full gradient equation. These are exactly the
ingredients in the printed proof of `lt:potential`; no strong-\(L^1\)
estimate for the singular integral is being assumed.

For completeness, the local potential argument can be checked separately.
Scale to the fixed balls \(B_2\Subset B_3\Subset B_4\), write the scalar
gradient equation as
\(\partial_j v=\partial_iF_{ij}+g_j\), and suppose the total masses of
these data are at most \(\varepsilon\). Smooth first and localize the
data by a cutoff equal to one on \(B_3\). A Newton potential
\[
 u=\partial_i\partial_j\Phi*(\chi F_{ij})
                  +\partial_j\Phi*(\chi g_j)
\]
then has the same Laplacian as \(v\) on \(B_3\). The second-derivative
operator has weak-(1,1) size \(C\varepsilon\): decompose each smoothed
measure into a part bounded by the chosen level and zero-mean pieces on
disjoint maximal dyadic cubes. The squared L2 norm of the bounded part is
at most the level times its L1 norm, and the Fourier multiplier has
absolute value at most one. Outside doubled bad cubes, integrate the
kernel difference from its value at the cube center; its gradient bound
\(C|x|^{-m-1}\) and the zero means give L1 size \(C\varepsilon\).
The bad cubes themselves have total volume \(C\varepsilon/t\).
Chebyshev proves the asserted weak estimate. The first-derivative kernel
is L1 on the bounded region. Moving derivatives onto a fixed smooth test
also bounds the distributional pairing with \(u\) by
\(C\varepsilon\|\varphi\|_{C^k}\) for one fixed \(k\).

Now \(h=v-u\) is harmonic on \(B_3\). Test its derivative at a point of
\(B_{5/2}\) with a fixed translated radial averaging bump, and substitute
the **gradient** equation, not just its divergence. The resulting terms
are \(F\) against one derivative of the bump, \(g\) against the bump, and
\(u\) against one derivative of the bump. They bound
\(\sup|\nabla h|\) by \(C\varepsilon\). Subtract \(h(0)\).
The constants \(h(0)\) are bounded by one fixed smooth pairing with the
finite measure \(v\) and with \(u\). Choose a convergent subsequence of
these constants as smoothing vanishes. At Lebesgue points the smoothed
scalar density converges to \(v_{\rm ac}\); the uniform weak estimate
passes to the limit. Weak convergence against smooth tests gives the
distributional estimate. This proves exactly the potential input in
(2.1), without assuming absolute continuity of \(v\) or strong L1
boundedness of its singular-integral potential.

In a curved chart take coordinate field \(X=a^{-1}Y\), where
\(d\operatorname{vol}_S=a\,dy\). Then
\(\operatorname{div}_S X=a^{-1}\operatorname{div}Y\), so there is no
uncontrolled derivative of a background projected mass. The connection
term is at most \(Cl|z_{\rm phys}|\operatorname{Lip}(f)\); it is charged
to \(\Lambda\) and obeys (2.1). All coordinate constants remain the
original inherited ones.

For clarity, the finite selection from (2.1) is as follows. Fix an
exceptional base proportion \(\theta>0\). Choose a coordinate quantile
mesh \(\eta_0\) with \(6\eta_0<1/(2Q)\). Test the two sides of each
quantile with transition width \(w=Ks\sqrt d\). There are finitely many
tests, depending only on \(n,Q\) and the mesh. Their oscillation bounds
are \(C(d+K^{-1})\); choose \(K\), then the density threshold, so their
exceptional sets occupy less than \(\theta/3\).

On the remaining \(Q\)-entry fibers, ordered lists in each coordinate
differ by \(Cw\): the distribution-function error is less than a half
integer atom, so it cannot change the order statistic. Group the finitely
many coordinate levels into intervals of diameter \(CQw\), with empty
gaps between intervals. Test products of their cutoffs. There are at most
\(Q^n\) such joint-box tests. Discarding another \(\theta/3\), their
integer counts are constant, since each is within less than \(1/4\) of
the same average. Discarding the \(N\ne Q\) set costs the last
\(\theta/3\). A representative in each occupied box, repeated with its
count, gives the majority configuration. This also explains why marginal
coordinate counts alone would not have sufficed.

Two such configurations match on an overlapping comparable ball whenever
their exceptional proportions are smaller than the fixed overlap
fraction: choose one common good fiber and compose the two matchings.
This proves finite selection and matching with constants
\(C_\theta\), without a height moment or a support-height estimate.
The analytic potential and area-formula dependencies remain stated;
they are not promoted to kernel-verified facts by this audit.

## 3. Every support point, including an exceptional fiber

Fix a small internal proportion \(\theta\) and a small internal density
threshold \(d_{\rm int}\). A continuing ball of radius \(r\) has a majority
configuration with good-fiber height error
\(C_\theta r\sqrt{d_{\rm int}}\). The mass outside those height
neighborhoods over the ball is at most
\[
 C(Q\theta+d_{\rm int})r^m.                           \tag{3.1}
\]
Indeed add the null projected image of the deficient-rank set to the
bad base set and use
\(\pi_\#\mu(A)\le Q\operatorname{vol}_S(A)+|M|(A)\).
This bound accounts for the complete mass on the bad fibers, not just
their base volume or their Jacobian-weighted mass.

If a support point over a fixed inner ball were a fixed multiple of \(r\)
away from every height neighborhood, an ambient ball of radius \(c_2r\)
about it would be outside those neighborhoods and inside the lateral
working region. It would have mass at least \(\omega_m(c_2r)^m\).
Choose \(\theta,d_{\rm int}\) so that (3.1) is smaller than this number.
This is a contradiction. Bounded bi-Lipschitz constants give the same
argument in a curved tube.

The ambient monotonicity ball is legitimate because separation from the
artificial vertical boundary permits extension of the restricted
varifold by zero: multiply a test field by a vertical cutoff equal to one
near its support. The extension is stationary away from the lateral
boundary. Without this separation the argument would be invalid.
Thus every support height over the inner ball is within \(C r\) of
the local configuration. No density-one or nonzero-Jacobian hypothesis
was imposed on that support point.
The lower mass bound itself follows directly by testing stationarity
with decreasing radial fields: the normalized ball mass is nondecreasing
in the ambient radius. At almost every rectifiable point its limiting
density is a positive integer. Approximate any other support point by
these points, use slightly smaller balls contained in the desired ball,
and then pass to the radius limit. This gives
\(\mu(\mathbf B_\rho(p))\ge\omega_m\rho^m\) at every support point.

## 4. A quantitative stopped-descent theorem

Normalize \(s=1\) temporarily. Cover the inner base region by a dyadic
root and use selection balls of radius \(K\ell(R)\) about its cubes,
with \(K\ge4\sqrt m\) fixed. Choose their associated fixed enlargements
so that a parent's enlargement contains each child's enlargement and
all selection and comparison balls. These enlarged balls have bounded
overlap at each generation; taking \(c\) large at the outset supplies
the room.

Continue a branch while the normalized \(\tau\)-mass of its selection
enlargement is at most \(d_{\rm int}\); stop at the first violating
child. The root continues for small input \(d\).

On a continuing edge, majority matching bounds the increment by
\[
 Cr\sqrt{r^{-m}\tau(\widetilde B_{\rm parent})}.
\]
On a first stopped child use instead the all-support error \(Cr\) from
its continuing parent. The mass above that child's cube is \(Cr^m\):
this follows from the entire projected-mass bound on the parent,
not from its good fibers. Stopping charges \(r^m\) to
\(d_{\rm int}^{-1}\tau(\widetilde B_{\rm child})\).
For continuing children the same parent-mass bound charges the square
of the matching increment to \(Cr^2\tau(\widetilde B_{\rm parent})\).

Sum these charges using the fixed-generation overlap bound. After
restoring \(s\), enlarge one fixed constant \(A\ge1\) to obtain measurable
nonnegative increments \(b_j\), \(j\ge0\), with
\[
\begin{split}
 h(q):=\operatorname{dist}(\zeta(q),\mathcal A)
       &\le\sum_{j\ge0}b_j(q),\\
 \|b_j\|_{L^2(s^{-m}\mu)}
       &\le A s\sqrt d\,2^{-j},\\
 \|b_j\|_\infty
       &\le A s\,2^{-j}
          \min\{1,2^{jm/2}\sqrt d\}.                  \tag{4.1}
\end{split}
\]
At a stop, the second supremum bound follows because the stopping
condition implies \(2^{jm}d\ge c d_{\rm int}\). On an infinite
continuing branch the all-support \(Cr_j\) error tends to zero, proving
the first inequality. All configurations and matchings are chosen on
countably many cubes; hence the functions used in the integrals are
measurable. Every charge was against full \(\mu\), including mass
projecting to a null set.

The root configuration uses only the fixed internal \(\theta\), and
therefore \(A\) is independent of the requested exceptional proportion,
the later moment exponent, \(d\), and \(s\). If a finer root majority
proportion \(\delta_0\) is wanted, select another configuration at that
proportion and match it to this root on a common good fiber. The root
itself still has the requested majority bound, with \(C_{\delta_0}\).
The input threshold is
\(\min(d_{\rm int},d_{\rm sel}(\delta_0))\); it does not depend on
the later exponents.

## 5. Consequences of (4.1), with constants and quantifiers

Let \(p>2\), \(\lambda=1-m(1/2-1/p)>0\). Interpolation and Minkowski give
\[
 \|h\|_{L^p(s^{-m}\mu)}
 \le {A\over1-2^{-\lambda}}\,s\sqrt d.                \tag{5.1}
\]
The exact exponent calculation is
\[
 {2\over p}+(1-2/p)(1-m/2)=1-m(1/2-1/p).
\]
This proves the full-mass moment part of `lt:config` for its **same**
configuration. In particular choose, in every dimension \(m\ge1\),
\[
 p={2(m+1)\over m},\qquad
 \sigma={1\over2(m+1)},\qquad
 \lambda={m+2\over2(m+1)}\ge\tfrac12.                \tag{5.2}
\]
Then (5.1) is at most \(4As\sqrt d\). No fourth moment in a
dimension where it is inadmissible is being used.

Summing the supremum bound at the split
\(J=\lceil m^{-1}\log_2(1/d)\rceil\) gives
\[
 \|h\|_\infty\le As
 \begin{cases}
 4\sqrt d,&m=1,\\
 \sqrt d[3+\log(1/d)/(2\log2)],&m=2,\\
 [2+q/(q-1)]d^{1/m},\quad q=2^{m/2-1},&m>2.
 \end{cases}                                      \tag{5.3}
\]
The last line uses \(q>1\). These imply the printed bound for every
fixed \(\beta<\min(1/2,1/m)\); for the logarithmic case use
\(\sup_{x\ge0}xe^{-\alpha x}=1/(e\alpha)\),
\(\alpha=1/2-\beta\). When \(d=0\), take positive upper bounds
decreasing to zero, match their majority configurations through one
fiber that is good infinitely often, and use (5.3). The resulting
configuration contains every support height and all its moments vanish.

There is a useful stronger consequence. For any measurable set \(E\)
and \(\eta=s^{-m}\mu(E)\), restriction of (4.1) gives
\[
 \|h1_E\|_{L^2(s^{-m}\mu)}
 \le As\sqrt d\sum_{j\ge0}
       \min\{2^{-j},\sqrt\eta\,2^{j(m/2-1)}\}.        \tag{5.4}
\]
For \(0<\eta\le1\) split at
\(\lceil m^{-1}\log_2(1/\eta)\rceil\), exactly as before. Thus
\[
 \|h1_E\|_2\le As\sqrt d
 \begin{cases}
 4\sqrt\eta,&m=1,\\
 \sqrt\eta[3+\log(1/\eta)/(2\log2)],&m=2,\\
 K_m\eta^{1/m},\quad K_m=2+q/(q-1),&m>2.
 \end{cases}                                      \tag{5.5}
\]
For \(\eta\ge1\), the \(m>2\) bound still holds because
\(\|h\|_2\le2As\sqrt d\). The zero-mass case follows by
integration, not by assigning values to exceptional fibers.
In particular (5.5) gives the unprinted weak critical endpoint
\[
 (s^{-m}\mu)\{h>t\}
 \le (AK_ms\sqrt d/t)^{\,2m/(m-2)},\qquad m>2.       \tag{5.6}
\]
This is a weak endpoint, **not** a strong critical-moment assertion.

## 6. Fixed wells, Gaussian moments, and uniform tails

Now fix an actual witness, put \(u=(y-x)/s\),
\(\delta=e^{-a}\), and \(v=V_b(z)/s\).
Hold these wells, the clipping function, and \(V_b\) fixed under dilation.
The inherited-coordinate and physical-unit conventions remain in force.

Polynomial dilation gives, for all required \(1\le R\) through
\(R_*=O(\sqrt a)\) and on the fixed enlargement,
\[
 (Rs)^{-m}\tau(B_{cRs}(x))
 \le C(1+R)^{K-2}\delta=:d_R.
\]
All these densities are below the one fixed internal threshold when
\(a\) is large. Apply the previous descent to their joint configurations
\(\mathcal B_R\).

Every entry of \(\mathcal B_1\) is matched on every good fiber to a
projection entry within \(Cs\sqrt\delta\). The area formula and a
uniform upper bound on \(J_\pi\) give that entry a fixed amount of
Gaussian-weighted \(\mu\)-mass. Consequently the Lipschitz bound on
\(V_b\), \(|V_b|^2\le\Gamma_s\), and the barrier \(U\le s^2\delta/k\)
give, **one entry at a time**,
\[
 \max_{\xi\in\mathcal B_1}|V_b(\xi)|^2
 \le C(U+s^2\delta)\le Ck^{-1}s^2\delta.
\]
No disjoint allocation of mass to repeated entries is needed.
Majority matching through concentric dyadic dilations transfers this
bound to \(\mathcal B_R\), at the cost of a fixed polynomial in \(R\).
Using \(|v|\le C s^{-1}\operatorname{dist}(z,\mathcal B_R)
+\max_{\xi\in\mathcal B_R}|V_b(\xi)|/s\), (5.1) yields
\[
 \|v\|_{L^p((Rs)^{-m}\mu;\,B_{Rs})}
 \le C_p(1+R)^C k^{-1/2}\sqrt\delta.                \tag{6.1}
\]
Annular Gaussian summation proves
\[
 \|v\|_{L^p(G_s\mu)}
 \le C_p k^{-1/2}\sqrt\delta,\qquad
 \int G_s(1+|u|^2)e\,d\mu\le E\delta.               \tag{6.2}
\]
The second bound is directly the energy dilation bound.

Here the remote tail is uniform even as \(s\downarrow0\).
Clipping gives \(|v|\le C_{\rm clip}\), and projected mass plus
dilation gives \((\pi_\#\mu)_{\sqrt2s}\le M_0\). Exactly
\[
 1_{\{|u|>R\}}G_s
 \le 2^{m/2}e^{-R^2/4}G_{\sqrt2s}.
\]
Thus the bare mass tail is at most
\(2^{m/2}M_0e^{-R^2/4}\). Taking \(R=C\sqrt a\), with
the fixed \(C\) chosen for the fixed \(p\), makes its contribution
smaller than any prescribed inverse power of \(B\) times
\(\delta^{p/2}\). The energy tail is bounded by Gaussian comparison
and energy dilation, retaining its factor \(\delta\).
There is no negative power of \(s\). Chart-cutoff contributions are
retained in exactly these tails, as prescribed in `lt:weightedballs`.

For (5.2), \(k\ge B^{-\epsilon}\) and
\(B\ge\max(1,C_p)^{2/\epsilon}\) imply the explicit convenient form
\[
 \|v\|_{L^p(G_s\mu)}\le B^\epsilon\sqrt\delta.        \tag{6.3}
\]
This establishes `pk:flux-moments`, not just a finite collection of examples.

## 7. A Gaussian critical-endpoint refinement for \(m>2\)

The same hypotheses imply the stronger full-mass estimate
\[
 \int_EG_s|v|^2\,d\mu
 \le C_m k^{-1}\delta
       \left(\int_EG_s\,d\mu\right)^{2/m}            \tag{7.1}
\]
for **every** measurable \(E\), including sets carried by exceptional
projection fibers.
Here \(C_m\) may depend on the fixed local selection, dilation, clipping,
mass, and coordinate data as well as \(m\), but not on \(s,a,k,\epsilon\)
or the measurable set.

Here are details of the Gaussian step, since it is not a formal
replacement of Lebesgue measure by a Gaussian. On a ball of radius \(Rs\),
(5.5), the center bound, and bounded normalized projected mass give
\[
 \int_E|v|^2\,d\mu/s^m
 \le C(1+R)^L k^{-1}\delta
       [s^{-m}\mu(E)]^{2/m},\quad E\subset\pi^{-1}B_{Rs}.
\]
The extra center term initially has exponent one in the mass; absorb it
using \(s^{-m}\mu(E)\le CR^m\). All powers of \(R\) are fixed.

For \(A_n=\{n\le|u|<n+1\}\) put
\(\eta_n=\int_{E\cap A_n}G_s\,d\mu\). On annuli inside \(R_*\) the
last display bounds the contribution by
\[
 C k^{-1}\delta\,c_n\eta_n^{2/m},\qquad
 c_n=(n+2)^L\exp[-n^2/2+(n+1)^2/m]
\]
after absorbing the fixed Gaussian normalization. Since \(m>2\),
\(\sum c_n^{m/(m-2)}<\infty\). Holder on this series gives
\[
 \sum c_n\eta_n^{2/m}
 \le \left(\sum c_n^{m/(m-2)}\right)^{(m-2)/m}
       \left(\sum\eta_n\right)^{2/m}.
\]

Set
\[
 R_*=2\sqrt{{m\over m-2}a+\log(2^{m/2}M_0+1)}.
\]
It is in the permitted fixed polynomial range. The bare Gaussian mass
beyond \(R_*\) is at most \(\delta^{m/(m-2)}\). If that part of \(E\)
has mass \(\eta_{\rm tail}\), clipping therefore gives
\[
 \int_{E\cap\{|u|>R_*\}}G_s|v|^2\,d\mu
 \le C_{\rm clip}^2\eta_{\rm tail}
 \le C_{\rm clip}^2\delta\,\eta_{\rm tail}^{2/m}.
\]
This proves (7.1) without an additive tail error, and hence without
losing control when \(E\) itself is exceptionally small. It proves
weak \(L^{2m/(m-2)}(G_s\mu)\) control of the fixed-well multiplier and
the endpoint absolute-flux bound
\[
 \left|\int_EG_s\,v\cdot P_{vh}u\,d\mu\right|
 \le C_m k^{-1/2}\delta
       \left(\int_EG_s\,d\mu\right)^{1/m}.           \tag{7.2}
\]
The printed proof uses only exponents strictly below this endpoint.
This endpoint statement is the structural extension proposed for
independent significance/novelty review; novelty is not certified here.

## 8. Explicit controlled-density constants

Write \(\epsilon=\epsilon_0\), \(0<\epsilon\le1\), and use (5.2).
The witness has total signed flux at least \(fB^{-\epsilon}\delta\)
for a fixed \(f>0\). Gaussian summation of (6.1) outside
\(R_B=C_1\sqrt{\log B}\) makes its absolute flux at most
\(fB^{-\epsilon}\delta/4\); choose \(C_1\) for the fixed
polynomial exponents and the bound \(\epsilon\le1\), before choosing \(B\).
The tilt tail is similarly smaller than half the witness tilt.

The adjacent-grid property gives a half-open dyadic cube \(J\)
containing \(B_{R_Bs}(x)\) with interior room and
\(\ell(J)\le C R_Bs\).
The remaining tilt and \(G_s\le (2\pi)^{-m/2}s^{-m}\) give
\(\nu(J)\ge c B^{-\epsilon}\delta s^m\).
Polynomial dilation gives its upper density. Absorbing fixed logarithmic
factors, exactly as quantified below, yields
\[
 cB^{-2\epsilon}\delta\le {\nu(J)\over|J|}
                      \le B^\epsilon\delta.       \tag{8.1}
\]

One possible dimension-explicit choice in the printed assertion is
\[
                  C_*=16(m+1),\qquad c_*=6.         \tag{8.2}
\]
Only the lower threshold for \(B\), not these two constants, depends
on \(\epsilon\) or the fixed geometric and witness constants.

Let \(H\) be the disjoint union of maximal descendants of \(J\) with
\(\nu(R)/|R|>B^{C_*}\delta\). Since the root is not bad, every bad
descendant is in one of these maximal cubes. Countability and half-open
partitions include mass on dyadic boundaries. From (8.1),
\[
 |H|/|J|\le B^{\epsilon-C_*}.
\]
Most importantly, the exact projected-mass identity gives
\[
 \mu(\pi^{-1}H)\le Q\operatorname{vol}_S(H)+|M|(J).
                                                               \tag{8.3}
\]
This does not require \(\pi_\#\mu\ll dy\). Absorb the fixed volume and
Gaussian normalization and \(|J|/s^m=O((\log B)^{m/2})\) into
one factor \(B^\epsilon\). Then
\[
 \eta_H:=\int_{\pi^{-1}H}G_s\,d\mu
 \le B^{2\epsilon}(B^{-C_*}+\delta).                \tag{8.4}
\]

For \(B\ge4C_*^2\), \(\log B\le\sqrt B\) implies
\(\delta\le e^{-B}\le B^{-C_*}\).
Holder, \(|P_{vh}u|\le\sqrt e\,|u|\), (6.2), and (6.3) give
\[
 |\mathcal F_H|
 \le \sqrt E\,2^\sigma
       B^{(1+2\sigma)\epsilon-C_*\sigma}\delta.
\]
Here \(C_*\sigma=8\) and
\((2+2\sigma)\epsilon\le5/2\), in every \(m\ge1\).
Consequently
\[
 |\mathcal F_H|
 \le \sqrt E\,2^\sigma B^{-5}B^{-\epsilon}\delta
 \le fB^{-\epsilon}\delta/4
\]
as soon as \(B^5\ge4\sqrt E\,2^\sigma/f\).
This is `pk:bad-flux` with the mass defect retained. In dimensions
above two (7.2) supplies a stronger endpoint alternative, not a needed
extra assumption.

At least \(fB^{-\epsilon}\delta/2\) flux remains on
\((J\setminus H)\cap B_{R_Bs}\). With
\(M_0'=\int G_s\,d\mu\le C\), Cauchy--Schwarz and (6.3) imply
\[
 {f^2\over4}B^{-2\epsilon}\delta^2
 \le C(M_0')^{2\sigma}B^{2\epsilon}\delta
        R_B^2s^{-m}\nu(J\setminus H).
\]
Divide by the upper bound in (8.1). This gives
\[
 {\nu(J\setminus H)\over\nu(J)}
 \ge c\,B^{-5\epsilon}(\log B)^{-(m+2)/2}
 \ge B^{-6\epsilon}                              \tag{8.5}
\]
for the stated large threshold. Since \(J\setminus H\) is exactly
the set whose every dyadic descendant has density at most
\(B^{C_*}\delta\), (8.5) is the full printed controlled-density
fraction, with (8.2).

All logarithmic absorptions here can be made explicit without
asymptotic notation: for \(L\ge1\), \(q\ge0\), integer
\(N\ge\max(1,q)\), and \(B\ge e\),
\[
 B\ge[L\,N!(2/\epsilon)^N]^{2/\epsilon}
 \quad\Longrightarrow\quad
 L(\log B)^q\le B^\epsilon.
\]
Indeed \(t^q\le t^N\le N!(2/\epsilon)^N e^{\epsilon t/2}\) for
\(t=\log B\ge1\), by the \(N\)-th term of the exponential series.
Use this once with the larger of the finitely many fixed prefactors,
and with \(N\ge m+2+K\), for all the logarithms in (8.1), (8.4),
and (8.5). Together with \(4C_*^2\), the displayed moment and flux
thresholds, and the explicit Gaussian tail comparisons, this specifies
one threshold for **all** witnesses and all positive bottom scales.

## 9. What the certificates do and do not establish

`verify.py` checks exact symbolic identities for the weighted
Cauchy--Schwarz pair kernels, the dyadic interpolation and endpoint
exponents, the uniform parameter slack in (8.2), and the rational
stationary-affine Gaussian sanity calculation submitted through Jacobian.
It also replays an exact abstract obstruction to an L2-only argument:
an atom of mass \(\delta\), with \(v=q=1\), has both squared L2
norms and its entire flux equal to \(\delta\). That atomic model
is **not** stationary or a manuscript counterexample.
Run `python3 verify.py` from a copy of the campaign with Python 3 and
SymPy available. It needs no live Jacobian server or Lean invocation:
it replays the typed exact output and checks the archived real compiler
run against its current source and fidelity document.

The affine example is one complete stationary integral line, in a
cylinder with enough vertical room, with slope \(200/9999\). Its area
factor is \(10001/9999\), its normal tilt is \(40000/100020001\),
and its flux equals its tilt integral, with the printed positive sign.
The exact Gaussian fourth moment is only a bounded check of the
normalization, not evidence for a universally quantified analytic estimate.

`Main.lean` has a fresh Lean 4.31.0 compiler/axiom-audit record with zero
proof holes. Its statement-fidelity document explicitly limits that
certificate to finite weighted Holder algebra and exponent arithmetic.
The complete arguments involving first variation, stopping, infinite sums,
tails, and publication novelty require the normal independent Reviewer.
The upstream witness/barrier inputs, both main regularity conclusions,
and the remainder of either manuscript are left open in the proof graph.
