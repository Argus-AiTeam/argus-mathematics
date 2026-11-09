# Arbitrary indexed centers: verification of the pattern-tail mechanism

## Scope and prior results

The target is `prop:pattern-tail` in the staged translative manuscript,
`build/sections/07-targets.tex`. The parameters are exactly those in
`02-construction.tex`: eps = 2^-30, a = 1 + eps, D = 2^-10,
v = 1/64, eta = n^-4, b = a(1+1/n), and
gamma = log(4) - 2 log(1+D/a). Center lists are indexed, with repetitions.
All asymptotic thresholds below are independent of the list and of R in
the stated range.

The existing project ledger initially contained only the campaign objective,
with no earlier proof or certificate to improve on. A targeted search of the
inherited Wiki found no prior treatment of this cap-block-tail argument.

Primary sources opened during scope:

1. H. Li and X. Liu, *Nearly Sharp Bounds for Lattice Coverings by Convex
   Bodies*, arXiv:2607.28429v2, Theorem 1.3. It proves an order n log n
   lower bound for single-lattice covering density. This is a comparator,
   not an assumption that excludes arbitrary unions of lattice cosets.
   Source: https://arxiv.org/html/2607.28429v2 .
2. S. Janson and L. Warnke, *The lower tail: Poisson approximation
   revisited*, arXiv:1406.1248v1, Introduction, definitions preceding
   equation (2), and equation (2). The family is indexed; its ordered
   dependency quantity includes its mean as the diagonal contribution.
   Source: https://arxiv.org/html/1406.1248 .
   The proof below derives the weaker constant needed here independently.

The lattice-only route does not settle the live question: taking an infimum
over more permitted center arrangements reverses the useful lower-bound
comparison. A second-moment argument alone also does not supply the required
doubly exponential upper bound on the zero-witness probability. Neither
shortcut is used.

## Verification theorem and its boundaries

**Theorem.** With the exact parameters and pattern family above, there are
absolute positive constants c0, Ctail and n0 such that, for every integer
n >= n0, every real 1 <= R <= c0 n log n, and every indexed P in F_n,

    Pr[B_D is covered by the translates p + K^+, p in P]
      <= exp(-exp(gamma n - Ctail log n)).

The constants are independent of P, its repetitions, its length, and R.
One may take the explicit polynomial-loss constant Ctail=17/2.
The proof below supplies the whole cap-block-Poisson-target implication;
it does not assume the desired inequality or a lattice-only substitute.
It is a mathematical verification, not a finite experiment. Its finite
matching core is additionally formalized in Lean. The remainder is a
human-readable analytic proof, not a claim of full kernel verification.
Independent Reviewer acceptance and the publication/novelty assessment
are still outstanding.

The proof does not certify the companion single-lattice upper-bound
manuscript, periodization, or the complete translative main theorem.
For the present proposition, deterministic localization is needed only
through the definition of F_n: membership gives the good-set volume and
the residual budgets directly. We also derive the required length bound
from the defining N_n, so no localization theorem is assumed.

### 1. Uniform deterministic inputs

Write lambda0 = log(1+D/a), and C_loc = 1000/v. By definition of F_n,
each P has length at most

    N_n = ceil[(20 R/v) ((D+b+5 eta)/a)^n].

For n>=2,

    ((D+b+5 eta)/a)^n
      <= (1+D/a)^n exp(1+5/n^3)
      < 9 exp(lambda0 n),

because b/a = 1+1/n, eta = n^-4, and e^2<9. Hence, for
1<=R<=n^2 and n>=11521,

    N_n <= (20*9/v+1)n^2 exp(lambda0 n)
         = 11521 n^2 exp(lambda0 n) <= n^3 exp(lambda0 n).

Thus k0=3 is an explicit choice, independent of R.
For every y in G_P, all relevant indexed residuals x_i = y-p_i obey

    a(1-10 log n/n) - 2 eta <= |x_i| <= b+3 eta,
    m_y <= 2 C_loc R,
    sum_i [1+n(1-|x_i|^2/a^2)_+] <= 2 C_loc R.              (1)

The good set is measurable and has volume at least |B_D|/4.
For large n, its residual lower bound is positive. If a point in it
has no relevant residual, coverage is impossible deterministically.
Otherwise all its relevant lists are nonempty. Our eventual range of R
is contained in [1,n^2], and 2 C_loc R <= n^2 eventually.
No distinctness of the centers was used.

### 2. Cap geometry with the original projective angles

This paragraph proves the inputs rather than importing a common-lens or
affinity assertion from the lattice-only literature. Fix a in (1,2), and
fixed shell parameters A,Q. Put t_* = 1/a and

    F_n(t) = k_n integral_t^1 (1-z^2)^((n-3)/2) dz.

For all sufficiently large n and 0<t<1, substitution z -> 1-z^2 gives

    k_n/(n-1) (1-t^2)^((n-1)/2)
      <= F_n(t)
      <= k_n/[(n-1)t] (1-t^2)^((n-1)/2).                 (2)

Differentiation therefore bounds -d log F_n(t)/dt between
(n-1)t/(1-t^2) and (n-1)/(1-t^2).
For a residual and a threshold perturbation of size at most Q n^-4,
put tau_i = (1+epsilon_i)/|x_i|. Its double-cap intensity is
c_i = F_n(tau_i)/F_n(t_*). All thresholds lie in
J = [t_*/2,(1+t_*)/2] eventually, and

    tau_i = t_* + O_(a,A,Q)(log n/n),
    tau_i >= t_* - C_a/n.

The derivative bound on J is at most C_a n. It proves

    n^-P0 <= c_i <= C_a,
    s_i := -log min(c_i,1/2)
       <= C_a [1+n(1-|x_i|^2/a^2)_+].                    (3)

Here P0 depends on a,A. The constants C_a do not depend on Q or A:
their contributions are absorbed by the starting dimension.

For ordinary half caps with thresholds tau, upsilon and axis angle
theta, their intersection is contained in the bisector cap of threshold
q = (tau+upsilon)/(2 cos(theta/2)); it is empty if theta=pi or q>=1.
For q<1, use (2), and put f(t)=log(1-t^2). The bound on f'' on J gives

    f((tau+upsilon)/2) - [f(tau)+f(upsilon)]/2
       <= C_a (tau-upsilon)^2.

Also

    (1-q^2)/(1-((tau+upsilon)/2)^2)
       <= exp(-c_a theta^2).

Since n(tau-upsilon)^2 tends to zero uniformly in the fixed shell,
these estimates give a dimension-independent bound
F_n(q)/sqrt(F_n(tau)F_n(upsilon)) <= C_a exp(-c_a n theta^2).
Summing the four signed pairs proves the same bound at projective
angle phi, with denominator sqrt(c_i c_j). Clipping the intensities
costs a bounded factor by (3). Independently, the intersection is at
most the smaller raw intensity, giving

    mu(C_i intersect C_j)/sqrt(bar_c_i bar_c_j)
       <= C_a exp(-|s_i-s_j|/2).

Take the geometric mean of the last bound and the angular bound. The
pseudometric

    d(i,j) = sqrt(n) angle(x_i,x_j) + sqrt(|s_i-s_j|)

then satisfies

    mu(C_i intersect C_j)/sqrt(bar_c_i bar_c_j)
       <= C0 exp(-kappa d(i,j)^2).                       (4)

Projective angle is a quotient metric, and sqrt(|s-t|) satisfies the
triangle inequality, so this remains a pseudometric on repeated labels.

For the common lens, let r(S)=min_j max_i d(i,j)^2 and choose a
raw-minimum-intensity anchor i0. It has the largest threshold tau0.
After orienting every axis toward that anchor, its angle is at most
Phi = 2 sqrt(r(S)/n). Conditional on u.e0=t, write
u=t e0+sqrt(1-t^2) W with W uniform on S^(n-2).
For W uniform on S^(d-1), its even moments satisfy

    E W_1^(2j) = (2j-1)/(d+2j-2) E W_1^(2j-2)
               <= (2j)!/(2^j j! d^j).

Expansion of the moment generating function and Markov's inequality give
Pr(W.v < -h) <= exp(-d h^2/2). With

    h = sqrt(2 log(2|S|)/(n-1)),
    delta = 2 Phi^2 + 4 Phi h,

the probability that every tangent scalar product is at least -h is
at least 1/2. If t>tau0+delta, then

    u.e_i > tau0 - Phi^2/2 + delta/2 - h Phi >= tau_i.

For r(S)<=B0 log n and |S|<=n^2, tau0+delta belongs to J eventually.
Consequently (2) and its derivative bound imply

    mu(intersection_(i in S) C_i)
      >= c_i0/4 exp(-C_a n delta)
      >= bar_c_i0 exp[-L(1+r(S)+log|S|)].                (5)

The inequality n delta <= C(r+sqrt(r log(2|S|))) makes L depend only
on a, not on B0, A or Q. Those constants change only the dimension
threshold. The case r=0 has Phi=delta=0 and is included. This
independence is what allows the block cutoff to be chosen later.

Finally eps=2^-30 gives

    cos(2 sqrt(eps)) <= 1-2 eps+(2/3)eps^2
                     < 1-eps <= 1/(1+eps).

Since tau_i >= 1/a-C_a/n, each signed half-cap has angular radius
strictly below 2 sqrt(eps) eventually. At projective separation
greater than 4 sqrt(eps), all signed intersections are empty.
Both angular scales are exactly those of the manuscript.

### 3. Terminal blocks, including coincident anchors

We prove the abstract block construction using (4)-(5). Set zeta=1/10,
R_*=B0 log n, and ell(S)=0 for a singleton and
L(1+r(S)+log|S|) otherwise. Starting from singletons, merge any
subfamily of at least two blocks whose union W has r(W)<=R_* and
ell(W)<=zeta|W|. There are at most m-1 mergers. At termination every
block satisfies these bounds, and no subfamily remains mergeable.

For each block S choose a raw-minimum anchor i(S). The triangle
inequality through a radius-minimizing index gives

    d(i,i(S)) <= 2 sqrt(r(S)) <= 2 sqrt(ell(S)/L).

Atomlessness and (5) permit a measurable common subset E_S of exact
intensity lambda_S = exp(-ell(S)) bar_c_i(S). In the actual sphere
space, exact subsets can be chosen by a coordinate threshold: level
sets of a fixed coordinate have zero surface measure, and the
restricted cumulative measure is continuous. For a singleton use a
subset of C_i of measure bar_c_i. All selections precede the process.
Put q_S=-log lambda_S. Since the anchors are different labels,

    sum_S q_S <= sum_i s_i + zeta m,    q_S >= log 2,
    lambda_S >= n^-K bar_c_i(S),        lambda_S <= 1/2,       (6)

with K=L(B0+3). In particular
sum_S log(1+lambda_S^-1) <= C(m+sum_i s_i).

Here is the row bound without a hidden distinctness assumption. For
z in the original indexed list, count terminal blocks with

    d(z,i(S))^2 <= t,   ell(S)<=u,   8t+8u/L<=R_*.

If h such blocks have union W of size N, then N>=h and
r(W)<=8t+8u/L. Choose a fixed N0 with
L log N <= zeta N/2 for N>=N0. If simultaneously
h>=N0 and h>=2L(1+8t+8u/L)/zeta, the whole union would be
mergeable. Thus the count is at most C_ct(1+t+u), regardless of
block sizes or coincident pseudometric anchors.

Define the normalized off-diagonal row weights

    w_ST = mu(E_S intersect E_T) /
       sqrt(lambda_S(1+lambda_S)lambda_T(1+lambda_T)).

Their two bounds are

    w_ST <= exp(-|q_S-q_T|/2) <= 1,
    w_ST <= C0 exp((ell(S)+ell(T))/2-kappa d(i(S),i(T))^2).

In the bin exp(-(k+1))<w_ST<=exp(-k), put Q_S=q_S+k+1.
Then ell(T)<=2Q_S and d(i(S),i(T))^2<=A1 Q_S, with
A1=(log C0+2)/kappa. Let delta0=1/max(1,8A1+16/L).
If Q_S<=delta0 R_*, terminal counting bounds the bin size by
C1(q_S+k+1). All constants so far are independent of B0.

Now fix B0>=max(1,6/delta0), and increase the dimension so
R_*>=4/delta0. If q_S<=delta0 R_*/4, sum the bounded bins up
to floor(delta0 R_*/2). Their row weight is at most C(1+q_S).
Every remaining weight is at most exp(-delta0 R_*/2), so their
total is at most n^2 exp(-delta0 B0 log n/2)<=1.
If q_S>delta0 R_*/4, instead use
log(1+sum_T w_ST)<=log(1+n^2)<=3 log n<=C q_S.
Thus, in both cases,

    sum_S log(1+sum_(T != S) w_ST) <= C(m+sum_i s_i).     (7)

This proves every needed block estimate. In particular a list with
many repeated caps is not incorrectly assigned independent slots:
terminal merging absorbs large nearby collections, and the count
above also counts coincident anchors.

### 4. All-finite matching theorem and ordered diagrams

Let h_ij=mu(E_i intersect E_j)/(lambda_i lambda_j) and
delta_i=1+lambda_i^-1. A directed partial matching between two
copies of the labels has at most one incoming and one outgoing edge
at a vertex. Fix its off-diagonal edges P. A diagonal loop is
available exactly at vertices not incident to P. Summing all such
loops multiplies by product_(i not incident) delta_i.

For arbitrary a_i>=1 and w_ij>=0, not necessarily symmetric, the
following all-finite algebraic statement holds:

    sum_(directed partial matchings)
       product_(loops i) (a_i^2-1)
       product_(off-diagonal (i,j)) (w_ij a_i a_j)
      <= product_i a_i^2 product_i (1+sum_(j != i) w_ij).   (8)

This is the principal theorem of `Main.lean`. To see its normalization,
the source labels and target labels of P are each injective. Since
a_i>=1, each of their a-products is bounded by the a-product on their
union. Therefore product_(i,j in P) a_i a_j is at most the product
of a_i^2 over the incident vertices. The diagonal completion supplies
the remaining vertices. Sum over the off-diagonal row choices and drop
the distinct-target restriction. The unrestricted sum factors into the
row product on the right of (8).

Taking a_i=sqrt(delta_i) and
w_ij=h_ij/sqrt(delta_i delta_j) gives exactly the normalized row
weight in (7), with diagonal loop weight h_ii=lambda_i^-1.
The matching polynomial includes the empty term 1 and every full
matching. Thus, for activity nu=product_i lambda_i,

    1+D_yy/nu_y^2
       <= product_i (1+lambda_i^-1)
          product_i (1+sum_(j != i) w_ij).                (9)

No symmetry hypothesis is needed for the finite algebra. The
substitution uses ordinary real square-root identities for positive
lambda; those identities and the Poisson interpretation are not part
of the formalized statement.

For two different lists, dropping every restriction on the nonempty
cross-edge set gives

    D_yz/(nu_y nu_z)
       <= product_(i,j)(1+h_ij)-1
       <= exp(sum_(i,j) h_ij)-1.                         (10)

The powerset bound and removal of the empty term are also proved in
Lean. The last inequality uses 1+t<=exp(t) for t>=0.

For a concrete repeated-slot check, take three labeled slots equal to
one set of intensity 1/3. Their matching counts by size are
(1,9,18,6), not (1,3,3,1). The six full matchings include the
identity and five nonidentity permutations. Their normalized
self second moment is 1+9*3+18*9+6*27=352, while (9) gives
4^3(1+2*3/4)^3=1000. The activity is (1/3)^3=1/27 without
division by 3!. The bounded Jacobian K_3,3 operation independently
returns the same matching coefficients. This experiment supports the
encoding; it does not replace (8).

### 5. Indexed Janson and the nonatomic Poisson limit

For independent Bernoulli coordinates, let I_i be the indicator that
all coordinates in a nonempty support H_i are 1. Indices with equal
supports remain separate. Put m=sum E I_i, and let Delta_off be the
ordered off-diagonal sum of E(I_i I_j) over intersecting supports.
Harris's correlation inequality follows by induction on the coordinate
count: the extra conditional covariance is
p(1-p)(f_1-f_0)(g_1-g_0)>=0 for increasing functions.

For index i, let F_i exclude earlier disjoint-support events and
G_i exclude earlier intersecting-support events. The first is independent
of I_i and decreasing. Harris and the conditional union bound give

    Pr(I_i=1 | F_i intersect G_i)
       >= Pr(I_i=1 intersect G_i | F_i)
       >= E I_i - sum_(j<i, H_i intersects H_j) E(I_i I_j).

If an avoidance denominator vanishes, the zero-event probability is
already zero. Otherwise multiply the conditional avoidance probabilities,
using 1-x<=exp(-x), to obtain
Pr(sum I_i=0)<=exp(-m+Delta_off/2).

Attach a different private Bernoulli(q) variable to every event.
The old zero event implies the thinned zero event; the new mean is
qm and new ordered off-diagonal sum is q^2 Delta_off, even for
repeated original supports. Set Delta*=m+Delta_off and q=m/Delta*.
Since Delta*>=m>0, 0<q<=1, and direct algebra gives

    -qm + q^2(Delta*-m)/2 <= -m^2/(2 Delta*).             (11)

This algebra is proved in Lean. The finite indexed Janson bound,
including its diagonal mean, follows. This argument does not depend
on the external Janson citation.

Now consider finitely many nonempty labeled slot lists in a finite
nonatomic standard Borel Poisson space (Omega,mu). Conditioning on its
total number of points proves

    E Z_y = nu_y = product_i lambda_yi.

There is no factorial divisor for equal slot sets: these are injective
assignments to labeled slots. In a pair of injections the shared points
determine one unique partial matching of slots. Poisson factorial
moments therefore give

    E(Z_y Z_z) = nu_y nu_z + D_yz,                       (12)

where D is the sum over all nonempty partial matchings.

Here are the details ensuring that the finite lower tail passes to this
model. Partition the Boolean atoms of the finitely many slots into
measurable cells of measure at most delta. Their occupation indicators
are independent Bernoulli variables of parameter p_C=1-exp(-mu(C)).
Writing a_C=mu(C), we have
0<=a_C-p_C<=a_C^2/2<=delta a_C/2.
For any fixed cell-union list F_1,...,F_r, let Q_delta sum
product_v p_Cv over distinct cells C_v contained in F_v. Telescoping
the unconstrained product and then union-bounding repeated cells gives

    0 <= product_v mu(F_v)-Q_delta(F_1,...,F_r)
      <= delta [(r/2) product_v mu(F_v)
          + sum_(v<w) mu(F_v intersect F_w)
                         product_(u != v,w) mu(F_u)].    (13)

The repeated-cell bound uses sum_C p_C^2<=delta mu(F_v intersect F_w).
There is no division by a slot intensity, so null intersections cause
no exception.

Index every internally injective assignment of occupied cells to slots.
Distinct assignments with the same underlying set of cells remain
separate Bernoulli events. For two assignments their exact cell-equality
relation is a unique partial matching. Identifying its paired slots and
requiring distinct cells for the resulting classes gives exactly the
Q_delta term in (13). Hence the finite mean converges to sum_y nu_y,
and its ordered dependency sum, INCLUDING all identical assignment pairs,
converges to sum_(y,z) D_yz. Full nonidentity matchings for repeated
slots are separate terms, not omitted diagonals.

If tau=mu(Omega), the probability that a cell contains two points is
at most sum_C a_C^2/2<=delta tau/2. Off that event, point and cell
injections are in bijection for all lists simultaneously. The zero-event
probabilities therefore converge. Apply the finite bound and let delta
tend to zero for this fixed finite family:

    Pr(Z_y=0 for all y)
      <= exp[-(sum_y nu_y)^2/(2 sum_(y,z) D_yz)].         (14)

The denominator is positive: the full identity matching at each y
contributes nu_y. This limit is taken separately at each dimension.
Neither the number of targets nor the total spherical intensity needs
a dimension-uniform cell approximation.

### 6. Uniform witnesses and both cross-angle interfaces

Equations (1) and (3) give m_y+sum_i s_yi<=A0 R for fixed A0.
Apply the terminal construction separately to each residual list,
before sampling the process. Equations (6), (7) and (9) yield fixed
A,C_*>0 with

    exp(-AR)<=nu_y<=1,    D_yy<=nu_y^2 exp(C_*R).         (15)

The shell lower bound gives bar_c_i>=n^-P0; the block cutoff gives
lambda_S>=n^-P1 bar_c_i(S), for fixed P0,P1. For a cross pair of
blocks, (4) consequently gives

    mu(E_yS intersect E_zT)/(lambda_yS lambda_zT)
       <= C n^(2P1+P0)
                  exp[-kappa' n angle(x_y,i(S),x_z,i(T))^2].

There are at most n^4 block pairs. Fix H with
kappa' H^2>9+2P1+P0. At cross-residual angles strictly greater than
H sqrt(log n/n), the sum in (10) is <=n^-4 eventually. Therefore

    D_yz <= n^-3 nu_y nu_z.                              (16)

At angles strictly greater than 4 sqrt(eps), the cross intersections
are empty, so D_yz=0 exactly. Applying the cap estimate to the two
anchors is legitimate without putting both full lists in a single
list of length at most n^2.

A positive injection cuts every relevant residual by a strict slab
inequality. Every other center is excluded by the outer ball. Thus
Z_y>0 implies that y is not covered. Empty lists were already handled.
This implication retains all repeated centers; it never replaces a
list by an independent model.

### 7. Two-scale targets for an arbitrary indexed pattern

For independent uniform Y,Z in G_P, condition on Y and on a center
pair p,q. If the two residuals have norm at most L0 and projective
angle at most xi, then Z lies in a cylinder around the affine line
q+R(Y-p), with transverse radius L0 sin xi. Both orientations belong
to this same cylinder. Its intersection with B_D has volume at most
2D omega_(n-1)(L0 sin xi)^(n-1). Division by |G_P| gives

    Pr(this center pair is xi-bad)
       <= 8 sqrt(n) (L0 sin xi/D)^(n-1).

Here omega_(n-1)/omega_n<=sqrt(n), from slicing the unit ball over
[-1/sqrt(n),1/sqrt(n)]. For large n, b+3 eta<=2. A union bound over
all N^2 ORDERED center labels therefore gives

    Pr((Y,Z) is xi-bad)
       <= 8 sqrt(n) N^2 (2 sin xi/D)^(n-1).              (17)

Repeated centers repeat events in this union; they cannot invalidate
it. Sample M=floor(exp(n log n/16)) independent uniform targets.
For xi=H sqrt(log n/n), the logarithm of (17) times binom(M,2)
is at most

    -(3/8)n log n + (1/2)n log log n + O_(H,k0)(n),

which tends to minus infinity. Thus no distinct target pair is fine-bad
with probability tending to one.

For xi=4 sqrt(eps), the exact relation 8 sqrt(eps)/D=1/4 gives

    f_n = 8 sqrt(n) n^(2k0) exp(2 lambda0 n) (1/4)^(n-1)
        = 32 n^(2k0+1/2) exp(-gamma n).                  (18)

The expected fraction of coarse-bad unordered pairs is at most f_n.
Markov's inequality bounds the probability of a fraction above 10 f_n
by 1/10. Both properties therefore hold simultaneously with positive
probability. The targets are distinct almost surely by atomlessness.
Fix one successful deterministic choice from P and G_P before exposing
the process. No relationship between the activity and the angle graph
is assumed.

### 8. Exact bin accounting and all-parameter asymptotics

Partition -log nu_y in [0,AR] into bins of length log 2, using at most
Q=1+ceil(AR/log 2) bins. A largest bin contains m>=M/Q targets with
activities in [nu,2nu]. The total number of coarse-bad ordered
distinct pairs in this bin is at most

    10 f_n M(M-1) <= 10 f_n Q^2 m^2.                    (19)

This permits every bad pair to fall in the chosen bin. From (15)-(16),
the full ordered dependency sum for this bin is at most

    4m nu^2 exp(C_*R) + 40m^2 nu^2 n^-3 Q^2 f_n.

The mean in (14) is at least m nu. Coverage forces every selected
Z_y to vanish. Consequently

    Pr(coverage)
      <= exp[-1/{8(exp(C_*R)/m+10 n^-3 Q^2 f_n)}].       (20)

Set c0=1/[64 max(C_*,1)]. Uniformly for 1<=R<=c0 n log n,
C_*R<=n log n/64 and Q<=C_Q n^2 eventually, for a fixed C_Q.
Since M>=exp(n log n/16)/2 eventually,

    exp(C_*R)/m <= 2 Q exp[-(3/64)n log n]
                <= exp[-n log n/32]                   (21)

for all sufficiently large n, independently of R. Combining (18)
with the other term in (20) gives the explicit bound

    10 n^-3 Q^2 f_n
       <= 320 C_Q^2 n^(2k0+3/2) exp(-gamma n).          (22)

The first term in (21) is at most exp(-gamma n) once log n>=32 gamma.
For n>=8(1+320 C_Q^2), the denominator in braces in (20), INCLUDING
its outside factor 8, is therefore at most

    n^(2k0+5/2) exp(-gamma n).

Taking reciprocals in (20) proves the theorem, with the explicit
permitted choice Ctail=2k0+5/2. Enlarging n0 absorbs every earlier
fixed threshold. This proves an all-parameter eventual statement,
not a calculation at one dimension.
In particular k0=3 gives Ctail=17/2 for the original F_n.

The order of choices is noncircular: fixed geometric parameters;
cap constants C0,kappa,L; terminal constants and B0; A,C_*,P0,P1,H;
c0; finally n0. No constant is chosen from the pattern or the sample.
Because log(1+D/a)<D=1/1024 and log 4>1, gamma>3 lambda0>0.

### 9. Structural extension beyond the rounding grid

The proof gives a strictly more general formulation without assuming the
desired tail. Fix any B>0 and k0>0. For every sufficiently large n,
let P be any deterministic finite indexed list of points in R^n, with
N<=n^k0 exp(lambda0 n); it need not lie on a grid. Suppose some
measurable G contained in B_D has volume at least |B_D|/4 and, at every
y in G, every residual has length at least r_--2 eta and

    sum_(i: |y-p_i|<=b+3 eta) w_a(|y-p_i|) <= B R.

This bounds the number of relevant residuals as well because w_a>=1.
Then there is c0=c0(B,k0)>0 such that, uniformly for
1<=R<=c0 n log n, the same coverage bound holds with
Ctail=2k0+5/2. All constants except this displayed Ctail may change
their dependence to the two fixed parameters B,k0.

Indeed sections 2-8 use only these properties of P and G. The larger
fixed B changes A0 and hence the block/witness constants and the starting
dimension; it does not change the rate gamma or the exponent arithmetic.
The original proposition is the case B=2 C_loc and k0=3.
This extension is **per deterministic list**. It does not assert that a
single random realization excludes every member of an uncountable
adaptive class; the original finite encoding remains necessary for that
separate conclusion.

## Evidence classification and remaining independent work

`Main.lean` proves (8), the exact loop summation, restricted cross-edge
products, and (11) for arbitrary finite types and real weights. It is
not a comparator formalization and does not assume (8) as a hypothesis.
Its exact scope is documented in `statement_fidelity.md`.

`verify.py` replays the rational matching and diagram fixtures, the
independent Jacobian coefficients, finite repeated-support probability
checks, cap-bound algebra, and the exact exponent/constant identities.
These checks support the proof but are not advertised as an exhaustive
search in dimension or as a machine proof of the analytic steps.

No false literal manuscript assertion was found in the argument verified
here, so no `F_*` refutation claim is warranted. The strongest comparison
settled during scope was a known single-lattice result; the present
mathematical improvement in verified scope is the full arbitrary-indexed-
center quantifier and the doubly exponential tail, with its ordered
self-overlaps and both original separation scales retained.

The Host-invoked Reviewer must independently check the analytic proof,
replay the standalone and Lean verifiers, and check the two primary-source
attributions. Their source passages are stored locally for that purpose.
Neither independent acceptance nor novelty/significance is self-awarded.

The authorized Lean run completed with exit code 0, `proof_holes=[]`,
and axiom-audit exit code 0 under Lean 4.31.0. Its archived claim
certificate is
`certificates/L_ACT_MATCHING_NORMALIZATION-18ecc622d0c4a8b3.json`.
The standalone replay passed 15,126 labeled matching enumerations,
912 normalized off-diagonal terms, 36 exact factorial-moment polynomial
identities, 2,800 indexed repeated-support Bernoulli families, and
584 cell-collision slot lists. None of those finite counts is being
used to replace an all-parameter proof.

Reproduction from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/certificates/arbitrary_center_tail/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/certificates/arbitrary_center_tail/Main.lean --statement-fidelity research/certificates/arbitrary_center_tail/statement_fidelity.md --claim L_ACT_MATCHING_NORMALIZATION --project-root .
```

After any ledger or graph change, both official campaign-local checks
must also pass, with project root
`campaigns/9000092`.
