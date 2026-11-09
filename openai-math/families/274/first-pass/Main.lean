import Mathlib

open scoped Kronecker ComplexOrder
open Matrix

namespace DimensionUniform

theorem projection_defect {R : Type*} [Ring R] (P Q : R)
    (hP : P * P = P) (hQ : Q * Q = Q) :
    P - P * Q * (2 - P) * Q * P =
      (P - P * Q * P) * (P - P * Q * P) := by
  have hPP (X : R) : P * (P * X) = P * X := by
    rw [← mul_assoc, hP]
  have hQQ (X : R) : Q * (Q * X) = Q * X := by
    rw [← mul_assoc, hQ]
  noncomm_ring [hP, hQ, hPP, hQQ]

section Matrices

variable {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n] [DecidableEq m]

theorem projection_defect_gram (P Q : Matrix n n ℂ)
    (hP : P * P = P) (hQ : Q * Q = Q)
    (hPs : Pᴴ = P) (hQs : Qᴴ = Q) :
    P - P * Q * (2 - P) * Q * P =
      (P - P * Q * P)ᴴ * (P - P * Q * P) := by
  have hs : (P - P * Q * P)ᴴ = P - P * Q * P := by
    simp only [Matrix.conjTranspose_sub, Matrix.conjTranspose_mul, hPs, hQs, mul_assoc]
  rw [hs]
  exact projection_defect P Q hP hQ

theorem weighted_projection_contraction (P Q : Matrix n n ℂ)
    (hP : P * P = P) (hQ : Q * Q = Q)
    (hPs : Pᴴ = P) (hQs : Qᴴ = Q) :
    (P - P * Q * (2 - P) * Q * P).PosSemidef := by
  rw [projection_defect_gram P Q hP hQ hPs hQs]
  exact Matrix.posSemidef_conjTranspose_mul_self _

theorem weighted_projection_gram (P Q : Matrix n n ℂ)
    (hP : P * P = P) (hPs : Pᴴ = P) (hQs : Qᴴ = Q) :
    P * Q * (2 - P) * Q * P =
      (Q * P)ᴴ * (Q * P) +
        ((1 - P) * Q * P)ᴴ * ((1 - P) * Q * P) := by
  have hPP (X : Matrix n n ℂ) : P * (P * X) = P * X := by
    rw [← mul_assoc, hP]
  simp only [Matrix.conjTranspose_mul, Matrix.conjTranspose_sub,
    Matrix.conjTranspose_one, hPs, hQs]
  noncomm_ring [hP, hPP]

theorem weighted_projection_positive (P Q : Matrix n n ℂ)
    (hP : P * P = P) (hPs : Pᴴ = P) (hQs : Qᴴ = Q) :
    (P * Q * (2 - P) * Q * P).PosSemidef := by
  rw [weighted_projection_gram P Q hP hPs hQs]
  exact (Matrix.posSemidef_conjTranspose_mul_self _).add
    (Matrix.posSemidef_conjTranspose_mul_self _)

theorem projection_positive (P : Matrix n n ℂ)
    (hP : P * P = P) (hPs : Pᴴ = P) : P.PosSemidef := by
  simpa only [hPs, hP] using Matrix.posSemidef_conjTranspose_mul_self P

theorem tensor_order_step (A B : Matrix n n ℂ) (C D : Matrix m m ℂ)
    (hA : A.PosSemidef) (hD : D.PosSemidef)
    (hBA : (B - A).PosSemidef) (hDC : (D - C).PosSemidef) :
    (B ⊗ₖ D - A ⊗ₖ C).PosSemidef := by
  have hid : B ⊗ₖ D - A ⊗ₖ C =
      (B - A) ⊗ₖ D + A ⊗ₖ (D - C) := by
    ext ⟨i, k⟩ ⟨j, l⟩
    change B i j * D k l - A i j * C k l =
      (B i j - A i j) * D k l + A i j * (D k l - C k l)
    ring
  rw [hid]
  exact (hBA.kronecker hD).add (hA.kronecker hDC)

theorem compressed_tail (K P W H : Matrix n n ℂ) (c : ℝ)
    (hc : 0 ≤ c)
    (hW : (P - Kᴴ * W * K).PosSemidef)
    (hH : (c • W - H).PosSemidef) :
    (c • P - Kᴴ * H * K).PosSemidef := by
  have hid : c • P - Kᴴ * H * K =
      c • (P - Kᴴ * W * K) + Kᴴ * (c • W - H) * K := by
    simp only [smul_sub, mul_sub, sub_mul, mul_smul_comm, smul_mul_assoc]
    abel
  rw [hid]
  exact (hW.smul hc).add (hH.conjTranspose_mul_mul_same K)

end Matrices

end DimensionUniform
