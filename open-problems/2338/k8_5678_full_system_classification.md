# Full simultaneous columns `5,6,7,8`

## Result

This round does **not** classify all integer points and does not prove the
`{5,6,7,8}` branch empty.  It gives a bidirectionally exact four-column
model, proves all-primary synchronization, and then keeps the complete
primary allocation rather than only its six row-gap consequences.

```text
for every p^e || a, one term in each of the four numerator windows
is divisible by p^e, with one coherent offset quadruple.
```

The exact allocation is a `5*6*7*8` tensor of pairwise coprime primary
cells.  Every one of its `5+6+7+8` marginals is nontrivial.  An exact
integer-root classification of every sparse column-`7` singleton then
proves the new necessary condition

```text
omega(a) >= 14.                                    (*)
```

This is a global four-column theorem, not a finite row search.  It removes
all coherent allocations with at most `13` occupied primary cells.  The
remaining `omega(a)>=14` allocation problem is still global and
unclassified.

The full normalization is geometrically integral of genus `1987`.  It has
two geometric points at infinity, conjugate over `Q(sqrt(14))`, so the
already reviewed direct Runge count still fails.

The rerunnable certificate is
`research/k8_5678_full_system_certificate.py`; it writes
`research/k8_5678_full_system_classification.json`.

## Exact model and campaign domain

Write

```text
P_k(X)=X(X-1)...(X-k+1).
```

For rows `x,s,y,z` in columns `5,6,7,8`, respectively, put
`t=P_5(x)=120a`.  The four equal binomial coefficients are equivalent,
without division by any variable, to

```text
P_5(x)=t,
P_6(s)=6t,
P_7(y)=42t,
P_8(z)=336t.                                      (1)
```

The all-disjoint campaign domain is exactly

```text
x>=10, s>=12, y>=14, z>=16,
x-s>=5, s-y>=6, y-z>=7.                           (2)
```

Indeed, the four numerator windows are then ordered from right to left,
and the three gap inequalities in (2) are precisely the three adjacent
disjointness conditions.

The centered variables

```text
u=x-2, V=2s-5, v=y-3, W=2z-7
```

give the equivalent equations

```text
u(u^2-1)(u^2-4)=t,
(V^2-1)(V^2-9)(V^2-25)=384t,
v(v^2-1)(v^2-4)(v^2-9)=42t,
(W^2-1)(W^2-9)(W^2-25)(W^2-49)=86016t.            (3)
```

Their exact domain is

```text
u>=8, V>=19 odd, v>=11, W>=25 odd,
2u-V>=11, V-2v>=13, 2v-W>=15.                     (4)
```

The inverse is

```text
x=u+2, s=(V+5)/2, y=v+3, z=(W+7)/2.
```

Equations (3)-(4) therefore neither delete nor introduce a campaign point.

## Smooth geometrically integral fiber product

Regard (1) as a cover of the `t`-line.  Its affine coordinate ring is

```text
Q[t,x,s,y,z] /
  (P_5(x)-t, P_6(s)-6t, P_7(y)-42t, P_8(z)-336t).  (5)
```

It is finite free of rank

```text
5*6*7*8=1680
```

over `Q[t]`.  The squarefree finite branch-support polynomials of the four
coordinate covers are

```text
D_5 = 3125t^4-47500t^2+82944,

D_6 = (128t+75)(81t^2+160t-192),

D_7 = 96889010407t^6-542352478080t^4
      +199502585856t^2-13271040000,

D_8 = (4096t-525)
      (5488t^3+9261t^2-2646t-675).                 (6)
```

The certificate recomputes the four derivative resultants and proves that
all six pairwise gcds of the polynomials in (6) are `1`.  It also proves
`gcd(P_k',P_k'')=1` for `5<=k<=8`.  Hence every finite ramification point
is simple and two coordinate covers never ramify over the same finite
value.  The Jacobian matrix of (5) consequently has rank four at every
affine geometric point.

Each field `Qbar(t)(n_k)` with `P_k(n_k)=c_k t` has degree `k`.  Inductively,
its intersection with the compositum of the preceding coordinate fields
can ramify only where both covers ramify.  By (6), that leaves only
`t=infinity`.  A nontrivial characteristic-zero cover of `P^1` cannot
ramify at only one point: if its degree is `d>1`, the ramification above
that point is at most `d-1`, contradicting Riemann--Hurwitz.  Every
intersection is therefore trivial.  This proves that (5) is geometrically
integral and has degree `1680`, not merely that its defining equations have
the expected generic rank.

## Complete boundary and genus

Over `Qbar((1/t))`, the four polynomial covers are the unique tame totally
ramified extensions of degrees `5,6,7,8`.  Their compositum has ramification
index

```text
lcm(5,6,7,8)=840.
```

Since the global degree is `1680`, the normalization has exactly two
geometric points above infinity.  At either point the pole orders are

```text
ord(t)=-840,
ord(x)=-168, ord(s)=-140, ord(y)=-120, ord(z)=-105. (7)
```

The valuation-zero function `z^4/s^3` distinguishes the two points.  From
(1), its two residues satisfy

```text
(z^4/s^3)^2 = 336/6 = 56,
```

so they are `+sqrt(56)` and `-sqrt(56)`.  Thus the two geometric points
form one degree-two closed point over `Q`, with residue field
`Q(sqrt(14))`.

The finite ramification contributions of the four coordinate covers are

```text
4*(1680/5)=1344,
5*(1680/6)=1400,
6*(1680/7)=1440,
7*(1680/8)=1470.
```

The two infinity points contribute `2*(840-1)=1678`.  Therefore

```text
2g-2 = -2*1680+1344+1400+1440+1470+1678 = 3972,
g=1987.                                             (8)
```

This boundary does not trigger the direct Runge theorem already checked in
the project.  Over `Q`, the pole support is one irreducible closed point, so
`r=1=|S|`.  Over `Q(sqrt(14))`, it splits into two points but the totally
real quadratic field has two archimedean places, so again `r=2=|S|`.
Adding the extra integral coordinates does not create extra pole-support
components.  This exhausts the direct normalized-fiber Runge route; it is
not an integer-point classification.

## The all-primary LCM lemma

Let `I` be any interval of `k` consecutive positive integers and `L_I` its
least common multiple.  Then

```text
product(I)/(k-1)! divides L_I.                       (9)
```

Here is a self-contained valuation proof.  Fix a prime `p`, let
`E=max_{m in I} v_p(m)`, and let `N_j` count the terms divisible by `p^j`.
For `j<=E`, retain one term having valuation `E`.  The other multiples of
`p^j` are spaced by at least `p^j` inside an interval of span `k-1`, so

```text
N_j-1 <= floor((k-1)/p^j).
```

For `j>E`, `N_j=0`.  Summing over `j` gives

```text
v_p(product(I))-E <= v_p((k-1)!),
```

which proves (9) for every prime.

For the column-`k` numerator window of an occurrence
`C(n_k,k)=a`, (9) says

```text
k*a divides lcm(n_k-k+1,...,n_k).                   (10)
```

Fix `p^e || a`.  Equation (10) implies that, in every one of the four
windows, at least one term is divisible by `p^e`.  Choose its offset

```text
h_k(p) in {0,...,k-1},
p^e | n_k-h_k(p).                                   (11)
```

The same primary power is used in all four rows.  If

```text
d56=x-s, d67=s-y, d78=y-z,
```

then (11) gives the coherent congruences

```text
d56 == h_5-h_6,
d67 == h_6-h_7,
d78 == h_7-h_8                         (mod p^e).    (12)
```

There are `5*6*7*8=1680` offset quadruples and exactly `840` distinct
triples in (12).  The certificate verifies the complete finite set.  The
three adjacent selected-term differences are positive by (2), so every
primary power also satisfies

```text
p^e <= min(d56+5, d67+6, d78+7).                    (13)
```

Unlike the previous `p>8` selection, (11)-(13) include `p=2,3,5,7` and
leave no smooth residual.

## Six exact row-gap divisibilities

For `k<l`, define

```text
R_kl(D)=product_(r=-(l-1))^(k-1) (D-r).              (14)
```

For each `p^e || a`, the relevant factor in (14) is
`D-(h_k-h_l)` and is divisible by `p^e`.  Distinct primary powers are
coprime, so multiplying over the primes proves

```text
a | R_56(d56),
a | R_67(d67),
a | R_78(d78),
a | R_57(d56+d67),
a | R_68(d67+d78),
a | R_58(d56+d67+d78).                              (15)
```

This is a global four-window statement about the complete common value.
It does not replace (1): retaining (1) obviously implies (15), while (15)
alone does not recover the binomial equalities.

The improvement over the prior large-primary relaxation is strict.  For
every `N>=4`, put

```text
a_N=2^(4N), z_N=2^N,
(x_N,s_N,y_N,z_N)=(z_N+18,z_N+13,z_N+7,z_N).         (16)
```

These are positive left-half rows with disjoint gaps `5,6,7`.  Their
`p>8` part is `L=1`; their old smooth residual is
`b=a_N=z_N^4`, so the old conditions `b<=z^4` and
`L | R_kl` are satisfied.  But

```text
R_56(5)=10!, v_2(R_56(5))=8 < 4N=v_2(a_N),
```

so (15) rejects every member of (16).  The family (16) is deliberately a
family of pseudoconfigurations, not of curve points.  It proves that the new
all-primary condition deletes a nonempty infinite part of the old relaxed
search space; it is not a counterexample and not an existence claim.

## Exact primary-cell tensor

For every primary `p^e || a`, choose one coherent offset quadruple

```text
H(p)=(h_5(p),h_6(p),h_7(p),h_8(p))
```

from (11).  For each of the `1680` possible quadruples put

```text
A_H = product_(H(p)=H) p^e
```

with an empty product equal to `1`, and define its column marginals by

```text
L_(k,h) = product_(H:h_k=h) A_H.                    (17)
```

The nonunit `A_H` are pairwise coprime and

```text
product_H A_H=a,       product_h L_(k,h)=a.         (18)
```

Since `L_(k,h)` divides `n_k-h`, write

```text
n_k-h=L_(k,h)u_(k,h).
```

Multiplying over the `k` offsets and using
`P_k(n_k)=k!a` gives the exact identities

```text
product_(h=0)^(k-1) u_(k,h)=k!,
u_(k,h)L_(k,h)-u_(k,h+1)L_(k,h+1)=1.               (19)
```

Conversely, (17)-(19), positivity, and one common collection of cells
recover `P_k(n_k)=k!a` in all four columns.  Thus (17)-(19) are a
bidirectionally exact allocation model; unlike (15), they do not discard
the coefficient equalities.

Every marginal in (17) is nontrivial.  Indeed, if `L_(k,h)=1`, then

```text
n_k-h=u_(k,h) divides k!.
```

There are only the following distinct campaign-row candidates:

| `k` | divisors of `k!` | candidate rows `n_k` | range |
|---:|---:|---:|---:|
| 5 | 16 | 39 | `10..124` |
| 6 | 30 | 102 | `12..725` |
| 7 | 60 | 259 | `14..5046` |
| 8 | 96 | 544 | `16..40327` |

For each candidate the certificate computes `a=C(n_k,k)` and performs
exact monotone inversion in the other three columns.  No value occurs in
all four columns.  This is a finite divisor classification forced by
`L_(k,h)=1`, not a cutoff imposed on the original rows.

## Excluding at most thirteen occupied cells

Let `c` be the number of nonunit cells `A_H`.  Their column-`7` offsets
partition the `c` cells into seven nonempty marginals.  If `c<=13`, one
of those marginals is a singleton; write its cell as `A`, its offsets as
`h` in column `7` and `j` in column `8`, and its column-`8` marginal as
`AB`.  Equations (19) give

```text
y-h=A p,       z-j=A q,
p=u_(7,h) divides 7!,       q=B u_(8,j).            (20)
```

The disjoint inequality `y-z>=7`, together with `0<=h<=6` and
`0<=j<=7`, makes the first selected term strictly larger than the second.
Therefore

```text
1<=q<p,       p divides 5040.                       (21)
```

The exact `(7,8)` equality in (1) is now

```text
F_(h,j,p,q)(A)
  =P_8(j+qA)-8P_7(h+pA)=0.                          (22)
```

There are exactly

```text
7*8*sum_(p|5040)(p-1)=1,079,904
```

polynomials in (22).  For each one the campaign domain starts at

```text
A_0=max(1,ceil((16-j)/q),ceil((7+j-h)/(p-q))).
```

After exact translation by `A_0`, `489636` polynomials have no sign
variation and positive constant term.  The other `590268` have one sign
variation and negative constant term, hence exactly one positive real
root after `A_0`.  Factoring the forced root `A=0` from (22) gives
multiplicity `1` in `1079759` cases and multiplicity `2` in `145` cases.
The integer-root theorem bounds every positive integer root by the first
nonzero coefficient.  In `108345` cases the real root is beyond that
bound; in the remaining `481923` cases exact bisection puts it strictly
between consecutive integers.  There is no campaign integer root.

Thus `c>=14`.  Every occupied cell contains a distinct prime divisor of
`a`, so `omega(a)>=c>=14`, proving (*).

The strengthening is strict relative to the preceding coherent-offset
relaxation.  For every prime `q>=2`, put

```text
a=q,       (x,s,y,z)=(40q,36q,28q,16q).
```

These rows satisfy all campaign inequalities.  The sole primary uses
offset quadruple `(0,0,0,0)`; `k*a` divides the corresponding window lcm,
and `a` divides all six row-gap polynomials because every row gap is a
multiple of `a`.  The four binomial coefficients are not asserted equal.
This infinite pseudofamily passes the preceding all-primary relaxation and
is rejected by marginal nontriviality, so (*) is not a reformulation of
(12) or (15).

## Jacobian record

The required Argus adapter discovery returned
`polynomial.compute.resultant` as the matching bounded operation.  Its exact
read-only typed contract was inspected before use.  The payload contains
the degree-`3` and degree-`4` squarefree branch-support polynomials `D_6`
and `D_8`.  Jacobian `0.14.0`, protocol `2025-11-25`, returned

```text
-1032328973349640579114596832324104960000
```

with the `SYLVESTER_DETERMINANT` convention in `56 ms`.  The adapter exited
zero, did not time out, and returned no structured error.  Discovery,
contract, exact payload, typed output, and status are preserved under
`research/jacobian/k8_5678_full_system/`.

This operation verifies only one of the six nonzero branch-support
resultants.  The project certificate independently recomputes that value
and all six polynomial gcds.  Jacobian supplies neither the fiber-product
strategy nor an integer-point classification.

For the new finite root subproblem, adapter discovery returned the exact
read-only operation `polynomial.roots.isolate`; its typed contract was
inspected before use.  On the off-domain control

```text
(h,j,p,q)=(0,7,15,8),
F(A)=P_8(7+8A)-8P_7(15A),
```

Jacobian `0.14.0`, protocol `2025-11-25`, isolated four simple real roots:

```text
0, one root in (0,1/5), 1, and one root in (76,77).
```

The exact root `A=1` recovers `y=z=15` and therefore violates both
`z>=16` and `y-z>=7`.  The operation returned in `18 ms`; the adapter
exited zero, did not time out, and returned no structured error.  Its
discovery, contract, payload, typed output, and status are preserved beside
the first Jacobian record.  This one operation cross-checks one control
polynomial only; the project certificate performs the exhaustive
`1,079,904`-case classification.

## Boundary and reproduction

Run from the campaign root:

```text
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/k8_5678_full_system_certificate.py
```

The exact output verifies all polynomial transformations, derivative and
critical-value calculations, pairwise branch separation, degree, boundary,
pole orders, genus, the finite LCM valuation kernels, all `1680` offset
quadruples and `840` residue triples, all six row-gap polynomials, the
exact tensor equivalence, all marginal divisor lists, the complete sparse
support root classification, both infinite strictness families, and both
typed Jacobian records.

The direct Runge route is exhausted at the conjugate-boundary count.  The
full primary-allocation route is narrowed to tensors with at least `14`
occupied prime cells, but remains open: no argument here classifies that
unbounded residual.  Consequently no full-system point list, branch
emptiness, `K>=9` theorem, or counterexample to universal multiplicity
realizability is claimed.
