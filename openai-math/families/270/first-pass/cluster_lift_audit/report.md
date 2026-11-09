# Corrected cluster lifts: independent audit

## Exact question and scope

The target is `prop:test-lifts` in the staged threshold manuscript,
`sections/05-lifts.tex:88-107`, with its dependencies in
`sections/04-fast-analysis.tex`. The parameters are every proper partition
of every allowed N, every real unit spinor v, and a fixed m >= 0 as h
tends to infinity. Center tests are smooth, compactly supported away from
collisions, and take values in finite algebraic tensors of actual internal
L2 kernel vectors. No internal moment or global derivative condition may
be added.

The two requested limits are

    ||I_h f - J_h f|| -> 0,
    ||D_v(h,m) I_h f - J_h D_v^C(m) f|| -> 0.

The scalar-block and SU(3), partition (2,1), calculations below are
falsification probes, not a verification of these quantified limits.
Failure of a displayed intermediate identity is not a counterexample to
either main spectral theorem.

## Starting knowledge

The source itself identifies the reduced-inverse asymptotic construction
as prior art: Konechny, arXiv:hep-th/9805046v4; Froehlich--Graf--Hasler--
Hoppe--Yau, arXiv:hep-th/9904182v2; and Lin--Yin, Section 4.1 (bibliographic
key `LinYin2015`). It attributes regular-Cartan gauge-spin/density
cancellation to Hasler--Hoppe, arXiv:hep-th/0206043. These attributions
are not, by themselves, evidence for the moment-free noncommuting-block
extension. The focused primary-source comparison below checks the
relevant Lin--Yin passage; the other papers are not used in the proof.

The undeformed square and graph-domain/local regularity assertions
`prop:square` and `lem:domains` were initially recorded as a dependency
of `C_LIFT_270`. Sections 1--2 below supply the required undeformed
identity and domain argument independently. No manuscript assertion
has been found false in this audit. Independent Reviewer acceptance
is still required. The shared Wiki index contains no BFSS/campaign-270
entry.

The dependency graph records both spectral arguments separately.
Threshold: massive index and normal-vacuum analysis; corrected lifts and
fast projection; profile liminf/exhaustion and exterior control; massive
tightness/gap and recovery; kernel count. Positive energy: form and
rotations; Spin(9)-to-Spin(8) selection and transverse oscillator bound;
confinement; nonzero physical high-weight sectors; positive eigenvalues.

## Exact-algebra tool boundary

The installed Jacobian adapter reports server version 0.14.0 and protocol
2025-11-25. Its symbolic characteristic-polynomial contract has been
inspected before custom exact algebra. Discovery and the typed contract
are retained in `jacobian/`. The bounded operation is used only for a
matrix invariant it actually computes, not as evidence for analytic
graph-norm convergence.

## Result and its evidentiary status

**Verification theorem submitted for independent review.** With the
BFSS definitions below, the original assertion `prop:test-lifts` holds:
both norm limits hold for the original class of tests, without a
moment or global derivative condition on any internal kernel vector.
The proof is Sections 1--9. The executable certificate checks the
load-bearing algebra exactly, not the analytic proof.

No counterexample, false intermediate assertion, or misapplied
external theorem has been established. In particular there is no
`F_...` refutation claim to file. Neither main spectral theorem is
proved here. This is an independent verification of a proposition
already asserted in the target manuscript, not a claim of a newly
discovered BFSS theorem or of verified originality.

The strongest prior result in the current campaign ledger was the
unexamined audit objective. The improvement is a general graph-norm
argument, including the moment-free multiplier stability estimate,
and coefficient-exact verification of its Clifford normalization and
undeformed square. It is not merely agreement of scalar-block or
finite oscillator truncation experiments.

### 1. Definitions, exact algebra, and the undeformed square

Use the real metric Lie algebra of traceless Hermitian matrices,
with inner product Tr(XY) and real bracket [X,Y]=(XY-YX)/i.
Thus K_X=ad(X) is skew. Fermions satisfy
{theta^A_mu,theta^B_nu}=delta_AB delta_mu,nu, so a unit real
fermion squares to 1/2, not 1. Fix real symmetric 16 by 16
Clifford matrices gamma_i. Write

    T = gamma_1 gamma_2 gamma_3,
    A_i = gamma_i v,
    B_ij = -gamma_i gamma_j v,                 i<j,
    L_i = s_i gamma_i T v,                    s_1,2,3=2, s_4,...,9=-1,
    D_v(h,m) = theta(A_i).p_i
               + h sum_(i<j) theta(B_ij).[x_i,x_j]
               + m theta(L_i).x_i.

All tensor products of fermion modules are graded. On physical
equivariant wavefunctions the Gauss identity is

    p.ad(w)x = -(i/2) theta^t(ad(w) tensor I)theta.

The following quadratic identity holds for any real spinor, not
only unit spinors. For a fixed axis j set a_i=gamma_i v and
c_i=gamma_i gamma_j v, with i != j. Then

    a_i.a_l = c_i.c_l = delta_il |v|^2,
    a_i.c_l = delta_il (v^t gamma_j v),
    sum_(i!=j) (a_i c_i^t + c_i a_i^t)
       = (v^t gamma_j v) I - |v|^2 gamma_j.             (1)

`verify.py` constructs a real Clifford representation from the
octonion multiplication table, checks all its Clifford relations,
and proves (1) by polarization, for all nine choices of j.
For a homogeneous quadratic matrix polynomial in 16 variables,
its values on e_a and e_a+e_b determine all 136 coefficients.
These are coefficient checks, not a finite-spinor approximation.

This representation does not restrict the choice of real gamma
matrices. Products of subsets of the first eight generators form
256 trace-orthogonal matrices: every nonempty product has zero
trace, by conjugation with a suitable generator. Thus they span
M_16(R). Any two such representations induce an automorphism of
M_16(R), which is inner: transport matrix units, choose a vector
in the first rank-one image, and transport it with the other
matrix units to obtain the intertwining basis. Symmetry of the
generators forces the positive square of the intertwiner to
commute with M_16(R), so the intertwiner is orthogonal after
rescaling. The ninth generator is determined up to sign by
anticommutation with the first eight. Formula (1) is covariant
under orthogonal conjugation and under any individual generator
sign change. The script additionally checks the full 256-element
matrix-algebra basis in its constructed representation.

For completeness these identities give the needed undeformed
square, rather than assuming it. The kinetic square is p^2/2.
The Gram matrix of B_ij has its metric part and an alternating
four-form part. For four distinct spatial indices the latter
contracts

    <[x_i,x_j],[x_k,x_l]> - <[x_i,x_k],[x_j,x_l]>
       + <[x_i,x_l],[x_j,x_k]> = 0,

by invariance of the inner product and Jacobi. Hence the
potential square is h^2 sum_(i<j)|[x_i,x_j]|^2/2.
The script checks the entire 36 by 36 Clifford Gram
decomposition, including its signs.

The first-order kinetic/bracket cross term is
h sum_j (v^t gamma_j v) p.ad(x_j)x. Differentiating the bracket
gives, by (1),

    (ih/2) theta^t sum_j
       K_(x_j) tensor ((v^t gamma_j v)I-gamma_j) theta.

The Gauss identity cancels its scalar-spinor part. Therefore,
on the invariant core, for every unit v,

    D_v(h,0)^2 =
       p^2/2 + h^2 sum_(i<j)|[x_i,x_j]|^2/2
       - (ih/2) theta^t sum_j(K_(x_j) tensor gamma_j)theta.       (2)

In particular the square is independent of v. Its fermion
multiplier has pointwise norm at most C h |x|, with C depending
only on the finite color and fermion dimensions.

### 2. Domains and the only internal-kernel estimate needed

The principal symbol of D_v is constant Clifford multiplication
and its square is |p|^2/2. If u and D_v u are locally L2,
a compactly supported localization satisfies the constant
Dirac elliptic estimate, since the polynomial potential is
bounded there. Consequently u is locally H1. For a maximal-domain
L2 vector, multiplication by cutoffs tending to one with
gradient O(1/R) approximates in graph norm: the commutator is
only the bounded Clifford multiplier of that gradient.
Compactly supported local H1 vectors can then be smoothed in
graph norm; the polynomial potential is smooth and bounded on
their compact support. This identifies the maximal domain with
the graph closure of the compact smooth core. Equivalently,
the deficiency kernels vanish by taking the imaginary part of
the cutoff identity for D_v^*u=+/- i u and letting R increase.
Compact gauge averaging commutes with the charge and preserves
these approximations. The same statements therefore hold on
the physical subspace.

Identity (2) makes all undeformed charge graph norms on the
invariant core equal. Their completions agree. An internal
vector phi in the nonnegative form kernel is thus annihilated
by every D_v(1,0), distributionally and in the common graph
domain. This also follows directly by summing the nonnegative
squared charge norms defining the form kernel.

Let xi be internal physical coordinates of dimension d, and
phi_h(xi)=h^(d/6)phi(h^(1/3)xi). Exact homogeneity gives

    D_v(h,0)phi_h = h^(1/3) [D_v(1,0)phi]_h = 0.

Choose a smooth, invariant, fixed physical cutoff kappa,
equal to one near xi=0. Its gradient is bounded and supported
outside a fixed positive radius. Then

    D_v(h,0)(kappa phi_h) = -i theta(A).(grad kappa) phi_h,
    ||D_v(h,0)(kappa phi_h)|| -> 0.                    (3)

The last limit is exactly an L2 tail after y=h^(1/3)xi;
it requires no rate of decay. The cutoff vector is locally
H1 and compactly supported, so (2) applies by core
approximation. From (2),

    h^-1 ||p_xi u_h||^2 + h sum_(i<j)||[xi_i,xi_j]u_h||^2
       <= 2 h^-1 ||D_v(h,0)u_h||^2
          + C integral |xi| |u_h|^2.                 (4)

On the fixed physical support |xi| is bounded. Its norm
measure concentrates at zero. More explicitly, for any
epsilon>0, the last integral is at most epsilon||u_h||^2
plus a fixed constant times the L2 tail beyond
epsilon h^(1/3). First let h increase, then let epsilon
decrease. Thus the last integral tends to zero.

Apply (3)--(4) to each internal factor of a test. Finite
linear combinations follow by the triangle inequality.
The center coefficients and their derivatives have bounded
norms. Writing b=c+xi and u_h=f_h, the resulting estimates are

    ||p_b f_h / sqrt(h)|| -> 0,
    sum_(i<j)||sqrt(h)[b_i,b_j] f_h|| -> 0,
    ||xi f_h|| -> 0,          sup_h ||f_h|| < infinity.          (5)

Centers commute with every block, so the displayed brackets
are exactly the internal brackets. The same assertions hold
for f replaced by D_v^C(m)f, which has the same finite
collection of internal kernel factors. No uncut y moment,
uncut gradient bound, or finite-dimensionality of a kernel
has entered the argument.

### 3. Exact slice and all remainder terms

For a separated-center chart choose an axis e separating the
block spectra. On its off-block real color space n the map
K_e=ad(b_e) is invertible. Diagonalizing the spectral windows
gives x=b+z, z_e=0. In the orbit/slice differential, the
missing e-component is [w,b_e]; all other components are
below this block. Its determinant is therefore

    j(b)=|det_n K_e|,                              (6)

independent of z. There is no unaccounted z-dependent metric
factor. With the fixed homogeneous-space volume V_C and
t=sqrt(h)z, flat pullback is
V_C^(1/2) j^(1/2) h^(-d_f/4) times restriction.

Let w_A=-K_e^-1 n_A. Solving the Gauss identity for the missing
momentum and then conjugating by j^(1/2) gives

    D_v(h,m) = sqrt(h) E_v(b) + D_v^s(h,m) + R_v(h,m).

Here E is exactly `fast:E-coordinate`. The full list of terms
in R, before the density addition, is:

    theta(B).[t,t],
    (m/sqrt(h)) theta_f(L).t,
    -sum_(A,r) theta_f^A(A_e)
          <Pi_perp[w_A,t_r],p_(t_r)>,
    -h^(-1/2) sum_(A,r) theta_f^A(A_e)
          <Pi_0[w_A,t_r],p_(b_r)>,
    -(i/2) sum_A theta_f^A(A_e) theta^t ad(w_A)theta.

Density conjugation replaces p_b by p_b+(i/2)grad log j.
Since j depends only on b_e and r is transverse to e,
its sole added term is

    +(i/2) theta_s(A_e).grad_(b_e) log j.           (7)

This derivation fixes the gauge-spin sign and the factor 1/2.
It also rules out an extra internal derivative or hidden
parameter-dependent coefficient in the remainder. All
coefficient derivatives are bounded on a compact slow
subchart; powers of t are handled by oscillator norms.

### 4. Neutral square, gap, and noncommuting-block persistence

In this section the rank-one projection and parity refer
to the fast module alone. The operator on the full graded
module is Gamma_s tensor e_f, and its kernel projection
is I_s tensor P_f. Thus "even fast line" does not assert
that every vector obtained by tensoring with an odd slow
vector has even total parity.

At scalar centers change linearly to the slice perpendicular
to conjugation, including its positive unitary density factor.
For a real root plane put ad(c_i)=lambda_i J, J^2=-I.
After a spatial rotation lambda=r e_9, the fast charge is

    sum_(i=1)^8 {theta_f(gamma_i v).p_i
                 + r theta_f(gamma_i gamma_9 v).J q_i}.

Using (1), its square is

    (p^2+r^2q^2)/2 + r s p.Jq
       + (ir/2) theta_f^t[J tensor (sI-gamma_9)]theta_f,
    s=v^t gamma_9 v.                               (8)

One must not impose neutrality separately in every root
plane. Sum the orbital terms in (8) first. Their generator
is the single central color sum_j(v^t gamma_j v)c_j.
The actual central-torus Gauss identity cancels precisely
the scalar-spinor part. Thus on the full neutral space

    E_v(c)^2 = H_osc(c)
       -(i/2)theta_f^t[ad(c_j)|_n tensor gamma_j]theta_f.       (9)

There are no cross terms from distinct root planes, since
their Clifford generators anticommute and their bosonic
operators commute. Each plane has sixteen real bosonic
coordinates and bosonic ground energy 8r. Its sixteen
complex fermion modes have unique minimum energy -8r,
with eight modes filled and eight empty. The resulting
vacuum is central-neutral. All occupation contributions
above it are nonnegative, so the zero line is unique and
the next eigenvalue of the square is at least the minimum
center distance. Restriction to neutral vectors cannot
lower that positive bound.

For a finite oscillator order s use the number-operator
space W^s with norm ||(1+N)^(s/2)u||. Equation (9) yields

    ||p_t u||+||t u|| <= C (||E_v(c)u||+||u||),
    (E_v(c)-zeta)^-1 : W^s -> W^(s+1)

on a small circle enclosing zero alone. The latter follows
by writing the resolvent as (E+zeta)(E^2-zeta^2)^-1:
the first factor loses one oscillator order and the second
gains two. Uniformity follows from compact collision-free
center support and compactness of the unit-spinor sphere.

The exact coefficient formula in Section 3 gives
||E_v(b)-E_v(c)||_(W^(s+1)->W^s) <= C_s |b-c|.
The central torus fixes b, so every such operator preserves
the same neutral Hilbert space, even for noncommuting
internal b. A resolvent Neumann series, for any prescribed
finite list of orders, gives a smooth rank-one Riesz
projection P(b). Symmetry on the common W^1 domain and a
relative bound less than one give self-adjointness.

The projection is even and its range has the same parity
as the scalar vacuum. To check that parity, in a last-six
spatial direction the fast fermion ground complex
structure anticommutes with the exterior complex
structure T. Its annihilator space is a graph over the
old one, with invertible projection; its vacuum has
nonzero degree-zero coefficient and only even degrees.
Parity then persists over the connected center-direction
space. Since E is odd, an invariant one-dimensional
even spectral range has eigenvalue exactly zero, not
merely a small perturbed eigenvalue.

The complementary inverse G is odd, uniformly bounded
W^s -> W^(s+1), with the same prescribed finite parameter
derivatives. This follows by differentiating the resolvent:
each derivative inserts a first-order coefficient
derivative between two resolvents. One fixes a sufficiently
large finite order at the start; no assertion of a single
Neumann radius valid for all s is needed.

### 5. Phase, gauge equivariance, and diagonal compression

The scalar spin ground line is homogeneous over S^8.
The orthogonal Spin(9) action on the fast generator
space lifts to its Clifford spin module because
Spin(9) is simply connected; the action is honest,
not merely projective.
Its Spin(8) stabilizer acts by a continuous character;
the derivative of such a character vanishes on the
perfect Lie algebra, and connectedness makes the
character trivial. Thus Spin(9) transport defines a
unit section. Its Berry form is an invariant one-form
on S^8; the stabilizer has no invariant tangent covector,
so that form is zero. The normalized positive real
Gaussian contributes zero as well.

In last-six directions choose positive overlap with the
empty T-vacuum. Block transformations and block
permutations preserve that empty vector. Fast pair
vacua are even, so reordering them contributes no sign.
The equivariant scalar section therefore has no
extra block character. The permutation and
Spin(3)xSpin(6) phase ratios are locally constant
because the Berry form is zero. Collision-free
labeled center space is connected (the removed
linear collision spaces have codimension nine);
agreement in last-six directions proves agreement
everywhere.

Write xi_0(c) for this scalar section and choose

    chi(b)=P(b)xi_0(c(b))/||P(b)xi_0(c(b))||.

The denominator stays positive on a smaller chart.
This is K_0-equivariant, including its internal block
action. In internal directions at b=c the scalar
section is constant and P(dP)P=0, so its Berry form
also vanishes in those directions.

It remains to check the gauge-spin/density cancellation
for an arbitrary slow color q, not just central q.
On each cross-block real space put K_q=ad(q)|_n
and K_e=delta J. K_q preserves that space and is
real skew. The fast two-point function has scalar
part (1/2)I and imaginary part with color factor J.
The latter gives

    Tr(J K_q K_e^-1)
       = -delta^-1 Tr(J K_q J)
       = delta^-1 Tr K_q = 0.                      (10)

The second equality only uses cyclicity and J^2=-I.
It does not assume q is central.

For the mixed real contraction, the fast/slow block
of ad(w_A) is [w_A,q]=K_q K_e^-1 n_A. Ordering
the fast fermion before the slow fermion combines
the two mixed entries to twice this coefficient.
The CAR scalar contraction is 1/2. The compressed
orbit-spin term is consequently

    -(i/2) Tr_n(K_e^-1 K_q) theta_s^q(A_e).         (11)

Jacobi's determinant derivative applied to (6)
gives d_q log j=Tr_n(K_e^-1 K_q), so (7) cancels
(11) exactly. This includes all internal traceless
colors.

All other diagonal terms vanish: a fast odd
operator has zero expectation in the even fast
line; the slow-color [t_i,t_j] term contracts a
symmetric Gaussian color covariance with an
antisymmetric color bracket; and the Berry
term is zero as above. If R_0 is R with its
fast mass and h^-1/2 t p_b terms removed, set

    A(b) = -i sum_(i,Q) theta_s^Q(A_i) partial_(b_i^Q)chi(b)
             + R_0(b)chi(b).

It is a smooth odd oscillator-vector map, with
bounded prescribed oscillator norms and parameter
derivatives, and

    P(c)A(c)=0,
    ||P(b)A(b) f_h|| <= C ||xi f_h|| -> 0.         (12)

### 6. The graded inverse and all correction estimates

The exact uncorrected output follows from Sections 2--5:

    D_v(h,m)(chi(b) f_h)
       = chi(b)(D_v^C(m)f)_h + A(b) f_h + o_L2(1). (13)

The omitted internal undeformed outputs are (3).
The internal mass term is O(m||xi f_h||).
The fast mass term is O(m/sqrt(h)). The removed
slow-derivative remainder is bounded by
C||p_b f_h/sqrt(h)||+O(h^-1/2), using oscillator
moments. Thus (13) is a norm assertion, not a
formal expansion or a weak-convergence argument.

Put V=(1-P)A and W=G V. On the full graded
module E=Gamma_s tensor e_f, so
G=Gamma_s tensor g_f. In particular E W=V
exactly, and W is even since G and V are odd.
Dropping Gamma_s would give the wrong sign on
odd slow vectors; the manuscript does not drop
it. The certificate includes this contrast
without calling it a manuscript error.

For any smooth oscillator-vector map M with the
required finite norms and first derivatives,
the product rule and pointwise finite Clifford
matrix bounds give

    ||h^-1/2 D_v^s(h,m)(M f_h)|| <= C_M {
       ||p_b f_h/sqrt(h)||
       + sum_(i<j)||sqrt(h)[b_i,b_j] f_h||
       + h^-1/2(1+m)||f_h|| }.                    (14)

M need not preserve an internal kernel and need
not commute with slow Clifford multipliers.
The bracket contribution is bounded pointwise
by its scalar bracket size times ||M||; it is
not simplified using a kernel equation after
M acts. This is the reason the separate estimate
(5), rather than only D_v^s f_h small, is needed.
Every term on the right of (14) tends to zero.

For the remainder of the correction, the explicit
list in Section 3 and the oscillator norms give

    ||h^-1/2 R_v(W f_h)|| <= C {
        h^-1/2(1+m/sqrt(h))||f_h||
        + h^-1 ||p_b f_h|| } -> 0.                (15)

The derivatives in the last term can hit W or
f_h; the first case is absorbed by the displayed
bounded term. No unbounded global derivative
of an internal kernel is used.

Define

    I_h f = chi(b) f_h - h^-1/2 W(b) f_h.

Its fast correction output is exactly -V f_h.
Equations (12)--(15) prove

    D_v(h,m) I_h f = chi(b)(D_v^C(m)f)_h + o_L2(1). (16)

The correction has norm O(h^-1/2).
The difference chi(b)-chi(c) is at most C|xi|
as an oscillator L2 map, so (5) permits its
replacement in both the state and (16). This
proves both claimed norm limits locally.

### 7. Physical domain and transverse cutoffs

All slow supports lie in the interior of a
spectral-window chart. Choose a fixed physical
transverse cutoff tau(z), equal to one near zero.
Its deleted tail has |t| >= a sqrt(h).
A fixed sufficiently high oscillator moment of
chi and W makes that tail tend to zero.
Equation (16) gives the same conclusion for
the charge output: its leading target has
uniform oscillator tails and its error already
tends to zero in full L2 norm.

The commutator of the ambient charge with tau
is a bounded Clifford multiplier, independent
of h and m, supported on that deleted tail.
It therefore tends to zero on I_h f.
Local H1 regularity, smooth slice coefficients,
and compact physical cutoffs put the resulting
state in the maximal domain. Extend by gauge
equivariance and by zero only where the
cutoffs have already vanished. Section 2 then
places it in the actual invariant graph
domain; gauge-averaged smooth compact
approximations are available. This step
requires no behavior of an uncut kernel at
large internal y.

### 8. Chart changes, finite families, and symmetries

For a second separating axis, solve its
off-block slice equation by an off-block gauge
generator w(b,z)=O(|z|), using the uniformly
invertible spectral-gap differential.
Since [n,k_0] is off-block, the block change
has no linear term in z:

    b'=b+O(|z|^2),       z'=L_b z+O(|z|^2).

On bounded rescaled |y|,|t| <= M this gives

    h^(1/3)(b'-b)=O_M(h^-2/3),
    t'=L_c t+o(1),       c'=c+O_M(h^-1).

The gauge spin action tends to identity.
The positive density factors in (6), the
fixed orbit-volume factor, and the Jacobian
of L_c are precisely the unitary change
between transverse slices. They therefore
identify the same normalized Gaussian.
The spin factor agrees by Section 5.

For smooth compact internal approximants
these facts give strong convergence on
bounded rescaled sets. For an arbitrary
fixed L2 internal tensor, approximate in
L2 by such functions. Unitary coordinate
changes and bounded cutoffs control the
approximation error uniformly; uniform
oscillator tails remove the t truncation.
This approximation is used for norm
transport only, not for the kernel energy
estimate, so the approximants need not be
kernel vectors. Apply the same argument
to D_v^C(m)f, whose internal factors are
unchanged.

A finite partition of unity lambda_nu(c)
on the center support now glues local
lifts of lambda_nu f. Their outputs sum
to the required target because
sum_nu D_v^C(m)(lambda_nu f)=D_v^C(m)f;
the derivative terms cancel by
sum_nu d lambda_nu=0.
Finite block permutation averaging gives
the specified quotient convention.
Common cutoffs and charts may be chosen
for a fixed finite-dimensional test
space, making the construction linear
there and the limits simultaneous.

The fast phase has no additional scalar
character. The only internal transport
is therefore the usual graded
permutation. Fixed Spin(3)xSpin(6)
transformations give the same leading
identification, with the charge spinor
transformed from v to gv. The same-charge
assertion applies when g fixes v.
No uniform assertion over all rotations
or a growing mass is needed or claimed.

### 9. Inner products and distinct partitions

The unitary internal rescalings, normalized
fast line, positive fixed orbit-volume
normalization, and finite-permutation
quotient measure give the profile inner
product for leading states in the limit.
Polarization and the two norm limits
give the stated leading/output and mixed
inner products.

For different unordered partitions,
collision-free compact center supports
are disjoint compact subsets of the
commuting gauge quotient. Their physical
internal measures concentrate at zero
and their transverse measures at z=0.
Choose disjoint neighborhoods of those
supports. The complements have norm
tending to zero, for both leading states
and targets in (16), so Cauchy--Schwarz
gives all claimed cross-partition
orthogonalities. This completes the
original quantified proposition.

## Focused prior-art comparison

Primary source read:
Lin--Yin, *On the Ground State Wave Function
of Matrix Theory*, arXiv:1402.0055v2,
https://arxiv.org/html/1402.0055v2,
Section 2.1, Section 4.1 equations (4.1)--(4.5),
and Section 5. Its setup expands near a
generic Coulomb-branch point with massive
off-diagonal variables. Equation (4.2)
obtains a first correction using the
inverse fast Hamiltonian and fast charge,
plus a fast-kernel term. Section 5
explicitly distinguishes the asymptotic
construction from determining a global
ground state.

That is genuine prior art for the
inverse-correction algebra. It is not
a cited theorem establishing the present
two norm limits for arbitrary actual
internal L2 kernel tensors in proper
nonabelian clusters. The additional
mathematical content verified here is
(4)--(5) and its use in (14)--(16),
together with the noncommuting-block
fast projection and full graded
inverse. This focused comparison does
not establish originality against all
literature, and no such claim is made.

## Reproduction and limitations

From the campaign directory run

    $WORKSPACE/argus-live-update/.venv/bin/python \
        research/cluster_lift_audit/verify.py

or, from any directory,

    $WORKSPACE/argus-live-update/.venv/bin/python \
        families/270/first-pass/cluster_lift_audit/verify.py

The script uses only the Python standard
library and compares its derived exact
answer with `exact_certificate.json`.
It replays the archived typed Jacobian
request and output; it does not require
a live adapter. The live bounded run
used the inspected operation
`matrix.symbolic.characteristic_polynomial.compute`
on the SU(3) (2,1) off-block matrix with
frequencies r+u and r-u. Its answer is

    det(lambda I-K_e)
      = lambda^4+2(r^2+u^2)lambda^2+(r^2-u^2)^2.

The density is consequently
(r^2-u^2)^2 in |u|<r. The exact payload,
operation id, protocol, server version,
typed result and measured adapter
runtime are in `jacobian/output.json`.
There was no timeout, UNKNOWN answer,
or transport error in that run.

The SU(3) calculations are falsification
probes for normalization and internal
color cancellation. The general
claims are justified by the preceding
algebraic identities and analytic
proof, not by extrapolating these
probes. No oscillator truncation,
numerical spectrum, Lean compiler
verdict, independent Reviewer verdict,
novelty certification, or proof of
either main spectral theorem is
claimed by this script.
