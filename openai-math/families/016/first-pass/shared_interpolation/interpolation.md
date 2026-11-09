# Common-relation interpolation: mathematical scope

The target is the implication in Elliptic-Squares `int:height`, including
the full proof in `09-interpolation-proof.tex`, and Quaternionic-Division-Points
`thm:interpolation`, including its full proof in `02-interpolation.tex`.
The fixed data include ordinary connection germs, bounded polynomial
combination degree, and fixed ambient dimension. The variable algebraic target
has a nonzero parameter `a`, global height polynomial in `d` times `h`,
selected negative logarithms of `a` at least `h/poly(d)`, and selected positive
coordinate logarithms, coefficient heights, and tail errors bounded by
polynomials in `d` and `1+log(h)`. Nonidentity is required on every relevant
normalization branch of every irreducible algebraic subvariety through the
target, not just on the original ambient variety. The claimed conclusion is
`h <= C d^C`, uniformly without a coefficient-field-degree bound.

The shared mathematical obligations are:

- a height-independent ordinary-point multiplicity bound on varying branches;
- exclusion of generic boundary divisors from the graph of `f/a^m`;
- interpolation in the actual, possibly nonradical ideal, not its radical;
- polynomial degree and coefficient-height bounds through the construction;
- product-formula evaluation followed by controlled dimension descent.

No obligation or application is marked proved at scope.

## Application dependency impact

The abelian manuscript's `thm:main` uses `prop:optimal-finite` and
`lem:maximal-optimal`; the former uses `thm:nondensity` and the cited
Barroero-Dill reduction. No dependency of that independent manuscript on the
two interpolation theorems has been established here.

The E-times-CM manuscript's `thm:main` uses its mixed-point `thm:orbits`,
conditional Daw-Orr finiteness, and Andre-Oort for special points. Its
height/period/gluing chain is separate from the shared interpolation lemma.

The quaternionic manuscript's `thm:height` uses common analytic relations,
universal branch nonidentity, and `thm:interpolation`. Its `thm:main` additionally
uses `prop:counting-finiteness`.

The elliptic-square manuscript's `intro:squares` uses its local input
`loc:groups`, branch assertion `nid:nonidentity`, height bound `nid:height`
and counting argument. Its full `intro:zp` also uses the E-times-CM and
quaternionic companion conclusions, special-curve classification, and
Andre-Oort. Settling the common mechanism alone therefore does not settle
any application hypothesis or any of the four full main theorems.

## Source facts and excluded attacks

The live scope supplies two previously source-checked facts to retain:
Gaudron-Remond Theorem 1.2 includes the numerator `(deg_L A)^(1/g)` in
the averaged inverse-square essential-period estimate, and its constant
depends only on dimension. An allegedly missing degree numerator is not an
available refutation.

Daw-Orr supply a finiteness implication conditional on large Galois orbits,
not an unrestricted height bound. The primary PDF arXiv:1902.10483v4,
pp. 2-3, confirms that the conditional result is Theorem 1.2 and the
orbit conjecture is Conjecture 1.3. The live task's reference to a
conditional "Theorem 1.3" is not the numbering of this version. This
observation is not attributed to the staged manuscripts.

Primary period source: Gaudron-Remond, *Theoreme des periodes et degres
minimaux d'isogenies*, Comment. Math. Helv. 89 (2014), 343-403,
doi:10.4171/CMH/322, Theorem 1.2. Primary conditional-finiteness source:
Daw-Orr, *Unlikely intersections with E x CM curves in A_2*,
arXiv:1902.10483v4. The downloaded arXiv:1105.1230v1 PDF, p. 3, independently confirms the
period numerator and the dimension-only constant `50 g^(2g+6)`. Its
exact version, rather than the published DOI, is the source of the
local extracted passage.

The inherited Wiki index has no campaign-specific interpolation or
Gaudron-Remond/Daw-Orr topic entry. Broad occurrences of interpolation in
unrelated campaigns are not evidence about this mechanism.

## Uniform verification and extension

The following theorem includes the two source statements and permits
logarithmic singular centers and several polynomial argument maps.
It is a mathematical theorem with a proof below. The Lean certificate
checks the coefficient/residue and strict dimension-count cores; it
does not check the whole geometry or the height argument.

### Theorem U (holomorphic logarithmic-connection interpolation)

Fix an affine dimension `N`, a number of equations, a polynomial-combination
degree bound `b`, and a finite list of algebraic curves with nonconstant
algebraic parameters and specified local analytic chart germs at parameter
zero. Fix algebraic connections on these curves, in algebraic frames
regular and invertible at the specified centers. The connection matrices
may have logarithmic poles at these centers. Fix finitely many horizontal
vector germs that are **holomorphic** at those centers, as well as finitely
many regular algebraic germs. Ordinary horizontal matrix germs and their
inverse/dual entries are included as a special case.

Fix finitely many polynomial maps

`phi_i(a,U) = a P_i(a,U)`.

The maps and their degrees are fixed. Allowed expressions are bounded-degree
polynomial combinations of `(a,U)`, the regular algebraic germs, and the
chosen holomorphic horizontal germs evaluated at these maps. Their scalar
algebraic coefficients may vary with the target. Require that their
expansions have polynomial coefficients in `U`, as in the source statements.

Let `Psi(h)=(1+log h)^c`, where `c` is fixed. For `h,d>=2`, let
`z=(a,U)` be algebraic with `a!=0`, in an algebraic locus `X`. Suppose:

1. `X` has support equations of degree and number at most `Q_0(d)` and
   joint affine coefficient height at most `Q_0(d) Psi(h)`, and
   `h_aff(z)<=Q_0(d)h`.
2. There is a finite weighted selection `V`, using normalized absolute
   values and with weights preserved under field extension, such that
   `|a|_v<1`,
   `S=sum_V w_v log |a|_v^(-1)>=h/Q_1(d)`, and
   `sum_V w_v log max(1,||U||_v)<=Q_2(d) Psi(h)`.
3. Common allowed equations
   `E_nu=sum_(j>=0) a^j e_(nu,j)(U)` vanish at every selected datum.
   They satisfy `deg e_(nu,j)<=C(1+j)` and
   `h_aff((e_(nu,j))_(nu,j<=l))<=Q_3(l,d) Psi(h)`.
   Their convergent tails satisfy
   `|sum_(j>=l) a^j e_(nu,j)(U)|_v
      <= |a|_v^l exp((l+1)b_v)` for all `l`,
   where `b_v>=0` and `sum_V w_v b_v<=Q_4(d) Psi(h)`.
4. On every normalization branch above every generic boundary component
   `a=0` of every irreducible algebraic `W subset X` through `z` on
   which `a` varies, not all the specified analytic germs `E_nu` are
   identities.

Here the `Q_i` are fixed polynomials with nonnegative coefficients and
all other constants and data specified as fixed are fixed before the
target is chosen. The denominators in the displayed hypotheses are
positive; bounding polynomials can be enlarged to be at least one.
Then `h<=C_1 d^C_2`.

No field-degree bound, G-function size bound, regularity of `W`,
radicality of its chosen support ideal, or non-zero-divisor hypothesis
on its special fiber is required.

### 1. Effective algebra and absolute heights

In a fixed number of variables, the following operations have polynomial
degree bounds and coefficient-height bounds polynomial in the input
degrees times `1+H`, where `H` is joint logarithmic affine coefficient
height: obtaining a degree-compatible Groebner basis with representations
in the original generators; actual-ideal membership; saturation and
coordinate elimination; and support equations for an irreducible component
of an intersection or a projected variety.

For the first two degree bounds use Dube's fixed-variable degree estimate
and Hermann's theorem as stated by Aschenbrenner, Theorem 3.4. The latter
applies over **any field** and to actual membership, not merely radical
membership. Recover a reduced leading-monomial basis and its generator
representations by coefficient comparison, with the bounded-degree
representations as extra unknowns. Each resulting affine linear system
has polynomial size and entries among input coefficients and `0,+1,-1`.
Solvable affine systems have solutions obtained by a nonzero pivot minor;
homogeneous systems have normalized kernel bases obtained by minors.

At a place `v`, an `s` by `s` determinant is at most the `s`th power
of the largest entry, times `s!` only at an infinite place. Summing with
normalized weights bounds its logarithmic height by `s H+log(s!)`.
The inverse of a nonzero pivot has the same absolute logarithmic height
as the pivot, by the product formula. Thus the height bounds are linear
in `H`, with polynomial degree factors and no field-degree loss.

For components and projections use KPS, Corollary 2.11, Lemma 2.6, and
Section 1.2.4 in the published author PDF `maino.pdf`. These statements
give the required height control for affine intersection and closure of
projection, with nonnegative additive cycle height. Normalize a Chow
coefficient to one. Its affine coefficient height is its projective
coefficient height. If a projective variety has dimension `r` and Chow
form `C`, substitute the `r+1` hyperplanes
`sum_j T_ij (X_j-x_j X_0)=0`. Their coefficient equations in the `T_ij`
have degree at most `(r+1)deg(W)` and bounded height. They define exactly
the affine support: outside the variety these hyperplanes are a
base-point-free system, and `r+1` general members have empty common
intersection. We never need generators of the radical ideal.

The arXiv:math/9911094v1 numbering differs: its projection lemma is
2.5 and its 2.6 is about injective affine maps. The published author
version cited by the manuscript has the projection bound at 2.6.
The apparent preprint-locator attack is therefore excluded, not a
manuscript error.

### 2. Exact logarithmic local order estimate

Here is the additional local result, including the ordinary case.
Let `T` be a smooth projective complex algebraic curve, `p` a point,
and `t` a rational uniformizer at `p`. Write a logarithmic horizontal
equation as `delta y=A y`, `delta=d/dt`, with `y` holomorphic at `p`.
Let `f=r_0 y` be nonzero, and form

`r_(i+1)=delta r_i+r_i A`.

Let `rho>=1` be the dimension of their function-field span, and assume
a common pole divisor of degree at most `P` bounds every entry of
`r_0,...,r_(rho-1)`. Let `Lambda>=0` bound the absolute values of the
eigenvalues of the horizontal residue matrix `(t A)|_(t=0)`. Then

`ord_p(f) <= (2 rho-1)P + Lambda + rho-1`.                 (Z)

Here and below "residue" means the constant matrix in the horizontal
Euler equation `t y'=B(t)y`. It is the negative of the conventional
residue of the connection `nabla=d-A dt`; absolute spectral bounds
are unchanged by that sign.

To prove this, the span stabilizes at the first linear dependence and
is stable under the dual connection. Saturate its common kernel in
the regular local lattice. This kernel is stable under `t nabla`:
generic stability and the logarithmic pole imply that `t nabla`
of an integral section is integral. The quotient lattice is free and
has a logarithmic connection. Its residue is a quotient of the
original residue, so its eigenvalues are among the original ones.

The image `bar y` is a nonzero holomorphic horizontal section. In
a local quotient frame write `bar y=t^ell(v_0+O(t))` with `v_0!=0`.
The coefficient of `t^ell` in its Euler equation gives
`ell v_0=bar B(0) v_0`. Hence `ell<=Lambda`.
This coefficient argument, for all ranks and all orders, is formalized
in `horizontal_leading_eigenpair` and `horizontal_order_bound`.
For an ordinary connection the residue is zero and `ell=0`.

Choose an integral quotient functional `lambda` for which
`ord_p(lambda y)=ell`. It lies in the saturated row lattice.
Choose a nonzero `rho` by `rho` minor `Delta` of the derivative-row
matrix. Cramer's rule gives

`Delta lambda = sum_(i<rho) c_i r_i`,

where `ord_p(c_i)>=-(rho-1)P`. Also
`ord_p(Delta)<=rho P`, because a nonzero rational function has equal
total zero and pole degrees. Evaluating at `y` shows that some `i<rho`
satisfies

`ord_p(delta^i f) <= ord_p(Delta)+ell+(rho-1)P
                   <= (2rho-1)P+Lambda`.

Otherwise every summand would have order greater than the order of
the nonzero left side, which is impossible. Finally
`ord_p(delta^i f)>=ord_p(f)-i`, proving (Z). This proof allows poles
in the derivative rows and does not assume a controlled global frame
for the quotient.

The residue term is necessary: in rank one, `y=t^m`,
`A=m/t`, and `r_0=1` give `rho=1`, `P=0`, `Lambda=m`, and equality
`ord_p(f)=m` for every nonnegative integer `m`. This is a sharpness
example for (Z), not a counterexample to the manuscripts' ordinary-center
statements.

### 3. Uniformity on varying algebraic branches

Let `W` have degree `D`. At a general point of any normalized divisor
above `a=0`, take a transverse linear section of the original affine
variety. It has degree at most `D`. The normalization map on the divisor
is generically separable, so suitable pullbacks of `dim(W)-1` general
linear forms are independent along the divisor and cut a transverse
smooth germ. A sufficiently long finite algebraic truncation of a
nonzero expression has its first nonzero branch coefficient. Avoiding
the zero set of this coefficient makes the slice preserve both its
order and the order of `a`. This uses no height bound for the slice.

The sliced curve has genus polynomial in `D` and every original
coordinate has polar degree at most `D`. Each `phi_i` therefore has
polar degree at most `deg(phi_i)D`. Adjoin the fixed algebraic chart
coordinates by normalized fiber products. The covering degree is
bounded by the product of the fixed parameter-map degrees, and the
number of branch points is `O(D)`. Riemann-Hurwitz bounds the genus
of the resulting curve polynomially in `D`; all pulled-back fixed
divisors have polynomial degree. Constant argument maps contribute
constant factors and require no cover.

Tensor products and direct sums encode the bounded-degree expressions
as `f=r_0 y` for a fixed-rank connection. At the tested point a
nonconstant argument has vanishing order at most a fixed multiple of
`D`, since this order is at most its total polar degree. A pulled-back
logarithmic residue is the corresponding positive integral ramification
multiple of its fixed residue. Tensor-product residues are sums of
these operators on separate tensor factors; their eigenvalues are sums
of the corresponding fixed eigenvalues, with these multiplicities.
Consequently their absolute values are bounded polynomially in `D`.
This is the bound `Lambda` in (Z).

Choose a rational uniformizer on the smooth curve with polar degree
at most `2g+1`, by Riemann-Roch (a degree-one parameter suffices for
genus zero). The poles of `delta=d/dt` have total degree at most
`2g-2+2deg(t)`. Differentiation adds at most the reduced pole divisor
of a function and the pole divisor of this vector field. Thus, for
the fixed number of derivative rows needed, a common pole divisor
has degree polynomial in `D`. Applying (Z) bounds
`ord(E)/ord(a)` polynomially in `D`, independently of the heights
of the coefficients of `W` and of the scalar combination.

There are at most `D` normalized generic boundary divisors: on the
normalization of the projective closure their positive contributions
to the hyperplane-section degree sum to `D`. Choose
`E=sum_nu T^(nu-1) E_nu` with a positive integer `T`. Each branch
forbids at most `s-1` choices of `T` by cancellation of its least-order
coefficient. One of the first `1+D(s-1)` choices is permissible.
Choose a polynomially bounded integer `m` strictly larger than all
the resulting order ratios. Then the truncation

`f=E_<m`

satisfies `ord_D f < m ord_D a` on every normalized boundary divisor:
the omitted tail has order at least `m ord_D a`. Integer coefficients
add no finite-place loss and only a polynomially bounded infinite-place
triangle-inequality error to the weighted tail bounds.

### 4. The constrained graph boundary

Put `u=f/a^m` and take the graph closure `W'`, with coordinate `q`.
It is irreducible of dimension `k=dim(W)` and is isomorphic to `W`
over `a!=0`. On every normalized generic boundary divisor `u` has
a pole. After adjoining the finite normalization to the graph,
an alleged point over that divisor would have a unit equal to
`pi^j q` with `j>0` and `pi` in the maximal ideal. This is impossible.
The projection of the graph boundary therefore misses a dense open
subset of each boundary component, and its closure has dimension
at most `k-2`.

For every regular `g` on `W`, imposing `q=-g` makes projection a
closed immersion. Consequently

`dim V(I(W'),a,q+g) <= k-2`,

with emptiness for `k=1`. This statement concerns the constrained
boundary; the unconstrained graph boundary need not have this dimension.
The argument applies equally to any ideal having support `W'`.

### 5. Actual-ideal interpolation, uniformly in the parameters

Let `I=(G_lambda)` be a controlled, possibly nonradical support ideal
of `W'`, and put

`F_0=q+e_m(U)`,
`F_n=F_0+sum_(1<=j<n) a^j e_(m+j)(U)`,
`J=(I,a,F_0)`.

A degree-compatible Groebner division for `J`, with fixed generator
representations, gives a linear identity

`H=NF_J(H)+sum G_lambda C_lambda(H)+a C(H)+F_0 D(H)`.

For input degree `T`, every coefficient polynomial has degree at most
`T+Delta`, with `Delta` polynomial in the fixed-dimensional input degree
bound. Start with a general degree-`L` polynomial in `k` algebraically
independent ambient coordinates on `W'`. In layer `i` impose zero
remainder and replace

`a^i F_0 D = a^i F_n D - sum_(1<=j<n) a^(i+j)e_(m+j)D`.

The term from `a C` advances one layer; every other new residual
advances at least one layer. Choose an integer `B` with
`Delta+C(1+m+j)<=Bj` for every `j>=1`. The residual in layer `i`
then has degree at most `L+Bi`. Terms advanced beyond layer `n-1`
are recorded as multiples of `a^n`.

If `J` is the unit ideal there are no conditions. Otherwise let
`t=dim V(J)<=k-2`. If its initial monomial ideal is generated in
degree at most `G`, a standard monomial has at most `t` exponents
at least `G`: otherwise the coordinate subspace in those variables
would lie in that monomial zero set and have dimension greater than
`t`. There are at most `2^M G^M(1+T)^t` standard monomials of
degree at most `T`. This argument counts nilpotents as well.

Thus at most `B' n(1+L+Bn+B)^(k-2)` linear equations are imposed.
The source has dimension `binom(L+k,k)>=L^k/k!` and intersects
`I(W')` only at zero. For `n=rL`, choose

`L > k! B' r (2+Br+B)^(k-2)`.

The number of conditions is strictly less than the source dimension.
This strict inequality for all natural parameters and all `k>=2`
is the declaration `layer_count_uniform` (whose parameter `k` is
the geometric dimension minus two). A nonzero kernel vector gives
a polynomial `P`, of degree at most `L`, nonzero on `W'`, with
an identity in the **actual ideal**

`P=sum A_lambda G_lambda+A F_n+a^n B_0`.                 (I)

The tracked residual degrees give a polynomial certificate-degree
bound. For height control solve the coefficient equations for (I)
directly, restricting `P` to the chosen independent monomials.
A minors kernel basis has polynomial height times `1+H`; at least
one vector has nonzero `P` part. This proves the height bound without
assuming any canonical remainder map on the reduced coordinate ring,
and without bounding an intermediate quotient frame.

When `k=1`, the constrained boundary is empty and `J=(1)`, so the
same construction has no remainder conditions. All choices of `L,n`
are polynomial in the initial degree bound and the prescribed `r`.

### 6. Product formula and finite descent

Maintain an irreducible `W subset X` through `z`, of polynomial degree
and support-equation height at most `Q(d)Psi(h)`. Component selection
in Section 1 gives this initially. If `W` misses `a=0`, its support
ideal together with `a` is the unit ideal, with a controlled identity
`1=sum A_lambda G_lambda+a B`. At `z`, `1=a B(z)`.
Evaluating on the selected data costs only coefficient heights and
positive logarithms of `U`. It gives `h/Q_1(d)<=Q(d)Psi(h)`.
This includes constant nonzero `a` and dimension zero.

Otherwise use Sections 3-4 to form the graph. The lifted target
`z'=(z,f(z)/a^m)` has global height

`h_aff(z')<=Q_5(d)h+Q_6(d)Psi(h)`.

The coefficient `Q_5` is fixed before `r,L,n` are chosen. Locally,
the exact relation `E(z)=0` and the tail bound instead give

`|q(z')|_v<=exp((m+1)b_v)`,
`|F_n(z')|_v<=|a|_v^n exp((m+n+1)b_v)`.

Therefore the positive selected logarithms of the lifted coordinates
are still at most `Q_7(d)Psi(h)`.

In (I), the terms `G_lambda(z')` vanish. If `P(z')!=0`, evaluating
the identity at selected places gives

`sum_V w_v log|P(z')|_v <= -n S+Q(d,n,L)Psi(h)`.

Every large certificate degree multiplies only small positive selected
logarithms. Finite-place sums use the ultrametric inequality; the
infinite-place triangle factors have total weight at most one.
At all other places evaluate `P` itself, not its certificate:

`sum_(v notin V) w_v log|P(z')|_v
 <= L Q_5(d)h+Q'(d,n,L)Psi(h)`.

Choose an integer `r>2Q_1(d)(Q_5(d)+1)+1`, then the polynomially
large `L` in Section 5, then `n=rL`. The product formula implies

`0<=(-n/Q_1(d)+LQ_5(d))h+Q''(d,n,L)Psi(h)
  <=-Lh+Q''(d,n,L)Psi(h)`.

All parameters are now polynomial in `d` and independent of `h`.
Since `(1+log h)^c<=C_c sqrt(h)` for `h>=2`, this inequality bounds
`h` polynomially in `d`.

If the bound fails, `P(z')=0`. Clear denominators in
`a^(mL) P(a,U,f/a^m)` to obtain a controlled polynomial nonzero
on `W` and zero at `z`. A component of this proper intersection
through `z` has smaller dimension and preserves the degree and
height controls of Section 1. Discard `q` before repeating. The
universal branch hypothesis applies to this new `W` because it is
an algebraic subvariety through the same target, even though its
equations depend on the constructed coefficients.

There are at most `N` drops, so polynomial composition and a maximum
over this fixed number of thresholds remain polynomial. All field
extensions extend every selected embedding in all possible ways;
the normalized sums are unchanged. This proves Theorem U.

### 7. Exact coverage of the source mechanism

For quaternionic `thm:interpolation`, take only ordinary centers and
the arguments `a` and `aR`; its extra local condition `|R|_v=1`
is retained and is not needed once the stated coefficient and tail
bounds are assumed. Its `1+(log h)^c` is bounded above and below by
fixed multiples of our `Psi(h)`. Its initial ambient support and
height bounds are exactly those of Theorem U.

For elliptic `int:height`, take `X=A^N` and ordinary centers.
Its individual coefficient-height bounds give the required joint
bound through any index `l` by summing `s(l+1)` individual heights;
this is still a fixed polynomial in `l,d` times `Psi(h)`. Its
branch condition is exactly the universal condition used here.
All constants depend only on the originally fixed data.

Thus the proof verifies the **full stated interpolation implication**,
not just the graph lemma, not just finitely many ideals, and not any
application's claimed verification of its hypotheses.

## Literature comparison and result classification

Bertrand-Beukers, doi:10.24033/asens.1488, Theorems 1 and 1 bis,
bound orders for polynomial expressions in a fixed rational differential
system. They already allow holomorphic solutions at singular points;
regular-singular local multiplicity estimation is not claimed new here.
Their discussion on pp. 185-186 explicitly notes the dependence of
the exponent constants on the system, possibly its coefficient heights.
The work above controls the **varying pullback** using bounded residue
spectra, genera, and polar divisors; it does not treat the varying
systems as fixed when invoking their theorem.

The closest arithmetic comparison obtained is Martin Orr,
*Explicit height bounds for G-functions and unlikely intersections with
lines in tori*, arXiv:2607.09565v1, Proposition 4.6, Theorems 4.2
and 5.1. Those results already include selected-place inequalities,
field-degree-independent bounds, monomial amplification, and Hilbert
functions of actual specialization ideals. None of those features
alone is a novelty claim here. They assume G-functions of finite
arithmetic size and control invariants of a fixed one-variable system.
Theorem 5.1's super-strong nontriviality means multiplication is
injective in the actual specialization quotient, not just that a
function is nonzero on reduced components.

Those hypotheses are not automatic here. The coefficient-height input
allows `exp(a)`, whose factorial denominators give infinite G-size;
and freezing `U` in `log(1+aU)` creates a singularity at `-1/U`,
whose height can be of order `h`, not `Psi(h)`. These observations
distinguish the interfaces, not refute Orr's theorems. Section 5
supplies its own actual-ideal amplification rather than replacing a
non-zero-divisor condition by reduced-branch nonidentity.

This is an independently derived uniform verification/extension,
with a formally checked local and combinatorial core. It is not a
counterexample. No flawed literal manuscript assertion has been
identified in this route. The bounded Jacobian computation below
is a stress test, not the proof. Originality relative to all prior
literature and publishable significance remain matters for independent
review: `novelty_status=not_established`, not `verified_new`.
Consequently this Engineer result is **not campaign completion**.

## Nonradical stress test

Take the graph support `u=aq`, but present it by the nonradical ideal
`I=((u-aq)^2)`. With `n=3` and `F_3=q+au`, the typed Jacobian
normal-form computation certifies

`q notin (I,a^3,F_3)`.

In contrast `q^2` belongs to that actual ideal. Writing `t=u-aq`,
an exact identity is

`q^2=(1-2a^2)(F_3^2-2a F_3 t+a^2 t^2)
      +a^3 [a(3+2a^2)q^2]`.

Thus radical membership would lose real information here. The
standalone verifier replays the typed input/output and checks this
identity over the rationals. A map to
`Q[epsilon,eta]/(epsilon^2,eta^2)` given by
`a=epsilon, u=eta, q=-epsilon eta` annihilates all ideal generators
but not `q`, independently certifying the reported nonmembership.

## Replay and certification boundary

Run, from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/shared_interpolation/verify.py
```

The script checks the exact polynomial identities and nilpotent witness,
binds and independently replays the preserved Jacobian computation,
invokes the real Lean 4.31.0 compiler through `lean_evidence verify`
with claim `C_SHARED_FORMAL_CORE`, and runs both official checks against
the current campaign root. Generated compiler records and archived
certificates remain in `research/shared_interpolation/`.

The Lean statement-fidelity document names the exact declarations and
the geometric/arithmetic hypotheses not formalized. A successful replay
is mechanical evidence for the formal core and the explicit algebraic
certificate, not automatic validation of the prose proof, primary-source
attributions, originality, or manuscript applications. Those are explicitly
left to the independent Host-invoked Reviewer.
