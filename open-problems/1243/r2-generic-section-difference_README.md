# Generic difference of the two delta-orbit sections

## Exact outcome

The generic construction succeeds algebraically, but it cannot produce a
counterexample. The two signed degenerate sections are independent over
`Q(a)`, their difference is non-torsion and generically leaves the
`delta(t)=delta(a)` locus, and the complete residual cover is a geometrically
integral genus-113 curve. A square-class decomposition of the `F` radicand
eliminates one branch unconditionally and reduces the other branch to

```text
s^2 = z^6 + 136*z^5 - 632*z^4 + 1248*z^3
      - 1264*z^2 + 640*z - 128.                 (G2)
```

An unconditional even-degree 2-descent, saturated rank-one Mordell-Weil
calculation, self-contained p-adic residue-disk argument, and finite
Mordell-Weil sieve prove

```text
G2(Q) = {(z,s)=(1,1), (1,-1), infinity_plus, infinity_minus}.
```

Testing both rational `w` branches above each point gives eight
`(curve point,w branch)` lifts. At `z=1` they have `a=0` or `a=1` and
`x=y=0`; at infinity they have `a=-1` or `a=infinity` and `y=0`. All `I`,
`F`, and `D` radicals lift, but every lift lies on the collision divisor.
Thus this section-difference route is retired. There is no noncollision
candidate, so the authoritative magic-square checker was not invoked.

## Signed sections and generic subtraction

Use the reviewed model

```text
beta = (a^2+2*a-1)/(a^2+1),
v^2 = beta^2*t^4 - 4*t^3 + 2*beta^2*t^2 + 4*t + beta^2,
Y^2 = X^3 + 2*beta^2*X^2 - 4*(4+beta^4)*X
      + 8*beta^2*(4-beta^4).
```

The signs are fixed by the certified `a=1/4` Mordell-Weil coordinates:

```text
P: t=a,                 v=-(1+a^2),
Q: t=(1+a)/(a-1),       v=-2*(1+a^2)/(a-1)^2.
```

Under the reviewed quartic-to-Weierstrass map, direct polynomial reduction
gives

```text
X(P) = -2*(a^6-4*a^3-3*a^2+4*a-2)/(a^2*(a^2+1)^2),
Y(P) = -8*(a-1)^2*(a+1)*(a^4+2*a^3+2*a^2-2*a+1)
       /(a^3*(a^2+1)^2),

X(Q) = 2*(a^6-2*a^5-5*a^4-12*a^3+11*a^2-10*a+1)
       /((a+1)^2*(a^2+1)^2),
Y(Q) = -64*a*(a^4+2*a^3+2*a^2-2*a+1)
       /((a+1)^3*(a^2+1)^2).
```

Both points satisfy the generic Weierstrass equation. With `R=Q-P`,

```text
X(R) = 2*(a^2+2*a-1)^4
       /((a^2+1)^2*(a^2-2*a-1)^2),
Y(R) = 64*a*(a-1)*(a+1)*(a^2+2*a-1)
       /(a^2-2*a-1)^3.
```

Inverting the birational map gives

```text
t_R = (a^2-2*a-1)*(3*a^2-2*a+1)/(a^2+2*a-1)^2.
```

The exact numerator of `delta(t_R)-delta(a)` is nonzero; for example, at
`a=1/4`, `t_R=-253/49` and

```text
delta(t_R)-delta(a) = -43892271336/318643315225.
```

At that smooth fiber, the certified full basis is

```text
G1=(-1058,21896), G2=(-982,24480),
T1=(98,0), T2=(1058,0), T3=(-1254,0).
```

Exact elliptic addition gives

```text
P(1/4) = G2 + T3,       free vector (0,1),
Q(1/4) = G1 + G2 + T1, free vector (1,1),
R(1/4) = G1 + T2,       free vector (1,0).
```

The mwrank certificate proves that `G1,G2` are an unconditional full
saturated basis, and PARI proves the complete torsion group is `C2 x C2`.
Thus `R(1/4)` is non-torsion. A generic torsion relation would specialize to
torsion at this smooth fiber, so `R` is non-torsion over `Q(a)`.

## Complete residual cover

The first residual `A=1+delta(t_R)-delta(a)` is already the square

```text
(v_R/(1+t_R^2))^2.
```

The remaining conditions are

```text
I = 1-delta(t_R)+delta(a),
F = 1+delta(t_R)-2*delta(a),
D = 1-delta(t_R)+2*delta(a).
```

All three have the common square denominator

```text
W(a)^2,
W(a) = (a^2+1)*(5*a^4-2*a^2+1)
       *(a^4-4*a^3+10*a^2-4*a+1).
```

The exact degree-20 numerators `N_I,N_F,N_D` are recorded coefficient by
coefficient in `evidence/cover-verification.json`. Each is squarefree, every
pair is coprime, and their leading coefficients are `49,1,49`, all squares.
Consequently the complete cover

```text
r_I^2=N_I(a), r_F^2=N_F(a), r_D^2=N_D(a)
```

has square-class rank 3, one geometric component, degree 8 over `P1_a`, 60
finite simple branch points, no branch at infinity, and

```text
2*g-2 = 8*(-2) + 60*(8/2) = 224,
g = 113.
```

No denominator factor was discarded as though it were a rational point.
`5*a^4-2*a^2+1` and
`a^4-4*a^3+10*a^2-4*a+1=(a-1)^4+4*a^2` are positive over the reals. The
other geometric map denominators and all eight reduced directional
collision numerators are explicitly retained in the saturation data.

## Quotient and all delta symmetries

The four transformations preserving `delta(a)` are

```text
a, -1/a, (1-a)/(1+a), (1+a)/(a-1).
```

The selected signed difference is fixed by the order-two subgroup generated
by

```text
h(a)=(1-a)/(1+a).
```

The other coset sends it to the opposite signed difference, rather than to a
second point on the same selected cover. The invariant coordinate and its
rational lift are

```text
z = (a^2+1)/(a+1),
w = (a^2+2*a-1)/(a+1),
w^2 = z^2+4*z-4,
a = (z+w)/2.
```

In this coordinate,

```text
t_R = (z-2)*(3*z-2)/(z^2+4*z-4),
delta(a) = -4*(z-1)/z^2.
```

After removing the proven common square denominator

```text
z^2*(5*z^4-20*z^3+48*z^2-48*z+16)^2,
```

the three residual radicands have degree 10. They are squarefree and
pairwise coprime, so the three-radical quotient has degree 8 and genus 53.
Recovering rational `a` adds the coprime quadratic radical
`z^2+4*z-4`; the resulting four-radical model has degree 16, 32 finite
simple branch points, one geometric component, and genus 113. Quotient
points are not accepted unless all three residual roots and this `w` root
lift.

## Exceptional and collision points

The rational exceptional values are handled directly:

| `a` | `t_R` | `(sqrt(I),sqrt(F),sqrt(D))` | collision |
|---|---|---|---|
| `0` | `-1` | `(1,1,1)` | `x=y=0` |
| `1` | `-1` | `(1,1,1)` | `x=y=0` |
| `-1` | `3` | `(7/5,1/5,7/5)` | `y=0` |
| infinity | `3` | `(7/5,1/5,7/5)` | `y=0` |

Thus every rational point introduced by a section-map exceptional branch is
degenerate. The search tests the full collision product

```text
x*y*(x-y)*(x+y)*(x-2*y)*(x+2*y)*(2*x-y)*(2*x+y)
```

with `x=delta(t_R)-delta(a)` and `y=delta(a)` exactly.

## Square-class reduction of `F`

Over `Q[z]`,

```text
N_F(z) =
(z^4+16*z^2-32*z+16)
*(z^6+136*z^5-632*z^4+1248*z^3-1264*z^2+640*z-128),
```

The exact resultant of the two factors is `2^37`, and the first factor is
`z^4+16*(z-1)^2>0`. For reduced `z=p/q`, if `N_F(z)` is a square, the two
primitive homogeneous factors therefore have the same square class
`d in {1,2}`.

For `d=2`, the quartic

```text
2*y^2=z^4+16*(z-1)^2
```

is birational to

```text
V^2=U^3+8*U^2-16*U.
```

mwrank proves rank zero unconditionally and PARI proves torsion `C2`.
The two elliptic points pull back to `(z,y)=(2,+-4)`. But
`z^2+4*z-4=8` is not a rational square at `z=2`, and the second homogeneous
factor has square class 6 there. Hence the complete cover has no `d=2`
point.

For `d=1`, the second factor must itself be a square, giving (G2). Put

```text
z=(x+1)/(x+2),       s=y/(x+2)^3.
```

This gives the reduced curve

```text
C: y^2=x^6-2*x^5-17*x^4+4*x^3+95*x^2-2*x-207.
```

Its polynomial discriminant is `2^42*487`. Stoll's even-degree descent has
finite descent set `{2}`; the real place is also imposed. The exact global
and local square-class calculation gives a trivial fake 2-Selmer group and
a one-dimensional true 2-Selmer group.
Good reduction gives `#J(F_3)=29` and `#J(F_5)=33`, so rational torsion is
trivial. With

```text
E=[infinity_minus-infinity_plus],
[(-2,1)-infinity_plus]=-2E,
[(-2,-1)-infinity_plus]=3E,
```

it follows that `rank J(Q)=1`.

The modified-height bound of Mueller-Stoll reduces saturation to exhaustive
Kummer enumeration with first-three-coordinate height at most `2016`.
`j-points 1.2 -a` returns exactly six Kummer points, and exact Sage arithmetic
identifies them as `E,2E,...,6E`. The covering-radius argument therefore proves

```text
J(Q)=Z*E.
```

### Faithful even-degree descent application

The application is to **Jacobian** fake and true 2-Selmer groups, not an
empty curve-Selmer set. Stoll's Section 5 is restricted to even genus, which
holds here. The two rational infinities and `(-2,+-1)` give rational points
and degree-one divisor classes globally and at every completion, so
condition `(dagger)` and the degree-one hypothesis in Lemma 5.1 hold.

The sextic and its degree-ten partition resolvent are irreducible over `Q`.
There is neither an odd-degree factor nor a resolvent root; Lemma 5.3
therefore excludes both alternatives in condition `(double-dagger)`.
At `Q_2` the factor degrees are `[2,4]`, and the resolvent factor degrees
are `[2,4,4]`, again excluding that condition. Lemma 5.7 gives
`dim J(Q_2)/2J(Q_2)=2-1+2=3`. Lemma 5.1 then removes a one-dimensional
kernel, so the descent image has dimension **two**, not three.
The recorded even-factor class and the point class `-theta` at `x=0`
are independent modulo `Q_2^*`; `f(0)=-207=1 mod 8` gives the required
`Q_2` point. Their dimension equals the full target dimension, so they
exhaust the local image rather than merely supplying samples.

The real factorization has two linear and two irreducible quadratic factors.
Lemma 5.6 gives `dim J(R)[2]=2`, so Lemma 5.14 gives real descent-image
dimension `2-2=0`. The certificate's real sign restriction modulo diagonal
rational signs is precisely this trivial image; the real place was not
omitted.

For the global step, the unconditional class-number-one calculation and the
complete six-dimensional `{2}`-unit squareclass space supply all candidates.
The combined norm, real and full `Q_2` restrictions have rank four and
kernel exactly the two-dimensional image of `-1,2`. Quotienting by these
rational constants gives fake dimension zero. Stoll Proposition 5.5, with
failure of global `(double-dagger)`, gives true dimension one. The omission
of `487`, where `v_487(disc(f))=1`, is justified by Proposition 5.10,
Corollary 5.11 and Proposition 5.12's algorithm, **not** by Lemma 5.14.
The torsion and nonzero infinity-difference calculation then gives rank one.

### Corrected height conversion and exhaustive saturation

The finite correction is valid, but the code comment identifying
`2^-4*disc(f)=2^38*487` as the curve discriminant is not a valid premise.
Mueller--Stoll Section 3 defines
`Delta(F,H)=2^-12*disc(4F+H^2)`. Section 18 step 6(b) gives the conversion
needed here:

```text
h = x^3+x^2+x+1,
f2 = -x^5-5*x^4+23*x^2-x-52,
f = h^2+4*f2,
Y=(y-h)/2,                 Y^2+h*Y=f2.
```

This is an integral Weierstrass model, with discriminant
`2^-12*disc(f)=2^30*487`; Theorem 11.3 bounds its local correction at `2`
by `30/4`. The original polynomial has coefficient gcd one, but step 6(b)
replaces the algorithm's `g` by `4g`. Thus step 7 adds `log(4)`, and the
total finite contribution on the original coordinates is

```text
(30/4)*log(2)+log(4) = (19/2)*log(2).
```

No minimality or semistability assumption is needed for Theorem 11.3.
The simple-discriminant prime `487` contributes zero, as Section 18 states.
This repairs the reason for the stored bound, without changing its value
or any enumeration output.

The integral identity and the strict cutoff are independently rerunnable with

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/literature/verify_height_conversion.py
```

The cutoff replay is exact rational arithmetic: raising the height inequality
to the twelfth power reduces it to
`exp(43269/2500) > 18^3*1217625097*2^114/2016^12`;
the positive Taylor sum through degree 80 already exceeds the right side.
It uses, rather than recomputes, the archived canonical and archimedean
upper bounds.

The archived certificate uses Lemma 16.1 with 20 iterations and certified
complex/real balls to obtain `beta_tilde_infinity < -1.4423`.
The exact duplication coefficient bound gives

```text
hhat(E) <= log(18)+(1/3)*log(1217625097),
rho^2 <= (1/4)*(log(18)+(1/3)*log(1217625097)),
B+beta_tilde < 7.608538501187,       exp(B+beta_tilde) < 2016,
```

with `B=rho^2`; these are upper bounds, not asserted exact canonical
heights. Section 18 steps 8-9 require enumeration of **all**
first-three-coordinate Kummer triples through this projective height,
checking their fourth-coordinate solutions and Jacobian lifts, and adding
the identity. The archived `j-points -a` run at height `2016` does this; an
affine curve-point search or an unmarked finite Mordell-Weil box would not.
The exact Sage identifications of its six outputs with the images of
`E,...,6E` account for both signs on the Jacobian.

Here saturation is Section 18 method **(i)**. A rank-one lattice generated
by `E` has covering-radius squared `hhat(E)/4`. For any `P in J(Q)`,
subtracting a nearest integer multiple of `E` produces a point of height
at most this radius. Every such point is in the exhaustive list and hence
in `Z*E`; rational torsion is already trivial. Therefore `P in Z*E`.
This proves saturation directly and does not use method (ii), which would
instead require an index bound and a separate saturation test at every
prime up to that bound.

The primary texts and the earlier independent reader records
`research/literature/cd68428c1f67e13e309925ad84065884.json` and
`research/literature/ee6676f4697e1bf917c62df4a2ed0c6a.json` are preserved.
The expanded faithful passages are
`research/literature/mueller-stoll-section-difference-excerpt.txt` and
`research/literature/stoll-section-difference-excerpt.txt`.
Earlier attributions to predecessor assumption references do not
automatically close the current claim-specific source judgments.
Host-invoked independent review must check those references and this
corrected implication; Engineer has not supplied an independent verdict.

At the good prime `19`, a local odd-degree transformation makes p-adic
integration available. If `I_0,I_1` are the integrals of
`dx/(2y),x dx/(2y)` from `(-2,-1)` to `(-2,1)`, then their divisor is `-5E`.
The combination

```text
omega=(I_1/19)*dx/(2y)-(I_0/19)*x dx/(2y)
```

therefore annihilates `J(Q)=Z*E`, and its reduction is

```text
(x+16) dx/(2y) mod 19.
```

Its only finite zero would have `x=3`, but the curve value there is the
nonsquare `15 mod 19`. At a branch point its local coefficient is
`(x+16)/f'(x)`, and in the infinity charts it is `-(1+16u)/(2v)` with
`v=+-1`; these are units. Thus the reduced differential is nonzero at every
point of `C(F_19)`. Its two geometric zeros above `x=3` are defined only over
`F_(19^2)` and do not index residue disks in `C(Q_19)`.

For completeness, `padic-residue-disk-proof.md` proves the disk bound
directly. On a residue disk write

```text
omega=(a_0+a_1*T+...)*dT,  T in 19*Z_19,
```

where `a_0` is a unit at the chosen `F_19`-rational reduction point. The
difference quotient of its termwise primitive is
`a_0` plus terms of valuation at least
`n-v_19(n+1)>=1`. It is therefore a unit, so the primitive is injective.
Two rational points in one disk have difference in `J(Q)`, on which `omega`
vanishes, and hence must coincide. This proves, without an external
residue-disk assumption, that every relevant disk contains at most one
rational point. The curve meets `<E>` modulo `19` in generator residues

```text
0,1,3,62,71,110,149,158,217.
```

The known points occupy `0,1,3,217`. A Mordell-Weil sieve at
`5,13,23,37,227` leaves only residues congruent to `0` or `1 mod 3`, whereas
the five extra residues modulo `19` are all `2 mod 3`. This excludes every
extra disk and proves

```text
C(Q)={(1:1:0),(1:-1:0),(-2,1),(-2,-1)}.
```

The birational map transfers these to the four points on (G2) stated above.
The exact `w`, `I`, `F`, and `D` boundary calculations in
`evidence/genus2-complete-classification.json` then prove that all eight lifts
are collision-degenerate.

## Targeted source lookup

Exact-coefficient searches of GitHub, the public web, and the LMFDB genus-2
search on 2026-08-27 found no published or database-backed complete
rational-point determination for (G2) or the genus-4 `I` quotient. The
classification above is therefore established by the campaign certificate,
not assumed from an external rational-point table. This negative lookup is
not a claim that no such result exists.

## Jacobian operation

The required Argus adapter command failed with exit 1 because
`argus_skill.tools.jacobian` is absent from the pinned environment. The
pinned fallback catalog was then searched for a small matching operation
set. It contains no hyperelliptic rational-point, Jacobian-rank, Chabauty,
or Mordell-Weil-sieve operation.

After inspecting its exact typed contract, one bounded read-only operation
was run:

```text
operation_id: polynomial.factor.compute
input: the canonical degree-10 I radicand over QQ[z]
output: content 49, one linear factor, one degree-9 factor,
        both with multiplicity 1, exact product reconstruction
runtime_ms: 20
```

The fallback catalog reports no server or protocol version, so both are
recorded as unreported rather than inferred. The adapter error, candidate
set, contract, exact payload, typed output, and status are preserved under
`evidence/jacobian/`. This operation certifies a factorization only; it is
not rational-point evidence.

## Rerun

From the campaign root:

```bash
/home/argustest/zimo/counterexample-batch-1/campaigns/1243/research/\
r2-generic-section-difference/toolchain/sage-10.9/bin/python \
  research/r2-generic-section-difference/certify_genus2_points.py

/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/r2-generic-section-difference/verify_cover.py

/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/r2-generic-section-difference/certify_twist.py

/home/argustest/zimo/references/jacobian/.venv/bin/jacobian \
  run polynomial.factor.compute \
  --file research/r2-generic-section-difference/evidence/jacobian/factor-I.payload.json
```

The complete rational-point certificate uses:

- Michael Stoll, *Implementing 2-descent for Jacobians of hyperelliptic
  curves*, Acta Arith. 98 (2001), 245-277,
  `doi:10.4064/aa98-3-4`, Section 5; Lemmas 5.1, 5.3, 5.6, 5.7, 5.14;
  Propositions 5.5, 5.10, 5.12 and Corollary 5.11.
- E. V. Flynn, *The Group Law on the Jacobian of a Curve of Genus 2*,
  J. Reine Angew. Math. 439 (1993), 45-70,
  `doi:10.1515/crll.1993.439.45`, Corollary 3.8 and Appendix C.
- J. Steffen Mueller and Michael Stoll, *Canonical Heights on Genus Two
  Jacobians*, `arXiv:1603.00640v2`, Section 3 discriminant definition,
  Theorem 11.3, Lemma 16.1 and Sections 17-18, including step 6(b)
  and saturation method (i).
- Michael Stoll, `j-points 1.2`; the source URL, archive and component
  hashes, build flags, executable hash, command, and exhaustive output are
  recorded in `evidence/j-points-height-2016.json`.
