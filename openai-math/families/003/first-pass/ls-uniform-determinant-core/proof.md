# Projected-box interpolation and weighted determinants

The target is the algebraic chain in
`research/openai_manuscript/Uniform-exclusion-of-Landau-Siegel-zeros-October-1-2026/build/paper.tex`:
Lemma `lem:interpolation` (lines 252-408), Corollary `cor:rectangle`
(410-432), weighted greedy selection (487-515), Lemma `lem:exponents`
(517-550), and Lemma `lem:divisibility` (598-638).
The analytic zero-free theorem is not a conclusion of this audit.

## Scope and initial adversarial reading

All coordinates and aspect ratios permitted by the stated hypotheses are in
scope. The kernel condition means rational linear independence of all four
coordinates of a nonzero complex kernel vector. It is not genericity, real
linear independence, or a numerical rank tolerance.

The initial reading found no counterexample. In particular:

* The nearest-point displacement in line 335 is `u-n`, not `n-u`.
  Its positive scalar product with the outward normal gives the stated
  strict decrease.
* The rational hyperplane containing the face need not be the supporting
  hyperplane itself. Integer vertices suffice to obtain a rational one.
* Lower-triangular replacement coefficients may lie in the field. Integral
  divisibility is extracted from the replacement entries, not those
  coefficients.

These initial checks by themselves were not a universal formal verification.
The continuation now supplies the full kernel proof described below.
The inherited Wiki has no entry specifically resolving this projected-box
or Landau--Siegel determinant claim. No literature theorem is yet used as an
undischarged assumption.

A targeted public literature search did not establish an exact prior
proposition with these hypotheses and separate-degree constants. Its broad
generated answer incorrectly described the kernel and was not used as
mathematical evidence. The Laurent primary-source landing page was obtained,
but a bibliography page is not a reading of a proposition. Consequently
novelty remains unverified; none of those search suggestions is recorded
as an assumed theorem.

## A rectangular-input, arbitrary-dimension interpolation theorem

The following is a mathematical proof, not a claimed Lean theorem.
It specializes exactly to `lem:interpolation`.

Let `d >= 2`, let `A : C^d -> C^(d-1)` be a surjective complex-linear map,
and suppose `ker(A) = C*c`, where the `d` coordinates of `c` are linearly
independent over `Q`. Let `N_i >= 1` be integers, and put

```
E = product_i {0,...,N_i-1},
D = sum_i (N_i-1) - min_i (N_i-1),
L = product_i (d*(N_i-1)+1).
```

For integer degree limits `t_1,...,t_(d-1) >= D`, assume

```
product_j (t_j-D+1) > L.
```

**Theorem.** Every complex-valued function on `E` is the restriction
`n |-> B(A*n)` of a polynomial with separate degrees at most `t_j`.
No constant depends on the coefficients of `A`.

**Proof.** If the evaluation map is not onto, finite-dimensional linear
algebra supplies a nonzero vector `v=(v_n)` annihilating all evaluations.
Let `S={n:v_n != 0}`, `P=conv(S)` in `R^d`, and `K=d*P`. Write
`b_j=t_j-D`. The space of polynomials of separate degrees at most `b_j`
has dimension `product_j(b_j+1)`. The set `K` is contained in the
rectangular box with side intervals `[0,d*(N_i-1)]`, so its number of
integer points is at most `L`. Consequently a nonzero polynomial `R`
of those separate degrees vanishes at `A*m` for every integer `m` in `K`.

Surjectivity of `A` implies that `R composed with A` is not the zero
polynomial. A nonzero complex polynomial cannot vanish on all of `Z^d`:
fix all but one integer coordinate, apply the univariate root bound,
and induct on the number of variables to its coefficient polynomials.
Thus an integer `m` with `R(A*m) != 0` exists.

Choose such an `m` minimizing its distance to `K`. This is a genuine
minimum: choose one such point first; all candidates no farther away
lie in a fixed bounded neighborhood of the compact set `K`, and this
neighborhood contains only finitely many integer points. Choose a
nearest point `y` of `K` to `m`, and put `h=m-y`. Since `m` is an
integer point where `R` is nonzero, `m` is not in `K`, so `h != 0`.
For `x` in `K`, convexity and the minimality of `y` give
`h dot (x-y) <= 0`, by expanding the distance to
`y+eta*(x-y)` for small positive `eta`.

The supporting face

```
G = {u in P : h dot u = max_(w in P) h dot w}
```

contains `y/d` and has dimension at most `d-1`. If `P` is
full-dimensional, this follows from `h != 0`; otherwise it follows
from the dimension of `P` itself. Express `y/d` as a convex combination
of at most `d` vertices of `G`. Here is the elementary finite
Caratheodory reduction needed for this statement: a convex combination
with more than `dim(G)+1` positive terms has an affine dependence;
subtract a scalar multiple of that dependence until one coefficient
is zero, without making any coefficient negative, and repeat.
One coefficient in the resulting combination is at least `1/d`.
Its vertex `u` belongs to `S`, and subtracting one copy of `u`
from the expression for `y` proves

```
y-u in (d-1)*P.
```

For `n` in `S` outside `G`, put `y'=y+n-u` and `m'=m+n-u`.
Then `y'` is in `K`, `m'-y'=h`, and `y-y'=u-n`.
Moreover `h dot (u-n)>0`. The point
`y'+eta*(y-y')` is in `K` for `0 <= eta <= 1`, and

```
norm(m'-(y'+eta*(y-y')))^2 - norm(h)^2
  = -2*eta*(h dot (u-n)) + eta^2*norm(u-n)^2 < 0
```

for sufficiently small positive `eta`. Thus `m'` is closer to `K`
than the minimizing nonzero point `m`; it follows that `R(A*m')=0`.
This is the sign-sensitive step, not an appeal to a numerical
nearest-point computation.

The face `G` has integer vertices and affine dimension at most `d-1`.
It lies in a rational affine hyperplane

```
H = {x : r dot x = k},  r in Z^d nonzero, k in Z.
```

To see this without an arithmetic hypothesis on its supporting
normal `h`, take the integer differences of its vertices from one
fixed vertex. Their real rank is at most `d-1`. Rank of an integer
matrix is the same over `Q` and `R`, by its minors. Its rational
nullspace therefore contains a nonzero vector; clearing denominators
gives `r`, and `k` is its scalar product with the fixed vertex.

Rational independence gives `r dot c != 0`. Therefore every affine
line parallel to `ker(A)` meets `H` exactly once. Equivalently,
`A` restricted to `H` is an affine bijection onto `C^(d-1)`.
The inverse is affine: for any linear right inverse `J` of `A`,
it is

```
z |-> J*z + ((k-r dot (J*z))/(r dot c))*c.
```

Choose `i0` with `r_i0 != 0`, and let `lambda_i`, for `i != i0`,
be the corresponding coordinates of this inverse. The product

```
Q(z) = product_(i != i0) product_(0 <= a < N_i, a != u_i)
         (lambda_i(z)-a)/(u_i-a)
```

has total degree at most `sum_(i != i0)(N_i-1) <= D`. It is one
at `A*u` and zero at every other `A*n` with `n` in `S` and in `G`:
on `H`, the coordinates other than `i0` determine the point.
Every denominator is a nonzero integer.

Finally

```
B(z) = Q(z)*R(z+A*(m-u))
```

has separate degree at most `D+b_j=t_j`. Translation does not
increase a separate degree. In the annihilating moment equation,
terms outside `G` vanish by the nearest-point argument and terms
on `G` except `u` vanish by `Q`. The surviving term is
`v_u*R(A*m) != 0`, a contradiction. This proves the theorem.

For `d=4` and `N_i=N`, the quantities are exactly
`D=3*(N-1)` and `L=(4*N-3)^4`, proving the literal interpolation
lemma mathematically for every stated coordinate system and budget.
The arbitrary-dimension, unequal-input-side formulation is a structural
extension; no claim of verified novelty or publishability is made.

## The manuscript rectangle and greedy basis

Put `V=H^(-1/3)*N^(4/3)` for integers `1 <= H <= N`. Then
`V >= N`, `H*V^3=N^4=M`, and the degree bounds are
`T=(32*H*V,32*V,32*V)`. Each `T_j >= 32*N`.
For `t_j=floor(T_j)` and `D=3*(N-1)`,

```
product_j(t_j-D+1) > product_j(T_j-D)
                   >= product_j(T_j)/8
                   =4096*N^4 > (4*N-3)^4.
```

All factors in these inequalities are positive. Apply interpolation
to the monomial basis to get the rectangle's spanning assertion.

For the specified biquadratic field, `d` is squarefree and
`d != 1,2`. Thus `1,a,b,a*b`, with `a^2=d,b^2=2`, is a rational
basis. The displayed matrix has a nonzero `3 x 3` minor `4*a*b`
and kernel vector `(a*b,b,-a,-1)` with rationally independent
coordinates. The rectangle therefore applies to this matrix.

Every bounded-weight prefix in the nonnegative triples is finite,
because `H` is positive. Greedy retention of the rows in such a
prefix gives a basis of that prefix's span: induction on the
ordered prefix proves that discarding a row does not change the
span. The rectangle rows have weight at most `W=96*H*V`.
Consequently, by the end of the weight-`W` prefix, exactly `M`
independent rows have been retained and no later row is retained.
Their determinant is nonzero. Extending scalars from `K` to `C`
does not change rank, since rank is detected by nonzero minors.

This argument also proves the precise property needed later:
every strictly smaller-weight row belongs to the field-span
of the retained rows preceding the given retained row. It does
not say that the spanning coefficients belong to the integer order.

## Exact exponent concentration without sorting or rounding identities

Here is an independent proof of the counting step, formalized in
`capacity_packing` and `triple_packing`.

For any finite family of distinct triples `(a_i,b_i,c_i)` with
`0 <= b_i,c_i <= B`, let `Q=(B+1)^2`, `S=sum_i a_i`,
and `M` be the number of triples. For fixed `i`, at most `Q*a_i`
indices have `a_j<a_i`, and at most `Q` have `a_j=a_i`.
Partition all `M^2` ordered pairs by `<`, `=`, or `>`. The
numbers in the strict cases are equal by reversing a pair, so

```
M^2 <= 2*Q*S + Q*M.
```

When `M >= 2*Q`, this implies `M^2 <= 4*Q*S`.
Also `sum_i(b_i+c_i) <= 2*B*M`. Both statements are
division-free and hold at empty and degenerate finite boundaries.

For the greedy basis set `B=floor(96*V)`, so
`Q <= 97^2*V^2`, using `V>=1`. If `H*V >= 2*97^2`,
then `M=H*V^3 >= 2*Q`. Hence

```
S1 >= M^2/(4*Q) >= M*H*V/(4*97^2),
S2 <= 192*M*V.
```

These are exactly the manuscript constants and its stated
field-uniform threshold. The proof does not infer a lower bound
from successful finite ranks.

## Frobenius, field-triangular replacement, and integral divisibility

For an admissible prime `p>H`, Euler's criterion in
`R/p*R`, with `R=Z[a,b]`, gives `a^p=-a` and
`b^p=(2/p)*b`. The integer coefficients are fixed by the
characteristic-`p` power map. Thus `theta^p-g(theta)` belongs
to `p*R` for every `theta` in `R`, with `g=sigma` or
`sigma*tau` as stated. This uses neither maximality of the order
nor unique factorization of ideals.

Write `alpha_1=p*k+r`, `0<=r<p`, and form the replacement row by
using `theta^r*(theta^p-g(theta))^k`. Expanding the ordinary
binomial theorem gives

```
replacement(alpha) = R_alpha
  + sum_(1<=m<=k) (-1)^m*binom(k,m)*R_(alpha-p*m*e1+m*ej).
```

The shifted indices are nonnegative, and their weights decrease
by `m*(p-H)>0`. The greedy property just proved makes every
extra term a field-linear combination of earlier retained rows.
For each fixed `p`, the full replacement matrix is therefore
`(I+C_p)*A_retained`, with `C_p` strictly lower triangular over `K`.
The determinant of `I+C_p` is one, so determinants agree in `K`,
and hence in its subring `R`.

Each entry of replacement row `alpha` is in `p^k*R`.
Factoring row powers in the determinant gives

```
Delta in p^(sum_alpha floor(alpha_1/p))*R.
```

`integral_replacement_divisibility` proves the general version
over every injective homomorphism of commutative rings, even when
the replacement coefficients lie outside the original ring.
`uniform_core` combines it for every member of an arbitrary finite
family with the exponent bounds. The new `LSChain.constructed_core`
derives its nonzero determinant, triangular replacement identities,
and entry divisibilities from interpolation and the basic congruences,
then invokes `uniform_core`. `LSChain.biquadratic_manuscript_chain`
also derives those basic congruences from the quadratic equations and
Legendre symbols, and supplies the manuscript's real-power constants.

The product of the four conjugates of an element of `R` is fixed
by both sign automorphisms and is therefore an integer, by uniqueness
of the basis coefficients. It is nonzero for a nonzero field element.
Taking norms gives `p^(4*E_p) | Norm(Delta)` in `Z`.
For any finite set of distinct admissible primes, their powers
are pairwise coprime integers, so their product divides that
same nonzero integer. There is no assertion of an infinite product.

## Exact replay, adversarial controls, and certification boundary

Run `verify.py` using a Python installation with SymPy. It recomputes
the symbolic sign, budget, weight, and packing identities and the
exact field-arithmetic examples recorded in `exact_certificate.json`.
The defaults compare against the existing certificate and fail on
a discrepancy; `--write-certificate` explicitly regenerates it.

The finite examples use the actual `N=2` box in `Q(sqrt(3),sqrt(2))`,
both permitted weights `H=1,2`, and both lexicographic tie directions.
At `H=2` with reversed ties, the `p=5` divisibility exponent is
nonzero. The `p=7` grid examples have exponent zero; they are not
represented as nontrivial divisibility experiments.

Two negative controls explicitly violate hypotheses. Removing the
greedy rule and choosing first powers `0,...,15` gives `E_5=18`,
whereas the norm has 5-adic valuation only `16`, not at least `72`.
Before the first power `3`, this choice has omitted the independent
row `(0,1,0)` of smaller weight `2`. Removing rational independence
allows the rank-three difference matrix with kernel `(1,1,1,1)`,
which identifies the two opposite vertices of the binary box.
Neither is a counterexample to the manuscript; no `F_` claim is
warranted by these controls.

The preserved Jacobian call is `matrix.rank.compute` on the `12 x 16`
rational representation of the manuscript's map for `d=3`.
Its typed answer is rank `12`, independently replayed by SymPy.
The server version, protocol, payload, output, and observed zero adapter
exit status are retained. This is a bounded specialization only.

The strongest prior result was the certified `uniform_core` theorem,
which assumed a nonzero determinant and triangular replacement data.
The present mathematical improvement removes those assumptions:
`LSChain.interpolation_polynomial` proves the literal interpolation
lemma for every permitted map and budget, and
`LSChain.bounded_greedy_construction` constructs the actual basis.
The nearest lattice pair, rational face, separate-degree algebra,
greedy prefix spans, binomial replacements, and coefficient matrices
are all kernel proofs. Every weight-compatible tie order is covered.
`greedy_scalar_extension` proves the selection is unchanged under
field extension.

`LSChain.full_chain` combines the construction with the explicit
biquadratic Frobenius proof, literal concentration constants, and
simultaneous nonzero integer-norm divisibility. It starts from the
manuscript's algebraic order data: a rank-four integral domain embedded
in `C`, the two quadratic generators, and rational independence of
`1,a,b,ab`. The source does not derive this presentation from the
primitive character and squarefree-discriminant classification.
The formal input integral basis is a basis of the order, never an
assumed basis of evaluation rows.

The final claim-bound compiler result and exact certificate certify
this universal algebraic construction, not the analytic zero-free
theorem. The arbitrary-dimension extension above remains a prose proof.
Independent statement-fidelity and publishability review is pending;
no mathematical refutation or verified novelty is claimed.
