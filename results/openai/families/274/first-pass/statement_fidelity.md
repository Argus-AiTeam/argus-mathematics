# Statement fidelity: arbitrary-rank weighted projection core

Claim `C_DIM_CORE` refers to the declarations in namespace `DimensionUniform`
in `research/Main.lean`.

`projection_defect` quantifies over every unital, not necessarily commutative
ring and every two idempotents `P,Q`. It proves
`P-PQ(2-P)QP=(P-PQP)(P-PQP)`. The numeral `2` means twice the ring identity.
No commutation hypothesis is present. Self-adjointness is unnecessary for
this algebraic identity.

The matrix declarations quantify over an arbitrary finite index type `n`
and complex square matrices on it. The hypotheses `P*P=P`, `Q*Q=Q`,
`P.conjTranspose=P`, and `Q.conjTranspose=Q` express precisely orthogonal
projections. There is no assumption on either rank, their intersection,
the local dimension, or their commutator. Empty index types are permitted.

`projection_defect_gram` identifies the same defect with `X.conjTranspose*X`
for `X=P-PQP`. `weighted_projection_contraction` proves that this defect is
positive semidefinite, that is, `PQ(2I-P)QP <= P` in Loewner order.
`weighted_projection_gram` and `weighted_projection_positive` prove
`PQ(2I-P)QP >= 0` by two Gram terms. For these latter two statements `Q`
need only be Hermitian; they do not require its idempotence.
`projection_positive` proves positivity of a Hermitian idempotent.
`Matrix.PosSemidef` includes Hermitian symmetry and nonnegativity against
every complex vector, not just product vectors.

`tensor_order_step` quantifies over two arbitrary and independently sized
finite index types `n,m`, and four complex square matrices `A,B,C,D` of the
indicated sizes. Its explicit hypotheses are positivity of `A,D,B-A,D-C`.
It proves positivity of `B tensor D - A tensor C`. The proof uses
`(B-A) tensor D + A tensor (D-C)` and never commutes matrices within a
factor. Repeated application gives tensor monotonicity for any finite list
of independently sized positive local pairs. The Lean declaration is this
universal induction step, not a separately encoded dependent-list theorem.

`compressed_tail` quantifies over arbitrary same-size complex matrices
`K,P,W,H` and a nonnegative real `c`. Assuming positivity of
`P-K.conjTranspose*W*K` and `c*W-H`, it proves positivity of
`c*P-K.conjTranspose*H*K`. Scalar multiplication here is real scalar
multiplication of complex matrices. This is the general quadratic
implication used after the tensor bound and scalar spectral Markov bound.
It contains no hypothesis asserting the desired localization conclusion.

For the depth-zero application in the mathematical report, take each
`P_i` to be a counted zero-subspace projection, `Q_i` a factor of the
tested product projection, `W=2^M`, `K=A P_zero`, `H=[M>=r]`, and
`c=2^(-r)`. The operator core is kernel-checked; the identification of count
spectra, iteration over all sites, norm conversion, polynomial approximation,
and full finite depth/scale induction are proved in prose in
`research/dimension_uniform_localization.md`. Those analytic conclusions
are not claimed to be formalized by this file. Compiler success alone does
not verify that application or the theorem's publication novelty.
