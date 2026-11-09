# Conditional directional bootstrap: mathematical audit

## Scope and prior results

The target is Proposition `prop:directional-bootstrap`, staged
`build/sections/07-rate-transfer.tex:841-993`, and its use at
lines 995-1150. The comparison populations, the pair law, and every
normalized restriction are different objects. No conclusion here about
the other rate-transfer arguments or the Bochner--Riesz theorem is assumed.

Write `L = log(1/rho)`. A subpower factor is a positive sequence with
`log K = o(L)`; a subpower retention has `log(1/m) = o(L)`.
All depths, finite meshes, increments, output errors, and numbers of
iterations are chosen before the small-precision limit. In particular,
`o(L) = o(a L)` only for an already fixed positive increment `a`.

The following are inputs, not conclusions of this audit.

1. Ren--Wang, arXiv:2308.08819v3, Theorem 4.1 and Definition 3.1,
   supplies the discrete exponent `min{1,d,(d+u)/2}` with a multiplicative
   tube-fiber cardinality. The output error precedes the input
   nonconcentration loss in the quantifier order. The staged weighted
   consequence is `03-projection.tex:61-195`, Theorem
   `thm:planar-projection`; the probability-weight/tag reduction is
   justified independently in Section 8 below.
2. The application's starting one-label population has the actual-marginal
   products and conditional prefix caps in `07-rate-transfer.tex:501-563`,
   its capacity floors at lines 750-784, and the exact star comparisons at
   lines 603-625. These upstream statements are not inferred from the
   directional proposition.
3. This application is explicitly in the no-strip branch (line 997).
   No-strip bounds for that unchanged named one-label population are a
   hypothesis, not a result of a subpower trim.
4. Finite homogenization and profile extraction are the finite-law
   statements in `02-entropy.tex`, Lemmas `lem:homogenization` and
   `lem:profile-diagonal`. Uniform original bins, not convergence in
   probability alone, are needed before subsequent subpower restrictions.

Primary-source retrieval by a separate research worker found genuinely
related, already known results:

- Orponen--Shmerkin--Wang, arXiv:2209.00348, Definition 2.1, Lemma 2.8,
  Corollary 2.18: a two-sided thin-tube bootstrap for product-measure graphs.
  Their graphs do not directly give the present conditional pair-law
  statement or subpower bounds for varying constants.
- Shmerkin--Wang, arXiv:2112.09044v3, Lemma 5.12 and Corollary 5.14:
  a finite-scale bootstrap under two-sided near-Ahlfors hypotheses.
  Definition 2.4 and Theorem 4.8 also contain robust entropy and graph-fiber
  formulations. These are precedents, not a substitute for checking the
  present hypotheses.

This bounded lookup does not establish novelty. Reconstructing the known
bootstrap, checking a finite example, or verifying its recurrence would
not by itself meet the campaign's publishability criterion.

## The conditional-population question

The manuscript keeps the following objects separate:

`P <= K mu_A x mu_B`, `R = P(. | H)`,
`R_c = R(. | A_j=c)`, and `G_c`, the separated restriction of `R_c`.
Put `m=P(H)`, `r_c=P(H | A_j=c)`, and let `v_c` be the relative mass of
the separation restriction inside `R_c`.

The reciprocal step must bound the actual pin marginal of `G_c`, not
silently replace it by the named `mu_B`. Its proposed upper bound has
the loss `(r_c v_c)^(-1)`. Establishing or disproving this bound, its
simultaneous use for both pins, and the subsequent projection argument
are the mathematical obligations addressed below.

## 1. Verification theorem and its quantifiers

Here is a slightly more general statement. Give the `A` comparison
population child rate `s_A` and the `B` comparison population child rate
`s_B`, where `0<s_A,s_B<=1`. Keep all the other hypotheses of the
proposition, including the same-law, simultaneous original-bin and
good-parent requirements. The direction conditioned on `A` has lower
prefix dimension

`u_A = min{s_B,(s_A+s_B)/2}`,

and conditioned on `B` it has lower prefix dimension

`u_B = min{s_A,(s_A+s_B)/2}`.

For every finite list of tested depths and every fixed output error,
one can choose a *single* subpower-mass restriction on which the actual
conditional direction caps hold at every surviving value of either
full pin. At a positive tested depth `d`, the bounds are
`rho^(u_A*d-o(1))` and `rho^(u_B*d-o(1))`, respectively. The same
conclusion, with another subpower trim, survives any further subpower
restriction supported on these original bins.

Taking `s_A=s_B=s` gives the literal proposition. This is an analytical
theorem conditional on the cited Ren--Wang theorem, not a fully Lean
formalized theorem. Sections 2-7 prove it; Section 9 checks its application.
The asymmetric statement is a structural consequence of the proof, not
an assertion of literature novelty.

The order of choices is part of the statement. First choose the finite
depth list, the desired output error and the finite iteration count.
At a profile differentiability point choose a fixed positive increment,
then finite intermediate-radius meshes and the projection output loss.
Only afterwards make all input losses and `rho` small. Take the
small-precision limit before shrinking an increment or its mesh. No
uniform finite rate in `a`, `kappa_t`, or the profile is asserted.

## 2. A finite two-sided core, without a product assumption

Let `p(a,b)>=0` be a finite matrix, of total mass `m`. Let `mu,nu` be
probability weights on its two index sets. For any `delta>=0` there
are subsets `I,J` such that the restriction `p'` to `I x J` has

`M >= m-2*delta`,

`p'_A(a) >= delta*mu(a)` on `I`, and
`p'_B(b) >= delta*nu(b)` on `J`.

**Proof.** Among all `I,J`, maximize

`Phi(I,J)=p(I x J)-delta*mu(I)-delta*nu(J)`.

There are finitely many choices. Deleting a row of mass less than
`delta*mu(a)` would strictly increase `Phi`; the analogous assertion
holds for a column. Thus a maximizer has the asserted floors. Its
potential is at least the potential `m-2*delta` of the full rectangle,
and its mass is at least its potential. This also covers zero reference
weights and zero matrix entries. For `delta=m/4`, `M>=m/2`.

This proof is formalized as `two_sided_core` in `Main.lean`.
The existence is universal in the finite alphabets, not a finite scan.
For replay, `verify.py` also implements the equivalent deletion
algorithm: remove one deficient row or column at a time; each index is
charged at most once and the total charged mass is at most `2*delta`.

Two consequences are essential.

**Actual-product replacement.** If the starting probability matrix
`g<=D mu x nu`, take threshold `1/4` and normalize the core by its
mass `M>=1/2`. With actual marginals `alpha,beta`, its normalized law `q`
satisfies

`q <= 16*D*M alpha x beta <= 16*D alpha x beta`,

`alpha <= (D/M) mu`, and `beta <= (D/M) nu`.

Indeed the floors say `mu<=4M alpha`, `nu<=4M beta` on surviving
values. Substitute these inequalities into the old product domination
before dividing by `M`. The marginal upper bounds instead follow by
summing the original named product. These are different arguments;
neither silently identifies named and actual populations.

**Uniform conditional caps under both pins.** Suppose a probability
law `P` has, on an event `E` of mass `m`, original conditional bin
caps `c_A` and `c_B` under the two pins. Start with the raw matrix
`1_E P` and reference weights `P_A,P_B`. Its core at `delta=m/4`
has mass at least `m/2`. At every surviving `a`, the raw mass of
one retained bin is at most `c_A P_A(a)`, while the raw row mass
is at least `(m/4)P_A(a)`. Its actual conditional cap is therefore
`4 c_A/m`. The same core gives `4 c_B/m` at every surviving `b`.
The total normalization cancels in both ratios.
The scalar implication is formalized as `fiber_cap_from_core`.
This supplies genuinely simultaneous, uniform caps without assuming
that a naively normalized intersection preserves either conditional law.

An unqualified actual-product replacement is a dead route, not a
manuscript error: the manuscript explicitly supplies the core.
For example `q(0,0)=e`, `q(1,1)=1-e` is bounded by four times
the uniform named product, but its actual-product density at `(0,0)`
is `1/e`, arbitrarily large. Section 2's core is necessary.

## 3. Conditioning a tested parent and separating pins

Write `P<=K mu_A x mu_B`, let `H` be the original common-bin event,
and set `R=1_H P/m`, `m=P(H)`. Fix the finite test and `0<eta<1/4`.
The elementary likelihood estimate

`U_C{U_C < eta V_C} <= eta`

for probability laws `U,V` follows by summing
`U_C(c)<eta V_C(c)` over that set.

Apply it to `R<=K/m mu_A x mu_B`, observed at `C=A_j`, and also
use `R_C(c)=P_C(c) r_c/m`. Outside `R_C`-mass at most `2*eta`,

`R_c <= D_c mu_A(.|C=c) x mu_B`,

`D_c=K/(m*eta)`, and `r_c>=m*eta`.

There is **no factor `P_C(c)^(-1)`** in this comparison. The first
inequality uses the likelihood ratio against `mu_A(C=c)`;
the second uses the event retention against `P_C(c)`. They need
not be the same parent distribution.

Fix one such parent, which is good by the common-event hypothesis.
Write `A=a_0+rho^j xi`. All the named child bounds belong to
`mu_A(.|C=c)` on the entire named conditional population, so the
rescaled `xi` has ball caps of rate `s_A` at all fixed tested
relative depths.

Remove `|B-a_0|<rho^theta`, initially for fixed `theta>0`.
Its `R_c` mass is at most `D_c` times the named `mu_B` ball
mass, hence at most `D_c rho^(kappa_theta+o(1))` by no-strip.
This estimate is uniform in the chosen center. A slow diagonal
`theta=theta_n -> 0` makes the deleted mass tend to zero.
Call the remaining relative mass `v_c`, the normalized law `G_c`,
and put `D=D_c/v_c`. Thus

`G_c <= D mu_A(.|C=c) x mu_B`,

and `D`, `r_c^(-1)`, `v_c^(-1)` are subpower.
All uses below have fixed `0<a<j`, so eventually `j-theta_n>a`.

## 4. Direction counts really give linear projection counts

Use the original homogeneous bins under the full pin `B`. If their
errors at depths `j,j+a` are at most `epsilon`, every retained
depth-`j` parent bin contains at most

`rho^(-(F_B(j+a)-F_B(j))-2*epsilon)`

retained finer bins. The original upper parent mass divided by the
original lower child mass proves this count. Conditioning on `A_j`
or later restricting support can only remove bins.

For a fixed `B`, put `R_B=|B-a_0|` and
`e_B=(B-a_0)/R_B`. In an angular chart,

`arg(B-A)=arg(B-a_0)-rho^j (e_B^perp . xi)/R_B
             + O(rho^(2j)/R_B^2)`.

All relevant `A` in the parent lie in an angular interval of length
`O(rho^j/R_B)`, meeting `O(rho^(-theta_n))` coarse depth-`j` bins.
Multiplying a fine angular bin by `R_B/rho^j` gives a projection
interval of length `O(rho^a)`, with error `O(rho^j/R_B)`.
The latter is smaller than `rho^a` eventually. Thus, for each
surviving full pin, the support of the normalized scalar projection
`e_B^perp . xi` is covered by

`N <= rho^(-(F_B(j+a)-F_B(j))-o(1))`                 (4.1)

intervals of length `C rho^a`. Counts, not probabilities, are being
transferred here. Boundedly many angular charts and grid boundary
neighbors change only the subpower factor. No lower bound on
`R_B` independent of `rho` is assumed.

## 5. The seed includes a child-law comparison after two pins

Apply Section 2 to `G_c`, obtaining `q`, actual marginals
`alpha,beta`, and `q<=T alpha x beta`, `T=16D`.
The child `alpha` has the named rescaled `s_A` ball cap with
factor `D/M`; `beta<=D/M mu_B` retains no-strip.
Independently sample two `B` pins conditional on `xi` with the
kernel of `q`. The star `S` satisfies

`S <= T^2 alpha x beta x beta`.

For fixed `tau>0`, the event
`|sin angle(B_0-a_0,B_1-a_0)| <= rho^(tau*a)`
places the second pin in a strip of width `C rho^(tau*a)` through
`a_0`. Its star probability is at most
`T^2 (D/M) rho^(kappa_(tau*a/2)+o(1))`, hence tends to zero.
Replacing `tau*a` by `tau*a/2` absorbs the fixed width constant.
This handles antiparallel as well as parallel directions.

Also, outside star pin-pair mass `eta`, the actual pin-pair
likelihood relative to `beta x beta` is at least `eta`.
Conditioning on any such nonparallel pair gives

`S(.|B_0,B_1) <= T^2/eta alpha`.

Thus a typical pair has a child law with the required ball cap;
this is not inferred merely from the unconditional child marginal.
Two projection intervals of length `C rho^a` at sine separation
`rho^(tau*a)` intersect in a set covered by a bounded number of
balls of radius `C' rho^((1-tau)*a)`.
By (4.1), at most a constant times `N^2` such balls cover this
conditional child law. Its total mass one implies

`2*(F_B(j+a)-F_B(j)) >= s_A*(1-tau)*a-o(1)`.

Take the small-precision limit, then `a -> 0`, then `tau -> 0`.
At almost every `j`, `F_B'(j)>=s_A/2`.
Interchanging the roles **on the same original pair law** gives
`F_A'(j)>=s_B/2`.

The profiles are absolutely continuous: nested angular prefixes
give monotonicity and `1`-Lipschitz entropy increments in the
limit, since each coarse bin has at most `C rho^(-(b-a))`
children. They vanish at zero. Integration proves
`F_B(d)>=s_A*d/2` and `F_A(d)>=s_B*d/2`.

## 6. The reciprocal step: average the original law, not a comparison

Suppose `F_A(r)>=u_A*r` and `F_B(r)>=u_B*r`. Return to `G_c`
*before* its actual-marginal core. At every tested `0<r<=a`,
the original conditional direction bins on `H` have cap
`rho^(u_A*r-o(1))` under full pin `A`.

Directions about `A` and about `a_0` differ by
`O(rho^(j-theta_n))`, which is less than the tested angular
precision. For any interval `I` of length comparable to `rho^r`,
write `Z_I` for the event

`H and separation and dir(B-a_0) in I`.

For every original pin `A=a` in the chosen parent,

`P(Z_I | A=a) <= C rho^(u_A*r-o(1))`.             (6.1)

This follows by covering the enlarged interval by boundedly many
original direction bins; bins not attained in `H` contribute zero.
Average (6.1) using **`P_A(.|A_j=c)`**, not `mu_A(.|A_j=c)`.
The numerator before normalizing `G_c` is at most

`C rho^(u_A*r-o(1)) P(A_j=c)`.

The normalizing mass is exactly
`P(A_j=c)*r_c*v_c`. Consequently its actual pin marginal obeys

`(G_c)_B{dir(B-a_0) in I}
       <= C (r_c*v_c)^(-1) rho^(u_A*r-o(1))`.   (6.2)

This is the cancellation formalized by
`reciprocal_retained_cap`. Neither a child-parent mass lower bound
for `P` nor an identification of its marginals with the named
populations is needed. The manuscript's factor is present and
is sufficient.

Now take the Section 2 core of `G_c`. Its actual pin marginal is
at most `M^(-1)(G_c)_B`, so (6.2) persists. Its actual child
marginal is at most `(D/M) mu_A(.|A_j=c)`. Its actual-product
comparison is `q<=16D alpha x beta`. All three properties hold
on **one law**, with the original support counts (4.1).

At working precision `delta=rho^a`, finite meshes of `r` in
`[0,a]` give the interval cap of dimension `u_A` for the pin
directions and the ball cap of dimension `s_A` for the child.
For each fixed projection output loss, choose these meshes fine
enough that their interpolation errors are smaller than the
admissible input loss in `delta` units. A fixed mesh error is
small, not automatically subpower; alternatively a slow
mesh-refinement diagonal makes this error subpower.
The support graph has `(alpha x beta)` mass at least `(16D)^(-1)`.
Indeed integrate its domination against the product. The density,
retention, original-bin and separation losses are subpower in
`delta`, because `a` is fixed. With the separately chosen mesh
error the weighted projection theorem gives the output inequality
up to any prescribed positive loss. Let that loss tend to zero.
Consequently

`F_B'(j) >= min{1,s_A,(s_A+u_A)/2}`.

The reverse argument gives, on the same pair law,

`F_A'(j) >= min{1,s_B,(s_B+u_B)/2}`.

There is no conditioning of `mu_B` on `A_j` in this step.

## 7. Iteration, common uniform trims, and heredity

For the symmetric proposition, starting at `u=s/2`, Section 6
replaces `u` by `(s+u)/2`. After `n` further steps the lower
rate is `s*(1-2^(-(n+1)))`. Every prescribed positive error
needs only finitely many steps; integration is on the same
absolutely continuous profiles throughout.

For the asymmetric theorem, update the vector by

`T_A(x,y)=min{s_B,(s_B+y)/2}`,
`T_B(x,y)=min{s_A,(s_A+x)/2}`.

Start from `(s_B/2,s_A/2)`. The updates are monotone, never
decrease this starting vector, and contract the maximum-coordinate
distance to a fixed point by a factor at most `1/2`.
Their fixed point is exactly

`(min{s_B,(s_A+s_B)/2}, min{s_A,(s_A+s_B)/2})`.

For example if `s_A<=s_B`, its second coordinate is `s_A`
and its first is `(s_A+s_B)/2`; substitution verifies both
equations. The opposite ordering is symmetric.
This proves the stated quantitative finite-iteration error bound.

For a finite output test choose one original common event `H`.
The resulting profile inequalities make its original bins have
the desired two caps. Section 2 applied to `1_H P` with
references `P_A,P_B` and threshold `m/4` gives one normalized
law of raw mass at least `m/2`, with actual caps at *every*
surviving full pin, simultaneously. The extra factor is `4/m`,
which is subpower. This is stronger than merely having two
possibly different exceptional pin sets.

A subsequent weighted restriction of relative mass `z` has raw
bin numerators no larger than before. Apply the same two-sided
core with threshold `z/4` against the previous marginals.
This retains at least `z/2` of raw mass and costs at most `4/z`
in each conditional cap. Thus heredity is a quantified statement,
not the false rule that arbitrary normalized intersections preserve
conditional bounds. Restrictions before the proof can instead be
treated by the same argument provided they retain the proposition's
stated comparison, child, and common-bin hypotheses.

## 8. Why the weighted tagged projection input applies

For completeness, here is the reduction needed above. Write its
precision as `delta` and suppose its point and slope probability
populations obey the `d,u` ball/interval bounds with loss
`delta^(-epsilon)`, and its graph has product mass
`q>=delta^epsilon`.

Sample `N=ceil(delta^(-d))` independent points and
`Q=ceil(delta^(-u))` independent **whole tags**. Binomial
exponential Markov bounds and a union bound over the polynomially
many dyadic cells give, with superpolynomially small failure
probability, occupancy bounds

`C delta^(-3 epsilon) (r/delta)^d` and
`C delta^(-3 epsilon) (r/delta)^u`

at every relevant ball or interval scale. This follows since the
mean is at most `2 delta^(-epsilon)(r/delta)^d` (or its slope
analogue), while the proposed threshold has an additional factor
of order `delta^(-2 epsilon)` and is at least
`C delta^(-3 epsilon)`.

The expected edge count is `qNQ`, and no sample has more than
`NQ` edges. Hence some occupancy-good sample has at least
`qNQ/2` edges: otherwise the bad-sample contribution, which is
`o(qNQ)`, could not make up the expectation.
Remove point vertices of degree below `qQ/4`; at least
`qNQ/4` edges and therefore `qN/4` point vertices remain.
Keep one such vertex per finest square. Finest-scale occupancy
costs at most `C delta^(-3 epsilon)`.

At a fixed retained point, a rounded tube can arise from at
most `C delta^(-3 epsilon)` sampled tags: its slope bin has
that occupancy and its intercept is fixed to bounded ambiguity
by the point. Keep one tube per coincidence. There are at least
`delta^(C epsilon) Q` tubes per retained point. Dyadically
pigeonhole these degrees and prune to comparable common
cardinality `M_0`; this retains at least
`delta^(C epsilon) N` point squares and
`M_0>=delta^(C epsilon) Q`.

The original absolute occupancy bounds still hold on all subsets.
Dividing them by the retained cardinalities proves that the
retained point squares and every selected tube fiber satisfy
the Ren--Wang nonconcentration hypotheses with loss
`delta^(-C epsilon)`. Here `C` is a fixed numerical constant.
Each tube meets its point square, so this is a nice configuration.
All tubes used by one sampled tag belong to its at most `M`
allowed projection intervals, giving at most `CQM` distinct tubes.
Ren--Wang gives

`CQM >= c_alpha delta^(-chi+alpha/4) M_0`,
`chi=min{1,d,(d+u)/2}`.

Fix the desired output `alpha` first. Choose `epsilon` so that
`C epsilon` is smaller than both the Ren--Wang admissible input
loss and `alpha/4`; then choose `delta` small enough to absorb
fixed constants and logarithmic pigeonholing. This proves
`M>=delta^(-chi+alpha)`. No multiplicity bound on tags sharing
a slope, or on their unused labels, was assumed.

In the bootstrap, `q>=1/(16D)`, with `D` subpower, so it
exceeds `delta^epsilon` eventually for every fixed positive
`epsilon`. Angular direction charts give normalized orthogonal
projections with fixed bounded scalar changes. All intermediate
nonconcentration radii are supplied by the finite meshes; refine
the mesh after the fixed input/output loss choices. This verifies
the exact theorem interface, not just its exponent formula.

## 9. The application at lines 995-1150

This check is conditional on the upstream one-label outputs and the
explicit no-strip branch recorded in the ledger. It does not certify
those upstream results.

**Named child bounds.** Every positive child in the current named
`lambda` is attained by its defining retained one-label law. The
tested caps and capacity floors therefore apply to the entire
named conditional population, not just to children of a later
pair marginal. No new comparison population is introduced by
triple-law homogenization.

For a real parent `j` and increment `a`, take
`j_-=j-e_L`, `j_+=j+e_R`, `b_-=j+a-e_C`, with each error in
`[0,delta_mesh]` and the required nesting. The globally fixed
atoms give the exact inequality

`lambda(Theta_(j+a)|Theta_j)
 <= lambda(Theta_bminus|Theta_jminus)
      /lambda(Theta_jplus|Theta_jminus)`.

The exponent furnished by the numerator cap and denominator floor is

`s*a -(2-s)*e_L -2*e_R -s*e_C -o(1)
 >= s*a -4*delta_mesh-o(1)`.

`mesh_exponent_loss` formalizes the last inequality. First choose
`delta_mesh` small relative to `a` and the input loss wanted by the
projection theorem; only then choose precision. The denominator
is the already floored global atom, not a newly selected real-depth
parent. This verifies the comparison population's child hypotheses.

**One pair and a common event.** The exact triple star has each
pair marginal dominated by `K_0^2 lambda_0 x lambda_1`; a raw
restriction of mass `z` changes this to `K_0^2/z`.
The direction children conditioned on either full pin are
functions of this first pair, so their conditional distributions
in the triple law equal those of its first-pair marginal.

Here is a precise finite-list refresh if actual original bins of
that retained pair are wanted. Uniformize the conditional surprises
for both pins and the scalar observation at once. Finite child
alphabets have size at most a fixed power of `rho^(-1)`.
Discard probabilities smaller than `rho^(C+sigma)`, then
pigeonhole the remaining normalized surprises into finitely many
fixed-width bins. The number of bins depends on the finite test,
not on the possibly unrestricted pin alphabets. Choose a part of
subpower mass and pass to a subsequence of its bin centers.

On such a part, every subsequent subpower law has the same
conditional entropy exponents: the lower entropy follows from
the relative-entropy loss at most the logarithm of its density;
the upper entropy follows from the uniform support count.
To refresh to the retained law's own conditional surprises, discard
parent likelihood ratios below a subpower threshold and child
probabilities below that threshold times the reciprocal support
count. Summing over parents and retained children bounds both
exceptions by that threshold. For a finite list their union is
still `o(1)`. This produces uniform bins for the actual pair law
on one common event for both pins. The direction-bin and
good-parent tests are pair-only, so the common event can be taken
in the pair space and lifted exactly to the triple.
The unchanged named factors retain their child and no-strip bounds.
This supplies the proposition's simultaneous hypotheses.

**The scalar test uses the correct pre-event population.** Let
`R` be that lifted normalized law. Retain its good label-0 set and
the pair likelihood filter
`R_01(b)>=eta_pair (lambda_0 x lambda_1)(b)`.
If their intersection has mass `z_0`, then for every interval
the direction distribution of `R^0` is bounded by the original
conditional label-0 cap divided by `z_0`: integrate before
normalizing, rather than asserting the same conditional cap after
a pair-dependent trim. Both filters are pair-only. The exact
comparison is

`R^0_012 <= (K_lab/eta_pair) R^0_01 x lambda_2`.

The factor `z_0` cancels on the two sides. The named third
population still has point dimension at least `s`; the actual
pre-scalar-event pair population has the rate-`s` direction cap.

Let `H_sc` have mass `m_sc` in `R^0`, with uniform original
scalar bins of exponent `l(r)`. Its support count per *full pair*
is at most `rho^(-l(r)-o(1))`. The normalized scalar law is
dominated by
`K_lab/(eta_pair*m_sc)` times the named product
`R^0_01 x lambda_2`. Apply Section 8 with the full pair as tag.
It gives `l(r)>=s*r`.

For a retained pair set `r_b=R^0(H_sc|b)`.
Outside scalar-law pair mass `eta_sc`,
`r_b>=m_sc*eta_sc`; on such a pair the actual conditional
third-label scalar cap is at most
`(m_sc*eta_sc)^(-1) rho^(l(r)-o(1))`.
This is the explicit conditional mass bound, not a conclusion
from entropy alone.

**Separation and the last core.** Pair product domination and
the absolute `lambda` ball cap give
`P(|theta_1-theta_0|<rho^t)<=rho^(s*t-o(1))`
for every fixed `t>0`. A slow diagonal chooses the stated
subpower separation threshold. This filter and the typical
star-comparison filters are pair-only: conditional laws at each
remaining pair are unchanged. On a fixed pair, any later
simultaneous core of raw relative mass `M_b` has third marginal
at most `M_b^(-1)` times the pre-core conditional third marginal.
Thus the scalar cap survives with the very same product-law
core, as asserted in `eq:rate-third-slope`.

All changes of comparison population in these lines are thereby
accounted for. In particular no polynomially small parent or
full-pair mass is inverted without the appropriate likelihood
or raw-retention factor.

## 10. Evidence boundaries and result

The argument proves the target directional proposition, including a
single common uniform two-pin trim, and checks its stated no-strip
application conditional on the recorded upstream inputs. No false
literal assertion in the target range has been established; hence
there is no justified `F_...` refutation claim for this route.

`Main.lean` addresses universally quantified finite core existence,
per-fiber normalization, retained-parent averaging, and the mesh
inequality. It does **not** check the analytical proof above.
`verify.py` replays exact rational examples, the Jacobian result,
the core algorithm, and algebraic identities; it also checks the
compiler certificate's binding when that certificate is present.
Finite examples are explicitly not an all-scale counterexample.
The mathematical all-scale conclusion rests on Sections 3-9 and
Ren--Wang, not on the finite experiment.

The only literature claim of necessity for this proof is the precise
Ren--Wang theorem already retrieved. Upstream one-label hypotheses
remain conditional. Independent statement-fidelity and analytical
review are still required. Novelty and publishable significance are
not established by this Engineer report or by the compiler; the
campaign must not be declared complete on that basis.

The actual compiler run used the installed Mathlib workspace and
Lean 4.31.0, returned exit code `0`, reported `proof_holes=[]`,
and passed its axiom audit. Its archived claim-linked certificate
is cited in `exact_certificate.json`. The exact replay returned
`ok=true`: 15 finite core fixtures, 128 simultaneous conditional
cap checks, 192 rational rate updates and 81 mesh checks. These
counts describe experiments only; the general finite core is
established by the formal theorem.

Two distinct versioned propositions still need independent
citation attribution: the common assumption `RW41`, used by
`DB_PROJECTION_INPUT`, `DB_MAIN` and `DB_ASYMMETRIC`, and the
background precedent `DB_PRIOR_RESULTS/SW_PRECEDENT`.
Primary-source retrieval has already been done; an attribution
is not replaced by a resolving DOI or by the Engineer filing
its own supporting judgement. The official attribution command
archives under `research/literature/`, outside this Engineer
mission's writable paths, so it has not been run here.

From the campaign root, the standalone exact replay is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/directional_bootstrap/verify.py
```

For a fresh real compiler run rather than checking the archived run:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/directional_bootstrap/Main.lean --statement-fidelity research/directional_bootstrap/statement_fidelity.md --claim DB_FINITE_CORE --project-root .
```

The source and fidelity document must remain untouched throughout that
compiler run. No project Lake file or dependency installation is needed.
