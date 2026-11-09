# Supported resolution and base change

**Assessment:** the preparation argument is supported *conditional on its
explicit supported-resolution input and marked reduction*. It is not an
unconditional resolution theorem, and the old ledger supplies no separate
independent supporting judgement for this claim.

## Versions, hypotheses and attribution

`C_RESOLUTION_BASECHANGE_064` versions 1 and 2 have the same statement hash
`396299931cd8bbcd9fbbe2e4d52dfbe9b7a0991c38d995627e9f8e272646323f`.
Version 1 already says "Assuming characteristic-zero supported projective
log resolution/principalization"; version 2 explicitly records
`A_SUPPORTED_RESOLUTION_064`. The added assumption is not evidence that an
unconditional version was proved, and the two records are not two results.

The source is `model_derivation.md:164-202`, compared with the preparation
in the proof of `prop:log-model`, `build/sections/06-model.tex`, at revision
`4eaee87548250b2682affda7d05d947c05554bae`.

The target is a flat projective family of integral normal Gorenstein surfaces
over a smooth connected complex curve. Its total space is normal
Gorenstein; a section contains every fiber singularity, and the morphism is
smooth off the section. Shrinking around \(0\) and finite smooth-curve base
change are allowed. No mu-constancy, log-canonicity of the target, or
assumption about the manuscript's later numerical invariant is added.

The external premise is a projective characteristic-zero log
resolution/principalization resolving the section ideal and central fiber,
supported away from the already resolved complement. The old draft
attributes this to resolution in the sense of Hironaka without an inspected
exact primary proposition. That source-only premise was recorded in the
active review ledger before this assessment and is not silently discharged.

## Decisive reasoning checked

Under that premise, the section ideal has divisorial inverse-image support,
and the exceptional support together with the central support is SNC.
Outside the section the target and central fiber are already smooth, which
is why a *supported* theorem, not an arbitrary resolution, is required.
There are finitely many exceptional divisors and strata. Characteristic-zero
generic smoothness, followed by deletion of their finitely many bad values
other than \(0\), makes the dominating strata relatively smooth and puts
all vertical exceptional divisors over \(0\). This is a simultaneous
shrinking for a finite set of strata, not a generic-fiber assertion falsely
relabelled as an every-parameter assertion.

Take the root cover with exponent divisible by every central multiplicity.
Locally the target's pullback is
\(A[s]/(s^b-\tau)\). The polynomial is a monic nonzerodivisor in the
Gorenstein polynomial ring, so its quotient is Gorenstein and hence S2.
Off the pulled-back section the morphism is smooth over the new smooth
curve. The section has codimension two; thus every codimension-one point
is regular and Serre's R1+S2 criterion gives normality. In particular it
would be wrong to assume that *arbitrary* ramified pullbacks preserve
normality without this argument.

The fibers over complex points remain the original integral surfaces.
Flatness excludes vertical irreducible components, and geometric
integrality of the fibers in this proper family gives an integral generic
fiber after the finite curve cover. Equivalently, on the now normal
projective total space, distinct dominating components would be disjoint
and give disconnected general fibers. Connectedness of the covering curve
and integral fibers therefore give one integral total space. The argument
does not require the pulled-back total space to have been smooth at the
section.

Apply the global marked reduction to the resolved source with its full
reduced horizontal exceptional marking. The cover is etale away from
\(0\), and the construction modifies only the special fiber; the already
smooth complement of the section stays unchanged. New exceptional
divisors are vertical, so the horizontal marking is exactly the transform
of the old one. The result is a projective birational smooth \(V\to X\)
with \((V,H_V+V_c)\) SNC at **every remaining** \(c\), and all vertical
exceptional primes over \(0\).

## Concrete outstanding input and result classification

What is not supplied is a primary-source or self-contained proof of the
supported resolution/principalization theorem in exactly this form.
Its required support and ideal-principalization conditions are concrete;
mere access failure is not a refutation. Conditional on it, the displayed
base-change and shrinking reasoning supplies the claimed preparation.
This assessment neither asserts that the external theorem is false nor
uses the local toric certificate to certify its hypotheses.

This is a reconstruction of the manuscript's preparation, not a new
resolution result or a failed counterexample. No novelty or priority has
been established. Tools were direct mathematical reading and source/hash
comparison. No Lean formalization is present, and no compiler or geometric
existence computation was run. Relative MMP existence and the main theorem
remain separate open matters.
