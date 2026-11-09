# The critical Cauchy-quadratic law

**Assessment:** the explicit law and uniqueness on the affine/quadratic
locus are supported by the checked formulas and elementary measure
argument. The global endpoint classification has a supported prose
reduction through the separately assessed analytic chain; it is **not**
the theorem proved by the symbolic or Lean certificates. Its proposed
novelty and native acceptance remain unresolved.

## Exact claims, versions, and dependencies

The source is the snapshot-matching old
`9000072/research/affine_transport/report.md`, opening theorem and
Sections 5-6. `C_AT_QUADRATIC` v1 asserts that F_t, t real, sampled with
dt/(pi(1+t^2)), satisfies the inverse-square affine law at beta=1 for
all nonnegative Borel tests, and uniquely does so on the affine/quadratic
locus. `C_AT_ENDPOINT` v1-8 asserts the stronger implication:

If P is any Borel probability on normalized univalent half-plane maps
and, for some beta>=1, all x real, y>0, and nonnegative Borel Phi satisfy

\[
 E_P[|Q_F(x+iy)|^2\Phi(T_{x+iy}F)]
     =y^{-\beta}E_P[\Phi(F)],
\]

then beta=1 and P is exactly the stated Cauchy-quadratic pushforward.
The converse existence assertion is part of the old theorem.

All eight endpoint versions have the same natural statement. Versions
2-4 add inherited foundations. Version 5 retires three short assumption
IDs **only to repair collisions**, explicitly announcing replacements;
versions 6-8 add A_ENDPOINT_KOEBE, A_ENDPOINT_MEASURE, A_ENDPOINT_PLANE.
This is neither assumption elimination nor eight separate classifications.

Global exclusion of other laws depends on `C_AT_COMPARE`, the moment
identity, and `C_AT_RIGIDITY`. Existence and uniqueness **on the specified
support** can be checked independently of that exclusion.

## Construction checked for every condition

For real t let

\[
 F_t(z)=((z-t)^2-(i-t)^2)/(2(i-t)).
\]

The denominator never vanishes. This polynomial is holomorphic,
F_t(i)=0, F_t'(i)=1, and
F_t(z)-F_t(w)=(z-w)(z+w-2t)/(2(i-t)). For z,w in H the
second factor cannot vanish, proving univalence. The parameter map
t -> F_t is continuous for the locally uniform topology, so its
probability pushforward is Borel. The Cauchy density has total mass one.

Direct calculation gives

\[
 T_{x+iy}F_t=F_{(t-x)/y},\qquad
 |Q_{F_t}(x+iy)|^2=\frac{1+t^2}{(t-x)^2+y^2}.
\]

Multiplying the Cauchy density by this weight and substituting t=x+yu
gives exactly

\[
 \frac{1+t^2}{(t-x)^2+y^2}\frac{dt}{\pi(1+t^2)}
       =\frac1y\frac{du}{\pi(1+u^2)}.
\]

This is an equality of positive measures, so it proves the law for
**all nonnegative Borel tests**, including infinite-valued ones. No
extension from a finite collection of moments or numerical samples is
being used. The existing deterministic checker verifies the rebasing,
normalizations, pushforward density, mass, and root moments exactly.
It does not itself prove the surrounding measure or uniqueness arguments.

## Uniqueness on the locus

The support locus is Borel: for k=1 it is also the zero set of the
continuous evaluations J_F(z) on a countable dense source set, by the
rigidity classification. Its nonaffine parameter inverse is
t=i-1/F''(i), and F_t tends to z-i as |t| tends to infinity.
The affine map is fixed by all T_z and has Q=1; rebasing cannot turn a
nonaffine map into an affine one. Applying the law to its singleton
at y=2 gives m=m/2 and removes its atom.

The remaining law is a probability mu on real vertices. At y=1,
the Borel test (1+s^2)psi(s) makes lambda=(1+t^2)mu translation-invariant.
This test is legitimate even if unbounded because the law was assumed
for every nonnegative Borel test. Lambda is locally finite, since its
weight is bounded on each compact interval.

Translation invariance gives equal mass to all singleton atoms, hence
zero atom mass by local finiteness. The finite interval-mass function
is monotone and additive in interval length; agreement first at
rational lengths and then by monotonicity at real lengths gives
lambda=c dt. Uniqueness of locally finite Borel measures extends the
interval identity. Probability normalization forces c=1/pi. This
proves locus uniqueness without an unquoted Haar classification.

## Global endpoint reduction and its actual bar

The separately checked moments give

\[
 ((\beta+3)/4)^2 E[J(i)]
       =(\beta+3)(\beta-1)/16.
\]

For beta>=1, the analytic comparison E[J(i)]<=0 forces beta=1.
The strict-gain equality argument then gives J identically zero almost
surely. Rigidity at k=1 concentrates P on exactly the locus treated
above; hence locus uniqueness implies global uniqueness.

This is not circular use of the dyadic law construction at beta=1:
the theorem hypothesizes an exact law. Its explicit example is constructed
directly. The threshold beta>=1 cannot simply be dropped: the affine
singleton with Q=1 has the law at beta=0.

No mathematical gap was identified in this prose reduction after retaining
the inherited analytic foundations. The distinction between support
classification and measure classification is essential; neither the
zero-J circle nor quadratic injectivity alone proves the theorem.

## Evidence and concrete limits

The old graph lists the correct global comparison/rigidity/quadratic
dependencies, but `R_AT_QUADRATIC_CORE` lists only `C_AT_FORMAL` as its
obligation. As a *sufficient proof decomposition* that route is incomplete:
the formal source does not prove the pushforward law, exclude the affine
atom, or identify the tilted translation-invariant measure. Section 6's
prose and exact density identity are essential additional evidence.
This is a dependency-coverage defect, not a counterexample to the law.

Likewise `exact_certificate.json` labels its result `new_theorem` and
`C_AT_ENDPOINT`, but its executable checks establish identities, not the
global analytic quantification over probabilities. The Lean endpoint
lemma treats beta and j as real numbers with the moment identity and
nonpositivity assumed. It contains no K, random univalent map, exact
law, support reduction, or uniqueness theorem. Thus a claim that the
existing machine certificate **alone** proves the global classification
is unsupported.

The strongest prior spectrum inequality is different in mathematical
content from this law classification; it does not by itself prove or
disprove it. The bounded source comparison did not identify this precise
classification, but does not establish priority, especially in the
access-limited univalent-measure literature. The old theorem is therefore
a proposed strengthening with unverified novelty, not `verified_new`.
Foundational Duren/Folland/planar inputs remain explicit inherited
assumptions of the global analytic reduction. Native independent review
must assess the full prose argument, not infer it from compilation.
