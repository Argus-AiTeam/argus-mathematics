# Statement fidelity: scalar core of the weighted inverse estimate

This document describes only the declarations in `Main.lean`, all in
namespace `WeightedInverse`. The associated
ledger claim is `C_SWI_ALG`, not the complete analytic claim `C_SWI`.

All numerical variables in the first five declarations are arbitrary real
numbers. There is no finite sampling or discretization.

`squared_comparison` assumes `delta > 0`, `B >= 0`,
`energy >= 0`, and the three inequalities

    H^2 <= energy * lift
    delta * lift <= B * N
    delta * N <= energy + a * H.

It proves

    delta^2 * H^2 <= B * energy * (energy + a * H).

For the analytic application, `H` is the weighted squared norm of a closed
form, `N` its unweighted squared norm, `energy` its weighted adjoint energy,
and `lift` the weighted squared norm of an admissible unweighted minimal
primitive. `B = exp(b)` and `a = m*C0*t`. The three hypotheses respectively
come from the adjoint identity and Cauchy--Schwarz, comparison of the
primitive norms, and the Bochner estimate. Lean does NOT prove that these
analytic hypotheses hold.

`normalized_comparison` is the same implication with `H=1`.
It proves `delta^2 <= B*energy*(energy+a)`. Normalizing a nonzero analytic
form to weighted norm one therefore gives the desired quadratic inequality
for its Rayleigh quotient. A lower spectral band then has energy at most
`mu`, so the manuscript's inequality follows by monotonicity on nonnegative
numbers. The normalization and spectral statements are not encoded in Lean.

`quadratic_gap_lower_bound` assumes `mu >= 0`, `r > 0`,
`a >= 0`, and `r*(r+a) <= mu*(mu+a)`, and proves `r <= mu`.
Taking `r = (sqrt(a^2+4*delta^2/B)-a)/2` gives the sharp quadratic lower
bound when `B>0`. Lean proves the monotonicity implication, not that
substitution or a spectral theorem.

`inverse_squared_bound` assumes `mu > 0`, `s > 0`,
`a >= 0`, and `s^2 <= mu*(mu+a)`, and proves

    1/mu <= 1/s + a/s^2.

The analytic substitution is `s = delta*exp(-b/2)`. Thus the squared
minimal-inverse norm is at most
`exp(b/2)/delta + a*exp(b)/delta^2`. Taking square roots and using
`sqrt(x+y) <= sqrt(x)+sqrt(y)` gives the bound in the manuscript.
Neither exponentials nor Hilbert-space operator norms occur in this source.

`completing_square` proves the exact polynomial identity
`(2*mu+a)^2 = 4*mu*(mu+a)+a^2`. The Jacobian certificate independently
checks the same completed square over the rationals.

`curvature_sum_lower_bound` quantifies over any index type
with decidable equality, any finite subset `J`, any real-valued function on
the index type, and any real `c`. Assuming each selected value is at least
`-c`, it proves their sum is at least `-card(J)*c`. No sign assumption on
`c` is needed for this implication. In the analytic application `c=C0*t`
is nonnegative and `card(J)=q<=m`. The identification of the curvature
commutator on top-holomorphic-degree forms with that sum is proved in prose,
not encoded in Lean.

The source does not formalize complete manifolds, orbifolds, differential
operators, Chern connections, Bochner--Kodaira, spectral calculus, Serre
duality, or any of the manuscript's downstream theorems. A successful
compiler run certifies these universal algebraic implications only.
