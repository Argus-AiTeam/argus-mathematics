import Mathlib

open scoped BigOperators

set_option exponentiation.threshold 3000

namespace RefinedReport

noncomputable def bit (p : Prop) : ℝ := by
  classical
  exact if p then 1 else 0

theorem prod_bits {ι : Type*} (s : Finset ι) (p : ι → Prop) :
    (∏ j ∈ s, bit (p j)) = bit (∀ j ∈ s, p j) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [bit]
  | @insert a s ha ih =>
      rw [Finset.prod_insert ha, ih]
      by_cases hp : p a <;> simp [bit, hp]

theorem reporting_cancellation {U Z : Type*} {m : ℕ}
    (selector : U → Fin m) (tests : Fin m → Z → Prop)
    (u : U) (z : Fin m → Z) :
    bit ((∀ j, j ≠ selector u → tests j (z j)) ∧
      ¬ (∀ j, tests j (z j))) =
    (∑ i : Fin m, bit (selector u = i) *
      ∏ j ∈ Finset.univ.erase i, bit (tests j (z j))) -
      ∏ j : Fin m, bit (tests j (z j)) := by
  classical
  simp_rw [prod_bits]
  simp only [Finset.mem_erase, Finset.mem_univ, and_true, true_implies]
  have hsum :
      (∑ i : Fin m, bit (selector u = i) *
        bit (∀ j, j ≠ i → tests j (z j))) =
      bit (∀ j, j ≠ selector u → tests j (z j)) := by
    rw [Finset.sum_eq_single (selector u)]
    · simp [bit]
    · intro j _ hj
      have hne : selector u ≠ j := Ne.symm hj
      simp [bit, hne]
    · simp
  rw [hsum]
  by_cases hp : ∀ j, j ≠ selector u → tests j (z j)
  · by_cases hb : ∀ j, tests j (z j) <;> simp [bit, hp, hb]
  · have hb : ¬ (∀ j, tests j (z j)) := by
      intro h
      exact hp (fun j _ => h j)
    simp [bit, hp, hb]

theorem cylinder_invariance {U Z : Type*} {m : ℕ}
    (selector : U → Fin m) (tests : Fin m → Z → Prop)
    (u : U) (i : Fin m) (z z' : Fin m → Z)
    (h : ∀ j, j ≠ i → z j = z' j) :
    bit (selector u = i) *
        (∏ j ∈ Finset.univ.erase i, bit (tests j (z j))) =
      bit (selector u = i) *
        (∏ j ∈ Finset.univ.erase i, bit (tests j (z' j))) := by
  classical
  have hp :
      (∏ j ∈ Finset.univ.erase i, bit (tests j (z j))) =
        ∏ j ∈ Finset.univ.erase i, bit (tests j (z' j)) := by
    apply Finset.prod_congr rfl
    intro j hj
    rw [h j (Finset.mem_erase.mp hj).1]
  rw [hp]

theorem ordinary_cell {U Z : Type*} {m : ℕ}
    (selector : U → Fin m) (tests : Fin m → Z → Prop)
    (u₀ : U) (i : Fin m) (w : Fin m → Z)
    (hsel : selector u₀ = i)
    (hfail : ¬ (∀ j, j ≠ i → tests j (w j)))
    (u : U) (z : Fin m → Z) :
    (u = u₀ ∧ selector u = i ∧
      (∀ j, j ≠ i → z j = w j) ∧
      ¬ (∀ j, j ≠ i → tests j (z j))) ↔
      (u = u₀ ∧ ∀ j, j ≠ i → z j = w j) := by
  constructor
  · rintro ⟨hu, _, hz, _⟩
    exact ⟨hu, hz⟩
  · rintro ⟨rfl, hz⟩
    refine ⟨rfl, hsel, hz, ?_⟩
    intro hp
    apply hfail
    intro j hj
    rw [← hz j hj]
    exact hp j hj

theorem gaussian_deficit_identity (p S J : ℝ) :
    (-p * J) - (-p * (1 + S)) = p * (1 + S - J) := by
  ring

theorem explicit_error_budget :
    (3576000 : ℝ) / 2 ^ 124 + 4704 / 2 ^ 2560 < 1 / 2 ^ 101 := by
  norm_num

theorem strict_gaussian_margin (p S J : ℝ)
    (hp : 0 < p) (hS : 0 ≤ S)
    (hJ : J ≤ 3576000 / (2 : ℝ) ^ 124 + 4704 / (2 : ℝ) ^ 2560) :
    (3 / 4 : ℝ) * p < (-p * J) - (-p * (1 + S)) := by
  rw [gaussian_deficit_identity]
  have hb : (3576000 : ℝ) / 2 ^ 124 + 4704 / 2 ^ 2560 < 1 / 4 := by
    exact lt_trans explicit_error_budget (by norm_num)
  have hj : J < 1 / 4 := lt_of_le_of_lt hJ hb
  nlinarith

theorem bernoulli (a : ℝ) (ha : 0 ≤ a) (k : ℕ) :
    1 + (k : ℝ) * a ≤ (1 + a) ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [pow_succ]
      have hm := mul_le_mul_of_nonneg_right ih (show 0 ≤ 1 + a by linarith)
      have ht : 0 ≤ (k : ℝ) * a ^ 2 :=
        mul_nonneg (Nat.cast_nonneg k) (sq_nonneg a)
      norm_num only [Nat.cast_add, Nat.cast_one]
      nlinarith

theorem finite_amplification (a target : ℝ) (ha : 0 < a) :
    ∃ k : ℕ, target < (1 + a) ^ k := by
  obtain ⟨k, hk⟩ := exists_nat_gt ((target - 1) / a)
  have hk' : target - 1 < (k : ℝ) * a := (div_lt_iff₀ ha).mp hk
  exact ⟨k, lt_of_lt_of_le (by linarith) (bernoulli a ha.le k)⟩

end RefinedReport
