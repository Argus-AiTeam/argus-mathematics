import Mathlib

namespace HandlePackingAudit

theorem square_zero_binomial {R : Type*} [CommRing R]
    (a b : R) (hb : b * b = 0) (n : ℕ) :
    (a + b) ^ (n + 1) =
      a ^ (n + 1) + ((n + 1 : ℕ) : R) * a ^ n * b := by
  induction n with
  | zero => simp
  | succ n ih =>
      calc
        (a + b) ^ (n + 1 + 1) =
            ((a + b) ^ (n + 1)) * (a + b) := by
              rw [pow_succ]
        _ = (a ^ (n + 1) + ((n + 1 : ℕ) : R) * a ^ n * b) *
            (a + b) := by rw [ih]
        _ = a ^ (n + 1 + 1) +
            ((n + 1 + 1 : ℕ) : R) * a ^ (n + 1) * b +
            ((n + 1 : ℕ) : R) * a ^ n * (b * b) := by
              push_cast
              ring
        _ = a ^ (n + 1 + 1) +
            ((n + 1 + 1 : ℕ) : R) * a ^ (n + 1) * b := by
              rw [hb]
              simp

theorem square_zero_top_power {R : Type*} [CommRing R]
    (a b : R) (hb : b * b = 0) (m : ℕ)
    (ha : a ^ (m + 1) = 0) :
    (a + b) ^ (m + 1) = ((m + 1 : ℕ) : R) * a ^ m * b := by
  rw [square_zero_binomial a b hb m, ha, zero_add]

end HandlePackingAudit
