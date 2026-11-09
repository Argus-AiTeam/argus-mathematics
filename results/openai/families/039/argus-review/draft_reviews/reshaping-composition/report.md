# The strongest prior reshaping theorem and its composition

**Assessment:** the existing prose proof supports `dw<1/3` reshaping
with mixed-order maximum-rank transfer under its exact hypotheses.
It is not a full Lean formalization, and finite experiments are not
the proof of its universal quantifiers. Native independent acceptance
of this assessment remains pending.

## Exact claims and comparison baseline

This unit covers historical `C_RS_COMPOSITION@v1`,
`C_RS_STRONG@v1`, and `C_RS_MAIN@v1`.
The old source is `9000039/research/reshaping_audit/report.md`,
particularly "Strengthened theorem", "A fixed primitive direction
and the improved constant", and "Complete composition and all-degree
coverage". The historical ledger contains matching supporting
`reviewer:reshaping-audit` judgements for all three statements.
Their unchanged proof text can be reused without calling those
judgements native acceptance of the present review.

The strongest relevant old claim is already the following theorem,
not merely the manuscript's `dw<1/16` proposition.

Fix an algebraically closed field `k`, of any characteristic, an
integer `n>=2`, positive real intercepts `A,B,a_3,...,a_n`,
and `w>0`. Put

```text
H=AB, d=max(3/A,2/B), W=dH, T=d^2 H, R=H/w,
Delta(a_1,...,a_n)={x>=0 : sum x_j/a_j <= 1}.
```

Suppose `dw<1/3`. For every graded family of finite integral
supports `S_N` in `N Delta(A,B,a_3,...,a_n)`, `N>=1`,
there exist finite integral supports `S'_N` in
`N Delta(w,R,a_3,...,a_n)` such that:

1. `#S'_N=#S_N` for every degree, and
   `S'_N+S'_M` is contained in `S'_(N+M)` for all positive `N,M`;
2. coordinates `3,...,n` remain the same labels, row by row;
3. for every degree, every finite number of distinct torus points,
   and every finite list of nonnegative orders, the maximum rank
   of the output monomial jet map is at most that of the input.

The jet quotient at order `m` is `O/m^(m+1)`; no factorial
convention is hidden. Supports are constructed for each fixed field.
They need not be identical in different characteristics. Tuples
attaining rank may depend on the degree and finite jet test.
There is no common tuple for infinitely many tests in this assertion.

Historical `C_RS_COMPOSITION` is the fixed sequence of operations
and residual-row bound proving the first two conclusions;
`C_RS_STRONG` adds the full rank assertion;
`C_RS_MAIN` is the original `dw<1/16`, equal-order-surjectivity
special case. The latter follows since `1/16<1/3` and an
equal-order profile is a mixed-order profile.

The staged target is `prop:reshape`,
positive-characteristic `04-reshape.tex:14-28`, with conventions
in `02-transfer.tex:11-48`. Source correspondence to revision
`4eaee87548250b2682affda7d05d947c05554bae` and the complete
locators are in `../companion-trace/report.md`. The nodal,
shear and compression construction is from that source.
The fixed-three direction and claimed improvement from the staged
constant belong to the old Argus draft. This review does not
improve on the old `1/3` result, establish optimality, or assert
global literature novelty.

## Decisive argument, with all-degree obligations

### One choice for every degree and unchanged label

From `dA>=3` and `dB>=2`, positivity gives `T>=6`.
The fixed-three lemma produces integers `i,p,q` with
`iq-3p=1` and positive real `a,b,t` satisfying

```text
a+b=W, a=Wt/(1+t), b=W/(1+t), t>T,
-3a < 3b < i/d, i/d+3a=R.
```

This requires only `H,d,w>0`, `T>=6`, and `dw<1/3`.
The construction and the exact theorem-fidelity comparison are
in `../fixed-three-height/report.md`. That arithmetic assertion
has a fresh official Lean 4.31.0 compiler certificate. The prose
intercept substitution `T>=6` and the subsequent polygon
interpretation are separate from what those declarations encode.

Choose these numbers and the determinant-one lattice basis
`u=(i,3)`, `v=(p,q)` once. None depends on `N` or a label.
For each present label `gamma=(gamma_3,...,gamma_n)`, set
`kappa=N-sum_(h>=3) gamma_h/a_h`. The original simplex bound
forces `kappa>=0`; its two-coordinate row lies in
`kappa Delta(A,B)`.

Apply the fixed nodal valuation to the corresponding polynomial
row space. The nodal unit proves that its least exponents lie in

```text
kappa Q, Q=conv{0,(a,0),(c,c),(0,b)}, c=1/d.
```

Distinct valuation pivots count exactly the row dimension.
The least exponent of a product is the sum of the least exponents.
Original gradedness therefore gives rowwise multiplication in every
pair of degrees after this step. This works with arbitrary sparse
input supports; filling a simplex is not assumed.

### The first compression is a continuous slice-length calculation

Since `t>T`,
`c/a+c/b=(1+t)^2/(Tt)>1`; thus the stated ordering of the
quadrilateral vertices is valid. Shear by
`(alpha,beta)->(alpha-beta,beta)`.
At horizontal coordinate `z`, the sheared polygon's vertical
length is

```text
c(1+z/b) for -b<=z<=0,
c(1-z/a) for 0<=z<=a.
```

These follow by subtracting the affine endpoints of each slice.
Order-at-one compression replaces each Laurent row by
nonnegative orders at most its old integer exponent span,
which is at most that real slice length. The resulting support
is therefore bounded by

```text
kappa P, P=conv{(-b,0),(a,0),(0,c)}.
```

No slice has been replaced by its number of lattice points.
This distinction is essential with real intercepts, negative
intermediate exponents and sparse rows. The area of `P` is
`c(a+b)/2=H/2`.

### Primitive heights, the tent, and the final simplex

Write exponents in basis `(u,v)`. This is an integral
determinant-one map, so both exponent integrality and area are
preserved. The second coordinate is `det(u,z)`. The three
vertex heights of `P`, in increasing order, are

```text
q0=-3a, q1=3b, q2=i/d, q2-q0=R.
```

A triangle's horizontal slice length is affine between its
vertex heights, zero at `q0,q2`, and maximal at `q1`.
Its area is half its vertical range times this maximum.
Since the area is `H/2`, the maximum length is `H/R=w`.
Horizontal compression thus bounds the next support by

```text
conv{(0,q0),(w,q1),(0,q2)}.
```

At horizontal coordinate `h` in `[0,w]`, subtracting the two
affine endpoints of this tent gives vertical length
`R(1-h/w)`. Final vertical compression leaves
`0<=z<=R(1-h/w)`, equivalently
`h/w+z/R<=1`. This is the required `Delta(w,R)`.
The Lean file checks the endpoint subtraction and the real
inequality implication, not that these expressions are the
slices of constructed polygons or of actual compressed supports.
Those identifications are the geometric argument just given.

Every linear map, slice formula and area relation commutes with
every real dilation `kappa>0`. For `kappa=0`, the only possible
first-two-coordinate exponent is `(0,0)`. Nodal valuation,
both linear maps and every order-at-one operation fix the
constant row. Empty rows stay empty. In dimension two the
remaining label is empty, with the same argument.

### Restore labels, gradedness and mixed-order ranks

The operations preserve each row dimension, so summing over the
unchanged labels proves exact degreewise cardinality and restores
the full target simplex inequality. Each compression is the
valuation construction on row spaces with the same axis/order
in every degree. Product containment and additivity of orders
therefore prove gradedness for **every** `N,M>=1`.
This conclusion is not extrapolated from tested degree sums,
and it requires no graded component in degree zero.

For any one finite jet test in one degree there are finitely many
row bases. A common positive integral exposing weight exists
for their selected real-order least terms. The jet-transfer
unit proves backward domination through nodal replacement and
each compression, and exact rank invariance through the
unimodular maps. All label coordinates remain present in the
same truncated jet algebras. Composing the inequalities yields
the stated maximum-rank comparison for arbitrary finite
mixed orders and numbers of points. It gives the manuscript's
backward surjectivity implication as a special case.

This finishes the asserted universal mathematical argument:
real residual slices, all positive degrees, labels, sparse/empty
rows, and arbitrary characteristic have each been accounted for.
No maximality assertion or external unproved mathematical theorem
is used as an input.

## Reused evidence, version reconciliation and genuine limits

Historical supporting reviewer records are
`judgement-C_RS_COMPOSITION-750b486ff807`,
`judgement-C_RS_STRONG-006a79e9bc62`, and
`judgement-C_RS_MAIN-b9286b2bb7dc`. Their subjects match their
respective unchanged v1 statements and the same prose artifact.
They do not make an all-claims old proof graph closed:
that graph keeps all nodes open.

In particular, old `R_RS_FULL` pins the height obligation to
`C_RS_HEIGHT@v1`, whereas its certificate and mechanical evidence
bind v2, which adds the formal text to the identical natural
statement. The detailed hash reconciliation in the height unit
shows no v2/certificate mismatch, but it does show a stale
exact-version route reference. We do not mechanically transport
that certificate to v1 or repair any old ledger. The active
review route is rebound to the freshly formalized height version.
The mathematical height statement is the one proved above;
exact-version bookkeeping is a distinct issue.

The supplementary checker reproduced 60 rational geometry cases
and four small support families. It does not prove arbitrary
real geometry or unbounded gradedness. Its finite-field two-point
maxima do not certify geometric generic ranks. The fresh
Jacobian rank-two result certifies only a local linear matrix.
The Lean source formalizes the height lemma and auxiliary real
identities, not nodes, formal-series specialization, compression
of arbitrary row spaces or this entire theorem.

There is no identified mathematical gap in the theorem as
stated and proved in the old report, within these qualifications.
This is a supported **prose proof assessment**, not a claim
that the whole theorem is `closed_kernel`. Neither the positive-
characteristic, complex or surface maximality statements nor
the separate strict Nagata theorem has been established by
this argument. Their concrete missing obligations are in
`../downstream-boundaries/report.md`.

**Acceptance:** `pending_native_independent_review`.
