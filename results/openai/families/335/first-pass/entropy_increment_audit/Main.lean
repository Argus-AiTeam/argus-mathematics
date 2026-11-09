import Mathlib

open scoped BigOperators

namespace OrderedEntropy

theorem defect_domination (a lam sigma v d : ℝ)
    (ha : (1 / 2 : ℝ) ≤ a) (hlam : 0 ≤ lam)
    (hlam' : lam ≤ (1 / 2 : ℝ))
    (hv : v = a * (sigma - 1) + lam * d) :
    max (1 - sigma) 0 ≤ 2 * |v| + |d| := by
  refine max_le ?_ (by positivity)
  by_cases hs : 1 ≤ sigma
  · have : 0 ≤ 2 * |v| + |d| := by positivity
    linarith
  · have hs' : 0 ≤ 1 - sigma := by linarith
    have hhalf := mul_le_mul_of_nonneg_right ha hs'
    have hlamd : lam * d ≤ (1 / 2 : ℝ) * |d| :=
      (mul_le_mul_of_nonneg_left (le_abs_self d) hlam).trans
        (mul_le_mul_of_nonneg_right hlam' (abs_nonneg d))
    have hv' := neg_abs_le v
    nlinarith

theorem scalar_young (m u v d cp theta : ℝ)
    (hcp : 0 < cp) (htheta : 0 < theta)
    (htheta' : theta ≤ (1 / 16 : ℝ)) :
    m * u * (2 * |v| + |d|) ≤
      cp * (v ^ 2 + theta * d ^ 2) +
        (m ^ 2 / (cp * theta)) * u ^ 2 := by
  have h1 : 0 ≤ theta * (cp * |v| - m * u) ^ 2 :=
    mul_nonneg htheta.le (sq_nonneg _)
  have h2 : 0 ≤ (cp * theta * |d| - m * u / 2) ^ 2 := sq_nonneg _
  have h3 : 0 ≤ ((3 / 4 : ℝ) - theta) * (m * u) ^ 2 :=
    mul_nonneg (by linarith) (sq_nonneg _)
  have hid :
      (cp * theta) * (cp * (v ^ 2 + theta * d ^ 2)) + m ^ 2 * u ^ 2 -
        (cp * theta) * (m * u * (2 * |v| + |d|)) =
      theta * (cp * |v| - m * u) ^ 2 +
        (cp * theta * |d| - m * u / 2) ^ 2 +
        ((3 / 4 : ℝ) - theta) * (m * u) ^ 2 := by
    ring_nf <;> simp only [sq_abs] <;> ring
  have hnonneg := add_nonneg (add_nonneg h1 h2) h3
  rw [← hid] at hnonneg
  have hscaled :
      (cp * theta) * (m * u * (2 * |v| + |d|)) ≤
        (cp * theta) * (cp * (v ^ 2 + theta * d ^ 2)) + m ^ 2 * u ^ 2 := by
    linarith
  have hprod : 0 < cp * theta := mul_pos hcp htheta
  have hscaled' :
      (cp * theta) * (m * u * (2 * |v| + |d|)) ≤
        (cp * theta) * (cp * (v ^ 2 + theta * d ^ 2) +
          (m ^ 2 / (cp * theta)) * u ^ 2) := by
    calc
      _ ≤ (cp * theta) * (cp * (v ^ 2 + theta * d ^ 2)) +
          m ^ 2 * u ^ 2 := hscaled
      _ = _ := by
        field_simp [ne_of_gt hcp, ne_of_gt htheta]
        <;> ring
  by_contra hn
  have hlt := mul_lt_mul_of_pos_left (lt_of_not_ge hn) hprod
  linarith

theorem weighted_young {ι : Type*} [Fintype ι]
    (w u v d : ι → ℝ) (m cp theta : ℝ)
    (hw : ∀ i, 0 ≤ w i) (hcp : 0 < cp) (htheta : 0 < theta)
    (htheta' : theta ≤ (1 / 16 : ℝ)) :
    m * (∑ i, w i * u i * (2 * |v i| + |d i|)) ≤
      cp * ((∑ i, w i * (v i) ^ 2) +
        theta * (∑ i, w i * (d i) ^ 2)) +
      (m ^ 2 / (cp * theta)) * (∑ i, w i * (u i) ^ 2) := by
  calc
    m * (∑ i, w i * u i * (2 * |v i| + |d i|)) =
        ∑ i, w i * (m * u i * (2 * |v i| + |d i|)) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ ≤ ∑ i, w i * (cp * ((v i) ^ 2 + theta * (d i) ^ 2) +
        (m ^ 2 / (cp * theta)) * (u i) ^ 2) := by
      apply Finset.sum_le_sum
      intro i _
      exact mul_le_mul_of_nonneg_left
        (scalar_young m (u i) (v i) (d i) cp theta hcp htheta htheta') (hw i)
    _ = _ := by
      simp [mul_add, Finset.sum_add_distrib, Finset.mul_sum, mul_left_comm]

theorem probability_second_moment {ι : Type*} [Fintype ι]
    (w u : ι → ℝ) (b : ℝ)
    (hw : ∑ i, w i = 1) (hu : ∑ i, w i * u i = b) :
    ∑ i, w i * (u i) ^ 2 =
      b ^ 2 + ∑ i, w i * (u i - b) ^ 2 := by
  have hvar :
      (∑ i, w i * (u i - b) ^ 2) =
        (∑ i, w i * (u i) ^ 2) -
        2 * b * (∑ i, w i * u i) + b ^ 2 * (∑ i, w i) := by
    calc
      (∑ i, w i * (u i - b) ^ 2) =
          ∑ i, (w i * (u i) ^ 2 - 2 * b * (w i * u i) + b ^ 2 * w i) := by
        apply Finset.sum_congr rfl
        intro i _
        ring
      _ = _ := by
        simp [Finset.sum_add_distrib, Finset.sum_sub_distrib,
          Finset.mul_sum]
  rw [hw, hu] at hvar
  linarith

theorem weighted_probability_defect {ι : Type*} [Fintype ι]
    (w u sigma v : ι → ℝ) (m eps b a lam cp theta : ℝ)
    (hw : ∀ i, 0 ≤ w i) (hu : ∀ i, 0 ≤ u i)
    (hw_sum : ∑ i, w i = 1) (hu_mean : ∑ i, w i * u i = b)
    (hm : 0 ≤ m) (heps : 0 ≤ eps)
    (ha : (1 / 2 : ℝ) ≤ a) (hlam : 0 ≤ lam)
    (hlam' : lam ≤ (1 / 2 : ℝ))
    (hv : ∀ i, v i = a * (sigma i - 1) + lam * (u i - b))
    (hcp : 0 < cp) (htheta : 0 < theta)
    (htheta' : theta ≤ (1 / 16 : ℝ)) :
    m * eps * (∑ i, w i * u i * max (1 - sigma i) 0) ≤
      cp * eps * ((∑ i, w i * (v i) ^ 2) +
        theta * (∑ i, w i * (u i - b) ^ 2)) +
      (m ^ 2 / (cp * theta)) * eps *
        (b ^ 2 + ∑ i, w i * (u i - b) ^ 2) := by
  have hdom :
      (∑ i, w i * u i * max (1 - sigma i) 0) ≤
        ∑ i, w i * u i * (2 * |v i| + |u i - b|) := by
    apply Finset.sum_le_sum
    intro i _
    exact mul_le_mul_of_nonneg_left
      (defect_domination a lam (sigma i) (v i) (u i - b)
        ha hlam hlam' (hv i))
      (mul_nonneg (hw i) (hu i))
  have hy := weighted_young w u v (fun i => u i - b)
    m cp theta hw hcp htheta htheta'
  have hmoment := probability_second_moment w u b hw_sum hu_mean
  calc
    m * eps * (∑ i, w i * u i * max (1 - sigma i) 0) =
        eps * (m * (∑ i, w i * u i * max (1 - sigma i) 0)) := by ring
    _ ≤ eps * (m * (∑ i, w i * u i * (2 * |v i| + |u i - b|))) :=
      mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hdom hm) heps
    _ ≤ eps * (cp * ((∑ i, w i * (v i) ^ 2) +
        theta * (∑ i, w i * (u i - b) ^ 2)) +
        (m ^ 2 / (cp * theta)) * (∑ i, w i * (u i) ^ 2)) :=
      mul_le_mul_of_nonneg_left hy heps
    _ = _ := by rw [hmoment]; ring

end OrderedEntropy
