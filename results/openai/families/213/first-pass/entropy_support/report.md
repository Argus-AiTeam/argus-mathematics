# Support-local entropy of adaptive transcripts

## Scope and source findings

This component concerns `lem:entropy` in the quasi-transitive manuscript,
`build/sections/two-cluster-dfs-entropy.tex`, and its use in
`eq:interpolation-pair-entropy` in `build/sections/interpolation.tex`.
It does not certify either manuscript's critical-percolation theorem.
The research target remains publishable and the objective mode exploratory.
Independent review has not yet occurred.

The ledger initially contained only the campaign objective, with no
mathematical supporting evidence. The two main assertions being audited are:

* The quasi-transitive manuscript, `sections/introduction.tex`, `thm:main`:
  every infinite connected locally finite quasi-transitive undirected graph
  with critical bond parameter less than one has no infinite cluster at
  its critical parameter.
* The cubic manuscript, `build/introduction.tex`, `thm:main`: nearest-neighbor
  bond percolation on Z^3 has no infinite cluster at its bond critical
  parameter, and nearest-neighbor site percolation has no infinite cluster
  at its separately defined site critical parameter.

The first manuscript separates exponential growth, superpolynomial
subexponential growth, and polynomial growth along an unbounded sequence.
Its superpolynomial branch uses the two-cluster estimate and finite
interpolation. Interpolation uses the depth-first pivotal second moment
and the present transcript inequality. The structured/polynomial branch
instead uses the nilpotent model, approximate moves, and corridor
exploration. The cubic manuscript uses a finite independent-hyperedge
connection comparison, extension and relay geometry, and sequential coarse
exploration. These other assertions are source-level obligations, not
results established here.

The primary upstream scope page `openai/math`, `lean/docs/213.md`, links
`lean/ComparatorChallenges/CriticalPercolation.lean` and `CriticalZ3.lean`.
Direct retrieval at revision
`4eaee87548250b2682affda7d05d947c05554bae` found `sorry` in their concluding
theorems. This limits those comparator files as proof evidence; it does
not refute either mathematical theorem.
The pinned primary texts are retained as `upstream_scope.txt`,
`upstream_CriticalPercolation.txt`, and `upstream_CriticalZ3.txt`.

The inherited Wiki was searched for percolation, adaptive transcripts,
Shearer inequalities, and Legendre polynomials. Its adaptive-support and
entropy-refinement pages concern different manuscripts, not this result.
A targeted literature lookup found fixed-set Shearer/relative-entropy
references and decision-tree literature, but no obtained primary source
establishing this precise support-local adaptive assertion. A search
summary is not evidence of novelty. NIST DLMF Sections 18.3 and 18.6 were
opened as background for the manuscript's Legendre calculation.

No unproved external mathematical proposition will be used in the proof
below: the finite entropy identities, Bernoulli bounds, pooling inequality,
and discrete polynomial calculation are derived explicitly. The fixed-set
Shearer shortcut is not a valid justification for adaptive read sets.

## Exact question

There are N independent Bernoulli(p) coordinates under mu, with 0 < p < 1.
There are m deterministic terminating query algorithms. Each algorithm's
next query or stop is a function only of its own previous queries and
answers, and no algorithm rereads a coordinate. Q is any law on the full
configuration space. Only on supp(Q), every coordinate is queried by at
most a algorithms. The question is whether

    sum_i D(Q_i || mu_i) <= a^2 D(Q || mu) / (2 p (1-p)).

Caching must not change any original algorithm's local path. Conditioning
histories for a local algorithm and a combined fresh-query algorithm must
not be conflated. The number of readers is allowed to depend on the
queried bit under Q.

## 1. Universal verification theorem and a finite-population refinement

For integers `1 <= b <= m`, define

    C(b,m) = sum_(k=0..b-1) (2k+1) product_(r=1..k) (m-r)/(m+r)
           = m [1 - product_(r=1..b) (m-r)/(m+r-1)].

An empty product is one. In particular,

    C(1,m) = 1,   C(m,m) = m,   C(b,m) <= b^2.

**Theorem.** Under exactly the hypotheses of `lem:entropy`, if `m >= 1`
and `b = min(a,m)`, then

    sum_i D(Q_i || mu_i)
        <= C(b,m) D(Q || mu) / (2 p (1-p))
        <= a^2 D(Q || mu) / (2 p (1-p)).

For `m=0` the left side is zero. There is no overlap assumption under mu,
no independence assumption under Q, and no restriction on the input size
or on the algorithms' finite adaptive paths.

There is a stronger nodewise version. At a positive-Q local pre-query
node h, let `a_h` be the largest number of readers of its queried bit
among configurations in `supp(Q)` visiting h. Let `r_h` be that bit's
conditional Q probability of one. Then

    sum_h Q(h) d(r_h || p) / C(a_h,m)
        <= D(Q || mu) / (2 p (1-p)).

Here h includes the algorithm's identity. This is a finite-population,
support-local verification theorem, not an assertion that the best
possible relative-entropy constant has been found. The endpoint constant
C is sharp for the polynomial problem below, not claimed sharp for
legal query algorithms. For `1 < b < m`, C is strictly smaller than b^2;
the elementary data-processing bound `m D(Q||mu)` can also be used.

### 1.1 Local chain rule, including stopping

Represent a deterministic algorithm by its finite binary query tree.
Every nonterminal node specifies its next coordinate. Along each path
coordinates are distinct. A leaf includes the deterministic stopping
decision. Its event is exactly the cylinder fixing the answers on its
path: any configuration with those answers follows the same path,
by induction on the queries. Consequently its mu probability is
`p^(number of ones) (1-p)^(number of zeros)`.

At a node h with positive Q probability, put `b_h = r_h-p`.
The ratios of Q probabilities of a child and its parent telescope along
each leaf. The corresponding mu child-to-parent ratios are p and 1-p.
Multiply their logarithms by leaf probabilities and sum to obtain

    D(Q_i || mu_i) = sum_(h in algorithm i) Q(h) d(r_h || p).

No separate stopping or query-label entropy is omitted: both are
deterministic functions of the preceding answers.

For `0<r<1`, `log u <= u-1` gives

    d(r||p) <= r(r/p-1) + (1-r)((1-r)/(1-p)-1)
            = (r-p)^2 / (p(1-p)).

The endpoint cases follow by continuity. Conversely, as a function of r,
`d''(r||p)=1/(r(1-r)) >= 4`. The value and first derivative vanish
at p, so integrating the second derivative on either side of p proves

    d(r||p) >= 2(r-p)^2.

This also extends to r=0,1 by continuity.

### 1.2 The cached global history is a legal fresh-query history

Fix a permutation pi of the algorithms. Run the algorithms in that
order. The cache stores every coordinate read by an earlier algorithm,
with its answer. An algorithm retains its own original local state.
When it requests a cached coordinate, supply that answer and update
only its local state; otherwise query the configuration and cache it.
Induction on local steps proves that its entire ordered local path,
including its stopping decision, is unchanged.

Given pi and the preceding *fresh* queries and answers, one can simulate
all intermediate cached reads and stops. Thus one knows the cache,
the current algorithm, its local node h, and its next coordinate e
before querying e. In particular, "this visit to h is fresh" is determined
by the global pre-query history. It is not a test of the as-yet unread
answer. The next fresh coordinate is not in the cache.

The same induction as in 1.1 shows that a global prefix is a cylinder
on its distinct previously fresh coordinates. Under mu the next fresh
answer is therefore Bernoulli(p), even on inputs outside supp(Q),
where many more than a algorithms might use a coordinate. This proves
the reference distribution required by the global chain rule.

Let g run over global fresh-query nodes for all permutations. Set

    rho_g = Q(global prefix g) / m!,
    beta_g = E_Q[X_e-p | global prefix g],
    S = sum_g rho_g beta_g^2.

Zero-Q nodes contribute zero. For each fixed pi the fresh transcript
Gamma_pi is a deterministic function of the input. Decomposing
`D(Q||mu)` over its fibers gives

    D(Q||mu) = D(Q_Gamma || mu_Gamma)
             + sum_t Q_Gamma(t) D(Q(.|t) || mu(.|t)).

The conditional divergences are nonnegative by `log u <= u-1`.
Use the global chain rule and the lower Bernoulli bound, then average
over the finite set of permutations:

    S <= D(Q||mu)/2.                                      (1)

The bias beta_g conditions on the full global prefix. It is not
identified with the local bias b_h.

### 1.3 Exact finite-rank pooling with bit-dependent reader counts

Fix a positive-Q local node h in algorithm i, querying e. For a fixed
configuration omega visiting h, its original reader set

    R_e(omega) = {algorithms whose original path reads e}

contains i. It is unchanged by caching, although it can depend on X_e.
Write `k=|R_e(omega)|`. Conditional on i having rank `j in {0,...,m-1}`,
its predecessors form a uniform j-subset of the other m-1 algorithms.
Its query at h is fresh precisely when this subset misses the other
k-1 readers. Equivalently all those readers are in the m-1-j later
positions. The exact probability is

    f_k(j) = binom(m-1-j,k-1) / binom(m-1,k-1).            (2)

Here the numerator is zero when `m-1-j < k-1`. As a function of real j,
the falling-factorial definition of the numerator makes f_k a polynomial
of degree k-1. Its values on the integer grid are the stated probabilities.
For k=1 it is identically one.

Define, without factoring any dependence out of either expectation,

    w_h(j) = E_Q[f_(K_e)(j) | h],
    z_h(j) = E_Q[(X_e-p) f_(K_e)(j) | h].

Then `0 <= w_h(j) <= 1`, `z_h(0)=b_h`, and z_h is a polynomial of
degree at most a_h-1. The support-only overlap hypothesis is used
exactly here, after conditioning on h under Q.

Group the nodes g by the current local node h and the current algorithm's
rank j. The group is determined before the fresh bit is read, by 1.2.
The conditional expectation identity and (2) give the two exact equalities

    sum_(g in group(h,j)) rho_g
        = Q(h) w_h(j)/m,
    sum_(g in group(h,j)) rho_g beta_g
        = Q(h) z_h(j)/m.                                 (3)

In the second equality the tower property is legitimate because group
membership is measurable in the *global pre-query* history. It does
not require K_e to be measurable in the local history.

For nonnegative weights u_l and real v_l, expansion of
`sum_(l,t) u_l u_t (v_l-v_t)^2 >= 0` proves

    (sum_l u_l v_l)^2 <= (sum_l u_l)(sum_l u_l v_l^2).

Apply this to each group in (3). Its squared-bias energy is at least

    Q(h) z_h(j)^2 / (m w_h(j))
        >= Q(h) z_h(j)^2 / m.                            (4)

If w_h(j)=0, every nonnegative f_(K_e)(j) is zero on this conditional
support, hence z_h(j)=0; (4) means 0>=0 and involves no division.
Every global fresh query belongs to exactly one group. There is no
double charging across local histories or ranks.

### 1.4 Universal finite-grid endpoint inequality

We prove the exact algebraic ingredient, rather than assuming a
fixed-read-set entropy theorem or a Legendre citation. For `0<=k<m` put

    G_k(x) = sum_(r=0..k) c_(k,r) binom(x,r),
    c_(k,r) = (-1)^r binom(k,r) binom(k+r,r) / binom(m-1,r).

These are real polynomials of degree k with `G_k(0)=1`.
Use the inner product `<f,g> = (1/m) sum_(j=0..m-1) f(j)g(j)`.
Define

    (Lf)(j) = (j+1)(m-1-j)(f(j+1)-f(j))
              + j(m-j)(f(j-1)-f(j)).

The apparent out-of-grid terms at j=0,m-1 have coefficient zero.
Writing the sum as a sum over neighboring pairs gives

    <f,Lg> = -(1/m) sum_(j=0..m-2)
                  (j+1)(m-1-j) Delta f(j) Delta g(j).

Thus L is self-adjoint. In the binomial polynomial basis,

    L binom(x,r) = -r(r+1) binom(x,r)
                   + r(m-r) binom(x,r-1),                (5)

with the second term zero for r=0. One obtains (5) directly from
`Delta binom(x,r)=binom(x,r-1)` and
`x binom(x,r-1)=r binom(x,r)+(r-1)binom(x,r-1)`.
For `0<=r<k<m`,

    c_(k,r+1)/c_(k,r)
        = -(k-r)(k+r+1)/((r+1)(m-r-1)).

Substitution in (5) proves `LG_k=-k(k+1)G_k`.
At r=k the next coefficient is zero and is treated separately;
there is no division by m-k-1 at the top-degree boundary.
Distinct eigenvalues and self-adjointness imply that the G_k are
orthogonal. Their nonzero leading coefficients and distinct degrees
make them a basis for all functions on these m grid points.

Here are the norms, including their derivation. Reflection
`j -> m-1-j` commutes with L. Uniqueness of the degree-k eigenpolynomial
with its leading coefficient gives
`G_k(m-1-j)=(-1)^k G_k(j)`. Consequently the coefficient of G_k
in the orthogonal expansion of xG_k is `(m-1)/2`.
Orthogonality and multiplication by x show that the coefficients at
degrees below k-1 vanish. Leading coefficients give

    A_k = -(k+1)(m-1-k)/(2(2k+1))

for the G_(k+1) coefficient. Evaluation at x=0, where every G is one,
then gives the G_(k-1) coefficient

    B_k = -k(m+k)/(2(2k+1)).

At k=m-1, xG_k is expanded as a function on the grid, not as a degree-m
polynomial; A_k=0, and reflection, orthogonality, and evaluation at
zero give the same B_k. At k=0 the absent lower term is zero.
Writing `N_k=<G_k,G_k>`, self-adjointness of multiplication by x gives

    N_0 = 1,
    N_k/N_(k-1) = B_k/A_(k-1)
                = (2k-1)(m+k)/((2k+1)(m-k)),
    1/N_k = (2k+1) product_(r=1..k) (m-r)/(m+r).           (6)

All denominators in (6) are positive for `1<=k<m`.
For `z=sum_(k<b) u_k G_k`, finite Cauchy--Schwarz now gives

    z(0)^2 = (sum_(k<b) u_k)^2
           <= (sum_(k<b) 1/N_k)(sum_(k<b) u_k^2 N_k)
           = C(b,m) (1/m) sum_(j=0..m-1) z(j)^2.          (7)

Equality occurs for `z=sum_(k<b) G_k/N_k`; hence this polynomial
constant is exact. Each ratio in its defining product lies in (0,1),
so `C(b,m)<=sum_(k<b)(2k+1)=b^2`. The stated product expression for C
follows by telescoping successive products; it also gives C(m,m)=m.
This proof applies to every pair of integers `1<=b<=m`, not just the
parameter values replayed by the script.

### 1.5 Completion of the adaptive theorem

Sum (4) over ranks, apply (7) to z_h, and then sum over local nodes:

    sum_h Q(h) b_h^2 / C(a_h,m)
        <= sum_g rho_g beta_g^2
        = S
        <= D(Q||mu)/2.

This proves the nodewise assertion using the upper Bernoulli bound.
Since `a_h<=min(a,m)` and C increases with its first argument, the
local chain rule proves the displayed theorem. Every configuration,
history, and permutation space used in the proof is finite, but its
size was arbitrary. No finite search is being used as a proof of the
universal assertion.

There is an equivalent reconstruction form used by the formal core.
Let `K_h(j)=sum_(k<a_h) G_k(j)/N_k`. Orthogonality gives

    (1/m) sum_j K_h(j) z_h(j) = z_h(0),
    (1/m) sum_j K_h(j)^2 = C(a_h,m).

For each h give global node g weight rho_g if it belongs to h, zero
otherwise; use coefficient K_h(rank(g)) and bias beta_g. Equation (3)
then gives exact weighted reconstruction `Q(h)b_h`. Its squared
coefficient norm is

    Q(h) (1/m) sum_j K_h(j)^2 w_h(j) <= Q(h) C(a_h,m).

Weighted Cauchy--Schwarz proves the same nodewise and summed budget.
In particular there is no assumption that the coefficient, the
freshness weight, and the conditional bit bias are independent.

## 2. Precise consequence for interpolation

Work under the descriptor fixed in `sections/interpolation.tex`, before
any active contact is opened. Take the configuration marginal Q_Omega
of the joint law Q of configurations and chosen marks.

For each fixed active index i, both w_i and the anchor of its active
parent are deterministic after descriptor conditioning. The standalone
pair algorithm exposes the two exact original clusters, including every
incident edge and every internal edge. Use any fixed exploration order,
cache a repeated incidence inside this algorithm, and record the full
query transcript. This is a deterministic terminating no-reread
algorithm on every configuration, not just under Q. Its transcript
depends on Omega alone, not on the randomly chosen contact.
Indeed, all ancestors of an active cluster are active or bases, their
creation times increase along a chain, and its parent is exactly the
preceding active index on its side, or that side's base. Thus no
contact-dependent parent selection remains inside the pair algorithm.

On supp(Q_Omega), the original nonhold clusters are distinct. The active
clusters on each side form one ancestry chain rooted at its base.
A cluster is in at most two pairs: once as a child and once as parent
of the next active child. A base is in at most one pair. The two sides
use disjoint original clusters. An edge has endpoints in at most two
original clusters; even a parallel edge is a distinct bit and a loop
meets only one cluster. Since each pair algorithm reads each incidence
bit at most once, every bit is read by at most four pair algorithms.

This argument is deliberately only on the conditioned support.
On an ordinary mu configuration the anchors may lie in merged clusters
and a bit might be read by many more pair algorithms. Section 1 does
not require otherwise.

Let `m=|I_*|`. For m=0 the sum in the target equation is empty. For m>0,
the theorem gives

    sum_(i in I_*) D(Q_(t_i) || mu_(t_i))
       <= C(min(4,m),m) D(Q_Omega || mu)/(2p(1-p))
       <= 8 D_Omega/(p(1-p)).

The pushforward of the joint Q to t_i is the same as the pushforward
of Q_Omega, so this is exactly `eq:interpolation-pair-entropy`.
Thus one may take `C_p=8/(p(1-p))` there, uniformly when p and 1-p
are bounded below. For `p in [epsilon,1-epsilon]` the displayed choice
is at most `8/(epsilon(1-epsilon))`.

This removes the stated support/conditioning concern at that equation.
It does not prove the pivotal second moment, the density/inverse-contact
calculations, the rest of interpolation, either growth reduction, or
either main criticality theorem. No false assertion in the scoped
manuscript argument has been demonstrated, so no refutation judgement
is warranted.

## 3. Exact certificate and limits of its mechanical scope

Run, from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/entropy_support/verify.py

`exact_certificate.json` contains the exact rational regression input,
expected structural quantities, and the symbolic induction identities
used in Section 1.4. The verifier checks those identities as rational
functions of unrestricted symbols; the induction, finite-dimensional
orthogonality argument, and probabilistic interpretation are proved
above. It also checks the actual adaptive cache, distinct conditioning
histories, reference transition probabilities, pooling identities,
endpoint energies, and entropies for the explicit regression instance.
The general algorithm-replay function accepts an arbitrary finite
instance through `--instance`; it has no mathematical size cutoff.
Its cost is exponential/factorial, so this is a replay interface, not
an efficient decision procedure. The 48-term logarithm enclosure can
be insufficient for a new near-equality input; in that case replay
refuses to certify the comparison, not declares a counterexample.

The regression has three bits x,y,z and three algorithms:

    A0: read x.
    A1: read y; if y=1 read x.
    A2: read z; if z=1 read x.

Take p=1/2 and

    Q(000)=1/4, Q(110)=3/8, Q(101)=3/8.

The bit strings are in x,y,z order. Overlap on supp(Q) is two,
whereas under mu it reaches three on y=z=1. K_x is one when x=0
and two when x=1 on supp(Q). In particular it is not independent
of the queried bit. At the root of A0 the rank-conditioned arrays are

    z = [1/4, 1/16, -1/8],
    w = [1,   5/8,  1/4].

The local bias is positive, while at rank two the fresh conditional
bias is negative. Pulling the freshness probability out of the signed
expectation would give the wrong answer. Nevertheless the correct
pooled identities hold exactly. Rational atanh-series enclosures
certify every logarithm used for the regression inequalities; no
floating-point comparison is used.
For `1<=x<=2`, set `y=(x-1)/(x+1)`. Integrating the finite geometric
expansion of `2/(1-y^2)` from zero to y gives

    log x = 2 sum_(j=0..t-1) y^(2j+1)/(2j+1) + R,
    0 <= R <= 2 y^(2t+1)/((2t+1)(1-y^2)).

Reciprocals and powers of two reduce every positive rational argument
to this interval. All endpoints used by the verifier are rational.

Jacobian discovery found no matching adaptive-entropy operation.
The inspected `matrix.inertia.compute` operation does match the bounded
algebraic postcondition for the interpolation value a=4: the matrix

    M_(r,s) = 16/(r+s+1)-1,  0<=r,s<4

is positive semidefinite. The first request redundantly supplied both
matrix triangles and was rejected by the adapter. Its exact payload,
structured error, and exit status 2 are retained in `jacobian_payload.json`,
`jacobian_result.json`, and `jacobian_status.json`. This rejection is
not a mathematical conclusion.

The corrected upper-triangle request is retained separately with its
typed result and status in `jacobian_upper_*.json`. It returned inertia
(3,0,1), `positive_semidefinite`, adapter exit status 0, server 0.14.0,
protocol 2025-11-25. `verify.py` independently reconstructs its source
matrix and an exact rational LDL congruence. This bounded matrix
calculation alone is not the adaptive theorem.

`Main.lean` provides a second, universally quantified mechanical check
of the *weighted pooling and budget-transport core*. The official
`lean_evidence verify` run used Lean 4.31.0 and returned exit_code=0,
audit_exit_code=0, and proof_holes=[] for `C_ENTROPY_POOLING`.
The result is in `lean_verification_result.json`, with the claim-bound
certificate archived under `lean_artifacts/certificates/`.
The first compile's type error and recording refusal are retained in
`lean_initial_result.json`; they are not mathematical refutations.
The source and its fidelity document were corrected before the
successful run and have not been edited since that run.

The quantified formal theorem takes arbitrary finite local/global
index sets, nonnegative weights, and arbitrary real biases and
reconstruction coefficients. Exact weighted reconstruction and its
norm bound imply the nodewise and summed energy inequalities, even
when weights and biases are dependent. A further declaration transports
an arbitrary quadratic local cost and global entropy budget.
`statement_fidelity.md` spells out both the concrete interpretation
and the formal omissions. The decision-tree construction, finite-rank
pooling identities, polynomial kernel, and KL identities are proved in
the report, not formalized in Lean. The full entropy claim must not
be labelled `closed_kernel` on the strength of this core certificate.

The certificate does not claim that Python is a proof-assistant kernel,
that a finite regression proves a universal result, or that either
percolation theorem has been formalized. The complete universal
mathematical proof is Sections 1 and 2, which require independent
Reviewer scrutiny.

## 4. Prior-result and literature comparison

The improvement over the initial project state is a complete all-size
adaptive proof, an exact finite-permutation refinement, and a justified
application with explicit constant; previously only the source claims
and the unsupported comparator status were known.

The following primary sources were obtained in a bounded literature
lookup, but none is an unproved input to the proof above:

* Gavinsky, Lovett, Saks, Srinivasan, *A Tail Bound for Read-k Families
  of Functions*, arXiv:1205.1478, Section 2.3, Corollary 2.8:
  the relative-entropy bound uses fixed coordinate sets with bounded
  multiplicity and independent uniform reference coordinates.
  <https://ar5iv.labs.arxiv.org/html/1205.1478>
* Dinur, Keller, Marmor, *Non-Adaptive Cryptanalytic Time-Space Lower
  Bounds via a Shearer-like Inequality for Permutations*,
  arXiv:2505.00894v2, Section 2.4, Theorem 7: its input is a random
  bijection and its coordinate subsets are fixed. It is not a theorem
  about permuting adaptive query algorithms.
  <https://arxiv.org/html/2505.00894v2#S2.SS4>

Neither obtained statement supplies the support-only adaptive hypothesis.
The discrete orthogonal-polynomial endpoint fact is classical.
No verified-new or publishable-novelty claim follows from this bounded
lookup. Those campaign-level judgements remain for independent review.
