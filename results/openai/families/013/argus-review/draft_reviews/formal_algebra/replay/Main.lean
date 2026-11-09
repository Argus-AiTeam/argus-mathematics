import Mathlib

set_option autoImplicit false

namespace TreeComparison

variable {K : Type*} [Field K]

theorem reconstruction_difference
    (D p u Hplus Hminus splus sminus sn : K)
    (hD : D ≠ 0) (hp : p ≠ 0) (hu : u ≠ 0)
    (hplus : Hplus ≠ 0) (hminus : Hminus ≠ 0)
    (hrec : splus * Hminus - sminus * Hplus = sn * p * u) :
    splus / (D * p * u * Hplus) - sminus / (D * p * u * Hminus) =
      sn / (D * Hplus * Hminus) := by
  field_simp [hD, hp, hu, hplus, hminus]
  linear_combination hrec

theorem held_ratio_square
    (D p u Hfree Hheld sfree sheld sn : K)
    (hD : D ≠ 0) (hp : p ≠ 0) (hu : u ≠ 0)
    (hfree : Hfree ≠ 0) (hheld : Hheld ≠ 0)
    (hsheld : sheld ≠ 0) (hsn : sn ≠ 0) :
    (sfree / (D * p * u * Hfree) / (sheld / (D * p * u * Hheld))) /
        (sn / (D * Hfree * Hheld)) =
      (D * sfree / (sheld * sn)) * Hheld ^ 2 := by
  field_simp [hD, hp, hu, hfree, hheld, hsheld, hsn] <;> ring

theorem reconstructed_square
    (D p u Hplus Hminus splus sminus sn : K)
    (hD : D ≠ 0) (hp : p ≠ 0) (hu : u ≠ 0)
    (hplus : Hplus ≠ 0) (hminus : Hminus ≠ 0)
    (hsplus : splus ≠ 0) (hsminus : sminus ≠ 0) (hsn : sn ≠ 0) :
    p ^ 2 =
      (splus * sminus / (sn * D * u ^ 2)) *
        (sn / (D * Hplus * Hminus)) /
        ((splus / (D * p * u * Hplus)) *
          (sminus / (D * p * u * Hminus))) := by
  field_simp [hD, hp, hu, hplus, hminus, hsplus, hsminus, hsn] <;> ring

theorem bad_held_cancellation
    (p d e c y : K) (he : e ≠ 0)
    (h : p ^ 2 * d * e = c * y) :
    d * p ^ 2 = c * y / e := by
  field_simp [he]
  linear_combination h

theorem square_fiber
    (z w : K) (h : z ^ 2 = w ^ 2) :
    z = w ∨ z = -w := by
  have hf : (z - w) * (z + w) = 0 := by
    calc
      (z - w) * (z + w) = z ^ 2 - w ^ 2 := by ring
      _ = 0 := sub_eq_zero.mpr h
  rcases mul_eq_zero.mp hf with hleft | hright
  · exact Or.inl (sub_eq_zero.mp hleft)
  · exact Or.inr (eq_neg_iff_add_eq_zero.mpr hright)

theorem affine_composition
    (r s t : K) (hr : r ≠ 0) :
    s - s ^ 2 * ((r - t) / r ^ 2) =
      (s / r) ^ 2 * t + s - s ^ 2 / r := by
  field_simp [hr] <;> ring

theorem affine_fixed_ratio_injective
    (z r r' : K) (hz : z ≠ 0) (hone : z ≠ 1)
    (h : r * (z - z ^ 2) = r' * (z - z ^ 2)) :
    r = r' := by
  have hfactor : z - z ^ 2 ≠ 0 := by
    rw [show z - z ^ 2 = z * (1 - z) by ring]
    exact mul_ne_zero hz (sub_ne_zero.mpr (Ne.symm hone))
  have hmul : (r - r') * (z - z ^ 2) = 0 := by
    linear_combination h
  rcases mul_eq_zero.mp hmul with heq | hzero
  · exact sub_eq_zero.mp heq
  · exact (hfactor hzero).elim

theorem quadratic_pairs_of_coefficients
    (b1 b2 b3 b4 : K)
    (hsum : b1 + b2 = b3 + b4)
    (hprod : b1 * b2 = b3 * b4) :
    (b1 = b3 ∧ b2 = b4) ∨ (b1 = b4 ∧ b2 = b3) := by
  have hf : (b1 - b3) * (b1 - b4) = 0 := by
    linear_combination b1 * hsum - hprod
  rcases mul_eq_zero.mp hf with hleft | hright
  · have hb : b1 = b3 := sub_eq_zero.mp hleft
    exact Or.inl ⟨hb, by linear_combination hsum - hb⟩
  · have hb : b1 = b4 := sub_eq_zero.mp hright
    exact Or.inr ⟨hb, by linear_combination hsum - hb⟩

theorem off_diagonal_collision_unique
    (a a' b1 b2 b3 b4 : K)
    (hoff : ¬ ((b1 = b3 ∧ b2 = b4) ∨ (b1 = b4 ∧ b2 = b3)))
    (ha : (a - b1) * (a - b2) = (a - b3) * (a - b4))
    (ha' : (a' - b1) * (a' - b2) = (a' - b3) * (a' - b4)) :
    a = a' := by
  by_contra hne
  have hf : (a - a') * ((b3 + b4) - (b1 + b2)) = 0 := by
    linear_combination ha - ha'
  have hdelta : (b3 + b4) - (b1 + b2) = 0 :=
    (mul_eq_zero.mp hf).resolve_left (sub_ne_zero.mpr hne)
  have hsum : b1 + b2 = b3 + b4 := by
    linear_combination -hdelta
  have hprod : b1 * b2 = b3 * b4 := by
    linear_combination ha + a * hsum
  exact hoff (quadratic_pairs_of_coefficients b1 b2 b3 b4 hsum hprod)

theorem cycle_index_unique
    {G : Type*} [Group G] (x y z : G)
    (hx : x * z = 1) (hy : y * z = 1) :
    x = y := by
  exact mul_right_cancel (hx.trans hy.symm)

theorem local_constant_budget :
    32 * 256 + 64 * 8192 ≤ (2 : ℕ) ^ 20 := by
  norm_num

end TreeComparison
