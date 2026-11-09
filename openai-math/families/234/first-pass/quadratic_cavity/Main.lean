import Mathlib

namespace QuadraticCavity

section RingIdentities

variable {R : Type*} [Ring R]

theorem ordered_factor (B C K J : R)
    (hC : (1 - C * K) * J = 1) :
    1 - (B - C) * (K * J) = (1 - B * K) * J := by
  calc
    1 - (B - C) * (K * J) =
        (1 - C * K) * J - (B - C) * (K * J) := by rw [hC]
    _ = (1 - B * K) * J := by noncomm_ring

theorem ordered_intertwining (B C K JB JC T : R)
    (hB : JB * (1 - B * K) = 1)
    (hC : (1 - C * K) * JC = 1)
    (hT : (1 - (B - C) * (K * JC)) * T = 1) :
    JC * T = JB := by
  have hCT : ((1 - B * K) * JC) * T = 1 := by
    rw [← ordered_factor B C K JC hC]
    exact hT
  calc
    JC * T = (JB * (1 - B * K)) * (JC * T) := by rw [hB, one_mul]
    _ = JB * (((1 - B * K) * JC) * T) := by simp only [mul_assoc]
    _ = JB := by rw [hCT, mul_one]

theorem left_right_resolvent (C K JC LC : R)
    (hJC : JC * (1 - C * K) = 1)
    (hLC : (1 - K * C) * LC = 1) :
    JC * C = C * LC := by
  calc
    JC * C = JC * C * ((1 - K * C) * LC) := by rw [hLC, mul_one]
    _ = (JC * (1 - C * K)) * C * LC := by noncomm_ring
    _ = C * LC := by rw [hJC, one_mul]

theorem ordered_resolvent_difference (B C K JB JC LC : R)
    (hB : JB * (1 - B * K) = 1)
    (hJC : JC * (1 - C * K) = 1)
    (hLC : (1 - K * C) * LC = 1) :
    JB * B - JC * C = JB * (B - C) * LC := by
  rw [left_right_resolvent C K JC LC hJC hLC]
  calc
    JB * B - C * LC =
        JB * B * ((1 - K * C) * LC) -
          (JB * (1 - B * K)) * C * LC := by
      rw [hB, hLC, mul_one, one_mul]
    _ = JB * (B - C) * LC := by noncomm_ring

end RingIdentities

section MatrixIdentities

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem transpose_right_inverse (C K J : Matrix n n ℝ)
    (hC : C.transpose = C) (hK : K.transpose = K)
    (hJ : J * (1 - C * K) = 1) :
    (1 - K * C) * J.transpose = 1 := by
  have h := congrArg Matrix.transpose hJ
  simpa only [Matrix.transpose_mul, Matrix.transpose_sub,
    Matrix.transpose_one, hC, hK] using h

theorem matrix_resolvent_difference (B C K JB JC : Matrix n n ℝ)
    (hC : C.transpose = C) (hK : K.transpose = K)
    (hJB : JB * (1 - B * K) = 1)
    (hJC : JC * (1 - C * K) = 1) :
    JB * B - JC * C = JB * (B - C) * JC.transpose := by
  exact ordered_resolvent_difference B C K JB JC JC.transpose hJB hJC
    (transpose_right_inverse C K JC hC hK hJC)

theorem innovation_covariance (JB JC T S : Matrix n n ℝ)
    (hJT : JC * T = JB) :
    JC * (T * S) * JC.transpose = JB * S * JC.transpose := by
  calc
    JC * (T * S) * JC.transpose =
        (JC * T) * S * JC.transpose := by simp only [mul_assoc]
    _ = JB * S * JC.transpose := by rw [hJT]

theorem scaled_covariance_difference (B C K JB JC S : Matrix n n ℝ)
    (a : ℝ)
    (hC : C.transpose = C) (hK : K.transpose = K)
    (hJB : JB * (1 - B * K) = 1)
    (hJC : JC * (1 - C * K) = 1)
    (hDelta : B - C = a • S) :
    JB * B - JC * C = a • (JB * S * JC.transpose) := by
  calc
    JB * B - JC * C = JB * (B - C) * JC.transpose :=
      matrix_resolvent_difference B C K JB JC hC hK hJB hJC
    _ = JB * (a • S) * JC.transpose := by rw [hDelta]
    _ = a • (JB * S * JC.transpose) := by
      simp only [mul_smul_comm, smul_mul_assoc]

end MatrixIdentities

end QuadraticCavity
