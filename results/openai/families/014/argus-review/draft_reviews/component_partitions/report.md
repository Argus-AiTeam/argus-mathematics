# Component partitions on a tame proper trait

**Assessment: supported written lemma on its stated base.** This is
`L_ABG_COMPONENT_ORBITS@1`, the component fact in old `theorem.md`
Section 6. It is not a generic-field comparison theorem.

## Exact statement and hypotheses

Let \(\mathcal Y/S\) be a proper flat tame root/nodal DM curve over a
complete strictly henselian DVR, with finite diagonal, projective coarse
space, and geometrically reduced fibers. Let
\(\mathcal T\to\mathcal Y\) be a representable finite etale torsor.
Along a section in the smooth scheme locus, trivialize its finite fiber.
The partitions of that same framed fiber into connected components on
the **geometric** special and generic fibers agree. The whole torsor need
not be connected.

## Decisive argument and inputs

Proper henselian invariance lifts each open-and-closed special summand to
a summand \(\mathcal Z\). This uses `A_RYDH_PROPER`: Rydh,
*Compactification of stacks and extending stackiness across the boundary*,
2014-09-16, Theorem 4.5, pp.11-12, for proper stacks with finite diagonal.
Finite etale representable pullback retains tame stabilizers. In the
root/node quotient charts, averaging over their invertible orders makes
invariants exact, so the coarse space \(Z\) is proper and flat with
fiberwise coarse formation and reduced geometric fibers. Its coarse map
to the given projective coarse curve is finite, hence it is projective.

For a connected geometric special summand,
\(H^0(Z_s,\mathcal O)=k(s)\), using properness and reducedness.
Writing \(R\) for the DVR and \(\varpi\) for its uniformizer, proper
coherence makes \(M=H^0(Z,\mathcal O)\) a finite \(R\)-module. Flatness
and the reduction exact sequence give
\[
 M/\varpi M\hookrightarrow H^0(Z_s,\mathcal O)=k(s).
\]
The image contains 1. Nakayama gives \(M=R\cdot1\), and flatness and
the nonempty fiber make \(R\to M\) injective. Flat base change to the
geometric generic field gives \(H^0(Z_{\bar\eta},\mathcal O)=\bar K\).
There are no nontrivial idempotents, so that geometric generic summand is
connected. Each special summand therefore contributes exactly one generic
summand; the fixed section identifies their fiber subsets.

The finiteness and flat-base-change inputs are `A_PROPER_COHOMOLOGY`:
Stacks Project `coherent.tex`,
`lemma-proper-over-affine-cohomology-finite` and
`lemma-flat-base-change-cohomology`, primary reading dated 2026-11-05.
Properness over the noetherian DVR, coherence, and flat field extension
are the hypotheses actually used. This proof does not assume the entire
torsor is connected, and it does not infer a full specialization
isomorphism of fundamental groups.

## Attribution, evidence, and limitation

The old independent support is
`judgement-L_ABG_COMPONENT_ORBITS-03aea65d72f9`; the author receipt is
`...-2195a8533118`. The two relevant independent source readings are
`judgement-A_RYDH_PROPER-f4ec4daf5e32` and
`judgement-A_PROPER_COHOMOLOGY-e56c071b69d8`.
They are inherited opinions/readings with their original attribution,
not a new Reviewer decision.

The several-point manuscript's `con:parameter` proof already uses a
connected-torsor version of this component/density mechanism over its
characteristic-zero smoothing trait. The old draft's summand argument
handles disconnected torsors arising after enlarging the compact structure
group. No literature priority is established by that comparison.

No archived computation or Lean compiler verifies this universal geometric
lemma. The [finite replay](../computation/replay.json) is not evidence for
its cohomological step. Its supported scope is exactly the proper flat
tame trait above; applying it over \(W(\bar k_0)\) does not discharge
[F1](../arithmetic_tower_lift/report.md) over the claimed \(\bar D\)-fiber.
Native independent review remains pending.
