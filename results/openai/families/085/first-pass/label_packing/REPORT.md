# Birth-aware spatial packing for dyadic vector masses

## Scope and source

The target is `prop:label-packing` in the staged September 26, 2026
manuscript, `build/sections/labels.tex`, lines 269-283. The full source
path, relative to the campaign root, is
`research/openai_manuscript/An-Endpoint-Gradient-Bound-for-the-Centered-Disk-Maximal-Operator-September-26-2026/`.

The assertion is a depth-independent bound for

    sum_(l=1)^m sum_(q in V_l) a_q [
      sup_(x in D(q)) (R_l(x) + R_(l+1)(x))
      + sum_(k=1)^l 2^(k-l) ess sup_(x in D(q)) T_k(x)].

Here the masses are the actual integrals of tensor-product tents against
`h = grad(g) dx`, not arbitrary nonnegative numbers. The spatial sets are
the closed squares of radius `25 r_l`; `R_1 = R_(m+1) = 1`.
`T_k` differentiates an individual transition row, not its marginal.
The palette and all vertex choices are fixed independently of observation
position. Zero vector masses retain arbitrary prescribed unit directions.
The switch function is exactly
`P(d) = min(1, tau^(-2) (d-tau)_+^2)`, with `tau = 1/100`.

The immediate dependencies are positive tent refinement and vector mass
monotonicity (`prices.tex`, equations `hat-refinement` and
`prices-vector-mass-budget`); the neighboring-direction budget; the
birth-aware particle measure; stopped vector defects and the switch
freezing argument; spatial comparison of finite-state laws; and a
birth-aware geometric convolution. These are assertions to be independently
proved below, not imported assumptions.

The endpoint theorem and signed finite-band theorem remain outside this
mission's certification. Their other dependencies, notably `lem:local`,
`prop:prices`, and the analytic assembly and extension arguments, remain
open. The packing proof needs no external literature theorem: its ingredients
are finite sums, tensor-product affine interpolation, Euclidean identities,
and elementary probability. A targeted search of the supplied Wiki index
for this campaign, centered disks, label packing, and Sobolev regularity
found no directly relevant page. No novelty priority is inferred from that
negative lookup.

## Result classification

The result proved below is a universal verification, not a finite
counterexample search and not a certification of the endpoint Sobolev
theorem. The strengthening replaces `grad(g) dx` by any compactly supported
finite real two-component vector measure. All spatial costs and the
manuscript's label law are retained. Independent Reviewer confirmation
is pending; no priority or publishable-novelty claim is made.

The original staged proof is the strongest prior result in this campaign.
The intended additional result is an independent proof with explicit
constants and a machine-checked finite-state/birth-convolution core. Merely
checking finitely many depths or assuming the spatial-comparison conclusion
would not establish this result.

## Verification theorem

Let h be any compactly supported finite real two-component vector measure
on the plane, and let V be its total variation. Construct every tent mass,
zero-mass unit direction, maximizing neighbor, palette choice, transition
row, R, T and D exactly as in the manuscript. For every integer m >= 1,

    sum_(l=1)^m sum_q a_q C_l(q) <= C_pack V,

where C_l(q) is the manuscript's entire bracket, and one valid constant is

    K_E    = 540 * 4097^2 = 9064120860,
    K_M    = 1280001,
    K_R    = 1 + 2 K_M + 2000000 K_E = 18128241722560003,
    K_S    = 2000000000,
    C_pack = 1 + 60 K_S + 8 K_S (K_R + K_E)
           = 290052012586893928000000001.

These constants are deliberately loose. They are independent of depth,
support size, palette cardinality, tie rules, atoms, absolute continuity,
and choices of unit directions at zero masses. The palette must still be
a finite tau/20 net and n_z must satisfy its stated approximation condition.
This theorem specializes to `prop:label-packing` by taking
h = grad(g) dx. No property of being a gradient is used below.

## Proof

### 1. Actual tent refinement and neighboring directions

One-dimensional hats sum to one. Each coarse hat is affine between
successive finer grid points, so its finer-grid interpolant is exactly
itself. Products give the stated two-dimensional refinement, column sums,
and composition identities. Integrating these finite, locally finite
identities against h gives vector refinement. The triangle inequality and
partition of unity give 0 <= A_i <= A_k <= V for i <= k. Compact support
ensures that only finitely many masses are nonzero at every level.

Fix k and q with a_q > 0, and let z attain E_k(q), with w=w(z).
The candidates for w include q, so a_w >= a_q and
|w-q|_infinity <= 500 r_k. At level k-12 take the coordinatewise
nearest vertex p to q. Then

    lambda_pq >= 1/4,      lambda_pw >= 9/64.

Indeed the first coordinatewise distances are <= r_(k-12)/2; the
second are <= (1/2+500/4096) r_(k-12) < 5r_(k-12)/8.
For H_p = sum_s lambda_ps a_s - a_p, vector refinement gives

    H_p = sum_s lambda_ps a_s (1-theta_p dot theta_s)
        = (1/2) sum_s lambda_ps a_s |theta_s-theta_p|^2 >= 0.

This identity is valid when a_p=0: theta_p is still unit and
theta_p dot h_p = a_p = 0. Consequently

    a_q E_k(q)
      <= 2 a_q (|theta_q-theta_p|^2 + |theta_w-theta_p|^2)
      <= (16+256/9) H_p
      <= 45 H_p.

This use of the two lower bounds is also valid when w=q (then E_k(q)=0);
it does not double-count a negative summand. A fixed p is chosen by at
most 4097^2 fine vertices, since each coordinate lies within 2048 fine
mesh lengths of p. Therefore

    sum_q a_q E_k(q) <= 45 * 4097^2 (A_k-A_(k-12)).

Summing k=1,...,m counts each nonnegative increment of A at most twelve
times. The sum of the increments over this finite range is <= V.
This proves the neighboring budget with K_E above, including the
coarser, possibly negative-index levels.

### 2. Positive particles with complete histories

Take all level-one roots whose closed tent supports meet supp(h), and
all positive-refinement paths down to m. This is a finite forest.
For a prefix xi ending at q_k put

    b_xi = product of its edge coefficients,    M_xi = b_xi a_qk.

Its associated vector is b_xi h_qk, which is the sum of its children's
vectors. Hence M_xi <= S_xi := sum_child M_child. Every path to a
nonzero a_q begins at one of the retained roots: support nesting holds
on every positive edge. Column sums then give

    sum_(xi ending at q) M_xi = a_q,    sum_(|xi|=k) M_xi = A_k.

At a root create M_xi particles of birth level one. If S_xi>0,
send each already present population type to a child eta in proportion
M_eta/S_xi, and create the remaining
M_eta - M_xi M_eta/S_xi there with birth level k+1. Both quantities
are nonnegative. They fill that child's capacity exactly, and summing
over children preserves every old population type. If S_xi=0, every
child capacity and M_xi are zero; no division is made.

Each newborn receives the full prefix, even if an ancestor has zero
mass. The resulting finite atomic measure mu on terminal paths and
birth levels satisfies, for every node xi at level k,

    mu{B<=k, prefix=xi} = M_xi.

The condition B<=k is essential: it is not dropped. Consequently

    mu{B<=k,q_k=q}=a_q,     mu(all)=A_m<=V.

Positive edges have coordinatewise displacement at most r_j/2.
For every complete path, even before its birth,

    |q_m-q_s|_infinity
      <= sum_(j=s)^(m-1) r_j/2
       = r_s (1-2^(-(m-s))) < r_s.

The last strict inequality also holds at s=m. If h=0 all weighted
assertions are zero and the forest can be empty.

### 3. Stopped defects, zero ancestors and the exact switch law

Mark roots. Below any mark, mark the first node with direction more
than tau/8 from that marked direction, and repeat. For a marked
nonterminal node take the frontier of its first subsequent marks,
completed with unmarked terminal nodes. Finite vector additivity gives

    sum_frontier M_eta - M_xi
      = (1/2) sum_frontier M_eta |theta_eta-theta_xi|^2
      >= (tau^2/128) sum_(marked frontier) M_eta.

Again zero M_xi causes no failure of the identity. Summing over marked
nonterminal nodes cancels every interior marked mass. Every terminal
node occurs once. Thus all nonroot marks cost at most
128 tau^(-2) (A_m-A_1); adding roots gives

    sum_marked M_xi <= K_M V.

For m=1 this follows directly from A_1<=V. Exact post-birth occupancy
also gives

    integral sum_(s=B)^m E_s(q_s) dmu <= K_E V.

Fix one particle and run the actual label law at y=q_m, including its
pre-birth history. Let X_1=1 and X_s be the indicator of a switch for
s>=2, so E_y X_s=R_s(y). At s>=B call a level exceptional if it is
marked or E_s(q_s)>c_*, where c_*=10^(-6).
In a consecutive nonexceptional interval, all path directions are
within tau/8 of one common most recent marked direction. This mark
is allowed to precede birth. Every sampled z at y satisfies
|z-q_s|_infinity<2r_s, so its direction Theta_z is within tau/10
of theta_qs. Any two sampled directions on the interval are thus
within 2(tau/8+tau/10)=9tau/20.

After one switch, the new label is within tau/20 of that sample;
its distance from every later sample is <=tau/2<tau.
The *exact* P(d) is zero there. Therefore there can be at most one
counted switch per nonexceptional interval, regardless of the incoming
label. The same applies to the counted initial assignment when s=1.
If there are J exceptional levels, there are at most J+1 intervening
intervals and at most J switches on exceptional levels. Pathwise,

    sum_(s=B)^m X_s <= 1 + 2 number_of_postbirth_marks
                          + 2 c_*^(-1) sum_(s=B)^m E_s(q_s).

Taking the law's expectation and then the particle integral proves

    integral sum_(s=B)^m R_s(y) dmu <= K_R V.

No positive-descendant mass was charged to an unoccupied zero ancestor.

### 4. Row-level spatial estimates, without assuming comparison

Fix a complete path, level l, and x in D(q_l). Locality gives
|x-y|_infinity<26r_l. For s<=min(l+1,m), a tent nonzero at x
or y has its vertex within

    r_s + 26r_l + r_s <= 54r_s < 200r_s

of q_s. Off the grid lines, the same statement covers every
differentiated tent. Thus all involved Theta_z differ from theta_qs
by at most sqrt(E_s(q_s)). Reference y may itself lie on a grid
line; only probabilities, never derivatives at y, are used.

The square root of the actual switch probability,
min(1,(d-tau)_+/tau), is tau^(-1)-Lipschitz. For any involved z,z',

    p_s(n,z) <= 2 p_s(n,z') + 8 tau^(-2) E_s(q_s).

Average z' at y. With B_s(n)=rho_s(y|n)+E_s(q_s),

    max_involved p_s(n,z) <= 80000 B_s(n).

There are at most four nonzero tent gradients and each has Euclidean
norm <=sqrt(2)/r_s. Since the l1 norm of delta_(n_z)-delta_n is
at most two,

    rho_s(x|n) + r_s sum_(n') |grad pi_s(x;n,n')|
      <= A B_s(n),             A=1040000.

The corresponding row observable is between zero and F=13
independently of n: rho<=1 and the scaled derivative sum is
<=8sqrt(2)<=12. For the initial row, 1+T_1<=7.

Each tent is sqrt(2)/r_s Lipschitz for Euclidean distance. Its
difference between x and y is at most 52*2^(s-l).
Only the at most eight tents nonzero at x or y enter a row
difference, including when those points are far apart on the
scale r_s. Therefore

    ||pi_s(x;n,.)-pi_s(y;n,.)||_1
      <= D 2^(s-l) B_s(n),      D=66560000.

For s=1 the initial-row difference is <=416*2^(1-l);
this is covered by the same D with c_1=1+E_1>=1.
To treat it as an ordinary Markov step, start both laws from any
one common auxiliary distribution and use identical initial rows
for every old state. This changes neither law after step one.

Here is the marginal argument, rather than a presupposed spatial
comparison. A nonnegative row-normalized matrix contracts the l1
norm of signed row vectors. Subtract the two marginal recursions,
use that contraction on their old-distribution difference, and
average the row difference using the reference old distribution.
Writing c_s=R_s(y)+E_s(q_s) and d_s=||zeta_s(x)-zeta_s(y)||_1 gives

    d_0=0,   d_s <= d_(s-1) + D 2^(s-l) c_s.

For the step-s nonnegative row observable above, first average at
y, using its individual-row bound; changing that old distribution
to the one at x costs at most F d_(s-1). Hence

    R_s(x)+T_s(x) <= A c_s + F d_(s-1).

Define e_0=0 and e_s=e_(s-1)/2+c_s. The preceding recursion implies

    d_(s-1) <= (D/2) 2^(s-l) e_(s-1).

Since s<=l+1, the factor 2^(s-l) is <=2, and therefore

    R_s(x)+T_s(x) <= A c_s + FD e_(s-1) <= K_S e_s.

The last inequality uses K_S>=A and K_S>=2FD; these numerical
inequalities hold for the constants stated above. For s=1 the same
bound follows from 1+T_1<=7 and c_1>=1. These deductions are pointwise
for R and almost everywhere for T, exactly as required.
`markov_one_step`, `observable_perturbation`,
`scaled_marginal_bound` and `spatial_observable_bound` in Main.lean
formalize these finite-state deductions from the individual-row inputs.
No desired spatial-comparison conclusion is among those inputs.

### 5. Whole squares, essential suprema and the birth convolution

The e_s just constructed depend on the complete path and y, not on x
or l. At a fixed l the estimates in the preceding section hold for
every x in D(q_l) with the same right side. Thus the supremum of
R_l+R_(l+1) is bounded by K_S(e_l+e_(l+1)) if l<m.
For l=m it is bounded by K_S e_m+1. The exceptional set for all T_k
is the fixed union of grid lines, a Lebesgue-null set; an almost-everywhere
uniform bound on D(q_l) bounds its essential supremum. This does
not replace an essential supremum by a point evaluation.

Set f_0=0 and f_l=f_(l-1)/2+e_l, so

    f_l = sum_(k=1)^l 2^(k-l) e_k.

Extend c by zero after m and retain both recurrences. Nonnegativity
then gives the simultaneous bound for the *actual* whole-square bracket

    C_l(q_l) <= K_S(e_l+e_(l+1)+f_l) + 1_(l=m).

The extra nonnegative e_(m+1) merely enlarges the last-level bound.
The real final sentinel is still the separate unit; R_1=1 has already
been included in c_1.

It remains to justify the inherited pre-birth terms. Before birth
0<=c_s<=5, so e_(B-1)<=10 and f_(B-1)<=20 by induction.
For any nonnegative input sequence, summing the first recurrence
from B to m gives the exact identity

    sum_(s=B)^m e_s
      = 2 sum_(s=B)^m c_s + e_(B-1) - e_m
      <= 2 sum_(s=B)^m c_s + e_(B-1).

Summing instead from B through m+1, using c_(m+1)=0, and dropping
the nonnegative e_B gives the same upper bound for
sum_(s=B)^m e_(s+1). Apply the first identity again to the f
recurrence:

    sum_(s=B)^m f_s <= 2 sum_(s=B)^m e_s + f_(B-1).

Adding all three bounds yields, for every birth and depth,

    sum_(l=B)^m (e_l+e_(l+1)+f_l)
      <= 8 sum_(s=B)^m c_s + 4 e_(B-1) + f_(B-1)
      <= 8 sum_(s=B)^m c_s + 60.

This is the universal `birth_convolution` theorem in Main.lean.
It charges no pre-birth ancestor with descendant occupancy. It
bounds its residual filter state instead, even when every earlier
mass was zero.

Finally exact occupancy, now applied to the genuine whole-square
bracket, gives

    sum_l sum_q a_q C_l(q)
      = integral sum_(l=B)^m C_l(q_l) dmu
      <= K_S [8 integral sum_(s=B)^m c_s dmu + 60 mu(all)]
           + mu(all)
      <= [1 + 60K_S + 8K_S(K_R+K_E)] V.

All sums and the particle measure are finite; no interchange of an
infinite sum, essential supremum, or derivative with integration was
used. This proves the verification theorem and its specialization. QED.

## Exact adversarial checks and formal boundary

The rerunnable `verify.py` checks exact algebra, actual-tent degeneracies,
zero-ancestor particle occupancy, stopped defects, the threshold law and
row derivatives, and birth filters. Its finite examples are regression
tests, not the proof for arbitrary depth. It also checks that the real
Lean compiler certificate matches the current source and statement-fidelity
document. A compiler failure, timeout, missing certificate, stale source,
or proof hole makes that check fail; no fallback is counted as support.

The dedicated Jacobian files retain the exact request and typed adapter
response for `polynomial.multivariate.factor.compute`. The operation
factors the switch-square inequality's margin
`2a^2+2b^2-(a+b)^2` as `(a-b)^2`; this is an algebraic supporting
check, not a proof strategy or an independent proof of packing.
The response retains server and protocol versions and any structured error.

The particle regression uses the actual vector measure
`e_1 (delta_(1/12,1/6) - 2 delta_(1/4,1/6) + delta_(5/12,1/6))`,
whose variation is 4. All level-one masses vanish. Its terminal masses
at depths 2, 3, 4 are respectively 8/3, 4, 4, with birth masses
8/3 at level two and 4/3 at level three. These are actual tent
integrals, not freely assigned tree capacities. In these examples
the whole-square costs are exactly 16/3, 20/3, 20/3: all nonzero
neighbors lie in every relevant candidate window, so the chosen
direction at each level is spatially constant on the complete squares
and their derivative costs are zero.

A separate actual-tent test has vector atoms of opposite signs at
level-one vertices (-300,0) and (301,0) in mesh coordinates.
The maximizing neighbor for each of the four sampled tents at
x=(1/4,1/4) is selected by the literal 300-mesh window.
The resulting probability row is (1/2,1/2), with spatial gradients
(-2,0), (2,0), giving scaled **Euclidean** derivative cost exactly 2.
This tests nonzero row derivatives rather than relying solely on
the spatially constant particle examples.

For these finite tests one explicit admissible palette is

    { +/- ((1-t^2)/(1+t^2), 2t/(1+t^2)) : t=j/4000, -4000<=j<=4000 }.

It includes e_1, -e_1 and e_2, all sampled directions in the tests.
The chord distance of two such parametrized points is
`2|t-u|/sqrt((1+t^2)(1+u^2)) <= 2|t-u|`.
The parameter interval and its negative cover the whole circle;
rounding to the nearest parameter gives distance <=1/4000<tau/20.
Thus choosing n_z=Theta_z in the tests is legitimate; unused palette
states are unreachable, not omitted transitions with positive probability.

An additional degeneracy is within the manuscript's original smooth
gradient class. Let rho be any nonnegative even smooth bump of integral
one, supported in (-1/160,1/160), and set

    g(x,y) = [rho(x-1/12)-rho(x-1/3)]
             [rho(y-1/12)-rho(y-1/3)].

Every component bump lies strictly within a cell at each of levels
one through four. Integration by parts against each bilinear tent
therefore depends only on the bumps' zeroth and first moments.
Writing F_p=hat_p(1/12)-hat_p(1/3) and
D_p=hat_p'(1/12)-hat_p'(1/3), the exact mass is
`h_(p,q)=(-D_p F_q,-F_p D_q)`. At level one both centers share
one affine interval and every D_p=0. At level two there are nine
nonzero vector masses. The script certifies these exact formulas
without numerically integrating an unspecified bump.

The 567 rational filter regressions include depths through 2048
and births immediately before the terminal scale. They are explicitly
finite tests. The proof of arbitrary depth and arbitrary birth is
the universally quantified Lean theorem, not an extrapolation from them.

The official Lean evidence run returned exit_code=0, proof_holes=[],
and axiom-audit exit code 0 on Lean 4.31.0. Its immutable claim
certificate is
`certificates/C_FORMAL9000085-b692eefffdf24175.json`.
The compiler establishes the finite algebraic/probabilistic statements;
the complete geometric and measure-theoretic bridges are the proofs
in sections 1-5 above. Neither their fidelity nor independent approval
is inferred from compilation.

The formal certificate applies to C_FORMAL9000085 only. All other
proved assertions use the explicit proof above and Engineer judgements;
their independent review is pending. In particular, proving the packing
mechanism neither certifies `lem:local`, the common-price estimates, nor
the signed finite-band/endpoint conclusions. Those dependencies remain
open in the proof graph. No false literal manuscript assertion has been
identified in this route, so no refutation judgement is manufactured.

## Reproduction

From the campaign root, the exact replay is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/label_packing/verify.py
```

It uses Python's exact fractions and SymPy (1.14.0 on this host).
For a fresh real compiler run, the official command is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/label_packing/Main.lean --statement-fidelity research/label_packing/statement_fidelity.md --claim C_FORMAL9000085 --project-root . --timeout 90
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root .
```

The compiler uses the prebuilt Mathlib workspace; no local Lake project
or library fetch is needed. The recorded project root is
`campaigns/9000085`;
both official campaign-local checks returned zero. These are structural
checks, not a substitute for independent reading of the proof.
