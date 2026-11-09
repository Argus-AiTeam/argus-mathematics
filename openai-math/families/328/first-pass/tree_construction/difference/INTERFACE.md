# Original-norm difference-subspace transport

Import `DifferenceSpace`; all new declarations are in `TreeConstruction`.
The source imports the attributed `Producer` without changing it.

Throughout, assume `{X : Type u} [NormedAddCommGroup X] [NormedSpace ℝ X]`,
`{K : Set X}`, and open `OAI.ReflexiveFixedPoints`, `Filter`, `Topology`,
`BigOperators`, and `Pointwise` where necessary.
`DifferenceSpace K` is definitionally `↥(differenceSpan K)` with its inherited
norm. No norm or topology on the original normed spaces is replaced.

## Translation, original norms, and nonlinear conjugation

```lean
shiftedSet (K : Set X) (a : K) : Set (DifferenceSpace K)
-- Definition: {y | (y : X) + (a : X) ∈ K}

shiftPoint (a : K) (x : K) : DifferenceSpace K
shiftPoint_coe (a x : K) :
  (shiftPoint a x : X) = (x : X) - (a : X)

shiftEquiv (a : K) : K ≃ shiftedSet K a
shiftEquiv_coe (a x : K) :
  (shiftEquiv a x : DifferenceSpace K) = shiftPoint a x
shiftEquiv_symm_coe (a : K) (y : shiftedSet K a) :
  ((shiftEquiv a).symm y : X) =
    ((y : DifferenceSpace K) : X) + (a : X)

shiftEquiv_norm_sub (a x y : K) :
  ‖(shiftEquiv a x : DifferenceSpace K) -
    (shiftEquiv a y : DifferenceSpace K)‖ = ‖(x : X) - (y : X)‖

shiftIsometryEquiv (a : K) : K ≃ᵢ shiftedSet K a
shiftHomeomorph (a : K) : K ≃ₜ shiftedSet K a
continuous_shiftPoint (a : K) : Continuous (shiftPoint a)
shiftedSet_convex (hK : Convex ℝ K) (a : K) :
  Convex ℝ (shiftedSet K a)

convexAverage {ι : Type v} (hK : Convex ℝ K) (s : Finset ι)
  (w : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i)
  (hw1 : ∑ i ∈ s, w i = 1) (x : ι → K) : K

shiftEquiv_convexAverage_val {ι : Type v} (hK : Convex ℝ K) (a : K)
  (s : Finset ι) (w : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i)
  (hw1 : ∑ i ∈ s, w i = 1) (x : ι → K) :
  (shiftEquiv a (convexAverage hK s w hw hw1 x) : DifferenceSpace K) =
    ∑ i ∈ s, w i • (shiftEquiv a (x i) : DifferenceSpace K)

shiftEquiv_convexAverage {ι : Type v} (hK : Convex ℝ K) (a : K)
  (s : Finset ι) (w : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i)
  (hw1 : ∑ i ∈ s, w i = 1) (x : ι → K) :
  shiftEquiv a (convexAverage hK s w hw hw1 x) =
    convexAverage (shiftedSet_convex hK a) s w hw hw1
      (fun i => shiftEquiv a (x i))

shiftConjugate (a : K) (F : K → K) : shiftedSet K a → shiftedSet K a
-- Definition: shiftEquiv a ∘ F ∘ (shiftEquiv a).symm
shiftConjugate_shiftEquiv (a : K) (F : K → K) (x : K) :
  shiftConjugate a F (shiftEquiv a x) = shiftEquiv a (F x)
shiftConjugate_nonexpansive (a : K) (F : K → K) (hF : LipschitzWith 1 F) :
  LipschitzWith 1 (shiftConjugate a F)
```

In particular, conjugation never treats `F` as linear or weakly continuous.

## Restriction of the original functionals

```lean
restrictFunctional (K : Set X) (f : X →L[ℝ] ℝ) :
  DifferenceSpace K →L[ℝ] ℝ
restrictFunctional_apply (f : X →L[ℝ] ℝ) (y : DifferenceSpace K) :
  restrictFunctional K f y = f (y : X)
norm_restrictFunctional_le (K : Set X) (f : X →L[ℝ] ℝ) :
  ‖restrictFunctional K f‖ ≤ ‖f‖
restrictFunctional_shift_sub (f : X →L[ℝ] ℝ) (a x y : K) :
  restrictFunctional K f
    ((shiftEquiv a x : DifferenceSpace K) -
      (shiftEquiv a y : DifferenceSpace K)) = f ((x : X) - (y : X))
```

## Intrinsic weak topology and arbitrary nets

```lean
WeakSubspaceCarrier (P : Submodule ℝ X) :=
  {w : WeakSpace ℝ X // (toWeakSpace ℝ X).symm w ∈ P}

weakSubspaceHomeomorph (P : Submodule ℝ X) :
  WeakSpace ℝ P ≃ₜ WeakSubspaceCarrier P
weakSubtype_isEmbedding (P : Submodule ℝ X) :
  Topology.IsEmbedding (WeakSpace.map P.subtypeL)

tendsto_shiftEquiv_weak {ι : Type v} (a : K) (x : ι → K) (q : K)
  (l : Filter ι)
  (hx : Tendsto (fun i => toWeakSpace ℝ X (x i : X)) l
    (𝓝 (toWeakSpace ℝ X (q : X)))) :
  Tendsto (fun i => toWeakSpace ℝ (DifferenceSpace K)
    (shiftEquiv a (x i) : DifferenceSpace K)) l
    (𝓝 (toWeakSpace ℝ (DifferenceSpace K)
      (shiftEquiv a q : DifferenceSpace K)))
```

The inverse continuity in `weakSubspaceHomeomorph` uses the actual Mathlib
`exists_extension_norm_eq` Hahn–Banach theorem. The net statement is stronger
than requested: it holds for every filter, without needing `[NeBot l]`.
Neither completeness nor ambient reflexivity is assumed in these statements.

## Norm-density and compactness

```lean
shiftedDenseDifferences (a : K) (z : ℕ → K) : Set (DifferenceSpace K)
-- Definition: Set.range (fun ij : ℕ × ℕ =>
--   (shiftEquiv a (z ij.1) : DifferenceSpace K) -
--     (shiftEquiv a (z ij.2) : DifferenceSpace K))

shifted_dense_differences_span (a : K) (z : ℕ → K) (hz : DenseRange z) :
  (Submodule.span ℝ (shiftedDenseDifferences a z)).topologicalClosure = ⊤

normalized_shifted_dense_differences_span
  (D : NormalizedMinimalData (X := X)) (a : D.K) :
  (Submodule.span ℝ (shiftedDenseDifferences a D.z)).topologicalClosure = ⊤

intrinsicWeakUnitBall (K : Set X) : Set (WeakSpace ℝ (DifferenceSpace K))
-- Definition: {w | ‖(toWeakSpace ℝ (DifferenceSpace K)).symm w‖ ≤ 1}

intrinsicWeakUnitBall_compact_of_ambient (K : Set X)
  (hK : WeaklyCompact (differenceBall K)) :
  IsCompact (intrinsicWeakUnitBall K)

normalized_intrinsicWeakUnitBall_compact
  (D : NormalizedMinimalData (X := X)) :
  IsCompact (intrinsicWeakUnitBall D.K)

differenceSpan_isClosed (K : Set X) :
  IsClosed (differenceSpan K : Set X)

-- Instance; uses closedness and the inherited original norm:
differenceSpace_completeSpace (K : Set X) [CompleteSpace X] :
  CompleteSpace (DifferenceSpace K)
```

The density equality is in the norm topology of `DifferenceSpace K`;
equivalently, the closure of the indicated span as a set is `Set.univ`.
Compactness is in its intrinsic weak topology, not a renormed or ambient
replacement topology.

## Rebuild and consume

From the campaign root:

```sh
python research/tree_construction/difference/build.py
```

The stdlib-only builder runs the host workspace's `lake env lean`, verifies
Lean **4.31.0**, and prepends the existing producer output directory to
`LEAN_PATH`. It installs nothing and creates no Lake project.

Outputs, relative to this directory:

* `build/lib/lean/DifferenceSpace.olean`
* `build/logs/DifferenceSpace.log`: real compiler and `#print axioms` output
* `build/logs/version.log`
* `build/result.json`: real compiler exit code, elapsed times, hashes,
  environment, and parsed standard-axiom dependencies

For another consumer, use the workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0` and prepend both
`research/tree_construction/producer/build/lib/lean` and
`research/tree_construction/difference/build/lib/lean` (absolute campaign
paths) to `LEAN_PATH`, then run that workspace's `lake env lean`.

The checked principal declarations depend only on `propext`,
`Classical.choice`, and `Quot.sound`. There are no proof holes or new axioms.
This module is a supporting transport lemma, **not completion of
`C_TREE_CONSTRUCTION`**, and contains no final fixed-point or switching
contradiction.
