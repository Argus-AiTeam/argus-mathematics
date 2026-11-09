# Statement fidelity: scalar pair-response algebra

The declarations in `Main.lean` certify the algebraic core of
`report.md`, not its analytical or stochastic arguments.

`PairResponse.real_power_slots` quantifies over arbitrary real incoming
mass `a`, real nonzero child mass `b`, real occupied-child count `k`,
and every natural slot count `n`. `falling x n` is the falling product
`x (x-1) ... (x-(n-1))`; `childSlots a b k n` is the product of
`a-(k+j)b` for `0 <= j < n`. The theorem is
`b^n falling(a/b-k,n) = childSlots(a,b,k,n)`. It requires only
`b != 0`; positive masses and integer occupied counts are applications,
not extra encoded conclusions. `real_power_factor` is its induction
step. This is report equation (12).

`PairResponse.colored_prefix_cancellation` quantifies over ten arbitrary
real numbers `p F u c cz czz jz jzz S Qpast`. `prefixCurvature` is
exactly the left side of report equation (20), with
`H = p F u - S`. The conclusion is exactly its right side. The
declaration does not assume or prove that any of these numbers is a
derivative, scalar spin moment, or Gaussian conditional expectation.
Those identifications and the weighted integration-by-parts calculation
are in report Sections 1 and 5.

`PairResponse.one_sheet_constant` and `one_sheet_additive` quantify over
arbitrary real `p q r` and prove the two displayed polynomial
specializations of (H2). No moment admissibility is inferred from this
quantification. In the actual one-sheet scalar model, `q` and `r` are
the second and fourth moments of its conditional spin mean.

`PairResponse.child_mixed_difference` is the scalar product-difference
identity behind report equation (25). It assumes no independence.

`PairResponse.gram_energy_nonneg` has an arbitrary finite marker type,
arbitrary sample and time types, real functions `m`, `v`, `weight`,
`alpha`, and `f`, and two positive functionals `E` and `I`.
Positivity of these functionals on every pointwise nonnegative
function is an explicit hypothesis, as are nonnegativity of `weight`
and `alpha`. The conclusion is nonnegativity of the sum of their
weighted-square expressions, the algebraic form of report (8).
`gram_decrement_nonneg` proves the corresponding integral-term
nonnegativity in (9). The functions need not be random variables and
the functionals are not constructed as integrals in Lean.

In particular, no declaration proves a Parisi PDE theorem, Ito's
formula, Gaussian integration by parts, interchange of derivatives and
expectations, existence or continuity of impulse derivatives, the
identity between the manuscript Hessian and the Gram energy,
real-mass transfer for arbitrary old-label topologies, uniform analytic
derivative bounds, or an SK fluctuation or limiting-law theorem.
Those obligations remain with the mathematical report and its
independent Reviewer. The compiler certificate is attached only to
ledger claim `C_PAIR_ALGEBRA`.
