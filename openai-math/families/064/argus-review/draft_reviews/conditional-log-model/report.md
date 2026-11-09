# Conditional preservation and the parent log-model proposition

**Assessment:** the preservation implication has the supported scope already
recognized by the old independent reviewer. The unconditional parent
`C_LOG_MODEL_064` remains unresolved because its existence input is not
established by the listed work. These are different conclusions.

## Claims, source and exact target

This unit covers `C_MMP_PRESERVATION_064` version 1 and
`C_LOG_MODEL_064` version 1. The decisive source is
`model_derivation.md:203-266`, read with its explicit input at 164-202.
It was compared with the full statement and proof of
`prop:log-model`, `build/sections/06-model.tex`, revision
`4eaee87548250b2682affda7d05d947c05554bae`. Sources and old claim hashes
match the preserved records.

The parent proposition has the literal flat projective normal Gorenstein
surface-family/total-space and singular-section hypotheses. After the
allowed shrinking and finite smooth-curve cover it asks for a projective
birational \(Y\to X\), normal Q-factorial and unchanged off the section;
**every** scheme fiber reduced Cartier and \((Y,H+Y_c)\) dlt;
\(K_Y+H\) nef over \(X\); all vertical exceptional primes over \(0\);
normal integral noncentral fibers with reduced horizontal restriction;
and exactly one central component dominating \(X_0\), with the others
projective over its section point. Here \(H\) is the **full** reduced
surviving horizontal exceptional boundary, not a convenient subset.
No mu-constant hypothesis occurs.

The preservation statement assumes the smooth marked semistable input and
the exact finite, divisor-nonextracting relative MMP formulated in the
separate attribution unit. It proves an implication conditional on these
inputs. It does not produce the input theorem.

## Decisive preservation arguments checked

For an arbitrary remaining \(c\), a local curve parameter defines the fiber
Cartier divisor. On a curve contracted over \(X\), this pullback has degree
zero. The same fixed \((K+H)\)-negative steps are therefore
\((K+H+V_c)\)-negative. Starting from the SNC augmented pair, the stipulated
dlt discrepancy-preservation input applies for each \(c\).
No interchange of a generic quantifier with "every" is needed: the
sequence is fixed and \(c\) is arbitrary.

No step extracts divisors. A divisor on a later model comes from a divisor
on \(V\), and the valuation of the rational curve parameter is unchanged.
Every surviving fiber component therefore still has order one. On an
integral normal model the parameter is a nonzerodivisor, so its fiber is
Cartier. This gives a reduced *scheme*, not only a reduced divisor cycle:
if \(u^n\in(t)\), at a height-one prime with \(v(t)=1\) one has
\(v(u)\geq1\), and elsewhere \(v(u/t)\geq0\). The normal-domain
intersection over height-one valuation rings gives \(u/t\) regular.
Thus \((t)\) is radical and the preserved boundary fiber is the actual
scheme fiber.

Surviving horizontal exceptional divisors keep coefficient one. A
nonexceptional divisor cannot acquire a lower-dimensional image under
maps over the same \(X\); conversely a final divisor was already present
on \(V\). Hence the boundary is exactly the full surviving horizontal
exceptional boundary. Vertical exceptional divisors remain over \(0\).
The sequence restricts to the identity off the section, where the initial
map is an isomorphism and has no relative curves.

If a Mori fiber space over \(X\) occurred, its lower-dimensional base
would factor a dominant birational map to the threefold \(X\).
The dimension inequality makes this impossible. Under the assumed
termination alternative the output is therefore nef over \(X\), not
merely nef relative to the curve.

For \(c\ne0\), any extra fiber component would be a vertical exceptional
prime, already excluded. The sole component is the strict transform of
the integral \(X_c\); it is reduced by the valuation argument and normal
as a coefficient-one component of the dlt pair. At a generic curve of
\(H\cap Y_c\), the coefficient-one components meet SNC. Restriction has
coefficient one, and two horizontal components cannot yield the same
generic curve, which would violate that SNC condition. Thus
\(H|_{Y_c}\) is reduced as a Weil divisor.

A proper birational morphism to the normal \(X\) is an isomorphism over
the generic codimension-one point of \(X_0\). Exactly one divisor on \(Y\)
dominates it. Other central components are exceptional; their image is
the section point, and projectivity of the morphism makes them projective
surfaces over that point.

These steps account for every clause, the scheme-theoretic fiber and the
full marking. They are the substantive reason for supporting the
conditional implication rather than simply trusting a status label.

## What remains open

Supported resolution and universal marked reduction provide the preparatory
route with its explicit resolution premise. The exact relative MMP
existence/application and its Kollár--Mori proposition-level attribution
remain outstanding. None of the preservation arguments closes that gap.
This review finds neither a proof nor a refutation of the parent
proposition from the listed work. Turning this implication into an
unconditional theorem would be a further result, not a review edit.

The independent old evidence is
`judgement-C_MMP_PRESERVATION_064-855e6ad959cd` (`supports`) and
`judgement-C_LOG_MODEL_064-4b3bdaa175a3` (`inconclusive`).
Both bind the unchanged source/claim and are reused in exactly those
scopes. The empty dependency list for the old preservation graph node
does not remove the premise written into its statement.

This is an expanded reconstruction/conditional analysis of the reference
manuscript, not an original MMP theorem, a counterexample, or a refuted
Argus attack. No novelty is established. Tools were direct source and
dependency comparison and mathematical reading; the local determinant
replay is not evidence for these geometric implications. There is no
Lean formalization or compiler run. The numerical, resolution-lifting and
complementary branches toward the main theorem were unworked in the
inventory and are not reopened or declared complete here.
