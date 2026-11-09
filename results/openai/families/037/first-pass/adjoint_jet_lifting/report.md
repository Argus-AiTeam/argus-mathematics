# Exact adjoint Taylor lifting: scope and verification

## Question and inherited hypotheses

The target is `adj:implication` and `adj:saturation` in the staged
`The-ordinary-double-point-gap-in-every-dimension-September-24-2026`,
Section 05. This report does not verify the companion fourfold theorem or
the main normalized-volume theorem.

Section 04 works on one fixed singular K-polystable Gorenstein affine cone
`C = Spec S` of dimension `n = N+1`, with smooth puncture, zero boundary,
and normalized volume at least `2 N^n`. In the induction, `N >= 4`.
The minimizing Reeb field has discrepancy `n`. Primitive positive integral
gradings approach that ray with error tending to zero in absolute
cocharacter norm; a rational minimizing ray permits a constant exact
grading. The selected subsequence has maximal cyclic stabilizer
`m >= r/N`, and the point selected attains that maximum.

For each such grading, `B = [(C minus vertex)/G_m]` is a smooth effective
proper complex orbifold of dimension `N` with projective coarse space.
The weight-one line bundle `L` is ample, `H^0(B,jL)=S_j`, and `-K_B=rL`.
The chosen residual gerbe has cyclic stabilizer `mu_m`; the fiber
character of `L` is faithful and is numbered `1`. Algebraic equivariant
etale coordinates `z_i` have characters `b_i`. The frame is algebraic,
not an arbitrarily chosen formal frame.

Taylor monomials are ordered by increasing total degree, then increasing
lexicographic exponent vector. In the **original**, unscaled degree,

```
Gamma = {(j,alpha): some nonzero section of jL has initial z^alpha},
Lambda = {(j,alpha) in Z x Z^N: j = sum b_i alpha_i modulo m},
K = closure(cone(Gamma)),                 c = (r,1,...,1).
```

`jet:setup` supplies the full generated group `Lambda`, realization of
every compatible finite jet in sufficiently large admissible degrees,
full dimensionality, the positive degree ray, bounded degree slices,
projection onto the exponent orthant, and the canonical congruence
`r = sum b_i modulo m`. The scaled integration coordinate `Nj/r` is
not the lattice degree.

The exact assertion to verify is

```
q in Lambda and q+c in Int(K)  ==>  q in Gamma.
```

It does **not** assume `c in Int(K)`. Saturation subsequently assumes
that additional condition and asserts rational polyhedrality, primitive
facet height one at `c`, `Gamma = K intersect Lambda`, and
`Int(K) intersect Lambda = c+Gamma`.

The density, minimizing-ray, dimension, and large-stabilizer assumptions
are inherited when applying Section 05 to the volume-gap argument. They
are not needed by the local-to-global lifting proof itself. They cannot
be discarded when proposing a counterexample to the manuscript in its
inherited scope. In particular an arbitrary Fano surface is not an
admissible counterexample to that application.

## Dependencies and prior knowledge

The other manuscript's unrestricted fourfold theorem has boundary zero
and bound `162`, with equality exactly at an ordinary double point.
Its proof runs through stable cone reduction, a stabilizer/discrepancy
bound, Hilbert-series short-weight nonvanishing, a maximal-ideal
log-canonical threshold greater than `3/2`, and a terminal Gorenstein
threefold section giving embedding dimension at most five, followed by
the known local-complete-intersection gap theorem. These remain
unverified inputs here. The higher-dimensional manuscript uses that
base case, cone reduction, small-stabilizer classification or canonical
interiority, adjoint saturation, two filtrations, and a stabilizer
bootstrap. Verification of the adjoint step does not verify those other
steps.

The positive route will use only the following non-elementary geometric
inputs: Howald's monomial multiplier-ideal formula, characteristic-zero
functorial log resolution/principalization, and Kawamata--Viehweg
vanishing for an integral Q-Cartier Weil divisor on a klt pair.
Their exact hypotheses and primary-source locators must be checked
before the proof is delivered. No asymptotic semigroup counting theorem
is a substitute for exact lifting.

A targeted literature search located the usual asymptotic
Newton--Okounkov references, but did not identify a primary-source
theorem proving or disproving this exact, fixed-degree adjoint lifting
statement. The search response's general statements about semigroup
holes are not a counterexample and are not used as a theorem. Novelty
is not established by that search.

## Computation boundary

The installed Jacobian server reported version `0.14.0`, protocol
`2025-11-25`. Inspected operations were `matrix.rank.compute`
(exact supplied rational matrix, at most 64 rows and output rank at most
32) and `polytope.lattice_points.enumerate` (bounded rational polytopes
of dimension at most four, closed rather than strict inequalities).
Neither constructs global section spaces or certifies strict interior
membership in the unbounded, possibly nonpolyhedral cone in dimension
`N+1 >= 5`. This capability mismatch is recorded once here. A supplied
Taylor matrix can nevertheless be checked by the rank operation.
Any such bounded computation is an auxiliary exact check, not a proof
of the universal lifting theorem.

## Primary-source readings

Howald, `arxiv:math/0003232v1`, Main Theorem, states the formula above
for an ordinary monomial ideal on smooth affine space, with rational
positive coefficient. It is not a global section-lifting theorem.
The source was read at
`https://arxiv.org/html/math/0003232v1`.

Fujino's actual cited draft is version 0.00, 9 October 2023
(`fujino.pdf`, title-page footnote). Theorem 3.2.4, printed page 31,
allows a **Q-Cartier integral Weil divisor**, not just a line bundle.
For a projective morphism and an lc pair it requires nefness and
bigness, and additionally bigness on every lc center. A klt pair
has no lc centers, so that last condition is vacuous here.
The downloaded primary source matches the manuscript's version.

Kollar, `arxiv:math/0508332v3`, Theorem 35, printed pages 24--25,
principalizes a nonzero ideal on a smooth characteristic-zero scheme
with a specified SNC boundary by smooth blowups having normal crossings
with that boundary; the algorithm commutes with smooth morphisms.
Theorem 36 gives functorial resolution, and Proposition 9.1 explains
equivariance. Apply Theorem 35 to the product of the base ideal and
the ideal of the already smooth exceptional divisor, with that divisor
as boundary. This makes the required joint SNC condition explicit,
rather than inferring it from separate SNC conditions.
Etale functoriality glues the centers over the
orbifold groupoid. Its restriction to the strict exceptional divisor
is a sequence of smooth blowups, principalizes the restricted ideal,
and is an isomorphism where that ideal is a unit. Thus no stronger
unstated simultaneous-resolution theorem is required.

These are external geometric inputs, not kernel-certified results.
The Engineer has read them; independent attribution of the citations
remains a Reviewer obligation. The raw source text and PDFs here are
reading copies, not new mathematical evidence.

## Theorem A: nef-twisted adjoint lifting

Let `B` be an integral smooth effective proper complex Deligne--Mumford
stack of dimension `N >= 2`, with trivial generic stabilizer and
projective coarse space. Let `L` be an ample orbifold line bundle.
At a chosen residual gerbe assume the stabilizer is cyclic `mu_m`,
the fiber character of `L` is faithful and numbered `1`, and choose
algebraic equivariant etale coordinates `z_i` of characters `b_i`.
Use an algebraic equivariant frame of `L` and the Taylor order fixed
above to form `K(L)`.

Let `M` be any orbifold line bundle and let `t > 0` be rational.
Suppose

```
M - K_B - t L is nef,
alpha in Z_{\ge 0}^N,
sum b_i alpha_i = character(M at the gerbe) modulo m,
(t,alpha+1) in Int K(L).
```

Then a global section of `M` has Taylor initial `z^alpha` in an
equivariant algebraic frame of `M`. Changing such a frame by a unit
does not change that initial exponent.

This removes subcanonicity, Fano positivity, the volume bound, Reeb
minimization, and the large-stabilizer condition from the lifting
statement, and allows an independent nef twist. Its specialization
`M=jL`, `t=j+r`, `-K_B=rL` is the manuscript's exact implication.
The following is a proof, not an inference from numerical examples.
No priority or verified-new claim is made before independent review.

### A1. Finite weights, without a SAGBI assumption

Write `v=alpha+1`. Openness permits a positive rational `t0<t`
with `(t0,v)` interior. A finite list of actual section indices
generates a cone containing this point in its ordinary interior:
surround it by a small simplex, approximate the vertices by finite
positive combinations of indices, and keep the finitely many indices
used. Interior containment survives sufficiently small perturbations.

Choose an integer `D` strictly larger than the total degrees of their
initials and of `alpha`. A positive rational weight vector sufficiently
close to `(1,...,1)` preserves every comparison in total degree through
`D`, and orders lexicographically the finitely many equal-degree
comparisons. For example base-`D+1` successive perturbations give this
lexicographic order; multiply the common weight sufficiently far above
all perturbations. Positivity also puts all monomials of degree greater
than `D` above the selected initials. Clear denominators and divide by
the gcd, obtaining positive primitive integer weights `u_i`.
In particular every Taylor monomial preceding `alpha` has weight
strictly below `p=u.alpha`, and each selected section has just its
specified monomial as weight-initial.

Put `U=u.v=p+sum u_i`. The slice of the finite cone by
`degree=t0` and `weight=U` contains a relative neighborhood of
`(t0,v)`. This is a rational affine plane. Surround `v` by finitely
many rational points in that slice and express them as rational
nonnegative combinations of the section indices. After a common
denominator `a` is cleared, multiplication of actual sections gives
sections of `a t0 L` with single weight-initials `z^{beta_k}`,
where

```
u.beta_k=a U,
v is interior in conv{beta_k/a} relative to {x:u.x=U}.
```

Here `a t0` is an integer. Products of single initials are single
initials. Finite generation of the original Taylor semigroup has
not been assumed.

### A2. A global weighted blowup, retaining all inertia

The local ideals generated by monomials of `u`-weight at least `h`
contain a power of the maximal ideal. Hence their quotients are finite
jets supported at the residual gerbe. Equivariance descends those
quotients; extend the kernels as the unit ideal off the gerbe.
On a larger quotient chart use the entire finite orbit. This constructs
global coherent ideals `I_h` with `I_h I_k` contained in `I_{h+k}`.
The coordinates are algebraic; merely choosing an unrelated formal
coordinate change would not justify this construction.

The weighted Rees algebra `sum I_h q^h` is locally generated by
`z_i q^ell`, `1<=ell<=u_i`, since the requested degree can be
distributed among monomial factors. Its stack Proj has, before the
original cyclic quotient, the presentation

```
[(A^{N+1}_{x_1,...,x_N,T} minus {x_1=...=x_N=0})/G_m],
rho.(x_i,T)=(rho^{u_i}x_i,rho^{-1}T),   z_i=T^{u_i}x_i.
```

The charts `x_i != 0` cover: `(z_i q^ell)^{u_i}` equals
`(z_i q^{u_i})^ell z_i^{u_i-ell}`. On such a chart
`T=(z_i q^{u_i-1})/(z_i q^{u_i})` is regular, also when `u_i=1`.
Thus this is a smooth DM stack `pi:Z->B`, with projective coarse
modification. It is an isomorphism away from the gerbe. The exceptional
divisor `E=(T=0)` is the smooth stack `[P(u)/mu_m]`, possibly with
generic inertia. All that inertia is retained.

Pulling back a local volume form shows that

```
K_Z+E = pi^*K_B + (sum u_i) E.
```

Indeed the exponent of `T` in its Jacobian is `sum u_i-1`.
This is a Cartier identity on the stack, not a coarse-space formula.

Set `P=pi^*M-pE` and `H=pi^*(a t0 L)-a U E`.
The selected sections define a base ideal `b` of `H`, not vanishing
generically on `E`. There is the exact numerical identity

```
P-(K_Z+E)-H/a = pi^*(M-K_B-t0 L).
```

The right side is the pullback of a nef class plus
`(t-t0)L`, hence is nef and big. This strict positive margin, rather
than Howald's theorem, will produce the global lift.

### A3. The monomial on E and its exact characters

The monomial `x^alpha` has weight `p`, and its original cyclic
character is that of `M`, so it is a global section of `P|_E`.
The chart `x_k != 0` has smooth finite uniformizer `x_k=1` with group

```
H_k={(rho,zeta) in G_m x mu_m : rho^{u_k} zeta^{b_k}=1}.
```

This need not be a direct product and its action need not be effective.
If `d` is the fiber character of `M`, the line `P|_E` has character
`rho^p zeta^d`. The character of the remaining-coordinate monomial is

```
prod_{i!=k}(rho^{u_i} zeta^{b_i})^{alpha_i}
 = rho^p zeta^d,
```

by the displayed relation for `H_k` and the assumed congruence.
Thus neither a character nor a fractional power is lost when `x_k`
is set to one.

The ideal `b|_E` on this uniformizer is generated by
`x_rem^{(beta_l)_rem}`. Dropping coordinate `k` from the plane
`u.x=U` is an affine isomorphism, since `u_k>0`. Consequently
`alpha_rem+1` lies in the ordinary interior of the convex hull of
the projected `beta_l/a`, hence in the interior of their scaled
Newton polyhedron. Howald gives

```
x^alpha in H^0(E, P|_E tensor J_E((b|_E)^{1/a})).
```

Multiplier ideals here are computed on the smooth finite uniformizers.
Their definitions are invariant under the finite group, so membership
descends. No assertion about a smooth coarse exceptional divisor is
being used.

### A4. Vanishing on the smooth stack: coarse rounding checked

We prove the needed stack version from the cited Weil-divisor
vanishing theorem. Let `q:Xstack->X` be the coarse map of a smooth
proper effective stack, `Theta` an effective SNC rational boundary
with coefficients below one, and `D` Cartier. Suppose
`D-(K_Xstack+Theta)` is nef and big.

At a coarse prime divisor with inertia order `e`, write the stack
coefficient of `D` as an integer `d`. Its coarse coefficient is
`d/e`, while `K_Xstack=q^*(K_X+R)` with coefficient
`R=(e-1)/e`. Define

```
Delta=R+Theta_c-{D_c}.
```

Writing the fractional part of `d/e` as `k/e`, `0<=k<=e-1`,
and the stack boundary coefficient as `0<=theta<1`, gives
`Delta=(e-1+theta-k)/e`, between zero and one. More importantly,
on every smooth finite quotient chart the log pullback of `Delta`
is `Theta` minus the pullback of `{D_c}`. It is bounded above by
the SNC subunit boundary. Its discrepancies are positive; the
finite ramification formula therefore makes `(X,Delta)` klt.

Normal extension and invariant sections give
`q_* O(D)=O_X(floor D_c)`. This is reflexive: regular sections of
the invertible module on a normal smooth chart extend over
codimension two, and remain invariant. Taking invariants of a finite
complex group is exact by averaging, so the coarse map has no higher
pushforwards on these sheaves. Quotient singularities are locally
Q-factorial, and the integral Weil divisor `floor D_c` is Q-Cartier.
Finally

```
floor D_c-(K_X+Delta)=D_c-(K_X+R+Theta_c).
```

It is the descended nef and big class. Fujino Theorem 3.2.4 applies
to the klt pair, with no lc-center condition left to check, and gives
`H^q(Xstack,O(D))=0` for `q>0`. No flatness of the coarse map is
required.

### A5. Restriction, rounding, and regular pushdown

Principalize `b O_Z(-E)` on `Z` with `E` as boundary, obtaining
`sigma:Y->Z`, strict transform `E'`, and
`b O_Y=O_Y(-G)`. The preceding primary-source discussion gives
a projective smooth-stack model with `E'+Supp G` SNC: the divisor
of the pulled-back product is `G+sigma^*E`, so its SNC support
contains both. It also contains every nontrivial exceptional divisor,
since the principalization is an isomorphism off the cosupport of
the product. The smooth centers with normal crossings to the evolving
boundary keep `E'` smooth. Its restriction principalizes `b|_E`,
with SNC exceptional support. The effective divisor `G`
does not contain `E'`. The bundle `sigma^*H-G` is generated by
the pulled-back finite list of sections and is therefore nef.
Let

```
A=K_Y+sigma^*(P-K_Z-E)-floor(G/a).
```

This is integral and

```
A-(K_Y+{G/a})
 = sigma^*pi^*(M-K_B-t0 L)+(sigma^*H-G)/a.
```

The first summand is nef and big, the second nef. Stack vanishing
therefore gives `H^1(Y,A)=0` and the **global** surjection
`H^0(Y,A+E')->H^0(E',(A+E')|_{E'})`.

Let `tau:E'->E`. Adjunction identifies the target line bundle as

```
tau^*(P|_E) + K_{E'}-tau^*K_E-floor((G|_{E'})/a).
```

Round-down commutes with this restriction. In SNC local coordinates
an irreducible divisor of `E'` belongs to the restriction of at most
one component of `G`; otherwise three boundary components would meet
in codimension two. Disconnected intersections retain the same
coefficient on each component. Also the pulled-back restricted ideal
is exactly `O_{E'}(-G|_{E'})`. Thus the monomial supplied by A3,
using the log-resolution definition of its multiplier ideal, is
a section of this target. It has a global lift on `Y`.

The difference between its lifting bundle and `sigma^*P` is

```
K_Y-sigma^*K_Z-sigma^*E+E'-floor(G/a).
```

The first four terms are effective and exceptional. At a blowup of
a smooth center of codimension `h>=2`, the new coefficient is
`h-1` if the center is not in the current strict boundary, and
`h-2` if it is, plus pullbacks of coefficients already known to be
nonnegative. A codimension-one blowup is an isomorphism and contributes
nothing. This proves effectiveness inductively also on etale charts.
The last term is negative effective, so the rational lift has no
pole at any nonexceptional prime. Normal extension pushes it to
a regular section of `P` on `Z`.

Over the dense open of `E` where `sigma` is an isomorphism its
restriction is the specified monomial; the two regular sections on
the integral stack `E` therefore agree everywhere. Since `p>=0`,
`O(P)` is a subsheaf of `pi^*M`, and
`pi_*O_Z=O_B` by normal extension for this birational modification.
The pushdown is a global section of `M` with no weight below `p`
and weight-`p` part exactly `z^alpha`. Every monomial preceding
`alpha` in the original Taylor order has smaller weight. Its Taylor
initial is therefore precisely `z^alpha`. This proves Theorem A.

### Consequence for adj:implication

In the manuscript set `M=jL`, `t=j+r`. Interiority gives
`alpha_i>=0` and `j+r>0` by the inherited bounded-slice positivity.
The character condition is exactly `(j,alpha) in Lambda`; the nef
class `M-K_B-tL` is zero. Every hypothesis of Theorem A is met.
In particular the proof has supplied the missing logical category
between a local multiplier-ideal calculation and a global section:
an actual global restriction surjection with its nef-and-big margin.
It has not assumed canonical interiority.

## Theorem B: an abstract lattice-strip rigidity theorem

Let `V` be a finite-dimensional real vector space, `Lambda` a full
lattice, `C` a proper full-dimensional closed convex cone, and
`c in Int C intersect Lambda`. Assume

```
(Int C-c) intersect Lambda is contained in C.
```

Then `C` is rational polyhedral and every primitive facet form is
integral on `Lambda` and has value one at `c`. This statement does
not require an exponent orthant, bounded slices, a degree coordinate,
or a jet semigroup.

**Proof.** Choose a nonzero nonnegative support form `ell` of `C`,
normalized by `ell(c)=1`, and put `W=ker ell`. Every line
`x+R c`, `x in W`, meets `C` in a closed upper ray. It meets
the interior for sufficiently large positive parameter since `c`
is interior, and the parameter is bounded below by zero since
`ell` is nonnegative. Thus

```
C={x+s c: x in W, s>=g(x)}
```

for a finite positively homogeneous convex function `g` on **all**
of `W`. In particular `g` is locally Lipschitz.

At a differentiability point `x`, the boundary point
`y=x+g(x)c` has the support form
`eta(x'+s c)=s-Dg(x).x'`, with `eta(c)=1`.
If `eta(Lambda)` is discrete, it is `h Z`. Since `1` is in
this group, `1=k h` for a positive integer `k`. Unless `k=1`,
there is `w in Lambda` with `-1<eta(w)<0`. If the group is
not discrete, it is dense and such `w` again exists.

There are positive integers `k_n` tending to infinity and lattice
points `l_n` with `e_n=l_n-k_n y` tending to zero. To see this,
pigeonhole multiples of `y` in arbitrarily fine partitions of the
compact torus `V/Lambda`. Their differences give arbitrarily small
returns. If the return times remain bounded, one is an exact period,
whose positive multiples supply unbounded return times.

Then `eta(l_n+w)` tends to `eta(w)<0`, so `l_n+w` is outside
`C`. But `eta(w+c)>0`. Differentiability of `g` at `x` gives,
uniformly for bounded perturbations near `w+c`,

```
y+(w+c+e_n)/k_n in Int C
```

for all sufficiently large `n`: its vertical excess is
`eta(w+c+e_n)/k_n+o(1/k_n)>0`.
Homogeneity puts `l_n+w+c` in `Int C`, contradicting the
assumed lattice-strip exclusion. Therefore `eta(Lambda)=Z`.
In particular `eta` is itself primitive integral and `eta(c)=1`.

Choose a Euclidean ball of radius `epsilon>0` about `c` in `C`.
Every nonnegative support form of value one at `c` has norm at
most `1/epsilon`, by evaluating on the ball in the negative normal
direction. Only finitely many elements of the dual lattice have that
bound. Hence the support forms at all differentiability points
belong to one finite list.

These supports recover `g`. Indeed differentiability points are dense;
approach any `x0` by such points `x_n`. Local Lipschitz continuity
bounds their gradients and gives
`g(x_n)+Dg(x_n).(x0-x_n)->g(x0)`. Thus `g` is the maximum of
the finite list of supporting linear functions. This proves rational
polyhedrality. A facet support occurs in an irredundant sublist and
has the asserted primitive height. In dimension one the same argument
uses the unique function on the zero-dimensional space `W`; the
conclusion also follows directly for a ray. This proves Theorem B.

The convex-analysis facts used here need no special regularity
assumption: a finite convex function is locally Lipschitz on its open
domain. Along each coordinate line its left and right derivatives are
monotone and disagree at only countably many points. Fubini implies
that all coordinate derivatives exist almost everywhere. At such a
point the supporting subdifferential has only one possible vector.
Local boundedness of subgradients, followed by the supporting inequality
at nearby points, makes that singleton condition differentiability.
This proves the density used above and explains why no differentiability
of the entire boundary was assumed.

## Exact saturation and the role of Lean

Apply Theorem B to the manuscript's `C=K`. Theorem A implies its
strip exclusion since `Gamma` is contained in `K`. All of the
finitely many primitive support forms `eta_i` have `eta_i(c)=1`.
They include any coordinate facets, without a separate boundary
argument.

For `q in K intersect Lambda`, all `eta_i(q)>=0`, hence all
`eta_i(q+c)>=1`. Thus `q+c` is interior and the lifting implication
gives `q in Gamma`. Conversely membership in `Gamma` already gives
membership in `K intersect Lambda`. For an interior lattice point
`q`, each integer `eta_i(q)` is at least one, so
`eta_i(q-c)>=0`. This gives exactly

```
Gamma=K intersect Lambda,
Int K intersect Lambda=c+Gamma.
```

These implications for an arbitrary finite family of integral additive
forms are formalized in `Main.lean`, declaration `exact_saturation`.
`height_one_surjective` also verifies that a form of value one on `c`
is primitive. The separate `statement_fidelity.md` explains exactly
what is, and is not, encoded. The geometry, topological cone-rigidity
argument, and cited vanishing theorems are **not** Lean formalizations.

Finally a rational polyhedral cone has finite lattice generation:
triangulate by lattice rays; subtract integer parts of the coefficients
in each simplicial cone. The remaining lattice vector lies in a bounded
half-open parallelepiped, so there are finitely many possibilities.
Every resulting remainder belongs to the saturated semigroup.
If `k q` belongs for positive integer `k` and `q in Lambda`,
homogeneity puts `q` in the cone, proving saturation. The generated
group is the inherited `Lambda`. This proves every conclusion of
`adj:saturation`, conditional only on its explicit canonical-interiority
hypothesis and the standard external inputs identified above.

## Exact quadric replay (auxiliary, not the proof)

For `Q^4` with homogeneous equation
`X0 Y=X1^2+X2^2+X3^2+X4^2`, choose `X0=1` and
`z_i=X_i/X0`. The complete degree-one section space has basis
`1,z1,z2,z3,z4,sum z_i^2`. Its actual Taylor matrix through degree
two is submitted to the inspected Jacobian rational-rank operation.
The first quadratic in the prescribed order is `z4^2`; the last
basis section has that single initial. A matrix rank increase at a
row is exactly the criterion that its monomial can be an initial:
the row is not a linear combination of all earlier coefficient rows.

The full section ring is the displayed quadratic hypersurface ring:
the restriction sequence and `H^1(P^5,O(j-2))=0` identify every
nonnegative degree with the homogeneous coordinate quotient.
Division by its monic relation in `X4^2` gives a basis of monomials

```
X0^a0 X1^a1 X2^a2 X3^a3 X4^a4 Y^b,   a4 in {0,1}.
```

In degree `j` their Taylor initials are the pairwise distinct vectors
`(a1,a2,a3,a4+2b)`. Hence, **for every degree**, the exact semigroup
is

```
j >= alpha1+alpha2+alpha3+ceil(alpha4/2),  alpha_i >= 0.
```

There are no unseen linear combinations with later initials, since the
basis initials are distinct. Its real cone has coordinate inequalities
and the primitive inequality `2j-2alpha1-2alpha2-2alpha3-alpha4>=0`.
The canonical vector `(4,1,1,1,1)` has value one on that form.
For `q=(1,0,0,0,2)` the shifted point is the strictly positive
combination with coefficients `(1/2,1,1,1,3/2)` of the five
independent actual section indices for `1,z1,z2,z3,Y`.
Thus strict interiority is certified with actual section indices,
not inferred from an asymptotic body.

The tempting absent initial `(1,0,0,1,1)` has unchanged Taylor-prefix
rank and a shifted facet value **zero**, not positive; it is correctly
rejected rather than reported as a counterexample. The script replays
normal forms through degree four as a finite implementation check.
The all-degree statement is the preceding basis proof. Neither this
example nor the finite replay proves the general geometric theorem.

## Status and comparison with the prior state

The prior state contained only the campaign goal and no verified
mathematical claim. This report gives a complete mathematical proof of
the adjoint implication and its saturation consequence, including two
scope-strengthened formulations. It does not infer a general theorem
from a bounded search. No false manuscript assertion has been established,
and there is consequently no `F_` refutation claim to file.

Independent correctness, source attribution, novelty, significance, and
statement-fidelity review are pending. In particular neither publication
priority nor the full ordinary-double-point volume gap is certified here.

## Reproduction and remaining review obligations

Run, from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/adjoint_jet_lifting/verify.py
```

The replay recomputes the symbolic identities, complete degree-one
Taylor map, exact strict-interior generator decomposition, rejected
boundary index, and degree-zero-through-four normal forms. It checks
the preserved Jacobian request and typed answer and the current Lean
source/fidelity bindings against the archived compiler result and
current claim version. It does not silently rerun remote operations
or a compiler and does not treat the finite replay as the theorem.

The real Lean 4.31.0 run exited zero, with `proof_holes=[]` and axiom
audit exit zero. The only diagnostic was an unused finite-index
typeclass warning, not a proof hole. Its source and fidelity text
have not changed since that run. The durable run receipt is in
`lean_submission.json`; its command also ran both campaign-local
official checks, each with exit zero.

The exact rank operation returned rank six, pivots `0,...,5`, adapter
exit zero and no timeout. The exact payload, raw typed result, and
adapter exit record are separate JSON files. No negative or unknown
tool result has been promoted into a mathematical verdict.

The Reviewer must independently read Theorems A and B, replay the
certificate, inspect the precise scope of the Lean theorem, attribute
the Howald and Kollar citations, and assess novelty and publishability.
The existing citations remain visibly unchecked in the ledger rather
than being self-confirmed by the Engineer. Fujino's versioned author
draft is recorded with its URL and locator in the prose source field,
not with an invented registry identifier.

The scoped writable paths do not include `research/literature/`, where
the citation-attribution module archives excerpts. No attribution
command that would write outside the mission boundary was run.
This is an outstanding Host/Reviewer integration obligation, not
evidence against a cited theorem and not an independent citation check.

After recording the Engineer's support judgments and retiring the
inadmissible boundary route, both official checks passed at
`2026-11-05T14:19:00Z` against the exact project root
`campaigns/9000037`:
`math_state check` exit `0`, `proof_graph_check check` exit `0`.
Graph nodes remain open to independent review rather than being marked
proved by the Engineer. The bounded Engineer milestone is ready for
review; campaign completion is not asserted.
