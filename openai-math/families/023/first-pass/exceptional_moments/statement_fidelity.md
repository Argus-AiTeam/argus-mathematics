# Statement fidelity: universal exceptional-moment exponents

`Main.lean` formalizes the finite combinatorial and real-exponent core of
the proof of Proposition `prop:dual`, not Poisson summation, a Hecke
functional equation, an asymptotic large sieve, or the prime asymptotic.
Those analytic bridges are proved in `report.md`, conditional on the
published inputs explicitly recorded in the ledger.

The index type `I` is an arbitrary finite type, with no bound on its
cardinality and no assumption that its positive entries have a minimum
size. All lengths `a i`, values `v i`, defects `d i`, and the row exponent
`r` are real numbers. Lengths are nonnegative and sum to one. Value
exponents may be negative. `weight k x` is the finite sum of
`(k i : Real) * x i`, for arbitrary nonnegative integer multiplicities.
The zero-length boundary is retained.

`extremal_forcing` assumes every length is strictly less than one, the
unsaved lower bound `2/3 - 2 sum d <= r`, and **all** cubic multiplicity
inequalities of total length in `[1/2,2]`. It proves every defect is zero
and `r = 2/3`. No extremality conclusion is assumed. The defects used by
`first_endpoint_impossible` are exactly `v i - (5/6) * a i`, and
`weight_defect` verifies that the raw repeated-factor sieve inequalities
translate to these defect inequalities.

`positive_short` proves that a length simplex with every entry below
one has a positive entry at most `1/2`. `multiple_in_uniform_interval`
constructs a natural-number multiplicity for **every** real
`0 < a <= 1/2`; its product belongs to `[7/5,19/10)`. This is not a
finite sample or an assumed existence statement.

`uniform_gram_gap` proves throughout the closed interval `[7/5,19/10]`
that the maximum of the diagonal exponent `z - 2/3` and the
off-diagonal exponent
`(z + max 1 (2 - 2*z/3) - 2/3)/2`
is at most `2*z/3 - 1/30`. Both sides of the switch at `z = 3/2` are
covered. `interval_gap_optimal` proves that `1/30` is the largest common
gap obtainable with a covering interval of width at least `1/2` using
these two affine endpoint constraints. It does not claim optimality of
the analytic moment saving in the proposition.

`first_endpoint_impossible` combines the unsaved lower bound, every raw
cubic repeated-factor moment inequality, and the actual Gram
exponent inequality for single-factor copies, to prove `False`.
The Gram hypothesis is the necessary exponent inequality for an
unsaved set of rows after the independently derived squared
off-diagonal estimate and finite Hilbert-space argument. It does not
assume the desired power saving, nor does it assume `d = 0` or
`r = 2/3`.

`second_endpoint_forcing` proves `r = 2/3` and `sum v = 5/6` from
cardinality, the fourth-moment inequality, and the unsaved lower bound.
`exists_high_value` proves, rather than assumes, that some positive
length has value at least five sixths of that length.
`second_endpoint_impossible` uses the ordinary sieve on the full product
with this factor repeated. `ordinary_interior_gap` covers every real
`1 < z < 2`, including both branches of its maximum.

`firstFullUpper` and `secondFullUpper` encode the upper exponents after
the full-sum functional equation, with height at most `Y^(37/100)`,
the other factors bounded trivially, conductor exponent respectively
`1` and `2/3`, and dual length exponent `87/50 - a` in the first
configuration. `dominant_full_first` proves a gap at least `9/100`
for `19/20 <= a <= 1`; `dominant_full_second` proves a gap at least
`4/25` for `a >= 19/20`. These are numerical consequences of the
analytic full-sum bounds, not formal proofs of that functional equation.

`first_endpoint_universal` and `second_endpoint_universal` remove the
strict `a i < 1` assumption: if a factor has length exponent exactly
one, the unsaved moment would require `7/3 <= firstFullUpper (a i)`
or `7/3 <= secondFullUpper (a i)`, respectively, contradicted by the
proved dominant-full bounds. Otherwise the all-interior theorem applies.
The second endpoint also has the faithful trivial value bounds
`v i <= a i`. Empty index types are included but cannot satisfy
`sum a = 1`.

The formalization does not assert that every abstract exponent vector
is realized by arithmetic polynomials. It proves that **none** can
satisfy all the necessary inequalities of an unsaved contribution.
The passage from the actual independently weighted prime sums to those
inequalities, nonprincipality, missing Euler factors, common Mellin
shifts, coefficient independence, and the compactness argument for fixed
positive neighborhoods and savings remain prose obligations. They must
be independently reviewed; compiler acceptance alone does not close
`C_DUAL` or certify the full first-moment theorem.
