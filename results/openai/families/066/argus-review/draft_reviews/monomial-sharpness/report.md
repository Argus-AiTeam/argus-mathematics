# The smooth-surface sharpness family

**Assessment:** `C_LC_SHARPNESS` v1 is an exact infinite-family
calculation supporting the stated sharpness conclusions. It is
neither a finite search nor a counterexample to either manuscript.

## Exact construction and version

On `X=Spec C[x,y]` at the origin take the lc boundary `div(x*y)`.
For every real `q>0`, put `z=y-x` and let `v_q` be monomial in
regular coordinates `(x,z)` with weights `(1,1+q)`. For every integer
`m>=1` use `f_m=(y-x)^m`.

The old claim asserts

```
A_X(v_q)=2+q,       v_q(x*y)=2,        e(v_q)=q,
vol(v_q)=1/(1+q),  r=ord_0,
v_q(f_m)-r(f_m)=m*q.
```

Its single version has hash
`ec2942f7919aa3d94b0b7003f4e5aba083e14f02acbbae41d5adffeb65e9b9b5`.
The source is `verification.md:461-507`, with arithmetic recorded in
`verify.py` and `exact_certificate.json`. The contribution is an
elementary example/check in the old Argus draft. No novelty search
establishes that the example or sharpness observation is new.

## Checking every geometric formula

The coordinate change is invertible, so the positive monomial
weights define a centred quasi-monomial valuation on a smooth
surface. Since `y=x+z` and the two terms have distinct values,
`v_q(y)=1`; hence `v_q(x*y)=2`. Smooth monomial discrepancy is the
sum of the weights, giving `2+q` and defect `q`.

On the first blowup, `t=x` and `s=y/x-1=z/x` have weights `(1,q)`.
The crepant boundary for `div(x*y)` has coefficient one on the
exceptional divisor. The point `s=0` is away from the strict
transforms of the axes. Retraction to the coefficient-one skeleton
through this point retains only the exceptional weight `1`, hence
is exactly the ordinary order `ord_0`.

For the volume, the monomials outside `a_T(v_q)` are
`i,j>=0` with `i+(1+q)*j<T`. Counting the triangle gives
`T^2/(2*(1+q))+O(T)` for each fixed positive real `q`, including
irrational `q`. Multiplication by `2!/T^2` gives `1/(1+q)`.
This is the geometric volume justification; checking a polynomial
identity alone would not establish it.

The powers `f_m=z^m` have values `m*(1+q)` and `m`, so the excess
is exactly `m*q`. On the blowup `A_(P,F)(v_q)=q`. Since the
generator degree of `f_m` is `m`, no fixed degree-independent
constant can bound the loss by that defect as `m` grows.

After normalizing `A_X=1`, the defect is `q/(2+q)` and the
relative excess `(v_q(f_m)-r(f_m))/r(f_m)` is still `q`.
Their ratio tends to `2` as `q` tends to zero. This disproves a
uniform `o(e)` replacement of the multiplicative error within
bounded-discrepancy, uniformly centred examples. It does not
assert the optimal constant in the existing `O(e)` estimate.

## Off-skeleton comparison and replay boundary

For the allowed height `b(v)=v(x*y)`, its value on the `A_X=1`
lc slice is one. The effective klt pair
`(X,(1-lambda)*div(x*y))`, `0<lambda<1`, has discrepancy
`q+2*lambda` at `v_q` and `2*lambda` at `r`. Thus its
normalized-volume excess is

```
(q+2*lambda)^2/(1+q)-4*lambda^2
  = q*(q+4*lambda*(1-lambda))/(1+q) > 0.
```

The fresh exact polynomial replay is recorded in
`../scalar-penalty/replay/arithmetic_replay.json`; its four
identities have zero residual terms over rational polynomial
arithmetic. The identity in independent indeterminates plus the
displayed factor signs covers every `q>0`, `0<lambda<1`, and the
power identity covers every positive integer `m`. No sampling
or numerical extrapolation is being relabelled as a proof.

Conversely, this single family does **not** establish global
minimization against all valuations. It only shows that this
proposed off-skeleton attack cannot beat `r`; global exactness
has its separate proof.

Prior independent support
`judgement-C_LC_SHARPNESS-adb7c8365af0` reads the same unchanged
proof draft. The real toolchain for the arithmetic replay is
Python standard-library `fractions.Fraction`; Lean certifies no
surface or valuation formula here. No concrete gap was found in
this family or its two stated sharpness consequences.
