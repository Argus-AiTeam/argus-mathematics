# Statement fidelity: algebra used by the cubical cutoff

This file describes `research/cubical_cutoff/Main.lean` and claim
`C_EXACT_ALGEBRA`. It does not interpret the source as a formalization of
`C_CUTOFF`, `C_IMMERSION`, either main approximation theorem, a covering
argument, or a literature theorem.

All coefficients and matrix entries are real numbers. Matrices have rows
and columns indexed by `Fin 3`. All depth indices are natural numbers.

- `scalar_determinant` (qualified as `CubicalCutoff.scalar_determinant`)
  quantifies over every real `q` and
  every real 3-by-3 matrix `A`. It proves
  `det(q A) = q^3 det(A)`, including `q=0`.
- `frame_transport_determinant`
  (qualified as `CubicalCutoff.frame_transport_determinant`) quantifies over all six real
  coordinates of vectors `v,w`. With `d=w dot w`, it proves
  `det(d Id + (v-w) w^T) = d^2 (v dot w)`. This is a polynomial identity;
  it does not assume `w` is nonzero and does not itself assert positivity
  or the existence of a frame homotopy. The prose proof divides by `d`
  only when `w` is nonzero and uses positivity only when `v dot w>0`.
- `dyadic_sum_identity` (qualified as `CubicalCutoff.dyadic_sum_identity`)
  proves, for every natural `N`,
  `sum_{k<N} (1/2)^k + 2(1/2)^N = 2`. The sum is finite; `N=0`
  is included.
- `dyadic_sum_bound` (qualified as `CubicalCutoff.dyadic_sum_bound`)
  proves the resulting upper bound `2`
  for every natural `N`.
- `weighted_overlap_bound` (qualified as `CubicalCutoff.weighted_overlap_bound`)
  quantifies over every real
  `K>=0`, every real sequence `w`, and every natural `N`. Its sole
  hypothesis on the sequence is `w(k)<=K*4^k` for every `k`. It proves
  `sum_{k<N} w(k)/8^k <= 2K`. The entries need not be integers or
  nonnegative; applying this to nonnegative simplex counts is a special
  case, not an extra formal hypothesis.

The last theorem corresponds exactly to multiplying three-dimensional
inverse-Jacobian weights `2^(-3k)` by a scale-wise overlap bound
`K*2^(2k)`. Passing from all finite depths to an infinite nonnegative
sum, geometric packing, chain rules, positive-codimension immersion,
Schoenflies, fixed-image filling, and Sobolev gluing are arguments in
`proof.md`, not kernel-checked declarations in this source.

No manuscript claim is refuted by these declarations. No external
topological or analytic theorem is encoded as an axiom.
