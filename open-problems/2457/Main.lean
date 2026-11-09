import Mathlib

open scoped BigOperators

namespace LiV2AffineDual

def seed (L : ℕ) : ℕ :=
  ∏ d ∈ Finset.Ico 1 L, (2 ^ d - 1)

def row (L i : ℕ) : ℕ :=
  2 ^ i * seed L + 1

def endpointWeight (L j : ℕ) : ℚ :=
  ∑ i ∈ Finset.range j, 1 / ((row L j : ℚ) - row L i)

noncomputable def normalizedCost (L : ℕ) : ℝ :=
  (∑ _i ∈ Finset.range (L - 1), Real.log 2) / L

structure UniversalCertificate (L : ℕ) : Prop where
  recurrence :
    ∀ i : ℕ, row L (i + 1) = 2 * row L i - 1
  strictIncrease :
    ∀ i j : ℕ, i < j → j < L → row L i < row L j
  pairwiseCoprime :
    ∀ i j : ℕ, i < j → j < L → Nat.Coprime (row L i) (row L j)
  endpointDistance :
    ∀ i j : ℕ, i < j → j < L →
      row L j - row L i = (2 ^ j - 2 ^ i) * seed L
  endpointWeightBound :
    ∀ j : ℕ, 1 ≤ j → j < L →
      endpointWeight L j ≤
        (j : ℚ) / (((2 ^ (j - 1) * seed L : ℕ) : ℚ))
  accumulatedWeightBound :
    (∑ j ∈ Finset.Ico 1 L, endpointWeight L j) <
      4 / (seed L : ℚ)
  exactNormalizedCost :
    normalizedCost L =
      (((L - 1 : ℕ) : ℝ) / (L : ℝ)) * Real.log 2
  seedLowerBound :
    2 ^ ((L - 1) * (L - 2) / 2) ≤ seed L

private lemma seed_pos (L : ℕ) : 0 < seed L := by
  simp only [seed]
  apply Finset.prod_pos
  intro d hd
  have hd1 : 1 ≤ d := (Finset.mem_Ico.mp hd).1
  have hp : 1 < 2 ^ d := Nat.one_lt_pow (by omega) (by omega)
  omega

private lemma row_strict (L i j : ℕ) (hij : i < j) :
    row L i < row L j := by
  have hp : 2 ^ i < 2 ^ j := Nat.pow_lt_pow_right (by omega) hij
  have hs : 0 < seed L := seed_pos L
  simp only [row]
  exact Nat.add_lt_add_right (Nat.mul_lt_mul_of_pos_right hp hs) 1

private lemma endpoint_distance_eq (L i j : ℕ) :
    row L j - row L i = (2 ^ j - 2 ^ i) * seed L := by
  simp only [row]
  rw [Nat.add_sub_add_right, Nat.sub_mul]

private lemma pow_gap_lower (i j : ℕ) (hij : i < j) :
    2 ^ (j - 1) ≤ 2 ^ j - 2 ^ i := by
  have hi : i ≤ j - 1 := by omega
  have hpowi : 2 ^ i ≤ 2 ^ (j - 1) :=
    Nat.pow_le_pow_right (by omega) hi
  have hj : j - 1 + 1 = j := by omega
  have hpowj : 2 ^ j = 2 * 2 ^ (j - 1) := by
    calc
      2 ^ j = 2 ^ (j - 1 + 1) := by rw [hj]
      _ = 2 * 2 ^ (j - 1) := by rw [pow_succ]; omega
  omega

private lemma pairwise_coprime (L i j : ℕ) (hij : i < j) (hjL : j < L) :
    Nat.Coprime (row L i) (row L j) := by
  rw [Nat.coprime_iff_gcd_eq_one]
  let g := Nat.gcd (row L i) (row L j)
  have hgi : g ∣ row L i := Nat.gcd_dvd_left _ _
  have hgj : g ∣ row L j := Nat.gcd_dvd_right _ _
  have hpow : 2 ^ (j - i) * row L i =
      row L j + (2 ^ (j - i) - 1) := by
    have hji : i ≤ j := Nat.le_of_lt hij
    have hp1 : 1 ≤ 2 ^ (j - i) := Nat.one_le_pow _ _ (by omega)
    simp only [row]
    rw [mul_add, ← mul_assoc, Nat.pow_sub_mul_pow 2 hji]
    omega
  have hgmul : g ∣ 2 ^ (j - i) * row L i :=
    dvd_mul_of_dvd_right hgi _
  have hggap : g ∣ 2 ^ (j - i) - 1 := by
    apply (Nat.dvd_add_iff_right hgj).mpr
    rwa [← hpow]
  have hgapSeed : 2 ^ (j - i) - 1 ∣ seed L := by
    simpa only [seed] using
      (Finset.dvd_prod_of_mem (fun d => 2 ^ d - 1)
        (Finset.mem_Ico.mpr ⟨by omega, by omega⟩))
  have hgSeed : g ∣ seed L := dvd_trans hggap hgapSeed
  have hgScaled : g ∣ 2 ^ i * seed L :=
    dvd_mul_of_dvd_right hgSeed _
  have hgOne : g ∣ 1 := by
    have := Nat.dvd_sub hgi hgScaled
    simpa only [row, Nat.add_sub_cancel_left] using this
  exact Nat.dvd_one.mp hgOne

private lemma endpoint_weight_bound (L j : ℕ) (hj1 : 1 ≤ j) :
    endpointWeight L j ≤
      (j : ℚ) / (((2 ^ (j - 1) * seed L : ℕ) : ℚ)) := by
  have hs : 0 < seed L := seed_pos L
  have hbaseN : 0 < 2 ^ (j - 1) * seed L :=
    Nat.mul_pos (pow_pos (by omega) _) hs
  unfold endpointWeight
  calc
    (∑ i ∈ Finset.range j, 1 / ((row L j : ℚ) - row L i)) ≤
        ∑ _i ∈ Finset.range j,
          1 / (((2 ^ (j - 1) * seed L : ℕ) : ℚ)) := by
      apply Finset.sum_le_sum
      intro i hi
      have hij : i < j := Finset.mem_range.mp hi
      have hrow : row L i ≤ row L j :=
        Nat.le_of_lt (row_strict L i j hij)
      have hgapN :
          2 ^ (j - 1) * seed L ≤ row L j - row L i := by
        rw [endpoint_distance_eq]
        exact Nat.mul_le_mul_right (seed L) (pow_gap_lower i j hij)
      have hden :
          (((2 ^ (j - 1) * seed L : ℕ) : ℚ)) ≤
            (row L j : ℚ) - row L i := by
        rw [← Nat.cast_sub hrow]
        exact_mod_cast hgapN
      exact one_div_le_one_div_of_le (by exact_mod_cast hbaseN) hden
    _ = (j : ℚ) / (((2 ^ (j - 1) * seed L : ℕ) : ℚ)) := by
      rw [Finset.sum_const, Finset.card_range]
      simp only [nsmul_eq_mul, Nat.cast_ofNat]
      ring

private lemma weighted_sum_identity (n : ℕ) :
    (∑ k ∈ Finset.range n, ((k + 1 : ℕ) : ℚ) / (2 : ℚ) ^ k) =
      4 - (2 * (n : ℚ) + 4) / (2 : ℚ) ^ n := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      rw [Finset.sum_range_succ, ih, pow_succ]
      push_cast
      field_simp
      ring

private lemma weighted_sum_lt_four (L : ℕ) :
    (∑ j ∈ Finset.Ico 1 L, (j : ℚ) / (2 : ℚ) ^ (j - 1)) < 4 := by
  rw [Finset.sum_Ico_eq_sum_range]
  have hshift :
      (∑ k ∈ Finset.range (L - 1),
          ((1 + k : ℕ) : ℚ) / (2 : ℚ) ^ (1 + k - 1)) =
        ∑ k ∈ Finset.range (L - 1),
          ((k + 1 : ℕ) : ℚ) / (2 : ℚ) ^ k := by
    apply Finset.sum_congr rfl
    intro k _hk
    congr 2 <;> omega
  rw [hshift, weighted_sum_identity]
  have hrem :
      0 < (2 * ((L - 1 : ℕ) : ℚ) + 4) / (2 : ℚ) ^ (L - 1) := by
    positivity
  linarith

private lemma seed_lower_bound (L : ℕ) :
    2 ^ ((L - 1) * (L - 2) / 2) ≤ seed L := by
  have hsum :
      (∑ d ∈ Finset.Ico 1 L, (d - 1)) =
        (L - 1) * (L - 2) / 2 := by
    rw [Finset.sum_Ico_eq_sum_range]
    simp only [Nat.add_sub_cancel_left]
    rw [Finset.sum_range_id]
    congr 2
  rw [← hsum, ← Finset.prod_pow_eq_pow_sum]
  simp only [seed]
  apply Finset.prod_le_prod
  · intro d hd
    exact Nat.zero_le _
  · intro d hd
    have hd1 : 1 ≤ d := (Finset.mem_Ico.mp hd).1
    have he : d - 1 + 1 = d := by omega
    have hp : 2 ^ d = 2 ^ (d - 1) * 2 := by
      rw [← pow_succ, he]
    have hp1 : 1 ≤ 2 ^ (d - 1) := Nat.one_le_pow _ _ (by omega)
    omega

theorem universal_constant_two_certificate (L : ℕ) (hL : 2 ≤ L) :
    UniversalCertificate L := by
  refine
    { recurrence := ?_
      strictIncrease := ?_
      pairwiseCoprime := ?_
      endpointDistance := ?_
      endpointWeightBound := ?_
      accumulatedWeightBound := ?_
      exactNormalizedCost := ?_
      seedLowerBound := ?_ }
  · intro i
    simp only [row, pow_succ]
    rw [show 2 ^ i * 2 * seed L = 2 * (2 ^ i * seed L) by ring]
    omega
  · intro i j hij _hjL
    exact row_strict L i j hij
  · intro i j hij hjL
    exact pairwise_coprime L i j hij hjL
  · intro i j _hij _hjL
    exact endpoint_distance_eq L i j
  · intro j hj1 _hjL
    exact endpoint_weight_bound L j hj1
  · have hs : 0 < seed L := seed_pos L
    calc
      (∑ j ∈ Finset.Ico 1 L, endpointWeight L j) ≤
          ∑ j ∈ Finset.Ico 1 L,
            (j : ℚ) / (((2 ^ (j - 1) * seed L : ℕ) : ℚ)) := by
        apply Finset.sum_le_sum
        intro j hj
        exact endpoint_weight_bound L j (Finset.mem_Ico.mp hj).1
      _ = (∑ j ∈ Finset.Ico 1 L,
            (j : ℚ) / (2 : ℚ) ^ (j - 1)) / (seed L : ℚ) := by
        rw [Finset.sum_div]
        apply Finset.sum_congr rfl
        intro j _hj
        push_cast
        field_simp
      _ < 4 / (seed L : ℚ) :=
        div_lt_div_of_pos_right (weighted_sum_lt_four L)
          (by exact_mod_cast hs)
  · simp only [normalizedCost, Finset.sum_const, Finset.card_range,
      nsmul_eq_mul]
    ring
  · exact seed_lower_bound L

end LiV2AffineDual
