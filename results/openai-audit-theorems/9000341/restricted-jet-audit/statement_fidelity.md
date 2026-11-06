# Statement fidelity: restricted first-jet algebra

The formal source is `Main.lean`, namespace `RestrictedJet`.
Every coordinate and scalar is real. `V = Fin 4 -> Real` is the
real tangent space of a complex surface in a complex-linear frame.
`J(v0,v1,v2,v3)=(-v1,v0,-v3,v2)` is the standard complex structure.
`formA` and `formH` are respectively the real and imaginary parts
of `dz_1 wedge dz_2`, with the real coordinate ordering
`(Re z_1, Im z_1, Re z_2, Im z_2)`.

All theorems universally quantify over their displayed vector and
scalar arguments. There are no hidden smoothness, positivity,
nonvanishing, or geometric-existence hypotheses.

- `J_squared` states `J^2=-I`.
- `pullback_identity_A` and `pullback_identity_H` state the exact
  identities `Q(u,v)=-2 Q(u,J((u+Jv)/2))` for arbitrary real
  vectors `u,v`, not merely a holomorphic tangent pair. These
  encode the algebra used before differentiating the manuscript's
  `eq:pencil-pullback-linearization`.
- `normal_A` and `normal_C` compute the two pullback linear forms
  for tangent vector `(a,b,0,0)` and arbitrary residual `e`.
  Here `C=x A+y H`. No nonvanishing is assumed for these identities.
- `normal_determinant` states that the determinant of their
  two-by-two normal matrix is `4*y*(a^2+b^2)`.
- `normal_kernel` states that zero values of both normal
  pullbacks imply `r=s=0`, **assuming explicitly** `y!=0` and
  `a^2+b^2!=0`. It does not assert invertibility at a critical
  tangent or a degenerate pair. Geometrically those hypotheses
  hold on the immersion locus of a definite pair.
- `real_symbol_norm`, `symbol_product`, `symbol_kernel`, and
  `symbol_injective_nonzero` prove the real Cauchy--Riemann
  symbol's injectivity at every nonzero real covector.
  `symbol(s,t)=s I+t J`, and its product with `s I-t J`
  is `(s^2+t^2)I`. The factor of one half in the geometric
  operator does not affect injectivity. This is the algebra
  used in the highest-order comparison in
  `eq:pencil-point-distribution`; distributions, variable
  coefficients, and that comparison are not formalized.
- `polynomial_symbol_norm` proves that `X_0^2+X_1^2` is a
  nonzero element of `Real[X_0,X_1]`, by evaluation at `(1,0)`.
  `polynomial_symbol_kernel` quantifies over six arbitrary
  elements `p,q,r0,r1,r2,r3` of that polynomial ring. Assuming
  explicitly `p^2+q^2!=0`, the four equations for
  `(p I+q J)(r0,r1,r2,r3)=0` imply all four `r` polynomials
  vanish. In particular this applies to `p=X_0,q=X_1` and
  to the adjoint-sign variant `q=-X_1`. There is no degree
  bound or finite search over jets. This certifies the
  algebraic impossibility of a nonzero highest-order
  coefficient polynomial once the analytic distribution
  comparison has produced those equations. It does not
  produce that comparison or prove distributional regularity.
- `independent_first_jets` proves that prescribing
  `w_s=e+h`, `w_t=J(h-e)` realizes independently the
  antiholomorphic and holomorphic derivatives `e,h`.
  It is an algebra statement, not an assertion that an arbitrary
  Sobolev jet admits point evaluation. The prose proof applies
  it to smooth variations at a critical point with `w(z)=0`.
- `period_recovery` proves surjectivity of the period derivative
  `-b I_2` by the preimage `(-p/b,-q/b)`, for arbitrary
  `p,q` and **explicitly nonzero** `b`. The geometric input
  `b=<B,F>>0` supplies this hypothesis.

The source does not prove a global analytic surjectivity theorem,
the exactness or support of an ambient perturbation, curve
compactness, nonsplitting, positivity of a perturbed triple,
Sard--Smale, a Fredholm index formula, or the manuscript's main
theorem. These conclusions and their assumptions are separated in
`argument.md`. A successful compiler run supports `JET_ALGEBRA`
only. This fidelity reading is authored by Engineer and still
requires independent Reviewer assessment.
