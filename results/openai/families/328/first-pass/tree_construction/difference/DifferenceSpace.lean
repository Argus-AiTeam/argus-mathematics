import Producer

/-!
Original-norm translation into the closed span of differences.  The subspace
weak topology is intrinsic: its comparison with the ambient weak topology is
proved using Hahn--Banach, not postulated.
-/

open Set Filter Topology
open scoped BigOperators Pointwise

noncomputable section

namespace TreeConstruction

open OAI.ReflexiveFixedPoints

universe u v

variable {X : Type u} [NormedAddCommGroup X] [NormedSpace ℝ X]
variable {K : Set X}

abbrev DifferenceSpace (K : Set X) := ↥(differenceSpan K)

theorem differenceSpan_isClosed (K : Set X) :
    IsClosed (differenceSpan K : Set X) :=
  (Submodule.span ℝ (K - K)).isClosed_topologicalClosure

instance differenceSpace_completeSpace (K : Set X) [CompleteSpace X] :
    CompleteSpace (DifferenceSpace K) :=
  (differenceSpan_isClosed K).completeSpace_coe

theorem sub_mem_differenceSpan (x y : K) :
    (x : X) - (y : X) ∈ differenceSpan K :=
  (Submodule.span ℝ (K - K)).le_topologicalClosure
    (Submodule.subset_span (Set.sub_mem_sub x.property y.property))

def shiftedSet (K : Set X) (a : K) : Set (DifferenceSpace K) :=
  {y | (y : X) + (a : X) ∈ K}

def shiftPoint (a : K) (x : K) : DifferenceSpace K :=
  ⟨(x : X) - (a : X), sub_mem_differenceSpan x a⟩

@[simp] theorem shiftPoint_coe (a x : K) :
    (shiftPoint a x : X) = (x : X) - (a : X) := rfl

def shiftEquiv (a : K) : K ≃ shiftedSet K a where
  toFun x := ⟨shiftPoint a x, by simp [shiftedSet, shiftPoint]⟩
  invFun y := ⟨((y : DifferenceSpace K) : X) + (a : X), y.property⟩
  left_inv x := by ext; simp [shiftPoint]
  right_inv y := by ext; simp [shiftPoint]

@[simp] theorem shiftEquiv_coe (a x : K) :
    (shiftEquiv a x : DifferenceSpace K) = shiftPoint a x := rfl

@[simp] theorem shiftEquiv_symm_coe (a : K) (y : shiftedSet K a) :
    ((shiftEquiv a).symm y : X) = ((y : DifferenceSpace K) : X) + (a : X) := rfl

theorem shiftPoint_sub_coe (a x y : K) :
    ((shiftPoint a x - shiftPoint a y : DifferenceSpace K) : X) =
      (x : X) - (y : X) := by
  change ((x : X) - a) - ((y : X) - a) = (x : X) - y
  abel

theorem shiftEquiv_norm_sub (a x y : K) :
    ‖(shiftEquiv a x : DifferenceSpace K) - (shiftEquiv a y : DifferenceSpace K)‖ =
      ‖(x : X) - (y : X)‖ :=
  congrArg norm (shiftPoint_sub_coe a x y)

theorem shiftEquiv_isometry (a : K) : Isometry (shiftEquiv a) := by
  apply Isometry.of_dist_eq
  intro x y
  change dist (shiftPoint a x) (shiftPoint a y) = dist (x : X) (y : X)
  simpa only [dist_eq_norm, shiftEquiv_coe] using shiftEquiv_norm_sub a x y

def shiftIsometryEquiv (a : K) : K ≃ᵢ shiftedSet K a where
  toEquiv := shiftEquiv a
  isometry_toFun := shiftEquiv_isometry a

def shiftHomeomorph (a : K) : K ≃ₜ shiftedSet K a :=
  (shiftIsometryEquiv a).toHomeomorph

theorem continuous_shiftPoint (a : K) : Continuous (shiftPoint a) :=
  (continuous_subtype_val.sub continuous_const).subtype_mk _

theorem shiftedSet_convex (hK : Convex ℝ K) (a : K) :
    Convex ℝ (shiftedSet K a) := by
  intro x hx y hy s t hs ht hst
  have h := hK hx hy hs ht hst
  change (s • (x : X) + t • (y : X)) + (a : X) ∈ K
  convert h using 1
  rw [smul_add, smul_add]
  have ha : s • (a : X) + t • (a : X) = (a : X) := by
    rw [← add_smul, hst, one_smul]
  calc
    (s • (x : X) + t • (y : X)) + (a : X) =
        (s • (x : X) + t • (y : X)) + (s • (a : X) + t • (a : X)) := by rw [ha]
    _ = (s • (x : X) + s • (a : X)) + (t • (y : X) + t • (a : X)) := by abel

def convexAverage {ι : Type v} (hK : Convex ℝ K) (s : Finset ι)
    (w : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i) (hw1 : ∑ i ∈ s, w i = 1)
    (x : ι → K) : K :=
  ⟨∑ i ∈ s, w i • (x i : X), hK.sum_mem hw hw1 (fun i _ => (x i).property)⟩

theorem shiftEquiv_convexAverage_val {ι : Type v} (hK : Convex ℝ K) (a : K)
    (s : Finset ι) (w : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i)
    (hw1 : ∑ i ∈ s, w i = 1) (x : ι → K) :
    (shiftEquiv a (convexAverage hK s w hw hw1 x) : DifferenceSpace K) =
      ∑ i ∈ s, w i • (shiftEquiv a (x i) : DifferenceSpace K) := by
  apply Subtype.ext
  simp only [shiftEquiv_coe, shiftPoint_coe, Submodule.coe_sum, Submodule.coe_smul]
  change (∑ i ∈ s, w i • (x i : X)) - (a : X) =
    ∑ i ∈ s, w i • ((x i : X) - (a : X))
  simp_rw [smul_sub]
  rw [Finset.sum_sub_distrib, ← Finset.sum_smul, hw1, one_smul]

theorem shiftEquiv_convexAverage {ι : Type v} (hK : Convex ℝ K) (a : K)
    (s : Finset ι) (w : ι → ℝ) (hw : ∀ i ∈ s, 0 ≤ w i)
    (hw1 : ∑ i ∈ s, w i = 1) (x : ι → K) :
    shiftEquiv a (convexAverage hK s w hw hw1 x) =
      convexAverage (shiftedSet_convex hK a) s w hw hw1 (fun i => shiftEquiv a (x i)) := by
  apply Subtype.ext
  exact shiftEquiv_convexAverage_val hK a s w hw hw1 x

def shiftConjugate (a : K) (F : K → K) : shiftedSet K a → shiftedSet K a :=
  shiftEquiv a ∘ F ∘ (shiftEquiv a).symm

@[simp] theorem shiftConjugate_shiftEquiv (a : K) (F : K → K) (x : K) :
    shiftConjugate a F (shiftEquiv a x) = shiftEquiv a (F x) := by
  simp [shiftConjugate]

theorem shiftConjugate_nonexpansive (a : K) (F : K → K) (hF : LipschitzWith 1 F) :
    LipschitzWith 1 (shiftConjugate a F) := by
  simpa [one_mul, shiftConjugate, shiftIsometryEquiv, IsometryEquiv.symm,
    Function.comp_def] using
    ((shiftIsometryEquiv a).isometry.lipschitz.comp hF).comp
      (shiftIsometryEquiv a).symm.isometry.lipschitz

def restrictFunctional (K : Set X) (f : X →L[ℝ] ℝ) :
    DifferenceSpace K →L[ℝ] ℝ :=
  f.comp (differenceSpan K).subtypeL

@[simp] theorem restrictFunctional_apply (f : X →L[ℝ] ℝ) (y : DifferenceSpace K) :
    restrictFunctional K f y = f (y : X) := rfl

theorem norm_restrictFunctional_le (K : Set X) (f : X →L[ℝ] ℝ) :
    ‖restrictFunctional K f‖ ≤ ‖f‖ := by
  apply ContinuousLinearMap.opNorm_le_bound _ (norm_nonneg f)
  intro y
  exact f.le_opNorm (y : X)

theorem restrictFunctional_shift_sub (f : X →L[ℝ] ℝ) (a x y : K) :
    restrictFunctional K f
      ((shiftEquiv a x : DifferenceSpace K) - (shiftEquiv a y : DifferenceSpace K)) =
      f ((x : X) - (y : X)) :=
  congrArg f (shiftPoint_sub_coe a x y)

abbrev WeakSubspaceCarrier (P : Submodule ℝ X) :=
  {w : WeakSpace ℝ X // (toWeakSpace ℝ X).symm w ∈ P}

/-- Hahn--Banach identifies the intrinsic weak topology with the ambient weak
subspace topology, without any reflexivity or completeness assumption. -/
def weakSubspaceHomeomorph (P : Submodule ℝ X) :
    WeakSpace ℝ P ≃ₜ WeakSubspaceCarrier P where
  toFun w := ⟨toWeakSpace ℝ X (((toWeakSpace ℝ P).symm w : P) : X),
    ((toWeakSpace ℝ P).symm w).property⟩
  invFun w := toWeakSpace ℝ P ⟨(toWeakSpace ℝ X).symm w.val, w.property⟩
  left_inv _ := rfl
  right_inv _ := rfl
  continuous_toFun := (WeakSpace.map P.subtypeL).continuous.subtype_mk _
  continuous_invFun := by
    apply WeakBilin.continuous_of_continuous_eval (topDualPairing ℝ P).flip
    intro f
    obtain ⟨g, hg, _⟩ := exists_extension_norm_eq P f
    change Continuous (fun w : WeakSubspaceCarrier P =>
      f ⟨(toWeakSpace ℝ X).symm w.val, w.property⟩)
    have hc : Continuous (fun w : WeakSubspaceCarrier P =>
        g ((toWeakSpace ℝ X).symm w.val)) :=
      (WeakBilin.eval_continuous (topDualPairing ℝ X).flip g).comp continuous_subtype_val
    convert hc using 1
    funext w
    exact (hg ⟨(toWeakSpace ℝ X).symm w.val, w.property⟩).symm

theorem weakSubtype_isEmbedding (P : Submodule ℝ X) :
    Topology.IsEmbedding (WeakSpace.map P.subtypeL) :=
  Topology.IsEmbedding.subtypeVal.comp (weakSubspaceHomeomorph P).isEmbedding

/-- Valid for every filter, hence in particular every proper filter and net. -/
theorem tendsto_shiftEquiv_weak {ι : Type v} (a : K) (x : ι → K) (q : K)
    (l : Filter ι)
    (hx : Tendsto (fun i => toWeakSpace ℝ X (x i : X)) l
      (𝓝 (toWeakSpace ℝ X (q : X)))) :
    Tendsto (fun i => toWeakSpace ℝ (DifferenceSpace K)
      (shiftEquiv a (x i) : DifferenceSpace K)) l
      (𝓝 (toWeakSpace ℝ (DifferenceSpace K) (shiftEquiv a q : DifferenceSpace K))) := by
  apply (weakSubtype_isEmbedding (differenceSpan K)).isInducing.tendsto_nhds_iff.mpr
  change Tendsto (fun i => toWeakSpace ℝ X ((x i : X) - (a : X))) l
    (𝓝 (toWeakSpace ℝ X ((q : X) - (a : X))))
  simpa only [map_sub] using hx.sub_const (toWeakSpace ℝ X (a : X))

def shiftedDenseDifferences (a : K) (z : ℕ → K) : Set (DifferenceSpace K) :=
  Set.range (fun ij : ℕ × ℕ =>
    (shiftEquiv a (z ij.1) : DifferenceSpace K) -
      (shiftEquiv a (z ij.2) : DifferenceSpace K))

theorem shifted_dense_differences_span (a : K) (z : ℕ → K) (hz : DenseRange z) :
    (Submodule.span ℝ (shiftedDenseDifferences a z)).topologicalClosure = ⊤ := by
  let P := (Submodule.span ℝ (shiftedDenseDifferences a z)).topologicalClosure
  have hP : IsClosed (P : Set (DifferenceSpace K)) :=
    (Submodule.span ℝ (shiftedDenseDifferences a z)).isClosed_topologicalClosure
  have hdiff : ∀ x y : K, shiftPoint a x - shiftPoint a y ∈ P := by
    refine isClosed_property2
      (p := fun x y : K => shiftPoint a x - shiftPoint a y ∈ P) hz ?_ ?_
    · exact hP.preimage
        (((continuous_shiftPoint a).comp continuous_fst).sub
          ((continuous_shiftPoint a).comp continuous_snd))
    · intro i j
      apply (Submodule.span ℝ (shiftedDenseDifferences a z)).le_topologicalClosure
      exact Submodule.subset_span ⟨(i, j), rfl⟩
  let Q : Submodule ℝ X := P.map (differenceSpan K).subtype
  have hQ : IsClosed (Q : Set X) := by
    change IsClosed ((differenceSpan K).subtype '' (P : Set (DifferenceSpace K)))
    exact (differenceSpan_isClosed K).isClosedMap_subtype_val _ hP
  have hYQ : differenceSpan K ≤ Q := by
    apply Submodule.topologicalClosure_minimal
    · apply Submodule.span_le.mpr
      rintro _ ⟨x, hx, y, hy, rfl⟩
      exact Submodule.mem_map.mpr
        ⟨shiftPoint a ⟨x, hx⟩ - shiftPoint a ⟨y, hy⟩,
          hdiff ⟨x, hx⟩ ⟨y, hy⟩, shiftPoint_sub_coe a ⟨x, hx⟩ ⟨y, hy⟩⟩
    · exact hQ
  apply top_unique
  intro y _
  obtain ⟨w, hw, hwy⟩ := Submodule.mem_map.mp (hYQ y.property)
  have heq : w = y := Subtype.ext hwy
  exact heq ▸ hw

theorem normalized_shifted_dense_differences_span
    (D : NormalizedMinimalData (X := X)) (a : D.K) :
    (Submodule.span ℝ (shiftedDenseDifferences a D.z)).topologicalClosure = ⊤ :=
  shifted_dense_differences_span a D.z D.dense_z

def intrinsicWeakUnitBall (K : Set X) : Set (WeakSpace ℝ (DifferenceSpace K)) :=
  {w | ‖(toWeakSpace ℝ (DifferenceSpace K)).symm w‖ ≤ 1}

theorem intrinsicWeakUnitBall_compact_of_ambient (K : Set X)
    (hK : WeaklyCompact (differenceBall K)) :
    IsCompact (intrinsicWeakUnitBall K) := by
  apply (weakSubtype_isEmbedding (differenceSpan K)).isCompact_iff.mpr
  have heq : (WeakSpace.map (differenceSpan K).subtypeL) '' intrinsicWeakUnitBall K =
      (toWeakSpace ℝ X) '' differenceBall K := by
    ext w
    constructor
    · rintro ⟨v, hv, rfl⟩
      exact ⟨(((toWeakSpace ℝ (DifferenceSpace K)).symm v : DifferenceSpace K) : X),
        ⟨((toWeakSpace ℝ (DifferenceSpace K)).symm v).property, hv⟩, rfl⟩
    · rintro ⟨x, ⟨hx, hnorm⟩, rfl⟩
      exact ⟨toWeakSpace ℝ (DifferenceSpace K) ⟨x, hx⟩, hnorm, rfl⟩
  rw [heq]
  exact hK

theorem normalized_intrinsicWeakUnitBall_compact (D : NormalizedMinimalData (X := X)) :
    IsCompact (intrinsicWeakUnitBall D.K) :=
  intrinsicWeakUnitBall_compact_of_ambient D.K D.weak_ball_compact

end TreeConstruction

#print axioms TreeConstruction.shiftEquiv
#print axioms TreeConstruction.shiftedSet_convex
#print axioms TreeConstruction.shiftEquiv_norm_sub
#print axioms TreeConstruction.shiftEquiv_convexAverage
#print axioms TreeConstruction.shiftConjugate_nonexpansive
#print axioms TreeConstruction.norm_restrictFunctional_le
#print axioms TreeConstruction.restrictFunctional_shift_sub
#print axioms TreeConstruction.weakSubspaceHomeomorph
#print axioms TreeConstruction.tendsto_shiftEquiv_weak
#print axioms TreeConstruction.normalized_shifted_dense_differences_span
#print axioms TreeConstruction.normalized_intrinsicWeakUnitBall_compact
#print axioms TreeConstruction.differenceSpace_completeSpace
