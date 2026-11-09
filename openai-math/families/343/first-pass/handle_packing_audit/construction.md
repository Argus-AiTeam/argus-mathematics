# Conditional audit of the one-handle construction

## Scope and source reading

The object under audit is Lemma `surf:packing`, especially Steps 2--5,
in the staged September 23, 2026 manuscript
`Symplectic-Ball-Packings-in-Higher-Dimensions-September-23-2026/build/`.
The source is not modified. The statement concerns arbitrary fiber
dimension `m >= 1`, closed source balls, open target interiors, and
embeddings defined on neighborhoods of the closed sources.

The following are INPUTS, not conclusions of this audit:

1. The finite models and uniform convergence in the hypotheses of
   `surface.tex`, Lemma `surf:packing`.
2. The smooth toric function `K`, neighborhood Hamiltonian isotopy
   `q_xi`, preservation of `V`, and uniform outer-face commutation
   asserted by `comparison.tex`, Lemma `cmp:comparison`.
3. The strictly positive comparison gap
   `g = min_V(K o q^{-1} - K + H - C_r)`.

The comparison inequality implies the displayed gap by substituting
`v = q(u)` and using compactness. This implication does not verify the
existence of the comparison data. The proofs of
`cmp:rearrangement-properties`, `cmp:lifted`, and `cmp:comparison` are
outside the present claim.

The source-backed dependency decomposition is:

| Manuscript assertion | Dependencies | This mission |
|---|---|---|
| `intro:main`, sufficiency | `app:small`, `app:large`, `six:large` | Not certified |
| Three sufficiency cases | Surface packing; geometric models and relative transfer/avoidance | Not certified |
| `surf:packing` | Comparison data; finite model; relative primitives; exact positive paths; face-relative Moser; planar-to-layer embedding | Construction under audit |
| Step 2 | Handle topology; `surf:primitive`; toric top-power identity | To be proved here |
| Step 3 | Suspension; one-covector top power; matching horizontal primitives | To be proved here |
| Step 4 | Common face collars; horizontal variation; smooth compact-time flow | To be proved here |
| Step 5 | Positive strip coordinate; signed toric shear; thin planar disk; compact slack | To be proved here |

`surface.tex` supplies explicit proofs of `surf:primitive` and
`surf:moser`. The thin planar step cites `cmp:planar-disks` and compares
Schlenk's constructions; the suspension citation is explicitly a
comparison, not a premise replacing a calculation. The construction
proof below will not assume a folding theorem or the comparison
realization theorem to justify those calculations.

The standard finite-dimensional inverse function theorem and
existence, uniqueness, smooth dependence, and continuation of smooth
ordinary differential equations are analytic foundations used here.
They are not numerical conclusions or claims of formal verification.

## A route already known not to work

Positive mean cannot be replaced by pointwise positivity. On
`Delta = [0,1]`, take `r = 1/2`,
`P(p) = p - 1/4`, and `H(p) = P(p) + (1/2-p)_+`.
Then `H >= 1/4`, `P` is affine, its mean is `1/4`, and
`inf_{Delta \ (1/2)Delta} P = 1/4`, whereas `P(0) = -1/4`.
The auxiliary simplex avoids the outer face `p = 1`.
Thus direct same-fiber stacking is not an available proof.
This is not a false manuscript assertion: the introduction expressly
notes this obstruction. No search in an inherited Wiki topic supplied
an additional result about this construction.

## The finite profile realization theorem

The following is a conditional, universally quantified analytic theorem.
It is not a finite experiment and does not assert that comparison data
exist.

Let `m >= 1`, let `Delta` be any full-dimensional compact convex
polytope in the nonnegative moment orthant, and set
`V = p^{-1}(Delta)`, `p_j = pi |z_j|^2`. In this theorem, the
noncoordinate inequalities defining `Delta` may have arbitrary real
coefficients: downward closure, simplicity, and rationality are not
needed. Use every noncoordinate defining level as an outer level.
Let `Sigma` be a compact connected oriented surface with nonempty
smooth boundary and an embedded handle. Suppose a neighborhood of
`Sigma x V` has

    Omega = omega_V + d Gamma,
    Gamma toric horizontal, kappa = d_C Gamma > 0,
    A(p) = integral_Sigma kappa(p).

Let `k >= 1`, let `h_1,...,h_k` be smooth strictly positive toric
functions, and let `K` be a smooth toric function. Suppose a smooth
neighborhood Hamiltonian isotopy `q_xi`, `0 <= xi <= 1`, starts at
the identity, preserves `V`, and has generators commuting with each
outer-level moment on a time-uniform collar of that level. Put `q=q_1`.
Assume

    d0 = min_V [K o q^{-1} - K + A - sum_i h_i] > 0.       (F)

Then there are pairwise disjoint symplectic embeddings

    E_i = {(v,x,T): v in Int V, 0<T<1, 0<x<h_i(p(v))}
          --> (Int(Sigma x V), Omega),

where `E_i` carries `omega_V + dx wedge dT`.
Consequently, for each `i`, every compact subset of

    W_i = {(v,z): v in Int V, pi|z|^2 < h_i(p(v))}

admits a symplectic embedding on an open neighborhood, and the finitely
many compact images and their sufficiently restricted neighborhoods
can be chosen disjoint.

All smooth data in this statement extend to neighborhoods of the
indicated closed sets. The flow and positivity arguments below also
produce the neighborhood extensions; none is inferred from an
action-angle chart at an axis.

This theorem isolates the finite-model mechanism and slightly extends
its formulation from balls to compact radial fiberwise regions and
from downward polytopes to arbitrary compact moment polytopes, given
the same face-commuting comparison data. It does not extend the
existence theorem for comparison maps to those other polytopes.
No priority or literature novelty is claimed.

### 1. Universal algebra, independently derived

Write a toric horizontal form as `Gamma = A ds + B dt`. Its differential
has vertical part zero, base part `F ds wedge dt`, and mixed parts
`d_p A wedge ds + d_p B wedge dt`. A top-degree monomial must use
both base covectors. Besides one copy of the base part, the only
possibility is one mixed `ds` part and one mixed `dt` part. Wedging
the latter with `omega_V^(m-1)` gives `m+1` moment covectors among
only `m` independent `dp_j`, and is zero. Thus, for every `m`,

    (omega_V + d Gamma)^(m+1)
      = (m+1) omega_V^m wedge d_C Gamma.                  (T)

For the nontoric calculation, let `beta=f(t)dt`, let `gamma` be a
base one-form, and let `G(s,v)` be arbitrary and possibly
angle-dependent. Set

    b = d gamma + partial_s G ds wedge beta
                  + d_v G wedge beta.

Every summand of `b` contains `dt`, so `b wedge b=0`.
Two-forms commute under wedge product. The universal square-zero
binomial identity gives

    (omega_V+b)^(m+1)
      = omega_V^(m+1) + (m+1) omega_V^m wedge b.

The first term vanishes by vertical dimension. The term
`omega_V^m wedge d_v G` also vanishes by vertical dimension, without
any toric assumption on `G`. Hence

    (d gamma + omega_V + d(G beta))^(m+1)
      = (m+1) omega_V^m wedge
          (d gamma + partial_s G ds wedge beta).         (O)

This is the required non-toric positivity mechanism. Applying (T)
directly to an arbitrary angle-dependent horizontal primitive would
be invalid; the manuscript instead uses (O) before pullback.
`lean/Main.lean` formalizes the square-zero binomial identity for every
natural exponent and every commutative ring, not merely tested
dimensions. Its separate fidelity document specifies precisely the
limited formal coverage. The dimension arguments here are analytic
exterior algebra and require mathematical review.

For a smooth family of Hamiltonian maps `q_s`, with convention
`i_{X_Q} omega_V = -dQ`, put `D(s,t,u)=(s,t,q_s(u))`.
On vertical pairs, `D^*omega_V=omega_V`. On `(partial_s,w)`,

    D^*omega_V(partial_s,w)
      = omega_V(X_{Q_s}, dq_s(w))
      = -d_u(Q_s o q_s)(w)
      = d((Q_s o q_s)ds)(partial_s,w).

On the other base pairs both sides vanish. Therefore

    D^*omega_V = omega_V + d((Q_s o q_s)ds).              (S)

This proves the plus sign in `surf:suspension` in every dimension.
The identities are statements about smooth forms on Cartesian fiber
space. Their derivations on the dense locus of nonzero fiber
coordinates extend to every axis by continuity.

### 2. Small background and normalized annulus

Choose transverse bands in the embedded punctured torus. An oriented
normal coordinate to the transverse band and a nonnegative bump of
integral one give a closed form `beta`, supported inside the handle,
whose restriction to a larger annulus `A+` is `f(t)dt`, with `f`
positive on a single interval, zero off its closure, and integral one.
Orient the other coordinate `s` so that `ds wedge dt` is positive.
Take an inner annulus `A` and a nondecreasing function `S(s)` equal
to zero and one on its lower and upper end collars. Then

    chi = S'(s) ds wedge beta

extends by zero, is nonnegative, has integral one, and has fixed
compact interior support.

Let `a0 = min_Delta A > 0`. Fix
`0 < e0 < min(d0,a0)/4`.
Write `kappa=a(y,p)lambda`, using a fixed positive base area form.
Choose a sufficiently thin base-boundary cutoff `zeta` and then a
sufficiently small constant `e>0`. The form

    kappa_b = (zeta a + (1-zeta)e)lambda

agrees with `kappa` near the base boundary, equals `e lambda` on `A+`,
and has `a_b(p)=integral_Sigma kappa_b(p)<e0` uniformly.
Uniformity follows from boundedness of `a` on the compact parameter
set; it does not require simplicity of `Delta`. Define

    H_* = A-a_b,       kappa_1 = kappa_b + H_* chi.

Then `H_*>3a0/4`, `kappa_1>0`, and `kappa_1-kappa` is
interior-supported with zero integral.

Here is the relative primitive argument rather than an appeal to a
cohomology slogan. For a zero-integral compactly supported
`h(x,y)dx wedge dy`, fix `rho` of integral one and put

    h0(y) = integral h(x,y)dx,
    U(x,y) = integral_{-infinity}^x (h(v,y)-rho(v)h0(y))dv,
    W(y) = integral_{-infinity}^y h0(v)dv.

The form `U dy-rho W dx` has differential `h dx wedge dy`.
The zero marginal makes `U` compactly supported, and the zero total
integral makes `W` compactly supported. A fixed finite disk cover,
partition of unity, and chains of overlapping disks transport the
nonzero integrals of the individual pieces to one fixed bump; its
coefficient is zero. This yields a linear primitive operator with
fixed interior support. Applying it coefficientwise in `p` gives a
smooth toric horizontal `alpha` with
`d_C alpha=kappa_1-kappa`. This also proves smooth dependence on all
parameters, including parameters on nonsimple faces.

Put `Gamma_tilde=Gamma+alpha`. Choose `gamma` on `A+` with
`d gamma=e lambda`: in annular coordinates a primitive is obtained
by integrating the coefficient of `e lambda` in `s`.
The base-closed form

    delta = Gamma_tilde - gamma - S H_* beta

has a smooth period `c(p)`. Its difference from `c(p)beta` has zero
period and equals `d_C F` on `A+`, by path integration from a fixed
base point. A cutoff `zeta_A=1` near the closed inner annulus gives

    Gamma_1 = Gamma_tilde - c(p)beta - d_C(zeta_A F).

This is toric horizontal, equals `Gamma` near the base boundary,
has base curvature `kappa_1`, and equals `gamma+S H_* beta` near
the closed inner annulus. Importantly, the cutoff normalization uses
`d_C`, not the total differential: it preserves horizontality.
All changes of the total two-form are nevertheless exact.
Linear interpolation of the primitives is symplectic by (T).

### 3. Two exact, glued, positive paths

Let `J=K-H_*` and

    R = K o q^{-1} - J - sum_i h_i.

By (F), `R >= d0-a_b > 3d0/4`. It may be nontoric.
For `0<=lambda<=1` set

    q_s^lambda = q_{lambda S(s)},
    Q_s^lambda = lambda S'(s) Q_{lambda S(s)},
    G_lambda(s,v) = S(s) H_*(q_lambda^{-1}(v)).

The generator vanishes on both end collars. By (S), the annular
form

    d gamma + D_lambda^*(omega_V+d(G_lambda beta))

has horizontal primitive

    gamma + (Q_s^lambda o q_s^lambda)ds
            + (G_lambda o q_s^lambda)beta.

On the lower end this is `gamma`. On the upper end it is
`gamma+H_* beta`, since `q_lambda^{-1}q_lambda=id`.
Thus the primitive itself glues to `Gamma_1` outside the annulus.
At `lambda=0` it is exactly `Gamma_1`. Positivity follows from (O),
`partial_s G_lambda=S' H_* o q_lambda^{-1}>=0`,
`ds wedge beta>=0`, and `d gamma>0`; a fiber-preserving pullback
cannot destroy nondegeneracy or its orientation.

Choose finitely many successively ordered disjoint closed intervals
`I_1,...,I_k,I_*` in the annular interior, and smooth step functions
`rho_i,rho_*`, zero below their interval and one above, constant on
end collars, with nonnegative derivatives. Define

    G_f = J + sum_i rho_i h_i + rho_* R.

This is nondecreasing in `s`. Its lower end is `J` and its upper end
is `K o q^{-1}`. On the `i`th packing interval,

    G_f = a_i + rho_i h_i,       a_i=J+sum_{j<i} h_j,

which is toric. The only angle-dependent derivative is in `I_*`,
after all packing intervals. It is not discarded above `I_*`.

Keep `D=D_1` fixed and interpolate
`G_hat_tau=(1-tau) S H_* o q^{-1}+tau G_f`.
On the annulus use
`d gamma+D^*(omega_V+d(G_hat_tau beta))`; outside use
`omega_V+d(Gamma_1+tau J beta)`.
The pulled-back coefficients on the lower and upper collars are,
respectively,

    tau J,       (1-tau)H_*+tau K = H_*+tau J.

The suspension term is zero there. These are precisely the outside
primitive values, so the global variation is exact and horizontal.
Inside, (O) applies because both `s` derivatives are nonnegative.
Outside, `J` is toric and `d_C(J beta)=0`, so (T) applies with
unchanged positive base curvature. In particular, neither this
gluing nor positivity requires `R` to be toric.

### 4. All face collars, intersections, and neighborhood Moser

Fix an outer-level moment `mu=b dot p`. On a smaller common
time-uniform collar, the supplied commutation
`{Q_xi,mu}=0` implies `mu o q_xi=mu`, also for inverse maps.
A trajectory starting in that collar cannot escape it through a
different value of `mu`, because its value is constant. Symplecticity
therefore gives `dq_xi(X_mu)=X_mu o q_xi`.
Consequently the functions `Q_s^lambda o q_s^lambda`,
`H_* o q_lambda^{-1}`, `K o q^{-1}`, and their stated pullbacks
are invariant under `X_mu` on that collar. All remaining
fiber-dependent functions in the primitives are toric.
Finitely many levels and compact parameter intervals permit common
collars. The statement applies to each level simultaneously; it
does not choose a basis of active faces.

Every global primitive `Gamma_t` along the three paths is horizontal,
has the same fixed boundary-collar restriction, and is `X_mu`-invariant
near the corresponding face. Cartan's identity gives

    i_{X_mu}(omega_V+d Gamma_t) = -d mu.

With `alpha_t=partial_t Gamma_t`, solve
`i_{Y_t}Omega_t=-alpha_t`. Evaluation on `X_mu` gives

    d mu(Y_t) = -alpha_t(X_mu) = 0.

Also `Y_t=0` in the base-boundary collar. For an interior trajectory,
the first exit through any outer level is impossible: after entering
its invariant collar the level value is constant. Boundary
trajectories follow by continuous dependence from interior points;
the compact full-dimensional polytope and its toric preimage are
closures of their interiors. This treats nonsimple and redundant
face intersections without corner coordinates. The argument works
with arbitrary real face coefficients, not only nonnegative ones.
The coordinate axes impose no extra escape condition: `p_j>=0`
identically on Cartesian fiber space.

Smooth nondegeneracy on the compact space-time region gives a
smooth vector field on a common neighborhood. Its trajectories in
the compact region exist for the entire parameter interval by ODE
continuation. Openness of the flow domain and a finite covering of
this compact family give a neighborhood on which the entire flow
exists as well. Reverse-time flow has the same properties. Hence
the time-one map preserves `Sigma x V`, its interior, and the base
boundary collar, and is a neighborhood diffeomorphism. The identity

    d/dt (psi_t^*Omega_t)
      = psi_t^*(d alpha_t + d i_{Y_t}Omega_t) = 0

proves `psi^*Omega_f=Omega`. Reparametrize the three stages to be
constant near their parameter endpoints before concatenation.
The direction returning a final packing to the original model is
`psi^{-1}`, as in the manuscript.

### 5. The full layer chart, including axes

In the `D` coordinates, work on `I_i` and on the open interval where
`f>0`. The coordinate `T=integral beta` is a diffeomorphism onto
`(0,1)`, since `f>0` and its total integral is one. On this open
chart write

    d gamma=ell(s,T)ds wedge dT,   ell>0,
    L(s,T)=integral_{s_i^-}^s ell(sigma,T)d sigma,
    x=L+rho_i(s)h_i(p).

Then `partial_s x=ell+rho_i' h_i>0`.
Although `ell` need not remain bounded as `T` approaches zero or
one, it is smooth at every point of this open chart; compact images
used below stay away from those ends. Direct differentiation gives

    Omega_layer = omega_V+dx wedge dT+da_i wedge dT.

Let `v'=phi_{a_i}^T(v)`. In action-angle coordinates the convention
in (S) yields

    theta_j'=theta_j+T partial_{p_j}a_i.

The symmetric Hessian contribution
`T sum_{j,l} partial_{jl}a_i dp_j wedge dp_l` is zero, so

    omega_V(v')=omega_V(v)+da_i wedge dT.

Thus the layer is in product coordinates
`omega_V(v')+dx wedge dT`. The sign is plus.
In Cartesian coordinates the same toric map is

    z_j' = exp(2 pi i T partial_{p_j}a_i(p(z))) z_j.

It is smooth at every axis, with inverse obtained by reversing the
phase; it preserves all moments and every defining inequality.
The lower `x` endpoint is zero and the upper endpoint is
`L(s_i^+,T)+h_i(p)>h_i(p)`. Strict monotonicity and the
parameterized inverse function theorem yield a smooth inverse
over the entire stated `E_i`, including at fiber axes. No polar
chart is used to extend that inverse.
Undoing `D` and then applying `psi^{-1}` proves the strip-embedding
part of the finite theorem. Different strips land over different
base intervals, so their images are disjoint.

### 6. Thin planar disks without a folding-theorem assumption

For any `A>0, delta>0` there is an area-preserving embedding of a
neighborhood of the closed planar disk of area `A` into the plane
with coordinates `(x,T)` such that

    0<T<1,       0<x<pi|z|^2+delta.                       (P)

Choose a finite area grid `0<h_1<...<h_l`, with
`h_1<delta/4`, all meshes `<delta/4`, and `h_l>A`.
Choose strictly increasing heights `H_j<1` sufficiently close to
one that `h_j/H_j` are strictly increasing and exceed `h_j` by
less than `delta/8`. Horizontal left endpoints can be chosen
strictly decreasing, positive, and sufficiently small that the
rectangles of height `H_j`, width `h_j/H_j`, and vertical center
`1/2` are strictly nested and have right endpoints below
`h_j+delta/4`.

These finite strict inequalities persist after smoothing and
area correction. More explicitly, inscribed superellipses with a
common even exponent `2N` have area

    c_N times width times height,
    c_N = integral_0^1 (1-u^(2N))^(1/(2N))du --> 1.

Dilate their horizontal semiaxes by `1/c_N` to restore area `h_j`.
For sufficiently large `N`, they remain strictly nested smooth
convex disks `E_j` inside
`0<x<h_j+delta/2, 0<T<1`. Smoothness follows from the nonvanishing
gradient of their defining polynomial on its level one. Choose a
common interior point of `E_1`; all `E_j` are star-shaped about it.

Here is the simultaneous area-preserving matching argument needed
for this special family. Translate the centered source disks to
that common point. Their circular radii and the target radial
boundary functions have the same strict order. A smooth radial
diffeomorphism matching the finitely many boundaries exists:
in each source annulus choose a positive radial derivative whose
integral is the prescribed positive difference of target radii.
Use a sufficiently small fixed positive derivative near the
finitely many joining circles and a positive bump in each open
annulus for the remaining integral. All differences have a
positive uniform minimum in the angular variable. Near the center
take the radial map to be linear, and outside a sufficiently large
circle take it to be the identity. This is a smooth
orientation-preserving diffeomorphism `phi` with compact support,
mapping every source disk to `E_j`.

Let `eta=phi^*omega-omega`. It is compactly supported, has total
integral zero, and has integral zero over every designated source
disk, since both disk areas are `h_j`. The explicit primitive
operator from part 2 gives a compactly supported `alpha` with
`d alpha=eta`. On each designated circle its tangential
restriction is exact, by its zero period. Subtract differentials
of extensions of these circle primitives in disjoint annular
collars. The resulting primitive vanishes on every circle's
tangent line. For the positive path `omega+t eta`, its Moser
field is tangent to those circles and compactly supported.
Its correction `chi` preserves each source disk and satisfies
`chi^*phi^*omega=omega`. Composing `phi chi` with the initial
translation gives the required simultaneous area-preserving disk
matching. This argument needs neither a Hamiltonian isotopy of
these planar maps nor the general parameterized
`cmp:planar-disks` theorem.

For a source point of radial area `w<=A`, the next larger grid
value `h` has `h-w<delta/4`, and its image lies in `E_h`.
Thus `x<h+delta/2<w+delta`. The last grid value exceeds `A`,
so the map is defined beyond the closed source disk. This proves
(P), including its center and its boundary.

For a compact subset of `W_i` in the theorem, take `delta` smaller
than the positive minimum of `h_i(p)-pi|z|^2` and take `A`
larger than the maximum radial area. The product of (P) with
the unchanged fiber lands compactly in `E_i`. It is symplectic
on an open neighborhood. Finitely many compact images in the
different layers have disjoint open neighborhoods; restricting
the source neighborhoods accordingly makes the neighborhood
images disjoint too. This proves the finite profile theorem.

## Application to the exact manuscript hypotheses

Let `g` be the supplied comparison gap in Step 1 and choose

    0<epsilon<min(g,min_Delta H)/8.

Uniform convergence and the handle exhaustion give one finite
surface with `|A-H|<epsilon` and the required handle. No
compatibility between models and no concavity of the finite
area function is used. Smooth upper cap approximations can be
chosen with

    0<sigma=sum_i h_i-C_r<epsilon.

Indeed
`[x+sqrt(x^2+eta_i^2)]/2-x_+` is strictly positive and at most
`eta_i/2`; take `sum eta_i/2<epsilon`.
Thus the finite profile gap is greater than `g-2epsilon`.
Choosing the background with `a_b<epsilon` gives exactly

    H_*>H-2epsilon>0,
    R = (K o q^{-1}-K+H-C_r)+(A-H)-a_b-sigma
      > g-3epsilon > 5g/8.                              (G)

For each requested ball choose
`0<delta<r_i-r_i'` and `A_planar>r_i'`. At every point of its
closed source,

    w+sum p_j <= r_i',
    0<x<w+delta<r_i-sum p_j<h_i(p).

Its fiber coordinates are separated from every outer face by
the auxiliary-simplex assumption, including where some `p_j=0`.
The planar image is compactly contained in `x>0, 0<T<1`.
The upper strip inequality has at least the positive slack
`r_i-r_i'-delta`. Therefore the image is compactly contained
in the product chart, and an open neighborhood of the entire
closed ball maps into it. Parts 4--5 give the claimed neighborhood
embedding in the original finite model and disjointness.

This proves `C343_HANDLE`, conditional on its recorded inputs.
It verifies the conclusion of `surf:packing` only after
`cmp:comparison` has actually supplied those inputs.

## Evidence classification and remaining dependencies

The exact script checks source equations, independently computes
exterior derivatives, wedge products, pullbacks and shears, checks
the error budget and a finite nested-rectangle construction, and
replays the archived Jacobian determinant. These are exact symbolic
calculations, with finite-dimensional runs labeled as such. Wrong
suspension/shear signs and a nontoric two-covector degeneration are
negative controls, not admissible counterexamples to the manuscript.
No literal false manuscript assertion has been established.

The arbitrary-dimension proof is parts 1--6, not extrapolation from
those runs. The only Lean-formalized part is the universal
square-zero ring identity described in its fidelity document.
The analytic proof uses the explicitly recorded smooth-calculus
foundations; it is not itself a Lean proof or an executable
geometric embedding.

The manuscript already asserts the ball-packing conclusion. The
improvement here is an independent proof of its exact finite
mechanism, explicit margins and neighborhood checks, a finite
profile formulation with unused downwardness removed, and a
limited universal formal certificate. This is not a new proof of
the full higher-dimensional packing theorem or a verified-new
literature claim. Comparison existence, the geometric models and
transfers, the three sufficiency cases, and the campaign's
publication/novelty gate remain open.

Independent Reviewer replay and statement-fidelity approval are
required and have not been performed by Engineer.

Replay the exact calculations from the campaign root with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/handle_packing_audit/verify.py
```

The script uses SymPy and the standard library, makes no network calls,
does not launch Jacobian or Lean, and does not change the ledger.
It recomputes the mathematical calculations and compares their full
typed summary to `exact_certificate.json`; it also checks that the
archived real Lean run is successful, hole-free, version 4.31.0, and
fresh for both formal source and fidelity text. Independent recompilation
uses the official command:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/handle_packing_audit/lean/Main.lean --statement-fidelity research/handle_packing_audit/lean/statement_fidelity.md --artifact-dir research/handle_packing_audit/lean --claim C343_SQUARE_ZERO --project-root .
```
