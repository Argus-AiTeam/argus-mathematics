import OAI.Geometry.HeilbronnTriangle.AuxiliaryZeroCount
import OAI.Geometry.HeilbronnTriangle.ZeroRowData

noncomputable section

open OAI OAI.Problem355
open scoped BigOperators Matrix

namespace ZeroWeightedCount

attribute [local instance] Classical.propDecidable

abbrev IntMatrix := Matrix (Fin 3) (Fin 3) ℤ
abbrev Vector (q : ℕ) := Fin 3 → ZMod q
abbrev Affine (q : ℕ) [Fact q.Prime] := Vector q ≃ᵃ[ZMod q] Vector q

instance finiteAffine (q : ℕ) [Fact q.Prime] : Finite (Affine q) :=
  Finite.of_injective (fun e : Affine q => (e : Vector q → Vector q))
    DFunLike.coe_injective

noncomputable instance fintypeAffine (q : ℕ) [Fact q.Prime] : Fintype (Affine q) :=
  Fintype.ofFinite _

def allowedShiftSet (q H w : ℕ) [Fact q.Prime] : Finset (Vector q) :=
  Auxiliary.vectorShifts (Auxiliary.allowedShifts
    (Auxiliary.positiveMultipliers q H) (Auxiliary.integerWindow q (3 * H * w)))

def restrictedWeight (q : ℕ) [Fact q.Prime]
    (S A : Finset (Vector q)) (p : Fin 3 → Vector q) : ℝ :=
  AuxiliaryWeights.affineInclusionWeight S
    (AuxiliaryWeights.affineMapsWithInputShift A) p

def actualWeight (q h : ℕ) [Fact q.Prime]
    (S : Finset (Vector q)) (M : IntMatrix) : ℝ :=
  restrictedWeight q S
    (allowedShiftSet q (h ^ 2) (q / (1000 * (h ^ 2) ^ 2)))
    (M.map (Int.castRingHom (ZMod q))).col

theorem uniform_weight_eq {q : ℕ} [Fact q.Prime]
    (S : Finset (Vector q)) (T : Finset (Affine q)) (p : Fin 3 → Vector q) :
    LiftingProbability.auxiliaryWeight q S.card
      (fun _ : T => (T.card : ℝ)⁻¹)
      (fun e : T => S.image (fun x => e.1 x)) p =
      AuxiliaryWeights.affineInclusionWeight S T p := by
  classical
  rw [AuxiliaryWeights.affineInclusionWeight_eq_uniform_sum]
  simp only [LiftingProbability.auxiliaryWeight, LiftingProbability.inclusionMass,
    ZMod.card]
  congr 1
  apply Finset.sum_congr rfl
  intro e he
  simp only [LiftingProbability.TripleIn, Finset.mem_image]
  split_ifs <;> simp_all

theorem affine_apply_inputShift {q : ℕ} [Fact q.Prime]
    (e : Affine q) (x : Vector q) :
    e x = (AffineTripleOrbit.inputShiftEquiv e).1
      ((AffineTripleOrbit.inputShiftEquiv e).2 + x) := by
  have h := congrArg (fun f : Affine q => f x)
    (AffineTripleOrbit.inputShiftEquiv.symm_apply_apply e)
  exact h.symm.trans (AffineTripleOrbit.inputShiftEquiv_symm_apply
    (AffineTripleOrbit.inputShiftEquiv e).1
    (AffineTripleOrbit.inputShiftEquiv e).2 x)

set_option maxHeartbeats 600000 in
theorem restrictedWeight_eq_uniform_product {q : ℕ} [Fact q.Prime]
    (S A : Finset (Vector q)) (p : Fin 3 → Vector q) :
    restrictedWeight q S A p =
      ((q : ℝ) ^ 3 / S.card) ^ 3 *
        ((Nat.card {u : ((Vector q) ≃ₗ[ZMod q] Vector q) × A //
          ∀ i, p i ∈ AuxiliarySet.transformed S u.2.1 u.1} : ℝ) /
          (Nat.card (((Vector q) ≃ₗ[ZMod q] Vector q) × A) : ℝ)) := by
  classical
  let T := AuxiliaryWeights.affineMapsWithInputShift (K := ZMod q) A
  let P : Affine q → Prop := fun e => ∀ i, e.symm (p i) ∈ S
  let Q : (((Vector q) ≃ₗ[ZMod q] Vector q) × A) → Prop :=
    fun u => ∀ i, p i ∈ AuxiliarySet.transformed S u.2.1 u.1
  let E : T ≃ (((Vector q) ≃ₗ[ZMod q] Vector q) × A) :=
    (Equiv.subtypeEquivRight
      (p := fun e : Affine q => e ∈ T)
      (q := fun e => (AffineTripleOrbit.inputShiftEquiv e).2 ∈ A)
      (fun e => by simp [T, AuxiliaryWeights.affineMapsWithInputShift])).trans
      (AffineTripleOrbit.restrictedInputShiftEquiv (A : Set (Vector q)))
  have hP (e : T) : P e.1 ↔ Q (E e) := by
    change (∀ i, e.1.symm (p i) ∈ S) ↔
      ∀ i, p i ∈ AuxiliarySet.transformed S
        (AffineTripleOrbit.inputShiftEquiv e.1).2
        (AffineTripleOrbit.inputShiftEquiv e.1).1
    constructor
    · intro hp i
      exact (AuxiliarySet.mem_transformed S
        (AffineTripleOrbit.inputShiftEquiv e.1).2
        (AffineTripleOrbit.inputShiftEquiv e.1).1 (p i)).mpr
        ⟨e.1.symm (p i), hp i,
          (affine_apply_inputShift e.1 (e.1.symm (p i))).symm.trans
            (e.1.apply_symm_apply (p i))⟩
    · intro hp i
      obtain ⟨x, hx, hxp⟩ := (AuxiliarySet.mem_transformed S
        (AffineTripleOrbit.inputShiftEquiv e.1).2
        (AffineTripleOrbit.inputShiftEquiv e.1).1 (p i)).mp (hp i)
      have he : e.1 x = p i := (affine_apply_inputShift e.1 x).trans hxp
      rw [← he, e.1.symm_apply_apply]
      exact hx
  let F : (T.filter P) ≃ {e : T // P e.1} :=
    (Equiv.subtypeEquivRight
      (p := fun e : Affine q => e ∈ T.filter P)
      (q := fun e => e ∈ T ∧ P e)
      (fun _ => Finset.mem_filter)).trans
      (Equiv.subtypeSubtypeEquivSubtypeInter (fun e => e ∈ T) P).symm
  have hnum : (T.filter P).card =
      Nat.card {u : (((Vector q) ≃ₗ[ZMod q] Vector q) × A) // Q u} := by
    have hc : Nat.card (T.filter P) = (T.filter P).card := by
      rw [Nat.card_eq_fintype_card, Fintype.card_coe]
    exact hc.symm.trans (Nat.card_congr (F.trans (E.subtypeEquiv hP)))
  have hden : T.card =
      Nat.card (((Vector q) ≃ₗ[ZMod q] Vector q) × A) := by
    have hc : Nat.card T = T.card := by
      rw [Nat.card_eq_fintype_card, Fintype.card_coe]
    exact hc.symm.trans (Nat.card_congr E)
  unfold restrictedWeight AuxiliaryWeights.affineInclusionWeight
  rw [ZMod.card]
  congr 1
  apply congrArg₂ (fun a b : ℕ => (a : ℝ) / (b : ℝ))
  · calc
      _ = (T.filter P).card := by
        apply congrArg Finset.card
        ext e
        simp only [Finset.mem_filter]
        rfl
      _ = _ := hnum
  · exact hden

def restrictedLaw {q H w : ℕ} [Fact q.Prime]
    (hH : 1 ≤ H) (hHq : H < q)
    (S : Finset (Vector q)) (hS : S.Nonempty)
    (hcap : AuxiliaryCap.IsCap (S : Set (Vector q)))
    (hbox : ∀ v ∈ S, (v 0).val < w)
    (hsize : q ^ 2 ≤ 2000 ^ 3 * H ^ 6 * S.card)
    (A : Finset (Vector q)) (hA : q ^ 3 ≤ 2 * A.card)
    (hallowed : ∀ a ∈ A, ∀ n : ℕ, 1 ≤ n → n ≤ 3 * H →
      (n : ZMod q) * a 0 ∉ Auxiliary.integerWindow q (3 * H * w)) :
    AuxiliarySampling.Law q H := by
  classical
  let T := AuxiliaryWeights.affineMapsWithInputShift (K := ZMod q) A
  have hA' : Fintype.card (Vector q) ≤ 2 * A.card := by simpa using hA
  have hT : T.Nonempty := AuxiliaryWeights.affineMapsWithInputShift_nonempty A hA'
  have hTsize : Fintype.card (Affine q) ≤ 2 * T.card :=
    AuxiliaryWeights.affineMapsWithInputShift_halfDensity A hA'
  let μ : T → ℝ := fun _ => (T.card : ℝ)⁻¹
  let V : T → Finset (Vector q) := fun e => S.image (fun x => e.1 x)
  have hV (e : T) : V e = AuxiliarySet.transformed S
      (AffineTripleOrbit.inputShiftEquiv e.1).2
      (AffineTripleOrbit.inputShiftEquiv e.1).1 := by
    ext y
    simp only [V, Finset.mem_image, AuxiliarySet.mem_transformed]
    constructor
    · rintro ⟨x, hx, rfl⟩
      exact ⟨x, hx, (affine_apply_inputShift e.1 x).symm⟩
    · rintro ⟨x, hx, rfl⟩
      exact ⟨x, hx, affine_apply_inputShift e.1 x⟩
  have hall (e : T) : ∀ n : ℕ, 1 ≤ n → n ≤ 3 * H →
      (n : ZMod q) * (AffineTripleOrbit.inputShiftEquiv e.1).2 0 ∉
        Auxiliary.integerWindow q (3 * H * w) := by
    apply hallowed
    exact (Finset.mem_filter.mp e.2).2
  have hprops (e : T) := AuxiliarySet.transformed_properties hH hHq hcap hbox
    (AffineTripleOrbit.inputShiftEquiv e.1).2 (hall e)
    (AffineTripleOrbit.inputShiftEquiv e.1).1
  refine {
    Outcome := T
    outcomeFintype := inferInstance
    weight := μ
    sets := V
    size := S.card
    size_pos := hS.card_pos
    weight_nonneg := ?_
    weight_sum := ?_
    sets_card := ?_
    size_lower := hsize
    zero_not_mem := ?_
    isCap := ?_
    short_relation := ?_
    weight_le_eight := ?_
    weight_le_four := ?_
    weight_le_two := ?_ }
  · intro e
    dsimp [μ]
    positivity
  · simp only [μ, Finset.sum_const, Finset.card_univ, Fintype.card_coe, nsmul_eq_mul]
    exact mul_inv_cancel₀ (by exact_mod_cast hT.card_pos.ne')
  · intro e
    rw [hV]
    exact (hprops e).1
  · intro e
    rw [hV]
    exact (hprops e).2.1
  · intro e
    rw [hV]
    exact (hprops e).2.2.1
  · intro e p hp hinj x hx hne
    exact (hprops e).2.2.2 p (fun i => hV e ▸ hp i) hinj x hx hne
  · intro p hp
    rw [show LiftingProbability.auxiliaryWeight q S.card μ V p =
      AuxiliaryWeights.affineInclusionWeight S T p from uniform_weight_eq S T p]
    exact AuxiliaryWeights.affineInclusionWeight_le_eight S hS T hT hTsize p hp
  · intro p i j hp
    rw [show LiftingProbability.auxiliaryWeight q S.card μ V p =
      AuxiliaryWeights.affineInclusionWeight S T p from uniform_weight_eq S T p]
    simpa only [ZMod.card] using
      AuxiliaryWeights.affineInclusionWeight_le_four_of_ne S hS T hT hTsize p i j hp
  · intro p
    rw [show LiftingProbability.auxiliaryWeight q S.card μ V p =
      AuxiliaryWeights.affineInclusionWeight S T p from uniform_weight_eq S T p]
    simpa only [ZMod.card] using
      AuxiliaryWeights.affineInclusionWeight_le_two S hS T hT hTsize p

theorem restrictedLaw_weight {q H w : ℕ} [Fact q.Prime]
    (hH : 1 ≤ H) (hHq : H < q)
    (S : Finset (Vector q)) (hS : S.Nonempty)
    (hcap : AuxiliaryCap.IsCap (S : Set (Vector q)))
    (hbox : ∀ v ∈ S, (v 0).val < w)
    (hsize : q ^ 2 ≤ 2000 ^ 3 * H ^ 6 * S.card)
    (A : Finset (Vector q)) (hA : q ^ 3 ≤ 2 * A.card)
    (hallowed : ∀ a ∈ A, ∀ n : ℕ, 1 ≤ n → n ≤ 3 * H →
      (n : ZMod q) * a 0 ∉ Auxiliary.integerWindow q (3 * H * w))
    (p : Fin 3 → Vector q) :
    let L := restrictedLaw hH hHq S hS hcap hbox hsize A hA hallowed
    LiftingProbability.auxiliaryWeight q L.size L.weight L.sets p =
      restrictedWeight q S A p := by
  exact uniform_weight_eq S (AuxiliaryWeights.affineMapsWithInputShift A) p

def MatrixBox (N : ℕ) (M : IntMatrix) : Prop :=
  ∀ j, 0 ≤ M 0 j ∧ M 0 j < (N : ℤ) ∧
    0 ≤ M 1 j ∧ M 1 j < (N : ℤ) ∧
    (N : ℤ) ≤ M 2 j ∧ M 2 j < 2 * (N : ℤ)

theorem box_entry_bounds {N : ℕ} {M : IntMatrix} (hbox : MatrixBox N M)
    (i j : Fin 3) : 0 ≤ M i j ∧ M i j < 2 * (N : ℤ) := by
  rcases hbox j with ⟨h0a, h0b, h1a, h1b, h2a, h2b⟩
  have hN : (0 : ℤ) ≤ N := by exact_mod_cast Nat.zero_le N
  fin_cases i
  · change 0 ≤ M 0 j ∧ M 0 j < 2 * (N : ℤ)
    omega
  · change 0 ≤ M 1 j ∧ M 1 j < 2 * (N : ℤ)
    omega
  · change 0 ≤ M 2 j ∧ M 2 j < 2 * (N : ℤ)
    omega

def DistinctProjections (M : IntMatrix) : Prop :=
  ∀ i j : Fin 3, i ≠ j →
    ((M 0 i : ℝ) / M 2 i, (M 1 i : ℝ) / M 2 i) ≠
    ((M 0 j : ℝ) / M 2 j, (M 1 j : ℝ) / M 2 j)

def coarseMatrices (N : ℕ) : Finset IntMatrix :=
  Finset.univ.image
    (fun M : Fin 3 → Fin 3 → Fin (2 * N) => fun i j => ((M i j).val : ℤ))

theorem mem_coarseMatrices_of_box {N : ℕ} {M : IntMatrix}
    (hbox : MatrixBox N M) : M ∈ coarseMatrices N := by
  classical
  have hentry := box_entry_bounds hbox
  let m : Fin 3 → Fin 3 → Fin (2 * N) := fun i j =>
    ⟨(M i j).toNat, by have := hentry i j; omega⟩
  refine Finset.mem_image.mpr ⟨m, Finset.mem_univ _, ?_⟩
  funext i j
  exact Int.toNat_of_nonneg (hentry i j).1

def zeroMatrices {B k : ℕ}
    (C : Matrix (Fin 3) (Fin 3) (ZMod (B ^ k))) (N : ℕ) : Finset IntMatrix := by
  classical
  exact (coarseMatrices N).filter (fun M =>
    MatrixBox N M ∧ (∀ i, M i ∈ PrimePowerRowData.rowModule C) ∧
      M.det = 0 ∧ DistinctProjections M)

theorem mem_zeroMatrices {B k N : ℕ}
    {C : Matrix (Fin 3) (Fin 3) (ZMod (B ^ k))} {M : IntMatrix} :
    M ∈ zeroMatrices C N ↔
      MatrixBox N M ∧ (∀ i, M i ∈ PrimePowerRowData.rowModule C) ∧
        M.det = 0 ∧ DistinctProjections M := by
  classical
  constructor
  · intro hm
    exact (Finset.mem_filter.mp hm).2
  · intro hm
    exact Finset.mem_filter.mpr ⟨mem_coarseMatrices_of_box hm.1, hm⟩

theorem box_height_ne_zero {N : ℕ} (hN : 1 ≤ N) {M : IntMatrix}
    (hbox : MatrixBox N M) (j : Fin 3) : M 2 j ≠ 0 := by
  have hNi : (1 : ℤ) ≤ N := by exact_mod_cast hN
  have := hbox j
  omega

theorem box_abs_le {N : ℕ} {M : IntMatrix} (hbox : MatrixBox N M)
    (i j : Fin 3) : |M i j| ≤ (2 * N : ℕ) := by
  have hh := box_entry_bounds hbox i j
  apply abs_le.mpr
  constructor <;> omega

theorem cap_size_bound_iff {q h s : ℕ} (hh : 0 < h) :
    q ^ 2 ≤ 2000 ^ 3 * h ^ 12 * s ↔
      (q : ℝ) ^ 2 / (2000 ^ 3 * (h : ℝ) ^ 12) ≤ (s : ℝ) := by
  have hhR : (0 : ℝ) < h := by exact_mod_cast hh
  have hden : (0 : ℝ) < 2000 ^ 3 * (h : ℝ) ^ 12 := by positivity
  rw [div_le_iff₀ hden]
  constructor
  · intro hn
    have hr : (q : ℝ) ^ 2 ≤ 2000 ^ 3 * (h : ℝ) ^ 12 * (s : ℝ) := by
      exact_mod_cast hn
    simpa only [mul_comm] using hr
  · intro hr
    have hn : (q : ℝ) ^ 2 ≤ 2000 ^ 3 * (h : ℝ) ^ 12 * (s : ℝ) := by
      simpa only [mul_comm] using hr
    exact_mod_cast hn

theorem logarithm_conversion {N : ℝ} (hN : 1 ≤ N) :
    Real.log (4 * N) / Real.log 2 ≤
      (2 / Real.log 2) * Real.log (2 * N) := by
  have hlog : Real.log (4 * N) ≤ 2 * Real.log (2 * N) := by
    have h := Real.log_le_log (by linarith : 0 < 4 * N)
      (by nlinarith : 4 * N ≤ (2 * N) ^ 2)
    simpa only [Real.log_pow, Nat.cast_ofNat] using h
  have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  calc
    Real.log (4 * N) / Real.log 2 ≤
        (2 * Real.log (2 * N)) / Real.log 2 :=
      div_le_div_of_nonneg_right hlog hlog2.le
    _ = _ := by ring

def absoluteConstant : ℝ :=
  AuxiliaryZeroCount.countConstant * (2 / Real.log 2)

theorem absoluteConstant_pos : 0 < absoluteConstant := by
  have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  unfold absoluteConstant AuxiliaryZeroCount.countConstant
    ZeroGlobalCount.countConstant ZeroDeterminantCount.planeConstant
  positivity

theorem auxiliary_parameter_bound {h q : ℕ} (hh : 2 ≤ h) (hq : h ^ 26 ≤ q) :
    2000 * (h ^ 2) ^ 2 ≤ q := by
  have h22 : 2000 ≤ h ^ 22 := by
    calc
      2000 ≤ (2 : ℕ) ^ 22 := by norm_num
      _ ≤ h ^ 22 := by gcongr
  calc
    2000 * (h ^ 2) ^ 2 ≤ h ^ 22 * (h ^ 2) ^ 2 :=
      Nat.mul_le_mul_right _ h22
    _ = h ^ 26 := by ring
    _ ≤ q := hq

theorem weighted_law_box_bound
    (D : ZeroDeterminantCount.RowData) (q N : ℕ) [Fact q.Prime]
    (hN : 1 ≤ N) (hEq : IsUnit (D.E : ZMod q))
    (hparam : D.h ^ 26 ≤ (q : ℝ))
    (L : AuxiliarySampling.Law q ((D.B ^ D.k) ^ 2))
    (F : Finset IntMatrix)
    (hdet : ∀ M ∈ F, M.det = 0)
    (hrows : ∀ M ∈ F, ∀ i, M i ∈ D.L)
    (hbox : ∀ M ∈ F, MatrixBox N M)
    (hproj : ∀ M ∈ F, ∀ i j : Fin 3, i ≠ j →
      ((M 0 i : ℝ) / M 2 i, (M 1 i : ℝ) / M 2 i) ≠
      ((M 0 j : ℝ) / M 2 j, (M 1 j : ℝ) / M 2 j)) :
    (∑ M ∈ F, LiftingProbability.auxiliaryWeight q L.size L.weight L.sets
      (M.map (Int.castRingHom (ZMod q))).col) ≤
      absoluteConstant * Real.log (2 * (N : ℝ)) * (N : ℝ) ^ 6 /
        (D.I : ℝ) ^ 2 := by
  have hb := AuxiliaryZeroCount.weighted_count_le_log D q N hN hEq hparam L F
    hdet hrows (fun M hM j => box_height_ne_zero hN (hbox M hM) j)
    hproj (fun M hM i j => box_abs_le (hbox M hM) i j)
  have hscale : 0 ≤ AuxiliaryZeroCount.countConstant * (N : ℝ) ^ 6 /
      (D.I : ℝ) ^ 2 := by
    exact div_nonneg
      (mul_nonneg AuxiliaryZeroCount.countConstant_nonneg (by positivity))
      (by positivity)
  calc
    _ ≤ AuxiliaryZeroCount.countConstant * (N : ℝ) ^ 6 / (D.I : ℝ) ^ 2 *
        (Real.log (4 * (N : ℝ)) / Real.log 2) := hb
    _ ≤ AuxiliaryZeroCount.countConstant * (N : ℝ) ^ 6 / (D.I : ℝ) ^ 2 *
        ((2 / Real.log 2) * Real.log (2 * (N : ℝ))) :=
      mul_le_mul_of_nonneg_left
        (logarithm_conversion (by exact_mod_cast hN)) hscale
    _ = _ := by unfold absoluteConstant; ring

theorem weighted_determinant_zero_bound
    {B k q : ℕ} (hB : B.Prime) [Fact q.Prime]
    (hh : 2 ≤ B ^ k) (hparam : (B ^ k) ^ 26 ≤ q)
    (C : Matrix (Fin 3) (Fin 3) (ZMod (B ^ k))) (d : PrimePowerData B k C)
    (S : Finset (Vector q))
    (hcap : AuxiliaryCap.IsCap (S : Set (Vector q)))
    (hcapbox : ∀ v ∈ S, (v 0).val < q / (1000 * ((B ^ k) ^ 2) ^ 2))
    (hsize : q ^ 2 ≤ 2000 ^ 3 * (B ^ k) ^ 12 * S.card)
    (N : ℕ) (hN : 1 ≤ N) (F : Finset IntMatrix)
    (hdet : ∀ M ∈ F, M.det = 0)
    (hrows : ∀ M ∈ F, ∀ i, M i ∈ PrimePowerRowData.rowModule C)
    (hbox : ∀ M ∈ F, MatrixBox N M)
    (hproj : ∀ M ∈ F, ∀ i j : Fin 3, i ≠ j →
      ((M 0 i : ℝ) / M 2 i, (M 1 i : ℝ) / M 2 i) ≠
      ((M 0 j : ℝ) / M 2 j, (M 1 j : ℝ) / M 2 j)) :
    (∑ M ∈ F, actualWeight q (B ^ k) S M) ≤
      absoluteConstant * Real.log (2 * (N : ℝ)) * (N : ℝ) ^ 6 /
        ((B : ℝ) ^ d.b * (B : ℝ) ^ d.e) ^ 2 := by
  classical
  let h := B ^ k
  let H := h ^ 2
  let w := q / (1000 * H ^ 2)
  let A := allowedShiftSet q H w
  have hhpos : 0 < h := by dsimp [h]; omega
  have hlarge : 2000 * H ^ 2 ≤ q := auxiliary_parameter_bound hh hparam
  have hH : 1 ≤ H := by
    dsimp [H]
    exact one_le_pow₀ (by omega)
  have hw : 1000 * H ^ 2 * w ≤ q := Nat.mul_div_le _ _
  have hmult : 3 * H < q := Auxiliary.auxiliary_multiplier_range q H hH hlarge
  have hHq : H < q := by omega
  have hA : q ^ 3 ≤ 2 * A.card :=
    (Auxiliary.auxiliary_allowed_vector_card_gt_half q H w hH hlarge hw).le
  have hallowed : ∀ a ∈ A, ∀ n : ℕ, 1 ≤ n → n ≤ 3 * H →
      (n : ZMod q) * a 0 ∉ Auxiliary.integerWindow q (3 * H * w) := by
    intro a ha n hn hnH
    have ha' := (Auxiliary.mem_vectorShifts_iff _ a).mp ha
    have ha'' := (Auxiliary.mem_allowedShifts_iff _ _
      (Auxiliary.positiveMultipliers_ne_zero q H hmult) (a 0)).mp ha'
    apply ha''
    exact Finset.mem_image.mpr ⟨n, Finset.mem_Icc.mpr ⟨hn, hnH⟩, rfl⟩
  have hS : S.Nonempty := by
    apply Finset.card_pos.mp
    have hp : 0 < q ^ 2 := pow_pos (Fact.out : q.Prime).pos 2
    by_contra hn
    have hz : S.card = 0 := by omega
    simp only [hz, mul_zero] at hsize
    omega
  have hsize' : q ^ 2 ≤ 2000 ^ 3 * H ^ 6 * S.card := by
    simpa only [H, h, ← pow_mul, Nat.mul_assoc] using hsize
  let L := restrictedLaw hH hHq S hS hcap hcapbox hsize' A hA hallowed
  have hlt : h < q := by
    have hp : h ^ 2 ≤ h ^ 26 :=
      Nat.pow_le_pow_right (by dsimp [h]; omega) (by decide)
    have hs : h < h ^ 2 := by dsimp [h] at *; nlinarith
    exact hs.trans_le (hp.trans hparam)
  have hcop : (B ^ k).Coprime q :=
    Nat.coprime_comm.mpr ((Fact.out : q.Prime).coprime_iff_not_dvd.mpr
      (Nat.not_dvd_of_pos_of_lt (by dsimp [h] at *; omega) hlt))
  have hparamR : ((B : ℝ) ^ k) ^ 26 ≤ (q : ℝ) := by exact_mod_cast hparam
  have hb := weighted_law_box_bound (d.toZeroRowData hB) q N hN
    (d.toZeroRowData_E_isUnit hB hcop) hparamR L F hdet hrows hbox hproj
  have hweight (M : IntMatrix) :
      LiftingProbability.auxiliaryWeight q L.size L.weight L.sets
        (M.map (Int.castRingHom (ZMod q))).col = actualWeight q (B ^ k) S M :=
    restrictedLaw_weight hH hHq S hS hcap hcapbox hsize' A hA hallowed _
  simp_rw [hweight] at hb
  rw [d.toZeroRowData_index_real hB] at hb
  exact hb

theorem manuscript_parameters_bound
    {B k q : ℕ} (hB : B.Prime) [Fact q.Prime]
    (hh : 2 ≤ B ^ k) (hq : (B ^ k) ^ 100 < q)
    (C : Matrix (Fin 3) (Fin 3) (ZMod (B ^ k))) (d : PrimePowerData B k C)
    (S : Finset (Vector q))
    (hcap : AuxiliaryCap.IsCap (S : Set (Vector q)))
    (hcapbox : ∀ v ∈ S, (v 0).val < q / (1000 * ((B ^ k) ^ 2) ^ 2))
    (hsize : q ^ 2 ≤ 2000 ^ 3 * (B ^ k) ^ 12 * S.card)
    (F : Finset IntMatrix)
    (hdet : ∀ M ∈ F, M.det = 0)
    (hrows : ∀ M ∈ F, ∀ i, M i ∈ PrimePowerRowData.rowModule C)
    (hbox : ∀ M ∈ F, MatrixBox ((B ^ k * q) ^ 10) M)
    (hproj : ∀ M ∈ F, ∀ i j : Fin 3, i ≠ j →
      ((M 0 i : ℝ) / M 2 i, (M 1 i : ℝ) / M 2 i) ≠
      ((M 0 j : ℝ) / M 2 j, (M 1 j : ℝ) / M 2 j)) :
    (∑ M ∈ F, actualWeight q (B ^ k) S M) ≤
      absoluteConstant * Real.log (2 * (((B ^ k * q) ^ 10 : ℕ) : ℝ)) *
        (((B ^ k * q) ^ 10 : ℕ) : ℝ) ^ 6 /
        ((B : ℝ) ^ d.b * (B : ℝ) ^ d.e) ^ 2 := by
  have hparam : (B ^ k) ^ 26 ≤ q :=
    (Nat.pow_le_pow_right (by omega : 0 < B ^ k) (by decide : 26 ≤ 100)).trans hq.le
  have hN : 1 ≤ (B ^ k * q) ^ 10 := by
    have hpos : 0 < B ^ k * q := mul_pos (by omega) (Fact.out : q.Prime).pos
    exact one_le_pow₀ (by omega)
  exact weighted_determinant_zero_bound hB hh hparam C d S hcap hcapbox hsize
    ((B ^ k * q) ^ 10) hN F hdet hrows hbox hproj

theorem manuscript_zero_count
    {B k q : ℕ} (hB : B.Prime) [Fact q.Prime]
    (hh : 2 ≤ B ^ k) (hq : (B ^ k) ^ 100 < q)
    (C : Matrix (Fin 3) (Fin 3) (ZMod (B ^ k))) (d : PrimePowerData B k C)
    (S : Finset (Vector q))
    (hcap : AuxiliaryCap.IsCap (S : Set (Vector q)))
    (hcapbox : ∀ v ∈ S, (v 0).val < q / (1000 * ((B ^ k) ^ 2) ^ 2))
    (hsize : (q : ℝ) ^ 2 /
      (2000 ^ 3 * (((B ^ k : ℕ) : ℝ) ^ 12)) ≤ (S.card : ℝ)) :
    (∑ M ∈ zeroMatrices C ((B ^ k * q) ^ 10), actualWeight q (B ^ k) S M) ≤
      absoluteConstant * Real.log (2 * (((B ^ k * q) ^ 10 : ℕ) : ℝ)) *
        (((B ^ k * q) ^ 10 : ℕ) : ℝ) ^ 6 /
        ((B : ℝ) ^ d.b * (B : ℝ) ^ d.e) ^ 2 := by
  have hsizeNat := (cap_size_bound_iff (by omega : 0 < B ^ k)).mpr hsize
  apply manuscript_parameters_bound hB hh hq C d S hcap hcapbox hsizeNat
    (zeroMatrices C ((B ^ k * q) ^ 10))
  · intro M hM
    exact (mem_zeroMatrices.mp hM).2.2.1
  · intro M hM
    exact (mem_zeroMatrices.mp hM).2.1
  · intro M hM
    exact (mem_zeroMatrices.mp hM).1
  · intro M hM
    exact (mem_zeroMatrices.mp hM).2.2.2

#print axioms OAI.Problem355.ZeroGlobalCount.weighted_count_le_log
#print axioms OAI.Problem355.AuxiliaryZeroCount.weighted_count_le_log
#print axioms uniform_weight_eq
#print axioms restrictedWeight_eq_uniform_product
#print axioms restrictedLaw
#print axioms logarithm_conversion
#print axioms cap_size_bound_iff
#print axioms mem_zeroMatrices
#print axioms weighted_law_box_bound
#print axioms weighted_determinant_zero_bound
#print axioms manuscript_parameters_bound
#print axioms manuscript_zero_count

end ZeroWeightedCount
