# Statement fidelity: QuotientUniform

The source is `research/quotient_uniform/Main.lean`, namespace
`QuotientUniform`, using Lean 4.31.0 and the host's built Mathlib.
The ledger claim `Q_FORMAL_CORE` is exactly the collection described below,
**not** the complete obstruction `Q_OBSTRUCTION`.

## Noncommutative block sums

`shifted_cartesian_sum` quantifies over arbitrary finite additive groups
`A,B` and an arbitrary possibly noncommutative semiring `R`. It proves
that summing `L(a+v)*T(b+u)` equals the product of the two unshifted
sums, in that order. `coordinate_block_factorization` additionally
quantifies over a bijection from arbitrary finite labels to `A × B`,
row/column index types, and opposite-index shifts. Its conclusion is
pointwise in an arbitrary row and column, so it proves the entire
block-matrix identity when `R` is a matrix ring. Applying it with
`L=U(L_group^-1)` and `T=U(R_group)` is the manuscript's factorization.
No commutation or bound on the characteristic is assumed.

## Regular permutations and integer trace expansions

`regular g` is the integer matrix with row `x`, column `y` entry
`[x=g*y]`, for every element of an arbitrary finite group `G`.
`regular_mul`, `regular_transpose`, and `regular_trace` prove its
homomorphism law, inverse-transpose law, and fixed-point trace formula.
`rectangle_trace` carries the exact multiplication order
`a*b^-1*c*d^-1`. `first_trace_sum` proves the first expanded trace sum.
`rectangle_trace_degeneracy` and `second_trace_sum` assume only that
all nondegenerate rectangular group words are nonidentity, and prove
the second expanded sum is `(2*r^3-r^2)*card G` in the integers.
The array size `r` is any natural number, including zero.

The source proves these **expanded sums of traces of regular matrix
products**. Identification of those sums with the traces of the full
Gram block matrix is by the entrywise expansion in `proof.md`, not an
additional formal declaration.

## Actual interpolation weights and tensor assembly

`lagrange` constructs the univariate product on `S.erase a`.
`lagrange_eval_self`, `lagrange_eval_other`, and `lagrange_degree`
prove its grid evaluations and degree bound. `onLine`, `gridEval`,
`linePoint`, and `gridOnLine` construct the coordinate product and
its restrictions to affine lines. Their evaluation and degree
theorems do not assume an interpolation certificate.

For any finite field `F`, `polynomial_sum_zero` proves the sum of
evaluations vanishes when the polynomial's natural degree is less
than `card F - 1`. It uses the library's kernel-proved
`FiniteField.sum_pow_lt_card_sub_one`, not a numerical experiment.
`punctured_polynomial_sum` deletes precisely parameter zero.

`gridEval_delta`, `punctured_grid_weight`, and
`punctured_grid_weight_line` quantify over arbitrary dimensions `h`,
finite `S`, injective grid marks, and the explicit bound
`2*h*(S.card-1)<card F-1`. The line version additionally requires a
nonzero direction coordinate. `gridWeight` is the actual outer product
of the constructed grid polynomials, not an unspecified weight.
`linePoint_injective` proves that nonzero directions enumerate lines
without multiplicity. `puncturedLine` is the image of all field
parameters except zero; other marks on the same line are not removed.

`incidence_exchange` proves finite-sum exchange over an arbitrary ring.
`weighted_tensor_identity` proves the negative diagonal identity from
specified line sums. Most importantly,
`interpolation_tensor_identity` discharges those line-sum premises
using the constructed grid weights and punctured lines. It quantifies
over every family `Y` of matrices, with arbitrary row and column types;
no triangle relation or rank conclusion is assumed. The right-hand
matrix has row `(label,row)` and column `(label,column)`, and is the
negative direct sum of `Y`. Its indexing is the transpose of the pair
order used by Mathlib's ordinary `Matrix.blockDiagonal`, not a sign
or orientation change.

This formal interpolation theorem is stronger in field scope than the
manuscript: `F` may be any finite field. Applying it to the prime field
requires the manuscript's displayed degree bound.

## Finite-product quantifier

`finite_product_quantifier` quantifies over any group `G` and finite
index type `I` in a common universe. If every homomorphism to a finite
group kills some `w i`, it proves that one fixed `w i` is killed by
every such homomorphism. It constructs the product of the hypothetical
separating maps. It does not assume that `w i` are nonidentity in `G`.
The passage from finite quotients to finite homomorphisms uses their
finite images, as proved in `proof.md`.

## Deliberate boundary

No declaration formalizes the real-rank trace inequality, Hadamard's
inequality, divisibility of integer minors, rank under reduction, tensor
rank estimates, or the final budget contradiction. Those are proved in
`proof.md` and must be independently read. The Lean result certifies a
substantive universal algebraic core, not only a numerical implication,
and must not be relabelled as a kernel proof of the whole manuscript.
Incidence existence, geometric nontriviality, hyperbolicity, novelty,
publishability, and independent Reviewer approval are not conclusions
of these declarations.
