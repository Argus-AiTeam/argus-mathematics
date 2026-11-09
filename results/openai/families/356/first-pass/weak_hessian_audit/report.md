# Distributional upper Hessian bounds and exponential reweighting

**Engineer result:** a universal proof of the companion's analytic bridge
at its original strength, together with exact supporting calculations and
an abstract formalization of graph closure. No admissible counterexample
or false assertion has been established in this bounded mission.
Final mathematical certification, citation attribution, significance and
novelty judgments belong to the Host-invoked independent Reviewer.

## Statement under audit

The target is Proposition `weight:variable-cd` and Theorem
`weight:every-geodesic` in the staged September 24, 2026 companion manuscript.
The ambient space is a complete, separable, full-support RCD(K,N) space,
with 1 < N < infinity and reference measure finite on bounded sets.
The measure need not have finite total mass. The Laplacian is nonpositive.

The hypotheses are a bounded globally Lipschitz real function F, a bounded
continuous real function G, and

    H_F(grad g, grad g)(h) <= integral h G Gamma(g) dm

for every compactly supported original test function g and nonnegative
compactly supported Lipschitz h. Here an original test function belongs
to D(Delta), is bounded globally Lipschitz, and has Delta g in W^{1,2}.
The weak Hessian is defined by the two integration-by-parts terms in the
manuscript, not by an assumed L2 Hessian of F.

The conclusions being investigated are CD(K-lambda G,infinity) for
exp(lambda F)m, for every lambda > 0, and the corresponding upper
second-derivative bound for F on every prescribed minimizing geodesic.
No global L2 condition on F, Laplacian-domain condition on F, or equality
of weighted and original test classes is part of the assertion.

## Source findings established before the proof

The independent source-reading task `curvature_source_reader` inspected
arXiv:1209.5786v4 (AGS) and arXiv:1906.09186v1 (BHS).

AGS's required BE domain is f in D(L) with Lf in W^{1,2}, and
0 <= phi in D(L) intersect L-infinity with Lphi in L-infinity.
It does not require bounded f or bounded Gamma(f). Equation (2.22),
Corollary 2.3(i), and Theorem 4.17 are the relevant locators.
Theorem 4.17 allows infinite reference measure, subject to (MD.exp).
The introductory finite-measure Theorem 1.1 is not a substitute.
The form normalization is E = 2 Ch = integral Gamma.

For the metric identification, the relevant AGS statements are (MD),
(ED), Theorems 3.9 and 3.14, and Definition 3.16. Sobolev-to-Lipschitz
and quadratic Cheeger energy provide the structural hypotheses;
Gaussian volume growth supplies (MD.exp) and conservativity.

BHS Theorem 1.1 assumes an already established RCD(K0,infinity)
structure and a lower-semicontinuous lower-bounded k. Its Definition 1.4
uses the AGS BE domain restricted further by bounded Gamma(f).
Definition 1.2 provides one optimal dynamical plan for all times.
Its kernel is

    min(s(1-t), t(1-s)) = min(s,t) - st,

whose integral in s is t(1-t)/2. Thus the constant-curvature correction
is -K t(1-t) W2^2 / 2. A constant-curvature bootstrap must precede the
variable-curvature invocation.

The source readers were restricted to inline answers. Their findings and
normalized mathematical transcriptions are preserved in `literature/`.
The second reader checked the original heat/test calculus in
arXiv:1802.02463v1, the Bochner measure in arXiv:1304.0643v2, and true
nonbranching in arXiv:2009.07956v2. In particular, GT's cutoff bounds are
uniform for support in B_{R+1}, and Savare's class does not require bounded
Delta g. The compact-core assertion below is a deduction, not the literal
statement of GT (A.13).

The official citation-attribution command archives outside this mission's
writable paths, in `research/literature/`. It has therefore not been run
by the Engineer. The cited assumptions retain their explicit versioned
identifiers, locators, and local reader transcriptions; attribution remains
an explicit Reviewer obligation, not a purported completed check.

## Dependency chain

The manuscript's chain is: original compact generator core and Bochner
calculus; equality and equivalence of the two generator graph domains;
bounded-drift resolvent regularity of weighted multipliers; weighted
core Bochner identity; graph-domain closure; constant-curvature AGS
bootstrap; BHS variable-curvature passage; entropy localization using
uniqueness of strict interior subsegments from Deng's nonbranching theorem.

The main characterization manuscript uses the resulting every-geodesic
theorem after its index inequality and Hessian comparison. Those index
and frame arguments are not verified by this bounded analytic mission.

## 1. Imported original-space facts and a compact graph core

The external analytic toolkit is the original RCD calculus, not any
curvature property of a reweighted space:

1. The weak differential is closed, linear and local, with the Leibniz
   rule. Original test functions have Gamma(g) in W^{1,2}.
2. The original heat semigroup P_t is self-adjoint and Markov. It is
   strongly continuous on L2 and W^{1,2}. Positive-time regularization
   sends L2 intersect L-infinity into GT's stricter Test-infinity class
   (GT Appendix A, (A.7)); Sobolev-to-Lipschitz is (A.10).
3. There are test cutoffs chi_R equal to one on B_R, supported in B_{R+1},
   with uniformly bounded gradients and Laplacians (GT Lemma A.2).
4. For an original test function, Gamma_2(g) is a finite measure with
   Gamma_2(g) >= K Gamma(g)m. Its nonnegative remainder does not charge
   zero-capacity sets (Savare Lemma 3.2 and (3.7)-(3.9)).
5. Finite-dimensional volume comparison gives properness, positive finite
   ball measures, and Gaussian volume growth. The original reverse
   Poincare estimate used below follows from the original BE bound.

These are recorded as external assumptions in the ledger. Unreduced
RCD(K,N) implies the RCD*(K,N) hypotheses of GT. The stronger
Hessian-square Bochner estimate is not needed for this proof.

Here is the compact-core deduction. For u in D(Delta), spectral
calculus gives P_t u -> u in the generator graph norm. For a fixed t,
bounded L2 data approximate u, and Delta P_t is bounded on L2, so their
regularizations approximate P_t u in that norm. For such a regularization
v in Test-infinity, multiply by chi_R. The product remains in compact
Test-infinity, and

    Delta(chi_R v)
      = chi_R Delta v + v Delta chi_R + 2 Gamma(chi_R,v).

The first term converges to Delta v in L2. The other two tend to zero:
their supports escape every fixed ball and they are bounded by uniform
constants times the L2 tails of v and grad v. The functions themselves
also converge in L2. A diagonal choice gives the compact graph core.
No constant function is required to be in L2.

Compact Lipschitz multipliers are admissible against the original
Bochner measure. One can regularize a compact Lipschitz multiplier by
an outer cutoff times P_t. The functions have common compact support
and bound, converge strongly in W^{1,2}, and converge quasi-everywhere
along a subsequence. Dominated convergence for the fixed Bochner measure
uses its zero-capacity-null property. In integration by parts,
grad Gamma(g) is in L2. Nonnegative multipliers can be regularized
nonnegatively. This justifies precisely the multiplier used in section 4.

## 2. Equality of generator domains without global Sobolev regularity of V

Fix a bounded globally Lipschitz V. Put w=exp(V), m_V=w m, and
L=Delta_V. The upper and lower bounds on w make the L2 and W^{1,2}
norms equivalent and give exactly the same weak gradients: test-plan
compression bounds transfer both ways. Multiplication by w or w^{-1}
preserves W^{1,2}, by the bounded Lipschitz multiplier rule.
This statement does not assert that w or V themselves belong to L2.

For u in D(Delta), test its generator identity with w eta.
The product rule gives, for every eta in W^{1,2},

    integral Gamma(u,eta) dm_V
      = -integral [Delta u + Gamma(V,u)] eta dm_V.

The drift is in L2 since |grad V| is bounded. Thus u belongs to D(L)
and Lu=Delta u+Gamma(V,u). Conversely, testing the weighted identity
with w^{-1}eta gives u in D(Delta) and the same formula.

The energy identities for each measure show

    ||grad u||_2^2 <= ||u||_2 ||Delta u||_2,
    ||grad u||_{2,V}^2 <= ||u||_{2,V} ||Lu||_{2,V}.

Together with the drift bound and norm equivalence, these give
equivalence of the two graph norms. Hence the compact original test
core is also a core for L. This proves `C_W356_GENERATOR`.

## 3. Quantitative bounded-drift resolvent lemma

Write B=||grad V||_infinity and beta=max(-K,0). For a>0, the
original resolvent R_a=(a-Delta)^{-1} satisfies, for p=2,infinity,

    ||R_a h||_p <= ||h||_p/a,
    ||grad R_a h||_2 <= ||h||_2/(2 sqrt(a)),
    ||grad R_a h||_infinity <= c_a ||h||_infinity,
    c_a = 2/sqrt(a) + sqrt(beta)/a.

The L2 derivative estimate is spectral: for x>=0,

    1/(4a) - x/(a+x)^2 = (a-x)^2/[4a(a+x)^2] >= 0.

For the supremum derivative bound, the original reverse Poincare
inequality gives

    ||grad P_t h||_infinity
      <= [1/sqrt(2t) + sqrt(beta)] ||h||_infinity.

For clarity, its semigroup derivation is

    P_t(h^2)-(P_t h)^2
      = 2 integral_0^t P_s Gamma(P_{t-s}h) ds
      >= 2 [integral_0^t exp(2Ks) ds] Gamma(P_t h).

The last step is the original BE heat-gradient estimate. The variance
is at most ||h||_infinity^2. The identity first holds after positive-time
regularization and then passes to bounded L2 data by approximation.
For beta>0 use beta/(1-exp(-2 beta t)) <= 1/(2t)+beta;
for K>=0 the estimate is no worse than K=0. Integrating against
exp(-at) gives sqrt(pi/(2a))+sqrt(beta)/a, which is at most c_a.
These are original-space estimates, established before using L.

The space E of W^{1,2} functions with bounded function and gradient is
complete. For fixed a, use the equivalent norm

    ||z||_{E,a} = max {
        a||z||_2, 2 sqrt(a)||grad z||_2,
        a||z||_infinity, ||grad z||_infinity/c_a }.

Closedness of the differential proves completeness. The displayed
resolvent estimates imply

    ||R_a h||_{E,a} <= max(||h||_2,||h||_infinity).

Also,

    max(||Gamma(V,z)||_2,||Gamma(V,z)||_infinity)
      <= B c_a ||z||_{E,a}.

Here c_a >= 1/(2 sqrt(a)). Choose

    a >= max(1, 64 B^2, 4 B sqrt(beta)).

Then B c_a <= 1/2. For h in L2 intersect L-infinity, the map

    Tz = R_a [h + Gamma(V,z)]

is a contraction of E. Its fixed point belongs to D(Delta)=D(L)
and solves (a-L)z=h. The weighted energy identity proves uniqueness
among all members of D(L), since (a-L)u=0 implies
a||u||_{2,V}^2+||grad u||_{2,V}^2=0.

For xi in D(L) with xi,Lxi bounded, h=a xi-Lxi belongs to both
L2 and L-infinity. Uniqueness identifies xi with this fixed point.
It is globally Lipschitz by the original Sobolev-to-Lipschitz property.
In fact,

    ||grad xi||_infinity
      <= c_a [a||xi||_infinity+||Lxi||_infinity]/(1-B c_a).

This proves `C_W356_RESOLVENT` with an explicit parameter choice.
The constants may depend on lambda when V=lambda F; no uniformity
in lambda is needed at any later stage.

## 4. The correctly signed weighted core identity

Now put V=lambda F, k=K-lambda G. Let xi be any nonnegative member of
D(L) such that xi and Lxi are bounded. Section 3 makes xi Lipschitz.
Let g be a compact original test function, q=Gamma(g)/2,
b=Gamma(V,g), and d=Delta g. Define

    B_V(g,xi)
      = -integral w Gamma(xi,q) dm
        + integral w [xi Lg+Gamma(xi,g)] Lg dm.

All terms are integrable. In particular, no derivative of b is used.
The original Bochner measure, integrated against w xi, gives

    B_0(g,w xi) >= K integral w xi Gamma(g) dm.

A nonnegative compact test cutoff equal to one near supp(g) is inserted
in this multiplier. Its derivatives meet none of the terms, by locality.
Thus w xi need not itself have compact support or belong to global L2.

Expanding Lg=d+b and Gamma(w xi,g)=w Gamma(xi,g)+w xi b gives

    B_V(g,xi)-B_0(g,w xi)
      = integral w {xi Gamma(V,q)
                    + b[Gamma(xi,g)+xi(d+b)]} dm
      = -H_V(grad g,grad g)(w xi).

The final equality uses

    div(w xi grad g)=w[Gamma(xi,g)+xi Lg],
    nabla_{grad g} grad g=grad q.

The weak Hessian hypothesis applies to the cutoff version of w xi,
which is a nonnegative compact Lipschitz function. Since H_V=lambda H_F,

    B_V(g,xi) >= integral k xi Gamma(g) dm_V.                 (4.1)

This is the sign needed for an exponential *positive* weight.
The coefficient identity is checked independently by SymPy, Jacobian
and the formal source. It does not by itself prove the analytic theorem.

## 5. Closure on the actual weighted generator domain

For compact original test g, integration by parts in the first term
of B_V is legitimate because q belongs to W^{1,2}. It gives

    Q(g) = (1/2) integral (Lxi) Gamma(g) dm_V
           + integral (Lg) Gamma(xi,g) dm_V
           + integral xi (Lg)^2 dm_V.                       (5.1)

This expression remains meaningful for every g in D(L), regardless
of whether Gamma(g) has a weak derivative.

Suppose g_n -> g in the L graph norm. Put X_n=grad g_n, X=grad g,
Y_n=Lg_n, Y=Lg. The energy identity for g_n-g proves X_n -> X in L2.
For bounded constants M0=||xi||_infinity, M1=||grad xi||_infinity,
M2=||Lxi||_infinity, the absolute differences of the three terms
of (5.1) are bounded respectively by

    (M2/2)||X_n-X||_2 (||X_n||_2+||X||_2),
    M1[||Y_n-Y||_2 ||X_n||_2 + ||Y||_2 ||X_n-X||_2],
    M0||Y_n-Y||_2 (||Y_n||_2+||Y||_2).

The right side of (4.1) has difference at most

    ||k||_infinity M0 ||X_n-X||_2 (||X_n||_2+||X||_2).

All tend to zero. The compact common graph core therefore extends
(4.1), in form (5.1), to every g in D(L).

If additionally Lg belongs to W^{1,2}, then xi Lg belongs to W^{1,2}.
Testing the generator identity for g with xi Lg shows that the last
two terms of (5.1) equal -integral xi Gamma(g,Lg) dm_V. Hence

    (1/2) integral (Lxi) Gamma(g) dm_V
      - integral xi Gamma(g,Lg) dm_V
        >= integral k xi Gamma(g) dm_V.                   (5.2)

This holds on the full AGS domain, not only the BHS subdomain with
bounded Gamma(g). The weighted and original test classes have not
been identified. This proves `C_W356_GRAPH_CLOSURE`.

The formal source proves the abstract functional-analytic step:
bounded linear multipliers produce a continuous quadratic form of
the gradient and Laplacian coordinates; its nonnegative cone is
closed under strong convergence. A separate formal lemma derives
gradient convergence from the energy estimate. The correspondence
to the concrete multipliers in (5.1) is set out in the fidelity note.

## 6. Constant and variable curvature, including infinite mass

The weighted Cheeger form E_V=2 Ch_V is quadratic, strongly local
and symmetric, with the same Gamma. Completeness, separability,
full support and finite bounded-ball measures give AGS (MD).
The original Sobolev-to-Lipschitz property transfers because the
weak gradients agree. Together with compactly supported Lipschitz
functions this gives (ED). AGS Theorem 3.9 identifies d_E with d.
Since E_V=2Ch_V for this metric, Theorem 3.14 supplies upper
regularity. The continuous representatives and Definition 3.16
give the required Riemannian Energy measure structure.

Bounded equivalence preserves Gaussian volume growth and hence
(MD.exp). The final assertion of AGS Theorem 3.14 provides
conservativity even when m_V(M)=infinity. This does not use 1 as
an L2 function or as a BE multiplier.

Let K0=inf k=K-lambda sup G. Inequality (5.2) implies the full
BE(K0,infinity) inequality, since xi Gamma(g)>=0. AGS
Corollary 2.3(i) and Theorem 4.17 yield RCD(K0,infinity)
with the original distance. On that weighted RCD space, restrict
(5.2) to Gamma(g) bounded. It is exactly BHS Definition 1.4.
The bounded continuous k is lower semicontinuous and bounded below;
BHS Theorem 1.1 therefore gives CD(k,infinity).

This proves Proposition `weight:variable-cd` for each lambda>0.
No weighted heat estimate was assumed in proving section 3.

## 7. Entropy localization on every prescribed geodesic

Let sigma be a minimizing constant-speed geodesic of positive length ell.
For 0<a<b<1 let tau(t)=sigma(a+(b-a)t), of length D=(b-a)ell.
Deng's nonbranching theorem makes tau the unique minimizer between
its endpoints: otherwise replacing that subsegment would produce two
minimizers from sigma(0) to sigma(1), of equal length and constant speed,
agreeing on [0,a] but not everywhere. This is forbidden by true
nonbranching. Uniqueness for arbitrary endpoint pairs is not asserted.

Choose eps_j decreasing to zero with eps_j<=1. Let mu_i^j be normalized
original measure on B_{eps_j}(tau_i), i=0,1. Its entropy relative to m is

    E_i^j = -log m(B_{eps_j}(tau_i)).

Choose lambda_j=j(1+|E_0^j|+|E_1^j|). These endpoints have finite
entropy relative to m_{lambda_j} as well. BHS provides one dynamical
optimal plan pi_j for all t. Every path has length at most L=D+2
and stays in a fixed compact ball Q. Arzela-Ascoli and uniqueness
show that every path with the shrinking endpoint constraints converges
uniformly to tau: a sequence violating this would have a different
limit minimizer between tau_0 and tau_1. In particular pi_j -> delta_tau.
Endpoint distances, and hence path speeds, converge uniformly to D.

Write g(s,t)=min(s,t)-st and

    A_t^j = integral F dmu_t^j,       E_t^j = Ent_m(mu_t^j),
    C_t^j = integral integral g(s,t) |dot gamma|^2 ds dpi_j,
    D_t^j = integral integral g(s,t) G(gamma_s)|dot gamma|^2 ds dpi_j.

The identity Ent_{m_lambda}=Ent_m-lambda integral F and the
variable CD inequality give exactly

    A_t^j >= (1-t)A_0^j+t A_1^j-D_t^j
             +[E_t^j-(1-t)E_0^j-t E_1^j+K C_t^j]/lambda_j. (7.1)

The intermediate entropies are finite: weighted CD gives a finite
upper bound, and support in Q gives a finite lower bound; bounded F
then transfers this to Ent_m. Jensen gives E_t^j>=-log m(Q), while
0<=C_t^j<=L^2/8. Consequently the last term of (7.1) is at least

    -[1+|log m(Q)|+|K| L^2/8]/j,

uniformly in t. No upper bound on E_t^j is required in this estimate.

Continuity of F and G on Q and convergence of all the paths give

    F(tau_t) >= (1-t)F(tau_0)+t F(tau_1)
                 -D^2 integral_0^1 g(s,t) G(tau_s) ds.      (7.2)

This holds on every strict subinterval of sigma. On a compact
subinterval of (0,1), choose A with A''=ell^2 G(sigma_t).
The Green representation for A and (7.2) say exactly that
F composed with sigma minus A lies above each of its chords.
It is concave. Its distributional second derivative is therefore
nonpositive, giving (F composed with sigma)''<=ell^2 G composed
with sigma. A zero-length geodesic is immediate.

This proves Theorem `weight:every-geodesic`, including a prescribed
geodesic contained in an m-null set.

## 8. An admissible nonsmooth, infinite-measure boundary test

On (R,usual distance,dx), an RCD(0,2) space, set

    F(x)=-|x|/(1+|x|),       G(x)=2/(1+|x|)^3.

F is bounded and globally 1-Lipschitz, G is bounded and continuous, and

    F'' = G dx - 2 delta_0

as distributions. Thus, for every original compact test g and
nonnegative h in Lip_c,

    H_F(g',g')(h)
      = integral h G (g')^2 dx - 2 h(0)(g'(0))^2
      <= integral h G (g')^2 dx.

The identity follows by integration by parts for the locally BV
derivative F'; original one-dimensional test functions have the
regularity needed for these traces. Moreover, |F|>=1/2 outside
[-1,1], so F is not in L2(dx), and its delta second derivative
precludes membership in D(Delta) or a local L2 Hessian.

For smooth compact g agreeing with x near zero,
L_lambda g=lambda F' there. Its jump is -2lambda, so it is not
in W^{1,2}_{loc}. This demonstrates, under the actual Hessian
hypotheses, why replacing weighted test functions by original tests
is invalid. It confirms the manuscript's domain warning; it is
not a counterexample to any manuscript assertion, and no F_<LABEL>
refutation is claimed for a shortcut the manuscript itself rejects.

On the geodesic sigma(t)=2t-1, the exact pullback is

    (F composed with sigma)''
      = 4 G(2t-1) dt - 4 delta_{1/2},

which satisfies the required every-geodesic inequality even through
the kink. `verify.py` checks the smooth densities and jump coefficients,
as well as the Bochner and entropy identities and kernel normalization.

## Scope of the certificates and remaining review

`verify.py` is an offline exact-arithmetic replay, not an RCD prover.
It reconstructs the symbolic inputs from the displayed formulas,
checks the saved typed Jacobian result against the exact payload,
and verifies the nonsmooth example's distributional data.
The Jacobian result is a formal coefficient identity modulo 101.
The sum of absolute input coefficients is 14<101, so a zero modular
residual implies zero integer residual; the script also checks this
directly over the rationals. A numerical sampling result is not used.

`lean/Main.lean` addresses graph-form continuity, closure under strong
limits, the energy-to-gradient convergence estimate, and the two
scalar cancellation identities. Its fidelity note explicitly separates
these formal statements from the unformalized RCD analysis and external
curvature equivalences. The complete analytic proof is sections 1-7,
not the scalar identity or the example alone.

The current source was compiled by Lean 4.31.0 with exit code 0 and
`proof_holes=[]`; its claim-bound immutable certificate is
`lean/certificates/C_W356_FORMAL_CORE-8ac378dde3cdece8.json`.
Two earlier type-error runs remain archived as inconclusive evidence
for earlier formal-source versions, not as refutations. The current
statement-fidelity document was unchanged throughout those proof edits.

Compared with the prior recorded state (an untested hypothesis and an
empty analytic decomposition), this supplies the full domain argument,
an explicit resolvent contraction scale, quantitative closure estimates,
and the uniform lower entropy-error bound. It does not independently
settle the characterization manuscript's index or frame theorems.
It also does not establish a novelty claim relative to the literature:
the main verified assertions are those of the staged companion itself.
Independent source attribution, proof review, and the campaign's
publishable/novelty assessment remain necessary before acceptance.
