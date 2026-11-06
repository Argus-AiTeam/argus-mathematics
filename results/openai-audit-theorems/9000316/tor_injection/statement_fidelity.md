# Statement fidelity: Laurent fillings and exponent-floor representatives

The claim is `C316_TRUNCATION`, not the complete Steenrod Tor-injection
claim `C316_TOR`. `Main.lean` uses Lean 4.31.0 and Mathlib.

`TorInjection.Laurent V` is the finitely supported function space
`Int ->₀ V`. Its integer coordinate is the exponent of `d0`.
The coefficient space can contain all other polynomial monomials and
resolution generators; no bound on its dimension is imposed.
`Above n f` means every coefficient below integer `n` is zero.
`AtFloor n f` means every coefficient except the one at `n` is zero.
`cutAbove n` discards all coordinates below `n` and preserves finite
support. These definitions do not use analytic convergence.

The quantifiers range over an arbitrary ring `R`, arbitrary
`R`-modules `V0,V1,V2`, arbitrary linear differentials on the Laurent
spaces, and every integer floor. In the application `R` is `F2`
and the floor is a nonnegative integer, but the encoded result is
stronger and does not rely on either restriction.

`RaisesOne d` requires a family of coefficient-linear maps `delta j`
such that `(d f)(j+1) = delta j (f j)` for **every** finitely
supported `f` and integer `j`. This states a strict shift by one,
not merely filtration preservation. It rules out contributions
from any other exponent. A differential can annihilate a monomial;
the condition does not require each input to have nonzero image.

`cutAbove_commutes` proves
`d (cutAbove n f) = cutAbove (n+1) (d f)`.
`boundary_above` proves that a boundary from coefficients at or above
`n` has no coefficients below `n+1`.

`fill_above_floor` assumes ambient exactness explicitly:
every `d1`-cycle in the Laurent coefficient space is the `d2`-image
of a finite Laurent coefficient vector. For each cycle `z` supported
at or above `n+1`, its conclusion supplies an actual finite filling
`y` supported at or above `n`, with `d2 y = z`.
Only `d2` needs the strict-shift hypothesis for this conclusion.
Ambient exactness is a hypothesis, not a result earned from the
compiler.

`floor_representative` additionally assumes `RaisesOne d1`.
It supplies, for every `d1`-cycle supported at or above `n`, a
cycle `f` supported exactly at the floor and a filling `y` supported
at or above `n`, such that `z = f + d2 y`.
`floor_boundary_zero` proves that a vector supported at the floor
which is a boundary from the truncated space is zero. Together
these give existence and uniqueness of floor representatives in
homology whenever the supplied maps form a complex.

In the manuscript application, the coefficient spaces in consecutive
resolution degrees are direct sums of polynomial spaces in
`d1,...,d(k-1)`. Formula (1) of `report.md` proves `RaisesOne` for
the first `k` primitives, and the explicit Laurent free basis (4)
and the periodic resolution (6) prove ambient exactness in every
positive homological degree. These application identifications,
Steenrod's algebra, Milnor's dual theorem, Laurent freeness itself,
replacement of later primitives, and the final right-exactness
argument are human mathematics in the report, **not** Lean
declarations hidden inside `C316_TRUNCATION`.

The compiler therefore certifies the uniform delicate filling and
truncation core and its stronger canonical floor-representative
consequence. It does not certify Curtis's conjecture, the geometric
weight or cone inputs, novelty, significance, or the absence of an
error in this fidelity reading. Independent Reviewer replay remains
necessary.
