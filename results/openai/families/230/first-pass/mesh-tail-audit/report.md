# The integrated stopped-density tail

## Scope and conventions

This audit addresses Proposition `mesh:tail` of the September 26, 2026
manuscript, not either manuscript's complete Hausdorff theorem. The requested
quantifiers are every prescribed final mesh, every permitted finite stopped
past with a free collar, and constants independent of the tip distance.
A failure of a proof would not alone refute the proposition.

The September 26 convention is

\[
 p=1-\kappa/8,\quad d=2-p,\quad a_0=8/\kappa-1,\qquad
 \partial_tg_t=2/(g_t-\sqrt\kappa B_t).
\]

Conformal radius is the full radius, so \(R_{\mathbb H}(x+iy)=2y\).
In the September 25 manuscript the symbols are different:
\(a=2/\kappa,\ \alpha=1-\kappa/8,\ p_{\rm old}=4a-1\).
Thus \(p=\alpha\), \(a_0=p_{\rm old}\), and its internal time is
\(\kappa\) times the September 26 capacity time. No defect or proof is
transferred between the manuscripts by changing the symbol \(p\).

Write `S26` for
`research/openai_manuscript/An-explicit-exact-Hausdorff-gauge-for-SLE-September-26-2026/build/sections/`
and `S25` for the corresponding September 25 directory.

## Source-verified scope facts

The separate source reader's findings are recorded in `literature.md`.
The following are background results, not results of this audit.

* Rezaei--Zhan, arXiv:1412.3700v2, Theorems 1.1--1.2: arbitrary approach
  radii and moments of every fixed order are allowed. The constant depends
  on the order; the observation set is not an arbitrary initial domain.
  These statements do not supply a uniform \(n^{p/2}\) moment norm bound
  for stopped-density integrals. Their Remark 4 even states exponential
  integrability of content as a conjectural strengthening.
* Schramm--Sheffield, arXiv:1008.2447v1, Lemmas 2.5--2.6: the cited
  covariance identity is stated for SLE4 and deterministic test functions.
  The all-\(\kappa\), asynchronously stopped identity needed here must be
  derived, not attributed to those lemmas.
* Lawler--Werness, arXiv:1011.3551v4, Lemma 2.9 and Proposition 2.12:
  uniform inverse-angle integrability requires positive elapsed radius
  time; the absolute continuity statement is at a finite radius stop.
  It does not assert absolute continuity on the completed infinite future.
* Rohde--Schramm, published Theorem 5.1: for each fixed
  \(0<\kappa<8\), a continuous generating trace exists simultaneously at
  all times. This is not a simultaneous assertion over \(\kappa\).
* Loridant--Luo, arXiv:1703.05914v1, Lemmas 2.4 and 2.6:
  filling preserves local connectedness and boundaries of complementary
  components of a locally connected planar continuum are locally
  connected. No quantitative modulus is supplied.
* The accessible May 25, 2008 Mörters--Peres draft has the occupation
  identity as Theorem 3.31, not the final edition's Theorem 3.32.
  Neither version supplies the boundary-layer estimate by itself.

The known unsuccessful shortcut is to optimize a fixed-order moment bound
without any control of its order-dependent constants. This route is retired
in the claim ledger; it gives no conclusion about the truth of `mesh:tail`.

## Manuscript dependency map

The ledger and `research/PROOF_GRAPH.json` distinguish the two main claims.

For September 25, `thm:main` depends on the finite Green tilt and mixing,
`mp:estimate`, the canonical mass construction and stopping restart,
finite disk moments, the finite-batch gauge inequalities, retained-mass
lower bounds, and adaptive upper covering. Its gauge is moment-defined
and irregular, not the September 26 closed formula.

For September 26, `thm:main` depends on retained mass for positivity and
`prop:dense-cover-upper` for finite expected spatial measure. The former
uses `mesh:tail`, finite centered lifetime, and finite stopping restart.
The latter uses `rc:dense`, `rc:step`, conformal localization, the
deterministic-interval sausage lower bound, and the bounded-region charge.

The present target `mesh:tail` has two branches:

1. For \(\kappa\le4\): finite stopped one-point martingales,
   boundary-layer occupation, an asynchronously started Green-kernel
   bracket estimate, and an infinite summable slab bound.
2. For \(4<\kappa<8\): the same one-point laws, conformal localization
   and swallowing implying the physical-disk rule, adaptive
   disjoint-window concentration, and a summably perturbed two-variable
   recurrence.

All these are initially open obligations, not certified consequences of
their presence in a manuscript.

## Result

**Verification theorem V.** Proposition `mesh:tail`, including its conditional
domain uniformity, arbitrarily fine prescribed final mesh, killing convention,
and optional time cutoff, follows from the proof below for every fixed
\(0<\kappa<8\). The equivalent normalized tail is

\[
 \mathbb P\{S_e>u\}\le C\exp(-cu^{2/p}),\qquad
 S_e=\int_AW_e\,dA,\quad u\ge u_0.
 \tag{V}
\]

No disputed stochastic dependency is assumed as a black box. The finite
one-point law and standard conformal/Brownian facts are identified explicitly;
the asynchronous bracket, localization, swallowing, window concentration,
and infinite-level propagation are proved below.

**Domain extension D.** The same constants work for chordal SLE in every
bounded simply connected domain with locally connected boundary, arbitrary
distinct marked prime ends, and the same free Euclidean collar of \(A\).
They do not depend on the domain's diameter, its boundary modulus, or the
locations of the marked ends. The statement includes subsequent stopped
pasts in those domains whenever that collar remains free.

**Simultaneous-mesh theorem U.** For \(4<\kappa<8\), both domain classes
admit a stronger assertion. For each \(0<\delta\le\delta_0\), there is a
measurable random envelope \(E_\delta\) such that, on one event,

\[
 \forall\,0<e\le\delta:\quad S_e\le E_\delta,\qquad
 \mathbb P\{E_\delta>C\delta^{-p}\}
       \le C\exp(-c\delta^{-2}).
 \tag{U}
\]

In particular (U) permits an arbitrarily fine mesh selected measurably
after the whole curve is observed. No uncountable union of exceptional
events is used. This simultaneous assertion is not claimed here for
\(\kappa\le4\).

V is an independent analytic verification of the manuscript's proposition;
D and U are structural strengthenings of that proposition. The separate
source search found no such strengthening among the inspected primary
results, but **global novelty, publishable significance, and independent
Reviewer acceptance remain unverified**. No false literal manuscript
assertion has been identified, so there is no invented `F_` refutation claim.

## 1. One-point laws, including terminal and conditional statements

All time variables in this proof are initial half-plane Loewner times.
Conditional on any permitted finite past, composition gives ordinary
half-plane SLE with a fresh Brownian driver and a now fixed inverse map
\(J\). Put \(\zeta=J^{-1}(z)\), \(Z_t=X_t+iY_t=g_t(\zeta)-\sqrt\kappa B_t\).
Until the point is killed,

\[
 R_t=2Y_t|J'(\zeta)|/|g_t'(\zeta)|,\quad
 ds=-d\log R_t=4Y_t^2|Z_t|^{-4}\,dt.
\]

The radius-time ordinary angle generator and density are

\[
 L={\kappa\over8}\partial_\theta^2+
       {\kappa-4\over4}\cot\theta\,\partial_\theta,\qquad
 M_t=R_t^{-p}h(\theta_t),\quad h(\theta)=\sin^{a_0}\theta.
\]

Direct calculation gives \(Lh=-ph\) and

\[
 dM_t=\sqrt\kappa\,a_0{X_t\over|Z_t|^2}M_t\,dB_t.
 \tag{1}
\]

In particular the sign printed for this driver is correct. The tilted
angle generator is
\(L^*=(\kappa/8)\partial_\theta^2+\cot\theta\,\partial_\theta\).
For \(0<b<a_0\),

\[
 {L^*\sin^{-b}\theta\over\sin^{-b}\theta}
   ={\kappa b\over8}
       -{\kappa b(a_0-b)\over8}\cot^2\theta.
 \tag{2}
\]

Localize away from the endpoints, \(Y=0\), and infinite time.
The nonnegative supermartingale obtained from (2) bounds the probability
of an angular endpoint approach before a fixed radius time by
\(C\sin^b\epsilon\). On a compact angular interval,

\[
 {d\log Y_s\over ds}=-{1\over2\sin^2\theta_s},\qquad
 {dt\over ds}={Y_s^2\over4\sin^4\theta_s}
 \tag{3}
\]

keep \(Y\) positive and Loewner time finite. Thus the finite changed laws
lose no probability before a prescribed radius level. This proves their
mean-one identities and consistency without an infinite-future
Radon--Nikodym assertion. It is also exactly the finite-scale content of
Lawler--Werness Proposition 2.12, after changing their half-radius and time
conventions.

Their Lemma 2.9 applies after the time change
\(\Theta_{\kappa s/4}=\theta_s\), and gives

\[
 \sup_{\theta}\sup_{s\ge s_0}
    \mathbb E_\theta^*\sin^{-a_0}\theta_s<\infty
       \quad(s_0>0),
 \tag{4}
\]

because the invariant density is proportional to
\(\sin^{a_0+1}\theta\), and its product with \(\sin^{-a_0}\theta\)
is integrable.

Here is the terminal issue needed for optional stopping. On a path on
which a positive radius cutoff is never reached, radius time stays in a
bounded interval. If the ordinary angle stayed in a compact interior
interval until its terminal radius time, its SDE and (3) would extend it
with positive \(Y\) and finite Loewner time. Otherwise it tends to an
endpoint. It cannot alternate between the two endpoints infinitely
often in a finite radius interval: crossing a fixed interior interval
would contradict uniform continuity of the Brownian path and bounded
drift there. Thus \(M_t\to0\) whenever a positive cutoff is missed,
also when original Loewner time tends to infinity.

Let \(\tau_r(z)\) be the first *live* trace-distance \(r\) approach,
with value infinity if absent. While live,

\[
 \operatorname{dist}(z,\partial D_t)=
 \min\{\operatorname{dist}(z,\partial D_0),
                 \operatorname{dist}(z,\gamma[0,t])\}.
 \tag{5}
\]

The boundary of the surviving component is in the old boundary and
trace, while both are outside that component; this proves (5).
Before and at the cutoff, Koebe gives \(R_t\ge r\), so the density
stopped at that cutoff is bounded by \(r^{-p}\). At a killing time
before the cutoff its zero continuation is continuous by the terminal
argument above. Its terminal value is \(W_r\), including the missing-hit
case. Bounded localization and convergence therefore give

\[
 \mathbb E[W_r]=M_0,\qquad
 \mathbb E[W_{qr}\mid\mathcal F_{\tau_r}]=W_r
 \quad\hbox{on a finite live start}.
 \tag{6}
\]

Untilting at a finite radius stop and using (4) shows that the
probability of reaching radius \(R_0e^{-u}\), \(u\ge1\), is at most
\(Ce^{-pu}\sin^{a_0}\theta_0\). A clearance \(\epsilon\) approach
forces an earlier radius \(8\epsilon\) crossing, by Koebe and continuity.
Consequently, when \(\epsilon\le
\operatorname{dist}(z,\partial D_0)/(8\mathrm e)\),

\[
 \mathbb P\{\tau_\epsilon<\infty\}
           \le C\epsilon^pM_0.
 \tag{7}
\]

The same statements hold after a live stop: the current map and Brownian
strong Markov property give exactly the same finite stopped law.
Requiring the approach before an additional stop only decreases its
expected nonnegative density. No regularity or upper tip-distance bound
has entered (1)--(7).

Joint measurable versions are obtained from the continuous Loewner maps
on compact live localizations and then exhaustion. Indicators of the
stochastic intervals have predictable versions for integration, since
endpoints do not affect a \(dt\) integral. The deterministic trace-distance
identity (5) also fixes the versions of the approach indicators.

## 2. A boundary-layer estimate with no boundary smoothness

Let \(K_D\) have the logarithmic normalization in `mesh:layer`.
For standard Brownian motion, whose generator is \(\Delta/2\), the
occupation kernel is \(K_D/\pi\).

There are absolute \(a,\eta>0\) such that a Brownian motion started
within distance \(r\) of the connected unbounded closed set \(D^c\)
hits that set by time \(ar^2\) with probability at least \(\eta\).
To see this, rescale to \(r=1\). A finite sequence of rectangle
crossings in a fixed annulus outside \(B(0,2)\), with a final transverse
crossing of the initial crossing, forces a closed subcurve separating
\(B(0,2)\) from infinity. The crossings can be prescribed with positive
margins; the Brownian transition density and Markov property give a
strictly positive probability in a fixed time. Such a separating
subcurve must intersect \(D^c\), which meets \(B(0,1)\) and is
connected and unbounded. Exiting \(D\) earlier is already a success.
All constants come from this one fixed, scale-invariant crossing event.

Start a block of length \(ar^2\) at the first entrance to the layer
\(\{\operatorname{dist}(\cdot,\partial D)\le r\}\); after its end,
wait for the next entrance. Use the open layer of width \(2r\) if
desired to remove an entrance-boundary convention. Each started
block has conditional killing probability at least \(\eta\).
The expected number of blocks is at most \(\eta^{-1}\), and all
occupation of the original layer is in their union. Hence

\[
 \int_{\{\operatorname{dist}(w,\partial D)\le r\}}
                 K_D(z,w)\,dA(w)\le \pi a r^2/\eta.
 \tag{8}
\]

This holds also for starting points far from the layer: wait for its
first entrance. The nonnegative occupation identity is first applied
in bounded exhaustions and then passed by monotone convergence.
In particular (8), rather than a boundary regularity assumption,
establishes finiteness of the integral.

## 3. Asynchronous slabs when \(\kappa\le4\)

Fix \(q>0\) sufficiently small; throughout the proof it may depend on
\(\kappa\), but never on the domain or final mesh. Require
\(q\le1/32<1/(8\mathrm e)\).
A point is active between \(\tau_r\) and \(\tau_{qr}\), or killing.
Since \(a_0\ge1\), (1) and \(R_t\ge qr\) imply that its active
coefficient satisfies

\[
 |b_t(z)|\le C r^{-p}\,{Y_t(z)\over|Z_t(z)|^2}.
 \tag{9}
\]

For two live points, direct differentiation, not an all-\(\kappa\)
invocation of Schramm--Sheffield, gives

\[
 -\partial_t K_{D_t}(z,w)
     =4\,{Y_t(z)\over|Z_t(z)|^2}
          {Y_t(w)\over|Z_t(w)|^2}.
 \tag{10}
\]

The common Brownian translation cancels in both differences of the
half-plane formula for \(K\). The exact rational identity (10) is one
of the symbolic certificate's checks.

For an overlapping pair, assign its contribution to the later starting
point, say \(z\). Integrating (9)--(10) only over the overlap and using
positivity of the terminal Green function bounds the contribution by
\(Cr^{-2p}K_{D_{\tau_r(z)}}(z,w)\).
At this particular time, every earlier still-active \(w\) is live
and within distance \(r\) of the boundary. Domain decrease preserves
that distance upper bound. For fixed \(z\), this is one domain, not a
different domain for each \(w\). Applying (8), integrating over \(z\)
in \(A\), and allowing both possible orders therefore gives pathwise

\[
 \int_0^\infty\left|\int_A b_t(z)\,dA(z)\right|^2dt
 \le\iint_{A^2}\int_0^\infty|b_t(z)b_t(w)|\,dt\,dA(z)dA(w)
 \le Cr^{2-2p}.
 \tag{11}
\]

The spatial diagonal is null; tied starts may be counted twice.
No-start points have coefficient zero. Infinite overlaps follow by
monotone convergence.

For completeness, write
\(N_t(z)=M_{t\wedge\tau_{qr}}(z)-M_{t\wedge\tau_r}(z)\),
with killed zero continuation before either freeze. These are bounded
continuous martingales by Section 1. Their terminal difference is
\(W_{qr}-W_r\), even if the second approach never happens:
then that term tends to zero and the difference tends to \(-W_r\).
Boundedness gives
\(\mathbb E\int b_t(z)^2dt\le Cr^{-2p}\).
Thus
\(\int_A(\mathbb E\int b_t(z)^2dt)^{1/2}dA(z)<\infty\).
The \(L^2\) stochastic Fubini identity applies, and bounded convergence
passes the terminal identity through the finite-area spatial integral.
This proves that (11) is the bracket of a genuine martingale whose
terminal value is \(S_{qr}-S_r\).

The exponential martingale, followed by localization and Fatou, gives

\[
 \mathbb P\{S_{qr}-S_r>x\}
             \le\exp(-c x^2/r^{2-2p}).
 \tag{12}
\]

Now fix any prescribed \(e\le\delta\). Choose \(N\ge0\) and
\(r_0\in(q\delta,\delta]\) so \(e=r_0q^N\); all slabs have ratio
exactly \(q\). The initial bound is
\(S_{r_0}\le\pi q^{-p}\delta^{-p}\).
Set \(x_j=\delta^{-p}/(j+1)^2\).
Reduce \(q\) further so \(B=q^{-2(1-p)}\ge32\).
The exceptional probability of slab \(j\) is at most

\[
 \exp\left(-c\delta^{-2}{B^j\over(j+1)^4}\right)
       \le \exp(-c\delta^{-2}(j+1)).
 \tag{13}
\]

The last inequality is universal, not an asymptotic finite test:
\((j+1)^5\le32^j\) follows by induction from
\(j+2\le2(j+1)\), and is also formally proved in `Main.lean`.
The sum of (13) over all \(j\ge0\) is
\(Ce^{-c'\delta^{-2}}\) for \(0<\delta\le\delta_0\).
Also \(\sum(j+1)^{-2}\le2\), by comparison of the terms after
the first with \(1/[j(j+1)]\).
Outside those exceptions, telescoping yields
\(S_e\le(\pi q^{-p}+2)\delta^{-p}\).
This proves V for \(\kappa\le4\), with no dependence on \(N\).

## 4. The physical-disk rule is a consequence, not an assumption

This section checks the extra input needed for \(4<\kappa<8\).
It also explains why an arbitrarily narrow passage in the old domain
does not invalidate the uniform constants.

### 4.1 A small target in the parameter half-plane

Ordinary half-plane SLE satisfies

\[
 \mathbb P\{\operatorname{dist}(v,\gamma)<\epsilon\}
     \le C\epsilon^\xi,\qquad
 v\in\overline{\mathbb H},\quad 1/2\le|v|\le2,
 \tag{14}
\]

for some \(\xi>0\), including boundary visits and the entire future.
Here is a derivation sufficient for uniformity.
For real \(x\) bounded above and away from zero put
\(X_t=g_t(x)-\sqrt\kappa B_t\) and
\(h=\int_0^tX_u^{-2}du\), up to collision. Then

\[
 \log|X_h|=\log|x|+(2-\kappa/2)h+\sqrt\kappa\,\widetilde B_h.
\]

For \(|w-x|<4\epsilon\), the Loewner difference
\(D_t(w)=g_t(w)-g_t(x)\), as long as
\(|D_t(w)/X_t|\le\eta\), satisfies

\[
 {d\log|D_t(w)|\over dh}
    =-2\operatorname{Re}{X_t\over X_t+D_t(w)}
    \le-2+C\eta.
\]

Choose \(\eta>0\) so \(\mu=4-\kappa/2-C\eta>0\).
Failure of the ratio bound requires
\(-\mu h-\sqrt\kappa\widetilde B_h\) to reach
\(\log(\eta|x|/(4\epsilon))\). The exponential Brownian hitting
bound makes this probability \(O(\epsilon^{2\mu/\kappa})\).
The estimate holds simultaneously on compact sub-half-balls by
analyticity and a countable dense exhaustion. On its complement
every point of that half-ball stays live up to \(x\)'s collision,
and collides at that time if it is finite.

Thus the trace cannot visit the smaller relative half-ball before or
after that time. A hypothetical boundary-only visit also gives an
interior visit nearby by continuity: a capacity-parametrized generating
trace cannot spend a positive time interval only on the real line,
since such additions do not increase its filled hull capacity.

For \(\Im v\le\sqrt\epsilon\), use the real estimate at
\(\Re v\) with radius \(2\sqrt\epsilon\).
For \(\Im v>\sqrt\epsilon\), (7) applies for small \(\epsilon\),
and
\[
 M_0(v)=(2\Im v)^{-p}(\Im v/|v|)^{a_0}\le C
\]
because \(a_0-p=(8-\kappa)^2/(8\kappa)>0\).
A visit forces a prior live \(2\epsilon\) approach: otherwise the
untouched connected ball would already have been swallowed and
could not be entered later. This proves (14).

### 4.2 Uniform localization through an irregular conformal map

Suppose \(F:\mathbb H\to\mathbb C\) is univalent with continuous
spherical boundary extension. Suppose an access from 0 to modulus 1
has image in \(\overline B(z,r)\). For \(H=\log L\), on strip
coordinates \(w=e^{v+i\phi}\) define

\[
 U(v,\phi)=\min\{H,\log^+(|F(e^{v+i\phi})-z|/r)\}.
\]

Univalence and conformal area change give the global bound

\[
 \int_{\mathbb R\times(0,\pi)}|\nabla U|^2\le2\pi H.
 \tag{15}
\]

This bound is independent of every boundary modulus. The access gives
a zero of \(U\) on each vertical section with \(v<0\).
On each slab \(Q_j=[j,j+1]\times[0,\pi]\), \(j<0\), its mean is
at most \(C\sqrt{E_j}\), by one-dimensional Poincare, where
\(E_j=\int_{Q_j}|\nabla U|^2\).
For positive \(v\), Cauchy--Schwarz on the derivative of the angular
mean gives
\(A(v)\le C\sqrt H+C\sqrt{(v+1)H}\).
Consequently all slab means with \(j\le bH\) are at most \(H/2\)
for a fixed sufficiently small \(b>0\) and large enough \(H\).

We need the following deterministic-energy hitting observation.
For a fixed-aspect rectangle \(Q\), continuous \(0\le u\le H\)
with mean at most \(H/2\) and energy \(E\ll H^2\), suppose a random
set hits each dyadic level-\(k\) rectangle with probability at most
\(C2^{-\xi k}\). Then

\[
 \mathbb P\{\text{hit }\{u=H\}\}
       \le C(E/H^2)\exp(-cH^2/E).
 \tag{16}
\]

To prove it, reflection and concentric dyadic annuli, followed by
Poincare and Cauchy--Schwarz, give for every nested chain
\(|u_{Q_k}-u_Q|\le C\sqrt{(k+1)E}\).
Choose \(N=\lfloor cH^2/E\rfloor\) so means up to level \(N\)
are at most \(3H/4\). Along a chain ending at \(u=H\), some
subsequent level \(N+j\) has a mean change at least \(cH/j^2\).
Poincare forces its parent to have energy at least \(cH^2/j^4\).
There are at most \(CEj^4/H^2\) such parents at that level,
since their interiors are disjoint. A union bound over these parents
and over all \(j\ge1\) proves (16). If \(E=0\), continuity and
the mean condition make the hit impossible. Closed dyadic rectangles
also cover boundary points.

By scaling (14), the exponential image of every level-\(k\)
subrectangle in \(Q_j\) has SLE hitting probability
\(C2^{-\xi k}\), uniformly in \(j\). Apply (16) and sum over
all \(j\le bH\). From (15),

\[
 \sum_{j\le bH}C{E_j\over H^2}e^{-cH^2/E_j}
       \le {C\over H}e^{-c'H}\le CL^{-\xi'}.
\]

The sum includes the infinitely many negative slabs. Until the
parameter trace reaches modulus \(L^b\), a physical exit from
\(B(z,Lr)\) must meet \(U=H\) in one of these slabs.
We have therefore proved the uniform conformal localization estimate,
including boundary excursions.

### 4.3 Swallowing is uniform in the initial angle

Assume \(4<\kappa<8\), \(|\zeta|=1\).
Set \(h=-\log(Y/Y_0)\), \(P=X/Y\). Its generator and physical clock are

\[
 G={\kappa\over4}(1+P^2)\partial_P^2+2P\partial_P,\qquad
 {dt\over dh}={Y_0^2\over2}e^{-2h}(1+P_h^2).
\]

Choose \(\beta=(\kappa-4)/(2\kappa)\), so
\(0<\beta<1-4/\kappa\), and let \(V=(1+P^2)^{\beta/2}\).
Direct calculation gives

\[
 {GV\over V}=
 {2\beta P^2+(\kappa\beta/4)[1+(\beta-1)P^2]\over1+P^2}.
 \tag{17}
\]

Its limiting value \(\rho=2\beta+\kappa\beta(\beta-1)/4\)
satisfies
\(\beta-\rho=(\kappa-4)^2/(16\kappa)>0\).
Also \(\rho>0\), since \(\kappa<8\).
Take \(\lambda=(\rho+\beta)/2\). Then
\(GV\le\lambda V+C\), and localization and Gronwall give
\(\mathbb EV(P_h)\le Ce^{\lambda h}V(P_0)\).
The SDE for \(P\) has linear-growth coefficients, so exists at
every finite \(h\). A finite terminal value of \(h\) would give
finite Loewner time, finite \(P\), positive \(Y\), and an extendible
Loewner solution, so is not a lifetime.

The drift and diffusion coefficients of \(\log V(P_h)\) are bounded.
The exponential martingale maximal bound on each unit interval
therefore gives
\(\mathbb E\sup_{n\le h\le n+1}V(P_h)\le
Ce^{\lambda n}V(P_0)\).
Since \(\beta/2<1\), subadditivity now yields

\[
 \mathbb ET_\infty^{\beta/2}
 \le C Y_0^\beta V(P_0)
         \sum_{n\ge0}e^{-(\beta-\lambda)n}\le C.
 \tag{18}
\]

The cancellation \(Y_0^\beta V(P_0)=|\zeta|^\beta=1\) is
why this is uniform even at nearly real initial angles.
The same estimate bounds the expected unit-interval supremum of
\(|X_h|^\beta\) by \(Ce^{-(\beta-\lambda)n}\).
Borel--Cantelli gives \(X_h\to0\), while \(Y_h\to0\), so this
finite terminal time is the actual collision \(T_\zeta\).

At time \(t\), a half-plane hull stays below height \(2\sqrt t\)
and between the extrema of its driver. Thus a trace excursion to
modulus \(A\) before time \(A\), for large \(A\), forces
\(\sup_{t\le A}|\sqrt\kappa B_t|\ge cA\), of probability
\(Ce^{-c'A}\). Splitting according to \(T_\zeta>A\), and using
(18), proves

\[
 \mathbb P\{\sigma_A\le T_\zeta\}\le CA^{-\beta/2}.
 \tag{19}
\]

### 4.4 Radial access and the conditional disk estimate

For a finite half-plane trace, the lower hemisphere together with
the trace is a locally connected continuum: each is a continuous
image of a compact interval or disk and they intersect. Filling
preserves local connectedness, and its complementary boundary is
locally connected, by the two source-checked Loridant--Luo lemmas.
The usual boundary-continuity consequence of prime-end theory then
gives continuous spherical extension of the inverse map.
One can obtain that consequence directly from the prime-end
correspondence in Beliaev Theorem 2.6.13: local connectedness joins
the nearby endpoints of a null crosscut by a small boundary arc,
so the side not containing a fixed interior point is contained
inside a small Jordan curve. Each prime-end impression is consequently
a singleton. Compactness gives continuity of the resulting extension.
For bounded Jordan initial domains the stronger boundary
homeomorphism is Beliaev Theorem 2.6.6.

At a fresh terminal interior point \(a\), the filled complement with
\(a\) removed is connected. Indeed the earlier trace and original
complement are connected without \(a\); every filled component's
closure minus \(a\) is connected and meets that set at a boundary
point other than \(a\). If two boundary parameters mapped to \(a\),
a crosscut joining them would map to a Jordan curve in \(D\cup\{a\}\).
Neither intervening boundary arc can map constantly to \(a\):
reflection across that arc would force a univalent map to be constant.
There would therefore be a complement point on each side of the
Jordan curve, disconnecting the complement minus \(a\). This
contradiction proves uniqueness of its boundary parameter and hence
of every access to that point. This is the separation argument used
in `geom:fresh-tip`; no quantitative boundary continuity is claimed.

At a first live circle hit of an initially free \(\overline B(z,r)\),
the hit is fresh, the open disk is untouched and contains the live
center, and the radial segment from hit to center is in the surviving
domain. Its image in a tip--target half-plane map, normalized so the
center has modulus one, is a continuous access from 0 to modulus 1.
The inverse image of that access stays in \(\overline B(z,r)\).

Apply Section 4.2 to this inverse map and Section 4.3 to its unit-modulus
marked point. Except with probability \(CL^{-c_1}\), the image
trace does not leave \(B(z,Lr)\) before parameter modulus \(L^b\).
Except with probability \(CL^{-bc_2}\), the point is swallowed
before that modulus. Therefore

\[
 \mathbb P\{\text{exit }B(z,Lr)\text{ live}\mid
                         \mathcal F_{\tau_r}\}\le C_*L^{-c_*}.
 \tag{20}
\]

This proves the required physical-disk rule. The outer disk need not
be free. Conditional on the entire past, the future parameter-plane
law is ordinary SLE; all constants in (14)--(20) were independent
of that past and its conformal map.

## 5. Adaptive windows do not require independent test locations

Let centers be a Borel subset of the unit disk, start on their
radius-\(r\) circles, remain within radius \(R\) during their
windows, and have outputs \(0\le Y_z\le K\) with
\(\mathbb E[Y_z\mid\mathcal F_{\sigma_z}]\le\mu_z\).
Assume the joint measurability and zero-output conventions of
`win:concentration`. Require \(r\le R\) and \(3R\le1\).

For a fixed shift of the lattice of spacing \(a=3R\), there are
at most \(Ca^{-2}\) centers in the unit disk.
While one window is running another center's window cannot start:
its distance from that center would imply a center separation
less than \(R+r\le2R<a\). Order actual starts by the next minimum
among remaining stopping times. The selected index is known at
that start; the previous output is known by then. Distinct finite
starts cannot tie. This is an adaptive enumeration, not a
conditioning on the final permutation.

Conditional Hoeffding, applied to each selected test by partitioning
over its finitely many possible indices, gives

\[
 \mathbb E[e^{\theta(Y-\mu)}\mid\mathcal F_\sigma]
                     \le e^{K^2\theta^2/8},\quad \theta\ge0.
\]

Iterate for the deterministic upper bound on the number of centers,
padding with zeros. If a window lasts forever its output is zero,
its increment is \(-\mu\le0\), and it prevents all later starts;
the same argument applies with terminal sigma fields. Missing starts
also give zero increments. No optional selection of a favorable
permutation has occurred.

For \(f=Y-\mu\), extended by zero, put
\(T_\xi=a^2\sum_{z\in\xi+a\mathbb Z^2}f(z)\).
The exact identity

\[
 \int f\,dA={1\over a^2}\int_{[0,a)^2}T_\xi\,d\xi
\]

and Jensen and Tonelli give
\(\mathbb E e^{\lambda\int f}\le
\exp(CK^2\lambda^2R^2)\).
Exponential Markov optimization proves

\[
 \mathbb P\{\int(Y-\mu)>b\}
             \le\exp(-c b^2/(K^2R^2)).
 \tag{21}
\]

The proof is valid after initial conditioning. It is not an
independence claim about the continuum of centers or the lattice shift.

## 6. All levels for \(4<\kappa<8\)

Set \(\epsilon=(1-p)/2\), and reduce the fixed \(q\) so that
\(B=q^{-2(1-p-\epsilon)}\ge32\).
At first live \(r_j=r_0q^j\) approach, set
\(L_j=L_*q^{-\epsilon j}\) and end a window at the first of
the next live \(qr_j\) approach, exit from \(B(z,L_jr_j)\), and
death. Let \(H_j\) indicate the next approach in that window,
\(V_j=r_j^pW_{r_{j+1}}H_j\), and \(B_j\) indicate an outer
exit before the next approach while live. All outputs are zero
if there is no start or the window never ends. They are bounded
by fixed constants since \(W_{qr}\le(qr)^{-p}\).

Equations (6), (7), and (20), rather than an assumed stochastic
recurrence, give their conditional upper means

\[
 \mu^H_j=C(qr_j)^pW_{r_j},\qquad
 \mu^V_j=r_j^pW_{r_j},\qquad
 \mu^B_j=C_*L_j^{-c_*}I_{r_j}.
 \tag{22}
\]

An eventual next approach missed by the window must follow its live
outer exit; it cannot follow death or an infinite window. Thus

\[
 I_{r_{j+1}}\le H_j+B_j,\qquad
 W_{r_{j+1}}\le r_j^{-p}V_j+(qr_j)^{-p}B_j.
 \tag{23}
\]

Choose \(\delta_0\) eventually so \(3L_*\delta_0\le1\) and the
collar is free at every \(r_j\). Then
\(L_jr_j=L_*r_0q^{(1-\epsilon)j}\le L_*\delta\).
Apply (21) to each output with
\(b_j=(r_j/\delta)^p/(j+1)^2\).
Its failure probability is at most

\[
 C\exp\left[-{c\delta^{-2}\over L_*^2}
       (r_0/\delta)^{2p-2}{B^j\over(j+1)^4}\right].
 \tag{24}
\]

For \(r_0\le\delta\), the extra ratio is at least one.
The universal comparison used in (13) sums (24), including all
three outputs and every \(j\ge0\), to
\(C\exp(-c'\delta^{-2}/L_*^2)\).
This is a countable event independent of how many levels will be used.

On that event define \(S_j=\int W_{r_j}\) and
\(A_j=r_j^{-p}\int I_{r_j}\).
Integrating (22)--(23) gives, with fixed \(C_i\),

\[
 S_{j+1}\le S_j+\alpha_jA_j+e_j,\qquad
 A_{j+1}\le C_1S_j+\alpha_jA_j+e_j,
 \tag{25}
\]

where
\(\alpha_j=C_2L_*^{-c_*}q^{\epsilon c_*j}\) and
\(e_j=C_3\delta^{-p}/(j+1)^2\).
For example the two error terms from \(H_j,B_j\) contribute
\(2q^{-p}r_j^{-p}b_j\); this is a fixed constant times the
displayed \(e_j\). The term from the window density has conditional
mean exactly \(S_j\). This accounts for every factor of \(q\);
there is no accumulating fixed loss at each level.

Take \(\Lambda\ge\max(1,2C_1)\), then choose \(L_*\) so
\(\alpha_0\le1/2\), and only then choose \(\delta_0\).
All choices depend on \(\kappa\) and the collar alone.
With \(U_j=\max(S_j,A_j/\Lambda)\), (25) implies

\[
 U_{j+1}\le(1+\Lambda\alpha_j)U_j+e_j.
 \tag{26}
\]

The two affine coefficients are exactly
\(1+\Lambda\alpha_j\) and \(C_1/\Lambda+\alpha_j\);
their symbolic product is recorded by the Jacobian adapter.
The latter is at most one. `MeshTail.envelope_step` formally proves
this reduction for every admissible real parameter tuple.

Induction in (26), without a finite-horizon constant, yields

\[
 U_n\le\left(U_0+\sum_{j<n}e_j\right)
            \prod_{j<n}(1+\Lambda\alpha_j)
 \le\left(U_0+\sum_{j\ge0}e_j\right)
                 \exp\left(\Lambda\sum_{j\ge0}\alpha_j\right)
 \le C\delta^{-p}.
 \tag{27}
\]

The induction and its uniform-bound consequence are also proved in
Lean. Analytically, \(\sum e_j\le2C_3\delta^{-p}\) and
\(\sum\alpha_j=C_2L_*^{-c_*}/(1-q^{\epsilon c_*})<\infty\);
\(U_0\le C\delta^{-p}\) when \(r_0\ge q\delta\).
Thus all estimates are independent of \(n\).
For a prescribed \(e\le\delta\), choose \(r_0\in(q\delta,\delta]\)
with \(e=r_0q^n\). Equations (24)--(27) prove V in the remaining
parameter range.

For U, instead fix \(r_0=\delta\) once, use the same event for
all \(j\ge0\), and define the measurable envelope

\[
 E_\delta=q^{-p}\sup_{j\ge0} A_j.
\]

If \(r_{j+1}<e\le r_j\), continuity of live trace distance implies
\(I_e\le I_{r_j}\). The pointwise density cap then gives, on each
path and for every such \(e\),

\[
 S_e\le e^{-p}\int I_e
       \le q^{-p}r_j^{-p}\int I_{r_j}=q^{-p}A_j.
 \tag{28}
\]

The countable measurable envelope therefore dominates all meshes,
not just a sampled sequence. Its tail follows from (24)--(27).
For null-set precision, Loewner formulas and caps are taken on the
common continuous-trace event; finite-start martingale estimates
are required only at the countably many \(r_j\). Fubini gives their
simultaneous spatial versions. This avoids having to assume an
uncountable supremum is measurable.

## 7. Domain extension, normalization, and time cutoffs

Every part of Sections 1--6 has the following uniformity:

* The collar supplies \(R_0\ge\rho_{\rm col}\) and the initial
  first-approach interpretation, and nothing about the initial angle.
* The layer estimate is uniform over all surviving simply connected
  domains. Green differentiation is conformally invariant and allows
  any initial uniformization; its half-plane time cancels in the
  integrated bracket.
* Localization is uniform over all univalent inverse maps satisfying
  the access and continuous-extension conditions. It contains no
  modulus of boundary continuity or distance-to-tip constant.
* Swallowing is uniform even as the parameter angle tends to zero,
  by the exact cancellation in (18).
* Adaptive windows use physical Euclidean confinement only.

For a bounded simply connected locally connected initial domain,
prime-end theory gives a continuous finite extension of its
uniformization \(J_0\). At subsequent finite parameter times its
inverse is \(J_0\circ g_t^{-1}\); both factors extend continuously.
The physical trace is continuous and finite. At a first circle
hit inside the initial domain, injectivity of \(J_0\) in the interior
preserves freshness and the unique radial prime-end access of
Section 4.4. The proofs of (1)--(28) therefore apply verbatim, with
the same constants. This proves D, including its stopped versions.
This is stronger than merely transporting an estimate with
map-dependent derivative constants on a compact set.

To obtain (V) for every \(0<e<\rho_{\rm col}\), put
\(C_0\ge\max(C_{\rm threshold},\pi)\) and
\(\delta=(C_0/u)^{1/p}\) for \(u\ge C_0\delta_0^{-p}\).
If \(e\le\delta\), the proved estimate applies; if \(e>\delta\),
the deterministic bound \(S_e\le\pi e^{-p}<u\) makes the event
empty. The exponent is \(\delta^{-2}=C_0^{-2/p}u^{2/p}\).
This passage makes no implicit restriction to small \(e\) relative
to an unmentioned intermediate scale.

A spatial similarity of factor \(R\) multiplies the density by
\(R^{-p}\), area by \(R^2\), and mass by \(R^{2-p}=R^d\).
Finally, counting only approaches with \(\tau_e\le T\), for a
deterministic or stopping time \(T\), deletes nonnegative
contributions pointwise. It preserves V, D, and U without an
additional stopping argument. All statements are consequently
valid conditionally on a finite past with the required free collar.

## 8. Certificate coverage and limits

The exact anchors replayed by the certificate include:

| Source | Assertion | Label line |
|---|---|---|
| S26 `mesh-tails.tex` | Integrated mesh tail | 75 |
| S26 `mesh-tails.tex` | Boundary-layer occupation | 122 |
| S26 `mesh-tails.tex` | Green decrease / asynchronous bracket | 215 / 244 |
| S26 `mesh-tails.tex` | Adaptive window concentration | 334 |
| S26 `mesh-tails.tex` | Window means / recurrences | 492 / 551 |
| S26 `local-laws.tex` | Localization / swallowing / disk rule | 515 / 593 / 679 |
| S26 `geometry.tex` | Extension / fresh tip / first-hit access | 21 / 75 / 132 |
| S26 `introduction.tex` | Regular-gauge main theorem | 66 |
| S25 `introduction.tex` | Moment-defined-gauge main theorem | 38 |

`verify.py` exactly replays the one-point generator/tilt identities,
the Brownian-coefficient sign, the Green-decrease rational identity,
the swallowing Lyapunov calculation and positive exponent gaps,
the recurrence coefficient product, the summation comparisons,
and the scale exponents. It also checks the preserved typed
Jacobian request against its actual output. This is symbolic
verification in free variables, not a parameter sample.

`Main.lean` separately proves the deterministic recurrence envelope,
finite-product propagation, its all-natural-index uniform corollary,
and the universal exponential-versus-polynomial comparison.
Its compiler receipt and statement-fidelity document are required
to match the current source. No claim is made that Lean contains
SLE or a formalization of this entire analytic proof.

The Brownian circuit, stochastic calculus, prime-end separation,
energy localization, adaptive enumeration, and their application
to SLE are analytic proof obligations for independent human/agent
review, supplied above rather than inferred from the script's
exit status. The ledger records Engineer support as an opinion.
Both manuscript main Hausdorff claims and the unrelated ribbon
uniformity remain open in the graph.

Compared with the strongest inspected prior estimate, fixed-order
Rezaei--Zhan moments, V proves a quantitative domain-and-mesh-uniform
tail rather than moment finiteness. Compared with the target
manuscript itself, D enlarges the initial-domain class and U
strengthens prescribed meshes to one event for all finer meshes
when \(\kappa>4\). These comparisons do not establish global novelty
or sharpness of the exponent. The Host's independent Reviewer must
assess proof correctness, statement fidelity, significance and
originality before campaign acceptance.

## 9. Reproduction and current review boundary

From the campaign root:

```bash
python3 research/mesh-tail-audit/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/mesh-tail-audit/Main.lean --statement-fidelity research/mesh-tail-audit/statement_fidelity.md --claim C_MESH_ALGEBRA --project-root . --timeout 90
```

The executed symbolic replay passed 25 exact identities and 17 manuscript
anchors. The actual Lean 4.31.0 compiler and axiom audit both exited zero,
with `proof_holes=[]`, and the result was archived on `C_MESH_ALGEBRA`.
The replay checks that receipt against the present source and fidelity
document; it does not pretend that reading a saved receipt recompiles Lean.
No Lean source or fidelity text was changed after the successful recording.

Both official structural checks have passed against the exact project root
`campaigns/9000230`.
These checks do not constitute independent acceptance of the analytic proof.
The primary-source readings in `literature.md` still require the normal
independent citation-attribution records before the review stage can accept
the result. Six canonical citations are presently `unchecked` in that
ledger; three explicitly version-qualified lecture-note/draft sources have
prose citations without canonical identifiers. Those states are disclosed,
not silently re-labelled as completed literature evidence.
