# Integral labels and the arbitrary-E ample completion

## Assessment and exact scope

The old integral-label and ample-finiteness arguments are supported in
their stated scope. They also support reapplying the old geometric
argument to **the original, arbitrary bundle \(E\)**, rather than
identifying its master space with a twisted one. Thus the proposed
extension has substantive prose support, conditional on the same
geometric/common-\(R\) argument assessed in the localization unit. It
has no independent all-degree machine certificate. No specific gap in
the label/completion extension was established here.

This is an exploratory assessment of existing work, with review-result
novelty `not_applicable`; final acceptance is
`pending_native_independent_review`.

Precisely, \(B\) is smooth connected projective over \(\mathbb C\) and
\(E\) is any algebraic rank-\(r\geq2\) vector bundle, without global
generation or positivity. Put \(X=\mathbb P_B(E)\) and
\(W=\mathbb P_B(E\oplus\mathcal O)\) in the lines convention, with torus
weights \(0,1\). Work in full localized complex super cohomology, with
the two inverse-Euler fixed theories and the manuscript's stable-curve
ancestor conventions.

Use the isomorphism
\[
 H_2(P;\mathbb Z)\longrightarrow H_2(B;\mathbb Z)\oplus\mathbb Z,
 \quad d\longmapsto(\pi_*d,\langle p,d\rangle),\qquad
 p=c_1(\mathcal O_P(1)),\quad P=X,W.
\]
The coefficient monoid is the actual effective integral classes. A
coordinate \(l=\langle p,d\rangle\) may be **negative**; it is not
discarded when effective. Choose \(H\) integral ample on \(B\) and \(M\)
so that \(p+M\pi^*H\) is ample on \(W\). Complete in
\(l+M\langle H,\beta\rangle\), not in \(l\) alone.

`C_LOC_ARBITRARY` asserts unique positive-filtration \(u_B,u_X\) and
upper symplectic \(R=I+\) positive filtration with the same simultaneous
\(S_W=R S_{\rm bl}\) and ancestor identities as the localization unit.
It includes rational expansion at zero with a coefficientwise finite
lower bound and existence of both upper quantized actions. It does
not assert that before/after-twist master spaces coincide.

## Sources, versions, and attribution

The source is the old
`9000065/research/family_orbit_localization/report.md`, verification
theorem, Sections 1--5 and especially Section 6.
The manuscript comparison is
`Virasoro-Constraints-under-Projectivization-October-5-2026/build/sections/03-master-space.tex`,
`geo:curve-labels`, `geo:integral-splitting`, and
`04-localization.tex`'s finiteness paragraphs. The actual inputs match
the supplied revision `4eaee87548250b2682affda7d05d947c05554bae`.

| Old claim | Versions | Meaning |
|---|---|---|
| `L_LOC_LABELS` | 1 | Integral splitting, additive full labels, positive ample filtration and finiteness. |
| `L_LOC_NO_POSITIVITY` | 1 | The geometric construction uses no positivity; ample completion replaces nonnegative-\(l\) bookkeeping. |
| `C_LOC_ARBITRARY` | 1--6 | Same natural assertion throughout; successively records GP, virtual pullback, genus-zero identities, mixed ancestors and upper quantization. |

The extension and uniqueness are old Argus report assertions. The
manuscript uses a normalized \(E^\vee\)-globally-generated bundle and
therefore nonnegative \(l\); it does not assert nonnegative \(l\) for
arbitrary untwisted \(E\). This review does not manufacture such a
manuscript error. Novelty of the report's extension is unverified;
the abstract general-action formula was already anticipated in CGT
Remark 3.7. The finite algebra is standard, and no new result is
asserted by this review.

## Decisive checks of the argument

### Integral splitting, including torsion

The projective-bundle structure group acts trivially on the fiber
homology. In total degree two the Serre sequence has the base term
\(H_2(B;\mathbb Z)\) and fiber term \(\mathbb Z\), since the fiber is
simply connected. The global integral class \(p\) pairs to one with
the fiber line. Any differential killing a nonzero multiple of that
line, or a nontrivial quotient of it, would contradict that pairing.
Thus the fiber term survives and the edge sequence is
\[
 0\longrightarrow\mathbb Z[\text{fiber}]
  \longrightarrow H_2(P;\mathbb Z)
  \xrightarrow{\pi_*}H_2(B;\mathbb Z)\longrightarrow0.
\]
The \(p\)-pairing is an integral retraction. Together with \(\pi_*\)
it gives the stated splitting, without tensoring away torsion.
This justifies the exact labels rather than an identification by
divisor degrees or numerical equivalence.

The inclusion of \(X\) into \(W\) preserves the two coordinates;
the trivial section \(B\) sends \(\beta\) to \((\beta,0)\).
Gluing adds the actual integral classes. These facts do not require
global generation. Only the manuscript's additional conclusion
\(l\geq0\) uses global generation of the dual tautological data.
The equivariant restriction \(p|_B=-\lambda\) is not an ordinary
curve degree and does not change this calculation.

### Ample finiteness, not a hidden positivity assumption

A sufficiently large \(M\) makes the relative ample class
\(p+M\pi^*H\) ample on \(W\), hence on both fixed components.
Every nonconstant effective piece has strictly positive integral
degree for this class, and a moving degree-\(m\) fiber leg has
degree \(m\). Negative tautological coordinates therefore do not
produce zero-cost or negative-cost pieces.

Bounded ample-degree cycles lie in finitely many finite-type Chow
parameter spaces; homology is constant in a connected family.
Consequently only finitely many effective integral labels of bounded
ample degree occur. At a fixed total label, positivity bounds leg
multiplicities and the number of nonconstant pieces; this finite
label set bounds all decompositions. Stability bounds the remaining
degree-zero pieces for fixed genus and markings. Neither numerical
curve-class replacement nor a torsion-free hypothesis is used.

Cotangent powers on the fixed-target map stacks and ordinary leg
moments are nilpotent. Localization therefore expresses each
coefficient as a finite sum of rational loop-variable expressions.
Re-expansion at zero has a finite lower Laurent bound, distinct
from the original infinity expansion. Positive ample filtration
defines inverse and logarithm of \(R\); at fixed class, genus and
variable order it bounds the number of their positive-filtration
factors, edges and translations. Ancestor indices are bounded on
each surviving stable curve. The same reasoning applies to the
inverse upper action.

These are coefficientwise/formal existence arguments, not analytic
convergence claims or an assertion that the full positive loop
series is polynomial.

### Why the geometry can be reused for arbitrary E

The old proof's orbit covers project to points of \(B\), where the
relative tangent is \(\mathcal O(2m)\oplus\mathcal O(m)^{r-1}\).
The gerbe, its universal cover, tangent characters, normalization
sequence, diagonal matching, joint-moment convention and graph
stabilization require no global generation on \(B\).
The fixed normal bundles continue to have nonzero torus weights,
so the localized inverse-Euler twists exist without positivity.
The only bookkeeping use of the normalized nonnegative
tautological degree is replaced by the ample-degree argument above.
This supports `L_LOC_NO_POSITIVITY`.

This is a **reapplication of the same proof to a different master
space**, not a formal consequence of knowing the theorem for one
normalized master space. Although
\(\mathbb P(E\otimes L)\simeq\mathbb P(E)\),
\[
 \mathbb P(E\otimes L\oplus\mathcal O)
 \simeq\mathbb P(E\oplus L^{-1})
\]
does not identify it with \(\mathbb P(E\oplus\mathcal O)\) in
general. The old retired `R_LOC_CAMPAIGN` and the current retired
`HIST_TWIST_IDENTIFICATION` explicitly retain this obstruction.
The report's first-differing-ample-degree uniqueness proof applies
unchanged in this positive filtration.

## Limits and obligations

This unit supports the integral/completion foundation and the removal
of positivity, **not an independent proof of common-\(R\) geometry**.
`C_LOC_ARBITRARY` inherits the normalization/gluing, two-point,
ancestor-conversion and all-genus obligations assessed in the common-R
unit, together with the external inputs recorded on current `OLD_LOC`.
The source propositions have been independently read; their application
is still mathematical prose. No Lean definition of these spaces,
integral curve groups or effective monoids exists in the supplied
formalization. The bounded \(B=\mathrm{pt}\) calculation cannot test
base classes, torsion, negative \(l\), or arbitrary-bundle geometry.

No concrete missing mathematical step was found in the completion
argument. Final independent review must examine its inheritance from
the common-R proof and its effective integral coefficient conventions.
An unresolved downstream theorem is not a reason to discard this
bounded assessment, nor does the assessment settle such a theorem.
