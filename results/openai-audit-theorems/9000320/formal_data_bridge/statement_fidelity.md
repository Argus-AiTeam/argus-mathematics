# Statement fidelity: actual ideals in the full-parameter correction

## Claim and scope

This document describes claim `C320_FORMAL_CORE` and the declarations in
`Main.lean`, namespace `FormalDataBridge`. The objects are an arbitrary
commutative ring `R`, actual ideals `I` and `J` of `R`, arbitrary coordinate
index types, and natural-number exponents. The formal source does not
assume that `R` is reduced, that `I` is radical, or that its generators
form a regular sequence. It never imposes `J^2 = 0`.

The source formalizes algebra used in sections E and F of `report.md`.
It does **not** formalize a marked cut decomposition, de Rham theory,
the construction of the vertex curvature list, a Chern--Simons action,
the endpoint-assignment theorem, MT's marked algebraicity, or the main
four-manifold conclusions. In particular a successful compile is not
a proof of claim `C320_FORMAL` or campaign completion.

## Objects, quantifiers, hypotheses, and conclusions

`square_zero_product` quantifies over every finite set of indices, one
element `t` with the individual relation `t*t=0`, and two indexed scalar
families `r,u`. Its conclusion is the exact identity

    t product_i(r_i + t u_i) = t product_i r_i.

All other source parameters may be elements of `R`; no mixed source
product is killed by a hypothesis. This verifies the monomial absorption
used to replace factors in `(I,t)` after multiplication by their own
source parameter. It is a scalar-coefficient statement; it does not
assert that matrices commute.

`taylor_remainder_ideal` quantifies over arbitrary `I,J`, exponent `q`,
an indexed displacement `delta`, and a remainder. Its hypotheses are
`delta_i in J^q I` for every coordinate and remainder membership in
the **square** of the ideal spanned by the displacement coordinates.
Its conclusion is membership in `J^(2q) I^2`. Neither existence nor
analytic differentiability of a potential is assumed or proved by this
declaration.

`newton_step` adds a Taylor identity and cancellation of the linear
term to the preceding hypotheses. It concludes the doubled-power ideal
membership for the new value. The linear cancellation is an explicit
hypothesis; choosing that displacement using an inverse gradient minor
is proved in prose in `report.md`, not hidden in the Lean theorem.

`error_zero_of_nilpotent` assumes `J^N = bottom`, `N <= q`, and
`e in J^q I^2`, and concludes `e=0`. `finite_newton_termination`
quantifies over finitely many steps of value, linear-term, remainder,
and displacement families. It assumes the initial error lies in
`J I^2`; at step `k`, displacement is in `J^(2^k) I`, the remainder
is quadratic in that displacement, the linear term cancels, and the
displayed Taylor identity holds. If `J^N=bottom` and `N <= 2^steps`,
the final value is zero. This is a finite-iteration verification, not
an assumption that a Newton iteration exists for arbitrary input.

`twenty_parameters_five_steps` is the numerical specialization:
`J^21=bottom` and an error in `J^(2^5) I^2` imply zero. The statement
does not itself construct the twenty-parameter quotient or prove its
pigeonhole nilpotency; that elementary generator argument is in the
report. The bound is uniform in the degree of the cyclic cover.

`unit_of_nilpotent_congruence` assumes `J^N=bottom`, `u` is a unit,
and `v-u in J`. It concludes `v` is a unit. Applied to the selected
determinants, this is the minor-stability fact. It does not construct
the original unit minor from topological duality.

`polynomial_congruence` quantifies over every multivariate polynomial
and coordinate families congruent modulo the actual ideal `I`.
It concludes that their evaluations are congruent modulo `I`.
`polynomial_membership_transport` adds membership of one evaluation
in `I` and concludes membership of the other. The coefficient ring
may contain all the nilpotent parameters. These declarations are about
polynomials, not unrestricted formal power series; extending the
application to a convergent formal substitution in a complete
Noetherian ring uses ideal-closedness as explained in the report.

## Fidelity limitation

The imported MT single-cut and marked-algebraicity theorems remain
explicit external assumptions in the ledger. The compiler does not
check their truth, the geometric realizability of cuts, the report's
prose deductions, citation fidelity, or novelty. Independent review of
those questions is still required.
