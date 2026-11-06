# C318ACTALG: split transport and normalization algebra

`action/Main.lean`, namespace `SpecifiedAction`, formalizes algebraic
cores of `specified-action.md`, not its geometric or regulator theorems.

`split_surjective_right_inverse` quantifies over modules over an arbitrary
commutative ring, an inflation linear map `inf`, and its specified left
inverse `res`. Surjectivity of `inf` is a hypothesis; the theorem proves
that the same `res` is its right inverse. `split_inflation_pullback`
deduces the actual pullback factorization for any two specified compatible
linear maps. In the application, inflation equivalence is proved by the
continuous rational-additive-group calculation, not by Lean.

`specified_pullback_transport` retains two named classes and the equality
of their specified structural images. It propagates that equality through
a given pullback/block diagram. The common modification torsor, equality
of its two structural images, and block factorization are mathematical
inputs to this application, not formal constructions of this source.

`bezout_projector` quantifies over every commutative ring. Given
`u*a+v*b=1` and `a*b=0`, it proves that `v*b` is idempotent.
The three module theorems identify its action on the summands killed by
`a` or `b` and its idempotence. `a` and `b` may be powers of primary
polynomials, so no semisimplicity is hypothesized. In the application the
ring is the quotient of F5[T] by an annihilating product; existence of
the Bezout coefficients for the coprime factors is a separate elementary
polynomial fact. No infinite eigenspace/limit exchange is encoded.

`weightTwoParameter` is exactly the rational expression
`x - (z-x/25)/(1-1/25)`, for integer x,z.
`weight_two_parameter` proves that it is `(25/24)*(x-z)`.
`parameter_change_lift` proves invariance under simultaneous subtraction
of an arbitrary integer b. `parameter_image` characterizes the entire
image of that integer lattice, and `primitive_parameter` computes its
displayed generator.

`filtered_extension_nonsplit` proves that, over ZMod 5, no common change
of lift can make both coordinates x=1 and z=0 split. Its interpretation
as a Galois nonsplitting uses Fontaine--Laffaille exact realization,
finite full faithfulness, and the standard period lattice, all explicitly
imported in the prose proof. The source does not encode Q5, a p-adic
period ring, a filtered Frobenius category, or Galois cohomology.

`rank_two_constants` checks the unit denominator 24, the actual value
P2(2)=1, its nonzero denominator 1-2, and the two specified arithmetic
weights in ZMod 5. It is not a proof of a dilogarithm identity or a
local K-theory comparison.

No theorem here computes ordinary Morava-stabilizer cohomology,
identifies a geometric torsor, or constructs xi_i. The full specified
cup-map conclusion applies the imported source theorems, this algebra,
the new prose argument, and the previously certified ordinary comparison
and actual-unit criterion. Independent mathematical and fidelity review
remain distinct from compiler acceptance.
