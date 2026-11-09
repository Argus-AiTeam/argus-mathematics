# Permanence under bounded measurable kinetics

## Statement and scope

Let C be a finite set of complexes in N^d and R a finite set of directed
reactions, each admitting a directed return path. Allow isolated complexes,
disconnected linkage classes, and self-loops. For each reaction e fix
0 < l_e <= u_e < infinity. A schedule is any Lebesgue-measurable function
k_e : [0,infinity) -> [l_e,u_e]. The differential equation is

    x'(t) = sum_e k_e(t) x(t)^(source e) (target e - source e)

almost everywhere. Let S span the reaction vectors and
P = (c+S) intersect (0,infinity)^d, where c is positive.

The target is one nonempty compact convex K subset P, independent of the
schedule, strongly forward invariant for all schedules, with a unique
global positive Caratheodory solution from every positive initial state.
For every compact Q subset P, the entrance time into K must have a bound
independent of both the schedule and the initial state in Q. No assertion
about convergence to equilibrium or uniform initial-time bounds is made.

The independently reviewed claim C149_AFFINE and its existing certificate
are reused without modification. The affine family depends on the network,
not on the schedule or on individual reaction rates. The new argument must
replace everywhere-time right derivatives by almost-everywhere derivatives
and integral inequalities. The fixed-rate right-derivative arguments in the
staged manuscripts are not claimed to be incorrect in their stated setting.

## Primary-source boundary

The staged October paper, `trapping.tex`, Proposition `prop:plateau`,
Proposition `prop:increase`, and Lemma `lem:trapping`, and `permanence.tex`,
prove the geometric plateau and square-root-scale argument for fixed positive
rates. In particular, its class scale uses

    h^H sum_e k_e < min_e k_e.

The bounded-rate replacement is

    rho_h := min_e l_e - h^H sum_e u_e > 0.

The latter is only imposed when there is a reaction. Empty reaction sets and
zero stoichiometric subspaces are dealt with separately, without taking a
minimum over an empty set. A general time-varying right derivative is not
available. Sampling schedules or proving a cut inequality alone cannot
establish the target.

The shared Wiki index was searched for this campaign, mass-action kinetics,
and weak reversibility; it has no relevant entry. A generated web-search
summary supplied no verified primary proposition for the complete extension
and is not used as a citation or novelty evidence. Primary comparison and
the precise analytic inputs are recorded below as they are established.

## Theorem

The target stated above holds. More precisely, the construction below gives
one family of positive compact convex plateaux K_h and a scale h_P depending
only on the network, rate box, and representative c. The final set is

    K = K_(h_P) intersect (c+S).

For S={0}, including an empty reaction set or reactions consisting entirely
of self-loops, take K={c}: every solution is constant and T(Q)=0. Thus suppose
S is nonzero. In particular R and C are nonempty. Put

    l = min_e l_e > 0,    U = sum_e u_e > 0,
    N = max_(y in C) sum_i y_i.

### 1. One affine family and a fixed gap

Let D consist of the coordinate vectors and the nonzero differences of all
pairs of complexes, including pairs in different linkage classes. On the
cube [-1,1]^d define

    E(r) = min( {1/2} union
                {|r.v|/(2 ||v||_1) : v in D, r.v != 0} ).

This is pointwise positive; no continuity or positive global infimum is used.
Apply C149_AFFINE with a=-1, b=1. Write its fixed finite nonempty family as

    L_(lambda,h)(x) = r_lambda.x + b_lambda(h),
    F_h(x) = min_lambda L_(lambda,h)(x).

The uniform small-h consequence follows directly from the reviewed sequential
statement: otherwise choose h_n->0 with a violating active label and p_n in
the compact cube. Pass to a constant label subsequence and p_n->p. The
non-strict inequality ||p_n-r||_infinity >= E(r) passes to the limit and
contradicts the strict sequential conclusion. In particular this consequence
does not need regularity of b_lambda in h.

The finite family fixes the positive number

    H = min( {1} union
             {|r_lambda.v|/2 : lambda, v in D, r_lambda.v != 0} ).

For every sufficiently small h, let B_h=[h,h^(-1)]^d. If x=h^p is in B_h and
lambda is active, then for r=r_lambda and v in D,

    r.v != 0  implies  sign(p.v)=sign(r.v), |p.v| >= H.       (1)

Indeed |(p-r).v| < E(r)||v||_1 <= |r.v|/2. All quantities r, E, and H
were fixed before h and before any rate schedule. Consequently

    r.y < r.z  implies  x^z <= h^H x^y.                      (2)

Choose 0<h_P<1 so that for every 0<h<=h_P the activity bound holds,

    ||log c / log h||_infinity < H,
    h^H U <= l/2.

Choose it strictly below the activity threshold if that threshold is open.
These choices are possible since H>0. Define

    rho_h = l-h^H U >= l/2 > 0,
    delta_h = 2 H rho_h h^N > 0.                            (3)

The normalized margin in (3) is the universal inequality
1-eta in [1/2,1] for eta=h^H U/l in [0,1/2]. The inspected Jacobian
operation `polynomial.box.enclosure.compute` checks that entire symbolic
interval, not a sample network or sample schedule. Its exact input, output,
server version 0.14.0, protocol 2025-11-25 and successful adapter result
are retained in `jacobian-margin-*.json`. This simple auxiliary enclosure
is not offered as a proof of permanence; the general cut estimate is also
kernel checked.

### 2. Compact rate-independent plateaux

For every 0<h<=h_P, (1) at c forces each active slope to be zero: a nonzero
i-th coordinate would force |log c_i/log h|>=H. Hence an active constant
label supplies M_h=F_h(c), and F_h<=M_h on all of R^d. It is the least
of the constant-label values. Thus

    K_h = {F_h=M_h} = intersection_lambda {L_(lambda,h)>=M_h}

is closed, convex, and contains c. If x=h^p belongs to K_h intersect B_h,
that constant label is active. Its tolerance E(0)=1/2 gives ||p||<1/2,
so x is in int B_(sqrt h). In particular K_h misses the boundary of B_h.
If K_h had a point outside B_h, its segment with c would meet that
boundary while remaining in K_h, a contradiction. Therefore

    K_h is nonempty compact convex,
    K_h subset int B_(sqrt h) subset int B_h.                (4)

Here and in taking later extrema we use the elementary finite-dimensional
consequences of scalar Heine--Borel (Axler, Theorem 2.12). Indeed, a bounded
sequence has a convergent subsequence in its first coordinate, then in its
second, and so on through finitely many coordinates; a closed set contains
the resulting vector limit. This proves sequential compactness, equivalent
to compactness in these metric spaces. The continuous image of a compact
set is compact in R, hence closed and bounded and contains its supremum and
infimum. These observations also justify the extrema and compact-cube
subsequences used elsewhere in the proof.

These are geometric statements on R^d, independent of all kinetics.
For any compact Q in the positive orthant,
max_(x in Q,i) |log x_i| is finite. Choose h_0<=h_P sufficiently small
to make ||log x/log h_0||<H simultaneously for every x in Q.
The same zero-slope argument shows Q subset K_(h_0). The empty Q needs
no entrance argument and has T(Q)=0.

If x is in P but not K_h, a slope r in S-perp has
L_(lambda,h)(x)=L_(lambda,h)(c)>=M_h>F_h(x). Such a label cannot
be active. Thus every active label below the plateau in P is nonorthogonal
to S. This assertion requires the class restriction; it is not made on
the whole positive orthant.

### 3. Uniform strictness over the entire rate box

Fix h, x in B_h, an active r, and any rate vector k in the box. Order the
distinct levels r.y of complexes as a_1<...<a_m. Across cut j define Q_j
as upward reaction flux minus downward reaction flux. If any edge crosses,
there is an upward crossing: this is immediate for an upward edge, and a
downward edge has a return path which must cross upward. No connectivity
between different linkage classes is required.

Choose an upward crossing w->w'. Every downward source u satisfies
r.u>r.w, so (2) gives x^u<=h^H x^w. Therefore

    upward sum >= l x^w,
    downward sum <= h^H x^w sum_(down edges) u_e <= h^H U x^w,
    Q_j >= rho_h x^w >= rho_h h^N > 0.                     (5)

The degree bound follows from x_i>=h and y_i>=0:
x^w>=h^(sum_i w_i)>=h^N. If no edge crosses, Q_j=0. The calculation
allows an empty downward sum, isolated vertices, self-loops, tied levels,
parallel indexed reactions if desired, and multiple linkage classes.

For each edge the difference between its target and source levels is
the signed sum of the intervening consecutive gaps. Summing this exact
finite identity gives

    r.f_k(x) = sum_(j=1,...,m-1) (a_(j+1)-a_j) Q_j.          (6)

All terms are nonnegative. If r is not in S-perp, some reaction has
nonzero level difference, hence some cut is crossed. Each nonzero gap
between complex levels is >=2H by the definition of H. Equations
(5)-(6) imply

    r.f_k(x) >= delta_h > 0  if r is not in S-perp,
    r.f_k(x) >= 0            in all cases.                 (7)

There is no minimization over the space of measurable schedules. The same
explicit delta_h works for every x, every active label including ties, and
every k in the full box. In particular the result is stronger than pointwise
strictness followed by an unjustified time-dependent compactness assertion.

### 4. The absolutely continuous minimum lemma

Let gamma be absolutely continuous on a compact time interval, and
F(x)=min_(i in I)(r_i.x+b_i) for finite nonempty I. Then

    |F(x)-F(y)| <= max_i ||r_i||_2 ||x-y||_2,

by comparing a minimizing label at either endpoint. Composition with
gamma is absolutely continuous, directly from this Lipschitz bound and
the defining disjoint-interval criterion. The branch functions
g_i=r_i.gamma+b_i are absolutely continuous as well.

Outside a null set gamma, F(gamma), and every g_i are differentiable.
At each such interior time t, every active i makes g_i-F(gamma)
nonnegative with value zero. Its derivative is zero at this local minimum.
Consequently

    (F(gamma))'(t) = r_i.gamma'(t)
       for every active i, for almost every t.              (8)

This also proves that all tied active derivatives agree wherever both sides
are differentiable; no arbitrary selection of a potentially wrong branch
is used. The exceptional set can include switching times and accumulation
points. We make no assertion that right derivatives exist at every time.

The fundamental theorem for absolutely continuous real functions now
integrates (8). For a Caratheodory solution segment in B_h,
g(t)=F_h(x(t)) is nondecreasing. If that entire segment is in P outside
K_h, (7) gives

    F_h(x(t))-F_h(x(s)) >= delta_h (t-s).                   (9)

The only measure-theoretic inputs here are the componentwise fundamental
theorem and almost-everywhere differentiability for absolutely continuous
functions, and differentiation of indefinite Lebesgue integrals. Precise
read primary statements are Tao, 245A Notes 5, Theorem 89, Exercise 87,
and Theorem 15; see `analytic-excerpts.txt`. They are recorded as analytic
inputs in the ledger, not as conclusions of our Lean certificate.

### 5. Local existence, strong invariance, and global continuation

For any schedule f(t,x) is measurable in t and polynomial in x. On every
compact spatial ball, finite polynomial bounds and the upper rates give
constants B,L independent of t and schedule with

    ||f(t,x)|| <= B,  ||f(t,x)-f(t,y)|| <= L||x-y||.

Around a positive x_0 at any starting time s, choose a closed ball of radius
a>0 lying in the positive orthant. On continuous paths with sup-distance
at most a from x_0, the map

    Phi(z)(t) = x_0 + integral_s^t f(u,z(u)) du

is well defined: each monomial of z is continuous and each coefficient
is bounded measurable. For tau>0 with B*tau<=a and L*tau<1 it maps
this closed subset of the Banach space of continuous paths into itself
and is a contraction. Teschl's Theorem 2.1 gives a unique fixed point.
It is absolutely continuous and solves the ODE almost everywhere by the
Lebesgue fundamental theorem. Conversely every local Caratheodory solution
satisfies this integral equation. Contraction on successive sufficiently
short common intervals gives uniqueness and unique maximal continuation.
This proof does not apply the continuous-time Picard--Lindelof theorem
to a merely measurable vector field.

Start at any point in K_h and at any time s. For as long as the solution
stays in B_h, monotonicity and F_h<=M_h imply F_h=M_h. A first exit from
int B_h within its existence interval is impossible: continuity would
put that exit point both in K_h and on the boundary of B_h, contradicting
(4). More explicitly, on the initial connected time interval in int B_h,
the solution lies in K_h; the closure of that interval also lies in K_h
and hence still in int B_h, so it cannot have a finite exit endpoint.
This proves strong invariance for every schedule, not merely viability
for a selected schedule.

The trajectory is consequently in the positive compact K_h throughout
its maximal interval. Uniform boundedness of f on a neighborhood of K_h
makes the trajectory Lipschitz, including near a hypothetical finite
maximal endpoint T. It has a limit x_* in K_h. The same local integral
construction at time T using the given schedule restricted to [T,infinity)
extends it; joining the two absolutely continuous curves preserves the
ODE almost everywhere. This contradicts maximality. Thus the solution is
global and positive. This argument uses no continuity or right limit of
the schedule at T. Every positive x_0 lies in some K_h by Section 2,
so global existence holds for every positive initial state.

Finally f(t,x) is in S for almost every t. Applying any linear functional
annihilating S to the integral equation shows it is constant along the
solution. Since S is a closed finite-dimensional subspace, x(t)-x(0) is
in S. Thus solutions starting in P remain in P. The same proof works
from every starting time, so the claimed invariance is strong.

### 6. An explicit uniform delay and finitely many scales

Fix h and put

    m_h = min_(x in B_h) F_h(x),   D_h=M_h-m_h >= 0,
    tau_h = (D_h+1)/delta_h > 0.                              (10)

The minimum exists by compactness and continuity, and is finite. Suppose
a class solution stays in B_h for all t>=s. Then g=F_h(x) is nondecreasing,
bounded above by M_h, and g(s)>=m_h. If g(s+tau_h)<M_h, monotonicity makes
g<M_h throughout [s,s+tau_h]. Equation (9) yields

    g(s+tau_h) >= m_h+delta_h tau_h = M_h+1,

a contradiction. Hence the trajectory is in K_h at time s+tau_h and,
by monotonicity (or strong invariance), at every later time. This delay
does not depend on either the schedule or the initial point in B_h.

For nonempty compact Q subset P, choose h_0<=h_P with Q subset K_(h_0)
as above. All corresponding solutions stay there from time zero.
Define h_(j+1)=min(sqrt(h_j),h_P). If a solution remains in K_(h_j)
after time T_j, (4) and h_(j+1)<=sqrt(h_j) put it in B_(h_(j+1))
for every later time. Apply (10), and set

    T_0=0,    T_(j+1)=T_j+tau_(h_(j+1)).                    (11)

Induction proves that **every** schedule and initial state in Q is in
K_(h_j) for all t>=T_j. Neither compactness of the schedule space nor
nesting of the K_h is assumed. The inclusion used is only
K_(h_j) subset B_(h_(j+1)).

In logarithmic coordinates q_j=-log h_j>0, the recurrence is

    q_j=max(q_P,q_0/2^j),   q_P=-log h_P>0.

There is a finite n with q_0/2^n<=q_P, so h_n=h_P. Thus the finite
sum T(Q)=sum_(j=1,...,n) tau_(h_j) is the required common entrance bound.
Intersecting K_(h_P) with c+S gives the nonempty compact convex K subset P,
and both factors are invariant. The scale h_P was fixed before Q.
No bound at initial time uniform over all of an unbounded class is asserted.
For constant schedules these are exactly the October theorem's conclusions,
and (11) also supplies its compact-initial-set-uniform entrance refinement.

## Certification boundary and mathematical improvement

The complete argument above is a mathematical proof of the structural
extension. `Main.lean` separately certifies the universal rate-box cut margin,
positive gap summation, scalar integrated trapping, parameter-uniform
non-nested scale induction, and finite attainment of the logarithmic cap.
`statement_fidelity.md` lists its objects and hypotheses, including the
analytic inequalities that are proved in prose rather than assumed as
unmentioned formal axioms. The full ODE theorem is not labeled a closed
kernel merely because its abstract core compiles.

Compared with reviewed C149_AFFINE alone, the result completes the downstream
trapping and absorption mechanism. Compared with October Theorem 1.1, the
genuine extra quantifiers are one K for an entire positive rate box, all
Lebesgue-measurable schedules, and a time uniform on each compact initial
set. `prior-results.md` compares the strongest inspected primary statements,
including the revised Craciun 2026 bounded-trajectory result. No false
assertion in the staged manuscripts has been established; their fixed-rate
right derivatives are not incorrectly treated as claims about measurable
schedules. Independent review, including the novelty assessment, remains
necessary before declaring the campaign complete.

The fresh source-bound Argus run for `C149_BK_CORE` succeeded under Lean
4.31.0 with compiler exit 0, axiom-audit exit 0, and no proof holes.
Every printed theorem depends only on `propext`, `Classical.choice`, and
`Quot.sound`. The archived certificate is
`lean/certificates/C149_BK_CORE-0648d449d1870d62.json`.

Run `python3 research/bounded-kinetics/verify.py` from the campaign root
for an independent compiler replay of the current core plus exact rational
verification of the retained full-box margin. A different host can supply
`--workspace PATH` for its built Lean 4.31.0 Mathlib workspace.
`--evidence-only` instead checks the already obtained compiler certificate,
its exact source/fidelity binding, and the same exact margin; it does not
pretend to be a fresh compilation. Both modes reuse rather than rebuild
the reviewed affine input. Neither mode substitutes computation for review
of the full analytic proof or claims to have certified novelty.

The independent Reviewer still needs to read and attribute the cited
propositions in the claim ledger. The Engineer's source readings and
`analytic-excerpts.txt` are supplied for that review, not self-filed as
independent citation approvals. The older preliminary routes referencing an
unformalized core were superseded solely to bind the actual final source
and precise analytic inputs; they are not counterexamples or negative
mathematical route exclusions.
