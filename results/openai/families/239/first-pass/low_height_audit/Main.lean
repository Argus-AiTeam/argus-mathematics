import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

open scoped BigOperators

namespace LowHeightAudit

theorem shortBlockBound (a u b w : ℝ)
    (ha : a ≤ 1 / 40) (hu : 0 ≤ u) (hb : b ≤ 2 / 5)
    (hw : u * (1 / 2 - 4 * a - b / 2) ≤ w) :
    u / 5 ≤ w := by
  have h : 0 ≤ u * (3 / 10 - 4 * a - b / 2) :=
    mul_nonneg hu (by linarith)
  nlinarith

theorem longBlockBound (a u b w : ℝ)
    (hu : 0 ≤ u) (hb : b ≤ 1)
    (hw : u * (1 / 2 - 4 * a - b / 2) ≤ w) :
    -(4 * a) * u ≤ w := by
  have h : 0 ≤ u * (1 / 2 - b / 2) :=
    mul_nonneg hu (by linarith)
  nlinarith

theorem flagBlockCount {ι : Type*} (s : Finset ι)
    (u w : ι → ℝ) (a q c : ℝ)
    (ha : 0 ≤ a) (hq : 0 < q)
    (hu : ∀ i ∈ s, 1 ≤ u i)
    (htotal : ∑ i ∈ s, u i ≤ c)
    (hbalance : ∑ i ∈ s, w i ≤ 0)
    (hshort : ∀ i ∈ s, u i ≤ q → u i / 5 ≤ w i)
    (hlong : ∀ i ∈ s, q < u i → -(4 * a) * u i ≤ w i) :
    (s.card : ℝ) ≤ (20 * a + 1 / q) * c := by
  classical
  have hqinv : 0 ≤ 1 / q := le_of_lt (one_div_pos.mpr hq)
  have hk : 0 ≤ 20 * a + 1 / q := by positivity
  have hpoint : ∀ i ∈ s, (1 : ℝ) ≤
      5 * w i + (20 * a + 1 / q) * u i := by
    intro i hi
    have hui := hu i hi
    by_cases h : u i ≤ q
    · have hwi := hshort i hi h
      have hnonneg : 0 ≤ (20 * a + 1 / q) * u i :=
        mul_nonneg hk (by linarith)
      linarith
    · have hlt : q < u i := lt_of_not_ge h
      have hwi := hlong i hi hlt
      have hratio : 1 ≤ (1 / q) * u i := by
        have hdiv : 1 ≤ u i / q := (le_div_iff₀ hq).2 (by linarith)
        simpa [div_eq_mul_inv, mul_comm] using hdiv
      nlinarith
  have hsum := Finset.sum_le_sum hpoint
  simp only [Finset.sum_add_distrib, ← Finset.mul_sum,
    Finset.sum_const, nsmul_eq_mul, mul_one] at hsum
  have hscaled := mul_le_mul_of_nonneg_left htotal hk
  linarith

theorem flagBlockCount21 {ι : Type*} (s : Finset ι)
    (u w : ι → ℝ) (a q c : ℝ)
    (ha : 0 ≤ a) (hq : 0 < q) (hc : 0 ≤ c)
    (hqa : 1 / q ≤ a)
    (hu : ∀ i ∈ s, 1 ≤ u i)
    (htotal : ∑ i ∈ s, u i ≤ c)
    (hbalance : ∑ i ∈ s, w i ≤ 0)
    (hshort : ∀ i ∈ s, u i ≤ q → u i / 5 ≤ w i)
    (hlong : ∀ i ∈ s, q < u i → -(4 * a) * u i ≤ w i) :
    (s.card : ℝ) ≤ 21 * a * c := by
  have h := flagBlockCount s u w a q c ha hq hu htotal hbalance hshort hlong
  have hcoeff : (20 * a + 1 / q) * c ≤ 21 * a * c := by
    have := mul_le_mul_of_nonneg_right hqa hc
    nlinarith
  exact h.trans hcoeff

theorem singleFlagInexpensive (a y : ℝ)
    (ha : a ≤ 1 / 40) (hy : y ≤ a) :
    y ≤ 1 / 2 - 3 * a := by
  linarith

theorem multiDropBudget (h a z theta s : ℝ)
    (hz : z ≤ h / a) (htheta : -(h / a) ≤ theta)
    (hs : s ≤ 2 * (z - theta)) :
    s ≤ 4 * h / a := by
  calc
    s ≤ 4 * (h / a) := by linarith
    _ = 4 * h / a := by ring

theorem squaresBudget {ι : Type*} (s : Finset ι) (x : ι → ℝ) :
    (∀ i ∈ s, 0 ≤ x i) →
    ∑ i ∈ s, (x i) ^ 2 ≤ (∑ i ∈ s, x i) ^ 2 := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert i s hi ih =>
    intro hx
    have hxi := hx i (Finset.mem_insert_self i s)
    have hxs : ∀ j ∈ s, 0 ≤ x j := by
      intro j hj
      exact hx j (Finset.mem_insert_of_mem hj)
    have hsum : 0 ≤ ∑ j ∈ s, x j := Finset.sum_nonneg hxs
    have hind := ih hxs
    simp only [Finset.sum_insert hi]
    nlinarith [mul_nonneg hxi hsum]

theorem entropySubstitution (n l a h : ℝ) (ha : a ≠ 0) :
    462 * a ^ 2 * n * l * (4 * h / a) +
        6 * l / a * (4 * h / a) ^ 2 =
      1848 * a * n * l * h + 96 * l * h ^ 2 / a ^ 3 := by
  field_simp [ha]
  ring

theorem logHeightSubstitution (n l a b : ℝ) (ha : a ≠ 0) (hl : l ≠ 0) :
    1848 * a * n * l * (b / l) +
        96 * l * (b / l) ^ 2 / a ^ 3 =
      1848 * a * n * b + 96 * b ^ 2 / (a ^ 3 * l) := by
  field_simp [ha, hl]

end LowHeightAudit
