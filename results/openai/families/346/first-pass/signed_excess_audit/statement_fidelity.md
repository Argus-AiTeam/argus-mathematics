# Finite algebra in the signed-excess concentration bridge

`SignedExcessAudit.finite_weighted_flux_fourth` quantifies over an arbitrary
type, an arbitrary finite subset, nonnegative real weights, and arbitrary real
arrays `v` and `q`. It proves

\[
(\sum w_i v_i q_i)^4
\leq (\sum w_i v_i^4)(\sum w_i q_i^2)^2(\sum w_i).
\]

There are no positivity hypotheses on the height or flux arrays, and zero
weights and the empty set are allowed. The weights represent the entire
weighted mass, not Jacobian-weighted mass; hence the algebra does not discard
singular projected mass. The proof uses two weighted Cauchy--Schwarz
inequalities. Restricting the finite set gives the same inequality on an
exceptional set.

`interpolation_exponent` is the exact real algebraic exponent identity in
the interpolation of the dyadic increment bounds.
`uniform_concentration_exponent` proves positivity of
`1/(2(m+1))` and the lower bound `1/2` for `1-m/(2(m+1))`, for every natural
dimension (including zero as a harmless algebraic extension).

**Fidelity boundary:** These declarations do not encode varifolds, stationarity,
projection fibers, infinite sums, Gaussian localization, or publication
novelty. The fourth-moment inequality is an algebraic special case of the
analytic Holder step; its use with a geometric fourth-moment estimate is
restricted to dimensions where that moment is admissible. General dimensions
in the mathematical proof use `p=2(m+1)/m`, not an inadmissible fourth moment.
A successful compiler run certifies only claim `C_FINITE_HOLDER` and these
explicit algebraic supporting declarations. It does not certify
`C_CONCENTRATION`, `C_LT_CONFIG`, either main regularity theorem, or the new
endpoint analytic refinement. Those require independent mathematical review.
