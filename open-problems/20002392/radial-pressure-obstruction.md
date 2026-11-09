# A critical-weight obstruction to the coefficient one half

## Status and exact statement

This analytic lower-bound theorem and its exact symbolic certificate were
accepted in the preceding independent review. It is not a Navier--Stokes profile, a
counterexample to Navier--Stokes regularity, or a proof that `beta_star < 1`.
Novelty and publishable significance have not been independently established.

Let `H = {x_3 > 0}` and let `Pi_H` be the **unweighted** orthogonal Helmholtz
projection. For

    V in C_c^infinity(closure H; R^3), div V = 0, V|_(x_3=0) = 0,
    grad p_S[V] = (I - Pi_H) Delta V,

define

    beta_star = sup_(V != 0)
      integral_H |x| |grad p_S[V]|^2 / integral_H |x| |Delta V|^2.

**Theorem.** For precisely this three-dimensional test class,

    beta_star >= 4 log(2) / (25 log(2) - 12)
              > 4492/8635 > 13/25 > 1/2.

In particular, the coefficient `1/2` is false for the radial-weighted estimate
even after imposing solenoidality. This lower-bound argument does not settle
`beta_star < 1`. The subsequent, separate all-frequency proof in
`radial-pressure-upper-bound.md` supplies the upper coefficient `999/1000`.

The closest verified comparison is Liu--Liu--Pego, Theorem A.1: the
**unweighted** half-space commutator estimate has coefficient `1/2` for all
zero-trace `H^2` fields. On solenoidal fields its commutator is `grad p_S`.
That source's sharpness example is not solenoidal. Cozzi--Pego's weighted
cone estimates are planar and do not imply this statement. See
`radial-pressure-upper-bound.md`, section 7, for the integrated comparison
with the exact planar coefficient and later pressure/coercivity results,
and `literature/boundary-pressure-sources.md` for primary locators.

## 1. An explicit homogeneous solenoidal field

Write `r=|x|`, `omega=x/r`, `t=omega_3`, and `p=1-t^2`. Define

    A(t) = t^2/4 + t/8 - log(1+t),
    B0(t) = t(1-2t) / (8(1+t)^2),
    C0(t) = -t^2 / (2(1+t)),

and

    V_1 = A(t) + B0(t)(omega_1^2 - omega_2^2),
    V_2 = 2 B0(t) omega_1 omega_2,
    V_3 = C0(t) omega_1.

These Cartesian formulas are smooth on the closed hemisphere, including its
pole. All their denominators are positive for `0 <= t <= 1`. They define a
degree-zero field on `closure H \ {0}`, with zero wall trace.

In cylindrical components, with `omega_1=sqrt(p) cos(phi)`, put
`B=p B0` and `C=sqrt(p) C0`. Then

    V_rho = (A+B) cos(phi),
    V_phi = (-A+B) sin(phi),
    V_3   = C cos(phi).

The divergence identity, multiplied by `r sqrt(p)`, is the rational identity

    -t p (A'+B') + 2B + p(p C0' - t C0) = 0.

Consequently `div V=0` throughout the half-space. The apparent cylindrical
singularity at the pole is removable by the Cartesian formulas above.

Let `D(omega)=r^2 Delta V(x)`. Its Cartesian components are

    D_1 = D0(t) + D2(t)(omega_1^2-omega_2^2),
    D_2 = 2 D2(t) omega_1 omega_2,
    D_3 = (3t-1) omega_1,

where

    D0(t) = 3/2 - t/4 - 3t^2/2,
    D2(t) = (6t^2+7t-4) / (4(1+t)^2).

For example, the three scalar identities verifying this Laplacian are

    (p A')' = D0,
    p B0'' - 6t B0' - 6B0 = D2,
    p C0'' - 4t C0' - 2C0 = 3t-1.

The exact script checks these identities symbolically, not on a grid.

## 2. The pressure is the canonical one, not a harmonic addition

For a compact smooth solenoidal zero-trace field, set
`b(x')=partial_3 V_parallel(x',0)`. Tangential differentiation of the zero
trace and the divergence equation gives

    (Delta V)_3|_wall = -div' b.

The finite-unweighted-energy harmonic pressure therefore satisfies
`partial_3 p_S|_wall=-div' b`. With the Fourier convention
`hat f(xi)=integral exp(-i x' dot xi) f(x') dx'`, it is

    p_S_hat(xi,z) = i (xi/|xi|) dot b_hat(xi) exp(-|xi|z), xi != 0.

Indeed this solves the Neumann condition, and its gradient is the gradient
part of `Delta V`: integration by parts against smooth scalar tests gives
the defining orthogonality identity. The finite-energy gradient is unique.
The zero frequency introduces no free affine pressure.

Equivalently, with

    N_z(x') = 1 / (2 pi sqrt(|x'|^2+z^2)),

one has `p_S = sum_j (partial_j N_z) * b_j`. This agrees with
Liu--Liu--Pego (A.2), but also follows from the elementary Fourier transform
`hat N_z=exp(-|xi|z)/|xi|`.

The homogeneous field of section 1 is not itself in the test class. Its wall
shear is, for `rho=|x'|>0`,

    b_rho = -(3/4) cos(phi)/rho,
    b_phi = sin(phi)/rho.

Thus `div' b=cos(phi)/rho^2`, distributionally as well as away from zero:
the flux through a circle has zero angular mean, and the remaining small-circle
boundary term against a smooth test tends to zero.

The convolution defining `p_S` and its gradient is absolutely convergent at
each interior point for this homogeneous shear. At the boundary origin
`|b|=O(1/rho)` is locally integrable; at infinity the pressure kernel times
`b` is integrable. Homogeneity and rotation covariance show that the result
has degree `-1` and scalar azimuthal mode one. A harmonic of that degree,
smooth at the upper pole, has angular part proportional to

    q(t) = sqrt((1-t)/(1+t)).

This follows either by solving the angular ODE or by direct substitution,
with regularity at the pole selecting its one-dimensional regular solution.
Since `q(0)=1` and `q'(0)=-1`, the Neumann condition fixes the coefficient.
The resulting pressure is exactly

    P(x) = q(t) cos(phi)/r = x_1 / (r(r+x_3)).

There is no arbitrary harmonic pressure in this construction.

## 3. Exact angular energies

On the upper unit hemisphere, `d omega = dt d phi`. The azimuthal integrations
give

    (1/pi) integral |D|^2 d omega
      = integral_0^1 [2D0^2 + 2p^2 D2^2 + p(3t-1)^2] dt
      = (25/2) log(2) - 6 =: E_D,

and

    (1/pi) integral |r^2 grad P|^2 d omega
      = integral_0^1 [q^2 + p(q')^2 + q^2/p] dt
      = integral_0^1 [(1-t)/(1+t) + 2/(1+t)^2] dt
      = 2 log(2) =: E_P.

The gradient includes the radial derivative of the degree `-1` pressure;
omitting it would change the numerator. The homogeneous integrals in `H`
diverge logarithmically and are **not** themselves an admissible test.
The next step, rather than a formal cancellation of infinities, is necessary.

## 4. Solenoidal compactification and the infinite-domain limit

Choose any nonzero real `eta in C_c^infinity(R)`, for instance
`eta(s)=exp(-1/(1-s^2))` for `|s|<1` and zero otherwise. For `L>0`, put

    s = log r,  chi_L(s)=eta(s/L),
    A_vec(x) = -(1/2) x cross V(x),
    V_L = curl(chi_L(log r) A_vec).

The identity
`curl(x cross V)=-2V` follows from `div V=0` and degree-zero homogeneity.
Consequently, if `W=V-(V dot omega)omega`, then

    V_L = chi_L V + (chi_L'/2) W,

where primes on `chi_L` mean derivatives in `s`. Every `V_L` is real, smooth
on the closed half-space, zero in neighborhoods of zero and infinity,
divergence-free, and zero on the wall. In particular no divergence correction
or unproved density assertion is being used.

The exact Laplacian formula is

    r^2 Delta V_L =
      chi_L D
      + chi_L'  (V + Delta_S W/2)
      + chi_L'' (V + W/2)
      + chi_L''' W/2.

All angular coefficients are smooth. Since
`integral_H r |Delta V_L|^2 dx = integral_R integral_S+ |r^2 Delta V_L|^2 d omega ds`,
the remainder after `chi_L D` has `L^2(ds d omega)` norm `O(L^(-1/2))`.
The leading term has norm `O(L^(1/2))`. Therefore

    lim_(L->infinity) (1/L) integral_H r |Delta V_L|^2
      = pi E_D integral_R eta(sigma)^2 d sigma > 0.                 (4.1)

This retains all radial cutoff derivatives.

Let `b_L=partial_3(V_L)_parallel|_wall`. Direct differentiation gives

    b_L = chi_L b + (chi_L'/2)(b-(b dot e_rho)e_rho).

Fix `sigma in R` and write `R_L=exp(L sigma)`. Then for each `x' != 0`,

    R_L b_L(R_L x') -> eta(sigma) b(x'),
    |R_L b_L(R_L x')| <= C/|x'|,  L>=1,

where `C` is independent of `L,sigma`. Use the canonical convolution above.
For each fixed `omega` with `omega_3>0`, the gradient kernel
`grad partial_j N_(omega_3)(omega'-x')` is bounded near `x'=0` and is
`O(|x'|^(-3))` at infinity. Its product with `1/|x'|` is integrable over
the boundary plane. Dominated convergence, after rescaling that convolution,
therefore gives

    R_L^2 grad p_S[V_L](R_L omega)
      -> eta(sigma) grad P(omega).                                (4.2)

For each fixed `L`, the canonical pressure has finite `r`-weighted gradient
energy: it is smooth near the origin and its gradient is `O(r^(-3))`
at infinity, since `b_L` is smooth and compactly supported. Now change
variables `s=L sigma` in that weighted energy and apply Fatou's lemma to
the nonnegative integrand in `(sigma,omega)`. Equation (4.2) yields

    liminf_(L->infinity) (1/L) integral_H r |grad p_S[V_L]|^2
      >= pi E_P integral_R eta(sigma)^2 d sigma.                    (4.3)

No unproved boundedness of the weighted pressure operator is needed for
this passage. Boundary angles form a measure-zero set in the hemisphere;
no uniform estimate as `omega_3 -> 0` is asserted or used.

Dividing (4.3) by (4.1) proves `beta_star >= E_P/E_D`. It also proves that
all sufficiently large members of this exact compact-support family violate
coefficient `13/25`; no particular finite value of `L` is claimed here.

## 5. Rational separation and replay

The convergent positive series for `2 atanh(1/3)` gives, using its first two
terms and a geometric majorant for the remaining terms,

    56/81 < log(2) < 56/81 + 1/540 = 1123/1620.

The majorant is strict because the later denominators exceed the first
omitted denominator. On this whole rational interval,

    25 x - 12 >= 428/81 > 0,
    52 - 75 x >= 1/108 > 0.

Thus `4x/(25x-12)>13/25` there. The function is strictly decreasing,
and evaluating it at the upper endpoint gives `4492/8635`.

Replay the exact algebra and rational separation with:

    /home/argustest/zimo/argus-live-update/.venv/bin/python research/certify_pressure_obstruction.py

The script checks symbolic identities on their full domains, the exact
definite integrals, endpoint regularity factors, and rational inequalities.
It does not mechanically certify the analytic arguments of section 4.
Those are part of the proof for independent human review.

The matching bounded Jacobian operation is
`polynomial.box.enclosure.compute`; its exact request and typed response
are in `jacobian/pressure-gap-payload.json` and
`jacobian/pressure-gap-output.json`. The adapter result certifies only the
stated rational-box inequality, not the Navier--Stokes objective.

## 6. What remains between this result and the live objective

The universal strict upper estimate is addressed by the subsequent proof in
`radial-pressure-upper-bound.md`, not by this lower-bound construction.
The finite Mellin experiments in `pressure_modes.py` are lower-dimensional
tests, not an upper bound over all frequencies, angular modes, or fields.
The construction here instead proves a lower bound for the full compact
three-dimensional test class.

The subsequent `critical-alignment-exclusion.md` retains the wall pressure,
nonlinear pressure, critical drift/Hardy contribution, and infinite-domain
terms to obtain an explicit alignment criterion. None is discharged by this
lower-bound theorem alone. The older lower-bound certificate's unestablished
upper-bound/profile flags describe its scope at the time of that run.
Independent certification, novelty and publishable significance remain open.
