import Mathlib

namespace DyadicGerstenAudit

/-- An ascending quadratic polynomial `[c0, c1, c2]` is 2-Eisenstein if `c2` is odd,
`c0, c1` are even, and `c0 % 4 = 2`. -/
def eisensteinTwo (c0 c1 c2 : ℤ) : Prop :=
  c2 % 2 = 1 ∧ c0 % 2 = 0 ∧ c1 % 2 = 0 ∧ c0 % 4 = 2

/-- The naive `y = 0` substitution `naive_h = [0, -2, 1]` (`t^2 - 2t`) has constant term `0`
and therefore fails the 2-Eisenstein criterion (`F209_DYADIC_Y0_EISENSTEIN_SUBSTITUTION`). -/
theorem naive_substitution_not_eisenstein : ¬ eisensteinTwo 0 (-2) 1 := by
  unfold eisensteinTwo
  omega

/-- The repaired dyadic divisor `h = [2, -2, 1]` (`t^2 - 2t + 2`) is 2-Eisenstein. -/
theorem repaired_divisor_eisenstein : eisensteinTwo 2 (-2) 1 := by
  unfold eisensteinTwo
  omega

/-- Homogeneous quadratic model `Q(X, Y, Z) = 2 Z^2 - 2 X Z + X^2 + X Y - Y^2`. -/
def Q (x y z : ℤ) : ℤ :=
  2 * z ^ 2 - 2 * x * z + x ^ 2 + x * y - y ^ 2

theorem sign_uniform_model_identity (x y z : ℤ) :
    -((z - x) ^ 2) - x * y + y ^ 2 - z ^ 2 = -Q x y z := by
  unfold Q
  ring

theorem affine_relation_identity (x y : ℤ) :
    (2 - 2 * x) + (x ^ 2 + x * y - y ^ 2) = Q x y 1 := by
  unfold Q
  ring

/-- Companion matrix `M` of `t^2 - 2t + 2` and unit `η = I - M`. -/
def M : Matrix (Fin 2) (Fin 2) ℤ := !![0, -2; 1, 2]
def eta : Matrix (Fin 2) (Fin 2) ℤ := 1 - M

theorem companion_quadratic_identity :
    M * M - (2 : ℤ) • M + (2 : ℤ) • (1 : Matrix (Fin 2) (Fin 2) ℤ) = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> decide

theorem eta_squared_eq_neg_one :
    eta * eta = -(1 : Matrix (Fin 2) (Fin 2) ℤ) := by
  ext i j; fin_cases i <;> fin_cases j <;> decide

theorem companion_and_eta_determinants :
    Matrix.det M = 2 ∧ Matrix.det eta = 1 := by
  exact ⟨by decide, by decide⟩

/-- The norm form `det(a I + b M)` equals `a^2 + 2 a b + 2 b^2` and matches the
3×3 Sylvester resultant determinant of `t^2 - 2t + 2` and `a + b t`. -/
def normMatrix (a b : ℤ) : Matrix (Fin 2) (Fin 2) ℤ :=
  !![a, -2 * b; b, a + 2 * b]

def sylvesterMatrix (a b : ℤ) : Matrix (Fin 3) (Fin 3) ℤ :=
  !![1, -2, 2; b, a, 0; 0, b, a]

theorem norm_and_sylvester_identities (a b : ℤ) :
    Matrix.det (normMatrix a b) = a ^ 2 + 2 * a * b + 2 * b ^ 2 ∧
    Matrix.det (sylvesterMatrix a b) = a ^ 2 + 2 * a * b + 2 * b ^ 2 := by
  constructor
  · simp [normMatrix, Matrix.det_fin_two]; ring
  · simp [sylvesterMatrix, Matrix.det_fin_three]; ring

end DyadicGerstenAudit
