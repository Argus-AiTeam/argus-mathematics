# Sharp compatible barriers with per-visit tolls

## Statement and scope

Use the quotient-sphere, coordinate, compatibility (P), endpoint, gate,
and allowed-tagged-path definitions in Sections 1 and 3 of the staged
Koebe manuscript. In particular, B is compact and totally disconnected;
dust disks have smooth boundaries in the physical domain G; the prescribed
disks decrease strictly to the specified endpoint b; g is nonnegative Borel
in L2(G), with g >= c0 > 0 everywhere; and m is nonnegative in counting
ell2(B). A dust toll is charged at **every parameter visit**, not just once
per image point. No restriction on the atomless measure, earlier laws,
finite deletions, permitted tag tuples, or gate data is added.

Assume the manuscript's endpoint hypothesis: every allowed gated path
from E to b, first reaching b at its final time, has cost at least 1
when the final toll is omitted.

**Theorem (C_SHARP_BARRIER).** For every kappa > 1 and eta > 0 there
is a barrier u and, in the gated case, a permitted penalty region O,
such that

    0 <= u <= 1,           a_u = kappa m,
    ||du||_{2,G\O} + ||a_u||_ell2
        <= kappa (||g||_2 + ||m||_ell2) + eta.

Only supp(m) is added to the old flag set. Thus, for every eps > 0,
the controlled size can be at most ||g||_2 + ||m||_ell2 + eps,
with a_u = (1+o(1))m as eps decreases to zero.

**Theorem (C_SHARP_OPTIMAL).** The coefficient 1 in this last infimum
bound cannot be decreased, even with no prior coordinates, no gates,
m=0, and a single dust component.

These are mathematical proofs, with exact algebraic and toll-accounting
certificates, not exhaustive computational proofs of the analysis.
`Main.lean` formalizes only C_TOLL_CORE, whose precise scope is stated in
`statement_fidelity.md`. Independent review and global novelty assessment
are pending. No claim here proves Koebe uniformization, the positive-law
alternative, retained-test uniformization, or the rigidity companion.

The strongest prior result in the assigned source is thm:barrier, with
coefficient 8 and a_u=4m. The improvement is a coefficient-1 infimum
bound, an optimality example, and a direct measurability argument that
does not use lem:path-coding. In particular, the suspected collar and
jump steps are proved below rather than assumed.

## 1. Universal residual-contact stability

For an earlier law or prior coordinate, write C(A) for its incidence
functional on a dust set A, and w for its corresponding point weights.
C is countably subadditive, is continuous under increasing unions,
and C({s}) <= w(s). The law case is a probability of visiting A;
the level case is Haar measure of levels meeting A. Removing the
specified finite set P is always performed before this functional
is applied. All sets used here are countable unions of compact images
minus finite sets, so these assertions use the same completed measures
as the path-system definition.

The rational-closed-interval constraint first extends to arbitrary
open intervals by increasing rational compact exhaustions. For a closed
interval add its at most two endpoint times using the singleton bound.
Right-hand sums are nonnegative sums over times, hence are continuous
under increasing unions of time sets, whether finite or infinite.

Restrict an old tag to the interior of a retained path piece. Keep it
when nonconstant there; otherwise discard it. Each discarded restriction
has one constant image point, so all newly exposed dust times have
countable image. They therefore have zero atomless measure. Their
incidences are bounded by summing singleton weights, and then by summing
over their parameter times. Reversal and affine reparametrization do
not alter this argument or the old tuple exclusions.

For a countable concatenation, let J range over its disjoint open
piece intervals. Fix a test interval I and a finite deletion P.
Partition the new residual times in I into:

1. old residual times R_J in each J intersected with int(I);
2. newly exposed times A_J there, from discarded constant tags;
3. the junction/limit times and endpoints of I, denoted T.

The last set is countable by the stipulated concatenation hypothesis.
Each image of A_J is countable. The partition is a partition of
**times**, not images. Old bounds apply to R_J by the open-interval
extension. Singleton subadditivity applies to T and all A_J. Summing
these bounds and then using subadditivity of C proves the new constraint.
No positive charge is used twice, even if different times have the same
image point. Atomless nullity follows from the same decomposition.
Every retained tag uses its old permitted tuple. Finite domain length
therefore proves all requirements for the new path.

This proves C_PATH_STABILITY, including all earlier laws, all prior
labels, all finite deletions, and all rational tests simultaneously.
There is no assertion about concatenations leaving an uncontrolled
Cantor set of additional times.

## 2. Collar construction, with its complete infinite budget

Suppose allowed paths with endpoints in G have costs tending to A<infinity
and their endpoints converge to distinct dust points p,q. Choose disjoint
strictly nested dust disks V_j,W_j decreasing to p,q. Their boundaries
can have finite g-integrals: in each compact smooth annulus in G,
ordinary Fubini and g in L2 give finite integrals on almost every smooth
parallel curve. Small perturbations preserve nesting. When prescribed
hit curves must be avoided, choose the annuli between those curves.

Pass to a subsequence so that path n starts in V_n and ends in W_n.
Let alpha_nj be its first hit of boundary(V_j), and beta_nj its last
hit of boundary(W_j). These cuts occur in the order

    alpha_nn <= ... <= alpha_n1 < beta_n1 <= ... <= beta_nn.

The alpha fragments lie in the appropriate closed V_j, the beta
fragments in the closed W_j. Keep the middle fragment as well.
Every cut is in G, so no dust visit is duplicated by these cuts.
Arclength has no atoms. The costs of every finite collection of these
fragments sum to at most the original full cost.

Compactness of each smooth collar and boundedness of these costs
give one diagonal subsequence on which all cut positions and all
fragment costs converge. If the limiting middle cost is c_star and
the other limiting costs are c_j^- and c_j^+, then

    c_star + sum_j (c_j^- + c_j^+) <= A.                 (2.1)

This follows first for each finite sum and then by the definition
of a nonnegative infinite sum; no lower semicontinuity of the path
cost functional is being assumed.

At a fixed collar, both adjacent fragments' endpoints converge to
the same cut position. Absolute continuity of the finite g-integral
on that smooth circle makes their joining arc cost arbitrarily small.
Enumerate **all** fragment-error allowances and joining-arc allowances
by n=1,2,..., and assign

    e_n = eta / 2^(n+1).

Select each actual fragment far enough along the diagonal subsequence
to satisfy both its endpoint neighborhoods and its own cost allowance.
This is possible independently for each fragment. Join neighboring
fragments on their shared collar. The total additional cost is at most
eta/2, and the allowance tail after item N is eta/2^(N+1).

Place the initial fragments on successive intervals accumulating
only at 0, the middle on an interior interval, and final fragments
on successive intervals accumulating only at 1. Their tails lie in
the shrinking closed V_j or W_j. Defining the endpoints as p,q
therefore makes the path continuous in X. Its cost with those two
endpoint tolls omitted is at most A+eta/2. Its total domain length
is at most (A+eta/2)/c0, hence finite. The extra times are countable,
and Section 1 proves that it is allowed.

The only new dust times are the specified endpoint times: all other
dust visits occur inside retained actual fragments and were charged
there. Avoided dust points remain avoided off the new endpoints.
Joining arcs lie in G and, when chosen disjoint from hit curves,
introduce no new restricted hits.

For a one-ended sequence starting in F with p outside closure_X(F),
choose an outer p-disk missing closure_X(F). Use last hits, retain one
actual prefix from F, and select successive last-hit fragments in
shrinking disks. The same diagonal construction and (2.1) apply.
The initial endpoint remains an actual point of F; only the final
toll is omitted. This proves both parts and the preservation clauses
of C_COLLAR.

## 3. Shrinking jumps: all anchor cases and visit multiplicities

Fix finitely many old levels with E-to-C chain cost at least beta>0.
Fix rho,tau>0 and 0<Delta<beta. Suppose finer and finer new covers
admit chains of cost less than beta-Delta. The old levels contain
only finitely many disks, all of positive toll. Together with rho
this gives a strictly positive lower bound for every jump cost.
The number of jumps in these chains is uniformly bounded.

Combine adjacent true pieces at their domain endpoints. Pass to
a subsequence fixing the number of jumps, their old/new pattern,
and each old disk label. Each new jump's endpoints converge to one
point p_i in B, since its disk meets the compact B and its diameter
tends to zero. Pass further so all true-piece and new-jump costs
converge. If d_i is a limiting new-jump cost, then

    d_i >= m(p_i).                                     (3.1)

Indeed an endpoint x_i,n of the shrinking disk tends to p_i, so
dist_X(p_i,V_i,n) <= d_X(p_i,x_i,n) < tau eventually. The fixed
tau-neighborhood supremum in the actual toll then includes m(p_i).
Replacing this supremum by values only inside the disk would not
justify (3.1); no such replacement is made.

Split a chain into blocks between old jumps. A block's anchors are
E, C, or the open disk of its adjacent old jump. Collapse a run of
equal consecutive p_i to one junction, discarding the intervening
true pieces and keeping one of that run's jump budgets. All discarded
costs are nonnegative. Distinct consecutive retained junctions are
joined by Section 2's two-ended construction applied to the original
true pieces separating their runs.

At an outer anchor A, the following list exhausts the possibilities.
If the adjacent junction p is outside closure_X(A), use Section 2's
one-ended construction, with F=A intersected with G when A is an old
jump disk. If p is in closure_X(A), A cannot be E or C:
they are compact subsets of G. Thus A is an old jump disk, and its
boundary is in G, so p actually belongs to A. Truncate the next
constructed path at a domain collar point sufficiently close to p
to be inside A, and discard that outer true piece and its now
unnecessary endpoint toll. Such domain points exist on the shrinking
collars of the construction itself.

If there is just one retained junction and it belongs to both old
disk anchors, use a domain point in their open intersection and the
constant path. The intersection contains p and is open in X, so
density of G supplies that point. If it belongs to exactly one
anchor, construct from the other anchor to p and truncate on a
domain collar inside the first anchor. If it belongs to neither,
use both one-ended constructions. If there are no new junctions,
retain an actual true piece with cost as close to its limit as
needed.

At a retained internal junction p identify the terminal and initial
parameter time, without a pause. The complete visit index set is
the disjoint union of the left internal visits, **one** junction
time, and the right internal visits. Thus its toll is

    left internal toll + m(p) + right internal toll.    (3.2)

Every extra internal return to p is still charged inside its
retained fragment. If the same p occurs at nonconsecutive junctions,
each junction time is charged separately. Equation (3.1) pays for
each occurrence of (3.2). This is not a sum over distinct dust
images. `Main.lean` proves this disjoint-index identity for arbitrary
nonnegative extended tolls, including infinitely many internal visits.

The replaced block has finite total cost and hence finite domain
length. It uses countably many actual restrictions and smooth joining
arcs, with only countably many extra times. Section 1 proves all
tag, atomless, and incidence conditions. The block may choose new
domain endpoints inside its adjacent old disks, which the unchanged
old jumps are allowed to connect. Summing block errors to less than
Delta/2 produces an old-level chain of cost at most
beta-Delta+Delta/2 < beta. This contradiction proves C_JUMP with its
stated universal quantifier over sufficiently fine new covers.

## 4. A measurable, sharp-gradient potential without path coding

Here is the analytic reduction C_POTENTIAL_ACL. Let v be any bounded
real function on a plane domain, initially without a measurability
assumption, and let h be nonnegative Borel and locally L2. Suppose

    |v(x)-v(y)| <= integral_[x,y] h |dz|                (4.1)

for every line segment contained in the domain.

Work in a closed rectangle contained in the domain. Fubini gives a
full-measure set of vertical lines on which h is integrable. Choose
a countable dense set of such lines. On each, (4.1) for all subsegments
implies that the actual values of v are absolutely continuous.
For each mesh 2^(-n), choose one such vertical line in each mesh
column, and define v_n(x,y) to be its value at height y throughout
that column. Each v_n is Borel. On almost every horizontal line,
h is integrable and (4.1) makes v continuous as a function of x.
On every such line v_n converges pointwise to v. The remaining
horizontal rows form a planar null set, on which a bounded function
is measurable for completed area. Thus v is completed-Lebesgue
measurable; a Borel representative exists.

On almost every horizontal and vertical line v is absolutely
continuous and its line derivative has absolute value at most h.
Integrating the one-dimensional integration-by-parts identity against
compactly supported test functions and then using Fubini proves
that these are the weak partial derivatives. They are locally L2.
Repeat the argument in rotated rectangles for a **countable dense
set of unit directions** e. Uniqueness of distributional derivatives
gives

    |e dot grad(v)| <= h

off one null set independent of those countably many directions.
Continuity in e then gives |grad(v)| <= h, not merely sqrt(2) h.
This proves the reduction without any projection theorem about
path codes.

## 5. The sharp compatible-barrier construction

Fix kappa>1, put

    delta = (kappa-1)/(4 kappa).

Then 0<delta<1/4 and

    kappa (1-2 delta) - 1 = (kappa-1)/2 > 0.            (5.1)

### A finite collar and penalty region

There is a prescribed C_k such that all allowed E-to-C_k paths
obeying the gates through k have cost at least 1-delta. Otherwise
take counterexamples for k increasing to infinity and stop each
at its first hit of C_k. They avoid b and every deeper collar.
Their costs have a subsequence tending to A<=1-delta. Apply the
one-ended construction of Section 2 with error less than delta.
Choose joining collars strictly between prescribed collars, with
finite g-integrals. They avoid every prescribed hit curve. The
result obeys every gate, first reaches b at its final time, and
has final-toll-omitted cost less than 1: a contradiction.

Without gates, set O empty and g1=g. With gates let

    F = union_{j<=k} (C_j \ f0^(-1)(W2)).

It is a compact subset of G, disjoint from E, and its f0-image
misses W1. Choose a relatively compact open O containing F with
closure disjoint from E and with f0(closure(O)) disjoint from W1.
If F is empty use O empty and h=0. Otherwise put

    d = dist_sph(F, sphere\O) > 0,   h = 1_O/d,   g1=g+h.

Every path from E to F has h-length at least 1. For rigor, the
last passage from outside O to the first relevant F-hit lies in
the compact physical domain neighborhood and has physical length
at least d; dust cannot bypass the boundary of this relatively
compact subset of G. A failed gate through k reaches F; a path
obeying those gates already has the lower bound 1-delta.
Consequently every allowed E-to-C_k true path, without gate
restrictions, has full (g1,m)-cost at least 1-delta. The density
g1 is L2, is >=c0, and equals g off O.

### Jumps, potential, and bands

Add countably many jump levels with rho_j,tau_j tending to zero.
Choose meshes tending to zero, disjoint from E and C_k, using
Section 3 at each stage with losses

    Delta_j = delta/2^(j+1),   j>=1.

Their sum is delta/2 < delta. Every finite chain using any of the
levels has E-to-C_k cost at least

    beta_star >= 1-delta-sum_j Delta_j > 1-2 delta.

Indeed a finite chain uses only finitely many levels. The required
finite covers with arbitrarily small mesh exist by the dust-disk
construction in the quotient-sphere setup.

Define D(x) as the infimum of all finite chain costs from E to x
and v(x)=min(1,kappa D(x)), interpreting a truncated infinite value
as 1. The empty chain gives v=0 on E. A jump disk is connected and
misses C_k, so it cannot change the side of C_k. Any chain ending
in U_k must therefore have a true piece crossing C_k. Truncation
there and (5.1) give v=1 throughout U_k intersected with G.

Concatenation and reversal give

    |v(x)-v(y)| <= kappa L_{g1,m}(gamma)                (5.2)

for every allowed true path between domain points. Finite connecting
cost makes finiteness of both chain distances equivalent, so this
argument also covers the extended-distance cases. A level-j jump
disk V similarly has oscillation at most kappa c_j(V).

Let V_j(s) be its unique disk containing a dust point s. For every
zeta>0, the set {r in B: m(r)>=m(s)+zeta} is finite, by counting
ell2 summability, and misses s. Since tau_j+mesh_j tends to zero,
this finite set eventually misses the tau_j-neighborhood of V_j(s).
As rho_j tends to zero, it follows that

    limsup_j c_j(V_j(s)) <= m(s).

Hence the actual topological band of v at every s has width at most
kappa m(s), with no exceptional dust set. Every new free point in
B outside (Sigma union supp(m)) has a unique trace.

### Sharp energy, smoothing, and constants

An ordinary line segment in a compact physical conformal chart is
allowed and has no dust toll. Write ds=Lambda(z)|dz|. Equation
(5.2) supplies (4.1) with h=kappa Lambda g1. Section 4 proves
measurability and

    |dv|_sph <= kappa g1 almost everywhere.

Boundedness of v and finite spherical area give global W12(G).
This argument does not assume lem:path-coding.

Choose a countable locally finite smooth partition of unity on
relatively compact physical patches, with slightly larger sampling
patches. They can be chosen with

    d_X(x,y) <= c dist_X(x,B)

whenever y contributes to the positive convolution average at x.
This is obtained by first choosing the expanded patches small
relative to their distance from B, and then refining. On each
patch convolve a Borel representative of v with a nonnegative
unit-mass smooth kernel. Choose radii so that the local L2 value
and derivative errors, multiplied also by the bounded derivatives
of the partition functions, have a summable total less than eta.
Ordinary translation continuity in L2 gives these choices. Their
positive partition sum u is smooth, lies in [0,1], and satisfies

    ||du-dv||_{2,G} < eta.                             (5.3)

At a dust point s let [ell_s,r_s] be the actual band of v.
For every zeta>0 all actual nearby domain values lie between
ell_s-zeta and r_s+zeta. This remains true almost everywhere for
the Borel representative. If x tends to s, every contributing
sample y tends uniformly to s, since

    d_X(y,s) <= d_X(x,s)+c dist_X(x,B) -> 0.

Positivity of averages and of the partition shows that the band
of u is contained in the band of v. In particular every new free
trace is unchanged, and a_u=kappa m is valid at **every** dust
point.

Choose l>k. Refine the cover so every sampling patch meeting E_star
is contained in int(E), and every sampling patch meeting C_l is
contained in U_k intersected with G. These are disjoint compact
sets with the stated open neighborhoods. Their samples have
constant values 0 and 1 respectively, so u has exactly the required
constants, not just approximate ones.

Total energy is finite. Since g1=g off O, (5.3) yields the claimed
controlled bound. To obtain the coefficient-1 statement for a
specified eps, put S=||g||_2+||m||_ell2, choose

    kappa = 1 + eps/(2(S+1)),     eta=eps/2.

Then (kappa-1)S+eta < eps. Also a_u=kappa m tends to m with this
choice. For the original theorem, one can instead fix kappa=4
and eta=eps: this gives its exact requested budget a_u=4m and the
stronger coefficient 4, hence its coefficient-8 inequality.

### Compatibility, not just separation

Fix a prior finite type and a tuple outside its permitted exclusion
and the generic-level exceptional sets for weights g1,m. For its
level union H define

    nu = 1_{H intersect G} g1 H1_sph
           + sum_{s in H intersect B} m(s) delta_s.

Smooth coarea and band incidence give finite nu: the integrated
bound for each participating label i is

    integral_{G intersect M_i} g1 |du_i| da
          + sum_s m(s)a_i(s) < infinity

by Cauchy--Schwarz. This is the ordinary smooth coarea input, not a
transboundary modulus/capacity identity.

For completeness, finite physical length in G gives the needed
topological geometry. Given eps>0 choose a core whose complementary
dust disks have X-diameter below eps. Every continuum of diameter
at least eps meets that compact core. Uniform continuity of the
quotient map and compactness give one physical radius r>0 such
that a closed spherical r-ball around any point of the core is
inside G and has X-diameter below eps. Boundary bumping shows
that such a continuum contains a subcontinuum joining its center
to that ball's boundary. Distance from the center, being
1-Lipschitz, proves physical length at least r. Thus pairwise
disjoint such continua have cardinality at most
H1_sph(H intersect G)/r.

It follows that there are countably many nondegenerate components.
Every subcontinuum L is locally connected: otherwise components
of L intersected with a small closed ball, distinct from the one
containing its center, would approach that center. Boundary
bumping makes infinitely many of them have diameter at least
half the ball radius, contradicting the preceding bound.
Connected relatively open subsets of a locally connected metric
continuum are arcwise connected (the usual shrinking-connected-chain
construction followed by loop erasure).

Let alpha be a simple arc in H joining two new free dust points
s,t. Its domain length is its physical image length and is finite.
Every subarc between domain points is allowed with the single tag
given by the fixed tuple. Injectivity means its dust visits are
counted once each and its cost is at most nu(alpha). Applying
(5.2), then approaching s,t through domain points on the arc, gives

    |trace_v(s)-trace_v(t)| <= kappa nu(alpha).          (5.4)

Those domain points exist arbitrarily near both ends because B is
totally disconnected and the arc is nonconstant. The same trace
inequality holds for u. The new free dust set has nu-outer measure
zero, since it is disjoint from G and supp(m).

In a nondegenerate locally connected component L, cover this set
by a relatively open O_L of nu-measure less than zeta. Its
components are open, countably many, and arcwise connected.
Equation (5.4) bounds the diameter of the trace image in each
component by kappa times its nu-measure. Covering those real
images by intervals with summable arbitrarily small excess gives
total trace-image outer measure at most kappa zeta. Let zeta
decrease to zero. There are countably many such components, so
the full free trace image in their union is null, also modulo 1.

Finally the relation "a free point of the new level belongs to a
nondegenerate continuum in the prior finite level union" is an
analytic projection of the compact-continuum witness relation,
with the countable flag set deleted. It is universally measurable,
as in the compatibility definition in the setup. Completed Fubini
therefore turns the preceding null sections into product-Haar
nullity. Countably many types and the fixed null tuple exclusions
do not change this conclusion. All old instances of (P) persist
under flag enlargement. This proves the full compatibility and
completes C_SHARP_BARRIER, not merely its energy estimate.

## 6. An exact sharpness family and its limiting bound

Use the unit-round spherical metric, whose stereographic conformal
factor is Lambda(z)=2/(1+|z|^2). Let

    G = {|z|>1} union {infinity},

and collapse its closed complementary unit disk to the sole dust
point b. Take no prior coordinates or gates, m=0, lambda=0, no
earlier laws, and empty flags. All finite-domain-length paths are
allowed. For each integer n>=2 set

    E      = {|z|>=2} union {infinity},
    E_star = {|z|>=2+1/n} union {infinity},
    r_l    = 1+2^(-l-2),   l>=1,
    C_l    = {|z|=r_l}.

These are legitimate endpoint data: E_star is compact in int(E),
and the closed nested dust disks bounded by C_l miss E and decrease
to b in X.

Define the spherical metric density

    g0(z) = 1/(Lambda(z)|z| log(2))   if 1<|z|<2,
            0                        otherwise;
    g_n = g0 + 1/n.

It is Borel, L2, and everywhere at least 1/n. A path from E first
reaching b at its final time must cross every annulus
1+t<|z|<2. The radial lower bound for its g0-length is

    1 - log(1+t)/log(2).

Letting t decrease to zero proves the exact endpoint hypothesis
L^-_{g_n,0} >= 1 for **every** allowed path, not just radial ones.
Equivalently, the radial function min(1,log(|z|)/log(2)) is 1 on E
and extends continuously as 0 at the collapsed disk. Its variation
on each compact initial domain subpath is bounded by that subpath's
g0-integral; letting the subpath approach its first b-arrival gives
the same lower bound.

Direct conformally invariant integration gives

    A = ||g0||_2^2 = 2 pi / log(2),    area_sph(G)=2 pi.

Since 0<log(2)<1, the triangle inequality gives

    ||g_n||_2 <= sqrt(A)(1+1/n).                        (6.1)

Any eligible smooth barrier is 1 on some C_l and 0 on the circle
of radius R_n=2+1/n. On every radial ray Cauchy--Schwarz gives

    1 <= (integral_{r_l}^{R_n} |u_r|^2 r dr)
                            log(R_n/r_l).

Integration in angle and discarding the nonnegative angular energy
therefore prove

    ||du||_2 >= sqrt(2 pi/log(R_n))
             = sqrt(A) sqrt(log(2)/log(2+1/n)).         (6.2)

This holds whether or not u changes values again inside C_l.
It uses only a required collar, not a presumed trace value at b.

The elementary integral bounds log(2)>=1/2 and
log(1+x)<=x give

    log(2)/log(2+1/n) >= n/(n+1).

Because sqrt(t)>=t for 0<=t<=1, (6.1)--(6.2) imply

    ||du||_2 / ||g_n||_2 >= (n/(n+1))^2 =: q_n,
    0 < 1-q_n = (2n+1)/(n+1)^2 < 2/(n+1).             (6.3)

Thus q_n tends to 1 with an explicit rational bound. For any proposed
universal coefficient c<1 choose n with 2/(n+1)<1-c, then choose
the additive tolerance smaller than the positive gap between (6.2)
and c times (6.1). No permitted barrier can satisfy that bound.
This proves C_SHARP_OPTIMAL with all endpoint, gate, regularity,
positivity, and infinite-limit conditions accounted for.

## Literature boundary

The primary text actually inspected is Kai Rajala, *Extremal length
and duality*, arXiv:2408.12027v1, Section 1 equation (5) and Section 4.
Its classical transboundary definition charges each **visited image
component** once. Its rectangular duality Proposition 4.2 assumes
countable connectivity. Neither supplies the tagged per-visit theorem
proved here. Classical annular capacity and the constant-1 Euclidean
gradient argument are known; no novelty is claimed for those facts.

The source's references to Federer smooth coarea and Kechris
Arsenin--Kunugui are recorded in the ledger with their inspection
limitations. Arsenin--Kunugui is not needed by this barrier proof;
analytic universal measurability for the compatibility slicing is
still used. The smooth coarea and analytic-measurability inputs require
independent citation reading. The novelty of the combined sharp
compatible theorem has not been established by the literature search,
and search-engine summaries were not treated as primary evidence.

No false literal manuscript assertion has been established in this
mission, so no F_ claim or refutes verdict is manufactured. The two
audited mechanism lemmas survive the universal argument above.
