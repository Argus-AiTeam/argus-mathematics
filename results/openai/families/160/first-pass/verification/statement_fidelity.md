# Statement fidelity: ReturnPatternCore

The claim `C160_FORMAL_CORE` is about the declarations in `Main.lean`,
not about a formalization of the full manuscript or of all circle-partition
geometry in the accompanying proof. All variables below are universally
quantified, with no bound on a dilation, translation, mesh width, or period.

`anchor_range` proves the closed enclosing range for
`a + shift + c*b` when `a` belongs to an interval of width `width`,
`|b| <= radius`, and `|c| <= 1`. Its conclusion includes both
endpoints. `shift` is an arbitrary real number: this is the step removing
dependence on the size of the rational translation and hence on lambda.
Replacing a half-open anchor by its closure only enlarges the range.

`integer_zero_of_abs_lt_one`, `unique_integer_lift`, and
`unwrap_integer_difference` prove, respectively, integer discreteness,
uniqueness of a lift of one circle endpoint in a closed interval of length
less than one, and exact unwrapping of two congruent reals whose difference
has absolute value less than one. The congruence in the last theorem is
the explicit integer equation `a-b=z`, not an assumed equality.

`radius_width_transfer` proves
`w1 >= w0/8 - H*distance/4` from `H >= 0`,
`w0 <= 2H*r0`, `w1 >= H*r1/4`, and `r0-r1 <= distance`.
No positive lower bound on `w0` is assumed.
`neighborhood_width` adds `H <= 1/8`, `w0 >= 0`, and
`distance <= 2w0` to prove `w1 >= w0/16`.
These are actual implications from mesh inequalities, not assumed
neighbor-comparability or eligibility statements.

`stationary_transfer` proves `drift <= w1` if
`distance <= drift` and `(8+2H)*drift <= w0`, with the same radius
and width hypotheses. `stationary_relative_transfer` derives that budget
from `drift <= mu*w0`, `w0 >= 0`, and `mu*(8+2H) <= 1`.
`uniform_stationary_budget` proves the last inequality for
`0 <= mu <= 4/33` and `H <= 1/8`.
`stationary_metric_transfer` expresses the first implication in an arbitrary
pseudometric space, using the explicit Lipschitz comparison
`|radius x-radius y| <= dist x y`. For the application, the space is the
circle, `radius = rho+alpha`, `width` is the width of the containing mesh
interval, and `drift = |v_i|`. The formal theorem does not require the
anchor to be regular, to avoid a representative cut, or to be an interior
point of its interval. The accompanying proof, not Lean, identifies the
manuscript's objects with these data.

`spacing_span` telescopes adjacent lower spacing bounds along an arbitrary
finite real sequence. `closed_grid_cardinality` proves that `n+1` such
points in a closed interval of length `length`, separated by at least
`1/period` for a positive real `period`, satisfy
`n+1 <= length*period+1`. The circle-to-line lift of points of a short
closed arc is justified in the report, not encoded in this declaration.
`regular_fraction` proves the strict numerical union-bound estimate
`1/250+1/D < 1/2` for every integer `D >= 3`.
`truncation_budget` proves the stated breakpoint-budget absorption.

`planar_face_recurrence` solves the recurrence
`F(0) <= 1`, `F(s+1) <= F(s)+4s+2` for an arbitrary natural-valued
function. The geometrical assertion that planar sign faces satisfy this
recurrence is proved in the report; it is not an implicit Lean hypothesis
claiming the desired number of sign vectors.
`scalar_entropy_constant` and `anchored_entropy_absorption` prove the exact
polynomial and power inequalities giving the absolute counting constant
801 for every pair of positive integers `D,h`.

The compiler certifies these real/integer/natural-number and metric
implications. It does not certify the exponential mesh construction,
the planar face interpretation, the pattern decoder, the closest-return
torus argument, or the choice of a prime and q. Those are supplied as
self-contained mathematical proofs for independent review. There is no
claim that a numerical sample or these implications alone is a formal
verification of `count:local`, `dichotomy:main`, or the final main theorem.
