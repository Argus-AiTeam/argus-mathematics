# Statement fidelity: C_TERMINAL_ALGEBRA

`Main.lean` formalizes the finite-dimensional bin factorization and the exact
lag-one twisted equality kernel algebra, in namespace `TerminalOrderKernel`.
It uses Lean 4.31.0 and Mathlib.

## Arbitrary finite matrix dimensions

`I`, `J`, and `B` are independent arbitrary finite types, possibly empty.
The maps `r : I → B`, `c : J → B`, real weights `w`, `z`, and real matrix
`K : Matrix B B ℝ` are arbitrary. No injectivity, surjectivity, positivity,
nonzero-weight, nonempty-type, or invertibility hypotheses are imposed.
Decidable equality on `B` permits writing the incidence matrices.

* `weightedBinMatrix_factorization` proves exactly
  `A = rowLift r w * K * columnLift c z`, with
  `A i j = w i * K (r i) (c j) * z j`,
  `rowLift r w i b = if r i = b then w i else 0`, and
  `columnLift c z b j = if b = c j then z j else 0`.
* `weightedBinMatrix_rank_le_kernel` proves `Matrix.rank A ≤ Matrix.rank K`.
* `weightedBinMatrix_rank_le_bins` proves
  `Matrix.rank A ≤ Fintype.card B` using Mathlib's rank-of-product bounds.
  Rank is the real linear-map image dimension, not a sampled numerical rank.

In particular, these are dimension-uniform statements, not fixed-size examples.
Empty bins and rank-deficient or zero weights are included whenever the
displayed bin maps exist.

## Exact time/permutation kernel

The label type `L` is arbitrary with decidable equality; it need not be finite.
For arbitrary real `u`, `v`, `osign u v` is `+1` when `u < v`, `-1` when
`v < u`, and zero otherwise, namely the sign of `v - u`.
`ltIndicator u v` and `eqIndicator y z` are real-valued zero/one indicators.
For an arbitrary permutation `σ : Equiv.Perm L`, the definition is exactly

`osign u v * [y = z] + [v < u] * [y = σ z] - [u < v] * [y = σ.symm z]`.

* `twistedEqualityKernel_skew` proves antisymmetry under simultaneous
  interchange of the two time/label arguments.
* `twistedEqualityKernel_identity` proves the kernel is identically zero for
  the identity permutation.
* `twistedEqualityKernel_of_symm_eq` proves the stated involution formula
  `osign u v * ([y = z] - [y = σ z])` under `σ.symm = σ`.
* `perm_symm_eq_of_involutive` and `twistedEqualityKernel_of_involutive`
  give the same result under `Function.Involutive σ`, i.e.
  `∀ y, σ (σ y) = y`.
* `twistedEqualityKernel_same_time` explicitly includes `u = v`.

No unequal-time, distinct-label, fixed-point-free, or open-interval assumptions
are used. In particular equal labels and fixed labels are included. These
are identities for the algebraic shift expression; no separate derivation of
that expression from an analytic operator is claimed.

## Scope limits

The bin rank theorem does not prove an analytic error estimate or
infinite-dimensional singular-value decay. The kernel identities do not assert
the manuscript's separate finite-displacement condition for order-one `g`,
and do not certify its other analytic hypotheses or conclusions.
