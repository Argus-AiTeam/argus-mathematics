# Statement fidelity: PC9000038

`Main.lean` formalizes the finite weighted-growth algebra and the universal
partition-to-contradiction argument used in the point-center proof. It does
not formalize schemes, birational models, section rings, monomial valuations,
or Fujita's conjecture. The complete geometric and asymptotic implication is
proved in `report.md` and remains subject to independent mathematical review.

## Objects and quantifiers

All scalar arithmetic is over `Real`. The Hilbert exponent `n` and finite
partition length `l` range over all natural numbers, without a dimension
cutoff. In the geometric application `n >= 1`. The center dimension is cast
to a positive real `d`. The uniform root-cardinality slope is the positive
real `sigma`, equal to one for the manuscript. The reference parameter `t`
is positive and the discrepancy lower bound `a` is nonnegative. Choosing a
strictly positive `a` permits `exists_parameter`.

`powerSum n l` is `sum_{i=0}^{l-1} i^n`.
`powerRiemann n l` is `l^(-1) sum_{i=0}^{l-1} (i/l)^n`.
`expRiemann n u l` is
`l^(-1) sum_{i=0}^{l-1} (i/l)^n exp((1-i/l)u)`.
For `n >= 1`, the term at zero vanishes, so this is exactly the manuscript's
sum over `1 <= i <= l-1`, not a different endpoint convention. Statements
using normalized sums require `l > 0`; the obstruction uses all `l >= 2`.

## Declaration coverage

* `power_growth` proves the convexity increment for every natural power
  `d+1`, with `b,h >= 0`.
* `weighted_growth` sums that increment over an arbitrary finite set with
  nonnegative weights. It assumes `c_i >= b_i+h` for the slices included in
  that set. In the geometric application these are the old nonempty slices;
  new slices contribute nonnegatively and are handled in the prose proof.
* `growth_telescope` proves finite telescoping directly from its successive
  growth inequalities. `moment_telescope` combines it with the simplex
  moment inequality to give `d sum q_i <= U+(d/2)Q`. Here `q_i` represents
  `(h_i-C')Q_{j_i}`, and `U` is the unnormalized tangential moment. The
  simplex comparison itself, and the geometric origin of the increments,
  are proved in prose rather than assumed proved by Lean.
* `power_sum_bounds` proves both monotone integral comparisons for all
  `n,l`. `power_riemann_eq` identifies the normalized sum exactly, and
  `power_riemann_bounds` proves its error bound. None of these declarations
  assumes a Riemann-sum limit.
* `exp_partition_lower` derives, using the exponential tangent inequality,
  `expRiemann(n,u,l) >= 1/(n+1)+u/((n+1)(n+2))-(1+u)/l` for `u >= 0`.
* `remove_vanishing_error` removes a `C/l` error using the Archimedean
  property, for arbitrary real `A,B,C`. It assumes the bound for every
  integer `l >= 2`, not just a finite collection of tested lengths.
* `numeric_obstruction` is exact denominator-cleared algebra. It accepts a
  real `N >= 0`, `d,t > 0`, and the displayed scalar moment comparison, and
  concludes `sigma(t+a/(N+2)) <= N+1`.
* `partition_obstruction` combines the preceding results. Its hypothesis is
  `sigma*d*expRiemann(n,a/t,l) <= d/t` for **every** `l >= 2`; its conclusion
  is `sigma(t+a/(n+2)) <= n+1`. The per-partition inequalities are obtained
  from section growth, first variation, Hilbert asymptotics, and the
  liminf-degree argument in `report.md`. Those geometric and limit
  passages are not silently included in the formal theorem.
* `partition_impossibility` gives a contradiction when the opposite strict
  parameter inequality holds. `exists_parameter` constructs one `t` in
  `[t0,n+1)` satisfying `t > n+1-a/(n+2)` from `0<t0<n+1` and `a>0`.

## Fidelity and remaining boundary

No finite-dimensional example is a substitute for these universally
quantified declarations. Conversely, successful compilation of this file
does not validate the upstream manuscript claims about minimizer attainment
or specialization, the uniform restriction-image lemma, the geometric
Taylor expansion, or the passage to the per-partition inequalities. Their
status and dependencies are stated separately in the report and claim
ledger. A reader must check those proofs; the compiler cannot check that
the geometric objects were translated faithfully.
