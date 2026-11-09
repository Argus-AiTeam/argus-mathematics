import Mathlib

open scoped BigOperators

namespace EntropySupport

theorem weighted_cauchy {G : Type*} [Fintype G]
    (w u v : G → ℝ) (hw : ∀ g, 0 ≤ w g) :
    (∑ g, w g * u g * v g) ^ 2 ≤
      (∑ g, w g * u g ^ 2) * (∑ g, w g * v g ^ 2) := by
  exact Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul
    (r := fun g => w g * u g * v g)
    (f := fun g => w g * u g ^ 2)
    (g := fun g => w g * v g ^ 2)
    Finset.univ
    (fun g _ => mul_nonneg (hw g) (sq_nonneg _))
    (fun g _ => mul_nonneg (hw g) (sq_nonneg _))
    (fun g _ => le_of_eq (by ring))

theorem node_budget {G : Type*} [Fintype G]
    (w u v : G → ℝ) (q b C : ℝ)
    (hw : ∀ g, 0 ≤ w g) (hq : 0 ≤ q) (hC : 0 < C)
    (hreconstruct : ∑ g, w g * u g * v g = q * b)
    (hnorm : ∑ g, w g * u g ^ 2 ≤ C * q) :
    q * b ^ 2 / C ≤ ∑ g, w g * v g ^ 2 := by
  have henergy : 0 ≤ ∑ g, w g * v g ^ 2 :=
    Finset.sum_nonneg (fun g _ => mul_nonneg (hw g) (sq_nonneg _))
  have hcs := weighted_cauchy w u v hw
  rw [hreconstruct] at hcs
  have hmul : (q * b) ^ 2 ≤ (C * q) * (∑ g, w g * v g ^ 2) :=
    hcs.trans (mul_le_mul_of_nonneg_right hnorm henergy)
  by_cases hzero : q = 0
  · simpa [hzero] using henergy
  · have hpositive : 0 < q := lt_of_le_of_ne hq (Ne.symm hzero)
    have hscaled :
        q * (q * b ^ 2) ≤ q * (C * (∑ g, w g * v g ^ 2)) := by
      nlinarith only [hmul]
    have hcancel := le_of_mul_le_mul_left hscaled hpositive
    apply (div_le_iff₀ hC).2
    simpa [mul_comm] using hcancel

theorem budget_transfer {H G : Type*} [Fintype H] [Fintype G]
    (w u v : H → G → ℝ) (q b C : H → ℝ)
    (hw : ∀ h g, 0 ≤ w h g) (hq : ∀ h, 0 ≤ q h)
    (hC : ∀ h, 0 < C h)
    (hreconstruct : ∀ h, ∑ g, w h g * u h g * v h g = q h * b h)
    (hnorm : ∀ h, ∑ g, w h g * u h g ^ 2 ≤ C h * q h) :
    (∑ h, q h * b h ^ 2 / C h) ≤
      ∑ h, ∑ g, w h g * v h g ^ 2 := by
  exact Finset.sum_le_sum (fun h _ =>
    node_budget (w h) (u h) (v h) (q h) (b h) (C h)
      (hw h) (hq h) (hC h) (hreconstruct h) (hnorm h))

theorem entropy_budget_transfer {H G : Type*} [Fintype H] [Fintype G]
    (w u v : H → G → ℝ) (q b C cost : H → ℝ) (p D : ℝ)
    (hw : ∀ h g, 0 ≤ w h g) (hq : ∀ h, 0 ≤ q h)
    (hC : ∀ h, 0 < C h) (hp : 0 < p) (hpone : p < 1)
    (hreconstruct : ∀ h, ∑ g, w h g * u h g * v h g = q h * b h)
    (hnorm : ∀ h, ∑ g, w h g * u h g ^ 2 ≤ C h * q h)
    (hcost : ∀ h, (p * (1 - p)) * cost h ≤ q h * b h ^ 2)
    (hbudget : (∑ h, ∑ g, w h g * v h g ^ 2) ≤ D / 2) :
    (∑ h, cost h / C h) ≤ D / (2 * (p * (1 - p))) := by
  have hpq : 0 < p * (1 - p) := mul_pos hp (sub_pos.mpr hpone)
  have hlocal :
      (∑ h, (p * (1 - p)) * (cost h / C h)) ≤
        ∑ h, q h * b h ^ 2 / C h := by
    apply Finset.sum_le_sum
    intro h _
    calc
      (p * (1 - p)) * (cost h / C h) =
          ((p * (1 - p)) * cost h) / C h := by ring
      _ ≤ q h * b h ^ 2 / C h :=
        div_le_div_of_nonneg_right (hcost h) (hC h).le
  have hscaled : (p * (1 - p)) * (∑ h, cost h / C h) ≤ D / 2 := by
    calc
      (p * (1 - p)) * (∑ h, cost h / C h) =
          ∑ h, (p * (1 - p)) * (cost h / C h) := by rw [Finset.mul_sum]
      _ ≤ ∑ h, q h * b h ^ 2 / C h := hlocal
      _ ≤ ∑ h, ∑ g, w h g * v h g ^ 2 :=
        budget_transfer w u v q b C hw hq hC hreconstruct hnorm
      _ ≤ D / 2 := hbudget
  apply (le_div_iff₀ (mul_pos (by norm_num : (0 : ℝ) < 2) hpq)).2
  nlinarith only [hscaled]

end EntropySupport
