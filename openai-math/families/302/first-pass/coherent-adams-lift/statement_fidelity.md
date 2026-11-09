# Statement fidelity and evidence boundary

The target is Proposition `prop:compatible-adams-lift` in the staged
September 25, 2026 companion manuscript, `build/sections/02-filtered-products.tex`.
Here a commutative ring spectrum is an E-infinity ring spectrum under the
sphere. Its unit fiber is `I_R = fib(S -> R)`; the map from its n-fold smash
power to the sphere is the smash of the n fiber inclusions.

The mathematical assertion to be proved is the following. For every pointed
CW inclusion `G -> E`, every commutative ring spectrum R, every integer d,
every stable map `v : Sigma^infinity E -> Sigma^d S`, and every pair of
integers `1 <= n <= ell`, suppose the restriction of the unit composite of
v to G is nullhomotopic. Then the restriction of the ell-fold smash of v
to the entire subspace of `E^smash ell` having at least n coordinates in G
factors, in spectra, through `Sigma^(d ell) I_R^smash n`. No connectivity,
localization, flatness, or parity hypothesis is imposed. The original
proposition additionally assumes the CW pair finite. Dropping finiteness
is a stated extension, not a change to the original assertion.

The conclusion is existence of one lift on the union, with a homotopy
identifying its composite with the restricted smash power. It is not just
existence of a lift separately on each product subspace. Neither uniqueness
of the lift nor equivariance under permutations of the factors is asserted.
A nullhomotopy of the R-valued restriction can be chosen once for the proof.

The proof must construct a null morphism in the functor category on the
full truncated simplex category before restricting its cone to the punctured
unit cube. Objectwise zero homotopy classes would not suffice.

Executable evidence will be explicitly separated from the spectral argument.
A finite chain-complex computation cannot certify this assertion about all
ring spectra. Any arithmetic or combinatorial certificate accompanying the
proof is evidence only for the precise parameter identities it checks.
Independent mathematical review of the functor-category and total-fiber
arguments remains required.

## Lean claim C_SLICE_CORE

`Main.lean` imports Mathlib in Lean 4.31.0 and uses the namespace
`CoherentAdams`. Its definition `overlap a b l u` is the real number
`max 0 (min b u - max a l)`. The following declarations are the
formalized, load-bearing parameter core:

- `overlap_split`: for all five real inputs with `a <= b <= c`
  and `l <= u`, overlap is additive across the break b.
- `overlap_telescope`: for every monotone sequence of real endpoints,
  every interval with `l <= u`, and every natural k, the sum of k
  adjacent overlaps is the overlap of their combined interval.
- `overlap_unit`: for `0 <= l <= u <= 1`, overlap with `[0,1]`
  is exactly `u-l`.
- `overlap_positive_endpoints`: strictly positive overlap forces
  `l < b` and `a < u`, for arbitrary real inputs.
- `two_positive_intervals_give_break`: if the first interval's right
  endpoint b is at most the second interval's left endpoint c, and
  both overlaps with the same slice are positive, then `l < b < u`.
- `slice_break_count`: for arbitrary naturals j and ell, a family
  of j real breaks and ell ordered slices with `hi r <= lo t`
  whenever `r<t`, every finite set of slices each containing a
  break in its strict interior has cardinality at most j. This
  is stronger than the equal-width instance used in the proof.
  No existence of a break for an empty slice is assumed.
- `restricted_factor_hits_vertex`: for arbitrary naturals ell,j,n,
  if a finite restricted-coordinate set has size at least n, the
  bad-coordinate set has size at most j, and `j<n`, some restricted
  coordinate is outside the bad set.

The two auxiliary declarations `overlap_nonneg` and `overlap_self`
state the indicated elementary properties without extra hypotheses.
All quantifiers are universal and all finite sets use distinct
indices; repeated real break values are allowed.

The source does not define or formalize the simplex category,
continuity, natural transformations, spectra, CW spaces, stable maps,
the mapping-space adjunction, or a coherent null cone. The formalized
real identities and finite cardinal arguments enter Section 1 of
`proof.md`; Sections 2-4 are a general mathematical proof, not a
Lean proof. A compiler success on C_SLICE_CORE must not be attached
to C_COHERENT_ADAMS_LIFT as though the spectral theorem had been
encoded in Lean.
