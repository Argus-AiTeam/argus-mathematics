# Statement fidelity: exact angular-cover core

The claim is `C_ANGULAR_CORE`, in context `CTX_ANGULAR`. This is a
formal certification of the finite-selection and radial-budget core, not
a claim that Lean has formalized Euclidean cylinder area or the entire
manuscript. The source is `Main.lean`, namespace `AngularCertificate`,
using Mathlib and Lean 4.31.0.

## Objects and quantifiers

`finite_bracket` quantifies over every positive natural number `n`, every
real sequence `F : Nat -> Real`, and every real `y` with
`F 0 <= y <= F n`. It proves that some `j < n` satisfies
`F j <= y <= F (j+1)`. It assumes neither monotonicity nor strict endpoint
inequalities. It proves adjacent bracketing, not that the chosen index is
the least crossing; leastness is unnecessary for coverage.

`alpha a b = (1+a*b)/4`, `beta a b = (a+b)/4`,
`phi q = (1-q^2)/4`, and `d q = q^2*(1+q^2)/16` are real functions.
`shared_left`, `shared_right`, and `sector_transfer` prove the endpoint
identities and translate a bracket into the two closed sector inequalities.
The only additional hypothesis of `sector_transfer` is `a < b`. Its
conclusion includes nonnegativity of the radial intercept. For the upper
family substitute `t := 1-t`, `x := -y`, and `y := x`.

`radial_budget_identity` quantifies over arbitrary real
`a,b,e,x,y,p,q,al,ar,bl,br`. Here `a=t0-1/2`, `b=s0-1/2`;
`al,bl` are the lower selected axis coefficients and `ar,br` the upper
ones. Its three hypotheses are exactly

    a+b = -e*x*bl + e*y*br
    q*a = y-e*x*al-q/2
    p*b = x+e*y*ar-p/2.

It proves the radial-budget identity by polynomial combination, without
assuming cancellation or a coverage statement.

`radial_caps` quantifies over arbitrary real
`a,b,x,y,p,q,al,ar,bl,br,M,N`, with the following explicit hypotheses:

- `|x|,|y|,|p|,|q| <= 1` and `|x|+|y| <= 1`;
- `0 <= al,ar <= 1/2`, `|bl|,|br| <= 1/2`;
- `|bl-q/2|,|br-p/2| <= 1/16000000 = Delta/4`;
- `|al-(1+q^2)/4|,|ar-(1+p^2)/4| <= 1/8000000 = Delta/2`;
- `1/1000+d(q) <= M`, `1/1000+d(p) <= N`, and
  `M,N <= 1/8+1/1000`;
- the three intercept identities above, with `e=1/2000`.

Its conclusion is

    a <= (1/2000)^2*M OR b <= (1/2000)^2*N.

Thus it excludes simultaneous strict cap failure. It does NOT assume that
the radial excesses are positive: positivity is deduced inside the
contradiction argument from the hypothetical failures and the cap lower
bounds. The rough-angle and quadratic-energy bounds are proved in Lean
(`rough_angle`, `square_error`, `energy_bound`), not supplied as coverage
hypotheses. `surplus_identity` and `surplus_nonnegative` include the
degenerate case `p^2=q^2`. The positive final gap is the exact rational
`15983/16000000`.

`reciprocal_sqrt_majorant` quantifies over every nonnegative real `z` and
proves

    1/sqrt(1+z) <= 1-z/2+3*z^2/8.

It uses the actual nonnegative real square root. It does not merely prove
a squared inequality, and has no upper restriction on `z`.

## Bridges checked outside Lean

`report.md` proves the Euclidean interpretation, nondegenerate triangular
bases, and minimum projection area. It also instantiates the sequence
endpoints, identifies sector ratios when both caps hypothetically fail,
and proves that the mesh/cutoffs satisfy all the displayed hypotheses.
`verify.py` independently checks the endpoint and radial polynomial
identities, universal interval certificates for the secant bounds, the
nonnegative-square surplus, the positive rational gap, and the exact
finite area upper bound by polynomial power summation. The area formula
and its Euclidean projection interpretation are not Lean declarations.

The finite area sum is not evaluated by enumerating eight million sectors,
and sampled coverage is not used as a proof. The separate exact boundary
examples in the Python certificate are adversarial regression tests only.

There are no project axioms asserting the desired conclusion and no proof
holes. As usual, Lean's foundational axioms and Mathlib's kernel-checked
theorems are part of the formal environment. Independent Reviewer approval
of this translation and the remaining geometric bridges is still required.
