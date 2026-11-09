# An explicit continuum certificate for the three-marginal Coulomb construction

## Result and scope

**Quantitative verification theorem (candidate for independent review).**
For the Coulomb cost on R^3 in the staged manuscript, take

    K = 16,  r = 10^-6,  delta = 10^-8,  beta = 10^-10.

Let U_0=B(0,r), U_k^+=B(a_k,delta), U_k^-=B(-a_k,r), where
a_1=e_1 and a_2=e_2. The potentials and stationary maps of `lem:local`
exist on these sets. Their (x,z)-Hessian is uniformly at least 12 I.
Both stationary coordinate maps are diffeomorphisms, with global lower
Lipschitz bounds 69/1000 and 1/500. Both central images contain B(0,beta).
The supporting inequality holds on the union of the five balls, with
exactly the two claimed contact families and their permutations.
Every unwanted distinct-component type has slack greater than 19/100;
every repeated-component type has slack at least 499991.

Consequently these explicit parameters yield a smooth compactly supported
identical probability density with smooth compactly supported square root,
a finite optimal Coulomb coupling, and no optimal preserving Borel pair.
This quantifies `lem:local`, `prop:certificate`, and `lem:common-ball`,
rather than just verifying their center configurations.

This is a proof using exact symbolic/rational arithmetic and standard
analysis, not a fully formalized analytic theorem. The accompanying Lean
source proves the full measurable-selection obstruction, generalized to
any finite family of disjoint measurable embeddings whose central weight
strictly exceeds every selectable outer weight. Lean 4.31.0 compiled it
with exit code 0 and no proof holes; the successful official record is
`lean_verify_v2.json`, archived as
`certificates/C_CC_SELECTOR-2676439fec1b53eb.json`.
Its precise scope is in `statement_fidelity.md`.
Independent Reviewer approval and literature-wide
novelty are not asserted. The full Riesz extension remains open in this audit.
No false assertion of the staged manuscript has been identified.

## What was already known

The supplied primary sources were opened before custom computation by the
`primary-baselines` research subagent; short excerpts are in `literature/`.
Colombo--Di Marino, April 11, 2013 author version, Theorem 1.1, proves
equality of Coulomb Kantorovich and cyclic Monge infima for identical
nonatomic marginals, not attainment. Gerolin--Kausamo--Rajala,
arXiv:1805.00417v1, Theorem 1.1, proves map nonattainment for repulsive
harmonic cost, not Coulomb. Friesecke, arXiv:2601.02616v1, Section 3.2,
records the higher-dimensional Coulomb Monge-existence question as open.
These are historical/comparison baselines, not inputs needed for the
quantitative proof below. In particular, we do not claim to rediscover
nonattainment independently of the staged September 2026 manuscript.
The new candidate contribution is an explicit, replayable quantitative
strengthening and formal certification of its obstruction.

The supplied Wiki index contained no matching Coulomb/Monge/optimal-transport
entry. No broader novelty search has yet established `verified_new`.

## 1. Independent center derivatives

Write h(b)=|b|^-1 and D=3aa^T-I for a unit coordinate vector a.
Direct differentiation gives

    Dh(b) = -b/|b|^3,
    D^2h(b) = (3bb^T-|b|^2 I)/|b|^5,
    D^3h(b)[u,v,w]
      = 3((u.v)(b.w)+(u.w)(b.v)+(v.w)(b.u))/|b|^5
        - 15(b.u)(b.v)(b.w)/|b|^7.

In particular ||D^3h(b)|| <= 24/|b|^4 by Cauchy--Schwarz.
The script differentiates h independently and checks all 9 second and
27 third partial identities. It also differentiates the complete
three-particle cost, without importing the manuscript's matrices.
At (0,a,-a), c=5/2, grad_x c=0, grad_z c=5a/4, and

    M = [[2D, -D], [-D, (9/8)D]],     N = [-D; -D/8].

Let H_0=M+16I. Symmetric row diagonal dominance gives H_0 >= 13I.
For a D-eigendirection d in {2,-1}, the determinant of its two-by-two
block is

    Delta_d(K) = K^2 + (25/8)Kd + (5/4)d^2,

and the stationary derivative -(M+KI)^-1 N has coordinates

    DX_d = d(K+5d/4)/Delta_d(K),
    DZ_d = d(K/8+5d/4)/Delta_d(K).

Thus at K=16 the axial/transverse entries are respectively

    DX: 37/361, -59/829;      DZ: 9/361, -3/829.

Their least singular values exceed 7/100 and 3/1000. Also
||N||^2=65/16<(5/2)^2. The second branch just permutes the axes.
As an adversarial boundary test, K=10 makes the transverse DZ entry zero.
This is **not** a counterexample to the manuscript, which chooses K
sufficiently large to make both coordinates invertible.

## 2. Uniform continuum bounds and existence

Consider the full product |x|<=r, |y-a|<=r, |z+a|<=r.
Each pair displacement differs from its center by at most 2r and has
norm at least 1-2r>1/2 along the intervening segment. The third derivative
bound gives a pair-Hessian perturbation at most

    24 * 16 * 2r = 768r.

Embedding a pair interaction in all nine variables multiplies its
Hessian norm bound by at most 2. Summing the three pair interactions
therefore bounds the **entire** cost-Hessian perturbation, and hence
each extracted block perturbation, by

    E = 4608r = 72/15625.

There is no sampling in this estimate. In particular for
F=c-u_0-v, with u_0=5/2-8|x|^2 and
v(z)=5a.(z+a)/4-8|z+a|^2,

    H = D^2_(x,z) F >= (13-E)I > 12I,
    ||D_y grad_(x,z) F|| <= 5/2+E < 3.

Set v_*= (x,z+a) in R^6, G(v_*,y)=grad_(x,z)F, and

    Phi_y(v_*) = v_* - H_0^-1 G(v_*,y).

On the closed six-ball |v_*|<=r/2, for |y-a|<=2delta, this map
has Lipschitz bound q=E/13<1/1000. Since G(0,a)=0,
|Phi_y(0)| <= 3|y-a|/13. The exact inequality

    q r/2 + 6delta/13 < r/2

shows that Phi_y preserves that closed ball. Banach's theorem gives
one fixed point. Its displacement is bounded by

    |v_*| <= 3|y-a|/(13(1-q)) < |y-a|/4.

The smooth implicit function theorem applies because H is invertible
everywhere at these solutions. This gives smooth X,Z on a neighborhood
of the closed delta-ball (indeed on the open 2delta-ball). For each y,
strict convexity on the convex product B(0,r) x B(-a,r) makes this
stationary pair the unique minimizer on that product. Its value w(y)
is smooth and w(a)=0. Thus the local inequality and its exact equality
characterization hold on the stated product, not just at its center.

## 3. Both diffeomorphisms and a common ball

Differentiation of G=0 and the resolvent identity give

    ||D(X,Z) - D(X,Z)(a)||
      <= (E/12)(1+3/13) < 1/1000.

All norms are Euclidean operator norms. For either coordinate Q=X,Z,
integrate DQ-L_Q along the segment joining any two parameter points.
This bounds |Q(y)-Q(y')-L_Q(y-y')| by |y-y'|/1000.
The singular margins in Section 1 imply lower Lipschitz bounds
69/1000 for X and 1/500 for Z. This proves global injectivity on
the convex delta-ball. Derivative invertibility and the inverse function
theorem give diffeomorphisms onto open images for **both** coordinates.
The stationary displacement bound places their images inside U_0,U_k^-.

To certify a common image ball without an unquantified shrinking argument,
write X(a+t)=L_X t+R(t), with R(0)=0 and Lip(R)<1/1000.
We have ||L_X^-1||<100/7. For any |x|<=beta, the map

    t -> L_X^-1(x-R(t))

has Lipschitz bound 1/70 and maps the closed delta-ball into the ball
of radius

    (100/7)(beta+delta/1000) = (11/70)delta < delta.

Banach's theorem therefore supplies an interior solution X(a+t)=x.
This applies to both axes with the same beta=delta/100.
Consequently Y_k=X_k^-1 and W_k=Z_k composed with Y_k are smooth
diffeomorphisms on B(0,beta), with the four required outer images.

## 4. Every component pattern and the entire contact set

The five closed component balls are disjoint, since 2r<1.
On the central ball use u_0; on the positive balls use w_k;
on the negative balls use v_k. This defines a bounded continuous u
on their disjoint union U.

At any stationary branch, the envelope identity gives
Dw=grad_y c. Its norm is at most
(1-2r)^-2+(2-2r)^-2<5, so |w(y)|<=5delta.
Also |v(z)|<=5r/4+8r^2<2r and |u_0-5/2|<=8r^2.
In particular |u|<3, and every component potential differs from
its center value by at most 5r.

There are 35 unordered component multisets: 2 designated types,
8 other distinct-component types, and 25 repeated-component types.
Equivalently all 125 ordered patterns split as 12,48,65.
The script enumerates all of them, including their pair squared distances.

For unwanted distinct centers, the gap is either
1/sqrt(2)-1/2>1/5 (central component present), or
1/2+sqrt(2)>19/10 (central component absent). The exact inequality
(7/10)^2*2<1 certifies the radical lower bound.
Moving the three points in their component balls changes each pair
cost by at most 8r: along the segment its gradient norm is at most 4,
and its displacement at most 2r. The total cost change is at most 24r;
the potential-sum change is at most 15r. Hence the slack is greater than

    1/5-39r = 199961/1000000 > 19/100.

For any repeated-component type, two points are within 2r, giving
c>=1/(2r), whereas the potential sum is <9. Its slack is at least
1/(2r)-9=499991, with infinite cost at collisions.

The remaining designated types have precisely the local equality set
from strict convexity. Symmetry handles all permutations. This proves
the global inequality and its **complete** contact characterization.
Restriction never introduces an extra equality pattern.

## 5. Smooth density, optimality, and arbitrary Borel nonattainment

Take the usual nonnegative bump

    b(x)=exp(-1/(1-4|x|^2/beta^2)) for |x|<beta/2, and 0 otherwise,
    g=b/(integral b^2)^(1/2),      nu=g^2 dx.

It has compact support strictly inside B=B(0,beta), is smooth including
its boundary, and integral g^2=1. For each of the four diffeomorphisms
H=Y_1,W_1,Y_2,W_2, put

    g_H(y)=g(H^-1(y)) |det D H^-1(y)|^(1/2) on H(B), and 0 outside.

Its compact support lies strictly inside H(B), so zero extension is
smooth. The nonzero smooth Jacobian determinant has a smooth absolute
square root, irrespective of its orientation. Change of variables gives
H#nu=g_H^2 dy. The five supports are disjoint, and therefore

    rho = g^2/3 + sum_H g_H^2/6,
    sqrt(rho) = g/sqrt(3) + sum_H g_H/sqrt(6).

Both functions are smooth and compactly supported; integral rho=1.

Choose x with law nu, k uniformly in {1,2}, and a uniform permutation of
(x,Y_k(x),W_k(x)). This coupling has all three marginals
mu=nu/3+sum_H H#nu/6 and is supported on the contact set. Its cost is
bounded by 2/(1-2r)+1/(2-2r)<3. The global supporting inequality proves
its optimality by integration; bounded u and finite optimal cost justify
subtraction of the dual value. Every optimizer must have zero
nonnegative slack almost everywhere and hence lie in the contact set.

Suppose a preserving Borel pair induced an optimizer. On the central
component, its first output T must be one of the four H_j(x) for
nu-almost every x. The Borel selection sets
S_j={x in B:T(x)=H_j(x)} cover nu-almost all of B. Each H_j(S_j) is
Borel, because H_j is a homeomorphism onto an open image. Disjointness
and injectivity give

    mu(S_j)=nu(S_j)/3,        mu(H_j(S_j))=nu(S_j)/6.

Since S_j is contained in T^-1(H_j(S_j)), preservation gives
nu(S_j)/3<=nu(S_j)/6. Finite nu forces nu(S_j)=0 for all j, contradicting
their almost-everywhere cover. This uses actual image measures, not just
component totals, and applies to arbitrarily irregular preserving Borel
maps. Other incoming mass only strengthens the contradiction. It already
excludes a single preserving output; no cyclic relation or regularity of
either output was used.

## Analytic dependencies, replay, and evidence boundary

The proof uses Banach's contraction theorem on a complete closed Euclidean
ball; the finite-dimensional smooth implicit/inverse function theorems
with explicitly verified invertible derivatives; integration along line
segments; the spectral consequence of symmetric row diagonal dominance;
the standard smooth bump and diffeomorphic change-of-variables theorems;
and elementary Borel pushforwards, finite subadditivity, and the zero
integral characterization for a nonnegative measurable function. These
standard analytic tools are explicit ledger assumptions. They are not
replaced by numerical evidence or claimed to have been formalized here.

Run `python3 research/coulomb-contact-certificate/verify.py` with SymPy
installed. It independently differentiates the Coulomb expressions,
checks the exact rational bounds used above, exhausts the finite
component-pattern reduction, checks the recorded Lean result against the
current source and fidelity text, and compares with `exact_certificate.json`.
No floating-point calculations enter the certificate.

The official source-bound formal replay, from the campaign root, is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify \
  research/coulomb-contact-certificate/Main.lean \
  --statement-fidelity research/coulomb-contact-certificate/statement_fidelity.md \
  --claim C_CC_SELECTOR --project-root .
```

Before custom code, the Argus Jacobian adapter discovered and inspected
`interval.expression.second_jet_enclosure.compute` and executed the
bounded three-variable Coulomb-pair payload in `jacobian_payload.json`.
The preserved typed output is `BACKEND_ERROR` on server 0.14.0, protocol
2025-11-25, despite adapter exit code 0. This is a backend non-conclusion,
not support or refutation. The proof uses the independently checked
symbolic third derivative and rational estimates instead. Exact request,
typed output, detail, and adapter status are preserved separately.

Independent review must assess the prose-to-bounds implications and the
Lean statement fidelity. A passing arithmetic replay alone does not
prove that a mistranslated analytic argument is correct. The stronger
quantitative result here improves on the staged proof's unspecified
"sufficiently small" neighborhoods; it does not refute the manuscript,
settle the full Riesz extension, or itself establish literature-wide novelty.

The source readings above are preserved, but the machine citation queue
for `A_FRIESECKE_OPEN` and `A_GKR_HARMONIC` is still open. The official
`citation_check attribute` unconditionally archives in `research/literature/`,
outside this mission's authoritative writable paths; no such write was
attempted. The Host must authorize that archival location or supply a
boundary-compatible official citation writer before final Reviewer
acceptance. This does not leave an analytic dependency of the quantitative
theorem unproved: those two assumptions belong only to the separate
historical-baseline claim, not to the construction proof.
