# Statement fidelity: complete three-layer rectification

The principal declaration is `ThreeLayer.complete_rectification`, whose
conclusion is `ThreeLayer.RectificationCertificate`. It universally
verifies the complete output of `lem:rectification` in the staged
September 23, 2026 manuscript, in a presentation-based encoding of
bimodule complexes. It does not formalize the Verdier quotient,
`prop:lifted-diagram`, the tensor-realization theorem, or the manuscript's
main finitistic-dimension theorem.

## Objects and quantifiers

`K` is an arbitrary field. `R` in the Lean source is an arbitrary,
possibly noncommutative, `K`-algebra acting on the module side; it is
**not** the manuscript's finitely presented algebra named R.
For the literal manuscript lemma specialize Lean's `R` to
`B` opposite. Left `R`-linear maps are then exactly right `B`-linear
maps. The scalar-tower and commuting-scalar instances express the
ordinary central field action on those modules, not commutativity of B.

`AI`, `BI`, and `RI` are arbitrary finite types, including empty types.
They index arrows 0->1, arrows 1->2, and a relation basis. The
`Diagram.j` linear map sends a relation-coordinate vector to its
coefficients in the free length-two path space `(BI x AI)->K`.
`Diagram.independent` says exactly that this relation list is linearly
independent. The associated quiver algebra is `KQ/(range j)`.
There are no arrows of another shape and no additional relations.

`Diagram` contains arbitrary module differentials, first-arrow maps
`f`, second-arrow maps `g`, and relation homotopies `h`. Its hypotheses
are square-zero differentials, chain-map identities, and, for every
relation and every module element, precisely

```text
d2 (h r x) + h r (d0 x)
  = sum b,a, j(single r 1)(b,a) * g b (f a x).
```

In particular neither `h=0` nor a strictly zero relation composite is
assumed. Neither Toda vanishing, stable flatness, nor higher coherence
is assumed.

`InputGrading` specifies the degree-n submodules `g0 n`, `g1 n`,
`g2 n`. The differentials raise degree by one, f and g preserve it,
and h lowers it by one. An ordinary bounded complex is encoded by the
direct sum of its degree modules, with these submodules the summands.
Conversely the restrictions to these submodules are cochain complexes.
The formalization checks the graded module equations directly; it does
not use Mathlib's `CochainComplex` wrapper.

`complete_rectification` assumes each input degree module projective
over `R` and finite-dimensional over `K`, and common integer support
bounds `[a,b]`. These follow from the manuscript hypotheses: B is
finite-dimensional, the terms are finitely generated projectives,
and there are three bounded complexes. `finite_over_finite_algebra`
verifies the restriction-of-scalars finiteness implication. Common
bounds are obtained by taking the minimum and maximum of the three
input bounds.

## Construction and the relation quotient

`relation_split` proves that an injective relation map over a field
has a linear left inverse. `extend_comp`, `extend_split`, and
`extend_natural` prove that scalar extension to finite copies of
arbitrary right modules preserves this splitting and commutes with
their differentials. Thus the split maps used in `System` are
**derived** in `assembledSystem`, not extra hypotheses of the
principal theorem.

Write `U=(BI x AI)->M0`, `T=RI->M0`, `V=BI->M1`.
`W` is the kernel of the extended relation retraction. The map
`quotientProjection` identifies this complement with the length-two
path quotient with module coefficients:
`projection_surjective` and `projection_kernel` prove surjectivity
and kernel exactly the relation image. This is a complement model of
the manuscript's quotient, not a replacement by the free path space.

At vertex 0 the output is unchanged. At vertex 1 the coordinates are
`(y,x,u)` in `M1, AI->M0, (AI->M0)[1]`. At vertex 2 they are
`(y,v,w,u,z,t)` in `M2,V,W,U[1],V[1],T[2]`. `delta1` and `delta`
are the manuscript's differential in these coordinates, including
the positive `h` entry and alternating diagonal signs. The output
degree-n module `FullTerm` is the product of the three vertex terms;
a finite product is also their direct sum. Its support is contained
in `[a-2,b]`.

## Both actions and every comparison

The left action is encoded by its generators, not by a Mathlib
`PathAlgebra` instance. `leftE0`, `leftE1`, `leftE2`, `leftA`, and
`leftB` are actual `R`-linear endomorphisms of `Full`.
`left_unit`, `left_vertex_rules`, and `left_arrow_endpoints` verify
the complete orthogonal vertex idempotents and the arrow sources
and targets. `full_strict_relations` verifies every quadratic
relation. These are precisely a unital representation of
`KQ/(range j)`: linear extension on paths factors through the
relation quotient. Since every generator is `R`-linear, this left
action commutes with the right module action. The theorem checks
that all generators commute with the differential and preserve
the grading. This presentation-to-module interpretation, like the
direct-sum encoding above, is the statement-fidelity translation
to be checked by the independent reader; no claim is made that
Mathlib generated a `Module B` instance.

`RectificationCertificate` includes the differential square, degree,
finite-dimensionality, right projectivity, boundedness, left
action laws, all strict relations, both nontrivial vertex homotopy
equivalences with degree-correct witnesses, and both families of
degree -1 arrow homotopies. Vertex 0 has the identity equivalence.
The witnesses are actual linear maps via `deltaMap`, `inclMap`,
`retractMap`, `contractMap`, their vertex-1 counterparts,
`actAMap`, `actBMap`, `homAMap`, and `homBMap`.
`complete_rectification` constructs every field, not just the
differential-square field.

The explicit second-vertex retraction and contraction additionally
satisfy `contraction_square`, `retraction_contraction`, and
`contraction_inclusion`. The vertex equivalences themselves do not
need input projectivity or boundedness: the algebraic identities
hold for arbitrary graded modules. Those hypotheses are used to
obtain the manuscript's finite, bounded, right-projective output.

## What remains outside the compiler

The compiler establishes the encoded assertions, not the correctness
of this translation or any claim of novelty. Independent review must
check the two presentation interpretations, the relation-basis
hypothesis, the nonzero-homotopy sign, and the specialization of the
right acting ring to B opposite. No independent review, publication
significance, or verification of the surrounding manuscript is
claimed by this document.
