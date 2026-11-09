# An all-size strengthening of the finite Green estimate

## Result and scope

Let `(M_n,T_n)` be uniform among rooted planar maps with `n >= 1` edges
and a distinguished spanning tree. Loops and parallel edges are retained.
Set `N=2n`, `mu(v)=deg(v)/N`, and let `H` be the counting-measure
unit-conductance Laplacian. For real `f` with `mu(f)=0`, define `Gf`
by `HGf=mu f` and `mu(Gf)=0`.

**Theorem 1 (higher moments).** For every `1<p<3` and
`0<rho<1-1/p`, there are nonnegative, map-measurable `A_n=A_n(p,rho)`
such that

    sup_n E[A_n^p] < infinity,
    ||Gf||_infinity <= A_n mu(|f|)^rho

simultaneously for all real `f` with `|f|<=1` and `mu(f)=0`.
In particular, every `rho<2/3` is allowed with bounded expected constants.
Taking `p=2` proves exactly Proposition `gr:green-bound`, with its
original ensemble, normalization, and simultaneous quantifiers.
It also gives uniformly bounded second moments of the original-range
control constants, hence uniform integrability, not just tightness.

**Theorem 2 (critical exponent with a logarithmic loss).** For every
`beta>4/3`, there are nonnegative, map-measurable `B_n=B_n(beta)` with
`sup_n E[B_n]<infinity` such that, writing `m=mu(|f|)`,

    ||Gf||_infinity <= B_n m^(2/3) (1+log(1/m))^beta,  0<m<=1,

simultaneously for the same sources. At `m=0` the potential is zero.

These are universal arguments, not conclusions from bounded enumeration.
The improvement over the staged manuscript is the full range `p<3`,
the resulting source exponent `rho<2/3`, and Theorem 2. A bounded
primary-source search found no matching finite-map statement; that does
not certify novelty or publishability. Independent Host review is pending.
No claim here proves diffusion convergence, a unit conductivity, optimality
of `2/3`, or a transfer from mated-CRT maps.

The bounded literature comparison inspected Gwynne--Miller,
[arXiv:1711.00836v4, Theorem 1.3](https://arxiv.org/html/1711.00836v4#S1.SS3)
(root-diagonal Green bounds for infinite maps), Gwynne--Miller--Sheffield,
[arXiv:1807.07511, Section 1.5](https://arxiv.org/html/1807.07511#S1.SS5)
(mated-CRT energy and harmonic-function estimates), and Gwynne--Pfeffer,
[arXiv:1901.06860v4, Theorem 1.9](https://arxiv.org/html/1901.06860v4#S1.Thmthm9)
(finite spanning-tree-weighted map diameters). These are not the finite
centered, simultaneous-source inequality here and are not used in its proof.
The comparison is not an exhaustive priority search.

The finite tree-rooted-map / parenthesis-shuffle bijection is a **known
result**, not a novelty claim: see Bernardi, arXiv:math/0601684v1,
Section 2, pp. 2--4, and `encoding_excerpt.md`. We include the forward
and inverse construction below, so the probabilistic theorem has no
unproved model-specific input. In particular it does not assume any
geometric result of the companion manuscripts.

## 1. Exact graph and probability bookkeeping

We first justify the exact finite encoding, rather than relying on a
companion assertion. Represent an oriented-sphere map by its half-edges:
`alpha` exchanges the two half-edges of every edge, `sigma` rotates the
half-edges about their incident primal vertices, and the distinguished
root is one half-edge. Choose the rotation direction consistently so
the face permutation is `sigma alpha`. Let `tau` exchange the two
half-edges of tree edges and fix all non-tree half-edges. The tour
successor is

    gamma = sigma tau.                                  (1.1)

It crosses a tree edge before rotating at its other endpoint; at a
non-tree half-edge it simply rotates at the same endpoint.

The boundary of a thin regular neighborhood of a plane tree is one
circle. This can be seen inductively: adjoining a leaf and its edge
adjoins a disk along one boundary arc and keeps the neighborhood a disk.
Mark the non-tree half-edges on this boundary in their incident cyclic
order. The boundary tour encounters every tree-edge side and every
non-tree mark once, and its successor is (1.1). Consequently `gamma`
is a single cycle of length `N`. Starting at the distinguished root,
write `H+` on a tree edge's first occurrence and `H-` on its second.
The extracted string is a Dyck word: it is the ordinary contour of
the tree rooted at the starting corner.

The non-tree edges are disjoint arcs in the complementary disk, whose
boundary is the same tree-neighborhood circle. They form a noncrossing
matching of the remaining marks. Starting at the root and writing
`V+` at the first endpoint of each such arc and `V-` at its second
gives another Dyck word, with the original edge matching: in a
noncrossing matching the partner of the next closing endpoint must
be the most recent unpaired opening endpoint. This proves that every
rooted map/tree pair produces a shuffle of the two words.

Conversely, from any such shuffle, construct the plane tree of the
horizontal word and insert one marked half-edge at the current corner
for every vertical occurrence. Join the marks in the complementary
disk according to the vertical Dyck matching. The arcs can be drawn
disjointly by nesting the matched intervals. Their embedding is unique
up to a boundary-fixing orientation-preserving homeomorphism: remove
an innermost adjacent pair, and induct on the number of pairs.
This yields a connected sphere map, with the horizontal tree spanning
all vertices, and with its root at the first occurrence. If the
horizontal word is empty, the tree is a single vertex with all marks
in its cyclic order; the same construction applies. Loops are not
removed.

For an algebraic check of the inverse, number occurrences `0,...,N-1`
and set `gamma(i)=i+1 mod N`. Let `alpha` match the same-color
parentheses, and let `tau` use only the horizontal matches. The
constructed vertex rotation is exactly

    sigma = gamma tau.

Indeed, for a horizontal half-edge its next half-edge at the same
vertex is the occurrence after its partner; for a vertical mark it
is the immediately following occurrence. Since `tau^2=1`, this
inverts (1.1). It also recovers the root, so no unrooted symmetry
factor is being divided out. The two constructions are inverse.

In particular a horizontal pair is a primal tree edge and a vertical
pair is one non-tree edge, with endpoints the primal vertices at its
two step starts. Different pairs remain distinct even when endpoints
agree. To verify the dual convention as well, let `upsilon` exchange
only vertical pairs. The disjoint supports imply
`tau alpha=upsilon`, so the face permutation is `sigma alpha=gamma upsilon`.
Its cycles are precisely the vertical contour vertices. Thus the
vertical word is the contour of the complementary dual tree, not
merely a tree with the same number of edges. For example its edge
connects the two face cycles at the starts of its matched steps.

Given a horizontal schedule `sigma` of `J=2k` slots, there are exactly
`C_k C_(n-k)` words, one for each pair of coordinate Dyck words. Thus,
conditional on `J`, the schedule is uniform, and conditional on the
schedule, the two strings are independent uniform Dyck words. The count is

    P(J=2k) = binom(2n,2k) C_k C_(n-k) / (C_n C_(n+1)).

For completeness, substituting the Catalan formula makes the numerator
`(2n)! binom(n+1,k) binom(n+1,n-k)/(n+1)!^2`.
Vandermonde gives the asserted denominator.

Let `v_i` be the primal vertex at step start `i`, modulo `N`.
Every horizontal traversal is one incidence at its departing vertex.
Every vertical occurrence is one non-tree half-edge at its incident
vertex. Hence the number of visits to `v` is exactly `deg(v)`; a loop
contributes two. The entire sequence `v_i`, and therefore every degree,
is determined by `(sigma,L)`, not the shape of the vertical Dyck word.

Deleting a primal tree edge separates a vertex set `S` from its complement.
The contour crosses between them only at the two traversals of that edge,
so its visits to either side form one cyclic interval. Choose the shorter
interval, resolving a tie by the side not containing `v_0`. This is a
deterministic function of `(sigma,L)`, including the tie case. Therefore
conditioning on all selected sides, or simply on `(sigma,L)`, does not
bias the vertical word. In particular

    mu(S) = ell/N.

A non-tree edge crosses this cut exactly when one, but not both, of its
vertical occurrences is in the interval. In the dual tree, these are
exactly the edges traversed an odd number of times along the corresponding
contour segment, namely the simple path joining its endpoints. The
endpoints are the dual vertices at the two horizontal traversals, since
horizontal steps hold the dual vertex fixed. With `D*` their distance,

    b(S) = 1 + D*.

Both statements retain all multiplicities. This settles the proposed
conditioning concern; there is no vertical-dependent smaller-side choice.

## 2. The exact reciprocal-cut denominator

For an arbitrary connected finite multigraph, choose a deleted vertex `o`
and a reduced oriented incidence matrix `B`. Loops have zero incidence
columns and can be discarded. For a zero-total source `q`, Cauchy--Binet
applied to `[B, sqrt(z) q_hat]` gives

    det(BB^t + z q_hat q_hat^t)
      = tau + z sum_F q(S_F)^2,

where `F` ranges over spanning two-component forests and `S_F` is the
component not containing `o`. An incidence minor is zero if its edges
contain a cycle. Otherwise deleting leaf rows and columns leaves `1`
for a tree minor, or `+/-q(S_F)` for the forest/source minor. This proves
both the constant coefficient `tau` and the coefficient of `z` without
an additional forest-theorem assumption. Expanding a rank-one determinant
at an invertible `BB^t` gives

    q^t H^+ q = (1/tau) sum_F q(S_F)^2.

Here a solution grounded at `o` differs from `H^+q` only by a constant,
which disappears when paired with `q`. Polarizing yields the bilinear
identity for any two zero-total sources. Use the second source
`delta_x-mu` to impose precisely the required `mu` centering.

A two-component forest has `b(F)` extensions to a spanning tree, one for
each individual crossing edge. Therefore, for a conditional uniform tree,

    Gf(x) = E_T sum_(e in T)
       [ (sum_(v in S_e) mu(v) f(v))
         (1_(x in S_e)-mu(S_e)) / b_e ].                 (2.1)

The factor is `1/b_e`, not `b_e`, and there is no extra factor of `N`,
`tau`, or degree. Replacing a side by its complement reverses both
zero-total factors and leaves the product unchanged. One-vertex graphs
give the zero sum and the zero potential.
The conditional tree really is uniform: the finite law is uniform over
rooted map/tree pairs, so fixing the rooted map gives equal weight to
each of its spanning trees.

## 3. Uniform contour estimates, including the missing moment range

For a uniform plane tree with `s/2` edges, let `w_i` be its contour
vertices, and put `D=dist(w_i,w_(i+j))` and `d=1+min(j,s-j)`.
Rerooting at a deterministic contour corner `i` is a bijection, inverted
by rerooting `s-i` corners later. Thus `D` has the height law at `j`
of a uniform `s`-step Dyck word, even if the original segment wraps.

Write `b_l(a)` for the number of nonnegative simple-walk paths from
zero to `a` in `l` steps. Reflection at the first visit to `-1` gives

    b_l(a) = binom(l,(l+a)/2) - binom(l,(l+a+2)/2).

Inadmissible coefficients are zero. Dividing the two coefficients when
admissible gives the exact multiplier `2(a+1)/(l+a+2)` on the first.
Here are elementary binomial bounds, so no local-limit theorem is assumed.
Set `r_l=floor(l/2)` and `B_l=binom(l,r_l)`. For `0<=r<=r_l`,

    binom(l,r_l-r)/B_l
       = product_(i=0)^(r-1) (r_l-i)/(l-r_l+i+1)
       <= exp(-r^2/(l+1)).

This follows from `log(1-u)<=-u`: the decrements in the factors are
at least `(2i+1)/(l+1)`. For `l>=64` and `r<=sqrt(l)/8`, the same
product is bounded below by an absolute positive constant, using
`log(1-u)>=-2u` for `0<=u<=1/2`. By symmetry, summing the coefficients
on the two sides of the mode bounds `2^l/B_l` above and below by
constant multiples of `sqrt(l+1)`. The finitely many `l<64` are absorbed
by fixed constants. The product bound at other `r` now supplies the
Gaussian factor. With the reflection multiplier this gives

    2^(-l) b_l(a)
       <= C (a+1) (l+1)^(-3/2) exp(-c a^2/(l+1)),
    2^(-s) b_s(0) >= c (s+1)^(-3/2)                (s even).

The lower central bound and the exact reflection multiplier also give
the second display's lower bound at height zero. These estimates cover
`l=0` by changing the absolute constants.
Splitting a Dyck word at time `j` and reversing its final segment gives

    P(D=a) = b_j(a) b_(s-j)(a) / b_s(0)
       <= C (a+1)^2 d^(-3/2) exp(-c a^2/d).             (3.1)

Indeed, after exchanging the two segments, `j<=s/2`; the factors
`((s+1)/(s-j+1))^(3/2)` are bounded and the shorter segment supplies
the Gaussian decay.

The important extra input beyond the manuscript's `p=2` argument is

    ||(1+D)^(-1)||_p <= C_p / sqrt(d),       0<p<3,
    ||(1+D)^(-1)||_p <= C (3-p)^(-1/p) / sqrt(d),
                                               2<=p<3. (3.2)

To prove the quantitative second line, multiply (3.1) by `(a+1)^(-p)`.
The resulting sum of `(a+1)^(2-p) exp(-c a^2/d)` is at most
`C d^((3-p)/2)/(3-p)`. Below `sqrt(d)` this follows by integrating
`x^(2-p)`; on each subsequent dyadic annulus the Gaussian makes the
sum converge uniformly for `2<=p<3`. Consequently the `p`th inverse
moment is at most `C d^(-p/2)/(3-p)`. The first line below `p=2`
follows from monotonicity of norms, and the same summation proves it
throughout `p<3`. No limit in tree size is being used.

Similarly (3.1) gives `E[D^4]<=C d^2`. If a deterministic contour segment
has `L` steps, use the nested grids `floor(kL/2^r)`, down to unit spacing.
At level `r` there are at most `C 2^r` new-to-parent pairs, separated
by at most `C L 2^(-r)` steps. The `L^4` norm of the maximum of their
tree distances is at most

    C (2^r)^1/4 (L 2^(-r))^1/2
       = C sqrt(L) 2^(-r/4).

Include the first `0`-to-`L` pair. Every sampled vertex joins the first
through a chain of parent pairs. Summing this geometric bound and using
the triangle inequality shows

    ||diam{w_i,...,w_(i+L)}||_4 <= C sqrt(L).             (3.3)

The assertion is zero for `L=0`; for an entire contour take `L=s`.
All grids and endpoints here are deterministic before sampling the tree.

## 4. A genuinely uniform one-scale higher-moment bound

For dyadic `1<=M<=N/2`, let `E_M` contain the selected cuts with
`M<=ell_e<2M`, and set

    U_(M,t) = sum_(e in E_M, t in I_e) 1/b_e,
    K_(M,t) = #{e in E_M : t in I_e}.

We prove, uniformly over `n,M,t`,

    ||U_(M,t)||_p <= C_p                  (1<p<3),
    ||U_(M,t)||_p <= C (3-p)^(-1/p)       (2<=p<3).     (4.1)

Here are the schedule estimates with all exceptional events accounted for.
The Catalan formula implies

    P(J outside [N/4,3N/4]) <= C (N+1)^3 exp(-cN).       (4.2)

To see this without an asymptotic assumption, use
`C_k C_(n-k)<=4^n` and
`C_n C_(n+1)>=c 4^(2n)/(n+1)^3`. The sum of `binom(N,J)` over
these `J` is at most `2^N` times an exponentially small binomial tail.
The binomial tail follows from its generating function
`((1+exp(theta))/2)^N` and Markov's inequality at any fixed small
nonzero `theta`.

For a balanced `J`, the vertical slots are a uniform subset of size
at least `N/4`. For any deterministic set of `L` slots, with vertical
count `X` and density `q>=1/4`,

    P(X<=qL/2) <= exp(-c qL).                            (4.3)

For clarity, a direct sampling-without-replacement proof is available:
for `theta>0`, average products of `L` distinct members of the population
containing `Nq` copies of `exp(-theta)` and the remaining copies of `1`.
This average is at most `(1-q+q exp(-theta))^L`. The elementary symmetric
mean inequality used here follows by replacing any two population entries
by their average: at fixed sum, the elementary symmetric polynomial
increases, since its dependence on the pair is
`A + B(a+b) + C ab`, with `C>=0`. Repeatedly averaging a largest and
a smallest entry converges to the constant population: the variance
drops by half the squared difference at each step, and that difference
controls the current variance by a fixed factor depending only on `N`.
Continuity gives the asserted symmetric-mean inequality.
Markov's inequality with `theta=log(2)` bounds
the probability by
`exp(qL(log(2)/2-1/2))`. This proves (4.3) with absolute constants.

There are at most `C(M+1)^2` cyclic intervals containing a deterministic
`t` with length in `[M,2M)` and at most `N/2`. Both an interval and its
complement have at least `M` slots. By (4.3) and a union bound, except
on a schedule-only event of probability at most

    C(M+1)^2 exp(-cM),                                  (4.4)

each such interval and its complement have at least `M/8` vertical slots.
The value `1/8` may be replaced by any smaller absolute constant.

Fix a good balanced schedule and then the horizontal word. All selected
cut intervals are now fixed; the remaining word is still uniform vertical
Dyck. Each denominator is `1+D*`, whose two contour separations are
at least `M/8`. Minkowski and (3.2), with no independence between cuts,
give

    ||U_(M,t)||_(p,vertical)
       <= C(3-p)^(-1/p) M^(-1/2) K_(M,t).               (4.5)

We next justify the horizontal count, rather than assuming it. In a tree,
two edge-cut components containing one vertex are nested unless their
union is the entire vertex set. To prove this, root at that vertex.
The complementary components are descendant subtrees, and so are nested
or disjoint. The disjoint case gives the full-union alternative.
The alternative is impossible for two selected smaller sides containing
`v_t`: their masses are each at most `1/2`, and their intersection
contains the positive-mass vertex `v_t`. This is the strict finite-mass
lemma also checked in `Main.lean`. Thus all sides counted by `K_(M,t)`
are nested, including half-mass ties.

If there are any, take the largest side and a contour vertex immediately
outside its interval. That vertex is within `2M+2` tour steps of `t`.
The tree path from `v_t` to it crosses every counted edge. Hence
`K_(M,t)` is at most the horizontal-tree diameter of the deterministic
tour window of radius `2M+2` about `t`. Conditional only on the schedule,
this is a deterministic horizontal contour segment of at most `C M`
steps, or the whole horizontal contour if the window covers the tour.
Equation (3.3) therefore implies

    ||K_(M,t)||_(p | schedule) <= C sqrt(M),    2<=p<=4. (4.6)

Equations (4.5)--(4.6) bound the good-schedule contribution to (4.1).
For any schedule, every counted cut has its delimiting traversal occurrences
within that same `O(M)` window. Different edges have different occurrences,
so deterministically `U<=K<=C(M+1)`. Its bad-schedule `p`th moment is at most

    C^p (M+1)^(p+2) exp(-cM),

bounded uniformly for `2<=p<3`. On the unbalanced counts use `U<=N` and
(4.2), giving `C N^p (N+1)^3 exp(-cN)`, also uniformly bounded.
This proves (4.1), with a single absolute `C` in its second line.
For `1<p<2`, use the `L^2` bound.

Crucially, we never condition on a dual distance or a vertical-dependent
success event. The good event is determined by the schedule alone; the
smaller-side rule is determined by the schedule and horizontal word alone.

## 5. From a one-scale bound to simultaneous Green control

For each scale, choose a deterministic cyclic grid with `O(N/M)` points,
maximum gap at most `M/4`, and minimum separation at least `cM`.
For `M<8` take all tour times. For `M>=8`, one explicit choice is
`floor(jN/q)`, `0<=j<q`, where `q=ceil(4N/M)`.

Each interval of length at least `M` containing `t` contains a grid point
within cyclic distance `2M` of `t`. Only constantly many grid points lie
in this neighborhood, so positivity, assigning each interval to one such
point, gives `max_t U_(M,t)<=C max_grid U_(M,t)`. Define

    W_M = max_x sum_(e in E_M)
               (1_(x in S_e)+mu(S_e))/b_e.

All visits to a vertex lie in the same cut side, and the tour average of
`U` is `sum_e mu(S_e)/b_e`. Therefore `W_M<=2 max_t U_(M,t)`.
For any `p>=1`, `max_i a_i^p<=sum_i a_i^p`. With `h_M=2M/N`,
(4.1) yields

    ||W_M||_p <= C_p h_M^(-1/p),                1<p<3,
    ||W_M||_p <= C(3-p)^(-1/p) h_M^(-1/p),      2<=p<3. (5.1)

This is the step that benefits from `p>2`. Restricting to second moments
only gives a summable scale exponent when `rho<1/2`; that method alone
cannot establish the strengthened result.

Let `m=mu(|f|)`. The source of a cut at scale `M` has absolute value at
most `min(h_M,m)`, hence at most `h_M^(1-rho) m^rho`.
By (2.1), simultaneously for every admissible `f`,

    ||Gf||_infinity <= m^rho E_T[Y_n | M_n],
    Y_n = sum_M h_M^(1-rho) W_M.                        (5.2)

In particular the conditional expectation is a function of the map,
not of the source. Minkowski and (5.1) give

    ||Y_n||_p <= C_p sum_M h_M^(1-rho-1/p)
              <= C_p / (1-2^(-(1-rho-1/p))).

The last bound holds for every `n`: the largest `h_M` is in `(1/2,1]`
and the others decrease geometrically. The exponent is positive exactly
under the hypotheses of Theorem 1. Set `A_n=E_T[Y_n|M_n]`.
Conditional Jensen gives `E[A_n^p]<=E[Y_n^p]`. This proves Theorem 1.
The deterministic weighted-sum passage, including all-source quantification,
is separately formalized in `Main.lean`; its probabilistic hypotheses are
proved here, not by Lean.

## 6. The critical logarithmic modulus

Put `L(h)=1+log(1/h)` for `0<h<=1`. In (5.1) choose the deterministic
exponent `p=3-1/L(h)`, which lies in `[2,3)`. Since

    h^(-1/p) <= C h^(-1/3),
    (3-p)^(-1/p) = L(h)^(1/p) <= C L(h)^(1/3),

we obtain the scale-uniform expectation bound

    E W_M <= C h_M^(-1/3) L(h_M)^(1/3).                 (6.1)

For the first inequality, the logarithm of the extra factor is
`log(1/h)/(3p L(h))<=1/6`; for the second it is
`log(L(h))/(3p L(h))<=1/6`. Thus no constant is concealing a dependence
on `n` or on the chosen exponent.

For `beta>4/3` define

    Z_n = sum_M [h_M^(1/3)/L(h_M)^beta] W_M.

Equation (6.1) gives `sup_n E Z_n<infinity`, since the remaining series
is bounded by a constant times `sum_(k>=0)(1+k log(2))^(1/3-beta)`.
For all `0<h,m<=1`,

    min(h,m) <= C_beta m^(2/3) L(m)^beta
                             h^(1/3)/L(h)^beta.        (6.2)

If `h>=m`, dividing the left side by the right side without `C_beta`
gives `(m/h)^(1/3)(L(h)/L(m))^beta<=1`.
If `h<=m`, writing `z=log(m/h)>=0` bounds that ratio by
`exp(-2z/3)(1+z)^beta`, whose supremum is finite.
Apply (6.2) termwise in (2.1) and set
`B_n=C_beta E_T[Z_n|M_n]`. This proves Theorem 2 with exactly the same
simultaneity and map measurability as Theorem 1.

## 7. What is and is not certified

`verify.py` reconstructs every shuffle for `n=1,...,5`, including loops
and parallel edges. It checks that the reconstructed rotation has the
claimed primal and dual incidence cycles and Euler characteristic two.
It checks degree incidences, smaller-side measurability
for every vertical word at fixed schedule and horizontal word, exact
dual-distance cut sizes, nesting and local-diameter control, and reports
exact rational one-scale second moments. For `n<=4` it independently
enumerates all spanning trees of each resulting graph, solves the centered
Green equation over rationals, and checks (2.1). For plane trees with
one through seven edges it checks every deterministic-corner distance
distribution against the exact ballot formula.

The bounded typed Jacobian operation checks only the triangle Laplacian.
Its inspected contract is for simple graphs and offers no certification
of the Dyck, multigraph, or all-size probabilistic claims; that mismatch
is not papered over by changing the target. Its exact payload, contract,
typed output, protocol/server version, and adapter status are retained
in dedicated JSON files.

The finite experiments corroborate the bookkeeping, not the universal
inequalities or novelty. The universal reasoning is Sections 1--6,
including an explicit reconstruction of the known encoding bijection.
Lean certifies only the finite weighted-sum and positive-mass lemmas
listed in `statement_fidelity.md`. None of the manuscript's assertions
examined here has been found false, so no spurious `F_` refutation claim
is filed. Independent review, including scrutiny of the new moment and
critical-logarithm arguments, remains the delivery gate.

Replays:

    $WORKSPACE/argus-live-update/.venv/bin/python research/green_estimate/verify.py
    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/green_estimate/Main.lean --statement-fidelity research/green_estimate/statement_fidelity.md --claim L_GREEN_TRANSFER --project-root .
