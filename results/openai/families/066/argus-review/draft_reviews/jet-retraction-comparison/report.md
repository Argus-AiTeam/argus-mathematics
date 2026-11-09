# Logarithmic jets and simultaneous local-ring comparison

**Assessment:** the degree-linear jet argument and its multiplicative
local-ring consequence are supported in the draft's quasi-monomial
working domain, with the stated discrepancy and centering bounds. This
is a human proof assessment, not a consequence of the scalar compiler.

## Exact claims, sources and hypotheses

`L_LC_JET` v1 asserts that for fixed affine generators, smooth resolution
`P`, and reduced snc divisor `F`, one `K` satisfies

```
0 <= v(g)-r_F(v)(g) <= K*(D+1)*A_(P,F)(v)
```

for every nonzero polynomial `g` of generator degree `D` and every
quasi-monomial `v`, including nonclosed centres and disappearing normal
weights. This is not a constant independent of `D`.

`L_LC_ALL` v1 asserts that, on the fixed germ and lc boundary, with
`r=r_F(v)`, `e=A_X(v)-v(Psi)`, `A_X(v),A_X(r)<=M` and
`v(m),r(m)>=c0>0`, one `C` works simultaneously for every nonzero local
regular function:

```
r(f) <= v(f) <= (1+C*e)*r(f),
vol(v)^(1/n) >= vol(r)^(1/n)/(1+C*e).
```

The supported domain is the quasi-monomial competitors used in
`verification.md:108-301`. The ledger's shorthand “every such v” must
not silently be read as a proved extension to arbitrary non-quasi-monomial
valuations. That extension is unnecessary for excluding actual ordinary
minimizers, since their quasi-monomiality is a separate known input.

The manuscript counterparts are `lem:E-log-jet`,
`cor:E-all-functions`, and complements equation `(A4)`. The two relevant
source sections match the exact revision and hashes in the coverage
index. These arguments already occur in the manuscripts; the old draft
is a reproduction/verification, not demonstrated original mathematics.

## Decisive checks of the jet argument

On each of finitely many etale charts use normal coordinates `z` and
tangential coordinates `y`. The chart function field is a finite
extension of `C(z,y)`. Multiplication by the finitely many affine
generators has fixed rational matrices. Clearing a common denominator
and taking the characteristic polynomial gives, for degree-`D` `g`,

```
sum_(j=0)^q p_j(z,y)*g^j = 0,    deg p_j <= H0*(D+1),
```

where `q,H0` are fixed and the constant term is nonzero.
For positive rationally independent weights on all coordinates, let
`gamma` be the leading exponent of `g` and `delta_j` that of `p_j`.
Cancellation forces `delta_j+j*gamma=delta_k+k*gamma` for some `j<k`,
so `|gamma|<=H0*(D+1)`. This bounds actual exponents, rather than a
weighted order divided by the smallest weight.

For the actual positive normal weights, the least normal exponents form
a finite set. Small generic normal and then positive tangential
perturbations select its vertices and a full exponent `(a,beta)`.
The same degree bound applies to each vertex and hence, by convexity,
to all the least normal exponents. Zero normal weights are handled on
the corresponding face chart. Thus no inverse smallest-weight constant
has entered the estimate.

With `L=ceil(H0*(D+1))`, the operator

```
partial_y^beta * product_i product_(0<=j<=L, j!=a_i)(z_i*partial_zi-j)
```

has order `O(D+1)`. It kills the other least normal terms and makes the
selected coefficient a unit. Higher normal terms remain in the
finitely generated monomial ideal of weights strictly above the least
weight. The congruence descends from completion by faithful flatness;
the proof does not assume continuity of an arbitrary valuation on the
completed ring.

For a regular logarithmic vector field `L0`,
`v(L0 f)>=v(f)-A_(P,F)(v)`. The sign in the draft is correct:
at a divisor `E`, a logarithmic top form has order `A_(P,F)(E)-1`,
and `f*dlog(f) wedge i_(L0)omega` has order at least `v(f)-1`.
Pullbacks of logarithmic differential forms have at most one normal
logarithmic pole in a nonzero wedge. Divisorial weights, then
approximation on an adapted quasi-monomial cone, give the stated
inequality. Iterating it through the operator proves the jet bound.
Localization handles nonclosed centres.

## The all-functions step and volume direction

On an adapted resolution,

```
e(v)=A_(P,E)(v)+sum_i delta_i*v(E_i),   delta_i>=0,
F=union_(delta_i=0) E_i.
```

The minimum positive `delta_i` gives
`A_(P,F)(v)<=H*e(v)`. Component formulas also bound the losses of
bare discrepancy and each resolved fixed function or ideal by `H*e`.
Effectivity of the crepant pullback is not required.

For `q=ord_m(f)>=1`, choose one integer `L0` with
`L0*c0>C_I*M` and set `N=L0*q+1`. A representative `g` of `f mod m^N`
has generator degree below `N`, also in the localized ring by truncating
unit inverses. The remainder has value at least `N*c0`, greater than
both values of `f` by bare-germ Izumi. Thus `v(g)=v(f)` and `r(g)=r(f)`.
The jet bound yields
`v(f)-r(f)<=K*(L0+1)*H*q*e`, while `r(f)>=c0*q`.
This supplies one multiplicative constant for all `f`, not a separate
constant for each equation. Units have value zero.

The ideal inclusions have the claimed direction: from
`v<=k*r`, `a_t(v)` is contained in `a_(t/k)(r)`, so
`vol(v)>=vol(r)/k^n`. Cutkosky's correctly normalized length limit
justifies passing to volume; integer/real thresholds are squeezed.

## Evidence, dependencies and limits

The same-version prior judgments are
`judgement-L_LC_JET-d5e9d37000b2` and
`judgement-L_LC_ALL-928341bb4ebb`, by `reviewer:dccb8f343ba8`,
on the unchanged proof hash recorded in the index. They agree with
the argument above. The old graph's `open` labels do not refute them
and are not imported as current acceptance.

External inputs are the smooth-model retraction/discrepancy facts of
Jonsson--Mustata (DOI `10.5802/aif.2746`, Lemma 4.7, Corollary 4.8,
Proposition 5.1, Corollary 5.4), Li's bare-germ log Izumi estimate
(`arxiv:1511.08164v4`, Theorem 3.1), and Cutkosky's volume limit
(`arxiv:1508.01938v1`, Theorem 1.1 = 5.5). The ordinary-input unit
checks their exact hypotheses and the corrected historical normalization.

No arithmetic test checks the algebraic chart or differential argument,
and no Lean theorem encodes it. Within the quasi-monomial, bounded and
uniformly centred scope, no missing mathematical step was identified.
An unrestricted valuation-domain reading would need an additional
extension argument; it is not claimed here.
