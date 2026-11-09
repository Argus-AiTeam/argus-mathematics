# Jet-rank transfer and compression

**Assessment:** the argument supports the asserted backward maximum-rank
transfer and compression facts in the smooth formal-coordinate setting
actually used by the draft. It is a prose proof, not a kernel-checked
jet theorem or an inference from finite-field maxima.

## Exact claims, hypotheses and attribution

Historical `C_RS_TRANSFER@v1` asserts that replacing row bases by
commonly exposed formal least monomials cannot increase the maximum
rank of any finite mixed-order multipoint jet evaluation at distinct
torus points, in arbitrary characteristic and with unchanged labels.
Historical `C_RS_COMPRESS@v1` asserts preservation of row dimension
and multiplication by order-at-one compression, the real interval-length
bound on compressed orders, backward rank transfer, and exact rank and
cardinality preservation under integral unimodular exponent maps.

These are read against the actual hypotheses in
`9000039/research/reshaping_audit/report.md`, section "Elementary
least-term and specialization facts": polynomial or Laurent-polynomial
functions expanded in regular formal parameters at a smooth point,
a common positive integral exposing weight for each finite test,
and finitely many unscaled Laurent labels. The base field for the
reshaping application is algebraically closed, hence infinite, in any
characteristic. The maximum is over distinct tuples in its torus.
The short ledger wording does not license arbitrary unrelated
formal series, singular coordinate identifications, or a fixed tuple
in every degree.

For points `P_1,...,P_r` and nonnegative orders `m_1,...,m_r`,
the jet map is

```text
V -> direct_sum_i O_(P_i) / m_(P_i)^(m_i+1).
```

Rank domination concerns the maximum of its finite integer-valued rank.
It is not a claim that the same point tuple has nonincreasing rank.
Backward surjectivity follows when the output maximum equals the
target dimension; the input may use a different tuple.

The manuscript source is the positive-characteristic
`02-transfer.tex`, notably `lem:compression` at 225-259.
The complex companion has `lem:weighted-limit`, `lem:rank-transfer`,
`lem:unimodular`, and `lem:compression` at the ranges recorded in
`../companion-trace/report.md`. Source correspondence is to revision
`4eaee87548250b2682affda7d05d947c05554bae` of the existing
`9100039/MANUSCRIPTS.json`; exact excerpts are retained there.
The all-characteristic mixed-order proof is the old Argus reconstruction
being assessed, not a newly attributed manuscript theorem.

## Decisive specialization argument

Choose basis functions with distinct least terms `c_j z^(e_j)`,
possibly carrying unchanged factors `u^(gamma_j)`.
Suppose all are exposed by one positive integral weight `lambda`.
At a tuple of distinct output torus points `(Q_i,U_i)`, substitute

```text
z_a = s^(lambda_a) (Q_(i,a) + delta_a),
u_b = U_(i,b) + epsilon_b
```

in each ring
`k[[s]][delta,epsilon]/(delta,epsilon)^(m_i+1)`.
Functions index matrix columns; truncated Taylor coefficients index
rows. Divide column `j` by `c_j s^(lambda.e_j)`.
Every remaining coefficient is integral over `k[[s]]`, and reduction
modulo `s` is exactly the mixed-order monomial jet matrix.
Unique exposure makes every other formal monomial have strictly larger
`s` exponent. Positive weights make the substituted infinite sums
well-defined, also after nilpotent truncation.

A nonzero reduced minor of size `rho` remains nonzero over
`k((s))`. The coordinate changes in the application have formal
inverses with invertible linear part. At these `s`-small centres,
their Jacobians are units; after inverting `s`, the diagonal
scalings are units as well. They induce isomorphisms of the full
truncated local algebras. Thus the original-function evaluation has
rank at least `rho` over `k((s))`. Distinct centres remain distinct
under the inverse formal coordinate map.

For the nodal step the original functions are polynomials, so no
original-torus denominator is needed even if a particular centre lies
on a coordinate hyperplane. For compression, the original Laurent
variable is centred at one, where its denominators are units.
In both cases the nonzero minor establishes that the corresponding
rational minor in the original coordinates is not identically zero.
Clear denominators and intersect its nonvanishing locus with the
distinct-point torus open set. This intersection has a `k`-point:
a finite product of nonzero polynomials over an infinite field is
nonzero somewhere, by induction from the univariate root bound.
Consequently the original maximum rank over `k` is at least the
output rank `rho`. Taking an output tuple attaining its maximum
proves the asserted inequality.

This uses truncated local rings/Taylor coefficients, not divided
ordinary derivatives. No factorial need be invertible. It therefore
does not lose characteristic-two or higher-order jets in characteristic
`p`. It also does not identify maxima over a prime field with maxima
over an algebraic closure.

### Exposing the real weighted order in a finite test

The draft uses the order `(alpha+t beta,beta)` for real `t>0`.
There are only finitely many nonnegative integral exponents below a
chosen weight bound. Choose the bound strictly above all selected
least weights. Perturb `t` slightly to a rational `t'>t` so
the selected least weights remain below that bound, all finite strict
comparisons persist, and ties are resolved by increasing `beta`.
Terms originally above the bound cannot intrude because their weights
only increase. Clearing denominators yields a common positive integral
exposing weight for the finite collection.

The original real order stays fixed through all degrees. Only this
auxiliary weight depends on the finite test. For a fixed degree,
there are finitely many rows/labels, so the argument exposes all of
them together. No simultaneous infinite list of test points or
exposing weights is required.

## Compression and cross-degree multiplication

For a finite-dimensional Laurent row space `V`, successive elimination
at `z=1` gives a basis with distinct vanishing orders. The possible
orders of all nonzero elements are exactly those pivots, so their
number is `dim(V)`. This is a dimension argument, not an assertion
that these integers are consecutive.

Let the extreme old integer exponents be `a_-` and `a_+`.
For every nonzero row element `f`, the product `z^(-a_-) f`
is a polynomial of degree at most `a_+-a_-`. The multiplier is
a unit at one, so it leaves the vanishing order unchanged. Hence
every new order is in `[0,a_+-a_-]`, which in turn lies in
`[0,length]` if the old row lies in any real interval of that
length. Multiplication by this unit is used to prove the bound;
it is not an unannounced independent rowwise rank-preserving operation.

If row products satisfy `V_(N,gamma) V_(M,delta)` contained
in `V_(N+M,gamma+delta)`, additivity of order for nonzero
products gives the same inclusion for the new support orders.
This proves cross-degree gradedness for every pair of positive
degrees, not only the pairs sampled by the checker. Replacement
by initial powers of the regular parameter `z-1` is an instance
of the specialization proof above and transfers the full finite
mixed-order maximum ranks backward.

An integral unimodular exponent change has an integral inverse.
It is an automorphism of the torus in every characteristic, with
isomorphisms of the corresponding truncated local rings. It
preserves cardinalities, support addition and all those maximum
ranks exactly. No assertion about a determinant divisible by the
field characteristic is needed: the integral determinant is `+/-1`.

## Evidence, reuse and limits

Matching historical supporting judgements are
`judgement-C_RS_TRANSFER-551c43b498ea` and
`judgement-C_RS_COMPRESS-4fc250cc064c`, both attributed in the
old ledger to `reviewer:reshaping-audit`; each points to the same
unchanged old report. They support reuse of this proof text, not
native acceptance of the present coverage review.

The finite checker uses Hasse/Taylor coefficients and tests a few
characteristics, degrees, one-point orders, and normalized two-point
tuples. Those checks agree with their stored certificate but do not
prove the formal specialization, infinite-field nonvanishing argument,
or all-degree multiplicativity. The four Lean declarations concern
primitive heights and real identities, not this unit.

The argument above supplies the elementary facts it uses; no unproved
external mathematical theorem is invoked. Source-text assumptions
have been recorded and independently attributed, not treated as
proof that the manuscript's conclusions hold.

There is no identified unresolved step for the assertions in their
stated application. Applying them to the complete nodal/polygon
construction requires the hypotheses checked in the other units.
An unrestricted reading of the short ledger phrase without the
exposed-weight and regular-coordinate setting is not certified.
No maximality, nefness, saturation or Nagata assertion follows here.
The strongest prior result is already `dw<1/3` with mixed-order
maximum-rank transfer; this review adds no stronger theorem or
literature-priority claim.

**Acceptance:** `pending_native_independent_review`.
