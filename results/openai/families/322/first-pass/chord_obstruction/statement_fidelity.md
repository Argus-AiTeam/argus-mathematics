# Statement fidelity: conditional aligned-chord obstruction

The claim is `C_CHORD_OBSTRUCTION`, not the complete Tingley extension
theorem. The source is `Main.lean`, namespace `ChordObstruction`.

## Objects and quantifiers

`Plane` is a real-valued function of two real coordinates, with
nonnegativity, the triangle inequality, homogeneity for nonnegative real
scalars, simultaneous sign symmetry, and the two normalized axis
identities `n a 0 = |a|` and `n 0 b = |b|`. These are explicit
hypotheses, not axioms added to Lean. No positive-definiteness or
independence of the two coordinate directions is required.

`ofVectors v y hv hy` constructs this object as
`n a b = norm (a * v + b * y)` in **any** real normed vector space,
where both directions have norm one. The formal expression uses scalar
multiplication. No completeness, dimension, separability, smoothness,
strict convexity, or compactness typeclass is present.

For arbitrary `Plane` objects `P,Q`, `Configuration P Q` quantifies over
real numbers `t,p,r,s,u,M`. Its hypotheses are:

1. `0<t<1` and `p,r,s,u,M>0`;
2. `s=p+M`, `r=u+M`, and `p+r<=2`;
3. `P.n p t = P.n r (-t) = Q.n s t = Q.n u (-t) = 1`;
4. `P.n p (t-1) = Q.n s (t-1)` and
   `P.n r (1-t) = Q.n u (1-t)`;
5. for every real `q` with `0<=q<=1`,
   `Q.n s (t-q) - P.n p (t-q) <= M` and
   `P.n r (q-t) - Q.n u (q-t) <= M`.

`Configuration.balance` derives `p+r=s+u`; it is not an unrecorded
assumption. The radius bounds `[1-t,1+t]` are not needed.

## Conclusions and principal declarations

`Configuration.secant` proves the three finite secant inequalities in
the report. `Configuration.support_secant` proves the full numerical
chain in the manuscript's `lem:secant`, including its universal
quantifier over supports. Specifically, `lv,ly` are the values of any
linear functional on the two directions; `hdom` is its norm domination
on their span; `heq` says that it supports `(a,h)`, where `a=p/s`.
It proves `e/p<=lv<=K<=k`, with exactly the manuscript's `K` and
piecewise upper bound `k`.

To pass from a manuscript support at `v+theta*y` to `heq`, use
`theta=h*s/p`, so `a*theta=h` and `a>0`. Scaling a supported vector
by `a` gives a support at `a*v+h*y`. Linearity gives
`a*lv+h*ly=P.n a h`. Domination on the ambient finite span gives
`hdom`. Conversely the coordinate domination is all this proof needs.
The lower bound follows directly from the triangle inequality at the
unit endpoint and `ly<=1`, without assuming uniqueness or existence of
any additional support.

`Configuration.large_geometry` constructs a strictly inward direction
when `B>e`. `Configuration.not_large_B` and `not_large_A` prove
`B<=e` and `A<=e`, the conclusion of `lem:large`.
`Configuration.small_half` proves the required `e<1/2`.
`Configuration.no_configuration` proves `False` from a configuration.
`chord_obstruction` states that no such configuration exists.
`arbitrary_normed_spaces` specializes this conclusion to coordinate
norms in arbitrary real normed spaces, with no restriction on ambient
dimension or on dependence of directions.

## Explicit implication from the manuscript

`manuscript_chords_impossible` is a separate formal bridge, not merely
an informal interpretation of the coordinate theorem. It takes actual
vectors `v,y,x,z` in one arbitrary real normed space and
`w,b,fx,fz` in another, the positive radii and defect, and:

- all eight required unit-vector equalities;
- `x=p*v+t*y`, `z=t*y-r*v`,
  `fx=s*w+t*b`, `fz=t*b-u*w`;
- preservation of the distances `norm(x-y)=norm(fx-b)` and
  `norm(y-z)=norm(b-fz)`;
- the global absolute defect bounds for the pairs `(x,y)` and `(z,y)`
  for **all** `q` in `[0,1]`.

It constructs `Configuration` and concludes `False`. In the staged
manuscript take `b=f(y)`, `fx=f(x)`, `fz=f(z)`. The equations and
radii come from `eq:chords` and `eq:radii`; the distance equalities
come from the sphere isometry; the absolute inequalities come from
`eq:maximal`. The formal bridge reverses the order of the two summands
of `x` and `fx`, using commutativity only. It also explicitly handles
the minus signs for `z` and `fz`. Its conclusion therefore rules out
every aligned positive-defect configuration promised by
`prop:alignment`, provided that upstream proposition is valid.

The model does not assume a sphere map exists: it needs only the
specified finite endpoint data and two families of inequalities.
This is a weakening of hypotheses, not a replacement of arbitrary
norms with special norms.

## What is and is not certified

The Lean kernel checks the norm axioms, scalar algebra, secants,
inverse configuration, finite perturbation, and terminal contradiction.
There is no imported comparator file, external theorem assumption,
`sorry`, `admit`, or user-declared axiom in this source.
The printed axiom reports audit the three principal declarations.

The compiler does not verify this document's interpretation. In
particular, it does not certify `lem:attainment`, `prop:alignment`,
the Darbo argument, the existence of the initial sphere isometry, or
the full extension theorem `thm:main`. The manuscript's
`prop:no-defect` is verified **conditional on the aligned configuration
that its proof invokes**. Independent review of this translation and
of the result's significance remains required.
