# Product gaps and the weighted Bochner estimate

**Assessment:** the stated inequality is supported under the old draft's
geometric and scalar-gap hypotheses. All three old bookkeeping versions are
accounted for. The Demailly citation itself remains unverified; support for
the inequality is the local argument, not an assertion that the citation was
checked.

## Claim, versions and attribution

`L_SWI_BOCHNER@1,@2,@3` all have mathematical subject hash
`b43a7fb5f3200b471f15829b3658453f76d206b38afa2651793716b7e6e0837c`.
They assert, for `L=E^*`-valued `(m,q)` forms in the weighted form domain,

\[
 Q_h(\eta)+mC_0t\|\eta\|_h^2\ge\delta\|\eta\|_0^2, \qquad
 Q_h=\|d\eta\|_h^2+\|d_h^*\eta\|_h^2,
\]

uniformly in `S>=1`, with `m=2n`, `C0,t>=0`, and the other hypotheses in
`../conditional_weighted_inverse/report.md`. Old `proof.md`, Sections 1
and 3, gives the argument; the same inequality is already in manuscript
`spectral.tex:449-465` at reference revision
`4eaee87548250b2682affda7d05d947c05554bae`.

Version 1 has no recorded external assumption. Version 2 adds
`A_DEMAILLY_BKN`, referring to the purported June 21, 2012 book at Chapter VI
Section 6 and Chapter VII Theorems 1.1--1.2, without a checked source
identifier/locator pair. Version 3 retires it, explicitly saying that
Sections 2--3 derive the local identities and domain passage instead.
This is a change in dependency bookkeeping, not a change in the inequality.
The draft's source-status record says the university retrieval timed out;
the staged `references.bib:365-372` confirms what version was cited, not
what that book actually says. No checked-2012-source claim is made here.

## The two uniform product gaps

The original hypotheses are scalar `(p,0)` gaps on `U`, for all degrees.
Kahler Lefschetz powers, normalized by fixed dimensional factors, commute
with the scalar Laplacian and identify `(p,0)` with `(n,n-p)`.
Thus a common fixed `delta` works for scalar `(n,q_x)` as well.

On `U x U`, split an `L`-valued `(m,q)` form by its `x,y` degrees.
Its `x` holomorphic degree is `n`; its `y` form and line coefficients are
fixed Hilbert multiplicities when differentiating in `x`. The Dolbeault
product Laplacian splits into its nonnegative `x` and `y` parts, so the
scalar `x` gap supplies the `(m,*)` gap. On total `(p,0)` forms the same
calculation instead uses the original `(p_x,0)` gaps.

This applies on the diagonal quotient by integrating an invariant lift over
all `x` with `y` in a measurable deck fundamental region. Partial energies
are nonnegative; Tonelli and density justify fiberwise estimates. The
product splitting is an identity of the quotient differential operators;
it does not require integration by parts across an artificially introduced
fundamental-region boundary. Finite orbifold charts introduce the same
finite integration factors on both sides.

Scaling the `y` metric changes the multiplicity inner products, measure and
nonnegative `y` energy, but not the `x` estimate. The line bundle is pulled
back from `y` with a fixed unscaled coefficient metric. This proves the
needed uniformity without an `S`-uniform elliptic estimate for a degenerating
family of coordinate coefficients.

## Local adjoint cancellation and curvature sign

Work first on compactly supported smooth forms. In a holomorphic line frame
write the squared coefficient metric as `G=G0*h`. The Chern differential is
`D'_h=partial+partial log G wedge`. Integration by parts in the coefficient
weight contributes the negative contraction by
`barpartial log G` to the formal adjoint of `partial`. The adjoint of the
connection term is exactly the positive contraction by that covector.
They cancel. The remaining base-form-metric operator is

\[
 (D'_h)^*=\mathord{\pm} *_S\bar\partial *_S,
\]

where `*_S` is the **complex-linear, form-index-only** metric star taking
`(m,q)` to `(m-q,0)`. This is not the bundle-dual Serre star. This calculation
explains why derivatives of `h` do not appear in the estimate; it does not
assert equality of two Hilbert-adjoint domains.

In Kahler normal coordinates and a Chern-normal line frame, the
creation/contraction calculation gives
`[Lambda,D'']=-i(D')^*` and `[Lambda,D']=i(D'')^*`.
Using the connection-curvature identity in their commutators gives

\[
 \Delta''_h=\Delta'_h+[i\Theta_{L,h},\Lambda].
\]

These are local differential identities, not an application of an
unexamined compact-manifold theorem on a noncompact quotient.
For curvature eigenvalues `lambda_j` relative to `Omega_S`, the commutator
on index sets `I,J` has eigenvalue

\[
 \sum_{j\in I}\lambda_j+\sum_{j\in J}\lambda_j-\sum_j\lambda_j.
\]

For top holomorphic degree this is `sum_(j in J) lambda_j`.
The curvature hypothesis therefore bounds it below by
`-q*C0*t >= -m*C0*t`. In particular the lower curvature hypothesis is not
used with its sign reversed. The exact four-state wedge/contraction replay
in the scalar unit confirms this algebraic sign, but is not itself a proof
of these differential identities.

Since `D'_h eta=0` at top holomorphic degree, integration gives, with
`a=m*C0*t`,

\[
 Q_h(\eta)+a\|\eta\|_h^2
 \ge\|(D'_h)^*\eta\|_h^2
 \ge\|\bar\partial(*_S\eta)\|_0^2
 \ge\delta\|\eta\|_0^2.
\]

The middle inequality drops `h>=1`. The last uses the separate `(p,0)`
gap and the star isometry. There is no unnecessary `B=exp(b)` loss in this
step, an important distinction from the coarse norm-equivalence estimate.
At `q=0` the curvature sum is zero; no endpoint sign exception is needed.

## Passage to the complete form domain

The core result assessed in `../complete_domains/report.md` gives smooth
compact-support approximants in the weighted form norm, for each fixed
parameter choice. Applying the first inequality above to differences of
approximants makes their Chern-adjoint derivatives Cauchy in the weighted
norm. Since `h>=1`, their unweighted `barpartial(*_S eta)` derivatives
are Cauchy too. Local distributional closedness identifies the limits and
passes the inequality to the asserted domain.

This avoids assuming that an unbounded curvature operator acts in `L^2`
on the limiting form, that the curvature has an upper bound, or that
`eta` belongs to the unweighted adjoint domain. A lower curvature bound
and a form-core limit suffice.

## History reconciliation and disposition

The old Reviewer record
`judgement-L_SWI_BOCHNER-639471ed0ad5` supports the same mathematical hash
and `proof.md` path. Since all three versions share that hash, the judgement
does **not** distinguish which Demailly-assumption history was inspected.
The graph's pending-review label also does not settle that question.
The present assessment checks the actual local derivation and explicitly
keeps the unverified book attribution separate.

No internal sign, multiplier-derivative, domain or `S`-uniformity gap was
identified under the stated assumptions. The result is a reproduction of
the manuscript estimate using standard Kahler identities, not a new analytic
theorem. The local derivation is human-checked, not formalized by the scalar
Lean declarations. A verified reading of the precise 2012 Demailly locators
has not been supplied by this review and is not a hidden active assumption. Existence of the
scalar gaps is explicitly assumed; no downstream theorem is assessed.
Native independent review of these findings remains pending.
