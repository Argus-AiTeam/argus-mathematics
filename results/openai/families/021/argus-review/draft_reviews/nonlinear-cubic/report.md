# Coefficient-independent cubic nonlinear bound

**Engineer assessment: supported as a geometric prose proof, not a formal
geometry certificate.** The explicit constant is conservative. The cubic
degree dependence is already implicit in the manuscript's componentwise
argument; this review does not certify novelty.

## Claim, hypotheses, and source

Historical `C_INVERSE_NONLINEAR` v1 and `C_INVERSE_CUBIC` v1 share the argument
in `9000021/research/inverse_certificate/REPORT.md`, "An explicit
degree-uniform nonlinear bound". They are grouped, not counted as two
independent geometric discoveries. The active claim is `R_CUBIC`.

For a nonzero real bivariate polynomial of degree at most `d` and `S>=1`,
the number of integer points in `[0,S]^2` lying on its nonlinear
complex-irreducible components is at most

```
512*d^3*(1+ceil_cuberoot(S^2)).
```

There is no coefficient-height restriction, and no bound for points lying
only on line components. Distinct nonlinear factors, not their
multiplicities, are counted.

The staged manuscript, September 25, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`, supplies `inverse.tex`,
Lemma `lem:nonlinear-points`, and `elementary-inputs.tex`, Lemma
`lem:elementary-bezout`. Both arguments were read. The manuscript attributes
the convex-arc method to Jarnik; this review uses the displayed
self-contained vector argument, not an unexamined theorem from that
historical reference.

## Intersection and decomposition argument

Consider a complex-irreducible nonlinear factor `Q` of degree `j>=2`.
If it is not proportional to a real polynomial, `Q` and its conjugate
are coprime, and each real zero is common to both. Affine Bezout gives at
most `j^2` points.

For a real-scaled factor, neither partial derivative vanishes identically:
an irreducible polynomial over the algebraically closed field independent
of one coordinate would be linear. Each nonconstant derivative is coprime
to `Q` because it has smaller degree. Together they contribute at most
`2*j*(j-1)` intersection points; a nonzero constant derivative contributes
none. The four boundary lines contribute at most `4*j`, since none can be
a factor of nonlinear irreducible `Q`.

On a smooth graph `Y=f(X)` with `Q_Y!=0`, implicit differentiation gives

```
f''=-I_Q/Q_Y^3,
I_Q=Q_XX*Q_Y^2-2*Q_XY*Q_X*Q_Y+Q_YY*Q_X^2.
```

Its degree is at most `3*j-4`. If `Q` does not divide `I_Q`, the additional
inflection points number at most `j*(3*j-4)` (and a nonzero constant has
none). If `Q` divides `I_Q`, every nonspecial smooth real arc would have
zero second derivative and lie on a line. Restricting `Q` to that line
would yield a univariate polynomial vanishing on an interval, so the line
would be a factor, a contradiction. All remaining real points in that
case are among the already counted critical/boundary points.

Mark the abscissae of those points and `0,S`. A generous count is
`5*j^2+4*j+2<=8*j^2`. Between adjacent marked abscissae the implicit-function
theorem gives smooth graph branches. Continuation cannot end within the
strip without a critical point or boundary crossing: on a compact inner
substrip any limiting zero is still in the square, and nonzero `Q_Y`
continues it. Each vertical fiber has at most `j` zeros, so at most `j`
graphs cross a strip. There are at most `8*j^3` arcs. Nonvanishing `Q_X`
and `I_Q` make each graph monotone and strictly convex or concave.
Marked fibers also contain at most `j` points each; an identically
vanishing fiber would be a prohibited vertical line factor.

The affine intersection input is substantive, not a numeric fixture.
Its supplied elementary proof first makes both polynomials monic in `Y`
by a generic linear coordinate choice. Coprimality over `C(X)` makes the
Sylvester determinant nonzero. Its zeros and monic finite fibers first
establish finiteness of the common zero set. Only then is a second generic
projection chosen to separate those points. Each determinant term has
degree at most

```
sum_{i<n}(m+i)+sum_{j<m}(n+j)-sum_{k<m+n}k=m*n.
```

Distinct common zeros therefore inject into at most `m*n` roots. The proof
does not assume the finiteness or injectivity it is trying to prove.
Affine Bezout and real implicit-function/continuation facts remain explicit
source assumptions in the active ledger, not kernel-certified geometry.

## Lattice vectors and the explicit constant

Order the lattice points on one arc by increasing first coordinate.
Consecutive difference vectors have positive integer first coordinate,
distinct slopes, and hence are distinct. Their total taxicab length is
at most `2*S`, since both coordinates vary monotonically within the square.

There are exactly `T^2` integer vectors with positive first coordinate and
taxicab length at most a nonnegative integer `T`: summing
`2*(T-x)+1` over `x=1,...,T` proves this without a primitivity assumption.
For `M>=16` distinct vectors choose `T=floor(sqrt(M)/2)`. At most `M/4`
vectors have length at most `T`, while `T>=sqrt(M)/4`. In particular at
least half have length at least `sqrt(M)/4`, so total length is at least
`M^(3/2)/8`. Combining with `2*S` bounds the number of arc lattice points
by the report's looser `32*(1+S^(2/3))`; the cases `M<16` are covered too.

The arcs therefore contribute at most
`256*j^3*(1+S^(2/3))`, and the marked fibers at most `8*j^3`.
These fit within `512*j^3*(1+S^(2/3))`.
The nonreal-factor bound fits within the same allowance.
For distinct factors, `sum j<=d` and
`sum j^3<=(sum j)^3<=d^3`. Summing the component bounds proves the claim;
replacing `S^(2/3)` by its integer ceiling only enlarges the right side.
Intersections of components are harmless overcounting.

## Formal boundary and comparison with the strongest prior result

`marked_abscissa_constant` proves only
`5*d^2+4*d+2<=8*d^2` for natural `d>=2`.
The fresh Lean replay checks that arithmetic declaration, not factors,
Bezout, implicit functions, curvature, branch continuation, or lattice arcs.
The unchanged Python replay tests degree constants for degrees 2 through
100; it is likewise not a universal real-algebraic verification.
Their actual toolchain/results are linked in
[finite-rigidity/report.md](../finite-rigidity/report.md).

The manuscript states a looser `O(d^4*(1+S^(2/3)))` lemma, but its proof
already gives `O(j^3*(1+S^(2/3)))` per irreducible component. Summing cubes
rather than applying a loose global degree bound yields `O(d^3)`.
Thus the old report makes an implicit improvement explicit and supplies a
constant; it does not establish a new convex-curve method. This precise
comparison matters for the [conditional exponent extension](../structural-extension/report.md).

No concrete gap was identified in the coefficient-independent bound under
these standard inputs. The remaining review obligation is an independent
reading of this geometric proof, not merely another compiler run.
