# Statement fidelity: scalar coefficient finite core

The source is `Main.lean`, namespace `CoefficientCertificate`, compiled with
Lean 4.31.0 and the host's built Mathlib. It supports ledger claim
`L_COEFF_FORMAL_CORE`. It does **not** encode the entire scalar coefficient
theorem or the Banach-space theorem. No declaration assumes the scalar
nonvanishing conclusion or an explicit coefficient lower bound.

## Objects and quantifiers

`BinaryMatrix m n` is `Matrix (Fin m) (Fin n) (ZMod 2)` for arbitrary natural
row and column counts, including zero. `Matrix.rank` is rank over `ZMod 2`,
not over the rationals or the reals. `rowParity`, `colParity`, and
`totalParity` are sums in `ZMod 2`, hence parities, not integer weights.

`rectangle_row_parity`, `rectangle_col_parity`, and
`rectangle_total_parity` compute these sums for an arbitrary outer product
`p h^t`. `odd_rectangle_parities` assumes total parity one and proves both
factor sums are one and the row/column parity vectors are precisely `p,h`.
`rectangle_unique` assumes both original factor vectors are nonzero and
equality with another outer product, and proves equality of both factors.
The converse classification of every nonzero rank-one matrix as an outer
product is proved in the report, not formalized here.

`rowSupported P i` means every entry outside row `i` is zero;
`colSupported P j` is the analogous column assertion. The two
`*_supported_rank_le_one` declarations prove the corresponding actual
matrix-rank bounds.

## Exact coefficient-level projections

`c` is an arbitrary real-valued function of a binary matrix, interpreted in
the application as its uniform Fourier coefficient. `lowRankPart c P`
keeps `c P` when binary rank is at most one, and is zero otherwise.

`high_rank_row_coefficient_zero` assumes the **coefficient-level** row
projection identity for every index, binary rank greater than one, and row
parity equal to the selected unit vector. It proves that coefficient is
zero. The hypothesis says that selecting coefficients of that row parity
equals the row-supported coefficients of `a*g`; it is not a bound or a
nonvanishing assumption.

`row_projection_survives` and `col_projection_survives` assume the
corresponding original coefficient-level identity for all binary indices.
For arbitrary real `a,b` and arbitrary real coefficient arrays `g,f`, they
prove that the same identity holds for `lowRankPart c`.
The identification of these hypotheses with the manuscript's function
identities uses finite Fourier character orthogonality, which is proved
in the report and checked on small complete cubes by `verify.py`, not
formalized in Lean. In the application oddness ensures that the supported
row/column coefficient identities have exactly the stated form. No
sup-norm bound for the rank projection is assumed or proved.

## Weighted parity mass and tail exponents

`parityMass r n` is a pair of rational numbers defined by the exact even/odd
weighted-mass recurrence, starting with `(1,0)`. `parity_mass_sum`,
`parity_mass_sub`, and `odd_mass_closed` prove its closed formula for every
rational `r` and natural `n`. The combinatorial identification of this
recurrence with the sum of `r^|P|` over all odd binary matrices is explained
in the report; the formal theorem is about the recurrence itself.

`tail_log_exponent` is an inequality for real `k,l,t` with `t>=0` and
`k,l>=2t`; it proves `(k+l)t<=kl`. `tail_geometric_exponent` assumes real
`k,l>=4` and proves `k+l<=kl/2`. The logarithm comparison, Parseval,
probability expectation, and geometric summation are not formalized.

## Final margin and conversion

`quantitative_margin` quantifies over real `d,A,B,K,epsilon,W`. Its
hypotheses are `d>=4`, `A,B>=80d(d+1)^2`, the mixed-derivative upper
inequality

\[
 AB/2 \le 4d(d+1)(A+B)+5K\,d(d+1)\,d(d+1)^2,
\]

and `K<=8+epsilon*W`. It proves
`epsilon*W>=640d+504` by an exact nonnegative polynomial identity.
It does not assume positivity of `epsilon` or `W`, because that is
unnecessary for this algebraic implication. The existence of `H0` and
its Chebyshev/mixed-derivative estimates establishing these premises are
proved in prose, not discharged by this formal theorem.

`coefficient_from_mass` assumes a natural `N`, real `epsilon>=0`,
`W<=(3/2)^N`, and `epsilon*W>=1`. It proves
`epsilon>=(2/3)^N`. In the application
`N=m^2`, the odd-mass formula provides the mass bound and
`quantitative_margin` provides a strictly stronger lower bound on
`epsilon*W`.

The scalar theorem has no unproved external mathematical assumption.
Its remaining **non-formalized proof obligations** are the stated finite
Fourier translation, rank-one existence, Parseval/Cauchy--Schwarz,
noise expectation, tail summation, and elementary Chebyshev integral
argument. The full scalar claim is supported by a written proof and
exact replay, not labelled as a kernel-closed theorem.
