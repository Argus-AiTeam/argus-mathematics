# Lattice-strip rigidity and conditional saturation

## Assessment and boundary

**Disposition: supported.** The abstract theorem in
`C_AJL_POLYHEDRAL@2` has a valid proof, including when the cone has
lineality. Version 1 follows as a specialization. `C_AJL_SAT@1` is
supported **conditionally on the exact lifting implication and the
separately supplied canonical-interiority hypothesis**. Neither lifting
nor canonical interiority is proved by this assessment.

This is an Engineer assessment of one old-draft unit, not native
independent Reviewer acceptance, family completion, or verification of
either volume-gap theorem. No novelty is claimed.

## Sources, versions, and attribution

All paths beginning `old/` below mean the read-only directory
`campaigns/9000037/`.

The controlling inventory is `PRIOR_DRAFTS.json`, with the unit assignment
in `research/DRAFT_REVIEW_INDEX.json`. The mathematical sources are:

* `old/research/adjoint_jet_lifting/report.md`: definitions and scope,
  lines 1–60; Theorem B and its proof, lines 428–513; saturation,
  lines 514–551.
* `old/research/MATH_STATE.json`: exact archived claim versions and
  `CTX_AJL@1`; `old/research/PROOF_GRAPH.json`: historical dependency
  context. Their confidence/status labels are not evidence of correctness.
* Reference manuscript, revision
  `4eaee87548250b2682affda7d05d947c05554bae`,
  `old/research/openai_manuscript/`
  `The-ordinary-double-point-gap-in-every-dimension-September-24-2026/`
  `build/sections/04-jet-interiority.tex`, lines 28–120, 139–148,
  221–225: lattice, original/scaled degree, and canonical congruence.
  The companion `05-adjoint-semigroup.tex`, lines 405–556, contains
  `adj:saturation` and its differentiability/recurrence/finite-normal
  argument. It is consulted for attribution and exact specialization,
  not subjected to a new manuscript-wide audit.

All three unit claim versions are in the same archived context,
`CTX_AJL@1`, whose hash is
`0c8ef64398a37000eefe67feaf45033eacf3035d7463f05393a9c07db33eed59`.

| Archived claim | Exact archived natural statement | Assessment |
| --- | --- | --- |
| `C_AJL_POLYHEDRAL@1` | “A full-dimensional bounded-slice epigraph cone with an interior lattice shift and no lattice point in its forbidden adjoint strip has finitely many primitive integral height-one support forms.” | Supported in its closed-convex, full-lattice jet context; a finite **defining** family is meant, not every real support form. |
| `C_AJL_POLYHEDRAL@2` | “For any proper full-dimensional closed convex cone C in a finite-dimensional real vector space with full lattice Lambda and c in Int C intersect Lambda, if (Int C-c) intersect Lambda is contained in C, then C is rational polyhedral and every primitive facet form has value one at c.” | Supported under the explicit convention below. |
| `C_AJL_SAT@1` | “Assuming c in Int K, adjoint lifting forces rational polyhedrality, primitive facet height one, exact saturation, and interior translation.” | Supported as the stated conditional implication. |

Version 2 removes version 1's bounded original-degree slices, specified
epigraph/exponent orthant, and jet-semigroup structure. Instead it obtains
a global epigraph along the interior vector itself. It consequently
also covers nonpointed cones. There is one shared final proof, not a
separately preserved earlier version-1 proof to certify.

The manuscript already contains the corresponding jet-cone argument.
The old Argus report, attributed in its ledger to
`engineer:adjoint-jet`, abstracts/strengthens that argument. This is not
evidence of an independently discovered or previously unknown theorem.
Only elementary convex analysis, compactness of a lattice torus, and
dual-lattice discreteness are needed here; no new literature search was
necessary.

## Exact statements and hypotheses

Write
`Lambda* = {eta in V*: eta(Lambda) is contained in Z}`.
The supported abstract statement is:

> Let `V` be finite dimensional, `Lambda` a full lattice in `V`, and
> `C != V` a full-dimensional closed convex cone. Let
> `c in Int_V(C) intersect Lambda`. If
> `(Int_V(C)-c) intersect Lambda` is contained in `C`, then there are
> finitely many primitive forms `eta_i in Lambda*` such that
> `C = {v: eta_i(v) >= 0 for every i}` and `eta_i(c)=1`.
> In particular every facet's primitive nonnegative integral support
> form has height one at `c`.

Interior is ordinary ambient interior, not relative interior. “Primitive”
means `eta_i(Lambda)=Z`; it is not primitivity relative to an
arbitrarily substituted coordinate lattice.

The report does not separately define “proper” or impose pointedness.
Its proof uses precisely `C != V` to obtain a nonzero nonnegative
support. The assessment therefore explicitly adopts that weaker
convention and verifies it. If “proper” was intended in a stronger
pointed-cone convention, this proves more than required; no missing
pointedness assumption is needed.

The saturation application has the following exact conditional inputs:

1. `K` is a proper full-dimensional closed convex cone in
   `R x R^N`, `Lambda` is the full congruence lattice below, and
   `Gamma` is contained in `K intersect Lambda`.
2. `c=(r,1,...,1)` belongs to `Int K intersect Lambda`.
3. For **every** `q in Lambda`,
   `q+c in Int K` implies `q in Gamma`.

Then `K` has the height-one facet description above,
`Gamma=K intersect Lambda`, and
`Int K intersect Lambda=c+Gamma`. In the inherited jet setting this
is a finitely generated saturated affine semigroup with group `Lambda`.
The geometric hypotheses used to establish input 3 belong to the
separate adjoint-lifting assessment.

## Decisive proof check

### 1. The epigraph is global; no primal compact section is assumed

Separation of the proper closed cone gives a nonzero `ell >= 0` on
`C`. Since `c` is interior, `ell(c)>0`; normalize it to one.
Put `W=ker ell`. Every `v` has unique coordinates `v=x+s c`
with `x in W` and `s=ell(v)`.

For each fixed `x`, `x+s c` is interior for all sufficiently large
positive `s`: write it as `s(c+x/s)`. Its admissible parameters in
`C` are closed, upward closed, nonempty, and bounded below by zero.
They therefore form `[g(x),infinity)`. Convexity and homogeneity of
`C` give a finite convex positively homogeneous function `g` on
**all** of `W`, with

```
C = {x+s c : s >= g(x)}.
```

In particular `g` is locally Lipschitz and the strict epigraph is the
interior. This construction needs neither coercivity nor a lattice
on `W`; `ell` and `W` may initially be irrational.

There are two legitimate compactness uses later: the torus `V/Lambda`
and the **dual** section normalized at `c`. A primal slice such as
`C intersect {ell=1}` need not be compact, even for some pointed
cones, and is certainly not generally compact with lineality.
Version 1's bounded degree slices must not be silently imported into
version 2.

### 2. A smooth boundary support must be primitive integral

At a differentiability point `x` of `g`, homogeneity gives
`g(x)=Dg(x)[x]`. Thus, for `y=x+g(x)c`,

```
eta(x'+s c) = s-Dg(x)[x']
```

is nonnegative on `C`, vanishes at `y`, and satisfies `eta(c)=1`.
The supporting inequality for convex `g` proves its global
nonnegativity, not merely local tangency.

The additive group `eta(Lambda)` contains `1`. A subgroup of `R`
is either dense or discrete. In the discrete case write it as
`h Z`; then `1=k h` for an integer `k>=1`. If `k>1`, a lattice
point of value `-h` has value strictly between `-1` and `0`.
The dense case also supplies such a lattice point. Consequently,
unless `eta(Lambda)=Z`, there is `w in Lambda` with

```
-1 < eta(w) < 0.
```

This handles both irrational normal rays and rational rays whose
primitive integral generator has height greater than one. In
particular, **discreteness alone does not establish height one**;
the exclusion of `k>1` is essential and is present in the draft.

Compact-torus recurrence supplies positive integers `k_n` tending
to infinity and `l_n in Lambda` such that
`e_n=l_n-k_n y` tends to zero. Pigeonhole differences of multiples
of `y` give arbitrarily small returns. Either the return integers
have an unbounded subsequence, or a bounded subsequence gives an
exact positive period, whose multiples give the required unbounded
sequence. This works also for rational `y`, including `y=0`.

Now `eta(l_n+w)=eta(e_n)+eta(w)<0` eventually, so `l_n+w`
is outside `C`. To check the opposite strict inclusion carefully,
decompose

```
w+c+e_n = h_n+a_n c,       h_n in W.
```

The perturbations `h_n,a_n` are bounded. Differentiability at the
fixed point `x` gives

```
g(x+h_n/k_n) = g(x)+Dg(x)[h_n]/k_n+o(1/k_n).
```

The vertical excess of `y+(w+c+e_n)/k_n` over this graph is

```
eta(w+c+e_n)/k_n+o(1/k_n).
```

Its leading numerator tends to `1+eta(w)>0`. The point is
therefore interior for all sufficiently large `n`; positive scaling
then puts `l_n+w+c` in `Int C`. The lattice point `l_n+w`
violates the assumed strip exclusion. This contradiction proves
`eta(Lambda)=Z`.

The small-error estimate is sufficient: there is no requirement
that `e_n` decay faster than `1/k_n`, since the actual perturbation
is `e_n/k_n`.

### 3. Finiteness is in the dual lattice, not in an unbounded strip

Take a closed ball of radius `epsilon>0` about `c` inside `C`.
For every nonnegative support form with `eta(c)=1`, testing the
ball in its negative unit-normal direction gives
`||eta|| <= 1/epsilon`. Hence the normalized dual section

```
{eta in C*: eta(c)=1}
```

is closed and bounded, and therefore compact. Its intersection
with the discrete full dual lattice is finite. Step 2 places every
support obtained at a differentiability point in that finite set.

This is not an assertion that all normalized real supports are
integral. For example, on the positive quadrant with `c=(1,1)`,
`a x+(1-a)y` is a normalized support for irrational
`0<a<1`; it supports the nonsmooth vertex. Only the smooth
boundary supports are forced integral by Step 2.

Nor is there a hidden finite enumeration of the forbidden strip.
Primal strips and their lattice intersections are generally
unbounded. For the same quadrant, its forbidden region contains
`(-1/2,t)` for every `t>=0`, although it contains no lattice
point. The draft's valid finiteness argument concerns bounded
**integral dual normals**, not a bounded primal lattice search.

### 4. The finite smooth supports recover every boundary point

A finite convex function is differentiable on a dense set in its
open domain. The elementary justification supplied in the draft
is adequate: on coordinate lines the one-sided derivatives are
monotone and disagree at only countably many points; Fubini gives
all coordinate partials almost everywhere. At such a point a
supporting subgradient is uniquely determined by the partials.
Local boundedness of subgradients and the supporting inequality
then give differentiability.

Write the finite collection of smooth-point supports as
`eta_i(x+s c)=s-a_i(x)`. Each `a_i` is a global linear
minorant of `g`. For arbitrary `x0`, approach by differentiability
points `x_n`. Local boundedness of their derivatives gives

```
g(x_n)+Dg(x_n)[x0-x_n] -> g(x0).
```

By homogeneity the left side is one of the finitely many values
`a_i(x0)`, all at most `g(x0)`. Thus
`g(x0)=max_i a_i(x0)`. It follows that
`C=intersection_i {eta_i>=0}`.

This supplies the missing logical passage that merely testing
already-known rational facets would not supply: no finite facet
description or rationality was assumed in advance. In an
irredundant sublist every facet is cut out by one of these forms,
already primitive integral of height one.

### 5. Lineality and small dimensions

No step above assumes `C intersect (-C)={0}`. After the finite
description has been proved, its lineality space is exactly

```
L = intersection_i ker eta_i.
```

It is consequently rational, of dimension between zero and
`dim V-1`, and the quotient cone in `V/L` is pointed. Taking
a lattice quotient before proving this rationality would have
been unjustified; the draft does not do so. Halfspaces, with
lineality of dimension `dim V-1`, are included.

In dimension one a proper full-dimensional cone is a ray. If
`a` is its primitive positive lattice generator, write `c=k a`
with `k>=1`. For `k>=2`, `-a` is outside the ray but
`-a+c=(k-1)a` is interior, a direct contradiction. Thus `k=1`,
exactly the claimed height-one conclusion. This is also the
zero-dimensional-`W` case of the proof. A ray in a larger ambient
space is not full dimensional and is not covered. In dimension
zero there is no proper full-dimensional cone under `C != V`,
so the statement is vacuous.

## Conditional geometric application: lattice and dependencies

Use the **original** degree and the complete lattice

```
Lambda = {(j,alpha) in Z x Z^N :
          j-sum_i b_i alpha_i is divisible by m},
Gamma = the actual leading Taylor indices,
K = closure(cone(Gamma)),       c=(r,1,...,1).
```

The congruence map to `Z/m` is surjective because of its
coefficient `1` on `j`. Hence this is a full lattice of index
`m`, with basis `(m,0)` and `(\tilde b_i,e_i)` for integer
representatives `\tilde b_i`. In particular exponent coordinate
forms are primitive on this lattice. The supplied canonical
identity `r congruent sum_i b_i modulo m`, following from
`-K_B=rL` with the stated character convention, gives `c in Lambda`.
These facts do not require semigroup saturation.

The integration coordinate `D_0=Nj/r` is not an integer degree.
Under that change of coordinates the correct lattice is the
image of `Lambda`, and the canonical vector becomes `(N,1,...,1)`.
One can transport the entire theorem by that real linear
isomorphism, but cannot replace the image lattice by `Z^(N+1)`
or reuse the untransformed congruence. Facet integrality and height
are always relative to the actual lattice.

The dependency order is noncircular:

1. `C_AJL_LIFT@1` supplies, for all `q in Lambda`,
   `q+c in Int K => q in Gamma`, **without** assuming
   `c in Int K`. Its strongest geometric justification is
   `C_AJL_GENERAL@5`, assessed separately with its cited inputs.
2. Add the separate hypothesis `c in Int K`; containment
   `Gamma subset K` converts lifting into
   `(Int K-c) intersect Lambda subset K`.
3. Theorem B, independently proved above, now supplies the finite
   primitive integral facet forms of height one.
4. For `q in K intersect Lambda`,
   `eta_i(q+c)=eta_i(q)+1>=1` for every facet. Thus `q+c`
   is interior and exact lifting gives `q in Gamma`.
   The reverse containment was given from the start.
5. For `p in Int K intersect Lambda`, the integers `eta_i(p)`
   are positive, hence at least one. Therefore
   `eta_i(p-c)>=0`, and `p-c in K intersect Lambda=Gamma`.
   Conversely `eta_i(c+g)>=1` for `g in Gamma`, giving
   `c+Gamma subset Int K intersect Lambda`.

This proves precisely

```
Gamma=K intersect Lambda,
Int K intersect Lambda=c+Gamma.
```

Steps 4–5 are the elementary finite-facet algebra assigned to the
parent/facet-kernel unit; the above checks its interface, not its
separate Lean proof or compiler receipts. No finite generation or
saturation assumption is used to establish Step 2 or Theorem B.

For the further finite-generation assertion, the inherited jet
cone is pointed by positivity of the original degree on its
nonzero points. A rational simplicial subdivision and lattice
ray generators reduce each lattice point to integer coefficients
plus a lattice remainder in one of finitely many bounded
half-open parallelepipeds. This proves finite generation, not
merely bounded-degree agreement. If `kq in K intersect Lambda`
for `k>0` and `q in Lambda`, homogeneity gives `q in K`;
this proves saturation. The group is the full `Lambda`, as
also supplied by `jet:setup`. Even without that supplied group
statement, for any `q in Lambda` and sufficiently large integer
`a`, both `q+a c` and `a c` are in `K intersect Lambda`,
so their difference generates `q`.

If one extends this auxiliary finite-generation discussion to the
nonpointed abstract setting, first use the now-rational lineality
space: lift generators of the pointed quotient and add the two
signs of a basis of `Lambda intersect L`. No triangulation of
an implicitly pointed cone is needed for Theorem B itself.

## Evidence limits and remaining obligations

The support for Theorem B is the reconstructed proof above, not
old “supports” labels, finite examples, a computation, or a
formal theorem. The old exact certificates and Jacobian operation
concern other units; they cannot establish this general convex
statement. `Main.lean` formalizes conditional integer inequalities,
not torus recurrence, convex differentiability, polyhedrality,
the congruence-lattice geometry, or vanishing.

No mathematical gap remains in Theorem B under its explicit
hypotheses. The geometric application retains concrete,
separately assigned obligations: establish the **all-lattice-point
exact lifting implication**, with its geometric hypotheses and
cited inputs, and independently supply `c in Int K` for the
particular grading. Asymptotic counting or a finite jet check
would not discharge the first; this theorem does not prove the
second. These are conditional inputs, not unresolved steps in
the lattice-strip proof.

The three archived claim-version bindings and JSON syntax are
validated locally. No old inputs, active/old ledgers, graph,
Lean files, or other unit outputs are modified. Native independent
review remains required and is not an additional mathematical
assumption or a substitute for this assessment.
