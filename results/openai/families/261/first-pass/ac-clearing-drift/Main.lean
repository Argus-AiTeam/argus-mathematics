import Mathlib

namespace ClearingDrift

variable {R : Type*} [Ring R]

theorem inverse_linear_right (D T : R) (h : T * (1 + D) = 1) :
    T * D = 1 - T := by
  calc
    T * D = T * (1 + D) - T := by noncomm_ring
    _ = 1 - T := by rw [h]

theorem inverse_linear_left (D T : R) (h : (1 + D) * T = 1) :
    D * T = 1 - T := by
  calc
    D * T = (1 + D) * T - T := by noncomm_ring
    _ = 1 - T := by rw [h]

theorem total_leverage_identity (Q D T : R)
    (hleft : (1 + D) * T = 1) (hright : T * (1 + D) = 1) :
    (Q + D) * T - Q = (1 - Q) * T * D := by
  have hDT := inverse_linear_left D T hleft
  have hTD := inverse_linear_right D T hright
  calc
    (Q + D) * T - Q = Q * T + D * T - Q := by noncomm_ring
    _ = Q * T + (1 - T) - Q := by rw [hDT]
    _ = (1 - Q) * (1 - T) := by noncomm_ring
    _ = (1 - Q) * (T * D) := by rw [hTD]
    _ = (1 - Q) * T * D := by rw [mul_assoc]

theorem inverse_quadratic_remainder (D T : R)
    (hleft : (1 + D) * T = 1) :
    T - 1 = -D + D * D * T := by
  have hDT := inverse_linear_left D T hleft
  calc
    T - 1 = -D + (D - (1 - T)) := by noncomm_ring
    _ = -D + (D - D * T) := by rw [hDT]
    _ = -D + D * (1 - T) := by noncomm_ring
    _ = -D + D * (D * T) := by rw [hDT]
    _ = -D + D * D * T := by rw [mul_assoc]

theorem congruence_inverse (L J K T : R)
    (hLJ : L * J = 1) (hJL : J * L = 1)
    (hKT : K * T = 1) (hTK : T * K = 1) :
    (L * K * L) * (J * T * J) = 1 ∧
      (J * T * J) * (L * K * L) = 1 := by
  constructor
  · calc
      (L * K * L) * (J * T * J) = L * K * (L * J) * T * J := by
        noncomm_ring
      _ = L * K * 1 * T * J := by rw [hLJ]
      _ = L * (K * T) * J := by noncomm_ring
      _ = L * J := by rw [hKT]; simp
      _ = 1 := hLJ
  · calc
      (J * T * J) * (L * K * L) = J * T * (J * L) * K * L := by
        noncomm_ring
      _ = J * T * 1 * K * L := by rw [hJL]
      _ = J * (T * K) * L := by noncomm_ring
      _ = J * L := by rw [hTK]; simp
      _ = 1 := hJL

end ClearingDrift
