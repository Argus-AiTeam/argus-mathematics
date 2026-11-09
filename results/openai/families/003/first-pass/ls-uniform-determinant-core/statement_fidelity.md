# Statement fidelity: the universal algebraic construction

`Main.lean` is a self-contained Lean 4.31.0 source importing Mathlib.
It concatenates the nine implementation sources listed by `verify.py`;
the replay checks that equality, not just the presence of theorem names.
This document describes the formal statements, not numerical experiments.

The result is a verification of the selected algebraic construction:
the literal projected-box interpolation lemma, its constant-32 rectangle,
actual weighted greedy selection, concentration, Frobenius replacements,
and simultaneous determinant and integer-norm divisibility. It is not a
proof of the analytic Landau--Siegel zero-free theorem, a refutation, or an
adjudication of mathematical novelty or publishability.

## Exact input and quantifier boundary

`LSChain.interpolation_polynomial` quantifies over every:

- integer `N >= 1` and triple of natural degree limits `t`;
- surjective complex-linear map `A : C^4 -> C^3`;
- vector `c : C^4` with `A x = 0` exactly when `x` is a complex multiple
  of `c`, whose four entries are linearly independent over `Q`;
- prescribed function `y : {0,...,N-1}^4 -> C`.

Its only numerical hypotheses are
`t_j >= 3*(N-1)` and
`product_j(t_j-3*(N-1)+1) > (4*N-3)^4`.
It constructs an actual multivariate complex polynomial with every
separate degree at most `t_j` and value `y(n)` at `A(n)`.
The box uses integer coordinates in `[0,N)`, not a generic finite point
configuration. There is no assumed lattice selector, interpolation
polynomial, rank conclusion, nonzero determinant, or greedy basis.

`LSChain.constructed_core` additionally quantifies over an arbitrary
commutative ring `R`, injective ring map `f : R -> C`, integer
`H >= 1`, finite weight cutoff `W`, and ring-valued coordinates whose
images are exactly `A(n)`. It accepts an explicit finite family of basic
prime-like congruences and a capacity threshold. These congruences are
discharged for the actual biquadratic coordinates by the final theorems
below; they are not silently identified with proved arithmetic here.

The most specialized theorem, `LSChain.full_chain`, uses the manuscript's
rank-four order data as inputs: an integral domain `R` with a
`Z`-basis indexed by `Fin 4`, an injective `f : R -> C`, integer `d`,
elements `a,b` with `a^2=d`, `b^2=2`, and rational linear independence
of `1,f(a),f(b),f(a)*f(b)`. The supplied integral basis is not a basis
of evaluation rows. It is used only to identify the exponent four in the
algebra norm and prove that norm nonzero.

These are explicit algebraic structure hypotheses, not derived claims
about arbitrary squarefree `d` in this source. In the manuscript they
are the presented data for `R=Z[sqrt(d),sqrt(2)]`, `K=Q(sqrt(d),sqrt(2))`
at lines 456-466. The reduction from primitive real characters and
squarefree discriminants to that rank-four presentation is not formalized.
No determinant, full row rank, interpolation conclusion, replacement
matrix, or Frobenius congruence is a hypothesis of `full_chain`.

## Unconditional geometric and interpolation bridge

`LSLatticeGeometry.lattice_face_selection` quantifies over every nonempty
subset `S` of the integer box and every complex-valued function on `Z^4`
which is nonzero somewhere and zero on `[0,4*(N-1)]^4`. It constructs
`u in S`, a nonzero integer normal `r`, integer `k`, and an integer point
`m` where the function is nonzero, such that `r.u=k` and
`F(m+n-u)=0` whenever `n in S` is outside that hyperplane.
This is a proved universal theorem, not an axiom or a supplied witness.

Its proof obtains a nearest pair between a compact convex hull and
a closed subset of the integer lattice. Positive Caratheodory weights
give at most four supporting vertices and one weight at least `1/4`.
An integral Gram matrix produces the nonzero integer hyperplane normal.
This does not assume the real supporting hyperplane itself is rational.
Singleton support, lower-dimensional hulls, and `N=1` are included.

`LSChain.lattice_selection` supplies exactly that theorem to
`LSRectInterpolation.projected_box_monomial_span_of_selection` and
`rectangular_interpolation_of_selection`. The latter module proves the
dimension count, nonvanishing on the integer lattice, affine inverse on
the rational hyperplane, face Lagrange polynomial of total degree at most
`3*(N-1)`, and preservation of separate degrees under translation.
The annihilator contradiction proves spanning, then constructs the
prescribed interpolating polynomial. `LSChain.interpolation` and
`interpolation_polynomial` have no remaining selector premise.

## Literal rectangle, arbitrary tie orders, and actual greedy matrix

For integers `1 <= H <= N`, define

```
V = H^(-1/3) * N^(4/3)
t = (floor(32*H*V), floor(32*V), floor(32*V))
W = floor(96*H*V).
```

Real powers are `Real.rpow`; the floors are natural floors of nonnegative
reals. `manuscript_scale_properties` proves `V >= N` and `H*V^3=N^4`.
`manuscript_scale_weight` proves
`H*V=H^(2/3)*N^(4/3)`. `rectangle_budget` proves the literal interpolation
budget and `t_0+H*(t_1+t_2) <= W`; these are not assumed in the final
theorems. Its strict product margin is `4096*N^4 > (4*N-3)^4`.

`Candidate H W` is precisely the set of nonnegative triples of weight
at most `W`: the additional coordinate representation by `Fin(W+1)`
loses none, since `H>=1` implies each coordinate is at most its weight.
The final construction quantifies over every linear order on this
finite set for which strict weight increase implies strict order increase.
Equal-weight ties are unrestricted. A concrete lexicographic default
instance proves this is an inhabited, usable requirement.

`LSGenericGreedy.greedySet` retains a row exactly when it is outside
the span of all earlier candidates. `ordered_greedy_construction`
proves its cardinality, enumerates it in retained order, proves linear
independence and full span, and obtains the nonzero determinant and all
prefix-span statements. `bounded_greedy_construction` obtains its spanning
premise from the unconditional interpolation theorem. `gridEnumeration`
is a bijection from `Fin(N^4)` to the integer box, so columns have exactly
the required cardinality.

`LSChain.greedy_scalar_extension`, using
`LSScalarDescent.span_descent`, proves equality of the greedy sets over
any field and any extension field for every finite-coordinate row family.
Thus complex-span selection is the same selection as over the
manuscript's embedded field `K`, not a different selection rule.

## Replacement construction and invocation of uniform_core

`replacement_expansion` proves, over every commutative ring and all
natural exponents, the exact binomial expansion of

```
x_0^(alpha_0 mod p) * (x_0^p-target)^floor(alpha_0/p)
  * x_1^alpha_1 * x_2^alpha_2.
```

`shift_weight_lt` and `shifted_candidate` prove the shifted exponents
are nonnegative bounded candidates of strictly smaller weight when
`m>0`, `m<=floor(alpha_0/p)`, and `p>H`.
`replacement_difference_mem` puts the difference in the earlier retained
span. `exists_strictLowerTriangular_replacement` constructs the actual
coefficient matrix from that membership; no replacement coefficients
are assumed.

`LSChain.constructed_core` constructs all these objects, establishes
their exact matrix equality, proves row-power divisibility, and calls
`UniformDeterminant.uniform_core`. Its nonzero determinant and all
replacement data are derived before that call. Determinant equality is
proved after mapping into `C` and descended through the injective map;
divisibility is proved in `R`. Integral triangular coefficients, unique
factorization, maximal orders, and ideal factorization are unnecessary.

## Arithmetic, concentration, and simultaneous integer norms

`LSBiquadratic` defines the three coordinates exactly as
`theta`, `sigmaTheta`, and `sigmaTauTheta`, with arbitrary integer
coefficients, including negative coefficients and negative `d`.
`explicit_projection_data` derives the surjective displayed projection,
kernel line through `(ab,b,-a,-1)`, and kernel rational independence
from the rational basis hypothesis.

For every odd rational prime `p` with `(d/p)=-1`,
`prime_dvd_theta_sub_signedTheta` derives Frobenius using Mathlib's
Euler criterion `legendreSym.eq_pow` and the quadratic equations.
The quotient modulo `p` is not assumed to be a field or even nontrivial.
`biquadratic_frobenius` chooses the second or third coordinate according
to `(2/p)=1` or `-1`, proved exhaustive for odd primes.
`primeSymbol` is an explicit total wrapper around the actual Legendre
symbol; its nonprime value zero is never used as arithmetic evidence.

The final prime family `P` is any finite set satisfying
`p.Prime`, `p != 2`, `p>H`, and `(d/p)=-1` for every member.
This includes every finite family of manuscript admissible primes.
The conductor and character-to-Legendre identification are outside the
formalized algebraic construction.

`coordinate_capacity_bound`, `capacity_threshold`, and
`concentration_from_capacity` derive the literal constants, assuming
only the manuscript's explicit large-size condition
`H*V >= 2*97^2`. They give

```
S1 >= N^4 * H*V / (4*97^2)
S2 <= 192*N^4*V.
```

The integer counting proof uses `B=W/H` and `Q=(B+1)^2`, with
`Q<=97^2*V^2`, and counts ordered pairs rather than presupposing a
sorted exponent list.

`biquadratic_manuscript_chain` constructs the actual `N^4` retained rows,
proves their determinant `Delta` nonzero, their uniform weight bound,
both concentration inequalities, and

```
product_(p in P) p^E_p divides Delta in R,
E_p = sum_i floor(alpha_i,0/p).
```

`simultaneous_prime_powers` derives pairwise comaximality by mapping
integer Bezout identities for distinct rational primes into `R`.
It does not confuse distinct prime elements of an arbitrary order
with rational-integer primes.

`full_chain` further proves that the integer algebra norm of this same
nonzero determinant is nonzero and is divisible by
`product_(p in P) p^(4*E_p)`. The degree four follows from the supplied
rank-four integral basis through `Algebra.norm_algebraMap_of_basis`.
The statement concerns an arbitrary finite prime set, never an infinite
product.

## Deliberate exclusions

The unequal-input-box, arbitrary-dimension extension in `proof.md` remains
a prose theorem, not a declaration of this Lean source. The analytic
prime-bias, size estimates, and zero-free conclusion are not certified.
No literal manuscript assertion has been refuted. Independent statement-
fidelity and publishability review remains the Host-invoked Reviewer's
responsibility; compilation does not perform that review.
