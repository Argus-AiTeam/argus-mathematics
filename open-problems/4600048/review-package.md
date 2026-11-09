# Result 4600048 external review package

## Corrected statement

The literal catalogue identity

```text
Per(beta) = Q intersect [0,1)
```

for every Salem number is false. Schmidt's classical open problem instead
uses `Q(beta)` on the right-hand side.

## Exact witness

Let `beta` be the larger real root of

```text
p(t) = t^4 - 3t^3 + 3t^2 - 3t + 1.
```

Reduction modulo two proves that `p` is irreducible. The substitution
`u=t+t^(-1)` gives

```text
p(t)/t^2 = u^2 - 3u + 1,
u = (3 +/- sqrt(5))/2.
```

Thus the conjugates are `beta`, `beta^(-1)`, and one nonreal conjugate pair
on the unit circle; the larger root satisfies `beta>2`. Hence `beta` is a
Salem number.

Set

```text
x = 1/(beta-1).
```

Then `0<x<1` and `beta*x=1+x`, so `T_beta(x)=x`. The point is irrational,
because rationality of `x` would make `beta=1+1/x` rational. Therefore
`x` lies in `Per(beta)` but not in `Q`.

## Scope

The same point belongs to `Q(beta)`. It is therefore not a counterexample to
Schmidt's open identity

```text
Per(beta) = Q(beta) intersect [0,1).
```

This publication is an erratum and scope correction, not an original
resolution of the Salem-base problem.

## Reproduction

Run:

```bash
python3 verify.py
```

The verifier uses exact integer and rational arithmetic. Independent
scientific review and a separate atomic-integration review have both passed.
