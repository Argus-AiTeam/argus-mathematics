# Excluding multiplicity five below lower index seven

For `a>=2`, let

`S(a)=P(a)\{(a,1)}`

and, when `S(a)` is nonempty, let

`K(a)=max{k:(n,k) in S(a)}`.

The conclusion proved here is

`m(a)=5 => K(a)>=7`,

conditional on the three complete published classifications stated
below.  The finite recovery from those classifications is checked by
`research/lower_index_six_certificate.py`.

## The five possible lower-index sets

For fixed `k`, `binomial(n,k)` is strictly increasing for `n>=2k`.
Thus distinct members of `S(a)` have distinct lower indices.  If
`m(a)=5`, then `|S(a)|=4`.  Under the contrary assumption `K(a)<=6`,
the four lower indices form one of the five four-element subsets of
`{2,3,4,5,6}`:

`{2,3,4,5}`, `{2,3,4,6}`, `{2,3,5,6}`,
`{2,4,5,6}`, or `{3,4,5,6}`.

Three sets contain both `2` and `5`.  The other two contain,
respectively, both `2,3` and both `3,4`.

## Sets containing lower indices 2 and 5

Bugeaud--Mignotte--Siksek--Stoll--Tengely, Theorem 1.2, completely
solves

`binomial(Y,2)=binomial(X,5)`.

In the positive Pascal domain the only nontrivial common values are
`3003` and `11628`.  Exact complete enumeration gives

`P(3003)={(14,6),(15,5),(78,2),(3003,1)}`

and

`P(11628)={(19,5),(153,2),(11628,1)}`.

Their multiplicities are `4` and `3`, so neither can realize any of
the three four-column sets containing `{2,5}`.

## The lower-index set `{2,3,4,6}`

Avanesov proves that the only positive integers that are both
triangular and tetrahedral are

`1,10,120,1540,7140`.

His indices `x,y` satisfy

`3y(y+1)=x(x+1)(x+2)`.

The substitutions

`X=x+2`, `Y=y+1`

are a two-way identification with

`binomial(Y,2)=binomial(X,3)`

for positive source indices.  The five source pairs are

`(x,y)=(1,1),(3,4),(8,15),(20,55),(34,119)`.

Complete enumeration in the campaign's left half gives

| `a` | `P(a)` | `m(a)` |
|---:|---|---:|
| 1 | empty | 0 |
| 10 | `(5,2),(10,1)` | 2 |
| 120 | `(10,3),(16,2),(120,1)` | 3 |
| 1540 | `(22,3),(56,2),(1540,1)` | 3 |
| 7140 | `(36,3),(120,2),(7140,1)` | 3 |

No candidate has the four nontrivial lower indices `{2,3,4,6}`.

## The lower-index set `{3,4,5,6}`

Suppose

`binomial(Y,3)=binomial(X,4)`

with both occurrences in the left half, so `Y>=6` and `X>=8`.  Put

`u=Y-2`, `v=X(X-3)/2`.

The second quantity is integral, and direct multiplication gives

`v(v+1)=X(X-1)(X-2)(X-3)/4`

and

`u(u+1)(u+2)=Y(Y-1)(Y-2)`.

Therefore the binomial equality is equivalent in the forward
direction to

`v(v+1)=u(u+1)(u+2)`.

Mordell proves that all integer solutions of this equation are

- `u in {-2,-1,0}` with `v in {-1,0}`;
- `u=1` with `v in {-3,2}`;
- `u=5` with `v in {-15,14}`.

The left-half condition gives `u=Y-2>=4`, so only `u=5` remains.
But `X>=8` gives `v=X(X-3)/2>=20`, contradicting
`v in {-15,14}`.  Hence there is no left-half collision at all
between lower indices `3` and `4`, and the last four-column set is
impossible.

## Conclusion and certificate boundary

All five lower-index sets are impossible, proving

`m(a)=5 => K(a)>=7`.

For every finite candidate above, the certificate enumerates all
`1<=n<=a`; this is complete because in the left half
`binomial(n,k)>=binomial(n,1)=n`, so `binomial(n,k)=a` implies
`n<=a`.

Jacobian 0.14.0 was also queried through the Argus adapter.  Its full
catalog has exact point addition, scalar multiplication, point
membership, discriminant, and affine-curve validation operations, but
no Mordell--Weil basis, height-bound, or complete integral-point
operation.  The inspected operation
`algebraic_geometry.affine_plane_curve.check` accepted the exact
`(2,3)` collision polynomial as a degree-three affine curve in 1 ms.
That typed result is recorded only as a curve-input check; it supplies
no point list and no completeness evidence.  Unbounded completeness
comes from the cited Avanesov and Mordell theorems, not from Jacobian
or the project's finite enumeration.

## Sources

- Y. Bugeaud, M. Mignotte, S. Siksek, M. Stoll, Sz. Tengely,
  *Integral Points on Hyperelliptic Curves*, Algebra & Number Theory
  2 (2008), Theorem 1.2 and equation (1-4), pp. 860-861,
  DOI `10.2140/ant.2008.2.859`.
- E. T. Avanesov, *Reshenie odnoi problemy figurnykh chisel*,
  Acta Arithmetica 12 (1967), pp. 409-420.  The complete common-value
  statement is on pp. 409-410 and equation (1) is on p. 410,
  DOI `10.4064/aa-12-4-409-420`.
- L. J. Mordell, *On the integer solutions of
  y(y+1)=x(x+1)(x+2)*, Pacific Journal of Mathematics 13 (1963),
  problem and equations (1)-(2) on p. 1347, proof completed on
  p. 1351, DOI `10.2140/pjm.1963.13.1347`.
