# Statement fidelity: claim C_ANCHOR_CORE

`Main.lean` uses real arithmetic and arbitrary finite sums. It does not
formalize a randomized k-server policy, a metric partition construction,
posterior conditional expectation, or the whole travel theorem. It
imports Mathlib and introduces no custom axioms.

The namespace is `AnchorTravel`. Its declarations have the following
exact scope.

* `finite_bin_bound`: for any type and finite set of indices, real
  nonnegative numerators, denominators bounded below by a positive `D`,
  and total numerator at most `U*D`, the sum of ratios is at most `U`.
  `U` need not be assumed positive; the hypotheses enforce any needed
  constraint.
* `coefficient_packing`: `bad` and `groups` are arbitrary finite subsets
  of the natural numbers; `members a` is a finite set for each group.
  The conclusion bounds the sum over `bad` plus all group sums by
  `27*C*(1+L)`. Hypotheses are `C,L >= 0`, bad individual ratios at most
  `6*C/5`, bad cardinality at most `14*L`, group cardinality at most
  `1+2*L`, positive group scales, nonnegative good numerators, good
  denominators at least `5*scale/12`, and each group's numerator sum at
  most `2*C*scale`. No height bound or bound on the number of members of
  a group is assumed. The formal theorem bounds the displayed sum even
  with overlapping groups. The application uses disjoint groups
  partitioning the selected good levels. The geometric capacity bound,
  logarithmic bad-level count, and logarithmic group count are proved
  in the prose report, not by this declaration.
* `refresh_separation`: positive real `u,s` outside the closed holding
  interval `[5*u/6,6*u/5]` obey
  `max u s / 6 <= abs (s-u)`.
* `refresh_credit`: positive real `u,s` and an arbitrary real `gap`
  satisfying that separation and
  `(s-u)^2/(2*max u s) <= gap` obey `(u+s)/144 <= gap`.
  It does not prove the analytic entropy-gap inequality; the integral
  proof of that premise is in the report.
* `retained_drop_constant`: all real `z>=0` and `0<=delta<=1/4`
  satisfy `1/(2*(1+z)) <= (1-delta)/((6/5)*(z+1+delta))`.
  In the application `z=alpha/h`. The formal range on delta is wider
  than the manuscript's range. Metric ramp separation, inner mass,
  and posterior membership are not encoded here.
* `finite_signed_payment`: for every natural horizon `n`, four arbitrary
  real sequences, and every real payment coefficient `c`, pointwise
  signed step inequalities, a zero sum of `filter` over the entire
  horizon, and a nonnegative terminal potential imply
  `c*sum pay <= phi 0 + sum cost`. This is a finite deterministic
  accounting theorem. Expected signed increments can be substituted
  after the prose conditional-expectation argument; the Lean theorem
  does not assert that a selected-event martingale sum vanishes.
* `anchor_bound_constant`: all real totals with `C>=1`, `e>=1`,
  `V,P,Q>=0` and the displayed scalar bound on `T/4` imply the
  manuscript-specialized explicit bound
  `T <= 1400*C*(V+e*P+e*Q)+(24/5)*endpoint`.
  `endpoint` is arbitrary and corresponds to `k*r0+C0*D_size`.
  The premise is not taken as the travel proof: the report derives it
  separately from all five ordered substeps.

The quantified metric/probability theorem and the affine-offset,
weighted-multiple-mover extension are prose results, not additional
declarations silently attributed to the compiler. Independent review
must check those proofs, the stated interfaces against the staged
sources, and this translation.
