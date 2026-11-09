import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.ExteriorAlgebra.Grading
import Mathlib.LinearAlgebra.ExteriorPower.Pairing

noncomputable section

open scoped DirectSum
open Finset

namespace FixedSpaceAudit

abbrev LayerIndex {m : ℕ} (t : Fin m → ℕ) := Σ a : Fin m, Fin (t a)

def layerFiberEquiv {m : ℕ} (t : Fin m → ℕ) (a : Fin m) :
    Fin (t a) ≃ {x : LayerIndex t // x.1 = a} where
  toFun i := ⟨⟨a, i⟩, rfl⟩
  invFun x := by
    rcases x with ⟨⟨b, i⟩, h⟩
    cases h
    exact i
  left_inv _ := rfl
  right_inv x := by
    rcases x with ⟨⟨b, i⟩, h⟩
    cases h
    rfl

theorem det_layers {m : ℕ} (t : Fin m → ℕ)
    (M : ∀ a, Matrix (Fin (t a)) (Fin (t a)) ℚ) :
    (Matrix.blockDiagonal' M).det = ∏ a, (M a).det := by
  classical
  rw [(Matrix.blockTriangular_blockDiagonal' M).det_fintype]
  apply Finset.prod_congr rfl
  intro a _
  let e := layerFiberEquiv t a
  have h :
      Matrix.reindex e.symm e.symm
        ((Matrix.blockDiagonal' M).toSquareBlock Sigma.fst a) = M a := by
    ext i j
    change (Matrix.blockDiagonal' M) ⟨a, i⟩ ⟨a, j⟩ = M a i j
    exact Matrix.blockDiagonal'_apply_eq M a i j
  rw [← h, Matrix.det_reindex_self]

def orderedLayers {m : ℕ} (t : Fin m → ℕ)
    (M : ∀ a, Matrix (Fin (t a)) (Fin (t a)) ℚ) :
    Matrix (Fin (Fintype.card (LayerIndex t)))
      (Fin (Fintype.card (LayerIndex t))) ℚ :=
  Matrix.reindex (Fintype.equivFin (LayerIndex t))
    (Fintype.equivFin (LayerIndex t)) (Matrix.blockDiagonal' M)

theorem orderedLayers_det {m : ℕ} (t : Fin m → ℕ)
    (M : ∀ a, Matrix (Fin (t a)) (Fin (t a)) ℚ) :
    (orderedLayers t M).det = ∏ a, (M a).det := by
  rw [orderedLayers, Matrix.det_reindex_self, det_layers]

def coordinateVolume (N : ℕ) :
    Module.Dual ℚ (⋀[ℚ]^N (Fin N → ℚ)) :=
  exteriorPower.pairingDual ℚ (Fin N → ℚ) N
    (exteriorPower.ιMulti ℚ N (fun j => LinearMap.proj j))

def topValue (N : ℕ) : ExteriorAlgebra ℚ (Fin N → ℚ) →ₗ[ℚ] ℚ :=
  (coordinateVolume N).comp
    ((DirectSum.component ℚ ℕ (fun s : ℕ => ⋀[ℚ]^s (Fin N → ℚ)) N).comp
      (ExteriorAlgebra.GradedAlgebra.liftι ℚ (Fin N → ℚ)).toLinearMap)

theorem volume_wedge {N : ℕ} (M : Matrix (Fin N) (Fin N) ℚ) :
    coordinateVolume N (exteriorPower.ιMulti ℚ N (fun i => M i)) = M.det := by
  unfold coordinateVolume
  rw [exteriorPower.pairingDual_ιMulti_ιMulti]
  rfl

theorem topValue_wedge {N : ℕ} (M : Matrix (Fin N) (Fin N) ℚ) :
    topValue N (ExteriorAlgebra.ιMulti ℚ N (fun i => M i)) = M.det := by
  change topValue N
    ((exteriorPower.ιMulti ℚ N (fun i => M i) : ⋀[ℚ]^N (Fin N → ℚ)) :
      ExteriorAlgebra ℚ (Fin N → ℚ)) = M.det
  dsimp only [topValue, LinearMap.comp_apply, AlgHom.toLinearMap_apply]
  rw [ExteriorAlgebra.GradedAlgebra.liftι_eq]
  change coordinateVolume N
    (DirectSum.component ℚ ℕ (fun s : ℕ => ⋀[ℚ]^s (Fin N → ℚ)) N
      (DirectSum.lof ℚ ℕ (fun s : ℕ => ⋀[ℚ]^s (Fin N → ℚ)) N
        (exteriorPower.ιMulti ℚ N (fun i => M i)))) = M.det
  rw [DirectSum.component.lof_self]
  exact volume_wedge M

theorem topValue_homogeneous {N s : ℕ} (h : s < N)
    (x : ⋀[ℚ]^s (Fin N → ℚ)) :
    topValue N (x : ExteriorAlgebra ℚ (Fin N → ℚ)) = 0 := by
  dsimp only [topValue, LinearMap.comp_apply, AlgHom.toLinearMap_apply]
  rw [ExteriorAlgebra.GradedAlgebra.liftι_eq]
  change coordinateVolume N
    (DirectSum.component ℚ ℕ (fun s : ℕ => ⋀[ℚ]^s (Fin N → ℚ)) N
      (DirectSum.lof ℚ ℕ (fun s : ℕ => ⋀[ℚ]^s (Fin N → ℚ)) s x)) = 0
  rw [DirectSum.component.of]
  simp [ne_of_lt h]

theorem homogeneous_product {N n : ℕ} (s : Fin n → ℕ)
    (x : ∀ i, ⋀[ℚ]^(s i) (Fin N → ℚ)) :
    (List.ofFn (fun i => (x i : ExteriorAlgebra ℚ (Fin N → ℚ)))).prod ∈
      ⋀[ℚ]^(∑ i, s i) (Fin N → ℚ) := by
  revert s x
  induction n with
  | zero =>
      intro s x
      simpa using
        (SetLike.one_mem_graded (fun s : ℕ => ⋀[ℚ]^s (Fin N → ℚ)))
  | succ n ih =>
      intro s x
      rw [List.ofFn_succ, List.prod_cons, Fin.sum_univ_succ]
      exact SetLike.mul_mem_graded (x 0).property
        (ih (fun i => s i.succ) (fun i => x i.succ))

theorem shorter_products_vanish {N n : ℕ} (s : Fin n → ℕ)
    (x : ∀ i, ⋀[ℚ]^(s i) (Fin N → ℚ)) (h : (∑ i, s i) < N) :
    topValue N
      (List.ofFn (fun i => (x i : ExteriorAlgebra ℚ (Fin N → ℚ)))).prod = 0 := by
  exact topValue_homogeneous h
    ⟨_, homogeneous_product s x⟩

theorem filtered_coefficient {m : ℕ} (t : Fin m → ℕ)
    (M : ∀ a, Matrix (Fin (t a)) (Fin (t a)) ℚ) :
    topValue (Fintype.card (LayerIndex t))
      (ExteriorAlgebra.ιMulti ℚ (Fintype.card (LayerIndex t))
        (fun i => orderedLayers t M i)) = ∏ a, (M a).det := by
  rw [topValue_wedge, orderedLayers_det]

theorem filtered_coefficient_nonzero {m : ℕ} (t : Fin m → ℕ)
    (M : ∀ a, Matrix (Fin (t a)) (Fin (t a)) ℚ)
    (h : ∀ a, (M a).det ≠ 0) :
    topValue (Fintype.card (LayerIndex t))
      (ExteriorAlgebra.ιMulti ℚ (Fintype.card (LayerIndex t))
        (fun i => orderedLayers t M i)) ≠ 0 := by
  rw [filtered_coefficient]
  exact Finset.prod_ne_zero_iff.mpr (fun a _ => h a)

theorem filtered_wedge_nonzero {m : ℕ} (t : Fin m → ℕ)
    (M : ∀ a, Matrix (Fin (t a)) (Fin (t a)) ℚ)
    (h : ∀ a, (M a).det ≠ 0) :
    ExteriorAlgebra.ιMulti ℚ (Fintype.card (LayerIndex t))
      (fun i => orderedLayers t M i) ≠ 0 := by
  intro hz
  apply filtered_coefficient_nonzero t M h
  rw [hz, map_zero]

theorem weighted_filtered_nonzero {m n : ℕ} (t : Fin m → ℕ)
    (M : ∀ a, Matrix (Fin (t a)) (Fin (t a)) ℚ)
    (c : Fin n → ℚ) (hc : ∀ j, c j ≠ 0)
    (h : ∀ a, (M a).det ≠ 0) :
    (∏ j, c j) *
      topValue (Fintype.card (LayerIndex t))
        (ExteriorAlgebra.ιMulti ℚ (Fintype.card (LayerIndex t))
          (fun i => orderedLayers t M i)) ≠ 0 := by
  exact mul_ne_zero
    (Finset.prod_ne_zero_iff.mpr (fun j _ => hc j))
    (filtered_coefficient_nonzero t M h)

def prefixMinor {m r : ℕ} (t : Fin m → ℕ) (ht : ∀ a, t a ≤ r)
    (B : Matrix (Fin r) (Fin r) ℚ) (a : Fin m) :
    Matrix (Fin (t a)) (Fin (t a)) ℚ :=
  fun i j => B (Fin.castLE (ht a) i) (Fin.castLE (ht a) j)

theorem nested_minor_nonzero {m r : ℕ} (t : Fin m → ℕ) (ht : ∀ a, t a ≤ r)
    (B : Matrix (Fin r) (Fin r) ℚ)
    (h : ∀ a, (prefixMinor t ht B a).det ≠ 0) :
    topValue (Fintype.card (LayerIndex t))
      (ExteriorAlgebra.ιMulti ℚ (Fintype.card (LayerIndex t))
        (fun i => orderedLayers t (prefixMinor t ht B) i)) ≠ 0 :=
  filtered_coefficient_nonzero t (prefixMinor t ht B) h

end FixedSpaceAudit
