# Statement fidelity: universal rectangular coefficient recovery

## Claim and scope

This file interprets `RectangularCore` in `Main.lean` as the **algebraic
coefficient-recovery core only** of ledger claim `L_RECTANGULAR_CORE` in
`CTX_SPECTRAL`. The existing natural-language claim and context are not
replaced by geometric statements.

The algebraic declarations quantify over an arbitrary type `K` with a
`Semiring K` instance. Thus they apply, in particular, to **every field in
every characteristic**, without characteristic, infinitude, algebraic
closure, or genericity assumptions. In fact, neither commutativity of
coefficients nor division is needed: multiplication by the monomial uses
coefficient `1`. All indices and all parameters `a,b,c,i,j,m,q` are natural
numbers. Zero values of `a,b,c,q` are permitted.

## Polynomial representation and multiplication

* `Index2` is `ℕ × ℕ`; `Index3` is `ℕ × (ℕ × ℕ)`. We write the latter as
  `(i,j,k)`. Addition of exponents is componentwise.
* `BiPoly K` is `AddMonoidAlgebra K Index2`, the finite-support coefficient
  array of the formal bivariate polynomial
  `p(s,t) = sum_(i,j) p(i,j) s^i t^j`.
* `TriPoly K` is `AddMonoidAlgebra K Index3`, the analogous trivariate
  polynomial array. `P(a,b,c)` means the coefficient of `s^a t^b u^c`,
  **not** polynomial evaluation at scalar points. `P.coeff` exposes the
  underlying `Finsupp`. This is a polynomial representation, not a quotient
  by equality of polynomial functions on a possibly finite field.
* Multiplication `P * Q` is Mathlib's actual additive-monoid-algebra
  convolution: its coefficient at `w` is
  `sum_(v+z=w) P(v) * Q(z)`, a finite sum. It is not a custom recovery
  operation or a pointwise product. `AddMonoidAlgebra.single (r₁,r₂,r₃) 1`
  is the genuine monomial `s^r₁ t^r₂ u^r₃`.
* `degree2 (i,j) = i+j` and `degree3 (i,j,k) = i+j+k`.
  `totalDegree p` and `totalDegree3 P` are the maxima of these degrees
  on the respective finite nonzero supports, implemented by `Finset.sup`.
  The convention for the zero polynomial is degree zero.
* `InRectangle p a b` means every nonzero coefficient has `i ≤ a` and
  `j ≤ b`. It imposes no fixed-degree or triangular support condition.
  `IsHomogeneous P m` means every nonzero term of `P` has total degree
  `m`. The zero polynomial satisfies this predicate for every `m`;
  exact-degree conclusions therefore explicitly require nonzeroness.

## Finite-support homogenization

`liftExponent m (i,j) = (i,j,m-(i+j))`. Natural subtraction is truncated.
`liftExponent_injective` proves that this exponent map is injective,
because it retains both original coordinates.

`homogenize m p` is the actual finite-support pushforward
`Finsupp.mapDomain (liftExponent m) p.coeff`, repackaged as a monoid
algebra. `homogenize_expansion` proves the explicit coefficient-array
identity

```
(homogenize m p).coeff
  = sum_(e in p.coeff.support) Finsupp.single (liftExponent m e) (p e).
```

In particular this definition is the polynomial sum
`sum p(i,j) s^i t^j u^(m-i-j)`. Its usual homogeneous interpretation
requires the support bound `i+j ≤ m`; no homogeneity is claimed for
arbitrarily smaller `m`.

* `homogenize_coefficient`: for every `p,m,e`, the coefficient at the
  lifted exponent equals `p e`, using injectivity and the finite sum,
  rather than defining that coefficient to be the desired answer.
* `support_degree_le`: every support exponent has degree at most the
  actual `totalDegree p`.
* `exists_top_term`: if `p ≠ 0`, there is an exponent in its finite
  nonzero support whose degree equals `totalDegree p`. This follows
  from a maximum of a nonempty finite set, and is not an assumption
  that every nonzero polynomial has a prescribed leading term.
* `homogenize_homogeneous`: for every `p,m`, if all support terms have
  degree at most `m`, `homogenize m p` is homogeneous of degree `m`.
* `homogenize_actual_degree_homogeneous` specializes that result to the
  actual degree, with no additional support-degree hypothesis.

## Multiplication, recovery, and detection declarations

* `homogeneous_mul_monomial`: every homogeneous `P` of degree `m`,
  multiplied by the monomial at an arbitrary `r : Index3`, is homogeneous
  of degree `m + degree3 r`. The proof uses the convolution-product
  support inclusion, not an assumed degree formula.
* `homogeneous_totalDegree`: if additionally `P ≠ 0`, the homogeneous
  degree is its actual finite-support maximum `totalDegree3 P`.
* `recover_top_coefficient`: for every `p,m,a,b,c,i,j`, assuming only
  `i ≤ a`, `j ≤ b`, and `i+j=m`, the coefficient at `(a,b,c)` of
  ```
  homogenize m p * AddMonoidAlgebra.single (a-i,b-j,c) 1
  ```
  equals `p(i,j)`. The proof invokes Mathlib's convolution coefficient
  lemma `AddMonoidAlgebra.mul_single_apply_aux`. Componentwise
  cancellation shows that only the lifted exponent `(i,j,0)` can
  contribute. No nonzeroness assumption is needed for this identity.
  The equation is also valid for arbitrary `m` satisfying `i+j=m`;
  actual-degree and homogeneity conclusions are supplied separately.
* `complementary_product_homogeneous` uses `m = totalDegree p` and the
  same coordinate bounds/top-degree equality to prove the whole product
  is homogeneous of degree `a+b+c`.
* `complementary_product_degree` additionally assumes `p(i,j) ≠ 0`.
  Recovery makes the product nonzero, proving its **actual total
  degree** is exactly `a+b+c`, not merely a support upper bound.
* `zero_of_top_coefficients_vanish`: for every `p,a,b,c` with rectangular
  support, if the displayed coefficient is zero for every exponent in
  the rectangle whose degree equals `totalDegree p`, then `p=0`.
  A hypothetical nonzero polynomial has a maximal-degree nonzero
  support coefficient; the recovery identity contradicts its vanishing.
  The vanishing premise does not assume that those coefficients of `p`
  are already zero.
* `all_complementary_coefficients_vanish_iff`: for every rectangularly
  supported `p` and each fixed `c`, vanishing for **all** rectangular
  complementary monomials is equivalent to `p=0`. Only the top-degree
  members are needed in the nontrivial direction.
* `nonzero_rectangular_detection`: for every rectangularly supported
  nonzero `p`, one top-degree nonzero exponent in the rectangle works
  **simultaneously for every `c : ℕ`**. The theorem supplies product
  homogeneity, exact product total degree `a+b+c`, and coefficient
  equality with that nonzero coefficient.

## Cardinality and comparison

`rectangle a b` is the actual finite set
`range (a+1) × range (b+1)`. `mem_rectangle` identifies membership with
the two coordinate bounds, and `rectangle_card` proves cardinality
`(a+1)*(b+1)`. For every natural `q`, `square_ge_triangle` proves
`Nat.choose (q+2) 2 ≤ (q+1)^2`. `square_gt_triangle` proves the strict
inequality under the exact additional hypothesis `0 < q`. The proofs
use `Nat.choose_two_right` and exact natural-number arithmetic; they
do not divide in the coefficient semiring or assume characteristic
different from two.

## Explicit exclusions

No declaration formalizes a finite scheme, disjointness from `u=0`,
restriction of sections, independence after restriction, an annihilator
ideal, apolarity, adjugates, determinant fibers, Jacobian rank, codimension,
or an algebraic-geometric dimension theorem. This certificate alone does
not prove any geometric theorem of the manuscript. It certifies the
universal finite-support polynomial algebra and the numerical count that
can be used as inputs to a separate geometric argument.

There are no added axioms, unproved local assumptions, proof holes, native
decision shortcuts, or unsafe declarations in the source. The standard
logical principles used through Mathlib are not additional hypotheses on
the coefficient field.
