# Statement fidelity: RefinedReport

`Main.lean` formalizes the pointwise cancellation and cylinder structure,
the exact arithmetic error budget, its algebraic implication for the
Gaussian deficit, and the Archimedean finite-iteration step. It does not
formalize Gaussian integration, weak convergence, conditional expectation,
Fourier degree, or the final Boolean existence theorem.

The declarations described below have the unqualified names `bit`,
`prod_bits`, `reporting_cancellation`, `cylinder_invariance`, `ordinary_cell`,
`gaussian_deficit_identity`, `explicit_error_budget`,
`strict_gaussian_margin`, `bernoulli`, and `finite_amplification`, all
inside the namespace `RefinedReport`.

`RefinedReport.bit` is the real-valued indicator of an arbitrary proposition.
`RefinedReport.prod_bits` identifies a finite product of these indicators
with the indicator of their conjunction.

`RefinedReport.reporting_cancellation` quantifies over arbitrary types `U`
and `Z`, any natural number `m`, any total selector `U -> Fin m`, arbitrary
coordinate tests `Fin m -> Z -> Prop`, and every input `(u,z)`. Its left
side is exactly the indicator of "every unselected leaf passes, but not
every leaf passes." Its right side is the sum of the selected-index
indicators times the products of the unselected-leaf indicators, minus
the product of all leaf indicators. No independence, continuity,
non-atomicity, finite-alphabet, or generic-position hypothesis is assumed.
Although a common type `Z` is used, heterogeneous finite alphabets embed
in their disjoint union; the theorem restricts to every such product.

`RefinedReport.cylinder_invariance` proves that the term indexed by `i`
is unchanged when only leaf `i` changes. It may depend on the center
and the other `m-1` leaves. The all-leaf product in the cancellation
identity omits the center. This is the coordinate-saving algebra, not
a theorem about ignoring a single fixed coordinate for the entire report.

`RefinedReport.ordinary_cell` describes an attained `P^c` report. The
fixed center selects `i` and the fixed unselected leaves include a
failed test. Under these explicit hypotheses, the cell imposes no
condition on leaf `i`. The theorem proves equivalence of the report's
full predicate with equality of just its `m` reported coordinates.

`RefinedReport.gaussian_deficit_identity` is the polynomial subtraction
`(-p*J)-(-p*(1+S)) = p*(1+S-J)` for all real `p,S,J`.
`RefinedReport.explicit_error_budget` proves the unconditional exact
numerical inequality
`3576000/2^124 + 4704/2^2560 < 1/2^101`.
`RefinedReport.strict_gaussian_margin` derives a deficit greater than
`3p/4` from `p>0`, `S>=0`, and `J` at most that explicit budget. It does
not assume the gain it proves. The interpretation of `p,S,J` as the
Gaussian quantities and the analytic bound on `J` are proved in
`report.md`, not in Lean.

`RefinedReport.bernoulli` proves `(1+a)^k >= 1+k*a` for every real
`a>=0` and natural `k`. `RefinedReport.finite_amplification` consequently
proves that, for every real `a>0` and every real target, some finite
natural exponent has `(1+a)^k` above that target. It does not assert
the existence of the finite observations used to realize those factors.

There are no project axioms or proof placeholders. Mathlib and Lean's
ordinary foundational axioms are the formal dependencies. The compiler
checks the declarations above; the correspondence to the reporting
construction and the remaining analytic/probabilistic proof require
independent mathematical review.
