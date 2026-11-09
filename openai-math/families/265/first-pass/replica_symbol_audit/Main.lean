import Mathlib

namespace ReplicaSymbol

theorem complement_product_bounds (xs : List ℝ)
    (hxs : ∀ x ∈ xs, 0 ≤ x ∧ x ≤ 1) :
    0 ≤ (xs.map (fun x => 1 - x)).prod ∧
      1 - xs.sum ≤ (xs.map (fun x => 1 - x)).prod := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
      have hx : 0 ≤ x ∧ x ≤ 1 := hxs x (by simp)
      have htail : ∀ y ∈ xs, 0 ≤ y ∧ y ≤ 1 := by
        intro y hy
        exact hxs y (by simp [hy])
      have hi := ih htail
      have hsum : 0 ≤ xs.sum := List.sum_nonneg (fun y hy => (htail y hy).1)
      simp only [List.map_cons, List.prod_cons, List.sum_cons]
      constructor
      · exact mul_nonneg (sub_nonneg.mpr hx.2) hi.1
      · calc
          1 - (x + xs.sum) ≤ (1 - x) * (1 - xs.sum) := by
            nlinarith [mul_nonneg hx.1 hsum]
          _ ≤ (1 - x) * (xs.map (fun y => 1 - y)).prod :=
            mul_le_mul_of_nonneg_left hi.2 (sub_nonneg.mpr hx.2)

def nilpotent (a : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, 0; a, 0]

theorem nilpotent_square (a : ℝ) :
    nilpotent a * nilpotent a = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nilpotent, Matrix.mul_apply, Fin.sum_univ_two]

theorem nilpotent_self_commutator (a : ℝ) :
    nilpotent a * (nilpotent a).transpose -
      (nilpotent a).transpose * nilpotent a = !![-a ^ 2, 0; 0, a ^ 2] := by
  ext i j
  simp only [Matrix.sub_apply, Matrix.mul_apply, Matrix.transpose_apply, Fin.sum_univ_two]
  fin_cases i <;> fin_cases j <;>
    simp [nilpotent] <;> ring

theorem nilpotent_not_normal (a : ℝ) (ha : a ≠ 0) :
    nilpotent a * (nilpotent a).transpose -
      (nilpotent a).transpose * nilpotent a ≠ 0 := by
  intro h
  rw [nilpotent_self_commutator] at h
  have hentry : -(a ^ 2) = 0 := by
    have hm := congrArg (fun M : Matrix (Fin 2) (Fin 2) ℝ => M 0 0) h
    simpa using hm
  have hsquare : a * a = 0 := by nlinarith
  rcases mul_eq_zero.mp hsquare with hzero | hzero <;> exact ha hzero

theorem scalar_self_commutator (a b : ℂ) : a * b - b * a = 0 := by
  ring

end ReplicaSymbol
