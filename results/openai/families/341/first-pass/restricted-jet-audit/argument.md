# Restricted exact-pair first-jet transversality

## Result and scope

The universal-surjectivity assertion in `07-pencil.tex`, from
`eq:pencil-coefficient-pair` through `eq:pencil-critical-index`, admits
the conditional proof below. At a simple critical sphere, the annihilator
of the **unaugmented** map-and-first-jet derivative is exactly
two-dimensional: its elements are the two integrated pullback
functionals, with zero component on the jet target. The coefficient
sphere kills precisely these two functionals. No unrestricted variation
of the almost-complex structure is used.

This verifies the restricted mechanism, not the manuscript's main
deformation theorem. In particular, the marked-curve existence,
nonsplitting, prescribed taming-class theorem, nodal insertion, auxiliary
volume equation, and endpoint argument are not established here.
The compactness and curve-theoretic inputs below remain explicit inputs.
The algebra certificate checks identities, not elliptic regularity,
the distribution structure theorem, Banach-manifold arguments, or
Sard--Smale. No independent Reviewer verdict is asserted here.

The pre-existing ledger contained the campaign objective but no
mathematical proof or reviewed result. The improvement here is an
explicit description of the entire restricted cokernel, a proof of
its elimination at every distributional order, and a support-relative
argument, rather than a principal-symbol test alone.

## Primary-source scope

Oh--Zhu, arXiv:0805.3581v3, Sections 2--3, is a reference for the
universal first-jet framework, not for the restricted assertion.
In their notation, the parameter `B` is an infinitesimal variation of
`J` in the space of tame/compatible almost-complex structures; it is
not the fixed two-form called `B` in the manuscript. Equation (2.18)
tests arbitrary such variations. Consequently its off-mark vanishing
argument cannot be copied for exact pair variations.

Section 3, equation (3.3) and Remark 3.2, uses the dual of `W^{1,p}`
to obtain a multiple of the delta distribution. The manuscript works
with a higher-order target, so that conclusion does not follow from
Sobolev order alone. The descending highest-order argument in Step 5
below supplies the additional argument. Thus these are scope warnings,
not refutations of Oh--Zhu or of the manuscript.

The linear index and sphere domain facts used here are the
Riemann--Roch index and the degree-greater-than-minus-two surjectivity
criterion for a line-bundle Cauchy--Riemann operator, as cited in the
manuscript to Wendl, arXiv:1011.1690v2, Theorems 3.22--3.23.
The separable Banach Fredholm Sard theorem is a classical analytic
input, not a conclusion of the algebra computation.

## Conditional theorem

Let `X` be a closed oriented smooth four-manifold, `(A,C,B)` a smooth
positive triple of closed real two-forms, and `J` the sign of the
structure determined by `(A,C)` tamed by `B`. Let `F` be a nonzero
class with

```
<A,F> = <C,F> = 0,       b = <B,F> > 0.
```

For the local surjectivity conclusion, assume that each simple
`J`-holomorphic sphere under consideration has a finite exceptional
set outside which it is an injective immersion. For an allowed closed
forbidden set `K`, assume that every such sphere with a critical point
is disjoint from `K`. All compactly supported smooth ambient
one-forms in `X \ K` must be allowed as infinitesimal primitives.
There is **no** fixed forbidden tubular neighborhood of the curve.

At every simple sphere `u:(S^2,j)->X` with `du(z)=0`, consider

```
S(u,z,v; beta_A,beta_C)
  = (dbar_(j,J_v) u, partial_(j,J_v) u(z)),
A' = A + d beta_A,       C' = C + d beta_C,
A'_v = A' - (v_1/v_3) B, C'_v = C' - (v_2/v_3) B,
v_0 = (0,0,1).
```

Use the structure determined by this last pair with the sign continuous
from `J`. The second target has real dimension four. The derivative
of `S` at `(u,z,v_0;0,0)`, with `j` fixed, is a split surjection
for the permitted primitives. With `v` omitted its annihilator is
exactly the span of the two functionals

```
(e,h) |-> integral L_A(e),       (e,h) |-> integral L_C(e).
```

For the generic immersion conclusion, also assume the following
curve-theoretic hypotheses, uniformly for the small fixed-class
families being considered:

1. Simple spheres of class `F`, including a single marked point, are
   compact modulo reparametrization in the finite differentiability
   orders used below, without bubbling or a change to a multiply
   covered limit.
2. Distinct simple images in `F` are disjoint. A simple sphere with
   the same image as an immersed retained sphere is a
   reparametrization and hence immersed.
3. Each forbidden model subdisk is a compact union of complete
   `F`-curves; its sphere fibers are immersed, and its other fibers
   are embedded tori. This is the ordinary-node model, not an
   arbitrary singular foliation.

Then arbitrarily small smooth exact pair perturbations make all
simple `F`-spheres immersed, with `B` unchanged and positivity
preserved. The conclusion holds for a smooth path relative to
immersed endpoints, preserves any prescribed finite set of immersed
common-Lagrangian `F`-sphere images throughout that path, and allows
the stated endpoint model subdisks to remain fixed.

The analytic background inputs are the usual elliptic regularity
and Fredholm theory for real Cauchy--Riemann operators on closed
surfaces, the point-support structure theorem for distributions,
Sobolev multiplication and composition, and the separable Banach
Fredholm Sard theorem. None is replaced by a finite-dimensional
algebra certificate.

## Proof

### 1. The pullback identities and the two genuine obstructions

Write `j partial_s = partial_t` and identify a Cauchy--Riemann
residual with its value on `partial_s`. Thus

```
e = (u_s + J u_t)/2.
```

If `Q` is `J`-anti-invariant, then `Q(a,Ja)=0`; consequently the
following is an identity for arbitrary `u_s,u_t`, not just for
holomorphic maps:

```
Q(u_s,u_t) = -2 Q(u_s,J e).
```

Differentiating at a holomorphic map gives

```
delta(u* A_v) = L_A(delta dbar u),
L_A(e) = -2 A(u_s,J e) ds wedge dt,
```

and the analogous formula for `C`. Differentiating the parameter
dependence of `Q`, `J`, and `u_s` contributes no further terms,
because each of these terms multiplies the zero residual. In
particular, the identities include simultaneous map, pair, and
coefficient-sphere variations. They use no inverse of `du`;
the maps `L_A,L_C` vanish at a critical point.

Let `P_Q(e)=integral L_Q(e)`. For a map variation `w`,
closedness and Cartan's formula give

```
P_Q(D_u w) = integral d(u* i_w Q) = 0.
```

For an exact background variation with the map fixed the value is
`integral d(u* beta_Q)=0`; the jet variation is zero at a critical
point because it contains `du(z)`. A mark variation contributes
only to the jet. Thus `(P_A,0)` and `(P_C,0)` really annihilate
the unaugmented universal derivative.

They are linearly independent. On any injective immersion disk,
choose complex-linear coordinates in the tangent and normal
lines so that

```
A = Re(dz_1 wedge dz_2), H = Im(dz_1 wedge dz_2),
C = x A + y H,              y != 0,
u_s = (a,b,0,0),            a^2+b^2 > 0.
```

On a residual whose normal component is `(r,s)`, the two pullbacks
are the matrix

```
M = 2 [[b, a], [x b-y a, x a+y b]],
det M = 4 y (a^2+b^2) != 0.
```

Arbitrary compactly supported target residuals on the disk
therefore give independent values of the two integrated
functionals. This is not a claim that arbitrary pullback
two-forms can be produced by an exact perturbation.

### 2. Tangential annihilation with fixed domain structure

Let `(eta,lambda)` annihilate the unaugmented derivative.
Tests `w` supported away from the marked point give
`D_u^* eta=0` there. Elliptic regularity gives at least `C^1`
coefficients away from the mark.

Every infinitesimal domain complex-structure variation on `S^2`
has the form `L_xi j`. Indeed the cokernel of the relevant
Dolbeault operator is `H^{0,1}(TS^2)=0`, since `TS^2` has
degree two. Apply naturality to domain diffeomorphisms acting by
`(u,z) -> (u composed with g, g^{-1}z)`.
At a holomorphic critical marked map the section is zero, so
differentiating naturality expresses the domain-structure test as
a linear combination of the allowed map and mark tests.
The direct domain-structure derivative of the jet is zero since
`du(z)=0`. Hence

```
eta( (1/2) J du dot_j ) = 0
```

for every smooth `dot_j`, including ones supported in an
arbitrarily small disk away from the mark. At an immersion
point, anti-commuting `dot_j` have two real free components,
and their residual values span exactly the complex tangent
line. Thus `eta` vanishes on tangential residuals. The mark
test is important here; fixed `j` alone is not silently being
treated as an extra free parameter.

### 3. Exact tests force the normal coefficients to be constant

The matrix in Step 1 identifies the normal residual with a pair
of two-form values. Therefore, on the injective immersion locus,
there are unique `C^1` functions `f_A,f_C` representing `eta` by

```
eta(e) = integral (f_A L_A(e) + f_C L_C(e))
```

for residuals supported there. Their definition is intrinsic
under oriented coordinate changes on the source.

Let `U` be any relatively compact injective immersion disk not
containing the mark. Its image has an isolated tubular
neighborhood: after making `U` slightly smaller, compactness of
the rest of the source and injectivity give positive separation
from every other sheet. It is also disjoint from `K`. Every
compactly supported one-form `theta` on `U` extends to an ambient
one-form in this neighborhood in tubular coordinates. In finite
regularity use a `C^2` extension and smooth approximations in
`C^1`, with support in the same allowed neighborhood.

Set `w=0` and vary only `beta_A`. The differentiated pullback
identity and the zero background jet derivative give

```
0 = integral_U f_A d theta.
```

The `C^1` approximation is enough to pass this integral to the
limit. Integration by parts gives `df_A=0` on `U`. Varying
`beta_C` independently gives `df_C=0`. The injective immersion
locus is the complement of a finite set in `S^2`, so it is
connected. Thus there are single constants `k_A,k_C`, not
different constants on different branches.

### 4. Subtract the periods before analyzing the marked point

Define on the whole source

```
eta_0 = k_A P_A + k_C P_C.
```

Its coefficients extend continuously across every critical point
because `L_A,L_C` contain `du`, not `du^{-1}`.
Both `eta` and `eta_0` have continuous coefficients away from
the mark; they agree on the dense injective immersion locus.
They therefore agree away from the mark, including at the
other critical points and at all preimages of double points.
This rules out unexamined point distributions at those points.

For every smooth map variation, Cartan's formula gives
`eta_0(D_u w)=0` globally. Set `R=eta-eta_0`.
It is supported at the mark and satisfies

```
D_u^* R = - J_z^* lambda,
```

where `J_z w` is the fixed-mark linearized holomorphic first jet.
The right side has distributional order at most one.

### 5. All higher delta derivatives vanish

A distribution supported at one point is a finite sum of
derivatives of the delta distribution. Its continuity on
`W^{k-1,p}` in real dimension two, with `p>2`, bounds its order
by `k-2`: derivatives of order at most `k-2` admit continuous
point evaluation, whereas a nonzero top derivative of order
`k-1` or greater does not. This bound is a regularity bound,
not the false assertion that the order is already zero.

Suppose the largest nonzero order of `R` is `m>=1`. Compare
the terms of order `m+1` in its adjoint equation. Coefficient
derivatives and lower-order terms have strictly smaller order;
the right side has order at most one. The homogeneous
covector polynomial `R_m(xi)` must satisfy

```
sigma(D_u)^*(xi) R_m(xi) = 0.
```

The real Cauchy--Riemann symbol is, up to a nonzero scalar,
`s I + t J`; its inverse for `(s,t)!=0` is
`(s I-t J)/(s^2+t^2)`. Thus `R_m(xi)=0` for every nonzero
real `xi`. A polynomial that vanishes on this open set has all
coefficients zero, contradicting the definition of `m`.
This argument works for every finite `m`, not just orders
enumerated by a program. The Lean theorem
`RestrictedJet.polynomial_symbol_kernel` also certifies the
polynomial-kernel step without a degree bound, once the
distributional comparison has produced those polynomial
equations. It does not formalize that comparison.
Hence `R=q delta_z`.

Now test variations with `w(z)=0`. At a critical point the
zeroth-order terms of the map and jet derivatives disappear,
so their values are, respectively,

```
(w_s+J w_t)/2,             (w_s-J w_t)/2.
```

Given any two vectors `e,h`, take `w_s=e+h` and
`w_t=J(h-e)`. The two displayed values are `e,h`
independently. These derivatives and zero value are realized
by a linear polynomial times a cutoff supported near the
mark; a map variation need not avoid `K`.
The adjoint equation then reads `q(e)+lambda(h)=0` for
arbitrary independent `e,h`. Therefore `q=0=lambda`.

Combining Steps 1--5 proves that the unaugmented annihilator
is exactly the two stated period functionals.

### 6. The coefficient sphere removes exactly the two periods

For all maps in class `F` and all exact pair perturbations,

```
(integral u* A'_v, integral u* C'_v)
  = -b (v_1/v_3, v_2/v_3).
```

At `v_0` its derivative is `-b I_2`, which is invertible.
Applying `eta_0` to these variations forces `k_A=k_C=0`.
Consequently the augmented annihilator is zero.

The range is closed: the fixed-background map-and-mark-and-jet
operator is Fredholm, hence has finite-codimensional closed
range; adding any linear parameter image leaves a closed
range, as is seen in the finite-dimensional quotient.
Finite many parameter vectors span that quotient. Together
with a complemented Fredholm kernel they give a bounded
right inverse for the augmented operator. Thus it is a
split surjection, not merely an operator with dense range.

At a holomorphic zero the two pullbacks vanish pointwise, so
their periods force `v=v_0`. The extra coefficient directions
do not introduce any additional curve solutions or change
the actual two-form `B`. In particular they are legitimate
auxiliary variables, not forbidden deformations of `B`.

### 7. The actual Fredholm indices and regularity

Choose any `p>2`, integer `k>=8`, and integer `r>=k+8`.
Maps are `W^{k,p}`; the first target is `W^{k-1,p}`;
primitives are in the `C^{r+1}` closure of the allowed
smooth primitives. Use the same closure for smooth
parameter-dependent primitives on a path.
These are separable Banach spaces. Sobolev embedding gives
`C^{k-1,alpha}` maps for `0<alpha<1-2/p`.
Moving first-jet evaluation is at least `C^{k-2}`, hence
`C^6`; the pair-to-structure operation is smooth on the open
positive locus, and composition with the `C^r` backgrounds
has the needed `C^6` regularity.

The generous finite regularity also makes the negative-order
distribution argument legitimate: `eta` starts in
`W^{1-k,q}`, `q=p/(p-1)>1`; local elliptic bootstrap away
from the mark reaches `W^{4,q}`, hence `C^1`. Only finitely
many coefficient derivatives, fewer than the stated margin,
are needed. Products with delta derivatives of order at most
`k-2` require no more coefficient derivatives than this margin.

The canonical bundle trivialization gives `c_1(u*TX)=0`.
The fixed-`j` parametrized sphere operator has real index
`2 rank_C(TX)+2c_1=4`. The marked critical problem with
the auxiliary coefficient sphere consequently has index

```
4 + 2 (coefficient sphere) + 2 (mark) - 4 (jet) = 4.
```

A path adds one, giving five. This is not the unrestricted
generic-`J` index, which would omit the two coefficient
variables. The universal split surjectivity makes the zero
set a Banach manifold; its projection to the primitive space
is Fredholm of the indicated index. Sard--Smale applies
because its differentiability is at least six, greater than
both four and five.

At a regular primitive, a nonempty fiber would have dimension
four, or five for a path. But the six-dimensional
`PSL(2,C)` orbit of any simple marked sphere is in this
fiber. Its derivative is injective: if `du xi=0`, then
`xi=0` on the dense immersion locus and hence everywhere.
The finite-regularity solutions have more than enough
additional derivatives for this orbit map to be `C^1` in
the `W^{k,p}` topology. Its tangent space therefore supplies
six independent vectors in a space of dimension at most
five, a contradiction. No assertion about a smooth action
on all low-regularity, off-shell maps is needed.

### 8. Relative paths, retained spheres, and model subdisks

The assumed marked compactness makes absence of critical
spheres open in a sufficiently high finite topology:
otherwise mark critical points in a convergent sequence and
obtain a critical point on an immersed limiting sphere.
At immersed endpoints this gives larger parameter collars
free of critical spheres. Choose smaller fixed collars on
which all perturbations vanish. At every remaining possible
critical parameter, arbitrary local tests can be multiplied
by a path bump equal to one there. Hence the preceding
universal argument applies without changing the endpoints.

Let `K` first be the union of the specified retained sphere
images. If a critical simple `F`-sphere met one of them,
the disjoint-image hypothesis would make their images
identical. Factorization and simplicity would then make it
a reparametrization of an immersion, a contradiction.
Thus every needed injective disk is disjoint from `K`.
Use the closure of smooth primitives supported in
`X \ K`, not forms excluded from a fixed tubular
neighborhood. All local tests used in Step 3 are still
available. In this closure the forms and their relevant
jets vanish on `K`, so the retained curves remain common
Lagrangians exactly. This argument also applies to a
path when they are common Lagrangians throughout it.

For a fixed closed model subdisk, every point lies on a
complete model `F`-curve. A critical simple sphere meeting
the subdisk would have to be that curve. A torus cannot
be the image of a simple sphere, and the model rational
curve is immersed. Therefore a critical sphere is
disjoint from the entire closed subdisk. The same
support argument works for one-pair perturbations there.
For paths relative to their endpoints, endpoint models
are automatically unchanged on the fixed collars.
This argument would not justify an arbitrary forbidden
open set intersecting a critical curve.

Finally the Banach spaces and map spaces admit countable
atlases, so residual choices cover all simple sphere
charts and components simultaneously. Approximate a
regular primitive by smooth primitives in its defining
closure. Compactness and the just-proved openness retain
the immersion conclusion, and the approximation retains
the support and endpoint conditions. Any prescribed
`C^infinity` neighborhood bounds finitely many seminorms;
choose `r` larger than those orders to obtain arbitrary
smooth smallness. Positivity is an open `C^0` condition
with a uniform margin on compact `X` (and on the compact
path). A sufficiently small perturbation and its straight
interpolation stay positive. All changes to `A,C` are
exact and `B` is literally unchanged. This proves all
the stated versions of the conditional theorem.

## Certification boundary

`verify.py` is an exact algebra verifier. It does not construct
an arbitrary global perturbation or establish the manuscript's
upstream hypotheses. The analytic conclusion is the preceding
conditional argument, subject to independent review.
The Lean source, when successfully compiled, certifies only
the algebraic declarations identified in `statement_fidelity.md`.
No compiled algebra result is to be promoted to a kernel proof
of the analytic theorem.

The route of citing unrestricted generic-`J` transversality as
the restricted proof is invalid and is retired in the claim
ledger. The restricted route itself has not been refuted.

The inspected Jacobian operation was `matrix.symbolic.rank.compute`,
on server 0.14.0, protocol 2025-11-25. Its typed contract accepts
rectangular matrices with at most eight rows over a rational-function
field in at most eight variables. It returns rank and pivot columns,
not an infinite-dimensional cokernel or a real-specialization theorem.
The exact two-by-two payload and complete adapter output are preserved
in `jacobian_payload.json` and `jacobian_output.json`. The adapter
completed with rank two and no reported error. The determinant identity,
its real nonvanishing hypotheses, and the degenerate boundaries are
checked separately rather than inferred from generic rank.

The source readings and the independent source reader's observations
are in `primary-sources/readings.md`. Wendl's smooth Sard--Smale
statement does not specify the finite-differentiability inequality;
the precise finite-regularity version remains an explicit classical
analytic input. Official citation attribution is still outstanding:
that command writes under `research/literature/`, outside the assigned
write boundary. This is not a mathematical counterexample and has not
been hidden by marking the citations independently confirmed.

From the campaign root, replay the exact certificate with:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/restricted-jet-audit/verify.py
```
