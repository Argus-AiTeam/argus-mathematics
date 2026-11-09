# Reading of the historical formal subset

This replay source is an exact copy of the listed old `Main.lean`. It does
not formalize the review claim, the manuscript theorems, or `C_AT_ENDPOINT`.
The replay claim `C_REPLAY_FORMAL` concerns only these declarations in
namespace `AffineTransport`.

| Declaration | Objects, hypotheses, and conclusion |
|---|---|
| `le_of_small_error` | Real numbers a,d; a <= d+epsilon for every positive real epsilon implies a <= d. |
| `exhausted_comparison` | An arbitrary real sequence a and reals b,d; each a(n) is at most d plus every positive error, and for every positive error some a(n) approximates b from below; conclude b <= d. Monotonicity and a probability law are not asserted. |
| `box_factor_bound` | Real nonnegative h,v, 0 < epsilon <= 1, h,v <= epsilon/4; conclude (1+h)(1+v) <= 1+epsilon. No spatial boxes or limits are encoded. |
| `strict_gain_forces_zero` | Any measurable space and measure; real integrable pos,neg,gain; pos,neg nonnegative almost everywhere; pos <= gain almost everywhere with strict inequality wherever pos > 0; integral gain <= integral neg and integral pos = integral neg. Conclude pos and neg vanish almost everywhere. Integrability of the unbounded gain is a hypothesis, not a derived transport result. |
| `inverse_square_endpoint` | Real beta,j; beta >= 1, j <= 0, and the displayed second-power moment identity imply beta = 1. No random variable, law, or geometric Jacobian is defined here. |
| `inverse_first_endpoint` | Real beta,j; beta >= 1/4, j <= 0, and the displayed first-power moment identity imply beta = 1/4. It does not exclude this equality case. |
| `quadratic` | The complex-valued function ((z-t)^2-(i-t)^2)/(2(i-t)), t real, z complex. |
| `quadratic_denominator_ne_zero` | For every real t, the complex denominator 2(i-t) is nonzero. |
| `quadratic_at_i` | For every real t, quadratic(t,i) = 0. |
| `quadratic_injective_on_upper_half_plane` | For every real t, this quadratic is injective on the set of complex numbers with strictly positive imaginary part. |

Holomorphy and derivative normalization F'(i)=1 are elementary facts of
this polynomial formula, but are not the conclusions of declarations in
this file. Compact-family bounds, exact affine laws, compact superlevels,
critical-point counts, Borel selection, exceptional-root transfer, the
area comparison, moment differentiation, zero-Jacobian rigidity, and
uniqueness of the Cauchy law are all outside this formalization.

The compiler and axiom audit decide the encoded statements only.
Standard Lean/Mathlib logical foundations are not a formalization of those
missing analytic premises. This reading is the current Engineer's
interpretation; it still requires the native independent Reviewer's
statement-fidelity assessment.
