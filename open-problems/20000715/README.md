# Result 20000715

## Differential equations and linear-ODE obstructions for $\eta$-products (AIM Problem 1.2)

**Status:** independently reviewed premise correction and differential obstruction<br>
**Field:** modular forms and differential algebra

AIM Problem 1.2 asks whether $\eta$-products (grouped with mock modular forms in the problem prompt) satisfy differential equations other than holomorphic anomaly equations.

For the discriminant modular form $\Delta(\tau) = \eta(\tau)^{24}$, this package establishes:

1. **Explicit third-order nonlinear algebraic differential equation:** via the Ramanujan system $D E_2 = (E_2^2-E_4)/12$, $D E_4 = (E_2 E_4 - E_6)/3$, $D E_6 = (E_2 E_6 - E_4^2)/2$, $D(\eta^{24}) = E_2 \eta^{24}$, and $1728\eta^{24} = E_4^3 - E_6^2$, $\eta^{24}$ satisfies an explicit polynomial differential equation of order 3 over $\mathbb Q$ (verified to zero symbolic remainder).
2. **All-order homogeneous $\mathbb C(q)$-linear ODE obstruction:** using arbitrary-order radial flatness at the dense cusp $q \to e^{2\pi i c/d}$ and analytic continuation from ordinary points, $\eta^{24}$ satisfies **no** nonzero finite-order homogeneous linear differential equation with coefficients in $\mathbb C(q)$.

## Boundary

Classical $\eta$-products are modular/cusp forms rather than non-modular mock modular forms; this package clarifies the premise for $\eta^{24}$ and does not resolve nonlinear differential equations for genuine mock theta functions in AIM Problem 1.2.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20000715_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_20000715_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `eta_status_resolution.md` | Full derivation of the 3rd-order nonlinear ODE and the all-order $\mathbb C(q)$-linear obstruction |
| `eta_exact.py` | Symbolic verifier for the Ramanujan differential elimination |
| `eta_exact_result.json` | Verification output |
| `reviewer-eta-exact-result.json` | Independent Reviewer verification receipt (21 exact checks) |
| `reviewer-normal-form.output.json` | Independent normal-form remainder verification |
| `verification-summary.json` | Structured verification summary |
