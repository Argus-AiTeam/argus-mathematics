# Private valuations over the enlarged coefficient field

## Result and scope

**Theorem.** Under the setup actually stated in Section 7 of the staged
unit-distance manuscript, Lemma `alg:private-valuations` and the subsequent
unused-sign-change obstruction hold. In particular, the valuations are
constructed on **`M = K_0(V_1)`**, not on a smaller function field.
They satisfy `v_l(D_l)=1` and `v_l(D_m)=0` for every `m != l`.
Both the rank-two and the common-line branches of the linear system are
inconsistent with `A-A'_l != 0` for every column.

This is a universal mathematical verification of this particular dependency,
not a finite search and not a proof of either main theorem. It does not certify
generic-grid extraction, the height argument, or the upstream pair graph.
No false assertion or admissible counterexample was found in the assertions
examined here. No novelty or publishable breakthrough is claimed.
Independent Reviewer assessment is still required.

The comparison point is the manuscript's own proof. The added verification
makes the constant-field quantifiers explicit, supplies a direct elementary
proof of the radical-field step, and gives exact symbolic and Lean checks of
the finite algebra. It does not strengthen the manuscript's distance bound.

## 1. Exact hypotheses

Work in an algebraically closed characteristic-zero ambient field `U`.
The field `B=B_0` contains the normalized equations of `V_1,V_2`.
Each locus is the plane or a geometrically irreducible plane curve, and every
curve has both coordinate projections nonconstant. The manuscript's
conjugate-coordinate symmetry interchanges the two projection degrees.
The anchors `r_l=(a_l,c_l)` are jointly generic on `V_2` over `B`: the selected
coordinates (both on a plane, the abscissa on a curve) are algebraically
independent, and the remaining coordinates are algebraic over them and `B`.
The left grid is jointly generic as stated in `alg:generic-grid`.
If both loci are the same curve `(z-u)(w-v)=b`, then `b != 1`.
Here `b=1` means exact equality of loci, not a limiting approximation.

Let `K=K_0` be the algebraic closure, inside `U`, of
`B(r_1,...,r_j,U_1,...,U_j,A'_1,...,A'_j)`.
In particular, `K` contains the anchor coordinates and the stated derivative
data, is algebraically closed, and is **not** asserted to contain `k_0`.
Use the surviving point `p`, whose transcendence degree over `K` is
`dim V_1`. Evaluation therefore embeds `K(V_1)` into `U` with image `K(p)`.
The field throughout the proof below is this `M=K(V_1)=K(p)`.

The geometric proof in fact works for any algebraically closed intermediate
field `B(r_1,...,r_j) <= K <= U`; identifying it with the field of the
actual surviving point additionally requires that point to remain generic.
No restriction on the dependence of the derivative data on the left grid
is imposed or used. The existing dimension count, `20 > 3*5`, is the
manuscript's reason such a surviving point is available; that upstream
selection is a hypothesis of this scoped verification.

Put `L_l=(z-a_l)(w-c_l)` and `D_l=L_l(L_l-4)`.

### Genericity facts used below

For `m != l`, a point algebraic over `B(a_l)` does not consume any of the
transcendence degree of `r_m`: adjoining algebraic elements to `B(a_l)`
does not change that degree. Thus `r_m` remains generic over that field.
For a geometrically irreducible curve, a polynomial vanishing at a generic
point is zero on the curve: otherwise the function-field embedding would
send a nonzero element to zero. On the plane this is algebraic independence.
These statements are applied **before** adjoining the derivative data.
Once a concrete element of `U` has been shown nonzero, a larger subfield of
`U` cannot turn it into zero.

The polynomial-ring fact implicit here has an elementary justification.
An irreducible curve equation of positive `w`-degree is primitive over
the Euclidean ring `K[z]`. A product of primitive polynomials is primitive:
reduce modulo any irreducible polynomial of `K[z]`, where the resulting
coefficient ring is a field and a product of nonzero polynomials is nonzero.
Clearing denominators in a putative factorization over `K(z)[w]` and
cancelling coefficient contents would therefore give a factorization over
`K[z,w]`. Thus irreducibility persists over `K(z)`.
The same argument applies after each of the intermediate field extensions,
since the curve equation is absolutely irreducible.

## 2. All private-valuation cases

### 2.1 Left plane

Regard `M` as `K(z)(w)`. In the polynomial ring in the single variable `w`
over the field `K(z)`, use the linear prime

`q_l = w-c_l-4/(z-a_l)`.

Its order defines an integer-valued valuation, trivial on `K(z)^*`.
This is the same valuation as the exponent of the manuscript's
`Q_l=(z-a_l)(w-c_l)-4`; the factor `z-a_l` is a unit in `K(z)`.
The polynomial `Q_l` is also irreducible in `K[z,w]`: its coefficients
in `w` are relatively prime, and it is linear over `K(z)`.

At `w=c_l+4/(z-a_l)`, `L_l=4`, and `L_l-4=(z-a_l)q_l`.
Consequently `v_l(D_l)=1`. No `L_m` vanishes identically under this
substitution: neither `z-a_m` nor `c_l-c_m+4/(z-a_l)` is zero in `K(z)`.
Moreover,

`(z-a_l) Q_m(z,c_l+4/(z-a_l))`
`= (c_l-c_m)(z-a_m)(z-a_l)+4(a_l-a_m)`.

If `c_l != c_m`, its leading coefficient is nonzero. If `c_l=c_m`,
distinctness of the centers gives `a_l != a_m` and the displayed
constant is nonzero. Hence `v_l(D_m)=0`.
This proof takes place over `K` and requires only distinct centers.

### 2.2 Left curve: different loci, or the same curve of projection degree at least two

Write the irreducible equation as `f(z,w)` and take `a=a_l`.
This abscissa is transcendental over `B`. Its leading coefficient in
`w` is nonzero. The polynomial `f` is separable in `w` over `B(z)`:
in characteristic zero its positive-degree irreducible polynomial has
coprime derivative. A Bezout identity, with denominators cleared, gives
`u f+v f_w=h(z)` for some nonzero `h in B[z]`.
Since `h(a) != 0`, every root of `f(a,w)` is simple.

If `V_2 != V_1`, the generic anchor `r_l` is not on `V_1`.
Choose any root `b` of `f(a,w)`; then `b != c_l`.
If `V_2=V_1` and `deg_w f >= 2`, choose a different root from `c_l`;
separability guarantees one. In either case

`s_l=(a,b)`, `f_w(a,b) != 0`, `b-c_l != 0`,

and `b` is algebraic over `B(a)` and belongs to `K`.

For `m != l`, genericity over `B(s_l)` rules out `a_m=a` and `c_m=b`,
because both projections on a curve are nonconstant (and the plane case
is immediate). Hence `L_m(s_l) != 0`.
If `L_m(s_l)=4`, generic evaluation in the anchor variables forces
`V_2` to lie in `(Z-a)(W-b)=4`. This cannot contain the plane.
For a curve it forces equality of irreducible curves. Normalizing the
coefficient of `ZW` to one then recovers `-a` as the coefficient of `W`
in the equation of `V_2`, whose normalized coefficients belong to `B`.
This would give `a in B`, a contradiction.
Absolute irreducibility ensures this comparison is valid even after
the algebraic sheet ordinate `b` has been adjoined.

Now work over `K`, not over `B`. Recursively solve

`f(a+T,b+c_1 T+c_2 T^2+...) = 0` in `K[[T]]`.

The coefficient of each new `c_n` is the nonzero scalar `f_w(a,b)`,
so induction gives a unique formal solution `w(T)`.
The resulting homomorphism `K[z,w]/(f) -> K[[T]]` is injective:
`z=a+T` is transcendental over `K`, and irreducibility of `f` over
`K(z)` says that the minimal polynomial of `w(T)` over `K(z)` is `f`.
It extends to an embedding `M -> K((T))`.
Order in `T` is therefore an integer-valued valuation of `M`.

Here `L_l=T(b-c_l+O(T))`, so `L_l` has order one and `L_l-4`
has order zero. Every other `D_m` has nonzero constant term by the
previous paragraph. This gives exactly the desired valuations.
The simple formal root and the embedding, not merely a smooth numerical
sample, are the reason this covers every curve in this branch.

### 2.3 Both loci are the same line

The remaining case has `deg_w f=1`. The symmetry gives `deg_z f=1`.
Writing `f=Az w+Cz+Dw+E` proves the classification directly.
If `A=0`, both `C,D` are nonzero and the curve has the form
`w=e z+e'`, with `e != 0`, all constants in `B`.
Then `L_l=e(z-a_l)^2`.

Choose `c in K` with `c^2=4/e`. It is nonzero and algebraic over `B`.
At `z=a_l+c`, `L_l=4`, and `(L_l-4)'=2ec != 0`.
The point `s_l` is algebraic over `B(a_l)`.
For an independent anchor `a_m`, either equation
`e(z_s-a_m)^2=0` or `e(z_s-a_m)^2=4` is a nonzero polynomial
equation over an algebraic extension of `B(a_l)`, contrary to
transcendence. Thus order at `z=a_l+c` in `M=K(z)` is private.

### 2.4 Both loci are the same fractional-linear curve

If `A != 0`, completing the product gives
`(z-u)(w-v)=b`, with `b != 0` by irreducibility.
The exact common-unit-circle exclusion is precisely `b != 1`.
For `A_l=a_l-u != 0` and `z=u+A_l*zeta`, direct substitution gives

`L_l=-b(zeta-1)^2/zeta`,

`L_l-4=-g(zeta)/zeta`,
`g(X)=bX^2+(4-2b)X+b`.

The discriminant is `16(1-b) != 0`. Its roots `rho` belong to `K`,
are algebraic over `B`, and are nonzero since `b != 0`.
Also `g(1)=4`, so `rho != 1`. Choose either root.
It is a simple root, and the corresponding finite abscissa
`z_s=u+(a_l-u)rho` is different from `u`.
Thus order at `z=z_s` gives `v_l(D_l)=1`, with `L_l(z_s)=4`.

For a different anchor abscissa `a_m`,

`L_m(s_l)=-b(z_s-a_m)^2/((z_s-u)(a_m-u))`.

As a rational function of the variable `a_m`, this is nonconstant:
the numerator has degree two with nonzero leading coefficient `-b`,
and its denominator has degree one. There is no cancellation at `a_m=u`,
since `b(z_s-u) != 0`. Both equations `L_m(s_l)=0,4` therefore give
nonzero polynomial equations over `B(s_l)`.
The independent transcendental `a_m` satisfies neither.
Hence this valuation is private too.

These four branches exhaust the manuscript's loci. In every branch
the constructions occur in `K(V_1)` itself. The algebraic closure of
the coefficient field provides the sheet ordinate and roots; it does
not erase their simple orders.

## 3. Square classes and actual radical fields

For a nonempty finite set `I`, select `l in I`. Multiplicativity gives

`v_l(product_{m in I} D_m)=1`.

The valuation of a square is even. Thus no such product is a square
in `M`, and all radicands are nonzero. This argument proves independence
over the **enlarged** field. Independence over a smaller field would
not suffice: for example, the constant `t` is a nonsquare in
`Q(t)(z)` but becomes a square after extending its constants to an
algebraic closure of `Q(t)`. That smaller-field route is retired.

For completeness, here is an elementary proof of the quadratic Kummer
step, so no unverified literature theorem is needed as an assumption.
Induct on `n`. Suppose `E_n=M(R_1,...,R_n)` has the `2^n` monomial
basis `R_S` and all individual sign changes. If `x in E_n` satisfies
`x^2=D_{n+1}`, every sign change sends `x` to `x` or `-x`.
Expand `x` in the monomial basis. Distinct basis monomials have distinct
sign characters, so an element which is an eigenvector for every sign
change has only one nonzero monomial coefficient. Thus `x=c R_S`
for `c in M`, contradicting the square-class independence already proved.
Therefore `X^2-D_{n+1}` is irreducible over `E_n`.
Adjoining its root doubles the degree, supplies the enlarged monomial
basis, and extends each old sign change by fixing the new root;
negating the new root supplies the additional sign change.
The initial case `E_0=M` is immediate.

Consequently `[M(R_1,...,R_j):M]=2^j`, with every sign choice realized.
In particular the single radicals are linearly independent over `M`:
applying the flip of `R_l` to a linear relation and subtracting isolates
twice its `l`-th coefficient times the nonzero `R_l`.

**Source check.** The manuscript cites J. S. Milne, *Fields and Galois
Theory*, version 5.10, September 2022, Theorem 5.30 and Remark 5.32.
The primary PDF was obtained from
<https://www.jmilne.org/math/CourseNotes/FT.pdf>, and its title page
has that exact version. The cited Kummer theorem assumes a primitive
`n`-th root of unity and characteristic prime to `n`; its degree
formula and Remark 5.32 give the stated quadratic conclusion.
Section 3 above proves the needed specialization independently.
The source is corroboration, not an external assumption of our theorem.

## 4. The unused sign change, including the line case

All coefficients `p-r_l`, `U_l`, and `A'_l` lie in `M`, and
the system is

`2(p-r_l).H-R_l A = 2(p-r_l).U_l-R_l A'_l`.             (1)

Ordinary coordinates are recovered from `z,w` by
`x=(z+w)/2`, `y=(z-w)/(2i)`; since `i in B`, this is an invertible
`K`-linear coordinate change and does not change any rank condition.
The unknowns initially lie in `U`; one must not apply a radical-field
automorphism to them before placing them in that field.

### Rank two

Let `a_l=2(p-r_l)_x`, `b_l=2(p-r_l)_y` for the first three rows.
The determinant of their coefficient matrix `[a_l,b_l,-R_l]` is
minus

`Delta = (a_2 b_3-a_3 b_2)R_1`
`      + (a_3 b_1-a_1 b_3)R_2`
`      + (a_1 b_2-a_2 b_1)R_3`.

Rank two of the position rows means at least one of these coefficients
is nonzero. Single-radical independence over `M` gives `Delta != 0`.
Cramer's rule, in the field `M(R_1,R_2,R_3)`, puts the actual unique
solution `H_x,H_y,A` in that subfield, since its right-hand sides
also lie there. This is valid even if the original solution was
initially specified in the larger ambient field.
Explicitly, multiplication by the adjugate expresses each unknown as
a cofactor combination of the right-hand sides divided by the nonzero
determinant. The identities hold in the ambient field as well as the
subfield, so this is a field-membership argument, not an assumed
automorphism action on the ambient solution.

The automorphism of `E=M(R_1,...,R_j)` flipping only `R_4`
fixes that subfield and hence these unknowns. Apply it to row 4 of
(1) and subtract the original row. It gives
`2 R_4(A-A'_4)=0`. Characteristic zero and `R_4 != 0` imply
`A=A'_4`, contrary to the specified nonzero derivative.

### Why the rank alternatives are exhaustive

If `V_2` is the plane or a curve other than a line, three independent
generic anchors are noncollinear. The line through the first two is
defined over their coordinate field; a generic third anchor on it
would force its whole locus into that line. If `V_2` is a line,
the first two anchors are distinct, and the position rows have rank
two unless `p` belongs to that line. Since `p` is generic on `V_1`
over `K`, this requires `V_1=V_2` to be that same line.

### Common line

Choose a direction `v in K^2`, and write `p-r_l=s_l v`.
The factors `s_l in M` are nonzero: a generic `p` over `K`
cannot equal an anchor in `K^2`. Put `h=v.H`. The first two
rows in the two unknowns `h,A` have determinant
`2(s_2 R_1-s_1 R_2)`, which is nonzero by single-radical
independence and `s_1,s_2 != 0`. Cramer's rule puts `h,A` in
`M(R_1,R_2)`. The flip of `R_3` then gives
`2 R_3(A-A'_3)=0`, again impossible.
No automorphism of `F` or of `U`, and no compatibility with the
original derivation, has been used.

Thus `j>=4` suffices in rank two and `j>=3` on the common line.
The manuscript has `j=5`.

## 5. Exact computation and formal boundary

`verify.py` checks the supplied certificate using exact symbolic
identities, not floating-point samples. It covers the plane-prime
restriction, the local order-one normal form for the smooth-sheet branch,
both bidegree-one normal forms, the fractional discriminant, the
unit-circle boundary, determinant/elimination identities for both ranks,
and private-valuation parity. Its rejection tests deliberately violate
distinctness, smoothness, nonconstant projection, or `b != 0,1`;
those rejected inputs are **not** counterexamples to the manuscript.
The symbolic sheet calculation checks the universal local algebra
after `f_w != 0`; the proof in Section 2.2 supplies that hypothesis
and the formal-series embedding for arbitrary-degree curves.

`Main.lean` formalizes the finite algebra named in
`statement_fidelity.md`. In particular, parity of the private
orders and the unused-sign linear-system implication are distinct
formal statements. The existence of the geometric valuations,
joint genericity, the surviving-point argument, and realization of
the sign automorphisms in the actual field are proved in prose here,
not asserted to have been formalized. The Lean sign theorem takes
those automorphisms as explicit hypotheses.

The Jacobian adapter's exact translated-plane factorization is in
`jacobian_output.json`, with the exact input in `jacobian_payload.json`.
Its protocol, server version, operation, typed success status and
runtime are preserved there. That operation only supports `QQ`
polynomials: its successful output is a corroborating algebraic check,
not a certificate for arbitrary constant-field enlargement.

The completed exact replay returned 25 symbolic identities, all five
locus-case local-order pairs `[1,0]`, all 31 nonempty products for the
actual `j=5`, and ten rejected invalid-hypothesis tests; see
`verify_output.json`. The real Lean 4.31.0 compilation and axiom audit
returned `exit_code=0`, `audit_exit_code=0`, and `proof_holes=[]`;
see `lean_check.json` and the archived claim certificate
`certificates/C167_PV_CORE-f2c4cd187d435ec7.json`.
Only `C167_PV_CORE`, not the whole geometric theorem, earned
`closed_kernel`. Its statement-fidelity review is still independent work.

Reproduce the two distinct checks from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/private-valuations/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify --project-root . --claim C167_PV_CORE --statement-fidelity research/private-valuations/statement_fidelity.md research/private-valuations/Main.lean
```

The installed official interface takes the Lean source as a positional
argument, rather than the unsupported `--source` spelling.
