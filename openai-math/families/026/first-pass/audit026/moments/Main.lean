import Mathlib

open scoped BigOperators

namespace Audit026

variable {α β : Type*} [DecidableEq α]

def signedNonempty (s : Finset α) : ℚ :=
  ∑ u ∈ s.powerset.erase ∅, (-1 : ℚ) ^ u.card

theorem nonempty_subset_product (s : Finset α) (x : α → ℚ) :
    (∑ u ∈ s.powerset.erase ∅, (-1 : ℚ) ^ u.card * ∏ a ∈ u, x a) =
      (∏ a ∈ s, (1 - x a)) - 1 := by
  have h := Finset.prod_sub (fun _ : α => (1 : ℚ)) x s
  simp only [Finset.prod_const_one, mul_one] at h
  rw [← Finset.sum_erase_add s.powerset
    (fun u : Finset α => (-1 : ℚ) ^ u.card * ∏ a ∈ u, x a)
    (a := (∅ : Finset α)) (by simp)] at h
  simp only [Finset.card_empty, pow_zero, Finset.prod_empty, mul_one] at h
  linarith

theorem fiber_sign (s : Finset α) (hs : s.Nonempty) :
    signedNonempty s = -1 := by
  have h := nonempty_subset_product s (fun _ => (1 : ℚ))
  have hc : s.card ≠ 0 := Nat.ne_of_gt (Finset.card_pos.mpr hs)
  simpa [signedNonempty, Finset.prod_const, hc] using h

theorem fiber_sign_sum (c : Finset β) (f : β → Finset α)
    (hf : ∀ i ∈ c, (f i).Nonempty) :
    (∑ i ∈ c, signedNonempty (f i)) = -(c.card : ℚ) := by
  calc
    (∑ i ∈ c, signedNonempty (f i)) = ∑ _i ∈ c, (-1 : ℚ) :=
      Finset.sum_congr rfl (fun i hi => fiber_sign (f i) (hf i hi))
    _ = -(c.card : ℚ) := by simp

theorem occupied_local_density (c : Finset β) (f : β → Finset α)
    (hf : ∀ i ∈ c, (f i).Nonempty) (p d : ℚ) :
    1 + (∑ i ∈ c, signedNonempty (f i)) / (p - d) =
      1 - (c.card : ℚ) / (p - d) := by
  rw [fiber_sign_sum c f hf]
  ring

theorem marked_normalization (p nu : ℚ) (t : ℕ)
    (hp : p ≠ 0) (hp1 : p ≠ 1) :
    (1 - (nu - 1) / (p - 1)) / (1 - 1 / p) ^ t =
      (1 - nu / p) / (1 - 1 / p) ^ (t + 1) := by
  have hpm : p - 1 ≠ 0 := sub_ne_zero.mpr hp1
  have hb : 1 - 1 / p ≠ 0 := by
    intro h
    have hdiv : (1 : ℚ) / p = 1 := (sub_eq_zero.mp h).symm
    exact hp1 ((div_eq_one_iff_eq hp).mp hdiv).symm
  have hstep :
      (1 - (nu - 1) / (p - 1)) * (1 - 1 / p) = 1 - nu / p := by
    field_simp
    ring
  rw [pow_succ, ← hstep]
  exact (mul_div_mul_right _ _ hb).symm

theorem marked_collision_normalization (c : Finset β) (f : β → Finset α)
    (hf : ∀ i ∈ c, (f i).Nonempty) (p : ℚ) (t : ℕ)
    (hp : p ≠ 0) (hp1 : p ≠ 1) :
    (1 + (∑ i ∈ c, signedNonempty (f i)) / (p - 1)) /
        (1 - 1 / p) ^ t =
      (1 - ((c.card : ℚ) + 1) / p) / (1 - 1 / p) ^ (t + 1) := by
  rw [occupied_local_density c f hf p 1]
  simpa using marked_normalization p ((c.card : ℚ) + 1) t hp hp1

theorem marked_zero_factor (p : ℚ) (t : ℕ) (hp : p ≠ 0) (hp1 : p ≠ 1) :
    (1 - (p - 1) / (p - 1)) / (1 - 1 / p) ^ t = 0 := by
  rw [marked_normalization p p t hp hp1]
  simp [hp]

end Audit026
