# Statement fidelity: moving-active local injectivity core

`Main.lean` contains an attributed consolidation of five generic analysis
modules from `openai/math` commit
`4eaee87548250b2682affda7d05d947c05554bae`, followed by the campaign's
`MovingActive` namespace. Their module imports are replaced by
`import Mathlib`; their proof bodies are reused, not replaced by assumptions.
Two proved compatibility lemmas supply the old `uniqueDiffOn_uIcc` and
`dite_eq_left` API names on the installed Mathlib revision.
The exact originals and Apache-2.0 license are in `upstream_sources/`.
No upstream geometric or global-support theorem is imported.

## Scalar normalized-remainder theorem

`MovingActive.movingFiniteCollisionImpossible` quantifies over a sequence
of arbitrary finite types `I j`. There is no upper bound on their
cardinalities, and the slot type itself may change with `j`. For each stage
there are real arrays of weights `m`, first-order scalars `d`, second-order
scalars `B`, and normalized remainders `epsilon`. Weights are nonnegative
and sum to one. The real separation `l j` is positive and the collision
increment `Delta j` is nonpositive. Each slot satisfies

    l*d + (l^2/2)*B + l^2*epsilon <= Delta.

The weighted first-order sum is exactly zero at each finite stage.
Every normalized remainder has absolute value at most `r j`, where
`r j -> 0`. The weighted second-order sums tend to a strictly positive
real `gap`. The conclusion is `False`: no such data can coexist.

The theorem intentionally does not assume convergence of individual slots,
weights, or first-order terms, and does not require `l -> 0`: that analytic
work has already been encoded by uniform normalized remainders and the
positive weighted-gap limit. In the geometric application `l -> 0` is what
produces those remainder bounds. All-stage hypotheses are equivalent to
eventual hypotheses after discarding a finite prefix.

`MovingActive.cancellationBound` proves the exact finite-stage normalized
inequality. `MovingActive.weightedRemainderBound` bounds the absolute
weighted remainder by the same `r`, independently of the slot count.
`MovingActive.tendstoZeroOfAbsLe` is the real squeeze argument.
`MovingActive.barycentricCancellation` proves, for any real inner product
space and any finite slot type, that unit-sum real weights and the exact
vector barycenter identity imply the exact weighted pairing cancellation.
It does not even need nonnegativity of the weights.

## Limits, zero weights, and transversality

`MovingActive.firstOrderNonpos` has scalar sequences with `l > 0`,
`l -> 0`, `d -> d0`, `B -> B0`, `epsilon -> 0`, `Delta <= 0`, and the
displayed slot inequality. It proves `d0 <= 0`.

`MovingActive.finiteWeightedLimit` is for any fixed finite type, with
independently converging real weights and second-order scalars; it proves
convergence of their weighted sum to the corresponding limiting sum.
There is no lower bound on weights and no rate hypothesis.

`MovingActive.vanishingWeightBounded` is stronger than requiring a
second-order limit in a zero-weight slot. It assumes `w -> 0` and a
uniform bound `abs(B j) <= K`, and proves `w j * B j -> 0`.
The bounded factors need not converge, and weights need not be positive.

`MovingActive.positiveWeightFace` proves that nonnegative weights,
nonpositive slot values, and zero weighted sum force every strictly
positive-weight slot value to vanish.
`MovingActive.limitingPositiveWeightFace` obtains this conclusion from
moving weights and values, exact finite-stage cancellation, and limiting
nonpositive values. These scalars represent the pairings
`<a_i-p,e>`; tangent vectors and this geometric interpretation are not
encoded in these declarations.

## Reused smooth Taylor theorem

`MovingActive.smoothParameterCollisionImpossible` uses the actual upstream
`OAI.WeakMTWGlobalSupport.MovingTaylor.collision_limits`.
It quantifies over arbitrary real normed parameter spaces, any
fixed finite slot type, smooth real functions `B` and `C i`, and convergent
moving poles, directions, endpoint parameters, coefficients and weights.
Separations tend to zero and are eventually positive; weights are
eventually nonnegative. It assumes the individual nonpositive comparison
increments and exact eventual cancellation of their weighted first
derivatives. A strictly positive limiting weighted second derivative is
impossible. No limiting weight is required to be positive.
The scalar coefficient `beta` is not a potential or a barycentric weight.

## What the compiler does not verify

The formal result is the complete limit/cancellation core, not a Lean
formalization of a Riemannian manifold or of the manuscript's lemma.
`report.md` proves the analytic bridge: compact active logarithms for an
arbitrary continuous representing datum, uniform Taylor bounds from
properly shortened supports and a common nonconjugate branch, exact
barycentric cancellation, and the transverse MTW/radial positive gap.
It also proves the stronger fiber-local geometric criterion and then
deduces the literal manuscript lemma.

The compiler does not certify that geometric translation, the full
global-support/convexity theorem, the transport manuscript, mathematical
novelty, publishable significance, or independent Reviewer acceptance.
The source prints the axioms of five principal declarations so that
their dependence on only Lean/Mathlib's standard logical axioms is visible.
