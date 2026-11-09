import Mathlib

open scoped BigOperators

namespace GenusAudit

theorem determinant_frobenius
    {R : Type*} [CommRing R] (p : ℕ) [Fact p.Prime] [CharP R p]
    {ι : Type*} [Fintype ι] [DecidableEq ι] (A : Matrix ι ι R) :
    (A.map (frobenius R p)).det = A.det ^ p := by
  exact ((frobenius R p).map_det A).symm

theorem genus_recurrence_numerator
    (p q v next f image : ℚ)
    (hgenus : v = q * next + (p - 1) * f)
    (himage : image = v + f) :
    p * v = q * next + (p - 1) * image := by
  linear_combination hgenus - (p - 1) * himage

def discounted (t : ℚ) : List ℚ → ℚ
  | [] => 0
  | x :: xs => (1 - t) * x + t * discounted t xs

theorem prefix_weights (t : ℚ) (u : ℕ) :
    (∑ j ∈ Finset.range u, (1 - t) * t ^ j) = 1 - t ^ u := by
  induction u with
  | zero => simp
  | succ u ih =>
      rw [Finset.sum_range_succ, ih, pow_succ]
      ring

theorem length_le_sum
    (m : List ℕ) (hm : ∀ x ∈ m, 1 ≤ x) :
    m.length ≤ m.sum := by
  induction m with
  | nil => simp
  | cons x xs ih =>
      have hx : 1 ≤ x := hm x (by simp)
      have hxs : ∀ y ∈ xs, 1 ≤ y := by
        intro y hy
        exact hm y (by simp [hy])
      have htail := ih hxs
      simp only [List.length_cons, List.sum_cons]
      omega

private theorem profile_error_step
    (t h x a b z : ℚ) (hab : 0 ≤ a - b) :
    (1 - t) * (h + x) +
        t * ((h + 1) * (1 - z) + (1 - t) * (a - b)) ≤
      (h + 1) * (1 - z * t) + (1 - t) * (x + a - (b + 1)) := by
  apply le_of_sub_nonneg
  have hid :
      ((h + 1) * (1 - z * t) + (1 - t) * (x + a - (b + 1))) -
        ((1 - t) * (h + x) +
          t * ((h + 1) * (1 - z) + (1 - t) * (a - b))) =
        (1 - t) ^ 2 * (a - b) := by ring
  rw [hid]
  exact mul_nonneg (sq_nonneg (1 - t)) hab

theorem profile_error_bound
    (t h : ℚ) (ht : 0 ≤ t) (m : List ℕ)
    (hm : ∀ x ∈ m, 1 ≤ x) :
    discounted t (m.map (fun (x : ℕ) => h + (x : ℚ))) ≤
      (h + 1) * (1 - t ^ m.length) +
        (1 - t) * ((m.sum : ℚ) - (m.length : ℚ)) := by
  induction m with
  | nil => simp [discounted]
  | cons x xs ih =>
      have hxs : ∀ y ∈ xs, 1 ≤ y := by
        intro y hy
        exact hm y (by simp [hy])
      have htail := ih hxs
      have hlength : (xs.length : ℚ) ≤ (xs.sum : ℚ) := by
        exact_mod_cast length_le_sum xs hxs
      have hscaled := mul_le_mul_of_nonneg_left htail ht
      have hstep := profile_error_step t h (x : ℚ) (xs.sum : ℚ)
        (xs.length : ℚ) (t ^ xs.length) (sub_nonneg.mpr hlength)
      have hbound := le_trans
        (add_le_add (le_refl ((1 - t) * (h + (x : ℚ)))) hscaled) hstep
      simpa only [List.map_cons, discounted, List.length_cons, List.sum_cons,
        Nat.cast_add, Nat.cast_one, pow_succ] using hbound

theorem degree_lattice_rounding
    (N A : ℤ) (hN : 0 < N) (hdiv : N ∣ A) (hA : -N < A) :
    0 ≤ A := by
  obtain ⟨k, rfl⟩ := hdiv
  have hk0 : 0 ≤ k := by
    by_contra hk
    have hkneg : k ≤ -1 := by omega
    have hprod := mul_le_mul_of_nonneg_left hkneg (le_of_lt hN)
    linarith
  exact mul_nonneg (le_of_lt hN) hk0

theorem exact_degree_bound
    (N nu branch : ℤ) (loss : ℚ)
    (hN : 0 < N) (hdiv : N ∣ nu - branch)
    (happrox : -loss ≤ ((nu - branch : ℤ) : ℚ))
    (hthreshold : loss < (N : ℚ)) :
    branch ≤ nu := by
  have hAq : (-(N : ℚ)) < ((nu - branch : ℤ) : ℚ) := by
    linarith
  have hA : -N < nu - branch := by exact_mod_cast hAq
  exact sub_nonneg.mp (degree_lattice_rounding N (nu - branch) hN hdiv hA)

end GenusAudit
