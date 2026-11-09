# Closed anti-diagonal quotient core

Claim: `C286_QUOTIENT_CORE`.

The declarations in namespace `BoundarySharpness` concern an arbitrary complex
vector space `E`, arbitrary complex normed spaces `K1`, `K2`, and arbitrary
linear maps `j1`, `j2` from `E` into those spaces. Neither an inner product nor
completeness is assumed. The product norm has the same topology as the Hilbert
direct-sum norm when the spaces are Hilbert spaces.

`closedAntidiagonal` is the topological closure of the linear range of
`b |-> (j1 b, -j2 b)`. `quotient_inputs_agree` proves that `(j1 b, 0)` and
`(0, j2 b)` have identical images in the quotient by that closed subspace.

`sumFunctional` sends `(v1, v2)` to `L1(v1) + L2(v2)`, where the two `Li`
are arbitrary continuous complex-linear scalar functionals.
`antidiagonal_le_kernel` assumes, for every `b`, that `L1(j1 b) = L2(j2 b)`
and proves that the CLOSED anti-diagonal lies in this functional's kernel.
`nonzero_common_functional_survives` additionally assumes that this common
scalar functional is nonzero at some `b`. Its conclusion is that some
`(j1 b, 0)` has nonzero quotient image. Thus closure does not kill a nonzero
functional bounded for both completions.

`closedAntidiagonal_invariant` assumes arbitrary continuous linear operators
`T1`, `T2` and a linear domain operator `m` satisfying `Ti(ji b) = ji(m b)`
for every `b`. It proves invariance of the CLOSED anti-diagonal under
`(v1, v2) |-> (T1 v1, T2 v2)`. Applying it separately to angular
multiplication and its adjoint, or to a covariance and its inverse, is the
reducing-subspace step in the mathematical proof.

For the manuscript application, `E` is `C-infinity(Z) tensor H` and `Ki`
are its two angular-form completions. A common bounded scalar functional
extends continuously to each completion, giving the `Li` above. A
conjugate-linear functional is first complex conjugated.

The formalization DOES NOT assert positivity of the quotient CP map,
normality of group representations, frame-functional encoding, measurable
central-component selection, pair ergodicity, candidate existence, or the
analytic transfer bounds used for sharpness. Those are separate propositions
in `../theorem.md`. Compiler success for this core must not be reported as
compiler verification of `lem:transfer-disjointness` or either main theorem.
