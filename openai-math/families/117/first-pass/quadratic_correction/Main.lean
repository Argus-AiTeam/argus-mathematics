import Mathlib

open scoped BigOperators

namespace Argus9000117

theorem weighted_grid_comm
    {I J R : Type*} [Fintype I] [Fintype J] [CommRing R]
    (a : I → R) (b : J → R) (z : I → J → R) :
    (∑ i, a i * ∑ j, b j * z i j) =
      ∑ j, b j * ∑ i, a i * z i j := by
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro i _
  ring

theorem grid_predictions_agree
    {I J R : Type*} [Fintype I] [Fintype J] [CommRing R]
    (a : I → R) (b : J → R) (z : I → J → R)
    (u : I → R) (v : J → R)
    (hu : ∀ i, u i = ∑ j, b j * z i j)
    (hv : ∀ j, v j = ∑ i, a i * z i j) :
    (∑ i, a i * u i) = ∑ j, b j * v j := by
  calc
    (∑ i, a i * u i) = ∑ i, a i * ∑ j, b j * z i j := by
      apply Finset.sum_congr rfl
      intro i _
      rw [hu i]
    _ = ∑ j, b j * ∑ i, a i * z i j := weighted_grid_comm a b z
    _ = ∑ j, b j * v j := by
      apply Finset.sum_congr rfl
      intro j _
      rw [hv j]

theorem translated_relations_transfer
    {I J R : Type*} [Fintype I] [Fintype J] [CommRing R]
    (c : I → R) (b : J → R) (z : I → J → R)
    (v : I → R)
    (hv : ∀ i, v i = ∑ j, b j * z i j)
    (hz : ∀ j, ∑ i, c i * z i j = 0) :
    ∑ i, c i * v i = 0 := by
  calc
    (∑ i, c i * v i) = ∑ i, c i * ∑ j, b j * z i j := by
      apply Finset.sum_congr rfl
      intro i _
      rw [hv i]
    _ = ∑ j, b j * ∑ i, c i * z i j := weighted_grid_comm c b z
    _ = 0 := by simp [hz]

theorem collision_le_modal
    {I : Type*} [Fintype I]
    (p : I → ℝ) (hp : ∀ i, 0 ≤ p i) (hs : ∑ i, p i = 1)
    (m : I) (hm : ∀ i, p i ≤ p m) :
    (∑ i, (p i) ^ 2) ≤ p m := by
  calc
    (∑ i, (p i) ^ 2) ≤ ∑ i, p m * p i := by
      apply Finset.sum_le_sum
      intro i _
      nlinarith [mul_nonneg (hp i) (sub_nonneg.mpr (hm i))]
    _ = p m := by rw [← Finset.mul_sum, hs, mul_one]

theorem modal_mass_from_collision
    {I : Type*} [Fintype I] [Nonempty I]
    (p : I → ℝ) (hp : ∀ i, 0 ≤ p i) (hs : ∑ i, p i = 1)
    (eta : ℝ) (hc : 1 - eta ≤ ∑ i, (p i) ^ 2) :
    ∃ m, (∀ i, p i ≤ p m) ∧ 1 - eta ≤ p m := by
  obtain ⟨m, _, hm⟩ :=
    Finset.exists_max_image (Finset.univ : Finset I) p Finset.univ_nonempty
  have hmax : ∀ i, p i ≤ p m := fun i => hm i (Finset.mem_univ i)
  exact ⟨m, hmax, hc.trans (collision_le_modal p hp hs m hmax)⟩

theorem collision_budget (r gamma rho : ℝ) :
    (r + r) * gamma + (r * r) * gamma + 2 * rho =
      (r ^ 2 + 2 * r) * gamma + 2 * rho := by ring

theorem shared_direction_completion_budget (r gamma rho : ℝ) :
    ((r ^ 2 + 2 * r) * gamma + 2 * rho) +
        rho + (r * (r + 1)) * gamma =
      (2 * r ^ 2 + 3 * r) * gamma + 3 * rho := by ring

theorem quadratic_specialization (gamma rho : ℝ) :
    (2 * (3 : ℝ) ^ 2 + 3 * 3) * gamma + 3 * rho =
      27 * gamma + 3 * rho := by ring

theorem manuscript_completion_implies_improved
    (gamma delta : ℝ) (hd : 0 ≤ delta)
    (h : 27 * gamma + 5 * delta < 1) :
    27 * gamma + 3 * delta < 1 := by linarith

theorem manuscript_cleanup_margin
    (delta lambda : ℝ)
    (hd : delta ≤ 1 / 16000) (hl : lambda ≤ 1 / 1000000) :
    (187 : ℝ) / 500000 ≤ 1 / 2000 - 2 * delta - lambda := by
  linarith

theorem nonvacuity_numerator_identities (s : ℝ) :
    192 * (s + 1) ^ 2 + 271 * (s + 1) - 22 =
        192 * s ^ 2 + 655 * s + 441 ∧
      224 * (s + 1) ^ 2 + 336 * (s + 1) - 3 =
        224 * s ^ 2 + 784 * s + 557 := by
  constructor <;> ring

theorem all_degree_margins_positive
    (r : ℝ) (hr : 1 ≤ r) :
    0 < (192 * r ^ 2 + 271 * r - 22) /
        (128 * (2 * r ^ 2 + 3 * r)) ∧
      0 < (224 * r ^ 2 + 336 * r - 3) /
        (128 * (2 * r ^ 2 + 3 * r)) := by
  have hc : 0 < 2 * r ^ 2 + 3 * r := by nlinarith [sq_nonneg r]
  have hden : 0 < 128 * (2 * r ^ 2 + 3 * r) := by positivity
  constructor
  · apply div_pos _ hden
    nlinarith [sq_nonneg (r - 1)]
  · apply div_pos _ hden
    nlinarith [sq_nonneg (r - 1)]

end Argus9000117
