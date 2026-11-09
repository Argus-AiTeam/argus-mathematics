# Fidelity of the rationalization formalization

The ledger claim is `A_RATIONALIZATION`. The formal source is this
directory's `Main.lean`. Unlike the three-layer source in the parent
directory, this result is not restricted to any value of `s` or `d`.

The outcome type `alpha : Type u` is arbitrary, finite, and nonempty.
For alignment it is the finite nonempty set of `s`-subsets of `[r]`,
with `r >= s`. The input `w : alpha -> Real` is any nonnegative real
probability law; `hsum` states its sum is exactly one.

`rational_below` proves that a nonnegative real number admits a
nonnegative rational approximation from below with any strictly
positive absolute tolerance. The zero case is included.

`finite_rational_l1_approximation` quantifies over every positive real
`epsilon` and produces `q : alpha -> Rat` with all coordinates
nonnegative, total mass exactly one, and

    sum i, abs ((q i : Real) - w i) < epsilon.

The proof approximates each weight from below and puts the rational
residual mass at one distinguished outcome. Normalization and
nonnegativity are conclusions, not assumptions about a proposed
approximation.

The principal declaration `rationalize_uniformly` assumes only
`xi < eta`. It produces the single rational probability law `q`
before universally quantifying over the test function `b`. For every
`b : alpha -> Real` satisfying `0 <= b i <= 1`, it proves

    sum i, w i * b i <= xi
       -> sum i, (q i : Real) * b i < eta.

Bad-set indicators are special cases of these test functions. Thus
the same `q` works for every allowed pattern and every label universe,
without enumerating or bounding those families. The strict tolerance
margin is preserved exactly.

There are no project axioms or manuscript results among the
hypotheses. The proof uses Mathlib's rational density, finite sums,
absolute-value inequalities, and rational/real field arithmetic.
It does not prove that the real sampler `w` exists. In particular it
does not certify `A_ALIGNMENT`, minimax, Ramsey homogenization, or
the invariant-cut step.
