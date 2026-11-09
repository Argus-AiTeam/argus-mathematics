# 20000443 Evidence

Disposition: confirmed_counterexample.

## Frozen proposition

If `k` has cohomological dimension at most `1` and `X/k` is smooth,
projective, and rationally connected, must `X(k)` be nonempty?

## Ax's construction

Let `F` be an algebraically closed field of characteristic zero and put

```text
C = F((s))(s^(1/m) : gcd(m,6)=1),
Y = C((t))(t^(1/n) : gcd(n,5)=1).
```

On pages 1215-1216 of his 1965 Proceedings paper, James Ax proves that
`cd(Y)=1` and constructs a degree-five form in ten variables with no
nontrivial zero over `Y`. Choose the norm forms in Ax's construction as

```text
J(u,v) = u^2 - s v^2,
K(u,v,w) = Norm_{C(s^(1/3))/C}(u + v s^(1/3) + w s^(2/3)),
L(u,v) = J(u,v) K(u,v,0) = (u^2-sv^2)(u^3+sv^3).
```

Then Ax's form (his equation (1)) is

```text
H(z1,...,z10) = L(z1,z2) + t L(z3,z4) + t^2 L(z5,z6)
               + t^3 L(z7,z8) + t^4 L(z9,z10).
```

Ax's valuation argument shows that `H` has no nontrivial zero over `Y`.
Consequently the projective hypersurface `X = V(H)` in `P^9_Y` has
`X(Y)=empty`.

## Smoothness check

Dehomogenize the binary quintic at `v=1`:

```text
f(z) = (z^2-s)(z^3+s) = z^5-sz^3+sz^2-s^2.
```

The exact Jacobian operation `polynomial.multivariate.resultant.compute`
returns

```text
Res_z(f, df/dz) = -108 s^7 (s-1)^2.
```

This is nonzero in `C`, where `s` is the Laurent-series parameter. Thus
`L` is squarefree over an algebraic closure. Also `L(1,0)=1`, so there is
no root at infinity. If all partial derivatives of `H` vanished at a
projective point, both partial derivatives of `L` would vanish on every
two-coordinate block; squarefreeness forces every block to be `(0,0)`,
which is impossible in projective space. Hence `X` is smooth.

The exact request and typed output are archived in
`jacobian-request.json` and `jacobian-output.json`. The requested Argus
adapter was absent from the pinned checkout; `adapter-status.json` records
that error and the direct pinned-CLI fallback.

## Rational connectedness

Adjunction gives

```text
K_X = O_X(5-10) = O_X(-5).
```

Therefore `-K_X=O_X(5)` is ample, so after base change to an algebraic
closure `X` is a smooth Fano variety. Campana's Corollary 3.2 states that
Fano varieties are rationally connected. Thus `X/Y` is geometrically
rationally connected.

## Conclusion

`Y` has cohomological dimension `1`; `X/Y` is smooth, projective, and
rationally connected; and `X(Y)` is empty. This exactly refutes the frozen
universal proposition.

Reproduction command:

```bash
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian run polynomial.multivariate.resultant.compute --file evidence/20000443/jacobian-request.json
```

