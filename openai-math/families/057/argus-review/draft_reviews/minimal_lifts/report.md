# Minimal lifts and nonzero lower spectral bands

**Assessment:** `L_SWI_LIFTS@1` is supported under its stated closed-complex,
gap and norm-comparison hypotheses. The direction of its comparison is
correct. This is neither a new theorem nor a refutation.

## Exact claim and source

The old subject hash is
`d8095a59724ddc0f6098019684f683129a6627f207ebfac11d0a43a9acf191c8`.
The claim concerns `A=dd_h^*` on the closed space
`B_q=im d_(q-1)=ker d_q`, for `q>=1`. For every nonzero vector `eta`
in a spectral band `(0,mu]`, `mu>0`, it asserts

\[
 \|\eta\|_0^2\ge
 \delta\,e^{-b}\mu^{-1}\|\eta\|_h^2.
\]

Its argument is old `proof.md` Section 4, using the existence/coarse inverse
from Section 2. The manuscript already gives this minimal-lift comparison
in `spectral.tex:467-478`; the staged source matches existing reference
revision `4eaee87548250b2682affda7d05d947c05554bae`.
Attribution belongs to that manuscript argument, reproduced and expanded
by the old Argus draft. Novelty was not claimed.

## The two lifts and the spectral calculation

Write `B=exp(b)>=1`. The domain unit establishes exactness and closed
ranges, and an unweighted minimal primitive `T_0 eta` satisfying

\[
 dT_0\eta=\eta,\qquad
 \|T_0\eta\|_0^2\le\delta^{-1}\|\eta\|_0^2.
\]

Bounded metric comparison makes it an admissible **weighted differential**
domain primitive and gives

\[
 \|T_0\eta\|_h^2\le (B/\delta)\|\eta\|_0^2. \tag{1}
\]

Let `V` be the weighted minimal inverse. It is already bounded, independently
of the improved quadratic estimate, by the coarse norm-equivalence bound.
On the source complement of `ker d`, `d` is bijective onto `B_q`;
its closed-range adjoint is the reverse bijection. Thus `A=dd_h^*` is the
positive self-adjoint operator associated to the restricted adjoint form,
and `A^(-1)=V^*V` is bounded on `B_q`. In particular

\[
 \|V\eta\|_h^2=\langle A^{-1}\eta,\eta\rangle_h. \tag{2}
\]

For a vector in `(0,mu]`, spectral calculus bounds `A^(-1)` below by
`1/mu` on that subspace. Bounded spectral support also puts the vector in
`Dom A`, and hence the required adjoint form domain. Formula (2) gives
`||V eta||_h^2>=mu^(-1)||eta||_h^2`.

Minimality means `||V eta||_h<=||T_0 eta||_h`, not the reverse.
Combining that fact with (1)--(2) yields exactly

\[
 \mu^{-1}\|\eta\|_h^2
 \le\|V\eta\|_h^2
 \le(B/\delta)\|\eta\|_0^2,
\]

which is the asserted comparison. There is no use of weighted/unweighted
adjoint-domain equality, no assumption of discrete spectrum and no need
to choose an eigenvector. The qualification **nonzero** band matters:
an empty spectral subspace imposes no inequality on an arbitrary cutoff
`mu`. The proof applies to continuous spectrum as well.

The improved Bochner/quadratic bound is not used to obtain this coarse
inverse or its bounded `A^(-1)`. The lift proof is therefore not circular.
Nor does it require an unweighted primitive to lie in the weighted adjoint
domain. Its differential-domain membership is enough.

## Direct alternative and assessment boundary

The old draft also pairs any closed adjoint-domain form with `T_0 eta`
directly and obtains the same quadratic estimate without a spectral band.
That is assessed under `quantitative_refinements`; it does not mean this
specific band inequality was derived for arbitrary vectors with an
arbitrarily assigned `mu`. The original band argument remains valid in
its own scope.

The old Reviewer-support record
`judgement-L_SWI_LIFTS-8cd42ce70c44` names this exact subject and shared
`proof.md`. The graph still says review pending; neither administrative
label replaces the calculation above. The current old proof matches its
preserved snapshot core record, but its historical prose judgement does
not itself carry an artifact-byte archive.

No unresolved lift or spectral-domain gap was identified within the
stated assumptions. Actual exactness, completeness and unweighted gaps
are supplied/assumed by the separate analytic units. The scalar Lean
proof is compatible with the numerical inequality but does not formalize
minimal lifts, spectral projections or `dd_h^*`. Native independent review
of this assessment remains pending.
