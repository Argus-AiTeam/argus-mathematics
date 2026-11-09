import Mathlib

noncomputable section

open scoped BigOperators
open Finset

namespace LSChain

def rectangleDegrees (H : ℕ) (V : ℝ) : Fin 3 → ℕ :=
  ![⌊32 * (H : ℝ) * V⌋₊, ⌊32 * V⌋₊, ⌊32 * V⌋₊]

def weightBound (H : ℕ) (V : ℝ) : ℕ := ⌊96 * (H : ℝ) * V⌋₊

theorem rectangle_budget
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ)
    (hV : (N : ℝ) ≤ V) (hvol : (H : ℝ) * V ^ 3 = (N : ℝ) ^ 4) :
    (∀ j, 3 * (N - 1) ≤ rectangleDegrees H V j) ∧
      (4 * N - 3) ^ 4 <
        ∏ j, (rectangleDegrees H V j - 3 * (N - 1) + 1) ∧
      rectangleDegrees H V 0 +
          H * (rectangleDegrees H V 1 + rectangleDegrees H V 2) ≤ weightBound H V := by
  have hNr : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hHr : (1 : ℝ) ≤ H := by exact_mod_cast hH
  have hVp : 0 < V := by linarith
  let T : Fin 3 → ℝ := ![32 * (H : ℝ) * V, 32 * V, 32 * V]
  have htdef : ∀ j, rectangleDegrees H V j = ⌊T j⌋₊ := by
    intro j
    fin_cases j <;> rfl
  have hT : ∀ j, 32 * (N : ℝ) ≤ T j := by
    intro j
    fin_cases j <;> simp [T]
    · nlinarith
    · linarith
    · linarith
  have hpos : ∀ j, 0 ≤ T j := fun j => by have := hT j; linarith
  have hD : ((3 * (N - 1) : ℕ) : ℝ) ≤ 3 * (N : ℝ) := by
    exact_mod_cast Nat.mul_le_mul_left 3 (Nat.sub_le N 1)
  have ht : ∀ j, 3 * (N - 1) ≤ rectangleDegrees H V j := by
    intro j
    rw [htdef]
    apply Nat.le_floor
    have := hT j
    linarith
  have hfactor : ∀ j, T j / 2 <
      ((rectangleDegrees H V j - 3 * (N - 1) + 1 : ℕ) : ℝ) := by
    intro j
    have hf := Nat.lt_floor_add_one (T j)
    rw [← htdef] at hf
    rw [Nat.cast_add, Nat.cast_one, Nat.cast_sub (ht j)]
    have := hT j
    linarith
  have hprod :
      (∏ j, T j / 2) <
        ∏ j, ((rectangleDegrees H V j - 3 * (N - 1) + 1 : ℕ) : ℝ) :=
    Finset.prod_lt_prod_of_nonempty
      (fun j _ => by have := hT j; linarith)
      (fun j _ => hfactor j) (by simp)
  have hTprod : (∏ j, T j / 2) = 4096 * (N : ℝ) ^ 4 := by
    simp only [Fin.prod_univ_succ, T, Matrix.cons_val_zero, Fin.isValue]
    dsimp
    calc
      (32 * (H : ℝ) * V / 2) * ((32 * V / 2) * ((32 * V / 2) * 1)) =
          4096 * ((H : ℝ) * V ^ 3) := by ring
      _ = _ := by rw [hvol]
  have hmargin : (4 * N - 3) ^ 4 < 4096 * N ^ 4 := by
    have hb := Nat.pow_le_pow_left (Nat.sub_le (4 * N) 3) 4
    have hnp : 0 < N ^ 4 := pow_pos (by omega) _
    rw [mul_pow] at hb
    norm_num at hb
    nlinarith
  have hbudget : (4 * N - 3) ^ 4 <
      ∏ j, (rectangleDegrees H V j - 3 * (N - 1) + 1) := by
    rw [hTprod] at hprod
    have hm : (((4 * N - 3) ^ 4 : ℕ) : ℝ) < 4096 * (N : ℝ) ^ 4 := by
      exact_mod_cast hmargin
    exact_mod_cast hm.trans hprod
  refine ⟨ht, hbudget, ?_⟩
  apply Nat.le_floor
  have h0 := Nat.floor_le (hpos 0)
  have h1 := Nat.floor_le (hpos 1)
  have h2 := Nat.floor_le (hpos 2)
  change (rectangleDegrees H V 0 : ℝ) ≤ 32 * (H : ℝ) * V at h0
  change (rectangleDegrees H V 1 : ℝ) ≤ 32 * V at h1
  change (rectangleDegrees H V 2 : ℝ) ≤ 32 * V at h2
  push_cast
  nlinarith

theorem coordinate_capacity_bound
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ) (hV : (N : ℝ) ≤ V) :
    ((weightBound H V / H : ℕ) : ℝ) ≤ 96 * V ∧
      (((weightBound H V / H + 1) ^ 2 : ℕ) : ℝ) ≤ 97 ^ 2 * V ^ 2 := by
  have hNr : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hHr : (1 : ℝ) ≤ H := by exact_mod_cast hH
  have hVp : 0 < V := by linarith
  have hW : (weightBound H V : ℝ) ≤ 96 * (H : ℝ) * V :=
    Nat.floor_le (by positivity)
  have hdiv : ((weightBound H V / H : ℕ) : ℝ) * (H : ℝ) ≤ weightBound H V := by
    exact_mod_cast Nat.div_mul_le_self (weightBound H V) H
  have hB : ((weightBound H V / H : ℕ) : ℝ) ≤ 96 * V := by
    nlinarith
  refine ⟨hB, ?_⟩
  have hQ : ((weightBound H V / H + 1 : ℕ) : ℝ) ≤ 97 * V := by
    push_cast
    linarith
  have hs := sq_le_sq₀ (by positivity : 0 ≤ ((weightBound H V / H + 1 : ℕ) : ℝ))
    (by positivity : 0 ≤ 97 * V)
  have hh := hs.mpr hQ
  push_cast at hh ⊢
  nlinarith

theorem capacity_threshold
    (N H : ℕ) (hN : 1 ≤ N) (hH : 1 ≤ H) (V : ℝ)
    (hV : (N : ℝ) ≤ V) (hvol : (H : ℝ) * V ^ 3 = (N : ℝ) ^ 4)
    (hthreshold : 2 * 97 ^ 2 ≤ (H : ℝ) * V) :
    2 * (weightBound H V / H + 1) ^ 2 ≤ N ^ 4 := by
  have hQ := (coordinate_capacity_bound N H hN hH V hV).2
  have ht := mul_le_mul_of_nonneg_right hthreshold (sq_nonneg V)
  have hbound :
      (2 : ℝ) * (((weightBound H V / H + 1) ^ 2 : ℕ) : ℝ) ≤ (N : ℝ) ^ 4 := by
    nlinarith
  exact_mod_cast hbound

def manuscriptScale (N H : ℕ) : ℝ :=
  (H : ℝ) ^ (-(1 : ℝ) / 3) * (N : ℝ) ^ ((4 : ℝ) / 3)

theorem manuscript_scale_weight (N H : ℕ) (hH : 1 ≤ H) :
    (H : ℝ) * manuscriptScale N H =
      (H : ℝ) ^ ((2 : ℝ) / 3) * (N : ℝ) ^ ((4 : ℝ) / 3) := by
  have hHp : (0 : ℝ) < H := by exact_mod_cast (show 0 < H by omega)
  have hh : (H : ℝ) * (H : ℝ) ^ (-(1 : ℝ) / 3) =
      (H : ℝ) ^ ((2 : ℝ) / 3) := by
    calc
      (H : ℝ) * (H : ℝ) ^ (-(1 : ℝ) / 3) =
          (H : ℝ) ^ (1 : ℝ) * (H : ℝ) ^ (-(1 : ℝ) / 3) := by
        rw [Real.rpow_one]
      _ = (H : ℝ) ^ ((1 : ℝ) + (-(1 : ℝ) / 3)) := (Real.rpow_add hHp _ _).symm
      _ = _ := by norm_num
  simpa only [manuscriptScale, ← mul_assoc] using
    congrArg (fun x => x * (N : ℝ) ^ ((4 : ℝ) / 3)) hh

theorem manuscript_scale_properties (N H : ℕ) (hH : 1 ≤ H) (hHN : H ≤ N) :
    (N : ℝ) ≤ manuscriptScale N H ∧
      (H : ℝ) * manuscriptScale N H ^ 3 = (N : ℝ) ^ 4 := by
  have hHp : (0 : ℝ) < H := by exact_mod_cast (show 0 < H by omega)
  have hNp : (0 : ℝ) < N := by exact_mod_cast (show 0 < N by omega)
  have hHN' : (H : ℝ) ≤ N := by exact_mod_cast hHN
  have hHcube :
      ((H : ℝ) ^ (-(1 : ℝ) / 3)) ^ 3 = (H : ℝ)⁻¹ := by
    rw [← Real.rpow_mul_natCast hHp.le]
    norm_num [Real.rpow_neg_one]
  have hNcube : ((N : ℝ) ^ ((4 : ℝ) / 3)) ^ 3 = (N : ℝ) ^ 4 := by
    rw [← Real.rpow_mul_natCast hNp.le]
    norm_num
  have hcube : manuscriptScale N H ^ 3 = (H : ℝ)⁻¹ * (N : ℝ) ^ 4 := by
    simp only [manuscriptScale, mul_pow, hHcube, hNcube]
  have hvolume : (H : ℝ) * manuscriptScale N H ^ 3 = (N : ℝ) ^ 4 := by
    rw [hcube]
    field_simp
  refine ⟨?_, hvolume⟩
  have hVp : 0 < manuscriptScale N H := by
    exact mul_pos (Real.rpow_pos_of_pos hHp _) (Real.rpow_pos_of_pos hNp _)
  have hcube_le : (N : ℝ) ^ 3 ≤ manuscriptScale N H ^ 3 := by
    have hh := mul_le_mul_of_nonneg_right hHN' (pow_nonneg hNp.le 3)
    nlinarith
  exact (pow_le_pow_iff_left₀ hNp.le hVp.le (by norm_num : (3 : ℕ) ≠ 0)).mp hcube_le

end LSChain
