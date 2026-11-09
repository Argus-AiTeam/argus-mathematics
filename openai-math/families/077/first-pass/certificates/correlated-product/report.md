# Incidence-uniform pinned products

## Scope and source statements

This work concerns Lemma `proj:product` and its use in Proposition `proj:tied`
of the staged September 24, 2026 elliptic-capacity manuscript, not a proof of
either main restriction theorem. The exact source is
`research/openai_manuscript/Elliptic-capacity-propagation-and-Fourier-restriction-to-the-sphere-September-24-2026/build/sections/03-projection.tex`.

The relevant source ranges are:

| Lines | Assertion |
|---|---|
| 11-25 | Fixed power scales, subpower-density restrictions, and order of limits |
| 41-71 | Finite Ren--Wang input, explicitly arXiv:2308.08819v2, Theorem 4.1 |
| 180-345 | Radial nonconcentration, including power-small exceptional pairs |
| 545-575 | Full hypotheses and both alternatives of the product lemma |
| 639-676 | Original-cell normalization and the actual conditional query law |
| 678-758 | Direction transfer, collision estimate, and nonlinear remainder |
| 760-791 | Conditional entropy chain and the coefficient Frostman conclusion |
| 803-1020 | Equal-slope application, weighted overlaps, and projection test |

The parent-law hypotheses are not an independence assumption. They refer to
unrestricted normalized target laws in typical intermediate cells. Their
quantitative exceptional-mass content is supplied by `ent:regularization`
(02-entropy.tex, lines 153-250) and `ent:tangent-realization` (lines 553-626).
A conclusion conditional on those hypotheses is not a verification that every
preceding geometric construction supplies them.

The other main conclusion is the diagonal extension theorem for every compact
smooth positively curved surface in R^3 (smooth boundary permitted), for
3 < p < infinity. Its packet input uses the elliptic-capacity theorem. Both
main conclusions and the dependency chains are recorded as open claims.

No relevant Fourier/projection entry was found in the inherited Wiki index.
The best prior scoped input supplied to this mission was source support, not
certification, for the Ren--Wang finite incidence exponent. A shear identity
alone does not settle the present goal and is not pursued as a solution.

## An exact conditional entropy inequality

Let pi and mu be probability laws, let E be a measurable incidence of product
mass alpha > 0, and let T_f be a finite-valued measurable map of the target.
Write beta(f) = mu(E_f), and

    K_f = (mu x mu){T_f(v) = T_f(v')}.

If S = {f : beta(f) > 0} and integral_S K_f d pi <= K, then

    H(T_F(V) | F; (pi x mu)|E) >= -log K + 2 log alpha.       (CE)

This statement permits arbitrary query-dependent fibers E_f. It does not
assert that pins and targets remain independent after conditioning.

Proof. The conditional query law is q(df) = beta(f) pi(df)/alpha.
The output collision probability on a restricted fiber is at most
K_f/beta(f)^2. Shannon entropy is at least negative logarithmic collision
probability. Consequently its q-average is at least

    E_q[-log(K_f/beta(f))] + E_q[log beta(f)].

Jensen's inequality bounds the first term below by log(alpha/K).
Convexity of x log x bounds the second below by log alpha, since
integral beta d pi = alpha. Their sum proves (CE). Zero fibers carry no q
mass. In a finite output partition K_f is positive on every positive fiber.

The coefficient 2 is optimal without extra hypotheses: take a one-pin law,
a target atom of mass alpha, and distribute the remaining mass uniformly
among N distinct output atoms. Condition on the first atom. The conditional
output entropy is zero and

    K = alpha^2 + (1-alpha)^2/N -> alpha^2.

A coefficient smaller than 2 would yield a positive lower bound for
sufficiently large N. This is an analytic limiting argument, not a finite
search.

## Quantitative nonlinear incidence theorem

Here is the principal verification theorem. It is a finite-scale statement,
not an inference from the computations accompanying this report.

Let b >= 16 be a power of two, delta = 1/b, J >= 4, n = J-3, and
0 < a < s <= 1. Let nu be a probability law on [-1,1]^2. Let A,B >= 1
and delta <= g <= 1/4. Use dyadic target squares D_j of side delta^j and
the nested scalar bins

    P_j(f,d) = floor(delta^(-j) Q_f(d)).

Assume the following precise finite hypotheses.

1. The original law nu satisfies nu(B(x,r)) <= A r^s for delta <= r <= 1.
2. For every j = 3,...,J-1, outside target cells of total original mass
   beta_j, the normalized unrestricted law mu_C in a cell C of D_j
   satisfies mu_C(B(v,r)) <= A r^s for delta <= r <= 1. The normalization
   is d = c + delta^j v, with c the cell center and v in [-1/2,1/2]^2.
3. There is a set R of distinct pairs, of original product-pair mass
   at least 1-gamma, such that for every (f,d) in R and delta <= r <= 1,

       nu{x != d : angle([x-d],[f-d]) <= r} <= B r^a.

   This is a reverse radial bound, for the original comparison-pin law.
   It is not a bound for an independently resampled conditional law.

Put

    K0 = 2^16 A(A+B)/(s-a),
    Gamma = gamma + sum_(j=3)^(J-1) beta_j + A(2g)^s.

For EVERY measurable incidence E of original product mass rho, if, for
each pin f, the output P_J on E_f has at most N values, then

    rho <= Gamma + sqrt(8 K0) N^(1/(2n)) (delta/g)^(a/2).     (QI)

In particular, E may be chosen after seeing all the product coefficients,
all parent cells, or all spatial overlaps. The theorem does not impose
independence after that choice.

### Proof: original parent cells and query directions

Remove from E the complement of R, all the bad-parent cells, and pairs
with |f-d| < 2g. Their original total mass is at most Gamma: the last
assertion follows by integrating the original Frostman bound at radius
2g. If rho <= Gamma there is nothing to prove. Otherwise the remaining
incidence E' has mass rho' >= rho-Gamma > 0.

Fix a good cell C at depth j >= 3, put L = delta^j, and let S_C be the
pins with positive mu_C incidence fiber. For any f in S_C there is an
actual d in that fiber, and hence

    |c-f| >= 2g - L/sqrt(2) >= g.

No measurable choice of d is needed: the following bound is valid for
every such witnessing d. The normalized gradient is

    omega_C(f) = (t_c-t_f, r_c-r_f)/|c-f|.

Swapping the two coordinates is an isometry of the unoriented direction
space. Comparing radial directions at c and d changes the queried
direction by at most 2L/g. For a comparison pin x with |x-c| >= delta,
it changes its direction by at most 2L/delta. Since L <= delta^3 and
g >= delta, the combined error is at most 4 delta^2 <= delta/4.
The discarded comparison pins have original mass at most A delta^s.

Apply the reverse radial bound at the ACTUAL d to a ball centered on
the ACTUAL direction f-d. For angular radius r >= delta the preceding
error is absorbed by doubling r. For r > 1/2 use the trivial mass
bound; B >= 1 makes it compatible with the same estimate. Thus angular
balls centered on surviving gradient directions have mass at most

    (A+2B) r^a

under the subprobability law omega_C#(nu|S_C). Here
A delta^s <= A r^a uses s > a. Recenter an arbitrary ball meeting this
support and double its radius once more. A convenient uniform bound is

    omega_C#(nu|S_C)(I) <= 16(A+B) r^a,  r >= delta.          (D)

Notice the two different normalizations. Targets use mu_C in cell
increment units, while comparison pins still use the ORIGINAL nu in
physical coordinates. Replacing the latter by mu_C is neither needed
nor justified.

### Proof: nonlinear collisions before conditioning

For v,v' in the normalized cell, the exact expansion is

    Q_f(c+Lv) = Q_f(c) + L grad Q_f(c).v + L^2 v_r v_t.      (T)

If their nonlinear outputs P_(j+1) coincide, then

    |omega_C(f).(v-v')| <= 2 delta/g =: w.

Indeed the physical bin width is L delta, the difference between the
two quadratic remainders is at most L^2/2, and |grad Q_f(c)| >= g.
When w >= 1 the estimates below are trivial. Otherwise the collision
directions occupy an angular interval of radius at most
2w/|v-v'|, with a trivial bound when this ratio is large. That radius,
when relevant, is at least delta because |v-v'| <= sqrt(2).
Using (D), their original pin mass is at most

    32(A+B) min{1,(w/|v-v'|)^a}.

The original target-cell Frostman bound gives

    integral integral min{1,(w/|v-v'|)^a} dmu_C(v)dmu_C(v')
        <= 4A w^a/(s-a).                                  (EN)

For completeness, write the expectation by layer cake in the distance
R=|v-v'| <= 2. Integrating A r^s against a r^(-a-1) on [w,2]
and including the upper endpoint gives at most
A w^a(1 + 2a/(s-a)) <= 4A w^a/(s-a). Distances below w are included
by the same formula. No ball estimate below delta is used, since
w >= delta. If w >= 1 the displayed bound is at least one.

Consequently, if K_(C,f) is the UNRESTRICTED nonlinear output collision
probability under mu_C,

    integral_(S_C) K_(C,f) dnu(f)
        <= K0 (delta/g)^a =: K.                            (NC)

The constants just computed need at most 2^8 in place of 2^16; the
larger stated constant also covers closed-bin boundary conventions.
This proves (NC) for the nonlinear output itself, not just for its
linearization.

### Proof: conditioning and the entire entropy chain

Write alpha_C = (nu x mu_C)(E'_C). Apply (CE) with this ORIGINAL
product law and map P_(j+1). The result is

    H(P_(j+1) | F,C; E') >= -log K + 2 log alpha_C.

Now average over the actual target-cell law under E'. If w_C = nu(C),
its weights are w_C alpha_C/rho'. Since sum_C w_C alpha_C = rho',
convexity of x log x gives

    sum_C (w_C alpha_C/rho') log alpha_C >= log rho'.

Cells with alpha_C=0 contribute zero. This also accounts for all
bad-parent cells, where E' is empty. Therefore, for every used j,

    H(P_(j+1) | F,D_j; E')
        >= a log(g/delta) - log K0 + 2 log rho'.             (B)

This is the promised quantitative control of the ACTUAL conditional
query law. It avoids per-cell density pigeonholing, per-query Markov
trims, and an independence assertion.

For fixed f and a target square of side L, Q_f varies through an
interval of length at most 4L+L^2/2. Hence f,D_j determine at most
eight possible P_j bins. Since the scalar partitions are nested,
the elementary entropy chain rule yields

    H(P_(j+1)|F;E') - H(P_j|F;E')
       >= H(P_(j+1)|F,D_j;E') - log 8.

Sum (B) over j=3,...,J-1 and discard the nonnegative initial entropy.
The upper support hypothesis also holds on E', so

    log N >= H(P_J|F;E')
          >= n [a log(g/delta) - log(8K0) + 2 log rho'].

Rearranging gives (QI), since rho <= Gamma+rho'. This proves the
theorem. The loss of the first three blocks is explicit; it is not
silently replaced by a full-length entropy increment.

### Explicit exponent budget

Fix 0 <= sigma < s <= 1 and 0 < h <= 1, and set

    D = s-sigma,       a = (s+sigma)/2,
    J >= ceil(24a/D),  eta = h/J,       n = J-3,
    k = D/(8a),        tau = eta k,      c0 = hD/(32J).

Use delta = m^(-eta), g = m^(-tau), and N <= m^(h sigma).
For an arbitrary realizing sequence, take
b=2^floor(eta log_2 m) and replace its base by b^(1/eta).
This changes log m by O(1), not its exponents. The original dyadic
parent grids and bounded-overlap enlargements absorb the fixed
rounding constants. No special subsequence of input bases is required.
We have

    0 < k <= 1/4,
    (1-3/J)a(1-k)-sigma >= D/4,
    e := [a(eta-tau)-h sigma/n]/2 >= hD/(8n) >= 4c0,
    tau s >= 4c0.                                         (EB)

The middle inequality is especially transparent:

    [(1-3/J)a(1-k)-sigma] - D/4
        = [JD-24a+3D]/(8J) >= 0.

If A,B <= m^epsilon for epsilon <= c0, (QI) gives the quantitative
bad-incidence bound

    rho <= gamma + sum beta_j
           + 2m^(-3c0) + C_(s,a) m^(-3c0),                 (PB)

for sufficiently large m satisfying the finite geometric conditions.
If the radial and parent exceptions are power-small, so is rho.
This is a uniform statement for arbitrary incidences, not just a
test on a prescribed set of pins.

## Supplying the radial hypothesis from power-light strips

Here we independently check the radial bootstrap needed to apply (QI).
The only non-elementary input is the finite incidence theorem
RW41 in the ledger. We do NOT invoke a Hausdorff-dimension theorem as
though it were a finite estimate.

Let nu be Frostman s, 0<s<=1, at the relevant fixed power scales,
with arbitrarily small input losses, and assume every strip of each
fixed power width has power-small mass. At angular scale beta, call
a pair u-bad when its original centered angular bin has mass
greater than beta^u. Failure of a power bound for its pair mass
would yield a subsequence of bad mass beta^(o(1)).

First suppose 2u<s. If such a dense incidence exists, Cauchy--Schwarz
on the target fibers gives a dense integral of common-target masses
for two pins. Remove pin pairs closer than beta^alpha, using the
planar Frostman bound, and remove targets in the beta^alpha strip
about their joining line, using the UNIFORM strip hypothesis.
Both removals have power-small mass and cannot exhaust a dense
triple incidence. Each pin has O(beta^(-u)) heavy direction bins.
Off the joining strip, the sine of the intersection angle is at
least a constant times beta^(2alpha). A pair of pencil tubes thus
meets inside a ball of radius O(beta^(1-2alpha)). Their common
targets have total mass at most

    beta^(-2u + (1-2alpha)s - o(1)).

Choose alpha sufficiently small. This is power-small, a contradiction.

Suppose next that the radial assertion is known at u<s on every
fixed power grid. Choose positive alpha,z with

    3z+alpha < (s-u)/2,       z < alpha(s-u)/2.               (RM)

Remove the old exceptional pairs in both orders at a fine angular
power grid, with an arbitrarily small power slack. Suppose bins of
original target mass >= beta^(u+z) still carry dense incidence.
Call a heavy bin dispersed if its containing tube has original
separated-pair mass at least beta^(2u+3z), where separation is
at least beta^alpha.

If the dispersed bins carry dense incidence, the remaining pin law
is still planar Frostman s. The old radial bounds make the
direction law in each surviving pencil Frostman u after dense
normalization. Sampling the pins and each pin's pencil separately,
with repetitions removed, converts these laws into the finite
sets of RW41 with arbitrarily small losses. The theorem gives at
least

    beta^(-(s+3u)/2 + o(1))

distinct dispersed tubes. Here the relevant minimum is
(s+3u)/2 because u<s<=1. A beta-separated tube family contains any
pair at separation >= beta^alpha in O(beta^(-alpha)) tubes:
its slopes occupy O(beta/distance), and its intercept choices
have bounded multiplicity. Integrating original separated-pair
masses bounds the number of these tubes by

    O(beta^(-2u-3z-alpha)).

The first inequality of (RM), with RW41 losses chosen afterwards,
contradicts these two bounds.

If the nondispersed bins carry dense incidence, a bin of original
mass b>=beta^(u+z) has a ball of radius beta^alpha containing all
but O(beta^(2u+3z)/b) <= O(beta^(u+2z)) of that original mass.
This follows by averaging its original separated-pair mass.
There are O(beta^(-u-z)) heavy bins per pin, so deleting their
outside portions costs O(beta^z) in total pair mass.

Choose a surviving target y with a dense reverse pin fiber.
For each retained pin, the original heavy tube still carries
mass comparable to beta^(u+z) in B(y,C beta^alpha).
For a fixed original target z in this ball, incidence in that
tube forces the reverse pin direction into an interval of
radius O(beta/|z-y|). The inherited reverse u-bound, divided
only by the dense reverse fiber's mass, bounds its average by

    beta^(-o(1))
      integral_(|z-y|<=C beta^alpha)
        min{1,(beta/|z-y|)^u} dnu(z)
      <= beta^(u+alpha(s-u)-o(1)).

The last step is the same annular energy calculation as (EN).
This is power-smaller than beta^(u+z), by the second strict
inequality of (RM), a contradiction.

All target masses in the nondispersed argument are ORIGINAL
masses, not renormalized restricted-bin masses. Conversely, the
reverse direction law is the actual dense reverse fiber of the
surviving incidence. These distinctions justify the two operations
that would be invalid if conditioning were replaced by independence.

There is a finite explicit bootstrap schedule for any desired a<s.
Start at u=s/4. Put D_r=s-a, take

    alpha = D_r/16,       z = D_r^2/512.

While u<a, both margins in (RM) hold uniformly, since s-u>=D_r
and D_r<=1. After at most ceil((a-s/4)/z) improvements, the exponent
is at least a and still below s. For each of these finitely many
steps choose its strict output margins first, then its earlier
radial losses and its RW41 input losses. All uses of strip
nonconcentration are at fixed positive power widths. A finite
union of power-small exceptional sets remains power-small.

This proves the reverse radial hypothesis of (QI), with
B <= m^epsilon for any prescribed epsilon>0 after fine-grid
interpolation, outside a set of mass gamma=m^(-c_r) for some
c_r>0. The value c_r is not claimed to be explicit: it depends on
the strip decay rates and RW41's input allowance. The explicit
quantity (PB) is conditional on those actual rates.

## Completing both product alternatives

In the power-light-strip case the time marginal already makes the
planar law Frostman s. The stated affine hereditary hypothesis,
with the parent trims of `ent:regularization`, supplies hypothesis
2 of (QI) with arbitrarily small fixed power losses and power-small
bad-parent mass. The preceding radial argument supplies hypothesis
3. Apply (QI) to the incidence of pairs lying in ORIGINAL pinned
coefficient bins of mass greater than m^(-h sigma).
There are at most m^(h sigma) such bins for each pin. Formula (PB)
proves that this incidence has power-small mass.

After deleting those pairs on a finite grid, every remaining
coefficient bin has the corresponding original mass upper bound.
An interval centered off the support is recentered on any surviving
point it meets and enlarged by a fixed factor. Normalize only pin
fibers that retain dense target mass; this costs a subpower factor.
A fine fixed power grid interpolates to all intermediate radii
with an arbitrarily small power loss. This proves all of alternative
(ii), including the claimed allowed restrictions and exceptions.

For alternative (i), let a strip of width m^(-chi) have dense mass.
Its slope in coordinates r=a t+b must satisfy
m^(-o(1)) <= |a| <= m^(o(1)). Otherwise one marginal is confined
to a fixed power-small interval: small slope contradicts the
positive tilt exponent, and large or vertical slope contradicts
the time exponent. This argument uses BOTH marginal hypotheses.
Normalize the strip restriction, at only a subpower loss.

On that strip,

    Q_f(d) = a(t_d-t_f)^2 + O(m^(-chi+o(1))).

For any particular dense incidence of retained pairs, remove
|t_d-t_f|<m^(-u_m), where u_m -> 0 sufficiently slowly relative to
the marginal losses and that incidence's density exponent. Its
mass is negligible relative to the incidence. The derivative of
the quadratic on either sign branch is then between subpower
reciprocals. For every fixed 0<h<chi, a coefficient interval of
radius rho>=m^(-h) has inverse image in at most two time intervals
of length m^(o(1)) rho. The error term is smaller than the output
mesh. The time Frostman bound proves the s bound on the retained
pairs, at all required intermediate radii. One may first choose
any sufficiently short positive fractional block, exactly as
allowed in the manuscript.

Thus (QI), the radial argument, and this elementary strip argument
verify the COMPLETE product-coefficient mechanism under its
stated hereditary hypotheses. There is no assumption that r and t
are independent.

## The weighted equal-slope application

We now check that the coefficient theorem is used on the law it
actually controls. The following are the precise rate-realization
hypotheses of Proposition `proj:tied`, not new independence
hypotheses: a common spatial universe has exponent L=p+H+g; for
typical fine parameter labels f its full spatial fiber S_f has
that exponent and retained pre-trim cell weights at least
N^(-L-o(1)); its original conditional (x,w_f) law is planar
Frostman p+g; its additional full-cell fibers have upper exponent
H; and the output triples have support exponent H+g.
Here N is the base of the full or positive fractional block used.
`ent:finite-states` and the matched parent/refinement states in
`proj:tied` identify these labels up to bounded multiplicity.

For clarity, assign all these errors a fixed small allowance e.
After restricting the parameter law to ANY dense set, the entire
S_f remains available. Cauchy--Schwarz in the common universe gives

    integral integral |S_f intersect S_d| dnu(f)dnu(d)
        >= N^(L-3e).

The upper overlap bound is N^(L+e). Therefore parameter pairs with
overlap at least N^(L-3e)/2 have measure at least N^(-4e)/2.
This is dense when e tends to zero after the fixed tests have
been chosen. Power-small exceptional parameter pairs from the
coefficient theorem cannot exhaust these overlaps.

Fix such a pair f,d. Put dr=r_d-r_f and dt=t_d-t_f. The FULL
mixed-term shear update, not two unrelated one-parameter shears,
gives

    y_d = y_f-dr x,              z_d = z_f+dt x,
    w_d-dt y_d+dr z_d = w_f+dt dr x.                        (SI)

There are at most N^(p+g+e) input bins (x,w_f). Deleting input
bins with fewer than N^(H-6e) full cells removes at most
N^(L-5e) full cells, negligible compared with the selected overlap.
The remaining rich input subset retains at least a constant
times N^(L-3e) full cells, hence at least a constant times
N^(-4e) weight for the ORIGINAL conditional (x,w_f) law.
This last inference uses the pre-trim lower cell weights; a
cardinality assertion alone would not justify it.

Inside a rich input bin, the fine-frame output triples have
bounded multiplicity: knowing x and the triple inverts the shear
to full-cell accuracy. Thus one attained scalar output uses at
least a constant times N^(H-6e) triples. Well-separated scalar
outputs use disjoint triples, because the left side of (SI) is
determined by a triple. There are at most N^(H+g+e) triples in
all. The rich scalar projection therefore has at most

    O(N^(g+7e))

mesh bins. This verifies both the support and the dense WEIGHT
requirements of the scalar projection test for each chosen
coefficient direction.

In the dense-strip case, first make the allowed dense parameter
restriction to that strip, repeat this overlap argument with the
ENTIRE spatial fibers, and use a fractional block h<chi. The
time-diagonal discard can be made negligible relative to the
dense overlaps. In the power-light case remove the coefficient
exceptions on the required finite scale grid BEFORE selecting
the pin. Averaging then selects one f with a dense target fiber,
its coefficient Frostman exponent arbitrarily close to s, and
the rich inputs just proved for the SAME original planar law.

If several targets share a coefficient mesh bin, choose one of
their rich subsets and use it throughout that bin. Replacing the
coefficient by its bin representative changes the scalar output
by only bounded mesh error, since x is bounded. Each chosen
subset has dense mass for the same original conditional planar
law. Thus the product of that law and the ACTUAL coefficient
marginal contains dense point-direction incidence. It need not
be a product law before passing to these reference marginals.

The finite weighted projection consequence of RW41 now gives,
on letting the fixed test losses tend to zero,

    g >= min{p+g, (p+g+s)/2, 1}.

Its weighted reduction uses a COMMON globally sampled direction
population, then sampled pins and dense fiber restrictions. The
reference laws remain Frostman after these restrictions; removing
mesh repetitions costs a fixed small power. The line-count upper
exponent is direction exponent plus g, while RW41 gives the
corresponding lower exponent. Choosing all sampling losses below
RW41's input allowance proves the displayed minimum. Sampling
different populations at each pin would not justify that upper
bound and is not used here.

For p>0 and g<1, both the first and third entries exceed g, so
g>=p+s. If g=1 the desired bound is automatic, and if p=0 the
definition f_s(0)=0 applies. Hence g>=f_s(p).

Finally the middle-pair diagonal rate needs no invented separate
B,D rates at the tie. Off the tie in B<D the scalar time test
gives partial_D J>=f_s(p). Monotonicity in B and integration
on a vertical segment give

    Hh = J(b+h,b+h)-J(b,b)
       >= J(b,b+h)-J(b,b) >= h f_s(p).

The profile is Lipschitz, so absolute continuity on almost every
such segment suffices, and continuity includes the boundary
segment. Thus H>=f_s(p). This completes the stated equal-slope
consequence under the actual rate-realization hypotheses.

## External input, novelty, and certification limits

The retrieved primary source
<https://arxiv.org/html/2308.08819v2>, Theorem 4.1 and Definitions
1.3, 2.3-2.4, and 3.1, states exactly the finite incidence
exponent used here. The original HTML and extracted statement
including its hypotheses are retained beside this report.
The source uses (s,t)=(direction exponent, pin exponent);
our notation (a,s) or (sigma,k) reverses those names only.
Independent citation attribution is still owed by the Reviewer;
the Engineer must not attribute support to its own assumption.
The official attribution writer archives under `research/literature/`,
outside this mission's current owned paths. It has not been run;
an authorized review scope is needed for that write. The retained
excerpt and the Engineer's judgements are not substitutes for
independent literature evidence.

This is an independent quantitative verification and extension
of the manuscript's conditional mechanism: (QI) makes its
incidence density, parent exceptions, gradient cutoff and
finite-block loss explicit. It is stronger than checking the
shear or an unconditioned projection, but does NOT establish
either main restriction theorem or the entire earlier entropy
tangent construction.

The closest sources opened during scope include
arXiv:1605.00187v2, Theorem 1.1 (pinned Euclidean distances,
discrete Ahlfors regularity, dimension s>1),
arXiv:2209.00348v1, Theorem 1.1 and the introduction (radial
projections and thin-tube methods), and
arXiv:2601.09582v1, Theorem 1.6 (quadratic images of THREE
independent one-dimensional Frostman variables). We also opened
arXiv:2003.01636v2, Theorems 1.3 and 1.7 and Section 1.3:
nonlinear projection theorems already permit target-dependent
parameter restrictions and robust target restrictions. Its
multiscale entropy method is explicitly not new. Correlation
robustness alone is therefore NOT a novelty claim of this work.
None of these opened statements is the precise quantitative
inequality (QI); whether (QI) is already a routine quantitative
corollary requires independent assessment. They do not justify
assuming independent r,t in the present problem. This limited
comparison does not certify publication priority or novelty.
One search result supplied an incorrect
arXiv identifier for a nonlinear projection paper; opening the
primary page exposed an unrelated astronomy paper, and that
reference is not used.

The Python certificate checks exact algebra, rational exponent
budgets, finite weighted-incidence inequalities, and the retained
Jacobian result. The universal geometric and entropy proofs are
the analytic arguments above, not conclusions of a bounded
search. Independent Reviewer replay AND mathematical reading are
required. No Lean formalization or kernel verification is claimed.
No flawed manuscript assertion has been established on this
route, so there is no invented F_ claim or refutation judgement.
Publication-level significance, verified novelty, and final
campaign acceptance remain open to the normal Reviewer.

To replay the exact certificate, using only the Python standard library:

```bash
python3 research/certificates/correlated-product/verify.py
```

The Engineer's run exited 0. It checked four formal polynomial
identities, 410 rational exponent budgets, all 510 incidences in
two finite weighted query models (including parent averaging and
the conditional entropy chain), 3,969 weighted overlap inequalities,
1,048,560 rich-support inequalities covering both shear signs,
the density-penalty sharpness example, and the retained successful
Jacobian result. The finite examples are not promoted to proofs
of the universal statements. Both official campaign-local structural
checks also exited 0 at the exact campaign root; the public role
progress records their commands and root.
