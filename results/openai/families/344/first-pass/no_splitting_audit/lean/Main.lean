import Mathlib

namespace NoSplittingAudit

theorem schur_completion {k m : ℕ}
    (V : Matrix (Fin k) (Fin k) ℝ)
    (H : Matrix (Fin m) (Fin m) ℝ)
    (U R : Matrix (Fin k) (Fin m) ℝ) :
    V - (U * H) * R.transpose - R * (H * U.transpose)
        + (R * H) * R.transpose =
      (V - (U * H) * U.transpose)
        + ((R - U) * H) * (R - U).transpose := by
  simp only [Matrix.transpose_sub, Matrix.sub_mul, Matrix.mul_sub, Matrix.mul_assoc]
  abel

theorem schur_reversal {k m : ℕ}
    (V : Matrix (Fin k) (Fin k) ℝ)
    (C : Matrix (Fin k) (Fin m) ℝ)
    (Hinv : Matrix (Fin m) (Fin m) ℝ) :
    -V - ((-C) * (-Hinv)) * (-C).transpose =
      -(V - (C * Hinv) * C.transpose) := by
  simp only [Matrix.transpose_neg, Matrix.neg_mul, Matrix.mul_neg, neg_neg]
  abel

end NoSplittingAudit
