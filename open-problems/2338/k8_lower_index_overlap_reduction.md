# Exact `K=8` lower-index and overlap reduction

This note proves at Engineer level the bounded statement

`m(a)=5 and K(a)=8`

implies that the four nontrivial lower indices are

`{3,5,7,8}` or `{5,6,7,8}`,                              (1)

and that the four corresponding numerator windows are pairwise disjoint.
It does not solve either surviving all-disjoint equality system.

## Primary-source completeness

The external completeness input is R. J. Stroeker and B. M. M. de Weger,
*Elliptic Binomial Diophantine Equations*, Mathematics of Computation 68
(1999), 1257-1281, DOI
`10.1090/S0025-5718-99-01047-9`.

The paper allows all `m,n in Z` under the polynomial definition of binomial
coefficients (p. 1259). It states the complete classifications as Theorems
A28 and A48 on p. 1259. The transformations are in Table 1 on p. 1260, and
the complete integral point lists are:

- Theorem B28 and Table T28, pp. 1261-1262;
- Theorem B48 and Table T48, pp. 1263-1264.

Section 3 (pp. 1268-1275) proves both classifications by linear forms in
elliptic logarithms. Proposition 2 and Tables 8-13 establish the relevant
Mordell-Weil data. Table 15 reduces the coefficient bounds to `M<=7` for
Q28 and `M<=6` for Q48. The terminal paragraph on p. 1275 says that every
solution below those reduced bounds was found and that this completes the
proof. Thus the source result is an all-integer classification, not a bounded
search in the row variables.

The retained source is
`research/literature/stroeker_deweger_1999.pdf`.

## Complete `(2,8)` recovery

For

`C(n,2)=C(m,8)`,

Table 1 uses

`U=(m^2-7m+12)/2`, `V=210n-105`.

Direct exact expansion gives

`V^2-(35U^4-350U^3+945U^2-630U+11025)`

`=88200*(C(n,2)-C(m,8))`.                              (2)

The inverse conditions are

`n=(V+105)/210`,

`(2m-7)^2=8U+1`.                                       (3)

Table T28 contains exactly the following 26 points, with both signs of every
displayed nonzero `V`:

```text
(U,|V|)=
(-147,132195), (-25,4445), (-15,1785), (-4,245),
(0,105), (1,105), (3,105), (6,105), (8,175),
(10,315), (21,1995), (55,16275), (91,46305).
```

The certificate checks (2), puts all 26 points on Q28, applies both inverse
conditions in (3), maps every inverse back to its source point, and substitutes
every recovered pair into the original binomial equation. The 32 recovered
integer pairs are exactly:

| rows `(n,m)` | value |
|---|---:|
| `{0,1} x {0,1,2,3,4,5,6,7}` | 0 |
| `{-1,2} x {-1,8}` | 1 |
| `{-9,10} x {-3,10}` | 45 |
| `{-77,78} x {-7,14}` | 3003 |
| `{-220,221} x {-10,17}` | 24310 |

The campaign left-half conditions are `n>=4` and `m>=16`. The unique pair
that survives them is

`C(221,2)=C(17,8)=24310`.                              (4)

The point `C(78,2)=C(14,8)=3003` is retained in the certificate but correctly
filtered because `14<16`: lower index 8 lies to the right of the midpoint of
row 14.

For any campaign occurrence of a positive value `a`,
`C(n,k)>=C(n,1)=n`, so every occurrence has `n<=a`. Exhaustive evaluation of
that complete finite row range gives

`P(24310)={(17,8),(221,2),(24310,1)}`.                 (5)

Thus (4) has multiplicity 3, not 5, and cannot supply any four-element
nontrivial lower-index set.

## Complete `(4,8)` recovery

For

`C(n,4)=C(m,8)`,

Table 1 uses

`U=(m^2-7m+6)/2`, `V=105n^2-315n+105`.

Exact expansion gives

`V^2-(105U^4+210U^3-945U^2-1890U+11025)`

`=264600*(C(n,4)-C(m,8))`.                             (6)

The inverse conditions are

`(2n-3)^2=(4V+525)/105`,

`(2m-7)^2=8U+25`.                                      (7)

Table T48 contains exactly the following 12 points, again with both signs:

```text
(U,|V|)=
(-3,105), (-2,105), (0,105), (3,105), (7,525),
(33,11445).
```

Checking all points and both directions of (7) recovers exactly 40 integer
binomial pairs:

| rows `(n,m)` | value |
|---|---:|
| `{0,1,2,3} x {0,1,2,3,4,5,6,7}` | 0 |
| `{-1,4} x {-1,8}` | 1 |
| `{-9,12} x {-5,12}` | 495 |

None satisfies the campaign domain `n>=8`, `m>=16`. In particular,

`C(12,4)=C(12,8)=495`

is present in the source recovery but is filtered because lower index 8 is
not in the left half of row 12.

## All twenty lower-index sets

A hypothetical `m(a)=5`, `K(a)=8` value has one trivial representation
`(a,1)` and four nontrivial representations with distinct lower indices.
There are exactly

`C(6,3)=20`

four-element subsets of `{2,3,4,5,6,7,8}` containing 8. The complete
classification is:

| lower-index set | decisive exclusion |
|---|---|
| `{2,3,4,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,3,5,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,3,6,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,3,7,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,4,5,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,4,6,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,4,7,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,5,6,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,5,7,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{2,6,7,8}` | `(2,8)`: only (4), whose complete `P` is (5) |
| `{3,4,5,8}` | `(4,8)`: no left-half collision |
| `{3,4,6,8}` | `(4,8)`: no left-half collision |
| `{3,4,7,8}` | `(4,8)`: no left-half collision |
| `{3,5,6,8}` | reviewed `(3,6)`: no left-half collision |
| `{3,5,7,8}` | survives |
| `{3,6,7,8}` | reviewed `(3,6)`: no left-half collision |
| `{4,5,6,8}` | `(4,8)`: no left-half collision |
| `{4,5,7,8}` | `(4,8)`: no left-half collision |
| `{4,6,7,8}` | `(4,8)`: no left-half collision |
| `{5,6,7,8}` | survives |

The certificate also records every additional applicable blocker, rather than
only the decisive one in this table. The counts are 10 exclusions by `(2,8)`,
6 further exclusions by `(4,8)`, 2 further exclusions by `(3,6)`, and the
2 survivors in (1).

## The ten new overlap equations

Let `k<l` be two adjacent lower indices and write their rows as `x+g,x`.
Equality in the left half forces the row order to be strictly decreasing, so
`g>=1`. Relative to `x`, their numerator windows are

`[g-k+1,g]` and `[1-l,0]`.

They overlap exactly for `1<=g<=k-1`. The two new adjacent pair types in (1)
are therefore:

- `(k,l)=(5,7)`, with `g=1,2,3,4`;
- `(k,l)=(7,8)`, with `g=1,2,3,4,5,6`.

Starting from

`C(x+g,k)=C(x,l)`,

multiplication by `l!` gives

`(x)_falling_l=(l!/k!)(x+g)_falling_k`.                (8)

Both sides contain exactly

`x(x-1)...(x-(k-g-1))`.

For `x>=2l` this common factor is positive, so cancellation is reversible
throughout the campaign domain. The reduced equation is

`product_(j=k-g)^(l-1)(x-j)`

`=(l!/k!)*product_(r=1)^g(x+r)`.                       (9)

The left side of (9) minus the right side gives the following ten monic
integer polynomials:

| `(k,l,g)` | polynomial, descending coefficients | signed divisors tested | integer roots |
|---|---|---:|---|
| `(5,7,1)` | `[1,-15,32,-162]` | 20 | none |
| `(5,7,2)` | `[1,-18,77,-468,276]` | 24 | none |
| `(5,7,3)` | `[1,-20,113,-832,582,-972]` | 36 | none |
| `(5,7,4)` | `[1,-21,133,-1155,154,-3864,-288]` | 36 | none |
| `(7,8,1)` | `[1,-21,34]` | 8 | none |
| `(7,8,2)` | `[1,-26,83,-226]` | 8 | none |
| `(7,8,3)` | `[1,-30,131,-726,792]` | 48 | none |
| `(7,8,4)` | `[1,-33,165,-1455,2354,-2712]` | 32 | none |
| `(7,8,5)` | `[1,-35,175,-2345,3304,-10220,4080]` | 80 | none |
| `(7,8,6)` | `[1,-36,154,-3360,889,-26124,-1044,-10800]` | 120 | none |

Every constant term is nonzero. Hence the monic integer-root theorem says
that every integer root is a positive or negative divisor of that constant
term. The project certificate evaluates every such signed divisor. It also
substitutes every candidate into both sides of (8) and verifies the exact
factorization of the original residual by the cancelled common factor.
There are no integer roots, without a cutoff in `x`.

For an independent exact diagnostic, the program also constructs the rational
Sturm chain of each polynomial, proves squarefreeness, isolates every real
root inside an exact Cauchy bound, and verifies that the intervals exhaust the
Sturm root count. This real-root work is not needed to turn a finite row search
into a proof: the signed-divisor argument already classifies every integer.

## Reused overlap classifications and consequence

The independently reviewed project certificates are read but not rerun:

- `(3,5)` has two overlap gaps and no admissible solution;
- `(5,6)` has four overlap gaps and only
  `C(15,5)=C(14,6)=3003`, whose complete occurrence set has `m=4`, `K=6`;
- `(6,7)` has five overlap gaps and no admissible solution.

Therefore the adjacent pairs are excluded as follows:

| surviving set | adjacent pairs |
|---|---|
| `{3,5,7,8}` | reviewed `(3,5)`, new `(5,7)`, new `(7,8)` |
| `{5,6,7,8}` | reviewed `(5,6)`, reviewed `(6,7)`, new `(7,8)` |

For increasing lower indices, equal left-half coefficients have strictly
decreasing rows. If adjacent numerator intervals with decreasing right
endpoints are disjoint, the earlier interval lies wholly to the right of the
later one. Chaining the three adjacent disjointness statements orders all four
intervals, so every pair is disjoint.

Thus, conditional on the cited complete A28/A48 classifications until
independent source attribution,

`m(a)=5 and K(a)=8`

forces one of the two sets in (1), with four pairwise disjoint numerator
windows.

## Bounded Jacobian cross-check

The Argus adapter discovered five candidates for exact univariate root
isolation and inspected the typed, read-only operation
`polynomial.roots.isolate`. One bounded call used the highest-degree case
`(k,l,g)=(7,8,6)` with the exact descending coefficient payload

`[1,-36,154,-3360,889,-26124,-1044,-10800]`.

Jacobian `0.14.0`, protocol `2025-11-25`, returned one simple real root in
`[34,35]` in `19 ms`. The adapter exited zero, with no timeout or structured
error. The project Sturm chain independently gives count one on that interval
and the same total real-root count. Jacobian is only this cross-check; the ten
integer-root classifications are carried by the project certificate.

The discovery result, exact contract, payload, typed output, and adapter status
are retained under `research/jacobian/`.

## Reproduction and boundary

Run

```text
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/k8_lower_index_overlap_reduction_certificate.py
```

The generated
`research/k8_lower_index_overlap_reduction_certificate.json` contains every
T28/T48 point and inverse image, all original-equation substitutions, all
source-value occurrence sets, all twenty lower-index decisions, every
cancelled polynomial and common factor, every signed divisor evaluation and
original-equation substitution, all Sturm records, and the bounded Jacobian
record.

This result does not exclude the two surviving all-disjoint exact-equality
systems, any `K>=9` branch, or prove that `m(a)=5` is impossible.
