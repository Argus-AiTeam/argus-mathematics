import Mathlib

namespace GammaCore

variable {A : Type*} [Ring A] [Algebra ℝ A]

def partialSum (c : ℕ → ℝ) (r : ℕ → A) (n : ℕ) : A :=
  ∑ i ∈ Finset.range n, c i • r i

def comm (x y : A) : A := x * y - y * x

theorem trace_second_step (tr : A →ₗ[ℝ] ℝ)
    (cyc : ∀ x y, tr (x * y) = tr (y * x))
    (x r : A) (c : ℝ) (hr : r * r = 1) :
    tr ((x + c • r) ^ 2) =
      tr (x ^ 2) + 2 * c * tr (x * r) + c ^ 2 * tr 1 := by
  have h := cyc r x
  simp only [pow_two, add_mul, mul_add, smul_mul_assoc, mul_smul_comm,
    map_add, map_smul, hr] at *
  rw [h]
  ring

theorem trace_fourth_step (tr : A →ₗ[ℝ] ℝ)
    (cyc : ∀ x y, tr (x * y) = tr (y * x))
    (x r : A) (c : ℝ) (hr : r * r = 1) :
    tr ((x + c • r) ^ 4) =
      tr (x ^ 4) + 4 * c * tr (x ^ 3 * r) +
      c ^ 2 * (4 * tr (x ^ 2) + 2 * tr (x * r * x * r)) +
      4 * c ^ 3 * tr (x * r) + c ^ 4 * tr 1 := by
  have h1 : tr (x * (x * (r * x))) = tr (x * (x * (x * r))) := by
    simpa only [mul_assoc] using cyc (x * x * r) x
  have h2 : tr (x * (r * (x * x))) = tr (x * (x * (x * r))) := by
    simpa only [mul_assoc] using cyc (x * r) (x * x)
  have h3 : tr (r * (x * (x * x))) = tr (x * (x * (x * r))) := by
    simpa only [mul_assoc] using cyc r (x * x * x)
  have h4 : tr (r * (x * (x * r))) = tr (x * x) := by
    calc
      tr (r * (x * (x * r))) = tr ((x * (x * r)) * r) := cyc _ _
      _ = tr (x * x) := by simp only [mul_assoc, hr, mul_one]
  have h5 : tr (r * (x * (r * x))) = tr (x * (r * (x * r))) := by
    simpa only [mul_assoc] using cyc r (x * r * x)
  have h6 : tr (r * x) = tr (x * r) := cyc _ _
  simp only [pow_succ, pow_zero, mul_one, one_mul, add_mul, mul_add,
    smul_mul_assoc, mul_smul_comm, map_add, map_smul,
    mul_assoc, hr, h1, h2, h3, h4, h5, h6]
  ring

variable [StarRing A]

theorem comm_square_trace (tr : A →ₗ[ℝ] ℝ)
    (cyc : ∀ x y, tr (x * y) = tr (y * x))
    (x r : A) (hx : star x = x) (hs : star r = r)
    (hr : r * r = 1) :
    tr (star (comm x r) * comm x r) =
      2 * tr (x ^ 2) - 2 * tr (x * r * x * r) := by
  have h1 : tr (r * x * x * r) = tr (x * x) := by
    calc
      tr (r * x * x * r) = tr ((x * x * r) * r) := by
        simpa only [mul_assoc] using cyc r (x * x * r)
      _ = tr (x * x) := by simp only [mul_assoc, hr, mul_one]
  have h2 : tr (r * x * r * x) = tr (x * r * x * r) := by
    simpa only [mul_assoc] using cyc r (x * r * x)
  have h3 : tr (x * r * r * x) = tr (x * x) := by
    simp only [mul_assoc, hr, one_mul]
  simp only [comm, star_sub, star_mul, hx, hs, sub_mul, mul_sub,
    map_sub, pow_two]
  simp only [mul_assoc] at h1 h2 h3 ⊢
  rw [h1, h2, h3]
  ring

theorem centered_fourth_step (tr : A →ₗ[ℝ] ℝ)
    (cyc : ∀ x y, tr (x * y) = tr (y * x))
    (hunit : tr 1 = 1)
    (x r : A) (c : ℝ) (hx : star x = x) (hs : star r = r)
    (hr : r * r = 1) (hfirst : tr (x * r) = 0)
    (hthird : tr (x ^ 3 * r) = 0) :
    tr ((x + c • r) ^ 4) =
      tr (x ^ 4) + 6 * c ^ 2 * tr (x ^ 2) + c ^ 4 -
      c ^ 2 * tr (star (comm x r) * comm x r) := by
  rw [trace_fourth_step tr cyc x r c hr,
    comm_square_trace tr cyc x r hx hs hr, hfirst, hthird, hunit]
  ring

theorem prefix_second (tr : A →ₗ[ℝ] ℝ)
    (cyc : ∀ x y, tr (x * y) = tr (y * x))
    (hunit : tr 1 = 1) (c : ℕ → ℝ) (r : ℕ → A)
    (hr : ∀ i, r i * r i = 1)
    (hfirst : ∀ i, tr (partialSum c r i * r i) = 0) (n : ℕ) :
    tr ((partialSum c r n) ^ 2) = ∑ i ∈ Finset.range n, (c i) ^ 2 := by
  induction n with
  | zero => simp [partialSum]
  | succ n ih =>
      rw [partialSum, Finset.sum_range_succ]
      change tr ((partialSum c r n + c n • r n) ^ 2) = _
      rw [trace_second_step tr cyc _ _ _ (hr n), hfirst n, hunit, ih,
        Finset.sum_range_succ]
      ring

theorem prefix_fourth_defect (tr : A →ₗ[ℝ] ℝ)
    (cyc : ∀ x y, tr (x * y) = tr (y * x))
    (hunit : tr 1 = 1) (c : ℕ → ℝ) (r : ℕ → A)
    (hr : ∀ i, r i * r i = 1)
    (hs : ∀ i, star (r i) = r i)
    (hp : ∀ i, star (partialSum c r i) = partialSum c r i)
    (hfirst : ∀ i, tr (partialSum c r i * r i) = 0)
    (hthird : ∀ i, tr ((partialSum c r i) ^ 3 * r i) = 0) (n : ℕ) :
    tr ((partialSum c r n) ^ 4) =
      3 * (∑ i ∈ Finset.range n, (c i) ^ 2) ^ 2 -
      2 * (∑ i ∈ Finset.range n, (c i) ^ 4) -
      ∑ i ∈ Finset.range n,
        (c i) ^ 2 * tr (star (comm (partialSum c r i) (r i)) *
          comm (partialSum c r i) (r i)) := by
  induction n with
  | zero => simp [partialSum]
  | succ n ih =>
      rw [partialSum, Finset.sum_range_succ]
      change tr ((partialSum c r n + c n • r n) ^ 4) = _
      rw [centered_fourth_step tr cyc hunit _ _ _ (hp n) (hs n) (hr n)
        (hfirst n) (hthird n), ih,
        prefix_second tr cyc hunit c r hr hfirst n]
      simp only [Finset.sum_range_succ]
      ring

theorem prefix_fourth_bound (tr : A →ₗ[ℝ] ℝ)
    (cyc : ∀ x y, tr (x * y) = tr (y * x))
    (hunit : tr 1 = 1) (c : ℕ → ℝ) (r : ℕ → A)
    (hr : ∀ i, r i * r i = 1)
    (hs : ∀ i, star (r i) = r i)
    (hp : ∀ i, star (partialSum c r i) = partialSum c r i)
    (hfirst : ∀ i, tr (partialSum c r i * r i) = 0)
    (hthird : ∀ i, tr ((partialSum c r i) ^ 3 * r i) = 0)
    (hpositive : ∀ x : A, 0 ≤ tr (star x * x))
    (n : ℕ) (hnormal : ∑ i ∈ Finset.range n, (c i) ^ 2 = 1) :
    tr ((partialSum c r n) ^ 4) ≤
      3 - 2 * (∑ i ∈ Finset.range n, (c i) ^ 4) := by
  rw [prefix_fourth_defect tr cyc hunit c r hr hs hp hfirst hthird n, hnormal]
  have hnonneg : 0 ≤ ∑ i ∈ Finset.range n,
      (c i) ^ 2 * tr (star (comm (partialSum c r i) (r i)) *
        comm (partialSum c r i) (r i)) :=
    Finset.sum_nonneg fun i _ => mul_nonneg (sq_nonneg _) (hpositive _)
  nlinarith

end GammaCore
