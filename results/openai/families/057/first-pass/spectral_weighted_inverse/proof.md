# The weighted Dolbeault inverse: a domain-complete verification

## Result and scope

Under exactly the standing geometric and scalar-gap hypotheses preceding
Lemma `sp:weighted-inverse`, that lemma is valid. In particular its quadratic
comparison is not reversed. No counterexample to that lemma is asserted.

Here is a direct proof that also avoids the manuscript's use of spectral
bands. It proves an estimate for every closed form in the adjoint domain.
The manuscript already states the quadratic comparison; obtaining it again
is a verification, not evidence that the underlying result is new.

Put `m=2n`, `B=exp(b)`, `a=m*C0*t`, and

    r = (sqrt(a^2 + 4*delta^2/B) - a)/2 > 0.

As usual a curvature-bound constant can be taken nonnegative: replacing
`C0` by `max(C0,0)` only weakens its lower-bound hypothesis. This
convention is used in the formulas for `a`.

One can take the norm of every minimal differential inverse to be at most

    min(sqrt(B/delta), 1/sqrt(r)).

In particular its square is at most

    exp(b/2)/delta + m*C0*t*exp(b)/delta^2,

and hence its norm is at most

    delta^(-1/2)*exp(b/4)
      + sqrt(m*C0)*delta^(-1)*sqrt(t)*exp(b/2).

These constants do not depend on `S,b,t`. The finer root bound is a
quantitative refinement of the displayed big-constant bound, not a claimed
novelty theorem or a sharpness assertion in the geometric category.

This is conditional on the manuscript's common positive scalar gaps.
Nothing here establishes their simultaneous existence, the zero-spectrum
theorem, localization, Hilbert-coefficient positivity, or abelianity.

## 1. The unweighted hypotheses really are uniform in S

Let `D=(U x U)/P`, `Omega_S=omega_x+S*omega_y`, `S>=1`, and let
`L=E^*=p_y^*K_M^*` have its fixed metric pulled back from the unscaled
`omega`. There are two distinct unweighted estimates:

1. The `L`-valued `(m,*)` Dolbeault Laplacians have gap at least `delta`.
2. On `L`-valued `(p,0)` forms, `||dbar xi||_0^2 >= delta*||xi||_0^2`.

Both follow from the assumed scalar gaps on `U`, not from a curvature
condition on `L`. For (1), split a form into its `x,y` bidegrees. The
`x` part of its product energy is the scalar `(n,q_x)` energy on `U`,
with the `y` form and line coefficients as fixed multiplicities. Lefschetz
identifies that scalar gap with an assumed `(p_x,0)` gap, after the fixed
normalization already incorporated into `delta`. For (2), the `x` part
uses the original scalar `(p_x,0)` gap. All remaining `y` energies are
nonnegative. Scaling `omega_y` changes the fiber inner products and the
nonnegative `y` energy but not either `x` estimate.

For rigor on the diagonal quotient, choose a measurable fundamental region
for the action on the `y` factor and integrate the invariant lift first
over all `x` in `U`. Tonelli's theorem applies to these nonnegative
energies. The bundle in the `y` variable is constant during the `x`
calculation. This also proves the statement for nonsimple tensors by
local trivialization, density and orthogonal decomposition. The
fundamental-region boundary has measure zero and introduces no integration
by parts in `y`. Invariant lifts in finite orbifold charts give the same
calculation with their usual finite integration factors. Thus no
`S`-dependent elliptic estimate is used in obtaining `delta`.

## 2. Differential domains, exactness, and form cores

Write `H_q^0` and `H_q^h` for the unweighted and weighted Hilbert spaces.
Since `1<=h<=B`,

    ||w||_0^2 <= ||w||_h^2 <= B*||w||_0^2

in every degree. The distributional operator `d_q=dbar` is unchanged.
Membership in its maximal domain requires just that `w` and `d_q w`
are square integrable. Consequently the maximal domains coincide as
sets, and their graph norms are equivalent. The same holds for the
minimal closures, since the initial compactly supported operator is
the same. Kernels and ranges therefore coincide as sets, and a range
closed in one norm is closed in the other.

The unweighted Laplacian gap gives exactness, closed ranges and an
unweighted minimal solution operator `T_q` with

    d_(q-1) T_q eta = eta,
    ||T_q eta||_0^2 <= delta^(-1)*||eta||_0^2        (2.1)

for `eta in ker d_q`, `q>=1`. Here is an elementary Hilbert-complex
argument, so no additional Green-operator regularity is being assumed.
If `u in Dom d_q` is orthogonal to `ker d_q`, it is orthogonal to
`im d_(q-1)`, and thus is in `Dom d_(q-1)^*` with adjoint zero.
The gap gives `||d_q u||_0^2>=delta*||u||_0^2`. Subtracting the
orthogonal projection onto the closed kernel preserves `Dom d_q`.
Hence a Cauchy sequence in `im d_q` has orthogonal minimal lifts
which are Cauchy. Closedness of `d_q` proves that its image is closed.
Now any vector in
`ker d_q intersect (im d_(q-1))^perp` has both differential and
adjoint zero, so the gap makes that vector zero. Thus
`ker d_q=im d_(q-1)`. Applying the same gap to its orthogonal
primitive gives (2.1). At degree zero the preceding image is zero,
so the closed kernel is zero as well.

Norm equivalence now gives weighted exactness and closed ranges without
any assertion about equality of adjoint domains.

Here are the additional form-domain details. Fix the parameters.
Complete lifted metrics admit compactly supported cutoffs tending to one
whose gradients tend uniformly to zero. They may be chosen using
`Omega_1`; their gradient norms for `Omega_S` are no larger. The
commutators of `d`, its weighted formal adjoint, and the Chern
differential with a cutoff are zeroth-order exterior multiplication or
contraction by that gradient. Their pointwise bounds use the same
weighted fiber norm on both sides. Derivatives of `h` do not occur in
these commutators.

Thus cutoff approximation, followed by Friedrichs smoothing on the
resulting compact sets, gives compactly supported smooth sections as
a core for `Dom d intersect Dom d_h^*` in the form norm. The smoothing
step uses smooth coefficients on each compact set, not globally bounded
derivatives of `h`. Finite-chart averaging gives invariant smoothing
on the orbifold. The same cutoff argument proves equality of the
minimal and maximal differentials for either bundle metric. This
justifies the complete-domain integrations below even for bounded
smooth `h` with unbounded derivatives.

## 3. The Bochner inequality and its sign

Let `*` be the complex-linear metric star on form indices, extended
linearly on `L`; it sends `(m,q)` to `(m-q,0)`. This is not the
conjugate-linear bundle-dual star of Section 6 below.

For compactly supported smooth forms the Chern connection satisfies

    (D'_h)^* = +/- * dbar *.

In a holomorphic line frame with squared metric `H`, one has
`D'_h=partial+partial log(H*h)`. The formal weighted adjoint of
`partial` contributes minus contraction by `partial log(H*h)`.
The adjoint of the connection term contributes exactly the opposite
contraction. What remains is the metric-star expression, which is
independent of `h` on the coefficient index. This checks the
cancellation rather than assuming equality of weighted adjoint domains.

The Kahler commutation identities give

    Delta''_h = Delta'_h + [i*Theta_(L,h), Lambda].

For completeness these are local identities, so their use here does
not require a compact-manifold theorem on `D`: in Kahler normal
coordinates and a Chern-normal line frame the first-order identities
`[Lambda,D'']=-i*(D')^*` and
`[Lambda,D']=i*(D'')^*` are the exterior
creation/contraction identities. They are tensorial first-order
identities and hence hold in every chart. Substituting them into the
two Laplacians and using `D'D''+D''D'=Theta` gives the displayed
formula. This is the Bochner--Kodaira--Nakano identity with the
nonnegative Laplacian convention.

To check its curvature contribution without a sign ambiguity, diagonalize
the Hermitian `(1,1)` curvature with eigenvalues `lambda_j` relative to
`Omega_S`. On a form with holomorphic index set `I` and
antiholomorphic index set `J`, the commutator eigenvalue is

    sum_(j in I) lambda_j + sum_(j in J) lambda_j - sum_j lambda_j.

For `I={1,...,m}` this is exactly `sum_(j in J) lambda_j`.
The assumption `lambda_j>=-C0*t` therefore gives a lower bound
`-q*C0*t>=-a`. In particular the curvature assumption is used with
the correct sign, and the constant is independent of `S`.

Since `D'_h eta=0` in holomorphic degree `m`, integration gives

    E_h(eta) + a*||eta||_h^2
       >= ||(D'_h)^* eta||_h^2
       >= ||dbar(*eta)||_0^2
       >= delta*||eta||_0^2.                       (3.1)

The middle step uses `h>=1` and the star isometry. The final step is
estimate (2) of Section 1.

There is no hidden domain assumption in extending (3.1). Approximate
`eta` in the weighted form norm by compactly supported `eta_j`.
The first inequality applied to `eta_j-eta_k` shows that their
Chern-adjoint derivatives are Cauchy. By `h>=1` the unweighted
`dbar(*eta_j)` are also Cauchy. Closedness puts `*eta` in the
unweighted differential domain and gives (3.1) by passage to the
limit. No upper curvature bound, global derivative bound on `h`,
or unweighted-adjoint membership of `eta` is used.

## 4. Direct quadratic comparison for every closed form

Let `0!=eta in ker d_q intersect Dom d_(q-1,h)^*`, `q>=1`.
Take the unweighted minimal primitive `u=T_q eta` from (2.1).
It belongs to the weighted differential domain by Section 2, and

    ||u||_h^2 <= B/delta * ||eta||_0^2.             (4.1)

The defining identity of the weighted Hilbert adjoint gives

    ||eta||_h^2 = <du,eta>_h = <u,d_h^*eta>_h.

This pairing is legitimate with precisely the domains just specified;
it does not require `u` in any adjoint domain. Cauchy--Schwarz,
(4.1), and (3.1) yield

    ||eta||_h^4
      <= ||d_h^*eta||_h^2 * ||u||_h^2
      <= (B/delta^2) * ||d_h^*eta||_h^2
                       * (||d_h^*eta||_h^2 + a*||eta||_h^2).

For `x=||d_h^*eta||_h^2/||eta||_h^2` this is

    x*(x+a) >= delta^2/B.                          (4.2)

In particular `x>0` and `x>=r`. This is stronger than needing (4.2)
only on lower spectral bands. If `eta` is in a nonzero spectral band
of `d d_h^*` up to `mu`, then `0<x<=mu`; since `a>=0`,

    mu*(mu+a) >= delta^2*exp(-b).

Thus the precise manuscript inequality follows, with `C1=m*C0`.

The manuscript's more specific minimal-lift comparison is valid too.
On `B_q`, the already established coarse weighted inverse bound makes
`A=d d_h^*` positive with a bounded inverse. For a vector in its
spectral band `(0,mu]`, bounded spectral support puts that vector in
`Dom A` and hence in the adjoint form domain. Its weighted minimal
primitive is `d_h^* A^(-1) eta` and has squared norm
`<A^(-1)eta,eta>_h>=mu^(-1)*||eta||_h^2`.
Comparing with (4.1) gives
`||eta||_0^2>=delta*B^(-1)*mu^(-1)*||eta||_h^2`,
exactly as claimed. This comparison uses only differential-domain
equivalence, not adjoint-domain equivalence.

The scalar implication from the three inequalities above to (4.2),
quadratic monotonicity, and the reciprocal bound are independently
formalized in `Main.lean`. The applicability of those inequalities
to differential operators is the mathematical proof in Sections 1--4,
not something the scalar formalization checks.

## 5. From coercivity to minimal inverse bounds

On the closed space `B_q=ker d_q=im d_(q-1)`, (4.2) says

    ||d_(q-1,h)^* eta||_h^2 >= r*||eta||_h^2.

It follows that

    ||T_(q,h)|| <= r^(-1/2).

To see this directly, let `V:B_q -> (ker d_(q-1))^perp` be the
already bounded weighted minimal inverse, whose existence and coarse
bound follow from Section 2. For `u` in its target, the adjoint
definition shows `V^*u in Dom d_h^*` and `d_h^*V^*u=u`:
for any `z in Dom d`, one has
`<V^*u,dz>_h=<u,Vdz>_h=<u,z>_h`.
Since `d` maps onto `B_q`, its restricted adjoint has zero kernel.
The coercivity bound applied to `V^*u` gives
`||V^*u||_h<=r^(-1/2)*||u||_h`, whence
`||V||=||V^*||<=r^(-1/2)`. Equivalently `A=d d_h^*>=r`
and `V=d_h^* A^(-1)`. The simpler metric comparison also gives
`||V||<=sqrt(B/delta)`.

To obtain the displayed estimate without losing a parameter, put
`s=delta/sqrt(B)>0`. From `x*(x+a)>=s^2` one has

    1/x <= 1/s + a/s^2.

Indeed, if `x<=s`, then `s^2<=x*(s+a)` by (4.2).
If `x>=s`, that inequality follows from `x*s>=s^2` and `x*a>=0`.
Division by `x*s^2>0` proves the assertion. Consequently

    r^(-1) <= sqrt(B)/delta + a*B/delta^2.

Taking square roots and using `sqrt(u+v)<=sqrt(u)+sqrt(v)`
gives the claimed bound. The case `t=0` is included, with
`r=delta*exp(-b/2)`; the case `b=0` also causes no degeneration.
Only fixed dimension, `C0`, and the initial `delta` enter the final
constant. Large derivatives of `h` affect none of these constants.

## 6. The dual complete complex

Let `J_h` denote the conjugate-linear bundle-metric Serre star for
the full metric on `L`. It maps

    L-valued (m,q), metric multiplier h
      --> E-valued (0,m-q), metric multiplier h^(-1).

It is a pointwise isometry. In a local line frame its coefficient
map is the conjugate coefficient multiplied by the full metric;
the dual squared metric is its reciprocal, proving the norm identity.
Stokes' formula for the wedge pairing gives, with the usual degree
signs, `J_h d_h^* = +/- d J_h` and
`J_h d = +/- d_k^* J_h`. Approximation in the complete-domain cores
of Section 2 extends these equalities to the corresponding closed
domains. The maximal/minimal distinction does not disappear merely
by assertion: completeness and the cutoff argument are what identify
the two extensions.

The reduced inverse of a closed-range operator and that of its
adjoint have equal norms: between the orthogonal complements of
their kernels the inverse maps are Hilbert adjoints, as proved
explicitly in Section 5. Exactness of the reversed adjoint complex
also follows immediately by taking orthogonal complements of
`im d=ker d` and using the closed ranges. Therefore
`J_h` transfers exactness, closed ranges and all the bounds in
Section 5 to the reversed `E`-valued complex. The zero-degree
closed kernel is zero; for a positive-degree closed `F`, its
minimal primitive satisfies exactly the stated estimate.

The domain-sensitive identities are also checked against the primary
source Chakrabarti--Shaw, arXiv:1006.3117v2, Section 2.4, Lemma 2,
and Section 3.1, Proposition 1, with the complete-manifold observation
in Section 3.2 and closed-range Lemma 3. Their general theorem pairs
maximal and minimal extensions. It does NOT allow these to be
identified on an incomplete manifold. The orbifold extension here
is supplied by the invariant-chart proof above, not attributed to
that paper.

## 7. Sharpness in the abstract comparison class only

There is a useful exact check on both the exponent and the signs.
Consider the two-term exact Hilbert complex `C --sqrt(delta)--> C`.
Both unweighted squared norms are the ordinary absolute square.
Give the source weighted squared norm `B*|u|^2` and the target
weighted squared norm `w*|z|^2`, with `1<=w<=B`.
Then

    x = delta*w/B,
    E_h(z) = x*||z||_h^2.

For `0<=a<=delta*(1-1/B)`, take `x=r` and `w=B*r/delta`.
The defining quadratic equation implies
`delta/B<=r<=delta/sqrt(B)`, so `1<=w<=sqrt(B)<=B`.
Then `w*(r+a)=delta`: both comparison inequalities, the
Cauchy--Schwarz step and the final root bound are equalities.

For `a>=delta*(1-1/B)`, take `w=1`, giving `x=delta/B`;
the Bochner-type inequality holds because `delta/B+a>=delta`.
Thus `max(delta/B,r)` is the optimal coercivity bound among
abstract two-norm Hilbert complexes satisfying just these assumptions.
For instance `delta=1,B=16,a=0,w=4` gives `x=1/4` and
minimal inverse norm `2=B^(1/4)`, while the switch point
`a=15/16,w=1` gives `x=1/16`.

These are not geometric realizations with a common scalar bundle
multiplier. They are sharpness witnesses for the abstract proof,
not counterexamples or geometric optimality claims. The exact
rational examples are replayed by `verify.py`.

## 8. Certification boundary

`verify.py` checks exact coefficient identities and rational abstract
examples. `Main.lean` proves universal scalar implications and the
finite-sum curvature bound. Neither program checks the global analytic
argument, so independent mathematical review is required for `C_SWI`.

The cited 2012 Demailly book could not be retrieved from its university
server in this run. No claim is made that its exact locators have
been independently checked. The identities needed here were derived
locally in Section 3 instead. The unrelated and insufficient search
results returned by general web search were not used as mathematical
evidence. The Serre-duality primary PDF was obtained and its actual
domain statements were read.

Replay the exact evidence from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/spectral_weighted_inverse/verify.py
```

For a fresh real compiler run, preserving the source/fidelity pairing:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify \
  research/spectral_weighted_inverse/Main.lean \
  --statement-fidelity research/spectral_weighted_inverse/statement_fidelity.md \
  --artifact-dir research/spectral_weighted_inverse --claim C_SWI_ALG --project-root .
```

No false assertion was identified within this scoped lemma. In particular
there is presently no justified `F_...` refutation claim. The overall
publishable campaign remains open even if the Reviewer accepts this
load-bearing verification.
