# A scale-invariant alignment exclusion for backward half-space profiles

## Theorem

This theorem, its boundary-pressure input, and the critical-tail comparison
were accepted in the preceding independent reviews. Section 5 now submits
their precise contribution relative to the closest primary results.
Independent novelty and publishable-significance certification remain open;
novelty is not marked `verified_new`.

Let `nu>0`, `a>0`. Suppose `U,P` solve the **backward** Leray system

    -nu Delta U + a(U+y dot grad U) + (U dot grad)U + grad P = 0,
    div U=0,  U|_(y_3=0)=0

in the three-dimensional half-space. Assume `U` is smooth up to the wall and

    |grad^j U(y)| <= C_j (1+|y|)^(-1-j),  j=0,1,2.                (H1)

Let `Pi_H` be the unweighted Helmholtz projection and require the canonical
pressure condition

    grad P = nu(I-Pi_H)Delta U - (I-Pi_H)((U dot grad)U).          (H2)

Thus an additional pressure-driven harmonic/affine component is not allowed.
Only pressure gradients are normalized; an additive constant is irrelevant.

Put `Omega=curl U` and `beta=999/1000`. Every nonzero such profile satisfies

    || |y|^(1/2) (U cross Omega) ||_2
    --------------------------------  >= nu sqrt(2/3)(1-sqrt(beta))
       || |y|^(1/2) Delta U ||_2
                                      > nu/2500.                (1)

In particular,

    || |y|^(1/2) (U cross Omega) ||_2
       <= (nu/2500) || |y|^(1/2) Delta U ||_2                    (2)

implies `U=0`. The ratio is scale invariant under `U_lambda(y)=lambda U(lambda y)`;
both norms scale by `lambda`. The associated similarity coefficient changes
to `lambda^2 a`, and the assertion is independent of its positive value.

This is an alignment/depletion condition, not an unconditional exclusion of
all backward profiles. No actual nonzero profile is constructed.

## 1. A weighted Helmholtz bound with an explicit constant

For the half-space Helmholtz projection one has

    ||r^(1/2) Pi_H F||_2 <= sqrt(3/2) ||r^(1/2) F||_2.            (3)

Here it is enough to prove the assertion for `F in L^2 intersect L^2(r dy)`.
For clarity, the following gives a direct proof, not an unspecified weighted
Calderon--Zygmund constant.

First work in the whole space and transform `r^2 F` in `s=log r`.
In a spherical harmonic of eigenvalue `lambda=l(l+1)>0`, the gradient
projection has a two-dimensional radial/gradient-tangential block. Its column
and row, before the scalar denominator, are

    c=(-1+i k, sqrt(lambda)),
    b=(i k, -sqrt(lambda)),
    b c=-(k^2+lambda+i k).

This is the rank-one idempotent `Q=c b/(b c)`. Its squared operator norm is

    ||Q||^2 =
      (k^2+lambda)(k^2+lambda+1)
      ---------------------------------
           (k^2+lambda)^2+k^2
    = 1 + lambda/[(k^2+lambda)^2+k^2] <= 3/2.                    (4)

The last step uses `lambda>=2`; equivalently its cleared numerator is
`K^2+(2lambda+1)K+lambda(lambda-2)>=0`, `K=k^2`.
The complementary rank-one block `I-Q` has the same norm: its squared
Frobenius norm is `2-2 Re tr Q+||Q||^2=||Q||^2`.
Solenoidal tangential harmonics contribute the identity. For `l=0`, the
radial gradient block is the identity for almost every `k`, and its complement
is zero. Plancherel proves the full-space bound.

Extend `F_parallel` evenly and `F_3` oddly across the wall. The full-space
projection respects this reflection, and its restriction is `Pi_H`:
the gradient part solves the half-space Neumann Helmholtz problem. This can
first be checked for smooth data and then by unweighted `L^2` uniqueness.
Both weighted squared norms double under extension, proving (3).
Simultaneous approximation in unweighted and weighted `L^2` justifies the
extension to the stated class.

## 2. Boundary pressure and the nonlinear term

By (H1), `Delta U` and `F=(U dot grad)U` belong to both unweighted and
`r`-weighted `L^2`. The approximation in section 6 of
`radial-pressure-upper-bound.md` proves

    ||r^(1/2)(I-Pi_H)Delta U||_2
      <= sqrt(beta) ||r^(1/2)Delta U||_2.                         (5)

Using (H2), the profile equation is exactly

    -nu Delta U + nu grad p_S[U] + Pi_H F + a W = 0,
    W=U+y dot grad U.                                            (6)

In particular (3), (5), and (6) show `r^(1/2)W in L^2`; this is a
consequence, not a secretly imposed decay condition on the drift.

The full nonlinear pressure is retained in `Pi_H F`. Since

    F=grad(|U|^2/2)-U cross Omega,

and the displayed scalar gradient is in unweighted `L^2`,

    Pi_H F=-Pi_H(U cross Omega).

Thus (3) bounds the projected nonlinear term by
`sqrt(3/2)||r^(1/2)(U cross Omega)||_2`.

The wall term has not been declared zero: its linear pressure contribution is
exactly `grad p_S[U]`, controlled by (5), and its nonlinear pressure contribution
is part of `Pi_H F`. This is a weighted velocity/enstrophy test, rather than a
vorticity integration by parts that would need a separate uncontrolled wall
trace.

## 3. The critical drift, Hardy contribution, and infinity

The critical drift pairing has a favorable sign:

    I = integral_H r W dot Delta U <= 0.                         (7)

A naive subtraction of `integral r|partial_r U|^2` and
`integral |U|^2/r` would be invalid under (H1): both can diverge
logarithmically. The following retains the critical radial and angular terms.

Set `Z(s,omega)=r U(r omega)`. Direct differentiation gives

    W=r^(-1) Z_s,
    Delta U=r^(-3)(Z_ss-Z_s+Delta_S Z).

Consequently, on a finite logarithmic shell `[s0,S]`,

    integral r W dot Delta U
      = [ (||Z_s||_S+^2-||grad_S Z||_S+^2)/2 ]_(s0)^S
        - integral_(s0)^S ||Z_s||_S+^2 ds.                       (8)

In the angular integration by parts the equatorial term is zero because
`Z=Z_s=0` on the wall; no condition on its normal derivative is assumed.
Equation (8) displays the outer angular term rather than discarding it.

Near the origin the smooth zero trace gives `U=O(r)`, so `Z,Z_s,grad_S Z`
are `O(r^2)` and the inner boundary term tends to zero.
At infinity,

    integral_(s>0) ||Z_s||^2 ds
      <= integral_(s>0) exp(2s)||Z_s||^2 ds
       = integral_(r>1) r |W|^2 dy < infinity.

Choose a sequence `S_j -> infinity` with `||Z_s(S_j)||^2 -> 0`.
The angular term in (8) is nonpositive. Meanwhile `I` is absolutely
convergent by weighted Cauchy--Schwarz, since `W` and `Delta U` have the
required weighted norms. Passing along this sequence proves (7).
No angular limit at infinity, vanishing asymptotic profile, or finite
unweighted kinetic energy has been assumed.

## 4. The quantitative exclusion

Pair (6) with `r Delta U`. Equations (5) and (7) give

    nu(1-sqrt(beta)) ||r^(1/2)Delta U||_2^2
      <= sqrt(3/2) ||r^(1/2)(U cross Omega)||_2
                    ||r^(1/2)Delta U||_2.

If `Delta U=0`, (H1), the wall trace and the scalar maximum principle on
expanding half-balls give `U=0`. Otherwise division proves the first
inequality in (1). Finally,

    1-sqrt(999/1000) > 1/2000,  sqrt(2/3)>4/5,

so the right side is strictly larger than `nu/2500`. This proves (2).
The radical comparison, the critical radial identity in (8), and the
velocity--vorticity identity are included in
`certify_pressure_constants.py`.

## 5. Original pressure theorem, boundary corollary, and prior exclusions

The principal original-result submission is the fixed-norm pressure theorem
(5), not the assertion that geometric depletion can prevent singularity.
Section 7 of `radial-pressure-upper-bound.md` compares it directly with
Liu--Liu--Pego, Cozzi--Pego, Alhomsi--Wu--Zheng, and
Iyer--Pego--Zarnescu. In particular, the known unrestricted planar
half-plane coefficient at the same radial weight exceeds `15/8`; the
three-dimensional solenoidal pressure constraint is substantive.
The mathematical application here combines that strict gap with (7).
It does not delete the boundary pressure or the angular term at infinity.

### 5.1. The directly applicable strong-L3 theorem

The directly applicable comparison is Seregin's half-space endpoint theorem,
arXiv:math/0410056v1, Theorem 1.1, p.2, together with the mixed-norm definition
on p.3. Its `L_(3,infinity)` means a uniform-in-time **strong spatial L3**
norm, not spatial weak L3. Bradshaw--Tsai, arXiv:1610.05680v1, Appendix 5,
p.22, explicitly states the resulting backward half-space exclusion and
distinguishes it from the critical pointwise bound `C/(1+r)`.

The exact construction and primary-source comparison are in
`critical-tail-comparison.md`. In particular,

    S(y)=y_3(-y_2,y_1,0)/(1+|y|^2)^(3/2)

is smooth, solenoidal, zero-trace and has a nonzero `1/r` tail. For
`0<epsilon<=nu/200`, the field `epsilon S` satisfies H1 and (2), yet

    integral_(B_R^+) |epsilon S|^3
      = (4pi epsilon^3/35) log R + O(1).

Thus the new alignment hypothesis does not imply strong L3 or Seregin's
local mixed endpoint after similarity rescaling. Furthermore, adding
`-curl(y_3^2 exp(-|y|^2) B_k)`, where
`B_k=(cos(k y_3),sin(k y_3),0)`, gives non-L3 comparison fields satisfying
(2) with arbitrary positive tail amplitude and arbitrarily large weak-L3
norm. The explicit sufficient frequency and all interaction bounds are
proved and exactly certified in that companion note.

These are **kinematic comparison fields, not profile solutions**.
Canonical pressure can be assigned by H2 without imposing the profile
equation. The result is a different sufficient exclusion condition applicable
to critical-tail hypotheses not contained in the strong-L3 or small-critical-
norm hypotheses; it is not a replacement of Seregin's theorem on its entire
solution class.

The independent Round 2 review accepted this non-L3 separation and its exact
certificates. It is reused here, not re-proved or treated as sufficient by
itself to establish publication-level significance.

### 5.2. Boundary vorticity coherence is a different geometric hypothesis

Barker--Prange,
[arXiv:1906.08225v1](https://arxiv.org/pdf/1906.08225v1), Theorem 4, p.30,
(133)--(134), is a genuine three-dimensional no-slip boundary regularity
criterion. Its suitable weak solution class is Definition 6, (38)--(41):
the local energy spaces and inequality, distributional equations, wall
trace, and `p in L^(3/2)`. It assumes the Type-I bound

    sup_(-1<t<0) sqrt(-t) ||u(.,t)||_(L_infinity(B_1^+)) < infinity

and one time-independent modulus `eta`, continuous with `eta(0)=0`, such
that the vorticity direction `xi=omega/|omega|` satisfies

    |xi(x,t)-xi(z,t)| <= eta(|x-z|)

for pairs in the high-vorticity set `d<|omega|<infinity`. The condition is
required up to the boundary. The conclusion is boundedness on the smaller
half-cylinder, so it excludes backward profiles **when these hypotheses
hold**.

H1 supplies the Type-I velocity bound for our ansatz, but the two geometric
conditions measure different quantities. Their condition compares vorticity
directions at different points. Our condition controls the integrated
pointwise cross product of velocity and vorticity relative to a weighted
second-derivative norm. Neither its formulation nor our proof imposes their
time-independent directional modulus.

The distinction is especially concrete for a backward self-similar field.
For any fixed profile points `y,z` with nonzero vorticity, take physical
points `x=sqrt(2a(-t))y` and `x'=sqrt(2a(-t))z`. Both eventually lie in
the half-ball, both vorticities exceed `d`, and the modulus condition would
give

    |Omega(y)/|Omega(y)|-Omega(z)/|Omega(z)||
      <= eta(sqrt(2a(-t))|y-z|) -> 0.

Thus that condition requires a common vorticity direction on the profile's
nonzero-vorticity set. Our proof does not derive this property from the
Lamb-vector norm. Applying their theorem to our full class would therefore
require an additional implication, not just H1 or the word "alignment".
We do not claim a strict ordering of the two solution classes or a
counterexample to their regularity theorem.

Their Proposition 4 also imposes mildness, suitable-solution and global
scaled-energy/pressure bounds, and vanishing of two vorticity components
on a prescribed region at one time. It is not a theorem that every
Type-I ancient half-space solution vanishes. No equivalence between their
pressure class and H2 is assumed.

### 5.3. Whole-space and ancient-solution results do not remove the wall

The remaining potentially misleading comparisons have the following exact
scope; the source locators and retained primary texts are listed in
`literature/boundary-pressure-sources.md`.

| Source | Actual conclusion and hypotheses relevant here | Limit of its implication |
|---|---|---|
| Tsai, Theorems 1--2, ARMA 143 (1998) | Whole-space backward profiles in `L^q`, `3<q<=infinity`, and a full-ball local-energy exclusion | H1 gives whole-space `L^q`, `q>3`, if the domain were all of space; it does not supply an extension solving the equations across the no-slip wall |
| Pineau--Vicol, arXiv:2607.09619v1, Theorem 1.4 | Whole-space rotated backward profiles with `C/(|x|+sqrt(-t))` decay vanish for the stated small/large rotation ranges, including zero rotation | At zero rotation the whole-space exclusion needs no Lamb-vector smallness; it is not a half-space theorem |
| Giga--Hsu--Maekawa, arXiv:1310.6471v1, Theorem 1.1 | Two-dimensional half-plane ancient solutions vanish under (C1)--(C4): uniform classical regularity, specified nonlinear/harmonic pressure, Type-I bound, and nonnegative scalar vorticity | Neither the dimension nor the one-sign scalar-vorticity hypothesis is supplied here; this is not unrestricted three-dimensional ancient vanishing |
| Barker--Seregin, arXiv:1503.07428v1, Theorem 1.4 | Characterization of bounded mild ancient solutions by equations and an admissible pressure decomposition | Pressure admissibility, not a vanishing theorem; global bounded ancient solutions are also not the same class as profiles singular at the terminal time |
| Seregin, arXiv:1901.08842v1, Theorems 1.4 and 1.7 | Connections between boundary Type-I singularities and nontrivial ancient solutions with the specified scaled bounds and pressure class | These are connection/existence implications, not exclusions |

In particular, Pineau--Vicol's Proposition 5.1, under its smooth
divergence-free whole-space hypotheses and pointwise bounds (1.9) and (2.1),
constructs a positive adjoint weight comparable to
`exp(-(1+/-epsilon)|y|^2/4)`. Its weighted
Bernoulli/vorticity identity is a whole-space Gaussian-weighted argument,
not an `r`-weighted Lamb-vector/Stokes-pressure estimate. Their whole-space
pressure is recovered as `R_i R_j(U_i U_j)` up to a constant in the proof
of Lemma 2.1. That recovery does not supply our boundary harmonic Stokes
pressure. The assertion numbered 1.1 in the inspected version is a
conjecture; no purported "Theorem 1.1" Lamb-vector criterion from a search
summary is used.

### 5.4. What the submission advances

The advance over the accepted previous round is now a source-specific
original-result case, rather than just noncontainment in strong L3.
The pressure theorem gives uniform strict domination in the prescribed
three-dimensional radial norm using the no-slip solenoidal moment. The
corollary turns this into a positive, viscosity-proportional lower bound
on the weighted Lamb-vector ratio for any hypothetical nonzero H1/H2
backward half-space profile. Strong spatial L3, small weak-L3 norm,
vanishing critical tail, and uniform spatial coherence of vorticity
direction are not assumptions of this theorem.

The pressure theorem is the primary claimed original contribution; this
boundary exclusion is its substantive Navier--Stokes application, not a
second claim to have originated geometric regularity criteria. Its
significance is the nonzero quantitative obstruction in a critical-tail,
no-slip setting where the listed sufficient hypotheses do not supply this
argument. The threshold `nu/2500` is explicit, not optimized.

The preserved H1 derivative decay and H2 canonical pressure are real
restrictions. No equivalence with every suitable or mild solution class is
asserted, and no existing regularity theorem is contradicted. No
Millennium problem or unrestricted half-space Liouville theorem is claimed
solved. Only the Host-invoked Reviewer may certify that the complete result,
not the source-search outcome or the comparison fields alone, is genuinely
new and publishable.
