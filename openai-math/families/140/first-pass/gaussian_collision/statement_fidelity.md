# Statement fidelity: exact Gaussian collisions and finite-measure moments

## Claim and mathematical scope

Claim `GC_EXACT_VERIFICATION` is the conjunction of the exact Gaussian
collision identity, its coincident-tuple normalization, and the finite-measure
smoothing moment identity and bound described below. The source is
`Main.lean`, namespace `GaussianCollision`. The principal declarations are
`manuscript_gaussian_identity`, `coincident_collision_rpow`,
`smoothing_moment_rpow`, and `smoothing_mass_bound`. This is a verification of
an existing manuscript identity, not a novelty claim or a formalization of
the full memory-sample lower bound.

The manuscript target is `h:proj:gaussian` and the moment expansion in
`h:dv:gaussian-moment` in the September 27, 2026 staged version of *Memory
and precision in noiseless Gaussian regression*, `build/sections/projection.tex`.

## Objects and measures

The finite index types `tau`, `rho`, and `iota` in the mathematical reading
are the Lean parameters `τ`, `ρ`, and `ι`. Their cardinalities are input
dimension d, output dimension m, and q = k-1. Their real function spaces
carry the usual coordinate topology and Borel measurable structure.
`volume` is coordinate Lebesgue measure. Functions `τ -> R` represent
vectors; `ρ -> τ -> R` represents a matrix whose rows are indexed by `ρ`.

`gaussianPi τ` is literally the finite product of the probability measures
`ProbabilityTheory.gaussianReal 0 1`. `gaussianRows ρ τ` is literally the
product, over `ρ`, of `gaussianPi τ`. Thus all matrix entries are
independent N(0,1), and the law on the left side is not an abstract
measure assumed to have the desired collision property.

The real parameter v is the variance, not the standard deviation.
For v > 0, `phi v x` is

    exp(-x^2/(2v)) / sqrt(2*pi*v).

`phiVec v y` is the coordinate product of these scalar densities, hence
the normalized N(0,v I_m) Lebesgue density. `phi_eq_gaussianPDFReal` and
`integral_phiVec` identify this normalization with Mathlib's actual
Gaussian density and prove its integral is one. `project A t` is ordinary
matrix multiplication in row-dot-product notation.

`differences z t` is the d by q matrix D with entries `t i j - z j`.
`ones` has every entry one, `noiseBase` is I_q + 11^T, and
`covariance v D` is exactly D^T D + v(I_q + 11^T).
No column independence, distinctness, injectivity, or rank condition
is present in any of the collision or smoothing theorems.

## Literal collision identity and boundary normalization

`manuscript_gaussian_identity` quantifies over every natural d, m, q,
every real delta > 0, and every tuple
`t : Fin (q+1) -> Fin d -> R`. Its left side is the actual iterated
Lebesgue integral and Gaussian expectation of the product of q+1
densities `phiVec (delta^2) (y - project A (t i))`. Its right side is

    (2*pi)^(-m*q/2)
      * det(D^T D + delta^2(I_q + 11^T))^(-m/2).

Exponents here are real powers, not natural-number division.
For the requested d,m >= 1 and k >= 2 take q = k-1. The source actually
allows zero-dimensional coordinate sets and q = 0 as well; this extends,
and does not restrict, the requested quantifiers.
`gaussian_difference_identity_rpow` is the same result for arbitrary
finite decidable index types with one tuple point supplied as the anchor.
The wrapper uses the exact full product over `Fin (q+1)`.

`covariance_posDef` proves strict positive definiteness from v > 0
for every rectangular D. In particular, repeated points and q > d
do not require a separate limiting argument. `determinant_relation`
proves the exact determinant reduction used in the integral evaluation.

`coincident_collision_rpow` proves, for every anchor and every v > 0,
the exact value

    (q+1)^(-m/2) * (2*pi*v)^(-m*q/2)

when all q+1 points coincide. Thus the factor k^(-m/2) at D = 0 is
formally present for all parameters, not inferred from finitely many
examples. `coincident_collision` is the equivalent square-root form.

## Finite-measure moment and mass bound

`smooth v mu A y` is the ordinary real integral of
`phiVec v (y - project A s)` against mu. The measure parameter is any
`Measure (τ -> R)` with `IsFiniteMeasure mu`: it is nonnegative by
the type of a measure, but is not assumed to be a probability measure,
nonzero, compactly supported, atomless, or absolutely continuous.

For every natural q, v > 0, and finite mu,
`smoothing_moment_rpow` proves

    integral_(A,y) smooth(v,mu,A,y)^(q+1)
      = (2*pi)^(-m*q/2)
        * integral_(s_0,...,s_q)
            det(D^T D + v(I_q + 11^T))^(-m/2) dmu^(q+1).

The left side uses the product of `gaussianRows ρ τ` and Lebesgue
measure. The right side uses literally
`Measure.pi (fun _ : Fin (q+1) => mu)`. No conditional distribution
or normalized version of mu is substituted. For the manuscript
integer p >= 2 take q = p-1.

`smoothing_moment` first proves the equality for nonnegative extended
integrals. `smoothing_mass_bound` proves that this moment is at most

    ((sqrt(2*pi*v)^(-q) / sqrt(q+1))^m) * mu(univ)^(q+1).

Its extended-real formulation uses `ENNReal.ofReal` for the displayed
finite real constant and the actual extended-real mass of mu.
`smoothing_moment_finite` and `integrable_smoothing_power` prove
finiteness and ordinary real integrability, respectively.
`integrable_moment_kernel` proves integrability on the tuple side.
`smoothing_moment_real` and `smoothing_moment_rpow` therefore do not
rely on the convention that a nonintegrable Bochner integral is zero.
Zero measure and measures of arbitrary finite mass are covered by
these quantifiers without additional cases or hypotheses.

## Proof dependencies and limitations

`gaussian_integral` proves the positive-definite multivariate Gaussian
integral using the matrix square root, the actual Lebesgue
change-of-variables theorem, and Mathlib's scalar `integral_gaussian`.
`gaussianPi_density` and `gaussianPi_density_formula` establish the
normalized density of the actual product Gaussian law.
`scalar_collision`, `gaussian_laplace`, `row_collision`, translation,
and finite-product integration then give the collision identity.
`smoothing_power_expansion` and nonnegative Tonelli give the moment.
No desired collision identity is a hypothesis, imported upstream
manuscript theorem, custom axiom, or placeholder.

The stochastic auxiliary vector of Gaussian differences is explained
in the mathematical report but is not separately encoded as a random
variable with a certified covariance law: the formal proof bypasses
that density-at-zero route by direct integration. The actual Gaussian
measure and integral equality are nevertheless formalized as above.

The manuscript's ambient-growth Gram integral estimate, the uniform
in-delta B^p bound obtained from that estimate, the compact-test
duality argument for the unsmoothed exact-label density, and the final
memory-sample lower bound are not formalized in this file. The report
states their relationship to the certified identity. In particular,
the delta-dependent mass bound proved here must not be relabeled as
the manuscript's uniform-in-delta ambient-growth bound.

Lean compilation verifies the encoded propositions and their proof
dependencies, not the correctness of this reading or mathematical
novelty. Independent Reviewer confirmation of statement fidelity and
the bounded mission remains required.
