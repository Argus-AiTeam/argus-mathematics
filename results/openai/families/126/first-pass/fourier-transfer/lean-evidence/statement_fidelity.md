# Statement fidelity: FourierTransfer algebraic core

The declarations in `Main.lean` are universally quantified over the finite
types and real entries they name. They are not fixed-size rational examples.
`Row` and `Col` are independent types, so rectangular dimensions are allowed.
No commutativity of matrix multiplication is assumed.

* `tagged_overlap_entry` proves (F3) entrywise, with arbitrary finite tag,
  input, and row sets, arbitrary column and frequency types, real functions
  `chi` and `s`, real normalization, and arbitrary matrices `U(x)`.
  Substituting `normalization = 1/L`, `s(y,x) = sqrt(pi_y^m(x))`,
  and Walsh characters gives exactly the manuscript's tagged-stack overlap
  identity, with the old weighted coefficient columns included in `Col`.
  The row index is `Y x (X x Row)`. No cross product between different
  tags appears in its conclusion.
* `tagged_square_entry` proves exact pointwise reconstruction (F2).
  It uses a tag equality test and arbitrary real `s`; the probability
  specialization again uses `s^2 = pi`.
* `resolution_square` proves exact square preservation under a finite
  resolution by symmetric idempotent matrices summing to the identity.
  Pairwise orthogonality is not needed for this identity.
* `noncommutative_block_gap` verifies the trace algebra in (S1), with
  `A,B,C,D` standing for `A11,B11,A22,B22`. The real variable `off`
  stands for the squared Frobenius norm of the common off-diagonal block.
  The two diagonal block sizes are independent (`Row` and `OtherRow`).
  This declaration does not prove that these are spectral blocks, or
  that any of its terms is nonnegative.
* `frobSq_sub_le` is the squared triangle inequality for arbitrary finite
  rectangular real matrices; `frobSq_nonneg` proves nonnegativity.
* `balanced_step` proves (S4)'s scalar charging implication from explicitly
  stated hypotheses `d >= 1/2`, `a >= 0`, and the preceding loss bound.
  `splitConstant_formula` proves the closed form of the binary-height
  recurrence, namely `splitConstant(a+1) = 2^(a+1)/4`. It does not assert
  the existence of the matrix projections.
* `one_step_factor` proves the exact ordered-count simplification in
  (F7) for arbitrary real parameters with `L != 0`.
* `potential_iterate` proves the universal homogeneous scalar recurrence.
  The heterogeneous product recurrence in the mathematical theorem is
  proved by induction in the accompanying proof, not by this declaration.
* `mass_squared_conversion` propagates a Gram-potential bound through the
  squared rank/branch estimate, assuming that estimate explicitly.
  It does not formalize Cauchy-Schwarz or matrix ranks.

The full universal theorem, including noncommuting spectral splitting,
character orthogonality, probability conditioning, selection of projection
families, matrix Cauchy-Schwarz, and final mass conversion, is proved in
`research/fourier-transfer/theorem.md`. Those analytic and spectral parts
are **not fully formalized**. A compiler success supports the claim
`C_FOURIER_CORE`, not a claim that the entire Fourier theorem or matching
lower bound has been checked by Lean.

There are no additional axioms or external theorem declarations in this
file. Mathlib's ordinary real-number, matrix, finite-sum, and tactic
infrastructure is used. The exact rational Python replays are finite
regressions, not the proof of the universal quantifiers.
