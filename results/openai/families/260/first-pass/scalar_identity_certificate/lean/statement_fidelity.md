# Statement fidelity: scalar algebra

The declarations are in namespace `ScalarIdentityCertificate` in `Main.lean`.
This is a formalization of the universal real algebra supporting the two local
propositions, not a formalization of differential geometry or the Penrose
inequality. No global existence, energy condition, boundary, asymptotic, or
literature assumption occurs in the Lean theorem.

## Variables and translation

The real variable `k` satisfies `2 <= k`; it specializes to the integer
`n - 1` for every spatial dimension `n >= 3`. The real parameter `p` is
nonnegative. The real variable `a` satisfies `a^2 < 1`, with `v = a^2`
and `d = 1 - a^2`. Allowing a negative `a` is harmless and is slightly
more general than the manuscript's nonnegative gradient length.

The definitions `q`, `s`, `chi`, `transverse`, `axialX`, `axialF`,
`B`, and `axialJ` are respectively

```
q = k + p a^2
s = p + (k-1)/2
chi = k d/q
A = k s - (k-1)^2 a^2/4
alpha = k s d
beta = (k+1)/(2k)
B = (k(k+2)+a^2)/(2(k+1))
gamma = k d B/q^2.
```

In the manuscript's orthogonal block decomposition, the scalar inputs are
`t0 = |T^0|^2`, `z2 = |M+s a y|^2`, `y2 = |y|^2`,
and `m2 = |M|^2`. The real scalars `F`, `j`, `x` are exactly the
manuscript's trace, axial tensor entry and axial derivative. The formal theorem
assumes the nonnegativity of the first three squared norms and the recovery
inequality

```
m2 <= 2 z2 + 2 s^2 a^2 y2.
```

This is not an additional geometric hypothesis:
`shift_recovery` proves its scalar summand, and
`finite_shift_recovery` proves its sum over an arbitrary finite index set.
The application takes an orthonormal basis of the `k`-dimensional transverse
space. The separate elementary orthogonal decomposition
`|T|^2 = |T^0|^2 + (F-chi j)^2/k` is used in the mathematical report; the
Lean theorem directly controls this scalar expression rather than defining
matrices, their trace, or an orthonormal frame.

## Declarations and conclusions

`completed_axial` identifies `quadratic` with `completed`. Here `quadratic`
is the displayed manuscript expression with its already-completed transverse
square denoted by `z2`; `completed` is its sum of the three axial squares.
This rational identity assumes only the nonvanishing denominators
`k`, `k+1`, and `q`. It is not a finite numerical check.

`coefficient_bounds` proves the ten explicit coefficient and weight estimates
needed for coercivity from `k >= 2`, `p >= 0`, and `a^2 < 1`.
`reconstruction` proves the generic sum-of-squares recovery argument from
those estimates. `coercivity` combines them to prove nonnegativity and

```
t0 + (F-chi j)^2/k + m2 + d j^2 + F^2 + y2 + d x^2
    <= (32+4 k^2) (1+p)^2 quadratic.
```

`coercivity_in_N` assumes the additional real inequality `p <= N` and proves
the same estimate with exactly `(1+N)^2`. In particular it does not replace
the required quadratic dependence with a higher-degree polynomial. There is
no positive lower bound on `d`; the theorem includes `a = 0` and applies
arbitrarily close to `a^2 = 1`, but does not include that excluded endpoint.

`stationary_coercivity` is the two-sided stationary estimate. It assumes
`k >= 2`, `0 <= c <= 1`, and nonnegative `t0,m2`; it proves that the
completed stationary energy lies between `1/16` and `3` times
`t0+m2+F^2+c j^2`. Applying `c = chi` gives the manuscript's estimate.

`cutoff_redistribution` proves the polynomial cancellation of the two terms
proportional to the arbitrary real variable `p1`, leaving `-p1 v y2`.
It does not itself identify those terms as geometric divergences.
`graph_divergence_algebra` proves the universal polynomial equality between
the Riemannian graph contraction and the independently expanded divergence
contraction given in the report. Its inputs are arbitrary reals representing
the block trace, squared tensor norm, mixed norm and contractions. It does
not formalize connections, covariant derivatives, Gauss' equation, or the
geometric reduction to those inputs.

`quadratic_exponent_sharpness` proves that the explicit family with
`k=2`, `a=1/2`, `j=2+p/4`, `x=-1/2`, `F=1/2`, and all transverse
squared norms zero has energy exactly `33/16` for every `p >= 0`.
The norm-to-energy polynomial and its implication that the exponent two
cannot be lowered are also checked in `verify.py` and proved in the report;
the Lean declaration asserts the constant energy only.

## Unverified by the kernel

The matching of smooth geometric quantities to these real inputs, the
coordinate curvature derivation, smoothness and axis independence at zero
gradient, and the mathematical significance and novelty of this verification
remain human-review obligations. The zero-gradient case is not removed by
any formal denominator: denominators involve `k`, `k+1`, and `q`, not `a`.
No external literature result is used as an axiom in this source.
