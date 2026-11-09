# Statement fidelity: finite-horizon probabilistic tournament

The principal declaration is
`ProbabilisticTournament.finite_horizon_miss_bound` in `Main.lean`.
This document describes that declaration and its supporting definitions and
lemmas, not the entire quantum algorithm or the quartic-separation theorem.

## Objects and quantifiers

The candidate type `ι` is arbitrary, with a finite enumeration and decidable
equality. A distinguished element `star : ι` is supplied, so the type is
nonempty. Its cardinality is `m = Fintype.card ι`. The manuscript uses `m >= 2`;
the formal theorem also allows `m = 1`.

The comparison function `a : ι -> ι -> Real` is universally quantified.
`Comparison a` requires, for every pair, `0 <= a i j <= 1`, `a i i = 0`,
and `a i j + a j i = 1` when `i != j`. The entry `a i j` means that
**i defeats j**, not the opposite orientation. There is no rationality,
transitivity, determinism, or gap-from-one-half hypothesis.

Both `epsilon` and `eta` are arbitrary nonnegative real numbers.
Dominance means `1 - epsilon <= a star p` for every `p != star`.
The horizon `T` is any natural number, including zero, with
`(T : Real) * epsilon <= 1/2`.

## The actual finite stochastic process

`weights a [] i = 1`. The list stores the newest pivot first, and
`weights a (p :: h) i = weights a h i * a i p`. Thus these are exactly
the manuscript's product weights. `total w` sums all candidate weights.

The arbitrary function `q : List ι -> Real` assigns a conditional failure
probability to every complete pivot history. Its values lie in `[0,1]`.
Only histories omitting `star` with total weight at least `1/2` must satisfy
`q h <= eta`. In particular, failures need not be history independent;
failures after a hit or at low total weight have no extra bound.

`miss a star q n h` is the explicitly defined probability of ending with no
`star` after at most `n` further stages:

* If `star` is already in `h`, it is zero.
* With no stages left and no previous hit, it is one.
* With zero total weight and no hit, it is one (absorbing termination).
* Otherwise it is
  `q h + (1-q h) * sum_p (weight h p / total(weight h)) *
    miss a star q (n-1) (p :: h)`.

This is the finite-tree law of stopping on failure and, on success, sampling
exactly the normalized weights. It is not a hypothesis asserting the desired
success bound. `miss_nonneg` and `miss_le_one` prove this recursive probability
lies in `[0,1]`; `pivot_sum` proves the positive-weight pivot law normalizes.
If extra internal classical history exists, conditional exactness lets one
average its failure probability at each pivot history to obtain this same law.
The semantic identification with an implemented quantum experiment is a
separate, explicitly stated bridge in `report.md`.

## Proved conclusion and load-bearing lemmas

`finite_horizon_miss_bound` proves

`miss a star q T [] <= 2*m/(2^T) + T*eta`.

The number on the left is the missing-star event, not expected total weight.
`miss_bound_from_state` proves the stronger induction invariant with
`weight h star >= 1/2 + n*epsilon`, for arbitrary histories and remaining
horizons. Selected-star children have miss probability zero. The other
children retain the required weight margin. Sampler failure contributes at
most one additional `eta` at each level.

`numerator_le` and `average_next_le` prove the half-total-weight drift
inequality from complementarity and the zero diagonal. The exact
sum-of-squares drift identity is proved in the report, not encoded as a
separate Lean equality. `surviving_weight` proves the all-history lower bound
`1 - length(h)*epsilon <= weight h star` for histories omitting `star`.

## Formal boundary

Lean checks all real-valued arithmetic, finite sums, recursion, normalization,
dominance, survival, and the final finite-horizon miss bound above. No custom
axiom, admitted proof, finite-grid replacement for real probabilities, or
stochastic conclusion assumed as a premise is used.

Lean does **not** encode Hilbert spaces, retained-garbage state preparation,
Grover reflections or their trigonometric averaging, the interpretation of
quantum measurements, the ceiling/logarithm parameter arithmetic, or bit-query
accounting. Those implementation obligations have complete ordinary proofs
and exact regression checks in `report.md` and `verify.py`; they require
independent human review. The certificate is not a formalization of
`prop:quantum`, the construction, the classical lower bound, or `thm:main`.
Compilation alone does not establish that this translation is faithful.
