# Original logarithmic interpolation theorem

**Assessment:** the original interpolation assertion is supported by the written multiplicity/curve/jet chain under its complete hypotheses. This is a synthesis of the preceding units, not a separate certificate or verification of the final pi theorem.

## Literal statement and version

The source is OpenAI's September 24, 2026 manuscript, revision `4eaee87548250b2682affda7d05d947c05554bae`, `interpolation.tex`, `geom:interpolation` (lines 14-44). Its supplied source hash agrees with the existing manuscript reference manifest. The old dossier assertion is `C_GEOM_INTERPOLATION` (A01); the written proof is A04 sections 1, 4 and 6. Current claim: `C_GEOM_INTERPOLATION`.

Fix integers `m,K>=1` and positive rational `w0,v0,theta`, with

    0<theta<1,  K theta^m<1,  K (w0/v0) theta^m<1.

There are successive lower thresholds for positive rational `w1,...,wm`, each depending only on those fixed data and earlier weights. **Choose these weights before the centers.** For every array of centers `aj=(1,cj1,...,cjm)` with the `K` values `cji` pairwise distinct for each fixed coordinate `i`, the map

    P -> coefficients of P(1+t,cj1+u1+log(1+t),...,cjm+um+log(1+t))

from polynomials of `W`-degree **at most** `H` onto all `K` coefficient packets of strict `V`-weight **less than** `H` is surjective for every sufficiently large sufficiently divisible integer `H`, where `V=(v0,w1/theta,...,wm/theta)`.

The fixed divisibility integer depends only on the weights. The later lower threshold on `H` may depend on the center locations. This is not surjectivity at every finite `H`, and distinct points alone are weaker than the required coordinatewise distinctness.

## Dependency analysis

The two volume inequalities let one choose positive rational `sigma` with all three original slack inequalities. The finite set of product inequalities permits a successive center-independent choice of weights, because in each ratio the largest differing positive index enters on the degree side and all remaining nonconstant factors use already chosen weights; common higher indices contribute fixed powers of `theta`.

The [multiplicity](../weighted-multiplicity/report.md) and [normal-basis](../normal-basis-geometry/report.md) arguments then justify the persistence-to-coordinate-flat steps. The [curve assessment](../original-curve-inequality/report.md) checks the complete branch-summed curve inequality, including the ambient count, constant-Y reduction, fiber count, and the final `S/theta` contradiction using coordinatewise distinctness. The [bridge assessment](../curve-to-jet/report.md) checks that this curve positivity supplies the exact coefficient packets, not merely an integrally closed approximation.

The bridge uses `H=nR`, with `R` chosen using only rational weights. After centers are fixed, the various existence and cohomology thresholds can be combined into one center-dependent threshold for `n`. Thus the proof preserves the order of quantifiers in the original theorem. No finite rank calculation can replace this argument.

## Scope and verdict

This unit depends on Mondal's isolated-zero bound; complete smooth curve models and curve degrees; ordinary blowup; eventual ordinary Rees pieces and higher cohomology; Serre vanishing; and ample plus nef on projective schemes. These are explicitly registered on the corresponding current prerequisite claims and cited in their reports. None is imported merely because the old graph marked a node supported.

The exact replay verifies hypotheses and two illustrative curves, not eventual interpolation for every configuration. Fresh Lean compilation verifies a local algebraic ingredient only. The proposed coordinate-flat extension changes the admissible center condition and is separately assessed; it is not silently substituted for this original assertion.

No false statement of the original interpolation section is established by the old dossier. Under the named inputs, no concrete gap was found in its scoped written verification. That does **not** establish that every later determinant, collision, parameter-selection or irrationality argument is correct. Native independent review of this original-claim verification remains required.
