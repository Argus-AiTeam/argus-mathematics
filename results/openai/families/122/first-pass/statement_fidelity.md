# Statement fidelity: the universal contour algebra

`research/Main.lean` uses Lean 4.31.0 and Mathlib. Its namespace is
`PositiveMomentMultiscale`. Claim `C_MULTI_ALG` is the universal real
coercivity and weighted-Young part of the multiscale proof, not the
entire multiscale proposition.

The definitions are exact real rational expressions:
`rho=500/1001`, `delta=1-4*rho^2`, `cOne=delta/2`,
`cFour=3+(4+rho)^2*(1+8*rho^2/delta)`, and `beta=2^-48`.

* `four_sum_sq` quantifies over four arbitrary real numbers and proves
  the four-term squared-sum inequality. There is no bounded search.
* `four_factor_coercivity` quantifies over five arbitrary reals, including
  an arbitrary real slope `r`. It proves
  `(1-4*r^2) sum(a_i^2) <= sum(a_i^2)-r^2(sum a_i)^2`.
  The separately proved `delta_positive` makes this a genuinely
  coercive bound at the specified slope. `rho_range` and `cOne_lower`
  prove the stated exact numerical margins.
* `weighted_young_identity` is an identity for every real `x,b`. Its
  right side is a nonnegative square with positive rational coefficient.
  `contour_young` proves the resulting upper bound for every real `x,b`;
  it does not assume either is positive.
* `bent_energy` quantifies over real `b,x,omega`, assumes `b>=0`, `x>=0`
  and `abs(omega)<=2*x+b`, and proves the precise worst-four-factor
  contour quadratic estimate. In the analytic proof, `x` is the
  Euclidean norm of the imaginary coordinates, padded to four entries;
  that application of the hypothesis is proved in prose.
* `explicit_contour_constants` certifies the mass, tail, and retained-box
  outer-decay numerical margins for `K=2^16` and `beta=2^-48`.
  `sector_bound` quantifies over real `b,omega` with `b>=0` and proves
  `abs(omega)<=2.002*(b+rho*abs(omega))`.
* `endpoint_two`, `endpoint_three`, and `endpoint_four` quantify over
  arbitrary complex coefficients, positions, and center. They prove the
  endpoint/gap telescoping identities with the minus signs used by the
  contour. Positions need not be real or ordered for these identities.
  Ordering, positive dampings, and the one-factor case are handled in
  the mathematical report.

The compiler checks these algebraic statements and their proofs only.
It does not check the translation from a truncated Boolean functional,
Cauchy matching, Gaussian integration/deformation, the existence of an
interleaving witness, graph-to-gap matching, or the complete `7.84`
theorem. Those universal arguments are in `research/audit_report.md`
and require independent mathematical review. No compilation of this
file is represented as kernel closure of `C_MULTI_STRONG` or
`C_MULTI_LITERAL`.
