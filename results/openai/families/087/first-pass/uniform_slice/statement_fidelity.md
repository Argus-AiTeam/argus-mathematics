# Statement fidelity: the universal scalar core

Claim: `C_SCALAR_CORE`. Source: `Main.lean`. All variables below are real;
there are no finite grids, rational-only restrictions, axioms, or omitted cases.

All declarations are in namespace `UniformSlice`.
`resolvent_slack` is an identity for arbitrary `q`, `x`, and `y`.
`disk_resolvent` assumes `0 <= q < 1` and
`x^2 + y^2 <= q^2`, and concludes

    1/(1+q) <= (1+x)/((1+x)^2+y^2).

The right side is the real part of `1/(1+z)` for `z=x+iy`.
For the derivative argument take `z=s^2 w^2` and `q=s^2 |w|^2`,
where `|w|<1` and `0<=s<=1`. The norm hypothesis and `q<1` then hold.
This substitution and its integration are analytic arguments in `REPORT.md`,
not declarations of the Lean file.

`exponential_peak` proves `x exp(-x) <= exp(-1)` for every real
`x`, with no positivity assumption. `endpoint_peak` specializes
it to `x=H/2`, still for every real `H`. This bounds the second half of the
endpoint integral after the analytic substitution `y=k(1-r)`.

`left_half_kernel` assumes only `H>0` and `y<=H/2` and proves
`sqrt(y/(H-y))<=1`. Real square root has its Mathlib total meaning, zero on
negative inputs. In the application `0<=y<=H/2`, so this is the usual
nonnegative square root and the denominator is strictly positive.

`tip_constant_square` is an identity for every real `p`:

    (3 sqrt(2) p^2/8)^2 (p^2/2) = (3 p^3/8)^2.

At `p=pi` it checks the constant conversion in the angular tip estimate;
the positivity and order implications are supplied in the analytic proof.

The file does **not** encode the holomorphic map, univalence, integration,
the arctangent estimate, convergence of the error sequence, or the full slice
proposition. In particular a kernel-checked scalar claim is not a
kernel-checked Mahler theorem. Those distinctions are also explicit in
`exact_certificate.json` and `REPORT.md`.
