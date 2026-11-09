# Statement fidelity: C_CR227_ALGEBRA

The declarations are in namespace `CriticalResolventComparison`.
All scalar variables are arbitrary real numbers unless stated otherwise.

`tiltedMass` and `tiltedMeanNumerator` compute the total mass and signed
first moment of the two weights
`((1+t)/2)(1+us)` and `((1-t)/2)(1-us)`. For actual conditional
probabilities, `t` is the conditional spin mean and `s` is the other
spin in the interaction.

`varianceNumerator` assumes `s^2=1`. It proves the polynomial identity
that gives the variance after the binary tilt.
`unnormalizedEndpointVariance` additionally assumes
`1+ust != 0` and proves

`(1+ust)(1-((t+us)/(1+ust))^2) = (1-t^2)(1-u^2)/(1+ust)`.

Thus the energy multiplier is `(1-u^2)/(1+ust)`. No division by
`1-t^2` occurs: the statement does not introduce a nondegeneracy
assumption at a frozen spin. The real Gibbs application has
`|u|<1`, `|t|<=1`, so its denominator is positive.

`halfDifferenceResidual` is the exact endpoint cancellation
`D_k(qg)+s t_k D_kg = s E_kg`. Here `gp` and `gm` are the two
values of the test function, and `D_k` is the half difference.
`finiteEndpointResidual` proves the corresponding finite weighted
sum for arbitrary endpoint weights, slopes, and conditional means.
These are identities without positivity assumptions.

`binaryJensenIdentity` is the exact two-point variance identity.
`binaryJensen` derives conditional Jensen's inequality assuming
`t^2<=1`. `twoEndpointCauchy` proves the two-component real
Cauchy--Schwarz inequality, the endpoint-counting source of the
constant two in the residual estimate.

`endpointCoefficientRecurrence` states the denominator-clearing
recurrence for the coefficients of `(1-u^2)/(1+ua)` from order two
onward; the exceptional order-two right-hand side is minus one.
It is a polynomial identity for every natural `k`.

For any real module `V`, `residualEquation` assumes a bilinear form
`M`, a linear source `b`, and a vector `v` solving `M(v,g)=b(g)` for
every test `g`. It proves that `v-y` solves the equation with source
`b-M(y,.)`. `variationalCompletion` and
`variationalCompletionEnergy` additionally assume symmetry of `M`.
They prove the exact residual-square completion, respectively using
the residual covector and its energy. In the Gibbs application,
`v=M(u)^(-1)b(u)` and `y=Y`; invertibility follows from positive
mass and energy in the mathematical report, not from a Lean
assumption hidden in a definition.

The compiler certifies these finite algebraic statements, not their
translation from the manuscript. It does not certify the full
operator-norm estimates, disorder overlap concentration, fourth
derivative bound, infinite-volume Gaussian inputs, functional
convergence, novelty, or publishability. Those are explicitly
separate mathematical proof and independent-review obligations.
