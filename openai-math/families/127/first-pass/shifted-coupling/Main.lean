import Mathlib

open scoped BigOperators

namespace ShiftedCoupling

noncomputable def primitive (x : ℝ) : ℝ := x * |x| / 2

noncomputable def envelope (a x : ℝ) : ℝ :=
  4 * (x ^ 2 - (max (|x| - a / 2) 0) ^ 2)

noncomputable def potential (a c x : ℝ) : ℝ :=
  4 * primitive (x - c - a / 2) - 2 * a * (x - c)

theorem primitive_increment (x y : ℝ) (hxy : x ≤ y) :
    (y - x) ^ 2 ≤ 4 * (primitive y - primitive x) := by
  by_cases hx : 0 ≤ x
  · have hy : 0 ≤ y := le_trans hx hxy
    simp only [primitive, abs_of_nonneg hx, abs_of_nonneg hy]
    nlinarith [sq_nonneg (y - x), mul_nonneg (sub_nonneg.mpr hxy) hx]
  · have hx' : x ≤ 0 := le_of_lt (lt_of_not_ge hx)
    by_cases hy : y ≤ 0
    · simp only [primitive, abs_of_nonpos hx', abs_of_nonpos hy]
      nlinarith [sq_nonneg (y - x),
        mul_nonpos_of_nonneg_of_nonpos (sub_nonneg.mpr hxy) hy]
    · have hy' : 0 ≤ y := le_of_lt (lt_of_not_ge hy)
      simp only [primitive, abs_of_nonpos hx', abs_of_nonneg hy']
      nlinarith [sq_nonneg (x + y)]

theorem envelope_primitive (a x : ℝ) (ha : 0 ≤ a) :
    envelope a x =
      4 * (primitive (x + a / 2) - primitive (x - a / 2)) - a ^ 2 := by
  by_cases hx : 0 ≤ x
  · have hp : 0 ≤ x + a / 2 := by linarith
    by_cases ht : a / 2 ≤ x
    · have hm : 0 ≤ x - a / 2 := by linarith
      simp only [envelope, primitive, abs_of_nonneg hx, abs_of_nonneg hp,
        abs_of_nonneg hm, max_eq_left hm]
      ring
    · have hm : x - a / 2 ≤ 0 := by linarith
      simp only [envelope, primitive, abs_of_nonneg hx, abs_of_nonneg hp,
        abs_of_nonpos hm, max_eq_right hm]
      ring
  · have hx' : x ≤ 0 := le_of_lt (lt_of_not_ge hx)
    have hm : x - a / 2 ≤ 0 := by linarith
    by_cases ht : x ≤ -(a / 2)
    · have hp : x + a / 2 ≤ 0 := by linarith
      have ht' : 0 ≤ -x - a / 2 := by linarith
      simp only [envelope, primitive, abs_of_nonpos hx', abs_of_nonpos hp,
        abs_of_nonpos hm, max_eq_left ht']
      ring
    · have hp : 0 ≤ x + a / 2 := by linarith
      have ht' : -x - a / 2 ≤ 0 := by linarith
      simp only [envelope, primitive, abs_of_nonpos hx', abs_of_nonneg hp,
        abs_of_nonpos hm, max_eq_right ht']
      ring

theorem envelope_mad (a x : ℝ) (ha : 0 ≤ a) :
    envelope a x ≤ 4 * a * |x| := by
  by_cases h : |x| ≤ a / 2
  · have hm : |x| - a / 2 ≤ 0 := by linarith
    simp only [envelope, max_eq_right hm, zero_pow (by decide : 2 ≠ 0), sub_zero]
    nlinarith [sq_abs x, mul_nonneg (abs_nonneg x)
      (show 0 ≤ a - |x| by linarith)]
  · have hm : 0 ≤ |x| - a / 2 := by linarith
    simp only [envelope, max_eq_left hm]
    nlinarith [sq_abs x, sq_nonneg a]

theorem pointwise_dual (a c u v : ℝ) (ha : 0 ≤ a) (hs : v ≤ u + a) :
    (u - v) ^ 2 ≤ envelope a (u - c) + potential a c u - potential a c v := by
  have h := primitive_increment (v - c - a / 2) (u - c + a / 2)
    (by linarith)
  rw [envelope_primitive a (u - c) ha]
  unfold potential
  nlinarith

theorem finite_envelope {ι : Type*} [Fintype ι]
    (w : ι → ι → ℝ) (x : ι → ℝ) (a c : ℝ)
    (ha : 0 ≤ a)
    (hw : ∀ i j, 0 ≤ w i j)
    (hmarg : ∀ i, ∑ j, w i j = ∑ j, w j i)
    (hs : ∀ i j, w i j ≠ 0 → x j ≤ x i + a) :
    (∑ i, ∑ j, w i j * (x i - x j) ^ 2) ≤
      ∑ i, (∑ j, w i j) * envelope a (x i - c) := by
  classical
  have balance :
      (∑ i, ∑ j, w i j * potential a c (x i)) =
        ∑ i, ∑ j, w i j * potential a c (x j) := by
    calc
      _ = ∑ i, (∑ j, w i j) * potential a c (x i) := by
        simp_rw [Finset.sum_mul]
      _ = ∑ i, (∑ j, w j i) * potential a c (x i) := by
        simp_rw [hmarg]
      _ = ∑ i, ∑ j, w j i * potential a c (x i) := by
        simp_rw [Finset.sum_mul]
      _ = _ := Finset.sum_comm
  have bound :
      (∑ i, ∑ j, w i j * (x i - x j) ^ 2) ≤
        ∑ i, ∑ j, w i j *
          (envelope a (x i - c) + potential a c (x i) - potential a c (x j)) := by
    apply Finset.sum_le_sum
    intro i _
    apply Finset.sum_le_sum
    intro j _
    by_cases hzero : w i j = 0
    · simp only [hzero, zero_mul, le_refl]
    · exact mul_le_mul_of_nonneg_left
        (pointwise_dual a c (x i) (x j) ha (hs i j hzero)) (hw i j)
  have cancel :
      (∑ i, ∑ j, w i j *
          (envelope a (x i - c) + potential a c (x i) - potential a c (x j))) =
        ∑ i, (∑ j, w i j) * envelope a (x i - c) := by
    simp_rw [mul_sub, mul_add, Finset.sum_sub_distrib, Finset.sum_add_distrib]
    rw [balance]
    simp only [add_sub_cancel_right]
    simp_rw [Finset.sum_mul]
  exact cancel ▸ bound

theorem finite_mad {ι : Type*} [Fintype ι]
    (w : ι → ι → ℝ) (x : ι → ℝ) (a c : ℝ)
    (ha : 0 ≤ a)
    (hw : ∀ i j, 0 ≤ w i j)
    (hmarg : ∀ i, ∑ j, w i j = ∑ j, w j i)
    (hs : ∀ i j, w i j ≠ 0 → x j ≤ x i + a) :
    (∑ i, ∑ j, w i j * (x i - x j) ^ 2) ≤
      4 * a * (∑ i, (∑ j, w i j) * |x i - c|) := by
  classical
  calc
    _ ≤ ∑ i, (∑ j, w i j) * envelope a (x i - c) :=
      finite_envelope w x a c ha hw hmarg hs
    _ ≤ ∑ i, (∑ j, w i j) * (4 * a * |x i - c|) := by
      apply Finset.sum_le_sum
      intro i _
      exact mul_le_mul_of_nonneg_left (envelope_mad a (x i - c) ha)
        (Finset.sum_nonneg fun j _ => hw i j)
    _ = _ := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring

#print axioms finite_envelope
#print axioms finite_mad

end ShiftedCoupling
