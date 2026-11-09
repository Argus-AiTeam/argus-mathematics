# Simultaneous shielding with arbitrary matching seam traces

## Result and scope

**Theorem T.** Under the finite-label packet and true-cut hypotheses specified
below, Proposition `shield:global` holds with its stated coefficient
`22/25 = .88`, on the wall and on **both** joined sides, without imposing a
zero seam trace. In fact its existential conclusion holds with `7/25 = .28`.
More generally, every prescribed common coefficient

\[
                         \theta>29/108
\tag{T}
\]

is possible. The choices of scales and fronts depend on the packets and on
theta. No optimality is asserted.

This is an analytic proof, with exact executable checks of its algebraic,
differential, and dimension/count identities. The geometric theorem is not
fully Lean-formalized; `Main.lean` separately encodes only the explicitly
scoped scalar, seam, count, exponent and dyadic-budget core.
The executable checks alone are not a proof of compactness or of the geometric
construction. Those arguments are given below and require independent review.
No false manuscript assertion is claimed, and no `F_` refutation is being
submitted. Neither spectral paper nor the manuscript family's main theorem is
certified by this result.

The strongest relevant prior result is the manuscript's `.88` bound. The
improvement is not an additive-cost calculation: the same number-independent
construction works below `.28`, by improving the joined Hardy field and the
two-pole profile. The broader threshold (T) follows by taking strict parameter
limits, not by using a critical profile with infinite crossing length.

### Exact hypotheses, and dependencies not discharged here

The staged source is
`../openai_manuscript/Positive-scalar-curvature-and-uniform-codimension-two-width-September-23-2026/build/`.
The following are the actual inputs to this downstream shielding assertion.

1. The finite status diagram of `packet:category` has commuting proper product
   tails, finite directed face and coface incidence including chains, finite
   depth, compact truncations, and compatible smooth metrics and positive old
   warp weights. There may be countably many packets. A fixed packet is
   complete; it has the compact-part/product-end geometry of
   `packet:geometry` and `packet:escape`.
2. There are finitely many remaining labels. The profiles, potentials, forced
   sets and open cores satisfy `packet:invariant`; in particular
   `3/5 <= a_r <= 63/100`, potentials have positive floors, and each core
   closure is inside its designated pole interior. Smooth data and sets are
   exact products sufficiently far in each relevant tail.
3. The true cuts are fixed. We use **all the relevant conclusions** of
   `cut:gmt`: singular sets are relatively closed of Hausdorff dimension at
   most `m-8`; regular walls are smooth embedded multiplicity-one perimeter
   hypersurfaces; their generalized mean curvature is locally bounded; area
   measures have local upper and lower bounds; blowups are minimizing cones;
   densities are upper semicontinuous; flat tangents imply regularity; and
   converging cuts have no stray boundary support and are single smooth
   graphs near regular limiting points. We also use the measure, support,
   phase and regular graphical product convergence of `cut:end-convergence`.
   These are imported **geometric hypotheses**, not consequences of the
   coefficient calculations in this report. This audit does not independently
   establish the full `cut:gmt`, generic uniqueness, or end-convergence
   theorems from perimeter minimization.
4. At the initial radial parent, the compact transition-shell buffers are
   locally finite and separated by the prescribed barrier subbands, as in
   `packet:initialization` and `cut:barriers`. No product convergence or bounded
   geometry at infinity of the original manifold is assumed.

These inputs are not strengthened to uniform curvature, uniform shell scales,
vanishing seam values, finite undirected incidence components, or compactness
of the entire singular set. Local constants may depend on the fixed packet
and compact window. The imported geometric hypotheses remain obligations of
any audit of the full pointwise or spectral theorem.

The external analytic inputs used below are Simon's submanifold Sobolev
inequality and the compact smooth Nash embedding theorem. Primary sources are
archived in `literature/`; their precise locators and scope are recorded at the
end. They remain explicit assumptions in the claim ledger, pending independent
citation attribution.

## 1. Forms and the seam identity

Write `b=4/5`, `c=17/10`, and `e0>0`. On a wall use
`N=c integral |grad v|^2`. On a joined side

\[
 J_\Omega=\Omega\cup_{S_{\rm reg}}(S_{\rm reg}\times[0,\infty)),\qquad
 N=b\int_\Omega|\nabla v|^2+c\int_{S_{\rm reg}\times[0,\infty)}|\nabla v|^2.
\]

All integrals carry the old warp weight, frozen in cylinder height.
`h=N+e0||v||_2^2`. The form space is the completion of compact piecewise smooth
tests avoiding the singular set and its cylinders, with equal, otherwise
arbitrary, seam traces. An ambient potential is frozen in cylinder height.
Compact pure-cylinder tests inherit every joined form bound by translation
into positive height and extension as zero on the bulk.

For any smooth weighted vector field A on a regular domain Q, expansion of
`integral |grad v+Av|^2` and integration by parts give

\[
 \int_Q|\nabla v|^2\ge
 \int_Q(\operatorname{div}_\omega A-|A|^2)v^2
       -\int_{\partial Q} A\cdot\nu_Q\,v^2.
\tag{1}
\]

Use a bulk field `A_b` and a cylinder field `A_h+a partial_t`, with `a>=0`,
independent of height, and `c a >= b |A_b|` at the seam. The two boundary
terms in (1), with their energy coefficients, have sum

\[
                \int_S[-b A_b\cdot\nu_\Omega+c a]v(0)^2\ge0.
\tag{2}
\]

The sign is correct for either phase normal. Equality of the traces, not a
Dirichlet condition, is what permits (2). Horizontal derivatives of `a(x)` do
not enter its vertical divergence. Its interior cost is exactly `c a^2`.

## 2. Anchors and compact uniformly flat pieces

Clip each old profile to `[-1,1]` and compatibly smooth within `1/10`.
Finite directed incidence permits assigning the finitely many coface error
requests to a face before smoothing; blending with exact face copies beyond
larger thresholds preserves the assigned error. Denote the results by `h_j`.
At a positive old pole `h_j>=.9`, and at a negative pole `h_j<=-.9`.

For any set I of `m-7` labels, the smooth map `h_I` sends the singular set to
a Lebesgue-null subset of `R^(m-7)`: its source has Hausdorff dimension at
most `m-8`. A compact exhaustion makes these images measurable. There are
only countably many packets and finitely many such subsets per packet.
Choose thresholds `t_j in (-.3,.3)` outside the union of the corresponding
null cylinder sets. At a singular point at most `m-8` labels have
`h_j=t_j`. A strict positive anchor cannot contain an old negative pole,
and conversely.

For completeness, the compact-piece decomposition does not assume
rectifiability of the singular set. A tangent minimizing cone C has a linear
translation-invariance spine of dimension at most `m-8`. Indeed, a point z
with density at least the vertex density has equality at every radius in
the stationary monotonicity formula, so C is conical about z as well as
about zero. Composing dilations gives invariance along z. Such spine points
are singular unless C is a plane.

Fix a singular point x and any small flatness eta. At all sufficiently small
radii, the singular points z with `Theta(z)>=Theta(x)-d_x`, for some
`d_x>0`, lie within `eta r` of an `(m-8)`-plane. Otherwise rescale failing
radii with tolerances tending to zero. A converging bad point on the tangent
cone has density at least the vertex density by upper semicontinuity,
contradicting its positive distance from a plane containing the spine.

Group points by lower bounds `r_x>=1/a`, `d_x>=1/b`, and density intervals of
length less than `1/(2b)`. Within a group every point meets every other
point's density tolerance. Intersect with countably many compact chart
subpatches contained in the chosen strict anchor, then take closures. At
a closure center, use group centers tending to it and radius `2r`; compactness
of the Grassmannian transfers the plane containment to the closure. Starting
with flatness less than `eta/3` gives the desired eta after this step.

Thus, for every eta, each strict-anchor portion of the singular set is
covered by countably many compact pieces F with

\[
 F\cap B_r(x)\subset\{z:\operatorname{dist}(z,L_{x,r})<\eta r\}
                  \quad(x\in F,\ 0<r<r_F).
\tag{3}
\]

The eventual positive-radius forcing neighborhoods, not the compact pieces
themselves, will be the open cover used in the stopping argument.

## 3. A preliminary Hardy estimate with uniform leading coefficient

Here the proof must avoid choosing the later strong flatness using an
F-dependent constant. Fix rough flatness `eta0` first. The projection packing
argument applied to (3) covers a piece at each scale by at most
`lambda^(-(m-8+1/2))` smaller balls, after choosing a sufficiently small
fixed lambda. Iteration and enlargement of the last balls imply

\[
 |B_d(x)\cap\{\delta<t\}|\le C d^{m-7.5}t^{7.5},\qquad
 \int_{B_d(x)}\delta^{-5.5}\le C d^{m-5.5},
 \quad\delta=\operatorname{dist}(\,\cdot\,,F).
\tag{4}
\]

These statements are at allowed small scales in a buffered chart; constants
depend only on dimension and the permitted rough distortion.

With a chart cutoff chi equal to one near F, set

\[
 U(x)=1+\int\chi(y)\delta(y)^{-5.5}|x-y|^{-(m-4)}\,dy.
\]

Splitting into a ball of radius comparable to delta and dyadic annuli, using
(4), gives `U` between fixed positive multiples of `delta^(-1.5)` and
`|grad U|<=C delta^(-2.5)`, after reducing the final distance threshold.
For a d-dimensional Euclidean tangent plane T and `a=m-4`,

\[
 -\operatorname{tr}_T D^2|z|^{-a}
 =a|z|^{-a-2}\{d-(a+2)|\operatorname{proj}_T\widehat z|^2\}
 \ge a(d-a-2)|z|^{-a-2}.
\tag{5}
\]

For `d=m,m-1` the last coefficient is positive. Small fixed chart distortion
preserves this. Connection, weight and bounded wall mean-curvature errors
are first-order errors of size at most `C_F delta^(-2.5)` before division
by U. The positive second-order contribution is of order `delta^(-3.5)`.
Consequently, near F,

\[
              -\Delta_\omega U/U\ge c_1\delta^{-2},
                   \qquad|\nabla\log U|\le C_1/\delta .
\tag{6}
\]

Second derivatives of the kernel are locally integrable off F, so this
differentiation is legitimate and has no diagonal distributional term.

In (1) use `-s rho grad log U` in bulk, its tangential version horizontally,
and `(b/c)s rho sqrt(1+|grad log U|^2)` vertically on the cylinder. Here rho
is a fixed cutoff equal to one near F. Formula (2) applies. For small
`0<s<=1`, (6) supplies positive order-s inverse-square terms, whereas the
vertical square costs order `s^2`. Absorb the latter by choosing s first.
All cutoff errors away from F are bounded F-dependent potentials. Thus

\[
 c_0\int_{\delta<d_F}\delta^{-2}v^2
                  \le N(v)+C_F\|v\|_2^2,\qquad c_0>0.
\tag{7}
\]

The leading `c0` depends only on dimension and rough distortion, not on F.
No bound on the individual wall principal curvatures was used.

## 4. A stronger joined Hardy field

Choose a logarithmic squared partition `q^2+q_infty^2=1`, with `q=1` on
the potential shell and `q=0` outside `delta<xi K epsilon`. Arrange
`|grad q|^2+|grad q_infty|^2<=xi^2 delta^(-2)`. Take a normalized squared
box partition `sum phi_i^2=1` at scale `K epsilon`. Its gradient error on
the support of q is at most `C_m xi^2 delta^(-2)`. The weighted IMS identity
and (7) allow the choice of xi so that

\[
        \sum_i N(q\phi_i v)\le(1001/1000)N(v)+C_F\|v\|_2^2.
\tag{8}
\]

Choose xi using `c0` first, then K large enough for the logarithmic taper,
then strong flatness eta, and only then F and epsilon. Thus (8) involves
no circular choice of a leading coefficient using `C_F`.

On a box choose the plane L in (3) on a sufficiently large neighboring
ball, and put

\[
 \zeta^2=\operatorname{dist}_{\rm Eucl}(x,L)^2+\alpha^2\epsilon^2,\qquad
 P=\zeta^2/2.
\]

The Hessian of P is a rank-eight orthogonal projection. Its trace on every
hyperplane is at least seven. By accurate charts, small scales, then small
alpha and eta, arrange, with `0<=e<=1/10000`,

\[
 \Delta_\omega P\ge8-e\ \hbox{in bulk},\quad
 \Delta_{S,\omega}P\ge7-e,\quad
 |\nabla P|^2/\zeta^2\le1+e,\quad
                 \zeta\le(1001/1000)\delta
                 \ \hbox{on the potential shell}.
\tag{9}
\]

The wall Laplacian uses its mean curvature, not its individual principal
curvatures. All first-order terms are `O_F(K epsilon)`.

For `A=d grad log zeta`,

\[
 (\operatorname{div}_\omega A-|A|^2)\zeta^2
             =d\Delta_\omega P-(2d+d^2)|\nabla P|^2/\zeta^2.
\tag{10}
\]

Use the improved coefficients **d=3 in bulk and d=5/2 horizontally on the
cylinder or wall**, rather than the manuscript's 1 and 2. On the cylinder
add the vertical component

\[
                 \frac{b}{c}\frac{3\sqrt{1+e}}{\zeta}\partial_t .
\]

It pays either bulk normal flux by (2). The resulting interior coefficients
of `zeta^(-2)` are bounded below by

\[
\begin{split}
 B(e)&=\frac45(9-18e),\\
 C(e)&=\frac{17}{10}\left(\frac{25}{4}-\frac{55}{4}e\right)
               -\frac{288}{85}(1+e),\\
 W(e)&=\frac{17}{10}\left(\frac{25}{4}-\frac{55}{4}e\right).
\end{split}
\tag{11}
\]

For the entire interval `0<=e<=1/10000`, both B and C exceed `719/100`;
W exceeds C. In particular

\[
 N(q\phi_i v)\ge(719/100)\int\zeta^{-2}(q\phi_i v)^2.
\tag{12}
\]

This estimate is valid on the entire localized support, so its nonnegative
right side can be restricted to the shell. Summing, and using (8)--(9), gives
for every nonnegative shell potential with `D<=C_up delta^(-2)`,

\[
 \frac{29}{25}\int Dv^2
 \le
 \frac{(29/25)C_{\rm up}(1001/1000)^3}{719/100}\,N(v)
                  +C_F\|v\|_2^2.
\tag{13}
\]

For the manuscript's original `C_up=53/25`, the coefficient is exactly
`1541615612537/4493750000000 < .344 < .78`. Hence this argument also
verifies its required local `.78` estimate without changing its shell.

Letting all strict errors in (8)--(12) tend to zero proves every leading
Hardy coefficient below `36/5`. The cylinder limiting coefficient is
`4921/680 > 36/5`, with the strictly positive difference `5/136`.
This small strict margin is essential: it is not justified to optimize the
bulk field while ignoring the compensating vertical square.

## 5. Two-pole profiles, including the strengthened choice

Fix `a_s<a_r`, `C_low>1/a_s`, and `C_up>C_low`. Write

\[
 Q(y)=\tfrac12a_s y^2-y+\tfrac12 C_{\rm low},\qquad
 s^2=a_s C_{\rm low}-1>0,\quad L=2\pi/s.
\]

The identity

\[
           2a_s Q(y)=(a_s y-1)^2+s^2
\tag{14}
\]

shows positivity. The solution

\[
 y(t)=a_s^{-1}\{1+s\tan(st/2-\pi/2)\},\quad 0<t<L,
 \qquad u_\epsilon(x)=\frac{y(\log(e^L\epsilon/\delta(x)))}{\delta(x)}
\tag{15}
\]

has the required two infinite end values. Extend by `+infinity` for
`delta<=epsilon` and by `-infinity` for `delta>=e^L epsilon`. Since distance
is 1-Lipschitz, (14)--(15) give

\[
                 2|\nabla u_\epsilon|
                   \le a_s u_\epsilon^2+C_{\rm low}\delta^{-2}.
\tag{16}
\]

Every finite clipping is locally Lipschitz, including near its clipping
interfaces and the extended poles. Smooth a nonnegative distance cutoff
times a coefficient strictly between `C_low` and `C_up`, retaining support
in `epsilon/2<delta<2e^L epsilon`. The strict margins give a smooth D with
`D>=C_low delta^(-2)` on the finite band and
`D<=C_up delta^(-2)` everywhere. For small epsilon its support and inner
pole region lie compactly in the prescribed strict anchor.

Taking the maximum with the old profile, or the minimum with `-u`, preserves
the gradient bound by the almost-everywhere active-branch rule. Add the open
`delta<epsilon/2` region to the appropriate core; its closure lies in the
open new pole region. Opposite signs have disjoint strict anchors, which
also exclude opposite old poles. Thus all old forced signs and cores persist.

The original construction uses `a_s=29/50`, `C_low=2`, `L=5 pi`, and
`C_up=53/25`; (14) verifies its discriminant and crossing length.
For the strengthened construction choose

\[
                a_s=59/100,\quad C_{\rm low}=17/10,\quad C_{\rm up}=171/100.
\tag{17}
\]

Here `a_s C_low-1=3/1000>0` and `a_s<3/5`. By (13) the local coefficient
is exactly

\[
          \kappa_{\rm exact}
          =4973891881959/17975000000000<277/1000.
\tag{18}
\]

The larger shell ratio `exp(2 pi/sqrt(3/1000))` is finite. No uniform or
practical bound on this ratio, or on the final shell scale, is needed.

## 6. The compactness actually needed

We include this argument because a local coefficient calculation does not
justify a nonadditive global form bound.

On an enlarged compact window the weights are uniformly comparable to one.
A fixed smooth isometric embedding of the fixed compact ambient geometry
adds only a bounded embedding mean curvature to that of the walls.
Simon's submanifold inequality therefore has uniform local constants.
Applied to powers of tests, it bounds the wall in its usual exponent and
the full cylinder in

\[
               q=2m/(m-2)>2.
\]

Reflect a half-cylinder test evenly at height zero. Put
`beta=2(m-1)/(m-2)`, so `2(beta-1)=q` and `beta=(q+2)/2`.
The fundamental theorem of calculus after a height cutoff gives

\[
 \int_S|v(0)|^\beta
 \le C\int_{S\times[0,L]}(|v|^\beta+|v|^{\beta-1}|\partial_t v|)
 \le C
\tag{19}
\]

for `h(v)<=1`. This uses no zero trace.

The zero extension of `|v_bulk|^beta` has distributional variation equal
to its interior gradient variation plus the regular seam jump (19).
There is no singular jump for a defining test. Mollification and the
ambient L1 Sobolev inequality give, writing `J=integral_Omega |v|^q`,

\[
              J^{(m-1)/m}\le C(1+J^{1/2}).
\tag{20}
\]

Here `beta m/(m-1)=q`; the lower-order integral is bounded by
`J^(1/2)||v||_2`. Since `(m-1)/m>1/2`, J is bounded. This is a BV
calculation, not an assumed uniform H1 extension operator for the bulk.
Density extends these bounds to the form completion.

For a moving window, let F be the compact portion of the limiting singular
set in a larger window. Its ambient and perimeter measures vanish.
Weak perimeter measure convergence and the closed-set upper bound show
that the limsup measures of a fixed closed delta-neighborhood of F tend
to zero as delta tends to zero. Cylinder measures multiply by the fixed
interval length. The uniform local `L^p`, `p>2`, estimates imply
`integral_A |v_i|^2 <= C mu_i(A)^(1-2/p)`. Thus no L2 mass survives there.
The order of limits is first the sequence index, then the neighborhood size.

Off F, regular graphical charts and ordinary H1 compactness give weak H1
and strong L2 limits. One can obtain the latter directly from the translation
estimate `||v(.+z)-v||_2 <= |z| ||grad v||_2` on slightly enlarged charts
and finite cell averages. The regular-chart trace maps are bounded by the
one-dimensional integral estimate, so weak limits preserve equality of the
two traces. Combining with the preceding no-concentration result proves
strong L2 convergence, also against fixed bounded continuous potentials.
Exhaustion gives lower semicontinuity of the gradient energy.

The limiting function really belongs to the defining completion. On the
one fixed limit geometry, local area upper bounds and
`dim_H Sigma<=m-8` give finite ball covers of a compact singular portion
with `sum r_i^(m-3)` arbitrarily small. The maximum of ball cutoffs costs
at most this sum on the wall and bounded cylinders, and at most
`C sum r_i^(m-2)` in bulk. Use the same base cutoff on both seam sides.
First truncate the limit function, then remove these neighborhoods.
The cutoff energy tends to zero, while absolute continuity handles its
already finite gradient integrals. Matching H1 pieces away from the singular
set glue across a regular seam and can be mollified to defining tests.

This proves `C_SHIELD_COMPACT`, including membership and the energy liminf.
For extra Euclidean factors, ambient and singular dimensions both increase
by the number of factors; the capacity exponent gap stays five. A translated
height interval is a pure-cylinder window. No global moving-space
identification or uniform principal-curvature bound has been used.

## 7. Why successive costs take a maximum

Suppose `integral Vv^2 <= theta h(v)` on all three pieces and
`integral A_epsilon v^2 <= kappa N(v)+C_F||v||_2^2`, with base supports
shrinking to a compact singular piece. V is bounded on the relevant compact
base windows.

For every fixed form-space vector, its A-form tends to zero. This holds
first for defining tests, eventually disjoint from the support, and then
by density and the uniform form bound. Cauchy--Schwarz controls the mixed
term of this nonnegative form.

A matching sine/cosine partition with a sufficiently wide base transition
has arbitrarily small IMS error relative to h, because `e0>0`. Its exterior
part misses A and has the old bound. Partition the interior further into
long, fixed cylinder intervals, the first constant one near the seam and
on bulk, and all others zero there. These additional errors are likewise
arbitrarily small. A quotient exceeding
`max(theta,kappa)+eta` then selects a compact-base, bounded-height
localized quotient exceeding `max(theta,kappa)+eta/2`. If its height escapes,
translate to a fixed pure-cylinder interval; neither potential nor weight
depends on height.

Normalize such a putative violating sequence by `h(v_i)=1`. Section 6 and
weak Hilbert compactness give a fixed-space weak limit v and strong L2
convergence. For `w_i=v_i-v`,

\[
 h(w_i)=1-h(v)+o(1),\qquad \|w_i\|_2\longrightarrow0.
\]

The old potential converges strongly and the new form and its mixed term
vanish on v. Therefore

\[
 \limsup\int(V+A_i)v_i^2
 \le\theta h(v)+\kappa(1-h(v))\le\max(\theta,\kappa).
\tag{21}
\]

This contradicts selection. The same small scale works for the three
pieces, which are a finite list. This proves `C_SHIELD_MAX`. In particular
it does not assert that the sum of an arbitrary preassigned collection
of individually cheap shells has this bound: successive scale choice is
essential.

## 8. Coface extension with no unbudgeted cap energy

Hold one chosen compact source shell D on a face B fixed. Suppose its new
source bound is beta, at least the old common bound. In each directed
coface occurrence choose `0<=D_E<=D o pi_B`, supported over a fixed compact
base K and beyond late fronts in **all** its normal coordinates.

Localize with wide matching squared cutoffs separating this support from
the old-only region, then into large fixed boxes in the normal coordinates
and fixed cylinder-height intervals. Choose all widths using the desired
error and `e0` before moving any front. A violating localized box must meet
the new support; thus every normal center tends to infinity as the fronts
do. Recenter these coordinates. If cylinder height also escapes, translate
to a pure cylinder.

The ambient windows are exact products. Old potentials are exactly the
face pullbacks once fronts exceed their fixed thresholds. The true-cut
convergence in hypothesis 3 and Section 6 give a strong L2 limit v with
`h_lim(v)<=1` and

\[
 \limsup\int(V_E+(29/25)D_E)v_E^2
       \le\int(V_B+(29/25)D)\circ\pi_B\,v^2\le\beta .
\tag{22}
\]

The last inequality is the source form bound sliced in the extra Euclidean
coordinates. The extra derivative terms are nonnegative; all three energy
coefficients are unchanged. Approximation in the limit completion justifies
slicing beyond defining tests. For a pure cylinder, first use translation
of a face cylinder test into its joined space. Formula (22) contradicts
any quotient at least `beta+eta/2`. Finite directed incidence makes the
same late-front choice work for all affected occurrences.

Here is the compatible profile construction, which must accompany this
potential argument. For a plus source u choose one cap w for each normal
coordinate, inactive at `-infinity` before a late front, crossing to
`+infinity`, then constant. Solve
`2w'=.58w^2+p_j^*` on the crossing. The positive floor makes its crossing
length finite. Let chi rise smoothly from zero to one and **finish before**
this crossing begins. Set

\[
              u_E=\min(u,w_1,\ldots,w_d),\qquad
                     D_E=D\prod_i\chi_i .
\tag{23}
\]

Use `-infinity` outside the occurrence and take the maximum with the old
profile. If u is the active finite branch, all chi factors are already
one, so its full D is available. If a cap is active, its gradient is paid
by the old positive potential floor and `.58<a_r`. There is no sum of
normal cap derivatives. Finite minima and maxima have the active derivative
almost everywhere, including almost every tie point. Negating the construction
and taking a minimum gives a minus update.

The source window includes the entire inner pole region as well as the
annular potential support. Extend its strict anchor to the coface product.
Enlarge the plus core only by
`{delta_B<epsilon/2} times product (T_i^++b_i,infinity)`, where `b_i>0`
and `T_i^+` is the end of the cap crossing. Properness of closed tails
places its closure inside
`{delta_B<epsilon} times product (T_i^+,infinity)`, where every branch is
`+infinity`. Thus closure confinement also holds at cap fronts.

Use identical caps, cutoffs and front choices for the same individually
labelled normal coordinate on all commuting chains. On hitting that face
the corresponding cap is eventually `+infinity` and its chi is one,
so that factor disappears from (23). An unrelated sufficiently far face
cannot meet the compact source window in its base; raise the finitely many
intersection thresholds to ensure this. No alternating face/coface closure
is performed. These observations prove exact compatibility, no double
counting of an occurrence, and preservation of old opposite poles.
Together with (22) they prove `C_SHIELD_EXT`.

## 9. Compact residual guard and genuinely finite stopping

Work from deepest faces upward. Suppose the strict further faces of E
are already shielded and their updates extended. The residual set
`K=Sigma_E intersect H_E^*` is closed. If it escaped every compact set,
the packet escape property would give a subsequence over a deeper face B,
with convergent compact base coordinates and all escaping normals tending
to infinity. Exact product cores and finitely many labels permit fixing a
subset of `m-2` undecided labels. Their closed memberships pass to the base
limit, which therefore lies in the weaker face guard, whose threshold is
`dim B-2 <= m-2`.

Support convergence puts that point on the face boundary. If it were regular,
smooth single-sheeted graphical convergence in a neighborhood would exclude
the approaching singular points. It is therefore singular, contradicting
completed shielding of B. Hence K is compact. In dimensions below eight
there are no singular points.

Cover each strict-anchor portion of this initial compact K by the countably
many compact pieces from Section 2, and enumerate signed pieces. Choose a
positive shell scale successively by Section 7, then its fronts by Section 8.
Every point of a chosen piece belongs to its new open inner core,
**regardless of how small its positive scale is**. For a fixed x in K, each
of its finitely many strict anchors is eventually processed. Only the at
most `m-8` threshold-equality labels can then remain undecided at x, fewer
than `m-2`.

After N additions let O_N be the set with fewer than `m-2` undecided labels.
It is open: its complement is a finite union of finite intersections of
closed guards. The O_N increase and cover K. Compactness gives a finite
subcover and therefore a finite stopping index. This is not a finite-cover
assertion about the original compact pieces and not an infinite sum of
profiles.

Each originating packet has finitely many directed cofaces, and each target
packet finitely many source faces including chains. Thus a fixed target
receives only finitely many additions at a completed depth. Finite depth
gives finite sums, finite branch operations, bounded derivatives and finite
product thresholds on each post-radial packet. Subsequent updates only
shrink guards.

For the radial parent apply the same argument separately in its compact
transition-shell buffers. Supports stay in those buffers. At every finite
step the old sum is bounded and compactly supported, and the compact-window
argument of Section 7 applies. The buffers are locally finite, so a compact
test sees only finitely many additions; the final form bound follows by
the exact local integral equality. No original-end convergence is used.
This proves `C_SHIELD_FINITE`.

## 10. Simultaneous, number-independent budgets

Enumerate the countable pairs (originating packet, possible local addition
number) by distinct positive integers nu. Start the common bookkeeping
coefficient at kappa, although the initial potential is zero. Reserve
`gamma_nu=delta 2^(-nu)` for each pair, half for the small-scale maximum
step and half for its simultaneous coface extensions. Since the old common
bound is always at least kappa, Section 7 increases it by at most the first
half, and Section 8 by the second. For every finite subcollection,

\[
                 \theta_{\rm used}\le
                  \kappa+\sum_{\nu\ {\rm used}}\gamma_\nu
                       \le\kappa+\delta .
\tag{24}
\]

Local finiteness passes this inequality through a whole depth. Finite
incidence and depth, not a globally finite number of packets, are the reason
there is no infinite-profile issue.

For the literal manuscript construction take `kappa=.78`, `delta=.1`.
Equations (13), (21)--(24) prove its common `.88` bound and hence its stated
bound strictly below `.9`. Every other conclusion follows from Sections
2, 5, 8 and 9. This establishes `C_SHIELD_GLOBAL` from the exact listed
geometric inputs, rather than from a numerical coefficient check alone.

For (17) take `kappa=277/1000`, `delta=3/1000`. This gives the full conclusion
with `7/25`, proving the explicit strengthened assertion `C_SHIELD_028`.

Finally let `a_s` increase strictly to `3/5`, let
`C_low>1/a_s` and `C_up>C_low` decrease to `5/3`, and let the strict Hardy,
localization and distance-comparison errors tend to zero in their proper
order. The limiting local quotient is

\[
           \frac{(29/25)(5/3)}{36/5}=\frac{29}{108}.
\tag{25}
\]

For any theta strictly above this number, continuity permits **fixed,
noncritical** choices with local coefficient kappa strictly below theta.
Allocate a positive summable total less than `theta-kappa` in (24).
The shell crossing length is finite for every such choice. Thus (T) follows.
The endpoint itself is not proved.

## 11. Sources, novelty limits, and executable evidence

The inherited wiki index has no shielding, Hardy, inverse-square,
scalar-curvature or Urysohn-width result usable here. A bounded independent
literature retrieval read Simon's primary notes and three nearby Hardy
statements. It found no inspected theorem with all of the present glued
matching-trace, frozen-cylinder-potential and vertical-compensation features.
This is **not** evidence of verified novelty.

The primary analytic sources actually used are:

- Leon Simon, *Introduction to Geometric Measure Theory*, Tsinghua draft
  updated 3 December 2014, Chapter 4 Section 5 Theorem 5.7, printed p. 98,
  PDF p. 53, and Remark 5.9, printed p. 100, PDF p. 54.
  `literature/simon-2014.pdf` and `literature/simon-sobolev.txt`.
  The theorem assumes a rectifiable varifold of density at least one,
  generalized mean curvature, and nonnegative compactly supported C1 tests.
  It does not require integer multiplicity or a bound on principal
  curvatures. Its constant is independent of codimension. Here mean
  curvature is locally bounded, more than the theorem needs.
- John Nash, *The Imbedding Problem for Riemannian Manifolds*,
  Annals of Mathematics 63 (1956), 20--63, DOI `10.2307/1969989`,
  compact embedding Theorem 2, printed p. 59 (PDF p. 41), with introductory
  description on printed p. 21 (PDF p. 3). `literature/nash-1956.pdf` and
  `literature/nash-locator-41.png`. Only a fixed compact smooth ambient
  extension is embedded; no sequence of unrelated embeddings with asserted
  uniform constants is used.

The exact scalar polynomials in (11) were sent through the inspected Argus
Jacobian operation `polynomial.box.enclosure.compute`, server `0.14.0`,
protocol `2025-11-25`. Its complete payload, typed output and process status
are in the dedicated `jacobian_*.json` files. The enclosure is over the
whole real box `0<=e<=1/10000`, `0<=t<=1`, for

\[
            t[B(e)-719/100]+(1-t)[C(e)-719/100].
\]

The returned strictly positive lower endpoint is `49801/6800000`.
`verify.py` independently replays this interval computation and its binding
to the retained polynomial and box. This bounded scalar operation is not
being presented as proof of the geometric theorem.

Run `python3 research/shielding_audit/verify.py`. It checks exact universal
polynomial identities for the two-pole ODE and its radial derivative,
the vector-field potential and seam compensation, the full continuous
error box, the original and improved local coefficients, all-dimensional
Sobolev and capacity exponent identities, the convex-energy maximum, and
the count and summable-budget identities. It checks the quoted source
constants and compares the recomputed result with `exact_certificate.json`.
No numerical sampling, network request, or running Jacobian server is needed
for replay. SymPy is the only nonstandard Python dependency and is listed in
`requirements.txt`. The certificate also checks that the real Lean compiler
result is successful, zero-hole, and current for both source and statement
fidelity. It expressly distinguishes these exact checks and the narrow Lean
claim from the analytic proof and the imported geometric hypotheses.

The actual Lean 4.31.0 compilation has succeeded with exit code zero and
`proof_holes=[]`. Only `C_SHIELD_CORE` has derived status `closed_kernel`;
its archived certificate is
`certificates/C_SHIELD_CORE-1d8a322542315104.json`. No geometric claim inherits
that status. Source and fidelity were not edited during compilation.

The official citation status still reports the Nash assumption as `unchecked`
and the author-hosted Simon notes as `uncited`. Both primary statements were
read and are archived above. No independent attribution has been fabricated.
`citation_check`'s default `research/literature/` archival destination is outside
this mission's writable paths, so the Engineer has not invoked an attribution
that would write there. This ownership constraint and the independent source
reading remain explicit review work; it is not permission to write outside
the boundary.

Independent review of the analytic proof, statement fidelity, citations,
significance and novelty is still required. The campaign is not complete.
