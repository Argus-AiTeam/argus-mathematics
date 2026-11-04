# Velocity-only backward profiles: the complete energy-class exclusion

This note proves the velocity-only alignment exclusion by an **integrated
boundary-regularity route**, rather than asserting uniform pointwise
derivative decay. Sections 6--11 give the new proof submitted for independent
review. Section 4 is the unchanged automatic-mildness reduction independently
verified in the preceding review. Section 5 retains the precise limits of the
two retired pointwise shortcuts.

The accepted theorem `CWP_ALIGN_H1` and its proof in
[`automatic-profile-pressure.md`](automatic-profile-pressure.md) are unchanged.
The new argument verifies the same weighted-energy prerequisites without H1's
independently assumed derivative decay. It retains the alignment condition;
it is not an unrestricted Liouville or campaign-completion claim.

## 1. Theorem and accepted comparison

Let `H={y in R^3:y3>0}`, `r=|y|`, `nu>0`, and `a>0`. Assume a smooth
up-to-the-wall solution of

    -nu Delta U+a(U+y dot grad U)+(U dot grad)U+grad P=0,
    div U=0,                 U|_(y3=0)=0,                      (1)

with only

    |U(y)| <= C/(1+|y|).                                      (V)

There is no pressure normalization, derivative bound, mildness assumption,
finite kinetic energy, or strong spatial L3 assumption in (V).

Then both

    D=(integral_H r|Delta U|^2)^(1/2),
    L=(integral_H r|U cross curl U|^2)^(1/2)

are finite, and every nonzero profile satisfies

    L/D >= nu sqrt(2/3)(1-sqrt(999/1000)) > nu/2500.             (2)

Thus `L <= (nu/2500)D` forces `U=0` and `grad P=0`. An inequality
between two infinite extended integrals is not an admissible replacement.
If `D=0`, each component of `U` is harmonic, has zero wall trace, and tends
uniformly to zero at infinity by (V). The maximum principle on expanding
half-balls then gives `U=0`, and (1) gives `grad P=0`. This zero-denominator
argument does not need derivative decay.

The strongest accepted comparison is already (2), with the same exact
constant and automatic pressure recovery, under (V) together with

    |grad U(y)| <= C1(1+|y|)^(-2),
    |grad^2 U(y)| <= C2(1+|y|)^(-3).                            (D12)

The new conclusion removes those two derivative hypotheses. The proof does
not assert (D12): sections 8--10 establish the alternative energy-class
prerequisites and section 11 proves (2). The exact constant is unchanged.

## 2. Elementary rescaling reduction

Set `lambda(t)=sqrt(-2at)` for `t<0` and define

    u(x,t)=lambda(t)^(-1) U(x/lambda(t)),
    p(x,t)=lambda(t)^(-2) P(x/lambda(t)).

Since `lambda'(t)=-a/lambda(t)`, direct differentiation yields

    partial_t u=a lambda^(-3)(U+y dot grad U),
    Delta_x u=lambda^(-3) Delta_y U,
    (u dot grad_x)u=lambda^(-3)(U dot grad_y)U,
    grad_x p=lambda^(-3) grad_y P.

Consequently (1) is precisely the Navier--Stokes equation
`partial_t u-nu Delta u+(u dot grad)u+grad p=0`, with the same no-slip
wall. Assumption (V) implies

    |u(x,t)| <= C/(sqrt(-2at)+|x|).                             (3)

In particular `U in Lq(H)` for every `q>3`, and

    ||u(t)||_q=lambda(t)^(3/q-1)||U||_q,
    ||u(t)||_infinity <= C/sqrt(-2at).                         (4)

For `R=|y|>=2`, put `x=y/R` and `t_R=-1/(2aR^2)`. Then

    grad_x^j u(x,t_R)=R^(j+1) grad_y^j U(y),     j=1,2.         (5)

Uniform bounds for these derivatives on a fixed half-annulus containing
`{|x|=1,x3>=0}`, for all times sufficiently close to zero from below,
would therefore prove (D12). Compact smoothness supplies the remaining
bounded `y` region. Conversely, (D12) supplies exactly such annular
bounds through the same scaling.

Bound (3) gives uniform **velocity** bounds on that annulus. Smoothness
on each compact time interval lying strictly below zero does not give
uniform derivative bounds as `t` tends to zero. The global bound in (4)
also diverges in that limit. These are different assertions.

## 3. Primary-source boundary estimates and their hypotheses

The source readings below were performed by the separate
`boundary-source-reader` research agent. This is source verification, not
the Host's independent mathematical review. No whole-space estimate is
being transferred across the wall.

### Barker--Seregin: mildness is a hypothesis

Primary version:
[arXiv:1503.07428v1](https://arxiv.org/pdf/1503.07428v1),
*Ancient Solutions to Navier--Stokes Equations in Half Space*.
Theorem 1.3, p.6, assumes a **mild bounded ancient solution** on the
entire half-space-time cylinder. It bounds all mixed time and spatial
derivatives of the velocity, and the spatial pressure gradient, in terms
of the global velocity bound. Definition 1.2, p.5, (1.9), defines
mildness by the Stokes-kernel representation for every initial time.

Theorem 1.4, p.6, instead characterizes mildness through the distributional
equations and a pressure decomposition `p=p1_(u tensor u)+p2`. The
canonical `p1` has an even BMO extension. The harmonic remainder must obey

    |grad p2(x,t)| <= c log(2+1/x3),                            (1.10)
    sup_(x') |grad p2(x',x3,t)| -> 0 as x3 -> infinity,          (1.11)

the latter for each fixed `t<0`. Lemma 3.1, pp.22--24, also uses these
pressure hypotheses in its boundary gradient and local mixed-norm
second-derivative estimates. Constructing only `p1` does not verify the
conditions on `p2`.

Neither mildness nor these harmonic-pressure estimates follows merely
by substituting (3) into the displayed theorems. Moreover, even after
mildness on `t<T<0` is established, Theorem 1.3 with the available
global bound (4) is not a uniform annular estimate through `t=0`.

### Jia--Seregin--Sverak: a linear classification

Primary version:
[arXiv:1201.1664v2](https://arxiv.org/pdf/1201.1664v2),
*Liouville theorems in unbounded domains for the time-dependent Stokes
system*, Definition 1.1, p.1, and Theorem 4.1, p.8.
A bounded very weak ancient solution of the homogeneous Stokes system
with zero wall data has the form

    w(x,t)=(w1(x3,t),w2(x3,t),0).                              (6)

This permits pressure-driven shears and is not a vanishing theorem.
Lemma 2.2, p.3, gives interior derivative estimates, not wall estimates.
The boundary smoothness of mollified fields in Lemma 4.1, p.7, is not
a bound uniform in the mollification parameter.

For a field already known to satisfy the linear hypotheses of (6),
decay as `|x'|` tends to infinity would eliminate the shear. Applying
this observation directly to the nonlinear `u` would be invalid.

### Seregin: local second-derivative estimates retain pressure

Primary original edition: G. A. Seregin, *A note on local boundary
regularity for the Stokes system*, Zap. Nauchn. Sem. POMI 370 (2009),
151--159,
[original PDF](https://www.mathnet.ru/php/getFT.phtml?jrnid=znsl&paperid=3536&what=fullt&option_lang=eng).
Theorem 1.2, p.153, with (1.3)--(1.5) on p.152, assumes

    v in W^(1,0)_(m,n)(Q_+(2)),  q in L_(m,n)(Q_+(2)),
    f in L_(s,n)(Q_+(2)),       s>=m,                         (7)

for the no-slip weak Stokes equation
`partial_t v-Delta v=f-grad q`, `div v=0`. Its estimate
(1.7)--(1.8) controls `partial_t v`, `grad^2 v`, and `grad q` on
`Q_+(1)` by the indicated norms of `f`, `grad v`, `v`, and `q` on
`Q_+(2)`. Here `L_(m,n)=L_t^n L_x^m`.

This is not a pointwise Hessian estimate from bounded velocity alone.
Replacing `f` by `-u dot grad u` does not establish (7), in particular
its pressure norm, uniformly on the required terminal-time annuli.

### A genuine limitation, not a profile counterexample

Primary original edition: G. Seregin and V. Sverak, *On a bounded shear
flow in half-space*, Zap. Nauchn. Sem. POMI 385 (2010), 200--205,
[original PDF](https://www.mathnet.ru/php/getFT.phtml?jrnid=znsl&paperid=3905&what=fullt&option_lang=eng).
Section 2, pp.203--204, (2.1)--(2.8), constructs

    v=(w(x3,t),0,0),    q=-f(t)x1,
    w_t-w_zz=f(t),     w(0,t)=0,    w(z,-4)=0,
    f(t)=|t|^(alpha-1),             0<alpha<1/2.

The velocity is bounded but its gradient is unbounded near the terminal
boundary point. Its convection term is zero, so it is also a
Navier--Stokes solution. Thus a general velocity-only boundary
derivative estimate of the required kind is false.

The example is independent of `x'`, fails (V), and is not a backward
self-similar profile of (1). It does not refute (D12) in the target class.
It rules out only the shortcut that invokes bounded local velocity
without treating the global pressure or mildness issue.

## 4. A source-based reduction: spatial decay removes the shear ambiguity

**Proposition (`CWP_VELOCITY_MILD`).** Under (1) and (V), `u` has the
standard half-space mild representation for every initial time `A<0`.
Its restriction to `t<T<0` is a bounded mild ancient solution. It also
has an absolutely convergent infinite-past representation. Consequently
all spatial derivatives of `U` are globally bounded. This last assertion
is not their inverse-power decay.

The external inputs are `BS_KERNEL`, `JSS_STOKES_DECAY`, and
`BS13_GLOBAL`, recorded separately as assumptions on this claim. The
kernel formulas and their hypotheses were checked by
`stokes-kernel-source-reader`; the primary papers are the specified
Barker--Seregin and Jia--Seregin--Sverak versions, not an unspecified
half-space regularity theorem.

### 4.1. The full kernel, its sign, and its elementary integrated bound

Write `theta>0` for diffusion time and `y*=(y',-y3)`. Barker--Seregin,
pp.4--5, (1.7)--(1.8), use `G=G1+G2`, with

    G1_ij(x,y,theta)
        =delta_ij[Gamma(x-y,theta)-Gamma(x-y*,theta)].

Their tensor potential solves

    Delta_y Phi_mn=G_mn,
    partial_y3 Phi_mn=0 on the wall for n<3,
    Phi_m3=0 on the wall,

and their bilinear kernel is

    K_mjl=partial_yi partial_yi partial_yl Phi_mj
                -partial_yn partial_yj partial_yl Phi_mn,      (8)

with repeated indices summed. In (2.1), pp.7--8,

    K=Kbar+Khat.

`Kbar` consists of first source derivatives of `G`. The nonlocal
`Khat` consists of the stated derivatives of convolutions of `G` with
the Neumann/Dirichlet Newton potentials. It must not be dropped.

Here are the source estimates used, with `alpha'` and `gamma'` denoting
tangential multiindices:

    |D_x^alpha D_y^gamma G2(x,y,theta)|
      <= C theta^(-gamma3/2) (theta+x3^2)^(-alpha3/2)
         (|x-y*|^2+theta)^(-(3+|alpha'|+|gamma'|)/2)
         exp(-c y3^2/theta),                                  (9)

for `|gamma|=0` or `1`, and

    |Khat(x,y,theta)| <= C(|x-y|^2+theta)^(-2).                (10)

These are (2.2)--(2.3), p.8; the paper attributes these kernel estimates
to Solonnikov. Equation (10) is not an estimate for the whole `K`.

The Gaussian bound for `G1`, (9), and (10) imply

    sup_x integral_H |G(x,y,theta)| dy <= C_G,
    sup_x integral_H |K(x,y,theta)| dy <= C_K theta^(-1/2).
                                                                  (11)

For completeness, integration in `y'` of the source-normal term in (9)
gives a constant times

    theta^(-1/2) integral_0^infinity
       exp(-c z^2/theta)/sqrt((x3+z)^2+theta) dz
       <= C theta^(-1/2).

With no source derivative the same calculation has no prefactor
`theta^(-1/2)` and gives `C`. Tangential source derivatives and
`Khat` are bounded by integrating
`(|x-y|^2+theta)^(-2)` over all of `R^3`; scaling gives
`C theta^(-1/2)`. The Gaussian derivative gives the same bound.
Thus (11) controls every part of `K`, including the nonlocal one.

Lemma 2.1, p.9, identifies the sign as

    integral_H K_ijm(x,y,theta) F_jm(y) dy
      = integral_H G_ij(x,y,theta)
                    [-div F-grad p1_F]_j(y) dy.               (12)

Its literal hypotheses are `F in W_infinity^1(H)`, local `C1` up to
the wall, bounded continuous `div div F`, and both `F=0` and
`partial_j F_3j=0` at the wall. We use (12) first for smooth tensors
compactly supported away from the wall, where every hypothesis holds.
We do not infer global derivative bounds on `F=u tensor u` from its
amplitude bound.

For viscosity `nu`, the kernels in the time integral have
`theta=nu(t-s)`. Because (12) already represents the negative projected
divergence, its contribution to the velocity formula has a **plus**
sign. No extra minus sign or factor of `nu` multiplies `K F`.

### 4.2. Finite-time construction with the full boundary test class

Fix `A<T<0`. Let `F=u tensor u` and `M=C/sqrt(2a)`. Equations (3)--(4)
give

    ||u(s)||_infinity <= M/sqrt(-s),
    ||F(s)||_infinity <= M^2/(-s).                             (13)

Define, for `A<t<T`,

    v^A_i(x,t)
      = integral_H G_ij(x,y,nu(t-A)) u_j(y,A) dy
        + integral_A^t integral_H
            K_ijm(x,y,nu(t-s)) F_jm(y,s) dy ds.                (14)

The initial datum is bounded, solenoidal, no-slip, and tends to zero
at spatial infinity; it also lies in `Lq(H)` for every `q>3`.
These satisfy the initial-data conditions for the Stokes Green
representation, rather than imposing a pressure condition.

Formula (11) proves absolute convergence and boundedness of (14).
The finite-time Stokes construction and its boundary weak identities
are given in Barker--Seregin, pp.24--26. The extension to the present
bounded tensor can be made without assuming its derivatives are
globally bounded: multiply `F` by smooth cutoffs in time and space,
including a cutoff vanishing near the wall. Choose their values
between zero and one and let their supports exhaust
`H times (A,T)`. The resulting smooth compact tensors `F_n` meet
Lemma 2.1, converge locally to `F` in the open cylinder, and obey
`|F_n(y,s)|<=M^2/(-s)`.

The kernel solutions for `F_n` converge pointwise to the tensor part
of (14), by (11) and dominated convergence. They are uniformly bounded
on `H times (A,T)`. Consequently their weak identities pass to the
limit even for tests whose support meets the wall: the tests have
compact support, and the fields and tensors have a common bound there.
The limiting identities are

    integral v^A dot grad psi = 0,                            (15)

for every scalar test smooth up to the wall, and

    integral [v^A dot (partial_t phi+nu Delta phi)
                        +F:grad phi]
        + integral_H u(y,A) dot phi(y,A) dy = 0,               (16)

for every smooth compactly supported solenoidal vector test on
`closure H times [A,T)` with `phi=0` on the wall. The spacetime
integrals in (15)--(16) are over `H times (A,T)`; (15) may also use
time-dependent scalar tests. These are precisely the boundary test
classes needed below. Interior-only equations would not suffice.

The original smooth `u` satisfies (15)--(16) with `v^A` replaced
by `u`. This follows by integration by parts on the compact support:
the pressure term vanishes because `div phi=0` and `phi=0` at
the wall, both viscous boundary terms vanish by the two zero traces,
and `u dot n=0` gives (15). No pressure bound at infinity enters.

Set `w=u-v^A` for `A<t<T`, and set `w=0` for `t<=A`.
Subtracting (16) cancels both the tensor and the initial term.
There is therefore no distribution supported at `t=A`. Equations
(15)--(16) give exactly a bounded very weak ancient homogeneous
Stokes field on `H times (-infinity,T)` in JSS Definition 1.1.
Boundedness on this entire cylinder follows from (11), (13), and
the finiteness of `T-A`. Smoothness or a classical pressure trace
of `v^A` is not being assumed for this step.

After a translation of time and normalization of viscosity, JSS
Theorem 4.1 gives

    w(x,t)=(b1(x3,t),b2(x3,t),0)  almost everywhere.            (17)

This theorem has been applied to a **linear difference**, not to the
nonlinear velocity `u`.

### 4.3. Tangential decay eliminates the shear

For each fixed `h>0` and `t<T`,

    u(x',h,t) -> 0 as |x'| -> infinity

by (3). Both kernels are invariant under simultaneous tangential
translation of `x` and `y`. In the first integral of (14), change
variables `y'=x'+z'`; the initial datum then tends pointwise to zero
as `|x'|` tends to infinity. The integrable dominator is

    |G((0,h),(z',z3),nu(t-A))| ||u(A)||_infinity.

The tensor integral has the same pointwise convergence, dominated by

    |K((0,h),(z',z3),nu(t-s))| M^2/(-s).

It is integrable in `z',z3,s` by (11). Dominated convergence therefore
proves `v^A(x',h,t)->0`. This is a fixed-time statement, not a rate
uniform as `t` tends to zero.

Thus `w` tends to zero tangentially. The shear in (17) must vanish:
for almost every `(h,t)`, choose an unbounded sequence of tangential
points from the full-measure set on which (17) holds and take its
limit. Hence `u=v^A` almost everywhere. This is the mild identity
(14); its smooth velocity representative is the original `u`.
Since `A<T<0` were arbitrary, mildness is established, not imposed.

The initial term of (14) has norm at most
`C_G M/sqrt(-A)`, so it vanishes as `A` tends to minus infinity.
For the other term, put `b=-t>0` and `q=sqrt((t-s)/b)` to obtain

    integral_(-infinity)^t (t-s)^(-1/2)(-s)^(-1) ds
       = (2/sqrt(b)) integral_0^infinity (1+q^2)^(-1) dq
       = pi/sqrt(-t).                                       (18)

Therefore

    u_i(x,t)=integral_(-infinity)^t integral_H
               K_ijm(x,y,nu(t-s)) u_j(y,s)u_m(y,s) dy ds,     (19)

with an absolute-norm bound
`C_K pi M^2/(sqrt(nu) sqrt(-t))`. This proves the claimed
infinite-past representation; the integral's sign is the one in (12).

### 4.4. What the bounded-mild theorem now legitimately supplies

For each fixed `T<0`, (13) bounds `u` globally on `t<T`.
It is now legitimate to apply Barker--Seregin Theorem 1.3 on that
time-translated ancient interval. Viscosity can be normalized by
`tilde u(z,t)=nu^(-1/2)u(sqrt(nu)z,t)`.
Choose `t0=-1/(2a)` and any `T` with `t0<T<0`. Since
`lambda(t0)=1`, `u(.,t0)=U`. The theorem yields

    sup_H |grad^j U| < infinity for each fixed j.              (20)

It does not yield (D12). On intervals approaching zero, the available
global velocity bound is `M/sqrt(-T)`, which diverges. No localization
with a constant independent of `T` has been established.

In particular (19) eliminates the arbitrary linear shear ambiguity
without silently postulating mildness. It does **not** yet justify
applying the unweighted L2 Helmholtz projection to `Delta U`, or
asserting the canonical identity H2 in that L2 formulation: the
needed global integrability remains to be proved.

## 5. Retained limits of the pointwise-derivative route

An alternative attempt after (19) is to differentiate its kernel and
use absolute values. The checked source does not close this argument.
For example (9) gives

    |partial_x3^2 partial_y3 G2|
      <= C theta^(-1/2) (theta+x3^2)^(-1)
           (|x-y*|^2+theta)^(-3/2) exp(-c y3^2/theta).         (21)

Its integrated majorant, uniform down to the wall, is of order
`theta^(-3/2)`. Integrating that majorant against merely bounded
`F(s)` near `s=t` produces

    integral_0^delta theta^(-3/2) dtheta = infinity.

This is failure of that absolute estimate, **not** divergence of the
actual Hessian. Cancellation, extra forcing regularity, or a separate
boundary argument would be needed. Furthermore (10) controls
`Khat` itself, not `partial_x3^2 Khat`. A derivative estimate cannot
be obtained by differentiating an upper bound.

The wall issue is not removed by `|x|` being bounded away from zero:
the half-annulus still contains points with arbitrarily small `x3`.
Barker--Seregin's intermediate estimate (2.14), pp.12--13, contains
at derivative order two the factor

    integral_0^sqrt(-A) (x3^2+q^2)^(-1) dq
       = arctan(sqrt(-A)/x3)/x3,

which is not uniformly bounded at the wall. Their eventual global
bounded-mild regularity theorem uses additional forcing/pressure
estimates and a bootstrap. The required version of that bootstrap
localized away from the similarity centre, with constants uniform
through `t=0`, has not been proved here.

The two abandoned shortcuts are therefore distinct:
`RWP_VELOCITY_LOCAL_BOUNDED_SHORTCUT` omits pressure/mildness control
altogether; `RWP_VELOCITY_ABSOLUTE_KERNEL` begins with the
legitimately recovered mildness but lacks integrable, complete
boundary derivative estimates. Neither failure refutes the target.

The unresolved pointwise-derivative obligation from the preceding round was

    sup_(x in A_+, -epsilon<t<0)
         (|grad_x u(x,t)|+|grad_x^2 u(x,t)|) < infinity,        (22)

for a fixed half-annulus `A_+` surrounding `|x|=1`, including its
wall limit. Equation (5) explains why (22) would suffice. We do not claim
it below. Instead, finite space-time Hessian energy on this annulus
transforms exactly into the required weighted profile norm.

In particular, the new proof does not differentiate the Duhamel kernel
absolutely. The nonlocal harmonic pressure is controlled in time-integrated
norms, and only then is a local boundary Stokes estimate applied.

## 6. Primary inputs for the integrated route

The following four propositions are recorded as external assumptions on
`CWP_VELOCITY_ANNULAR_ENERGY`. Their primary statements and hypotheses were
read by the source researchers `energy-pressure-source` and
`hilbert-stokes-source`. Formal independent attribution of these new
assumptions is a Reviewer obligation, not an Engineer self-certification.

**ABP_LOCAL_ENERGY.** Albritton--Barker--Prange,
[arXiv:2112.10705v1](https://arxiv.org/pdf/2112.10705v1),
*Localized smoothing and concentration for the Navier--Stokes equations in
the half space*, Theorem 1.1 with (1.2)--(1.3), and Lemma 2.1, p.8,
(2.3)--(2.4). For its local-energy solution class, initial
`L2_uloc` norm at most `M>=1`, and spatially vanishing local L2 tails,
there is `S1 >= c min(1,M^(-96))` such that

    sup_x0 [ sup_(0<t<min(S1,T)) integral_Omega2(x0) |u|^2
        + integral_0^min(S1,T) integral_Omega2(x0) |grad u|^2 ]
      <= C M^2.                                               (23)

The formal hypotheses also include a finite local initial `Lm` norm,
`m>=3`, small only when `m=3`. We use `m=4` on a smooth initial
slice. The lifespan and bound in (23) do not depend on that local norm.
The spatial supremum is **outside** the dissipation time integral.
The lemma's separate weak-`L^(4/3)` pressure estimate is not promoted
to an L2 estimate.

**MMP_PRESSURE_SPLIT.** Maekawa--Miura--Prange,
[arXiv:1711.04486v3](https://arxiv.org/pdf/1711.04486v3),
*Local energy weak solutions for the Navier--Stokes equations in the
half-space*, Definition 1.1, Lemma A.4, Proposition 3.1, and
(2.2), (2.12)--(2.25). Proposition 3.1 identifies the actual pressure,
up to a function of time, with the seven-term decomposition (2.18):

    p = p_loc^initial + p_nonloc^initial
        + p_loc,H + p_loc,harm
        + p_nonloc,H + p_harm,<=1 + p_harm,>=1.                (24)

For elapsed time `tau` since the initial slice, the two initial
terms are locally bounded by `C tau^(-3/4)` times the appropriate
initial local/uniformly-local L2 norms, (2.20)--(2.21).
They therefore have L2 time norms away from that slice.

Put `K=sup_t ||u(t)||_(L2_uloc)` and

    E=sup_eta integral_0^L integral_cube(eta) |grad u|^2.

On a fixed observation cube, (2.23)--(2.24) bound `p_nonloc,H`
and `p_harm,<=1` in `L_infinity(time;L_infinity(space))` by `C_L K^2`.
Equation (2.25) gives

    ||p_harm,>=1||_(L2(time;L_infinity(space)))
      <= C_L (E+L K^2).                                      (25)

The gradient estimates are not needed for this step. The constants can
be taken at a fixed upper time horizon for all shorter truncations.
No global kinetic-energy norm occurs in these bounds.

Crucially, `p_loc,H+p_loc,harm` is exactly the pressure of the
zero-initial **whole-half-space auxiliary Stokes problem**

    v_t-Delta v+grad pi=-div(chi4^2 u tensor u),
    div v=0,    v|wall=0,    v|initial=0,                      (26)

not the pressure of `chi4 u`. The cutoff is one on `4Q` and
supported in `5Q`, as specified in section 1.3. We choose the entire
`5Q` away from the similarity centre. Section 2.2, (2.28), identifies
its forcing as the projected sum of a cutoff term and
`chi4^2 u dot grad u`. MMP's own estimate of this local pressure uses
lower exponents; section 7 below proves the L2 estimate we need.

**LLP_HILBERT_COMMUTATOR.** Liu--Liu--Pego,
[doi:10.1002/cpa.20178](https://doi.org/10.1002/cpa.20178),
Theorem A.1, p.1478, and (1.17), p.1447. For every vector field
`z in H2(H) intersect H1_0(H)`, without requiring `div z=0`,

    C z=[Delta,Pi_H]z=(I-Pi_H)Delta z-grad div z,
    ||C z||_2 <= 2^(-1/2) ||Delta z||_2.                     (27)

The same proposition was also read in the
[author's accepted preprint](https://www.math.cmu.edu/~bobpego/preprints/LLP-preprint.pdf),
revised February 2006, Appendix A, Theorem 7, p.36, and (16)--(17),
p.5. The different theorem numbering is not being silently interchanged.
The published proposition already has independent attribution elsewhere
in the campaign. Its **all-vector-field** version is important below.

**SEREGIN_LOCAL_L2.** Seregin,
[Math-Net znsl3536, original POMI 370 (2009), pp.151--159](https://www.mathnet.ru/eng/znsl3536),
Theorem 1.2, p.153, and (1.1)--(1.8), pp.151--152.
The choice `m=n=s=2` is allowed because `s>=m`, not `s>m`.
For a no-slip weak Stokes solution, local L2 bounds for
`v,grad v,q,f` on the larger half-cylinder give

    ||v_t||_2 + ||grad^2 v||_2 + ||grad q||_2
      <= C (||f||_2+||grad v||_2+||v||_2+||q||_2)             (28)

on the smaller half-cylinder. The additional second-derivative
assumption (1.6) of Theorem 1.1 is **not** an assumption of
Theorem 1.2. The canonical identifier above names the original edition;
the later translation has DOI `10.1007/s10958-010-9847-7`.
We apply (28) only after proving the pressure norm on its right.

## 7. The L2 auxiliary Stokes estimate, including its realization

Here is a Hilbert-space proof of the particular maximal estimate needed
for (26); it does not extrapolate MMP's lower-exponent estimate.
Write `P=Pi_H`, `Q=I-P`, `X=P L2(H;R^3)`,
and `D=H2(H;R^3) intersect H1_0(H;R^3)`.

The componentwise Dirichlet Laplacian `B=-Delta_D` has domain `D`.
Odd reflection and the full-space Fourier transform give its
nonnegative self-adjoint realization and

    ||B(lambda+B)^(-1)|| <= 1,           lambda>0.

By (27), `||C(lambda+B)^(-1)||<=1/sqrt(2)<1`. Therefore

    lambda+B+C
      = [I+C(lambda+B)^(-1)](lambda+B)

is invertible from `D` to `L2`, by a norm-convergent Neumann series.
For `g in X`, let `z=(lambda+B+C)^(-1)g` and `d=div z`.
Since `z in D`, `d in H1`. The equation is

    lambda z-P Delta z-grad d=g.

Pair it with `grad d`. Gradients are orthogonal to `X`, and the
zero trace of `z` gives `(z,grad d)=-||d||_2^2`; hence

    lambda ||d||_2^2+||grad d||_2^2=0.

Thus `d=0`, and the displayed equation also gives `z in X`.
Consequently

    A=-P Delta,        D(A)=D intersect X

has `lambda+A` onto `X`. It is symmetric and nonnegative, because
`(Az,w)=(grad z,grad w)` on this domain. The domain is dense:
if `g` is orthogonal to it, solve `(lambda+A)z=g` and pair with
`z`; then `z=0` and `g=0`. The symmetric positive resolvent is
defined on all of `X`; equivalently, the usual surjective-resolvent
criterion makes `A` self-adjoint. This proves the claimed domain
rather than assuming an unchecked Stokes elliptic estimate.

For `f in L2((0,L);L2(H))`, take the canonical zero-initial solution

    v(t)=integral_0^t exp(-nu(t-s)A) P f(s) ds.

Let `E_n=1_[0,n](A)`. The equation for spectral-cutoff data
`E_n P f` has bounded operator `A` and can be tested legitimately.
Expanding the square of `v_t+nu A v=E_n P f` and integrating yields

    integral_0^L (||v_t||_2^2+nu^2||A v||_2^2) dt
          +nu||A^(1/2)v(L)||_2^2
       = integral_0^L ||E_n P f||_2^2 dt.                     (29)

Applying this also to differences and using the spectral theorem
gives the limit in
`H1((0,L);X) intersect L2((0,L);D(A))`.
Orthogonality and (27), now for solenoidal `z`, give

    ||Delta z||_2^2=||Az||_2^2+||Q Delta z||_2^2,
    ||Delta z||_2<=sqrt(2)||Az||_2,
    ||Q Delta z||_2<=||Az||_2.

Recover the pressure by `grad pi=Q f+nu Q Delta v`.
Equations (29) and the orthogonal splitting of `f` prove

    ||v_t||_(L2_t,x) <= ||f||_(L2_t,x),
    ||Delta v||_(L2_t,x) <= (sqrt(2)/nu)||f||_(L2_t,x),
    ||grad pi||_(L2_t,x) <= sqrt(2)||f||_(L2_t,x).             (30)

The constants are independent of the finite horizon `L`.
Poincare's inequality on any fixed connected bounded local patch
then controls `pi-(pi)_patch` in `L2_t L2_x`.

This is the same canonical solution as (26): on smooth compact
forcing the Stokes Green representation and the self-adjoint
semigroup solve the same zero-data L2 problem, whose difference has
zero energy. Approximation by such forcing and (29)--(30) give the
identification for L2 forcing. Only its pressure gradient is fixed;
the local time-dependent additive normalization is harmless.

## 8. Uniform annular space-time energy, not a pointwise Hessian bound

We prove `CWP_VELOCITY_ANNULAR_ENERGY`. In this section the cited
unit-viscosity estimates can be used after
`u_tilde(z,t)=nu^(-1/2)u(sqrt(nu)z,t)`; transforming back changes
finite constants and fixed patch sizes only. No smallness of `nu`,
`a`, or the velocity amplitude is required.

### 8.1. Local-energy membership before the uniform estimate

Bound (3) implies

    K=sup_(t<0) ||u(t)||_(L2_uloc(H)) < infinity.              (31)

For example, `|u|^2<=C^2/|x|^2`; the integral on balls near zero
is finite in dimension three, and on far unit balls it is uniformly
bounded by the inverse square of their distance. The same bound
shows vanishing local L2 mass at spatial infinity, uniformly in time.

For every finite interval `[A,T]`, `A<T<0`, the accepted mildness
and Barker--Seregin regularity give global bounds on the velocity,
its derivatives, and the pressure gradient. Thus this interval is
in MMP Definition 1.1: uniformly local dissipation is finite,
the required uniformly local mixed pressure-gradient norm is finite,
and smoothness gives the weak equations and local energy equality.
The scalar pressure itself is locally integrable after a time gauge.
Time-derivative bounds give strong initial continuity in `L2_uloc`.
The decaying spatial class follows from (31), zero normal trace and
MMP Lemma A.4. These facts are only finiteness on a fixed truncated
interval; no uniform endpoint derivative bound is used.

Choose `M>=max(1,K)` with any fixed ball/cube equivalence constants
included, and fix `delta>0` smaller than the lifespan in (23).
Restart at `A=-delta`. Each initial slice is smooth and bounded,
so the additional local `L4` hypothesis of ABP holds with some finite
norm; it need not be small. Apply (23) on every `[A,T]`, `T<0`.
Its constants depend on `M`, not on the diverging global
`L_infinity` norm near zero. Letting `T` increase to zero gives

    E=sup_eta integral_A^0 integral_cube(eta) |grad u|^2
       < infinity.                                          (32)

The supremum remains outside the time integral. This is exactly
the order used in (25).

### 8.2. L2 pressure on patches away from the centre

Cover the closed half-annulus `1<=|x|<=2`, including its wall
portion, by finitely many smaller observation patches. For each,
choose an outer cube/half-cube `Q` whose entire enlargement `5Q`
lies in `1/2<|x|<3`. Use the rescaled MMP construction there.
All scales are fixed positive numbers; (31)--(32) control the
rescaled uniformly-local quantities by covering with finitely many
unit cubes. On every `5Q`,

    |u(x,t)| <= 2C,                 A<t<0.                   (33)

The auxiliary local forcing from (26) is

    f_Q=-chi4^2 (u dot grad)u -(u dot grad chi4^2)u.

By (32)--(33) and the bounded cutoff derivatives,

    integral_A^0 integral_H |f_Q|^2
       <= C_Q [E+delta K^2] < infinity.                      (34)

This is a full-space-in-time L2 forcing for the auxiliary half-space
Stokes problem, not an assumption about the original pressure.
Apply (30) to obtain the L2 time-space norm of
`p_loc,H+p_loc,harm`, modulo its spatial mean on `Q`.

For the other five terms in (24), (25), (31)--(32) give the
nonlinear nonlocal L2 time-space bounds. The two initial terms
are in `L2_t L2_x(Q)` on `A+delta/4<t<T` uniformly in `T<0`,
because their `tau^(-3/4)` factor is bounded away from `tau=0`.
Combining the seven terms, subtracting the mean on `Q`, and using
Proposition 3.1's identification with the actual pressure gives

    sup_(T<0, T>A+delta/4)
      ||p-(p)_Q||_(L2((A+delta/4,T);L2(Q))) < infinity.        (35)

No unproved uniform gradient bound on the nonlocal harmonic
pressure was used. The far harmonic part is allowed to be only
L2 in time.

The normalization can be chosen separately on each patch.
Subtracting a function of time changes neither `grad p` nor the
Stokes equation. The conclusion below concerns velocity derivatives,
so no gluing of these local pressure representatives is necessary.

### 8.3. Applying the boundary estimate after its hypotheses hold

On an outer patch the original equation is Stokes with
`f=-(u dot grad)u`. This forcing is in `L2_t,x` by (32)--(33);
`u`, `grad u`, and the locally normalized pressure have the other
L2 bounds required in (28).

Take fixed sufficiently small half-cylinders whose spatial parts
lie in these patches and whose lower time faces are after
`A+delta/4`. Translate their top time to `T<0`. Seregin Theorem 1.2
with `m=n=s=2` gives a bound for `grad^2 u` on each smaller
half-cylinder independent of `T` as `T` increases to zero.
One may take the radii so that their full time lengths are less
than `delta/4`.

For patches separated from the wall the corresponding interior
L2 estimate follows directly: `Delta p=div f` and an interior
elliptic energy test give the local L2 norm of `grad p` from
those of `p,f`; applying the L2 heat estimate to a space-time
cutoff of `u` then gives its local Hessian norm. All cutoff
terms use only the already bounded norms of `u,grad u`.

Take a sequence `T` increasing to zero and use Fatou's lemma
on the smaller cylinders, then a finite covering. There is
`epsilon>0` for which

    integral_(-epsilon)^0 integral_(1<|x|<2, x3>0)
             (|grad u|^2+|grad^2 u|^2) dx dt < infinity.      (36)

This includes the wall without shrinking an excluded strip.
The same integral with `|u cross curl u|^2` is finite by
bounded velocity on this annulus and (32).

### 8.4. Exact conversion to weighted profile norms

Put `lambda0=sqrt(2a epsilon)`. For `j=1,2`, the change of
variables in section 2 and Tonelli's theorem give

    integral_(-epsilon)^0 integral_(1<|x|<2) |grad^j u|^2
      = (1/a) integral_H |grad^j U(y)|^2
          [integral_0^lambda0
             lambda^(2-2j) 1_(1<lambda r<2) d lambda] dy.     (37)

When `r>=2/lambda0`, the bracket is exactly

    j=1:  integral_(1/r)^(2/r) 1 d lambda = 1/r,
    j=2:  integral_(1/r)^(2/r) lambda^(-2) d lambda = r/2.     (38)

Thus (36), local smoothness and `U(0)=0` imply

    grad U in L2(H,r^(-1)dy),
    grad^2 U in L2(H,r dy),    Delta U in L2(H,r dy).           (39)

The corresponding change for `u cross curl u`, which scales
as `lambda^(-3)`, has the second bracket in (38). Hence its
weighted profile norm is finite as well. Alternatively, it follows
from (V) and the first assertion of (39), since

    r |U|^2 |grad U|^2 <= C^2 r/(1+r)^2 |grad U|^2
                       <= C^2 r^(-1)|grad U|^2.              (40)

The same estimate applies to `F=(U dot grad)U` and
`grad(|U|^2/2)`. In particular both norms in the theorem are now
proved finite, **before** the alignment inequality is used.

## 9. Extending the accepted pressure estimate to this energy class

We next prove the first part of `CWP_ALIGNMENT_ENERGY_EXTENSION`.
The accepted radial pressure theorem `CWP_999` is used on compact
smooth solenoidal zero-trace fields only; its earlier H1 extension
is not assumed to cover the present fields.

For this section write `||h||_s^2=integral_H r^s |h|^2`.
In addition to (39), (V) and `U=O(r)` near the origin give
`||U||_(-3)<infinity`. Define the same radial vector potential
as in the accepted compact approximation:

    F0(y)=integral_0^1 t U(ty) dt,       A_U(y)=-y cross F0(y).

Solenoidality gives `curl A_U=U`, and both `A_U` and `U` vanish
on the wall. The identity
`||h(t .)||_s=t^(-(3+s)/2)||h||_s` and Minkowski's inequality
give

    ||A_U||_(-5) <= (1/2)||U||_(-3),
    ||grad A_U||_(-3)
       <= C (||U||_(-3)+||grad U||_(-1)),
    ||Delta A_U||_(-1)
       <= C (||grad U||_(-1)+||Delta U||_1).                  (41)

Indeed
`grad F0=integral_0^1 t^2 grad U(t y)dt` and
`Delta F0=integral_0^1 t^3 Delta U(t y)dt`.
In each needed weighted norm the dilation changes the time factor
to `t`, whose integral is `1/2`; differentiating `y cross F0`
then proves (41). These are integrated estimates, not pointwise
derivative decay of the potential.

Let `chi_R` be a radial cutoff equal to one for `r<=R` and zero
for `r>=2R`, with its usual derivative bounds. Set

    U_R=curl(chi_R A_U)=chi_R U+grad chi_R cross A_U.

These are compact smooth solenoidal no-slip fields. In
`Delta U_R-Delta U`, the non-tail terms are bounded respectively by

    R^(-1)|grad U|,  R^(-2)|U|,  R^(-1)|Delta A_U|,
    R^(-2)|grad A_U|,           R^(-3)|A_U|                   (42)

on `R<r<2R`. Their squared `r`-weighted norms are bounded by
constant multiples of the tails of the finite norms
`||grad U||_(-1)^2`, `||U||_(-3)^2`,
`||Delta A_U||_(-1)^2`, `||grad A_U||_(-3)^2`,
and `||A_U||_(-5)^2`. The other term is
`(chi_R-1)Delta U`. Therefore

    ||Delta U_R-Delta U||_1 -> 0.                            (43)

All errors are outside `r>=R`, so (43) also implies convergence
in unweighted L2. The canonical gradients
`(I-Pi_H)Delta U_R` converge in unweighted L2. Applying the
accepted compact pressure estimate to differences makes them
Cauchy in the weighted norm as well. The limits agree locally,
so

    norm_r((I-Pi_H)Delta U)
          <= sqrt(999/1000) norm_r(Delta U).                 (44)

Here `Delta U in L2(H)` follows from (39) outside the unit ball
and smoothness inside it. Thus the unweighted projection in (44)
has its proper domain.

## 10. Canonical pressure and the critical drift without pointwise decay

Let `F=(U dot grad)U`, `G=nu Delta U-F`, and
`W=U+y dot grad U`. By (39)--(40),
`G in L2(H) intersect L2(H,r dy)`.
The local weak-Neumann construction in section 2 of
[`automatic-profile-pressure.md`](automatic-profile-pressure.md)
requires only this L2 fact and the local smooth profile equation:
`div W=0`, `W|wall=0`, and the definition of the unweighted
projection give a potential `q in W^(1,2)_loc(closure H)` with

    grad q=Pi_H G-aW,
    integral_H grad q dot grad phi=0
          for every phi in C_c^infinity(closure H).           (45)

The test functions need not vanish at the wall. More explicitly,
take `grad p=(I-Pi_H)G` and `q=P-p`; the original equation
gives `grad P=G-aW`, and integration of `W` against compact
gradients gives (45). No global integrability of `W` is assumed.

The earlier L2+L4 harmonic-vanishing proof is replaced as follows.
Reflect `q` evenly to obtain a distributionally harmonic potential
on all of `R^3`; (45) guarantees there is no wall measure.
Its gradient `K` has even tangential and odd normal components.
Reflect `U` with this same vector parity and call the result `V`.
Its zero wall trace makes it continuous, with

    |V(x)| <= C/(1+|x|).

The reflected `W` is `V+x dot grad V` distributionally, including
across the wall. With `B_ij=x_j V_i`,

    V+x dot grad V=div B-2V,             ||B||_infinity<infinity.

Thus, if `f2` is the same-parity reflection of `Pi_H G`,

    K=f2-a div B+2aV,                    f2 in L2(R^3).        (46)

Mollify with a fixed compact smooth unit-mass kernel. The resulting
`K_eta` is a smooth harmonic vector field. Its mean on a ball
`B_R(x0)` equals its value at `x0`. The three terms in (46) have
mean bounds

    |B_R|^(-1/2)||f2||_2,
    (3a/R)||B||_infinity,
    (2a/|B_R|) integral_(B_R(x0)) |V_eta|.

For fixed `x0,eta` and large `R`, the last integral is at most
`C_eta,x0 R^2`, using the inverse-distance bound. All three means
tend to zero. Hence `K_eta=0` for each `eta`, and passage to the
distributional limit gives `grad q=0`. This proves, without assuming
derivative decay or a pressure normalization,

    grad P=(I-Pi_H)G,              aW=Pi_H G.                 (47)

The accepted weighted projection bound now gives
`W in L2(H,r dy)`. It has not been applied to a field outside L2.

For completeness the critical drift sign has exactly the same
finite-shell proof in this energy class. Put `s=log r` and
`Z(s,omega)=r U(r omega)`. The algebraic identity from the accepted
theorem is

    integral_(s0<s<S) r W dot Delta U
      = [(||Z_s||^2-||grad_S Z||^2)/2]_(s0)^S
          - integral_s0^S ||Z_s||^2 ds.                      (48)

The wall term vanishes because `Z=Z_s=0` there. At the origin,
smoothness and zero trace give `Z,Z_s,grad_S Z=O(r^2)`.
At infinity,

    integral_0^infinity exp(2s)||Z_s||^2 ds
       = integral_(r>1) r |W|^2 dy < infinity.

Choose `S_j` increasing to infinity with `||Z_s(S_j)||^2`
tending to zero. The outer angular term in (48) is nonpositive
and is not discarded as zero. The left side converges absolutely
by the finite weighted norms of `W` and `Delta U`. Consequently

    I=integral_H r W dot Delta U <= 0.                       (49)

No uniform bound or limit of the angular derivative at infinity
was needed.

## 11. Complete quantitative exclusion

All quantities used here have already been proved finite. By (47)
the profile equation is

    -nu Delta U+nu grad p_S+Pi_H F+aW=0,
    grad p_S=(I-Pi_H)Delta U.

The identity
`F=grad(|U|^2/2)-U cross curl U` is valid in unweighted L2.
Indeed (40) controls each gradient term, and
`|U|^2/2 in H1(H)`, so its gradient is annihilated by `Pi_H`.
The accepted weighted Helmholtz bound therefore gives

    norm_r(Pi_H F)<=sqrt(3/2)L.

Pair the equation with `r Delta U`, using (44) and (49):

    nu(1-sqrt(999/1000))D^2 <= sqrt(3/2)L D.                 (50)

If `D=0`, the maximum-principle argument in section 1 gives
`U=0`, and the equation gives `grad P=0`. If `D>0`, division
in (50) proves the first inequality in (2).
The unchanged exact comparisons

    1-sqrt(999/1000)>1/2000,        sqrt(2/3)>4/5

give the strict lower bound `L/D>nu/2500`. Thus the inequality
`L<=(nu/2500)D` is impossible for a nonzero profile. This completes
`CWP_ALIGN_VELOCITY` without adding H1, H2, mildness, strong L3,
or finite kinetic energy as hypotheses.

The mathematical improvement over the strongest previously accepted
exclusion is removal of the two independently imposed derivative-decay
bounds. It is obtained by proving their energy-class substitutes, not
by claiming the unproved pointwise statement (22). The pressure gap
`999/1000`, projection constant `sqrt(3/2)`, threshold `nu/2500`,
and zero-denominator conclusion are unchanged.

## 12. Exact algebra replay and certification scope

The following standard-library certificate checks the new similarity
moments (37)--(38), the dilation exponents used in (41), and the cutoff
weight balances in (42). The primitive is checked symbolically for
every positive `r` through its Laurent exponent and rational coefficient;
this is not sampling finitely many radii.

```python
from fractions import Fraction as Q

for j, expected in ((1, (Q(1), -1)), (2, (Q(1, 2), 1))):
    exponent = 3 + 1 - 2 * (1 + j)
    primitive_exponent = exponent + 1
    assert primitive_exponent != 0
    coefficient = (Q(2) ** primitive_exponent - 1) / primitive_exponent
    radial_exponent = -primitive_exponent
    assert (coefficient, radial_exponent) == expected
    assert Q(1, primitive_exponent) * primitive_exponent == 1

for time_power, weight in ((1, -3), (2, -1), (3, 1)):
    exponent = Q(time_power) - Q(3 + weight, 2)
    assert exponent == 1
    assert 1 / (exponent + 1) == Q(1, 2)

for cutoff_order, required_weight in ((1, -1), (2, -3), (3, -5)):
    assert 1 - 2 * cutoff_order == required_weight

assert 3 - 1 == 2  # div(x V) - 2V = V + x.grad V in dimension three
print("Exact annular moments, potential dilations, and cutoff weights: PASS")
```

Replay directly from this proof file, without creating an extra source file:

    awk '/^```python/{on=1;next} on&&/^```$/{exit} on{print}' \
      research/velocity-only-profile-exclusion.md | \
      /home/argustest/zimo/argus-live-update/.venv/bin/python

The certificate does not verify the PDE arguments or source applicability.
Those are analytic proof and independent-review obligations. The unchanged
accepted pressure and constant certificates were not rerun. No Lean file,
formal-kernel verdict, optimality, unrestricted Liouville theorem, new
novelty certification, or final campaign certification is claimed here.
