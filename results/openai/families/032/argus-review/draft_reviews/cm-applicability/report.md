# CM ordinary-geometric applicability assessment

**Unit:** `cm-applicability`. **Engineer assessment:** the submitted
ordinary-CM-to-formal-hypotheses argument and the source-level interpretation
are supported within the foundations stated below. This is a prose and
statement-reading assessment, not a successful Lean elaboration, an axiom
audit, or current independent acceptance. The Host Reviewer must judge it.

## Source, version, attribution, and exact assertion

The assessed Argus draft is Campaign 9000032's November 5, 2026
`research/cm_dependency_audit/report.tex`, Sections 2--4, and its
`lean/statement_fidelity.md`. Its ledger claim is `CM-APPLICABILITY` v1.
The same report also contains separate kernel and conditional-consequence
obligations; neither is counted again here.

Let `OLD` be
`campaigns/9000032` and let `U`
be `OLD/research/cm_dependency_audit/upstream/lean/OAI/AlgebraicGeometry`.
The imported work is OpenAI's source at recorded commit
`4eaee87548250b2682affda7d05d947c05554bae`, specifically
`HodgeConjecture/MainSolution.lean`. Its named declaration is
`OAI.AlgebraicGeometry.HodgeConjecture.MainSolution.hodge_conjecture_for_cm_abelian_varieties`.
The declared environment is Lean **4.34.1** and Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`, not the host's different
4.31.0 workspace.

The fresh, read-only source preflight in
`../cm-kernel/replay_probe.json` checked all **33,168 local module source
digests and actual import lists**, including exact closure and acyclicity.
That establishes consistency with the existing pinned source manifest; it
does not check their proofs or independently reconstruct upstream history.
The preserved snapshot lists the old fidelity document and checker, but
not the CM TeX report or a completed replay wrapper. Its omission is not
silently replaced by an invented snapshot hash.

The exact source-written type, with the scoped Hodge notation expanded, is:

```text
X : Over (Spec C)
[IsIntegral X.left] [Smooth X.hom]
[ProjectiveSpaceIs.IsProjective X.hom] [GrpObj X]
hCM : Definitions.HasComplexMultiplication X
p : Nat
------------------------------------------------------------
hodgeClasses Q X p <= algebraicCycleClassSpan X p
```

This is a reading of the source, **not compiler-produced elaborated output**.
There is no dimension bound, simplicity assumption, principal-polarization
requirement, or restriction to divisors. The conclusion concerns degree
`2*p` for every natural `p`, including zero. The particular input needed by
DS is every ordinary CM source, including a point, not just CM sources in
dimension at most six.

## 1. Ordinary CM really supplies the explicit input

An ordinary complex abelian variety has an integral smooth projective
scheme over `Spec C` and an actual scheme-theoretic group law.
`Foundations/ProjectiveSpaceIs.lean` defines `IsProjective` by a closed
immersion into a finite-dimensional projective space over the base,
together with the structure-map equality. It is not a predicate saying
that some cohomology happens to be projective. Thus an ordinary projective
embedding supplies this hypothesis.

`ComplexMultiplication/Definitions.lean` defines `HasComplexMultiplication`
as `Nonempty (CMH1Data X)`. The data consist of a finite list of CM number
fields, a rational linear isomorphism
\[
H^1(X,\mathbb Q)\simeq\prod_i K_i,
\]
and preservation of geometric `F^1` by **every** transported coordinatewise
multiplication after applying `h1Comparison`. Higher-degree cycle classes
and their algebraicity do not occur in these data.

Here is the decisive ordinary mathematical argument, with an adjoint
invariance detail made explicit. Let the actual Hodge group of the
polarizable weight-one structure be a torus. Its rational representation
is semisimple. On an irreducible rational summand \(V\), the commutative
representation algebra has a faithful simple quotient \(K\), a number
field. A nonzero vector generates \(V\) as a \(K\)-module, so
\(\dim_K V=1\). This is a statement about a simple module for a
commutative semisimple algebra, not an assumption that all original
isogeny factors are distinct.

The polarization restricted to this Hodge summand is nondegenerate.
Its adjoint preserves \(K\): the Hodge circle preserves the polarization,
so adjoint is inversion on that circle; rational Hodge-group minimality
extends the same algebraic identity to the torus and its representation
algebra. The restricted involution is positive. The Albert-field
alternative is therefore totally real with trivial involution or CM with
complex conjugation. In the totally real alternative, the Hodge complex
structure is a \(K\)-linear endomorphism of the rank-one real module, hence
an element of \(K\otimes_{\mathbb Q}\mathbb R\). It would square to
\(-1\) in a product of copies of \(\mathbb R\), which is impossible.
Thus each \(K\) is CM.

Taking all summands, with repetitions, gives precisely the required
finite product. Its coordinate actions are rational Hodge maps and
preserve the actual complexified `F^1`. Repeated fields are permitted by
`CMH1Data`; no Galois assumption is inserted. For a point, `H^1=0` and
the empty product gives `factors=0`. This proves the claimed direction of
applicability without assuming any CM Hodge-conjecture conclusion.

The structural external inputs are the same ALBERT and HODGE-GROUP
propositions used in the reviewed actual-group result:
`isbn:9780821844762`, Sections 10.12--10.14, pp. 527--528; and
`arxiv:math/9901113v2`, Sections (1.2)--(1.3). Their historical independent
attribution records and exact scope are detailed in
`../actual-group/report.md`. Polarizability, weight-one semisimplicity,
and the ordinary analytic comparison facts used below are explicit
foundations, not new results established by this review.

## 2. The Hodge predicate is about the ordinary coefficient comparison

The source definitions inspected are:

| Source under `U` | Decisive definition or statement |
|---|---|
| `ComplexPoint/Basic.lean` | `Point R X` is an actual morphism over `Spec R`; affine regular-function evaluation describes the analytic topology. |
| `Hodge/AnalyticDifferentialForms.lean` | Holomorphic functions are analytic functions on the complex charts; `chartEvaluation`, `chartEvaluationKernel`, and `HolomorphicForm` use their actual derivatives. |
| `Hodge/HolomorphicDeRham.lean` | Sheafification of these forms and the exterior derivative; constants map to holomorphic zero-forms. |
| `Hodge/Filtration.lean:729-957` | Coefficient inclusion, form-degree truncation, conjugation, and `hodgeClasses`. |
| `ComplexMultiplication/CMComparisonTo.lean` | `h1Comparison_tmul`, complex linearity, and rational-coefficient injectivity. |

This is not an arbitrary abstract Hodge filtration. The forms are algebraic
Kahler forms of holomorphic functions modulo the **intersection of the
kernels of their coordinate derivative evaluations**. Locally, ordinary
holomorphic forms are sums of \(f_I\,dz_{i_1}\wedge\cdots\wedge dz_{i_p}\).
The coordinate functions and their holomorphic coefficients are present,
so evaluation is locally surjective onto ordinary holomorphic forms.
Quotienting by its full kernel makes it injective onto that image.
Sheafification therefore yields the ordinary holomorphic form sheaf;
the displayed exterior derivative has its ordinary local formula.
This local argument is the substantive reason for the interpretation,
not the module names or comments alone.

`fieldToDeRhamCohomologyLinear` is induced by the actual coefficient
inclusion into the constant complex sheaf, followed by its map into the
holomorphic de Rham complex. In degree \(2p\), `hodgeClasses` is
\[
c_{\mathbb Q}^{-1}\bigl(F^p\cap\overline{F^p}\bigr).
\]
The filtration is the image on hypercohomology of the stupid truncation
in **form degrees at least \(p\)**. Conjugation is transported from
conjugation of constant complex coefficients, not chosen freely on a
vector space. Under ordinary smooth-projective de Rham/Hodge comparison,
this is exactly the rational \((p,p)\) space.

For `h1Comparison`, the actual pure-tensor formula is
\[
c\otimes v\longmapsto c\,c_{\mathbb Q}(v).
\]
Although its initial bundled type is rational-linear, the inspected source
proves its complex linearity. The rational-linear retraction
\(\mathbb C\to\mathbb Q\) in `CMComparisonTo` acts on **constant additive
coefficient sheaves**. It is not asserted continuous for the usual
topologies of these fields, and it is not used as a holomorphic function.
This is a valid split-inclusion argument for coefficient injectivity.

## 3. Cycle spans and geometric bridges

`Cycle/FundamentalClass.lean` indexes components by actual generic scheme
points of coheight \(p\), takes their reduced closures, constructs the
complex-oriented supported class on the smooth locus, extends it across
the singular boundary, and forgets support. For a smooth finite-type
complex variety these are the ordinary codimension-\(p\) integral
subvarieties and their rational fundamental classes.

`Reference/CycleClassMap.lean` identifies the supremum of the
one-generator spans with the range of `Finsupp.linearCombination` on
these **same** components. It is a finite rational algebraic cycle span,
not an arbitrarily selected subspace or a definition equating cycles with
Hodge classes. Ordinary passage from cycles to rational Chow classes does
not change the image of the cycle-class map.

The native/original comparisons inspected retain the relevant geometry:

* `BundledAbelianBridge` changes a projective presentation but retains
  the scheme, base map and group law; its `toOver` equalities are `rfl`.
* `PointBettiBridge.complexPointSpaceIso` is the identity on the same
  points, with continuity in both directions and naturality for the
  actual scheme maps.
* `Reference/RationalCoefficientComparison.lean` proves compatibility
  with the **actual rational-to-complex coefficient inclusion**.
  `Reference/RationalHodgePurity.lean` transports the actual filtration;
  taking its first filtration condition is sufficient for a rational
  class, whose conjugate coefficient class is itself.
* `Reference/CMDecomposition.lean` transports the field model and its
  Hodge actions; `originalCMInput_hasCMH1` adds no cycle-class premise.
* `Reference/DimensionCycleSupports.lean` gives a bijection of precisely
  the same reduced supports, with unchanged schemes and immersions.

The normalization comparison is also adequate for the **rational**
conclusion. Put \(n_D\) for the transported native component and \(c_D\)
for the original one. `Reference.ComponentComparison` states
\[
q_p n_D=c_D,\qquad
q_p=\texttt{normalCoclassCoefficient}\ p\in\mathbb Q^\times.
\]
`NormalCoclassComparison` obtains \(q_p\) from the two actual generators
of the one-dimensional rational normal relative-cohomology group. Its
nonvanishing follows because the original normal coclass pairs to 1
with its orientation class. `IntrinsicCycleSpan` multiplies by
\(q_p^{-1}\), so finite rational spans agree. No value \(q_p=1\),
integral normalization equality, or invertibility of a potentially zero
class is assumed. The argument includes codimension zero.

Finally, `Reference/GeometricAlgebraicity.lean` applies the native CM
result to the transported actual Hodge class and returns a finite
cycle. `MainSolution` uses the just-described component comparison and
span transport. The source-level final implication is correctly routed.

## Supported scope and concrete remaining obligations

There is no concrete contradiction in the submitted ordinary-CM
applicability argument after its foundations and these specific maps are
made explicit. This is neither a proof that every imported declaration is
valid nor a statement that the surrounding manuscript is correct.

The outstanding obligations are precise. The target's **elaborated**
statement and transitive axiom report have not been obtained; the source
proofs of the coefficient/filtered-form/purity and supported-class bridge
chain have no completed pinned kernel replay in the supplied evidence.
An independent reader must judge the ordinary comparison and orientation
interpretations, rather than inheriting them from a successful import or
an equality of vector-space dimensions. The current ledger explicitly
records the ordinary comparison foundations as an uncited standard input;
it does not invent an external proposition locator.

The old fidelity document describes `CMDependencyAudit.cm_input_kernel`
in `Main.lean`, but **that file and its native evidence record are absent**.
It is a description of an intended replay, not an extant checked local
theorem. The source theorem itself is present. This distinction belongs to
the kernel unit, not to an alleged counterexample to ordinary CM
applicability.

The strongest prior result remains DS's all-degree supply-and-Hodge-lift
theorem. This review clarifies the exact remaining CM input; it neither
improves that theorem by a larger finite test nor discharges the input.
Attribution is an old Argus prose argument about an imported OpenAI result,
not a new proof of CM algebraicity or a checked novelty claim.
