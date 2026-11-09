# Locally-klt-type extension

**Assessment:** the extension's decisive comparison is valid, conditional
on the shared analytic inputs and foundational results identified in the
toroidal-volume unit. It is a proposed strengthening in the old draft,
not a theorem whose originality this review establishes.

## Exact quantified claim and provenance

Old report section 6, Theorem A, and `C_TV_KLT_TYPE` v1 make the
following change to G `g:toroidal-volume`, September 26, 2026 revision
`4eaee87548250b2682affda7d05d947c05554bae`. For **every** normal
integral \(W\), projective birational \(p:W\to X\) and projective
surjective equidimensional \(f:W\to Y\), drop toroidality and instead
require that **each point** of \(W\) has a neighborhood with an
effective rational boundary \(\Delta\), \(K_W+\Delta\) rationally
Cartier, and \((W,\Delta)\) klt. No single global boundary is required.

Retain smooth connected projective complex \(X,Y\), \(\dim Y>0\),
a smooth semipositive metric on \(-K_X\), a smooth projective
resolution, and the **full** generic adjoint rank one at exponent
zero. Use exactly the same finite-branch formula
\[
 a_Q=\max(0,\min_{E\to Q}(1+a_E)/e_E-1).
\]
All correction, semipositivity, smooth-open and unweighted
integrability conclusions are retained. The ordinary-open strictness
conclusion still requires the separate horizontal-curvature patch
away from the Jacobian divisor. This is not a claim about arbitrary
normal sources, invariant rank alone, or a method for constructing
the model.

## Decisive argument

The correction calculation needs normality, birationality to smooth
\(X\), and equidimensionality, not toroidality. In particular it still
gives finite exceptional correction, \(\Theta_0\leq0\), and
\[
 K_W+\Theta_0=p^*K_X+f^*A_0
\]
rationally Cartier. On one of the stipulated neighborhoods,
\[
 B=\Delta-\Theta_0=(K_W+\Delta)-(K_W+\Theta_0)
\]
is effective rational Cartier. For **every** centered divisorial
valuation whose center is in that neighborhood,
\[
 A_{W,\Theta_0}(v)=A_{W,\Delta}(v)+v(B)>0.
\]
The first term is strictly positive by the actual klt hypothesis;
the second is nonnegative by effectivity and Cartierness. No
full-support or toroidal valuation reduction is needed here.
Taking a neighborhood of a point of the center handles any
divisorial valuation; incompatible choices of local boundaries do
not affect the globally specified pair \((W,\Theta_0)\).

This supplies precisely the exponents greater than \(-1\) needed
for the log-resolution/proper-pushforward integrability argument.
The entire adjoint-line identification, Berndtsson positivity and
patch strictness, generic transverse map at a branch over a divisor,
and psh removability in the shared volume unit do not use
toroidality of \(f\). The transverse map uses characteristic-zero
generic smoothness of \(E\to Q\) at general smooth points, still
available here. Thus the proof does not silently reuse a toroidal
step after deleting its hypothesis.

## Does this include the old source class?

Yes, locally. On a rational strongly convex toric cone choose a
rational functional positive on every ray and scale it so its ray
values lie strictly between zero and one. For primitive rays \(u_j\),
\[
 \Delta=\sum_j(1-\langle m,u_j\rangle)D_j
\]
is effective and \(K_W+\Delta=-\operatorname{div}(\chi^m)\) is
rationally Cartier; denominators are cleared in interpreting
\(\chi^m\). The divisor
\(D_W-\Delta=\operatorname{div}(\chi^m)\) has full boundary support.
The logarithmic all-valuation calculation from the volume unit
gives \(A_{W,D_W}\geq0\); adding this full-support Cartier divisor
gives positive discrepancies. A chart with no rays is smooth.
The construction and the klt property pass through the local
toroidal charts. This is a local boundary construction, not an
assertion that the choices glue globally.

The special case of normal rationally Gorenstein klt \(W\) takes
\(\Delta=0\). Neither this special case nor the argument asserts that
every modification of a smooth variety is itself klt or locally of
klt type.

## Scope, attribution, and outstanding questions

The old claim has only v1. Its novelty was explicitly unverified in
the old draft and remains so: the comparison is classical discrepancy
monotonicity, and neither the inspected Kim precedent nor this
review establishes priority for this exact metric extension.
The shared Lean theorem `klt_type_monotonicity` proves a conditional
sign implication on rational-valued functions; it does not construct
\(\Delta\), discrepancies, or the analytic metric.

No gap was identified in the extension under its explicit hypotheses.
Foundational log resolution and the shared analytic inputs remain
external. The concrete obligations for an application are to
produce the locally-klt-type source and equidimensional morphism,
verify full generic rank, and, for strictness, verify the patch.
Those are assumptions of Theorem A, not consequences it supplies.
Removing any of them is not supported. Determining novelty or
proving unrelated family targets is outside this review.
Native independent acceptance remains pending.
