import Mathlib

set_option autoImplicit false

namespace FourStateConeAudit

def taylor1 (z : ℝ) : ℝ :=
  6 - 15 * z + 20 * z ^ 2 - 15 * z ^ 3 + 6 * z ^ 4 - z ^ 5

def taylor5 (z : ℝ) : ℝ :=
  252 - 1050 * z + 1800 * z ^ 2 - 1575 * z ^ 3 + 700 * z ^ 4 - 126 * z ^ 5

def quotient5 (z : ℝ) : ℝ :=
  1 + 6 * z + 21 * z ^ 2 + 56 * z ^ 3 + 126 * z ^ 4

theorem remainder1 (z : ℝ) :
    1 - z * taylor1 z = (z - 1) ^ 6 := by
  dsimp [taylor1]
  ring

theorem remainder5 (z : ℝ) :
    1 - z ^ 5 * taylor5 z = (z - 1) ^ 6 * quotient5 z := by
  dsimp [taylor5, quotient5]
  ring

theorem reciprocal1_lower (z : ℝ) (hz : 0 < z) :
    taylor1 z ≤ 1 / z := by
  have h : 0 ≤ 1 - z * taylor1 z := by
    rw [remainder1]
    positivity
  apply (le_div_iff₀ hz).2
  nlinarith only [h]

theorem reciprocal5_lower (z : ℝ) (hz : 0 < z) :
    taylor5 z ≤ 1 / z ^ 5 := by
  have hq : 0 ≤ quotient5 z := by
    dsimp [quotient5]
    positivity
  have h : 0 ≤ 1 - z ^ 5 * taylor5 z := by
    rw [remainder5]
    exact mul_nonneg (by positivity) hq
  apply (le_div_iff₀ (pow_pos hz 5)).2
  nlinarith only [h]

theorem shifted_reciprocal_lower (N z m t : ℝ) (k : ℕ)
    (hz : 0 < z) (hfactor : 0 ≤ N + m * z ^ (k + 1))
    (ht : t ≤ 1 / z ^ k) :
    (N + m * z ^ (k + 1)) * t - m * z ≤ N / z ^ k := by
  have h := mul_le_mul_of_nonneg_left ht hfactor
  have hid :
      (N + m * z ^ (k + 1)) * (1 / z ^ k) - m * z = N / z ^ k := by
    rw [pow_succ]
    field_simp [ne_of_gt hz]
    ring
  calc
    _ ≤ (N + m * z ^ (k + 1)) * (1 / z ^ k) - m * z :=
      sub_le_sub_right h _
    _ = _ := hid

theorem corrected_remainder_lower (N z J c : ℝ) (k : ℕ)
    (hz : 0 < z) (hrem : 0 ≤ N - z ^ k * J + c * z ^ k) :
    J - c ≤ N / z ^ k := by
  apply (le_div_iff₀ (pow_pos hz k)).2
  nlinarith only [hrem]

theorem coefficient_nonnegative {ι : Type*} (s : Finset ι)
    (coefficient monomial : ι → ℝ)
    (hc : ∀ i ∈ s, 0 ≤ coefficient i)
    (hm : ∀ i ∈ s, 0 ≤ monomial i) :
    0 ≤ ∑ i ∈ s, coefficient i * monomial i := by
  exact Finset.sum_nonneg fun i hi => mul_nonneg (hc i hi) (hm i hi)

theorem finite_certificate {ι : Type*} (s : Finset ι) (K : ℝ)
    (f lower : ι → ℝ)
    (hterms : ∀ i ∈ s, lower i ≤ f i)
    (hbase : 0 ≤ K + ∑ i ∈ s, lower i) :
    0 ≤ K + ∑ i ∈ s, f i := by
  have hsum : (∑ i ∈ s, lower i) ≤ ∑ i ∈ s, f i := Finset.sum_le_sum hterms
  linarith only [hbase, hsum]

theorem typeT_sound {ι : Type*} (s : Finset ι) (k : ℕ) (K m : ℝ)
    (N z t : ι → ℝ)
    (hz : ∀ i ∈ s, 0 < z i)
    (hfactor : ∀ i ∈ s, 0 ≤ N i + m * z i ^ (k + 1))
    (ht : ∀ i ∈ s, t i ≤ 1 / z i ^ k)
    (hbase : 0 ≤ K +
      ∑ i ∈ s, ((N i + m * z i ^ (k + 1)) * t i - m * z i)) :
    0 ≤ K + ∑ i ∈ s, N i / z i ^ k := by
  apply finite_certificate s K (fun i => N i / z i ^ k)
    (fun i => (N i + m * z i ^ (k + 1)) * t i - m * z i)
  · intro i hi
    exact shifted_reciprocal_lower (N i) (z i) m (t i) k
      (hz i hi) (hfactor i hi) (ht i hi)
  · exact hbase

theorem typeP_sound {ι : Type*} (s : Finset ι) (k : ℕ) (K : ℝ)
    (N z J c : ι → ℝ)
    (hz : ∀ i ∈ s, 0 < z i)
    (hrem : ∀ i ∈ s, 0 ≤ N i - z i ^ k * J i + c i * z i ^ k)
    (hbase : 0 ≤ K + ∑ i ∈ s, (J i - c i)) :
    0 ≤ K + ∑ i ∈ s, N i / z i ^ k := by
  apply finite_certificate s K (fun i => N i / z i ^ k) (fun i => J i - c i)
  · intro i hi
    exact corrected_remainder_lower (N i) (z i) (J i) (c i) k (hz i hi) (hrem i hi)
  · exact hbase

theorem average_normalization (slack : ℝ) (h : 0 ≤ 24 * slack) :
    0 ≤ slack := by
  nlinarith only [h]

end FourStateConeAudit
