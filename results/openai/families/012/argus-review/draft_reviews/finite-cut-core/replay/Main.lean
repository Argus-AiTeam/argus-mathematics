import Mathlib

open scoped BigOperators

noncomputable section

namespace AdaptiveCutTransfer

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def signPlus (x : ℝ) : ℝ := if 0 ≤ x then 1 else -1

theorem abs_signPlus (x : ℝ) : |signPlus x| = 1 := by
  unfold signPlus
  split_ifs <;> norm_num

theorem response_loss (r h : ℝ) :
    |r| - r * signPlus h ≤ 2 * |r - h| := by
  by_cases hh : 0 ≤ h
  · rw [signPlus, if_pos hh, mul_one]
    by_cases hr : 0 ≤ r
    · rw [abs_of_nonneg hr]
      linarith [abs_nonneg (r - h)]
    · rw [abs_of_neg (lt_of_not_ge hr)]
      linarith [neg_le_abs (r - h)]
  · rw [signPlus, if_neg hh, mul_neg_one]
    by_cases hr : 0 ≤ r
    · rw [abs_of_nonneg hr]
      have hh' : h < 0 := lt_of_not_ge hh
      linarith [le_abs_self (r - h)]
    · rw [abs_of_neg (lt_of_not_ge hr)]
      linarith [abs_nonneg (r - h)]

theorem test_le_abs (x z : ℝ) (hz : |z| ≤ 1) : x * z ≤ |x| := by
  calc
    x * z ≤ |x * z| := le_abs_self _
    _ = |x| * |z| := abs_mul _ _
    _ ≤ |x| * 1 := mul_le_mul_of_nonneg_left hz (abs_nonneg x)
    _ = |x| := mul_one _

def response (X : ι → ι → ℝ) : ℝ := ∑ k, |∑ i, X i k|

theorem adaptive_response_bound (A : ι → ι → ℝ) (δ h : ι → ℝ)
    (hδ : ∀ k, |δ k| ≤ 1) :
    (∑ i, |∑ k, A i k * δ k|) ≤
      (∑ k, |∑ i, A i k * signPlus (h i)|) +
        2 * ∑ i, |(∑ k, A i k * δ k) - h i| := by
  have loss :
      (∑ i, (|∑ k, A i k * δ k| -
        (∑ k, A i k * δ k) * signPlus (h i))) ≤
          2 * ∑ i, |(∑ k, A i k * δ k) - h i| := by
    calc
      _ ≤ ∑ i, 2 * |(∑ k, A i k * δ k) - h i| :=
        Finset.sum_le_sum fun i _ => response_loss _ _
      _ = _ := by rw [Finset.mul_sum]
  have swap :
      (∑ i, (∑ k, A i k * δ k) * signPlus (h i)) =
        ∑ k, (∑ i, A i k * signPlus (h i)) * δ k := by
    simp_rw [Finset.sum_mul]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro k _
    apply Finset.sum_congr rfl
    intro i _
    ring
  have bound :
      (∑ i, (∑ k, A i k * δ k) * signPlus (h i)) ≤
        ∑ k, |∑ i, A i k * signPlus (h i)| := by
    rw [swap]
    exact Finset.sum_le_sum fun k _ => test_le_abs _ _ (hδ k)
  rw [Finset.sum_sub_distrib] at loss
  linarith

theorem response_difference (X Y : ι → ι → ℝ) :
    |response X - response Y| ≤ ∑ i, ∑ k, |X i k - Y i k| := by
  unfold response
  calc
    |(∑ k, |∑ i, X i k|) - (∑ k, |∑ i, Y i k|)| =
        |∑ k, (|∑ i, X i k| - |∑ i, Y i k|)| := by
      rw [Finset.sum_sub_distrib]
    _ ≤ ∑ k, abs (|∑ i, X i k| - |∑ i, Y i k|) :=
      Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ k, ∑ i, |X i k - Y i k| := by
      apply Finset.sum_le_sum
      intro k _
      calc
        abs (|∑ i, X i k| - |∑ i, Y i k|) ≤
            |(∑ i, X i k) - ∑ i, Y i k| :=
          abs_abs_sub_abs_le_abs_sub _ _
        _ = |∑ i, (X i k - Y i k)| := by rw [Finset.sum_sub_distrib]
        _ ≤ ∑ i, |X i k - Y i k| := Finset.abs_sum_le_sum_abs _ _
    _ = ∑ i, ∑ k, |X i k - Y i k| := Finset.sum_comm

theorem incident_mass_bound (W : ι → ι → ℝ) (J : Finset ι) (d : ℝ)
    (hW : ∀ i k, 0 ≤ W i k)
    (hoff : ∀ i k, i ∉ J → k ∉ J → W i k = 0)
    (hrow : ∀ i, ∑ k, W i k ≤ d)
    (hcol : ∀ k, ∑ i, W i k ≤ d) :
    (∑ i, ∑ k, W i k) ≤ 2 * (J.card : ℝ) * d := by
  have point (i k : ι) :
      W i k ≤ (if i ∈ J then W i k else 0) +
        (if k ∈ J then W i k else 0) := by
    by_cases hi : i ∈ J
    · by_cases hk : k ∈ J
      · simp only [if_pos hi, if_pos hk]
        linarith [hW i k]
      · simp [hi, hk]
    · by_cases hk : k ∈ J
      · simp [hi, hk]
      · simp [hi, hk, hoff i k hi hk]
  have first :
      (∑ i, ∑ k, if i ∈ J then W i k else 0) ≤ (J.card : ℝ) * d := by
    calc
      _ ≤ ∑ i, if i ∈ J then d else 0 := by
        apply Finset.sum_le_sum
        intro i _
        by_cases hi : i ∈ J
        · simpa [hi] using hrow i
        · simp [hi]
      _ = _ := by simp
  have second :
      (∑ i, ∑ k, if k ∈ J then W i k else 0) ≤ (J.card : ℝ) * d := by
    rw [Finset.sum_comm]
    calc
      _ ≤ ∑ k, if k ∈ J then d else 0 := by
        apply Finset.sum_le_sum
        intro k _
        by_cases hk : k ∈ J
        · simpa [hk] using hcol k
        · simp [hk]
      _ = _ := by simp
  calc
    _ ≤ ∑ i, ∑ k,
        ((if i ∈ J then W i k else 0) + (if k ∈ J then W i k else 0)) :=
      Finset.sum_le_sum fun i _ => Finset.sum_le_sum fun k _ => point i k
    _ = (∑ i, ∑ k, if i ∈ J then W i k else 0) +
        (∑ i, ∑ k, if k ∈ J then W i k else 0) := by
      simp_rw [Finset.sum_add_distrib]
    _ ≤ (J.card : ℝ) * d + (J.card : ℝ) * d := add_le_add first second
    _ = _ := by ring

theorem good_configuration_lipschitz (X Y : ι → ι → ℝ)
    (J : Finset ι) (d : ℝ)
    (hoff : ∀ i k, i ∉ J → k ∉ J → X i k = Y i k)
    (hrowX : ∀ i, ∑ k, |X i k| ≤ d)
    (hcolX : ∀ k, ∑ i, |X i k| ≤ d)
    (hrowY : ∀ i, ∑ k, |Y i k| ≤ d)
    (hcolY : ∀ k, ∑ i, |Y i k| ≤ d) :
    |response X - response Y| ≤ 4 * d * (J.card : ℝ) := by
  have point (i k : ι) : |X i k - Y i k| ≤ |X i k| + |Y i k| := by
    simpa using abs_sub_le (X i k) 0 (Y i k)
  have row : ∀ i, ∑ k, |X i k - Y i k| ≤ 2 * d := by
    intro i
    calc
      _ ≤ ∑ k, (|X i k| + |Y i k|) := Finset.sum_le_sum fun k _ => point i k
      _ = (∑ k, |X i k|) + ∑ k, |Y i k| := Finset.sum_add_distrib
      _ ≤ d + d := add_le_add (hrowX i) (hrowY i)
      _ = _ := by ring
  have col : ∀ k, ∑ i, |X i k - Y i k| ≤ 2 * d := by
    intro k
    calc
      _ ≤ ∑ i, (|X i k| + |Y i k|) := Finset.sum_le_sum fun i _ => point i k
      _ = (∑ i, |X i k|) + ∑ i, |Y i k| := Finset.sum_add_distrib
      _ ≤ d + d := add_le_add (hcolX k) (hcolY k)
      _ = _ := by ring
  calc
    _ ≤ ∑ i, ∑ k, |X i k - Y i k| := response_difference X Y
    _ ≤ 2 * (J.card : ℝ) * (2 * d) :=
      incident_mass_bound _ J (2 * d) (fun i k => abs_nonneg _)
        (by intro i k hi hk; rw [hoff i k hi hk, sub_self, abs_zero]) row col
    _ = _ := by ring

def deleteVertices (X : ι → ι → ℝ) (J : Finset ι) (i k : ι) : ℝ :=
  if i ∈ J ∨ k ∈ J then 0 else X i k

theorem deletion_bound (X : ι → ι → ℝ) (J : Finset ι) (d : ℝ)
    (hrow : ∀ i, ∑ k, |X i k| ≤ d)
    (hcol : ∀ k, ∑ i, |X i k| ≤ d) :
    response X ≤ response (deleteVertices X J) + 2 * (J.card : ℝ) * d := by
  have point (i k : ι) :
      |X i k - deleteVertices X J i k| ≤ |X i k| := by
    unfold deleteVertices
    split_ifs <;> simp
  have row : ∀ i, ∑ k, |X i k - deleteVertices X J i k| ≤ d := by
    intro i
    exact (Finset.sum_le_sum fun k _ => point i k).trans (hrow i)
  have col : ∀ k, ∑ i, |X i k - deleteVertices X J i k| ≤ d := by
    intro k
    exact (Finset.sum_le_sum fun i _ => point i k).trans (hcol k)
  have mass :
      (∑ i, ∑ k, |X i k - deleteVertices X J i k|) ≤
        2 * (J.card : ℝ) * d := by
    apply incident_mass_bound _ J d (fun i k => abs_nonneg _) _ row col
    intro i k hi hk
    simp [deleteVertices, hi, hk]
  have hd := (response_difference X (deleteVertices X J)).trans mass
  have hs := le_abs_self (response X - response (deleteVertices X J))
  linarith

theorem adaptive_deleted_response_bound (A : ι → ι → ℝ)
    (δ h : ι → ℝ) (J : Finset ι) (d : ℝ)
    (hδ : ∀ k, |δ k| ≤ 1)
    (hrow : ∀ i, ∑ k, |A i k| ≤ d)
    (hcol : ∀ k, ∑ i, |A i k| ≤ d) :
    (∑ i, |∑ k, A i k * δ k|) ≤
      response (deleteVertices (fun i k => A i k * signPlus (h i)) J) +
        2 * ∑ i, |(∑ k, A i k * δ k) - h i| +
        2 * (J.card : ℝ) * d := by
  have row : ∀ i, ∑ k, |A i k * signPlus (h i)| ≤ d := by
    intro i
    simpa only [abs_mul, abs_signPlus, mul_one] using hrow i
  have col : ∀ k, ∑ i, |A i k * signPlus (h i)| ≤ d := by
    intro k
    simpa only [abs_mul, abs_signPlus, mul_one] using hcol k
  have ha := adaptive_response_bound A δ h hδ
  have hd := deletion_bound (fun i k => A i k * signPlus (h i)) J d row col
  dsimp only [response] at hd ⊢
  linarith

end AdaptiveCutTransfer
