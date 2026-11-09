# Arbitrary-chart averaged holonomy with an Lp connection

## Result and scope

Theorem 1 below proves the quantitative geometric implication underlying
`prop:averaged-holonomy`, for every fixed finite p >= 1. Theorem 2 solves
its exponent inequalities for every interpolation order, not just tested
orders. Theorem 3 supplies the weak-exit input using only locally L1
connection mass. Theorem 4 is a conditional category-transfer theorem
for every fixed finite p > 4/3, with the packet signal still r^(1/4).

No counterexample to the selected manuscript assertions was established.
The stopped frame equation, position-measure change, almost-everywhere
representative argument and interpolation have the stated signs and
scales. This is NOT a verification of the companion exterior, interior,
constraint-packet, nonlinear comparison, or full-development attachment
theorems. Those are explicit unverified hypotheses of Theorem 4.
The previous strongest result relevant here is the staged p=2 geometric
proposition; the improvement proved here is its finite-Lp geometric
version and the exact finite-jet threshold. Publication-level novelty
and significance require independent assessment; the bounded primary
comparison in literature.md does not establish priority.

Throughout, norms are fixed Euclidean component/operator norms in the
named coordinates. Changing between such norms changes constants only.
A function Q(r) is subpower if, for every epsilon>0,
Q(r) <= C_epsilon r^(-epsilon) for small r. Finite products and sums
of a fixed number of subpower bounds are subpower. Q may be enlarged
in different estimates. The parameter r is constant on each experiment.

The Sobolev/connection convention introduces no extra regularity
assumption: on a precompact chart a continuous nondegenerate metric
and its inverse are bounded. Its distributional lowered Koszul
coefficients are
Gamma_flat(i,j,k)=(partial_j g_ik+partial_k g_ij-partial_i g_jk)/2.
For p>=1, W1,p metric components give Lp lowered coefficients;
bounded inverse raises the index. Conversely
partial_k g_ij=Gamma_flat(i,k,j)+Gamma_flat(j,k,i) recovers W1,p
from Lp lowered coefficients. These identities are distributional.
On the smooth open image the weak arrays agree almost everywhere
with the smooth arrays. Smooth changes of charts preserve the
local class on precompact subcharts by their bounded derivatives
and smooth inhomogeneous connection term. No individual weak
curve restriction follows from any of these facts.

## Source anchors

All paths below are relative to research/openai_manuscript.

* `Generic-Future-Inextendibility-with-Square-Integrable-Connection-Near-a-Fixed-Kerr-Spacetime-September-23-2026/build/sections/holonomy_category.tex`:
  `ho:base-comparison`, lines 104-135;
  `ho:loop-jets`, lines 170-247;
  `prop:averaged-holonomy`, lines 252-271;
  `ho:density-only` and representative removal, lines 307-339;
  `ho:frame-ode` and `ho:stop-improvement`, lines 366-393;
  interpolation and polarization, lines 411-439;
  `thm:nowhere-dense`, lines 457-553.
* The same manuscript's `weak_exits.tex`:
  `ex:homotopy`, `ex:graph`, `ex:boxes`, `prop:exit-family`,
  lines 22-445; `def:exit-test`, lines 481-526;
  `prop:exit-cover`, lines 535 onward.
* The same manuscript's `background.tex`:
  `prop:bg-package`, `prop:bg-runout`, `lem:bg-branch-tube`.
  These imported near-Kerr inputs remain open.
* The same manuscript's `packet_preparation.tex`,
  `nonlinear_comparison.tex`, `attachment_signal.tex`:
  `prop:packet-preparation`, `thm:dn-comparison`,
  `prop:experiment-attachment`, `prop:curvature-signal`,
  `prop:matched-seeds`. These analytic inputs remain open.
* The three main assertions are the square-integrable manuscript's
  `introduction.tex`, `thm:main`, lines 98-106; the C1 manuscript's
  `02-phase-space.tex`, `phase:main`, lines 94-103; and the C2
  manuscript's `01-introduction.tex`, `thm:main`, lines 67-79.
  Their exact regularity classes and common dependency structure are
  separately recorded in the ledger and proof graph.

The C1 and C2 implications by regularity inclusion require restricting
to a common neighborhood at the same positive-spin Kerr center.
They do not identify the three manuscripts' different neighborhoods.

## Theorem 1: quantitative averaged-holonomy estimate

Fix an integer N>=3, a finite p>=1, a>0, and a real b satisfying
1+a-b>0. For every sufficiently small r, suppose the following objects
are given.

(H1) A smooth Lorentzian metric g of signature (-+++) on a coordinate
observation box, with coordinates (u,v,theta1,theta2). A measurable
parameter set P_r has measure

    dnu = du dv dtheta1 dtheta2 dm1 dm2 dm3 = dx dm.

Its position projection has a fixed coordinate margin inside a larger
observation box, and its momentum fibers lie in one bounded measurable
box Q in R^3. There is no injectivity assumption on the projection of
P_r onto positions.

(H2) Put F=(partial_u,r^(-1)partial_v,partial_theta1,partial_theta2).
The Gram matrix G=(g(F_i,F_j)) and its inverse are uniformly bounded.
Their ordinary coordinate derivatives through order N+1 have a
subpower bound. At each parameter a chosen future unit timelike
tangent U has uniformly bounded F components.

(H3) The smooth observation region embeds smoothly and openly,
isometrically and injectively into an ambient manifold with a continuous
nondegenerate Lorentzian metric. At most B smooth charts are supplied.
On their full coordinate domains the ambient metric and inverse have
component norm <=B and their weak Christoffel representatives have
Lp(dy) norm <=B. On the smooth image these arrays agree almost
everywhere with the smooth interior Levi-Civita connection.

(H4) G_r is the measurable subset of parameters whose point and chosen
unit tangent have, in at least one of these same charts, coordinate
margin >=1/B and coordinate tangent norm <=B.

Let ell=r^a and R=r^(-b). There is a measurable exceptional set
E_r subset G_r such that

    nu(E_r) <= C/(r R^p) = C r^(pb-1),
    |D(x)| <= C rR/ell + Q(r) ell^(N-2)
            = C r^(1-b-a) + Q(r) r^((N-2)a)                 (1)

at every remaining parameter, where
D_AB=Riem(partial_v,partial_thetaA,partial_v,partial_thetaB).
The constant depends only on fixed N,p,B and the stated uniform
observation and momentum bounds. The subpower term may also depend on
the fixed derivative bounds. No symmetry, prescribed-curve weak trace,
or boundary comparison of differentiable structures is assumed.

### Proof: the good base point

For any Lorentzian Gram matrix A and unit timelike vector t, define

    K(A,t)=A+2(At)(At)^transpose.

Decomposing z=ct+w with A(t,w)=0 gives K(z,z)=c^2+A(w,w)>0
unless z=0. The matrix determinant lemma gives the exact identity

    det K(A,t)=det A (1+2 t^transpose A t)=-det A.          (2)

Bounded A,A^(-1),t bound the largest eigenvalue of K and bound
its determinant away from zero. In dimension four its smallest
eigenvalue is bounded below by the determinant divided by the cube
of the largest-eigenvalue bound.

Choose at each good parameter the least admissible chart index.
This is a finite measurable selector, even when it depends on m.
If M is the matrix of the F columns in this chart, and g_c is the
chart metric, then G=M^transpose g_c M, U_c=M U_F, and

    K(G,U_F)=M^transpose K(g_c,U_c)M.

The positive definite comparisons in both bases bound M and M^(-1)
at the base by one uniform C0. Bounded Lorentzian Gram matrices
alone would not bound a boost; the same bounded timelike vector in
both bases is essential here and is already present in (H2)-(H4).

### Proof: loop jets and the curvature identity

The F fields commute. Koszul's formula, for a constant column V and
W=r V^i F_i, gives the connection matrix

    A(W)^k_j =
      (1/2) G^(kh) V^i
       [(r F_i)G_jh+(r F_j)G_ih-(r F_h)G_ij].             (3)

Each rF_i is one of r partial_u, partial_v, r partial_thetaA,
with constant bounded coefficients. Thus A(partial_v) and A(rX),
for X in {partial_theta1,partial_theta2,
partial_theta1+partial_theta2}, and their ordinary derivatives
through order N, are bounded by a subpower function. Derivatives
of G through N+1 suffice. Uncontracted F connection coefficients
need not be subpower.

For a base point x, consider the coordinate rectangle with consecutive
displacements l partial_v, lrX, -l partial_v, -lrX, for
0<=l<=(N-1)ell. Its four edges are translations x+c_e(s,l),
0<=s<=1, with c_e linear in l and independent of m. Their positions
stay in the larger observation box for small r. In F each edge
transport equation has coefficient l A(+/-W)(x+c_e(s,l)).
Its integral norm is <=l Q(r)=o(1).

If P'=-A_e P, differentiation k times in l gives

    (partial_l^k P)' =
      -A_e partial_l^k P
      - sum_(j=1)^k binom(k,j)
           (partial_l^j A_e)(partial_l^(k-j)P).

The differentiated initial data vanish for k>0. Induction and the
integral inequality for this linear ODE bound all derivatives through
N by finite products of subpower bounds: the exponential involves
only the undifferentiated integral o(1), not Q(r) alone.
Multiplying four edge transports therefore gives

    sup_(0<=l<=(N-1)ell) |partial_l^N H_x,X(l)| <= Q(r).  (4)

Write C2 for the quadratic Taylor coefficient of H-I. To identify
it, pull back the smooth connection to the two-plane with coordinates
(s,t) mapped to x+s partial_v+t rX, and choose a smooth frame
whose connection form vanishes at the origin. Its boundary integral
around [0,l]^2 is O(l^2); the error between ordered transport and
I minus that integral is O(l^4). Stokes and the curvature identity
give C2=+/-Riem(partial_v,rX) as an endomorphism at x.
Returning to F preserves this statement, because a closed loop's
frame change conjugates by its value at the base only. Consequently,

    g(C2 F1,X)
       = +/- g(Riem(partial_v,rX)(r^(-1)partial_v),X)
       = +/- D(X,X).                                    (5)

The same curvature and loop-orientation convention fixes all signs.
There is exactly one factor r and one factor r^(-1); none remains.

### Proof: averaging the stopped connection, before any frame bound

Fix X and a positive sampled size l=j ell, 1<=j<=N-1.
Use the selected base chart on the concatenation of all four edges.
Choose K>2C0+1. Stop at the first time that |M| reaches K or that
the chart position is at distance 1/(2B) from its base position.
Edges after an earlier stop contribute zero. A coordinate ball of
this radius about the base is contained in the selected chart by
its initial margin.

The pre-stop subset is measurable. Indeed the interior positions,
chart coordinates and M are smooth on their open domains; requiring
the two strict thresholds at all earlier times can be written using
suprema over rational earlier times. Intersect with the finite
measurable chart selector. No bound on a weak connection is used
to define the stop.

Fix an edge time s and chart c. The position map

    x -> x+c_e(s,l) -> ambient image -> y_c

is smooth and injective on its chart domain. If g_x denotes the
ordinary coordinate matrix, the constant frame change gives

    det g_x = r^2 det G,
    c r <= sqrt(|det g_x|) <= C r.                       (6)

Isometry and the smooth change-of-variables identity give

    dx = sqrt(|det g_c(y)|)/sqrt(|det g_x(x+c_e)|) dy
       <= C_B r^(-1) dy.                                (7)

This uses determinants, NOT an unproved bound for M along an edge.
Enlarge the nonnegative integral over selected pre-stop parameters
to all m in Q and all translated positions in the chart. Thus

    integral_(selected, pre-stop) |Gamma_c(y_e(s))|^p dnu
       <= C_B |Q| r^(-1) integral_chart |Gamma_c(y)|^p dy.
                                                               (8)

The chart selector and stop may depend on all momenta: they only
restrict the integral before this enlargement. No projected seed
injectivity is needed.

Fix Borel representatives of the weak arrays. For each fixed s,
the inverse image of their exceptional position null sets under
the preceding smooth coordinate diffeomorphism is null.
Fubini in s,x,m, followed by the finite union over charts, edges,
directions and sampled sizes, removes a single parameter null set
on which smooth and weak stopped integrals could disagree.
This argument does not assert a trace on an individually specified
curve, and the stop did not depend on the representative.

Set

    I_e(x,m)=integral_0^1 1_pre-stop |Gamma_c(y_e(s))| ds.

For p>=1, convexity on the unit s interval yields
I_e^p <= integral_0^1 1_pre-stop |Gamma_c|^p ds.
Integrating (8), and summing the at most B charts, gives

    integral_G_r I_e^p dnu <= C/r.

Markov therefore bounds nu{I_e>R} by C/(rR^p). The finite union
over 4(N-1)3 choices has the same bound, with a different fixed
constant. Add the previously discarded null set.

### Proof: the stop cannot occur

At a remaining parameter all the I_e are <=R. On any pre-stop
edge, its F velocity is f=lrV with V fixed and bounded.
Differentiating its coordinate frame columns gives the EXACT law

    M' = M A_e - Gamma_c(Mf) M,                          (9)

since the chart components of the covariant derivative of F are
M'+Gamma_c(y')M, whereas in F they are M A_e, and y'=Mf.
In particular there is no sign reversal, omitted M, or inverse in
the contraction Gamma_c(Mf).

Before the stop,

    |M'| <= K l Q(r)+C K^2 lr |Gamma_c|,
    |y'| <= C K lr.

Summing all stopped edge pieces, including any terminal partial
edge, gives

    sup |M-M(0)| <= C_N K ell Q(r)+C_N K^2 ell rR=o(1),
    sup |y-y(0)| <= C_N K ell r=o(1).                   (10)

Here a>0 and 1+a-b>0 are exactly the required smallness conditions.
These are strict improvements of both first-stop thresholds for
small r. Continuity excludes a first stop. A path cannot leave the
chart while remaining in the compact coordinate ball already
specified. The original rectangle exists smoothly in the observation
box throughout, so there is no additional existence endpoint.

For completeness, inverse-frame bounds are not needed in this
bootstrap. They would also follow from
det(M)^2=det G/det g_c and the cofactor formula.

The total chart transport coefficient now has integral <=C_N ell rR.
The transport integral equation and its convergent iterates give

    |P_c-I| <= exp(C_N ell rR)-1 <= C_N ell rR.

The loop closes at its exact starting position. Its final frame
matrix is therefore M(0), not an unrelated terminal matrix.
Consequently H=M(0)^(-1)P_c M(0), and

    |H_x,X(j ell)-I| <= C_N ell rR.                     (11)

### Proof: finite interpolation, not a continuum of weak traces

Taylor's formula and (4) give

    H(l)-I = sum_(k=0)^(N-1) C_k l^k + R_N(l),
    |R_N(j ell)| <= Q(r) ell^N,  0<=j<=N-1.

The Vandermonde determinant at the distinct integer nodes is
the nonzero product of all positive differences j-i.
Hence there are fixed rational weights w_j with

    sum_(j=0)^(N-1) w_j j^k = 1 if k=2, and 0 otherwise,
                                   0<=k<=N-1.           (12)

Equivalently w_j is the coefficient of t^2 in the jth Lagrange
basis polynomial. For n=N-1 and H_n=sum_(k=1)^n 1/k,

    w_0 = sum_(1<=i<j<=n) 1/(ij),
    w_j = (-1)^j binom(n,j)(H_n-1/j)/j,  1<=j<=n.       (13)

These formulas follow by differentiating the finite products
t/j times the remaining linear factors for j>0, and
product_(k=1)^n(1-t/k) for j=0. They prove (12) for every N.
Multiply the Taylor samples by w_j and sum. Equations (11)-(12)
give

    |C2| <= C_N ell^(-2) max_j |H(j ell)-I|
             +Q(r) ell^(N-2)
          <= C_N rR/ell+Q(r) ell^(N-2).

Only a FINITE set of sampled positive loops was used in the
weak-connection averaging. Smooth interior jets, not weak ambient
traces, supply the remainder for other l.

Bounded G and (5) control D(X,X) for the three chosen X.
The curvature pair symmetry gives D_12=D_21 and
2D_12=D(theta1+theta2,theta1+theta2)-D_11-D_22.
This proves (1) for the whole block and completes Theorem 1.

## Theorem 2: exact feasibility of the exponent system

For real p>0, q>0 and sigma>0 the following are equivalent:

    there exist a,b with
      a>0, pb>1, 1-b-a>sigma, qa>sigma;                 (14)
    1/p + sigma/q < 1-sigma.                           (15)

Necessity follows because (14) implies b>1/p,
a>sigma/q, and a+b<1-sigma.
For sufficiency put

    delta=(1-sigma-1/p-sigma/q)/3,
    a=sigma/q+delta, b=1/p+delta.

Then delta>0 and

    pb-1=p delta,
    1-b-a-sigma=delta,
    qa-sigma=q delta,                                  (16)

while a>0. These are exact identities, so the proof covers all
real p,q,sigma in the stated domains, without discretizing them.
In particular 1+a-b>0, as required in Theorem 1, follows already
from 1-b-a>sigma>0 and a>0.

For sigma=1/4, q=N-2 and integer N>=3, (15) is equivalent to

    p > 4(N-2)/(3N-7).                                 (17)

Indeed q>=1 and multiplication by 4pq>0 reduces (15) to
(3p-4)q>p, equivalently p(3q-1)>4q.
The right side of (17) is

    4/3 + 4/[3(3N-7)] > 4/3.

Conversely if p>4/3, choose a positive integer

    q > p/(3p-4),  N=q+2.

Such an integer exists by the Archimedean property, and it satisfies
(17). Thus some finite interpolation order works if and only if
p>4/3.

With (14), the exceptional measure in (1) tends to zero and
both curvature terms are o(r^sigma): a strictly positive power
beats a subpower function. This last assertion follows directly
by taking epsilon equal to half of the positive exponent margin
in the definition of Q.

This is a sharp criterion for the displayed strict POWER-LAW
estimates. It is not a counterexample to inextendibility or a proof
that a better geometric method cannot reach p<=4/3.

### Original p=2 constants and the finite derivative budget

The manuscript uses N=18, a=1/16, b=17/32, sigma=1/4.
The exact exponents are

    pb-1       = 1/16,
    1-b-a      = 13/32,
    (N-2)a     = 1,
    1+a-b      = 17/32.

The curvature exponent margins over sigma are 5/32 and 3/4.
These reproduce the manuscript's exceptional measure
r^(1/16) and curvature errors r^(13/32)+Q(r)r exactly.
Its 30 ordinary Gram derivatives more than suffice for N=18.

For fixed N=18, (17) is p>64/47, not all p>4/3.
The direct N+1 derivative budget permits N=29 with 30 derivatives,
which suffices for p>27/20. Claiming the entire p>4/3 range
from those 30 derivatives alone would NOT follow from this proof.
Near 4/3, Theorem 4 explicitly assumes the larger fixed finite
jet budget chosen after p. No packet-amplitude strengthening occurs.

## Theorem 3: positive geodesic family from a weak exit

Let (M,g) be a smooth time-oriented globally hyperbolic
four-dimensional spacetime with a smooth spacelike Cauchy surface
Sigma. Suppose it embeds smoothly, openly and isometrically into a
continuous nondegenerate Lorentzian extension, whose chart connection
has locally L1 representatives agreeing almost everywhere with the
smooth interior connection. Assume a future timelike C1 curve in M
has an ambient boundary endpoint. Then a positive canonical section
measure set of future unit geodesics from Sigma has finite FULL
future proper lifetimes and ambient boundary endpoints in one
compact chart region. Finitely many precompact ambient charts give
uniform metric/inverse bounds, finite L1 connection norms, positive
coordinate margins and bounded velocities throughout these geodesics.

This includes continuous nondegenerate W1,p_loc extensions for every
finite p>=1, using local finite chart volume when p>1.

### Proof

First, a fixed-endpoint homotopy of ambient future causal curves
from interior p to interior q cannot leave M if one member is in M.
For the set A of parameters whose whole path is in M, compactness
of the path interval makes A open. Every such member lies in the
one compact intrinsic diamond J_M^+(p) cap J_M^-(q).
Its image is closed in the Hausdorff ambient manifold, so limits
of members still lie in that compact set and A is closed.
The parameter interval is connected, proving the assertion.

A late part of the exiting curve lies in I_M^+(Sigma): extend it
to a past-inextendible timelike curve and use the Cauchy property.
Choose a sufficiently small chart near the exit, a point q on a
uniformly timelike coordinate line slightly to its future, and
late interior points x_n tending to the exit. All straight
segments [x_n,q] are uniformly timelike for large n. If none had
a first exit, q would be interior and all these x_n would lie
in one compact intrinsic diamond with a fixed earlier p. Their
boundary limit would then be in M. Thus a straight timelike
first exit exists, starting in I_M^+(Sigma).

Translate this exit to (s,z)=(0,0), straighten its direction,
and choose the other coordinate axes spacelike orthogonal there.
After shrinking the chart, s is temporal, the spatial metric
block is uniformly positive definite, and every (1,eta) with
|eta|<c is uniformly timelike. Choose a common bottom -d0 in
I_M^+(Sigma), and 0<delta<d0/4. Over a sufficiently small spatial
ball define the first vertical exit height f(z), clipped at
2delta. Compact openness below the central exit ensures
f(z)>-delta. If f(z)>delta, the vertical interior path from
(-d0,z) to (delta,z) is homotopic through uniformly timelike
spatial graphs to the broken path through (0,0). Shrink the
spatial radius so all slopes are <c. This contradicts the
preceding homotopy fact, so f(z)<=delta.

If f(z')>f(z)+L|z-z'| with L>4/c, choose
f(z)+2|z-z'|/c < b' < f(z'). The broken path from
(-d0,z') through (f(z),z) to (b',z') has slopes <c after
the same shrinking. Its endpoints and the reference vertical
path are interior. Linear interpolation of spatial graphs again
contradicts the homotopy fact. Interchanging z,z' proves that
f is Lipschitz. All subgraph vertical segments are in M, and
(f(z),z) is a boundary point. Only intrinsic global hyperbolicity
has been used, not ambient global hyperbolicity.

For z in a fixed smaller ball D', fix K>3 and define

    Q_l(z)={|y-z|<Kl, |s-f(z)|<Kl}.

All these boxes lie in a fixed compact chart for small l.
If L is a Lipschitz constant of f, their union lies in the
layer |s-f(y)|<=K(1+L)l. For each (s,y) the admissible centers
z have three-volume <=C_K l^3. Tonelli gives

    integral_D' l^(-3) integral_Q_l(z) |Gamma| ds dy dz
        <= C_K integral_layer |Gamma| ds dy -> 0.        (18)

The graph has four-dimensional measure zero by Fubini, and
absolute continuity of the L1 integral proves the limit.
Choose scales l->0 and centers with normalized mass tending
to zero. This argument needs L1, not L2.

Write s_c=f(z_c), s0=s_c-l, s1=s_c+l. Choose small rho,eps>0
with Lrho<1/4, rho+4eps<1, and

    2eps+C_beta(rho+2eps)<c,                            (19)

where C_beta controls the derivative of a unit-scale bump.
The slice s=s0, |z-z_c|<rho l, is in I_M^+(Sigma).
Parameterize future unit initial velocities by

    U=N(1,eta), |eta|<eps,
    N=[-g((1,eta),(1,eta))]^(-1/2),
    pi_i=N(g_i0+g_ij eta^j).

Uniform timelikeness gives upper and positive lower bounds for N.
Algebraic differentiation, not ambient spatial differentiation, gives

    partial pi_i / partial eta^j
      = N g_ij + N^3(g_i0+g_ik eta^k)(g_j0+g_jk eta^k).
                                                               (20)

This is uniformly positive definite because the spatial block is.
Integrating its quadratic form along a segment proves injectivity
on the convex slope ball. Its determinant is bounded above and
away from zero. Hence the canonical initial set A_l in (z,pi)
has volume between c1 l^3 and C1 l^3, and its momenta are
uniformly bounded.

Follow the smooth interior unit geodesics, using s as parameter,
until s1, a box/chart face, or |eta|=2eps. Before these stops
|z-z_c|< (rho+4eps)l<l, so no spatial face is reached.
The pre-stop domain is open by smooth dependence. On the future
unit shell H=(1/2)g^(alpha beta)pi_alpha pi_beta=-1/2,
partial_pi0 H=dot s>0. Solve pi0=-h(s,z,pi). The reduced
equations are

    dz^i/ds=partial_pi_i h,  dpi_i/ds=-partial_z_i h.

Their divergence in (z,pi) vanishes by equality of mixed
derivatives. The hitting map to a fixed s slice is smooth,
injective by backward uniqueness before the stop, and has
canonical Jacobian one. With bounded momentum fibers, Tonelli
and (18) therefore yield

    integral_A_l I(x) dx
      <= C integral_Q_l(z_c) |Gamma| ds dz=o(l^3),
    I(x)=integral_pre-stop |Gamma_M(gamma_x(s))| ds.      (21)

The same change of variables removes weak/smooth representative
null sets for almost every initial arc; no weak trace is prescribed.
The slope equation is exactly

    d eta^i/ds =
       -Gamma^i_alpha beta V^alpha V^beta
       +eta^i Gamma^0_alpha beta V^alpha V^beta,
    V=(1,eta).

Thus |eta'|<=C2 |Gamma_M| before the stop. By (21), a set
G_l of measure >=|A_l|/2 has I<eps/(2C2). Its slopes stay
<3eps/2 and cannot reach the wider slope stop. Position and
chart stops have already been excluded.

If such an arc survived in M through s1, choose a bump beta
supported in (s0,s1), equal to 1 at s_c, with
|beta'|<=C_beta/l. Set Delta z=z_c-z(s_c) and
z_t(s)=z(s)+t beta(s)Delta z, 0<=t<=1.
Here |Delta z|<=(rho+2eps)l. Condition (19) makes every
graph future timelike, in the same ambient rectangle and with
the same interior endpoints. The last member passes through
(s_c,z_c) on the boundary, contradicting the homotopy fact.
The maximal pre-stop height is therefore s_*<=s1, with no
other stop.

Unit normalization on the narrower cone gives
0<c3<=ds/dtau<=C3. There is finite elapsed proper time and,
by bounded slope, an ambient position limit in a compact
subrectangle. If that limit were interior, the smooth local
geodesic equation with bounded velocity would give a velocity
limit and continuation. For s_*<s1 this contradicts maximality;
for s_*=s1 it supplies the forbidden surviving arc.
The limit is consequently a boundary point. An extension of
this geodesic within the FULL M would have to take that
boundary value at the joining finite proper time, impossible
under the continuous embedding. Its full future lifetime is
finite, not just its lifetime in the comparison chart.

Finally a maximal timelike geodesic in a smooth spacetime
cannot have an interior causal endpoint. In a compact smooth
temporal chart around such an endpoint causal coordinate
slopes are bounded, and

    d/ds log(ds/dtau)
       =-Gamma^0_alpha beta(1,eta)^alpha(1,eta)^beta

is bounded. A finite s endpoint then gives bounded positive
ds/dtau, finite affine duration, a velocity limit and smooth
continuation. Apply the same argument to the past.
The Cauchy property forces the maximal geodesics here to
intersect Sigma once, in their past.

Locally this backward hit and its time are smooth, transverse,
and diffeomorphic onto their image in the unit shell.
Take precompact initial neighborhoods with compact earlier
flow tubes. A countable cover has one member meeting G_l
in positive measure; restrict to it. The unit-shell
Hamiltonian argument preserves section symplectic volume
also for a variable hitting time: the flow direction is
the kernel of the restricted symplectic form, so the
additional hitting-time term vanishes. At Sigma the
tangential covector of sqrt(1+h(w,w))n+w is h(w,.).
This is exactly the canonical section measure asserted.

Finitely many smaller ambient charts cover the compact
earlier flow tube with positive margins and bounded
velocities. Add the one exit chart for the final arcs.
All metric/inverse and local L1 bounds are finite on these
precompact charts. This proves Theorem 3.

## Theorem 4: conditional category transfer, with unchanged signal

Fix a finite p>4/3. Assume a Baire data space with the same
extension definition as the staged paper, except W1,p_loc
in place of W1,2_loc. Retain the smooth open embedding,
continuous nondegenerate metric, future timelike C1 exit,
and no ambient field equation or global hyperbolicity.
Suppose the following additional packages hold in ONE
fixed data neighborhood.

(C1) Every finite-full-lifetime geodesic has a classified
first comparison runout; corner seeds are canonical-section
null, and every branch seed has an open common observation
tube and bounded terminal momentum box. A countable fine
seed-ball basis and smooth positive initial section densities
are available.

(C2) For each datum, each finite seminorm neighborhood order,
and the fixed finite N selected by Theorem 2 after p, there
are arbitrarily late exact full-data packet perturbations,
attached to their full MGHDs. On common observation coordinates,
the background and packet metrics satisfy (H1)-(H2) through
N+1 ordinary derivatives, with uniform subpower bounds.
For a trimmed seed ball O0 with mu_d(O0)>.95 mu_d(O),
their backward terminal-state maps are injective into O
and preserve their canonical section volumes.

(C3) For each fixed experiment these facts persist on a
relative open data neighborhood. The persisted metric
g_hat, compared with g_d at the SAME numerical terminal
states, has

    |D(g_hat)-D(g_d)| > r^(1/4)

on a set of v levels occupying more than half of a fixed
interval J0. The initial measure ratio
mu_hat(O)/mu_d(O) tends to one. Frame and tangent bounds
and common terminal momentum bounds persist uniformly.

Then data admitting future C0 cap W1,p_loc extensions
are meagre in that data neighborhood. This is a theorem
ABOUT THESE IMPLICATION HYPOTHESES, not a claim that the
unreviewed near-Kerr analytic packages satisfy them.

### Proof

Define E_p(O,B) exactly as the manuscript's existential test,
with Lp chart norm replacing L2: more than .99 of the
section measure of O has finite full future lifetimes and
one finite chart collection supplies velocity, margin,
metric, inverse and connection bounds along the ENTIRE
future geodesics. Its branch tube is an existential
witness, not a new uncountable test index.

Theorem 3 and local Lp subset L1 supply a positive family
from every weak exit. By (C1), remove the corner-null subset,
take a density point that is a branch seed, and choose a
fine rational basis ball with closure in its branch tube
and good density >.99. Enlarge an integer B to bound
the finitely many witnesses. Thus all extendible data
belong to the countable union of E_p(O,B). This argument
does not replace full future lifetimes by chart lifetimes.

If E_p(O,B) were dense in a nonempty relative open V
contained in its closure, choose d in E_p(O,B) cap V.
There is a finite seminorm ball around d contained in V.
By (C2) choose sufficiently late packet data in this ball.
By finite persistence (C3) and density of E_p(O,B), choose
g_hat from E_p(O,B) as close to that packet as this
particular finite experiment requires. Such closeness
may depend on its observation time. No uniform data
neighborhood radius is assumed.

Use the background terminal-state parameter set from O0.
On every v slice it has canonical six-volume mu_d(O0).
The background bad seeds lose at most .01 mu_d(O).
Injectivity and canonical measure preservation of the
persisted backward map lose at most .01 mu_hat(O).
The density ratio tends to one, so for large observation
times the joint good slice has volume >.91 mu_d(O).
Integrating over the signal's v levels gives total joint
good signal measure >.455 mu_d(O)|J0|, a fixed positive
number. No injectivity of position projection was used.

Select N,a,b by Theorem 2 with sigma=1/4. Apply Theorem 1
to each metric, using its own fixed extension/chart
witness collection and the same numerical parameter
measure. The two exceptional measures tend to zero.
They cannot cover the positive joint signal set.
At a remaining parameter both curvature blocks are
o(r^(1/4)), contradicting their difference >r^(1/4).
Thus every E_p(O,B) is relatively nowhere dense.

The countable union is meagre; the complement of the
union of their closures is a dense G_delta by the
assumed Baire property. This proves Theorem 4.

## Certificate coverage and limitations

`verify.py` deterministically replays rational interpolation weights
and all eighteen moment equations, the original exponents and strict
margins, source-anchor presence, symbolic determinant/density/frame
identities, the slope Jacobian, and an oriented nonflat small-loop
curvature computation. It also checks the retained typed Jacobian
solution against its exact request. These are exact algebraic
certificates, not numerical experiments with tolerances.

`Main.lean` formalizes the universal real exponent equivalence,
its fixed-integer-N specialization and its finite-order existence
criterion, together with the original rational constants.
`statement_fidelity.md` separates these quantifiers from the
analytic arguments above. A real, claim-linked compiler run is
required; merely possessing the source is not evidence.

The analytic and measure-theoretic proofs above require independent
human mathematical review. Neither SymPy nor Lean in this directory
formalizes the spacetime geometry, weak representatives, Fubini
argument, differential equations, or the companion PDE constructions.
No empirical test is represented as a proof of those steps.
No false literal manuscript assertion has been established in this
mission, so no manufactured F_* refutation is recorded.

## Reproduction and current formal evidence

Run from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/holonomy_certification/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/holonomy_certification/Main.lean --statement-fidelity research/holonomy_certification/statement_fidelity.md --artifact-dir research/holonomy_certification --claim C_EXPONENTS --project-root .
```

The current source was compiled by Lean 4.31.0 in the host's built
Mathlib workspace: exit_code=0, proof_holes=[], with a claim-linked
mechanical supports record. Its archived compiler certificate is
`certificates/C_EXPONENTS-bd73616b17897e19.json` in this directory.
The source and its fidelity document have not been edited since that
successful run. An earlier source's type-error run is retained as
inconclusive evidence, not used as support or refutation.

The bounded Jacobian execution is separately replayable:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation matrix.rational_linear_system.solve --payload-file research/holonomy_certification/jacobian_linear_payload.json
```

Its retained server is version 0.14.0, protocol 2025-11-25.
The operation returned UNIQUE and adapter exit 0 without a timeout.
The exact request, typed contract and complete typed response are
dedicated JSON files; verify.py independently checks the returned
rationals and every moment, rather than trusting this classification.
