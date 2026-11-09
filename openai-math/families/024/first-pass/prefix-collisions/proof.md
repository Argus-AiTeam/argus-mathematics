# Ordered prefix collisions: scoped theorem and proof

## Statement and dependency boundary

The target is exactly `collisions.tex`, Proposition `prop:collisions`, in
`research/openai_manuscript/An-asymptotic-formula-for-the-number-of-totients-September-25-2026/build/source/`.
All parameters, including `m`, `R`, `L`, and the definition of a good tuple,
are formed from **x**, also when the value endpoint is x/c. The count is of
**ordered pairs of distinct tuples**, not of values, witnesses, or tail
preimages. H is fixed before x tends to infinity.

The route uses Ford, *The distribution of totients*,
arXiv:1104.3264v2 (14 July 2013), Lemma 5.1, pp. 21--24, with its original
size, cutoff, and gap restrictions. The primary PDF and its extracted text
are in `literature/`. Its root rho is the manuscript's root by (1.3)--(1.4);
in particular 0.54 < rho < 0.545.

The independent comparison in `layers.tex` is **not** an assumption of this
route. The projected-prefix reciprocal mass needed in the final summation
will be derived from elementary simplex volume and Mertens' estimate, not
assumed from the full asymptotic theorem. The prime number theorem can be
replaced here by the elementary upper bound pi(X) = O(X/log X).

No certificate for the main totient asymptotic, extraction coverage,
discarded-tuple estimate, limiting coefficient, or companion theorem is
asserted by settling this proposition. Novelty and publishable significance
remain matters for independent review, not consequences of compilation.

## Formalization boundary

The formal certificate concerns the finite combinatorial recovery
bound, with arbitrary slot and occurrence counts, repeated residual prime
factors, and the product of the two residual recovery counts. It will not
claim that Lean verifies Ford's analytic sieve theorem, real asymptotics,
or the full proposition.

## Quantitative transfer theorem

There are absolute C,kappa > 0 and H0 such that, for fixed H >= H0 and
sufficiently large x, simultaneously for **every** 0 <= t <= x,

    K(t) / (x G_m / log x)
      <= C exp(-kappa B/m^4)
         + C sum_{h>=H} h^4 exp(-kappa rho^(-h)/h^3).                 (T)

Here G(t) is defined using the same parameters from x. In particular (T)
proves `prop:collisions`, with a convergent tail tending to zero. The
constants are uniform in the phase. This is a prose analytic theorem,
using the external comparison theorem specified below. It is not a
numerical claim about an unspecified implied constant.

### 1. Uniform scales and actual Ford restrictions

Write beta=b_i=alpha h rho^(-h), h=m-i, and J=ceil(30 log h).
For all sufficiently large x, uniformly in its phase, one may use
1/2 <= alpha <= 3 and
0.99 <= alpha_theta/alpha <= 1. The latter follows from
`extraction.tex`, `eq:alpha-comparison`. The order of limits is important:
x is chosen sufficiently large after H, not after each individual h.
All estimates below then hold simultaneously for H <= h <= m.

The root bounds imply 3/5 < lambda=log(1/rho) < 2/3. Thus

    J < h/2,
    c h^(-20) <= b_{i+J}/beta = (1-J/h) rho^J <= C h^(-18),
    log beta = O(h).                                                 (1)

These are uniform asymptotic assertions, not a check of finitely many
layers. The root bounds and a geometric-ratio majorant for every
polynomial-times-exponential error are also checked by exact rational
arithmetic in `verify.py`.
Since P=floor(log log H)<h/2, (1) also gives i+J<L=m-P.

Fix i and consider pairs of suffix tuples
`(p_i,...,p_R,d)` and `(q_i,...,q_R,d')` arising from good tuples,
with p_i != q_i. Every distinct collided tuple pair has a unique first
unequal prime index: equality of all displayed primes would force d=d'
and hence equality of the tuples. Their common suffix value is v.
For i=0 take y=x; for i>=1,
put v in (y/2,y]. All statements involving i=0 use u_0=B, not
log_2 p_0. Choose one witnessing continuation per suffix-pair being
counted. Existence suffices: the good conditions hold for every witness.
Counting all admissible comparison data is an upper bound regardless
of which continuation is selected.

The logarithm of the preimage suffix after p_i is at most

    h exp(0.62 beta) + exp(2 tilde_b_L).                              (2)

Indeed 1.1 tilde_b_{i+1} < 0.62 beta, and there are at most h later
displayed primes. Also 2 tilde_b_L < 0.61 beta uniformly for h>=H
once H is large: P=floor(log log H), so
tilde_b_L/beta <= C(P/h)rho^(h-P). In comparison
log p_i >= exp(0.88 beta). For both witnesses this proves

    p_i,q_i >= y^0.9,
    0.88 beta <= B_y=log_2 y <= 1.12 beta,
    u_i <= B_y+O(1).                                                 (3)

For i=0 the first bound is a basic-witness condition and B_y=beta=B.
For i>=1, use p_i-1 <= v <= p_i times its preimage tail, and y<2v.
The harmless additive constants are absorbed uniformly because beta
grows exponentially in h.

Put D=phi(p_{i+J+1}...p_L a), and similarly D'. Coprimality of
the preceding displayed primes with this tail gives the exact identity

    D product_{j=0}^J(p_{i+j}-1)
      = D' product_{j=0}^J(q_{i+j}-1) = v.                           (4)

Here i+J<L. Repetition of p_L inside a is therefore entirely inside
D and does not invalidate (4). Both residuals have largest prime
factor < z=exp(exp(0.7 b_{i+J})).

Normality and p_{i+j}-1 <= y give Omega(p_{i+j}-1) <= 4B_y.
Consequently, for A_j=P^+(p_{i+j}-1),

    log_2 A_j = u_{i+j}+O(log beta),                                (5)

and the analogous formula holds on the other side. The original bands
are disjoint and decreasing, with gaps at least c beta h^(-20).
This dominates the O(log beta) error. In particular every A_j,A'_j
exceeds z.

Let delta=sqrt(log_2 S/B_y), where log_2 S=beta^(1/3).
Then delta=O(beta^(-1/3)). The normality comparison on the interval
between A_j and A'_j gives

    |log_2 A_j-log_2 A'_j| <= (2j+1) delta B_y.                       (6)

For example, if the left endpoint is A'_j<A_j, the first j+1
left shifts contribute at least (e-delta)B_y each to (A'_j,A_j],
where e is the normalized gap; only the first j right shifts can
contribute, at most (e+delta)B_y each. The residuals contribute
nothing. Hence (j+1)(e-delta) <= j(e+delta). The reversed ordering
is identical. The lower endpoint exceeds S. If an upper endpoint
is beyond a shift, cap it at that shift; this only decreases an
upper bound. All lower bounds concern shifts reaching the endpoint.

Cancel equal displayed primes. They can coincide only at the same
original index. The index zero of (4) survives. Let b be the number
of surviving indices and r the product of the canceled shifts.
There are 1 <= b <= J+1 <= B_y surviving indices.

We apply Ford with k=b, **ell=1 and f_1=1**, d=D and e=D'.
Adding the unit factor does not change (4), and makes the use of
the smooth-factor exponent uniform even at b=1. We do not need a
degenerate k+ell=1 interpretation of that exponent.

Use the Ford last cutoff

    V_b=exp(exp(0.75 b_{i+J})),                                     (7)

slightly **above** z, not equal to z. This matters: Ford's condition
(1) excludes a square of a prime **at least** V_b, whereas the
manuscript assumes squarefreeness only **above** z. With (7) the
implication is exact, even if a real cutoff happens to be prime.
No transcendence assertion about the cutoffs is required. The
residuals are V_b-smooth, and Omega(f_1)=0.

For each positive surviving index j_k, take a closed interval on a
delta-grid containing the two normalized largest factors in (6),
of width O(J delta). Denote its upper and lower cutoffs by V_k,U_k.
Let V_0=y and log_2 U_0=0.8 B_y. These intervals are strictly
ordered. Their normalized gaps, including the gap down to (7),
are at least c h^(-20), hence greater than 2 delta. The smallest
gap is positive because 0.9 tilde_b_{i+J} exceeds
0.75 b_{i+J}+O(log beta). All positive upper endpoints are below
height 0.75 for H large, since
u_{i+1}/B_y <= 0.62/0.88 < 0.705. The top largest factors are
above height 0.9. This also handles b=1, when V_1=V_b and
there are no positive-index grid intervals.

In particular Ford's additional first-cutoff restriction holds:

    log V_1 <= exp(0.75 B_y) <= log y/(10 B_y),
    V_1 <= y^(1/(10 B_y)).                                        (8)

For the original r and D, (2) also bounds their logarithms by
(h+1)exp(0.62 beta). In view of (3),

    max(log r,log D)/log y
       <= (h+1)exp(-0.26 beta) -> 0                               (9)

uniformly for h>=H. Thus r<=y^(1/10) and D<=y^(1/100).
The assumption on the unit factor, and all ordered-cutoff and
normality assumptions, are now verified, not discarded.

Finally the part of p_i-1 supported on primes <=V_1 has logarithm
at most 4B_y log V_1. By (8) and the stronger height bound 0.75,
this is o(log y). Since p_i>=y^0.9, the complementary part is
greater than sqrt(y). This proves Ford's condition (4).
The whole common product is squarefree on primes >z by the good
conditions and residual smoothness. Canceling r preserves it,
so Ford's individual-shift squarefreeness condition follows as well.
The extra k<=B_y used in Ford's proof on p. 23 is also satisfied.

### 2. Strict slack and growing b

Let nu_k=log_2 V_k/B_y and mu_k=log_2 U_k/B_y.
Because a_j is increasing, and j_k>=k, positivity and the strict
good-witness simplex inequality imply

    sum_{k=1}^{b-1} a_k nu_k
      <= B_y^(-1) sum_{j=1}^J a_j u_{i+j}
           + O(J^2 log(2J) delta)
      <= 1-h^(-4) + O(B_y^(-1)+J^2 log(2J) delta).                 (10)

The error E in Ford's lemma is O(J^2 log(2J) delta) too.
Since beta is exponentially large in h, these errors are
o(h^(-4)) uniformly for h>=H. The exponent in Ford's logarithmic
factor is therefore at most -1-1/(2h^4).

Ford counts ordered displayed primes, the unit factor (in a larger
set of allowed f_1), and the residual e=D'. Thus his bound here is

    y/(rD log y) * (C B_y^6)^b * (b+1)^Omega(D)
      * (log V_b)^[1+20(b+1)log(b+1)]
      * exp(-B_y/(2h^4)).                                        (11)

There is no fixed-layer restriction in (11): the constant per layer
is raised to b. In particular b=1 is included. This is an upper
bound on auxiliary representations, which is the direction needed.

### 3. Recovering both ordered tuple tails

For n>=1 and k>=1, every ordered multiplicative k-factorization
of n is obtained by assigning its Omega(n) labeled prime occurrences
to k labeled slots. An exponent distribution of a repeated prime
has at least one such assignment; different assignments may give
the same factorization, which only helps the upper bound. Hence

    #{(n_1,...,n_k): n_j>=1, product n_j=n} <= k^Omega(n).           (12)

This is the universal statement formalized by
`mem_factorizations_iff` and `ordered_factorizations_bound` in
`Main.lean`, not an extrapolation from small integers.

If R>i+J, the forgotten tuple coordinates satisfy the exact ordered
factorization

    D = d product_{j=i+J+1}^R(p_j-1).                              (13)

There are at most h+1 slots. Once their factors are fixed, every
prime coordinate is recovered uniquely by adding 1 and d is fixed.
The multiplicativity in (13) is valid because the displayed primes
are distinct and the remaining preimage w is <p_R, so is coprime
to all these primes. The inequality w<p_R itself follows from
(2)--(3) with i=R; no extraction-coverage theorem is needed.
Repetitions inside w stay inside d.

If R<=i+J there are no missing tuple primes:
d=D product_{j=R+1}^{i+J}(p_j-1), with the empty product equal to 1.
The same statements apply independently to the primed side.
Thus, **including both residuals**, the extra multiplicity is at most

    (h+1)^[Omega(D)+Omega(D')]
       <= exp(2 beta log(h+1)/h^8).                               (14)

`two_residuals_bound` proves the Cartesian-product bound in (14)
for arbitrary two slot counts <=h+1. No division by factorials,
unordering of the tuples, or assumption of squarefree residuals
occurs. Two ordered suffix tuples giving the same selected
comparison data and the two factorizations (13) are identical.
This proves the required injectivity into the counted auxiliary data.

### 4. Summing the auxiliary data

There are at most 2^(J+1) canceled-index sets. Each canceled prime
has reciprocal-shift sum O(beta), by Mertens' estimate. There are
at most (C/delta)^[2(J+1)] grid choices. Together with (C B_y^6)^b
these costs have logarithm O(h^2), since log beta=O(h).

Use the restrictions Omega(D),Omega(D')<=beta/h^8 **before**
enlarging the smooth sums. This bounds both (14) and
(b+1)^Omega(D) in (11). The remaining D-sum is

    sum_{P^+(D)<z} 1/D <= product_{p<z}(1-1/p)^(-1) = O(log z).    (15)

Repeated powers are included in this Euler product. The logarithm
of the factor involving V_b in (11), together with (15), is
O(beta log h log log(3h)/h^18). Altogether the positive logarithmic
cost is

    O(h^2)
      + O(beta log h/h^8)
      + O(beta log h log log(3h)/h^18)
      = o(beta/h^4).                                              (16)

For clarity, the ratios to beta/h^4 are bounded by constants times

    h^5 rho^h,  log h/h^4,  log h log log(3h)/h^14,                 (17)

respectively. These limits are uniform on the entire tail h>=H.
The script proves a single exact geometric-ratio majorant for the
polynomial/exponential terms, rather than testing selected h.
The constants in the O-notation need not be numerically known to
deduce (16); no numerical failure against an unspecified constant
is being used.

After absorbing (16) into the strict saving in (11), for an
absolute kappa>0 the number of ordered suffix-tuple pairs in
(y/2,y] is at most

    C y/log y * exp(-kappa B_y/h^4).                               (18)

For i=0 the same estimate, with y=x, counts all pairs first differing
at zero. The selection of witnesses does not multiply this count:
we have bounded the larger set of all auxiliary descriptions and
proved that a description recovers at most one ordered suffix pair.

### 5. Projected prime-prefix mass, without the main asymptotic

Here is an elementary derivation of the projected-prefix estimate
needed for restoration. For 0<=j<=R, first take the simplex with
coefficients all 1. The triangular change of variables

    s_i=u_i-sum_{r=i+1}^j a_{r-i}u_r  (1<=i<=j)

has determinant 1. Its inverse is
u_i=sum_{r=i}^j g_{r-i}s_r, by the recurrence for g.
The zeroth inequality becomes sum_{r=1}^j g_r s_r<=B.
Consequently its volume is exactly
G_j=B^j/(j! product_{r=1}^j g_r), also for j=0.

No recurrence asymptotic is needed to compare this with G_m.
Induction using sum_{d>=1}a_d rho^d=1 gives

    0 < rho^j g_j <= 1.

Since B=alpha m rho^(-m), it follows, with q=m-j, that

    G_j/G_m
      = product_{r=j+1}^m (r g_r/B)
      <= alpha^(-q) rho^[q(q-1)/2] <= C.                           (19)

The last constant is uniform because alpha>=1/2 and rho<0.545.

Cover the projected prime region by half-open unit boxes in
u_i=log_2 p_i. Perturbing coordinates by at most 1 changes the
ith simplex inequality by O(h_i^2). The basic lower bands
u_i>=c h_i rho^(-h_i) absorb this after replacing xi_i by

    beta_i=1+C(exp(-h_i/40)+h_i^2 rho^h_i),  beta_j=1.

The map u_i -> u_i / product_{r<i} beta_r sends this enlarged
simplex into the unit-coefficient simplex. Its inverse Jacobian
is product_{r<j} beta_r^(j-r), bounded by

    exp(C sum_{h>=H} h(exp(-h/40)+h^2 rho^h)) <= C.                 (20)

For each box, Mertens' prime-sum estimate gives
sum_{n<=log_2 p<n+1}1/(p-1)=1+O(exp(-n)).
The product of these errors is uniformly bounded because the lower
bands grow geometrically as h increases. Using (19)--(20), the
reciprocal-prime mass of all the projected boxes is therefore
O(G_m). The same proof includes j=0, whose mass is 1.
This proves the required instance of `eq:projected-mass` without
assuming extraction coverage, discarded-tuple bounds, or the
totient asymptotic.

### 6. Dyadic mass, restoration, and endpoints

For i>=1, divide (18) by the lower endpoint y/2. With y=2^n, the
weighted suffix mass is bounded by

    C sum_{log(n log 2)>=0.88 beta-O(1)}
        exp(-kappa log(n log 2)/h^4)/(n log 2)
      <= C h^4 exp(-kappa' beta/h^4).                             (21)

To justify the sum-integral comparison including its first term,
the summand is a decreasing constant multiple of n^(-1-kappa/h^4).
Bound its sum by the first term plus the integral. The substitution
u=log(n log 2) gives dn/(n log 2)=du/log 2; this is only an
absolute factor, not exp(beta). The first term is absorbed in
the same bound. Enlarging the upper limit to infinity helps.

For fixed suffix data and common p_1,...,p_{i-1}, the elementary
prime upper bound gives at most

    C x/log x / [v product_{j=1}^{i-1}(p_j-1)]                     (22)

choices for p_0. If this range is nonempty its upper endpoint is
at least x^0.9, so its logarithm is comparable to log x. Restoring
the other common primes by the projected mass proved above and
using (21) gives, for this i,

    C xG_m/log x * h^4 exp(-kappa' beta/h^4).

Since beta>=c h rho^(-h), summing i>=1 is bounded by the tail
in (T). It converges: rho^(-h)/h^3 eventually exceeds h^2, so
the terms are eventually bounded by h^4 exp(-kappa'' h^2).
For i=0, (18) gives C x/log x exp(-kappa B/m^4).
Equation (19) with j=0 gives 1/G_m<=C, and
B/m^4=alpha rho^(-m)/m^3 tends to infinity. This is the first
term in (T), tending to zero as x tends to infinity.

Finally, with the parameters fixed from x, the endpoint is used
only in F(tau)<=t. All basic witnesses of a given tuple have
the same value. Thus

    G(t) = {tau in G(x): F(tau)<=t}  for 0<=t<=x,
    K(t)<=K(x).                                                    (23)

The normality, strict-slack, and universal-witness conditions are
unchanged. `endpoint_restriction_bound` formalizes the ordered-pair
cardinality implication. Both requested endpoints, including their
closed upper conventions, are therefore covered by the same estimate.
This completes the proof of (T) and of `prop:collisions`.

For completeness the prime upper bound used in (22) is elementary:
the product of primes N<p<=2N divides binomial(2N,N)<4^N.
Summing this logarithmic bound over dyadic intervals gives
sum_{p<=X}log p=O(X). Separate primes <=sqrt(X) to obtain
pi(X)<=sqrt(X)+2 sum_{p<=X}log p/log X=O(X/log X).
Integer rounding only changes the absolute constant. Thus the
prime number theorem is not an external dependency of this proof.

## What this improves and what remains to be reviewed

The strongest prior result used is Ford's ordered comparison theorem,
not a finite-layer numerical experiment. The new argument supplies the
application-level uniform transfer: both smooth residuals are decoded
with multiplicity, the layer count may grow, Ford's smallness and gap
restrictions are checked, and the last cutoff is moved strictly above
the manuscript threshold to settle its endpoint convention.
The unit factor makes the one-layer case unambiguous. The resulting
quantitative tail controls ordered tuple pairs, not only collided values.

No false assertion of the staged manuscript has been established on
this route, so there is no corresponding F_ claim to refute. In
particular, declining to rely on its more general comparison would not
refute it. The direct comparison proof was read but is not certified
here. The staged manuscript's other main-theorem dependencies remain
open. The only non-elementary external input of this proof is Ford's
Lemma 5.1, in the restricted parameter range actually verified above.
Mertens' unit-box prime-sum estimate is the other classical input:
summing its boxes gives sum_{p<=z}1/p<=log_2 z+O(1), and then
log product_{p<=z}(1-1/p)^(-1)=sum_{p<=z}1/p+O(1) proves (15).
The elementary prime upper bound was derived above.

`verify.py` checks exact root intervals, uniform decay certificates,
repeated-factor arithmetic, source bindings, and the recorded fresh Lean
compile. It does not purport to machine-check Ford's theorem or the
analytic inequalities (1)--(23). Their correctness and the statement
fidelity require independent Reviewer reading. Novelty has not been
independently established by this Engineer.
