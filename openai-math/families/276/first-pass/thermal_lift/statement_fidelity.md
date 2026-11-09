# Statement fidelity: universal thermal lifting

## What is formally proved

`Main.lean` uses Lean 4.31.0 and Mathlib. Its principal declaration is
`ThermalLift.thermal_from_triangular`, with the channel corollary
`ThermalLift.kraus_channel_lift`. It proves a universal implication from
explicit analytic hypotheses, not a definition or a construction of von
Neumann entropy. The implication includes the entropy lower bound itself,
not merely its coefficient identity.

The row index type `m` and column index type `n` are arbitrary finite types.
They need not coincide. The matrices `X Y : Matrix m n Complex` are
arbitrary complex matrices with `trace (X * X.conjTranspose) = 1` and the
same condition for `Y`. Normalization already rules out an empty row or
column type in any instance; no invertibility, orthogonality, rank, or
commutativity assumption occurs.

`Coeff.a`, `Coeff.b`, `Coeff.e`, and `Coeff.d` represent the manuscript's
alpha, beta, eta, and delta. The real number `k` represents its **K**,
not the channel coherence multiplier also denoted by a lower-case k in
the manuscript. `Admissible q k` requires all five numbers to be
nonnegative, the four coefficients to sum to one, and
`q.a*q.d-q.b*q.e=k^2`. `thermal X Y q k` is exactly the manuscript's
2-by-2 block matrix, with the adjoint, rather than the transpose or
entrywise conjugate, in every Gram expression. `State A` means both
Mathlib's `Matrix.PosSemidef A` and the complex trace equality `A.trace=1`.
`scalar q k` is `(q.a+q.b)*(q.e+q.d)-k^2`.

The entropy symbols are explicit parameters. `E` is a real-valued
function on the doubled output matrix space, `S` is a real-valued
function on the single output matrix space, and `g` is a real-valued
function of a real scalar. The main formal theorem has these analytic
hypotheses:

1. `hc` is concavity of `E` on actual normalized positive semidefinite
   matrices, for arbitrary two nonnegative real weights summing to one.
2. `htri : TriangularInput E S g` is the rectangular triangular
   inequality for **all** normalized matrices `Z,W` of the same
   rectangular shape, and **all** nonnegative real masses `a,b,d`
   summing to one. Its matrix is the Gram matrix of
   `[[sqrt(a) Z, sqrt(b) W], [sqrt(d) W, 0]]`; its lower bound is
   `a*S(ZZ*)+(b+d)*S(WW*)+g(b*d)`. This is a specialization of Tang
   arXiv:2609.28592v1 Theorem 4.2, after a row permutation and conversion
   from bits to nats. It is not the thermal inequality assumed back
   as a hypothesis: exactly one matrix block is zero.
3. `hswap` says `E` is invariant under simultaneously interchanging the
   two block rows and two block columns of a **state**. No assertion
   about entropy of non-positive matrices is required.

The conclusion of `thermal_from_triangular` is the conjunction that the
thermal matrix is a state, that `0 <= scalar q k <= 1/4`, and that
`(q.a+q.e)*S(XX*)+(q.b+q.d)*S(YY*)+g(scalar q k) <= E(thermal X Y q k)`.
Thus taking `E` and `S` to be von Neumann entropy in nats and `g` to be
the stated binary-spectrum entropy recovers the full universal thermal
bound, subject precisely to the three analytic inputs above.

## Why the boundaries and the lifting are not assumed

`scalar_identity`, `scalar_range`, `left_rows`, `right_rows`,
`left_valid`, and `right_valid` verify the coefficient identities,
nonnegativity, normalization, determinant constraint, and scalar range.
`interior_decomposition` constructs the manuscript's two endpoints and
weights and proves recovery of every coefficient and equality of the
two endpoint scalar terms. Its strict hypotheses are only `q.b>0`
and `q.e>0`; its proof derives positivity of both row sums and the
scalar before dividing by them.

`lower_recovery` and `concave_endpoint_lift` prove the actual ordered
inequality for every affine coefficient-to-vector map into any real
module, using a convex state predicate and a concave functional.
`thermal_mix` proves that the concrete complex matrix is such an
affine map when the cross coefficient is kept fixed.

`sqrt_cross`, `gram1_identity`, and `gram2_identity` prove the complex
Gram factorizations, including the sign of the cross coefficient.
`thermal_trace` proves trace one, `state_convex` proves closure of
normalized positive semidefinite matrices under convex combinations,
and `thermal_state` proves positivity and normalization for **all**
admissible coefficients without any analytic entropy hypothesis.

`flip_valid`, `flip_scalar`, `thermal_swap`, `triangular_left_edge`,
and `triangular_edges` derive both endpoint bounds from the single
triangular input and the actual block permutation.
`thermal_entropy_lift` combines those endpoint bounds by the generic
concavity theorem; `thermal_from_triangular` supplies the endpoint
bounds from the stated analytic input.

The outer split treats `q.b=0` or `q.e=0` directly. Only the remaining
case uses `interior_decomposition`. Therefore zero mixture weights,
zero row sums, `scalar=0`, `k=0`, and singular matrices are included;
none can cause an unguarded division or require a limiting argument.
This split is equivalent to, but less singular than, the manuscript's
initial split on `u=0`.

## Channel and Kraus declarations

`channelCoeff` is the exact substitution
`((1-gamma*nu)*(1-p), gamma*(1-nu)*p,
gamma*nu*(1-p), (1-gamma*(1-nu))*p)`.
`channelK` is `sqrt(1-gamma)*sqrt((1-p)*p)`.
`channel_admissible` proves all hypotheses for every real
`gamma,nu,p` in the closed interval `[0,1]`.
`channel_columns` proves the column sums `1-p,p`.
`channel_scalar` proves the completed-square formula
`gamma*nu*(1-nu)+gamma*(1-gamma)*(p-nu)^2`.
`channel_entropy_lift` and `channel_from_triangular` prove the
population-weighted entropy inequality after this substitution.

For arbitrary finite input, output, and Kraus index types `i,o,l`,
`branchColumns V psi` has column `b` equal to `V b * psi`.
The branch vectors are one-column matrices indexed by `Unit`.
`common_index_cross` proves their common-index Gram identity;
`common_index_kraus` identifies it with
`sum_b V b * (psi*phi*) * (V b)*`.
`common_index_normalized` proves normalization from
`sum_b (V b)* * V b=I` and `trace(psi*psi*)=1`.
There is no equality-of-dimensions or orthogonal-branches hypothesis.

`kraus_channel_lift` quantifies over every such family and both
normalized branches and proves the substituted thermal output is a
state with the claimed weighted lower bound. It includes all
parameter endpoints. The existence of a Kraus family for an arbitrary
CPTP map is an external input, Watrous Theorems 2.22 and 2.26, not
silently formalized here. Direct identification of the manuscript's
channel notation with the explicit block matrix is given in
`theorem.md` and the common-index identities.

## What neither compilation nor finite computation establishes

Lean verifies the universal lifting, the matrix algebra and positivity,
the parameter substitution, and the conditional inequality. It does
not verify the external triangular entropy theorem, entropy's analytic
concavity or spectral definition, the existence theorem for Kraus
representations, or the manuscript's full capacity theorem.
`verify.py` replays exact algebra and checks the real compiler record
against the current source and this document. The numerical search
is only an adversarial finite experiment. Independent statement-fidelity
review, independent attribution of the cited propositions, novelty,
and publishable significance remain human/Reviewer obligations.
