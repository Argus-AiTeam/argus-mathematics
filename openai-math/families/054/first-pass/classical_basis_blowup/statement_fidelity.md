# Statement fidelity: reconstruction order and tensor division

Claim: `C_RECONSTRUCTION_ORDER`.
Source: `research/classical_basis_blowup/Main.lean`.

All declarations are in `BlowupReconstruction`. Natural-number variables
are unbounded; this is not a finite parameter search.

`restricted_contact` proves that a nonnegative singleton-tail codimension
`r*(k-kp)+b`, with positive `r` and `b<r`, forces `kp<=k`.
The geometric restricted correspondence uses `r>=2`, a stronger hypothesis.
`restricted_empty_tail` excludes every positive-contact empty tail when
`r>=2`.

`divisorCodim` is the integer
`sum(input contacts)-number(input contacts)-output contact+1`.
For an arbitrary finite list of tails, `divisor_balance` proves its summed
identity, including empty tails. `divisor_length_order` deduces that the
new length is at least the original length when total contacts agree and
the sum of codimensions is nonnegative. It does not assert that geometric
tail pushforwards have nonnegative codimension; that is a geometric input
proved in REPORT.md. `empty_divisor_tail` forces contact one for a
nonnegative-codimension empty divisor tail.

`length_le_sum_of_positive` bounds the length of any positive-contact list
by its total contact K. `divisor_measure_lt` proves strict decrease of
`(K-length)*(K+1)+positive_count` if the new length increases, or if length
is unchanged and the positive count decreases. The new positive count is
assumed at most the new length. This proves termination at fixed K;
neither a nef divisor nor a global bound on descendants is assumed.

For a list whose entries count the positive-weight input labels on each
tail, `positiveCount_le_sum` proves that coalescence does not increase
their number. `positiveCount_lt_of_merge` makes the decrease strict if a
tail contains at least two such labels. `positiveCount_rigidity` says that
equality forces at most one positive-weight input label on every tail.
The interpretation of these counts as geometric labels, and preservation
of each label in the equality case, are not encoded in Lean.

`fibreCoefficient_pos` proves strict positivity of the rational expression
`1/(k^(r-j)*((k-1)!)^r)` for every positive k. This expression is the
published fibre invariant only in the geometric range `0<=j<=r-1`.
`labelled_tail_coefficient_pos` includes the contact gluing factor and m
ordinary point-divisor insertions. Lean does not compute a virtual class
or prove the Hu--Li--Ruan formula.

`tensor_recover` quantifies over every rational module V and rational
submodule S. A single rational scalar c must be nonzero and must satisfy
the equality `A=c*B+R` in V, not just pointwise after variable
specialization. Membership of A and R in S then implies membership of B.
This models bilinear tensors with two distinguished formal slots.

These declarations formalize only the arithmetic and linear reconstruction
core. They do not formalize Gromov--Witten moduli, Hodge theory,
degeneration, descendant compatibility, the blowup theorem, or its proposed
extension. Those mathematical dependencies and their application are
separately stated in REPORT.md. A compiler success for this file must not
be reported as a kernel proof of `C_GW_SPLIT` or `C_EVEN_HODGE_SPLIT`.
