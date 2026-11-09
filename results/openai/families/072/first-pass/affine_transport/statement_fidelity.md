# Statement fidelity: the formal transport core

`Main.lean` uses Lean 4.31.0 and Mathlib. It proves the declarations below
without additional axioms or proof holes.

- `le_of_small_error` and `exhausted_comparison` quantify over real numbers
  and a sequence indexed by natural numbers. The former passes from every
  positive additive error to an exact inequality. The latter combines
  finite-cutoff upper bounds with an explicitly assumed exhaustion from
  below. It does not silently assume monotonicity, convergence, a probability
  law, or a spatial area formula.
- `box_factor_bound` bounds the actual product of the horizontal and
  logarithmic-height enlargement factors once both errors are between zero
  and epsilon/4 and 0 < epsilon <= 1. The proof in `report.md` establishes
  that the manuscript boxes meet these hypotheses at fixed cutoff.
- `strict_gain_forces_zero` quantifies over any measurable space, any measure,
  and three real-valued integrable functions `pos`, `neg`, and `gain`.
  The hypotheses require almost-everywhere nonnegativity of `pos` and `neg`,
  `pos <= gain`, strict inequality wherever `pos > 0`, a transport bound
  `integral gain <= integral neg`, and balanced positive/negative integrals.
  The conclusion is that both functions vanish almost everywhere. No
  uniformly positive gain, bounded multiplier, or finite total measure is
  assumed. In the application the exceptional-root lemma removes the bad
  fibers; the weighted area comparison supplies gain integrability and
  its transport bound. Those analytic premises are proved in `report.md`,
  not assumed to be formal consequences of the manuscript's notation.
- `inverse_square_endpoint` and `inverse_first_endpoint` quantify over real
  beta and real expected Jacobian `j`. Nonpositivity of `j`, the respective
  moment identity, and the contrary lower bound on beta force beta = 1 and
  beta = 1/4, respectively. They do not prove existence of a law or the
  exclusion of the latter equality case.
- `quadratic` is exactly
  `((z-t)^2-(i-t)^2)/(2*(i-t))`, for real `t` and complex `z`.
  `quadratic_denominator_ne_zero` proves the denominator nonzero for every
  real vertex. `quadratic_at_i` proves its zero normalization.
  `quadratic_injective_on_upper_half_plane` proves injectivity restricted
  to the set of complex numbers with strictly positive imaginary part,
  without a boundedness or boundary-extension assumption.

The source does **not** formalize the construction of the weighted law,
compact-superlevel proof, Morse/index count, Borel rank pairing, or the
analytic classification of all zero-Jacobian maps. It does not encode the
full claim `C_AT_ENDPOINT`. Those parts have a complete mathematical proof
in `report.md` and require independent human/Reviewer scrutiny. The separate
claim `C_AT_FORMAL` names exactly the formal results above.
