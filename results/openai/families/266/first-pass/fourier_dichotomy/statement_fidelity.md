# Formal statement fidelity

This file describes `Main.lean`, namespace `FourierDichotomy`, for claim
`C_CONTRACTION_BRIDGE`. It does not assert a Lean formalization of the entire
Hadamard dichotomy or of the rational identity certificate.

`occupied_unused_split` quantifies over every subset `used` of the six labels,
every complex function `f` on these labels, and every complex multiplier `M`.
Its hypothesis is the complex orthogonality identity `sum f = 0`. Its conclusion
is that the unused-label sum of `M*f` is the negative of its occupied-label sum.
There is no probability assumption in this finite-sum theorem.

`unusedAverage` divides the unused-label sum by the natural-number count
`6 - used.card`. `normalized_order_one_contraction` requires `used.card < 6`,
so this denominator is nonzero, and proves the corresponding normalized
contraction with coefficient `6 - used.card`. `normalized_real_contraction`
proves its real-part version with the same coefficient.

To apply these statements to a manuscript order-one exponent row, take
`f(t) = K(t,c_plus) * conjugate(K(t,c_minus))`, for distinct sampled columns,
and take `M` to be the product from all other exponent rows. Column
orthogonality supplies `sum f = 0`. With `p-1` other rows injectively assigned,
the coefficient is `6-(p-1) = 7-p`. The conversion from conditional finite sums
to the manuscript's uniformly averaged injective moments, including the
marginal uniformity after merging rows, is proved in the mathematical report,
not encoded in Lean.

`seven_row_boundary` states that the occupied sum is zero when all six labels
are used. It neither defines a seven-row injective moment nor divides by zero.
Its six summands correspond to the six merged exponent matrices in the report.
The identification of those summands with their exponent monomials is again
the mathematical-to-computational bridge outside Lean.

`nonnegative_sums_vanish` quantifies over any finite type and any two
nonnegative real functions `u,v`. From `3*sum u + sum v = 0` it proves that
every value of both functions is zero. `pointwise_products_from_certificate`
specializes this to complex squared norms and proves, at every index, that
`L=0` and `A=0 or B=0`. For the manuscript take the index type to be the two
orientations times the row permutations, multiply the average identity by
1440, and use `A=g(alpha)` and `B=g(q)`. No connection between the symbols
`L,A,B` and an actual matrix is postulated or proved in Lean; that connection
is explicit in `verify.py` and the report.

The source uses no axioms beyond Lean/Mathlib's standard foundations and no
proof holes. The compiler result, rather than this document, determines
whether the file actually checks. Statement fidelity still requires
independent human mathematical review.
